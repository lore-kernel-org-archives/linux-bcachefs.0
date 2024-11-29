Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052D414D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912097; cv=none; b=EVB6auLYBNl6lrJ+xAxehfObpJhGckNJQ0O5kU04Zn3Q09Z5X/9zwBG0i1oYCyKSOy9CdzyQD9BYQO3r/eTGcZ18ZK6176HoCXrRJyiEnmqpTOHs9i5bTokLQ6EzMbNY5KkEQLQrihxoOpCHCX7Srv9vTNa3JrMVokRivqMnKN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912097; c=relaxed/simple;
	bh=yFssJBlD5vgXlaEvqdsc0eVqfwlHbYFtFX0pYRE+eNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugZtsBKhooqDtfz9TrcsPMYXKkp6UGm+5ifuqzOMj9byzXP7goqElqzvQwCuUw8ow0oDSBZyjccL0SrYDqPcwP/PK/QRKb20KnoYnwmQmzXg7yIoMxstu0pINoIaN9tAz7QB3TeWA/FpsLKsmbyK7wK1HssxCASrallgojc9S2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+e088be3c2d5c05aaac35@syzkaller.appspotmail.com
Subject: [PATCH 32/34] bcachefs: bch2_trans_relock() is trylock for lockdep
Date: Fri, 29 Nov 2024 15:27:31 -0500
Message-ID: <20241129202736.2713679-33-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

fix some spurious lockdep splats

Reported-by: syzbot+e088be3c2d5c05aaac35@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.c    | 8 ++++----
 fs/bcachefs/btree_locking.c | 2 +-
 fs/bcachefs/btree_locking.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 80c3b55ce763..9c54891c737a 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -1007,7 +1007,7 @@ static int bch2_btree_path_traverse_all(struct btree_trans *trans)
 
 	bch2_trans_unlock(trans);
 	cond_resched();
-	trans_set_locked(trans);
+	trans_set_locked(trans, false);
 
 	if (unlikely(trans->memory_allocation_failure)) {
 		struct closure cl;
@@ -3248,7 +3248,7 @@ u32 bch2_trans_begin(struct btree_trans *trans)
 
 	trans->last_begin_ip = _RET_IP_;
 
-	trans_set_locked(trans);
+	trans_set_locked(trans, false);
 
 	if (trans->restarted) {
 		bch2_btree_path_traverse_all(trans);
@@ -3354,7 +3354,7 @@ struct btree_trans *__bch2_trans_get(struct bch_fs *c, unsigned fn_idx)
 	trans->srcu_idx		= srcu_read_lock(&c->btree_trans_barrier);
 	trans->srcu_lock_time	= jiffies;
 	trans->srcu_held	= true;
-	trans_set_locked(trans);
+	trans_set_locked(trans, false);
 
 	closure_init_stack_release(&trans->ref);
 	return trans;
@@ -3622,7 +3622,7 @@ int bch2_fs_btree_iter_init(struct bch_fs *c)
 #ifdef CONFIG_LOCKDEP
 	fs_reclaim_acquire(GFP_KERNEL);
 	struct btree_trans *trans = bch2_trans_get(c);
-	trans_set_locked(trans);
+	trans_set_locked(trans, false);
 	bch2_trans_put(trans);
 	fs_reclaim_release(GFP_KERNEL);
 #endif
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index efe2a007b482..d343df9f0ad2 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -782,7 +782,7 @@ static inline int __bch2_trans_relock(struct btree_trans *trans, bool trace)
 			return bch2_trans_relock_fail(trans, path, &f, trace);
 	}
 
-	trans_set_locked(trans);
+	trans_set_locked(trans, true);
 out:
 	bch2_trans_verify_locks(trans);
 	return 0;
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index ca4aeefd631e..7474ab6ce019 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -188,10 +188,10 @@ int bch2_six_check_for_deadlock(struct six_lock *lock, void *p);
 
 /* lock: */
 
-static inline void trans_set_locked(struct btree_trans *trans)
+static inline void trans_set_locked(struct btree_trans *trans, bool try)
 {
 	if (!trans->locked) {
-		lock_acquire_exclusive(&trans->dep_map, 0, 0, NULL, _THIS_IP_);
+		lock_acquire_exclusive(&trans->dep_map, 0, try, NULL, _THIS_IP_);
 		trans->locked = true;
 		trans->last_unlock_ip = 0;
 
-- 
2.45.2

