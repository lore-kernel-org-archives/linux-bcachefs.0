Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E4E1EEE0
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893832; cv=none; b=hQ5v7EiVHPx0dXxwZOEujQNkYt+CRB0ia+465wE6pShnK4D9IjneBy5XImWwtSunA22n5NTTAtH396IFY1L70md58PnA7prGZppk456ohzTacfwsgcc/kYjI4BLGHCWY/EmwfkwEEiSMsODkXv8eH/+EFj5O7qjxr4oawObQ4gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893832; c=relaxed/simple;
	bh=65RaslPZ6mOT7ErZzODznaN2HxYn21Wl3bsQpM1SyP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9lkNmLQz8dwYhVrbX1/OlybpHHSEOiwRqmzHSjC+rfJmNOeOQGcbUfQlbZquIAkwNA/BKIPlaJ5ZMAOmww3xVfZCyE7karc+ZLYZq6k5REz9AEoWrMRithv9PpMkRzVjQig7hiX3EQDhFe5aaHTQkMJ4SzmOvONjKFjNDh6KSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kyiphlor; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kyiphlor"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GClqiAH1QF46FrvTljGCPDK42yTRkSmxOtHLEuao2Nk=;
	b=kyiphlorl8d4gZejyrWW/MB5aJHuBrRl6bd2Bnp9KeTuKx2nCJgFYfx7KWFO0wBZ1xHCci
	KmGzVDSXujL7xT5kFEZY7P50M34ctJa40JmSLBkI+zDLoPwLIXFFxhjU7qTcSvGOxZbE1c
	HLhFwwZys1+rSzyO/3zAfgTn5HOVr8M=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Don't use a shared decompress workspace mempool
Date: Sun, 17 Nov 2024 20:36:50 -0500
Message-ID: <20241118013651.2275187-2-kent.overstreet@linux.dev>
In-Reply-To: <20241118013651.2275187-1-kent.overstreet@linux.dev>
References: <20241118013651.2275187-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

gzip and zstd require different decompress workspace sizes, and if we
start with one and then start using the other at runtime we may not get
the correct size

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |  1 -
 fs/bcachefs/compress.c | 52 +++++++++++++++++++++++++-----------------
 fs/bcachefs/errcode.h  |  1 -
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 60ad547c52a8..7a947d43d504 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -983,7 +983,6 @@ struct bch_fs {
 
 	mempool_t		compression_bounce[2];
 	mempool_t		compress_workspace[BCH_COMPRESSION_OPT_NR];
-	mempool_t		decompress_workspace;
 	size_t			zstd_workspace_size;
 
 	struct crypto_shash	*sha256;
diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 4f541a195c84..2813e4556f0d 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -9,6 +9,24 @@
 #include <linux/zlib.h>
 #include <linux/zstd.h>
 
+static inline enum bch_compression_opts bch2_compression_type_to_opt(enum bch_compression_type type)
+{
+	switch (type) {
+	case BCH_COMPRESSION_TYPE_none:
+	case BCH_COMPRESSION_TYPE_incompressible:
+		return BCH_COMPRESSION_OPT_none;
+	case BCH_COMPRESSION_TYPE_lz4_old:
+	case BCH_COMPRESSION_TYPE_lz4:
+		return BCH_COMPRESSION_OPT_lz4;
+	case BCH_COMPRESSION_TYPE_gzip:
+		return BCH_COMPRESSION_OPT_gzip;
+	case BCH_COMPRESSION_TYPE_zstd:
+		return BCH_COMPRESSION_OPT_zstd;
+	default:
+		BUG();
+	}
+}
+
 /* Bounce buffer: */
 struct bbuf {
 	void		*b;
@@ -158,6 +176,10 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 	void *workspace;
 	int ret;
 
+	enum bch_compression_opts opt = bch2_compression_type_to_opt(crc.compression_type);
+	mempool_t *workspace_pool = &c->compress_workspace[opt];
+	BUG_ON(!mempool_initialized(workspace_pool));
+
 	src_data = bio_map_or_bounce(c, src, READ);
 
 	switch (crc.compression_type) {
@@ -176,13 +198,13 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 			.avail_out	= dst_len,
 		};
 
-		workspace = mempool_alloc(&c->decompress_workspace, GFP_NOFS);
+		workspace = mempool_alloc(workspace_pool, GFP_NOFS);
 
 		zlib_set_workspace(&strm, workspace);
 		zlib_inflateInit2(&strm, -MAX_WBITS);
 		ret = zlib_inflate(&strm, Z_FINISH);
 
-		mempool_free(workspace, &c->decompress_workspace);
+		mempool_free(workspace, workspace_pool);
 
 		if (ret != Z_STREAM_END)
 			goto err;
@@ -195,14 +217,14 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 		if (real_src_len > src_len - 4)
 			goto err;
 
-		workspace = mempool_alloc(&c->decompress_workspace, GFP_NOFS);
+		workspace = mempool_alloc(workspace_pool, GFP_NOFS);
 		ctx = zstd_init_dctx(workspace, zstd_dctx_workspace_bound());
 
 		ret = zstd_decompress_dctx(ctx,
 				dst_data,	dst_len,
 				src_data.b + 4, real_src_len);
 
-		mempool_free(workspace, &c->decompress_workspace);
+		mempool_free(workspace, workspace_pool);
 
 		if (ret != dst_len)
 			goto err;
@@ -562,7 +584,6 @@ void bch2_fs_compress_exit(struct bch_fs *c)
 {
 	unsigned i;
 
-	mempool_exit(&c->decompress_workspace);
 	for (i = 0; i < ARRAY_SIZE(c->compress_workspace); i++)
 		mempool_exit(&c->compress_workspace[i]);
 	mempool_exit(&c->compression_bounce[WRITE]);
@@ -571,7 +592,6 @@ void bch2_fs_compress_exit(struct bch_fs *c)
 
 static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 {
-	size_t decompress_workspace_size = 0;
 	ZSTD_parameters params = zstd_get_params(zstd_max_clevel(),
 						 c->opts.encoded_extent_max);
 
@@ -581,17 +601,15 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 		unsigned			feature;
 		enum bch_compression_opts	type;
 		size_t				compress_workspace;
-		size_t				decompress_workspace;
 	} compression_types[] = {
 		{ BCH_FEATURE_lz4, BCH_COMPRESSION_OPT_lz4,
-			max_t(size_t, LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS),
-			0 },
+			max_t(size_t, LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS) },
 		{ BCH_FEATURE_gzip, BCH_COMPRESSION_OPT_gzip,
-			zlib_deflate_workspacesize(MAX_WBITS, DEF_MEM_LEVEL),
-			zlib_inflate_workspacesize(), },
+			max(zlib_deflate_workspacesize(MAX_WBITS, DEF_MEM_LEVEL),
+			    zlib_inflate_workspacesize()) },
 		{ BCH_FEATURE_zstd, BCH_COMPRESSION_OPT_zstd,
-			c->zstd_workspace_size,
-			zstd_dctx_workspace_bound() },
+			max(c->zstd_workspace_size,
+			    zstd_dctx_workspace_bound()) },
 	}, *i;
 	bool have_compressed = false;
 
@@ -616,9 +634,6 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 	for (i = compression_types;
 	     i < compression_types + ARRAY_SIZE(compression_types);
 	     i++) {
-		decompress_workspace_size =
-			max(decompress_workspace_size, i->decompress_workspace);
-
 		if (!(features & (1 << i->feature)))
 			continue;
 
@@ -631,11 +646,6 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 			return -BCH_ERR_ENOMEM_compression_workspace_init;
 	}
 
-	if (!mempool_initialized(&c->decompress_workspace) &&
-	    mempool_init_kvmalloc_pool(&c->decompress_workspace,
-				       1, decompress_workspace_size))
-		return -BCH_ERR_ENOMEM_decompression_workspace_init;
-
 	return 0;
 }
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 18c995d41203..3affdafc2c04 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -54,7 +54,6 @@
 	x(ENOMEM,			ENOMEM_compression_bounce_read_init)	\
 	x(ENOMEM,			ENOMEM_compression_bounce_write_init)	\
 	x(ENOMEM,			ENOMEM_compression_workspace_init)	\
-	x(ENOMEM,			ENOMEM_decompression_workspace_init)	\
 	x(ENOMEM,			ENOMEM_bucket_gens)			\
 	x(ENOMEM,			ENOMEM_buckets_nouse)			\
 	x(ENOMEM,			ENOMEM_usage_init)			\
-- 
2.45.2

