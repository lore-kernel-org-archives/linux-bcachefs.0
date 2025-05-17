Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7B2170826
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509960; cv=none; b=rjrhzsygzbxjvpAihwGZ0nG4XHZdn0vOEbr8OGh4JUL3JONVrF3GRBTTljMKSuL5zR9LbRiLljtBZTHVTCMwo6G1+IBseZ6a4ZbClGgqTlajyhI2d703v8t6m2qAafX+xRdw/jzFEyTTv8I1vkjc+rvY8x0sLYTfcIiaW27GEVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509960; c=relaxed/simple;
	bh=4MWoKPWMDlIwazHiIQTDAZjBRNf2ZChLkF0fGacZGF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isLwhVUZf35cBwNu1xhBIxcmN6aAgBBSiaj5620+dR1nHpcuqL8ae1n6iAMYmyI+vf4kpjXFK2sMNfStgHHo9/Zx5ic8eN98QTTydkXcVU4ADsarFefJ9nRHqDlFzhRVnyGirviVEpMBybqaOPWl6kkW5QOXnKEXq9IuJj1KV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wbEnoUQj; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wbEnoUQj"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5dQTcQKB+JHGTMHkaMCPh2mxynfownSBc4FeekpJ1gA=;
	b=wbEnoUQj9D2jbO5R6JASVK+B7jVPi6+iy/b2Ofgqu81AO7eGTgOrVsstJNQYbSXKor5Fu7
	Kcg93OuJ+08jduWW8birMVY7jh8DQ78hxrEAAg3lU/BIViFM7i3wgFy1OOv5xXqjsP0TAh
	wK6sT1MbYBTt3gkaY2abj+6YCT9M+7k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/8] bcachefs: struct bch_fs_recovery
Date: Sat, 17 May 2025 15:25:38 -0400
Message-ID: <20250517192547.3849149-2-kent.overstreet@linux.dev>
In-Reply-To: <20250517192547.3849149-1-kent.overstreet@linux.dev>
References: <20250517192547.3849149-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch_fs has gotten obnoxiously big, let's start organizing thins a bit
better.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c      |  2 +-
 fs/bcachefs/alloc_foreground.c      |  6 +--
 fs/bcachefs/backpointers.c          |  4 +-
 fs/bcachefs/bcachefs.h              | 17 +-------
 fs/bcachefs/btree_cache.c           |  2 +-
 fs/bcachefs/btree_io.c              |  6 +--
 fs/bcachefs/btree_update_interior.c |  2 +-
 fs/bcachefs/fsck.c                  |  8 ++--
 fs/bcachefs/movinggc.c              |  2 +-
 fs/bcachefs/rebalance.c             |  2 +-
 fs/bcachefs/recovery.c              | 10 ++---
 fs/bcachefs/recovery_passes.c       | 60 +++++++++++++++--------------
 fs/bcachefs/recovery_passes_types.h | 23 +++++++++++
 fs/bcachefs/snapshot.c              |  4 +-
 fs/bcachefs/super.c                 |  2 +-
 15 files changed, 81 insertions(+), 69 deletions(-)
 create mode 100644 fs/bcachefs/recovery_passes_types.h

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index f8d21c12c3d1..4ae2aa6ea758 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -309,7 +309,7 @@ int bch2_alloc_v4_validate(struct bch_fs *c, struct bkey_s_c k,
 				 "data type inconsistency");
 
 		bkey_fsck_err_on(!a.io_time[READ] &&
-				 c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_to_lru_refs,
+				 c->recovery.curr_pass > BCH_RECOVERY_PASS_check_alloc_to_lru_refs,
 				 c, alloc_key_cached_but_read_time_zero,
 				 "cached bucket with read_time == 0");
 		break;
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 6aefa490ec24..76641cc4c27d 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -154,7 +154,7 @@ static struct open_bucket *bch2_open_bucket_alloc(struct bch_fs *c)
 
 static inline bool is_superblock_bucket(struct bch_fs *c, struct bch_dev *ca, u64 b)
 {
-	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_trans_mark_dev_sbs)
+	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_trans_mark_dev_sbs)
 		return false;
 
 	return bch2_is_superblock_bucket(ca, b);
@@ -524,7 +524,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 
 	if (!avail) {
 		if (req->watermark > BCH_WATERMARK_normal &&
-		    c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations)
+		    c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_allocations)
 			goto alloc;
 
 		if (cl && !waiting) {
@@ -554,7 +554,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		goto alloc;
 	}
 
-	if (!ob && freespace && c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_alloc_info) {
+	if (!ob && freespace && c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_alloc_info) {
 		freespace = false;
 		goto alloc;
 	}
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index bdf524b465fa..44da8e2657af 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -120,7 +120,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 
 		bch_err(c, "%s", buf.buf);
-	} else if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers) {
+	} else if (c->recovery.curr_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers) {
 		prt_printf(&buf, "backpointer not found when deleting\n");
 		printbuf_indent_add(&buf, 2);
 
@@ -136,7 +136,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 	}
 
-	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers &&
+	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers &&
 	    __bch2_inconsistent_error(c, &buf))
 		ret = -BCH_ERR_erofs_unfixed_errors;
 
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 252fc1eaa0dc..1458f131af16 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -502,6 +502,7 @@ enum bch_time_stats {
 #include "keylist_types.h"
 #include "quota_types.h"
 #include "rebalance_types.h"
+#include "recovery_passes_types.h"
 #include "replicas_types.h"
 #include "sb-members_types.h"
 #include "subvolume_types.h"
@@ -1116,21 +1117,7 @@ struct bch_fs {
 	/* RECOVERY */
 	u64			journal_replay_seq_start;
 	u64			journal_replay_seq_end;
-	/*
-	 * Two different uses:
-	 * "Has this fsck pass?" - i.e. should this type of error be an
-	 * emergency read-only
-	 * And, in certain situations fsck will rewind to an earlier pass: used
-	 * for signaling to the toplevel code which pass we want to run now.
-	 */
-	enum bch_recovery_pass	curr_recovery_pass;
-	enum bch_recovery_pass	next_recovery_pass;
-	/* bitmask of recovery passes that we actually ran */
-	u64			recovery_passes_complete;
-	/* never rewinds version of curr_recovery_pass */
-	enum bch_recovery_pass	recovery_pass_done;
-	spinlock_t		recovery_pass_lock;
-	struct semaphore	run_recovery_passes_lock;
+	struct bch_fs_recovery	recovery;
 
 	/* DEBUG JUNK */
 	struct dentry		*fs_debug_dir;
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 96c3846e0079..2600a97582b1 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -1019,7 +1019,7 @@ static noinline void btree_bad_header(struct bch_fs *c, struct btree *b)
 {
 	struct printbuf buf = PRINTBUF;
 
-	if (c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations)
+	if (c->recovery.curr_pass <= BCH_RECOVERY_PASS_check_allocations)
 		return;
 
 	prt_printf(&buf,
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 97cd25cd492b..e5db374f001b 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -556,7 +556,7 @@ static int __btree_err(int ret,
 		       struct printbuf *err_msg,
 		       const char *fmt, ...)
 {
-	if (c->curr_recovery_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
+	if (c->recovery.curr_pass == BCH_RECOVERY_PASS_scan_for_btree_nodes)
 		return -BCH_ERR_fsck_fix;
 
 	bool have_retry = false;
@@ -1428,7 +1428,7 @@ static void btree_node_read_work(struct work_struct *work)
 	if ((failed.nr ||
 	     btree_node_need_rewrite(b)) &&
 	    !btree_node_read_error(b) &&
-	    c->curr_recovery_pass != BCH_RECOVERY_PASS_scan_for_btree_nodes) {
+	    c->recovery.curr_pass != BCH_RECOVERY_PASS_scan_for_btree_nodes) {
 		prt_printf(&buf, " (rewriting node)");
 		bch2_btree_node_rewrite_async(c, b);
 	}
@@ -1776,7 +1776,7 @@ void bch2_btree_node_read(struct btree_trans *trans, struct btree *b,
 		bch2_btree_lost_data(c, &buf, b->c.btree_id);
 
 		if (c->opts.recovery_passes & BIT_ULL(BCH_RECOVERY_PASS_check_topology) &&
-		    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_topology &&
+		    c->recovery.curr_pass > BCH_RECOVERY_PASS_check_topology &&
 		    bch2_fs_emergency_read_only2(c, &buf))
 			ratelimit = false;
 
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 2d43d51b597d..a658c97439ed 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2363,7 +2363,7 @@ void bch2_btree_node_rewrite_async(struct bch_fs *c, struct btree *b)
 	bool now = false, pending = false;
 
 	spin_lock(&c->btree_node_rewrites_lock);
-	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_journal_replay &&
+	if (c->recovery.curr_pass > BCH_RECOVERY_PASS_journal_replay &&
 	    enumerated_ref_tryget(&c->writes, BCH_WRITE_REF_node_rewrite)) {
 		list_add(&a->list, &c->btree_node_rewrites);
 		now = true;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 4dcd51b8259e..dc541a66b8eb 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -3140,7 +3140,7 @@ static int bch2_fsck_online_thread_fn(struct thread_with_stdio *stdio)
 	c->opts.fsck = true;
 	set_bit(BCH_FS_in_fsck, &c->flags);
 
-	c->curr_recovery_pass = BCH_RECOVERY_PASS_check_alloc_info;
+	c->recovery.curr_pass = BCH_RECOVERY_PASS_check_alloc_info;
 	int ret = bch2_run_online_recovery_passes(c);
 
 	clear_bit(BCH_FS_in_fsck, &c->flags);
@@ -3150,7 +3150,7 @@ static int bch2_fsck_online_thread_fn(struct thread_with_stdio *stdio)
 	c->stdio_filter = NULL;
 	c->opts.fix_errors = old_fix_errors;
 
-	up(&c->run_recovery_passes_lock);
+	up(&c->recovery.run_lock);
 	bch2_ro_ref_put(c);
 	return ret;
 }
@@ -3174,7 +3174,7 @@ long bch2_ioctl_fsck_online(struct bch_fs *c, struct bch_ioctl_fsck_online arg)
 	if (!bch2_ro_ref_tryget(c))
 		return -EROFS;
 
-	if (down_trylock(&c->run_recovery_passes_lock)) {
+	if (down_trylock(&c->recovery.run_lock)) {
 		bch2_ro_ref_put(c);
 		return -EAGAIN;
 	}
@@ -3206,7 +3206,7 @@ long bch2_ioctl_fsck_online(struct bch_fs *c, struct bch_ioctl_fsck_online arg)
 		bch_err_fn(c, ret);
 		if (thr)
 			bch2_fsck_thread_exit(&thr->thr);
-		up(&c->run_recovery_passes_lock);
+		up(&c->recovery.run_lock);
 		bch2_ro_ref_put(c);
 	}
 	return ret;
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index cc843815f7eb..4bfdb1befb9a 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -362,7 +362,7 @@ static int bch2_copygc_thread(void *arg)
 	 * Data move operations can't run until after check_snapshots has
 	 * completed, and bch2_snapshot_is_ancestor() is available.
 	 */
-	kthread_wait_freezable(c->recovery_pass_done > BCH_RECOVERY_PASS_check_snapshots ||
+	kthread_wait_freezable(c->recovery.pass_done > BCH_RECOVERY_PASS_check_snapshots ||
 			       kthread_should_stop());
 
 	bch2_move_stats_init(&move_stats, "copygc");
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index c223bb092d33..de1ec9e0caa0 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -616,7 +616,7 @@ static int bch2_rebalance_thread(void *arg)
 	 * Data move operations can't run until after check_snapshots has
 	 * completed, and bch2_snapshot_is_ancestor() is available.
 	 */
-	kthread_wait_freezable(c->recovery_pass_done > BCH_RECOVERY_PASS_check_snapshots ||
+	kthread_wait_freezable(c->recovery.pass_done > BCH_RECOVERY_PASS_check_snapshots ||
 			       kthread_should_stop());
 
 	bch2_moving_ctxt_init(&ctxt, c, NULL, &r->work_stats,
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 1895a6b13001..cd2372221a54 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -434,7 +434,7 @@ int bch2_journal_replay(struct bch_fs *c)
 	trans = NULL;
 
 	if (!c->opts.retain_recovery_info &&
-	    c->recovery_pass_done >= BCH_RECOVERY_PASS_journal_replay)
+	    c->recovery.pass_done >= BCH_RECOVERY_PASS_journal_replay)
 		bch2_journal_keys_put_initial(c);
 
 	replay_now_at(j, j->replay_journal_seq_end);
@@ -1001,7 +1001,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		bch_info(c, "Fixed errors, running fsck a second time to verify fs is clean");
 		clear_bit(BCH_FS_errors_fixed, &c->flags);
 
-		c->curr_recovery_pass = BCH_RECOVERY_PASS_check_alloc_info;
+		c->recovery.curr_pass = BCH_RECOVERY_PASS_check_alloc_info;
 
 		ret = bch2_run_recovery_passes(c);
 		if (ret)
@@ -1047,7 +1047,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 
 	if (c->opts.fsck &&
 	    !test_bit(BCH_FS_error, &c->flags) &&
-	    c->recovery_pass_done == BCH_RECOVERY_PASS_NR - 1 &&
+	    c->recovery.pass_done == BCH_RECOVERY_PASS_NR - 1 &&
 	    ext->btrees_lost_data) {
 		ext->btrees_lost_data = 0;
 		write_sb = true;
@@ -1234,7 +1234,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	c->recovery_pass_done = BCH_RECOVERY_PASS_NR - 1;
+	c->recovery.pass_done = BCH_RECOVERY_PASS_NR - 1;
 
 	bch2_copygc_wakeup(c);
 	bch2_rebalance_wakeup(c);
@@ -1257,7 +1257,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
-	c->curr_recovery_pass = BCH_RECOVERY_PASS_NR;
+	c->recovery.curr_pass = BCH_RECOVERY_PASS_NR;
 	return 0;
 err:
 	bch_err_fn(c, ret);
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 22cefffcf1fa..c1eca55a1dde 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -210,16 +210,18 @@ static int __bch2_run_explicit_recovery_pass(struct printbuf *out,
 					     struct bch_fs *c,
 					     enum bch_recovery_pass pass)
 {
-	if (c->curr_recovery_pass == ARRAY_SIZE(recovery_pass_fns))
+	struct bch_fs_recovery *r = &c->recovery;
+
+	if (r->curr_pass == ARRAY_SIZE(recovery_pass_fns))
 		return -BCH_ERR_not_in_recovery;
 
-	if (c->recovery_passes_complete & BIT_ULL(pass))
+	if (r->passes_complete & BIT_ULL(pass))
 		return 0;
 
 	bool print = !(c->opts.recovery_passes & BIT_ULL(pass));
 
 	if (pass < BCH_RECOVERY_PASS_set_may_go_rw &&
-	    c->curr_recovery_pass >= BCH_RECOVERY_PASS_set_may_go_rw) {
+	    r->curr_pass >= BCH_RECOVERY_PASS_set_may_go_rw) {
 		if (print)
 			prt_printf(out, "need recovery pass %s (%u), but already rw\n",
 				   bch2_recovery_passes[pass], pass);
@@ -229,14 +231,14 @@ static int __bch2_run_explicit_recovery_pass(struct printbuf *out,
 	if (print)
 		prt_printf(out, "running explicit recovery pass %s (%u), currently at %s (%u)\n",
 			   bch2_recovery_passes[pass], pass,
-			   bch2_recovery_passes[c->curr_recovery_pass], c->curr_recovery_pass);
+			   bch2_recovery_passes[r->curr_pass], r->curr_pass);
 
 	c->opts.recovery_passes |= BIT_ULL(pass);
 
 	if (test_bit(BCH_FS_in_recovery, &c->flags) &&
-	    c->curr_recovery_pass > pass) {
-		c->next_recovery_pass = pass;
-		c->recovery_passes_complete &= (1ULL << pass) >> 1;
+	    r->curr_pass > pass) {
+		r->next_pass = pass;
+		r->passes_complete &= (1ULL << pass) >> 1;
 		return -BCH_ERR_restart_recovery;
 	} else {
 		return 0;
@@ -251,9 +253,9 @@ static int bch2_run_explicit_recovery_pass_printbuf(struct bch_fs *c,
 	out->atomic++;
 
 	unsigned long flags;
-	spin_lock_irqsave(&c->recovery_pass_lock, flags);
+	spin_lock_irqsave(&c->recovery.lock, flags);
 	int ret = __bch2_run_explicit_recovery_pass(out, c, pass);
-	spin_unlock_irqrestore(&c->recovery_pass_lock, flags);
+	spin_unlock_irqrestore(&c->recovery.lock, flags);
 
 	--out->atomic;
 	return ret;
@@ -361,7 +363,7 @@ int bch2_run_online_recovery_passes(struct bch_fs *c)
 
 		int ret = bch2_run_recovery_pass(c, i);
 		if (bch2_err_matches(ret, BCH_ERR_restart_recovery)) {
-			i = c->curr_recovery_pass;
+			i = c->recovery.curr_pass;
 			continue;
 		}
 		if (ret)
@@ -381,26 +383,26 @@ int bch2_run_recovery_passes(struct bch_fs *c)
 	 */
 	c->opts.recovery_passes_exclude &= ~BCH_RECOVERY_PASS_set_may_go_rw;
 
-	down(&c->run_recovery_passes_lock);
-	spin_lock_irq(&c->recovery_pass_lock);
+	down(&c->recovery.run_lock);
+	spin_lock_irq(&c->recovery.lock);
 
-	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_pass_fns) && !ret) {
-		unsigned prev_done = c->recovery_pass_done;
-		unsigned pass = c->curr_recovery_pass;
+	while (c->recovery.curr_pass < ARRAY_SIZE(recovery_pass_fns) && !ret) {
+		unsigned prev_done = c->recovery.pass_done;
+		unsigned pass = c->recovery.curr_pass;
 
-		c->next_recovery_pass = pass + 1;
+		c->recovery.next_pass = pass + 1;
 
 		if (c->opts.recovery_pass_last &&
-		    c->curr_recovery_pass > c->opts.recovery_pass_last)
+		    c->recovery.curr_pass > c->opts.recovery_pass_last)
 			break;
 
 		if (should_run_recovery_pass(c, pass)) {
-			spin_unlock_irq(&c->recovery_pass_lock);
+			spin_unlock_irq(&c->recovery.lock);
 			ret =   bch2_run_recovery_pass(c, pass) ?:
 				bch2_journal_flush(&c->journal);
-			spin_lock_irq(&c->recovery_pass_lock);
+			spin_lock_irq(&c->recovery.lock);
 
-			if (c->next_recovery_pass < c->curr_recovery_pass) {
+			if (c->recovery.next_pass < c->recovery.curr_pass) {
 				/*
 				 * bch2_run_explicit_recovery_pass() was called: we
 				 * can't always catch -BCH_ERR_restart_recovery because
@@ -408,30 +410,30 @@ int bch2_run_recovery_passes(struct bch_fs *c)
 				 * node read completion)
 				 */
 				ret = 0;
-				c->recovery_passes_complete &= ~(~0ULL << c->curr_recovery_pass);
+				c->recovery.passes_complete &= ~(~0ULL << c->recovery.curr_pass);
 			} else {
-				c->recovery_passes_complete |= BIT_ULL(pass);
-				c->recovery_pass_done = max(c->recovery_pass_done, pass);
+				c->recovery.passes_complete |= BIT_ULL(pass);
+				c->recovery.pass_done = max(c->recovery.pass_done, pass);
 			}
 		}
 
-		c->curr_recovery_pass = c->next_recovery_pass;
+		c->recovery.curr_pass = c->recovery.next_pass;
 
 		if (prev_done <= BCH_RECOVERY_PASS_check_snapshots &&
-		    c->recovery_pass_done > BCH_RECOVERY_PASS_check_snapshots) {
+		    c->recovery.pass_done > BCH_RECOVERY_PASS_check_snapshots) {
 			bch2_copygc_wakeup(c);
 			bch2_rebalance_wakeup(c);
 		}
 	}
 
-	spin_unlock_irq(&c->recovery_pass_lock);
-	up(&c->run_recovery_passes_lock);
+	spin_unlock_irq(&c->recovery.lock);
+	up(&c->recovery.run_lock);
 
 	return ret;
 }
 
 void bch2_fs_recovery_passes_init(struct bch_fs *c)
 {
-	spin_lock_init(&c->recovery_pass_lock);
-	sema_init(&c->run_recovery_passes_lock, 1);
+	spin_lock_init(&c->recovery.lock);
+	sema_init(&c->recovery.run_lock, 1);
 }
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
new file mode 100644
index 000000000000..69e8e29d58d0
--- /dev/null
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_RECOVERY_PASSES_TYPES_H
+#define _BCACHEFS_RECOVERY_PASSES_TYPES_H
+
+struct bch_fs_recovery {
+	/*
+	 * Two different uses:
+	 * "Has this fsck pass?" - i.e. should this type of error be an
+	 * emergency read-only
+	 * And, in certain situations fsck will rewind to an earlier pass: used
+	 * for signaling to the toplevel code which pass we want to run now.
+	 */
+	enum bch_recovery_pass	curr_pass;
+	enum bch_recovery_pass	next_pass;
+	/* never rewinds version of curr_pass */
+	enum bch_recovery_pass	pass_done;
+	/* bitmask of recovery passes that we actually ran */
+	u64			passes_complete;
+	spinlock_t		lock;
+	struct semaphore	run_lock;
+};
+
+#endif /* _BCACHEFS_RECOVERY_PASSES_TYPES_H */
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index c3dc450cbcec..c401d5285701 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -143,7 +143,7 @@ bool __bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
 	rcu_read_lock();
 	struct snapshot_table *t = rcu_dereference(c->snapshots);
 
-	if (unlikely(c->recovery_pass_done < BCH_RECOVERY_PASS_check_snapshots)) {
+	if (unlikely(c->recovery.pass_done < BCH_RECOVERY_PASS_check_snapshots)) {
 		ret = __bch2_snapshot_is_ancestor_early(t, id, ancestor);
 		goto out;
 	}
@@ -348,7 +348,7 @@ static int __bch2_mark_snapshot(struct btree_trans *trans,
 
 		if (BCH_SNAPSHOT_WILL_DELETE(s.v)) {
 			set_bit(BCH_FS_need_delete_dead_snapshots, &c->flags);
-			if (c->curr_recovery_pass > BCH_RECOVERY_PASS_delete_dead_snapshots)
+			if (c->recovery.curr_pass > BCH_RECOVERY_PASS_delete_dead_snapshots)
 				bch2_delete_dead_snapshots_async(c);
 		}
 	} else {
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index c46b2b2ebab1..170b0f26c018 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -392,7 +392,7 @@ void bch2_fs_read_only(struct bch_fs *c)
 	    !test_bit(BCH_FS_emergency_ro, &c->flags) &&
 	    test_bit(BCH_FS_started, &c->flags) &&
 	    test_bit(BCH_FS_clean_shutdown, &c->flags) &&
-	    c->recovery_pass_done >= BCH_RECOVERY_PASS_journal_replay) {
+	    c->recovery.pass_done >= BCH_RECOVERY_PASS_journal_replay) {
 		BUG_ON(c->journal.last_empty_seq != journal_cur_seq(&c->journal));
 		BUG_ON(atomic_long_read(&c->btree_cache.nr_dirty));
 		BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));
-- 
2.49.0

