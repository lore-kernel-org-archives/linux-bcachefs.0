Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2F432D5A14
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039096; cv=none; b=WlSYXQzBC7o+FWuTFK/+tvh8K7O9lvtLqlQpASOk2u62sDF3MODtVNR4Idz+GkcppuLCz5h6lPNaZ7sqR4RpUMYI3Gs26CUT+FJXRR/QIfd40NE2GzwL5ot4jM7gJYk/Tw3mNdHFih5sq8W7OGO2XORu+VHwUf2HTAmk0Qnqcz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039096; c=relaxed/simple;
	bh=oIMIymEGQ8jVHTjXgSS7CVeOz0Y8ErcLcAQIGrQQlu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avh5rwGnDxATMxGrAJHoLtybkFI4/2TIklPlnbH6hefPwhm2lSPcGt8QefvF9zxyxNo8OGvE9EcXQ3oPigkiJOHN00NRyBQyfOU31SW2xH/g7wX5aanHFAeMZm7aFibWyFPDOwU26Df30x3G0elZkGYTHFuVCT4aKyprBAQgB3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rvlnEudt; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rvlnEudt"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/EMdZKo4w+WW63xyOtRU3WNPX7MOMjXWGSDjSkuQCU=;
	b=rvlnEudtowdRqFsDzvm4OHtl6tMXGTKmK4HmErZqHvIy0MqpkIOzsQU/BsAJxnZMGjJCyA
	COyHcCuWjVvEsmkwXUI9Nnd139A/snI3pNlGzysvsBA5UUrhmTTnFIz7LeotFIn9eL5wwA
	AMjFuGFo2fCebPXmLZAWSfDpKXa6nm4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 09/21] bcachefs: do_rebalance_extent() uses bch2_extent_get_apply_io_opts()
Date: Sun, 24 Aug 2025 08:37:46 -0400
Message-ID: <20250824123800.1617669-10-kent.overstreet@linux.dev>
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

No reason for it to be using bch2_extent_get_io_opts_one(), iterating
over the rebalance_work btree iterates in natural key order.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 51 ++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index d34a287cace4..f292c93ddd4d 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -457,9 +457,10 @@ static int bch2_bkey_clear_needs_rebalance(struct btree_trans *trans,
 }
 
 static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
+			struct per_snapshot_io_opts *snapshot_io_opts,
 			struct bpos work_pos,
 			struct btree_iter *extent_iter,
-			struct bch_inode_opts *io_opts,
+			struct bch_inode_opts **opts_ret,
 			struct data_update_opts *data_opts)
 {
 	struct bch_fs *c = trans->c;
@@ -473,14 +474,19 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 	if (bkey_err(k))
 		return k;
 
-	int ret = bch2_extent_get_io_opts_one(trans, io_opts, extent_iter, k,
+	struct bch_inode_opts *opts =
+		bch2_extent_get_apply_io_opts(trans, snapshot_io_opts,
+					      extent_iter->pos, extent_iter, k,
 					      SET_NEEDS_REBALANCE_other);
+	int ret = PTR_ERR_OR_ZERO(opts);
 	if (ret)
 		return bkey_s_c_err(ret);
 
+	*opts_ret = opts;
+
 	memset(data_opts, 0, sizeof(*data_opts));
-	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, io_opts, k);
-	data_opts->target		= io_opts->background_target;
+	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, opts, k);
+	data_opts->target		= opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_only_specified_devs;
 
 	if (!data_opts->rewrite_ptrs) {
@@ -505,19 +511,19 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 
 		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 
-		unsigned p = bch2_bkey_ptrs_need_compress(c, io_opts, k, ptrs);
+		unsigned p = bch2_bkey_ptrs_need_compress(c, opts, k, ptrs);
 		if (p) {
 			prt_str(&buf, "compression=");
-			bch2_compression_opt_to_text(&buf, io_opts->background_compression);
+			bch2_compression_opt_to_text(&buf, opts->background_compression);
 			prt_str(&buf, " ");
 			bch2_prt_u64_base2(&buf, p);
 			prt_newline(&buf);
 		}
 
-		p = bch2_bkey_ptrs_need_move(c, io_opts, ptrs);
+		p = bch2_bkey_ptrs_need_move(c, opts, ptrs);
 		if (p) {
 			prt_str(&buf, "move=");
-			bch2_target_to_text(&buf, c, io_opts->background_target);
+			bch2_target_to_text(&buf, c, opts->background_target);
 			prt_str(&buf, " ");
 			bch2_prt_u64_base2(&buf, p);
 			prt_newline(&buf);
@@ -532,6 +538,7 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 
 noinline_for_stack
 static int do_rebalance_extent(struct moving_context *ctxt,
+			       struct per_snapshot_io_opts *snapshot_io_opts,
 			       struct bpos work_pos,
 			       struct btree_iter *extent_iter)
 {
@@ -539,7 +546,7 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	struct bch_fs *c = trans->c;
 	struct bch_fs_rebalance *r = &trans->c->rebalance;
 	struct data_update_opts data_opts;
-	struct bch_inode_opts io_opts;
+	struct bch_inode_opts *io_opts;
 	struct bkey_s_c k;
 	struct bkey_buf sk;
 	int ret;
@@ -550,8 +557,8 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	bch2_bkey_buf_init(&sk);
 
 	ret = lockrestart_do(trans,
-		bkey_err(k = next_rebalance_extent(trans, work_pos,
-				extent_iter, &io_opts, &data_opts)));
+		bkey_err(k = next_rebalance_extent(trans, snapshot_io_opts,
+				work_pos, extent_iter, &io_opts, &data_opts)));
 	if (ret || !k.k)
 		goto out;
 
@@ -564,7 +571,7 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	bch2_bkey_buf_reassemble(&sk, c, k);
 	k = bkey_i_to_s_c(sk.k);
 
-	ret = bch2_move_extent(ctxt, NULL, extent_iter, k, io_opts, data_opts);
+	ret = bch2_move_extent(ctxt, NULL, extent_iter, k, *io_opts, data_opts);
 	if (ret) {
 		if (bch2_err_matches(ret, ENOMEM)) {
 			/* memory allocation failure, wait for some IO to finish */
@@ -607,6 +614,7 @@ static int do_rebalance_scan_indirect(struct btree_trans *trans,
 }
 
 static int do_rebalance_scan(struct moving_context *ctxt,
+			     struct per_snapshot_io_opts *snapshot_io_opts,
 			     u64 inum, u64 cookie, u64 *sectors_scanned)
 {
 	struct btree_trans *trans = ctxt->trans;
@@ -626,9 +634,6 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 
 	r->state = BCH_REBALANCE_scanning;
 
-	struct per_snapshot_io_opts snapshot_io_opts;
-	per_snapshot_io_opts_init(&snapshot_io_opts, c);
-
 	int ret = for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 					 r->scan_start.pos, r->scan_end.pos,
 					 BTREE_ITER_all_snapshots|
@@ -636,7 +641,7 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 		ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
 		struct bch_inode_opts *opts = bch2_extent_get_apply_io_opts(trans,
-					&snapshot_io_opts, iter.pos, &iter, k,
+					snapshot_io_opts, iter.pos, &iter, k,
 					SET_NEEDS_REBALANCE_opt_change);
 		PTR_ERR_OR_ZERO(opts) ?:
 		(inum &&
@@ -648,16 +653,14 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 	commit_do(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
 		  bch2_clear_rebalance_needs_scan(trans, inum, cookie));
 
-	per_snapshot_io_opts_exit(&snapshot_io_opts);
 	*sectors_scanned += atomic64_read(&r->scan_stats.sectors_seen);
-	bch2_move_stats_exit(&r->scan_stats, c);
-
 	/*
 	 * Ensure that the rebalance_work entries we created are seen by the
 	 * next iteration of do_rebalance(), so we don't end up stuck in
 	 * rebalance_wait():
 	 */
 	*sectors_scanned += 1;
+	bch2_move_stats_exit(&r->scan_stats, c);
 
 	bch2_btree_write_buffer_flush_sync(trans);
 
@@ -709,6 +712,9 @@ static int do_rebalance(struct moving_context *ctxt)
 
 	bch2_move_stats_init(&r->work_stats, "rebalance_work");
 
+	struct per_snapshot_io_opts snapshot_io_opts;
+	per_snapshot_io_opts_init(&snapshot_io_opts, c);
+
 	while (!bch2_move_ratelimit(ctxt)) {
 		if (!bch2_rebalance_enabled(c)) {
 			bch2_moving_ctxt_flush_all(ctxt);
@@ -723,15 +729,18 @@ static int do_rebalance(struct moving_context *ctxt)
 			break;
 
 		ret = k->k.type == KEY_TYPE_cookie
-			? do_rebalance_scan(ctxt, k->k.p.inode,
+			? do_rebalance_scan(ctxt, &snapshot_io_opts,
+					    k->k.p.inode,
 					    le64_to_cpu(bkey_i_to_cookie(k)->v.cookie),
 					    &sectors_scanned)
-			: do_rebalance_extent(ctxt, k->k.p, &extent_iter);
+			: do_rebalance_extent(ctxt, &snapshot_io_opts,
+					      k->k.p, &extent_iter);
 		if (ret)
 			break;
 	}
 
 	bch2_trans_iter_exit(&extent_iter);
+	per_snapshot_io_opts_exit(&snapshot_io_opts);
 	bch2_move_stats_exit(&r->work_stats, c);
 
 	if (!ret &&
-- 
2.50.1

