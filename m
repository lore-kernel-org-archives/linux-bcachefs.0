Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03E838DD4
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XotOJj9n"
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B48163EB02
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RRzlijvwVafwO1/gKPBU2ENOfeBYrdt7k4Uo/kyJMk4=;
	b=XotOJj9n4HuFw/Bijkam5Aw8UwvrJvtCqVIlGii6+SkZdCornBLX/pJPFhWD5RTni5iu4U
	MTzKHLNN65WYK/4RVH/USKU8MyQmcz2ldYbr+5UjO/DCBYlrDKEhziB5cNPJdv6qU0Y9xJ
	P+GHQtJW7pje0eTxFzFZ3bJJ1Tg4z5k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/17] bcachefs: Kill journal pre-reservations
Date: Fri, 10 Nov 2023 11:31:38 -0500
Message-ID: <20231110163157.2736111-2-kent.overstreet@linux.dev>
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

This deletes the complicated and somewhat expensive journal
pre-reservation machinery in favor of just using journal watermarks:
when the journal is more than half full, we run journal reclaim more
aggressively, and when the journal is more than 3/4s full we only allow
journal reclaim to get new journal reservations.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c            |  2 -
 fs/bcachefs/btree_key_cache.c       | 14 -----
 fs/bcachefs/btree_trans_commit.c    | 36 +----------
 fs/bcachefs/btree_types.h           |  3 -
 fs/bcachefs/btree_update_interior.c | 25 --------
 fs/bcachefs/btree_update_interior.h |  1 -
 fs/bcachefs/journal.c               | 31 ---------
 fs/bcachefs/journal.h               | 98 -----------------------------
 fs/bcachefs/journal_reclaim.c       | 42 +++++--------
 fs/bcachefs/journal_types.h         | 26 --------
 fs/bcachefs/trace.h                 | 11 +---
 11 files changed, 19 insertions(+), 270 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 50493b784316..96bdf0c6051c 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -3089,8 +3089,6 @@ void bch2_trans_put(struct btree_trans *trans)
 		srcu_read_unlock(&c->btree_trans_barrier, trans->srcu_idx);
 	}
 
-	bch2_journal_preres_put(&c->journal, &trans->journal_preres);
-
 	kfree(trans->extra_journal_entries.data);
 
 	if (trans->fs_usage_deltas) {
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 2239c03b242c..375a997a0bdd 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -673,7 +673,6 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 		goto out;
 
 	bch2_journal_pin_drop(j, &ck->journal);
-	bch2_journal_preres_put(j, &ck->res);
 
 	BUG_ON(!btree_node_locked(c_iter.path, 0));
 
@@ -771,18 +770,6 @@ bool bch2_btree_insert_key_cached(struct btree_trans *trans,
 
 	BUG_ON(insert->k.u64s > ck->u64s);
 
-	if (likely(!(flags & BTREE_INSERT_JOURNAL_REPLAY))) {
-		int difference;
-
-		BUG_ON(jset_u64s(insert->k.u64s) > trans->journal_preres.u64s);
-
-		difference = jset_u64s(insert->k.u64s) - ck->res.u64s;
-		if (difference > 0) {
-			trans->journal_preres.u64s	-= difference;
-			ck->res.u64s			+= difference;
-		}
-	}
-
 	bkey_copy(ck->k, insert);
 	ck->valid = true;
 
@@ -1009,7 +996,6 @@ void bch2_fs_btree_key_cache_exit(struct btree_key_cache *bc)
 		cond_resched();
 
 		bch2_journal_pin_drop(&c->journal, &ck->journal);
-		bch2_journal_preres_put(&c->journal, &ck->res);
 
 		list_del(&ck->list);
 		kfree(ck->k);
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 02d806ff07bf..d0ead308deef 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -323,17 +323,6 @@ static inline void btree_insert_entry_checks(struct btree_trans *trans,
 		bch2_snapshot_is_internal_node(trans->c, i->k->k.p.snapshot));
 }
 
-static noinline int
-bch2_trans_journal_preres_get_cold(struct btree_trans *trans, unsigned flags,
-				   unsigned long trace_ip)
-{
-	return drop_locks_do(trans,
-		bch2_journal_preres_get(&trans->c->journal,
-			&trans->journal_preres,
-			trans->journal_preres_u64s,
-			(flags & BCH_WATERMARK_MASK)));
-}
-
 static __always_inline int bch2_trans_journal_res_get(struct btree_trans *trans,
 						      unsigned flags)
 {
@@ -882,14 +871,6 @@ static inline int do_bch2_trans_commit(struct btree_trans *trans, unsigned flags
 		}
 	}
 
-	ret = bch2_journal_preres_get(&c->journal,
-			&trans->journal_preres, trans->journal_preres_u64s,
-			(flags & BCH_WATERMARK_MASK)|JOURNAL_RES_GET_NONBLOCK);
-	if (unlikely(ret == -BCH_ERR_journal_preres_get_blocked))
-		ret = bch2_trans_journal_preres_get_cold(trans, flags, trace_ip);
-	if (unlikely(ret))
-		return ret;
-
 	ret = bch2_trans_lock_write(trans);
 	if (unlikely(ret))
 		return ret;
@@ -1052,7 +1033,6 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 	struct bch_fs *c = trans->c;
 	struct btree_insert_entry *i = NULL;
 	struct btree_write_buffered_key *wb;
-	unsigned u64s;
 	int ret = 0;
 
 	if (!trans->nr_updates &&
@@ -1112,13 +1092,8 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 
 	EBUG_ON(test_bit(BCH_FS_CLEAN_SHUTDOWN, &c->flags));
 
-	memset(&trans->journal_preres, 0, sizeof(trans->journal_preres));
-
 	trans->journal_u64s		= trans->extra_journal_entries.nr;
-	trans->journal_preres_u64s	= 0;
-
 	trans->journal_transaction_names = READ_ONCE(c->opts.journal_transaction_names);
-
 	if (trans->journal_transaction_names)
 		trans->journal_u64s += jset_u64s(JSET_ENTRY_LOG_U64s);
 
@@ -1134,16 +1109,11 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 		if (i->key_cache_already_flushed)
 			continue;
 
-		/* we're going to journal the key being updated: */
-		u64s = jset_u64s(i->k->k.u64s);
-		if (i->cached &&
-		    likely(!(flags & BTREE_INSERT_JOURNAL_REPLAY)))
-			trans->journal_preres_u64s += u64s;
-
 		if (i->flags & BTREE_UPDATE_NOJOURNAL)
 			continue;
 
-		trans->journal_u64s += u64s;
+		/* we're going to journal the key being updated: */
+		trans->journal_u64s += jset_u64s(i->k->k.u64s);
 
 		/* and we're also going to log the overwrite: */
 		if (trans->journal_transaction_names)
@@ -1175,8 +1145,6 @@ int __bch2_trans_commit(struct btree_trans *trans, unsigned flags)
 
 	trace_and_count(c, transaction_commit, trans, _RET_IP_);
 out:
-	bch2_journal_preres_put(&c->journal, &trans->journal_preres);
-
 	if (likely(!(flags & BTREE_INSERT_NOCHECK_RW)))
 		bch2_write_ref_put(c, BCH_WRITE_REF_trans);
 out_reset:
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 35a1623a3c55..0c97b4ef78fb 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -337,7 +337,6 @@ struct bkey_cached {
 	struct rhash_head	hash;
 	struct list_head	list;
 
-	struct journal_preres	res;
 	struct journal_entry_pin journal;
 	u64			seq;
 
@@ -448,11 +447,9 @@ struct btree_trans {
 	struct journal_entry_pin *journal_pin;
 
 	struct journal_res	journal_res;
-	struct journal_preres	journal_preres;
 	u64			*journal_seq;
 	struct disk_reservation *disk_res;
 	unsigned		journal_u64s;
-	unsigned		journal_preres_u64s;
 	struct replicas_delta_list *fs_usage_deltas;
 };
 
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 39c2db68123b..925837eca369 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -513,8 +513,6 @@ static void bch2_btree_update_free(struct btree_update *as, struct btree_trans *
 		up_read(&c->gc_lock);
 	as->took_gc_lock = false;
 
-	bch2_journal_preres_put(&c->journal, &as->journal_preres);
-
 	bch2_journal_pin_drop(&c->journal, &as->journal);
 	bch2_journal_pin_flush(&c->journal, &as->journal);
 	bch2_disk_reservation_put(c, &as->disk_res);
@@ -734,8 +732,6 @@ static void btree_update_nodes_written(struct btree_update *as)
 
 	bch2_journal_pin_drop(&c->journal, &as->journal);
 
-	bch2_journal_preres_put(&c->journal, &as->journal_preres);
-
 	mutex_lock(&c->btree_interior_update_lock);
 	for (i = 0; i < as->nr_new_nodes; i++) {
 		b = as->new_nodes[i];
@@ -1129,27 +1125,6 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 	if (ret)
 		goto err;
 
-	ret = bch2_journal_preres_get(&c->journal, &as->journal_preres,
-				      BTREE_UPDATE_JOURNAL_RES,
-				      journal_flags|JOURNAL_RES_GET_NONBLOCK);
-	if (ret) {
-		if (flags & BTREE_INSERT_JOURNAL_RECLAIM) {
-			ret = -BCH_ERR_journal_reclaim_would_deadlock;
-			goto err;
-		}
-
-		ret = drop_locks_do(trans,
-			bch2_journal_preres_get(&c->journal, &as->journal_preres,
-					      BTREE_UPDATE_JOURNAL_RES,
-					      journal_flags));
-		if (ret == -BCH_ERR_journal_preres_get_blocked) {
-			trace_and_count(c, trans_restart_journal_preres_get, trans, _RET_IP_, journal_flags);
-			ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_journal_preres_get);
-		}
-		if (ret)
-			goto err;
-	}
-
 	ret = bch2_disk_reservation_get(c, &as->disk_res,
 			(nr_nodes[0] + nr_nodes[1]) * btree_sectors(c),
 			c->opts.metadata_replicas,
diff --git a/fs/bcachefs/btree_update_interior.h b/fs/bcachefs/btree_update_interior.h
index 4df21512d640..031076e75fa1 100644
--- a/fs/bcachefs/btree_update_interior.h
+++ b/fs/bcachefs/btree_update_interior.h
@@ -55,7 +55,6 @@ struct btree_update {
 	unsigned			update_level;
 
 	struct disk_reservation		disk_res;
-	struct journal_preres		journal_preres;
 
 	/*
 	 * BTREE_INTERIOR_UPDATING_NODE:
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index ced1983d675b..46eba1072940 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -526,36 +526,6 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 	return ret;
 }
 
-/* journal_preres: */
-
-static bool journal_preres_available(struct journal *j,
-				     struct journal_preres *res,
-				     unsigned new_u64s,
-				     unsigned flags)
-{
-	bool ret = bch2_journal_preres_get_fast(j, res, new_u64s, flags, true);
-
-	if (!ret && mutex_trylock(&j->reclaim_lock)) {
-		bch2_journal_reclaim(j);
-		mutex_unlock(&j->reclaim_lock);
-	}
-
-	return ret;
-}
-
-int __bch2_journal_preres_get(struct journal *j,
-			      struct journal_preres *res,
-			      unsigned new_u64s,
-			      unsigned flags)
-{
-	int ret;
-
-	closure_wait_event(&j->preres_wait,
-		   (ret = bch2_journal_error(j)) ||
-		   journal_preres_available(j, res, new_u64s, flags));
-	return ret;
-}
-
 /* journal_entry_res: */
 
 void bch2_journal_entry_res_resize(struct journal *j,
@@ -1307,7 +1277,6 @@ void __bch2_journal_debug_to_text(struct printbuf *out, struct journal *j)
 	prt_printf(out, "last_seq:\t\t%llu\n",			journal_last_seq(j));
 	prt_printf(out, "last_seq_ondisk:\t%llu\n",		j->last_seq_ondisk);
 	prt_printf(out, "flushed_seq_ondisk:\t%llu\n",		j->flushed_seq_ondisk);
-	prt_printf(out, "prereserved:\t\t%u/%u\n",		j->prereserved.reserved, j->prereserved.remaining);
 	prt_printf(out, "watermark:\t\t%s\n",			bch2_watermarks[j->watermark]);
 	prt_printf(out, "each entry reserved:\t%u\n",		j->entry_u64s_reserved);
 	prt_printf(out, "nr flush writes:\t%llu\n",		j->nr_flush_writes);
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 011711e99c8d..c85d01cf4948 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -395,104 +395,6 @@ static inline int bch2_journal_res_get(struct journal *j, struct journal_res *re
 	return 0;
 }
 
-/* journal_preres: */
-
-static inline void journal_set_watermark(struct journal *j)
-{
-	union journal_preres_state s = READ_ONCE(j->prereserved);
-	unsigned watermark = BCH_WATERMARK_stripe;
-
-	if (fifo_free(&j->pin) < j->pin.size / 4)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_copygc);
-	if (fifo_free(&j->pin) < j->pin.size / 8)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
-
-	if (s.reserved > s.remaining)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_copygc);
-	if (!s.remaining)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
-
-	if (watermark == j->watermark)
-		return;
-
-	swap(watermark, j->watermark);
-	if (watermark > j->watermark)
-		journal_wake(j);
-}
-
-static inline void bch2_journal_preres_put(struct journal *j,
-					   struct journal_preres *res)
-{
-	union journal_preres_state s = { .reserved = res->u64s };
-
-	if (!res->u64s)
-		return;
-
-	s.v = atomic64_sub_return(s.v, &j->prereserved.counter);
-	res->u64s = 0;
-
-	if (unlikely(s.waiting)) {
-		clear_bit(ilog2((((union journal_preres_state) { .waiting = 1 }).v)),
-			  (unsigned long *) &j->prereserved.v);
-		closure_wake_up(&j->preres_wait);
-	}
-
-	if (s.reserved <= s.remaining && j->watermark)
-		journal_set_watermark(j);
-}
-
-int __bch2_journal_preres_get(struct journal *,
-			struct journal_preres *, unsigned, unsigned);
-
-static inline int bch2_journal_preres_get_fast(struct journal *j,
-					       struct journal_preres *res,
-					       unsigned new_u64s,
-					       unsigned flags,
-					       bool set_waiting)
-{
-	int d = new_u64s - res->u64s;
-	union journal_preres_state old, new;
-	u64 v = atomic64_read(&j->prereserved.counter);
-	enum bch_watermark watermark = flags & BCH_WATERMARK_MASK;
-	int ret;
-
-	do {
-		old.v = new.v = v;
-		ret = 0;
-
-		if (watermark == BCH_WATERMARK_reclaim ||
-		    new.reserved + d < new.remaining) {
-			new.reserved += d;
-			ret = 1;
-		} else if (set_waiting && !new.waiting)
-			new.waiting = true;
-		else
-			return 0;
-	} while ((v = atomic64_cmpxchg(&j->prereserved.counter,
-				       old.v, new.v)) != old.v);
-
-	if (ret)
-		res->u64s += d;
-	return ret;
-}
-
-static inline int bch2_journal_preres_get(struct journal *j,
-					  struct journal_preres *res,
-					  unsigned new_u64s,
-					  unsigned flags)
-{
-	if (new_u64s <= res->u64s)
-		return 0;
-
-	if (bch2_journal_preres_get_fast(j, res, new_u64s, flags, false))
-		return 0;
-
-	if (flags & JOURNAL_RES_GET_NONBLOCK)
-		return -BCH_ERR_journal_preres_get_blocked;
-
-	return __bch2_journal_preres_get(j, res, new_u64s, flags);
-}
-
 /* journal_entry_res: */
 
 void bch2_journal_entry_res_resize(struct journal *,
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 4a18f47c9ae7..b3b822170b2c 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -50,16 +50,21 @@ unsigned bch2_journal_dev_buckets_available(struct journal *j,
 	return available;
 }
 
-static void journal_set_remaining(struct journal *j, unsigned u64s_remaining)
+static inline void journal_set_watermark(struct journal *j, bool low_on_space)
 {
-	union journal_preres_state old, new;
-	u64 v = atomic64_read(&j->prereserved.counter);
+	unsigned watermark = BCH_WATERMARK_stripe;
 
-	do {
-		old.v = new.v = v;
-		new.remaining = u64s_remaining;
-	} while ((v = atomic64_cmpxchg(&j->prereserved.counter,
-				       old.v, new.v)) != old.v);
+	if (low_on_space)
+		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
+	if (fifo_free(&j->pin) < j->pin.size / 4)
+		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
+
+	if (watermark == j->watermark)
+		return;
+
+	swap(watermark, j->watermark);
+	if (watermark > j->watermark)
+		journal_wake(j);
 }
 
 static struct journal_space
@@ -162,7 +167,6 @@ void bch2_journal_space_available(struct journal *j)
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct bch_dev *ca;
 	unsigned clean, clean_ondisk, total;
-	s64 u64s_remaining = 0;
 	unsigned max_entry_size	 = min(j->buf[0].buf_size >> 9,
 				       j->buf[1].buf_size >> 9);
 	unsigned i, nr_online = 0, nr_devs_want;
@@ -222,16 +226,10 @@ void bch2_journal_space_available(struct journal *j)
 	else
 		clear_bit(JOURNAL_MAY_SKIP_FLUSH, &j->flags);
 
-	u64s_remaining  = (u64) clean << 6;
-	u64s_remaining -= (u64) total << 3;
-	u64s_remaining = max(0LL, u64s_remaining);
-	u64s_remaining /= 4;
-	u64s_remaining = min_t(u64, u64s_remaining, U32_MAX);
+	journal_set_watermark(j, clean * 4 <= total);
 out:
 	j->cur_entry_sectors	= !ret ? j->space[journal_space_discarded].next_entry : 0;
 	j->cur_entry_error	= ret;
-	journal_set_remaining(j, u64s_remaining);
-	journal_set_watermark(j);
 
 	if (!ret)
 		journal_wake(j);
@@ -590,11 +588,6 @@ static u64 journal_seq_to_flush(struct journal *j)
 		/* Try to keep the journal at most half full: */
 		nr_buckets = ja->nr / 2;
 
-		/* And include pre-reservations: */
-		nr_buckets += DIV_ROUND_UP(j->prereserved.reserved,
-					   (ca->mi.bucket_size << 6) -
-					   journal_entry_overhead(j));
-
 		nr_buckets = min(nr_buckets, ja->nr);
 
 		bucket_to_flush = (ja->cur_idx + nr_buckets) % ja->nr;
@@ -673,10 +666,7 @@ static int __bch2_journal_reclaim(struct journal *j, bool direct, bool kicked)
 			       msecs_to_jiffies(c->opts.journal_reclaim_delay)))
 			min_nr = 1;
 
-		if (j->prereserved.reserved * 4 > j->prereserved.remaining)
-			min_nr = 1;
-
-		if (fifo_free(&j->pin) <= 32)
+		if (j->watermark != BCH_WATERMARK_stripe)
 			min_nr = 1;
 
 		if (atomic_read(&c->btree_cache.dirty) * 2 > c->btree_cache.used)
@@ -687,8 +677,6 @@ static int __bch2_journal_reclaim(struct journal *j, bool direct, bool kicked)
 		trace_and_count(c, journal_reclaim_start, c,
 				direct, kicked,
 				min_nr, min_key_cache,
-				j->prereserved.reserved,
-				j->prereserved.remaining,
 				atomic_read(&c->btree_cache.dirty),
 				c->btree_cache.used,
 				atomic_long_read(&c->btree_key_cache.nr_dirty),
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 1a9a0293c36a..1acce6ecfca0 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -76,14 +76,6 @@ struct journal_res {
 	u64			seq;
 };
 
-/*
- * For reserving space in the journal prior to getting a reservation on a
- * particular journal entry:
- */
-struct journal_preres {
-	unsigned		u64s;
-};
-
 union journal_res_state {
 	struct {
 		atomic64_t	counter;
@@ -104,22 +96,6 @@ union journal_res_state {
 	};
 };
 
-union journal_preres_state {
-	struct {
-		atomic64_t	counter;
-	};
-
-	struct {
-		u64		v;
-	};
-
-	struct {
-		u64		waiting:1,
-				reserved:31,
-				remaining:32;
-	};
-};
-
 /* bytes: */
 #define JOURNAL_ENTRY_SIZE_MIN		(64U << 10) /* 64k */
 #define JOURNAL_ENTRY_SIZE_MAX		(4U  << 20) /* 4M */
@@ -180,8 +156,6 @@ struct journal {
 	union journal_res_state reservations;
 	enum bch_watermark	watermark;
 
-	union journal_preres_state prereserved;
-
 	} __aligned(SMP_CACHE_BYTES);
 
 	unsigned long		flags;
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 893304a1f06e..7857671159b4 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -196,10 +196,9 @@ DEFINE_EVENT(bio, journal_write,
 TRACE_EVENT(journal_reclaim_start,
 	TP_PROTO(struct bch_fs *c, bool direct, bool kicked,
 		 u64 min_nr, u64 min_key_cache,
-		 u64 prereserved, u64 prereserved_total,
 		 u64 btree_cache_dirty, u64 btree_cache_total,
 		 u64 btree_key_cache_dirty, u64 btree_key_cache_total),
-	TP_ARGS(c, direct, kicked, min_nr, min_key_cache, prereserved, prereserved_total,
+	TP_ARGS(c, direct, kicked, min_nr, min_key_cache,
 		btree_cache_dirty, btree_cache_total,
 		btree_key_cache_dirty, btree_key_cache_total),
 
@@ -209,8 +208,6 @@ TRACE_EVENT(journal_reclaim_start,
 		__field(bool,		kicked			)
 		__field(u64,		min_nr			)
 		__field(u64,		min_key_cache		)
-		__field(u64,		prereserved		)
-		__field(u64,		prereserved_total	)
 		__field(u64,		btree_cache_dirty	)
 		__field(u64,		btree_cache_total	)
 		__field(u64,		btree_key_cache_dirty	)
@@ -223,22 +220,18 @@ TRACE_EVENT(journal_reclaim_start,
 		__entry->kicked			= kicked;
 		__entry->min_nr			= min_nr;
 		__entry->min_key_cache		= min_key_cache;
-		__entry->prereserved		= prereserved;
-		__entry->prereserved_total	= prereserved_total;
 		__entry->btree_cache_dirty	= btree_cache_dirty;
 		__entry->btree_cache_total	= btree_cache_total;
 		__entry->btree_key_cache_dirty	= btree_key_cache_dirty;
 		__entry->btree_key_cache_total	= btree_key_cache_total;
 	),
 
-	TP_printk("%d,%d direct %u kicked %u min %llu key cache %llu prereserved %llu/%llu btree cache %llu/%llu key cache %llu/%llu",
+	TP_printk("%d,%d direct %u kicked %u min %llu key cache %llu btree cache %llu/%llu key cache %llu/%llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->direct,
 		  __entry->kicked,
 		  __entry->min_nr,
 		  __entry->min_key_cache,
-		  __entry->prereserved,
-		  __entry->prereserved_total,
 		  __entry->btree_cache_dirty,
 		  __entry->btree_cache_total,
 		  __entry->btree_key_cache_dirty,
-- 
2.42.0

