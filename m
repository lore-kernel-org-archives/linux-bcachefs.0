Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61502040B6
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216019; cv=none; b=qQGlxCcVA/tT2+/6NyDKalX/GJXhQRoREqEuMpdZZafdNf68iOPJv5zqugcsUsgN2jgHkLnz0jJgl5hB4/waW8PX5rxuZIWeywiDmmaM14q7KM81UbsQ83faRLwJlQlUtkCZ+JvW8uLKFftM9IP7Y5Um2IOFQi6O6wdPZIM3okU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216019; c=relaxed/simple;
	bh=x9+BBsUWn5CT6heUB5Cn0XLl9xnBkRFy8cicf5/iK1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l55xhGZfAc6WsOju5gOKxddrM3Uzs4pyrXUpARoGvIuJwDqMZQzrXtl6Rl7j8/CcWq4r0Yy/RfXySwcoZyReo2ERWH6Z8N6jsnsiOimX6jAkAUWRiiliC+S+51pq4T5vgpgjKzrS0PJrOhR1xrk1YhCiStGwSRPK0kiIwDij9dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z/BPyKfG; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z/BPyKfG"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ovDVNBJHIHUHnzYc0hryULdGfBYXL9xjKAwOPlwvfkw=;
	b=Z/BPyKfGQ0BpXJOwC2hKF4LUf8P/GRdFXO/7xOlMxdsYclhrIm0PNWqdhnHlG3bTPKccvu
	pUEjHwjIHET+RmGZnVdplBgY7Y7sh8Ys5KL23kTIwleDpT0CQVwoUJGIMaVN3gK/xSvnv+
	sl4tNYmH66kpOfSyh+JNiqupAiCrMe0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/8] bcachefs: bcachefs_metadata_version_snapshot_deletion_v2
Date: Fri,  2 May 2025 15:59:59 -0400
Message-ID: <20250502200002.1309862-8-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're going to be speeding up snapshot deletion, by only having it
process the extents/dirents/xattrs btrees if an inode of a given
snapshot ID was present.

This raises the possibility of 'bkey_in_missing_snapshot' errors popping
up, if we ever accidentally don't do the corresponding inode update, or
if the new algorithm has bugs.

So instead of deleting snapshot IDs, add a new deleted flag, so that
'key in missing snapshot' errors can more definitively tell what
happened and automatically repair.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h  |  3 +-
 fs/bcachefs/sb-errors_format.h |  3 +-
 fs/bcachefs/snapshot.c         | 80 ++++++++++++++++++++++++++--------
 fs/bcachefs/snapshot.h         | 25 ++++++++---
 fs/bcachefs/snapshot_format.h  |  2 +-
 fs/bcachefs/snapshot_types.h   | 30 +++++++++++++
 fs/bcachefs/subvolume_types.h  | 27 ------------
 7 files changed, 116 insertions(+), 54 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 7ce475c565b5..0beff6af7ecf 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -695,7 +695,8 @@ struct bch_sb_field_ext {
 	x(stripe_backpointers,		BCH_VERSION(1, 22))		\
 	x(stripe_lru,			BCH_VERSION(1, 23))		\
 	x(casefolding,			BCH_VERSION(1, 24))		\
-	x(extent_flags,			BCH_VERSION(1, 25))
+	x(extent_flags,			BCH_VERSION(1, 25))		\
+	x(snapshot_deletion_v2,		BCH_VERSION(1, 26))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 82bc1906aa00..448326c01d13 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -209,6 +209,7 @@ enum bch_fsck_flags {
 	x(subvol_to_missing_root,				188,	0)		\
 	x(subvol_root_wrong_bi_subvol,				189,	FSCK_AUTOFIX)	\
 	x(bkey_in_missing_snapshot,				190,	0)		\
+	x(bkey_in_deleted_snapshot,				315,	0)		\
 	x(inode_pos_inode_nonzero,				191,	0)		\
 	x(inode_pos_blockdev_range,				192,	0)		\
 	x(inode_alloc_cursor_inode_bad,				301,	0)		\
@@ -324,7 +325,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							315,	0)
+	x(MAX,							316,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index 7349f7f33a4f..f074b9de5024 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -314,7 +314,9 @@ static int __bch2_mark_snapshot(struct btree_trans *trans,
 	if (new.k->type == KEY_TYPE_snapshot) {
 		struct bkey_s_c_snapshot s = bkey_s_c_to_snapshot(new);
 
-		t->live		= true;
+		t->state	= !BCH_SNAPSHOT_DELETED(s.v)
+			? SNAPSHOT_ID_live
+			: SNAPSHOT_ID_deleted;
 		t->parent	= le32_to_cpu(s.v->parent);
 		t->children[0]	= le32_to_cpu(s.v->children[0]);
 		t->children[1]	= le32_to_cpu(s.v->children[1]);
@@ -711,6 +713,9 @@ static int check_snapshot(struct btree_trans *trans,
 	memset(&s, 0, sizeof(s));
 	memcpy(&s, k.v, min(sizeof(s), bkey_val_bytes(k.k)));
 
+	if (BCH_SNAPSHOT_DELETED(&s))
+		return 0;
+
 	id = le32_to_cpu(s.parent);
 	if (id) {
 		ret = bch2_snapshot_lookup(trans, id, &v);
@@ -998,7 +1003,7 @@ int bch2_reconstruct_snapshots(struct bch_fs *c)
 		snapshot_id_list_to_text(&buf, t);
 
 		darray_for_each(*t, id) {
-			if (fsck_err_on(!bch2_snapshot_exists(c, *id),
+			if (fsck_err_on(bch2_snapshot_id_state(c, *id) == SNAPSHOT_ID_empty,
 					trans, snapshot_node_missing,
 					"snapshot node %u from tree %s missing, recreate?", *id, buf.buf)) {
 				if (t->nr > 1) {
@@ -1023,22 +1028,38 @@ int bch2_reconstruct_snapshots(struct bch_fs *c)
 	return ret;
 }
 
-int bch2_check_key_has_snapshot(struct btree_trans *trans,
-				struct btree_iter *iter,
-				struct bkey_s_c k)
+int __bch2_check_key_has_snapshot(struct btree_trans *trans,
+				  struct btree_iter *iter,
+				  struct bkey_s_c k)
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
+	enum snapshot_id_state state = bch2_snapshot_id_state(c, k.k->p.snapshot);
+
+	/* Snapshot was definitively deleted, this error is marked autofix */
+	if (fsck_err_on(state == SNAPSHOT_ID_deleted,
+			trans, bkey_in_deleted_snapshot,
+			"key in deleted snapshot %s, delete?",
+			(bch2_btree_id_to_text(&buf, iter->btree_id),
+			 prt_char(&buf, ' '),
+			 bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
+		ret = bch2_btree_delete_at(trans, iter,
+					   BTREE_UPDATE_internal_snapshot_node) ?: 1;
 
-	if (fsck_err_on(!bch2_snapshot_exists(c, k.k->p.snapshot),
+	/*
+	 * Snapshot missing: we should have caught this with btree_lost_data and
+	 * kicked off reconstruct_snapshots, so if we end up here we have no
+	 * idea what happened:
+	 */
+	if (fsck_err_on(state == SNAPSHOT_ID_empty,
 			trans, bkey_in_missing_snapshot,
 			"key in missing snapshot %s, delete?",
 			(bch2_btree_id_to_text(&buf, iter->btree_id),
 			 prt_char(&buf, ' '),
 			 bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
 		ret = bch2_btree_delete_at(trans, iter,
-					    BTREE_UPDATE_internal_snapshot_node) ?: 1;
+					   BTREE_UPDATE_internal_snapshot_node) ?: 1;
 fsck_err:
 	printbuf_exit(&buf);
 	return ret;
@@ -1085,24 +1106,25 @@ static int bch2_snapshot_node_delete(struct btree_trans *trans, u32 id)
 	struct btree_iter iter, p_iter = {};
 	struct btree_iter c_iter = {};
 	struct btree_iter tree_iter = {};
-	struct bkey_s_c_snapshot s;
 	u32 parent_id, child_id;
 	unsigned i;
 	int ret = 0;
 
-	s = bch2_bkey_get_iter_typed(trans, &iter, BTREE_ID_snapshots, POS(0, id),
-				     BTREE_ITER_intent, snapshot);
-	ret = bkey_err(s);
+	struct bkey_i_snapshot *s =
+		bch2_bkey_get_mut_typed(trans, &iter, BTREE_ID_snapshots, POS(0, id),
+					BTREE_ITER_intent, snapshot);
+	ret = PTR_ERR_OR_ZERO(s);
 	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), c,
 				"missing snapshot %u", id);
 
 	if (ret)
 		goto err;
 
-	BUG_ON(s.v->children[1]);
+	BUG_ON(BCH_SNAPSHOT_DELETED(&s->v));
+	BUG_ON(s->v.children[1]);
 
-	parent_id = le32_to_cpu(s.v->parent);
-	child_id = le32_to_cpu(s.v->children[0]);
+	parent_id = le32_to_cpu(s->v.parent);
+	child_id = le32_to_cpu(s->v.children[0]);
 
 	if (parent_id) {
 		struct bkey_i_snapshot *parent;
@@ -1160,24 +1182,38 @@ static int bch2_snapshot_node_delete(struct btree_trans *trans, u32 id)
 		 */
 		struct bkey_i_snapshot_tree *s_t;
 
-		BUG_ON(s.v->children[1]);
+		BUG_ON(s->v.children[1]);
 
 		s_t = bch2_bkey_get_mut_typed(trans, &tree_iter,
-				BTREE_ID_snapshot_trees, POS(0, le32_to_cpu(s.v->tree)),
+				BTREE_ID_snapshot_trees, POS(0, le32_to_cpu(s->v.tree)),
 				0, snapshot_tree);
 		ret = PTR_ERR_OR_ZERO(s_t);
 		if (ret)
 			goto err;
 
-		if (s.v->children[0]) {
-			s_t->v.root_snapshot = s.v->children[0];
+		if (s->v.children[0]) {
+			s_t->v.root_snapshot = s->v.children[0];
 		} else {
 			s_t->k.type = KEY_TYPE_deleted;
 			set_bkey_val_u64s(&s_t->k, 0);
 		}
 	}
 
-	ret = bch2_btree_delete_at(trans, &iter, 0);
+	if (!bch2_request_incompat_feature(c, bcachefs_metadata_version_snapshot_deletion_v2)) {
+		SET_BCH_SNAPSHOT_DELETED(&s->v, true);
+		s->v.parent		= 0;
+		s->v.children[0]	= 0;
+		s->v.children[1]	= 0;
+		s->v.subvol		= 0;
+		s->v.tree		= 0;
+		s->v.depth		= 0;
+		s->v.skip[0]		= 0;
+		s->v.skip[1]		= 0;
+		s->v.skip[2]		= 0;
+	} else {
+		s->k.type = KEY_TYPE_deleted;
+		set_bkey_val_u64s(&s->k, 0);
+	}
 err:
 	bch2_trans_iter_exit(trans, &tree_iter);
 	bch2_trans_iter_exit(trans, &p_iter);
@@ -1468,6 +1504,9 @@ static int check_should_delete_snapshot(struct btree_trans *trans, struct bkey_s
 	if (BCH_SNAPSHOT_SUBVOL(s.v))
 		return 0;
 
+	if (BCH_SNAPSHOT_DELETED(s.v))
+		return 0;
+
 	for (unsigned i = 0; i < 2; i++) {
 		u32 child = le32_to_cpu(s.v->children[i]);
 
@@ -1524,6 +1563,9 @@ static int bch2_fix_child_of_deleted_snapshot(struct btree_trans *trans,
 	struct bkey_i_snapshot *s;
 	int ret;
 
+	if (!bch2_snapshot_exists(c, k.k->p.offset))
+		return 0;
+
 	if (k.k->type != KEY_TYPE_snapshot)
 		return 0;
 
diff --git a/fs/bcachefs/snapshot.h b/fs/bcachefs/snapshot.h
index 24a451bb7024..69c484b77729 100644
--- a/fs/bcachefs/snapshot.h
+++ b/fs/bcachefs/snapshot.h
@@ -120,21 +120,26 @@ static inline u32 bch2_snapshot_root(struct bch_fs *c, u32 id)
 	return id;
 }
 
-static inline bool __bch2_snapshot_exists(struct bch_fs *c, u32 id)
+static inline enum snapshot_id_state __bch2_snapshot_id_state(struct bch_fs *c, u32 id)
 {
 	const struct snapshot_t *s = snapshot_t(c, id);
-	return s ? s->live : 0;
+	return s ? s->state : SNAPSHOT_ID_empty;
 }
 
-static inline bool bch2_snapshot_exists(struct bch_fs *c, u32 id)
+static inline enum snapshot_id_state bch2_snapshot_id_state(struct bch_fs *c, u32 id)
 {
 	rcu_read_lock();
-	bool ret = __bch2_snapshot_exists(c, id);
+	enum snapshot_id_state ret = __bch2_snapshot_id_state(c, id);
 	rcu_read_unlock();
 
 	return ret;
 }
 
+static inline bool bch2_snapshot_exists(struct bch_fs *c, u32 id)
+{
+	return bch2_snapshot_id_state(c, id) == SNAPSHOT_ID_live;
+}
+
 static inline int bch2_snapshot_is_internal_node(struct bch_fs *c, u32 id)
 {
 	rcu_read_lock();
@@ -241,7 +246,17 @@ int bch2_snapshot_node_create(struct btree_trans *, u32,
 int bch2_check_snapshot_trees(struct bch_fs *);
 int bch2_check_snapshots(struct bch_fs *);
 int bch2_reconstruct_snapshots(struct bch_fs *);
-int bch2_check_key_has_snapshot(struct btree_trans *, struct btree_iter *, struct bkey_s_c);
+
+int __bch2_check_key_has_snapshot(struct btree_trans *, struct btree_iter *, struct bkey_s_c);
+
+static inline int bch2_check_key_has_snapshot(struct btree_trans *trans,
+					      struct btree_iter *iter,
+					      struct bkey_s_c k)
+{
+	return likely(bch2_snapshot_exists(trans->c, k.k->p.snapshot))
+		? 0
+		: __bch2_check_key_has_snapshot(trans, iter, k);
+}
 
 int bch2_snapshot_node_set_deleted(struct btree_trans *, u32);
 
diff --git a/fs/bcachefs/snapshot_format.h b/fs/bcachefs/snapshot_format.h
index 685a9fe209ab..9bccae1f3590 100644
--- a/fs/bcachefs/snapshot_format.h
+++ b/fs/bcachefs/snapshot_format.h
@@ -16,9 +16,9 @@ struct bch_snapshot {
 };
 
 LE32_BITMASK(BCH_SNAPSHOT_WILL_DELETE,	struct bch_snapshot, flags,  0,  1)
-
 /* True if a subvolume points to this snapshot node: */
 LE32_BITMASK(BCH_SNAPSHOT_SUBVOL,	struct bch_snapshot, flags,  1,  2)
+LE32_BITMASK(BCH_SNAPSHOT_DELETED,	struct bch_snapshot, flags,  2,  3)
 
 /*
  * Snapshot trees:
diff --git a/fs/bcachefs/snapshot_types.h b/fs/bcachefs/snapshot_types.h
index 39fb47f43183..a64f4b942655 100644
--- a/fs/bcachefs/snapshot_types.h
+++ b/fs/bcachefs/snapshot_types.h
@@ -3,8 +3,38 @@
 #define _BCACHEFS_SNAPSHOT_TYPES_H
 
 #include "bbpos_types.h"
+#include "darray.h"
 #include "subvolume_types.h"
 
+typedef DARRAY(u32) snapshot_id_list;
+
+#define IS_ANCESTOR_BITMAP	128
+
+struct snapshot_t {
+	enum snapshot_id_state {
+		SNAPSHOT_ID_empty,
+		SNAPSHOT_ID_live,
+		SNAPSHOT_ID_deleted,
+	}			state;
+	u32			parent;
+	u32			skip[3];
+	u32			depth;
+	u32			children[2];
+	u32			subvol; /* Nonzero only if a subvolume points to this node: */
+	u32			tree;
+	unsigned long		is_ancestor[BITS_TO_LONGS(IS_ANCESTOR_BITMAP)];
+};
+
+struct snapshot_table {
+	struct rcu_head		rcu;
+	size_t			nr;
+#ifndef RUST_BINDGEN
+	DECLARE_FLEX_ARRAY(struct snapshot_t, s);
+#else
+	struct snapshot_t	s[0];
+#endif
+};
+
 struct snapshot_interior_delete {
 	u32	id;
 	u32	live_child;
diff --git a/fs/bcachefs/subvolume_types.h b/fs/bcachefs/subvolume_types.h
index 1549d6daf7af..9d634b906dcd 100644
--- a/fs/bcachefs/subvolume_types.h
+++ b/fs/bcachefs/subvolume_types.h
@@ -2,33 +2,6 @@
 #ifndef _BCACHEFS_SUBVOLUME_TYPES_H
 #define _BCACHEFS_SUBVOLUME_TYPES_H
 
-#include "darray.h"
-
-typedef DARRAY(u32) snapshot_id_list;
-
-#define IS_ANCESTOR_BITMAP	128
-
-struct snapshot_t {
-	bool			live;
-	u32			parent;
-	u32			skip[3];
-	u32			depth;
-	u32			children[2];
-	u32			subvol; /* Nonzero only if a subvolume points to this node: */
-	u32			tree;
-	unsigned long		is_ancestor[BITS_TO_LONGS(IS_ANCESTOR_BITMAP)];
-};
-
-struct snapshot_table {
-	struct rcu_head		rcu;
-	size_t			nr;
-#ifndef RUST_BINDGEN
-	DECLARE_FLEX_ARRAY(struct snapshot_t, s);
-#else
-	struct snapshot_t	s[0];
-#endif
-};
-
 typedef struct {
 	/* we can't have padding in this struct: */
 	u64		subvol;
-- 
2.49.0

