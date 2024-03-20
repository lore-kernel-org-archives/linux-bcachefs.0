Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B9F2207A
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 06:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710916195; cv=none; b=ABx/46N4NLdhXMuKwlzxBHqdvYv6nT1oHDrhliD8xS7DRrAe33MV4APdIeLfMeu6fluuVad3LotfRHMZ2BHjr/1XgTOEe4kcZ/J/18iHOq5hWfCeFCjBnUdrRvkYCHE6s+nMloUtra4FAyORx4NrXj3W9EwoLiITu6xwq99DjXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710916195; c=relaxed/simple;
	bh=yrubQoxoD40vSRD5THJIYgrSOjCF1HvFnJW0obTYVpA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjgVNuODfzfmwlYFJpLiH62242I6TW6ZMGrW1uv5SiIr3QHV/HB7Jgx44vnfa2lSt9k3Zg0uXgUjbf/tCMHojwjOpin/lo1gs0S18sTvxPA1q2To6I6PO4VzhNPzs6N9MV7curQdR+3DbcipQhvZd3x1B7mudNLMwRs9aBXl+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4TzzFW0TCmz1vx93;
	Wed, 20 Mar 2024 14:29:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 469E21A016C;
	Wed, 20 Mar 2024 14:29:49 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Wed, 20 Mar
 2024 14:29:49 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <kent.overstreet@linux.dev>, <bfoster@redhat.com>
CC: <linux-bcachefs@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH RFC 1/2] bcachefs: use btree_path_state to represent btree_path status
Date: Wed, 20 Mar 2024 14:29:22 +0800
Message-ID: <20240320062923.305431-2-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240320062923.305431-1-lihongbo22@huawei.com>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)

First, the old structure cannot clearly represent the state changes
of btree_path (such as BTREE_ITER_xxx). Secondly, the member (
btree_path->uptodate) cannot express its purpose intuitively. It's
essentially a state value if I understand correctly. Using this way
can makes the representation of member variables more reasonable.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 fs/bcachefs/btree_iter.c         | 22 +++++++++++-----------
 fs/bcachefs/btree_iter.h         |  6 +++---
 fs/bcachefs/btree_key_cache.c    | 12 ++++++------
 fs/bcachefs/btree_locking.c      | 14 +++++++-------
 fs/bcachefs/btree_locking.h      |  8 ++++----
 fs/bcachefs/btree_trans_commit.c |  2 +-
 fs/bcachefs/btree_types.h        | 10 +++++-----
 7 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 51bcdc6c6d1c..2202b3571c81 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -693,7 +693,7 @@ void bch2_trans_node_add(struct btree_trans *trans,
 	for (;
 	     path && btree_path_pos_in_node(path, b);
 	     path = next_btree_path(trans, path))
-		if (path->uptodate == BTREE_ITER_UPTODATE && !path->cached) {
+		if (path->status == UPTODATE && !path->cached) {
 			enum btree_node_locked_type t =
 				btree_lock_want(path, b->c.level);
 
@@ -1007,7 +1007,7 @@ static int bch2_btree_path_traverse_all(struct btree_trans *trans)
 		 * Traversing a path can cause another path to be added at about
 		 * the same position:
 		 */
-		if (trans->paths[idx].uptodate) {
+		if (trans->paths[idx].status) {
 			__btree_path_get(&trans->paths[idx], false);
 			ret = bch2_btree_path_traverse_one(trans, idx, 0, _THIS_IP_);
 			__btree_path_put(&trans->paths[idx], false);
@@ -1024,7 +1024,7 @@ static int bch2_btree_path_traverse_all(struct btree_trans *trans)
 
 	/*
 	 * We used to assert that all paths had been traversed here
-	 * (path->uptodate < BTREE_ITER_NEED_TRAVERSE); however, since
+	 * (path->status < NEED_TRAVERSE); however, since
 	 * path->should_be_locked is not set yet, we might have unlocked and
 	 * then failed to relock a path - that's fine.
 	 */
@@ -1068,7 +1068,7 @@ static void btree_path_set_level_down(struct btree_trans *trans,
 		if (btree_lock_want(path, l) == BTREE_NODE_UNLOCKED)
 			btree_node_unlock(trans, path, l);
 
-	btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+	btree_path_set_dirty(path, NEED_TRAVERSE);
 	bch2_btree_path_verify(trans, path);
 }
 
@@ -1180,7 +1180,7 @@ int bch2_btree_path_traverse_one(struct btree_trans *trans,
 		}
 	}
 out_uptodate:
-	path->uptodate = BTREE_ITER_UPTODATE;
+	path->status = UPTODATE;
 out:
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart) != !!trans->restarted)
 		panic("ret %s (%i) trans->restarted %s (%i)\n",
@@ -1245,7 +1245,7 @@ __bch2_btree_path_set_pos(struct btree_trans *trans,
 	if (unlikely(path->cached)) {
 		btree_node_unlock(trans, path, 0);
 		path->l[0].b = ERR_PTR(-BCH_ERR_no_btree_node_up);
-		btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+		btree_path_set_dirty(path, NEED_TRAVERSE);
 		goto out;
 	}
 
@@ -1274,7 +1274,7 @@ __bch2_btree_path_set_pos(struct btree_trans *trans,
 	}
 
 	if (unlikely(level != path->level)) {
-		btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+		btree_path_set_dirty(path, NEED_TRAVERSE);
 		__bch2_btree_path_unlock(trans, path);
 	}
 out:
@@ -1631,7 +1631,7 @@ btree_path_idx_t bch2_path_get(struct btree_trans *trans,
 		path->pos			= pos;
 		path->btree_id			= btree_id;
 		path->cached			= cached;
-		path->uptodate			= BTREE_ITER_NEED_TRAVERSE;
+		path->status			= NEED_TRAVERSE;
 		path->should_be_locked		= false;
 		path->level			= level;
 		path->locks_want		= locks_want;
@@ -1675,7 +1675,7 @@ struct bkey_s_c bch2_btree_path_peek_slot(struct btree_path *path, struct bkey *
 	if (unlikely(!l->b))
 		return bkey_s_c_null;
 
-	EBUG_ON(path->uptodate != BTREE_ITER_UPTODATE);
+	EBUG_ON(path->status != UPTODATE);
 	EBUG_ON(!btree_node_locked(path, path->level));
 
 	if (!path->cached) {
@@ -1811,7 +1811,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
 		__bch2_btree_path_unlock(trans, path);
 		path->l[path->level].b		= ERR_PTR(-BCH_ERR_no_btree_node_relock);
 		path->l[path->level + 1].b	= ERR_PTR(-BCH_ERR_no_btree_node_relock);
-		btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+		btree_path_set_dirty(path, NEED_TRAVERSE);
 		trace_and_count(trans->c, trans_restart_relock_next_node, trans, _THIS_IP_, path);
 		ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_relock);
 		goto err;
@@ -1849,7 +1849,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
 					iter->flags & BTREE_ITER_INTENT,
 					btree_iter_ip_allocated(iter));
 	btree_path_set_should_be_locked(btree_iter_path(trans, iter));
-	EBUG_ON(btree_iter_path(trans, iter)->uptodate);
+	EBUG_ON(btree_iter_path(trans, iter)->status);
 out:
 	bch2_btree_iter_verify_entry_exit(iter);
 	bch2_btree_iter_verify(iter);
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 24772538e4cc..c76070494284 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -28,9 +28,9 @@ static inline bool __btree_path_put(struct btree_path *path, bool intent)
 }
 
 static inline void btree_path_set_dirty(struct btree_path *path,
-					enum btree_path_uptodate u)
+					enum btree_path_state u)
 {
-	path->uptodate = max_t(unsigned, path->uptodate, u);
+	path->status = max_t(unsigned, path->status, u);
 }
 
 static inline struct btree *btree_path_node(struct btree_path *path,
@@ -219,7 +219,7 @@ int __must_check bch2_btree_path_traverse_one(struct btree_trans *,
 static inline int __must_check bch2_btree_path_traverse(struct btree_trans *trans,
 					  btree_path_idx_t path, unsigned flags)
 {
-	if (trans->paths[path].uptodate < BTREE_ITER_NEED_RELOCK)
+	if (trans->paths[path].status < NEED_RELOCK)
 		return 0;
 
 	return bch2_btree_path_traverse_one(trans, path, flags, _RET_IP_);
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 581edcb0911b..47cf735f24a0 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -511,12 +511,12 @@ bch2_btree_path_traverse_cached_slowpath(struct btree_trans *trans, struct btree
 	path->l[0].lock_seq	= six_lock_seq(&ck->c.lock);
 	path->l[0].b		= (void *) ck;
 fill:
-	path->uptodate = BTREE_ITER_UPTODATE;
+	path->status = UPTODATE;
 
 	if (!ck->valid && !(flags & BTREE_ITER_CACHED_NOFILL)) {
 		/*
 		 * Using the underscore version because we haven't set
-		 * path->uptodate yet:
+		 * path->status yet:
 		 */
 		if (!path->locks_want &&
 		    !__bch2_btree_path_upgrade(trans, path, 1, NULL)) {
@@ -533,18 +533,18 @@ bch2_btree_path_traverse_cached_slowpath(struct btree_trans *trans, struct btree
 		if (ret)
 			goto err;
 
-		path->uptodate = BTREE_ITER_UPTODATE;
+		path->status = UPTODATE;
 	}
 
 	if (!test_bit(BKEY_CACHED_ACCESSED, &ck->flags))
 		set_bit(BKEY_CACHED_ACCESSED, &ck->flags);
 
 	BUG_ON(btree_node_locked_type(path, 0) != btree_lock_want(path, 0));
-	BUG_ON(path->uptodate);
+	BUG_ON(path->status);
 
 	return ret;
 err:
-	path->uptodate = BTREE_ITER_NEED_TRAVERSE;
+	path->status = NEED_TRAVERSE;
 	if (!bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
 		btree_node_unlock(trans, path, 0);
 		path->l[0].b = ERR_PTR(ret);
@@ -600,7 +600,7 @@ int bch2_btree_path_traverse_cached(struct btree_trans *trans, struct btree_path
 	if (!test_bit(BKEY_CACHED_ACCESSED, &ck->flags))
 		set_bit(BKEY_CACHED_ACCESSED, &ck->flags);
 
-	path->uptodate = BTREE_ITER_UPTODATE;
+	path->status = UPTODATE;
 	EBUG_ON(!ck->valid);
 	EBUG_ON(btree_node_locked_type(path, 0) != btree_lock_want(path, 0));
 
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index b9b151e693ed..8d8e3207ca7a 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -462,7 +462,7 @@ void bch2_btree_node_lock_write_nofail(struct btree_trans *trans,
 		for (i = 0; i < BTREE_MAX_DEPTH; i++)
 			if (btree_node_read_locked(linked, i)) {
 				btree_node_unlock(trans, linked, i);
-				btree_path_set_dirty(linked, BTREE_ITER_NEED_RELOCK);
+				btree_path_set_dirty(linked, NEED_RELOCK);
 			}
 	}
 
@@ -505,7 +505,7 @@ static inline bool btree_path_get_locks(struct btree_trans *trans,
 	 */
 	if (fail_idx >= 0) {
 		__bch2_btree_path_unlock(trans, path);
-		btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+		btree_path_set_dirty(path, NEED_TRAVERSE);
 
 		do {
 			path->l[fail_idx].b = upgrade
@@ -515,12 +515,12 @@ static inline bool btree_path_get_locks(struct btree_trans *trans,
 		} while (fail_idx >= 0);
 	}
 
-	if (path->uptodate == BTREE_ITER_NEED_RELOCK)
-		path->uptodate = BTREE_ITER_UPTODATE;
+	if (path->status == NEED_RELOCK)
+		path->status = UPTODATE;
 
 	bch2_trans_verify_locks(trans);
 
-	return path->uptodate < BTREE_ITER_NEED_RELOCK;
+	return path->status < NEED_RELOCK;
 }
 
 bool __bch2_btree_node_relock(struct btree_trans *trans,
@@ -621,7 +621,7 @@ int bch2_btree_path_relock_intent(struct btree_trans *trans,
 	     l++) {
 		if (!bch2_btree_node_relock(trans, path, l)) {
 			__bch2_btree_path_unlock(trans, path);
-			btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+			btree_path_set_dirty(path, NEED_TRAVERSE);
 			trace_and_count(trans->c, trans_restart_relock_path_intent, trans, _RET_IP_, path);
 			return btree_trans_restart(trans, BCH_ERR_transaction_restart_relock_path_intent);
 		}
@@ -865,7 +865,7 @@ void bch2_btree_path_verify_locks(struct btree_path *path)
 	unsigned l;
 
 	if (!path->nodes_locked) {
-		BUG_ON(path->uptodate == BTREE_ITER_UPTODATE &&
+		BUG_ON(path->status == UPTODATE &&
 		       btree_path_node(path, path->level));
 		return;
 	}
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index 4bd72c855da1..f3f03292a675 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -157,7 +157,7 @@ static inline int btree_path_highest_level_locked(struct btree_path *path)
 static inline void __bch2_btree_path_unlock(struct btree_trans *trans,
 					    struct btree_path *path)
 {
-	btree_path_set_dirty(path, BTREE_ITER_NEED_RELOCK);
+	btree_path_set_dirty(path, NEED_RELOCK);
 
 	while (path->nodes_locked)
 		btree_node_unlock(trans, path, btree_path_lowest_level_locked(path));
@@ -371,7 +371,7 @@ static inline int bch2_btree_path_upgrade(struct btree_trans *trans,
 
 	if (path->locks_want < new_locks_want
 	    ? __bch2_btree_path_upgrade(trans, path, new_locks_want, &f)
-	    : path->uptodate == BTREE_ITER_UPTODATE)
+	    : path->status == UPTODATE)
 		return 0;
 
 	trace_and_count(trans->c, trans_restart_upgrade, trans, _THIS_IP_, path,
@@ -384,7 +384,7 @@ static inline int bch2_btree_path_upgrade(struct btree_trans *trans,
 static inline void btree_path_set_should_be_locked(struct btree_path *path)
 {
 	EBUG_ON(!btree_node_locked(path, path->level));
-	EBUG_ON(path->uptodate);
+	EBUG_ON(path->status);
 
 	path->should_be_locked = true;
 }
@@ -401,7 +401,7 @@ static inline void btree_path_set_level_up(struct btree_trans *trans,
 				    struct btree_path *path)
 {
 	__btree_path_set_level_up(trans, path, path->level++);
-	btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+	btree_path_set_dirty(path, NEED_TRAVERSE);
 }
 
 /* debug */
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 30d69a6d133e..0c94a885b567 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -745,7 +745,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 			bch2_btree_insert_key_cached(trans, flags, i);
 		else {
 			bch2_btree_key_cache_drop(trans, path);
-			btree_path_set_dirty(path, BTREE_ITER_NEED_TRAVERSE);
+			btree_path_set_dirty(path, NEED_TRAVERSE);
 		}
 	}
 
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 9404d96c38f3..7146d6cf9fba 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -218,10 +218,10 @@ static const __maybe_unused u16 BTREE_ITER_CACHED_NOFILL	= 1 << 13;
 static const __maybe_unused u16 BTREE_ITER_KEY_CACHE_FILL	= 1 << 14;
 #define __BTREE_ITER_FLAGS_END					       15
 
-enum btree_path_uptodate {
-	BTREE_ITER_UPTODATE		= 0,
-	BTREE_ITER_NEED_RELOCK		= 1,
-	BTREE_ITER_NEED_TRAVERSE	= 2,
+enum btree_path_state {
+        UPTODATE		= 0,
+        NEED_RELOCK		= 1,
+        NEED_TRAVERSE		= 2
 };
 
 #if defined(CONFIG_BCACHEFS_LOCK_TIME_STATS) || defined(CONFIG_BCACHEFS_DEBUG)
@@ -241,7 +241,7 @@ struct btree_path {
 	enum btree_id		btree_id:5;
 	bool			cached:1;
 	bool			preserve:1;
-	enum btree_path_uptodate uptodate:2;
+	enum btree_path_state   status:2;
 	/*
 	 * When true, failing to relock this path will cause the transaction to
 	 * restart:
-- 
2.34.1

