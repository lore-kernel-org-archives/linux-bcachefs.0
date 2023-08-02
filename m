Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB44FC001DF
	for <linux-bcachefs@archiver.kernel.org>; Wed,  2 Aug 2023 22:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbjHBWyG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 2 Aug 2023 18:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjHBWyG (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 2 Aug 2023 18:54:06 -0400
Received: from out-84.mta1.migadu.com (out-84.mta1.migadu.com [95.215.58.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD549B
        for <linux-bcachefs@vger.kernel.org>; Wed,  2 Aug 2023 15:54:04 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691016841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tuwIaqR3DqzQQpOJaV48Bi2ZDqaaLyaxNTrSV+cdxpE=;
        b=iuAToKbybp695Ytn2PTEpNXvS2Vn1W8wOqUW3P3mujGooJXULm+WCmnwCVnY8xqtdX1HkK
        rX3OFre1z4o0rOuk3uXEGfDo3CLw/wYk0HxEfqqAL9/MjWwBYvJCOEOyrwYn3E12aChMwv
        8ZMBZi1r/LroGjJGhQH8e1GyWJtOwUo=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: bcachefs_metadata_version_deleted_inodes
Date:   Wed,  2 Aug 2023 18:53:48 -0400
Message-Id: <20230802225348.3519160-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Add a new bitset btree for inodes pending deletion; this means we no
longer have to scan the full inodes btree after an unclean shutdown.

Specifically, this adds:
 - a trigger to update the deleted_inodes btree based on changes to the
   inodes btree
 - a new recovery pass
 - and check_inodes is now only a fsck pass.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |   4 +-
 fs/bcachefs/bcachefs_format.h |   8 ++-
 fs/bcachefs/inode.c           | 113 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/inode.h           |   1 +
 4 files changed, 123 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 82b0706a89..003f4d5ada 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -452,6 +452,7 @@ enum gc_phase {
 	GC_PHASE_BTREE_backpointers,
 	GC_PHASE_BTREE_bucket_gens,
 	GC_PHASE_BTREE_snapshot_trees,
+	GC_PHASE_BTREE_deleted_inodes,
 
 	GC_PHASE_PENDING_DELETE,
 };
@@ -682,13 +683,14 @@ enum bch_write_ref {
 	x(check_subvols,		PASS_FSCK)						\
 	x(delete_dead_snapshots,	PASS_FSCK|PASS_UNCLEAN)					\
 	x(fs_upgrade_for_subvolumes,	0)							\
-	x(check_inodes,			PASS_FSCK|PASS_UNCLEAN)					\
+	x(check_inodes,			PASS_FSCK)						\
 	x(check_extents,		PASS_FSCK)						\
 	x(check_dirents,		PASS_FSCK)						\
 	x(check_xattrs,			PASS_FSCK)						\
 	x(check_root,			PASS_FSCK)						\
 	x(check_directory_structure,	PASS_FSCK)						\
 	x(check_nlinks,			PASS_FSCK)						\
+	x(delete_dead_inodes,		PASS_FSCK|PASS_UNCLEAN)					\
 	x(fix_reflink_p,		0)							\
 
 enum bch_recovery_pass {
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index b771d80f63..5ec218ee35 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1629,7 +1629,9 @@ struct bch_sb_field_journal_seq_blacklist {
 	x(major_minor,			BCH_VERSION(1,  0),		\
 	  0)								\
 	x(snapshot_skiplists,		BCH_VERSION(1,  1),		\
-	  BIT_ULL(BCH_RECOVERY_PASS_check_snapshots))
+	  BIT_ULL(BCH_RECOVERY_PASS_check_snapshots))			\
+	x(deleted_inodes,		BCH_VERSION(1,  2),		\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
@@ -2251,7 +2253,9 @@ enum btree_id_flags {
 	x(bucket_gens,		14,	0,					\
 	  BIT_ULL(KEY_TYPE_bucket_gens))					\
 	x(snapshot_trees,	15,	0,					\
-	  BIT_ULL(KEY_TYPE_snapshot_tree))
+	  BIT_ULL(KEY_TYPE_snapshot_tree))					\
+	x(deleted_inodes,	16,	BTREE_ID_SNAPSHOTS,			\
+	  BIT_ULL(KEY_TYPE_set))
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 755cf7d177..fea21e1e57 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -2,6 +2,7 @@
 
 #include "bcachefs.h"
 #include "btree_key_cache.h"
+#include "btree_write_buffer.h"
 #include "bkey_methods.h"
 #include "btree_update.h"
 #include "buckets.h"
@@ -519,6 +520,23 @@ void bch2_inode_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c
 	__bch2_inode_unpacked_to_text(out, &inode);
 }
 
+static inline bool bkey_is_deleted_inode(struct bkey_s_c k)
+{
+	switch (k.k->type) {
+	case KEY_TYPE_inode:
+		return bkey_s_c_to_inode(k).v->bi_flags &
+			cpu_to_le32(BCH_INODE_UNLINKED);
+	case KEY_TYPE_inode_v2:
+		return bkey_s_c_to_inode_v2(k).v->bi_flags &
+			cpu_to_le32(BCH_INODE_UNLINKED);
+	case KEY_TYPE_inode_v3:
+		return bkey_s_c_to_inode_v3(k).v->bi_flags &
+			cpu_to_le64(BCH_INODE_UNLINKED);
+	default:
+		return false;
+	}
+}
+
 int bch2_trans_mark_inode(struct btree_trans *trans,
 			  enum btree_id btree_id, unsigned level,
 			  struct bkey_s_c old,
@@ -526,6 +544,8 @@ int bch2_trans_mark_inode(struct btree_trans *trans,
 			  unsigned flags)
 {
 	int nr = bkey_is_inode(&new->k) - bkey_is_inode(old.k);
+	bool old_deleted = bkey_is_deleted_inode(old);
+	bool new_deleted = bkey_is_deleted_inode(bkey_i_to_s_c(new));
 
 	if (nr) {
 		int ret = bch2_replicas_deltas_realloc(trans, 0);
@@ -537,6 +557,12 @@ int bch2_trans_mark_inode(struct btree_trans *trans,
 		d->nr_inodes += nr;
 	}
 
+	if (old_deleted != new_deleted) {
+		int ret = bch2_btree_bit_mod(trans, BTREE_ID_deleted_inodes, new->k.p, new_deleted);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -986,3 +1012,90 @@ int bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
 
 	return ret ?: -BCH_ERR_transaction_restart_nested;
 }
+
+static int may_delete_deleted_inode(struct btree_trans *trans, struct bpos pos)
+{
+	struct bch_fs *c = trans->c;
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	struct bch_inode_unpacked inode;
+	int ret;
+
+	if (bch2_snapshot_is_internal_node(c, pos.snapshot))
+		return 0;
+
+	if (!fsck_err_on(c->sb.clean, c,
+			 "filesystem marked as clean but have deleted inode %llu:%u",
+			 pos.offset, pos.snapshot))
+		return 0;
+
+	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_inodes, pos, BTREE_ITER_CACHED);
+	ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	ret = bkey_is_inode(k.k) ? 0 : -BCH_ERR_ENOENT_inode;
+	if (fsck_err_on(!bkey_is_inode(k.k), c,
+			"nonexistent inode %llu:%u in deleted_inodes btree",
+			pos.offset, pos.snapshot))
+		goto delete;
+
+	ret = bch2_inode_unpack(k, &inode);
+	if (ret)
+		goto err;
+
+	if (fsck_err_on(!(inode.bi_flags & BCH_INODE_UNLINKED), c,
+			"non-deleted inode %llu:%u in deleted_inodes btree",
+			pos.offset, pos.snapshot))
+		goto delete;
+
+	return 1;
+err:
+fsck_err:
+	return ret;
+delete:
+	return bch2_btree_bit_mod(trans, BTREE_ID_deleted_inodes, pos, false);
+}
+
+int bch2_delete_dead_inodes(struct bch_fs *c)
+{
+	struct btree_trans trans;
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret;
+
+	bch2_trans_init(&trans, c, 0, 0);
+
+	ret = bch2_btree_write_buffer_flush_sync(&trans);
+	if (ret)
+		goto err;
+
+	/*
+	 * Weird transaction restart handling here because on successful delete,
+	 * bch2_inode_rm_snapshot() will return a nested transaction restart,
+	 * but we can't retry because the btree write buffer won't have been
+	 * flushed and we'd spin:
+	 */
+	for_each_btree_key(&trans, iter, BTREE_ID_deleted_inodes, POS_MIN,
+			   BTREE_ITER_PREFETCH|BTREE_ITER_ALL_SNAPSHOTS, k, ret) {
+		ret = lockrestart_do(&trans, may_delete_deleted_inode(&trans, k.k->p));
+		if (ret < 0)
+			break;
+
+		if (ret) {
+			if (!test_bit(BCH_FS_RW, &c->flags)) {
+				bch2_trans_unlock(&trans);
+				bch2_fs_lazy_rw(c);
+			}
+
+			ret = bch2_inode_rm_snapshot(&trans, k.k->p.offset, k.k->p.snapshot);
+			if (ret && !bch2_err_matches(ret, BCH_ERR_transaction_restart))
+				break;
+		}
+	}
+	bch2_trans_iter_exit(&trans, &iter);
+err:
+	bch2_trans_exit(&trans);
+
+	return ret;
+}
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 1b9dc27e82..22b2440564 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -199,5 +199,6 @@ void bch2_inode_opts_get(struct bch_io_opts *, struct bch_fs *,
 			 struct bch_inode_unpacked *);
 
 int bch2_inode_rm_snapshot(struct btree_trans *, u64, u32);
+int bch2_delete_dead_inodes(struct bch_fs *);
 
 #endif /* _BCACHEFS_INODE_H */
-- 
2.40.1

