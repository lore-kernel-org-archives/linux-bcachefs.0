Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9086726AEA
	for <linux-bcachefs@vger.kernel.org>; Sun, 30 Jun 2024 05:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719724509; cv=none; b=aqweyjvVTOOKy6UXAKFnSZdCzJ80tCpOot0MRqWcbiE/wrSaskQdEDlR7v/KpISO5yxE21zV79NOlrxOjU0McupkCauUa51CDbu+WzZyXLvhVwYxCKg74eBabXwIdiJi9TOK2SGYdI38qc+khEMlApvl+h/j5ZNHOwWXOmZVS3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719724509; c=relaxed/simple;
	bh=nG0PfmfDtwvyMJl0dlQwoeobItCuj+pN3jlYGbFPxbY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nu1p4m27zxdP+r9mhYgavcKK/eU58jmhUOcJnABsfbi2QyPXd1QE7oKwxdh7g/9dHJtQMYFvREgHZGXGhOf8LywoEbAyEbwoAGjIUhgAHMrsjJHZIIKgsYyK/a1sWvHD5xOJxpuWkkdMFsQIaROBlMpA19ieIrcSsHfGR5bRS1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WowXCZQc; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WowXCZQc"
X-Envelope-To: linux-bcachefs@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719724505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JpYXP9cpz6RanT/cOhSwyKajEz83pDUVSCOVXhqXonE=;
	b=WowXCZQcHcvxq8fRf8P01Gc+fOR57LuJ5WP0oZvCgcidkY62uc1ZKnCvpKWPj4CnwDlTbZ
	mDvTMbDYRFBvpZMV3M8ZxnzQ2SQmVpEZfsNN0Ry7sGmV6NMjzdIbfpY0OfV5QKu7ygT9HA
	RTKCl5KJfN3r1lj32GCEO2NnqlgUa7Y=
X-Envelope-To: kent.overstreet@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Add lockdep support for btree node locks
Date: Sun, 30 Jun 2024 01:14:58 -0400
Message-ID: <20240630051458.2786201-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This adds lockdep tracking for held btree locks with a single dep_map in
btree_trans, i.e. tracking all held btree locks as one object.

This is more practical and more useful than having lockdep track held
btree locks individually, because
 - we can take more locks than lockdep can track (unbounded, now that we
   have dynamically resizable btree paths)
 - there's no lock ordering between btree locks for lockdep to track (we
   do cycle detection)
 - and this makes it easy to teach lockdep that btree locks are not safe
   to hold while invoking memory reclaim.

The last rule is one that lockdep would never learn, because we only do
trylock() from within shrinkers - but we very much do not want to be
invoking memory reclaim while holding btree node locks.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c    | 30 ++++++++++++++++++++++++------
 fs/bcachefs/btree_locking.c |  8 ++++++++
 fs/bcachefs/btree_locking.h | 14 ++++++++++++--
 fs/bcachefs/btree_types.h   |  3 +++
 4 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 80f4a39592b4..eca7634cc423 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -987,7 +987,7 @@ static int bch2_btree_path_traverse_all(struct btree_trans *trans)
 
 	bch2_trans_unlock(trans);
 	cond_resched();
-	trans->locked = true;
+	trans_set_locked(trans);
 	trans->last_unlock_ip = 0;
 
 	if (unlikely(trans->memory_allocation_failure)) {
@@ -3088,8 +3088,8 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 		bch2_trans_srcu_unlock(trans);
 
 	trans->last_begin_ip = _RET_IP_;
-	trans->locked  = true;
-	trans->last_unlock_ip = 0;
+
+	trans_set_locked(trans);
 
 	if (trans->restarted) {
 		bch2_btree_path_traverse_all(trans);
@@ -3173,6 +3173,12 @@ struct btree_trans *__bch2_trans_get(struct bch_fs *c, unsigned fn_idx)
 
 	trans->paths_allocated[0] = 1;
 
+	static struct lock_class_key lockdep_key;
+	lockdep_init_map(&trans->dep_map, "bcachefs_btree", &lockdep_key, 0);
+
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lock_acquire_exclusive(&trans->dep_map, 0, 0, NULL, _THIS_IP_);
+
 	if (fn_idx < BCH_TRANSACTIONS_NR) {
 		trans->fn = bch2_btree_transaction_fns[fn_idx];
 
@@ -3441,7 +3447,19 @@ int bch2_fs_btree_iter_init(struct bch_fs *c)
 		mempool_init_kmalloc_pool(&c->btree_trans_mem_pool, 1,
 					  BTREE_TRANS_MEM_MAX) ?:
 		init_srcu_struct(&c->btree_trans_barrier);
-	if (!ret)
-		c->btree_trans_barrier_initialized = true;
-	return ret;
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_LOCKDEP
+	fs_reclaim_acquire(GFP_KERNEL);
+	struct btree_trans *trans = bch2_trans_get(c);
+	lock_acquire_exclusive(&trans->dep_map, 0, 0, NULL, _THIS_IP_);
+	trans->locked = true;
+	bch2_trans_put(trans);
+	fs_reclaim_release(GFP_KERNEL);
+#endif
+
+	c->btree_trans_barrier_initialized = true;
+	return 0;
+
 }
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 16834a6b4c3d..2fdd95359a04 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -792,6 +792,8 @@ static inline int __bch2_trans_relock(struct btree_trans *trans, bool trace)
 			return bch2_trans_relock_fail(trans, path, &f, trace);
 	}
 
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		lock_acquire_exclusive(&trans->dep_map, 0, 0, NULL, _THIS_IP_);
 	trans->locked = true;
 	trans->last_unlock_ip = 0;
 out:
@@ -813,6 +815,9 @@ void bch2_trans_unlock_noassert(struct btree_trans *trans)
 {
 	__bch2_trans_unlock(trans);
 
+	if (trans->locked && IS_ENABLED(CONFIG_LOCKDEP))
+		lock_release(&trans->dep_map, _THIS_IP_);
+
 	trans->locked = false;
 	trans->last_unlock_ip = _RET_IP_;
 }
@@ -821,6 +826,9 @@ void bch2_trans_unlock(struct btree_trans *trans)
 {
 	__bch2_trans_unlock(trans);
 
+	if (trans->locked && IS_ENABLED(CONFIG_LOCKDEP))
+		lock_release(&trans->dep_map, _THIS_IP_);
+
 	trans->locked = false;
 	trans->last_unlock_ip = _RET_IP_;
 }
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index 2530fdb29b15..af7b3d663a65 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -194,19 +194,29 @@ int bch2_six_check_for_deadlock(struct six_lock *lock, void *p);
 
 /* lock: */
 
+static inline void trans_set_locked(struct btree_trans *trans)
+{
+	if (!trans->locked) {
+		if (IS_ENABLED(CONFIG_LOCKDEP))
+			lock_acquire_exclusive(&trans->dep_map, 0, 0, NULL, _THIS_IP_);
+		trans->locked = true;
+		trans->last_unlock_ip = 0;
+	}
+}
+
 static inline int __btree_node_lock_nopath(struct btree_trans *trans,
 					 struct btree_bkey_cached_common *b,
 					 enum six_lock_type type,
 					 bool lock_may_not_fail,
 					 unsigned long ip)
 {
-	int ret;
+	trans_set_locked(trans);
 
 	trans->lock_may_not_fail = lock_may_not_fail;
 	trans->lock_must_abort	= false;
 	trans->locking		= b;
 
-	ret = six_lock_ip_waiter(&b->lock, type, &trans->locking_wait,
+	int ret = six_lock_ip_waiter(&b->lock, type, &trans->locking_wait,
 				 bch2_six_check_for_deadlock, trans, ip);
 	WRITE_ONCE(trans->locking, NULL);
 	WRITE_ONCE(trans->locking_wait.start_time, 0);
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index c9c9864a87b0..994e45c8dbeb 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -522,6 +522,9 @@ struct btree_trans {
 	unsigned		journal_u64s;
 	unsigned		extra_disk_res; /* XXX kill */
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
 	/* Entries before this are zeroed out on every bch2_trans_get() call */
 
 	struct list_head	list;
-- 
2.45.2

