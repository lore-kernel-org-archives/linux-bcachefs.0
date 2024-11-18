Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D53E4225D6
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893831; cv=none; b=YZx16QO7Wnvj3VzVt2sX1tJO6LlIRMD1MY9DbK00PKoY5ydkjo1oai6RMKUXbMirbp4V41U1QaHFatY7aYMr0ehvAXdsfuYzsLcD6OTLvtu4VV72AaosNMv+tH6D+fawWYW0jOsCMC5XRxMMqsdemfJa8PtxQV36Aw+xUGL1bG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893831; c=relaxed/simple;
	bh=USfbZPckiYmfWrvxkdABFU4gmgv39/OW2CKuvBOGleM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Sf+MWIenq1w14XLjNFmYD2WFqm5uJjz9Yw6vJPz0uCIDnwANyUtCtXBzAAS29LvOZNLy/4KNGGATp+W4hgAxQU/+EPDpa9HqaQqbg23HR721zq/8DT7IzLidZhHYdpCkvkqEBtxH67jitgisgU/Oe03icKt/jkTQ7kFzr0kY7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xYXVng3e; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xYXVng3e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zERKxQ23wVYeTkt6dknnmna5h2wTvT4tyCW8pgvCtTM=;
	b=xYXVng3eiQkoKOkZa+i7XCULQIF5nvtl+1ZsM9HM9YZGX1Rj+DKf/5f+Y2cvdEsRgD4V67
	xbu+xhpU2tb1j4q8kQeXsFMTfkIKvgIYPoLWu506vm//xr8Y7XT3UgvjxYnk04ILTOEmc7
	MpAqqBpjnhodogfi5CHseznY9GMx2uI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: compression workspaces should be indexed by opt, not type
Date: Sun, 17 Nov 2024 20:36:49 -0500
Message-ID: <20241118013651.2275187-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

type includes lz4 and lz4_old, which do not get different compression
workspaces, and incompressible, a fake type - BCH_COMPRESSION_OPTS() is
the correct enum to use.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h |  2 +-
 fs/bcachefs/compress.c | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index c59a58b93a92..60ad547c52a8 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -982,7 +982,7 @@ struct bch_fs {
 	struct rhashtable	promote_table;
 
 	mempool_t		compression_bounce[2];
-	mempool_t		compress_workspace[BCH_COMPRESSION_TYPE_NR];
+	mempool_t		compress_workspace[BCH_COMPRESSION_OPT_NR];
 	mempool_t		decompress_workspace;
 	size_t			zstd_workspace_size;
 
diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 1410365a8891..4f541a195c84 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -394,8 +394,11 @@ static unsigned __bio_compress(struct bch_fs *c,
 	unsigned pad;
 	int ret = 0;
 
-	BUG_ON(compression_type >= BCH_COMPRESSION_TYPE_NR);
-	BUG_ON(!mempool_initialized(&c->compress_workspace[compression_type]));
+	/* bch2_compression_decode catches unknown compression types: */
+	BUG_ON(compression.type >= BCH_COMPRESSION_OPT_NR);
+
+	mempool_t *workspace_pool = &c->compress_workspace[compression.type];
+	BUG_ON(!mempool_initialized(workspace_pool));
 
 	/* If it's only one block, don't bother trying to compress: */
 	if (src->bi_iter.bi_size <= c->opts.block_size)
@@ -404,7 +407,7 @@ static unsigned __bio_compress(struct bch_fs *c,
 	dst_data = bio_map_or_bounce(c, dst, WRITE);
 	src_data = bio_map_or_bounce(c, src, READ);
 
-	workspace = mempool_alloc(&c->compress_workspace[compression_type], GFP_NOFS);
+	workspace = mempool_alloc(workspace_pool, GFP_NOFS);
 
 	*src_len = src->bi_iter.bi_size;
 	*dst_len = dst->bi_iter.bi_size;
@@ -447,7 +450,7 @@ static unsigned __bio_compress(struct bch_fs *c,
 		*src_len = round_down(*src_len, block_bytes(c));
 	}
 
-	mempool_free(workspace, &c->compress_workspace[compression_type]);
+	mempool_free(workspace, workspace_pool);
 
 	if (ret)
 		goto err;
@@ -576,17 +579,17 @@ static int __bch2_fs_compress_init(struct bch_fs *c, u64 features)
 
 	struct {
 		unsigned			feature;
-		enum bch_compression_type	type;
+		enum bch_compression_opts	type;
 		size_t				compress_workspace;
 		size_t				decompress_workspace;
 	} compression_types[] = {
-		{ BCH_FEATURE_lz4, BCH_COMPRESSION_TYPE_lz4,
+		{ BCH_FEATURE_lz4, BCH_COMPRESSION_OPT_lz4,
 			max_t(size_t, LZ4_MEM_COMPRESS, LZ4HC_MEM_COMPRESS),
 			0 },
-		{ BCH_FEATURE_gzip, BCH_COMPRESSION_TYPE_gzip,
+		{ BCH_FEATURE_gzip, BCH_COMPRESSION_OPT_gzip,
 			zlib_deflate_workspacesize(MAX_WBITS, DEF_MEM_LEVEL),
 			zlib_inflate_workspacesize(), },
-		{ BCH_FEATURE_zstd, BCH_COMPRESSION_TYPE_zstd,
+		{ BCH_FEATURE_zstd, BCH_COMPRESSION_OPT_zstd,
 			c->zstd_workspace_size,
 			zstd_dctx_workspace_bound() },
 	}, *i;
-- 
2.45.2

