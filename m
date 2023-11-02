Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40ACEC4167B
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Nov 2023 02:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346501AbjKBCuE (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 22:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346485AbjKBCuD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 22:50:03 -0400
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0546ED71
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:49:34 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698893372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iCwI9OcRT4JdPoGBxhRdAfYvrG5TWjmUCmKfHNTj6sg=;
        b=nhXn5YWJS6cAMaRFmXfYxAFjcvRimjQ+barzmXjOb2A4im1ohUvhmVvRTf3UyTRO6c2ktk
        ADtv7I66J8HhYjaW0d1Nc83gQCXvVPdg3NDnjbb+5SxbLvz4b1RJKJvbPaWmsVlsCZdxAK
        L4rxRwVsAU+zJyonWOpaj7GMYSEQ18c=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] bcachefs: bch_member->seq
Date:   Wed,  1 Nov 2023 22:49:19 -0400
Message-ID: <20231102024924.4107287-2-kent.overstreet@linux.dev>
In-Reply-To: <20231102024924.4107287-1-kent.overstreet@linux.dev>
References: <20231102024924.4107287-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Add new fields for split brain detection:

 - bch_member->seq, which tracks the sequence number of the last superblock
   write that happened to each member device

 - bch_sb->write_time, which tracks the time of the last superblock write,
   to allow detection of when two members have diverged but had the same
   number of superblock writes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  4 +++-
 fs/bcachefs/sb-members.c      |  5 +++++
 fs/bcachefs/super-io.c        | 10 ++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 5b44598b9df9..b22868ca9770 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1294,6 +1294,7 @@ struct bch_member {
 	__le64			errors[BCH_MEMBER_ERROR_NR];
 	__le64			errors_at_reset[BCH_MEMBER_ERROR_NR];
 	__le64			errors_reset_time;
+	__le64			seq;
 };
 
 #define BCH_MEMBER_V1_BYTES	56
@@ -1761,7 +1762,8 @@ struct bch_sb {
 	__le32			time_base_hi;
 	__le32			time_precision;
 
-	__le64			flags[8];
+	__le64			flags[7];
+	__le64			write_time;
 	__le64			features[2];
 	__le64			compat[2];
 
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 6a7e20de971c..4c6908cfca05 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -235,6 +235,11 @@ static void member_to_text(struct printbuf *out,
 		prt_printf(out, "(never)");
 	prt_newline(out);
 
+	prt_printf(out, "Last superblock write:");
+	prt_tab(out);
+	prt_u64(out, le64_to_cpu(m.seq));
+	prt_newline(out);
+
 	prt_printf(out, "State:");
 	prt_tab(out);
 	prt_printf(out, "%s",
diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index a93e53d0b37e..3ebe14c806ac 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -890,6 +890,11 @@ int bch2_write_super(struct bch_fs *c)
 
 	le64_add_cpu(&c->disk_sb.sb->seq, 1);
 
+	struct bch_sb_field_members_v2 *mi = bch2_sb_field_get(c->disk_sb.sb, members_v2);
+	for_each_online_member(ca, c, i)
+		__bch2_members_v2_get_mut(mi, i)->seq = c->disk_sb.sb->seq;
+	c->disk_sb.sb->write_time = cpu_to_le64(ktime_get_real_seconds());
+
 	if (test_bit(BCH_FS_ERROR, &c->flags))
 		SET_BCH_SB_HAS_ERRORS(c->disk_sb.sb, 1);
 	if (test_bit(BCH_FS_TOPOLOGY_ERROR, &c->flags))
@@ -1193,6 +1198,11 @@ void bch2_sb_to_text(struct printbuf *out, struct bch_sb *sb,
 	prt_printf(out, "%llu", le64_to_cpu(sb->seq));
 	prt_newline(out);
 
+	prt_printf(out, "Time of last write:");
+	prt_tab(out);
+	bch2_prt_date_seconds(out, le64_to_cpu(sb->write_time));
+	prt_newline(out);
+
 	prt_printf(out, "Superblock size:");
 	prt_tab(out);
 	prt_printf(out, "%zu", vstruct_bytes(sb));
-- 
2.42.0

