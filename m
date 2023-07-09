Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF29C0015E
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjGIRQH (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjGIRQF (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:05 -0400
Received: from out-8.mta0.migadu.com (out-8.mta0.migadu.com [91.218.175.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABAD126
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ehKjqP+Yw877r6G70PMQDXue0TeXuJdQJdRFrHi5onQ=;
        b=jiu6LgSfEylFKydowMW1mWZ8enAp8UUFgAGGsl06MlfkGKe7iqT9DDvLCtFnp4TZ86pznz
        Cz2W509Jgv8cqeAOzp4xuQq2T6gPOv29sOd8renPt4mSwVPikFKyl2hRJ2YlVHkJflLT8q
        OsVzTMgo2btRKy9qP/ELkWnjCEEgRrU=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 01/10] bcachefs: Allow for unknown btree IDs
Date:   Sun,  9 Jul 2023 13:15:42 -0400
Message-Id: <20230709171551.2349961-2-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

We need to allow filesystems with metadata from newer versions to be
mountable and usable by older versions.

This patch enables us to roll out new btrees without a new major version
number; we can now handle btree roots for unknown btree types.

The unknown btree roots will be retained, and fsck (including
backpointers) will check them, the same as other btree types.

We add a dynamic array for the extra, unknown btree roots, in addition
to the fixed size btree root array, and add new helpers for looking up
btree roots.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c          | 14 ++++++++------
 fs/bcachefs/bcachefs.h              |  3 ++-
 fs/bcachefs/btree_cache.c           | 21 +++++++++++++--------
 fs/bcachefs/btree_cache.h           | 22 +++++++++++++++++++++-
 fs/bcachefs/btree_gc.c              | 22 ++++++++++++++++++----
 fs/bcachefs/btree_io.c              |  2 +-
 fs/bcachefs/btree_iter.c            |  4 ++--
 fs/bcachefs/btree_update_interior.c | 18 +++++++++---------
 fs/bcachefs/move.c                  | 10 ++++++++--
 fs/bcachefs/recovery.c              | 16 ++++++++--------
 fs/bcachefs/super.c                 |  1 +
 11 files changed, 91 insertions(+), 42 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 8d0f831550..760c4cc16a 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -272,6 +272,7 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 					 unsigned iter_flags)
 {
 	struct bch_fs *c = trans->c;
+	struct btree_root *r = bch2_btree_id_root(c, bp.btree_id);
 	struct bpos bucket = bp_pos_to_bucket(c, bp_pos);
 	struct bkey_s_c k;
 
@@ -279,7 +280,7 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 				  bp.btree_id,
 				  bp.pos,
 				  0,
-				  min(bp.level, c->btree_roots[bp.btree_id].level),
+				  min(bp.level, r->level),
 				  iter_flags);
 	k = bch2_btree_iter_peek_slot(iter);
 	if (bkey_err(k)) {
@@ -287,8 +288,8 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 		return k;
 	}
 
-	if (bp.level == c->btree_roots[bp.btree_id].level + 1)
-		k = bkey_i_to_s_c(&c->btree_roots[bp.btree_id].key);
+	if (bp.level == r->level + 1)
+		k = bkey_i_to_s_c(&r->key);
 
 	if (k.k && extent_matches_bp(c, bp.btree_id, bp.level, k, bucket, bp))
 		return k;
@@ -531,6 +532,7 @@ static int check_btree_root_to_backpointers(struct btree_trans *trans,
 					    struct bpos_level *last_flushed)
 {
 	struct bch_fs *c = trans->c;
+	struct btree_root *r = bch2_btree_id_root(c, btree_id);
 	struct btree_iter iter;
 	struct btree *b;
 	struct bkey_s_c k;
@@ -539,8 +541,7 @@ static int check_btree_root_to_backpointers(struct btree_trans *trans,
 	const union bch_extent_entry *entry;
 	int ret;
 
-	bch2_trans_node_iter_init(trans, &iter, btree_id, POS_MIN, 0,
-				  c->btree_roots[btree_id].level, 0);
+	bch2_trans_node_iter_init(trans, &iter, btree_id, POS_MIN, 0, r->level, 0);
 	b = bch2_btree_iter_peek_node(&iter);
 	ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
@@ -640,12 +641,13 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 						   struct bpos bucket_start,
 						   struct bpos bucket_end)
 {
+	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
 	enum btree_id btree_id;
 	struct bpos_level last_flushed = { UINT_MAX };
 	int ret = 0;
 
-	for (btree_id = 0; btree_id < BTREE_ID_NR; btree_id++) {
+	for (btree_id = 0; btree_id < btree_id_nr_alive(c); btree_id++) {
 		unsigned depth = btree_type_has_ptrs(btree_id) ? 0 : 1;
 
 		bch2_trans_node_iter_init(trans, &iter, btree_id, POS_MIN, 0,
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index b8d50fe64b..a8488d4e18 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -749,7 +749,8 @@ struct bch_fs {
 	struct bio_set		btree_bio;
 	struct workqueue_struct	*io_complete_wq;
 
-	struct btree_root	btree_roots[BTREE_ID_NR];
+	struct btree_root	btree_roots_known[BTREE_ID_NR];
+	DARRAY(struct btree_root) btree_roots_extra;
 	struct mutex		btree_root_lock;
 
 	struct btree_cache	btree_cache;
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index be4d22d7fc..721e2b43e2 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -32,13 +32,15 @@ void bch2_recalc_btree_reserve(struct bch_fs *c)
 {
 	unsigned i, reserve = 16;
 
-	if (!c->btree_roots[0].b)
+	if (!c->btree_roots_known[0].b)
 		reserve += 8;
 
-	for (i = 0; i < BTREE_ID_NR; i++)
-		if (c->btree_roots[i].b)
-			reserve += min_t(unsigned, 1,
-					 c->btree_roots[i].b->c.level) * 8;
+	for (i = 0; i < btree_id_nr_alive(c); i++) {
+		struct btree_root *r = bch2_btree_id_root(c, i);
+
+		if (r->b)
+			reserve += min_t(unsigned, 1, r->b->c.level) * 8;
+	}
 
 	c->btree_cache.reserve = reserve;
 }
@@ -457,9 +459,12 @@ void bch2_fs_btree_cache_exit(struct bch_fs *c)
 
 	kvpfree(c->verify_ondisk, btree_bytes(c));
 
-	for (i = 0; i < BTREE_ID_NR; i++)
-		if (c->btree_roots[i].b)
-			list_add(&c->btree_roots[i].b->list, &bc->live);
+	for (i = 0; i < btree_id_nr_alive(c); i++) {
+		struct btree_root *r = bch2_btree_id_root(c, i);
+
+		if (r->b)
+			list_add(&r->b->list, &bc->live);
+	}
 
 	list_splice(&bc->freeable, &bc->live);
 
diff --git a/fs/bcachefs/btree_cache.h b/fs/bcachefs/btree_cache.h
index 608accd1c4..00c9b92183 100644
--- a/fs/bcachefs/btree_cache.h
+++ b/fs/bcachefs/btree_cache.h
@@ -101,7 +101,27 @@ static inline unsigned btree_blocks(struct bch_fs *c)
 	(BTREE_FOREGROUND_MERGE_THRESHOLD(c) +			\
 	 (BTREE_FOREGROUND_MERGE_THRESHOLD(c) >> 2))
 
-#define btree_node_root(_c, _b)	((_c)->btree_roots[(_b)->c.btree_id].b)
+static inline unsigned btree_id_nr_alive(struct bch_fs *c)
+{
+	return BTREE_ID_NR + c->btree_roots_extra.nr;
+}
+
+static inline struct btree_root *bch2_btree_id_root(struct bch_fs *c, unsigned id)
+{
+	if (likely(id < BTREE_ID_NR)) {
+		return &c->btree_roots_known[id];
+	} else {
+		unsigned idx = id - BTREE_ID_NR;
+
+		EBUG_ON(idx >= c->btree_roots_extra.nr);
+		return &c->btree_roots_extra.data[idx];
+	}
+}
+
+static inline struct btree *btree_node_root(struct bch_fs *c, struct btree *b)
+{
+	return bch2_btree_id_root(c, b->c.btree_id)->b;
+}
 
 void bch2_btree_node_to_text(struct printbuf *, struct bch_fs *,
 			     const struct btree *);
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index e64bfbb860..1fc386761d 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -529,8 +529,13 @@ static int bch2_repair_topology(struct bch_fs *c)
 
 	bch2_trans_init(&trans, c, 0, 0);
 
-	for (i = 0; i < BTREE_ID_NR && !ret; i++) {
-		b = c->btree_roots[i].b;
+	for (i = 0; i < btree_id_nr_alive(c)&& !ret; i++) {
+		struct btree_root *r = bch2_btree_id_root(c, i);
+
+		if (!r->alive)
+			continue;
+
+		b = r->b;
 		if (btree_node_fake(b))
 			continue;
 
@@ -883,7 +888,7 @@ static int bch2_gc_btree(struct btree_trans *trans, enum btree_id btree_id,
 		return ret;
 
 	mutex_lock(&c->btree_root_lock);
-	b = c->btree_roots[btree_id].b;
+	b = bch2_btree_id_root(c, btree_id)->b;
 	if (!btree_node_fake(b)) {
 		struct bkey_s_c k = bkey_i_to_s_c(&b->key);
 
@@ -1006,7 +1011,7 @@ static int bch2_gc_btree_init(struct btree_trans *trans,
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
 
-	b = c->btree_roots[btree_id].b;
+	b = bch2_btree_id_root(c, btree_id)->b;
 
 	if (btree_node_fake(b))
 		return 0;
@@ -1075,6 +1080,15 @@ static int bch2_gc_btrees(struct bch_fs *c, bool initial, bool metadata_only)
 			? bch2_gc_btree_init(&trans, ids[i], metadata_only)
 			: bch2_gc_btree(&trans, ids[i], initial, metadata_only);
 
+	for (i = BTREE_ID_NR; i < btree_id_nr_alive(c) && !ret; i++) {
+		if (!bch2_btree_id_root(c, i)->alive)
+			continue;
+
+		ret = initial
+			? bch2_gc_btree_init(&trans, i, metadata_only)
+			: bch2_gc_btree(&trans, i, initial, metadata_only);
+	}
+
 	if (ret < 0)
 		bch_err_fn(c, ret);
 
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index cb2959bee8..a8197c5008 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -517,7 +517,7 @@ static void btree_pos_to_text(struct printbuf *out, struct bch_fs *c,
 	prt_printf(out, "%s level %u/%u\n  ",
 	       bch2_btree_ids[b->c.btree_id],
 	       b->c.level,
-	       c->btree_roots[b->c.btree_id].level);
+	       bch2_btree_id_root(c, b->c.btree_id)->level);
 	bch2_bkey_val_to_text(out, c, bkey_i_to_s_c(&b->key));
 }
 
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index bbf8f026ea..e292c5a2a8 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -238,7 +238,7 @@ static void bch2_btree_path_verify(struct btree_trans *trans,
 	for (i = 0; i < (!path->cached ? BTREE_MAX_DEPTH : 1); i++) {
 		if (!path->l[i].b) {
 			BUG_ON(!path->cached &&
-			       c->btree_roots[path->btree_id].b->c.level > i);
+			       bch2_btree_id_root(c, path->btree_id)->b->c.level > i);
 			break;
 		}
 
@@ -732,7 +732,7 @@ static inline int btree_path_lock_root(struct btree_trans *trans,
 				       unsigned long trace_ip)
 {
 	struct bch_fs *c = trans->c;
-	struct btree *b, **rootp = &c->btree_roots[path->btree_id].b;
+	struct btree *b, **rootp = &bch2_btree_id_root(c, path->btree_id)->b;
 	enum six_lock_type lock_type;
 	unsigned i;
 	int ret;
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 22cec9a29a..5592feff79 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -1199,7 +1199,7 @@ static void bch2_btree_set_root_inmem(struct bch_fs *c, struct btree *b)
 	       (b->c.level < btree_node_root(c, b)->c.level ||
 		!btree_node_dying(btree_node_root(c, b))));
 
-	btree_node_root(c, b) = b;
+	bch2_btree_id_root(c, b->c.btree_id)->b = b;
 	mutex_unlock(&c->btree_root_lock);
 
 	bch2_recalc_btree_reserve(c);
@@ -2402,7 +2402,7 @@ bool bch2_btree_interior_updates_flush(struct bch_fs *c)
 
 void bch2_journal_entry_to_btree_root(struct bch_fs *c, struct jset_entry *entry)
 {
-	struct btree_root *r = &c->btree_roots[entry->btree_id];
+	struct btree_root *r = bch2_btree_id_root(c, entry->btree_id);
 
 	mutex_lock(&c->btree_root_lock);
 
@@ -2428,15 +2428,15 @@ bch2_btree_roots_to_journal_entries(struct bch_fs *c,
 
 	mutex_lock(&c->btree_root_lock);
 
-	for (i = 0; i < BTREE_ID_NR; i++)
-		if (c->btree_roots[i].alive && !test_bit(i, &have)) {
-			journal_entry_set(end,
-					  BCH_JSET_ENTRY_btree_root,
-					  i, c->btree_roots[i].level,
-					  &c->btree_roots[i].key,
-					  c->btree_roots[i].key.k.u64s);
+	for (i = 0; i < btree_id_nr_alive(c); i++) {
+		struct btree_root *r = bch2_btree_id_root(c, i);
+
+		if (r->alive && !test_bit(i, &have)) {
+			journal_entry_set(end, BCH_JSET_ENTRY_btree_root,
+					  i, r->level, &r->key, r->key.k.u64s);
 			end = vstruct_next(end);
 		}
+	}
 
 	mutex_unlock(&c->btree_root_lock);
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 37fb3784a2..0527267390 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -632,7 +632,7 @@ int bch2_move_data(struct bch_fs *c,
 	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
 
 	for (id = start_btree_id;
-	     id <= min_t(unsigned, end_btree_id, BTREE_ID_NR - 1);
+	     id <= min_t(unsigned, end_btree_id, btree_id_nr_alive(c) - 1);
 	     id++) {
 		stats->btree_id = id;
 
@@ -640,6 +640,9 @@ int bch2_move_data(struct bch_fs *c,
 		    id != BTREE_ID_reflink)
 			continue;
 
+		if (!bch2_btree_id_root(c, id)->b)
+			continue;
+
 		ret = __bch2_move_data(&ctxt,
 				       id == start_btree_id ? start_pos : POS_MIN,
 				       id == end_btree_id   ? end_pos   : POS_MAX,
@@ -861,10 +864,13 @@ static int bch2_move_btree(struct bch_fs *c,
 	stats->data_type = BCH_DATA_btree;
 
 	for (id = start_btree_id;
-	     id <= min_t(unsigned, end_btree_id, BTREE_ID_NR - 1);
+	     id <= min_t(unsigned, end_btree_id, btree_id_nr_alive(c) - 1);
 	     id++) {
 		stats->btree_id = id;
 
+		if (!bch2_btree_id_root(c, id)->b)
+			continue;
+
 		bch2_trans_node_iter_init(&trans, &iter, id, POS_MIN, 0, 0,
 					  BTREE_ITER_PREFETCH);
 retry:
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index cf8f5c0e1b..9ea85b097e 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -702,13 +702,13 @@ static int journal_replay_entry_early(struct bch_fs *c,
 	case BCH_JSET_ENTRY_btree_root: {
 		struct btree_root *r;
 
-		if (entry->btree_id >= BTREE_ID_NR) {
-			bch_err(c, "filesystem has unknown btree type %u",
-				entry->btree_id);
-			return -EINVAL;
+		while (entry->btree_id >= c->btree_roots_extra.nr + BTREE_ID_NR) {
+			ret = darray_push(&c->btree_roots_extra, (struct btree_root) { NULL });
+			if (ret)
+				return ret;
 		}
 
-		r = &c->btree_roots[entry->btree_id];
+		r = bch2_btree_id_root(c, entry->btree_id);
 
 		if (entry->u64s) {
 			r->level = entry->level;
@@ -980,8 +980,8 @@ static int read_btree_roots(struct bch_fs *c)
 	unsigned i;
 	int ret = 0;
 
-	for (i = 0; i < BTREE_ID_NR; i++) {
-		struct btree_root *r = &c->btree_roots[i];
+	for (i = 0; i < btree_id_nr_alive(c); i++) {
+		struct btree_root *r = bch2_btree_id_root(c, i);
 
 		if (!r->alive)
 			continue;
@@ -1014,7 +1014,7 @@ static int read_btree_roots(struct bch_fs *c)
 	}
 
 	for (i = 0; i < BTREE_ID_NR; i++) {
-		struct btree_root *r = &c->btree_roots[i];
+		struct btree_root *r = bch2_btree_id_root(c, i);
 
 		if (!r->b) {
 			r->alive = false;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 4d7380099e..426d2acfca 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -486,6 +486,7 @@ static void __bch2_fs_free(struct bch_fs *c)
 		for_each_possible_cpu(cpu)
 			kfree(per_cpu_ptr(c->btree_paths_bufs, cpu)->path);
 
+	darray_exit(&c->btree_roots_extra);
 	free_percpu(c->btree_paths_bufs);
 	free_percpu(c->pcpu);
 	mempool_exit(&c->large_bkey_pool);
-- 
2.40.1

