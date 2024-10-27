Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB29D4A03
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990323; cv=none; b=CHirSMON5f4W27OP2/xa4XtgnbW8/LeD50WYbgWsIgwE1Erg3QL5mcCrfWlSDbRNFItau+bh6ikBpKgvGBDHituIFzg0yS3csJgfC+xNyH4EGxITKbBgPFeeig2gcqyyNqeJOTSOkMEftDz4ruO7HEAtyP4ITgwiYcl5jA7GN2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990323; c=relaxed/simple;
	bh=61O7TOE3bNEIqjKF4uW9tuZs6ALyX06wQBiDYMpLp/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDAHQkz5HD2egJvuhtegKY84ko0lcP3QWhvTQuKE8uFk/c78LvmbmNLd7uDZyAWNQo0vRSt4ImaGsC2dj+g1CK+XPR440PsSoLmqLON8HHoulnAK3tZSUbUxxPjWfFJxHzI+d1sjoLZ+I6xxEcCngA3/KJByz7Z5PyXR2WXOCoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fpDyjJ+t; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fpDyjJ+t"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lSDTXziLL1qOttveWkKA2IfHZybKotaGxeAeNBMr28g=;
	b=fpDyjJ+t3554rQQAmdOIc4KQhWqsE+MwFoXIE8eUO4jhP+j06upd0L0e2Phvn9ou/v+SQh
	oMD+q5UyNxq5MKOGYlE4oz6ebKJGv4lsFAMZVplD2Tl2IYLLJPi4w/fLg/YQp5MT2Iox84
	jAmtud7sRheYeCYgyE24us3FEb4VUsY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/9] bcachefs: Implement bch2_btree_iter_prev_min()
Date: Sat, 26 Oct 2024 20:51:37 -0400
Message-ID: <20241027005141.2337634-9-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A user contributed a filessytem dump, where the dump was actually
corrupted (due to being taken while the filesystem was online), but
which exposed an interesting bug in fsck - reconstruct_inode().

When itearting in BTREE_ITER_filter_snapshots mode, it's required to
give an end position for the iteration and it can't span inode numbers;
continuing into the next inode might mean we start seeing keys from a
different snapshot tree, that the is_ancestor() checks always filter,
thus we're never able to return a key and stop iterating.

Backwards iteration never implemented the end position because nothing
else needed it - except for reconstuct_inode().

Additionally, backwards iteration is now able to overlay keys from the
journal, which will be useful if we ever decide to start doing journal
replay in the background.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c         | 264 +++++++++++++++++++++----------
 fs/bcachefs/btree_iter.h         |   8 +-
 fs/bcachefs/btree_journal_iter.c |  46 ++++++
 fs/bcachefs/btree_journal_iter.h |   2 +
 fs/bcachefs/errcode.h            |   1 -
 fs/bcachefs/fsck.c               |   4 +-
 fs/bcachefs/io_misc.c            |   2 +-
 7 files changed, 239 insertions(+), 88 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index e16dbf431c10..6bb2eb388c1b 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -270,8 +270,10 @@ static void bch2_btree_iter_verify_entry_exit(struct btree_iter *iter)
 	BUG_ON(!(iter->flags & BTREE_ITER_all_snapshots) &&
 	       iter->pos.snapshot != iter->snapshot);
 
-	BUG_ON(bkey_lt(iter->pos, bkey_start_pos(&iter->k)) ||
-	       bkey_gt(iter->pos, iter->k.p));
+	BUG_ON(iter->flags & BTREE_ITER_all_snapshots	? !bpos_eq(iter->pos, iter->k.p) :
+	       !(iter->flags & BTREE_ITER_is_extents)	? !bkey_eq(iter->pos, iter->k.p) :
+	       (bkey_lt(iter->pos, bkey_start_pos(&iter->k)) ||
+		bkey_gt(iter->pos, iter->k.p)));
 }
 
 static int bch2_btree_iter_verify_ret(struct btree_iter *iter, struct bkey_s_c k)
@@ -2134,6 +2136,37 @@ struct bkey_s_c btree_trans_peek_journal(struct btree_trans *trans,
 	return k;
 }
 
+static struct bkey_i *bch2_btree_journal_peek_prev(struct btree_trans *trans,
+					      struct btree_iter *iter,
+					      struct bpos end_pos)
+{
+	struct btree_path *path = btree_iter_path(trans, iter);
+
+	return bch2_journal_keys_peek_prev_min(trans->c, iter->btree_id,
+					   path->level,
+					   path->pos,
+					   end_pos,
+					   &iter->journal_idx);
+}
+
+static noinline
+struct bkey_s_c btree_trans_peek_prev_journal(struct btree_trans *trans,
+					 struct btree_iter *iter,
+					 struct bkey_s_c k)
+{
+	struct btree_path *path = btree_iter_path(trans, iter);
+	struct bkey_i *next_journal =
+		bch2_btree_journal_peek_prev(trans, iter,
+				k.k ? k.k->p : path_l(path)->b->key.k.p);
+
+	if (next_journal) {
+		iter->k = next_journal->k;
+		k = bkey_i_to_s_c(next_journal);
+	}
+
+	return k;
+}
+
 /*
  * Checks btree key cache for key at iter->pos and returns it if present, or
  * bkey_s_c_null:
@@ -2446,131 +2479,193 @@ struct bkey_s_c bch2_btree_iter_next(struct btree_iter *iter)
 	return bch2_btree_iter_peek(iter);
 }
 
+static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, struct bpos search_key)
+{
+	struct btree_trans *trans = iter->trans;
+	struct bkey_s_c k, k2;
+
+	bch2_btree_iter_verify(iter);
+
+	while (1) {
+		iter->path = bch2_btree_path_set_pos(trans, iter->path, search_key,
+					iter->flags & BTREE_ITER_intent,
+					btree_iter_ip_allocated(iter));
+
+		int ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
+		if (unlikely(ret)) {
+			/* ensure that iter->k is consistent with iter->pos: */
+			bch2_btree_iter_set_pos(iter, iter->pos);
+			k = bkey_s_c_err(ret);
+			break;
+		}
+
+		struct btree_path *path = btree_iter_path(trans, iter);
+		struct btree_path_level *l = path_l(path);
+
+		if (unlikely(!l->b)) {
+			/* No btree nodes at requested level: */
+			bch2_btree_iter_set_pos(iter, SPOS_MAX);
+			k = bkey_s_c_null;
+			break;
+		}
+
+		btree_path_set_should_be_locked(trans, path);
+
+		k = btree_path_level_peek_all(trans->c, l, &iter->k);
+		if (!k.k || bpos_gt(k.k->p, search_key)) {
+			k = btree_path_level_prev(trans, path, l, &iter->k);
+
+			BUG_ON(k.k && bpos_gt(k.k->p, search_key));
+		}
+
+		if (unlikely(iter->flags & BTREE_ITER_with_key_cache) &&
+		    k.k &&
+		    (k2 = btree_trans_peek_key_cache(iter, k.k->p)).k) {
+			k = k2;
+			if (bkey_err(k2)) {
+				bch2_btree_iter_set_pos(iter, iter->pos);
+				break;
+			}
+		}
+
+		if (unlikely(iter->flags & BTREE_ITER_with_journal))
+			k = btree_trans_peek_prev_journal(trans, iter, k);
+
+		if (unlikely((iter->flags & BTREE_ITER_with_updates) &&
+			     trans->nr_updates))
+			bch2_btree_trans_peek_prev_updates(trans, iter, &k);
+
+		if (likely(k.k && !bkey_deleted(k.k))) {
+			break;
+		} else if (k.k) {
+			search_key = bpos_predecessor(k.k->p);
+		} else if (likely(!bpos_eq(path->l[0].b->data->min_key, POS_MIN))) {
+			/* Advance to previous leaf node: */
+			search_key = bpos_predecessor(path->l[0].b->data->min_key);
+		} else {
+			/* Start of btree: */
+			bch2_btree_iter_set_pos(iter, POS_MIN);
+			k = bkey_s_c_null;
+			break;
+		}
+	}
+
+	bch2_btree_iter_verify(iter);
+	return k;
+}
+
 /**
- * bch2_btree_iter_peek_prev() - returns first key less than or equal to
+ * bch2_btree_iter_peek_prev_min() - returns first key less than or equal to
  * iterator's current position
  * @iter:	iterator to peek from
+ * @end:	search limit: returns keys greater than or equal to @end
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bpos end)
 {
 	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = iter->pos;
 	struct bkey_s_c k;
-	struct bkey saved_k;
-	const struct bch_val *saved_v;
 	btree_path_idx_t saved_path = 0;
-	int ret;
 
 	bch2_trans_verify_not_unlocked(trans);
-	EBUG_ON(btree_iter_path(trans, iter)->cached ||
-		btree_iter_path(trans, iter)->level);
-
-	if (iter->flags & BTREE_ITER_with_journal)
-		return bkey_s_c_err(-BCH_ERR_btree_iter_with_journal_not_supported);
-
-	bch2_btree_iter_verify(iter);
 	bch2_btree_iter_verify_entry_exit(iter);
+	EBUG_ON((iter->flags & BTREE_ITER_filter_snapshots) && bpos_eq(end, POS_MIN));
 
-	ret = trans_maybe_inject_restart(trans, _RET_IP_);
-	if (unlikely(ret))
-		return bkey_s_c_err(ret);
+	int ret = trans_maybe_inject_restart(trans, _RET_IP_);
+	if (unlikely(ret)) {
+		k = bkey_s_c_err(ret);
+		goto out_no_locked;
+	}
 
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		search_key.snapshot = U32_MAX;
 
 	while (1) {
-		iter->path = bch2_btree_path_set_pos(trans, iter->path, search_key,
-						iter->flags & BTREE_ITER_intent,
-						btree_iter_ip_allocated(iter));
-
-		ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
-		if (unlikely(ret)) {
-			/* ensure that iter->k is consistent with iter->pos: */
-			bch2_btree_iter_set_pos(iter, iter->pos);
-			k = bkey_s_c_err(ret);
+		k = __bch2_btree_iter_peek_prev(iter, search_key);
+		if (unlikely(!k.k))
+			goto end;
+		if (unlikely(bkey_err(k)))
 			goto out_no_locked;
-		}
 
-		struct btree_path *path = btree_iter_path(trans, iter);
-
-		k = btree_path_level_peek(trans, path, &path->l[0], &iter->k);
-		if (!k.k ||
-		    ((iter->flags & BTREE_ITER_is_extents)
-		     ? bpos_ge(bkey_start_pos(k.k), search_key)
-		     : bpos_gt(k.k->p, search_key)))
-			k = btree_path_level_prev(trans, path, &path->l[0], &iter->k);
+		if (iter->flags & BTREE_ITER_filter_snapshots) {
+			struct btree_path *s = saved_path ? trans->paths + saved_path : NULL;
+			if (s && bpos_lt(k.k->p, SPOS(s->pos.inode, s->pos.offset, iter->snapshot))) {
+				/*
+				 * If we have a saved candidate, and we're past
+				 * the last possible snapshot overwrite, return
+				 * it:
+				 */
+				bch2_path_put_nokeep(trans, iter->path,
+					      iter->flags & BTREE_ITER_intent);
+				iter->path = saved_path;
+				saved_path = 0;
+				k = bch2_btree_path_peek_slot(btree_iter_path(trans, iter), &iter->k);
+				break;
+			}
 
-		if (unlikely((iter->flags & BTREE_ITER_with_updates) &&
-			     trans->nr_updates))
-			bch2_btree_trans_peek_prev_updates(trans, iter, &k);
+			/*
+			 * We need to check against @end before FILTER_SNAPSHOTS because
+			 * if we get to a different inode that requested we might be
+			 * seeing keys for a different snapshot tree that will all be
+			 * filtered out.
+			 */
+			if (unlikely(bkey_lt(k.k->p, end)))
+				goto end;
 
-		if (likely(k.k)) {
-			if (iter->flags & BTREE_ITER_filter_snapshots) {
-				if (k.k->p.snapshot == iter->snapshot)
-					goto got_key;
+			if (!bch2_snapshot_is_ancestor(trans->c, iter->snapshot, k.k->p.snapshot)) {
+				search_key = bpos_predecessor(k.k->p);
+				continue;
+			}
 
+			if (k.k->p.snapshot != iter->snapshot) {
 				/*
-				 * If we have a saved candidate, and we're no
-				 * longer at the same _key_ (not pos), return
-				 * that candidate
+				 * Have a key visible in iter->snapshot, but
+				 * might have overwrites: - save it and keep
+				 * searching. Unless it's a whiteout - then drop
+				 * our previous saved candidate:
 				 */
-				if (saved_path && !bkey_eq(k.k->p, saved_k.p)) {
-					bch2_path_put_nokeep(trans, iter->path,
-						      iter->flags & BTREE_ITER_intent);
-					iter->path = saved_path;
+				if (saved_path) {
+					bch2_path_put_nokeep(trans, saved_path,
+					      iter->flags & BTREE_ITER_intent);
 					saved_path = 0;
-					iter->k	= saved_k;
-					k.v	= saved_v;
-					goto got_key;
 				}
 
-				if (bch2_snapshot_is_ancestor(trans->c,
-							      iter->snapshot,
-							      k.k->p.snapshot)) {
-					if (saved_path)
-						bch2_path_put_nokeep(trans, saved_path,
-						      iter->flags & BTREE_ITER_intent);
+				if (!bkey_whiteout(k.k)) {
 					saved_path = btree_path_clone(trans, iter->path,
 								iter->flags & BTREE_ITER_intent,
 								_THIS_IP_);
-					path = btree_iter_path(trans, iter);
-					trace_btree_path_save_pos(trans, path, trans->paths + saved_path);
-					saved_k = *k.k;
-					saved_v = k.v;
+					trace_btree_path_save_pos(trans,
+								  trans->paths + iter->path,
+								  trans->paths + saved_path);
 				}
 
 				search_key = bpos_predecessor(k.k->p);
 				continue;
 			}
-got_key:
-			if (bkey_whiteout(k.k) &&
-			    !(iter->flags & BTREE_ITER_all_snapshots)) {
+
+			if (bkey_whiteout(k.k)) {
 				search_key = bkey_predecessor(iter, k.k->p);
-				if (iter->flags & BTREE_ITER_filter_snapshots)
-					search_key.snapshot = U32_MAX;
+				search_key.snapshot = U32_MAX;
 				continue;
 			}
-
-			btree_path_set_should_be_locked(trans, path);
-			break;
-		} else if (likely(!bpos_eq(path->l[0].b->data->min_key, POS_MIN))) {
-			/* Advance to previous leaf node: */
-			search_key = bpos_predecessor(path->l[0].b->data->min_key);
-		} else {
-			/* Start of btree: */
-			bch2_btree_iter_set_pos(iter, POS_MIN);
-			k = bkey_s_c_null;
-			goto out_no_locked;
 		}
-	}
 
-	EBUG_ON(bkey_gt(bkey_start_pos(k.k), iter->pos));
+		EBUG_ON(iter->flags & BTREE_ITER_all_snapshots		? bpos_gt(k.k->p, iter->pos) :
+			iter->flags & BTREE_ITER_is_extents		? bkey_ge(bkey_start_pos(k.k), iter->pos) :
+									  bkey_gt(k.k->p, iter->pos));
+
+		if (unlikely(iter->flags & BTREE_ITER_all_snapshots	? bpos_lt(k.k->p, end) :
+			     iter->flags & BTREE_ITER_is_extents	? bkey_le(k.k->p, end) :
+									  bkey_lt(k.k->p, end)))
+			goto end;
+
+		break;
+	}
 
 	/* Extents can straddle iter->pos: */
-	if (bkey_lt(k.k->p, iter->pos))
-		iter->pos = k.k->p;
+	iter->pos = bpos_min(iter->pos, k.k->p);;
 
 	if (iter->flags & BTREE_ITER_filter_snapshots)
 		iter->pos.snapshot = iter->snapshot;
@@ -2580,8 +2675,11 @@ struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *iter)
 
 	bch2_btree_iter_verify_entry_exit(iter);
 	bch2_btree_iter_verify(iter);
-
 	return k;
+end:
+	bch2_btree_iter_set_pos(iter, end);
+	k = bkey_s_c_null;
+	goto out_no_locked;
 }
 
 /**
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index dfda865cd394..36cfc1dc4d43 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -409,7 +409,13 @@ static inline struct bkey_s_c bch2_btree_iter_peek(struct btree_iter *iter)
 	return bch2_btree_iter_peek_max(iter, SPOS_MAX);
 }
 
-struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *, struct bpos);
+
+static inline struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *iter)
+{
+	return bch2_btree_iter_peek_prev_min(iter, POS_MIN);
+}
+
 struct bkey_s_c bch2_btree_iter_prev(struct btree_iter *);
 
 struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *);
diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index c9dee4b4627a..c44889ef9817 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -107,6 +107,52 @@ struct bkey_i *bch2_journal_keys_peek_max(struct bch_fs *c, enum btree_id btree_
 	return NULL;
 }
 
+struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *c, enum btree_id btree_id,
+					   unsigned level, struct bpos pos,
+					   struct bpos end_pos, size_t *idx)
+{
+	struct journal_keys *keys = &c->journal_keys;
+	unsigned iters = 0;
+	struct journal_key *k;
+
+	BUG_ON(*idx > keys->nr);
+search:
+	if (!*idx)
+		*idx = __bch2_journal_key_search(keys, btree_id, level, pos);
+
+	while (*idx &&
+	       __journal_key_cmp(btree_id, level, end_pos, idx_to_key(keys, *idx - 1)) <= 0) {
+		(*idx)++;
+		iters++;
+		if (iters == 10) {
+			*idx = 0;
+			goto search;
+		}
+	}
+
+	while ((k = *idx < keys->nr ? idx_to_key(keys, *idx) : NULL)) {
+		if (__journal_key_cmp(btree_id, level, end_pos, k) > 0)
+			return NULL;
+
+		if (k->overwritten) {
+			--(*idx);
+			continue;
+		}
+
+		if (__journal_key_cmp(btree_id, level, pos, k) >= 0)
+			return k->k;
+
+		--(*idx);
+		iters++;
+		if (iters == 10) {
+			*idx = 0;
+			goto search;
+		}
+	}
+
+	return NULL;
+}
+
 struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *c, enum btree_id btree_id,
 					   unsigned level, struct bpos pos)
 {
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index 754939f604d5..fa8c4f82c9c7 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -45,6 +45,8 @@ static inline int journal_key_cmp(const struct journal_key *l, const struct jour
 
 struct bkey_i *bch2_journal_keys_peek_max(struct bch_fs *, enum btree_id,
 				unsigned, struct bpos, struct bpos, size_t *);
+struct bkey_i *bch2_journal_keys_peek_prev_min(struct bch_fs *, enum btree_id,
+				unsigned, struct bpos, struct bpos, size_t *);
 struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *, enum btree_id,
 					   unsigned, struct bpos);
 
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 9c54d2c230c6..4ccd098207e5 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -192,7 +192,6 @@
 	x(EINVAL,			opt_parse_error)			\
 	x(EINVAL,			remove_with_metadata_missing_unimplemented)\
 	x(EINVAL,			remove_would_lose_data)			\
-	x(EINVAL,			btree_iter_with_journal_not_supported)	\
 	x(EROFS,			erofs_trans_commit)			\
 	x(EROFS,			erofs_no_writes)			\
 	x(EROFS,			erofs_journal_err)			\
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 2229f0dcc860..2e92031fe01a 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -618,7 +618,7 @@ static int reconstruct_inode(struct btree_trans *trans, enum btree_id btree, u32
 		struct btree_iter iter = {};
 
 		bch2_trans_iter_init(trans, &iter, BTREE_ID_extents, SPOS(inum, U64_MAX, snapshot), 0);
-		struct bkey_s_c k = bch2_btree_iter_peek_prev(&iter);
+		struct bkey_s_c k = bch2_btree_iter_peek_prev_min(&iter, POS(inum, 0));
 		bch2_trans_iter_exit(trans, &iter);
 		int ret = bkey_err(k);
 		if (ret)
@@ -1647,7 +1647,7 @@ static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_wal
 		if (i->count != count2) {
 			bch_err_ratelimited(c, "fsck counted i_sectors wrong for inode %llu:%u: got %llu should be %llu",
 					    w->last_pos.inode, i->snapshot, i->count, count2);
-			return -BCH_ERR_internal_fsck_err;
+			i->count = count2;
 		}
 
 		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty),
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index ff661a072000..524e31e7411b 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -426,7 +426,7 @@ case LOGGED_OP_FINSERT_shift_extents:
 		bch2_btree_iter_set_pos(&iter, SPOS(inum.inum, pos, snapshot));
 
 		k = insert
-			? bch2_btree_iter_peek_prev(&iter)
+			? bch2_btree_iter_peek_prev_min(&iter, POS(inum.inum, 0))
 			: bch2_btree_iter_peek_max(&iter, POS(inum.inum, U64_MAX));
 		if ((ret = bkey_err(k)))
 			goto btree_err;
-- 
2.45.2

