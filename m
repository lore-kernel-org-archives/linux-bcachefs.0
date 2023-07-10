Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1523EB64D9
	for <linux-bcachefs@archiver.kernel.org>; Mon, 10 Jul 2023 15:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjGJPeL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 10 Jul 2023 11:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjGJPeK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 10 Jul 2023 11:34:10 -0400
Received: from out-37.mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2A4D1
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jul 2023 08:34:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689003245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MBX6EByaa1pzPR9c9RmYBFhby4qTZLjc97odjt8WSfo=;
        b=qkvZmF62OqU4aXwGTdcKzAZhZ3ljrNVOeOlr/Q0VooK8XUqqLQ5DNV5s1RJH75LTvdPNKU
        CVCAHzpS1ubMfyuBmtLjg0UBS7g7Ey4RBdPf+jxseHGPG2w2e7Foxvlq5CUWFtArh+AtpX
        VkY0EULHfhJqg+BmwnF9uLKwrfIWCBw=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Snapshot depth, skiplist fields
Date:   Mon, 10 Jul 2023 11:33:53 -0400
Message-Id: <20230710153353.3703069-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This extents KEY_TYPE_snapshot to include some new fields:
 - depth, to indicate depth of this particular node from the root
 - skip[3], skiplist entries for quickly walking back up to the root

These are to improve bch2_snapshot_is_ancestor(), making it O(ln(n))
instead of O(n) in the snapshot tree depth.

Skiplist nodes are picked at random from the set of ancestor nodes, not
some fixed fraction.

This introduces bcachefs_metadata_version 1.1, snapshot_skiplists.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |   5 +-
 fs/bcachefs/btree_iter.h      |   8 ++
 fs/bcachefs/fsck.c            |  10 +-
 fs/bcachefs/recovery.c        |   7 +-
 fs/bcachefs/subvolume.c       | 240 +++++++++++++++++++++++++++-------
 fs/bcachefs/subvolume.h       |  33 ++++-
 fs/bcachefs/subvolume_types.h |   2 +
 7 files changed, 242 insertions(+), 63 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 78771d8d8a..707d4f76fb 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1148,6 +1148,8 @@ struct bch_snapshot {
 	__le32			children[2];
 	__le32			subvol;
 	__le32			tree;
+	__le32			depth;
+	__le32			skip[3];
 };
 
 LE32_BITMASK(BCH_SNAPSHOT_DELETED,	struct bch_snapshot, flags,  0,  1)
@@ -1599,7 +1601,8 @@ struct bch_sb_field_journal_seq_blacklist {
 	x(fragmentation_lru,		BCH_VERSION(0, 27))		\
 	x(no_bps_in_alloc_keys,		BCH_VERSION(0, 28))		\
 	x(snapshot_trees,		BCH_VERSION(0, 29))		\
-	x(major_minor,			BCH_VERSION(1,  0))
+	x(major_minor,			BCH_VERSION(1,  0))		\
+	x(snapshot_skiplists,		BCH_VERSION(1,  1))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 0e9c1cb98a..c472aa8c58 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -795,6 +795,14 @@ __bch2_btree_iter_peek_upto_and_restart(struct btree_trans *trans,
 			    (_do) ?: bch2_trans_commit(_trans, (_disk_res),\
 					(_journal_seq), (_commit_flags)))
 
+#define for_each_btree_key_reverse_commit(_trans, _iter, _btree_id,	\
+				  _start, _iter_flags, _k,		\
+				  _disk_res, _journal_seq, _commit_flags,\
+				  _do)					\
+	for_each_btree_key_reverse(_trans, _iter, _btree_id, _start, _iter_flags, _k,\
+			    (_do) ?: bch2_trans_commit(_trans, (_disk_res),\
+					(_journal_seq), (_commit_flags)))
+
 #define for_each_btree_key_upto_commit(_trans, _iter, _btree_id,	\
 				  _start, _end, _iter_flags, _k,	\
 				  _disk_res, _journal_seq, _commit_flags,\
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index ddc2782fc5..581143a770 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -541,13 +541,13 @@ static bool key_visible_in_snapshot(struct bch_fs *c, struct snapshots_seen *see
 	ssize_t i;
 	u32 top = seen->ids.nr ? seen->ids.data[seen->ids.nr - 1].equiv : 0;
 
-	BUG_ON(id > ancestor);
-	BUG_ON(!bch2_snapshot_is_equiv(c, id));
-	BUG_ON(!bch2_snapshot_is_equiv(c, ancestor));
+	EBUG_ON(id > ancestor);
+	EBUG_ON(!bch2_snapshot_is_equiv(c, id));
+	EBUG_ON(!bch2_snapshot_is_equiv(c, ancestor));
 
 	/* @ancestor should be the snapshot most recently added to @seen */
-	BUG_ON(ancestor != seen->pos.snapshot);
-	BUG_ON(ancestor != top);
+	EBUG_ON(ancestor != seen->pos.snapshot);
+	EBUG_ON(ancestor != top);
 
 	if (id == ancestor)
 		return true;
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index cf59baf20f..b9b34c177f 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -593,8 +593,7 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 	struct btree_iter iter;
 	unsigned iter_flags =
 		BTREE_ITER_INTENT|
-		BTREE_ITER_NOT_EXTENTS|
-		BTREE_UPDATE_KEY_CACHE_RECLAIM;
+		BTREE_ITER_NOT_EXTENTS;
 	int ret;
 
 	if (!k->level && k->btree_id == BTREE_ID_alloc)
@@ -611,7 +610,9 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 	if (k->overwritten)
 		goto out;
 
-	ret = bch2_trans_update(trans, &iter, k->k, BTREE_TRIGGER_NORUN);
+	ret = bch2_trans_update(trans, &iter, k->k,
+				BTREE_TRIGGER_NORUN|
+				BTREE_UPDATE_KEY_CACHE_RECLAIM);
 out:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index f3852c433c..144179608b 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -8,8 +8,41 @@
 #include "fs.h"
 #include "subvolume.h"
 
+#include <linux/random.h>
+
 static int bch2_subvolume_delete(struct btree_trans *, u32);
 
+static inline u32 get_ancestor_below(struct bch_fs *c, u32 id, u32 ancestor)
+{
+	struct snapshot_t *s = snapshot_t(c, id);
+
+	if (s->skip[2] <= ancestor)
+		return s->skip[2];
+	if (s->skip[1] <= ancestor)
+		return s->skip[1];
+	if (s->skip[0] <= ancestor)
+		return s->skip[0];
+	return s->parent;
+}
+
+bool bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
+{
+	EBUG_ON(c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_snapshots);
+
+	while (id && id < ancestor)
+		id = get_ancestor_below(c, id, ancestor);
+
+	return id == ancestor;
+}
+
+static bool bch2_snapshot_is_ancestor_early(struct bch_fs *c, u32 id, u32 ancestor)
+{
+	while (id && id < ancestor)
+		id = snapshot_t(c, id)->parent;
+
+	return id == ancestor;
+}
+
 /* Snapshot tree: */
 
 void bch2_snapshot_tree_to_text(struct printbuf *out, struct bch_fs *c,
@@ -140,6 +173,25 @@ int bch2_snapshot_invalid(const struct bch_fs *c, struct bkey_s_c k,
 		}
 	}
 
+	if (bkey_val_bytes(k.k) > offsetof(struct bch_snapshot, skip)) {
+		if (le32_to_cpu(s.v->skip[0]) > le32_to_cpu(s.v->skip[1]) ||
+		    le32_to_cpu(s.v->skip[1]) > le32_to_cpu(s.v->skip[2])) {
+			prt_printf(err, "skiplist not normalized");
+			return -BCH_ERR_invalid_bkey;
+		}
+
+		for (i = 0; i < ARRAY_SIZE(s.v->skip); i++) {
+			id = le32_to_cpu(s.v->skip[i]);
+
+			if (!id != !s.v->parent ||
+			    (s.v->parent &&
+			     id <= k.k->p.offset)) {
+				prt_printf(err, "bad skiplist node %u)", id);
+				return -BCH_ERR_invalid_bkey;
+			}
+		}
+	}
+
 	return 0;
 }
 
@@ -161,10 +213,17 @@ int bch2_mark_snapshot(struct btree_trans *trans,
 		struct bkey_s_c_snapshot s = bkey_s_c_to_snapshot(new);
 
 		t->parent	= le32_to_cpu(s.v->parent);
+		t->skip[0]	= le32_to_cpu(s.v->skip[0]);
+		t->skip[1]	= le32_to_cpu(s.v->skip[1]);
+		t->skip[2]	= le32_to_cpu(s.v->skip[2]);
+		t->depth	= le32_to_cpu(s.v->depth);
 		t->children[0]	= le32_to_cpu(s.v->children[0]);
 		t->children[1]	= le32_to_cpu(s.v->children[1]);
 		t->subvol	= BCH_SNAPSHOT_SUBVOL(s.v) ? le32_to_cpu(s.v->subvol) : 0;
 		t->tree		= le32_to_cpu(s.v->tree);
+
+		if (BCH_SNAPSHOT_DELETED(s.v))
+			set_bit(BCH_FS_HAVE_DELETED_SNAPSHOTS, &c->flags);
 	} else {
 		t->parent	= 0;
 		t->children[0]	= 0;
@@ -370,9 +429,9 @@ static int check_snapshot_tree(struct btree_trans *trans,
 			"snapshot tree points to missing subvolume:\n  %s",
 			(printbuf_reset(&buf),
 			 bch2_bkey_val_to_text(&buf, c, st.s_c), buf.buf)) ||
-	    fsck_err_on(!bch2_snapshot_is_ancestor(c,
-						   le32_to_cpu(subvol.snapshot),
-						   root_id), c,
+	    fsck_err_on(!bch2_snapshot_is_ancestor_early(c,
+						le32_to_cpu(subvol.snapshot),
+						root_id), c,
 			"snapshot tree points to subvolume that does not point to snapshot in this tree:\n  %s",
 			(printbuf_reset(&buf),
 			 bch2_bkey_val_to_text(&buf, c, st.s_c), buf.buf)) ||
@@ -414,6 +473,8 @@ int bch2_check_snapshot_trees(struct bch_fs *c)
 	struct bkey_s_c k;
 	int ret;
 
+	bch_verbose(c, "checking snapshot trees");
+
 	ret = bch2_trans_run(c,
 		for_each_btree_key_commit(&trans, iter,
 			BTREE_ID_snapshot_trees, POS_MIN,
@@ -441,7 +502,48 @@ static int snapshot_tree_ptr_good(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	return bch2_snapshot_is_ancestor(trans->c, snap_id, le32_to_cpu(s_t.root_snapshot));
+	return bch2_snapshot_is_ancestor_early(trans->c, snap_id, le32_to_cpu(s_t.root_snapshot));
+}
+
+static u32 snapshot_rand_ancestor_get(struct bch_fs *c, u32 id)
+{
+	struct snapshot_t *s;
+
+	if (!id)
+		return 0;
+
+	s = snapshot_t(c, id);
+	if (!s->parent)
+		return id;
+
+	return bch2_snapshot_nth_parent(c, id, get_random_u32_below(s->depth));
+}
+
+static int snapshot_rand_ancestor_good(struct btree_trans *trans,
+				       struct bch_snapshot s)
+{
+	struct bch_snapshot a;
+	unsigned i;
+	int ret;
+
+	for (i = 0; i < 3; i++) {
+		if (!s.parent != !s.skip[i])
+			return false;
+
+		if (!s.parent)
+			continue;
+
+		ret = snapshot_lookup(trans, le32_to_cpu(s.skip[i]), &a);
+		if (bch2_err_matches(ret, ENOENT))
+			return false;
+		if (ret)
+			return ret;
+
+		if (a.tree != s.tree)
+			return false;
+	}
+
+	return true;
 }
 
 /*
@@ -451,14 +553,15 @@ static int snapshot_tree_ptr_good(struct btree_trans *trans,
  */
 static int snapshot_tree_ptr_repair(struct btree_trans *trans,
 				    struct btree_iter *iter,
-				    struct bkey_s_c_snapshot *s)
+				    struct bkey_s_c k,
+				    struct bch_snapshot *s)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter root_iter;
 	struct bch_snapshot_tree s_t;
 	struct bkey_s_c_snapshot root;
 	struct bkey_i_snapshot *u;
-	u32 root_id = bch2_snapshot_root(c, s->k->p.offset), tree_id;
+	u32 root_id = bch2_snapshot_root(c, k.k->p.offset), tree_id;
 	int ret;
 
 	root = bch2_bkey_get_iter_typed(trans, &root_iter,
@@ -484,18 +587,18 @@ static int snapshot_tree_ptr_repair(struct btree_trans *trans,
 			goto err;
 
 		u->v.tree = cpu_to_le32(tree_id);
-		if (s->k->p.snapshot == root_id)
-			*s = snapshot_i_to_s_c(u);
+		if (k.k->p.offset == root_id)
+			*s = u->v;
 	}
 
-	if (s->k->p.snapshot != root_id) {
-		u = bch2_bkey_make_mut_typed(trans, iter, &s->s_c, 0, snapshot);
+	if (k.k->p.offset != root_id) {
+		u = bch2_bkey_make_mut_typed(trans, iter, &k, 0, snapshot);
 		ret = PTR_ERR_OR_ZERO(u);
 		if (ret)
 			goto err;
 
 		u->v.tree = cpu_to_le32(tree_id);
-		*s = snapshot_i_to_s_c(u);
+		*s = u->v;
 	}
 err:
 	bch2_trans_iter_exit(trans, &root_iter);
@@ -507,9 +610,14 @@ static int check_snapshot(struct btree_trans *trans,
 			  struct bkey_s_c k)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_s_c_snapshot s;
+	struct bch_snapshot s;
 	struct bch_subvolume subvol;
 	struct bch_snapshot v;
+	struct bkey_i_snapshot *u;
+	u32 parent_id = bch2_snapshot_parent_early(c, k.k->p.offset);
+	struct snapshot_t *parent = parent_id
+		? snapshot_t(c, parent_id)
+		: NULL;
 	struct printbuf buf = PRINTBUF;
 	bool should_have_subvol;
 	u32 i, id;
@@ -518,94 +626,119 @@ static int check_snapshot(struct btree_trans *trans,
 	if (k.k->type != KEY_TYPE_snapshot)
 		return 0;
 
-	s = bkey_s_c_to_snapshot(k);
-	id = le32_to_cpu(s.v->parent);
+	memset(&s, 0, sizeof(s));
+	memcpy(&s, k.v, bkey_val_bytes(k.k));
+
+	id = le32_to_cpu(s.parent);
 	if (id) {
 		ret = snapshot_lookup(trans, id, &v);
 		if (bch2_err_matches(ret, ENOENT))
 			bch_err(c, "snapshot with nonexistent parent:\n  %s",
-				(bch2_bkey_val_to_text(&buf, c, s.s_c), buf.buf));
+				(bch2_bkey_val_to_text(&buf, c, k), buf.buf));
 		if (ret)
 			goto err;
 
-		if (le32_to_cpu(v.children[0]) != s.k->p.offset &&
-		    le32_to_cpu(v.children[1]) != s.k->p.offset) {
+		if (le32_to_cpu(v.children[0]) != k.k->p.offset &&
+		    le32_to_cpu(v.children[1]) != k.k->p.offset) {
 			bch_err(c, "snapshot parent %u missing pointer to child %llu",
-				id, s.k->p.offset);
+				id, k.k->p.offset);
 			ret = -EINVAL;
 			goto err;
 		}
 	}
 
-	for (i = 0; i < 2 && s.v->children[i]; i++) {
-		id = le32_to_cpu(s.v->children[i]);
+	for (i = 0; i < 2 && s.children[i]; i++) {
+		id = le32_to_cpu(s.children[i]);
 
 		ret = snapshot_lookup(trans, id, &v);
 		if (bch2_err_matches(ret, ENOENT))
 			bch_err(c, "snapshot node %llu has nonexistent child %u",
-				s.k->p.offset, id);
+				k.k->p.offset, id);
 		if (ret)
 			goto err;
 
-		if (le32_to_cpu(v.parent) != s.k->p.offset) {
+		if (le32_to_cpu(v.parent) != k.k->p.offset) {
 			bch_err(c, "snapshot child %u has wrong parent (got %u should be %llu)",
-				id, le32_to_cpu(v.parent), s.k->p.offset);
+				id, le32_to_cpu(v.parent), k.k->p.offset);
 			ret = -EINVAL;
 			goto err;
 		}
 	}
 
-	should_have_subvol = BCH_SNAPSHOT_SUBVOL(s.v) &&
-		!BCH_SNAPSHOT_DELETED(s.v);
+	should_have_subvol = BCH_SNAPSHOT_SUBVOL(&s) &&
+		!BCH_SNAPSHOT_DELETED(&s);
 
 	if (should_have_subvol) {
-		id = le32_to_cpu(s.v->subvol);
+		id = le32_to_cpu(s.subvol);
 		ret = bch2_subvolume_get(trans, id, 0, false, &subvol);
 		if (bch2_err_matches(ret, ENOENT))
 			bch_err(c, "snapshot points to nonexistent subvolume:\n  %s",
-				(bch2_bkey_val_to_text(&buf, c, s.s_c), buf.buf));
+				(bch2_bkey_val_to_text(&buf, c, k), buf.buf));
 		if (ret)
 			goto err;
 
-		if (BCH_SNAPSHOT_SUBVOL(s.v) != (le32_to_cpu(subvol.snapshot) == s.k->p.offset)) {
+		if (BCH_SNAPSHOT_SUBVOL(&s) != (le32_to_cpu(subvol.snapshot) == k.k->p.offset)) {
 			bch_err(c, "snapshot node %llu has wrong BCH_SNAPSHOT_SUBVOL",
-				s.k->p.offset);
+				k.k->p.offset);
 			ret = -EINVAL;
 			goto err;
 		}
 	} else {
-		if (fsck_err_on(s.v->subvol, c, "snapshot should not point to subvol:\n  %s",
-				(bch2_bkey_val_to_text(&buf, c, s.s_c), buf.buf))) {
-			struct bkey_i_snapshot *u = bch2_trans_kmalloc(trans, sizeof(*u));
-
+		if (fsck_err_on(s.subvol, c, "snapshot should not point to subvol:\n  %s",
+				(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
+			u = bch2_bkey_make_mut_typed(trans, iter, &k, 0, snapshot);
 			ret = PTR_ERR_OR_ZERO(u);
 			if (ret)
 				goto err;
 
-			bkey_reassemble(&u->k_i, s.s_c);
 			u->v.subvol = 0;
-			ret = bch2_trans_update(trans, iter, &u->k_i, 0);
-			if (ret)
-				goto err;
-
-			s = snapshot_i_to_s_c(u);
+			s = u->v;
 		}
 	}
 
-	ret = snapshot_tree_ptr_good(trans, s.k->p.offset, le32_to_cpu(s.v->tree));
+	ret = snapshot_tree_ptr_good(trans, k.k->p.offset, le32_to_cpu(s.tree));
 	if (ret < 0)
 		goto err;
 
 	if (fsck_err_on(!ret, c, "snapshot points to missing/incorrect tree:\n  %s",
-			(bch2_bkey_val_to_text(&buf, c, s.s_c), buf.buf))) {
-		ret = snapshot_tree_ptr_repair(trans, iter, &s);
+			(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
+		ret = snapshot_tree_ptr_repair(trans, iter, k, &s);
 		if (ret)
 			goto err;
 	}
 	ret = 0;
 
-	if (BCH_SNAPSHOT_DELETED(s.v))
-		set_bit(BCH_FS_HAVE_DELETED_SNAPSHOTS, &c->flags);
+	if (fsck_err_on(le32_to_cpu(s.depth) != (parent ? parent->depth + 1 : 0), c,
+			"snapshot with incorrect depth fields, should be %u:\n  %s",
+			parent->depth + 1,
+			(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
+		u = bch2_bkey_make_mut_typed(trans, iter, &k, 0, snapshot);
+		ret = PTR_ERR_OR_ZERO(u);
+		if (ret)
+			goto err;
+
+		u->v.depth = cpu_to_le32(parent ? parent->depth + 1 : 0);
+		s = u->v;
+	}
+
+	ret = snapshot_rand_ancestor_good(trans, s);
+	if (ret < 0)
+		goto err;
+
+	if (fsck_err_on(!ret, c, "snapshot with bad rand_ancestor field:\n  %s",
+			(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
+		u = bch2_bkey_make_mut_typed(trans, iter, &k, 0, snapshot);
+		ret = PTR_ERR_OR_ZERO(u);
+		if (ret)
+			goto err;
+
+		for (i = 0; i < ARRAY_SIZE(u->v.skip); i++)
+			u->v.skip[i] = cpu_to_le32(snapshot_rand_ancestor_get(c, parent_id));
+
+		bubble_sort(u->v.skip, ARRAY_SIZE(u->v.skip), cmp_int);
+		s = u->v;
+	}
+	ret = 0;
 err:
 fsck_err:
 	printbuf_exit(&buf);
@@ -618,14 +751,19 @@ int bch2_check_snapshots(struct bch_fs *c)
 	struct bkey_s_c k;
 	int ret;
 
+	/*
+	 * We iterate backwards as checking/fixing the depth field requires that
+	 * the parent's depth already be correct:
+	 */
 	ret = bch2_trans_run(c,
-		for_each_btree_key_commit(&trans, iter,
-			BTREE_ID_snapshots, POS_MIN,
+		for_each_btree_key_reverse_commit(&trans, iter,
+			BTREE_ID_snapshots, POS_MAX,
 			BTREE_ITER_PREFETCH, k,
 			NULL, NULL, BTREE_INSERT_LAZY_RW|BTREE_INSERT_NOFAIL,
 		check_snapshot(&trans, &iter, k)));
 	if (ret)
 		bch_err_fn(c, ret);
+
 	return ret;
 }
 
@@ -847,10 +985,12 @@ static int create_snapids(struct btree_trans *trans, u32 parent, u32 tree,
 			  u32 *snapshot_subvols,
 			  unsigned nr_snapids)
 {
+	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
 	struct bkey_i_snapshot *n;
 	struct bkey_s_c k;
-	unsigned i;
+	unsigned i, j;
+	u32 depth = parent ? snapshot_t(c, parent)->depth + 1 : 0;
 	int ret;
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_snapshots,
@@ -880,6 +1020,12 @@ static int create_snapids(struct btree_trans *trans, u32 parent, u32 tree,
 		n->v.parent	= cpu_to_le32(parent);
 		n->v.subvol	= cpu_to_le32(snapshot_subvols[i]);
 		n->v.tree	= cpu_to_le32(tree);
+		n->v.depth	= cpu_to_le32(depth);
+
+		for (j = 0; j < ARRAY_SIZE(n->v.skip); j++)
+			n->v.skip[j] = cpu_to_le32(snapshot_rand_ancestor_get(c, parent));
+
+		bubble_sort(n->v.skip, ARRAY_SIZE(n->v.skip), cmp_int);
 		SET_BCH_SNAPSHOT_SUBVOL(&n->v, true);
 
 		ret = bch2_mark_snapshot(trans, BTREE_ID_snapshots, 0,
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index daa9a6b081..ab0b4a6de2 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -37,9 +37,34 @@ static inline struct snapshot_t *snapshot_t(struct bch_fs *c, u32 id)
 	return genradix_ptr(&c->snapshots, U32_MAX - id);
 }
 
+static inline u32 bch2_snapshot_parent_early(struct bch_fs *c, u32 id)
+{
+	return snapshot_t(c, id)->parent;
+}
+
 static inline u32 bch2_snapshot_parent(struct bch_fs *c, u32 id)
 {
+#ifdef CONFIG_BCACHEFS_DEBUG
+	u32 parent = snapshot_t(c, id)->parent;
+
+	if (parent &&
+	    snapshot_t(c, id)->depth != snapshot_t(c, parent)->depth + 1)
+		panic("id %u depth=%u parent %u depth=%u\n",
+		      id, snapshot_t(c, id)->depth,
+		      parent, snapshot_t(c, parent)->depth);
+
+	return parent;
+#else
 	return snapshot_t(c, id)->parent;
+#endif
+}
+
+static inline u32 bch2_snapshot_nth_parent(struct bch_fs *c, u32 id, u32 n)
+{
+	while (n--)
+		id = bch2_snapshot_parent(c, id);
+
+	return id;
 }
 
 static inline u32 bch2_snapshot_root(struct bch_fs *c, u32 id)
@@ -84,13 +109,7 @@ static inline u32 bch2_snapshot_sibling(struct bch_fs *c, u32 id)
 	return 0;
 }
 
-static inline bool bch2_snapshot_is_ancestor(struct bch_fs *c, u32 id, u32 ancestor)
-{
-	while (id && id < ancestor)
-		id = bch2_snapshot_parent(c, id);
-
-	return id == ancestor;
-}
+bool bch2_snapshot_is_ancestor(struct bch_fs *, u32, u32);
 
 static inline bool bch2_snapshot_has_children(struct bch_fs *c, u32 id)
 {
diff --git a/fs/bcachefs/subvolume_types.h b/fs/bcachefs/subvolume_types.h
index c6c1cbad97..750d975ac4 100644
--- a/fs/bcachefs/subvolume_types.h
+++ b/fs/bcachefs/subvolume_types.h
@@ -8,6 +8,8 @@ typedef DARRAY(u32) snapshot_id_list;
 
 struct snapshot_t {
 	u32			parent;
+	u32			skip[3];
+	u32			depth;
 	u32			children[2];
 	u32			subvol; /* Nonzero only if a subvolume points to this node: */
 	u32			tree;
-- 
2.40.1

