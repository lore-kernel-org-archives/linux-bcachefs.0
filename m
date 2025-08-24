Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E442D8788
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039103; cv=none; b=WpvXjVQ1ZkbZG/vFpCLQR1EIt56ldDTMm+a/ABI47aEND3s52dE2mIe9Yp52MA7SfBstlabf4NKizXD86jtRh1e2iA1l9Bi46Z4UO72/rwx4WNPEBFJJVN1nHPHG0DnVwdTUzH/kM8DJgGgJwlEhpgix/7ayRMiTYZq7bgBlXjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039103; c=relaxed/simple;
	bh=Egf/UAZ+yuLCgJI89eRL4wnXjquI+olt6OjYy7acPSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W50NwDlMAmgML3RQKoMmtr2ltazLIjXgK3W6v6zShIMaSAPg1KI3VkBavLs/Ocs7Knam9airiGNWD352DNtf2clfMuxksYAZnPHqf/+qxpuIH7JfK42xGdE//x50clTBY/8hEo1AlOORlx/ziOC8u5acQLewsg6sKmmdUqzDLoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mzOZpeCB; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mzOZpeCB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AuPHVGQMq53KTbV2tPbx4XrmimXkMQRN1C4r6O4Ro3s=;
	b=mzOZpeCBT0QTolzwmzWdloOxp/Hp6kccJfJkN0PakFsngNIvp0Tcvq0CtGAuMjrVUo7+Oo
	4/XGhdGoTiMlTPu86PyNKNmEKRoAPLYUB6po64uxJhgM8M1PFvgZAWELXjSMBvZ/1x5xO/
	98Oy4bIq0O0l43cRHgCcteY/LyVc9r0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 16/21] bcachefs: bch2_bkey_set_needs_rebalance() now takes per_snapshot_io_opts
Date: Sun, 24 Aug 2025 08:37:53 -0400
Message-ID: <20250824123800.1617669-17-kent.overstreet@linux.dev>
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

To be used for caching the existence of scan cookies.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  2 +-
 fs/bcachefs/io_write.c    |  4 ++--
 fs/bcachefs/rebalance.c   |  7 +++++--
 fs/bcachefs/rebalance.h   | 21 +++++++++++----------
 4 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index e932ee5488da..0f968bab7d93 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -438,7 +438,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, insert->k.p) ?:
 			bch2_inum_snapshot_opts_get(trans, k.k->p.inode, k.k->p.snapshot, &opts) ?:
-			bch2_bkey_set_needs_rebalance(c, &opts, insert,
+			bch2_bkey_set_needs_rebalance(trans, NULL, &opts, insert,
 						      SET_NEEDS_REBALANCE_foreground,
 						      m->op.opts.change_cookie) ?:
 			bch2_trans_update(trans, &iter, insert,
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 16bcdada8cf1..cf1dd8bc7fe9 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -365,7 +365,7 @@ int bch2_extent_update(struct btree_trans *trans,
 						  min(k->k.p.offset << 9, new_i_size),
 						  i_sectors_delta, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
-		 bch2_bkey_set_needs_rebalance(c, &opts, k,
+		 bch2_bkey_set_needs_rebalance(trans, NULL, &opts, k,
 					       SET_NEEDS_REBALANCE_foreground,
 					       change_cookie)) ?:
 		bch2_trans_update(trans, iter, k, 0) ?:
@@ -1271,7 +1271,7 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 	return  bch2_extent_update_i_size_sectors(trans, iter,
 					min(new->k.p.offset << 9, new_i_size), 0, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
-		 bch2_bkey_set_needs_rebalance(c, &opts, new,
+		 bch2_bkey_set_needs_rebalance(trans, NULL, &opts, new,
 					       SET_NEEDS_REBALANCE_foreground,
 					       op->opts.change_cookie)) ?:
 		bch2_trans_update(trans, iter, new,
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 70000d9a1ec4..33bddbd33088 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -153,7 +153,9 @@ static inline bool bkey_should_have_rb_opts(struct bch_fs *c,
 	return k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k);
 }
 
-int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
+int bch2_bkey_set_needs_rebalance(struct btree_trans *trans,
+				  struct per_snapshot_io_opts *snapshot_io_opts,
+				  struct bch_inode_opts *opts,
 				  struct bkey_i *_k,
 				  enum set_needs_rebalance_ctx ctx,
 				  u32 change_cookie)
@@ -161,6 +163,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 	if (!bkey_extent_is_direct_data(&_k->k))
 		return 0;
 
+	struct bch_fs *c = trans->c;
 	struct bkey_s k = bkey_i_to_s(_k);
 	struct bch_extent_rebalance *old =
 		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
@@ -286,7 +289,7 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	ret = bch2_bkey_set_needs_rebalance(c, io_opts, n, ctx, 0) ?:
+	ret = bch2_bkey_set_needs_rebalance(trans, NULL, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
 		bch_err_throw(c, transaction_restart_commit);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index fd33e7aa2ecb..fd873894c8b6 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -28,16 +28,6 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
 
-enum set_needs_rebalance_ctx {
-	SET_NEEDS_REBALANCE_opt_change,
-	SET_NEEDS_REBALANCE_opt_change_indirect,
-	SET_NEEDS_REBALANCE_foreground,
-	SET_NEEDS_REBALANCE_other,
-};
-
-int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *,
-				  struct bkey_i *, enum set_needs_rebalance_ctx, u32);
-
 /* Inodes in different snapshots may have different IO options: */
 struct snapshot_io_opts_entry {
 	u32			snapshot;
@@ -61,6 +51,17 @@ static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opt
 	darray_exit(&io_opts->d);
 }
 
+enum set_needs_rebalance_ctx {
+	SET_NEEDS_REBALANCE_opt_change,
+	SET_NEEDS_REBALANCE_opt_change_indirect,
+	SET_NEEDS_REBALANCE_foreground,
+	SET_NEEDS_REBALANCE_other,
+};
+
+int bch2_bkey_set_needs_rebalance(struct btree_trans *,
+				  struct per_snapshot_io_opts *, struct bch_inode_opts *,
+				  struct bkey_i *, enum set_needs_rebalance_ctx, u32);
+
 struct bch_inode_opts *bch2_extent_get_apply_io_opts(struct btree_trans *,
 			  struct per_snapshot_io_opts *, struct bpos,
 			  struct btree_iter *, struct bkey_s_c,
-- 
2.50.1

