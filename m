Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D940EC001DF
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbjGIRQH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjGIRQG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:06 -0400
Received: from out-31.mta0.migadu.com (out-31.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B2412E
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:05 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAketf4JpaICSkka2IAa8JRNgrC44G4BIgasgvjulX0=;
        b=a/bTeZhpEi+o4r08HW+1g9qtXnFtY8gIXWrkLyBQc94CAbA3ZBqnKXY1Eo8XcXxGResZWu
        WLM1NBkut2DHbgTwhAmOndM3TKzl70t9c9Wer/nfSGgnPeutWfjDyc73aiVRvItasMjMaa
        KN+jxrbR7+rehjKNEjlst2XbcmEY7Tg=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 03/10] bcachefs: Refactor bch_sb_field_ops handling
Date:   Sun,  9 Jul 2023 13:15:44 -0400
Message-Id: <20230709171551.2349961-4-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This changes bch_sb_field_ops lookup to match how bkey_ops now works;
for an unknown field type we return an empty ops struct.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/super-io.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index eaf90eb137..833e78d48c 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -1405,21 +1405,29 @@ static const struct bch_sb_field_ops *bch2_sb_field_ops[] = {
 #undef x
 };
 
+static const struct bch_sb_field_ops bch2_sb_field_null_ops = {
+	NULL
+};
+
+static const struct bch_sb_field_ops *bch2_sb_field_type_ops(unsigned type)
+{
+	return likely(type < ARRAY_SIZE(bch2_sb_field_ops))
+		? bch2_sb_field_ops[type]
+		: &bch2_sb_field_null_ops;
+}
+
 static int bch2_sb_field_validate(struct bch_sb *sb, struct bch_sb_field *f,
 				  struct printbuf *err)
 {
 	unsigned type = le32_to_cpu(f->type);
 	struct printbuf field_err = PRINTBUF;
+	const struct bch_sb_field_ops *ops = bch2_sb_field_type_ops(type);
 	int ret;
 
-	if (type >= BCH_SB_FIELD_NR)
-		return 0;
-
-	ret = bch2_sb_field_ops[type]->validate(sb, f, &field_err);
+	ret = ops->validate ? ops->validate(sb, f, &field_err) : 0;
 	if (ret) {
 		prt_printf(err, "Invalid superblock section %s: %s",
-		       bch2_sb_fields[type],
-		       field_err.buf);
+			   bch2_sb_fields[type], field_err.buf);
 		prt_newline(err);
 		bch2_sb_field_to_text(err, sb, f);
 	}
@@ -1432,13 +1440,12 @@ void bch2_sb_field_to_text(struct printbuf *out, struct bch_sb *sb,
 			   struct bch_sb_field *f)
 {
 	unsigned type = le32_to_cpu(f->type);
-	const struct bch_sb_field_ops *ops = type < BCH_SB_FIELD_NR
-		? bch2_sb_field_ops[type] : NULL;
+	const struct bch_sb_field_ops *ops = bch2_sb_field_type_ops(type);
 
 	if (!out->nr_tabstops)
 		printbuf_tabstop_push(out, 32);
 
-	if (ops)
+	if (type < BCH_SB_FIELD_NR)
 		prt_printf(out, "%s", bch2_sb_fields[type]);
 	else
 		prt_printf(out, "(unknown field %u)", type);
@@ -1446,9 +1453,9 @@ void bch2_sb_field_to_text(struct printbuf *out, struct bch_sb *sb,
 	prt_printf(out, " (size %zu):", vstruct_bytes(f));
 	prt_newline(out);
 
-	if (ops && ops->to_text) {
+	if (ops->to_text) {
 		printbuf_indent_add(out, 2);
-		bch2_sb_field_ops[type]->to_text(out, sb, f);
+		ops->to_text(out, sb, f);
 		printbuf_indent_sub(out, 2);
 	}
 }
-- 
2.40.1

