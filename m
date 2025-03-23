Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF902433BE
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739298; cv=none; b=Tzhf03UJZPyJ2dE5uGhONen1WtIv4CvFlJy2eZcDkAbFu+oGmk1FkLgaZzu1cVPTdYyuFpQtZuGZn20Y2pEtgdovha6xkiO1Te75PlOGSqAPwdZBWJbKSfaPY0gZ148ewXTobtbKz3gAQqQhXiKE1lh67cxMd5BrYtNBd2Lnb1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739298; c=relaxed/simple;
	bh=PItLNyChKFhvwupnmA5QokacbAfhl+HELvSNvOcRnv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt/q9UvbgRFvYctjZTG2qF1oOt99etGADf7q8iHua2FF4arJ5TTvPc+rgXgq9mEUUE1L23JRDoZeJwzKf47GAOvp360NfoEgQkQsoMX/RsTjWyeqJeXvLVtIoAI6NvV57tCNIIl31QcHfF+SHh1rOQ5EnxEM2xR38GWtvVLR7ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wF+Powyf; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wF+Powyf"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=McVL4HEHtydjoqTkoJAJBEmYijSS6kiKptxToK6UiB8=;
	b=wF+Powyfl0cqpR6GXZLdWHgUf/848+9Cchm3cHc5RnbPDFn3R8obWhpnKuW6p9TZjGplFb
	cLV6zHKeIhxZ7U1C25/ttz+2YW46OvVyovaLL5VW+ZgFKdoU7DgmkFyQU3OAv+DYBWWl6v
	wymndKpozAv+w4gdhO/7KKjfR5TikLc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/8] bcachefs: bch2_alloc_to_v4() no longer converts on stack
Date: Sun, 23 Mar 2025 10:14:38 -0400
Message-ID: <20250323141445.566595-5-kent.overstreet@linux.dev>
In-Reply-To: <20250323141445.566595-1-kent.overstreet@linux.dev>
References: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KMSAN builds have been overflowing the stack:

  transaction commit
  btree split
  allocator - sector/bucket
  runtime fsck checks - bch2_check_discard_freespace_key

bch2_alloc_to_v4() exists for compatibility with ancient versions, it's
generally a noop but will convert old alloc keys into the new format.

This gets rid of the stack allocated bch_alloc_v4 in those codepaths; we
allocate it with the btree_trans bump allocator if needed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 54 ++++++++++++++++++++++++----------
 fs/bcachefs/alloc_background.h | 23 +++++++++++++--
 fs/bcachefs/alloc_foreground.c | 15 ++++++++--
 fs/bcachefs/backpointers.c     |  2 +-
 fs/bcachefs/btree_gc.c         |  4 +--
 fs/bcachefs/ec.c               |  2 +-
 fs/bcachefs/lru.c              |  9 ++++--
 fs/bcachefs/movinggc.c         |  2 +-
 8 files changed, 82 insertions(+), 29 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 8b6051d19abf..b6aceae9daf9 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -338,7 +338,7 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 void bch2_alloc_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
 {
 	struct bch_alloc_v4 _a;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &_a);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(k, &_a);
 	struct bch_dev *ca = c ? bch2_dev_bucket_tryget_noerror(c, k.k->p) : NULL;
 
 	prt_newline(out);
@@ -367,7 +367,7 @@ void bch2_alloc_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	bch2_dev_put(ca);
 }
 
-void __bch2_alloc_to_v4(struct bkey_s_c k, struct bch_alloc_v4 *out)
+void __bch2_alloc_to_v4_copy(struct bkey_s_c k, struct bch_alloc_v4 *out)
 {
 	if (k.k->type == KEY_TYPE_alloc_v4) {
 		void *src, *dst;
@@ -403,6 +403,15 @@ void __bch2_alloc_to_v4(struct bkey_s_c k, struct bch_alloc_v4 *out)
 	}
 }
 
+const struct bch_alloc_v4 *__bch2_alloc_to_v4(struct btree_trans *trans, struct bkey_s_c k)
+{
+	struct bch_alloc_v4 *out = bch2_trans_kmalloc(trans, sizeof(*out));
+	if (!IS_ERR(out))
+		__bch2_alloc_to_v4_copy(k, out);
+
+	return out;
+}
+
 static noinline struct bkey_i_alloc_v4 *
 __bch2_alloc_to_v4_mut(struct btree_trans *trans, struct bkey_s_c k)
 {
@@ -429,7 +438,7 @@ __bch2_alloc_to_v4_mut(struct btree_trans *trans, struct bkey_s_c k)
 	} else {
 		bkey_alloc_v4_init(&ret->k_i);
 		ret->k.p = k.k->p;
-		bch2_alloc_to_v4(k, &ret->v);
+		__bch2_alloc_to_v4_copy(k, &ret->v);
 	}
 	return ret;
 }
@@ -552,7 +561,7 @@ int bch2_bucket_gens_init(struct bch_fs *c)
 			continue;
 
 		struct bch_alloc_v4 a;
-		u8 gen = bch2_alloc_to_v4(k, &a)->gen;
+		u8 gen = bch2_alloc_to_v4_onstack(k, &a)->gen;
 		unsigned offset;
 		struct bpos pos = alloc_gens_pos(iter.pos, &offset);
 		int ret2 = 0;
@@ -644,7 +653,7 @@ int bch2_alloc_read(struct bch_fs *c)
 			}
 
 			struct bch_alloc_v4 a;
-			*bucket_gen(ca, k.k->p.offset) = bch2_alloc_to_v4(k, &a)->gen;
+			*bucket_gen(ca, k.k->p.offset) = bch2_alloc_to_v4_onstack(k, &a)->gen;
 			0;
 		}));
 	}
@@ -837,8 +846,12 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 	if (!ca)
 		return -BCH_ERR_trigger_alloc;
 
+	/*
+	 * We have to use the _onstack version here as we're called for atomic
+	 * triggers where we can't take a transaction restart:
+	 */
 	struct bch_alloc_v4 old_a_convert;
-	const struct bch_alloc_v4 *old_a = bch2_alloc_to_v4(old, &old_a_convert);
+	const struct bch_alloc_v4 *old_a = bch2_alloc_to_v4_onstack(old, &old_a_convert);
 
 	struct bch_alloc_v4 *new_a;
 	if (likely(new.k->type == KEY_TYPE_alloc_v4)) {
@@ -1146,7 +1159,6 @@ int bch2_check_alloc_key(struct btree_trans *trans,
 			 struct btree_iter *bucket_gens_iter)
 {
 	struct bch_fs *c = trans->c;
-	struct bch_alloc_v4 a_convert;
 	const struct bch_alloc_v4 *a;
 	unsigned gens_offset;
 	struct bkey_s_c k;
@@ -1165,7 +1177,10 @@ int bch2_check_alloc_key(struct btree_trans *trans,
 	if (!ca->mi.freespace_initialized)
 		goto out;
 
-	a = bch2_alloc_to_v4(alloc_k, &a_convert);
+	a = bch2_alloc_to_v4(trans, alloc_k);
+	ret = PTR_ERR_OR_ZERO(a);
+	if (unlikely(ret))
+		goto err;
 
 	bch2_btree_iter_set_pos(trans, discard_iter, alloc_k.k->p);
 	k = bch2_btree_iter_peek_slot(trans, discard_iter);
@@ -1414,8 +1429,10 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 		goto out;
 	}
 
-	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(trans, alloc_k);
+	ret = PTR_ERR_OR_ZERO(a);
+	if (unlikely(ret))
+		goto err;
 
 	if (a->data_type != state ||
 	    (state == BCH_DATA_free &&
@@ -1435,6 +1452,7 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 
 	*gen = a->gen;
 out:
+err:
 fsck_err:
 	bch2_set_btree_iter_dontneed(trans, &alloc_iter);
 	bch2_trans_iter_exit(trans, &alloc_iter);
@@ -1680,8 +1698,6 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 				       struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
-	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a;
 	struct bkey_s_c alloc_k;
 	struct printbuf buf = PRINTBUF;
 	int ret;
@@ -1698,7 +1714,10 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 	if (!ca)
 		return 0;
 
-	a = bch2_alloc_to_v4(alloc_k, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(trans, alloc_k);
+	ret = PTR_ERR_OR_ZERO(a);
+	if (unlikely(ret))
+		goto err;
 
 	u64 lru_idx = alloc_lru_idx_fragmentation(*a, ca);
 	if (lru_idx) {
@@ -2160,8 +2179,10 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(trans, alloc_k);
+	ret = PTR_ERR_OR_ZERO(a);
+	if (unlikely(ret))
+		goto err;
 
 	/* We expect harmless races here due to the btree write buffer: */
 	if (lru_pos_time(lru_iter->pos) != alloc_lru_idx_read(*a))
@@ -2190,6 +2211,7 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	trace_and_count(c, bucket_invalidate, c, bucket.inode, bucket.offset, cached_sectors);
 	--*nr_to_invalidate;
 out:
+err:
 fsck_err:
 	bch2_trans_iter_exit(trans, &alloc_iter);
 	printbuf_exit(&buf);
@@ -2334,7 +2356,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
 			 * time:
 			 */
 			struct bch_alloc_v4 a_convert;
-			const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &a_convert);
+			const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(k, &a_convert);
 
 			ret =   bch2_bucket_do_index(trans, ca, k, a, true) ?:
 				bch2_trans_commit(trans, NULL, NULL,
diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index c556ccaffe89..e6e45ad39bfe 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -220,9 +220,10 @@ struct bkey_i_alloc_v4 *
 bch2_trans_start_alloc_update(struct btree_trans *, struct bpos,
 			      enum btree_iter_update_trigger_flags);
 
-void __bch2_alloc_to_v4(struct bkey_s_c, struct bch_alloc_v4 *);
+void __bch2_alloc_to_v4_copy(struct bkey_s_c, struct bch_alloc_v4 *);
+const struct bch_alloc_v4 *__bch2_alloc_to_v4(struct btree_trans *, struct bkey_s_c);
 
-static inline const struct bch_alloc_v4 *bch2_alloc_to_v4(struct bkey_s_c k, struct bch_alloc_v4 *convert)
+static inline const struct bch_alloc_v4 *bch2_alloc_to_v4(struct btree_trans *trans, struct bkey_s_c k)
 {
 	const struct bch_alloc_v4 *ret;
 
@@ -235,7 +236,23 @@ static inline const struct bch_alloc_v4 *bch2_alloc_to_v4(struct bkey_s_c k, str
 
 	return ret;
 slowpath:
-	__bch2_alloc_to_v4(k, convert);
+	return __bch2_alloc_to_v4(trans, k);
+}
+
+static inline const struct bch_alloc_v4 *bch2_alloc_to_v4_onstack(struct bkey_s_c k, struct bch_alloc_v4 *convert)
+{
+	const struct bch_alloc_v4 *ret;
+
+	if (unlikely(k.k->type != KEY_TYPE_alloc_v4))
+		goto slowpath;
+
+	ret = bkey_s_c_to_alloc_v4(k).v;
+	if (BCH_ALLOC_V4_BACKPOINTERS_START(ret) != BCH_ALLOC_V4_U64s)
+		goto slowpath;
+
+	return ret;
+slowpath:
+	__bch2_alloc_to_v4_copy(k, convert);
 	return convert;
 }
 
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 5c824b368fe2..8f96f3231214 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -333,8 +333,11 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 			continue;
 		}
 
-		struct bch_alloc_v4 a_convert;
-		const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &a_convert);
+		const struct bch_alloc_v4 *a = bch2_alloc_to_v4(trans, k);
+		ret = PTR_ERR_OR_ZERO(a);
+		if (unlikely(ret))
+			break;
+
 		if (a->data_type != BCH_DATA_free)
 			continue;
 
@@ -344,7 +347,13 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 		if (ret)
 			break;
 
-		a = bch2_alloc_to_v4(ck, &a_convert);
+		a = bch2_alloc_to_v4(trans, ck);
+		ret = PTR_ERR_OR_ZERO(a);
+		if (unlikely(ret)) {
+			bch2_trans_iter_exit(trans, &citer);
+			break;
+		}
+
 		if (a->data_type != BCH_DATA_free)
 			goto next;
 
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index e177f0980ead..849658c7896b 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -807,7 +807,7 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 {
 	struct bch_fs *c = trans->c;
 	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(alloc_k, &a_convert);
 	bool need_commit = false;
 
 	if (a->data_type == BCH_DATA_sb ||
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index e05cc02274be..d17da7e4f5ed 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -806,7 +806,7 @@ static int bch2_alloc_write_key(struct btree_trans *trans,
 	if (!bucket_valid(ca, k.k->p.offset))
 		return 0;
 
-	old = bch2_alloc_to_v4(k, &old_convert);
+	old = bch2_alloc_to_v4_onstack(k, &old_convert);
 	gc = new = *old;
 
 	__bucket_m_to_alloc(&gc, *gc_bucket(ca, iter->pos.offset));
@@ -1119,7 +1119,7 @@ static int bch2_alloc_write_oldest_gen(struct btree_trans *trans, struct bch_dev
 				       struct btree_iter *iter, struct bkey_s_c k)
 {
 	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(k, &a_convert);
 	struct bkey_i_alloc_v4 *a_mut;
 	int ret;
 
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index a65c90bdd425..16cca83e504e 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2092,7 +2092,7 @@ struct ec_stripe_head *bch2_ec_stripe_head_get(struct btree_trans *trans,
 static int bch2_invalidate_stripe_to_dev(struct btree_trans *trans, struct bkey_s_c k_a)
 {
 	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k_a, &a_convert);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(k_a, &a_convert);
 
 	if (!a->stripe)
 		return 0;
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index a299d9ec8ee4..d1cf83f92459 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -139,12 +139,17 @@ static u64 bkey_lru_type_idx(struct bch_fs *c,
 	struct bch_alloc_v4 a_convert;
 	const struct bch_alloc_v4 *a;
 
+	/*
+	 * XXX: if we ever start calling bch2_check_lru_key() at runtime, not
+	 * just during fsck, this needs tobe converted to bch2_alloc_to_v4()
+	 */
+
 	switch (type) {
 	case BCH_LRU_read:
-		a = bch2_alloc_to_v4(k, &a_convert);
+		a = bch2_alloc_to_v4_onstack(k, &a_convert);
 		return alloc_lru_idx_read(*a);
 	case BCH_LRU_fragmentation: {
-		a = bch2_alloc_to_v4(k, &a_convert);
+		a = bch2_alloc_to_v4_onstack(k, &a_convert);
 
 		rcu_read_lock();
 		struct bch_dev *ca = bch2_dev_rcu_noerror(c, k.k->p.inode);
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 5126c870ce5b..962055341352 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -94,7 +94,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 		goto out_put;
 
 	struct bch_alloc_v4 _a;
-	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &_a);
+	const struct bch_alloc_v4 *a = bch2_alloc_to_v4_onstack(k, &_a);
 	b->k.gen	= a->gen;
 	b->sectors	= bch2_bucket_sectors_dirty(*a);
 	u64 lru_idx	= alloc_lru_idx_fragmentation(*a, ca);
-- 
2.49.0

