Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27E720E31B
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509962; cv=none; b=tv6na6N793MU4Bi4SsENa5kd1hsiR9+tz4NDFiWieq04B+cf6Z/8LDYHGdLN32v1LUWgsEo1j9+ot8cHYIBqF8TyQHbC5IuXlcFWgG/3nqomN2/uZNCmZOsjR1a1MGLEoTrEPBqpP6qg4bvZp/z5GjLlrxcGZNALiH4RfImkK8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509962; c=relaxed/simple;
	bh=56lw+XsPWEt9mwVuDfSwuzPuUKM2NdtLJkgjZEzjDMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iY1PLipcc+VNjsn2F6bIBs414Wo2b6hN6wfQRiqeFRh6ImNJvj4ioxxzWRh9697IETUQ5zWjvNV7/BGbGGCJh/JrwsZRlNXFwEgGgPhyfvoSr53h/seyBo2sF1Y5Z5+qeqbD+J4Zt0yMxNm8SepFSeKZG0YiAwJ9+kmIEZ0QWzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ihqM1Tzs; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ihqM1Tzs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kp9VAYQLBi0pZt+IF9+IVnXnRcDF8AQc7FVsbNwKX7c=;
	b=ihqM1TzsbumwZPqa3xkHNd7PZPGXSYWrXlPJ2FSvYuAGpQzcL0e9fQvg4nr41Kh93Snbq3
	25Ha7qVOa6cKJLkXwWlyPRSp6vzGAjXmBQoi4tHOTaJI7A44zeXghiFivYczZQ+aegbrZ1
	9ET+zgpnCKr+Z09pqVitW6rM3Z7cQvc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/8] bcachefs: __bch2_run_recovery_passes()
Date: Sat, 17 May 2025 15:25:39 -0400
Message-ID: <20250517192547.3849149-3-kent.overstreet@linux.dev>
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

Consolidate bch2_run_recovery_passes() and
bch2_run_online_recovery_passes(), prep work for automatically
scheduling and running recovery passes in the background.

- Now takes a mask of which passes to run, automatic background repair
  will pass in sb.recovery_passes_required.

- Skips passes that are failing: a pass that failed may be reattempted
  after another pass succeeds (some passes depend on repair done by
  other passes for successful completion).

- bch2_recovery_passes_match() helper to skip alloc passes on a
  filesystem without alloc info.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c                  |   2 +-
 fs/bcachefs/recovery.c              |   7 +-
 fs/bcachefs/recovery_passes.c       | 180 +++++++++++++++-------------
 fs/bcachefs/recovery_passes.h       |   4 +-
 fs/bcachefs/recovery_passes_types.h |   2 +
 5 files changed, 104 insertions(+), 91 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index dc541a66b8eb..0909716900f9 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -3141,7 +3141,7 @@ static int bch2_fsck_online_thread_fn(struct thread_with_stdio *stdio)
 	set_bit(BCH_FS_in_fsck, &c->flags);
 
 	c->recovery.curr_pass = BCH_RECOVERY_PASS_check_alloc_info;
-	int ret = bch2_run_online_recovery_passes(c);
+	int ret = bch2_run_online_recovery_passes(c, ~0ULL);
 
 	clear_bit(BCH_FS_in_fsck, &c->flags);
 	bch_err_fn(c, ret);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index cd2372221a54..a7e6b5a6505a 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -966,7 +966,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	ret = bch2_run_recovery_passes(c);
+	ret = bch2_run_recovery_passes(c, 0);
 	if (ret)
 		goto err;
 
@@ -1001,9 +1001,8 @@ int bch2_fs_recovery(struct bch_fs *c)
 		bch_info(c, "Fixed errors, running fsck a second time to verify fs is clean");
 		clear_bit(BCH_FS_errors_fixed, &c->flags);
 
-		c->recovery.curr_pass = BCH_RECOVERY_PASS_check_alloc_info;
-
-		ret = bch2_run_recovery_passes(c);
+		ret = bch2_run_recovery_passes(c,
+			BCH_RECOVERY_PASS_check_alloc_info);
 		if (ret)
 			goto err;
 
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index c1eca55a1dde..e0e261aa752e 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -203,6 +203,21 @@ static struct recovery_pass_fn recovery_pass_fns[] = {
 #undef x
 };
 
+static u64 bch2_recovery_passes_match(unsigned flags)
+{
+	u64 ret = 0;
+
+	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++)
+		if (recovery_pass_fns[i].when & flags)
+			ret |= BIT_ULL(i);
+	return ret;
+}
+
+u64 bch2_fsck_recovery_passes(void)
+{
+	return bch2_recovery_passes_match(PASS_FSCK);
+}
+
 /*
  * For when we need to rewind recovery passes and run a pass we skipped:
  */
@@ -235,10 +250,12 @@ static int __bch2_run_explicit_recovery_pass(struct printbuf *out,
 
 	c->opts.recovery_passes |= BIT_ULL(pass);
 
+	if (test_bit(BCH_FS_in_recovery, &c->flags))
+		r->passes_to_run |= BIT_ULL(pass);
+
 	if (test_bit(BCH_FS_in_recovery, &c->flags) &&
 	    r->curr_pass > pass) {
 		r->next_pass = pass;
-		r->passes_complete &= (1ULL << pass) >> 1;
 		return -BCH_ERR_restart_recovery;
 	} else {
 		return 0;
@@ -302,37 +319,9 @@ int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *c,
 	return ret;
 }
 
-u64 bch2_fsck_recovery_passes(void)
-{
-	u64 ret = 0;
-
-	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++)
-		if (recovery_pass_fns[i].when & PASS_FSCK)
-			ret |= BIT_ULL(i);
-	return ret;
-}
-
-static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
-{
-	struct recovery_pass_fn *p = recovery_pass_fns + pass;
-
-	if ((p->when & PASS_ALLOC) && (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info)))
-		return false;
-	if (c->opts.recovery_passes_exclude & BIT_ULL(pass))
-		return false;
-	if (c->opts.recovery_passes & BIT_ULL(pass))
-		return true;
-	if ((p->when & PASS_FSCK) && c->opts.fsck)
-		return true;
-	if ((p->when & PASS_UNCLEAN) && !c->sb.clean)
-		return true;
-	if (p->when & PASS_ALWAYS)
-		return true;
-	return false;
-}
-
 static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
+	struct bch_fs_recovery *r = &c->recovery;
 	struct recovery_pass_fn *p = recovery_pass_fns + pass;
 
 	if (!(p->when & PASS_SILENT))
@@ -341,8 +330,15 @@ static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 
 	s64 start_time = ktime_get_real_seconds();
 	int ret = p->fn(c);
-	if (ret)
+
+	r->passes_to_run &= ~BIT_ULL(pass);
+
+	if (ret) {
+		r->passes_failing |= BIT_ULL(pass);
 		return ret;
+	}
+
+	r->passes_failing = 0;
 
 	if (!test_bit(BCH_FS_error, &c->flags))
 		bch2_sb_recovery_pass_complete(c, pass, start_time);
@@ -353,80 +349,96 @@ static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 	return 0;
 }
 
-int bch2_run_online_recovery_passes(struct bch_fs *c)
+static int __bch2_run_recovery_passes(struct bch_fs *c, u64 orig_passes_to_run,
+				      bool online)
 {
-	for (unsigned i = 0; i < ARRAY_SIZE(recovery_pass_fns); i++) {
-		struct recovery_pass_fn *p = recovery_pass_fns + i;
-
-		if (!(p->when & PASS_ONLINE))
-			continue;
+	struct bch_fs_recovery *r = &c->recovery;
+	int ret = 0;
 
-		int ret = bch2_run_recovery_pass(c, i);
-		if (bch2_err_matches(ret, BCH_ERR_restart_recovery)) {
-			i = c->recovery.curr_pass;
-			continue;
-		}
-		if (ret)
-			return ret;
-	}
+	spin_lock_irq(&r->lock);
 
-	return 0;
-}
+	if (online)
+		orig_passes_to_run &= bch2_recovery_passes_match(PASS_ONLINE);
 
-int bch2_run_recovery_passes(struct bch_fs *c)
-{
-	int ret = 0;
+	if (c->sb.features & BIT_ULL(BCH_FEATURE_no_alloc_info))
+		orig_passes_to_run &= ~bch2_recovery_passes_match(PASS_ALLOC);
 
 	/*
-	 * We can't allow set_may_go_rw to be excluded; that would cause us to
-	 * use the journal replay keys for updates where it's not expected.
+	 * A failed recovery pass will be retried after another pass succeeds -
+	 * but not this iteration.
+	 *
+	 * This is because some passes depend on repair done by other passes: we
+	 * may want to retry, but we don't want to loop on failing passes.
 	 */
-	c->opts.recovery_passes_exclude &= ~BCH_RECOVERY_PASS_set_may_go_rw;
 
-	down(&c->recovery.run_lock);
-	spin_lock_irq(&c->recovery.lock);
+	orig_passes_to_run &= ~r->passes_failing;
 
-	while (c->recovery.curr_pass < ARRAY_SIZE(recovery_pass_fns) && !ret) {
-		unsigned prev_done = c->recovery.pass_done;
-		unsigned pass = c->recovery.curr_pass;
+	r->passes_to_run = orig_passes_to_run;
 
-		c->recovery.next_pass = pass + 1;
+	while (r->passes_to_run) {
+		unsigned prev_done = r->pass_done;
+		unsigned pass = __ffs64(r->passes_to_run);
+		r->curr_pass = pass;
+		r->next_pass = r->curr_pass + 1;
+		r->passes_to_run &= ~BIT_ULL(pass);
 
-		if (c->opts.recovery_pass_last &&
-		    c->recovery.curr_pass > c->opts.recovery_pass_last)
-			break;
+		spin_unlock_irq(&r->lock);
+
+		int ret2 = bch2_run_recovery_pass(c, pass) ?:
+			bch2_journal_flush(&c->journal);
 
-		if (should_run_recovery_pass(c, pass)) {
-			spin_unlock_irq(&c->recovery.lock);
-			ret =   bch2_run_recovery_pass(c, pass) ?:
-				bch2_journal_flush(&c->journal);
-			spin_lock_irq(&c->recovery.lock);
-
-			if (c->recovery.next_pass < c->recovery.curr_pass) {
-				/*
-				 * bch2_run_explicit_recovery_pass() was called: we
-				 * can't always catch -BCH_ERR_restart_recovery because
-				 * it may have been called from another thread (btree
-				 * node read completion)
-				 */
-				ret = 0;
-				c->recovery.passes_complete &= ~(~0ULL << c->recovery.curr_pass);
-			} else {
-				c->recovery.passes_complete |= BIT_ULL(pass);
-				c->recovery.pass_done = max(c->recovery.pass_done, pass);
-			}
+		spin_lock_irq(&r->lock);
+
+		if (r->next_pass < r->curr_pass) {
+			/* Rewind: */
+			r->passes_to_run |= orig_passes_to_run & (~0ULL << r->next_pass);
+		} else if (!ret2) {
+			r->pass_done = max(r->pass_done, pass);
+			r->passes_complete |= BIT_ULL(pass);
+		} else {
+			ret = ret2;
 		}
 
-		c->recovery.curr_pass = c->recovery.next_pass;
+		if (ret && !online)
+			break;
 
 		if (prev_done <= BCH_RECOVERY_PASS_check_snapshots &&
-		    c->recovery.pass_done > BCH_RECOVERY_PASS_check_snapshots) {
+		    r->pass_done > BCH_RECOVERY_PASS_check_snapshots) {
 			bch2_copygc_wakeup(c);
 			bch2_rebalance_wakeup(c);
 		}
 	}
 
-	spin_unlock_irq(&c->recovery.lock);
+	spin_unlock_irq(&r->lock);
+
+	return ret;
+}
+
+int bch2_run_online_recovery_passes(struct bch_fs *c, u64 passes)
+{
+	return __bch2_run_recovery_passes(c, c->sb.recovery_passes_required|passes, true);
+}
+
+int bch2_run_recovery_passes(struct bch_fs *c, enum bch_recovery_pass from)
+{
+	u64 passes =
+		bch2_recovery_passes_match(PASS_ALWAYS) |
+		(!c->sb.clean ? bch2_recovery_passes_match(PASS_UNCLEAN) : 0) |
+		(c->opts.fsck ? bch2_recovery_passes_match(PASS_FSCK) : 0) |
+		c->opts.recovery_passes |
+		c->sb.recovery_passes_required;
+
+	/*
+	 * We can't allow set_may_go_rw to be excluded; that would cause us to
+	 * use the journal replay keys for updates where it's not expected.
+	 */
+	c->opts.recovery_passes_exclude &= ~BCH_RECOVERY_PASS_set_may_go_rw;
+	passes &= ~c->opts.recovery_passes_exclude;
+
+	passes &= ~(BIT_ULL(from) - 1);
+
+	down(&c->recovery.run_lock);
+	int ret = __bch2_run_recovery_passes(c, passes, false);
 	up(&c->recovery.run_lock);
 
 	return ret;
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 4c03472be5b9..0e79cc33fd8f 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -17,8 +17,8 @@ int __bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, struct printbu
 int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, struct printbuf *,
 					       enum bch_recovery_pass);
 
-int bch2_run_online_recovery_passes(struct bch_fs *);
-int bch2_run_recovery_passes(struct bch_fs *);
+int bch2_run_online_recovery_passes(struct bch_fs *, u64);
+int bch2_run_recovery_passes(struct bch_fs *, enum bch_recovery_pass);
 
 void bch2_fs_recovery_passes_init(struct bch_fs *);
 
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index 69e8e29d58d0..deb6e0565cb9 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -14,8 +14,10 @@ struct bch_fs_recovery {
 	enum bch_recovery_pass	next_pass;
 	/* never rewinds version of curr_pass */
 	enum bch_recovery_pass	pass_done;
+	u64			passes_to_run;
 	/* bitmask of recovery passes that we actually ran */
 	u64			passes_complete;
+	u64			passes_failing;
 	spinlock_t		lock;
 	struct semaphore	run_lock;
 };
-- 
2.49.0

