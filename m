Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69EC2C07545
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbjJXTO3 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343884AbjJXTO2 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:28 -0400
Received: from out-201.mta1.migadu.com (out-201.mta1.migadu.com [95.215.58.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C439F10D4
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3bArN59AmbGpy0xHN6nRDE4A3nmSZIHs15pOZKVuNE=;
        b=FetQfkgpsrN0kdFnj0kcyr1cdvmxFBb63PtyTpkN3/lzBvgRLQkrxYxI9b9ey0FK7W6RLP
        Q8oTBMg2w4abrT/Uy7ni9kWWRjQl9tIp+hNkw3FHgoeKHEm0d3M8W4VSvS4wkykIpkqVCa
        tcfUpbsOj2xy3zzWnSYulSp5gCDMdHA=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/6] bcachefs: move: move_stats refactoring
Date:   Tue, 24 Oct 2023 15:14:09 -0400
Message-ID: <20231024191414.2157874-5-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

data_progress_list is gone - it was redundant with moving_context_list

The upcoming rebalance rewrite is going to have it using two different
move_stats objects with the same moving_context, depending on whether
it's scanning or using the rebalance_work btree - this patch plumbs
stats around a bit differently so that will work.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h    |  3 --
 fs/bcachefs/data_update.c |  2 +-
 fs/bcachefs/move.c        | 98 +++++++++++++++++++++------------------
 fs/bcachefs/move.h        |  5 +-
 fs/bcachefs/move_types.h  |  3 +-
 fs/bcachefs/movinggc.c    |  1 +
 fs/bcachefs/trace.c       |  1 +
 fs/bcachefs/trace.h       | 31 +++++++++----
 8 files changed, 82 insertions(+), 62 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 1e0191197de1..bff6324447e1 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -939,9 +939,6 @@ struct bch_fs {
 	struct list_head	moving_context_list;
 	struct mutex		moving_context_lock;
 
-	struct list_head	data_progress_list;
-	struct mutex		data_progress_lock;
-
 	/* REBALANCE */
 	struct bch_fs_rebalance	rebalance;
 
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index e445c441764c..4860f8293a4f 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -440,7 +440,7 @@ int bch2_data_update_init(struct btree_trans *trans,
 	m->btree_id	= btree_id;
 	m->data_opts	= data_opts;
 	m->ctxt		= ctxt;
-	m->stats	= ctxt->stats;
+	m->stats	= ctxt ? ctxt->stats : NULL;
 
 	bch2_write_op_init(&m->op, c, io_opts);
 	m->op.pos	= bkey_start_pos(k.k);
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 753755a627d5..1b15b010461a 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -60,20 +60,6 @@ static void trace_move_extent_alloc_mem_fail2(struct bch_fs *c, struct bkey_s_c
 	}
 }
 
-static void progress_list_add(struct bch_fs *c, struct bch_move_stats *stats)
-{
-	mutex_lock(&c->data_progress_lock);
-	list_add(&stats->list, &c->data_progress_list);
-	mutex_unlock(&c->data_progress_lock);
-}
-
-static void progress_list_del(struct bch_fs *c, struct bch_move_stats *stats)
-{
-	mutex_lock(&c->data_progress_lock);
-	list_del(&stats->list);
-	mutex_unlock(&c->data_progress_lock);
-}
-
 struct moving_io {
 	struct list_head		read_list;
 	struct list_head		io_list;
@@ -190,13 +176,6 @@ void bch2_moving_ctxt_exit(struct moving_context *ctxt)
 	EBUG_ON(atomic_read(&ctxt->read_sectors));
 	EBUG_ON(atomic_read(&ctxt->read_ios));
 
-	if (ctxt->stats) {
-		progress_list_del(c, ctxt->stats);
-		trace_move_data(c,
-				atomic64_read(&ctxt->stats->sectors_moved),
-				atomic64_read(&ctxt->stats->keys_moved));
-	}
-
 	mutex_lock(&c->moving_context_lock);
 	list_del(&ctxt->list);
 	mutex_unlock(&c->moving_context_lock);
@@ -231,16 +210,17 @@ void bch2_moving_ctxt_init(struct moving_context *ctxt,
 	mutex_lock(&c->moving_context_lock);
 	list_add(&ctxt->list, &c->moving_context_list);
 	mutex_unlock(&c->moving_context_lock);
+}
 
-	if (stats) {
-		progress_list_add(c, stats);
-		stats->data_type = BCH_DATA_user;
-	}
+void bch2_move_stats_exit(struct bch_move_stats *stats, struct bch_fs *c)
+{
+	trace_move_data(c, stats);
 }
 
 void bch2_move_stats_init(struct bch_move_stats *stats, char *name)
 {
 	memset(stats, 0, sizeof(*stats));
+	stats->data_type = BCH_DATA_user;
 	scnprintf(stats->name, sizeof(stats->name), "%s", name);
 }
 
@@ -303,6 +283,8 @@ int bch2_move_extent(struct moving_context *ctxt,
 	unsigned sectors = k.k->size, pages;
 	int ret = -ENOMEM;
 
+	if (ctxt->stats)
+		ctxt->stats->pos = BBPOS(iter->btree_id, iter->pos);
 	trace_move_extent2(c, k);
 
 	bch2_data_update_opts_normalize(k, &data_opts);
@@ -878,14 +860,18 @@ static int bch2_move_btree(struct bch_fs *c,
 {
 	bool kthread = (current->flags & PF_KTHREAD) != 0;
 	struct bch_io_opts io_opts = bch2_opts_to_inode_opts(c->opts);
-	struct btree_trans *trans = bch2_trans_get(c);
+	struct moving_context ctxt;
+	struct btree_trans *trans;
 	struct btree_iter iter;
 	struct btree *b;
 	enum btree_id id;
 	struct data_update_opts data_opts;
 	int ret = 0;
 
-	progress_list_add(c, stats);
+	bch2_moving_ctxt_init(&ctxt, c, NULL, stats,
+			      writepoint_ptr(&c->btree_write_point),
+			      true);
+	trans = ctxt.trans;
 
 	stats->data_type = BCH_DATA_btree;
 
@@ -933,14 +919,10 @@ static int bch2_move_btree(struct bch_fs *c,
 			break;
 	}
 
-	bch2_trans_put(trans);
-
-	if (ret)
-		bch_err_fn(c, ret);
-
+	bch_err_fn(c, ret);
+	bch2_moving_ctxt_exit(&ctxt);
 	bch2_btree_interior_updates_flush(c);
 
-	progress_list_del(c, stats);
 	return ret;
 }
 
@@ -1061,8 +1043,7 @@ int bch2_scan_old_btree_nodes(struct bch_fs *c, struct bch_move_stats *stats)
 		mutex_unlock(&c->sb_lock);
 	}
 
-	if (ret)
-		bch_err_fn(c, ret);
+	bch_err_fn(c, ret);
 	return ret;
 }
 
@@ -1093,6 +1074,8 @@ int bch2_data_job(struct bch_fs *c,
 				     true,
 				     rereplicate_pred, c) ?: ret;
 		ret = bch2_replicas_gc2(c) ?: ret;
+
+		bch2_move_stats_exit(stats, c);
 		break;
 	case BCH_DATA_OP_MIGRATE:
 		if (op.migrate.dev >= c->sb.nr_devices)
@@ -1117,10 +1100,13 @@ int bch2_data_job(struct bch_fs *c,
 				     true,
 				     migrate_pred, &op) ?: ret;
 		ret = bch2_replicas_gc2(c) ?: ret;
+
+		bch2_move_stats_exit(stats, c);
 		break;
 	case BCH_DATA_OP_REWRITE_OLD_NODES:
 		bch2_move_stats_init(stats, "rewrite_old_nodes");
 		ret = bch2_scan_old_btree_nodes(c, stats);
+		bch2_move_stats_exit(stats, c);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1129,18 +1115,43 @@ int bch2_data_job(struct bch_fs *c,
 	return ret;
 }
 
-static void bch2_moving_ctxt_to_text(struct printbuf *out, struct bch_fs *c, struct moving_context *ctxt)
+void bch2_move_stats_to_text(struct printbuf *out, struct bch_move_stats *stats)
 {
-	struct bch_move_stats *stats = ctxt->stats;
-	struct moving_io *io;
+	prt_printf(out, "%s: data type=%s pos=",
+		   stats->name,
+		   bch2_data_types[stats->data_type]);
+	bch2_bbpos_to_text(out, stats->pos);
+	prt_newline(out);
+	printbuf_indent_add(out, 2);
 
-	prt_printf(out, "%s (%ps):", stats->name, ctxt->fn);
+	prt_str(out, "keys moved:  ");
+	prt_u64(out, atomic64_read(&stats->keys_moved));
 	prt_newline(out);
 
-	prt_printf(out, " data type %s position: ",
-		   bch2_data_types[stats->data_type]);
-	bch2_bbpos_to_text(out, stats->pos);
+	prt_str(out, "keys raced:  ");
+	prt_u64(out, atomic64_read(&stats->keys_raced));
+	prt_newline(out);
+
+	prt_str(out, "bytes seen:  ");
+	prt_human_readable_u64(out, atomic64_read(&stats->sectors_seen) << 9);
+	prt_newline(out);
+
+	prt_str(out, "bytes moved: ");
+	prt_human_readable_u64(out, atomic64_read(&stats->sectors_moved) << 9);
 	prt_newline(out);
+
+	prt_str(out, "bytes raced: ");
+	prt_human_readable_u64(out, atomic64_read(&stats->sectors_raced) << 9);
+	prt_newline(out);
+
+	printbuf_indent_sub(out, 2);
+}
+
+static void bch2_moving_ctxt_to_text(struct printbuf *out, struct bch_fs *c, struct moving_context *ctxt)
+{
+	struct moving_io *io;
+
+	bch2_move_stats_to_text(out, ctxt->stats);
 	printbuf_indent_add(out, 2);
 
 	prt_printf(out, "reads: ios %u/%u sectors %u/%u",
@@ -1181,7 +1192,4 @@ void bch2_fs_move_init(struct bch_fs *c)
 {
 	INIT_LIST_HEAD(&c->moving_context_list);
 	mutex_init(&c->moving_context_lock);
-
-	INIT_LIST_HEAD(&c->data_progress_list);
-	mutex_init(&c->data_progress_lock);
 }
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 39e762b103ca..1b1e8678bfae 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -127,7 +127,10 @@ int bch2_data_job(struct bch_fs *,
 		  struct bch_move_stats *,
 		  struct bch_ioctl_data);
 
-void bch2_move_stats_init(struct bch_move_stats *stats, char *name);
+void bch2_move_stats_to_text(struct printbuf *, struct bch_move_stats *);
+void bch2_move_stats_exit(struct bch_move_stats *, struct bch_fs *);
+void bch2_move_stats_init(struct bch_move_stats *, char *);
+
 void bch2_fs_moving_ctxts_to_text(struct printbuf *, struct bch_fs *);
 
 void bch2_fs_move_init(struct bch_fs *);
diff --git a/fs/bcachefs/move_types.h b/fs/bcachefs/move_types.h
index f402aa179bbe..e22841ef31e4 100644
--- a/fs/bcachefs/move_types.h
+++ b/fs/bcachefs/move_types.h
@@ -7,13 +7,12 @@
 struct bch_move_stats {
 	enum bch_data_type	data_type;
 	struct bbpos		pos;
-	struct list_head	list;
 	char			name[32];
 
 	atomic64_t		keys_moved;
 	atomic64_t		keys_raced;
-	atomic64_t		sectors_moved;
 	atomic64_t		sectors_seen;
+	atomic64_t		sectors_moved;
 	atomic64_t		sectors_raced;
 };
 
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index a2862e322658..f73b9b7f4bf7 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -361,6 +361,7 @@ static int bch2_copygc_thread(void *arg)
 	move_buckets_wait(&ctxt, &buckets, true);
 	rhashtable_destroy(&buckets.table);
 	bch2_moving_ctxt_exit(&ctxt);
+	bch2_move_stats_exit(&move_stats, c);
 
 	return 0;
 }
diff --git a/fs/bcachefs/trace.c b/fs/bcachefs/trace.c
index 33efa6005c6f..dc48b52b01b4 100644
--- a/fs/bcachefs/trace.c
+++ b/fs/bcachefs/trace.c
@@ -7,6 +7,7 @@
 #include "btree_locking.h"
 #include "btree_update_interior.h"
 #include "keylist.h"
+#include "move_types.h"
 #include "opts.h"
 #include "six.h"
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 2308f49f3b2e..81f72b2add09 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -767,25 +767,36 @@ DEFINE_EVENT(bkey, move_extent_alloc_mem_fail,
 );
 
 TRACE_EVENT(move_data,
-	TP_PROTO(struct bch_fs *c, u64 sectors_moved,
-		 u64 keys_moved),
-	TP_ARGS(c, sectors_moved, keys_moved),
+	TP_PROTO(struct bch_fs *c,
+		 struct bch_move_stats *stats),
+	TP_ARGS(c, stats),
 
 	TP_STRUCT__entry(
-		__field(dev_t,		dev			)
-		__field(u64,		sectors_moved	)
+		__field(dev_t,		dev		)
 		__field(u64,		keys_moved	)
+		__field(u64,		keys_raced	)
+		__field(u64,		sectors_seen	)
+		__field(u64,		sectors_moved	)
+		__field(u64,		sectors_raced	)
 	),
 
 	TP_fast_assign(
-		__entry->dev			= c->dev;
-		__entry->sectors_moved = sectors_moved;
-		__entry->keys_moved = keys_moved;
+		__entry->dev		= c->dev;
+		__entry->keys_moved	= atomic64_read(&stats->keys_moved);
+		__entry->keys_raced	= atomic64_read(&stats->keys_raced);
+		__entry->sectors_seen	= atomic64_read(&stats->sectors_seen);
+		__entry->sectors_moved	= atomic64_read(&stats->sectors_moved);
+		__entry->sectors_raced	= atomic64_read(&stats->sectors_raced);
 	),
 
-	TP_printk("%d,%d sectors_moved %llu keys_moved %llu",
+	TP_printk("%d,%d keys moved %llu raced %llu"
+		  "sectors seen %llu moved %llu raced %llu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->sectors_moved, __entry->keys_moved)
+		  __entry->keys_moved,
+		  __entry->keys_raced,
+		  __entry->sectors_seen,
+		  __entry->sectors_moved,
+		  __entry->sectors_raced)
 );
 
 TRACE_EVENT(evacuate_bucket,
-- 
2.42.0

