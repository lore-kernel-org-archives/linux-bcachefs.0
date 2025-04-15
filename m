Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C13E2DFA32
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 05:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744695201; cv=none; b=ulPpXei4lItPDLg8lbG06FUWx8UzWnyc1gGT27Z+l1+478nyTQwSCTHZdOOn2tVIWSIoPDIYanGypG3qvMvi/9yn1es/0R44Dk2RaBobAYB5JM2XvKdT7vMToGLkoT2fcVi4Rq480wUzkb0RHSkUWnVz/3UBiSzucyWbRtY429w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744695201; c=relaxed/simple;
	bh=Oi+VTrykXYJ6BvdD3sRs3VCJ8S/hiMImryGlKalcqAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSFrsSpnURYN3AMlZZUFOG0PM4YRgRmkQbCPxzLGAlXCaDViYCeo3L/URGXC7fBb/eMMMmWkC5uTlONWG2ooOG5S8BrDpEUL39ZPHNtsD2Bc7A36yq0HdMjD2egADBoN8sHVjgcWw6hrtMPrz/IsFTYF1XfPYPqvJB+GrTjlNiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUrzPLiB; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUrzPLiB"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-af93cd64ef3so3530614a12.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 14 Apr 2025 22:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744695199; x=1745299999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26kYfEFkCzI8CxtnQDgF22/3h5KIK35R3RzmcnIm+u8=;
        b=bUrzPLiB8Go/y66VU3DGWct5i8Q+/YgX3vjHTj9nlfEAaKqFOdG0cLIrdwn6h7WGsd
         NNxuyhCuFuZ8xPBGZcBQZO9EFLMQ0NUv9ytziqdHqAo2PNcivklAkxn4okdFNyA7oWZy
         yyfjT4GdhXvOQuIhiEUOT0xPyLlxLMPzSigeg/E5tphT8cJmEKG7R11/9tI0d1wE4BHl
         3HfkgJazSTIw6imJFUbbFIqssrSqt5SuLCKMFKt3k0TgoBr+jmFxMQ7v0VIK2iCMPh70
         gDZ4Q3LhGJfP41PQbxvZsWvI8fUkzHrWF4MhTt/ft7IVRLjCGBxvDzaoHmwBye2iAsI+
         a+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744695199; x=1745299999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=26kYfEFkCzI8CxtnQDgF22/3h5KIK35R3RzmcnIm+u8=;
        b=uSGshx9S2iK0R9yfu+0oNRsia6dJ3PMQ8jgBRRkNJRnmP94MAYLfib3R7b5+F3Cp0i
         PS85tT5pjtP7wVztiZ9DgQ2PscT8i3WZGkJrmNkwD2yfI59u6loLQZA4Enld19VhhKTi
         VUgSNfZZkuss7bI57rY/XGNcPLh2TVvyAwhVzjeaaBx6JtGliCD8wfoJ2K0ZQg/vR2bb
         aAH5kgtOHf6DA82790NHS8k6yFUoFiLrlq4+1JnVdJfY6rk2TLsdn7XemBpJLnR1TQPc
         agqEp1NpU3yFh9i60kpHbXH4qCgUXrgBdxSP7HrUDVNqaU8Cr3bKqXgiuQ42f+KKIEzk
         435w==
X-Gm-Message-State: AOJu0Ywll2ye8hP32skEqUzW2AX9B3viah4NC4Nywp3mRMaYJakZI/wM
	7HZHvuKU+VjpyTxInoum0dIw2LjpPUXkEx0wCkNT4cYe4y6KhL0ZCxebAUQi
X-Gm-Gg: ASbGncvmoygkZMSw92PHsUsUg9XWwNcsyP3KO63eCIoBRaxG/a5kBQuejkxWYq1We23
	874sJj09FYH2r+hXtUMM6bGhdP0aIKLvcKiZYJZp3UlF6tJ59sq725h52fWf4PVjz5WIRaRrsq2
	gkEXGZ7HoVDZbTYgwnh8OBibIa8Vl5aKygybL5e/MznWfcIVFq8NbLX+FWKodsGGb/PqrDDtpOp
	pnm4SW8fq2+3J9EACdYrmd+L86itNtx3lgPUdgFy+Yw9eUGBTs+6+j+ZvXn16a0G2v1HsgKVLp+
	i38hiUDMetFdTkM=
X-Google-Smtp-Source: AGHT+IH20mNHFh3ZPSLrJolF3btFQR4/rFFpRhv4in8plljjvyniVT0XjeEWbu/3YaSvfQdgxFzbug==
X-Received: by 2002:a17:90a:d00d:b0:2fe:ba7f:8032 with SMTP id 98e67ed59e1d1-30823662c21mr23812493a91.9.1744695199199;
        Mon, 14 Apr 2025 22:33:19 -0700 (PDT)
Received: from localhost ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-306df401abdsm12100678a91.43.2025.04.14.22.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 22:33:18 -0700 (PDT)
From: Alan Huang <mmpgouride@gmail.com>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH 2/4] bcachefs: mark_btree_node_locked_noreset -> mark_btree_node_locked_reset
Date: Tue, 15 Apr 2025 13:33:05 +0800
Message-ID: <20250415053307.81354-3-mmpgouride@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415053307.81354-1-mmpgouride@gmail.com>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The semantic is reset now, rename the function to reflect that.

Signed-off-by: Alan Huang <mmpgouride@gmail.com>
---
 fs/bcachefs/btree_key_cache.c       |  6 +++---
 fs/bcachefs/btree_locking.c         |  6 +++---
 fs/bcachefs/btree_locking.h         | 10 +++++-----
 fs/bcachefs/btree_update_interior.c |  4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index 2b186584a291..c7ad01c1355c 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -240,7 +240,7 @@ static int btree_key_cache_create(struct btree_trans *trans,
 	ck->flags		= 1U << BKEY_CACHED_ACCESSED;
 
 	if (unlikely(key_u64s > ck->u64s)) {
-		mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
+		mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
 
 		struct bkey_i *new_k = allocate_dropping_locks(trans, ret,
 				kmalloc(key_u64s * sizeof(u64), _gfp));
@@ -282,7 +282,7 @@ static int btree_key_cache_create(struct btree_trans *trans,
 	return 0;
 err:
 	bkey_cached_free(bc, ck);
-	mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
+	mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
 
 	return ret;
 }
@@ -500,7 +500,7 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 			atomic_long_dec(&c->btree_key_cache.nr_dirty);
 		}
 
-		mark_btree_node_locked_noreset(path, 0, BTREE_NODE_UNLOCKED);
+		mark_btree_node_locked_reset(path, 0, BTREE_NODE_UNLOCKED);
 		if (bkey_cached_evict(&c->btree_key_cache, ck)) {
 			bkey_cached_free(&c->btree_key_cache, ck);
 		} else {
diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index f4f563944340..71dbac0bcd58 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -435,7 +435,7 @@ int __bch2_btree_node_lock_write(struct btree_trans *trans, struct btree_path *p
 	six_lock_readers_add(&b->lock, readers);
 
 	if (ret)
-		mark_btree_node_locked_noreset(path, b->level, BTREE_NODE_INTENT_LOCKED);
+		mark_btree_node_locked_reset(path, b->level, BTREE_NODE_INTENT_LOCKED);
 
 	return ret;
 }
@@ -564,7 +564,7 @@ bool bch2_btree_node_upgrade(struct btree_trans *trans,
 	trace_and_count(trans->c, btree_path_upgrade_fail, trans, _RET_IP_, path, level);
 	return false;
 success:
-	mark_btree_node_locked_noreset(path, level, BTREE_NODE_INTENT_LOCKED);
+	mark_btree_node_locked_reset(path, level, BTREE_NODE_INTENT_LOCKED);
 	return true;
 }
 
@@ -693,7 +693,7 @@ void __bch2_btree_path_downgrade(struct btree_trans *trans,
 		} else {
 			if (btree_node_intent_locked(path, l)) {
 				six_lock_downgrade(&path->l[l].b->c.lock);
-				mark_btree_node_locked_noreset(path, l, BTREE_NODE_READ_LOCKED);
+				mark_btree_node_locked_reset(path, l, BTREE_NODE_READ_LOCKED);
 			}
 			break;
 		}
diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
index 66b27c0853a5..8978f7969bef 100644
--- a/fs/bcachefs/btree_locking.h
+++ b/fs/bcachefs/btree_locking.h
@@ -63,7 +63,7 @@ static inline bool btree_node_locked(struct btree_path *path, unsigned level)
 	return btree_node_locked_type(path, level) != BTREE_NODE_UNLOCKED;
 }
 
-static inline void mark_btree_node_locked_noreset(struct btree_path *path,
+static inline void mark_btree_node_locked_reset(struct btree_path *path,
 						  unsigned level,
 						  enum btree_node_locked_type type)
 {
@@ -80,7 +80,7 @@ static inline void mark_btree_node_locked(struct btree_trans *trans,
 					  unsigned level,
 					  enum btree_node_locked_type type)
 {
-	mark_btree_node_locked_noreset(path, level, (enum btree_node_locked_type) type);
+	mark_btree_node_locked_reset(path, level, (enum btree_node_locked_type) type);
 #ifdef CONFIG_BCACHEFS_LOCK_TIME_STATS
 	path->l[level].lock_taken_time = local_clock();
 #endif
@@ -134,7 +134,7 @@ static inline void btree_node_unlock(struct btree_trans *trans,
 		}
 		six_unlock_type(&path->l[level].b->c.lock, lock_type);
 		btree_trans_lock_hold_time_update(trans, path, level);
-		mark_btree_node_locked_noreset(path, level, BTREE_NODE_UNLOCKED);
+		mark_btree_node_locked_reset(path, level, BTREE_NODE_UNLOCKED);
 	}
 }
 
@@ -183,7 +183,7 @@ bch2_btree_node_unlock_write_inlined(struct btree_trans *trans, struct btree_pat
 	EBUG_ON(path->l[b->c.level].lock_seq != six_lock_seq(&b->c.lock));
 	EBUG_ON(btree_node_locked_type(path, b->c.level) != SIX_LOCK_write);
 
-	mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
+	mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
 	__bch2_btree_node_unlock_write(trans, b);
 }
 
@@ -315,7 +315,7 @@ static inline int __btree_node_lock_write(struct btree_trans *trans,
 	 * write lock: thus, we need to tell the cycle detector we have a write
 	 * lock _before_ taking the lock:
 	 */
-	mark_btree_node_locked_noreset(path, b->level, BTREE_NODE_WRITE_LOCKED);
+	mark_btree_node_locked_reset(path, b->level, BTREE_NODE_WRITE_LOCKED);
 
 	return likely(six_trylock_write(&b->lock))
 		? 0
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 55fbeeb8eaaa..29e03408a019 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -245,7 +245,7 @@ static void bch2_btree_node_free_inmem(struct btree_trans *trans,
 	mutex_unlock(&c->btree_cache.lock);
 
 	six_unlock_write(&b->c.lock);
-	mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
+	mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
 
 	bch2_trans_node_drop(trans, b);
 }
@@ -788,7 +788,7 @@ static void btree_update_nodes_written(struct btree_update *as)
 
 		mutex_unlock(&c->btree_interior_update_lock);
 
-		mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
+		mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
 		six_unlock_write(&b->c.lock);
 
 		btree_node_write_if_need(trans, b, SIX_LOCK_intent);
-- 
2.48.1

