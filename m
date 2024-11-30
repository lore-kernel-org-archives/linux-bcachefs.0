Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189564D8C8
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930780; cv=none; b=tAOpL+AjjaIpMKGA9rcjvLB0INQ80p5VKW84EV7s9fEiK2/Xk0x/uBlFkoGKQ+p2F0N10j1gO+BY68Xsfkb8mGnxIrdlDC+DIVyFCMJZ6v4427V7u/OODegdSQd+aMJlAqrhVIwE2qGG6j+qXw3ZEYX1KLiPgXhYoyTwK1otvvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930780; c=relaxed/simple;
	bh=I/xiW+87o91a1m8kwrEcVpJXtoeob7aE0zFV6yAbKXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7aagSEKhBbeJNtiv3q9O2seLC3V1mMv8bXv9Lnbv5kofejaxuXHSWT6I1luNZiBSSEBZJbZbPyEqD8UDj7cjwMUBeznKI2T34WKvCICUrLqiEy7hxoHkLYI6KFwHRdg1FDfVWN6usuL/JKQ6fSHr6BriGXWrjoF5ioyf+hTltA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YK5NRVRZ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YK5NRVRZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QJxiczrNSWYCbnZVIa0nGI7jZF1t9QFWuBIK4RYdNo0=;
	b=YK5NRVRZTs/XVpx/jQHSFX5sHxhBMpC6Dci4PCQz2z0/HAZwp0mIPhiApTQ2zyQaHZcKyB
	nrzpFAOe1P7Q38CIVArzXxHwAc0QpbHIMSeBdydZoik3MjquW34nat0CV0f5llguk+6fgn
	ZxwR3gCuSG3Dd0XwukGU3t1i4x3WFEI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/8] bcachefs: check_extents_to_backpointers() now only checks buckets with mismatches
Date: Fri, 29 Nov 2024 20:39:17 -0500
Message-ID: <20241130013922.3135792-6-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Instead of walking every extent and every backpointer it points to,
first sum up backpointers in each bucket and check for mismatches, and
only look for missing backpointers if mismatches were detected, and only
check extents in those buckets.

This is a major fsck scalability improvement, since the two backpointers
passes (backpointers -> extents and extents -> backpointers) are the
most expensive fsck passes by far.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 278 ++++++++++++++++++++++++++++++++++---
 fs/bcachefs/bcachefs.h     |   2 +
 fs/bcachefs/btree_cache.c  |   1 -
 fs/bcachefs/errcode.h      |   1 +
 4 files changed, 263 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 7e2ae07b9df8..719781470633 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -566,25 +566,29 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 					struct bkey_s_c k)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_ptrs_c ptrs;
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
-	int ret;
 
-	ptrs = bch2_bkey_ptrs_c(k);
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		struct bkey_i_backpointer bp;
-
 		if (p.ptr.cached)
 			continue;
 
 		if (p.ptr.dev == BCH_SB_MEMBER_INVALID)
 			continue;
 
-		bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
-		ret = check_bp_exists(trans, s, &bp, k);
-		if (ret)
-			return ret;
+		rcu_read_lock();
+		struct bch_dev *ca = bch2_dev_rcu_noerror(c, p.ptr.dev);
+		bool check = ca && test_bit(PTR_BUCKET_NR(ca, &p.ptr), ca->bucket_backpointer_mismatches);
+		rcu_read_unlock();
+
+		if (check) {
+			struct bkey_i_backpointer bp;
+			bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
+			int ret = check_bp_exists(trans, s, &bp, k);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -793,26 +797,259 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 	return 0;
 }
 
+enum alloc_sector_counter {
+	ALLOC_dirty,
+	ALLOC_cached,
+	ALLOC_stripe,
+	ALLOC_SECTORS_NR
+};
+
+static enum alloc_sector_counter data_type_to_alloc_counter(enum bch_data_type t)
+{
+	switch (t) {
+	case BCH_DATA_btree:
+	case BCH_DATA_user:
+		return ALLOC_dirty;
+	case BCH_DATA_cached:
+		return ALLOC_cached;
+	case BCH_DATA_stripe:
+		return ALLOC_stripe;
+	default:
+		BUG();
+	}
+}
+
+static int check_bucket_backpointer_mismatch_one(struct btree_trans *trans, struct bkey_s_c alloc_k,
+						 struct bkey_buf *last_flushed)
+{
+	int ret = 0;
+	struct bch_alloc_v4 a_convert;
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
+
+	if (a->data_type == BCH_DATA_sb ||
+	    a->data_type == BCH_DATA_journal ||
+	    a->data_type == BCH_DATA_parity)
+		return 0;
+
+	u32 sectors[ALLOC_SECTORS_NR];
+	memset(sectors, 0, sizeof(sectors));
+
+	struct bch_dev *ca = bch2_dev_bucket_tryget_noerror(trans->c, alloc_k.k->p);
+	if (!ca)
+		return 0;
+
+	struct btree_iter iter;
+	struct bkey_s_c bp_k;
+	for_each_btree_key_max_norestart(trans, iter, BTREE_ID_backpointers,
+				bucket_pos_to_bp_start(ca, alloc_k.k->p),
+				bucket_pos_to_bp_end(ca, alloc_k.k->p), 0, bp_k, ret) {
+		if (bp_k.k->type != KEY_TYPE_backpointer)
+			continue;
+
+		struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(bp_k);
+
+		if (bp.v->bucket_gen != a->gen)
+			continue;
+
+		sectors[data_type_to_alloc_counter(bp.v->data_type)] += bp.v->bucket_len;
+	};
+	bch2_trans_iter_exit(trans, &iter);
+	if (ret)
+		goto err;
+
+	/* Cached pointers don't have backpointers: */
+
+	if (sectors[ALLOC_dirty] != a->dirty_sectors ||
+	    sectors[ALLOC_stripe] != a->stripe_sectors) {
+		ret = bch2_backpointers_maybe_flush(trans, alloc_k, last_flushed);
+		if (ret)
+			goto err;
+
+		__set_bit(alloc_k.k->p.offset, ca->bucket_backpointer_mismatches);
+	}
+err:
+	bch2_dev_put(ca);
+	return ret;
+}
+
+static int check_bucket_backpointer_mismatches(struct btree_trans *trans,
+					       struct bkey_buf *last_flushed)
+{
+	return for_each_btree_key(trans, iter, BTREE_ID_alloc,
+				     POS_MIN, BTREE_ITER_prefetch, k, ({
+		check_bucket_backpointer_mismatch_one(trans, k, last_flushed);
+	}));
+}
+
+static bool backpointer_node_has_missing(struct bch_fs *c, struct bkey_s_c k)
+{
+	switch (k.k->type) {
+	case KEY_TYPE_btree_ptr_v2: {
+		bool ret = false;
+
+		rcu_read_lock();
+		struct bpos pos = bkey_s_c_to_btree_ptr_v2(k).v->min_key;
+		while (pos.inode <= k.k->p.inode) {
+			struct bch_dev *ca = bch2_dev_rcu_noerror(c, pos.inode);
+			if (!ca)
+				goto next;
+
+			struct bpos bucket = bp_pos_to_bucket(ca, pos);
+			bucket.offset = find_next_bit(ca->bucket_backpointer_mismatches,
+						      ca->mi.nbuckets, bucket.offset);
+			if (bucket.offset == ca->mi.nbuckets)
+				goto next;
+
+			ret = bpos_le(bucket_pos_to_bp_end(ca, bucket), k.k->p);
+			if (ret)
+				break;
+next:
+			pos = SPOS(pos.inode + 1, 0, 0);
+		}
+		rcu_read_unlock();
+
+		return ret;
+	}
+	case KEY_TYPE_btree_ptr:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int btree_node_get_and_pin(struct btree_trans *trans, struct bkey_i *k,
+				  enum btree_id btree, unsigned level)
+{
+	struct btree_iter iter;
+	bch2_trans_node_iter_init(trans, &iter, btree, k->k.p, 0, level, 0);
+	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	int ret = PTR_ERR_OR_ZERO(b);
+	if (ret)
+		goto err;
+
+	if (b)
+		bch2_node_pin(trans->c, b);
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+static int bch2_pin_backpointer_nodes_with_missing(struct btree_trans *trans,
+					struct bpos start, struct bpos *end)
+{
+	struct bch_fs *c = trans->c;
+	int ret = 0;
+
+	struct bkey_buf tmp;
+	bch2_bkey_buf_init(&tmp);
+
+	bch2_btree_cache_unpin(c);
+
+	*end = SPOS_MAX;
+
+	s64 mem_may_pin = mem_may_pin_bytes(c);
+	struct btree_iter iter;
+	bch2_trans_node_iter_init(trans, &iter, BTREE_ID_backpointers, start,
+				  0, 1, BTREE_ITER_prefetch);
+	ret = for_each_btree_key_continue(trans, iter, 0, k, ({
+		if (!backpointer_node_has_missing(c, k))
+			continue;
+
+		mem_may_pin -= c->opts.btree_node_size;
+		if (mem_may_pin <= 0)
+			break;
+
+		bch2_bkey_buf_reassemble(&tmp, c, k);
+		struct btree_path *path = btree_iter_path(trans, &iter);
+
+		BUG_ON(path->level != 1);
+
+		bch2_btree_node_prefetch(trans, path, tmp.k, path->btree_id, path->level - 1);
+	}));
+	if (ret)
+		return ret;
+
+	struct bpos pinned = SPOS_MAX;
+	mem_may_pin = mem_may_pin_bytes(c);
+	bch2_trans_node_iter_init(trans, &iter, BTREE_ID_backpointers, start,
+				  0, 1, BTREE_ITER_prefetch);
+	ret = for_each_btree_key_continue(trans, iter, 0, k, ({
+		if (!backpointer_node_has_missing(c, k))
+			continue;
+
+		mem_may_pin -= c->opts.btree_node_size;
+		if (mem_may_pin <= 0) {
+			*end = pinned;
+			break;
+		}
+
+		bch2_bkey_buf_reassemble(&tmp, c, k);
+		struct btree_path *path = btree_iter_path(trans, &iter);
+
+		BUG_ON(path->level != 1);
+
+		int ret2 = btree_node_get_and_pin(trans, tmp.k, path->btree_id, path->level - 1);
+
+		if (!ret2)
+			pinned = tmp.k->k.p;
+
+		ret;
+	}));
+	if (ret)
+		return ret;
+
+	return ret;
+}
+
 int bch2_check_extents_to_backpointers(struct bch_fs *c)
 {
+	int ret = 0;
+
+	/*
+	 * Can't allow devices to come/go/resize while we have bucket bitmaps
+	 * allocated
+	 */
+	lockdep_assert_held(&c->state_lock);
+
+	for_each_member_device(c, ca) {
+		BUG_ON(ca->bucket_backpointer_mismatches);
+		ca->bucket_backpointer_mismatches = kvcalloc(BITS_TO_LONGS(ca->mi.nbuckets),
+							     sizeof(unsigned long),
+							     GFP_KERNEL);
+		if (!ca->bucket_backpointer_mismatches) {
+			bch2_dev_put(ca);
+			ret = -BCH_ERR_ENOMEM_backpointer_mismatches_bitmap;
+			goto err_free_bitmaps;
+		}
+	}
+
 	struct btree_trans *trans = bch2_trans_get(c);
 	struct extents_to_bp_state s = { .bp_start = POS_MIN };
-	int ret;
 
 	bch2_bkey_buf_init(&s.last_flushed);
 	bkey_init(&s.last_flushed.k->k);
 
+	ret = check_bucket_backpointer_mismatches(trans, &s.last_flushed);
+	if (ret)
+		goto err;
+
+	u64 nr_buckets = 0, nr_mismatches = 0;
+	for_each_member_device(c, ca) {
+		nr_buckets += ca->mi.nbuckets;
+		nr_mismatches += bitmap_weight(ca->bucket_backpointer_mismatches, ca->mi.nbuckets);
+	}
+
+	if (!nr_mismatches)
+		goto err;
+
+	bch_info(c, "scanning for missing backpointers in %llu/%llu buckets",
+		 nr_mismatches, nr_buckets);
+
 	while (1) {
-		struct bbpos end;
-		ret = bch2_get_btree_in_memory_pos(trans,
-				BIT_ULL(BTREE_ID_backpointers),
-				BIT_ULL(BTREE_ID_backpointers),
-				BBPOS(BTREE_ID_backpointers, s.bp_start), &end);
+		ret = bch2_pin_backpointer_nodes_with_missing(trans, s.bp_start, &s.bp_end);
 		if (ret)
 			break;
 
-		s.bp_end = end.pos;
-
 		if ( bpos_eq(s.bp_start, POS_MIN) &&
 		    !bpos_eq(s.bp_end, SPOS_MAX))
 			bch_verbose(c, "%s(): alloc info does not fit in ram, running in multiple passes with %zu nodes per pass",
@@ -837,10 +1074,15 @@ int bch2_check_extents_to_backpointers(struct bch_fs *c)
 
 		s.bp_start = bpos_successor(s.bp_end);
 	}
+err:
 	bch2_trans_put(trans);
 	bch2_bkey_buf_exit(&s.last_flushed, c);
-
 	bch2_btree_cache_unpin(c);
+err_free_bitmaps:
+	for_each_member_device(c, ca) {
+		kvfree(ca->bucket_backpointer_mismatches);
+		ca->bucket_backpointer_mismatches = NULL;
+	}
 
 	bch_err_fn(c, ret);
 	return ret;
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index b12c9c78beec..f2ccca1366b1 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -557,6 +557,8 @@ struct bch_dev {
 	unsigned long		*buckets_nouse;
 	struct rw_semaphore	bucket_lock;
 
+	unsigned long		*bucket_backpointer_mismatches;
+
 	struct bch_dev_usage __percpu	*usage;
 
 	/* Allocator: */
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 1117be901cf0..b00c6a20be27 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -222,7 +222,6 @@ void bch2_node_pin(struct bch_fs *c, struct btree *b)
 	struct btree_cache *bc = &c->btree_cache;
 
 	mutex_lock(&bc->lock);
-	BUG_ON(!__btree_node_pinned(bc, b));
 	if (b != btree_node_root(c, b) && !btree_node_pinned(b)) {
 		set_btree_node_pinned(b);
 		list_move(&b->list, &bc->live[1].list);
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 47387f7d6202..924d24007464 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -54,6 +54,7 @@
 	x(ENOMEM,			ENOMEM_compression_bounce_read_init)	\
 	x(ENOMEM,			ENOMEM_compression_bounce_write_init)	\
 	x(ENOMEM,			ENOMEM_compression_workspace_init)	\
+	x(ENOMEM,			ENOMEM_backpointer_mismatches_bitmap)	\
 	x(EIO,				compression_workspace_not_initialized)	\
 	x(ENOMEM,			ENOMEM_bucket_gens)			\
 	x(ENOMEM,			ENOMEM_buckets_nouse)			\
-- 
2.45.2

