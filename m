Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A61C13212A;
	Sat, 31 May 2025 06:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748673109; cv=none; b=LXjT6fkqiWvyn8S4WSNiLubQP8l4puhkVDUimNBjsrYJLO/18X0IkHYpDqkBwUVQNJjDsua+bewdmIGC4YBJTMRyuYX45s8TFVqjZaN5IKcC95p2BTQCshc8g0Ko7Ko2DPW2IwmqSSYMmijqVEr4hlXaSunhcHM3Vrk9D0Du4WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748673109; c=relaxed/simple;
	bh=nvMdHSpWVUPTjrFiKn24e2laEyS1rQMORZ9YpXHTrVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FkVPdA1cQui8jBPbLGMtm30SBao3z8FCbrnyDDthRcSrg2dF65laP6xjUqXonMKzGkdeW23a8t0HkEIb43zxVw3/94rOpOpvh+8G5K80rGKZSJ9B4M75JwcNexKf848daSFOT0cNiVMv4MbiB+f5YRv3NLSB0IAU4Zrhk0dvJRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=ND2k8Pxg; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=jjsU1GQ5; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="ND2k8Pxg";
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="jjsU1GQ5"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1748673103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRoqgXRJ2jvZqZ0wCNBlPWys9iezWcvb617+aqNYKXw=;
	b=ND2k8Pxg7K7ozl448gQH2AQZG3NfeqQvM+WscsR/+oJELXpi1ktzh+P/8peQysqiV/610U
	0JEppnsGTGdwibi98HrMwuN6q1W1SNh7EYVLy8gNwu3oW6j0eZL083Csv85FT1wTE19fLE
	AMedKM93O7yl+SSi/esIzMs6sT2+5sRDYSrCakbLWMMTqXOC7ORgQTYEed6ctcjS1ntwuK
	HCsHpP4h/sFhzHofUQdWENoA2522D/G60qBF2giisSBDUg1GK5aGJOHDNj0Q4K0n281ttk
	0SgwW/sTv73IH+D6c4vU1pV29Sjt3RV99LTK77As7VQMcgCnrOMi2+fQmvo4URJToyARgp
	bsVUk8ZVQvbic9w72MM7mc83hOoGLSe6fmGnfJq3Xd19S1UovZ98NKoDJluQsNyNLls9FS
	2GdhzYPZcZ5xj8QUdbXDJheCA12s8ZR3XqhY+VNobP9sbWd/lUhc0t+CUwM7JG5kLakNYM
	AwCin5Z5ZsIstnOkdj1zHviAGSw9/zyOyG+W2nZLISjDifTXyfAo3ZPk/O2GyzbmF7jH1Z
	ZVU3HP7ukyYiSSKDf6RdnQGkCL380mzdsQBplJap3SoHEu+vyYS5pT80II6bBa14hb7iXx
	kAV4CdtCKblp1TKkDcpZYEsaDo+4YgxEWCG46sBa2DGuSut7hwSoM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1748673103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRoqgXRJ2jvZqZ0wCNBlPWys9iezWcvb617+aqNYKXw=;
	b=jjsU1GQ5/pJYjbvpmWRjcQLvlTW7UtalXDmetBtNkFIlW9nj9IJmVa0hj8r9OldOyOHFsS
	XMzFI+9ru4Y8KWDQ==
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: kent.overstreet@linux.dev
Cc: integral@archlinux.org,
	linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] bcachefs: use union for bch_compression_opt to make encode & decode easier
Date: Sat, 31 May 2025 14:31:16 +0800
Message-ID: <20250531063116.710718-1-integral@archlinux.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <zxcvscosad6yv2y6km3xsdhh26qse3qcx5u66a4nqybev4u64y@uzdekpsliv35>
References: <zxcvscosad6yv2y6km3xsdhh26qse3qcx5u66a4nqybev4u64y@uzdekpsliv35>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Eliminate redundant encode & decode function by using union for
bch_compression_opt, which reduces code complexity.

Signed-off-by: George Hu <integral@archlinux.org>
---
 fs/bcachefs/compress.c | 17 +++++++++--------
 fs/bcachefs/compress.h | 36 +++++++++++-------------------------
 fs/bcachefs/extents.c  |  2 +-
 3 files changed, 21 insertions(+), 34 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index b37b1f325f0a..5f74de920c92 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -336,7 +336,7 @@ static int attempt_compress(struct bch_fs *c,
 			    void *workspace,
 			    void *dst, size_t dst_len,
 			    void *src, size_t src_len,
-			    struct bch_compression_opt compression)
+			    union bch_compression_opt compression)
 {
 	enum bch_compression_type compression_type =
 		__bch2_compression_opt_to_type[compression.type];
@@ -426,7 +426,7 @@ static int attempt_compress(struct bch_fs *c,
 static unsigned __bio_compress(struct bch_fs *c,
 			       struct bio *dst, size_t *dst_len,
 			       struct bio *src, size_t *src_len,
-			       struct bch_compression_opt compression)
+			       union bch_compression_opt compression)
 {
 	struct bbuf src_data = { NULL }, dst_data = { NULL };
 	void *workspace;
@@ -553,7 +553,7 @@ unsigned bch2_bio_compress(struct bch_fs *c,
 
 	compression_type =
 		__bio_compress(c, dst, dst_len, src, src_len,
-			       bch2_compression_decode(compression_opt));
+			       (union bch_compression_opt){ .value = compression_opt });
 
 	dst->bi_iter.bi_size = orig_dst;
 	src->bi_iter.bi_size = orig_src;
@@ -602,7 +602,8 @@ static int __bch2_check_set_has_compressed_data(struct bch_fs *c, u64 f)
 int bch2_check_set_has_compressed_data(struct bch_fs *c,
 				       unsigned compression_opt)
 {
-	unsigned compression_type = bch2_compression_decode(compression_opt).type;
+	unsigned int compression_type = ((union bch_compression_opt){ .value = compression_opt })
+					.type;
 
 	BUG_ON(compression_type >= ARRAY_SIZE(bch2_compression_opt_to_feature));
 
@@ -683,7 +684,7 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 
 static u64 compression_opt_to_feature(unsigned v)
 {
-	unsigned type = bch2_compression_decode(v).type;
+	unsigned int type = ((union bch_compression_opt){ .value = v }).type;
 
 	return BIT_ULL(bch2_compression_opt_to_feature[type]);
 }
@@ -703,7 +704,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 {
 	char *val = kstrdup(_val, GFP_KERNEL);
 	char *p = val, *type_str, *level_str;
-	struct bch_compression_opt opt = { 0 };
+	union bch_compression_opt opt = { 0 };
 	int ret;
 
 	if (!val)
@@ -736,7 +737,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 		opt.level = level;
 	}
 
-	*res = bch2_compression_encode(opt);
+	*res = opt.value;
 err:
 	kfree(val);
 	return ret;
@@ -744,7 +745,7 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
 
 void bch2_compression_opt_to_text(struct printbuf *out, u64 v)
 {
-	struct bch_compression_opt opt = bch2_compression_decode(v);
+	union bch_compression_opt opt = { .value = v };
 
 	if (opt.type < BCH_COMPRESSION_OPT_NR)
 		prt_str(out, bch2_compression_opts[opt.type]);
diff --git a/fs/bcachefs/compress.h b/fs/bcachefs/compress.h
index bec2f05bfd52..667ddb91d47a 100644
--- a/fs/bcachefs/compress.h
+++ b/fs/bcachefs/compress.h
@@ -10,41 +10,27 @@ static const unsigned __bch2_compression_opt_to_type[] = {
 #undef x
 };
 
-struct bch_compression_opt {
-	u8		type:4,
-			level:4;
-};
-
-static inline struct bch_compression_opt __bch2_compression_decode(unsigned v)
-{
-	return (struct bch_compression_opt) {
-		.type	= v & 15,
-		.level	= v >> 4,
+union bch_compression_opt {
+	u8 value;
+	struct {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+		u8 type:4, level:4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+		u8 level:4, type:4;
+#endif
 	};
-}
+};
 
 static inline bool bch2_compression_opt_valid(unsigned v)
 {
-	struct bch_compression_opt opt = __bch2_compression_decode(v);
+	union bch_compression_opt opt = { .value = v };
 
 	return opt.type < ARRAY_SIZE(__bch2_compression_opt_to_type) && !(!opt.type && opt.level);
 }
 
-static inline struct bch_compression_opt bch2_compression_decode(unsigned v)
-{
-	return bch2_compression_opt_valid(v)
-		? __bch2_compression_decode(v)
-		: (struct bch_compression_opt) { 0 };
-}
-
-static inline unsigned bch2_compression_encode(struct bch_compression_opt opt)
-{
-	return opt.type|(opt.level << 4);
-}
-
 static inline enum bch_compression_type bch2_compression_opt_to_type(unsigned v)
 {
-	return __bch2_compression_opt_to_type[bch2_compression_decode(v).type];
+	return __bch2_compression_opt_to_type[((union bch_compression_opt){ .value = v }).type];
 }
 
 struct bch_write_op;
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 036e4ad95987..8bdcb1551814 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1512,7 +1512,7 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
 			const struct bch_extent_rebalance *r = &entry->rebalance;
 
 			if (!bch2_compression_opt_valid(r->compression)) {
-				struct bch_compression_opt opt = __bch2_compression_decode(r->compression);
+				union bch_compression_opt opt = { .value = r->compression };
 				prt_printf(err, "invalid compression opt %u:%u",
 					   opt.type, opt.level);
 				return bch_err_throw(c, invalid_bkey);
-- 
2.49.0

