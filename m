Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05041C04A6A
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 14:50:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjHLOuZ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 10:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjHLOuX (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 10:50:23 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA6BE5C
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3fe167d4a18so26610765e9.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691851824; x=1692456624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEOVXusQyUsPuODLQlGcOUTqTv43SHPE/ra0a23oDFU=;
        b=H/0UqDvFWS8lELVOpwKoh/U8elW1ROrfFmN2gnK3LHNoUOWAs4p76iY6la2qfgCJfA
         kG/3z/uXTv7L0Vd8ofmrHTkZm1vavPTqUW1c3Jza4/fVAkkVJLPnanDirOyK9wR19CO0
         KphqAxxORSmwZjldWt308FIXQEX/ygc79YRMIhtODWYJd9k1ZlBjjIFrnSnfoTcB7Ewn
         UehYNmz9HITSILGdcVWWDHjbL4h0Mx7iFMyRDlENMWn/6ub67Vo4GgN3uP39bIaqLCvN
         loyXyH1r3mI6JTpr79NHOyjwJWrCv1A1FO4OEReUMw52Ug+LIwmYlf2qiU4qxbPT2+HK
         WNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691851824; x=1692456624;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PEOVXusQyUsPuODLQlGcOUTqTv43SHPE/ra0a23oDFU=;
        b=KeBWAR6oii/fh3kCzzrxtBzf0FdarJZlkF10PMFasbMa+qqRzEbZPTwIIBl+FlVsOV
         UOqp3HE66SZQy6EmOc1qWN/u555F7A/q+uefHc0F//MyR9D5MWsX+Kr/tAfVWFgS5g7m
         Jw1q4JhjSGeWKul2x9DgOAn+qKPbq3jtyxxxO5jDwHOYUFJE1GIInm7OeN/w1E24auQk
         S8oDUt95GOAD15OqSWXnSHyY7LFLHEFmp3RMR+QY+9F8/dVusytDZmDTzN8x8HOYTEGv
         Jdcdmq6ttZiWdG6zkjDs+/iW0vE7LstZNy91fUMMD4R8E/jbisz2d8hsIrEJlAefZnPp
         DEnQ==
X-Gm-Message-State: AOJu0YyoR4+8ZlbAL4jLz5RBtMd9leNhsKiofbAbWrtUhG2mEMq3i1bl
        OBHi50Adlx8/DuWrukSxt9KBwklWXkAII+HV5V8=
X-Google-Smtp-Source: AGHT+IGVAz5DC/jLwFJB8KxsyH6EA1EWnAxlXO2pUC2exULIwYCY6vdwcpBhHEjdhUqR2+LWTMAnpg==
X-Received: by 2002:a05:600c:280b:b0:3fb:e1d5:7f48 with SMTP id m11-20020a05600c280b00b003fbe1d57f48mr3955568wmb.5.1691851824178;
        Sat, 12 Aug 2023 07:50:24 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id w17-20020adfee51000000b00317eee26bf0sm8771784wro.69.2023.08.12.07.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 07:50:23 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [PATCH 3/4] bcachefs: Introduce bch2_dirent_get_name
Date:   Sat, 12 Aug 2023 15:47:47 +0100
Message-ID: <20230812145017.259609-3-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812145017.259609-1-joshua@froggi.es>
References: <20230812145017.259609-1-joshua@froggi.es>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

A nice cleanup that avoids a bunch of open-coding name/string usage
around dirent usage.

Will be used by casefolding impl in future commits.

Signed-off-by: Joshua Ashton <joshua@froggi.es>
---
 fs/bcachefs/dirent.c | 50 +++++++++++++++++++++++++-------------------
 fs/bcachefs/dirent.h |  1 +
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index b86c6c27424a..49b2f9b330e1 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -29,6 +29,11 @@ unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 		trailing_nuls;
 }
 
+struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
+{
+	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+}
+
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
 			    const struct qstr *name)
 {
@@ -49,7 +54,7 @@ static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
 static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
-	struct qstr name = QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	struct qstr name = bch2_dirent_get_name(d);
 
 	return bch2_dirent_hash(info, &name);
 }
@@ -57,20 +62,20 @@ static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 static bool dirent_cmp_key(struct bkey_s_c _l, const void *_r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
-	int len = bch2_dirent_name_bytes(l);
-	const struct qstr *r = _r;
+	const struct qstr l_name = bch2_dirent_get_name(l);
+	const struct qstr *r_name = _r;
 
-	return len - r->len ?: memcmp(l.v->d_name, r->name, len);
+	return l_name.len - r_name->len ?: memcmp(l_name.name, r_name->name, l_name.len);
 }
 
 static bool dirent_cmp_bkey(struct bkey_s_c _l, struct bkey_s_c _r)
 {
 	struct bkey_s_c_dirent l = bkey_s_c_to_dirent(_l);
 	struct bkey_s_c_dirent r = bkey_s_c_to_dirent(_r);
-	int l_len = bch2_dirent_name_bytes(l);
-	int r_len = bch2_dirent_name_bytes(r);
+	const struct qstr l_name = bch2_dirent_get_name(l);
+	const struct qstr r_name = bch2_dirent_get_name(r);
 
-	return l_len - r_len ?: memcmp(l.v->d_name, r.v->d_name, l_len);
+	return l_name.len - r_name.len ?: memcmp(l_name.name, r_name.name, l_name.len);
 }
 
 static bool dirent_is_visible(subvol_inum inum, struct bkey_s_c k)
@@ -97,37 +102,36 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
 			struct printbuf *err)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
-	unsigned len;
+	struct qstr d_name = bch2_dirent_get_name(d);
 
-	len = bch2_dirent_name_bytes(d);
-	if (!len) {
+	if (!d_name.len) {
 		prt_printf(err, "empty name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (bkey_val_u64s(k.k) > dirent_val_u64s(len)) {
+	if (bkey_val_u64s(k.k) > dirent_val_u64s(d_name.len)) {
 		prt_printf(err, "value too big (%zu > %u)",
-		       bkey_val_u64s(k.k), dirent_val_u64s(len));
+		       bkey_val_u64s(k.k), dirent_val_u64s(d_name.len));
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (len > BCH_NAME_MAX) {
+	if (d_name.len > BCH_NAME_MAX) {
 		prt_printf(err, "dirent name too big (%u > %u)",
-		       len, BCH_NAME_MAX);
+		       d_name.len, BCH_NAME_MAX);
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (len == 1 && !memcmp(d.v->d_name, ".", 1)) {
+	if (d_name.len == 1 && !memcmp(d_name.name, ".", 1)) {
 		prt_printf(err, "invalid name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (len == 2 && !memcmp(d.v->d_name, "..", 2)) {
+	if (d_name.len == 2 && !memcmp(d_name.name, "..", 2)) {
 		prt_printf(err, "invalid name");
 		return -BCH_ERR_invalid_bkey;
 	}
 
-	if (memchr(d.v->d_name, '/', len)) {
+	if (memchr(d_name.name, '/', d_name.len)) {
 		prt_printf(err, "invalid name");
 		return -BCH_ERR_invalid_bkey;
 	}
@@ -145,10 +149,11 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
 			 struct bkey_s_c k)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
+	struct qstr d_name = bch2_dirent_get_name(d);
 
 	prt_printf(out, "%.*s -> %llu type %s",
-	       bch2_dirent_name_bytes(d),
-	       d.v->d_name,
+	       d_name.len,
+	       d_name.name,
 	       d.v->d_type != DT_SUBVOL
 	       ? le64_to_cpu(d.v->d_inum)
 	       : le32_to_cpu(d.v->d_child_subvol),
@@ -515,6 +520,7 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
 	subvol_inum target;
 	u32 snapshot;
 	struct bkey_buf sk;
+	struct qstr name;
 	int ret;
 
 	bch2_bkey_buf_init(&sk);
@@ -545,9 +551,11 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
 		dirent = bkey_i_to_s_c_dirent(sk.k);
 		bch2_trans_unlock(&trans);
 
+		name = bch2_dirent_get_name(dirent);
+
 		ctx->pos = dirent.k->p.offset;
-		if (!dir_emit(ctx, dirent.v->d_name,
-			      bch2_dirent_name_bytes(dirent),
+		if (!dir_emit(ctx, name.name,
+			      name.len,
 			      target.inum,
 			      vfs_d_type(dirent.v->d_type)))
 			break;
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index b42f4a13bc55..5dd853d3aa0e 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -25,6 +25,7 @@ struct bch_hash_info;
 struct bch_inode_info;
 
 unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent);
+struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d);
 
 static inline unsigned dirent_val_u64s(unsigned len)
 {
-- 
2.41.0

