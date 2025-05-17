Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971C48248C
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509963; cv=none; b=lx6AfCFziljJNiQH539fITmcOzlDTv2Ip1m9oe5QE6wyctyvK9CBc8iuBrk3D7NdCqlJ0CDprZQzSjUtMOZE8ARhACDzPUt2Ml3rm9A3CfKCVZdVV8Yb1W5/wSxehse6F7R2C5erFIgWRL7didUECJCdmGEfCgRo5Wf/8w/Kfus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509963; c=relaxed/simple;
	bh=ksmMNjENGnnufCH4YrWqoBqwZACMMfRa+VNmfr+J958=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AykPRo9tjrfJZ/w0bTMpivVYizPkpuO3Qyn+lpR0zpgi3XAFn1y4Q7db44/aB8cQRbVPPhjwhgn0HzzY0KXHCHKCVY5ssXvZMlva/ZrMRSz5+wnxrD195dISXnv4bQxZAYujUhQ24ulp3u1X06T+HkMwd1n27Ua5LGtdsX0frOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IQQkJt3a; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IQQkJt3a"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/NXy2gt84/gxDQWfo9NPBa4/LCnozjlxvInDxr/ihPo=;
	b=IQQkJt3aT4pMlhIsguBjZ15D8kdXV9L1pqe1xLDlkWL0xoDsU6ur+2XYEn1cQQNIHyM7OK
	zn5SJx5BQVOSdXvgwKGlt9cZf6Z97hu9jOOtAuih7xVaEajs8ExbIU5XWMsE+m7lDU3QK0
	2Zig2hCc8abBJSrz9rHR2d/8vlk9KKk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/8] bcachefs: bch2_run_explicit_recovery_pass() cleanup
Date: Sat, 17 May 2025 15:25:42 -0400
Message-ID: <20250517192547.3849149-6-kent.overstreet@linux.dev>
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

Consolidate the run_explicit_recovery_pass() interfaces by adding a
flags parameter; this will also let us add a RUN_RECOVERY_PASS_ratelimit
flag.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_node_scan.c |   2 +-
 fs/bcachefs/buckets.c         |   8 +-
 fs/bcachefs/errcode.h         |   1 -
 fs/bcachefs/error.c           |   2 +-
 fs/bcachefs/recovery.c        |  31 ++++----
 fs/bcachefs/recovery_passes.c | 142 +++++++++++++++++++---------------
 fs/bcachefs/recovery_passes.h |  18 +++--
 fs/bcachefs/sb-members.c      |   4 +-
 fs/bcachefs/subvolume.c       |   6 +-
 9 files changed, 117 insertions(+), 97 deletions(-)

diff --git a/fs/bcachefs/btree_node_scan.c b/fs/bcachefs/btree_node_scan.c
index 7bd13438d5ef..5a97a6b8a757 100644
--- a/fs/bcachefs/btree_node_scan.c
+++ b/fs/bcachefs/btree_node_scan.c
@@ -541,7 +541,7 @@ int bch2_get_scanned_nodes(struct bch_fs *c, enum btree_id btree,
 
 	struct find_btree_nodes *f = &c->found_btree_nodes;
 
-	int ret = bch2_run_explicit_recovery_pass(c, BCH_RECOVERY_PASS_scan_for_btree_nodes);
+	int ret = bch2_run_print_explicit_recovery_pass(c, BCH_RECOVERY_PASS_scan_for_btree_nodes);
 	if (ret)
 		return ret;
 
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 8d6955ef631b..ca6e58d6fbc8 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -399,8 +399,8 @@ static int bucket_ref_update_err(struct btree_trans *trans, struct printbuf *buf
 
 	bool print = __bch2_count_fsck_err(c, id, buf);
 
-	int ret = bch2_run_explicit_recovery_pass_persistent(c, buf,
-					BCH_RECOVERY_PASS_check_allocations);
+	int ret = bch2_run_explicit_recovery_pass(c, buf,
+					BCH_RECOVERY_PASS_check_allocations, 0);
 
 	if (insert) {
 		bch2_trans_updates_to_text(buf, trans);
@@ -972,8 +972,8 @@ static int __bch2_trans_mark_metadata_bucket(struct btree_trans *trans,
 
 		bool print = bch2_count_fsck_err(c, bucket_metadata_type_mismatch, &buf);
 
-		bch2_run_explicit_recovery_pass_persistent(c, &buf,
-					BCH_RECOVERY_PASS_check_allocations);
+		bch2_run_explicit_recovery_pass(c, &buf,
+					BCH_RECOVERY_PASS_check_allocations, 0);
 
 		if (print)
 			bch2_print_str(c, KERN_ERR, buf.buf);
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index 4aac0182cbed..62843e772b2c 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -183,7 +183,6 @@
 	x(BCH_ERR_fsck,			fsck_repair_unimplemented)		\
 	x(BCH_ERR_fsck,			fsck_repair_impossible)			\
 	x(EINVAL,			restart_recovery)			\
-	x(EINVAL,			not_in_recovery)			\
 	x(EINVAL,			cannot_rewind_recovery)			\
 	x(0,				data_update_done)			\
 	x(BCH_ERR_data_update_done,	data_update_done_would_block)		\
diff --git a/fs/bcachefs/error.c b/fs/bcachefs/error.c
index 52f1108d5829..a476dd2c196e 100644
--- a/fs/bcachefs/error.c
+++ b/fs/bcachefs/error.c
@@ -102,7 +102,7 @@ int __bch2_topology_error(struct bch_fs *c, struct printbuf *out)
 		__bch2_inconsistent_error(c, out);
 		return -BCH_ERR_btree_need_topology_repair;
 	} else {
-		return bch2_run_explicit_recovery_pass_persistent(c, out, BCH_RECOVERY_PASS_check_topology) ?:
+		return bch2_run_explicit_recovery_pass(c, out, BCH_RECOVERY_PASS_check_topology, 0) ?:
 			-BCH_ERR_btree_node_read_validate_error;
 	}
 }
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index a7e6b5a6505a..0f954567ea45 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -52,24 +52,24 @@ int bch2_btree_lost_data(struct bch_fs *c,
 	}
 
 	/* Once we have runtime self healing for topology errors we won't need this: */
-	ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_topology) ?: ret;
+	ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_topology, 0) ?: ret;
 
 	/* Btree node accounting will be off: */
 	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
-	ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_allocations) ?: ret;
+	ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_allocations, 0) ?: ret;
 
 #ifdef CONFIG_BCACHEFS_DEBUG
 	/*
 	 * These are much more minor, and don't need to be corrected right away,
 	 * but in debug mode we want the next fsck run to be clean:
 	 */
-	ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_lrus) ?: ret;
-	ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_backpointers_to_extents) ?: ret;
+	ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_lrus, 0) ?: ret;
+	ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_backpointers_to_extents, 0) ?: ret;
 #endif
 
 	switch (btree) {
 	case BTREE_ID_alloc:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_alloc_info, 0) ?: ret;
 
 		__set_bit_le64(BCH_FSCK_ERR_alloc_key_data_type_wrong, ext->errors_silent);
 		__set_bit_le64(BCH_FSCK_ERR_alloc_key_gen_wrong, ext->errors_silent);
@@ -79,30 +79,30 @@ int bch2_btree_lost_data(struct bch_fs *c,
 		__set_bit_le64(BCH_FSCK_ERR_alloc_key_stripe_redundancy_wrong, ext->errors_silent);
 		goto out;
 	case BTREE_ID_backpointers:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_btree_backpointers) ?: ret;
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_extents_to_backpointers) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_btree_backpointers, 0) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_extents_to_backpointers, 0) ?: ret;
 		goto out;
 	case BTREE_ID_need_discard:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_alloc_info, 0) ?: ret;
 		goto out;
 	case BTREE_ID_freespace:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_alloc_info, 0) ?: ret;
 		goto out;
 	case BTREE_ID_bucket_gens:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_alloc_info, 0) ?: ret;
 		goto out;
 	case BTREE_ID_lru:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_alloc_info, 0) ?: ret;
 		goto out;
 	case BTREE_ID_accounting:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_check_allocations) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_check_allocations, 0) ?: ret;
 		goto out;
 	case BTREE_ID_snapshots:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_reconstruct_snapshots) ?: ret;
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_scan_for_btree_nodes) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_reconstruct_snapshots, 0) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_scan_for_btree_nodes, 0) ?: ret;
 		goto out;
 	default:
-		ret = __bch2_run_explicit_recovery_pass_persistent(c, msg, BCH_RECOVERY_PASS_scan_for_btree_nodes) ?: ret;
+		ret = __bch2_run_explicit_recovery_pass(c, msg, BCH_RECOVERY_PASS_scan_for_btree_nodes, 0) ?: ret;
 		goto out;
 	}
 out:
@@ -978,7 +978,6 @@ int bch2_fs_recovery(struct bch_fs *c)
 	 */
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 	clear_bit(BCH_FS_in_fsck, &c->flags);
-	clear_bit(BCH_FS_in_recovery, &c->flags);
 
 	/* in case we don't run journal replay, i.e. norecovery mode */
 	set_bit(BCH_FS_accounting_replay_done, &c->flags);
diff --git a/fs/bcachefs/recovery_passes.c b/fs/bcachefs/recovery_passes.c
index 02639b3d86b0..b931a9b465d4 100644
--- a/fs/bcachefs/recovery_passes.c
+++ b/fs/bcachefs/recovery_passes.c
@@ -218,104 +218,119 @@ u64 bch2_fsck_recovery_passes(void)
 	return bch2_recovery_passes_match(PASS_FSCK);
 }
 
+static bool recovery_pass_needs_set(struct bch_fs *c,
+				    enum bch_recovery_pass pass,
+				    enum bch_run_recovery_pass_flags flags)
+{
+	struct bch_fs_recovery *r = &c->recovery;
+	bool in_recovery = test_bit(BCH_FS_in_recovery, &c->flags);
+	bool persistent = !in_recovery || !(flags & RUN_RECOVERY_PASS_nopersistent);
+
+	/*
+	 * If RUN_RECOVERY_PASS_nopersistent is set, we don't want to do
+	 * anything if the pass has already run: these mean we need a prior pass
+	 * to run before we continue to repair, we don't expect that pass to fix
+	 * the damage we encountered.
+	 *
+	 * Otherwise, we run run_explicit_recovery_pass when we find damage, so
+	 * it should run again even if it's already run:
+	 */
+
+	return persistent
+		? !(c->sb.recovery_passes_required & BIT_ULL(pass))
+		: !((r->passes_to_run|r->passes_complete) & BIT_ULL(pass));
+}
+
 /*
  * For when we need to rewind recovery passes and run a pass we skipped:
  */
-static int __bch2_run_explicit_recovery_pass(struct printbuf *out,
-					     struct bch_fs *c,
-					     enum bch_recovery_pass pass)
+int __bch2_run_explicit_recovery_pass(struct bch_fs *c,
+				      struct printbuf *out,
+				      enum bch_recovery_pass pass,
+				      enum bch_run_recovery_pass_flags flags)
 {
 	struct bch_fs_recovery *r = &c->recovery;
+	int ret = 0;
 
-	if (r->curr_pass == ARRAY_SIZE(recovery_pass_fns))
-		return -BCH_ERR_not_in_recovery;
+	lockdep_assert_held(&c->sb_lock);
 
-	if (r->passes_complete & BIT_ULL(pass))
-		return 0;
+	bch2_printbuf_make_room(out, 1024);
+	out->atomic++;
 
-	bool print = !(c->opts.recovery_passes & BIT_ULL(pass));
+	unsigned long lockflags;
+	spin_lock_irqsave(&r->lock, lockflags);
 
-	if (pass < BCH_RECOVERY_PASS_set_may_go_rw &&
-	    r->curr_pass >= BCH_RECOVERY_PASS_set_may_go_rw) {
-		if (print)
-			prt_printf(out, "need recovery pass %s (%u), but already rw\n",
-				   bch2_recovery_passes[pass], pass);
-		return -BCH_ERR_cannot_rewind_recovery;
+	if (!recovery_pass_needs_set(c, pass, flags))
+		goto out;
+
+	bool in_recovery = test_bit(BCH_FS_in_recovery, &c->flags);
+	bool rewind = in_recovery && r->curr_pass > pass;
+
+	if ((flags & RUN_RECOVERY_PASS_nopersistent) && in_recovery) {
+		r->passes_to_run |= BIT_ULL(pass);
+	} else {
+		struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
+		__set_bit_le64(bch2_recovery_pass_to_stable(pass), ext->recovery_passes_required);
 	}
 
-	if (print)
-		prt_printf(out, "running explicit recovery pass %s (%u), currently at %s (%u)\n",
-			   bch2_recovery_passes[pass], pass,
-			   bch2_recovery_passes[r->curr_pass], r->curr_pass);
+	if (pass < BCH_RECOVERY_PASS_set_may_go_rw &&
+	    (!in_recovery || r->curr_pass >= BCH_RECOVERY_PASS_set_may_go_rw)) {
+		prt_printf(out, "need recovery pass %s (%u), but already rw\n",
+			   bch2_recovery_passes[pass], pass);
+		ret = -BCH_ERR_cannot_rewind_recovery;
+		goto out;
+	}
 
-	c->opts.recovery_passes |= BIT_ULL(pass);
+	prt_printf(out, "running recovery pass %s (%u), currently at %s (%u)%s\n",
+		   bch2_recovery_passes[pass], pass,
+		   bch2_recovery_passes[r->curr_pass], r->curr_pass,
+		   rewind ? " - rewinding" : "");
 
 	if (test_bit(BCH_FS_in_recovery, &c->flags))
 		r->passes_to_run |= BIT_ULL(pass);
 
-	if (test_bit(BCH_FS_in_recovery, &c->flags) &&
-	    r->curr_pass > pass) {
+	if (rewind) {
 		r->next_pass = pass;
-		return -BCH_ERR_restart_recovery;
-	} else {
-		return 0;
+		r->passes_complete &= (1ULL << pass) >> 1;
+		ret = -BCH_ERR_restart_recovery;
 	}
-}
-
-static int bch2_run_explicit_recovery_pass_printbuf(struct bch_fs *c,
-				    struct printbuf *out,
-				    enum bch_recovery_pass pass)
-{
-	bch2_printbuf_make_room(out, 1024);
-	out->atomic++;
-
-	unsigned long flags;
-	spin_lock_irqsave(&c->recovery.lock, flags);
-	int ret = __bch2_run_explicit_recovery_pass(out, c, pass);
-	spin_unlock_irqrestore(&c->recovery.lock, flags);
-
+out:
+	spin_unlock_irqrestore(&r->lock, lockflags);
 	--out->atomic;
 	return ret;
 }
 
 int bch2_run_explicit_recovery_pass(struct bch_fs *c,
-				    enum bch_recovery_pass pass)
+				    struct printbuf *out,
+				    enum bch_recovery_pass pass,
+				    enum bch_run_recovery_pass_flags flags)
 {
-	struct printbuf buf = PRINTBUF;
-	bch2_log_msg_start(c, &buf);
-	unsigned len = buf.pos;
+	if (!recovery_pass_needs_set(c, pass, flags))
+		return 0;
 
-	int ret = bch2_run_explicit_recovery_pass_printbuf(c, &buf, pass);
+	mutex_lock(&c->sb_lock);
+	int ret = __bch2_run_explicit_recovery_pass(c, out, pass, flags);
+	bch2_write_super(c);
+	mutex_unlock(&c->sb_lock);
 
-	if (len != buf.pos)
-		bch2_print_str(c, KERN_NOTICE, buf.buf);
-	printbuf_exit(&buf);
 	return ret;
 }
 
-int __bch2_run_explicit_recovery_pass_persistent(struct bch_fs *c,
-						 struct printbuf *out,
-						 enum bch_recovery_pass pass)
-{
-	lockdep_assert_held(&c->sb_lock);
-
-	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
-	__set_bit_le64(bch2_recovery_pass_to_stable(pass), ext->recovery_passes_required);
-
-	return bch2_run_explicit_recovery_pass_printbuf(c, out, pass);
-}
-
-int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *c,
-					       struct printbuf *out,
-					       enum bch_recovery_pass pass)
+int bch2_run_print_explicit_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
 {
-	if (c->sb.recovery_passes_required & BIT_ULL(pass))
+	if (!recovery_pass_needs_set(c, pass, RUN_RECOVERY_PASS_nopersistent))
 		return 0;
 
+	struct printbuf buf = PRINTBUF;
+	bch2_log_msg_start(c, &buf);
+
 	mutex_lock(&c->sb_lock);
-	int ret = __bch2_run_explicit_recovery_pass_persistent(c, out, pass);
+	int ret = __bch2_run_explicit_recovery_pass(c, &buf, pass,
+						RUN_RECOVERY_PASS_nopersistent);
 	mutex_unlock(&c->sb_lock);
 
+	bch2_print_str(c, KERN_NOTICE, buf.buf);
+	printbuf_exit(&buf);
 	return ret;
 }
 
@@ -409,6 +424,7 @@ static int __bch2_run_recovery_passes(struct bch_fs *c, u64 orig_passes_to_run,
 		}
 	}
 
+	clear_bit(BCH_FS_in_recovery, &c->flags);
 	spin_unlock_irq(&r->lock);
 
 	return ret;
diff --git a/fs/bcachefs/recovery_passes.h b/fs/bcachefs/recovery_passes.h
index 8c90e29cd6cb..30f896479a52 100644
--- a/fs/bcachefs/recovery_passes.h
+++ b/fs/bcachefs/recovery_passes.h
@@ -10,12 +10,18 @@ u64 bch2_recovery_passes_from_stable(u64 v);
 
 u64 bch2_fsck_recovery_passes(void);
 
-int bch2_run_explicit_recovery_pass(struct bch_fs *, enum bch_recovery_pass);
-
-int __bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, struct printbuf *,
-					       enum bch_recovery_pass);
-int bch2_run_explicit_recovery_pass_persistent(struct bch_fs *, struct printbuf *,
-					       enum bch_recovery_pass);
+enum bch_run_recovery_pass_flags {
+	RUN_RECOVERY_PASS_nopersistent	= BIT(0),
+};
+
+int bch2_run_print_explicit_recovery_pass(struct bch_fs *, enum bch_recovery_pass);
+
+int __bch2_run_explicit_recovery_pass(struct bch_fs *, struct printbuf *,
+				      enum bch_recovery_pass,
+				      enum bch_run_recovery_pass_flags);
+int bch2_run_explicit_recovery_pass(struct bch_fs *, struct printbuf *,
+				    enum bch_recovery_pass,
+				    enum bch_run_recovery_pass_flags);
 
 int bch2_run_online_recovery_passes(struct bch_fs *, u64);
 int bch2_run_recovery_passes(struct bch_fs *, enum bch_recovery_pass);
diff --git a/fs/bcachefs/sb-members.c b/fs/bcachefs/sb-members.c
index 75184d8e685a..3398906660a5 100644
--- a/fs/bcachefs/sb-members.c
+++ b/fs/bcachefs/sb-members.c
@@ -20,8 +20,8 @@ int bch2_dev_missing_bkey(struct bch_fs *c, struct bkey_s_c k, unsigned dev)
 
 	bool print = bch2_count_fsck_err(c, ptr_to_invalid_device, &buf);
 
-	int ret = bch2_run_explicit_recovery_pass_persistent(c, &buf,
-						 BCH_RECOVERY_PASS_check_allocations);
+	int ret = bch2_run_explicit_recovery_pass(c, &buf,
+					BCH_RECOVERY_PASS_check_allocations, 0);
 
 	if (print)
 		bch2_print_str(c, KERN_ERR, buf.buf);
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index 3c6ba1469de2..35c9f86a73c1 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -23,8 +23,8 @@ static int bch2_subvolume_missing(struct bch_fs *c, u32 subvolid)
 	prt_printf(&buf, "missing subvolume %u", subvolid);
 	bool print = bch2_count_fsck_err(c, subvol_missing, &buf);
 
-	int ret = bch2_run_explicit_recovery_pass_persistent(c, &buf,
-					BCH_RECOVERY_PASS_check_inodes);
+	int ret = bch2_run_explicit_recovery_pass(c, &buf,
+					BCH_RECOVERY_PASS_check_inodes, 0);
 	if (print)
 		bch2_print_str(c, KERN_ERR, buf.buf);
 	printbuf_exit(&buf);
@@ -62,7 +62,7 @@ static int check_subvol(struct btree_trans *trans,
 	ret = bch2_snapshot_lookup(trans, snapid, &snapshot);
 
 	if (bch2_err_matches(ret, ENOENT))
-		return bch2_run_explicit_recovery_pass(c,
+		return bch2_run_print_explicit_recovery_pass(c,
 					BCH_RECOVERY_PASS_reconstruct_snapshots) ?: ret;
 	if (ret)
 		return ret;
-- 
2.49.0

