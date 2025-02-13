Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9BF245AFE
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472386; cv=none; b=h0/gf0aaHfMIK6k06RqqpgCW5WrJ+E0iM8cLH6Ej9zAz72xa61ANPaSYWMB6eTnUJHsX8rK9Kaa2/rH2cDg9KU3p6Ks/0kUNA5GhRtduoP1eVMxf+wsY/108wDFQE05NPuQTE2Gpm8YsgHILqHG4XREglVO2DcBNAK6rAj8GFFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472386; c=relaxed/simple;
	bh=wjc9kkEjyAcTWSAvq53hL8g2uDOwyKxOheSBjClDmT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcE0CDnqXn6gC7s547kPqNcbTUFD3THtzAAU4GQJvq47sM0pwrlsfkgzeXK5rTqZrVfCgt3IBtuoiChIZCnt+6XhjMk1u9o2pWZNMyPmspktXT6H2gJx6//8HlvVQ5IETM7Jp1cD7f6fheoeq0f/nL23L0oKOBVsDv4WmkyFkXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h5BUwhlT; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h5BUwhlT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMsKUKxNbdlO8QeNTk20WO5qVLVKQpYt58oxVs7vNfE=;
	b=h5BUwhlTs/CTJWD3CEH6PAvTyNglMlLTCJlJSnTzSJSxtUdIGikM6tGWPFm2EfmrLQLJoQ
	9bUZxCaUjigcFJQ9FAw7bSuWJnivC5lF06maItEXHbkAoMer8O0xMlWvHNuynQGBwVzGhh
	rDIr1a640f4FjY0qEZv3C+yLrY3ZOUQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/18] bcachefs: Invalidate cached data by backpointers
Date: Thu, 13 Feb 2025 13:45:54 -0500
Message-ID: <20250213184607.18237-10-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If we don't leave stale pointers around, we won't have to deal with
bucket gen wraparound.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 102 +++++++++++++++++++++++++--------
 1 file changed, 79 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 58cdb6a0acf9..97c2df18dfa4 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -2055,16 +2055,71 @@ static void bch2_discard_one_bucket_fast(struct bch_dev *ca, u64 bucket)
 	bch2_write_ref_put(c, BCH_WRITE_REF_discard_fast);
 }
 
+static int invalidate_one_bp(struct btree_trans *trans,
+			     struct bch_dev *ca,
+			     struct bkey_s_c_backpointer bp,
+			     struct bkey_buf *last_flushed)
+{
+	struct btree_iter extent_iter;
+	struct bkey_s_c extent_k =
+		bch2_backpointer_get_key(trans, bp, &extent_iter, 0, last_flushed);
+	int ret = bkey_err(extent_k);
+	if (ret)
+		return ret;
+
+	struct bkey_i *n =
+		bch2_bkey_make_mut(trans, &extent_iter, &extent_k,
+				   BTREE_UPDATE_internal_snapshot_node);
+	ret = PTR_ERR_OR_ZERO(n);
+	if (ret)
+		goto err;
+
+	bch2_bkey_drop_device(bkey_i_to_s(n), ca->dev_idx);
+err:
+	bch2_trans_iter_exit(trans, &extent_iter);
+	return ret;
+}
+
+static int invalidate_one_bucket_by_bps(struct btree_trans *trans,
+					struct bch_dev *ca,
+					struct bpos bucket,
+					u8 gen,
+					struct bkey_buf *last_flushed)
+{
+	struct bpos bp_start	= bucket_pos_to_bp_start(ca,	bucket);
+	struct bpos bp_end	= bucket_pos_to_bp_end(ca,	bucket);
+
+	return for_each_btree_key_max_commit(trans, iter, BTREE_ID_backpointers,
+				      bp_start, bp_end, 0, k,
+				      NULL, NULL,
+				      BCH_WATERMARK_btree|
+				      BCH_TRANS_COMMIT_no_enospc, ({
+		if (k.k->type != KEY_TYPE_backpointer)
+			continue;
+
+		struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
+
+		if (bp.v->bucket_gen != gen)
+			continue;
+
+		/* filter out bps with gens that don't match */
+
+		invalidate_one_bp(trans, ca, bp, last_flushed);
+	}));
+}
+
+noinline_for_stack
 static int invalidate_one_bucket(struct btree_trans *trans,
+				 struct bch_dev *ca,
 				 struct btree_iter *lru_iter,
 				 struct bkey_s_c lru_k,
+				 struct bkey_buf *last_flushed,
 				 s64 *nr_to_invalidate)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_i_alloc_v4 *a = NULL;
 	struct printbuf buf = PRINTBUF;
 	struct bpos bucket = u64_to_bucket(lru_k.k->p.offset);
-	unsigned cached_sectors;
+	struct btree_iter alloc_iter = {};
 	int ret = 0;
 
 	if (*nr_to_invalidate <= 0)
@@ -2081,13 +2136,18 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	if (bch2_bucket_is_open_safe(c, bucket.inode, bucket.offset))
 		return 0;
 
-	a = bch2_trans_start_alloc_update(trans, bucket, BTREE_TRIGGER_bucket_invalidate);
-	ret = PTR_ERR_OR_ZERO(a);
+	struct bkey_s_c alloc_k = bch2_bkey_get_iter(trans, &alloc_iter,
+						     BTREE_ID_alloc, bucket,
+						     BTREE_ITER_cached);
+	ret = bkey_err(alloc_k);
 	if (ret)
-		goto out;
+		return ret;
+
+	struct bch_alloc_v4 a_convert;
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
 
 	/* We expect harmless races here due to the btree write buffer: */
-	if (lru_pos_time(lru_iter->pos) != alloc_lru_idx_read(a->v))
+	if (lru_pos_time(lru_iter->pos) != alloc_lru_idx_read(*a))
 		goto out;
 
 	/*
@@ -2097,26 +2157,16 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	 *
 	 * bch2_lru_validate() also disallows lru keys with lru_pos_time() == 0
 	 */
-	BUG_ON(a->v.data_type != BCH_DATA_cached);
-	BUG_ON(a->v.dirty_sectors);
+	BUG_ON(a->data_type != BCH_DATA_cached);
+	BUG_ON(a->dirty_sectors);
 
-	if (!a->v.cached_sectors)
+	if (!a->cached_sectors)
 		bch_err(c, "invalidating empty bucket, confused");
 
-	cached_sectors = a->v.cached_sectors;
+	unsigned cached_sectors = a->cached_sectors;
+	u8 gen = a->gen;
 
-	SET_BCH_ALLOC_V4_NEED_INC_GEN(&a->v, false);
-	a->v.gen++;
-	a->v.data_type		= 0;
-	a->v.dirty_sectors	= 0;
-	a->v.stripe_sectors	= 0;
-	a->v.cached_sectors	= 0;
-	a->v.io_time[READ]	= bch2_current_io_time(c, READ);
-	a->v.io_time[WRITE]	= bch2_current_io_time(c, WRITE);
-
-	ret = bch2_trans_commit(trans, NULL, NULL,
-				BCH_WATERMARK_btree|
-				BCH_TRANS_COMMIT_no_enospc);
+	ret = invalidate_one_bucket_by_bps(trans, ca, bucket, gen, last_flushed);
 	if (ret)
 		goto out;
 
@@ -2124,6 +2174,7 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	--*nr_to_invalidate;
 out:
 fsck_err:
+	bch2_trans_iter_exit(trans, &alloc_iter);
 	printbuf_exit(&buf);
 	return ret;
 }
@@ -2150,6 +2201,10 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 	struct btree_trans *trans = bch2_trans_get(c);
 	int ret = 0;
 
+	struct bkey_buf last_flushed;
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
 	ret = bch2_btree_write_buffer_tryflush(trans);
 	if (ret)
 		goto err;
@@ -2174,7 +2229,7 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 		if (!k.k)
 			break;
 
-		ret = invalidate_one_bucket(trans, &iter, k, &nr_to_invalidate);
+		ret = invalidate_one_bucket(trans, ca, &iter, k, &last_flushed, &nr_to_invalidate);
 restart_err:
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			continue;
@@ -2187,6 +2242,7 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 err:
 	bch2_trans_put(trans);
 	percpu_ref_put(&ca->io_ref);
+	bch2_bkey_buf_exit(&last_flushed, c);
 	bch2_write_ref_put(c, BCH_WRITE_REF_invalidate);
 }
 
-- 
2.45.2

