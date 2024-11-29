Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3B21A3A8A
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912083; cv=none; b=oyDH+a44d5RZGvHHU58BrOacMvRmQ1+9xIiziS4oES+MhQQdX518XaPGEJlye3+62LYbJsUQpwrCr6y51kLmOhm7kvNFXy6Z0awQF3hPQhjTTIPh9TTezFwefyKCiapoK0xXTp+AK+/ZgAD3lLs8Yrv7AZ6ZYnBNU9ztOojVbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912083; c=relaxed/simple;
	bh=95jCvaYQi2F6NrKeXxyT26BkX+Onp5Rga7IYxZC9CSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hGc9UqjaVgOGFyxc5SVRSbK69DNMQVOdtR8MdZHuzkaU2jWHuOUUCFQE8V7AwQobDjaXa1XD03234E/5fRU9/Rs85FU3BSpO1z7cVGJKVShJx2LYis0nKbE6aoM9J44ZwwiW0px6oS1GZXg9SnCOymXFvGouKh5VyTbJVfnF0YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 18/34] bcachefs: Make topology errors autofix
Date: Fri, 29 Nov 2024 15:27:17 -0500
Message-ID: <20241129202736.2713679-19-kent.overstreet@linux.dev>
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

These repair paths are well tested, we can repair them without explicit
user intervention

This also tweaks bch2_topology_error() so that we run topology repair if
we're in recovery, not just fsck.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_gc.c         |  2 +-
 fs/bcachefs/recovery.c         | 31 +++++++++++++++++++++++++------
 fs/bcachefs/sb-errors_format.h | 12 ++++++------
 3 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 2e8cfc4d3265..19db4d8aca88 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -348,7 +348,7 @@ static int bch2_btree_repair_topology_recurse(struct btree_trans *trans, struct
 		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(cur_k.k));
 
 		if (mustfix_fsck_err_on(bch2_err_matches(ret, EIO),
-				trans, btree_node_unreadable,
+				trans, btree_node_read_error,
 				"Topology repair: unreadable btree node at\n"
 				"  %s",
 				buf.buf)) {
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index e361057ffad4..64bb330eac86 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -40,19 +40,42 @@ int bch2_btree_lost_data(struct bch_fs *c, enum btree_id btree)
 	int ret = 0;
 
 	mutex_lock(&c->sb_lock);
+	struct bch_sb_field_ext *ext = bch2_sb_field_get(c->disk_sb.sb, ext);
 
 	if (!(c->sb.btrees_lost_data & b)) {
 		struct printbuf buf = PRINTBUF;
 		bch2_btree_id_to_text(&buf, btree);
 		bch_err(c, "flagging btree %s lost data", buf.buf);
 		printbuf_exit(&buf);
-		bch2_sb_field_get(c->disk_sb.sb, ext)->btrees_lost_data |= cpu_to_le64(b);
+		ext->btrees_lost_data |= cpu_to_le64(b);
 	}
 
+	/* Once we have runtime self healing for topology errors we won't need this: */
+	ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_topology) ?: ret;
+
+	/* Btree node accounting will be off: */
+	__set_bit_le64(BCH_FSCK_ERR_accounting_mismatch, ext->errors_silent);
+	ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_allocations) ?: ret;
+
+#ifdef CONFIG_BCACHEFS_DEBUG
+	/*
+	 * These are much more minor, and don't need to be corrected right away,
+	 * but in debug mode we want the next fsck run to be clean:
+	 */
+	ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_lrus) ?: ret;
+	ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_backpointers_to_extents) ?: ret;
+#endif
+
 	switch (btree) {
 	case BTREE_ID_alloc:
-		ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_allocations) ?: ret;
 		ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_alloc_info) ?: ret;
+
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_data_type_wrong, ext->errors_silent);
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_gen_wrong, ext->errors_silent);
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_dirty_sectors_wrong, ext->errors_silent);
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_cached_sectors_wrong, ext->errors_silent);
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_stripe_wrong, ext->errors_silent);
+		__set_bit_le64(BCH_FSCK_ERR_alloc_key_stripe_redundancy_wrong, ext->errors_silent);
 		goto out;
 	case BTREE_ID_backpointers:
 		ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_btree_backpointers) ?: ret;
@@ -75,7 +98,6 @@ int bch2_btree_lost_data(struct bch_fs *c, enum btree_id btree)
 		goto out;
 	default:
 		ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_scan_for_btree_nodes) ?: ret;
-		ret = bch2_run_explicit_recovery_pass_persistent_locked(c, BCH_RECOVERY_PASS_check_topology) ?: ret;
 		goto out;
 	}
 out:
@@ -748,9 +770,6 @@ int bch2_fs_recovery(struct bch_fs *c)
 		bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
-	if (c->opts.fsck && IS_ENABLED(CONFIG_BCACHEFS_DEBUG))
-		c->opts.recovery_passes |= BIT_ULL(BCH_RECOVERY_PASS_check_topology);
-
 	if (c->opts.fsck)
 		set_bit(BCH_FS_fsck_running, &c->flags);
 	if (c->sb.clean)
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 89d9dc2c859b..917ef6aa4a23 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -72,12 +72,12 @@ enum bch_fsck_flags {
 	x(btree_root_read_error,				 59,	FSCK_AUTOFIX)	\
 	x(btree_root_bad_min_key,				 60,	0)		\
 	x(btree_root_bad_max_key,				 61,	0)		\
-	x(btree_node_read_error,				 62,	0)		\
-	x(btree_node_topology_bad_min_key,			 63,	0)		\
-	x(btree_node_topology_bad_max_key,			 64,	0)		\
-	x(btree_node_topology_overwritten_by_prev_node,		 65,	0)		\
-	x(btree_node_topology_overwritten_by_next_node,		 66,	0)		\
-	x(btree_node_topology_interior_node_empty,		 67,	0)		\
+	x(btree_node_read_error,				 62,	FSCK_AUTOFIX)	\
+	x(btree_node_topology_bad_min_key,			 63,	FSCK_AUTOFIX)	\
+	x(btree_node_topology_bad_max_key,			 64,	FSCK_AUTOFIX)	\
+	x(btree_node_topology_overwritten_by_prev_node,		 65,	FSCK_AUTOFIX)	\
+	x(btree_node_topology_overwritten_by_next_node,		 66,	FSCK_AUTOFIX)	\
+	x(btree_node_topology_interior_node_empty,		 67,	FSCK_AUTOFIX)	\
 	x(fs_usage_hidden_wrong,				 68,	FSCK_AUTOFIX)	\
 	x(fs_usage_btree_wrong,					 69,	FSCK_AUTOFIX)	\
 	x(fs_usage_data_wrong,					 70,	FSCK_AUTOFIX)	\
-- 
2.45.2

