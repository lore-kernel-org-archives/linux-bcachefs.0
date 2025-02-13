Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0510B245AF8
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472392; cv=none; b=O/a5gunfFu4JJDfGIA2zp5ZwtJZUEMyZ5pGoEtt3rpHogyu49Zce1i8JON2dF1Is8lkHboQ5tcdv1AnGJ/ECcBQcsNp3yHq/PJaXi6hr7H3N9MhSzfmxUdswFgBScynFbzDHfIxqejVhBYduExLajF50GZCvEEFBAV3OClltEqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472392; c=relaxed/simple;
	bh=pxj94mYFktmvPJZR8YKqW8wb9fE2siCTR1C+QTFzRgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilrhnpiwEQOkARIFneVpwwEyASpyQ5PCds/l8WJCMtpHDyzD6L4Gdmf58qJvOXdmEgiQo5reJSV0WQ+6yd2Znf9ZXASQ1n6QbDN1uPmqNKcX2xfi5yZvbYivKsPJ34aHVwpdOjsn3MAmv73eNoSD17TugdsFZmAXgQIHutZG6TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kW3umkFF; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kW3umkFF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472387;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nt85WNOe2c+Gvdj8ZtIlzEn4q+f4UgfnYXj01gpiv0=;
	b=kW3umkFFrmvcVJPG6yFuaHlxtIwupfDYxsKhgnAx/R0SNF/7j1BDW4rmGHGh+EnYEilDGv
	z1VnDmZ6i+SBOgpaCcjY2MDKTpjourvZZ8J9rt5WP2EbnTC3WgIxId0CgZHHZYQJ7jGPzA
	k5zO70RNR33TMy3jsCiUpT5fFdmwgog=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 15/18] bcachefs: We no longer read stripes into memory at startup
Date: Thu, 13 Feb 2025 13:46:00 -0500
Message-ID: <20250213184607.18237-16-kent.overstreet@linux.dev>
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

And the stripes heap gets deleted.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h              |   4 -
 fs/bcachefs/ec.c                    | 210 +---------------------------
 fs/bcachefs/ec.h                    |   5 -
 fs/bcachefs/ec_types.h              |   7 -
 fs/bcachefs/recovery_passes_types.h |   2 +-
 fs/bcachefs/sysfs.c                 |   5 -
 6 files changed, 2 insertions(+), 231 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index e8f4999806b6..28216297edbb 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -996,15 +996,11 @@ struct bch_fs {
 	wait_queue_head_t	copygc_running_wq;
 
 	/* STRIPES: */
-	GENRADIX(struct stripe) stripes;
 	GENRADIX(struct gc_stripe) gc_stripes;
 
 	struct hlist_head	ec_stripes_new[32];
 	spinlock_t		ec_stripes_new_lock;
 
-	ec_stripes_heap		ec_stripes_heap;
-	struct mutex		ec_stripes_heap_lock;
-
 	/* ERASURE CODING */
 	struct list_head	ec_stripe_head_list;
 	struct mutex		ec_stripe_head_lock;
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index bd47b8f0f705..689a0c32d07f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -494,38 +494,6 @@ int bch2_trigger_stripe(struct btree_trans *trans,
 			return ret;
 	}
 
-	if (flags & BTREE_TRIGGER_atomic) {
-		struct stripe *m = genradix_ptr(&c->stripes, idx);
-
-		if (!m) {
-			struct printbuf buf1 = PRINTBUF;
-			struct printbuf buf2 = PRINTBUF;
-
-			bch2_bkey_val_to_text(&buf1, c, old);
-			bch2_bkey_val_to_text(&buf2, c, new);
-			bch_err_ratelimited(c, "error marking nonexistent stripe %llu while marking\n"
-					    "old %s\n"
-					    "new %s", idx, buf1.buf, buf2.buf);
-			printbuf_exit(&buf2);
-			printbuf_exit(&buf1);
-			bch2_inconsistent_error(c);
-			return -1;
-		}
-
-		if (!new_s) {
-			bch2_stripes_heap_del(c, m, idx);
-
-			memset(m, 0, sizeof(*m));
-		} else {
-			stripe_to_mem(m, new_s);
-
-			if (!old_s)
-				bch2_stripes_heap_insert(c, m, idx);
-			else
-				bch2_stripes_heap_update(c, m, idx);
-		}
-	}
-
 	return 0;
 }
 
@@ -939,26 +907,6 @@ int bch2_ec_read_extent(struct btree_trans *trans, struct bch_read_bio *rbio,
 
 static int __ec_stripe_mem_alloc(struct bch_fs *c, size_t idx, gfp_t gfp)
 {
-	ec_stripes_heap n, *h = &c->ec_stripes_heap;
-
-	if (idx >= h->size) {
-		if (!init_heap(&n, max(1024UL, roundup_pow_of_two(idx + 1)), gfp))
-			return -BCH_ERR_ENOMEM_ec_stripe_mem_alloc;
-
-		mutex_lock(&c->ec_stripes_heap_lock);
-		if (n.size > h->size) {
-			memcpy(n.data, h->data, h->nr * sizeof(h->data[0]));
-			n.nr = h->nr;
-			swap(*h, n);
-		}
-		mutex_unlock(&c->ec_stripes_heap_lock);
-
-		free_heap(&n);
-	}
-
-	if (!genradix_ptr_alloc(&c->stripes, idx, gfp))
-		return -BCH_ERR_ENOMEM_ec_stripe_mem_alloc;
-
 	if (c->gc_pos.phase != GC_PHASE_not_running &&
 	    !genradix_ptr_alloc(&c->gc_stripes, idx, gfp))
 		return -BCH_ERR_ENOMEM_ec_stripe_mem_alloc;
@@ -1031,120 +979,6 @@ static void bch2_stripe_close(struct bch_fs *c, struct ec_stripe_new *s)
 	s->idx = 0;
 }
 
-/* Heap of all existing stripes, ordered by blocks_nonempty */
-
-static u64 stripe_idx_to_delete(struct bch_fs *c)
-{
-	ec_stripes_heap *h = &c->ec_stripes_heap;
-
-	lockdep_assert_held(&c->ec_stripes_heap_lock);
-
-	if (h->nr &&
-	    h->data[0].blocks_nonempty == 0 &&
-	    !bch2_stripe_is_open(c, h->data[0].idx))
-		return h->data[0].idx;
-
-	return 0;
-}
-
-static inline void ec_stripes_heap_set_backpointer(ec_stripes_heap *h,
-						   size_t i)
-{
-	struct bch_fs *c = container_of(h, struct bch_fs, ec_stripes_heap);
-
-	genradix_ptr(&c->stripes, h->data[i].idx)->heap_idx = i;
-}
-
-static inline bool ec_stripes_heap_cmp(const void *l, const void *r, void __always_unused *args)
-{
-	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
-	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
-
-	return ((_l->blocks_nonempty > _r->blocks_nonempty) <
-		(_l->blocks_nonempty < _r->blocks_nonempty));
-}
-
-static inline void ec_stripes_heap_swap(void *l, void *r, void *h)
-{
-	struct ec_stripe_heap_entry *_l = (struct ec_stripe_heap_entry *)l;
-	struct ec_stripe_heap_entry *_r = (struct ec_stripe_heap_entry *)r;
-	ec_stripes_heap *_h = (ec_stripes_heap *)h;
-	size_t i = _l - _h->data;
-	size_t j = _r - _h->data;
-
-	swap(*_l, *_r);
-
-	ec_stripes_heap_set_backpointer(_h, i);
-	ec_stripes_heap_set_backpointer(_h, j);
-}
-
-static const struct min_heap_callbacks callbacks = {
-	.less = ec_stripes_heap_cmp,
-	.swp = ec_stripes_heap_swap,
-};
-
-static void heap_verify_backpointer(struct bch_fs *c, size_t idx)
-{
-	ec_stripes_heap *h = &c->ec_stripes_heap;
-	struct stripe *m = genradix_ptr(&c->stripes, idx);
-
-	BUG_ON(m->heap_idx >= h->nr);
-	BUG_ON(h->data[m->heap_idx].idx != idx);
-}
-
-void bch2_stripes_heap_del(struct bch_fs *c,
-			   struct stripe *m, size_t idx)
-{
-	mutex_lock(&c->ec_stripes_heap_lock);
-	heap_verify_backpointer(c, idx);
-
-	min_heap_del(&c->ec_stripes_heap, m->heap_idx, &callbacks, &c->ec_stripes_heap);
-	mutex_unlock(&c->ec_stripes_heap_lock);
-}
-
-void bch2_stripes_heap_insert(struct bch_fs *c,
-			      struct stripe *m, size_t idx)
-{
-	mutex_lock(&c->ec_stripes_heap_lock);
-	BUG_ON(min_heap_full(&c->ec_stripes_heap));
-
-	genradix_ptr(&c->stripes, idx)->heap_idx = c->ec_stripes_heap.nr;
-	min_heap_push(&c->ec_stripes_heap, &((struct ec_stripe_heap_entry) {
-			.idx = idx,
-			.blocks_nonempty = m->blocks_nonempty,
-		}),
-		&callbacks,
-		&c->ec_stripes_heap);
-
-	heap_verify_backpointer(c, idx);
-	mutex_unlock(&c->ec_stripes_heap_lock);
-}
-
-void bch2_stripes_heap_update(struct bch_fs *c,
-			      struct stripe *m, size_t idx)
-{
-	ec_stripes_heap *h = &c->ec_stripes_heap;
-	bool do_deletes;
-	size_t i;
-
-	mutex_lock(&c->ec_stripes_heap_lock);
-	heap_verify_backpointer(c, idx);
-
-	h->data[m->heap_idx].blocks_nonempty = m->blocks_nonempty;
-
-	i = m->heap_idx;
-	min_heap_sift_up(h,	i, &callbacks, &c->ec_stripes_heap);
-	min_heap_sift_down(h, i, &callbacks, &c->ec_stripes_heap);
-
-	heap_verify_backpointer(c, idx);
-
-	do_deletes = stripe_idx_to_delete(c) != 0;
-	mutex_unlock(&c->ec_stripes_heap_lock);
-
-	if (do_deletes)
-		bch2_do_stripe_deletes(c);
-}
-
 /* stripe deletion */
 
 static int ec_stripe_delete(struct btree_trans *trans, u64 idx)
@@ -2391,46 +2225,7 @@ void bch2_fs_ec_flush(struct bch_fs *c)
 
 int bch2_stripes_read(struct bch_fs *c)
 {
-	int ret = bch2_trans_run(c,
-		for_each_btree_key(trans, iter, BTREE_ID_stripes, POS_MIN,
-				   BTREE_ITER_prefetch, k, ({
-			if (k.k->type != KEY_TYPE_stripe)
-				continue;
-
-			ret = __ec_stripe_mem_alloc(c, k.k->p.offset, GFP_KERNEL);
-			if (ret)
-				break;
-
-			struct stripe *m = genradix_ptr(&c->stripes, k.k->p.offset);
-
-			stripe_to_mem(m, bkey_s_c_to_stripe(k).v);
-
-			bch2_stripes_heap_insert(c, m, k.k->p.offset);
-			0;
-		})));
-	bch_err_fn(c, ret);
-	return ret;
-}
-
-void bch2_stripes_heap_to_text(struct printbuf *out, struct bch_fs *c)
-{
-	ec_stripes_heap *h = &c->ec_stripes_heap;
-	struct stripe *m;
-	size_t i;
-
-	mutex_lock(&c->ec_stripes_heap_lock);
-	for (i = 0; i < min_t(size_t, h->nr, 50); i++) {
-		m = genradix_ptr(&c->stripes, h->data[i].idx);
-
-		prt_printf(out, "%zu %u/%u+%u", h->data[i].idx,
-		       h->data[i].blocks_nonempty,
-		       m->nr_blocks - m->nr_redundant,
-		       m->nr_redundant);
-		if (bch2_stripe_is_open(c, h->data[i].idx))
-			prt_str(out, " open");
-		prt_newline(out);
-	}
-	mutex_unlock(&c->ec_stripes_heap_lock);
+	return 0;
 }
 
 static void bch2_new_stripe_to_text(struct printbuf *out, struct bch_fs *c,
@@ -2501,15 +2296,12 @@ void bch2_fs_ec_exit(struct bch_fs *c)
 
 	BUG_ON(!list_empty(&c->ec_stripe_new_list));
 
-	free_heap(&c->ec_stripes_heap);
-	genradix_free(&c->stripes);
 	bioset_exit(&c->ec_bioset);
 }
 
 void bch2_fs_ec_init_early(struct bch_fs *c)
 {
 	spin_lock_init(&c->ec_stripes_new_lock);
-	mutex_init(&c->ec_stripes_heap_lock);
 
 	INIT_LIST_HEAD(&c->ec_stripe_head_list);
 	mutex_init(&c->ec_stripe_head_lock);
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index cd1c837e4933..a1c662ada343 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -260,10 +260,6 @@ struct ec_stripe_head *bch2_ec_stripe_head_get(struct btree_trans *,
 			unsigned, unsigned, unsigned,
 			enum bch_watermark, struct closure *);
 
-void bch2_stripes_heap_update(struct bch_fs *, struct stripe *, size_t);
-void bch2_stripes_heap_del(struct bch_fs *, struct stripe *, size_t);
-void bch2_stripes_heap_insert(struct bch_fs *, struct stripe *, size_t);
-
 void bch2_do_stripe_deletes(struct bch_fs *);
 void bch2_ec_do_stripe_creates(struct bch_fs *);
 void bch2_ec_stripe_new_free(struct bch_fs *, struct ec_stripe_new *);
@@ -300,7 +296,6 @@ void bch2_fs_ec_flush(struct bch_fs *);
 
 int bch2_stripes_read(struct bch_fs *);
 
-void bch2_stripes_heap_to_text(struct printbuf *, struct bch_fs *);
 void bch2_new_stripes_to_text(struct printbuf *, struct bch_fs *);
 
 void bch2_fs_ec_exit(struct bch_fs *);
diff --git a/fs/bcachefs/ec_types.h b/fs/bcachefs/ec_types.h
index 37558cc2d89f..06144bfd9c19 100644
--- a/fs/bcachefs/ec_types.h
+++ b/fs/bcachefs/ec_types.h
@@ -31,11 +31,4 @@ struct gc_stripe {
 	struct bch_replicas_padded r;
 };
 
-struct ec_stripe_heap_entry {
-	size_t			idx;
-	unsigned		blocks_nonempty;
-};
-
-typedef DEFINE_MIN_HEAP(struct ec_stripe_heap_entry, ec_stripes_heap) ec_stripes_heap;
-
 #endif /* _BCACHEFS_EC_TYPES_H */
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index 418557960ed6..e89b9c783285 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -24,7 +24,7 @@
 	x(check_topology,			 4, 0)					\
 	x(accounting_read,			39, PASS_ALWAYS)			\
 	x(alloc_read,				 0, PASS_ALWAYS)			\
-	x(stripes_read,				 1, PASS_ALWAYS)			\
+	x(stripes_read,				 1, 0)					\
 	x(initialize_subvolumes,		 2, 0)					\
 	x(snapshots_read,			 3, PASS_ALWAYS)			\
 	x(check_allocations,			 5, PASS_FSCK)				\
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index b3f2c651c1f8..4551b1d86907 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -173,7 +173,6 @@ read_attribute(journal_debug);
 read_attribute(btree_cache);
 read_attribute(btree_key_cache);
 read_attribute(btree_reserve_cache);
-read_attribute(stripes_heap);
 read_attribute(open_buckets);
 read_attribute(open_buckets_partial);
 read_attribute(nocow_lock_table);
@@ -354,9 +353,6 @@ SHOW(bch2_fs)
 	if (attr == &sysfs_btree_reserve_cache)
 		bch2_btree_reserve_cache_to_text(out, c);
 
-	if (attr == &sysfs_stripes_heap)
-		bch2_stripes_heap_to_text(out, c);
-
 	if (attr == &sysfs_open_buckets)
 		bch2_open_buckets_to_text(out, c, NULL);
 
@@ -562,7 +558,6 @@ struct attribute *bch2_fs_internal_files[] = {
 	&sysfs_btree_key_cache,
 	&sysfs_btree_reserve_cache,
 	&sysfs_new_stripes,
-	&sysfs_stripes_heap,
 	&sysfs_open_buckets,
 	&sysfs_open_buckets_partial,
 #ifdef BCH_WRITE_REF_DEBUG
-- 
2.45.2

