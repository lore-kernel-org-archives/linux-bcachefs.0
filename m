Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2B52D7390
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039094; cv=none; b=tTuVAGm1BYTAweFnli2/i3pN/nedJR8v0UrLz0Vdo+DsIWdTc/SE30HL3nWmvC96b+RHKDx4QSrJAIeNM7WSamHjwWnjXKgQQVpip1WSrr7k8Pqmade6bcQKkE+tfS/RjERgUzpesnPueNBS86JPaRAAiaJOEjs+ZRbr7UtHUFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039094; c=relaxed/simple;
	bh=Hd0rY59iUklipZw/P/1uojTNJ9trXrq4OXuuRqhsang=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyyR4MCVdvYYgWxkWtmE2X9Rx4DUifEsvs1M/cK81cNm3MgG7vXxMe+Dt1YfiQbAJpwsrd5mko5IDQJDx2PiSc6Whw7+9QhcIr7tbhQztcJxtvYKl8+D9G1o84pQ6SZwi7QARrMP1d15PHYYI9vIEXp4FAG49PbueQkcEq4SOnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WcK6iJiP; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WcK6iJiP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U8BDaNEE61MnkK6jnhdRIKV8sQ87CPyn4WxVgkECwFI=;
	b=WcK6iJiPrvZk/x/HyxhE9WnGOcntlpTHaKi3ZMeZutkyRsS27epdIFR3h9n0718h5uDIkH
	Baw1AOwiBFC7PLzQ/P+XrfpaaHOFHu8hiJZkOvXpkaz5h0ma61mzTC229c4OwVNF2LRqXt
	rthAhJoePTvSTSjDeXAOc7y3O7x+d6k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 06/21] bcachefs: enum set_needs_rebalance_ctx
Date: Sun, 24 Aug 2025 08:37:43 -0400
Message-ID: <20250824123800.1617669-7-kent.overstreet@linux.dev>
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

Define why we're updating rebalance options, so we know what changes are
allowed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  1 +
 fs/bcachefs/io_write.c    |  5 ++++-
 fs/bcachefs/move.c        |  6 ++++--
 fs/bcachefs/rebalance.c   |  9 ++++++---
 fs/bcachefs/rebalance.h   | 19 ++++++++++++++-----
 5 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index b62d890003ec..e932ee5488da 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -439,6 +439,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 						k.k->p, insert->k.p) ?:
 			bch2_inum_snapshot_opts_get(trans, k.k->p.inode, k.k->p.snapshot, &opts) ?:
 			bch2_bkey_set_needs_rebalance(c, &opts, insert,
+						      SET_NEEDS_REBALANCE_foreground,
 						      m->op.opts.change_cookie) ?:
 			bch2_trans_update(trans, &iter, insert,
 				BTREE_UPDATE_internal_snapshot_node);
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 0122d8b3292a..16bcdada8cf1 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -366,6 +366,7 @@ int bch2_extent_update(struct btree_trans *trans,
 						  i_sectors_delta, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
 		 bch2_bkey_set_needs_rebalance(c, &opts, k,
+					       SET_NEEDS_REBALANCE_foreground,
 					       change_cookie)) ?:
 		bch2_trans_update(trans, iter, k, 0) ?:
 		bch2_trans_commit(trans, disk_res, NULL,
@@ -1270,7 +1271,9 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 	return  bch2_extent_update_i_size_sectors(trans, iter,
 					min(new->k.p.offset << 9, new_i_size), 0, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
-		 bch2_bkey_set_needs_rebalance(c, &opts, new, op->opts.change_cookie)) ?:
+		 bch2_bkey_set_needs_rebalance(c, &opts, new,
+					       SET_NEEDS_REBALANCE_foreground,
+					       op->opts.change_cookie)) ?:
 		bch2_trans_update(trans, iter, new,
 				  BTREE_UPDATE_internal_snapshot_node);
 }
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 03b3060f1964..e96443e67b29 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -499,7 +499,8 @@ struct bch_inode_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 				break;
 			}
 out:
-	ret = bch2_get_update_rebalance_opts(trans, opts_ret, extent_iter, extent_k);
+	ret = bch2_get_update_rebalance_opts(trans, opts_ret, extent_iter, extent_k,
+					     SET_NEEDS_REBALANCE_other);
 	if (ret)
 		return ERR_PTR(ret);
 	return opts_ret;
@@ -531,7 +532,8 @@ int bch2_move_get_io_opts_one(struct btree_trans *trans,
 		}
 	}
 
-	return bch2_get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k);
+	return bch2_get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k,
+					     SET_NEEDS_REBALANCE_other);
 }
 
 int bch2_move_ratelimit(struct moving_context *ctxt)
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index d8e214e6f671..a9d772642b3f 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -162,7 +162,9 @@ static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_inode_
 }
 
 int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
-				  struct bkey_i *_k, u32 change_cookie)
+				  struct bkey_i *_k,
+				  enum set_needs_rebalance_ctx ctx,
+				  u32 change_cookie)
 {
 	if (!bkey_extent_is_direct_data(&_k->k))
 		return 0;
@@ -189,7 +191,8 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 				   struct bch_inode_opts *io_opts,
 				   struct btree_iter *iter,
-				   struct bkey_s_c k)
+				   struct bkey_s_c k,
+				   enum set_needs_rebalance_ctx ctx)
 {
 	BUG_ON(iter->flags & BTREE_ITER_is_extents);
 	BUG_ON(iter->flags & BTREE_ITER_filter_snapshots);
@@ -218,7 +221,7 @@ int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n, 0) ?:
+	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
 		bch_err_throw(trans->c, transaction_restart_nested);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 62b7f0b3aec7..1e1d6818e7d4 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -27,11 +27,20 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 };
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
-int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *, struct bkey_i *, u32);
-int bch2_get_update_rebalance_opts(struct btree_trans *,
-				   struct bch_inode_opts *,
-				   struct btree_iter *,
-				   struct bkey_s_c);
+
+enum set_needs_rebalance_ctx {
+	SET_NEEDS_REBALANCE_opt_change,
+	SET_NEEDS_REBALANCE_opt_change_indirect,
+	SET_NEEDS_REBALANCE_foreground,
+	SET_NEEDS_REBALANCE_other,
+};
+
+int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *,
+				  struct bkey_i *, enum set_needs_rebalance_ctx, u32);
+
+int bch2_get_update_rebalance_opts(struct btree_trans *, struct bch_inode_opts *,
+				   struct btree_iter *, struct bkey_s_c,
+				   enum set_needs_rebalance_ctx);
 
 int bch2_set_rebalance_needs_scan_trans(struct btree_trans *, u64);
 int bch2_set_rebalance_needs_scan(struct bch_fs *, u64 inum);
-- 
2.50.1

