Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA55103F
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739299; cv=none; b=GrXreA61ujEEDiDqQEUuUGEi2SShUzWDR7BlqLJB6apvxyuD/AfN9gXojspW+dk9g10MM4wppcs7T6Ka1qGou5ST/vjcjigT/N6fnr67vvS8jIWXuusLE0JaSgsOL//8czcFKIRuNrNsc/B0HqgMcy5TzepI3zphREK1hD9blWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739299; c=relaxed/simple;
	bh=rCgdA5h9o64QPYJe/LdHq9c1hWzFfB03TmBuwa8Lqxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2fyGD8qQE/+5vsOdESygD1vwYUlWRUI7Q5dvyqX3c4nrJT6/I1itTweYSRLt/C8R90z4RYLmpMkN5DfdwQpkMB+nOJFJPxzluhq/p85u1z9ShsmdkAtuEsh4T38I/PYkTMI2s7j0wiXh+KLPtXEq/AthMbvxiSOYWALaXsBaAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g1uZ8dLa; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g1uZ8dLa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739294;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5URM19eSwmYeFMcFn+bjBlfbZxAhdFqNyWIqQG7Vz0I=;
	b=g1uZ8dLaea+h0AtAQsK6loDaFwER3+KMGXUr61snkKSL0W/aSyV3x0WFoI2C0tKqb/ZsaX
	HmFQZaTRh5rmd5PEfprqarg5+OxZfP4k9wgmInm3fTG9ArElRr+Dfdp9PbNsygEUK6ymAP
	X6vK150DnyLINfxFP6uYBUHv5EYBchw=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/8] bcachefs: Move cycle detector state to btree_trans
Date: Sun, 23 Mar 2025 10:14:39 -0400
Message-ID: <20250323141445.566595-6-kent.overstreet@linux.dev>
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

We need to prune our stack usage; this saves 260 bytes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_locking.c       | 43 +++++++++----------------------
 fs/bcachefs/btree_locking_types.h | 28 ++++++++++++++++++++
 fs/bcachefs/btree_types.h         |  2 ++
 3 files changed, 42 insertions(+), 31 deletions(-)
 create mode 100644 fs/bcachefs/btree_locking_types.h

diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
index 94eb2b73a843..5e28f8c80670 100644
--- a/fs/bcachefs/btree_locking.c
+++ b/fs/bcachefs/btree_locking.c
@@ -51,25 +51,6 @@ void bch2_btree_node_unlock_write(struct btree_trans *trans,
 
 /* lock */
 
-/*
- * @trans wants to lock @b with type @type
- */
-struct trans_waiting_for_lock {
-	struct btree_trans		*trans;
-	struct btree_bkey_cached_common	*node_want;
-	enum six_lock_type		lock_want;
-
-	/* for iterating over held locks :*/
-	u8				path_idx;
-	u8				level;
-	u64				lock_start_time;
-};
-
-struct lock_graph {
-	struct trans_waiting_for_lock	g[8];
-	unsigned			nr;
-};
-
 static noinline void print_cycle(struct printbuf *out, struct lock_graph *g)
 {
 	struct trans_waiting_for_lock *i;
@@ -288,33 +269,33 @@ static bool lock_type_conflicts(enum six_lock_type t1, enum six_lock_type t2)
 
 int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 {
-	struct lock_graph g;
+	struct lock_graph *g = &trans->cycle_detector_graph;
 	struct trans_waiting_for_lock *top;
 	struct btree_bkey_cached_common *b;
 	btree_path_idx_t path_idx;
 	int ret = 0;
 
-	g.nr = 0;
+	g->nr = 0;
 
 	if (trans->lock_must_abort && !trans->lock_may_not_fail) {
 		if (cycle)
 			return -1;
 
-		trace_would_deadlock(&g, trans);
+		trace_would_deadlock(g, trans);
 		return btree_trans_restart(trans, BCH_ERR_transaction_restart_would_deadlock);
 	}
 
-	lock_graph_down(&g, trans);
+	lock_graph_down(g, trans);
 
 	/* trans->paths is rcu protected vs. freeing */
 	rcu_read_lock();
 	if (cycle)
 		cycle->atomic++;
 next:
-	if (!g.nr)
+	if (!g->nr)
 		goto out;
 
-	top = &g.g[g.nr - 1];
+	top = &g->g[g->nr - 1];
 
 	struct btree_path *paths = rcu_dereference(top->trans->paths);
 	if (!paths)
@@ -351,7 +332,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 				 * structures - which means it can't be blocked
 				 * waiting on a lock:
 				 */
-				if (!lock_graph_remove_non_waiters(&g, g.g)) {
+				if (!lock_graph_remove_non_waiters(g, g->g)) {
 					/*
 					 * If lock_graph_remove_non_waiters()
 					 * didn't do anything, it must be
@@ -361,7 +342,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 					 * aren't actually waiting on anything.
 					 * Just bail out:
 					 */
-					lock_graph_pop_all(&g);
+					lock_graph_pop_all(g);
 				}
 
 				goto next;
@@ -388,7 +369,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 				closure_get(&trans->ref);
 				raw_spin_unlock(&b->lock.wait_lock);
 
-				ret = lock_graph_descend(&g, trans, cycle);
+				ret = lock_graph_descend(g, trans, cycle);
 				if (ret)
 					goto out;
 				goto next;
@@ -398,9 +379,9 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
 		}
 	}
 up:
-	if (g.nr > 1 && cycle)
-		print_chain(cycle, &g);
-	lock_graph_up(&g);
+	if (g->nr > 1 && cycle)
+		print_chain(cycle, g);
+	lock_graph_up(g);
 	goto next;
 out:
 	if (cycle)
diff --git a/fs/bcachefs/btree_locking_types.h b/fs/bcachefs/btree_locking_types.h
new file mode 100644
index 000000000000..94c07e2bc5ea
--- /dev/null
+++ b/fs/bcachefs/btree_locking_types.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_BTREE_LOCKING_TYPES_H
+#define _BCACHEFS_BTREE_LOCKING_TYPES_H
+
+#include "six.h"
+
+/* State used for the cycle detector */
+
+/*
+ * @trans wants to lock @b with type @type
+ */
+struct trans_waiting_for_lock {
+	struct btree_trans		*trans;
+	struct btree_bkey_cached_common	*node_want;
+	enum six_lock_type		lock_want;
+
+	/* for iterating over held locks :*/
+	u8				path_idx;
+	u8				level;
+	u64				lock_start_time;
+};
+
+struct lock_graph {
+	struct trans_waiting_for_lock	g[6];
+	unsigned			nr;
+};
+
+#endif /* _BCACHEFS_BTREE_LOCKING_TYPES_H */
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 023c472dc9ee..f467a15378b5 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -7,6 +7,7 @@
 
 #include "bbpos_types.h"
 #include "btree_key_cache_types.h"
+#include "btree_locking_types.h"
 #include "buckets_types.h"
 #include "darray.h"
 #include "errcode.h"
@@ -526,6 +527,7 @@ struct btree_trans {
 	struct btree_bkey_cached_common *locking;
 	struct six_lock_waiter	locking_wait;
 	int			srcu_idx;
+	struct lock_graph	cycle_detector_graph;
 
 	/* update path: */
 	u16			journal_entries_u64s;
-- 
2.49.0

