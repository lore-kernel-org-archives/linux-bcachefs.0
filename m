Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F9228BABD;
	Tue, 17 Jun 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750144003; cv=none; b=bSvvcyq4zUAowgsmpPuB81YrXJA9ea2hE3AD0hNTMu+DgnsMTqAzTSRoxqr/3dbGod5+pdbJYBHl7ZUwzfFsHon0wx58K2WDZ43u1mJG6aduybAvfuaYnCPf20CTjGm4QKE5lWA4oiiJ7e4Qpm2x3ki19OA1k3NXe4DGU5zpcHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750144003; c=relaxed/simple;
	bh=nvMdHSpWVUPTjrFiKn24e2laEyS1rQMORZ9YpXHTrVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XTqyCR25WGo0cNLFJzYF8XohzlTiFyfIM4v00QZOIEXHz2o74S2QpRxIt7KwwQbFlN9Pwf+f1RcNxgvra2jNRuOBqj+xJrUE8QvFDbE8Cnzdq8ieXp7zhHTwKuXagnNXtS/HzjlDaApulxAJEAdLKo1t9G0POo1TBrIwEUyqCEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=rvWxmHMC; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=j24T8DRD; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="rvWxmHMC";
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="j24T8DRD"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1750143632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRoqgXRJ2jvZqZ0wCNBlPWys9iezWcvb617+aqNYKXw=;
	b=rvWxmHMCqy73aEU+7tj3KNDRS5o83sS09bzRfoCoL1i3T7PZmw1ar2hNNdFu/tb6+d4KZh
	ekW1nqdWrg0aSW8kUu7AFrKzQNNTINKBZLoNiVZdwyyaJGAl4T33GVDfmiu5BDbrKyiBoK
	RKdtoO/Q+XQPyk2Wmo/sC+C8xsK5Top64LPmk6tMv34c7RQSbiHykobA/49v/pyawl+QV1
	GcQMBr6P48NVUb0bGlj9iXALv8K6DHoKPf7G75X0TA8wqO8DAVSAo6KKxnISG2jaqXK0kv
	2L6GlpnMrq3y8IhLlPXol7U4/A8dX8+l7qjmFax9/cMC4dBq9XbOxFj+zZ0sXJj7usUwol
	omXk6Wxy+3nI1nJfc35Jj+TokLi7m5tzaKtDMEPbrWpm8XwphBZpZT7FCft7IwxghVBw1l
	mPbrfJ9jiZOktIYSnLaddyFQDpWmZdyLUixSSFcx5QcBvS38HkQrNN4YswnZ6uGQEph/Hb
	cGdVqtFUbyj5kwdxiIsDRbcqPlakNTHR1ya/cK+9TWH+4Am7SfECd9R2GI1UXDoBwYKZCT
	AillVH+PxfWpU8snw+l3avWTXQ7v5gHbFd1Y66CgQizgjjmmnOL3F3xyOoV7gyDqX9bfey
	uB3pJfTTdY2eeLAmzzqz7/jtfSo/GE9TqEmj3bfxAgXil86fn/5EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1750143632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eRoqgXRJ2jvZqZ0wCNBlPWys9iezWcvb617+aqNYKXw=;
	b=j24T8DRDT5dhQYaPIdobl7Bam9a3TiBbsBiwmrszpqKQ7424GRwcwm+GoZOQfTVHfzNgo4
	UjJdIejrpHefiGAw==
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Hu <integral@archlinux.org>
Subject: [PATCH v2 RESEND] bcachefs: use union for bch_compression_opt to make encode & decode easier
Date: Tue, 17 Jun 2025 15:00:36 +0800
Message-ID: <20250617070036.10685-1-integral@archlinux.org>
X-Mailer: git-send-email 2.49.0
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

