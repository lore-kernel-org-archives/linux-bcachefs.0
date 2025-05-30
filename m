Received: from mail.archlinux.org (mail.archlinux.org [95.216.189.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D162288F7;
	Fri, 30 May 2025 14:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.216.189.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748616819; cv=none; b=O989bJ1p4tuMh4a+U5+PwBNj0bCKb/1NojRfI3ekOC9sTt5IkSorCgfsindgFi280LjSEK2+98vnDeWeWePA7kJbI8ThKnlI2XmXh5oYWcb2eYTDwXFEwGzMc2jYkDncZ9IsH5v4ad/nCxeUXR5gJfu5Js2C1QSMn+02oYw9N58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748616819; c=relaxed/simple;
	bh=33GME1eBkXIG5Q9DcVjTATtuKAFedNz9230MRHkfzew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=grKZCMfeydMYojs9pHfBbGdbivJIvq+StZeapbb/wMpUE5QXi2nLmIDznB5q6f0L8+EtTQ4TeNM7nvtYE5V6fkFe1eQ8/I195pwA1q1lBEekuJj8CQk1q3CjVXJn/s0THG+B9pw9yetu4n1UUImI7I/sEFHFPOf/S6pBlfAyX6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org; spf=pass smtp.mailfrom=archlinux.org; dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=kIAbcpw/; dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b=C2lhftgl; arc=none smtp.client-ip=95.216.189.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=archlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=archlinux.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="kIAbcpw/";
	dkim=permerror (0-bit key) header.d=archlinux.org header.i=@archlinux.org header.b="C2lhftgl"
From: George Hu <integral@archlinux.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-rsa; t=1748616805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w5/dxK0Li9/0+xal/PCoI1Cn8loZyMgD0rI6dmAczNg=;
	b=kIAbcpw/C2lLXOz7ysjp8OmYn1DQ0KdwHmZWXtZQhZrKqOF3qpcicBMF/4L1XAw/pSK2vx
	6FFGo14hmo7RgA7uhIRtr5GSm3P5xK3/w3aotuMZvnIyuTz6dh2hk/3U0WB674QGYOONha
	k+044TsY4YtjLFPcv7Ag2qWM/8KRfD0SDf/9sFIASxjgzodTWY8qe+QWSueBWX4WMM86il
	hngMEVtNx+cqQI3Z3jatvzlKjT+HbMm7Yd+6inYgPBm7fn+VaVlx4F6JFqg4YLX23HOK08
	L2Kqjxhgb3kWBe0LUi6q2+zZw8Vn8wnzmnZUqfSatdmQq2ODQ6tUscK+Ctuy1scNF+7LUC
	ECgWNi9zjZULMsUU2yXCs1+xPqm4cTwezeaNtg9SZcLZpVXBUXjd8CvRWgF4WOecv/Xbzh
	re9f7yxTYZQw7V61/XSk1OHS60NdKJvLJ8shBr/wRwx6SZcQJwZ+zHwIA3Vx8g9i2QCreH
	pE3ShVCvGllTDSORqLr9KddK6LNlsDu2Vzdv0z487dMQj+9avJWa9s8rmy/wkfNbTcrc37
	oof3fyGbOBc55EIQyg+QzhHNF0D7uKu9n+dKXATKnFfvZabjLbCJgb6XH17kqhIr4Stgpv
	BxVEcY/PMlksRupac47dpdC/NKeiBVTyivC5Kjj2JMJEiU1WX7H20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=archlinux.org;
	s=dkim-ed25519; t=1748616805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w5/dxK0Li9/0+xal/PCoI1Cn8loZyMgD0rI6dmAczNg=;
	b=C2lhftglUlZWipA2jq7os1BhjG76Nv9ZcqeGq3MaT685//BOjpyQrc7/OQ2LYqGMo3fOcC
	+f8ZijvXklDFJcCw==
Authentication-Results: mail.archlinux.org;
	auth=pass smtp.auth=integral smtp.mailfrom=integral@archlinux.org
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Hu <integral@archlinux.org>
Subject: [PATCH] bcachefs: use union for bch_compression_opt to make encode & decode easier
Date: Fri, 30 May 2025 22:52:43 +0800
Message-ID: <20250530145243.163974-1-integral@archlinux.org>
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
 fs/bcachefs/compress.h | 32 +++++++-------------------------
 fs/bcachefs/extents.c  |  2 +-
 3 files changed, 17 insertions(+), 34 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 1bca61d17092..10e88e14f5ed 100644
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
index bec2f05bfd52..8cded510b2ac 100644
--- a/fs/bcachefs/compress.h
+++ b/fs/bcachefs/compress.h
@@ -10,41 +10,23 @@ static const unsigned __bch2_compression_opt_to_type[] = {
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
+		u8 type:4, level:4;
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
index 677cf453b332..64419c028662 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1512,7 +1512,7 @@ int bch2_bkey_ptrs_validate(struct bch_fs *c, struct bkey_s_c k,
 			const struct bch_extent_rebalance *r = &entry->rebalance;
 
 			if (!bch2_compression_opt_valid(r->compression)) {
-				struct bch_compression_opt opt = __bch2_compression_decode(r->compression);
+				union bch_compression_opt opt = { .value = r->compression };
 				prt_printf(err, "invalid compression opt %u:%u",
 					   opt.type, opt.level);
 				return -BCH_ERR_invalid_bkey;
-- 
2.49.0

