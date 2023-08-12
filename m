Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B256C41513
	for <linux-bcachefs@archiver.kernel.org>; Sat, 12 Aug 2023 21:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjHLV0u (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sat, 12 Aug 2023 17:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjHLV0t (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sat, 12 Aug 2023 17:26:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B7AE50
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-317c3ac7339so2662216f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Aug 2023 14:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=froggi.es; s=google; t=1691875610; x=1692480410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCluMDNGhCeBjSE0Gr8i2lVruPFxd4/yRGwKtjwq4ck=;
        b=HwvE0l34W/oNTRJNiqyRWizoqaGw56kCY67d3Rdui3kyYmU99BIyZSIRdeEhAHV67i
         6O3HYd+qDgO8phrZWg8mCTm/zWpGx9yd4BbHJ6xO4gH/Ycl2JasLC/5P8ckboxmh0cGP
         zuVAtZij6wl59E8iPZ/XCYmR+lgtQ8/6vPoJ34l/43ifAt5IU5XOPqaqd3X+tqkh9zUP
         qQ1jHMaEKRiJCVV4R/91OWoslrkERQsxTRsriWmGoS+XFQoq9BMG2sf1kEefTPuJ5XWW
         nq3fLbYm3zHszCv2QqeUBCQQmRtEGJoxAcKy6kIGy313vQbAeS28KkTE3DuwebfvHgrU
         gkog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691875610; x=1692480410;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sCluMDNGhCeBjSE0Gr8i2lVruPFxd4/yRGwKtjwq4ck=;
        b=HrkMPIIF3R3Qxk+LBOKnRFIMxbJC2dDBCHJy+7LoLTEK7pKDiEipTvXfDhciJb9/71
         GbCmLNksk2t2iS918/d+MIWfDkLmUdGcyqybZb3wDlHNyTk3088bVQcKNLDkJ8J27Fjl
         w8e+AeYVoM2RHd4ifCX7Ne7HTcbaqs2N6g2uZbSc5F0Olr1xbbMr2BXlU6/qMCN/XnFg
         8D7Tria32tmzOafcqjjzBG0tP00UkZ6qKAV0QGYRXvzcU+iw2CEEjxPWswxRJXLZyknk
         zluJVJd6mx43RGgNx4sHRXN9o8+2n9ePJiFwfGYr5E8DAehvnfndb3JEjtD616r/sWU1
         UcSg==
X-Gm-Message-State: AOJu0Yy9N9znS46CC8RlTt+opWdoTnsqmJ3GcoiliXhKEt3MtpMjxhXL
        v/doh50+9+KrFFWNy0aqCybt3oITkQfNjeD1mEk=
X-Google-Smtp-Source: AGHT+IGRaEj3T4IAuMC3Mj8Jd4TLgw89+mRq3BK5krcDevTHm+SiisuqWB13LQsdI3Q+pMRU7uGBcg==
X-Received: by 2002:a5d:5347:0:b0:317:e5ec:8767 with SMTP id t7-20020a5d5347000000b00317e5ec8767mr3896356wrv.21.1691875610458;
        Sat, 12 Aug 2023 14:26:50 -0700 (PDT)
Received: from localhost.localdomain (darl-09-b2-v4wan-165404-cust288.vm5.cable.virginm.net. [86.17.61.33])
        by smtp.gmail.com with ESMTPSA id p1-20020adfcc81000000b003179b3fd837sm9536481wrj.33.2023.08.12.14.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Aug 2023 14:26:50 -0700 (PDT)
From:   Joshua Ashton <joshua@froggi.es>
To:     linux-bcachefs@vger.kernel.org
Cc:     Joshua Ashton <joshua@froggi.es>
Subject: [v2 1/3] bcachefs: Introduce bch2_dirent_get_name
Date:   Sat, 12 Aug 2023 22:26:29 +0100
Message-ID: <20230812212647.490829-2-joshua@froggi.es>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230812212647.490829-1-joshua@froggi.es>
References: <20230812212647.490829-1-joshua@froggi.es>
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
 fs/bcachefs/dirent.c | 52 +++++++++++++++++++++++++-------------------
 fs/bcachefs/dirent.h |  2 +-
 fs/bcachefs/fs.c     |  8 ++++---
 3 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index 065ea59ee9fa..a87c4e5f089d 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -13,7 +13,7 @@
 
 #include <linux/dcache.h>
 
-unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
+static unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 {
 	unsigned len = bkey_val_bytes(d.k) -
 		offsetof(struct bch_dirent, d_name);
@@ -21,6 +21,11 @@ unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent d)
 	return strnlen(d.v->d_name, len);
 }
 
+struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d)
+{
+	return (struct qstr) QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+}
+
 static u64 bch2_dirent_hash(const struct bch_hash_info *info,
 			    const struct qstr *name)
 {
@@ -41,7 +46,7 @@ static u64 dirent_hash_key(const struct bch_hash_info *info, const void *key)
 static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
 {
 	struct bkey_s_c_dirent d = bkey_s_c_to_dirent(k);
-	struct qstr name = QSTR_INIT(d.v->d_name, bch2_dirent_name_bytes(d));
+	struct qstr name = bch2_dirent_get_name(d);
 
 	return bch2_dirent_hash(info, &name);
 }
@@ -49,20 +54,20 @@ static u64 dirent_hash_bkey(const struct bch_hash_info *info, struct bkey_s_c k)
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
@@ -89,37 +94,36 @@ int bch2_dirent_invalid(const struct bch_fs *c, struct bkey_s_c k,
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
@@ -137,10 +141,11 @@ void bch2_dirent_to_text(struct printbuf *out, struct bch_fs *c,
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
@@ -507,6 +512,7 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
 	subvol_inum target;
 	u32 snapshot;
 	struct bkey_buf sk;
+	struct qstr name;
 	int ret;
 
 	bch2_bkey_buf_init(&sk);
@@ -537,9 +543,11 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
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
index b42f4a13bc55..e9fa1df38232 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -24,7 +24,7 @@ struct bch_fs;
 struct bch_hash_info;
 struct bch_inode_info;
 
-unsigned bch2_dirent_name_bytes(struct bkey_s_c_dirent);
+struct qstr bch2_dirent_get_name(struct bkey_s_c_dirent d);
 
 static inline unsigned dirent_val_u64s(unsigned len)
 {
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index eb5da358871b..d287db908e62 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1237,7 +1237,8 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 	struct bch_inode_unpacked inode_u;
 	subvol_inum target;
 	u32 snapshot;
-	unsigned name_len;
+	struct qstr dirent_name;
+	unsigned name_len = 0;
 	int ret;
 
 	if (!S_ISDIR(dir->v.i_mode))
@@ -1314,9 +1315,10 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 	ret = -ENOENT;
 	goto err;
 found:
-	name_len = min_t(unsigned, bch2_dirent_name_bytes(d), NAME_MAX);
+	dirent_name = bch2_dirent_get_name(d);
 
-	memcpy(name, d.v->d_name, name_len);
+	name_len = min_t(unsigned, dirent_name.len, NAME_MAX);
+	memcpy(name, dirent_name.name, name_len);
 	name[name_len] = '\0';
 err:
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-- 
2.41.0

