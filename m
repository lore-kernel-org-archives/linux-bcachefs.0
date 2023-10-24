Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F655C25B6E
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344223AbjJXTOb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344220AbjJXTOa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:30 -0400
Received: from out-198.mta1.migadu.com (out-198.mta1.migadu.com [95.215.58.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEE410CC
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:24 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Omxf1HA3C1Ea+sKD+UVZXv6WT2G0NDeBgTATK0xNhk=;
        b=Y9gMhHB7CHrwVU6v6fHvG+FOQ7nVyjgH9d6HB6M75d7y2u20/cGdIQ/M482CCmiaWmGgZL
        sGBSacFJar+WmCpw3Pw5E8jG//xt2kVf+ESZnwWQ9TO6+AtVqdaxAbHgEf5ICx+nRKmJ2r
        dIw5obPzze2DsS5dDecukG5El169Sgo=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/6] bcachefs: moving_context now owns a btree_trans
Date:   Tue, 24 Oct 2023 15:14:07 -0400
Message-ID: <20231024191414.2157874-3-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

btree_trans and moving_context are used together, and having the
moving_context owns the transaction object reduces some plumbing.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  2 +-
 fs/bcachefs/move.c        | 93 ++++++++++++++++++---------------------
 fs/bcachefs/move.h        | 27 +++++-------
 fs/bcachefs/movinggc.c    | 36 +++++++--------
 4 files changed, 70 insertions(+), 88 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 899ff46de8e0..9b42d37dc344 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -487,7 +487,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 
 		if (c->opts.nocow_enabled) {
 			if (ctxt) {
-				move_ctxt_wait_event(ctxt, trans,
+				move_ctxt_wait_event(ctxt,
 						(locked = bch2_bucket_nocow_trylock(&c->nocow_locks,
 									  PTR_BUCKET_POS(c, &p.ptr), 0)) ||
 						!atomic_read(&ctxt->read_sectors));
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 12167791e34c..570189eda6fd 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -157,13 +157,11 @@ static void move_read_endio(struct bio *bio)
 	closure_put(&ctxt->cl);
 }
 
-void bch2_moving_ctxt_do_pending_writes(struct moving_context *ctxt,
-					struct btree_trans *trans)
+void bch2_moving_ctxt_do_pending_writes(struct moving_context *ctxt)
 {
 	struct moving_io *io;
 
-	if (trans)
-		bch2_trans_unlock(trans);
+	bch2_trans_unlock(ctxt->trans);
 
 	while ((io = bch2_moving_ctxt_next_pending_write(ctxt))) {
 		list_del(&io->read_list);
@@ -171,21 +169,20 @@ void bch2_moving_ctxt_do_pending_writes(struct moving_context *ctxt,
 	}
 }
 
-void bch2_move_ctxt_wait_for_io(struct moving_context *ctxt,
-				struct btree_trans *trans)
+void bch2_move_ctxt_wait_for_io(struct moving_context *ctxt)
 {
 	unsigned sectors_pending = atomic_read(&ctxt->write_sectors);
 
-	move_ctxt_wait_event(ctxt, trans,
+	move_ctxt_wait_event(ctxt,
 		!atomic_read(&ctxt->write_sectors) ||
 		atomic_read(&ctxt->write_sectors) != sectors_pending);
 }
 
 void bch2_moving_ctxt_exit(struct moving_context *ctxt)
 {
-	struct bch_fs *c = ctxt->c;
+	struct bch_fs *c = ctxt->trans->c;
 
-	move_ctxt_wait_event(ctxt, NULL, list_empty(&ctxt->reads));
+	move_ctxt_wait_event(ctxt, list_empty(&ctxt->reads));
 	closure_sync(&ctxt->cl);
 
 	EBUG_ON(atomic_read(&ctxt->write_sectors));
@@ -203,6 +200,9 @@ void bch2_moving_ctxt_exit(struct moving_context *ctxt)
 	mutex_lock(&c->moving_context_lock);
 	list_del(&ctxt->list);
 	mutex_unlock(&c->moving_context_lock);
+
+	bch2_trans_put(ctxt->trans);
+	memset(ctxt, 0, sizeof(*ctxt));
 }
 
 void bch2_moving_ctxt_init(struct moving_context *ctxt,
@@ -214,7 +214,7 @@ void bch2_moving_ctxt_init(struct moving_context *ctxt,
 {
 	memset(ctxt, 0, sizeof(*ctxt));
 
-	ctxt->c		= c;
+	ctxt->trans	= bch2_trans_get(c);
 	ctxt->fn	= (void *) _RET_IP_;
 	ctxt->rate	= rate;
 	ctxt->stats	= stats;
@@ -287,14 +287,14 @@ static int bch2_extent_drop_ptrs(struct btree_trans *trans,
 		bch2_trans_commit(trans, NULL, NULL, BTREE_INSERT_NOFAIL);
 }
 
-int bch2_move_extent(struct btree_trans *trans,
-		     struct btree_iter *iter,
-		     struct moving_context *ctxt,
+int bch2_move_extent(struct moving_context *ctxt,
 		     struct move_bucket_in_flight *bucket_in_flight,
-		     struct bch_io_opts io_opts,
+		     struct btree_iter *iter,
 		     struct bkey_s_c k,
+		     struct bch_io_opts io_opts,
 		     struct data_update_opts data_opts)
 {
+	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	struct moving_io *io;
@@ -499,14 +499,13 @@ int bch2_move_get_io_opts_one(struct btree_trans *trans,
 	return 0;
 }
 
-int bch2_move_ratelimit(struct btree_trans *trans,
-			struct moving_context *ctxt)
+int bch2_move_ratelimit(struct moving_context *ctxt)
 {
-	struct bch_fs *c = trans->c;
+	struct bch_fs *c = ctxt->trans->c;
 	u64 delay;
 
 	if (ctxt->wait_on_copygc) {
-		bch2_trans_unlock(trans);
+		bch2_trans_unlock(ctxt->trans);
 		wait_event_killable(c->copygc_running_wq,
 				    !c->copygc_running ||
 				    kthread_should_stop());
@@ -516,7 +515,7 @@ int bch2_move_ratelimit(struct btree_trans *trans,
 		delay = ctxt->rate ? bch2_ratelimit_delay(ctxt->rate) : 0;
 
 		if (delay) {
-			bch2_trans_unlock(trans);
+			bch2_trans_unlock(ctxt->trans);
 			set_current_state(TASK_INTERRUPTIBLE);
 		}
 
@@ -529,7 +528,7 @@ int bch2_move_ratelimit(struct btree_trans *trans,
 			schedule_timeout(delay);
 
 		if (unlikely(freezing(current))) {
-			move_ctxt_wait_event(ctxt, trans, list_empty(&ctxt->reads));
+			move_ctxt_wait_event(ctxt, list_empty(&ctxt->reads));
 			try_to_freeze();
 		}
 	} while (delay);
@@ -538,7 +537,7 @@ int bch2_move_ratelimit(struct btree_trans *trans,
 	 * XXX: these limits really ought to be per device, SSDs and hard drives
 	 * will want different limits
 	 */
-	move_ctxt_wait_event(ctxt, trans,
+	move_ctxt_wait_event(ctxt,
 		atomic_read(&ctxt->write_sectors) < c->opts.move_bytes_in_flight >> 9 &&
 		atomic_read(&ctxt->read_sectors) < c->opts.move_bytes_in_flight >> 9 &&
 		atomic_read(&ctxt->write_ios) < c->opts.move_ios_in_flight &&
@@ -547,14 +546,14 @@ int bch2_move_ratelimit(struct btree_trans *trans,
 	return 0;
 }
 
-static int bch2_move_data_btree(struct btree_trans *trans,
-			    struct moving_context *ctxt,
-			    struct bpos start,
-			    struct bpos end,
-			    move_pred_fn pred, void *arg,
-			    enum btree_id btree_id)
+static int bch2_move_data_btree(struct moving_context *ctxt,
+				struct bpos start,
+				struct bpos end,
+				move_pred_fn pred, void *arg,
+				enum btree_id btree_id)
 {
-	struct bch_fs *c = ctxt->c;
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs *c = trans->c;
 	struct per_snapshot_io_opts snapshot_io_opts;
 	struct bch_io_opts *io_opts;
 	struct bkey_buf sk;
@@ -579,7 +578,7 @@ static int bch2_move_data_btree(struct btree_trans *trans,
 	if (ctxt->rate)
 		bch2_ratelimit_reset(ctxt->rate);
 
-	while (!bch2_move_ratelimit(trans, ctxt)) {
+	while (!bch2_move_ratelimit(ctxt)) {
 		bch2_trans_begin(trans);
 
 		k = bch2_btree_iter_peek(&iter);
@@ -617,15 +616,14 @@ static int bch2_move_data_btree(struct btree_trans *trans,
 		bch2_bkey_buf_reassemble(&sk, c, k);
 		k = bkey_i_to_s_c(sk.k);
 
-		ret2 = bch2_move_extent(trans, &iter, ctxt, NULL,
-					*io_opts, k, data_opts);
+		ret2 = bch2_move_extent(ctxt, NULL, &iter, k, *io_opts, data_opts);
 		if (ret2) {
 			if (bch2_err_matches(ret2, BCH_ERR_transaction_restart))
 				continue;
 
 			if (ret2 == -ENOMEM) {
 				/* memory allocation failure, wait for some IO to finish */
-				bch2_move_ctxt_wait_for_io(ctxt, trans);
+				bch2_move_ctxt_wait_for_io(ctxt);
 				continue;
 			}
 
@@ -646,13 +644,12 @@ static int bch2_move_data_btree(struct btree_trans *trans,
 	return ret;
 }
 
-int __bch2_move_data(struct btree_trans *trans,
-		     struct moving_context *ctxt,
+int __bch2_move_data(struct moving_context *ctxt,
 		     struct bbpos start,
 		     struct bbpos end,
 		     move_pred_fn pred, void *arg)
 {
-	struct bch_fs *c = trans->c;
+	struct bch_fs *c = ctxt->trans->c;
 	enum btree_id id;
 	int ret = 0;
 
@@ -665,7 +662,7 @@ int __bch2_move_data(struct btree_trans *trans,
 		    !bch2_btree_id_root(c, id)->b)
 			continue;
 
-		ret = bch2_move_data_btree(trans, ctxt,
+		ret = bch2_move_data_btree(ctxt,
 				       id == start.btree ? start.pos : POS_MIN,
 				       id == end.btree   ? end.pos   : POS_MAX,
 				       pred, arg, id);
@@ -686,26 +683,23 @@ int bch2_move_data(struct bch_fs *c,
 		   move_pred_fn pred, void *arg)
 {
 
-	struct btree_trans *trans;
 	struct moving_context ctxt;
 	int ret;
 
 	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
-	trans = bch2_trans_get(c);
-	ret = __bch2_move_data(trans, &ctxt, start, end, pred, arg);
-	bch2_trans_put(trans);
+	ret = __bch2_move_data(&ctxt, start, end, pred, arg);
 	bch2_moving_ctxt_exit(&ctxt);
 
 	return ret;
 }
 
-int __bch2_evacuate_bucket(struct btree_trans *trans,
-			   struct moving_context *ctxt,
+int __bch2_evacuate_bucket(struct moving_context *ctxt,
 			   struct move_bucket_in_flight *bucket_in_flight,
 			   struct bpos bucket, int gen,
 			   struct data_update_opts _data_opts)
 {
-	struct bch_fs *c = ctxt->c;
+	struct btree_trans *trans = ctxt->trans;
+	struct bch_fs *c = trans->c;
 	struct bch_io_opts io_opts = bch2_opts_to_inode_opts(c->opts);
 	struct btree_iter iter;
 	struct bkey_buf sk;
@@ -750,7 +744,7 @@ int __bch2_evacuate_bucket(struct btree_trans *trans,
 		goto err;
 	}
 
-	while (!(ret = bch2_move_ratelimit(trans, ctxt))) {
+	while (!(ret = bch2_move_ratelimit(ctxt))) {
 		bch2_trans_begin(trans);
 
 		ret = bch2_get_next_backpointer(trans, bucket, gen,
@@ -800,16 +794,15 @@ int __bch2_evacuate_bucket(struct btree_trans *trans,
 				i++;
 			}
 
-			ret = bch2_move_extent(trans, &iter, ctxt,
-					bucket_in_flight,
-					io_opts, k, data_opts);
+			ret = bch2_move_extent(ctxt, bucket_in_flight,
+					       &iter, k, io_opts, data_opts);
 			bch2_trans_iter_exit(trans, &iter);
 
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 				continue;
 			if (ret == -ENOMEM) {
 				/* memory allocation failure, wait for some IO to finish */
-				bch2_move_ctxt_wait_for_io(ctxt, trans);
+				bch2_move_ctxt_wait_for_io(ctxt);
 				continue;
 			}
 			if (ret)
@@ -865,14 +858,12 @@ int bch2_evacuate_bucket(struct bch_fs *c,
 			 struct write_point_specifier wp,
 			 bool wait_on_copygc)
 {
-	struct btree_trans *trans = bch2_trans_get(c);
 	struct moving_context ctxt;
 	int ret;
 
 	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
-	ret = __bch2_evacuate_bucket(trans, &ctxt, NULL, bucket, gen, data_opts);
+	ret = __bch2_evacuate_bucket(&ctxt, NULL, bucket, gen, data_opts);
 	bch2_moving_ctxt_exit(&ctxt);
-	bch2_trans_put(trans);
 
 	return ret;
 }
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 67ca13f7e772..39e762b103ca 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -12,7 +12,7 @@
 struct bch_read_bio;
 
 struct moving_context {
-	struct bch_fs		*c;
+	struct btree_trans	*trans;
 	struct list_head	list;
 	void			*fn;
 
@@ -38,10 +38,10 @@ struct moving_context {
 	wait_queue_head_t	wait;
 };
 
-#define move_ctxt_wait_event(_ctxt, _trans, _cond)			\
+#define move_ctxt_wait_event(_ctxt, _cond)				\
 do {									\
 	bool cond_finished = false;					\
-	bch2_moving_ctxt_do_pending_writes(_ctxt, _trans);		\
+	bch2_moving_ctxt_do_pending_writes(_ctxt);			\
 									\
 	if (_cond)							\
 		break;							\
@@ -60,11 +60,9 @@ void bch2_moving_ctxt_init(struct moving_context *, struct bch_fs *,
 			   struct bch_ratelimit *, struct bch_move_stats *,
 			   struct write_point_specifier, bool);
 struct moving_io *bch2_moving_ctxt_next_pending_write(struct moving_context *);
-void bch2_moving_ctxt_do_pending_writes(struct moving_context *,
-					struct btree_trans *);
-void bch2_move_ctxt_wait_for_io(struct moving_context *,
-				struct btree_trans *);
-int bch2_move_ratelimit(struct btree_trans *, struct moving_context *);
+void bch2_moving_ctxt_do_pending_writes(struct moving_context *);
+void bch2_move_ctxt_wait_for_io(struct moving_context *);
+int bch2_move_ratelimit(struct moving_context *);
 
 /* Inodes in different snapshots may have different IO options: */
 struct snapshot_io_opts_entry {
@@ -95,16 +93,14 @@ int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_io_opts *, struct
 
 int bch2_scan_old_btree_nodes(struct bch_fs *, struct bch_move_stats *);
 
-int bch2_move_extent(struct btree_trans *,
-		     struct btree_iter *,
-		     struct moving_context *,
+int bch2_move_extent(struct moving_context *,
 		     struct move_bucket_in_flight *,
-		     struct bch_io_opts,
+		     struct btree_iter *,
 		     struct bkey_s_c,
+		     struct bch_io_opts,
 		     struct data_update_opts);
 
-int __bch2_move_data(struct btree_trans *,
-		     struct moving_context *,
+int __bch2_move_data(struct moving_context *,
 		     struct bbpos,
 		     struct bbpos,
 		     move_pred_fn, void *);
@@ -117,8 +113,7 @@ int bch2_move_data(struct bch_fs *,
 		   bool,
 		   move_pred_fn, void *);
 
-int __bch2_evacuate_bucket(struct btree_trans *,
-			   struct moving_context *,
+int __bch2_evacuate_bucket(struct moving_context *,
 			   struct move_bucket_in_flight *,
 			   struct bpos, int,
 			   struct data_update_opts);
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 4017120baeee..a2862e322658 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -101,8 +101,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 	return ret;
 }
 
-static void move_buckets_wait(struct btree_trans *trans,
-			      struct moving_context *ctxt,
+static void move_buckets_wait(struct moving_context *ctxt,
 			      struct buckets_in_flight *list,
 			      bool flush)
 {
@@ -111,7 +110,7 @@ static void move_buckets_wait(struct btree_trans *trans,
 
 	while ((i = list->first)) {
 		if (flush)
-			move_ctxt_wait_event(ctxt, trans, !atomic_read(&i->count));
+			move_ctxt_wait_event(ctxt, !atomic_read(&i->count));
 
 		if (atomic_read(&i->count))
 			break;
@@ -129,7 +128,7 @@ static void move_buckets_wait(struct btree_trans *trans,
 		kfree(i);
 	}
 
-	bch2_trans_unlock(trans);
+	bch2_trans_unlock(ctxt->trans);
 }
 
 static bool bucket_in_flight(struct buckets_in_flight *list,
@@ -140,11 +139,11 @@ static bool bucket_in_flight(struct buckets_in_flight *list,
 
 typedef DARRAY(struct move_bucket) move_buckets;
 
-static int bch2_copygc_get_buckets(struct btree_trans *trans,
-			struct moving_context *ctxt,
+static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 			struct buckets_in_flight *buckets_in_flight,
 			move_buckets *buckets)
 {
+	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
 	struct bkey_s_c k;
@@ -152,7 +151,7 @@ static int bch2_copygc_get_buckets(struct btree_trans *trans,
 	size_t saw = 0, in_flight = 0, not_movable = 0, sectors = 0;
 	int ret;
 
-	move_buckets_wait(trans, ctxt, buckets_in_flight, false);
+	move_buckets_wait(ctxt, buckets_in_flight, false);
 
 	ret = bch2_btree_write_buffer_flush(trans);
 	if (bch2_fs_fatal_err_on(ret, c, "%s: error %s from bch2_btree_write_buffer_flush()",
@@ -188,10 +187,10 @@ static int bch2_copygc_get_buckets(struct btree_trans *trans,
 }
 
 noinline
-static int bch2_copygc(struct btree_trans *trans,
-		       struct moving_context *ctxt,
+static int bch2_copygc(struct moving_context *ctxt,
 		       struct buckets_in_flight *buckets_in_flight)
 {
+	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	struct data_update_opts data_opts = {
 		.btree_insert_flags = BCH_WATERMARK_copygc,
@@ -202,7 +201,7 @@ static int bch2_copygc(struct btree_trans *trans,
 	u64 moved = atomic64_read(&ctxt->stats->sectors_moved);
 	int ret = 0;
 
-	ret = bch2_copygc_get_buckets(trans, ctxt, buckets_in_flight, &buckets);
+	ret = bch2_copygc_get_buckets(ctxt, buckets_in_flight, &buckets);
 	if (ret)
 		goto err;
 
@@ -221,7 +220,7 @@ static int bch2_copygc(struct btree_trans *trans,
 			break;
 		}
 
-		ret = __bch2_evacuate_bucket(trans, ctxt, f, f->bucket.k.bucket,
+		ret = __bch2_evacuate_bucket(ctxt, f, f->bucket.k.bucket,
 					     f->bucket.k.gen, data_opts);
 		if (ret)
 			goto err;
@@ -300,7 +299,6 @@ void bch2_copygc_wait_to_text(struct printbuf *out, struct bch_fs *c)
 static int bch2_copygc_thread(void *arg)
 {
 	struct bch_fs *c = arg;
-	struct btree_trans *trans;
 	struct moving_context ctxt;
 	struct bch_move_stats move_stats;
 	struct io_clock *clock = &c->io_clock[WRITE];
@@ -317,7 +315,6 @@ static int bch2_copygc_thread(void *arg)
 	}
 
 	set_freezable();
-	trans = bch2_trans_get(c);
 
 	bch2_move_stats_init(&move_stats, "copygc");
 	bch2_moving_ctxt_init(&ctxt, c, NULL, &move_stats,
@@ -325,16 +322,16 @@ static int bch2_copygc_thread(void *arg)
 			      false);
 
 	while (!ret && !kthread_should_stop()) {
-		bch2_trans_unlock(trans);
+		bch2_trans_unlock(ctxt.trans);
 		cond_resched();
 
 		if (!c->copy_gc_enabled) {
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, &buckets, true);
 			kthread_wait_freezable(c->copy_gc_enabled);
 		}
 
 		if (unlikely(freezing(current))) {
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, &buckets, true);
 			__refrigerator(false);
 			continue;
 		}
@@ -345,7 +342,7 @@ static int bch2_copygc_thread(void *arg)
 		if (wait > clock->max_slop) {
 			c->copygc_wait_at = last;
 			c->copygc_wait = last + wait;
-			move_buckets_wait(trans, &ctxt, &buckets, true);
+			move_buckets_wait(&ctxt, &buckets, true);
 			trace_and_count(c, copygc_wait, c, wait, last + wait);
 			bch2_kthread_io_clock_wait(clock, last + wait,
 					MAX_SCHEDULE_TIMEOUT);
@@ -355,15 +352,14 @@ static int bch2_copygc_thread(void *arg)
 		c->copygc_wait = 0;
 
 		c->copygc_running = true;
-		ret = bch2_copygc(trans, &ctxt, &buckets);
+		ret = bch2_copygc(&ctxt, &buckets);
 		c->copygc_running = false;
 
 		wake_up(&c->copygc_running_wq);
 	}
 
-	move_buckets_wait(trans, &ctxt, &buckets, true);
+	move_buckets_wait(&ctxt, &buckets, true);
 	rhashtable_destroy(&buckets.table);
-	bch2_trans_put(trans);
 	bch2_moving_ctxt_exit(&ctxt);
 
 	return 0;
-- 
2.42.0

