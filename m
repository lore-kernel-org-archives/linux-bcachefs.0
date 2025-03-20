Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB16E2222B6
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505873; cv=none; b=LxMuLARG3ZEzeyswe9lgglEuS+FKmsW9Bt0t69WHl+wARSFIUv43WLKww/CY/JS40pG/W9A9JM+XdxYst5IOL0B8Bh4je8YKchf0F1ZbGbO9T/U+OjuT+demOWTpX7QjFKLnPNZ0hS2QlcyBSlNBNywic092X38R8lghPTmotNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505873; c=relaxed/simple;
	bh=QtyJH17Wmkx6uYr2Twv4MPZJOS8zFm/KpM2EjAOE4Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pfc+mw4L9G8I0KA9ZSzKXp9MtmcT2u/wQvBN/9BLvd9QuMGHTYEdmGKuTSHC8Fc0ZZRyxvCtLMVXM3B14lD+Qy02tMYTS1+sLUwSOLTk1e40oxtixw1pUhhpWCkhrBDOe/ysf567MCGwXTIAFjLH1XdYK+tQCc67+xOBMwQ+fLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S6cDRN15; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S6cDRN15"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ge2K22bU3cO3xJgsr4fmGU3ahD1yaIcrtwTS2CVZdoc=;
	b=S6cDRN15SdF5STM9ewRJR/8P6HHEs3Ep3uJHZYDm/+0kzg53C73BvRfYEQfjRrXF0qCPyS
	gWhmtOytyMQ2aEkUgTn8o4n8sa2loAxilcUk0g/PooDAF9h88nfMyI7Izy3VFD47S8sn0n
	dJHSoTZD8akZsEJFTmUdIxMQ0SLQlkU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: EIO cleanup
Date: Thu, 20 Mar 2025 17:24:18 -0400
Message-ID: <20250320212419.3359422-4-kent.overstreet@linux.dev>
In-Reply-To: <20250320212419.3359422-1-kent.overstreet@linux.dev>
References: <20250320212419.3359422-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Replace these with proper private error codes, so that when we get an
error message we're not sifting through the entire codebase to see where
it came from.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  4 +--
 fs/bcachefs/alloc_foreground.c |  4 +--
 fs/bcachefs/alloc_foreground.h |  2 +-
 fs/bcachefs/checksum.c         |  2 +-
 fs/bcachefs/compress.c         | 56 ++++++++++++++++++----------------
 fs/bcachefs/data_update.c      |  2 +-
 fs/bcachefs/ec.c               | 16 +++++-----
 fs/bcachefs/ec.h               |  2 +-
 fs/bcachefs/errcode.h          | 18 ++++++++++-
 fs/bcachefs/inode.c            |  4 +--
 fs/bcachefs/io_write.c         | 14 ++++-----
 fs/bcachefs/journal_io.c       |  2 +-
 fs/bcachefs/journal_reclaim.c  |  6 ++--
 13 files changed, 73 insertions(+), 59 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 54e0cc373bb1..2828baa9b162 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -837,7 +837,7 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 
 	struct bch_dev *ca = bch2_dev_bucket_tryget(c, new.k->p);
 	if (!ca)
-		return -EIO;
+		return -BCH_ERR_trigger_alloc;
 
 	struct bch_alloc_v4 old_a_convert;
 	const struct bch_alloc_v4 *old_a = bch2_alloc_to_v4(old, &old_a_convert);
@@ -1031,7 +1031,7 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 invalid_bucket:
 	bch2_fs_inconsistent(c, "reference to invalid bucket\n  %s",
 			     (bch2_bkey_val_to_text(&buf, c, new.s_c), buf.buf));
-	ret = -EIO;
+	ret = -BCH_ERR_trigger_alloc;
 	goto err;
 }
 
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 1759c15a7745..95aafc232290 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -127,14 +127,14 @@ void __bch2_open_bucket_put(struct bch_fs *c, struct open_bucket *ob)
 
 void bch2_open_bucket_write_error(struct bch_fs *c,
 				  struct open_buckets *obs,
-				  unsigned dev)
+				  unsigned dev, int err)
 {
 	struct open_bucket *ob;
 	unsigned i;
 
 	open_bucket_for_each(c, obs, ob, i)
 		if (ob->dev == dev && ob->ec)
-			bch2_ec_bucket_cancel(c, ob);
+			bch2_ec_bucket_cancel(c, ob, err);
 }
 
 static struct open_bucket *bch2_open_bucket_alloc(struct bch_fs *c)
diff --git a/fs/bcachefs/alloc_foreground.h b/fs/bcachefs/alloc_foreground.h
index baf5dc163c8a..69ec6a012898 100644
--- a/fs/bcachefs/alloc_foreground.h
+++ b/fs/bcachefs/alloc_foreground.h
@@ -82,7 +82,7 @@ static inline struct open_bucket *ec_open_bucket(struct bch_fs *c,
 }
 
 void bch2_open_bucket_write_error(struct bch_fs *,
-			struct open_buckets *, unsigned);
+			struct open_buckets *, unsigned, int);
 
 void __bch2_open_bucket_put(struct bch_fs *, struct open_bucket *);
 
diff --git a/fs/bcachefs/checksum.c b/fs/bcachefs/checksum.c
index 7f9e4c59950c..3726689093e3 100644
--- a/fs/bcachefs/checksum.c
+++ b/fs/bcachefs/checksum.c
@@ -466,7 +466,7 @@ int bch2_rechecksum_bio(struct bch_fs *c, struct bio *bio,
 		prt_str(&buf, ")");
 		WARN_RATELIMIT(1, "%s", buf.buf);
 		printbuf_exit(&buf);
-		return -EIO;
+		return -BCH_ERR_recompute_checksum;
 	}
 
 	for (i = splits; i < splits + ARRAY_SIZE(splits); i++) {
diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 91483f83eb59..85fc90342492 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -177,7 +177,7 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 	size_t src_len = src->bi_iter.bi_size;
 	size_t dst_len = crc.uncompressed_size << 9;
 	void *workspace;
-	int ret;
+	int ret = 0, ret2;
 
 	enum bch_compression_opts opt = bch2_compression_type_to_opt(crc.compression_type);
 	mempool_t *workspace_pool = &c->compress_workspace[opt];
@@ -189,7 +189,7 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 		else
 			ret = -BCH_ERR_compression_workspace_not_initialized;
 		if (ret)
-			goto out;
+			goto err;
 	}
 
 	src_data = bio_map_or_bounce(c, src, READ);
@@ -197,10 +197,10 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 	switch (crc.compression_type) {
 	case BCH_COMPRESSION_TYPE_lz4_old:
 	case BCH_COMPRESSION_TYPE_lz4:
-		ret = LZ4_decompress_safe_partial(src_data.b, dst_data,
-						  src_len, dst_len, dst_len);
-		if (ret != dst_len)
-			goto err;
+		ret2 = LZ4_decompress_safe_partial(src_data.b, dst_data,
+						   src_len, dst_len, dst_len);
+		if (ret2 != dst_len)
+			ret = -BCH_ERR_decompress_lz4;
 		break;
 	case BCH_COMPRESSION_TYPE_gzip: {
 		z_stream strm = {
@@ -214,45 +214,43 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 
 		zlib_set_workspace(&strm, workspace);
 		zlib_inflateInit2(&strm, -MAX_WBITS);
-		ret = zlib_inflate(&strm, Z_FINISH);
+		ret2 = zlib_inflate(&strm, Z_FINISH);
 
 		mempool_free(workspace, workspace_pool);
 
-		if (ret != Z_STREAM_END)
-			goto err;
+		if (ret2 != Z_STREAM_END)
+			ret = -BCH_ERR_decompress_gzip;
 		break;
 	}
 	case BCH_COMPRESSION_TYPE_zstd: {
 		ZSTD_DCtx *ctx;
 		size_t real_src_len = le32_to_cpup(src_data.b);
 
-		if (real_src_len > src_len - 4)
+		if (real_src_len > src_len - 4) {
+			ret = -BCH_ERR_decompress_zstd_src_len_bad;
 			goto err;
+		}
 
 		workspace = mempool_alloc(workspace_pool, GFP_NOFS);
 		ctx = zstd_init_dctx(workspace, zstd_dctx_workspace_bound());
 
-		ret = zstd_decompress_dctx(ctx,
+		ret2 = zstd_decompress_dctx(ctx,
 				dst_data,	dst_len,
 				src_data.b + 4, real_src_len);
 
 		mempool_free(workspace, workspace_pool);
 
-		if (ret != dst_len)
-			goto err;
+		if (ret2 != dst_len)
+			ret = -BCH_ERR_decompress_zstd;
 		break;
 	}
 	default:
 		BUG();
 	}
-	ret = 0;
+err:
 fsck_err:
-out:
 	bio_unmap_or_unbounce(c, src_data);
 	return ret;
-err:
-	ret = -EIO;
-	goto out;
 }
 
 int bch2_bio_uncompress_inplace(struct bch_write_op *op,
@@ -268,18 +266,22 @@ int bch2_bio_uncompress_inplace(struct bch_write_op *op,
 	BUG_ON(!bio->bi_vcnt);
 	BUG_ON(DIV_ROUND_UP(crc->live_size, PAGE_SECTORS) > bio->bi_max_vecs);
 
-	if (crc->uncompressed_size << 9	> c->opts.encoded_extent_max ||
-	    crc->compressed_size << 9	> c->opts.encoded_extent_max) {
-		bch2_write_op_error(op, op->pos.offset, "extent too big to decompress");
-		return -EIO;
+	if (crc->uncompressed_size << 9	> c->opts.encoded_extent_max) {
+		bch2_write_op_error(op, op->pos.offset,
+				    "extent too big to decompress (%u > %u)",
+				    crc->uncompressed_size << 9, c->opts.encoded_extent_max);
+		return -BCH_ERR_decompress_exceeded_max_encoded_extent;
 	}
 
 	data = __bounce_alloc(c, dst_len, WRITE);
 
-	if (__bio_uncompress(c, bio, data.b, *crc)) {
-		if (!c->opts.no_data_io)
-			bch2_write_op_error(op, op->pos.offset, "decompression error");
-		ret = -EIO;
+	ret = __bio_uncompress(c, bio, data.b, *crc);
+
+	if (c->opts.no_data_io)
+		ret = 0;
+
+	if (ret) {
+		bch2_write_op_error(op, op->pos.offset, "%s", bch2_err_str(ret));
 		goto err;
 	}
 
@@ -312,7 +314,7 @@ int bch2_bio_uncompress(struct bch_fs *c, struct bio *src,
 
 	if (crc.uncompressed_size << 9	> c->opts.encoded_extent_max ||
 	    crc.compressed_size << 9	> c->opts.encoded_extent_max)
-		return -EIO;
+		return -BCH_ERR_decompress_exceeded_max_encoded_extent;
 
 	dst_data = dst_len == dst_iter.bi_size
 		? __bio_map_or_bounce(c, dst, dst_iter, WRITE)
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 08bb7f3019ce..0ec273daccb7 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -354,7 +354,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			printbuf_exit(&buf);
 
 			bch2_fatal_error(c);
-			ret = -EIO;
+			ret = -BCH_ERR_invalid_bkey;
 			goto out;
 		}
 
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index c73ba73f6890..f2b9225fe0bc 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1124,7 +1124,7 @@ static int ec_stripe_update_extent(struct btree_trans *trans,
 
 		bch2_fs_inconsistent(c, "%s", buf.buf);
 		printbuf_exit(&buf);
-		return -EIO;
+		return -BCH_ERR_erasure_coding_found_btree_node;
 	}
 
 	k = bch2_backpointer_get_key(trans, bp, &iter, BTREE_ITER_intent, last_flushed);
@@ -1190,7 +1190,7 @@ static int ec_stripe_update_bucket(struct btree_trans *trans, struct ec_stripe_b
 
 	struct bch_dev *ca = bch2_dev_tryget(c, ptr.dev);
 	if (!ca)
-		return -EIO;
+		return -BCH_ERR_ENOENT_dev_not_found;
 
 	struct bpos bucket_pos = PTR_BUCKET_POS(ca, &ptr);
 
@@ -1227,21 +1227,19 @@ static int ec_stripe_update_extents(struct bch_fs *c, struct ec_stripe_buf *s)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
 	struct bch_stripe *v = &bkey_i_to_stripe(&s->key)->v;
-	unsigned i, nr_data = v->nr_blocks - v->nr_redundant;
-	int ret = 0;
+	unsigned nr_data = v->nr_blocks - v->nr_redundant;
 
-	ret = bch2_btree_write_buffer_flush_sync(trans);
+	int ret = bch2_btree_write_buffer_flush_sync(trans);
 	if (ret)
 		goto err;
 
-	for (i = 0; i < nr_data; i++) {
+	for (unsigned i = 0; i < nr_data; i++) {
 		ret = ec_stripe_update_bucket(trans, s, i);
 		if (ret)
 			break;
 	}
 err:
 	bch2_trans_put(trans);
-
 	return ret;
 }
 
@@ -1451,11 +1449,11 @@ static void ec_stripe_new_cancel(struct bch_fs *c, struct ec_stripe_head *h, int
 	ec_stripe_new_set_pending(c, h);
 }
 
-void bch2_ec_bucket_cancel(struct bch_fs *c, struct open_bucket *ob)
+void bch2_ec_bucket_cancel(struct bch_fs *c, struct open_bucket *ob, int err)
 {
 	struct ec_stripe_new *s = ob->ec;
 
-	s->err = -EIO;
+	s->err = err;
 }
 
 void *bch2_writepoint_ec_buf(struct bch_fs *c, struct write_point *wp)
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index 8f2228e59eda..62d27e04d763 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -249,7 +249,7 @@ int bch2_ec_read_extent(struct btree_trans *, struct bch_read_bio *, struct bkey
 
 void *bch2_writepoint_ec_buf(struct bch_fs *, struct write_point *);
 
-void bch2_ec_bucket_cancel(struct bch_fs *, struct open_bucket *);
+void bch2_ec_bucket_cancel(struct bch_fs *, struct open_bucket *, int);
 
 int bch2_ec_stripe_new_alloc(struct bch_fs *, struct ec_stripe_head *);
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index c179954aaf33..101806d7ebe1 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -116,6 +116,7 @@
 	x(ENOENT,			ENOENT_snapshot_tree)			\
 	x(ENOENT,			ENOENT_dirent_doesnt_match_inode)	\
 	x(ENOENT,			ENOENT_dev_not_found)			\
+	x(ENOENT,			ENOENT_dev_bucket_not_found)		\
 	x(ENOENT,			ENOENT_dev_idx_not_found)		\
 	x(ENOENT,			ENOENT_inode_no_backpointer)		\
 	x(ENOENT,			ENOENT_no_snapshot_tree_subvol)		\
@@ -207,6 +208,7 @@
 	x(EINVAL,			no_resize_with_buckets_nouse)		\
 	x(EINVAL,			inode_unpack_error)			\
 	x(EINVAL,			varint_decode_error)			\
+	x(EINVAL,			erasure_coding_found_btree_node)	\
 	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
 	x(EROFS,			erofs_trans_commit)			\
 	x(EROFS,			erofs_no_writes)			\
@@ -267,6 +269,7 @@
 	x(BCH_ERR_operation_blocked,    nocow_lock_blocked)			\
 	x(EIO,				journal_shutdown)			\
 	x(EIO,				journal_flush_err)			\
+	x(EIO,				journal_write_err)			\
 	x(EIO,				btree_node_read_err)			\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_cached)		\
 	x(EIO,				sb_not_downgraded)			\
@@ -275,6 +278,7 @@
 	x(EIO,				btree_node_read_validate_error)		\
 	x(EIO,				btree_need_topology_repair)		\
 	x(EIO,				bucket_ref_update)			\
+	x(EIO,				trigger_alloc)				\
 	x(EIO,				trigger_pointer)			\
 	x(EIO,				trigger_stripe_pointer)			\
 	x(EIO,				metadata_bucket_inconsistency)		\
@@ -290,7 +294,19 @@
 	x(EIO,				EIO_fault_injected)			\
 	x(EIO,				ec_block_read)				\
 	x(EIO,				ec_block_write)				\
-	x(EIO,				data_read)				\
+	x(EIO,				recompute_checksum)			\
+	x(EIO,				decompress)				\
+	x(BCH_ERR_decompress,		decompress_exceeded_max_encoded_extent)	\
+	x(BCH_ERR_decompress,		decompress_lz4)				\
+	x(BCH_ERR_decompress,		decompress_gzip)			\
+	x(BCH_ERR_decompress,		decompress_zstd_src_len_bad)		\
+	x(BCH_ERR_decompress,		decompress_zstd)			\
+	x(EIO,				data_write)				\
+	x(BCH_ERR_data_write,		data_write_io)				\
+	x(BCH_ERR_data_write,		data_write_csum)			\
+	x(BCH_ERR_data_write,		data_write_invalid_ptr)			\
+	x(BCH_ERR_data_write,		data_write_misaligned)			\
+	x(BCH_ERR_decompress,		data_read)				\
 	x(BCH_ERR_data_read,		no_device_to_read_from)			\
 	x(BCH_ERR_data_read,		data_read_io_err)			\
 	x(BCH_ERR_data_read,		data_read_csum_err)			\
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 7aca010e2e10..1383fdcc42a5 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1079,7 +1079,7 @@ int bch2_inode_rm(struct bch_fs *c, subvol_inum inum)
 		bch2_fs_inconsistent(c,
 				     "inode %llu:%u not found when deleting",
 				     inum.inum, snapshot);
-		ret = -EIO;
+		ret = -BCH_ERR_ENOENT_inode;
 		goto err;
 	}
 
@@ -1243,7 +1243,7 @@ static noinline int __bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum
 		bch2_fs_inconsistent(c,
 				     "inode %llu:%u not found when deleting",
 				     inum, snapshot);
-		ret = -EIO;
+		ret = -BCH_ERR_ENOENT_inode;
 		goto err;
 	}
 
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index a861f786c3db..29671075e3f1 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -535,7 +535,7 @@ static noinline int bch2_write_drop_io_error_ptrs(struct bch_write_op *op)
 					    test_bit(ptr->dev, op->failed.d));
 
 			if (!bch2_bkey_nr_ptrs(bkey_i_to_s_c(src)))
-				return -EIO;
+				return -BCH_ERR_data_write_io;
 		}
 
 		if (dst != src)
@@ -589,7 +589,7 @@ static void __bch2_write_index(struct bch_write_op *op)
 out:
 	/* If some a bucket wasn't written, we can't erasure code it: */
 	for_each_set_bit(dev, op->failed.d, BCH_SB_MEMBERS_MAX)
-		bch2_open_bucket_write_error(c, &op->open_buckets, dev);
+		bch2_open_bucket_write_error(c, &op->open_buckets, dev, -BCH_ERR_data_write_io);
 
 	bch2_open_buckets_put(c, &op->open_buckets);
 	return;
@@ -920,7 +920,7 @@ static noinline int bch2_write_prep_encoded_data(struct bch_write_op *op, struct
 	return 0;
 csum_err:
 	bch2_write_csum_err_msg(op);
-	return -EIO;
+	return -BCH_ERR_data_write_csum;
 }
 
 static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
@@ -1127,7 +1127,7 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 	return more;
 csum_err:
 	bch2_write_csum_err_msg(op);
-	ret = -EIO;
+	ret = -BCH_ERR_data_write_csum;
 err:
 	if (to_wbio(dst)->bounce)
 		bch2_bio_free_pages_pool(c, dst);
@@ -1233,7 +1233,7 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
 static void __bch2_nocow_write_done(struct bch_write_op *op)
 {
 	if (unlikely(op->flags & BCH_WRITE_io_error)) {
-		op->error = -EIO;
+		op->error = -BCH_ERR_data_write_io;
 	} else if (unlikely(op->flags & BCH_WRITE_convert_unwritten))
 		bch2_nocow_write_convert_unwritten(op);
 }
@@ -1424,7 +1424,7 @@ static void bch2_nocow_write(struct bch_write_op *op)
 				    "pointer to invalid bucket in nocow path on device %llu\n  %s",
 				    stale_at->b.inode,
 				    (bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
-		ret = -EIO;
+		ret = -BCH_ERR_data_write_invalid_ptr;
 	} else {
 		/* We can retry this: */
 		ret = -BCH_ERR_transaction_restart;
@@ -1632,7 +1632,7 @@ CLOSURE_CALLBACK(bch2_write)
 
 	if (unlikely(bio->bi_iter.bi_size & (c->opts.block_size - 1))) {
 		bch2_write_op_error(op, op->pos.offset, "misaligned write");
-		op->error = -EIO;
+		op->error = -BCH_ERR_data_write_misaligned;
 		goto err;
 	}
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index cf2700b06d58..4ed6137f0439 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1624,7 +1624,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 
 	if (!w->devs_written.nr) {
 		bch_err(c, "unable to write journal to sufficient devices");
-		err = -EIO;
+		err = -BCH_ERR_journal_write_err;
 	} else {
 		bch2_devlist_to_replicas(&replicas.e, BCH_DATA_journal,
 					 w->devs_written);
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 3ed31492e1aa..5d1547aa118a 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -645,7 +645,6 @@ static u64 journal_seq_to_flush(struct journal *j)
  * @j:		journal object
  * @direct:	direct or background reclaim?
  * @kicked:	requested to run since we last ran?
- * Returns:	0 on success, or -EIO if the journal has been shutdown
  *
  * Background journal reclaim writes out btree nodes. It should be run
  * early enough so that we never completely run out of journal buckets.
@@ -685,10 +684,9 @@ static int __bch2_journal_reclaim(struct journal *j, bool direct, bool kicked)
 		if (kthread && kthread_should_stop())
 			break;
 
-		if (bch2_journal_error(j)) {
-			ret = -EIO;
+		ret = bch2_journal_error(j);
+		if (ret)
 			break;
-		}
 
 		bch2_journal_do_discards(j);
 
-- 
2.49.0

