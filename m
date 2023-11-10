Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF6139876
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iwY+1b8w"
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ba])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFF13EB04
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:14 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=igq9PpvTdcS+zKMSQ/ZHLqwbENola+66BD+XdrqYLiE=;
	b=iwY+1b8wOPQLvNhlwArbrtcTj/FJZnLxZfQto6MgV1osHAxGPdP72k2fs+HXCdO612nEqU
	CLxIexHebLOB8dYs5E1jioYSJz+JlFGLLiSXlH4b6vKq4Xo1op4aD8tfnNvWfMTvMYJ7nW
	pCDG0zrl0aSyBDxNAjdUfvWiPrhCMhU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 16/17] bcachefs: btree write buffer now slurps keys from journal
Date: Fri, 10 Nov 2023 11:31:53 -0500
Message-ID: <20231110163157.2736111-17-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Previosuly, the transaction commit path would have to add keys to the
btree write buffer as a separate operation, requiring additional global
synchronization.

This patch introduces a new journal entry type, which indicates that the
keys need to be copied into the btree write buffer prior to being
written out. We switch the journal entry type back to
JSET_ENTRY_btree_keys prior to write, so this is not an on disk format
change.

Flushing the btree write buffer may require pulling keys out of journal
entries yet to be written, and quiescing outstanding journal
reservations; we previously added journal->buf_lock for synchronization
with the journal write path.

We also can't put strict bounds on the number of keys in the journal
destined for the write buffer, which means we might overflow the size of
the preallocated buffer and have to reallocate - this introduces a
potentially fatal memory allocation failure. This is something we'll
have to watch for, if it becomes an issue in practice we can do
additional mitigation.

The transaction commit path no longer has to explicitly check if the
write buffer is full and wait on flushing; this is another performance
optimization. Instead, when the btree write buffer is close to full we
change the journal watermark, so that only reservations for journal
reclaim are allowed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h                 |  11 +
 fs/bcachefs/bcachefs_format.h          |   3 +-
 fs/bcachefs/btree_trans_commit.c       |  52 +--
 fs/bcachefs/btree_write_buffer.c       | 507 ++++++++++++++++---------
 fs/bcachefs/btree_write_buffer.h       |  46 ++-
 fs/bcachefs/btree_write_buffer_types.h |  37 +-
 fs/bcachefs/errcode.h                  |   1 -
 fs/bcachefs/journal.c                  |  43 +++
 fs/bcachefs/journal.h                  |   1 +
 fs/bcachefs/journal_io.c               |  51 ++-
 fs/bcachefs/journal_reclaim.c          |  12 +-
 fs/bcachefs/journal_reclaim.h          |   1 +
 fs/bcachefs/journal_types.h            |   2 +
 fs/bcachefs/super.c                    |   3 +-
 14 files changed, 512 insertions(+), 258 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 748164c0e82b..d40a6bb0e7ef 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -406,6 +406,7 @@ BCH_DEBUG_PARAMS_DEBUG()
 	x(blocked_journal_max_in_flight)	\
 	x(blocked_allocate)			\
 	x(blocked_allocate_open_bucket)		\
+	x(blocked_write_buffer_full)		\
 	x(nocow_lock_contended)
 
 enum bch_time_stats {
@@ -1065,6 +1066,16 @@ static inline void bch2_write_ref_get(struct bch_fs *c, enum bch_write_ref ref)
 #endif
 }
 
+static inline bool __bch2_write_ref_tryget(struct bch_fs *c, enum bch_write_ref ref)
+{
+#ifdef BCH_WRITE_REF_DEBUG
+	return !test_bit(BCH_FS_GOING_RO, &c->flags) &&
+		atomic_long_inc_not_zero(&c->writes[ref]);
+#else
+	return percpu_ref_tryget(&c->writes);
+#endif
+}
+
 static inline bool bch2_write_ref_tryget(struct bch_fs *c, enum bch_write_ref ref)
 {
 #ifdef BCH_WRITE_REF_DEBUG
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 0a750953ff92..15083f9273d4 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -2124,7 +2124,8 @@ static inline __u64 __bset_magic(struct bch_sb *sb)
 	x(clock,		7)		\
 	x(dev_usage,		8)		\
 	x(log,			9)		\
-	x(overwrite,		10)
+	x(overwrite,		10)		\
+	x(write_buffer_keys,	11)
 
 enum {
 #define x(f, nr)	BCH_JSET_ENTRY_##f	= nr,
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 722542316eb1..e358990f58f0 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -660,10 +660,6 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 		i->k->k.needs_whiteout = false;
 	}
 
-	if (trans->nr_wb_updates &&
-	    trans->nr_wb_updates + c->btree_write_buffer.state.nr > c->btree_write_buffer.size)
-		return -BCH_ERR_btree_insert_need_flush_buffer;
-
 	/*
 	 * Don't get journal reservation until after we know insert will
 	 * succeed:
@@ -698,14 +694,6 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 	    bch2_trans_fs_usage_apply(trans, trans->fs_usage_deltas))
 		return -BCH_ERR_btree_insert_need_mark_replicas;
 
-	if (trans->nr_wb_updates) {
-		EBUG_ON(flags & BTREE_INSERT_JOURNAL_REPLAY);
-
-		ret = bch2_btree_insert_keys_write_buffer(trans);
-		if (ret)
-			goto revert_fs_usage;
-	}
-
 	h = trans->hooks;
 	while (h) {
 		ret = h->fn(trans, h);
@@ -767,7 +755,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 
 		trans_for_each_wb_update(trans, wb) {
 			entry = bch2_journal_add_entry(j, &trans->journal_res,
-					       BCH_JSET_ENTRY_btree_keys,
+					       BCH_JSET_ENTRY_write_buffer_keys,
 					       wb->btree, 0,
 					       wb->k.k.u64s);
 			bkey_copy((struct bkey_i *) entry->start, &wb->k);
@@ -951,30 +939,6 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 
 		ret = bch2_trans_relock(trans);
 		break;
-	case -BCH_ERR_btree_insert_need_flush_buffer: {
-		struct btree_write_buffer *wb = &c->btree_write_buffer;
-
-		ret = 0;
-
-		if (wb->state.nr > wb->size * 3 / 4) {
-			bch2_trans_unlock(trans);
-			mutex_lock(&wb->flush_lock);
-
-			if (wb->state.nr > wb->size * 3 / 4) {
-				bch2_trans_begin(trans);
-				ret = bch2_btree_write_buffer_flush_locked(trans);
-				mutex_unlock(&wb->flush_lock);
-				if (!ret) {
-					trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
-					ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
-				}
-			} else {
-				mutex_unlock(&wb->flush_lock);
-				ret = bch2_trans_relock(trans);
-			}
-		}
-		break;
-	}
 	default:
 		BUG_ON(ret >= 0);
 		break;
@@ -1077,20 +1041,6 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 			goto out_reset;
 	}
 
-	if (c->btree_write_buffer.state.nr > c->btree_write_buffer.size / 2 &&
-	    mutex_trylock(&c->btree_write_buffer.flush_lock)) {
-		bch2_trans_begin(trans);
-		bch2_trans_unlock(trans);
-
-		ret = bch2_btree_write_buffer_flush_locked(trans);
-		mutex_unlock(&c->btree_write_buffer.flush_lock);
-		if (!ret) {
-			trace_and_count(c, trans_restart_write_buffer_flush, trans, _THIS_IP_);
-			ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_write_buffer_flush);
-		}
-		goto out;
-	}
-
 	EBUG_ON(test_bit(BCH_FS_CLEAN_SHUTDOWN, &c->flags));
 
 	trans->journal_u64s		= trans->extra_journal_entries.nr;
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 74d864715b39..e961cf33db1e 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -7,6 +7,7 @@
 #include "btree_write_buffer.h"
 #include "error.h"
 #include "journal.h"
+#include "journal_io.h"
 #include "journal_reclaim.h"
 
 #include <linux/sort.h>
@@ -14,36 +15,47 @@
 static int bch2_btree_write_buffer_journal_flush(struct journal *,
 				struct journal_entry_pin *, u64);
 
-static int btree_write_buffered_key_cmp(const void *_l, const void *_r)
+static int bch2_journal_keys_to_write_buffer(struct bch_fs *, struct journal_buf *);
+
+static inline int wb_key_cmp(const void *_l, const void *_r)
 {
-	const struct btree_write_buffered_key *l = _l;
-	const struct btree_write_buffered_key *r = _r;
+	const struct btree_write_buffered_key_ref *l = _l;
+	const struct btree_write_buffered_key_ref *r = _r;
 
 	return  cmp_int(l->btree, r->btree) ?:
-		bpos_cmp(l->k.k.p, r->k.k.p) ?:
-		cmp_int(l->journal_seq, r->journal_seq) ?:
-		cmp_int(l->journal_offset, r->journal_offset);
+		bpos_cmp(l->pos, r->pos) ?:
+		cmp_int(l->idx, r->idx);
 }
 
-static int btree_write_buffered_journal_cmp(const void *_l, const void *_r)
+static noinline int wb_flush_one_slowpath(struct btree_trans *trans,
+					  struct btree_iter *iter,
+					  struct btree_write_buffered_key *wb)
 {
-	const struct btree_write_buffered_key *l = _l;
-	const struct btree_write_buffered_key *r = _r;
+	bch2_btree_node_unlock_write(trans, iter->path, iter->path->l[0].b);
+
+	trans->journal_res.seq = wb->journal_seq;
 
-	return  cmp_int(l->journal_seq, r->journal_seq);
+	return bch2_trans_update(trans, iter, &wb->k,
+				 BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
+		bch2_trans_commit(trans, NULL, NULL,
+				  BTREE_INSERT_NOCHECK_RW|
+				  BTREE_INSERT_NOFAIL|
+				  BTREE_INSERT_JOURNAL_REPLAY|
+				  BTREE_INSERT_JOURNAL_RECLAIM);
 }
 
-static int bch2_btree_write_buffer_flush_one(struct btree_trans *trans,
-					     struct btree_iter *iter,
-					     struct btree_write_buffered_key *wb,
-					     unsigned commit_flags,
-					     bool *write_locked,
-					     size_t *fast)
+static inline int wb_flush_one(struct btree_trans *trans, struct btree_iter *iter,
+			       struct btree_write_buffered_key *wb,
+			       bool *write_locked, size_t *fast)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_path *path;
 	int ret;
 
+	EBUG_ON(!wb->journal_seq);
+	EBUG_ON(!c->btree_write_buffer.flushing.pin.seq);
+	EBUG_ON(c->btree_write_buffer.flushing.pin.seq > wb->journal_seq);
+
 	ret = bch2_btree_iter_traverse(iter);
 	if (ret)
 		return ret;
@@ -66,46 +78,14 @@ static int bch2_btree_write_buffer_flush_one(struct btree_trans *trans,
 		*write_locked = true;
 	}
 
-	if (!bch2_btree_node_insert_fits(c, path->l[0].b, wb->k.k.u64s)) {
-		bch2_btree_node_unlock_write(trans, path, path->l[0].b);
+	if (unlikely(!bch2_btree_node_insert_fits(c, path->l[0].b, wb->k.k.u64s))) {
 		*write_locked = false;
-		goto trans_commit;
+		return wb_flush_one_slowpath(trans, iter, wb);
 	}
 
 	bch2_btree_insert_key_leaf(trans, path, &wb->k, wb->journal_seq);
 	(*fast)++;
 	return 0;
-trans_commit:
-	trans->journal_res.seq = wb->journal_seq;
-
-	return  bch2_trans_update(trans, iter, &wb->k,
-				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
-		bch2_trans_commit(trans, NULL, NULL,
-				  commit_flags|
-				  BTREE_INSERT_NOCHECK_RW|
-				  BTREE_INSERT_NOFAIL|
-				  BTREE_INSERT_JOURNAL_REPLAY|
-				  BTREE_INSERT_JOURNAL_RECLAIM);
-}
-
-static union btree_write_buffer_state btree_write_buffer_switch(struct btree_write_buffer *wb)
-{
-	union btree_write_buffer_state old, new;
-	u64 v = READ_ONCE(wb->state.v);
-
-	do {
-		old.v = new.v = v;
-
-		new.nr = 0;
-		new.idx++;
-	} while ((v = atomic64_cmpxchg_acquire(&wb->state.counter, old.v, new.v)) != old.v);
-
-	while (old.idx == 0 ? wb->state.ref0 : wb->state.ref1)
-		cpu_relax();
-
-	smp_mb();
-
-	return old;
 }
 
 /*
@@ -137,31 +117,76 @@ btree_write_buffered_insert(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
+static void move_keys_from_inc_to_flushing(struct btree_write_buffer *wb)
+{
+	struct bch_fs *c = container_of(wb, struct bch_fs, btree_write_buffer);
+	struct journal *j = &c->journal;
+
+	if (!wb->inc.keys.nr)
+		return;
+
+	bch2_journal_pin_add(j, wb->inc.keys.data[0].journal_seq, &wb->flushing.pin,
+			     bch2_btree_write_buffer_journal_flush);
+
+	darray_resize(&wb->flushing.keys, min_t(size_t, 1U << 20, wb->flushing.keys.nr + wb->inc.keys.nr));
+	darray_resize(&wb->sorted, wb->flushing.keys.size);
+
+	if (!wb->flushing.keys.nr && wb->sorted.size >= wb->inc.keys.nr) {
+		swap(wb->flushing.keys, wb->inc.keys);
+		goto out;
+	}
+
+	size_t nr = min(darray_room(wb->flushing.keys),
+			wb->sorted.size - wb->flushing.keys.nr);
+	nr = min(nr, wb->inc.keys.nr);
+
+	memcpy(&darray_top(wb->flushing.keys),
+	       wb->inc.keys.data,
+	       sizeof(wb->inc.keys.data[0]) * nr);
+
+	memmove(wb->inc.keys.data,
+		wb->inc.keys.data + nr,
+	       sizeof(wb->inc.keys.data[0]) * (wb->inc.keys.nr - nr));
+
+	wb->flushing.keys.nr	+= nr;
+	wb->inc.keys.nr		-= nr;
+out:
+	if (!wb->inc.keys.nr)
+		bch2_journal_pin_drop(j, &wb->inc.pin);
+
+	if (j->watermark) {
+		spin_lock(&j->lock);
+		bch2_journal_set_watermark(j);
+		spin_unlock(&j->lock);
+	}
+
+	BUG_ON(wb->sorted.size < wb->flushing.keys.nr);
+}
+
+static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
 	struct journal *j = &c->journal;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
-	struct journal_entry_pin pin;
-	struct btree_write_buffered_key *i, *keys;
+	struct btree_write_buffered_key_ref *i;
 	struct btree_iter iter = { NULL };
-	size_t nr = 0, skipped = 0, fast = 0, slowpath = 0;
+	size_t skipped = 0, fast = 0, slowpath = 0;
 	bool write_locked = false;
-	union btree_write_buffer_state s;
 	int ret = 0;
 
-	memset(&pin, 0, sizeof(pin));
-
-	bch2_journal_pin_copy(j, &pin, &wb->journal_pin,
-			      bch2_btree_write_buffer_journal_flush);
-	bch2_journal_pin_drop(j, &wb->journal_pin);
+	bch2_trans_unlock(trans);
+	bch2_trans_begin(trans);
 
-	s = btree_write_buffer_switch(wb);
-	keys = wb->keys[s.idx];
-	nr = s.nr;
+	mutex_lock(&wb->inc.lock);
+	move_keys_from_inc_to_flushing(wb);
+	mutex_unlock(&wb->inc.lock);
 
-	if (race_fault())
-		goto slowpath;
+	for (size_t i = 0; i < wb->flushing.keys.nr; i++) {
+		wb->sorted.data[i].idx = i;
+		wb->sorted.data[i].btree = wb->flushing.keys.data[i].btree;
+		wb->sorted.data[i].pos = wb->flushing.keys.data[i].k.k.p;
+	}
+	wb->sorted.nr = wb->flushing.keys.nr;
 
 	/*
 	 * We first sort so that we can detect and skip redundant updates, and
@@ -177,110 +202,154 @@ int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	 * If that happens, simply skip the key so we can optimistically insert
 	 * as many keys as possible in the fast path.
 	 */
-	sort(keys, nr, sizeof(keys[0]),
-	     btree_write_buffered_key_cmp, NULL);
+	sort(wb->sorted.data, wb->sorted.nr,
+	     sizeof(wb->sorted.data[0]),
+	     wb_key_cmp, NULL);
+
+	darray_for_each(wb->sorted, i) {
+		struct btree_write_buffered_key *k = &wb->flushing.keys.data[i->idx];
 
-	for (i = keys; i < keys + nr; i++) {
-		if (i + 1 < keys + nr &&
+		BUG_ON(!k->journal_seq);
+
+		if (i + 1 < &darray_top(wb->sorted) &&
 		    i[0].btree == i[1].btree &&
-		    bpos_eq(i[0].k.k.p, i[1].k.k.p)) {
+		    bpos_eq(i[0].pos, i[1].pos)) {
+			struct btree_write_buffered_key *n = &wb->flushing.keys.data[i[1].idx];
+
 			skipped++;
-			i->journal_seq = 0;
+			n->journal_seq = min(n->journal_seq, k->journal_seq);;
+			k->journal_seq = 0;
 			continue;
 		}
 
 		if (write_locked &&
-		    (iter.path->btree_id != i->btree ||
-		     bpos_gt(i->k.k.p, iter.path->l[0].b->key.k.p))) {
+		    (iter.path->btree_id != k->btree ||
+		     bpos_gt(k->k.k.p, iter.path->l[0].b->key.k.p))) {
 			bch2_btree_node_unlock_write(trans, iter.path, iter.path->l[0].b);
 			write_locked = false;
 		}
 
-		if (!iter.path || iter.path->btree_id != i->btree) {
+		if (!iter.path || iter.path->btree_id != k->btree) {
 			bch2_trans_iter_exit(trans, &iter);
-			bch2_trans_iter_init(trans, &iter, i->btree, i->k.k.p,
+			bch2_trans_iter_init(trans, &iter, k->btree, k->k.k.p,
 					     BTREE_ITER_INTENT|BTREE_ITER_ALL_SNAPSHOTS);
 		}
 
-		bch2_btree_iter_set_pos(&iter, i->k.k.p);
+		bch2_btree_iter_set_pos(&iter, k->k.k.p);
 		iter.path->preserve = false;
 
 		do {
-			ret = bch2_btree_write_buffer_flush_one(trans, &iter, i, 0,
-								&write_locked, &fast);
+			if (race_fault()) {
+				ret = -BCH_ERR_journal_reclaim_would_deadlock;
+				break;
+			}
+
+			ret = wb_flush_one(trans, &iter, k, &write_locked, &fast);
 			if (!write_locked)
 				bch2_trans_begin(trans);
 		} while (bch2_err_matches(ret, BCH_ERR_transaction_restart));
 
-		if (ret == -BCH_ERR_journal_reclaim_would_deadlock) {
+		if (!ret) {
+			k->journal_seq = 0;
+		} else if (ret == -BCH_ERR_journal_reclaim_would_deadlock) {
 			slowpath++;
-			continue;
-		}
-		if (ret)
+			ret = 0;
+		} else
 			break;
-
-		i->journal_seq = 0;
 	}
 
 	if (write_locked)
 		bch2_btree_node_unlock_write(trans, iter.path, iter.path->l[0].b);
 	bch2_trans_iter_exit(trans, &iter);
 
-	trace_write_buffer_flush(trans, nr, skipped, fast, wb->size);
-
-	if (slowpath)
-		goto slowpath;
-
+	if (ret)
+		goto err;
+
+	if (slowpath) {
+		/*
+		 * Flush in the order they were present in the journal, so that
+		 * we can release journal pins:
+		 * The fastpath zapped the seq of keys that were successfully flushed so
+		 * we can skip those here.
+		 */
+		trace_write_buffer_flush_slowpath(trans, slowpath, wb->flushing.keys.nr);
+
+		struct btree_write_buffered_key *i;
+		darray_for_each(wb->flushing.keys, i) {
+			if (!i->journal_seq)
+				continue;
+
+			bch2_journal_pin_update(j, i->journal_seq, &wb->flushing.pin,
+						bch2_btree_write_buffer_journal_flush);
+
+			bch2_trans_begin(trans);
+
+			ret = commit_do(trans, NULL, NULL,
+					BCH_WATERMARK_reclaim|
+					BTREE_INSERT_NOCHECK_RW|
+					BTREE_INSERT_NOFAIL|
+					BTREE_INSERT_JOURNAL_REPLAY|
+					BTREE_INSERT_JOURNAL_RECLAIM,
+					btree_write_buffered_insert(trans, i));
+			if (ret)
+				goto err;
+		}
+	}
+err:
 	bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret));
-out:
-	bch2_journal_pin_drop(j, &pin);
+	trace_write_buffer_flush(trans, wb->flushing.keys.nr, skipped, fast, 0);
+	bch2_journal_pin_drop(j, &wb->flushing.pin);
+	wb->flushing.keys.nr = 0;
 	return ret;
-slowpath:
-	trace_write_buffer_flush_slowpath(trans, slowpath, nr);
-
-	/*
-	 * Now sort the rest by journal seq and bump the journal pin as we go.
-	 * The slowpath zapped the seq of keys that were successfully flushed so
-	 * we can skip those here.
-	 */
-	sort(keys, nr, sizeof(keys[0]),
-	     btree_write_buffered_journal_cmp,
-	     NULL);
+}
 
-	for (i = keys; i < keys + nr; i++) {
-		if (!i->journal_seq)
-			continue;
+static int fetch_wb_keys_from_journal(struct bch_fs *c, u64 seq)
+{
+	struct journal *j = &c->journal;
+	struct journal_buf *buf;
+	int ret = 0;
 
-		bch2_journal_pin_update(j, i->journal_seq, &pin,
-			      bch2_btree_write_buffer_journal_flush);
-
-		ret = commit_do(trans, NULL, NULL,
-				BCH_WATERMARK_reclaim|
-				BTREE_INSERT_NOCHECK_RW|
-				BTREE_INSERT_NOFAIL|
-				BTREE_INSERT_JOURNAL_REPLAY|
-				BTREE_INSERT_JOURNAL_RECLAIM,
-				btree_write_buffered_insert(trans, i));
-		if (bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret)))
+	mutex_lock(&j->buf_lock);
+	while ((buf = bch2_next_write_buffer_flush_journal_buf(j, seq)))
+		if (bch2_journal_keys_to_write_buffer(c, buf)) {
+			ret = -ENOMEM;
 			break;
-	}
+		}
+	mutex_unlock(&j->buf_lock);
 
-	goto out;
+	return ret;
 }
 
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *trans)
 {
 	struct bch_fs *c = trans->c;
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+	int ret = 0, fetch_from_journal_err;
 
 	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
 		return -BCH_ERR_erofs_no_writes;
 
 	trace_write_buffer_flush_sync(trans, _RET_IP_);
-
+retry:
 	bch2_trans_unlock(trans);
-	mutex_lock(&c->btree_write_buffer.flush_lock);
-	int ret = bch2_btree_write_buffer_flush_locked(trans);
-	mutex_unlock(&c->btree_write_buffer.flush_lock);
+
+	bch2_journal_block_reservations(&c->journal);
+	fetch_from_journal_err = fetch_wb_keys_from_journal(c, U64_MAX);
+	bch2_journal_unblock(&c->journal);
+
+	/*
+	 * On memory allocation failure, bch2_btree_write_buffer_flush_locked()
+	 * is not guaranteed to empty wb->inc:
+	 */
+	mutex_lock(&wb->flushing.lock);
+	while (!ret &&
+	       (wb->flushing.keys.nr || wb->inc.keys.nr))
+		ret = bch2_btree_write_buffer_flush_locked(trans);
+	mutex_unlock(&wb->flushing.lock);
+
+	if (!ret && fetch_from_journal_err)
+		goto retry;
+
 	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
 	return ret;
 }
@@ -294,74 +363,170 @@ int bch2_btree_write_buffer_tryflush(struct btree_trans *trans)
 	if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer))
 		return -BCH_ERR_erofs_no_writes;
 
-	if (mutex_trylock(&wb->flush_lock)) {
+	if (mutex_trylock(&wb->flushing.lock)) {
 		ret = bch2_btree_write_buffer_flush_locked(trans);
-		mutex_unlock(&wb->flush_lock);
+		mutex_unlock(&wb->flushing.lock);
 	}
 	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
 	return ret;
 }
 
+static int bch2_btree_write_buffer_flush_all(struct bch_fs *c)
+{
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+	struct btree_trans *trans = bch2_trans_get(c);
+	int ret;;
+
+	mutex_lock(&wb->flushing.lock);
+	do {
+		ret = bch2_btree_write_buffer_flush_locked(trans);
+	} while (!ret && wb->inc.keys.nr);
+	mutex_unlock(&wb->flushing.lock);
+
+	bch2_trans_put(trans);
+	return ret;
+}
+
 static int bch2_btree_write_buffer_journal_flush(struct journal *j,
 				struct journal_entry_pin *_pin, u64 seq)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct btree_write_buffer *wb = &c->btree_write_buffer;
+	int ret, fetch_from_journal_err;
 
-	mutex_lock(&wb->flush_lock);
-	int ret = bch2_trans_run(c, bch2_btree_write_buffer_flush_locked(trans));
-	mutex_unlock(&wb->flush_lock);
+	do {
+		fetch_from_journal_err = fetch_wb_keys_from_journal(c, seq);
+		ret = bch2_btree_write_buffer_flush_all(c);
+	} while (!ret && fetch_from_journal_err);
 
 	return ret;
 }
 
-static inline u64 btree_write_buffer_ref(int idx)
+static void bch2_btree_write_buffer_flush_work(struct work_struct *work)
 {
-	return ((union btree_write_buffer_state) {
-		.ref0 = idx == 0,
-		.ref1 = idx == 1,
-	}).v;
+	struct bch_fs *c = container_of(work, struct bch_fs, btree_write_buffer.flush_work);
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+	struct btree_trans *trans = bch2_trans_get(c);
+	int ret;;
+
+	mutex_lock(&wb->flushing.lock);
+	do {
+		ret = bch2_btree_write_buffer_flush_locked(trans);
+	} while (!ret && bch2_btree_write_buffer_should_flush(c));
+	mutex_unlock(&wb->flushing.lock);
+
+	bch2_trans_put(trans);
+	bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
 }
 
-int bch2_btree_insert_keys_write_buffer(struct btree_trans *trans)
+int __bch2_journal_key_to_wb(struct bch_fs *c,
+			     struct journal_keys_to_wb *dst,
+			     u64 seq, enum btree_id btree, struct bkey_i *k)
 {
-	struct bch_fs *c = trans->c;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
-	struct btree_write_buffered_key *i;
-	union btree_write_buffer_state old, new;
-	int ret = 0;
-	u64 v;
-
-	trans_for_each_wb_update(trans, i) {
-		EBUG_ON(i->k.k.u64s > BTREE_WRITE_BUFERED_U64s_MAX);
+	int ret;
+retry:
+	ret = darray_make_room_gfp(&dst->wb->keys, 1, GFP_KERNEL);
+	if (!ret && dst->wb == &wb->flushing)
+		ret = darray_resize(&wb->sorted, wb->flushing.keys.size);
+
+	if (unlikely(ret)) {
+		if (dst->wb == &c->btree_write_buffer.flushing) {
+			mutex_unlock(&dst->wb->lock);
+			dst->wb = &c->btree_write_buffer.inc;
+			bch2_journal_pin_add(&c->journal, seq, &dst->wb->pin,
+					     bch2_btree_write_buffer_journal_flush);
+			goto retry;
+		}
 
-		i->journal_seq		= trans->journal_res.seq;
-		i->journal_offset	= trans->journal_res.offset;
+		return ret;
 	}
 
-	preempt_disable();
-	v = READ_ONCE(wb->state.v);
-	do {
-		old.v = new.v = v;
+	dst->room = darray_room(dst->wb->keys);
+	if (dst->wb == &wb->flushing)
+		dst->room = min(dst->room, wb->sorted.size - wb->flushing.keys.nr);
+	BUG_ON(!dst->room);
+
+	struct btree_write_buffered_key *wb_k = &darray_top(dst->wb->keys);
+	wb_k->journal_seq	= seq;
+	wb_k->btree		= btree;
+	bkey_copy(&wb_k->k, k);
+	dst->wb->keys.nr++;
+	dst->room--;
+	return 0;
+}
 
-		new.v += btree_write_buffer_ref(new.idx);
-		new.nr += trans->nr_wb_updates;
-		if (new.nr > wb->size) {
-			ret = -BCH_ERR_btree_insert_need_flush_buffer;
-			goto out;
+void bch2_journal_keys_to_write_buffer_start(struct bch_fs *c, struct journal_keys_to_wb *dst, u64 seq)
+{
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+
+	if (mutex_trylock(&wb->flushing.lock)) {
+		mutex_lock(&wb->inc.lock);
+		move_keys_from_inc_to_flushing(wb);
+
+		/*
+		 * Attempt to skip wb->inc, and add keys directly to
+		 * wb->flushing, saving us a copy later:
+		 */
+
+		if (!wb->inc.keys.nr) {
+			dst->wb = &wb->flushing;
+		} else {
+			mutex_unlock(&wb->flushing.lock);
+			dst->wb = &wb->inc;
 		}
-	} while ((v = atomic64_cmpxchg_acquire(&wb->state.counter, old.v, new.v)) != old.v);
+	} else {
+		mutex_lock(&wb->inc.lock);
+		dst->wb = &wb->inc;
+	}
 
-	memcpy(wb->keys[new.idx] + old.nr,
-	       trans->wb_updates,
-	       sizeof(trans->wb_updates[0]) * trans->nr_wb_updates);
+	dst->room = darray_room(dst->wb->keys);
+	if (dst->wb == &wb->flushing)
+		dst->room = min(dst->room, wb->sorted.size - wb->flushing.keys.nr);
 
-	bch2_journal_pin_add(&c->journal, trans->journal_res.seq, &wb->journal_pin,
+	bch2_journal_pin_add(&c->journal, seq, &dst->wb->pin,
 			     bch2_btree_write_buffer_journal_flush);
+}
+
+void bch2_journal_keys_to_write_buffer_end(struct bch_fs *c, struct journal_keys_to_wb *dst)
+{
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+
+	if (!dst->wb->keys.nr)
+		bch2_journal_pin_drop(&c->journal, &dst->wb->pin);
+
+	if (bch2_btree_write_buffer_should_flush(c) &&
+	    __bch2_write_ref_tryget(c, BCH_WRITE_REF_btree_write_buffer) &&
+	    !queue_work(system_unbound_wq, &c->btree_write_buffer.flush_work))
+		bch2_write_ref_put(c, BCH_WRITE_REF_btree_write_buffer);
+
+	if (dst->wb == &wb->flushing)
+		mutex_unlock(&wb->flushing.lock);
+	mutex_unlock(&wb->inc.lock);
+}
+
+static int bch2_journal_keys_to_write_buffer(struct bch_fs *c, struct journal_buf *buf)
+{
+	struct journal_keys_to_wb dst;
+	struct jset_entry *entry;
+	struct bkey_i *k;
+	u64 seq = le64_to_cpu(buf->data->seq);
+	int ret = 0;
+
+	bch2_journal_keys_to_write_buffer_start(c, &dst, seq);
+
+	for_each_jset_entry_type(entry, buf->data, BCH_JSET_ENTRY_write_buffer_keys) {
+		jset_entry_for_each_key(entry, k) {
+			ret = bch2_journal_key_to_wb(c, &dst, seq, entry->btree_id, k);
+			if (ret)
+				goto out;
+		}
 
-	atomic64_sub_return_release(btree_write_buffer_ref(new.idx), &wb->state.counter);
+		entry->type = BCH_JSET_ENTRY_btree_keys;
+	}
+
+	buf->need_flush_to_write_buffer = false;
 out:
-	preempt_enable();
+	bch2_journal_keys_to_write_buffer_end(c, &dst);
 	return ret;
 }
 
@@ -369,23 +534,23 @@ void bch2_fs_btree_write_buffer_exit(struct bch_fs *c)
 {
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
 
-	BUG_ON(wb->state.nr && !bch2_journal_error(&c->journal));
+	BUG_ON((wb->inc.keys.nr || wb->flushing.keys.nr) &&
+	       !bch2_journal_error(&c->journal));
 
-	kvfree(wb->keys[1]);
-	kvfree(wb->keys[0]);
+	darray_exit(&wb->sorted);
+	darray_exit(&wb->flushing.keys);
+	darray_exit(&wb->inc.keys);
 }
 
 int bch2_fs_btree_write_buffer_init(struct bch_fs *c)
 {
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
 
-	mutex_init(&wb->flush_lock);
-	wb->size = c->opts.btree_write_buffer_size;
+	mutex_init(&wb->inc.lock);
+	mutex_init(&wb->flushing.lock);
+	INIT_WORK(&wb->flush_work, bch2_btree_write_buffer_flush_work);
 
-	wb->keys[0] = kvmalloc_array(wb->size, sizeof(*wb->keys[0]), GFP_KERNEL);
-	wb->keys[1] = kvmalloc_array(wb->size, sizeof(*wb->keys[1]), GFP_KERNEL);
-	if (!wb->keys[0] || !wb->keys[1])
-		return -BCH_ERR_ENOMEM_fs_btree_write_buffer_init;
-
-	return 0;
+	return  darray_make_room(&wb->inc.keys, c->opts.btree_write_buffer_size) ?:
+		darray_make_room(&wb->flushing.keys, c->opts.btree_write_buffer_size) ?:
+		darray_make_room(&wb->sorted, c->opts.btree_write_buffer_size);
 }
diff --git a/fs/bcachefs/btree_write_buffer.h b/fs/bcachefs/btree_write_buffer.h
index 89d290e306e2..a28a37d75746 100644
--- a/fs/bcachefs/btree_write_buffer.h
+++ b/fs/bcachefs/btree_write_buffer.h
@@ -2,11 +2,53 @@
 #ifndef _BCACHEFS_BTREE_WRITE_BUFFER_H
 #define _BCACHEFS_BTREE_WRITE_BUFFER_H
 
-int bch2_btree_write_buffer_flush_locked(struct btree_trans *);
+#include "bkey.h"
+
+static inline bool bch2_btree_write_buffer_should_flush(struct bch_fs *c)
+{
+	struct btree_write_buffer *wb = &c->btree_write_buffer;
+
+	return wb->inc.keys.nr + wb->flushing.keys.nr > c->opts.btree_write_buffer_size / 2;
+}
+
+static inline bool bch2_btree_write_buffer_must_wait(struct bch_fs *c)
+{
+	return c->btree_write_buffer.inc.keys.nr > c->opts.btree_write_buffer_size * 3 / 4;
+}
+
+struct btree_trans;
 int bch2_btree_write_buffer_flush_sync(struct btree_trans *);
 int bch2_btree_write_buffer_tryflush(struct btree_trans *);
 
-int bch2_btree_insert_keys_write_buffer(struct btree_trans *);
+struct journal_keys_to_wb {
+	struct btree_write_buffer_keys *wb;
+	size_t room;
+};
+
+int __bch2_journal_key_to_wb(struct bch_fs *,
+			     struct journal_keys_to_wb *,
+			     u64, enum btree_id, struct bkey_i *);
+
+static inline int bch2_journal_key_to_wb(struct bch_fs *c,
+			     struct journal_keys_to_wb *dst,
+			     u64 seq, enum btree_id btree, struct bkey_i *k)
+{
+	BUG_ON(!seq);
+
+	if (unlikely(!dst->room))
+		return __bch2_journal_key_to_wb(c, dst, seq, btree, k);
+
+	struct btree_write_buffered_key *wb_k = &darray_top(dst->wb->keys);
+	wb_k->journal_seq	= seq;
+	wb_k->btree		= btree;
+	bkey_copy(&wb_k->k, k);
+	dst->wb->keys.nr++;
+	dst->room--;
+	return 0;
+}
+
+void bch2_journal_keys_to_write_buffer_start(struct bch_fs *, struct journal_keys_to_wb *, u64);
+void bch2_journal_keys_to_write_buffer_end(struct bch_fs *, struct journal_keys_to_wb *);
 
 void bch2_fs_btree_write_buffer_exit(struct bch_fs *);
 int bch2_fs_btree_write_buffer_init(struct bch_fs *);
diff --git a/fs/bcachefs/btree_write_buffer_types.h b/fs/bcachefs/btree_write_buffer_types.h
index 99993ba77aea..416790aca114 100644
--- a/fs/bcachefs/btree_write_buffer_types.h
+++ b/fs/bcachefs/btree_write_buffer_types.h
@@ -2,43 +2,36 @@
 #ifndef _BCACHEFS_BTREE_WRITE_BUFFER_TYPES_H
 #define _BCACHEFS_BTREE_WRITE_BUFFER_TYPES_H
 
+#include "darray.h"
 #include "journal_types.h"
 
 #define BTREE_WRITE_BUFERED_VAL_U64s_MAX	4
 #define BTREE_WRITE_BUFERED_U64s_MAX	(BKEY_U64s + BTREE_WRITE_BUFERED_VAL_U64s_MAX)
 
+struct btree_write_buffered_key_ref {
+	unsigned		idx:20;
+	enum btree_id		btree:12;
+	struct bpos		pos;
+};
+
 struct btree_write_buffered_key {
 	u64			journal_seq;
-	unsigned		journal_offset;
 	enum btree_id		btree;
 	__BKEY_PADDED(k, BTREE_WRITE_BUFERED_VAL_U64s_MAX);
 };
 
-union btree_write_buffer_state {
-	struct {
-		atomic64_t	counter;
-	};
-
-	struct {
-		u64		v;
-	};
-
-	struct {
-		u64			nr:23;
-		u64			idx:1;
-		u64			ref0:20;
-		u64			ref1:20;
-	};
+struct btree_write_buffer_keys {
+	DARRAY(struct btree_write_buffered_key) keys;
+	struct journal_entry_pin	pin;
+	struct mutex			lock;
 };
 
 struct btree_write_buffer {
-	struct mutex			flush_lock;
-	struct journal_entry_pin	journal_pin;
-
-	union btree_write_buffer_state	state;
-	size_t				size;
+	DARRAY(struct btree_write_buffered_key_ref) sorted;
 
-	struct btree_write_buffered_key	*keys[2];
+	struct btree_write_buffer_keys	inc;
+	struct btree_write_buffer_keys	flushing;
+	struct work_struct		flush_work;
 };
 
 #endif /* _BCACHEFS_BTREE_WRITE_BUFFER_TYPES_H */
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index e5c3262cc303..e42b45293bbd 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -150,7 +150,6 @@
 	x(BCH_ERR_btree_insert_fail,	btree_insert_need_mark_replicas)	\
 	x(BCH_ERR_btree_insert_fail,	btree_insert_need_journal_res)		\
 	x(BCH_ERR_btree_insert_fail,	btree_insert_need_journal_reclaim)	\
-	x(BCH_ERR_btree_insert_fail,	btree_insert_need_flush_buffer)		\
 	x(0,				backpointer_to_overwritten_btree_node)	\
 	x(0,				lock_fail_root_changed)			\
 	x(0,				journal_reclaim_would_deadlock)		\
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 5b390cb91884..8d53faa9a429 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -10,6 +10,7 @@
 #include "bkey_methods.h"
 #include "btree_gc.h"
 #include "btree_update.h"
+#include "btree_write_buffer.h"
 #include "buckets.h"
 #include "error.h"
 #include "journal.h"
@@ -329,6 +330,7 @@ static int journal_entry_open(struct journal *j)
 	buf->must_flush	= false;
 	buf->separate_flush = false;
 	buf->flush_time	= 0;
+	buf->need_flush_to_write_buffer = true;
 
 	memset(buf->data, 0, sizeof(*buf->data));
 	buf->data->seq	= cpu_to_le64(journal_cur_seq(j));
@@ -793,6 +795,47 @@ void bch2_journal_block_reservations(struct journal *j)
 	wait_event(j->wait, journal_reservations_stopped(j));
 }
 
+static struct journal_buf *__bch2_next_write_buffer_flush_journal_buf(struct journal *j, u64 max_seq)
+{
+	spin_lock(&j->lock);
+	max_seq = min(max_seq, journal_cur_seq(j));
+
+	for (u64 seq = journal_last_unwritten_seq(j);
+	     seq <= max_seq;
+	     seq++) {
+		unsigned idx = seq & JOURNAL_BUF_MASK;
+		struct journal_buf *buf = j->buf + idx;
+		union journal_res_state s;
+
+		if (!buf->need_flush_to_write_buffer)
+			continue;
+
+		if (seq == journal_cur_seq(j))
+			__journal_entry_close(j, JOURNAL_ENTRY_CLOSED_VAL);
+
+		s.v = atomic64_read_acquire(&j->reservations.counter);
+
+		if (journal_state_count(s, idx)) {
+			spin_unlock(&j->lock);
+			return ERR_PTR(-EAGAIN);
+		}
+
+		spin_unlock(&j->lock);
+		return buf;
+	}
+
+	spin_unlock(&j->lock);
+	return NULL;
+}
+
+struct journal_buf *bch2_next_write_buffer_flush_journal_buf(struct journal *j, u64 max_seq)
+{
+	struct journal_buf *ret;
+
+	wait_event(j->wait, (ret = __bch2_next_write_buffer_flush_journal_buf(j, max_seq)) != ERR_PTR(-EAGAIN));
+	return ret;
+}
+
 /* allocate journal on a device: */
 
 static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 310654bb74de..b5185f97af0f 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -428,6 +428,7 @@ static inline void bch2_journal_set_replay_done(struct journal *j)
 void bch2_journal_unblock(struct journal *);
 void bch2_journal_block(struct journal *);
 void bch2_journal_block_reservations(struct journal *);
+struct journal_buf *bch2_next_write_buffer_flush_journal_buf(struct journal *j, u64 max_seq);
 
 void __bch2_journal_debug_to_text(struct printbuf *, struct journal *);
 void bch2_journal_debug_to_text(struct printbuf *, struct journal *);
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 2394d4b02fff..89852fd16d68 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -4,6 +4,7 @@
 #include "alloc_foreground.h"
 #include "btree_io.h"
 #include "btree_update_interior.h"
+#include "btree_write_buffer.h"
 #include "buckets.h"
 #include "checksum.h"
 #include "disk_groups.h"
@@ -713,6 +714,22 @@ static void journal_entry_overwrite_to_text(struct printbuf *out, struct bch_fs
 	journal_entry_btree_keys_to_text(out, c, entry);
 }
 
+static int journal_entry_write_buffer_keys_validate(struct bch_fs *c,
+				struct jset *jset,
+				struct jset_entry *entry,
+				unsigned version, int big_endian,
+				enum bkey_invalid_flags flags)
+{
+	return journal_entry_btree_keys_validate(c, jset, entry,
+				version, big_endian, READ);
+}
+
+static void journal_entry_write_buffer_keys_to_text(struct printbuf *out, struct bch_fs *c,
+					    struct jset_entry *entry)
+{
+	journal_entry_btree_keys_to_text(out, c, entry);
+}
+
 struct jset_entry_ops {
 	int (*validate)(struct bch_fs *, struct jset *,
 			struct jset_entry *, unsigned, int,
@@ -1687,9 +1704,11 @@ static int bch2_journal_write_prep(struct journal *j, struct journal_buf *w)
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct jset_entry *start, *end, *i, *next, *prev = NULL;
 	struct jset *jset = w->data;
+	struct journal_keys_to_wb wb = { NULL };
 	unsigned sectors, bytes, u64s;
-	bool validate_before_checksum = false;
 	unsigned long btree_roots_have = 0;
+	bool validate_before_checksum = false;
+	u64 seq = le64_to_cpu(jset->seq);
 	int ret;
 
 	/*
@@ -1717,9 +1736,28 @@ static int bch2_journal_write_prep(struct journal *j, struct journal_buf *w)
 		 * to c->btree_roots we have to get any missing btree roots and
 		 * add them to this journal entry:
 		 */
-		if (i->type == BCH_JSET_ENTRY_btree_root) {
+		switch (i->type) {
+		case BCH_JSET_ENTRY_btree_root:
 			bch2_journal_entry_to_btree_root(c, i);
 			__set_bit(i->btree_id, &btree_roots_have);
+			break;
+		case BCH_JSET_ENTRY_write_buffer_keys:
+			EBUG_ON(!w->need_flush_to_write_buffer);
+
+			if (!wb.wb)
+				bch2_journal_keys_to_write_buffer_start(c, &wb, seq);
+
+			struct bkey_i *k;
+			jset_entry_for_each_key(i, k) {
+				ret = bch2_journal_key_to_wb(c, &wb, seq, i->btree_id, k);
+				if (ret) {
+					bch2_fs_fatal_error(c, "-ENOMEM flushing journal keys to btree write buffer");
+					bch2_journal_keys_to_write_buffer_end(c, &wb);
+					return ret;
+				}
+			}
+			i->type = BCH_JSET_ENTRY_btree_keys;
+			break;
 		}
 
 		/* Can we merge with previous entry? */
@@ -1742,6 +1780,10 @@ static int bch2_journal_write_prep(struct journal *j, struct journal_buf *w)
 			memmove_u64s_down(prev, i, jset_u64s(u64s));
 	}
 
+	if (wb.wb)
+		bch2_journal_keys_to_write_buffer_end(c, &wb);
+	w->need_flush_to_write_buffer = false;
+
 	prev = prev ? vstruct_next(prev) : jset->start;
 	jset->u64s = cpu_to_le32((u64 *) prev - jset->_data);
 
@@ -1749,8 +1791,7 @@ static int bch2_journal_write_prep(struct journal *j, struct journal_buf *w)
 
 	end	= bch2_btree_roots_to_journal_entries(c, end, btree_roots_have);
 
-	bch2_journal_super_entries_add_common(c, &end,
-				le64_to_cpu(jset->seq));
+	bch2_journal_super_entries_add_common(c, &end, seq);
 	u64s	= (u64 *) end - (u64 *) start;
 	BUG_ON(u64s > j->entry_u64s_reserved);
 
@@ -1773,7 +1814,7 @@ static int bch2_journal_write_prep(struct journal *j, struct journal_buf *w)
 	SET_JSET_CSUM_TYPE(jset, bch2_meta_checksum_type(c));
 
 	if (!JSET_NO_FLUSH(jset) && journal_entry_empty(jset))
-		j->last_empty_seq = le64_to_cpu(jset->seq);
+		j->last_empty_seq = seq;
 
 	if (bch2_csum_type_is_encryption(JSET_CSUM_TYPE(jset)))
 		validate_before_checksum = true;
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 67684cc5c1e5..32d1255936ed 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -3,6 +3,7 @@
 #include "bcachefs.h"
 #include "btree_key_cache.h"
 #include "btree_update.h"
+#include "btree_write_buffer.h"
 #include "buckets.h"
 #include "errcode.h"
 #include "error.h"
@@ -50,20 +51,23 @@ unsigned bch2_journal_dev_buckets_available(struct journal *j,
 	return available;
 }
 
-static inline void journal_set_watermark(struct journal *j)
+void bch2_journal_set_watermark(struct journal *j)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	bool low_on_space = j->space[journal_space_clean].total * 4 <=
 		j->space[journal_space_total].total;
 	bool low_on_pin = fifo_free(&j->pin) < j->pin.size / 4;
-	unsigned watermark = low_on_space || low_on_pin
+	bool low_on_wb = bch2_btree_write_buffer_must_wait(c);
+	unsigned watermark = low_on_space || low_on_pin || low_on_wb
 		? BCH_WATERMARK_reclaim
 		: BCH_WATERMARK_stripe;
 
 	if (track_event_change(&c->times[BCH_TIME_blocked_journal_low_on_space],
 			       &j->low_on_space_start, low_on_space) ||
 	    track_event_change(&c->times[BCH_TIME_blocked_journal_low_on_pin],
-			       &j->low_on_pin_start, low_on_pin))
+			       &j->low_on_pin_start, low_on_pin) ||
+	    track_event_change(&c->times[BCH_TIME_blocked_write_buffer_full],
+			       &j->write_buffer_full_start, low_on_wb))
 		trace_and_count(c, journal_full, c);
 
 	swap(watermark, j->watermark);
@@ -230,7 +234,7 @@ void bch2_journal_space_available(struct journal *j)
 	else
 		clear_bit(JOURNAL_MAY_SKIP_FLUSH, &j->flags);
 
-	journal_set_watermark(j);
+	bch2_journal_set_watermark(j);
 out:
 	j->cur_entry_sectors	= !ret ? j->space[journal_space_discarded].next_entry : 0;
 	j->cur_entry_error	= ret;
diff --git a/fs/bcachefs/journal_reclaim.h b/fs/bcachefs/journal_reclaim.h
index 7b15d682a0f5..ec84c3345281 100644
--- a/fs/bcachefs/journal_reclaim.h
+++ b/fs/bcachefs/journal_reclaim.h
@@ -16,6 +16,7 @@ static inline void journal_reclaim_kick(struct journal *j)
 unsigned bch2_journal_dev_buckets_available(struct journal *,
 					    struct journal_device *,
 					    enum journal_space_from);
+void bch2_journal_set_watermark(struct journal *);
 void bch2_journal_space_available(struct journal *);
 
 static inline bool journal_pin_active(struct journal_entry_pin *pin)
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 0fed32f94976..85c543af60e5 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -36,6 +36,7 @@ struct journal_buf {
 	bool			noflush;	/* write has already been kicked off, and was noflush */
 	bool			must_flush;	/* something wants a flush */
 	bool			separate_flush;
+	bool			need_flush_to_write_buffer;
 };
 
 /*
@@ -277,6 +278,7 @@ struct journal {
 	u64			low_on_space_start;
 	u64			low_on_pin_start;
 	u64			max_in_flight_start;
+	u64			write_buffer_full_start;
 
 	struct bch2_time_stats	*flush_write_time;
 	struct bch2_time_stats	*noflush_write_time;
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index bb9451082e87..9af723466aab 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -314,7 +314,8 @@ void bch2_fs_read_only(struct bch_fs *c)
 		BUG_ON(c->journal.last_empty_seq != journal_cur_seq(&c->journal));
 		BUG_ON(atomic_read(&c->btree_cache.dirty));
 		BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
-		BUG_ON(c->btree_write_buffer.state.nr);
+		BUG_ON(c->btree_write_buffer.inc.keys.nr);
+		BUG_ON(c->btree_write_buffer.flushing.keys.nr);
 
 		bch_verbose(c, "marking filesystem clean");
 		bch2_fs_mark_clean(c);
-- 
2.42.0

