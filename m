Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93D1381C4
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594983; cv=none; b=JIAq6TJtRB/yPhIoVB8Blh0zAKn4ADp4CHV4f5zdfV6Mp+joR6jTYrDaijHL65OcLYhqsKrisdILKCjy12jlpozKhquZagyUZUzYEX1toicX1SlhVhBSVYAnus7INZb8L3bthDdioitcaNfRaxEW6hsEwraLvRLN5MHU5ro0z1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594983; c=relaxed/simple;
	bh=BvfenptQD4o2QwP2bN8i9r85lJHCtkf94BCZsPB3Yc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCZxQU/izj8j26R64AHcybIiPpA8tCo499u+YHgaUrYntZcWZnQwjDPAwKujnwiub3zDqDgKcMVjua73zEMxYZJx7ozb86+MeO8Ol8a5xtI0LHnmQvb2vAqJfrLznGIqab/XT9QJ/PTCFs1q0MEXkikxhLMQVRk/i8tS9mQwYdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kyXVPD4b; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kyXVPD4b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0Jp5aRvkfBbgO4OvFIy3WnujfNjj1dl/dPuMkIn9KMU=;
	b=kyXVPD4bGLo5xBHzKKARxNw/nv7l9llupTT4xewW2cQW4Nu4darmk/61c/qmkNU5E6yKkw
	varf6KIveCwTsCHa4N6RhsStVB510/eI5eWnym0vjgw8VL+j35W7s6rwV8p2VfxVRP7Uoh
	g+BB6Hcbu9KCIhdlpO0qQaNUhks1lvQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/11] bcachefs: bch2_move_data_phys()
Date: Mon, 30 Dec 2024 16:42:42 -0500
Message-ID: <20241230214249.242966-4-kent.overstreet@linux.dev>
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

Add a more general version of bch2_evacuate_bucket - to be used for
scrub.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/chardev.c    |   4 +-
 fs/bcachefs/move.c       | 115 +++++++++++++++++++++++++++------------
 fs/bcachefs/move_types.h |  15 ++++-
 fs/bcachefs/trace.h      |  52 ------------------
 4 files changed, 94 insertions(+), 92 deletions(-)

diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index 46e9e32105a9..f374a3988622 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -312,7 +312,7 @@ static int bch2_data_thread(void *arg)
 	struct bch_data_ctx *ctx = container_of(arg, struct bch_data_ctx, thr);
 
 	ctx->thr.ret = bch2_data_job(ctx->c, &ctx->stats, ctx->arg);
-	ctx->stats.data_type = U8_MAX;
+	ctx->stats.done = true;
 	return 0;
 }
 
@@ -332,7 +332,7 @@ static ssize_t bch2_data_job_read(struct file *file, char __user *buf,
 	struct bch_fs *c = ctx->c;
 	struct bch_ioctl_data_event e = {
 		.type			= BCH_DATA_EVENT_PROGRESS,
-		.p.data_type		= ctx->stats.data_type,
+		.p.data_type		= ctx->stats.done ? U8_MAX : ctx->stats.data_type,
 		.p.btree_id		= ctx->stats.pos.btree,
 		.p.pos			= ctx->stats.pos.pos,
 		.p.sectors_done		= atomic64_read(&ctx->stats.sectors_seen),
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index c493ea625553..b524827ae841 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -689,21 +689,21 @@ int bch2_move_data(struct bch_fs *c,
 		   bool wait_on_copygc,
 		   move_pred_fn pred, void *arg)
 {
-
 	struct moving_context ctxt;
-	int ret;
 
 	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
-	ret = __bch2_move_data(&ctxt, start, end, pred, arg);
+	int ret = __bch2_move_data(&ctxt, start, end, pred, arg);
 	bch2_moving_ctxt_exit(&ctxt);
 
 	return ret;
 }
 
-int bch2_evacuate_bucket(struct moving_context *ctxt,
-			   struct move_bucket_in_flight *bucket_in_flight,
-			   struct bpos bucket, int gen,
-			   struct data_update_opts _data_opts)
+static int __bch2_move_data_phys(struct moving_context *ctxt,
+			struct move_bucket_in_flight *bucket_in_flight,
+			unsigned dev,
+			u64 bucket_start,
+			u64 bucket_end,
+			move_pred_fn pred, void *arg)
 {
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
@@ -712,16 +712,22 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	struct btree_iter iter = {}, bp_iter = {};
 	struct bkey_buf sk;
 	struct bkey_s_c k;
-	struct data_update_opts data_opts;
 	unsigned sectors_moved = 0;
 	struct bkey_buf last_flushed;
 	int ret = 0;
 
-	struct bch_dev *ca = bch2_dev_tryget(c, bucket.inode);
+	struct bch_dev *ca = bch2_dev_tryget(c, dev);
 	if (!ca)
 		return 0;
 
-	trace_bucket_evacuate(c, &bucket);
+	bucket_end = min(bucket_end, ca->mi.nbuckets);
+
+	struct bpos bp_start	= bucket_pos_to_bp_start(ca, POS(dev, bucket_start));
+	struct bpos bp_end	= bucket_pos_to_bp_end(ca, POS(dev, bucket_end));
+	bch2_dev_put(ca);
+	ca = NULL;
+
+	//trace_bucket_evacuate(c, &bucket);
 
 	bch2_bkey_buf_init(&last_flushed);
 	bkey_init(&last_flushed.k->k);
@@ -732,8 +738,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	 */
 	bch2_trans_begin(trans);
 
-	bch2_trans_iter_init(trans, &bp_iter, BTREE_ID_backpointers,
-			     bucket_pos_to_bp_start(ca, bucket), 0);
+	bch2_trans_iter_init(trans, &bp_iter, BTREE_ID_backpointers, bp_start, 0);
 
 	bch_err_msg(c, ret, "looking up alloc key");
 	if (ret)
@@ -757,7 +762,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		if (ret)
 			goto err;
 
-		if (!k.k || bkey_gt(k.k->p, bucket_pos_to_bp_end(ca, bucket)))
+		if (!k.k || bkey_gt(k.k->p, bp_end))
 			break;
 
 		if (k.k->type != KEY_TYPE_backpointer)
@@ -765,6 +770,10 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 
 		struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 
+		if (ctxt->stats)
+			ctxt->stats->offset =
+				bp.k->p.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT;
+
 		if (!bp.v->level) {
 			k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
 			ret = bkey_err(k);
@@ -775,34 +784,22 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 			if (!k.k)
 				goto next;
 
-			bch2_bkey_buf_reassemble(&sk, c, k);
-			k = bkey_i_to_s_c(sk.k);
-
 			ret = bch2_move_get_io_opts_one(trans, &io_opts, &iter, k);
 			if (ret) {
 				bch2_trans_iter_exit(trans, &iter);
 				continue;
 			}
 
-			data_opts = _data_opts;
-			data_opts.target	= io_opts.background_target;
-			data_opts.rewrite_ptrs = 0;
+			struct data_update_opts data_opts = {};
+			if (!pred(c, arg, k, &io_opts, &data_opts)) {
+				bch2_trans_iter_exit(trans, &iter);
+				goto next;
+			}
+
+			bch2_bkey_buf_reassemble(&sk, c, k);
+			k = bkey_i_to_s_c(sk.k);
 
 			unsigned sectors = bp.v->bucket_len; /* move_extent will drop locks */
-			unsigned i = 0;
-			const union bch_extent_entry *entry;
-			struct extent_ptr_decoded p;
-			bkey_for_each_ptr_decode(k.k, bch2_bkey_ptrs_c(k), p, entry) {
-				if (p.ptr.dev == bucket.inode) {
-					if (p.ptr.cached) {
-						bch2_trans_iter_exit(trans, &iter);
-						goto next;
-					}
-					data_opts.rewrite_ptrs |= 1U << i;
-					break;
-				}
-				i++;
-			}
 
 			ret = bch2_move_extent(ctxt, bucket_in_flight,
 					       &iter, k, io_opts, data_opts);
@@ -835,6 +832,12 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 			if (!b)
 				goto next;
 
+			struct data_update_opts data_opts = {};
+			if (!pred(c, arg, bkey_i_to_s_c(&b->key), &io_opts, &data_opts)) {
+				bch2_trans_iter_exit(trans, &iter);
+				goto next;
+			}
+
 			unsigned sectors = btree_ptr_sectors_written(bkey_i_to_s_c(&b->key));
 
 			ret = bch2_btree_node_rewrite(trans, &iter, b, 0);
@@ -851,21 +854,58 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 				atomic64_add(sectors, &ctxt->stats->sectors_seen);
 				atomic64_add(sectors, &ctxt->stats->sectors_moved);
 			}
-			sectors_moved += btree_sectors(c);
+			sectors_moved += sectors;
 		}
 next:
 		bch2_btree_iter_advance(&bp_iter);
 	}
 
-	trace_evacuate_bucket(c, &bucket, sectors_moved, ca->mi.bucket_size, ret);
+	//trace_evacuate_bucket(c, &bucket, sectors_moved, ca->mi.bucket_size, ret);
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
-	bch2_dev_put(ca);
 	bch2_bkey_buf_exit(&sk, c);
 	bch2_bkey_buf_exit(&last_flushed, c);
 	return ret;
 }
 
+struct evacuate_bucket_arg {
+	struct bpos		bucket;
+	int			gen;
+	struct data_update_opts	data_opts;
+};
+
+static bool evacuate_bucket_pred(struct bch_fs *c, void *_arg, struct bkey_s_c k,
+				 struct bch_io_opts *io_opts,
+				 struct data_update_opts *data_opts)
+{
+	struct evacuate_bucket_arg *arg = _arg;
+
+	*data_opts = arg->data_opts;
+
+	unsigned i = 0;
+	bkey_for_each_ptr(bch2_bkey_ptrs_c(k), ptr) {
+		if (ptr->dev == arg->bucket.inode && !ptr->cached)
+			data_opts->rewrite_ptrs |= BIT(i);
+		i++;
+	}
+
+	return data_opts->rewrite_ptrs != 0;
+}
+
+int bch2_evacuate_bucket(struct moving_context *ctxt,
+			   struct move_bucket_in_flight *bucket_in_flight,
+			   struct bpos bucket, int gen,
+			   struct data_update_opts data_opts)
+{
+	struct evacuate_bucket_arg arg = { bucket, gen, data_opts, };
+
+	return __bch2_move_data_phys(ctxt, bucket_in_flight,
+				   bucket.inode,
+				   bucket.offset,
+				   bucket.offset + 1,
+				   evacuate_bucket_pred, &arg);
+}
+
 typedef bool (*move_btree_pred)(struct bch_fs *, void *,
 				struct btree *, struct bch_io_opts *,
 				struct data_update_opts *);
@@ -1118,6 +1158,9 @@ int bch2_data_job(struct bch_fs *c,
 	bch2_move_stats_init(stats, bch2_data_ops_strs[op.op]);
 
 	switch (op.op) {
+	case BCH_DATA_OP_scrub:
+		break;
+
 	case BCH_DATA_OP_rereplicate:
 		stats->data_type = BCH_DATA_journal;
 		ret = bch2_journal_flush_device_pins(&c->journal, -1);
diff --git a/fs/bcachefs/move_types.h b/fs/bcachefs/move_types.h
index e22841ef31e4..15d1f7f3d1dc 100644
--- a/fs/bcachefs/move_types.h
+++ b/fs/bcachefs/move_types.h
@@ -5,9 +5,20 @@
 #include "bbpos_types.h"
 
 struct bch_move_stats {
-	enum bch_data_type	data_type;
-	struct bbpos		pos;
 	char			name[32];
+	bool			phys;
+	bool			done;
+
+	union {
+	struct {
+		enum bch_data_type	data_type;
+		struct bbpos		pos;
+	};
+	struct {
+		unsigned		dev;
+		u64			offset;
+	};
+	};
 
 	atomic64_t		keys_moved;
 	atomic64_t		keys_raced;
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 9d40b7d4ea29..e4c7dc0e8bf9 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -785,27 +785,6 @@ TRACE_EVENT(bucket_invalidate,
 
 /* Moving IO */
 
-TRACE_EVENT(bucket_evacuate,
-	TP_PROTO(struct bch_fs *c, struct bpos *bucket),
-	TP_ARGS(c, bucket),
-
-	TP_STRUCT__entry(
-		__field(dev_t,		dev			)
-		__field(u32,		dev_idx			)
-		__field(u64,		bucket			)
-	),
-
-	TP_fast_assign(
-		__entry->dev		= c->dev;
-		__entry->dev_idx	= bucket->inode;
-		__entry->bucket		= bucket->offset;
-	),
-
-	TP_printk("%d:%d %u:%llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->dev_idx, __entry->bucket)
-);
-
 DEFINE_EVENT(fs_str, move_extent,
 	TP_PROTO(struct bch_fs *c, const char *str),
 	TP_ARGS(c, str)
@@ -869,37 +848,6 @@ TRACE_EVENT(move_data,
 		  __entry->sectors_raced)
 );
 
-TRACE_EVENT(evacuate_bucket,
-	TP_PROTO(struct bch_fs *c, struct bpos *bucket,
-		 unsigned sectors, unsigned bucket_size,
-		 int ret),
-	TP_ARGS(c, bucket, sectors, bucket_size, ret),
-
-	TP_STRUCT__entry(
-		__field(dev_t,		dev		)
-		__field(u64,		member		)
-		__field(u64,		bucket		)
-		__field(u32,		sectors		)
-		__field(u32,		bucket_size	)
-		__field(int,		ret		)
-	),
-
-	TP_fast_assign(
-		__entry->dev			= c->dev;
-		__entry->member			= bucket->inode;
-		__entry->bucket			= bucket->offset;
-		__entry->sectors		= sectors;
-		__entry->bucket_size		= bucket_size;
-		__entry->ret			= ret;
-	),
-
-	TP_printk("%d,%d %llu:%llu sectors %u/%u ret %i",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->member, __entry->bucket,
-		  __entry->sectors, __entry->bucket_size,
-		  __entry->ret)
-);
-
 TRACE_EVENT(copygc,
 	TP_PROTO(struct bch_fs *c,
 		 u64 sectors_moved, u64 sectors_not_moved,
-- 
2.45.2

