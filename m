Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC61991CA
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594984; cv=none; b=gFhQdU+iqw9/f1jKDqOg5OGeA4TxpZkCGRLNkXbAHlHpyVrFW7oDaTkacmBub3rjLCjmyo1syNZim4q8ec8cndGHmA4HIYep1iRIGQ1PVW22z9qOzlg4TE4GvBLKo9QQyIyLB/CYz3secXUJrkXG6JDXfl2Il9D737IvdOAcQSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594984; c=relaxed/simple;
	bh=ZVLmbyvpzHYD76Ob6p/V0RcV+gNUErs3AXk8aic4E7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9rFy+Q+QzKU9cWkQ6jA3k3m3yJrN6Dh6SyVytkxQc4V33vLWv5bp2JcOU2sQtPirUWSMgV6wZhN3zTz7EzJfH/vKCW3Vrwo9CiLy2Su4WC/SPMYiYN94LDbxzxRtlmF2cUfzDDidwfbxB4YQVfAT1K4tXWzFNwXMIIJ7am3Jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Mqyj7iC3; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Mqyj7iC3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2/q62NdLOdNuqwwny+fJ16aMuX7eOVyUGewTHDqJQ=;
	b=Mqyj7iC3v0xcloDdZoX8WMD1fRkXdKGoF5f1/BU91GskN63MYaS8odNYnJ5KxFtyuZvxpa
	uWgV+RB2IYgv3a2atR5Lma/trpUrhWWrClgykftZErVJHaOFu57fQcIQDR4TMhjTjnmsqm
	c77kUTFaXtjxIbNP8oUTlrC7p56IG98=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/11] bcachefs: __bch2_move_data_phys() now uses bch2_btree_node_rewrite_key()
Date: Mon, 30 Dec 2024 16:42:43 -0500
Message-ID: <20241230214249.242966-5-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Kill most of the separate logic for btree nodes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c | 107 ++++++++++++++++-----------------------------
 1 file changed, 37 insertions(+), 70 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index b524827ae841..e257963c244b 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -771,91 +771,58 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 
 		if (ctxt->stats)
-			ctxt->stats->offset =
-				bp.k->p.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT;
+			ctxt->stats->offset = bp.k->p.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT;
 
-		if (!bp.v->level) {
-			k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
-			ret = bkey_err(k);
-			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-				continue;
-			if (ret)
-				goto err;
-			if (!k.k)
-				goto next;
+		k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
+		ret = bkey_err(k);
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			continue;
+		if (ret)
+			goto err;
+		if (!k.k)
+			goto next;
 
+		if (!bp.v->level) {
 			ret = bch2_move_get_io_opts_one(trans, &io_opts, &iter, k);
 			if (ret) {
 				bch2_trans_iter_exit(trans, &iter);
 				continue;
 			}
+		}
 
-			struct data_update_opts data_opts = {};
-			if (!pred(c, arg, k, &io_opts, &data_opts)) {
-				bch2_trans_iter_exit(trans, &iter);
-				goto next;
-			}
-
-			bch2_bkey_buf_reassemble(&sk, c, k);
-			k = bkey_i_to_s_c(sk.k);
-
-			unsigned sectors = bp.v->bucket_len; /* move_extent will drop locks */
-
-			ret = bch2_move_extent(ctxt, bucket_in_flight,
-					       &iter, k, io_opts, data_opts);
+		struct data_update_opts data_opts = {};
+		if (!pred(c, arg, k, &io_opts, &data_opts)) {
 			bch2_trans_iter_exit(trans, &iter);
+			goto next;
+		}
 
-			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-				continue;
-			if (ret == -ENOMEM) {
-				/* memory allocation failure, wait for some IO to finish */
-				bch2_move_ctxt_wait_for_io(ctxt);
-				continue;
-			}
-			if (ret)
-				goto err;
-
-			if (ctxt->stats)
-				atomic64_add(sectors, &ctxt->stats->sectors_seen);
-			sectors_moved += sectors;
-		} else {
-			struct btree *b;
-
-			b = bch2_backpointer_get_node(trans, bp, &iter, &last_flushed);
-			ret = PTR_ERR_OR_ZERO(b);
-			if (ret == -BCH_ERR_backpointer_to_overwritten_btree_node)
-				goto next;
-			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-				continue;
-			if (ret)
-				goto err;
-			if (!b)
-				goto next;
-
-			struct data_update_opts data_opts = {};
-			if (!pred(c, arg, bkey_i_to_s_c(&b->key), &io_opts, &data_opts)) {
-				bch2_trans_iter_exit(trans, &iter);
-				goto next;
-			}
+		bch2_bkey_buf_reassemble(&sk, c, k);
+		k = bkey_i_to_s_c(sk.k);
 
-			unsigned sectors = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
+		/* move_extent will drop locks */
+		unsigned sectors = !bp.v->level
+			? bp.v->bucket_len
+			: btree_ptr_sectors_written(k);
 
-			ret = bch2_btree_node_rewrite(trans, &iter, b, 0);
-			bch2_trans_iter_exit(trans, &iter);
+		ret = !bp.v->level
+			? bch2_move_extent(ctxt, bucket_in_flight, &iter, k, io_opts, data_opts)
+			: bch2_btree_node_rewrite_key(trans, bp.v->btree_id, bp.v->level, k.k->p, 0);
 
-			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-				continue;
-			if (ret)
-				goto err;
+		bch2_trans_iter_exit(trans, &iter);
 
-			if (ctxt->rate)
-				bch2_ratelimit_increment(ctxt->rate, sectors);
-			if (ctxt->stats) {
-				atomic64_add(sectors, &ctxt->stats->sectors_seen);
-				atomic64_add(sectors, &ctxt->stats->sectors_moved);
-			}
-			sectors_moved += sectors;
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			continue;
+		if (ret == -ENOMEM) {
+			/* memory allocation failure, wait for some IO to finish */
+			bch2_move_ctxt_wait_for_io(ctxt);
+			continue;
 		}
+		if (ret)
+			goto err;
+
+		if (ctxt->stats)
+			atomic64_add(sectors, &ctxt->stats->sectors_seen);
+		sectors_moved += sectors;
 next:
 		bch2_btree_iter_advance(&bp_iter);
 	}
-- 
2.45.2

