Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E996E8F66
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731893875; cv=none; b=GsbZGaMLpdkPAUTE3kO+KdcryZSEYqXawiJlrQelNiwV1AGUL7psbI+k+4NR+wi0il0T8ubSDy3k1aTxn9lybdSsRVDUTXxLDYpVLkvmnR3tK3Bhv2q0MKqto7C7tJcDrrlRZ2YojWEn+v1a8BLS3ZD+MeBBDHNXHsPevEIszsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731893875; c=relaxed/simple;
	bh=UKhD13vnShFfvGPQfGO7uIxmJw97Ge5zt31eig76Aws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feQKwHowyb196YA03QkOTZr8Jtcav3gJM+f/tMR4Wa0AU3d1tKNoxq4MrNqpCXtXX1Z66qIKPh2bI3gtW/ZzUyXEbGIFr3sEEgzenJsv2OfkxBmvEK+VD45grIuJeLqL/gKYY/MV/UbEda3vXZ4C+4MRC/4FllgOTG7kwLxpywA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YI1Hp9UI; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YI1Hp9UI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731893871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+em82R9YGzLjxBuEOS4eNOkO0PWaLHlmkqgDShJd7sM=;
	b=YI1Hp9UI+DUzLN9zHmkPdG0b7ynHSz8cma92Q17SSYsHcBY0gMlEVO20SuzBOlSryubi1A
	o7sRfCg0wN/bUFZ7s+TuL98e3lZ9BAEUr3/Dt/y9vckTInmU8hq0TGWE6h/DyPhHC/v2BX
	37+FI2sDKXqPI3sfahEApFil0JS8ICE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] bcachefs: fix O(n^2) issue with whiteouts in journal keys
Date: Sun, 17 Nov 2024 20:37:33 -0500
Message-ID: <20241118013733.2275244-4-kent.overstreet@linux.dev>
In-Reply-To: <20241118013733.2275244-1-kent.overstreet@linux.dev>
References: <20241118013733.2275244-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The journal_keys array can't be substantially modified after we go RW,
because lookups need to be able to check it locklessly - thus we're
limited on what we can do when a key in the journal has been
overwritten.

This is a problem when there's many overwrites to skip over for peek()
operations. To fix this, add tracking of ranges of overwrites: we create
a range entry when there's more than one contiguous whiteout.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h                 |  23 +---
 fs/bcachefs/btree_journal_iter.c       | 156 ++++++++++++++++++++++---
 fs/bcachefs/btree_journal_iter.h       |   2 +
 fs/bcachefs/btree_journal_iter_types.h |  36 ++++++
 fs/bcachefs/super.c                    |   3 +-
 5 files changed, 179 insertions(+), 41 deletions(-)
 create mode 100644 fs/bcachefs/btree_journal_iter_types.h

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 7a947d43d504..11f9ed42a9da 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -205,6 +205,7 @@
 #include <linux/zstd.h>
 
 #include "bcachefs_format.h"
+#include "btree_journal_iter_types.h"
 #include "disk_accounting_types.h"
 #include "errcode.h"
 #include "fifo.h"
@@ -658,28 +659,6 @@ struct journal_seq_blacklist_table {
 	}			entries[];
 };
 
-struct journal_keys {
-	/* must match layout in darray_types.h */
-	size_t			nr, size;
-	struct journal_key {
-		u64		journal_seq;
-		u32		journal_offset;
-		enum btree_id	btree_id:8;
-		unsigned	level:8;
-		bool		allocated;
-		bool		overwritten;
-		struct bkey_i	*k;
-	}			*data;
-	/*
-	 * Gap buffer: instead of all the empty space in the array being at the
-	 * end of the buffer - from @nr to @size - the empty space is at @gap.
-	 * This means that sequential insertions are O(n) instead of O(n^2).
-	 */
-	size_t			gap;
-	atomic_t		ref;
-	bool			initial_ref_held;
-};
-
 struct btree_trans_buf {
 	struct btree_trans	*trans;
 };
diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index 93a5f758d419..8bfbcf56476b 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -16,6 +16,17 @@
  * operations for the regular btree iter code to use:
  */
 
+static inline size_t pos_to_idx(struct journal_keys *keys, size_t pos)
+{
+	size_t gap_size = keys->size - keys->nr;
+
+	BUG_ON(pos >= keys->gap && pos < keys->gap + gap_size);
+
+	if (pos >= keys->gap)
+		pos -= gap_size;
+	return pos;
+}
+
 static inline size_t idx_to_pos(struct journal_keys *keys, size_t idx)
 {
 	size_t gap_size = keys->size - keys->nr;
@@ -84,27 +95,37 @@ struct bkey_i *bch2_journal_keys_peek_max(struct bch_fs *c, enum btree_id btree_
 		}
 	}
 
+	struct bkey_i *ret = NULL;
+	rcu_read_lock(); /* for overwritten_ranges */
+
 	while ((k = *idx < keys->nr ? idx_to_key(keys, *idx) : NULL)) {
 		if (__journal_key_cmp(btree_id, level, end_pos, k) < 0)
-			return NULL;
+			break;
 
 		if (k->overwritten) {
-			(*idx)++;
+			if (k->overwritten_range)
+				*idx = rcu_dereference(k->overwritten_range)->end;
+			else
+				*idx += 1;
 			continue;
 		}
 
-		if (__journal_key_cmp(btree_id, level, pos, k) <= 0)
-			return k->k;
+		if (__journal_key_cmp(btree_id, level, pos, k) <= 0) {
+			ret = k->k;
+			break;
+		}
 
 		(*idx)++;
 		iters++;
 		if (iters == 10) {
 			*idx = 0;
+			rcu_read_unlock();
 			goto search;
 		}
 	}
 
-	return NULL;
+	rcu_read_unlock();
+	return ret;
 }
 
 struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *c, enum btree_id btree_id,
@@ -130,17 +151,25 @@ struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *c, enum btree_id b
 		}
 	}
 
+	struct bkey_i *ret = NULL;
+	rcu_read_lock(); /* for overwritten_ranges */
+
 	while ((k = *idx < keys->nr ? idx_to_key(keys, *idx) : NULL)) {
 		if (__journal_key_cmp(btree_id, level, end_pos, k) > 0)
-			return NULL;
+			break;
 
 		if (k->overwritten) {
-			--(*idx);
+			if (k->overwritten_range)
+				*idx = rcu_dereference(k->overwritten_range)->start - 1;
+			else
+				*idx -= 1;
 			continue;
 		}
 
-		if (__journal_key_cmp(btree_id, level, pos, k) >= 0)
-			return k->k;
+		if (__journal_key_cmp(btree_id, level, pos, k) >= 0) {
+			ret = k->k;
+			break;
+		}
 
 		--(*idx);
 		iters++;
@@ -150,7 +179,8 @@ struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *c, enum btree_id b
 		}
 	}
 
-	return NULL;
+	rcu_read_unlock();
+	return ret;
 }
 
 struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *c, enum btree_id btree_id,
@@ -163,6 +193,7 @@ struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *c, enum btree_id btree
 
 static void journal_iter_verify(struct journal_iter *iter)
 {
+#ifdef CONFIG_BCACHEFS_DEBUG
 	struct journal_keys *keys = iter->keys;
 	size_t gap_size = keys->size - keys->nr;
 
@@ -175,6 +206,7 @@ static void journal_iter_verify(struct journal_iter *iter)
 		int cmp = __journal_key_btree_cmp(iter->btree_id, iter->level, k);
 		BUG_ON(cmp > 0);
 	}
+#endif
 }
 
 static void journal_iters_fix(struct bch_fs *c)
@@ -335,6 +367,68 @@ bool bch2_key_deleted_in_journal(struct btree_trans *trans, enum btree_id btree,
 		bkey_deleted(&keys->data[idx].k->k));
 }
 
+static void __bch2_journal_key_overwritten(struct journal_keys *keys, size_t pos)
+{
+	struct journal_key *k = keys->data + pos;
+	size_t idx = pos_to_idx(keys, pos);
+
+	k->overwritten = true;
+
+	struct journal_key *prev = idx > 0 ? keys->data + idx_to_pos(keys, idx - 1) : NULL;
+	struct journal_key *next = idx + 1 < keys->nr ? keys->data + idx_to_pos(keys, idx + 1) : NULL;
+
+	bool prev_overwritten = prev && prev->overwritten;
+	bool next_overwritten = next && next->overwritten;
+
+	struct journal_key_range_overwritten *prev_range =
+		prev_overwritten ? prev->overwritten_range : NULL;
+	struct journal_key_range_overwritten *next_range =
+		next_overwritten ? next->overwritten_range : NULL;
+
+	BUG_ON(prev_range && prev_range->end != idx);
+	BUG_ON(next_range && next_range->start != idx + 1);
+
+	if (prev_range && next_range) {
+		prev_range->end = next_range->end;
+
+		keys->data[pos].overwritten_range = prev_range;
+		for (size_t i = next_range->start; i < next_range->end; i++) {
+			struct journal_key *ip = keys->data + idx_to_pos(keys, i);
+			BUG_ON(ip->overwritten_range != next_range);
+			ip->overwritten_range = prev_range;
+		}
+
+		kfree_rcu_mightsleep(next_range);
+	} else if (prev_range) {
+		prev_range->end++;
+		k->overwritten_range = prev_range;
+		if (next_overwritten) {
+			prev_range->end++;
+			next->overwritten_range = prev_range;
+		}
+	} else if (next_range) {
+		next_range->start--;
+		k->overwritten_range = next_range;
+		if (prev_overwritten) {
+			next_range->start--;
+			prev->overwritten_range = next_range;
+		}
+	} else if (prev_overwritten || next_overwritten) {
+		struct journal_key_range_overwritten *r = kmalloc(sizeof(*r), GFP_KERNEL);
+		if (!r)
+			return;
+
+		r->start = idx - (size_t) prev_overwritten;
+		r->end = idx + 1 + (size_t) next_overwritten;
+
+		rcu_assign_pointer(k->overwritten_range, r);
+		if (prev_overwritten)
+			prev->overwritten_range = r;
+		if (next_overwritten)
+			next->overwritten_range = r;
+	}
+}
+
 void bch2_journal_key_overwritten(struct bch_fs *c, enum btree_id btree,
 				  unsigned level, struct bpos pos)
 {
@@ -344,8 +438,12 @@ void bch2_journal_key_overwritten(struct bch_fs *c, enum btree_id btree,
 	if (idx < keys->size &&
 	    keys->data[idx].btree_id	== btree &&
 	    keys->data[idx].level	== level &&
-	    bpos_eq(keys->data[idx].k->k.p, pos))
-		keys->data[idx].overwritten = true;
+	    bpos_eq(keys->data[idx].k->k.p, pos) &&
+	    !keys->data[idx].overwritten) {
+		mutex_lock(&keys->overwrite_lock);
+		__bch2_journal_key_overwritten(keys, idx);
+		mutex_unlock(&keys->overwrite_lock);
+	}
 }
 
 static void bch2_journal_iter_advance(struct journal_iter *iter)
@@ -359,8 +457,11 @@ static void bch2_journal_iter_advance(struct journal_iter *iter)
 
 static struct bkey_s_c bch2_journal_iter_peek(struct journal_iter *iter)
 {
+	struct bkey_s_c ret = bkey_s_c_null;
+
 	journal_iter_verify(iter);
 
+	rcu_read_lock();
 	while (iter->idx < iter->keys->size) {
 		struct journal_key *k = iter->keys->data + iter->idx;
 
@@ -369,13 +470,19 @@ static struct bkey_s_c bch2_journal_iter_peek(struct journal_iter *iter)
 			break;
 		BUG_ON(cmp);
 
-		if (!k->overwritten)
-			return bkey_i_to_s_c(k->k);
+		if (!k->overwritten) {
+			ret = bkey_i_to_s_c(k->k);
+			break;
+		}
 
-		bch2_journal_iter_advance(iter);
+		if (k->overwritten_range)
+			iter->idx = idx_to_pos(iter->keys, rcu_dereference(k->overwritten_range)->end);
+		else
+			bch2_journal_iter_advance(iter);
 	}
+	rcu_read_unlock();
 
-	return bkey_s_c_null;
+	return ret;
 }
 
 static void bch2_journal_iter_exit(struct journal_iter *iter)
@@ -556,9 +663,15 @@ void bch2_journal_keys_put(struct bch_fs *c)
 
 	move_gap(keys, keys->nr);
 
-	darray_for_each(*keys, i)
+	darray_for_each(*keys, i) {
+		if (i->overwritten_range &&
+		    (i == &darray_last(*keys) ||
+		     i->overwritten_range != i[1].overwritten_range))
+			kfree(i->overwritten_range);
+
 		if (i->allocated)
 			kfree(i->k);
+	}
 
 	kvfree(keys->data);
 	keys->data = NULL;
@@ -682,3 +795,12 @@ void bch2_journal_keys_dump(struct bch_fs *c)
 	}
 	printbuf_exit(&buf);
 }
+
+void bch2_fs_journal_keys_init(struct bch_fs *c)
+{
+	struct journal_keys *keys = &c->journal_keys;
+
+	atomic_set(&keys->ref, 1);
+	keys->initial_ref_held = true;
+	mutex_init(&keys->overwrite_lock);
+}
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index 9e8f8ab1c6ff..2a3082919b8d 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -97,4 +97,6 @@ void bch2_shoot_down_journal_keys(struct bch_fs *, enum btree_id,
 
 void bch2_journal_keys_dump(struct bch_fs *);
 
+void bch2_fs_journal_keys_init(struct bch_fs *);
+
 #endif /* _BCACHEFS_BTREE_JOURNAL_ITER_H */
diff --git a/fs/bcachefs/btree_journal_iter_types.h b/fs/bcachefs/btree_journal_iter_types.h
new file mode 100644
index 000000000000..8b773823704f
--- /dev/null
+++ b/fs/bcachefs/btree_journal_iter_types.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_BTREE_JOURNAL_ITER_TYPES_H
+#define _BCACHEFS_BTREE_JOURNAL_ITER_TYPES_H
+
+struct journal_key_range_overwritten {
+	size_t			start, end;
+};
+
+struct journal_key {
+	u64			journal_seq;
+	u32			journal_offset;
+	enum btree_id		btree_id:8;
+	unsigned		level:8;
+	bool			allocated;
+	bool			overwritten;
+	struct journal_key_range_overwritten __rcu *
+				overwritten_range;
+	struct bkey_i		*k;
+};
+
+struct journal_keys {
+	/* must match layout in darray_types.h */
+	size_t			nr, size;
+	struct journal_key	*data;
+	/*
+	 * Gap buffer: instead of all the empty space in the array being at the
+	 * end of the buffer - from @nr to @size - the empty space is at @gap.
+	 * This means that sequential insertions are O(n) instead of O(n^2).
+	 */
+	size_t			gap;
+	atomic_t		ref;
+	bool			initial_ref_held;
+	struct mutex		overwrite_lock;
+};
+
+#endif /* _BCACHEFS_BTREE_JOURNAL_ITER_TYPES_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 37eee352fa21..08170a3d524f 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -773,8 +773,6 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
 	init_rwsem(&c->gc_lock);
 	mutex_init(&c->gc_gens_lock);
-	atomic_set(&c->journal_keys.ref, 1);
-	c->journal_keys.initial_ref_held = true;
 
 	for (i = 0; i < BCH_TIME_STAT_NR; i++)
 		bch2_time_stats_init(&c->times[i]);
@@ -784,6 +782,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	bch2_fs_btree_key_cache_init_early(&c->btree_key_cache);
 	bch2_fs_btree_iter_init_early(c);
 	bch2_fs_btree_interior_update_init_early(c);
+	bch2_fs_journal_keys_init(c);
 	bch2_fs_allocator_background_init(c);
 	bch2_fs_allocator_foreground_init(c);
 	bch2_fs_rebalance_init(c);
-- 
2.45.2

