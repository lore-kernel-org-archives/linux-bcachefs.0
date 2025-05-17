Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D78B170826
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509962; cv=none; b=hYDpqnBb1Ofvm1PBh2GPG7uJP+4tTjiKHo0PUcVL8XeXEshS7Q730WI/xY1RopxJBSQEsckNi7utjY7HytgH2HQZKSu2axtohL8NlH0U9Q5xXgjAPNhRDwZP9y55hNy/Q45vbvZ7k/e1TVbFkviPB81b4CWdIP+xzK8c8MnZdPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509962; c=relaxed/simple;
	bh=x13Br3fJwTjEniC+KrY3pGcG6xxhmpNv7eKlYvuyMbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubIJIVimYw1obLAaRs4Rf0N4Mo57Pze8EKgu57hg55SLbbW/zLyqpcGtVlg3CaB7TM4GO/kS0tGwNMutRr+O5d31PCP5TpXEp3JnIqq8kQrbPoSkX8e5gP0ST3ZaCDplibZvZnGur6XLwTz7r37QiAPoX9XmydmDVptDl1pR8+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IDBPoNIF; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IDBPoNIF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FKydUxUP+IzkgNctDwz0b739VvfLs4QRHJGYFfdQefo=;
	b=IDBPoNIFaaxsysRLWwGrQJoXMuznh3CUQ0p2VDl0969J/i/HIIFewdYQI4TuRcPd52BqYd
	ZcYeIJfrePXxeiN4UZrC52JDA9C4J4i9ccl7iS//fKcHeDPUy1SH7griWfa1hmaDpV2PfW
	nWYVhpqetLiOey+KRIoyYhQ1faB2QxE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/8] bcachefs: Run recovery passes asynchronously
Date: Sat, 17 May 2025 15:25:43 -0400
Message-ID: <20250517192547.3849149-7-kent.overstreet@linux.dev>
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

When we request a recovery pass to be run online, i.e. not during
recovery, if it's an online pass it'll now be run in the background,
instead of waiting for the next mount.

To avoid situations where recovery passes are running continuously, this
also includes ratelimiting: if the RUN_RECOVERY_PASS_ratelimit flag is
passed, the pass may be deferred until later - depending on the runtime
and last run stats in the recovery_passes superblock section.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h              |   3 +-
 fs/bcachefs/recovery_passes.c       | 133 ++++++++++++++++++++++------
 fs/bcachefs/recovery_passes.h       |   1 +
 fs/bcachefs/recovery_passes_types.h |   2 +
 4 files changed, 113 insertions(+), 26 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 1458f131af16..e1680b635fe1 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -760,7 +760,8 @@ struct btree_trans_buf {
 	x(snapshot_delete_pagecache)					\
 	x(sysfs)							\
 	x(btree_write_buffer)						\
-	x(btree_node_scrub)
+	x(btree_node_scrub)						\
+	x(async_recovery_passes)
 
 enum bch_write_ref {
 #define x(n) BCH_WRITE_REF_##n,
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index b931a9b465d4..f74f14227137 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -138,6 +138,30 @@ static void bch2_sb_recovery_pass_complete(struct bch_fs *c,
 	mutex_unlock(&c->sb_lock);
 }
 
+static bool bch2_recovery_pass_want_ratelimit(struct bch_fs *c, enum bch_recovery_pass pass)
+{
+	enum bch_recovery_pass_stable stable = bch2_recovery_pass_to_stable(pass);
+	bool ret = false;
+
+	lockdep_assert_held(&c->sb_lock);
+
+	struct bch_sb_field_recovery_passes *r =
+		bch2_sb_field_get(c->disk_sb.sb, recovery_passes);
+
+	if (stable < recovery_passes_nr_entries(r)) {
+		struct recovery_pass_entry *i = r->start + stable;
+
+		/*
+		 * Ratelimit if the last runtime was more than 1% of the time
+		 * since we last ran
+		 */
+		ret = (u64) le32_to_cpu(i->last_runtime) * 100 >
+			ktime_get_real_seconds() - le64_to_cpu(i->last_run);
+	}
+
+	return ret;
+}
+
 const struct bch_sb_field_ops bch_sb_field_ops_recovery_passes = {
 	.validate	= bch2_sb_recovery_passes_validate,
 	.to_text	= bch2_sb_recovery_passes_to_text
@@ -218,13 +242,33 @@ u64 bch2_fsck_recovery_passes(void)
 	return bch2_recovery_passes_match(PASS_FSCK);
 }
 
+static void bch2_run_async_recovery_passes(struct bch_fs *c)
+{
+	if (!down_trylock(&c->recovery.run_lock))
+		return;
+
+	if (!enumerated_ref_tryget(&c->writes, BCH_WRITE_REF_async_recovery_passes))
+		goto unlock;
+
+	if (queue_work(system_long_wq, &c->recovery.work))
+		return;
+
+	enumerated_ref_put(&c->writes, BCH_WRITE_REF_async_recovery_passes);
+unlock:
+	up(&c->recovery.run_lock);
+}
+
 static bool recovery_pass_needs_set(struct bch_fs *c,
 				    enum bch_recovery_pass pass,
-				    enum bch_run_recovery_pass_flags flags)
+				    enum bch_run_recovery_pass_flags *flags)
 {
 	struct bch_fs_recovery *r = &c->recovery;
 	bool in_recovery = test_bit(BCH_FS_in_recovery, &c->flags);
-	bool persistent = !in_recovery || !(flags & RUN_RECOVERY_PASS_nopersistent);
+	bool persistent = !in_recovery || !(*flags & RUN_RECOVERY_PASS_nopersistent);
+
+	if ((*flags & RUN_RECOVERY_PASS_ratelimit) &&
+	    !bch2_recovery_pass_want_ratelimit(c, pass))
+		*flags &= ~RUN_RECOVERY_PASS_ratelimit;
 
 	/*
 	 * If RUN_RECOVERY_PASS_nopersistent is set, we don't want to do
@@ -236,9 +280,16 @@ static bool recovery_pass_needs_set(struct bch_fs *c,
 	 * it should run again even if it's already run:
 	 */
 
-	return persistent
-		? !(c->sb.recovery_passes_required & BIT_ULL(pass))
-		: !((r->passes_to_run|r->passes_complete) & BIT_ULL(pass));
+	if (persistent
+	    ? !(c->sb.recovery_passes_required & BIT_ULL(pass))
+	    : !((r->passes_to_run|r->passes_complete) & BIT_ULL(pass)))
+		return true;
+
+	if (!(*flags & RUN_RECOVERY_PASS_ratelimit) &&
+	    (r->passes_ratelimiting & BIT_ULL(pass)))
+		return true;
+
+	return false;
 }
 
 /*
@@ -260,15 +311,14 @@ int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
 	unsigned long lockflags;
 	spin_lock_irqsave(&r->lock, lockflags);
 
-	if (!recovery_pass_needs_set(c, pass, flags))
+	if (!recovery_pass_needs_set(c, pass, &flags))
 		goto out;
 
 	bool in_recovery = test_bit(BCH_FS_in_recovery, &c->flags);
 	bool rewind = in_recovery && r->curr_pass > pass;
+	bool ratelimit = flags & RUN_RECOVERY_PASS_ratelimit;
 
-	if ((flags & RUN_RECOVERY_PASS_nopersistent) && in_recovery) {
-		r->passes_to_run |= BIT_ULL(pass);
-	} else {
+	if (!(in_recovery && (flags & RUN_RECOVERY_PASS_nopersistent))) {
 		struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 		__set_bit_le64(bch2_recovery_pass_to_stable(pass), ext->recovery_passes_required);
 	}
@@ -281,18 +331,32 @@ int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
 		goto out;
 	}
 
-	prt_printf(out, "running recovery pass %s (%u), currently at %s (%u)%s\n",
-		   bch2_recovery_passes[pass], pass,
-		   bch2_recovery_passes[r->curr_pass], r->curr_pass,
-		   rewind ? " - rewinding" : "");
+	if (ratelimit)
+		r->passes_ratelimiting |= BIT_ULL(pass);
+	else
+		r->passes_ratelimiting &= ~BIT_ULL(pass);
+
+	if (in_recovery && !ratelimit) {
+		prt_printf(out, "running recovery pass %s (%u), currently at %s (%u)%s\n",
+			   bch2_recovery_passes[pass], pass,
+			   bch2_recovery_passes[r->curr_pass], r->curr_pass,
+			   rewind ? " - rewinding" : "");
 
-	if (test_bit(BCH_FS_in_recovery, &c->flags))
 		r->passes_to_run |= BIT_ULL(pass);
 
-	if (rewind) {
-		r->next_pass = pass;
-		r->passes_complete &= (1ULL << pass) >> 1;
-		ret = -BCH_ERR_restart_recovery;
+		if (rewind) {
+			r->next_pass = pass;
+			r->passes_complete &= (1ULL << pass) >> 1;
+			ret = -BCH_ERR_restart_recovery;
+		}
+	} else {
+		prt_printf(out, "scheduling recovery pass %s (%u)%s\n",
+			   bch2_recovery_passes[pass], pass,
+			   ratelimit ? " - ratelimiting" : "");
+
+		struct recovery_pass_fn *p = recovery_pass_fns + pass;
+		if (p->when & PASS_ONLINE)
+			bch2_run_async_recovery_passes(c);
 	}
 out:
 	spin_unlock_irqrestore(&r->lock, lockflags);
@@ -305,20 +369,24 @@ int bch2_run_explicit_recovery_pass(struct bch_fs *c,
 				    enum bch_recovery_pass pass,
 				    enum bch_run_recovery_pass_flags flags)
 {
-	if (!recovery_pass_needs_set(c, pass, flags))
-		return 0;
+	int ret = 0;
 
-	mutex_lock(&c->sb_lock);
-	int ret = __bch2_run_explicit_recovery_pass(c, out, pass, flags);
-	bch2_write_super(c);
-	mutex_unlock(&c->sb_lock);
+	scoped_guard(mutex, &c->sb_lock) {
+		if (!recovery_pass_needs_set(c, pass, &flags))
+			return 0;
+
+		ret = __bch2_run_explicit_recovery_pass(c, out, pass, flags);
+		bch2_write_super(c);
+	}
 
 	return ret;
 }
 
 int bch2_run_print_explicit_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
-	if (!recovery_pass_needs_set(c, pass, RUN_RECOVERY_PASS_nopersistent))
+	enum bch_run_recovery_pass_flags flags = RUN_RECOVERY_PASS_nopersistent;
+
+	if (!recovery_pass_needs_set(c, pass, &flags))
 		return 0;
 
 	struct printbuf buf = PRINTBUF;
@@ -430,6 +498,19 @@ static int __bch2_run_recovery_passes(struct bch_fs *c, u64 orig_passes_to_run,
 	return ret;
 }
 
+static void bch2_async_recovery_passes_work(struct work_struct *work)
+{
+	struct bch_fs *c = container_of(work, struct bch_fs, recovery.work);
+	struct bch_fs_recovery *r = &c->recovery;
+
+	__bch2_run_recovery_passes(c,
+		c->sb.recovery_passes_required & ~r->passes_ratelimiting,
+		true);
+
+	up(&r->run_lock);
+	enumerated_ref_put(&c->writes, BCH_WRITE_REF_async_recovery_passes);
+}
+
 int bch2_run_online_recovery_passes(struct bch_fs *c, u64 passes)
 {
 	return __bch2_run_recovery_passes(c, c->sb.recovery_passes_required|passes, true);
@@ -488,4 +569,6 @@ void bch2_fs_recovery_passes_init(struct bch_fs *c)
 {
 	spin_lock_init(&c->recovery.lock);
 	sema_init(&c->recovery.run_lock, 1);
+
+	INIT_WORK(&c->recovery.work, bch2_async_recovery_passes_work);
 }
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 30f896479a52..dc0d2014ff9b 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -12,6 +12,7 @@ u64 bch2_fsck_recovery_passes(void);
 
 enum bch_run_recovery_pass_flags {
 	RUN_RECOVERY_PASS_nopersistent	= BIT(0),
+	RUN_RECOVERY_PASS_ratelimit	= BIT(1),
 };
 
 int bch2_run_print_explicit_recovery_pass(struct bch_fs *, enum bch_recovery_pass);
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index deb6e0565cb9..aa9526938cc3 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -18,8 +18,10 @@ struct bch_fs_recovery {
 	/* bitmask of recovery passes that we actually ran */
 	u64			passes_complete;
 	u64			passes_failing;
+	u64			passes_ratelimiting;
 	spinlock_t		lock;
 	struct semaphore	run_lock;
+	struct work_struct	work;
 };
 
 #endif /* _BCACHEFS_RECOVERY_PASSES_TYPES_H */
-- 
2.49.0

