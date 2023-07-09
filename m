Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6905C001DF
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjGIRQM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjGIRQL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:11 -0400
Received: from out-32.mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8E7126
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bdXlaEsfaV5tyU7rVWBf0k3nYjNwNDcxwXv2ebTRlPQ=;
        b=pAvnlRoKDKim/xcIUie1WMxll0F0AaeBQWSX1Ui4LWcShHZXMuMNcio4alMpEAfosKzn1G
        6r+Gv4HsYnyhwf7Sex1/HcDf4ZpevIL9yWgXvRXJrIFmaMWPN1+hjsBZsDQdR4Bx/J8jBd
        YDBbA32dBD2ddj0BIQiw8wXy2PAp8Fk=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 09/10] bcachefs: Enumerate recovery passes
Date:   Sun,  9 Jul 2023 13:15:50 -0400
Message-Id: <20230709171551.2349961-10-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Recovery and fsck have many different passes/jobs to do, which always
run in the same order - but not all of them run all the time. Some are
for fsck, some for unclean shutdown, some for version upgrades.

This adds some new structure: a defined list of recovery passes that we
can run in a loop, as well as consolidating the log messages.

The main benefit is consolidating the "should run this recovery pass"
logic, as well as cleaning up the "this recovery pass has finished"
state; instead of having a bunch of ad-hoc state bits in c->flags, we've
now got c->curr_recovery_pass.

By consolidating the "should run this recovery pass" logic, in the
future on disk format upgrades will be able to say "upgrading to this
version requires x passes to run", instead of forcing all of fsck to
run.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  12 +-
 fs/bcachefs/alloc_foreground.c |   9 +-
 fs/bcachefs/backpointers.c     |   6 +-
 fs/bcachefs/bcachefs.h         |  49 ++++++-
 fs/bcachefs/btree_cache.c      |   2 +-
 fs/bcachefs/btree_gc.c         |   4 +-
 fs/bcachefs/fsck.c             |  77 ++---------
 fs/bcachefs/fsck.h             |  10 +-
 fs/bcachefs/recovery.c         | 227 +++++++++++++--------------------
 fs/bcachefs/subvolume.c        |  10 +-
 fs/bcachefs/subvolume.h        |   8 +-
 11 files changed, 175 insertions(+), 239 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 291d97f837..8d8481fc1e 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -286,7 +286,7 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
 
 	if (rw == WRITE &&
 	    !(flags & BKEY_INVALID_JOURNAL) &&
-	    test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags)) {
+	    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_btree_backpointers) {
 		unsigned i, bp_len = 0;
 
 		for (i = 0; i < BCH_ALLOC_V4_NR_BACKPOINTERS(a.v); i++)
@@ -336,7 +336,7 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
 			}
 
 			if (!a.v->io_time[READ] &&
-			    test_bit(BCH_FS_CHECK_ALLOC_TO_LRU_REFS_DONE, &c->flags)) {
+			    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_to_lru_refs) {
 				prt_printf(err, "cached bucket with read_time == 0");
 				return -BCH_ERR_invalid_bkey;
 			}
@@ -777,7 +777,7 @@ static int bch2_bucket_do_index(struct btree_trans *trans,
 		return ret;
 
 	if (ca->mi.freespace_initialized &&
-	    test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags) &&
+	    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info &&
 	    bch2_trans_inconsistent_on(old.k->type != old_type, trans,
 			"incorrect key when %s %s:%llu:%llu:0 (got %s should be %s)\n"
 			"  for %s",
@@ -1663,7 +1663,7 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 	}
 
 	if (a->v.journal_seq > c->journal.flushed_seq_ondisk) {
-		if (test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags)) {
+		if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
 			bch2_trans_inconsistent(trans,
 				"clearing need_discard but journal_seq %llu > flushed_seq %llu\n"
 				"%s",
@@ -1676,7 +1676,7 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 	}
 
 	if (a->v.data_type != BCH_DATA_need_discard) {
-		if (test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags)) {
+		if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
 			bch2_trans_inconsistent(trans,
 				"bucket incorrectly set in need_discard btree\n"
 				"%s",
@@ -1844,7 +1844,7 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&a->k_i));
 
 	bch_err(c, "%s", buf.buf);
-	if (test_bit(BCH_FS_CHECK_LRUS_DONE, &c->flags)) {
+	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_lrus) {
 		bch2_inconsistent_error(c);
 		ret = -EINVAL;
 	}
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 0cc5e9f8d4..06bfcc5a49 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -324,7 +324,7 @@ static struct open_bucket *try_alloc_bucket(struct btree_trans *trans, struct bc
 	a = bch2_alloc_to_v4(k, &a_convert);
 
 	if (a->data_type != BCH_DATA_free) {
-		if (!test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags)) {
+		if (c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_alloc_info) {
 			ob = NULL;
 			goto err;
 		}
@@ -340,7 +340,7 @@ static struct open_bucket *try_alloc_bucket(struct btree_trans *trans, struct bc
 	}
 
 	if (genbits != (alloc_freespace_genbits(*a) >> 56) &&
-	    test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags)) {
+	    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info) {
 		prt_printf(&buf, "bucket in freespace btree with wrong genbits (got %u should be %llu)\n"
 		       "  freespace key ",
 		       genbits, alloc_freespace_genbits(*a) >> 56);
@@ -350,10 +350,9 @@ static struct open_bucket *try_alloc_bucket(struct btree_trans *trans, struct bc
 		bch2_trans_inconsistent(trans, "%s", buf.buf);
 		ob = ERR_PTR(-EIO);
 		goto err;
-
 	}
 
-	if (!test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags)) {
+	if (c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_extents_to_backpointers) {
 		struct bch_backpointer bp;
 		struct bpos bp_pos = POS_MIN;
 
@@ -556,7 +555,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 	if (s.skipped_need_journal_commit * 2 > avail)
 		bch2_journal_flush_async(&c->journal, NULL);
 
-	if (!ob && freespace && !test_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags)) {
+	if (!ob && freespace && c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_alloc_info) {
 		freespace = false;
 		goto alloc;
 	}
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 571a7d19be..d412bae553 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -104,7 +104,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 
 		bch_err(c, "%s", buf.buf);
-	} else if (test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags)) {
+	} else if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers) {
 		prt_printf(&buf, "backpointer not found when deleting");
 		prt_newline(&buf);
 		printbuf_indent_add(&buf, 2);
@@ -125,7 +125,7 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 
 	printbuf_exit(&buf);
 
-	if (test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags)) {
+	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_check_extents_to_backpointers) {
 		bch2_inconsistent_error(c);
 		return -EIO;
 	} else {
@@ -258,7 +258,7 @@ static void backpointer_not_found(struct btree_trans *trans,
 	bch2_backpointer_to_text(&buf, &bp);
 	prt_printf(&buf, "\n  ");
 	bch2_bkey_val_to_text(&buf, c, k);
-	if (!test_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags))
+	if (c->curr_recovery_pass >= BCH_RECOVERY_PASS_check_extents_to_backpointers)
 		bch_err_ratelimited(c, "%s", buf.buf);
 	else
 		bch2_trans_inconsistent(trans, "%s", buf.buf);
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 67ed55761a..cfd4a7b9e8 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -564,11 +564,6 @@ enum {
 
 	/* fsck passes: */
 	BCH_FS_TOPOLOGY_REPAIR_DONE,
-	BCH_FS_INITIAL_GC_DONE,		/* kill when we enumerate fsck passes */
-	BCH_FS_CHECK_ALLOC_DONE,
-	BCH_FS_CHECK_LRUS_DONE,
-	BCH_FS_CHECK_BACKPOINTERS_DONE,
-	BCH_FS_CHECK_ALLOC_TO_LRU_REFS_DONE,
 	BCH_FS_FSCK_DONE,
 	BCH_FS_INITIAL_GC_UNFIXED,	/* kill when we enumerate fsck errors */
 	BCH_FS_NEED_ANOTHER_GC,
@@ -662,6 +657,48 @@ enum bch_write_ref {
 	BCH_WRITE_REF_NR,
 };
 
+#define PASS_SILENT		BIT(0)
+#define PASS_FSCK		BIT(1)
+#define PASS_UNCLEAN		BIT(2)
+#define PASS_ALWAYS		BIT(3)
+#define PASS_UPGRADE(v)		((v) << 4)
+
+#define BCH_RECOVERY_PASSES()									\
+	x(alloc_read,			PASS_ALWAYS)						\
+	x(stripes_read,			PASS_ALWAYS)						\
+	x(initialize_subvolumes,	PASS_UPGRADE(bcachefs_metadata_version_snapshot_2))	\
+	x(snapshots_read,		PASS_ALWAYS)						\
+	x(check_allocations,		PASS_FSCK)						\
+	x(set_may_go_rw,		PASS_ALWAYS|PASS_SILENT)				\
+	x(journal_replay,		PASS_ALWAYS)						\
+	x(check_alloc_info,		PASS_FSCK)						\
+	x(check_lrus,			PASS_FSCK)						\
+	x(check_btree_backpointers,	PASS_FSCK)						\
+	x(check_backpointers_to_extents,PASS_FSCK)						\
+	x(check_extents_to_backpointers,PASS_FSCK)						\
+	x(check_alloc_to_lru_refs,	PASS_FSCK)						\
+	x(fs_freespace_init,		PASS_ALWAYS|PASS_SILENT)				\
+	x(bucket_gens_init,		PASS_UPGRADE(bcachefs_metadata_version_bucket_gens))	\
+	x(fs_upgrade_for_subvolumes,	PASS_UPGRADE(bcachefs_metadata_version_snapshot_2))	\
+	x(check_snapshot_trees,		PASS_FSCK)						\
+	x(check_snapshots,		PASS_FSCK)						\
+	x(check_subvols,		PASS_FSCK)						\
+	x(delete_dead_snapshots,	PASS_FSCK|PASS_UNCLEAN|PASS_SILENT)			\
+	x(check_inodes,			PASS_FSCK|PASS_UNCLEAN)					\
+	x(check_extents,		PASS_FSCK)						\
+	x(check_dirents,		PASS_FSCK)						\
+	x(check_xattrs,			PASS_FSCK)						\
+	x(check_root,			PASS_FSCK)						\
+	x(check_directory_structure,	PASS_FSCK)						\
+	x(check_nlinks,			PASS_FSCK)						\
+	x(fix_reflink_p,		PASS_UPGRADE(bcachefs_metadata_version_reflink_p_fix))	\
+
+enum bch_recovery_pass {
+#define x(n, when)	BCH_RECOVERY_PASS_##n,
+	BCH_RECOVERY_PASSES()
+#undef x
+};
+
 struct bch_fs {
 	struct closure		cl;
 
@@ -996,6 +1033,8 @@ struct bch_fs {
 	/* RECOVERY */
 	u64			journal_replay_seq_start;
 	u64			journal_replay_seq_end;
+	enum bch_recovery_pass	curr_recovery_pass;
+
 	/* DEBUG JUNK */
 	struct dentry		*fs_debug_dir;
 	struct dentry		*btree_debug_dir;
diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
index 721e2b43e2..13c88d9533 100644
--- a/fs/bcachefs/btree_cache.c
+++ b/fs/bcachefs/btree_cache.c
@@ -825,7 +825,7 @@ static noinline void btree_bad_header(struct bch_fs *c, struct btree *b)
 {
 	struct printbuf buf = PRINTBUF;
 
-	if (!test_bit(BCH_FS_INITIAL_GC_DONE, &c->flags))
+	if (c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations)
 		return;
 
 	prt_printf(&buf,
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 1fc386761d..c47d5d8caa 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -1810,7 +1810,7 @@ int bch2_gc(struct bch_fs *c, bool initial, bool metadata_only)
 
 	if (IS_ENABLED(CONFIG_BCACHEFS_DEBUG) ||
 	    (BCH_SB_HAS_TOPOLOGY_ERRORS(c->disk_sb.sb) &&
-	     !test_bit(BCH_FS_INITIAL_GC_DONE, &c->flags) &&
+	     c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations &&
 	     c->opts.fix_errors != FSCK_OPT_NO)) {
 		bch_info(c, "Starting topology repair pass");
 		ret = bch2_repair_topology(c);
@@ -1825,7 +1825,7 @@ int bch2_gc(struct bch_fs *c, bool initial, bool metadata_only)
 
 	if (ret == -BCH_ERR_need_topology_repair &&
 	    !test_bit(BCH_FS_TOPOLOGY_REPAIR_DONE, &c->flags) &&
-	    !test_bit(BCH_FS_INITIAL_GC_DONE, &c->flags)) {
+	    c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations) {
 		set_bit(BCH_FS_NEED_ANOTHER_GC, &c->flags);
 		SET_BCH_SB_HAS_TOPOLOGY_ERRORS(c->disk_sb.sb, true);
 		ret = 0;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 98fde0bf6e..ddc2782fc5 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -350,7 +350,7 @@ static int lookup_lostfound(struct btree_trans *trans, u32 subvol,
 	}
 
 	/*
-	 * The check_dirents pass has already run, dangling dirents
+	 * The bch2_check_dirents pass has already run, dangling dirents
 	 * shouldn't exist here:
 	 */
 	return __lookup_inode(trans, inum, lostfound, &snapshot);
@@ -1008,8 +1008,9 @@ static int check_inode(struct btree_trans *trans,
 }
 
 noinline_for_stack
-static int check_inodes(struct bch_fs *c, bool full)
+int bch2_check_inodes(struct bch_fs *c)
 {
+	bool full = c->opts.fsck;
 	struct btree_trans trans;
 	struct btree_iter iter;
 	struct bch_inode_unpacked prev = { 0 };
@@ -1404,8 +1405,7 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
  * Walk extents: verify that extents have a corresponding S_ISREG inode, and
  * that i_size an i_sectors are consistent
  */
-noinline_for_stack
-static int check_extents(struct bch_fs *c)
+int bch2_check_extents(struct bch_fs *c)
 {
 	struct inode_walker w = inode_walker_init();
 	struct snapshots_seen s;
@@ -1419,8 +1419,6 @@ static int check_extents(struct bch_fs *c)
 	snapshots_seen_init(&s);
 	bch2_trans_init(&trans, c, BTREE_ITER_MAX, 0);
 
-	bch_verbose(c, "checking extents");
-
 	ret = for_each_btree_key_commit(&trans, iter, BTREE_ID_extents,
 			POS(BCACHEFS_ROOT_INO, 0),
 			BTREE_ITER_PREFETCH|BTREE_ITER_ALL_SNAPSHOTS, k,
@@ -1772,8 +1770,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
  * Walk dirents: verify that they all have a corresponding S_ISDIR inode,
  * validate d_type
  */
-noinline_for_stack
-static int check_dirents(struct bch_fs *c)
+int bch2_check_dirents(struct bch_fs *c)
 {
 	struct inode_walker dir = inode_walker_init();
 	struct inode_walker target = inode_walker_init();
@@ -1784,8 +1781,6 @@ static int check_dirents(struct bch_fs *c)
 	struct bkey_s_c k;
 	int ret = 0;
 
-	bch_verbose(c, "checking dirents");
-
 	snapshots_seen_init(&s);
 	bch2_trans_init(&trans, c, BTREE_ITER_MAX, 0);
 
@@ -1847,8 +1842,7 @@ static int check_xattr(struct btree_trans *trans, struct btree_iter *iter,
 /*
  * Walk xattrs: verify that they all have a corresponding inode
  */
-noinline_for_stack
-static int check_xattrs(struct bch_fs *c)
+int bch2_check_xattrs(struct bch_fs *c)
 {
 	struct inode_walker inode = inode_walker_init();
 	struct bch_hash_info hash_info;
@@ -1857,8 +1851,6 @@ static int check_xattrs(struct bch_fs *c)
 	struct bkey_s_c k;
 	int ret = 0;
 
-	bch_verbose(c, "checking xattrs");
-
 	bch2_trans_init(&trans, c, BTREE_ITER_MAX, 0);
 
 	ret = for_each_btree_key_commit(&trans, iter, BTREE_ID_xattrs,
@@ -1932,13 +1924,10 @@ static int check_root_trans(struct btree_trans *trans)
 }
 
 /* Get root directory, create if it doesn't exist: */
-noinline_for_stack
-static int check_root(struct bch_fs *c)
+int bch2_check_root(struct bch_fs *c)
 {
 	int ret;
 
-	bch_verbose(c, "checking root directory");
-
 	ret = bch2_trans_do(c, NULL, NULL,
 			     BTREE_INSERT_NOFAIL|
 			     BTREE_INSERT_LAZY_RW,
@@ -2089,11 +2078,10 @@ static int check_path(struct btree_trans *trans,
 
 /*
  * Check for unreachable inodes, as well as loops in the directory structure:
- * After check_dirents(), if an inode backpointer doesn't exist that means it's
+ * After bch2_check_dirents(), if an inode backpointer doesn't exist that means it's
  * unreachable:
  */
-noinline_for_stack
-static int check_directory_structure(struct bch_fs *c)
+int bch2_check_directory_structure(struct bch_fs *c)
 {
 	struct btree_trans trans;
 	struct btree_iter iter;
@@ -2376,15 +2364,12 @@ static int check_nlinks_update_hardlinks(struct bch_fs *c,
 	return 0;
 }
 
-noinline_for_stack
-static int check_nlinks(struct bch_fs *c)
+int bch2_check_nlinks(struct bch_fs *c)
 {
 	struct nlink_table links = { 0 };
 	u64 this_iter_range_start, next_iter_range_start = 0;
 	int ret = 0;
 
-	bch_verbose(c, "checking inode nlinks");
-
 	do {
 		this_iter_range_start = next_iter_range_start;
 		next_iter_range_start = U64_MAX;
@@ -2442,8 +2427,7 @@ static int fix_reflink_p_key(struct btree_trans *trans, struct btree_iter *iter,
 	return bch2_trans_update(trans, iter, &u->k_i, BTREE_TRIGGER_NORUN);
 }
 
-noinline_for_stack
-static int fix_reflink_p(struct bch_fs *c)
+int bch2_fix_reflink_p(struct bch_fs *c)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -2452,8 +2436,6 @@ static int fix_reflink_p(struct bch_fs *c)
 	if (c->sb.version >= bcachefs_metadata_version_reflink_p_fix)
 		return 0;
 
-	bch_verbose(c, "fixing reflink_p keys");
-
 	ret = bch2_trans_run(c,
 		for_each_btree_key_commit(&trans, iter,
 				BTREE_ID_extents, POS_MIN,
@@ -2466,40 +2448,3 @@ static int fix_reflink_p(struct bch_fs *c)
 		bch_err_fn(c, ret);
 	return ret;
 }
-
-/*
- * Checks for inconsistencies that shouldn't happen, unless we have a bug.
- * Doesn't fix them yet, mainly because they haven't yet been observed:
- */
-int bch2_fsck_full(struct bch_fs *c)
-{
-	int ret;
-again:
-	ret =   bch2_fs_check_snapshot_trees(c);
-		bch2_fs_check_snapshots(c) ?:
-		bch2_fs_check_subvols(c) ?:
-		bch2_delete_dead_snapshots(c) ?:
-		check_inodes(c, true) ?:
-		check_extents(c) ?:
-		check_dirents(c) ?:
-		check_xattrs(c) ?:
-		check_root(c) ?:
-		check_directory_structure(c) ?:
-		check_nlinks(c) ?:
-		fix_reflink_p(c);
-
-	if (bch2_err_matches(ret, BCH_ERR_need_snapshot_cleanup)) {
-		set_bit(BCH_FS_HAVE_DELETED_SNAPSHOTS, &c->flags);
-		goto again;
-	}
-
-	return ret;
-}
-
-int bch2_fsck_walk_inodes_only(struct bch_fs *c)
-{
-	return  bch2_fs_check_snapshots(c) ?:
-		bch2_fs_check_subvols(c) ?:
-		bch2_delete_dead_snapshots(c) ?:
-		check_inodes(c, false);
-}
diff --git a/fs/bcachefs/fsck.h b/fs/bcachefs/fsck.h
index 264f2706b1..90c87b5089 100644
--- a/fs/bcachefs/fsck.h
+++ b/fs/bcachefs/fsck.h
@@ -2,7 +2,13 @@
 #ifndef _BCACHEFS_FSCK_H
 #define _BCACHEFS_FSCK_H
 
-int bch2_fsck_full(struct bch_fs *);
-int bch2_fsck_walk_inodes_only(struct bch_fs *);
+int bch2_check_inodes(struct bch_fs *);
+int bch2_check_extents(struct bch_fs *);
+int bch2_check_dirents(struct bch_fs *);
+int bch2_check_xattrs(struct bch_fs *);
+int bch2_check_root(struct bch_fs *);
+int bch2_check_directory_structure(struct bch_fs *);
+int bch2_check_nlinks(struct bch_fs *);
+int bch2_fix_reflink_p(struct bch_fs *);
 
 #endif /* _BCACHEFS_FSCK_H */
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 1499efc9d2..3b9120bd36 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1028,7 +1028,7 @@ static int read_btree_roots(struct bch_fs *c)
 	return ret;
 }
 
-static int bch2_fs_initialize_subvolumes(struct bch_fs *c)
+static int bch2_initialize_subvolumes(struct bch_fs *c)
 {
 	struct bkey_i_snapshot_tree	root_tree;
 	struct bkey_i_snapshot		root_snapshot;
@@ -1139,6 +1139,88 @@ static void check_version_upgrade(struct bch_fs *c)
 	}
 }
 
+static int bch2_check_allocations(struct bch_fs *c)
+{
+	return bch2_gc(c, true, c->opts.norecovery);
+}
+
+static int bch2_set_may_go_rw(struct bch_fs *c)
+{
+	set_bit(BCH_FS_MAY_GO_RW, &c->flags);
+	return 0;
+}
+
+struct recovery_pass_fn {
+	int		(*fn)(struct bch_fs *);
+	const char	*name;
+	unsigned	when;
+};
+
+static struct recovery_pass_fn recovery_passes[] = {
+#define x(_fn, _when)	{ .fn = bch2_##_fn, .name = #_fn, .when = _when },
+	BCH_RECOVERY_PASSES()
+#undef x
+};
+
+static bool should_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
+{
+	struct recovery_pass_fn *p = recovery_passes + c->curr_recovery_pass;
+
+	if (c->opts.norecovery && pass > BCH_RECOVERY_PASS_snapshots_read)
+		return false;
+	if ((p->when & PASS_FSCK) && c->opts.fsck)
+		return true;
+	if ((p->when & PASS_UNCLEAN) && !c->sb.clean)
+		return true;
+	if (p->when & PASS_ALWAYS)
+		return true;
+	if (p->when >= PASS_UPGRADE(0) &&
+	    bch2_version_upgrading_to(c, p->when >> 4))
+		return true;
+	return false;
+}
+
+static int bch2_run_recovery_pass(struct bch_fs *c, enum bch_recovery_pass pass)
+{
+	int ret;
+
+	c->curr_recovery_pass = pass;
+
+	if (should_run_recovery_pass(c, pass)) {
+		struct recovery_pass_fn *p = recovery_passes + pass;
+
+		if (!(p->when & PASS_SILENT))
+			printk(KERN_INFO bch2_log_msg(c, "%s..."), p->name);
+		ret = p->fn(c);
+		if (ret)
+			return ret;
+		if (!(p->when & PASS_SILENT))
+			printk(KERN_CONT " done\n");
+	}
+
+	return 0;
+}
+
+static int bch2_run_recovery_passes(struct bch_fs *c)
+{
+	int ret = 0;
+again:
+	while (c->curr_recovery_pass < ARRAY_SIZE(recovery_passes)) {
+		ret = bch2_run_recovery_pass(c, c->curr_recovery_pass);
+		if (ret)
+			break;
+		c->curr_recovery_pass++;
+	}
+
+	if (bch2_err_matches(ret, BCH_ERR_need_snapshot_cleanup)) {
+		set_bit(BCH_FS_HAVE_DELETED_SNAPSHOTS, &c->flags);
+		c->curr_recovery_pass = BCH_RECOVERY_PASS_delete_dead_snapshots;
+		goto again;
+	}
+
+	return ret;
+}
+
 int bch2_fs_recovery(struct bch_fs *c)
 {
 	struct bch_sb_field_clean *clean = NULL;
@@ -1313,141 +1395,9 @@ int bch2_fs_recovery(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	bch_verbose(c, "starting alloc read");
-	ret = bch2_alloc_read(c);
-	if (ret)
-		goto err;
-	bch_verbose(c, "alloc read done");
-
-	bch_verbose(c, "starting stripes_read");
-	ret = bch2_stripes_read(c);
+	ret = bch2_run_recovery_passes(c);
 	if (ret)
 		goto err;
-	bch_verbose(c, "stripes_read done");
-
-	if (c->sb.version < bcachefs_metadata_version_snapshot_2) {
-		ret = bch2_fs_initialize_subvolumes(c);
-		if (ret)
-			goto err;
-	}
-
-	bch_verbose(c, "reading snapshots table");
-	ret = bch2_fs_snapshots_start(c);
-	if (ret)
-		goto err;
-	bch_verbose(c, "reading snapshots done");
-
-	if (c->opts.fsck) {
-		bool metadata_only = c->opts.norecovery;
-
-		bch_info(c, "checking allocations");
-		ret = bch2_gc(c, true, metadata_only);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking allocations");
-
-		set_bit(BCH_FS_INITIAL_GC_DONE, &c->flags);
-
-		set_bit(BCH_FS_MAY_GO_RW, &c->flags);
-
-		bch_info(c, "starting journal replay, %zu keys", c->journal_keys.nr);
-		ret = bch2_journal_replay(c);
-		if (ret)
-			goto err;
-		if (c->opts.verbose || !c->sb.clean)
-			bch_info(c, "journal replay done");
-
-		bch_info(c, "checking need_discard and freespace btrees");
-		ret = bch2_check_alloc_info(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking need_discard and freespace btrees");
-
-		set_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags);
-
-		bch_info(c, "checking lrus");
-		ret = bch2_check_lrus(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking lrus");
-		set_bit(BCH_FS_CHECK_LRUS_DONE, &c->flags);
-
-		bch_info(c, "checking backpointers to alloc keys");
-		ret = bch2_check_btree_backpointers(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking backpointers to alloc keys");
-
-		bch_info(c, "checking backpointers to extents");
-		ret = bch2_check_backpointers_to_extents(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking backpointers to extents");
-
-		bch_info(c, "checking extents to backpointers");
-		ret = bch2_check_extents_to_backpointers(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking extents to backpointers");
-		set_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags);
-
-		bch_info(c, "checking alloc to lru refs");
-		ret = bch2_check_alloc_to_lru_refs(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "done checking alloc to lru refs");
-		set_bit(BCH_FS_CHECK_ALLOC_TO_LRU_REFS_DONE, &c->flags);
-	} else {
-		set_bit(BCH_FS_INITIAL_GC_DONE, &c->flags);
-		set_bit(BCH_FS_CHECK_ALLOC_DONE, &c->flags);
-		set_bit(BCH_FS_CHECK_LRUS_DONE, &c->flags);
-		set_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags);
-		set_bit(BCH_FS_CHECK_ALLOC_TO_LRU_REFS_DONE, &c->flags);
-		set_bit(BCH_FS_FSCK_DONE, &c->flags);
-
-		if (c->opts.norecovery)
-			goto out;
-
-		set_bit(BCH_FS_MAY_GO_RW, &c->flags);
-
-		bch_verbose(c, "starting journal replay, %zu keys", c->journal_keys.nr);
-		ret = bch2_journal_replay(c);
-		if (ret)
-			goto err;
-		if (c->opts.verbose || !c->sb.clean)
-			bch_info(c, "journal replay done");
-	}
-
-	ret = bch2_fs_freespace_init(c);
-	if (ret)
-		goto err;
-
-	if (bch2_version_upgrading_to(c, bcachefs_metadata_version_bucket_gens)) {
-		bch_info(c, "initializing bucket_gens");
-		ret = bch2_bucket_gens_init(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "bucket_gens init done");
-	}
-
-	if (bch2_version_upgrading_to(c, bcachefs_metadata_version_snapshot_2)) {
-		ret = bch2_fs_upgrade_for_subvolumes(c);
-		if (ret)
-			goto err;
-	}
-
-	if (c->opts.fsck) {
-		ret = bch2_fsck_full(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "fsck done");
-	} else if (!c->sb.clean) {
-		bch_verbose(c, "checking for deleted inodes");
-		ret = bch2_fsck_walk_inodes_only(c);
-		if (ret)
-			goto err;
-		bch_verbose(c, "check inodes done");
-	}
 
 	if (enabled_qtypes(c)) {
 		bch_verbose(c, "reading quotas");
@@ -1548,10 +1498,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	}
 	mutex_unlock(&c->sb_lock);
 
-	set_bit(BCH_FS_INITIAL_GC_DONE, &c->flags);
-	set_bit(BCH_FS_CHECK_LRUS_DONE, &c->flags);
-	set_bit(BCH_FS_CHECK_BACKPOINTERS_DONE, &c->flags);
-	set_bit(BCH_FS_CHECK_ALLOC_TO_LRU_REFS_DONE, &c->flags);
+	c->curr_recovery_pass = ARRAY_SIZE(recovery_passes);
 	set_bit(BCH_FS_MAY_GO_RW, &c->flags);
 	set_bit(BCH_FS_FSCK_DONE, &c->flags);
 
@@ -1599,12 +1546,12 @@ int bch2_fs_initialize(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	ret = bch2_fs_initialize_subvolumes(c);
+	ret = bch2_initialize_subvolumes(c);
 	if (ret)
 		goto err;
 
 	bch_verbose(c, "reading snapshots table");
-	ret = bch2_fs_snapshots_start(c);
+	ret = bch2_snapshots_read(c);
 	if (ret)
 		goto err;
 	bch_verbose(c, "reading snapshots done");
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index f26397aa2b..f3852c433c 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -408,7 +408,7 @@ static int check_snapshot_tree(struct btree_trans *trans,
  * And, make sure it points to a subvolume within that snapshot tree, or correct
  * it to point to the oldest subvolume within that snapshot tree.
  */
-int bch2_fs_check_snapshot_trees(struct bch_fs *c)
+int bch2_check_snapshot_trees(struct bch_fs *c)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -612,7 +612,7 @@ static int check_snapshot(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_fs_check_snapshots(struct bch_fs *c)
+int bch2_check_snapshots(struct bch_fs *c)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -692,7 +692,7 @@ static int check_subvol(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_fs_check_subvols(struct bch_fs *c)
+int bch2_check_subvols(struct bch_fs *c)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -713,7 +713,7 @@ void bch2_fs_snapshots_exit(struct bch_fs *c)
 	genradix_free(&c->snapshots);
 }
 
-int bch2_fs_snapshots_start(struct bch_fs *c)
+int bch2_snapshots_read(struct bch_fs *c)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -1151,7 +1151,7 @@ static int bch2_delete_dead_snapshots_hook(struct btree_trans *trans,
 
 	set_bit(BCH_FS_HAVE_DELETED_SNAPSHOTS, &c->flags);
 
-	if (!test_bit(BCH_FS_FSCK_DONE, &c->flags))
+	if (c->curr_recovery_pass <= BCH_RECOVERY_PASS_delete_dead_snapshots)
 		return 0;
 
 	bch2_delete_dead_snapshots_async(c);
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index 105410e080..daa9a6b081 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -130,12 +130,12 @@ static inline int snapshot_list_add(struct bch_fs *c, snapshot_id_list *s, u32 i
 	return ret;
 }
 
-int bch2_fs_check_snapshot_trees(struct bch_fs *);
-int bch2_fs_check_snapshots(struct bch_fs *);
-int bch2_fs_check_subvols(struct bch_fs *);
+int bch2_check_snapshot_trees(struct bch_fs *);
+int bch2_check_snapshots(struct bch_fs *);
+int bch2_check_subvols(struct bch_fs *);
 
 void bch2_fs_snapshots_exit(struct bch_fs *);
-int bch2_fs_snapshots_start(struct bch_fs *);
+int bch2_snapshots_read(struct bch_fs *);
 
 int bch2_subvolume_invalid(const struct bch_fs *, struct bkey_s_c,
 			   unsigned, struct printbuf *);
-- 
2.40.1

