Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1897E2B2D7
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039096; cv=none; b=sQlCkWo107PH9mt2wkacnw11Ra/gH6Jvv5ltU8j9YWgYwuHWy+WkxOjXUjyCWEIChLx8RZv2hHBx8cDj2Oh59gkMxtc0tehYilsMXdynxq0prahHQ3tBmQhIXYgC0emYEZpj5E5XupQcfO+TTCQgx0sa09K66oIzT05FhbfHV4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039096; c=relaxed/simple;
	bh=ROxIN1cKLOPTI24ree4ua/C1pfUDi1B93+NdpprzrGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LjjPUS+L9MF63fJjsaJZeDDD4TSAYlDSg3q+iPPoAHhs53G42bYPrr3wM9LXXbq+QhfXjYFoMepkzCuDVSB6rODOlVQoySzrORsTYm7wssS0T2DQtub9NaaLuRExk6s6CMi9o4D3P5E585TASf0jdQDD9b4rhi2/8shjdqUxjWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=By5k98yr; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="By5k98yr"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPoZBiIDC80hasbBNdXR52Vp+51JhtIjPtWJ2/s64Is=;
	b=By5k98yrTsYSpDoX/xgJHPE8aDYVi4jqxTPzDXWxgCjJOzq/8ty6FHXSOnAzxPhfaQIX/B
	l2W07v6zc4Li97gmjU/wQSINUWU0swLnoDrxQE6tR8C38qqGmcVkhUtmdgN5FbhGOad/MS
	iRhL94tHVyegfo+tfbeiURg0Ky2PhTM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/21] bcachefs: Rename, split out bch2_extent_get_io_opts()
Date: Sun, 24 Aug 2025 08:37:45 -0400
Message-ID: <20250824123800.1617669-9-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Move to rebalance.c, where it more properly belongs, and split out
getting an extent's io options from re-propagating back to the extent -
prep work for new fsck code.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c      |  97 ++------------------------------
 fs/bcachefs/move.h      |  30 ----------
 fs/bcachefs/rebalance.c | 120 +++++++++++++++++++++++++++++++++++++---
 fs/bcachefs/rebalance.h |  34 +++++++++++-
 4 files changed, 147 insertions(+), 134 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 5adeca883ecd..62aeb54ef11b 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -447,95 +447,6 @@ int bch2_move_extent(struct moving_context *ctxt,
 	return ret;
 }
 
-struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *trans,
-			  struct per_snapshot_io_opts *io_opts,
-			  struct bpos extent_pos, /* extent_iter, extent_k may be in reflink btree */
-			  struct btree_iter *extent_iter,
-			  struct bkey_s_c extent_k)
-{
-	struct bch_fs *c = trans->c;
-	u32 restart_count = trans->restart_count;
-	struct bch_inode_opts *opts_ret = &io_opts->fs_io_opts;
-	int ret = 0;
-
-	if (btree_iter_path(trans, extent_iter)->level)
-		return opts_ret;
-
-	if (extent_k.k->type == KEY_TYPE_reflink_v)
-		goto out;
-
-	if (io_opts->cur_inum != extent_pos.inode) {
-		io_opts->d.nr = 0;
-
-		ret = for_each_btree_key(trans, iter, BTREE_ID_inodes, POS(0, extent_pos.inode),
-					 BTREE_ITER_all_snapshots, k, ({
-			if (k.k->p.offset != extent_pos.inode)
-				break;
-
-			if (!bkey_is_inode(k.k))
-				continue;
-
-			struct bch_inode_unpacked inode;
-			_ret3 = bch2_inode_unpack(k, &inode);
-			if (_ret3)
-				break;
-
-			struct snapshot_io_opts_entry e = { .snapshot = k.k->p.snapshot };
-			bch2_inode_opts_get_inode(trans->c, &inode, &e.io_opts);
-
-			darray_push(&io_opts->d, e);
-		}));
-		io_opts->cur_inum = extent_pos.inode;
-	}
-
-	ret = ret ?: trans_was_restarted(trans, restart_count);
-	if (ret)
-		return ERR_PTR(ret);
-
-	if (extent_k.k->p.snapshot)
-		darray_for_each(io_opts->d, i)
-			if (bch2_snapshot_is_ancestor(c, extent_k.k->p.snapshot, i->snapshot)) {
-				opts_ret = &i->io_opts;
-				break;
-			}
-out:
-	ret = bch2_get_update_rebalance_opts(trans, opts_ret, extent_iter, extent_k,
-					     SET_NEEDS_REBALANCE_other);
-	if (ret)
-		return ERR_PTR(ret);
-	return opts_ret;
-}
-
-int bch2_move_get_io_opts_one(struct btree_trans *trans,
-			      struct bch_inode_opts *io_opts,
-			      struct btree_iter *extent_iter,
-			      struct bkey_s_c extent_k)
-{
-	struct bch_fs *c = trans->c;
-
-	bch2_inode_opts_get(c, io_opts);
-
-	/* reflink btree? */
-	if (extent_k.k->p.inode) {
-		CLASS(btree_iter, inode_iter)(trans, BTREE_ID_inodes,
-				       SPOS(0, extent_k.k->p.inode, extent_k.k->p.snapshot),
-				       BTREE_ITER_cached);
-		struct bkey_s_c inode_k = bch2_btree_iter_peek_slot(&inode_iter);
-		int ret = bkey_err(inode_k);
-		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-			return ret;
-
-		if (!ret && bkey_is_inode(inode_k.k)) {
-			struct bch_inode_unpacked inode;
-			bch2_inode_unpack(inode_k, &inode);
-			bch2_inode_opts_get_inode(c, &inode, io_opts);
-		}
-	}
-
-	return bch2_get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k,
-					     SET_NEEDS_REBALANCE_other);
-}
-
 int bch2_move_ratelimit(struct moving_context *ctxt)
 {
 	struct bch_fs *c = ctxt->trans->c;
@@ -679,8 +590,9 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 		if (!bkey_extent_is_direct_data(k.k))
 			goto next_nondata;
 
-		io_opts = bch2_move_get_io_opts(trans, &snapshot_io_opts,
-						iter.pos, &iter, k);
+		io_opts = bch2_extent_get_apply_io_opts(trans, &snapshot_io_opts,
+						iter.pos, &iter, k,
+						SET_NEEDS_REBALANCE_other);
 		ret = PTR_ERR_OR_ZERO(io_opts);
 		if (ret)
 			continue;
@@ -878,7 +790,8 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 			goto next;
 
 		if (!bp.v->level) {
-			ret = bch2_move_get_io_opts_one(trans, &io_opts, &iter, k);
+			ret = bch2_extent_get_io_opts_one(trans, &io_opts, &iter, k,
+							  SET_NEEDS_REBALANCE_other);
 			if (ret) {
 				bch2_trans_iter_exit(&iter);
 				continue;
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 18021d2c51d0..754b0ad45950 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -87,32 +87,6 @@ void bch2_moving_ctxt_flush_all(struct moving_context *);
 void bch2_move_ctxt_wait_for_io(struct moving_context *);
 int bch2_move_ratelimit(struct moving_context *);
 
-/* Inodes in different snapshots may have different IO options: */
-struct snapshot_io_opts_entry {
-	u32			snapshot;
-	struct bch_inode_opts	io_opts;
-};
-
-struct per_snapshot_io_opts {
-	u64			cur_inum;
-	struct bch_inode_opts	fs_io_opts;
-	DARRAY(struct snapshot_io_opts_entry) d;
-};
-
-static inline void per_snapshot_io_opts_init(struct per_snapshot_io_opts *io_opts, struct bch_fs *c)
-{
-	memset(io_opts, 0, sizeof(*io_opts));
-	bch2_inode_opts_get(c, &io_opts->fs_io_opts);
-}
-
-static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opts)
-{
-	darray_exit(&io_opts->d);
-}
-
-int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_inode_opts *,
-			      struct btree_iter *, struct bkey_s_c);
-
 int bch2_scan_old_btree_nodes(struct bch_fs *, struct bch_move_stats *);
 
 int bch2_move_extent(struct moving_context *,
@@ -122,10 +96,6 @@ int bch2_move_extent(struct moving_context *,
 		     struct bch_inode_opts,
 		     struct data_update_opts);
 
-struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *,
-			  struct per_snapshot_io_opts *, struct bpos,
-			  struct btree_iter *, struct bkey_s_c);
-
 int bch2_move_data_btree(struct moving_context *, struct bpos, struct bpos,
 			 move_pred_fn, void *, enum btree_id, unsigned);
 
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 2bb634ee0f48..d34a287cace4 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -188,11 +188,11 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 	return 0;
 }
 
-int bch2_get_update_rebalance_opts(struct btree_trans *trans,
-				   struct bch_inode_opts *io_opts,
-				   struct btree_iter *iter,
-				   struct bkey_s_c k,
-				   enum set_needs_rebalance_ctx ctx)
+static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
+					  struct bch_inode_opts *io_opts,
+					  struct btree_iter *iter,
+					  struct bkey_s_c k,
+					  enum set_needs_rebalance_ctx ctx)
 {
 	BUG_ON(iter->flags & BTREE_ITER_is_extents);
 	BUG_ON(iter->flags & BTREE_ITER_filter_snapshots);
@@ -224,7 +224,107 @@ int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
-		bch_err_throw(trans->c, transaction_restart_nested);
+		bch_err_throw(trans->c, transaction_restart_commit);
+}
+
+static struct bch_inode_opts *bch2_extent_get_io_opts(struct btree_trans *trans,
+			  struct per_snapshot_io_opts *io_opts,
+			  struct bpos extent_pos, /* extent_iter, extent_k may be in reflink btree */
+			  struct btree_iter *extent_iter,
+			  struct bkey_s_c extent_k)
+{
+	struct bch_fs *c = trans->c;
+	u32 restart_count = trans->restart_count;
+	int ret = 0;
+
+	if (btree_iter_path(trans, extent_iter)->level)
+		return &io_opts->fs_io_opts;
+
+	if (extent_k.k->type == KEY_TYPE_reflink_v)
+		return &io_opts->fs_io_opts;
+
+	if (io_opts->cur_inum != extent_pos.inode) {
+		io_opts->d.nr = 0;
+
+		ret = for_each_btree_key(trans, iter, BTREE_ID_inodes, POS(0, extent_pos.inode),
+					 BTREE_ITER_all_snapshots, k, ({
+			if (k.k->p.offset != extent_pos.inode)
+				break;
+
+			if (!bkey_is_inode(k.k))
+				continue;
+
+			struct bch_inode_unpacked inode;
+			_ret3 = bch2_inode_unpack(k, &inode);
+			if (_ret3)
+				break;
+
+			struct snapshot_io_opts_entry e = { .snapshot = k.k->p.snapshot };
+			bch2_inode_opts_get_inode(c, &inode, &e.io_opts);
+
+			darray_push(&io_opts->d, e);
+		}));
+		io_opts->cur_inum = extent_pos.inode;
+	}
+
+	ret = ret ?: trans_was_restarted(trans, restart_count);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (extent_k.k->p.snapshot)
+		darray_for_each(io_opts->d, i)
+			if (bch2_snapshot_is_ancestor(c, extent_k.k->p.snapshot, i->snapshot))
+				return &i->io_opts;
+
+	return &io_opts->fs_io_opts;
+}
+
+struct bch_inode_opts *bch2_extent_get_apply_io_opts(struct btree_trans *trans,
+			  struct per_snapshot_io_opts *snapshot_io_opts,
+			  struct bpos extent_pos, /* extent_iter, extent_k may be in reflink btree */
+			  struct btree_iter *extent_iter,
+			  struct bkey_s_c extent_k,
+			  enum set_needs_rebalance_ctx ctx)
+{
+	struct bch_inode_opts *opts =
+		bch2_extent_get_io_opts(trans, snapshot_io_opts, extent_pos, extent_iter, extent_k);
+	if (IS_ERR(opts) || btree_iter_path(trans, extent_iter)->level)
+		return opts;
+
+	int ret = bch2_get_update_rebalance_opts(trans, opts, extent_iter, extent_k,
+						 SET_NEEDS_REBALANCE_other);
+	return ret ? ERR_PTR(ret) : opts;
+}
+
+int bch2_extent_get_io_opts_one(struct btree_trans *trans,
+				struct bch_inode_opts *io_opts,
+				struct btree_iter *extent_iter,
+				struct bkey_s_c extent_k,
+				enum set_needs_rebalance_ctx ctx)
+{
+	struct bch_fs *c = trans->c;
+
+	bch2_inode_opts_get(c, io_opts);
+
+	/* reflink btree? */
+	if (extent_k.k->p.inode) {
+		CLASS(btree_iter, inode_iter)(trans, BTREE_ID_inodes,
+				       SPOS(0, extent_k.k->p.inode, extent_k.k->p.snapshot),
+				       BTREE_ITER_cached);
+		struct bkey_s_c inode_k = bch2_btree_iter_peek_slot(&inode_iter);
+		int ret = bkey_err(inode_k);
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			return ret;
+
+		if (!ret && bkey_is_inode(inode_k.k)) {
+			struct bch_inode_unpacked inode;
+			bch2_inode_unpack(inode_k, &inode);
+			bch2_inode_opts_get_inode(c, &inode, io_opts);
+		}
+	}
+
+	return bch2_get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k,
+					      ctx);
 }
 
 #define REBALANCE_WORK_SCAN_OFFSET	(U64_MAX - 1)
@@ -373,7 +473,8 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	if (bkey_err(k))
 		return k;
 
-	int ret = bch2_move_get_io_opts_one(trans, io_opts, extent_iter, k);
+	int ret = bch2_extent_get_io_opts_one(trans, io_opts, extent_iter, k,
+					      SET_NEEDS_REBALANCE_other);
 	if (ret)
 		return bkey_s_c_err(ret);
 
@@ -534,8 +635,9 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 					 BTREE_ITER_prefetch, k, ({
 		ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
-		struct bch_inode_opts *opts = bch2_move_get_io_opts(trans,
-					&snapshot_io_opts, iter.pos, &iter, k);
+		struct bch_inode_opts *opts = bch2_extent_get_apply_io_opts(trans,
+					&snapshot_io_opts, iter.pos, &iter, k,
+					SET_NEEDS_REBALANCE_opt_change);
 		PTR_ERR_OR_ZERO(opts) ?:
 		(inum &&
 		 k.k->type == KEY_TYPE_reflink_p &&
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 1e1d6818e7d4..fd33e7aa2ecb 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -38,9 +38,37 @@ enum set_needs_rebalance_ctx {
 int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *,
 				  struct bkey_i *, enum set_needs_rebalance_ctx, u32);
 
-int bch2_get_update_rebalance_opts(struct btree_trans *, struct bch_inode_opts *,
-				   struct btree_iter *, struct bkey_s_c,
-				   enum set_needs_rebalance_ctx);
+/* Inodes in different snapshots may have different IO options: */
+struct snapshot_io_opts_entry {
+	u32			snapshot;
+	struct bch_inode_opts	io_opts;
+};
+
+struct per_snapshot_io_opts {
+	u64			cur_inum;
+	struct bch_inode_opts	fs_io_opts;
+	DARRAY(struct snapshot_io_opts_entry) d;
+};
+
+static inline void per_snapshot_io_opts_init(struct per_snapshot_io_opts *io_opts, struct bch_fs *c)
+{
+	memset(io_opts, 0, sizeof(*io_opts));
+	bch2_inode_opts_get(c, &io_opts->fs_io_opts);
+}
+
+static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opts)
+{
+	darray_exit(&io_opts->d);
+}
+
+struct bch_inode_opts *bch2_extent_get_apply_io_opts(struct btree_trans *,
+			  struct per_snapshot_io_opts *, struct bpos,
+			  struct btree_iter *, struct bkey_s_c,
+			  enum set_needs_rebalance_ctx);
+
+int bch2_extent_get_io_opts_one(struct btree_trans *, struct bch_inode_opts *,
+				struct btree_iter *, struct bkey_s_c,
+				enum set_needs_rebalance_ctx);
 
 int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
-- 
2.50.1

