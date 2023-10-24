Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AC67C25B6C
	for <linux-bcachefs@archiver.kernel.org>; Tue, 24 Oct 2023 19:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343884AbjJXTOb (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 24 Oct 2023 15:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344223AbjJXTOa (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 24 Oct 2023 15:14:30 -0400
Received: from out-199.mta1.migadu.com (out-199.mta1.migadu.com [IPv6:2001:41d0:203:375::c7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5109010C3
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Oct 2023 12:14:25 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698174863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1BjgAWv8uauZKx+GhGNCyrjJaWjXEh0EK59XRx10oew=;
        b=kzwBtr74dgvxnZ1aHMREk7tbssYOorB4gv21TVgu9/4WgNLgkum+K4jAdUxboJfVDVrGWs
        0FoFNoqkGLXkBELlHutvpiA/YDlgF5XHad5NnZq6mV5Rm484/GC7y2FT6H7wVw8J7eHNpk
        H+aFFbojF+j1v7bwT3FUjBCHHLGTMuE=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/6] bcachefs: move: convert to bbpos
Date:   Tue, 24 Oct 2023 15:14:08 -0400
Message-ID: <20231024191414.2157874-4-kent.overstreet@linux.dev>
In-Reply-To: <20231024191414.2157874-1-kent.overstreet@linux.dev>
References: <20231024191414.2157874-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bbpos.h       | 14 +-------------
 fs/bcachefs/bbpos_types.h | 18 ++++++++++++++++++
 fs/bcachefs/chardev.c     |  4 ++--
 fs/bcachefs/data_update.c |  8 +++++---
 fs/bcachefs/data_update.h |  1 +
 fs/bcachefs/move.c        | 19 ++++++++-----------
 fs/bcachefs/move_types.h  |  5 +++--
 7 files changed, 38 insertions(+), 31 deletions(-)
 create mode 100644 fs/bcachefs/bbpos_types.h

diff --git a/fs/bcachefs/bbpos.h b/fs/bcachefs/bbpos.h
index 0038bc28ba8c..be2edced5213 100644
--- a/fs/bcachefs/bbpos.h
+++ b/fs/bcachefs/bbpos.h
@@ -2,22 +2,10 @@
 #ifndef _BCACHEFS_BBPOS_H
 #define _BCACHEFS_BBPOS_H
 
+#include "bbpos_types.h"
 #include "bkey_methods.h"
 #include "btree_cache.h"
 
-struct bbpos {
-	enum btree_id		btree;
-	struct bpos		pos;
-};
-
-static inline struct bbpos BBPOS(enum btree_id btree, struct bpos pos)
-{
-	return (struct bbpos) { btree, pos };
-}
-
-#define BBPOS_MIN	BBPOS(0, POS_MIN)
-#define BBPOS_MAX	BBPOS(BTREE_ID_NR - 1, POS_MAX)
-
 static inline int bbpos_cmp(struct bbpos l, struct bbpos r)
 {
 	return cmp_int(l.btree, r.btree) ?: bpos_cmp(l.pos, r.pos);
diff --git a/fs/bcachefs/bbpos_types.h b/fs/bcachefs/bbpos_types.h
new file mode 100644
index 000000000000..5198e94cf3b8
--- /dev/null
+++ b/fs/bcachefs/bbpos_types.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_BBPOS_TYPES_H
+#define _BCACHEFS_BBPOS_TYPES_H
+
+struct bbpos {
+	enum btree_id		btree;
+	struct bpos		pos;
+};
+
+static inline struct bbpos BBPOS(enum btree_id btree, struct bpos pos)
+{
+	return (struct bbpos) { btree, pos };
+}
+
+#define BBPOS_MIN	BBPOS(0, POS_MIN)
+#define BBPOS_MAX	BBPOS(BTREE_ID_NR - 1, POS_MAX)
+
+#endif /* _BCACHEFS_BBPOS_TYPES_H */
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index f69e15dc699c..4bb88aefed12 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -332,8 +332,8 @@ static ssize_t bch2_data_job_read(struct file *file, char __user *buf,
 	struct bch_ioctl_data_event e = {
 		.type			= BCH_DATA_EVENT_PROGRESS,
 		.p.data_type		= ctx->stats.data_type,
-		.p.btree_id		= ctx->stats.btree_id,
-		.p.pos			= ctx->stats.pos,
+		.p.btree_id		= ctx->stats.pos.btree,
+		.p.pos			= ctx->stats.pos.pos,
 		.p.sectors_done		= atomic64_read(&ctx->stats.sectors_seen),
 		.p.sectors_total	= bch2_fs_usage_read_short(c).used,
 	};
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 9b42d37dc344..e445c441764c 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -281,11 +281,11 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		}
 		continue;
 nowork:
-		if (m->ctxt && m->ctxt->stats) {
+		if (m->stats && m->stats) {
 			BUG_ON(k.k->p.offset <= iter.pos.offset);
-			atomic64_inc(&m->ctxt->stats->keys_raced);
+			atomic64_inc(&m->stats->keys_raced);
 			atomic64_add(k.k->p.offset - iter.pos.offset,
-				     &m->ctxt->stats->sectors_raced);
+				     &m->stats->sectors_raced);
 		}
 
 		this_cpu_inc(c->counters[BCH_COUNTER_move_extent_fail]);
@@ -439,6 +439,8 @@ int bch2_data_update_init(struct btree_trans *trans,
 	bch2_bkey_buf_reassemble(&m->k, c, k);
 	m->btree_id	= btree_id;
 	m->data_opts	= data_opts;
+	m->ctxt		= ctxt;
+	m->stats	= ctxt->stats;
 
 	bch2_write_op_init(&m->op, c, io_opts);
 	m->op.pos	= bkey_start_pos(k.k);
diff --git a/fs/bcachefs/data_update.h b/fs/bcachefs/data_update.h
index 7ca1f98d7e94..9dc17b9d8379 100644
--- a/fs/bcachefs/data_update.h
+++ b/fs/bcachefs/data_update.h
@@ -23,6 +23,7 @@ struct data_update {
 	struct bkey_buf		k;
 	struct data_update_opts	data_opts;
 	struct moving_context	*ctxt;
+	struct bch_move_stats	*stats;
 	struct bch_write_op	op;
 };
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 570189eda6fd..753755a627d5 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -367,7 +367,6 @@ int bch2_move_extent(struct moving_context *ctxt,
 
 	BUG_ON(ret);
 
-	io->write.ctxt = ctxt;
 	io->write.op.end_io = move_write_done;
 
 	if (ctxt->rate)
@@ -567,8 +566,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 
 	if (ctxt->stats) {
 		ctxt->stats->data_type	= BCH_DATA_user;
-		ctxt->stats->btree_id	= btree_id;
-		ctxt->stats->pos	= start;
+		ctxt->stats->pos	= BBPOS(btree_id, start);
 	}
 
 	bch2_trans_iter_init(trans, &iter, btree_id, start,
@@ -595,7 +593,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 			break;
 
 		if (ctxt->stats)
-			ctxt->stats->pos = iter.pos;
+			ctxt->stats->pos = BBPOS(iter.btree_id, iter.pos);
 
 		if (!bkey_extent_is_direct_data(k.k))
 			goto next_nondata;
@@ -656,7 +654,7 @@ int __bch2_move_data(struct moving_context *ctxt,
 	for (id = start.btree;
 	     id <= min_t(unsigned, end.btree, btree_id_nr_alive(c) - 1);
 	     id++) {
-		ctxt->stats->btree_id = id;
+		ctxt->stats->pos = BBPOS(id, POS_MIN);
 
 		if (!btree_type_has_ptrs(id) ||
 		    !bch2_btree_id_root(c, id)->b)
@@ -894,7 +892,7 @@ static int bch2_move_btree(struct bch_fs *c,
 	for (id = start_btree_id;
 	     id <= min_t(unsigned, end_btree_id, btree_id_nr_alive(c) - 1);
 	     id++) {
-		stats->btree_id = id;
+		stats->pos = BBPOS(id, POS_MIN);
 
 		if (!bch2_btree_id_root(c, id)->b)
 			continue;
@@ -913,7 +911,7 @@ static int bch2_move_btree(struct bch_fs *c,
 			     bpos_cmp(b->key.k.p, end_pos)) > 0)
 				break;
 
-			stats->pos = iter.pos;
+			stats->pos = BBPOS(iter.btree_id, iter.pos);
 
 			if (!pred(c, arg, b, &io_opts, &data_opts))
 				goto next;
@@ -1139,10 +1137,9 @@ static void bch2_moving_ctxt_to_text(struct printbuf *out, struct bch_fs *c, str
 	prt_printf(out, "%s (%ps):", stats->name, ctxt->fn);
 	prt_newline(out);
 
-	prt_printf(out, " data type %s btree_id %s position: ",
-		   bch2_data_types[stats->data_type],
-		   bch2_btree_id_str(stats->btree_id));
-	bch2_bpos_to_text(out, stats->pos);
+	prt_printf(out, " data type %s position: ",
+		   bch2_data_types[stats->data_type]);
+	bch2_bbpos_to_text(out, stats->pos);
 	prt_newline(out);
 	printbuf_indent_add(out, 2);
 
diff --git a/fs/bcachefs/move_types.h b/fs/bcachefs/move_types.h
index baf1f8570b3f..f402aa179bbe 100644
--- a/fs/bcachefs/move_types.h
+++ b/fs/bcachefs/move_types.h
@@ -2,10 +2,11 @@
 #ifndef _BCACHEFS_MOVE_TYPES_H
 #define _BCACHEFS_MOVE_TYPES_H
 
+#include "bbpos_types.h"
+
 struct bch_move_stats {
 	enum bch_data_type	data_type;
-	enum btree_id		btree_id;
-	struct bpos		pos;
+	struct bbpos		pos;
 	struct list_head	list;
 	char			name[32];
 
-- 
2.42.0

