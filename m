Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37F415AADE
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153014; cv=none; b=ZWetGNyL21oSFoRsJbMfXKQMBggC+z3PAvwyf933omsE9WVsZj8eLiGB/8gwyt3XJ3RXAl4mgJxXaUYB+WHJp9tTS6qrYJb4i54Nw3/DoWzoFW7oHLgM/BvleAAfb1Qtr1Qwo5M5OKn/IKWqBmUo22WcFxpV3Bk3tYRIECNQZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153014; c=relaxed/simple;
	bh=A3Fy2oqErTJTZxxViXEfAXRdaiRCbvvYj6tTaWzvDHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plxasvayoMgUOMjgXvCyy5LXO96SppfsuoKa5NjBWEuVdIu0Wx4w0J3Siw3NdI+MEQcQ+y/L3xWdA/N8Xl71cjyAWgSuN7PcDB2NwYr5liFxlr+vgQQZjnin6B/G9YNqQF4I/Wu70hIj/bsbPUJ5l5T/AqjOGaAIw2ajVw58ch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zl2ToHvH; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zl2ToHvH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pCJkOaQbgKr6+Zjl7bwZ8ozMwGQuf37vkYdlYtiG1Iw=;
	b=Zl2ToHvHZvA9Cjs6MTYAS/ftpslOML4du8GtYyxIIO/FBA7g2pSGgJwDANYuows9vbC+jM
	cUhNBwkqlWxR70nRVba64Hpjvxz3VuBMk98k+QJGEikoYV7QbxRAH7NZTl484SWjaBd95C
	oIrU+mnDPLtaxOfW7f88Hr87GdAhkvY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/5] bcachefs: bcachefs_metadata_version_inode_has_child_snapshots
Date: Sat,  5 Oct 2024 14:29:52 -0400
Message-ID: <20241005182955.1588763-6-kent.overstreet@linux.dev>
In-Reply-To: <20241005182955.1588763-1-kent.overstreet@linux.dev>
References: <20241005182955.1588763-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There's an inherent race in taking a snapshot while an unlinked file is
open, and then reattaching it in the child snapshot.

In the interior snapshot node the file will appear unlinked, as though
it should be deleted - it's not referenced by anything in that snapshot
- but we can't delete it, because the file data is referenced by the
child snapshot.

This was being handled incorrectly with
propagate_key_to_snapshot_leaves() - but that doesn't resolve the
fundamental inconsistency of "this file looks like it should be deleted
according to normal rules, but - ".

To fix this, we need to fix the rule for when an inode is deleted. The
previous rule, ignoring snapshots (there was no well-defined rule
for with snapshots) was:
  Unlinked, non open files are deleted, either at recovery time or
  during online fsck

The new rule is:
  Unlinked, non open files, that do not exist in child snapshots, are
  deleted.

To make this work transactionally, we add a new inode flag,
BCH_INODE_has_child_snapshot; it overrides BCH_INODE_unlinked when
considering whether to delete an inode, or put it on the deleted list.

For transactional consistency, clearing it handled by the inode trigger:
when deleting an inode we check if there are parent inodes which can now
have the BCH_INODE_has_child_snapshot flag cleared.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h  |   3 +-
 fs/bcachefs/fs.c               |  21 ++-
 fs/bcachefs/fs.h               |   9 +-
 fs/bcachefs/fsck.c             |  51 +++-----
 fs/bcachefs/inode.c            | 233 ++++++++++++++++++++++++++++-----
 fs/bcachefs/inode.h            |  10 ++
 fs/bcachefs/inode_format.h     |   3 +-
 fs/bcachefs/sb-downgrade.c     |   5 +-
 fs/bcachefs/sb-errors_format.h |   4 +-
 9 files changed, 261 insertions(+), 78 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 84832c2d4df9..5004f6ba997c 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -678,7 +678,8 @@ struct bch_sb_field_ext {
 	x(disk_accounting_v2,		BCH_VERSION(1,  9))		\
 	x(disk_accounting_v3,		BCH_VERSION(1, 10))		\
 	x(disk_accounting_inum,		BCH_VERSION(1, 11))		\
-	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))
+	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))		\
+	x(inode_has_child_snapshots,	BCH_VERSION(1, 13))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 5bfc26d58270..23cae92d313d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -174,11 +174,30 @@ static const struct rhashtable_params bch2_vfs_inodes_params = {
 	.automatic_shrinking	= true,
 };
 
-struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
+static struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
 {
 	return rhashtable_lookup_fast(&c->vfs_inodes_table, &inum, bch2_vfs_inodes_params);
 }
 
+bool bch2_inode_is_open(struct bch_fs *c, struct bpos p)
+{
+	if (!test_bit(BCH_FS_started, &c->flags))
+		return false;
+
+	subvol_inum inum = {
+		.subvol = snapshot_t(c, p.snapshot)->subvol,
+		.inum	= p.offset,
+	};
+
+	/* snapshot tree interior node, can't safely delete while online (yet) */
+	if (!inum.subvol) {
+		bch_warn_ratelimited(c, "%s(): snapshot %u has no subvol, unlinked but can't safely delete", __func__, p.snapshot);
+		return true;
+	}
+
+	return __bch2_inode_hash_find(c, inum) != NULL;
+}
+
 static void __wait_on_freeing_inode(struct bch_fs *c,
 				    struct bch_inode_info *inode,
 				    subvol_inum inum)
diff --git a/fs/bcachefs/fs.h b/fs/bcachefs/fs.h
index da74ecc236e7..33a12b7c9c3c 100644
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -54,8 +54,6 @@ static inline subvol_inum inode_inum(struct bch_inode_info *inode)
 	return inode->ei_inum;
 }
 
-struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *, subvol_inum);
-
 /*
  * Set if we've gotten a btree error for this inode, and thus the vfs inode and
  * btree inode may be inconsistent:
@@ -181,6 +179,8 @@ void bch2_inode_update_after_write(struct btree_trans *,
 int __must_check bch2_write_inode(struct bch_fs *, struct bch_inode_info *,
 				  inode_set_fn, void *, unsigned);
 
+bool bch2_inode_is_open(struct bch_fs *c, struct bpos p);
+
 int bch2_setattr_nonsize(struct mnt_idmap *,
 			 struct bch_inode_info *,
 			 struct iattr *);
@@ -198,10 +198,7 @@ int bch2_vfs_init(void);
 
 #define bch2_inode_update_after_write(_trans, _inode, _inode_u, _fields)	({ do {} while (0); })
 
-static inline struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
-{
-	return NULL;
-}
+static inline bool bch2_inode_is_open(struct bch_fs *c, struct bpos p) { return false };
 
 static inline void bch2_evict_subvolume_inodes(struct bch_fs *c,
 					       snapshot_id_list *s) {}
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 171e3e47db5c..f0eb17e686af 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1096,22 +1096,6 @@ static int check_inode_dirent_inode(struct btree_trans *trans,
 	return ret;
 }
 
-static bool bch2_inode_is_open(struct bch_fs *c, struct bpos p)
-{
-	subvol_inum inum = {
-		.subvol = snapshot_t(c, p.snapshot)->subvol,
-		.inum	= p.offset,
-	};
-
-	/* snapshot tree corruption, can't safely delete */
-	if (!inum.subvol) {
-		bch_warn_ratelimited(c, "%s(): snapshot %u has no subvol, unlinked but can't safely delete", __func__, p.snapshot);
-		return true;
-	}
-
-	return __bch2_inode_hash_find(c, inum) != NULL;
-}
-
 static int check_inode(struct btree_trans *trans,
 		       struct btree_iter *iter,
 		       struct bkey_s_c k,
@@ -1184,28 +1168,27 @@ static int check_inode(struct btree_trans *trans,
 		ret = 0;
 	}
 
-	if ((u.bi_flags & BCH_INODE_unlinked) &&
-	    bch2_key_has_snapshot_overwrites(trans, BTREE_ID_inodes, k.k->p)) {
-		struct bpos new_min_pos;
-
-		ret = bch2_propagate_key_to_snapshot_leaves(trans, iter->btree_id, k, &new_min_pos);
-		if (ret)
-			goto err;
-
-		u.bi_flags &= ~BCH_INODE_unlinked;
-
-		ret = __bch2_fsck_write_inode(trans, &u);
+	ret = bch2_inode_has_child_snapshots(trans, k.k->p);
+	if (ret < 0)
+		goto err;
 
-		bch_err_msg(c, ret, "in fsck updating inode");
+	if (fsck_err_on(ret != !!(u.bi_flags & BCH_INODE_has_child_snapshot),
+			trans, inode_has_child_snapshots_wrong,
+			"inode has_child_snapshots flag wrong (should be %u)\n%s",
+			ret,
+			(printbuf_reset(&buf),
+			 bch2_inode_unpacked_to_text(&buf, &u),
+			 buf.buf))) {
 		if (ret)
-			goto err_noprint;
-
-		if (!bpos_eq(new_min_pos, POS_MIN))
-			bch2_btree_iter_set_pos(iter, bpos_predecessor(new_min_pos));
-		goto err_noprint;
+			u.bi_flags |= BCH_INODE_has_child_snapshot;
+		else
+			u.bi_flags &= !BCH_INODE_has_child_snapshot;
+		do_update = true;
 	}
+	ret = 0;
 
-	if (u.bi_flags & BCH_INODE_unlinked) {
+	if ((u.bi_flags & BCH_INODE_unlinked) &&
+	    !(u.bi_flags & BCH_INODE_has_child_snapshot)) {
 		if (!test_bit(BCH_FS_started, &c->flags)) {
 			/*
 			 * If we're not in online fsck, don't delete unlinked
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 74d7a42ba1a2..747b8bcd8049 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -12,6 +12,7 @@
 #include "error.h"
 #include "extents.h"
 #include "extent_update.h"
+#include "fs.h"
 #include "inode.h"
 #include "str_hash.h"
 #include "snapshot.h"
@@ -34,6 +35,8 @@ static const char * const bch2_inode_flag_strs[] = {
 };
 #undef  x
 
+static int delete_ancestor_snapshot_inodes(struct btree_trans *, struct bpos);
+
 static const u8 byte_table[8] = { 1, 2, 3, 4, 6, 8, 10, 13 };
 
 static int inode_decode_field(const u8 *in, const u8 *end,
@@ -575,9 +578,106 @@ static inline u64 bkey_inode_flags(struct bkey_s_c k)
 	}
 }
 
-static inline bool bkey_is_deleted_inode(struct bkey_s_c k)
+static inline bool bkey_is_unlinked_inode(struct bkey_s_c k)
+{
+	unsigned f = bkey_inode_flags(k) & BCH_INODE_unlinked;
+
+	return (f & BCH_INODE_unlinked) && !(f & BCH_INODE_has_child_snapshot);
+}
+
+static struct bkey_s_c
+bch2_bkey_get_iter_snapshot_parent(struct btree_trans *trans, struct btree_iter *iter,
+				   enum btree_id btree, struct bpos pos,
+				   unsigned flags)
+{
+	struct bch_fs *c = trans->c;
+	struct bkey_s_c k;
+	int ret = 0;
+
+	for_each_btree_key_upto_norestart(trans, *iter, btree,
+					  bpos_successor(pos),
+					  SPOS(pos.inode, pos.offset, U32_MAX),
+					  flags|BTREE_ITER_all_snapshots, k, ret)
+		if (bch2_snapshot_is_ancestor(c, pos.snapshot, k.k->p.snapshot))
+			return k;
+
+	bch2_trans_iter_exit(trans, iter);
+	return ret ? bkey_s_c_err(ret) : bkey_s_c_null;
+}
+
+static struct bkey_s_c
+bch2_inode_get_iter_snapshot_parent(struct btree_trans *trans, struct btree_iter *iter,
+				    struct bpos pos, unsigned flags)
 {
-	return bkey_inode_flags(k) & BCH_INODE_unlinked;
+	struct bkey_s_c k;
+again:
+	k = bch2_bkey_get_iter_snapshot_parent(trans, iter, BTREE_ID_inodes, pos, flags);
+	if (!k.k ||
+	    bkey_err(k) ||
+	    bkey_is_inode(k.k))
+		return k;
+
+	bch2_trans_iter_exit(trans, iter);
+	pos = k.k->p;
+	goto again;
+}
+
+int __bch2_inode_has_child_snapshots(struct btree_trans *trans, struct bpos pos)
+{
+	struct bch_fs *c = trans->c;
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret = 0;
+
+	for_each_btree_key_upto_norestart(trans, iter,
+			BTREE_ID_inodes, POS(0, pos.offset), bpos_predecessor(pos),
+			BTREE_ITER_all_snapshots|
+			BTREE_ITER_with_updates, k, ret)
+		if (bch2_snapshot_is_ancestor(c, k.k->p.snapshot, pos.snapshot) &&
+		    bkey_is_inode(k.k)) {
+			ret = 1;
+			break;
+		}
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+static int update_parent_inode_has_children(struct btree_trans *trans, struct bpos pos,
+					    bool have_child)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_inode_get_iter_snapshot_parent(trans,
+						&iter, pos, BTREE_ITER_with_updates);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+	if (!k.k)
+		return 0;
+
+	if (!have_child) {
+		ret = bch2_inode_has_child_snapshots(trans, k.k->p);
+		if (ret) {
+			ret = ret < 0 ? ret : 0;
+			goto err;
+		}
+	}
+
+	struct bch_inode_unpacked inode;
+	BUG_ON(bch2_inode_unpack(k, &inode));
+
+	if (have_child != !!(inode.bi_flags & BCH_INODE_has_child_snapshot)) {
+		if (have_child)
+			inode.bi_flags |= BCH_INODE_has_child_snapshot;
+		else
+			inode.bi_flags &= ~BCH_INODE_has_child_snapshot;
+
+		iter.snapshot = k.k->p.snapshot;
+		ret = bch2_inode_write_flags(trans, &iter, &inode,
+					     BTREE_UPDATE_internal_snapshot_node);
+	}
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
 }
 
 int bch2_trigger_inode(struct btree_trans *trans,
@@ -586,6 +686,8 @@ int bch2_trigger_inode(struct btree_trans *trans,
 		       struct bkey_s new,
 		       enum btree_iter_update_trigger_flags flags)
 {
+	struct bch_fs *c = trans->c;
+
 	if ((flags & BTREE_TRIGGER_atomic) && (flags & BTREE_TRIGGER_insert)) {
 		BUG_ON(!trans->journal_res.seq);
 		bkey_s_to_inode_v3(new).v->bi_journal_seq = cpu_to_le64(trans->journal_res.seq);
@@ -599,13 +701,31 @@ int bch2_trigger_inode(struct btree_trans *trans,
 			return ret;
 	}
 
-	int deleted_delta =	(int) bkey_is_deleted_inode(new.s_c) -
-				(int) bkey_is_deleted_inode(old);
-	if ((flags & BTREE_TRIGGER_transactional) && deleted_delta) {
-		int ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_deleted_inodes,
-						      new.k->p, deleted_delta > 0);
-		if (ret)
-			return ret;
+	if (flags & BTREE_TRIGGER_transactional) {
+		int unlinked_delta =	(int) bkey_is_unlinked_inode(new.s_c) -
+					(int) bkey_is_unlinked_inode(old);
+		if (unlinked_delta) {
+			int ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_deleted_inodes,
+							      new.k->p, unlinked_delta > 0);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * If we're creating or deleting an inode at this snapshot ID,
+		 * and there might be an inode in a parent snapshot ID, we might
+		 * need to set or clear the has_child_snapshot flag on the
+		 * parent.
+		 */
+		int deleted_delta = (int) bkey_is_inode(new.k) -
+				    (int) bkey_is_inode(old.k);
+		if (deleted_delta &&
+		    bch2_snapshot_parent(c, new.k->p.snapshot)) {
+			int ret = update_parent_inode_has_children(trans, new.k->p,
+								   deleted_delta > 0);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -888,6 +1008,11 @@ int bch2_inode_rm(struct bch_fs *c, subvol_inum inum)
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		goto retry;
 
+	if (ret)
+		goto err2;
+
+	ret = delete_ancestor_snapshot_inodes(trans, SPOS(0, inum.inum, snapshot));
+err2:
 	bch2_trans_put(trans);
 	return ret;
 }
@@ -992,7 +1117,7 @@ int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_i
 	return 0;
 }
 
-int bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
+static noinline int __bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter = { NULL };
@@ -1055,6 +1180,44 @@ int bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
 	return ret ?: -BCH_ERR_transaction_restart_nested;
 }
 
+/*
+ * After deleting an inode, there may be versions in older snapshots that should
+ * also be deleted - if they're not referenced by sibling snapshots and not open
+ * in other subvolumes:
+ */
+static int delete_ancestor_snapshot_inodes(struct btree_trans *trans, struct bpos pos)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret;
+next_parent:
+	ret = lockrestart_do(trans,
+		bkey_err(k = bch2_inode_get_iter_snapshot_parent(trans, &iter, pos, 0)));
+	if (ret || !k.k)
+		return ret;
+
+	bool unlinked = bkey_is_unlinked_inode(k);
+	pos = k.k->p;
+	bch2_trans_iter_exit(trans, &iter);
+
+	if (!unlinked)
+		return 0;
+
+	if (bch2_inode_is_open(trans->c, pos))
+		return 0;
+
+	ret = __bch2_inode_rm_snapshot(trans, pos.offset, pos.snapshot);
+	if (ret)
+		return ret;
+	goto next_parent;
+}
+
+int bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
+{
+	return __bch2_inode_rm_snapshot(trans, inum, snapshot) ?:
+		delete_ancestor_snapshot_inodes(trans, SPOS(0, inum, snapshot));
+}
+
 static int may_delete_deleted_inode(struct btree_trans *trans,
 				    struct btree_iter *iter,
 				    struct bpos pos,
@@ -1064,6 +1227,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 	struct btree_iter inode_iter;
 	struct bkey_s_c k;
 	struct bch_inode_unpacked inode;
+	struct printbuf buf = PRINTBUF;
 	int ret;
 
 	k = bch2_bkey_get_iter(trans, &inode_iter, BTREE_ID_inodes, pos, BTREE_ITER_cached);
@@ -1099,6 +1263,31 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 			pos.offset, pos.snapshot))
 		goto delete;
 
+	if (fsck_err_on(inode.bi_flags & BCH_INODE_has_child_snapshot,
+			trans, deleted_inode_has_child_snapshots,
+			"inode with child snapshots %llu:%u in deleted_inodes btree",
+			pos.offset, pos.snapshot))
+		goto delete;
+
+	ret = bch2_inode_has_child_snapshots(trans, k.k->p);
+	if (ret < 0)
+		goto out;
+
+	if (ret) {
+		if (fsck_err(trans, inode_has_child_snapshots_wrong,
+			     "inode has_child_snapshots flag wrong (should be set)\n%s",
+			     (printbuf_reset(&buf),
+			      bch2_inode_unpacked_to_text(&buf, &inode),
+			      buf.buf))) {
+			inode.bi_flags |= BCH_INODE_has_child_snapshot;
+			ret = __bch2_fsck_write_inode(trans, &inode);
+			if (ret)
+				goto out;
+		}
+		goto delete;
+
+	}
+
 	if (test_bit(BCH_FS_clean_recovery, &c->flags) &&
 	    !fsck_err(trans, deleted_inode_but_clean,
 		      "filesystem marked as clean but have deleted inode %llu:%u",
@@ -1107,33 +1296,11 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 		goto out;
 	}
 
-	if (bch2_snapshot_is_internal_node(c, pos.snapshot)) {
-		struct bpos new_min_pos;
-
-		ret = bch2_propagate_key_to_snapshot_leaves(trans, inode_iter.btree_id, k, &new_min_pos);
-		if (ret)
-			goto out;
-
-		inode.bi_flags &= ~BCH_INODE_unlinked;
-
-		ret = bch2_inode_write_flags(trans, &inode_iter, &inode,
-					     BTREE_UPDATE_internal_snapshot_node);
-		bch_err_msg(c, ret, "clearing inode unlinked flag");
-		if (ret)
-			goto out;
-
-		/*
-		 * We'll need another write buffer flush to pick up the new
-		 * unlinked inodes in the snapshot leaves:
-		 */
-		*need_another_pass = true;
-		goto out;
-	}
-
 	ret = 1;
 out:
 fsck_err:
 	bch2_trans_iter_exit(trans, &inode_iter);
+	printbuf_exit(&buf);
 	return ret;
 delete:
 	ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_deleted_inodes, pos, false);
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 9c1f67705684..c8e98443e2d4 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -5,6 +5,7 @@
 #include "bkey.h"
 #include "bkey_methods.h"
 #include "opts.h"
+#include "snapshot.h"
 
 enum bch_validate_flags;
 extern const char * const bch2_inode_opts[];
@@ -17,6 +18,15 @@ int bch2_inode_v3_validate(struct bch_fs *, struct bkey_s_c,
 			  enum bch_validate_flags);
 void bch2_inode_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 
+int __bch2_inode_has_child_snapshots(struct btree_trans *, struct bpos);
+
+static inline int bch2_inode_has_child_snapshots(struct btree_trans *trans, struct bpos pos)
+{
+	return bch2_snapshot_is_leaf(trans->c, pos.snapshot) <= 0
+		? __bch2_inode_has_child_snapshots(trans, pos)
+		: 0;
+}
+
 int bch2_trigger_inode(struct btree_trans *, enum btree_id, unsigned,
 		       struct bkey_s_c, struct bkey_s,
 		       enum btree_iter_update_trigger_flags);
diff --git a/fs/bcachefs/inode_format.h b/fs/bcachefs/inode_format.h
index 83d107331edf..a204e46b6b47 100644
--- a/fs/bcachefs/inode_format.h
+++ b/fs/bcachefs/inode_format.h
@@ -133,7 +133,8 @@ enum inode_opt_id {
 	x(i_size_dirty,			5)	\
 	x(i_sectors_dirty,		6)	\
 	x(unlinked,			7)	\
-	x(backptr_untrusted,		8)
+	x(backptr_untrusted,		8)	\
+	x(has_child_snapshot,		9)
 
 /* bits 20+ reserved for packed fields below: */
 
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 5102059a0f1d..ae715ff658e8 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -78,7 +78,10 @@
 	  BCH_FSCK_ERR_accounting_mismatch)			\
 	x(rebalance_work_acct_fix,				\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
-	  BCH_FSCK_ERR_accounting_mismatch)
+	  BCH_FSCK_ERR_accounting_mismatch)			\
+	x(inode_has_child_snapshots,				\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
+	  BCH_FSCK_ERR_inode_has_child_snapshots_wrong)
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 4135b1ea2fec..4cdddf15d752 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -225,11 +225,13 @@ enum bch_fsck_flags {
 	x(inode_multiple_links_but_nlink_0,			207,	FSCK_AUTOFIX)	\
 	x(inode_wrong_backpointer,				208,	FSCK_AUTOFIX)	\
 	x(inode_wrong_nlink,					209,	FSCK_AUTOFIX)	\
+	x(inode_has_child_snapshots_wrong,			287,	0)		\
 	x(inode_unreachable,					210,	FSCK_AUTOFIX)	\
 	x(deleted_inode_but_clean,				211,	FSCK_AUTOFIX)	\
 	x(deleted_inode_missing,				212,	FSCK_AUTOFIX)	\
 	x(deleted_inode_is_dir,					213,	FSCK_AUTOFIX)	\
 	x(deleted_inode_not_unlinked,				214,	FSCK_AUTOFIX)	\
+	x(deleted_inode_has_child_snapshots,			288,	FSCK_AUTOFIX)	\
 	x(extent_overlapping,					215,	0)		\
 	x(key_in_missing_inode,					216,	0)		\
 	x(key_in_wrong_inode_type,				217,	0)		\
@@ -298,7 +300,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							287,	0)
+	x(MAX,							289,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.45.2

