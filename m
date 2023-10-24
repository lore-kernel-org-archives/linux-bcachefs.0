Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C40CC25B47
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344221AbjJXTO1 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbjJXTO1 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:27 -0400
Received: from out-204.mta1.migadu.com (out-204.mta1.migadu.com [IPv6:2001:41d0:203:375::cc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127E510C6
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=95FHXNPxcK8CYVsPhhxfEJL64kXvYpU2nparaae5G+o=;
        b=RndrUkCg8/HrubavLjGmA3n4e50CwJkaMpDFKwbSWzUDpZjr0okB1Ky+aJdsbk3dDkiNf7
        CKhm2ByXBioS+Vmet4fWlEow69S4SW6t0SOcmucpNzeueTWleEnX9eFK2mqFln9midkrUH
        ioH5UhjMXcOHGztrfKvzjFuXiamwvOQ=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/6] bcachefs: move.c exports, refactoring
Date:   Tue, 24 Oct 2023 15:14:06 -0400
Message-ID: <20231024191414.2157874-2-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Prep work for the new rebalance code - we need a few helpers exported.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c      | 119 +++++++++++++++++++++-------------------
 fs/bcachefs/move.h      |  22 +++++++-
 fs/bcachefs/rebalance.c |   3 +-
 3 files changed, 85 insertions(+), 59 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 38b076ff1906..12167791e34c 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -171,8 +171,8 @@ void bch2_moving_ctxt_do_pending_writes(struct moving_context *ctxt,
 	}
 }
 
-static void bch2_move_ctxt_wait_for_io(struct moving_context *ctxt,
-				       struct btree_trans *trans)
+void bch2_move_ctxt_wait_for_io(struct moving_context *ctxt,
+				struct btree_trans *trans)
 {
 	unsigned sectors_pending = atomic_read(&ctxt->write_sectors);
 
@@ -287,14 +287,13 @@ static int bch2_extent_drop_ptrs(struct btree_trans *trans,
 		bch2_trans_commit(trans, NULL, NULL, BTREE_INSERT_NOFAIL);
 }
 
-static int bch2_move_extent(struct btree_trans *trans,
-			    struct btree_iter *iter,
-			    struct moving_context *ctxt,
-			    struct move_bucket_in_flight *bucket_in_flight,
-			    struct bch_io_opts io_opts,
-			    enum btree_id btree_id,
-			    struct bkey_s_c k,
-			    struct data_update_opts data_opts)
+int bch2_move_extent(struct btree_trans *trans,
+		     struct btree_iter *iter,
+		     struct moving_context *ctxt,
+		     struct move_bucket_in_flight *bucket_in_flight,
+		     struct bch_io_opts io_opts,
+		     struct bkey_s_c k,
+		     struct data_update_opts data_opts)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
@@ -356,7 +355,7 @@ static int bch2_move_extent(struct btree_trans *trans,
 	io->rbio.bio.bi_end_io		= move_read_endio;
 
 	ret = bch2_data_update_init(trans, ctxt, &io->write, ctxt->wp,
-				    io_opts, data_opts, btree_id, k);
+				    io_opts, data_opts, iter->btree_id, k);
 	if (ret && ret != -BCH_ERR_unwritten_extent_update)
 		goto err_free_pages;
 
@@ -371,6 +370,9 @@ static int bch2_move_extent(struct btree_trans *trans,
 	io->write.ctxt = ctxt;
 	io->write.op.end_io = move_write_done;
 
+	if (ctxt->rate)
+		bch2_ratelimit_increment(ctxt->rate, k.k->size);
+
 	if (ctxt->stats) {
 		atomic64_inc(&ctxt->stats->keys_moved);
 		atomic64_add(k.k->size, &ctxt->stats->sectors_moved);
@@ -400,7 +402,7 @@ static int bch2_move_extent(struct btree_trans *trans,
 	closure_get(&ctxt->cl);
 	bch2_read_extent(trans, &io->rbio,
 			 bkey_start_pos(k.k),
-			 btree_id, k, 0,
+			 iter->btree_id, k, 0,
 			 BCH_READ_NODECODE|
 			 BCH_READ_LAST_FRAGMENT);
 	return 0;
@@ -464,9 +466,9 @@ struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 	return &io_opts->fs_io_opts;
 }
 
-static int bch2_move_get_io_opts_one(struct btree_trans *trans,
-				     struct bch_io_opts *io_opts,
-				     struct bkey_s_c extent_k)
+int bch2_move_get_io_opts_one(struct btree_trans *trans,
+			      struct bch_io_opts *io_opts,
+			      struct bkey_s_c extent_k)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -497,8 +499,8 @@ static int bch2_move_get_io_opts_one(struct btree_trans *trans,
 	return 0;
 }
 
-static int move_ratelimit(struct btree_trans *trans,
-			  struct moving_context *ctxt)
+int bch2_move_ratelimit(struct btree_trans *trans,
+			struct moving_context *ctxt)
 {
 	struct bch_fs *c = trans->c;
 	u64 delay;
@@ -545,7 +547,8 @@ static int move_ratelimit(struct btree_trans *trans,
 	return 0;
 }
 
-static int __bch2_move_data(struct moving_context *ctxt,
+static int bch2_move_data_btree(struct btree_trans *trans,
+			    struct moving_context *ctxt,
 			    struct bpos start,
 			    struct bpos end,
 			    move_pred_fn pred, void *arg,
@@ -555,7 +558,6 @@ static int __bch2_move_data(struct moving_context *ctxt,
 	struct per_snapshot_io_opts snapshot_io_opts;
 	struct bch_io_opts *io_opts;
 	struct bkey_buf sk;
-	struct btree_trans *trans = bch2_trans_get(c);
 	struct btree_iter iter;
 	struct bkey_s_c k;
 	struct data_update_opts data_opts;
@@ -577,7 +579,7 @@ static int __bch2_move_data(struct moving_context *ctxt,
 	if (ctxt->rate)
 		bch2_ratelimit_reset(ctxt->rate);
 
-	while (!move_ratelimit(trans, ctxt)) {
+	while (!bch2_move_ratelimit(trans, ctxt)) {
 		bch2_trans_begin(trans);
 
 		k = bch2_btree_iter_peek(&iter);
@@ -616,7 +618,7 @@ static int __bch2_move_data(struct moving_context *ctxt,
 		k = bkey_i_to_s_c(sk.k);
 
 		ret2 = bch2_move_extent(trans, &iter, ctxt, NULL,
-					*io_opts, btree_id, k, data_opts);
+					*io_opts, k, data_opts);
 		if (ret2) {
 			if (bch2_err_matches(ret2, BCH_ERR_transaction_restart))
 				continue;
@@ -630,9 +632,6 @@ static int __bch2_move_data(struct moving_context *ctxt,
 			/* XXX signal failure */
 			goto next;
 		}
-
-		if (ctxt->rate)
-			bch2_ratelimit_increment(ctxt->rate, k.k->size);
 next:
 		if (ctxt->stats)
 			atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
@@ -641,48 +640,60 @@ static int __bch2_move_data(struct moving_context *ctxt,
 	}
 
 	bch2_trans_iter_exit(trans, &iter);
-	bch2_trans_put(trans);
 	bch2_bkey_buf_exit(&sk, c);
 	per_snapshot_io_opts_exit(&snapshot_io_opts);
 
 	return ret;
 }
 
-int bch2_move_data(struct bch_fs *c,
-		   enum btree_id start_btree_id, struct bpos start_pos,
-		   enum btree_id end_btree_id,   struct bpos end_pos,
-		   struct bch_ratelimit *rate,
-		   struct bch_move_stats *stats,
-		   struct write_point_specifier wp,
-		   bool wait_on_copygc,
-		   move_pred_fn pred, void *arg)
+int __bch2_move_data(struct btree_trans *trans,
+		     struct moving_context *ctxt,
+		     struct bbpos start,
+		     struct bbpos end,
+		     move_pred_fn pred, void *arg)
 {
-	struct moving_context ctxt;
+	struct bch_fs *c = trans->c;
 	enum btree_id id;
 	int ret = 0;
 
-	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
-
-	for (id = start_btree_id;
-	     id <= min_t(unsigned, end_btree_id, btree_id_nr_alive(c) - 1);
+	for (id = start.btree;
+	     id <= min_t(unsigned, end.btree, btree_id_nr_alive(c) - 1);
 	     id++) {
-		stats->btree_id = id;
+		ctxt->stats->btree_id = id;
 
-		if (id != BTREE_ID_extents &&
-		    id != BTREE_ID_reflink)
+		if (!btree_type_has_ptrs(id) ||
+		    !bch2_btree_id_root(c, id)->b)
 			continue;
 
-		if (!bch2_btree_id_root(c, id)->b)
-			continue;
-
-		ret = __bch2_move_data(&ctxt,
-				       id == start_btree_id ? start_pos : POS_MIN,
-				       id == end_btree_id   ? end_pos   : POS_MAX,
+		ret = bch2_move_data_btree(trans, ctxt,
+				       id == start.btree ? start.pos : POS_MIN,
+				       id == end.btree   ? end.pos   : POS_MAX,
 				       pred, arg, id);
 		if (ret)
 			break;
 	}
 
+	return ret;
+}
+
+int bch2_move_data(struct bch_fs *c,
+		   struct bbpos start,
+		   struct bbpos end,
+		   struct bch_ratelimit *rate,
+		   struct bch_move_stats *stats,
+		   struct write_point_specifier wp,
+		   bool wait_on_copygc,
+		   move_pred_fn pred, void *arg)
+{
+
+	struct btree_trans *trans;
+	struct moving_context ctxt;
+	int ret;
+
+	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
+	trans = bch2_trans_get(c);
+	ret = __bch2_move_data(trans, &ctxt, start, end, pred, arg);
+	bch2_trans_put(trans);
 	bch2_moving_ctxt_exit(&ctxt);
 
 	return ret;
@@ -739,7 +750,7 @@ int __bch2_evacuate_bucket(struct btree_trans *trans,
 		goto err;
 	}
 
-	while (!(ret = move_ratelimit(trans, ctxt))) {
+	while (!(ret = bch2_move_ratelimit(trans, ctxt))) {
 		bch2_trans_begin(trans);
 
 		ret = bch2_get_next_backpointer(trans, bucket, gen,
@@ -791,7 +802,7 @@ int __bch2_evacuate_bucket(struct btree_trans *trans,
 
 			ret = bch2_move_extent(trans, &iter, ctxt,
 					bucket_in_flight,
-					io_opts, bp.btree_id, k, data_opts);
+					io_opts, k, data_opts);
 			bch2_trans_iter_exit(trans, &iter);
 
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
@@ -804,8 +815,6 @@ int __bch2_evacuate_bucket(struct btree_trans *trans,
 			if (ret)
 				goto err;
 
-			if (ctxt->rate)
-				bch2_ratelimit_increment(ctxt->rate, k.k->size);
 			if (ctxt->stats)
 				atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
 		} else {
@@ -1087,8 +1096,8 @@ int bch2_data_job(struct bch_fs *c,
 		ret = bch2_replicas_gc2(c) ?: ret;
 
 		ret = bch2_move_data(c,
-				     op.start_btree,	op.start_pos,
-				     op.end_btree,	op.end_pos,
+				     (struct bbpos) { op.start_btree,	op.start_pos },
+				     (struct bbpos) { op.end_btree,	op.end_pos },
 				     NULL,
 				     stats,
 				     writepoint_hashed((unsigned long) current),
@@ -1111,8 +1120,8 @@ int bch2_data_job(struct bch_fs *c,
 		ret = bch2_replicas_gc2(c) ?: ret;
 
 		ret = bch2_move_data(c,
-				     op.start_btree,	op.start_pos,
-				     op.end_btree,	op.end_pos,
+				     (struct bbpos) { op.start_btree,	op.start_pos },
+				     (struct bbpos) { op.end_btree,	op.end_pos },
 				     NULL,
 				     stats,
 				     writepoint_hashed((unsigned long) current),
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index aa4b65c4f960..67ca13f7e772 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -2,6 +2,7 @@
 #ifndef _BCACHEFS_MOVE_H
 #define _BCACHEFS_MOVE_H
 
+#include "bbpos.h"
 #include "bcachefs_ioctl.h"
 #include "btree_iter.h"
 #include "buckets.h"
@@ -61,6 +62,9 @@ void bch2_moving_ctxt_init(struct moving_context *, struct bch_fs *,
 struct moving_io *bch2_moving_ctxt_next_pending_write(struct moving_context *);
 void bch2_moving_ctxt_do_pending_writes(struct moving_context *,
 					struct btree_trans *);
+void bch2_move_ctxt_wait_for_io(struct moving_context *,
+				struct btree_trans *);
+int bch2_move_ratelimit(struct btree_trans *, struct moving_context *);
 
 /* Inodes in different snapshots may have different IO options: */
 struct snapshot_io_opts_entry {
@@ -87,12 +91,26 @@ static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opt
 
 struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *,
 				struct per_snapshot_io_opts *, struct bkey_s_c);
+int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_io_opts *, struct bkey_s_c);
 
 int bch2_scan_old_btree_nodes(struct bch_fs *, struct bch_move_stats *);
 
+int bch2_move_extent(struct btree_trans *,
+		     struct btree_iter *,
+		     struct moving_context *,
+		     struct move_bucket_in_flight *,
+		     struct bch_io_opts,
+		     struct bkey_s_c,
+		     struct data_update_opts);
+
+int __bch2_move_data(struct btree_trans *,
+		     struct moving_context *,
+		     struct bbpos,
+		     struct bbpos,
+		     move_pred_fn, void *);
 int bch2_move_data(struct bch_fs *,
-		   enum btree_id, struct bpos,
-		   enum btree_id, struct bpos,
+		   struct bbpos start,
+		   struct bbpos end,
 		   struct bch_ratelimit *,
 		   struct bch_move_stats *,
 		   struct write_point_specifier,
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 568f1e8e7507..92403fa79f1f 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -254,8 +254,7 @@ static int bch2_rebalance_thread(void *arg)
 		rebalance_work_reset(c);
 
 		bch2_move_data(c,
-			       0,		POS_MIN,
-			       BTREE_ID_NR,	POS_MAX,
+			       BBPOS_MIN, BBPOS_MAX,
 			       /* ratelimiting disabled for now */
 			       NULL, /*  &r->pd.rate, */
 			       &move_stats,
-- 
2.42.0

