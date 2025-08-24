Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E9C274658
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039095; cv=none; b=SE5vzBL5Yvac/tklQ5UY3BYfUYtpffUhF3JlA88E8Y9wLUITnHHXxZLwQ6IcHnVArcZ3XLrmtaeT+f3cRImHTxwXjHbKBixeUzqmeGtzDogCX5h12sweXKDPQfVJVONB59x/qD+KAfqGDsRe/IowRP0l6/h2xhast5ciQO3tTqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039095; c=relaxed/simple;
	bh=D3niewMx8XDWCPu7lS6AMk4qkFv9RyEkD1nrkER5SK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XYwu3Q095Qxk1Xc2o2jL8z86Vps+84zQc7w/YPFicColbf51Y/t8qeThNKurR9OUMJBto1DB8P1kPFdcaXnOvnFYjKTMUB2SRmU+QednxWVVPziHkvwp90LrPrzSYYG3gFO9tdo4Ws0P51a8QVjiiCHZx5Bshnfs5mAMm32aSjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VeZRm4me; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VeZRm4me"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zYtN5UtckZXRhUCQkRZ1xNsj12BXAsMYlfqqx5sQJ1U=;
	b=VeZRm4meurBgHYbVaSDJZBcAHxXL1bDkUBPg+6Wj8BhRhpFoGBsecN6WhGGu8swGWGYtUg
	V40Dr+Y0cV85mbutk/L/7FWjcf4BkgifcsXWJPr9WhGKEtIQ0S/s0izkRF+dTyMCqVES7S
	R81GmUM9ojIyz8gK/OVMVZISrI7HjVQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/21] bcachefs: do_rebalance_scan() now responsible for indirect extents
Date: Sun, 24 Aug 2025 08:37:44 -0400
Message-ID: <20250824123800.1617669-8-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c      | 69 ++---------------------------------------
 fs/bcachefs/rebalance.c | 32 +++++++++++++++++--
 2 files changed, 33 insertions(+), 68 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index e96443e67b29..5adeca883ecd 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -580,37 +580,6 @@ int bch2_move_ratelimit(struct moving_context *ctxt)
 	return 0;
 }
 
-/*
- * Move requires non extents iterators, and there's also no need for it to
- * signal indirect_extent_missing_error:
- */
-static struct bkey_s_c bch2_lookup_indirect_extent_for_move(struct btree_trans *trans,
-					    struct btree_iter *iter,
-					    struct bkey_s_c_reflink_p p)
-{
-	if (unlikely(REFLINK_P_ERROR(p.v)))
-		return bkey_s_c_null;
-
-	struct bpos reflink_pos = POS(0, REFLINK_P_IDX(p.v));
-
-	bch2_trans_iter_init(trans, iter,
-			     BTREE_ID_reflink, reflink_pos,
-			     BTREE_ITER_not_extents);
-
-	struct bkey_s_c k = bch2_btree_iter_peek(iter);
-	if (!k.k || bkey_err(k)) {
-		bch2_trans_iter_exit(iter);
-		return k;
-	}
-
-	if (bkey_lt(reflink_pos, bkey_start_pos(k.k))) {
-		bch2_trans_iter_exit(iter);
-		return bkey_s_c_null;
-	}
-
-	return k;
-}
-
 int bch2_move_data_btree(struct moving_context *ctxt,
 			 struct bpos start,
 			 struct bpos end,
@@ -625,12 +594,6 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 	struct btree_iter iter, reflink_iter = {};
 	struct bkey_s_c k;
 	struct data_update_opts data_opts;
-	/*
-	 * If we're moving a single file, also process reflinked data it points
-	 * to (this includes propagating changed io_opts from the inode to the
-	 * extent):
-	 */
-	bool walk_indirect = start.inode == end.inode;
 	int ret = 0, ret2;
 
 	per_snapshot_io_opts_init(&snapshot_io_opts, c);
@@ -695,8 +658,6 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 		bch2_ratelimit_reset(ctxt->rate);
 
 	while (!bch2_move_ratelimit(ctxt)) {
-		struct btree_iter *extent_iter = &iter;
-
 		bch2_trans_begin(trans);
 
 		k = bch2_btree_iter_peek(&iter);
@@ -715,41 +676,17 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 		if (ctxt->stats)
 			ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
-		if (walk_indirect &&
-		    k.k->type == KEY_TYPE_reflink_p &&
-		    REFLINK_P_MAY_UPDATE_OPTIONS(bkey_s_c_to_reflink_p(k).v)) {
-			struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
-
-			bch2_trans_iter_exit(&reflink_iter);
-			k = bch2_lookup_indirect_extent_for_move(trans, &reflink_iter, p);
-			ret = bkey_err(k);
-			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-				continue;
-			if (ret)
-				break;
-
-			if (!k.k)
-				goto next_nondata;
-
-			/*
-			 * XXX: reflink pointers may point to multiple indirect
-			 * extents, so don't advance past the entire reflink
-			 * pointer - need to fixup iter->k
-			 */
-			extent_iter = &reflink_iter;
-		}
-
 		if (!bkey_extent_is_direct_data(k.k))
 			goto next_nondata;
 
 		io_opts = bch2_move_get_io_opts(trans, &snapshot_io_opts,
-						iter.pos, extent_iter, k);
+						iter.pos, &iter, k);
 		ret = PTR_ERR_OR_ZERO(io_opts);
 		if (ret)
 			continue;
 
 		memset(&data_opts, 0, sizeof(data_opts));
-		if (!pred(c, arg, extent_iter->btree_id, k, io_opts, &data_opts))
+		if (!pred(c, arg, iter.btree_id, k, io_opts, &data_opts))
 			goto next;
 
 		/*
@@ -760,7 +697,7 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 		k = bkey_i_to_s_c(sk.k);
 
 		if (!level)
-			ret2 = bch2_move_extent(ctxt, NULL, extent_iter, k, *io_opts, data_opts);
+			ret2 = bch2_move_extent(ctxt, NULL, &iter, k, *io_opts, data_opts);
 		else if (!data_opts.scrub)
 			ret2 = bch2_btree_node_rewrite_pos(trans, btree_id, level,
 							  k.k->p, data_opts.target, 0);
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index a9d772642b3f..2bb634ee0f48 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -482,6 +482,29 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	return ret;
 }
 
+static int do_rebalance_scan_indirect(struct btree_trans *trans,
+				      struct bkey_s_c_reflink_p p,
+				      struct bch_inode_opts *opts)
+{
+	u64 idx = REFLINK_P_IDX(p.v) - le32_to_cpu(p.v->front_pad);
+	u64 end = REFLINK_P_IDX(p.v) + p.k->size + le32_to_cpu(p.v->back_pad);
+	u32 restart_count = trans->restart_count;
+
+	int ret = for_each_btree_key(trans, iter, BTREE_ID_reflink,
+				     POS(0, idx), BTREE_ITER_not_extents, k, ({
+		if (bpos_ge(bkey_start_pos(k.k), POS(0, end)))
+			break;
+		bch2_get_update_rebalance_opts(trans, opts, &iter, k,
+					       SET_NEEDS_REBALANCE_opt_change_indirect);
+	}));
+	if (ret)
+		return ret;
+
+	/* suppress trans_was_restarted() check */
+	trans->restart_count = restart_count;
+	return 0;
+}
+
 static int do_rebalance_scan(struct moving_context *ctxt,
 			     u64 inum, u64 cookie, u64 *sectors_scanned)
 {
@@ -511,9 +534,14 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 					 BTREE_ITER_prefetch, k, ({
 		ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
-		struct bch_inode_opts *io_opts = bch2_move_get_io_opts(trans,
+		struct bch_inode_opts *opts = bch2_move_get_io_opts(trans,
 					&snapshot_io_opts, iter.pos, &iter, k);
-		PTR_ERR_OR_ZERO(io_opts);
+		PTR_ERR_OR_ZERO(opts) ?:
+		(inum &&
+		 k.k->type == KEY_TYPE_reflink_p &&
+		 REFLINK_P_MAY_UPDATE_OPTIONS(bkey_s_c_to_reflink_p(k).v)
+		 ? do_rebalance_scan_indirect(trans, bkey_s_c_to_reflink_p(k), opts)
+		 : 0);
 	})) ?:
 	commit_do(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
 		  bch2_clear_rebalance_needs_scan(trans, inum, cookie));
-- 
2.50.1

