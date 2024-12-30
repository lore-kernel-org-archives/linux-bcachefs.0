Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9645319B3CB
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594988; cv=none; b=cL9/jPDWuP2MlNYmRO1GrNwtBneoxA5e1YB0z8gTIrv5SQlU5oqG0EQ4f3/ZBFpmvG9hA6wEHwjqjTQ2h71OQwyQQZ6T33fPIM+yk45EvvT0+ObJQxl4Gy2qYdxE0dPR7UrG0Vt0SZ3nQmwP3yMY/pz2AiIrGuEHnXZbSDKRdoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594988; c=relaxed/simple;
	bh=fLPRSZT3IfChxlQHrEcPm29996yCvDmiA9/H1ZkD5os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7ErMzkKKKspo6KCUWwq6Yv/YQwY7jJ4fcHnxr1vREaKtCuDh+Xj2cCmH7n4m9ruetIF+ixeAIITorfOfVEOjsLV9u1MfXcFcPU4tgN6K7bjXKeNDydS5PlZmRzRiOwGshaJ0N8Hakbe8ucWgOGjOgaupM72qgNbxV3pzSZWG20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bg6tHqsg; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bg6tHqsg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WuN4X6i9tk82KBrUsrBUhlddBLEr2m1Bnou7+DY7VKo=;
	b=bg6tHqsgtQZmHBHSyZSoUVxlTHroVxrs9mi2Ki7KcQtHeFW8Q50dS7rxjUPq2ikYv2HqYI
	jWZorepWMGLDNijIYe83skKuWpltAIJ7oxwbATSpzq6hRgGa7egvu9p5EjnHV5IUei1BO6
	hA8Ayx1Nzc8oroxat/O4Wg+58miC1fM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/11] bcachefs: Scrub
Date: Mon, 30 Dec 2024 16:42:49 -0500
Message-ID: <20241230214249.242966-11-kent.overstreet@linux.dev>
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

Add a new data op to walk all data and metadata in a filesystem,
checking if it can be read successfully, and on error repairing from
another copy if possible.

- New helper: bch2_dev_idx_is_online(), so that we can bail out and
  report to userspace when we're unable to scrub because the device is
  offline

- data_update_opts, which controls the data move path, now understands
  scrub: data is only read, not written. The read path is responsible
  for rewriting on read error, as with other reads.

- scrub_pred skips data extents that don't have checksums

- bch_ioctl_data has a new scrub member, which has a data_types field
  for data types to check - i.e. all data types, or only metadata.

- Add new entries to bch_move_stats so that we can report numbers for
  corrected and uncorrected errors

- Add a new enum to bch_ioctl_data_event for explicitly reporting
  completion and return code (i.e. device offline)

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_ioctl.h |  14 +++-
 fs/bcachefs/chardev.c        |  33 +++++++--
 fs/bcachefs/data_update.h    |   3 +
 fs/bcachefs/io_read.c        |   1 +
 fs/bcachefs/io_read.h        |   1 +
 fs/bcachefs/move.c           | 127 ++++++++++++++++++++++++++++++-----
 fs/bcachefs/move_types.h     |   5 +-
 fs/bcachefs/sb-members.h     |  12 ++++
 8 files changed, 169 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/bcachefs_ioctl.h b/fs/bcachefs/bcachefs_ioctl.h
index 3c23bdf788ce..f176f1928725 100644
--- a/fs/bcachefs/bcachefs_ioctl.h
+++ b/fs/bcachefs/bcachefs_ioctl.h
@@ -213,6 +213,10 @@ struct bch_ioctl_data {
 	struct bpos		end_pos;
 
 	union {
+	struct {
+		__u32		dev;
+		__u32		data_types;
+	}			scrub;
 	struct {
 		__u32		dev;
 		__u32		pad;
@@ -237,11 +241,19 @@ struct bch_ioctl_data_progress {
 
 	__u64			sectors_done;
 	__u64			sectors_total;
+	__u64			sectors_error_corrected;
+	__u64			sectors_error_uncorrected;
 } __packed __aligned(8);
 
+enum bch_ioctl_data_event_ret {
+	BCH_IOCTL_DATA_EVENT_RET_done		= 1,
+	BCH_IOCTL_DATA_EVENT_RET_device_offline	= 2,
+};
+
 struct bch_ioctl_data_event {
 	__u8			type;
-	__u8			pad[7];
+	__u8			ret;
+	__u8			pad[6];
 	union {
 	struct bch_ioctl_data_progress p;
 	__u64			pad2[15];
diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
index f374a3988622..0eb320747a9e 100644
--- a/fs/bcachefs/chardev.c
+++ b/fs/bcachefs/chardev.c
@@ -312,7 +312,10 @@ static int bch2_data_thread(void *arg)
 	struct bch_data_ctx *ctx = container_of(arg, struct bch_data_ctx, thr);
 
 	ctx->thr.ret = bch2_data_job(ctx->c, &ctx->stats, ctx->arg);
-	ctx->stats.done = true;
+	if (ctx->thr.ret == -BCH_ERR_device_offline)
+		ctx->stats.ret = BCH_IOCTL_DATA_EVENT_RET_device_offline;
+	else
+		ctx->stats.ret = BCH_IOCTL_DATA_EVENT_RET_done;
 	return 0;
 }
 
@@ -331,14 +334,30 @@ static ssize_t bch2_data_job_read(struct file *file, char __user *buf,
 	struct bch_data_ctx *ctx = container_of(file->private_data, struct bch_data_ctx, thr);
 	struct bch_fs *c = ctx->c;
 	struct bch_ioctl_data_event e = {
-		.type			= BCH_DATA_EVENT_PROGRESS,
-		.p.data_type		= ctx->stats.done ? U8_MAX : ctx->stats.data_type,
-		.p.btree_id		= ctx->stats.pos.btree,
-		.p.pos			= ctx->stats.pos.pos,
-		.p.sectors_done		= atomic64_read(&ctx->stats.sectors_seen),
-		.p.sectors_total	= bch2_fs_usage_read_short(c).used,
+		.type				= BCH_DATA_EVENT_PROGRESS,
+		.ret				= ctx->stats.ret,
+		.p.data_type			= ctx->stats.data_type,
+		.p.btree_id			= ctx->stats.pos.btree,
+		.p.pos				= ctx->stats.pos.pos,
+		.p.sectors_done			= atomic64_read(&ctx->stats.sectors_seen),
+		.p.sectors_error_corrected	= atomic64_read(&ctx->stats.sectors_error_corrected),
+		.p.sectors_error_uncorrected	= atomic64_read(&ctx->stats.sectors_error_uncorrected),
 	};
 
+	if (ctx->arg.op == BCH_DATA_OP_scrub) {
+		struct bch_dev *ca = bch2_dev_tryget(c, ctx->arg.scrub.dev);
+		if (ca) {
+			struct bch_dev_usage u;
+			bch2_dev_usage_read_fast(ca, &u);
+			for (unsigned i = BCH_DATA_btree; i < ARRAY_SIZE(u.d); i++)
+				if (ctx->arg.scrub.data_types & BIT(i))
+					e.p.sectors_total += u.d[i].sectors;
+			bch2_dev_put(ca);
+		}
+	} else {
+		e.p.sectors_total	= bch2_fs_usage_read_short(c).used;
+	}
+
 	if (len < sizeof(e))
 		return -EINVAL;
 
diff --git a/fs/bcachefs/data_update.h b/fs/bcachefs/data_update.h
index e4b50723428e..144b935ca7ae 100644
--- a/fs/bcachefs/data_update.h
+++ b/fs/bcachefs/data_update.h
@@ -15,6 +15,9 @@ struct data_update_opts {
 	u8		extra_replicas;
 	unsigned	btree_insert_flags;
 	unsigned	write_flags;
+
+	int		read_dev;
+	bool		scrub;
 };
 
 void bch2_data_update_opts_to_text(struct printbuf *, struct bch_fs *,
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index e13766a73300..87fe59977e48 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -499,6 +499,7 @@ static void bch2_rbio_error(struct bch_read_bio *rbio, int retry,
 			    blk_status_t error)
 {
 	rbio->retry = retry;
+	rbio->saw_error = true;
 
 	if (rbio->flags & BCH_READ_IN_RETRY)
 		return;
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index ce94a71394f2..b62fcee760e1 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -41,6 +41,7 @@ struct bch_read_bio {
 				have_ioref:1,
 				narrow_crcs:1,
 				hole:1,
+				saw_error:1,
 				retry:2,
 				context:2;
 	};
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index e257963c244b..cc85249230a2 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -114,7 +114,20 @@ static void move_write_done(struct bch_write_op *op)
 
 static void move_write(struct moving_io *io)
 {
-	if (unlikely(io->rbio.bio.bi_status || io->rbio.hole)) {
+	struct moving_context *ctxt = io->write.ctxt;
+
+	if (ctxt->stats) {
+		if (io->rbio.bio.bi_status)
+			atomic64_add(io->rbio.bvec_iter.bi_size >> 9,
+				     &ctxt->stats->sectors_error_uncorrected);
+		else if (io->rbio.saw_error)
+			atomic64_add(io->rbio.bvec_iter.bi_size >> 9,
+				     &ctxt->stats->sectors_error_corrected);
+	}
+
+	if (unlikely(io->rbio.bio.bi_status ||
+		     io->rbio.hole ||
+		     io->write.data_opts.scrub)) {
 		move_free(io);
 		return;
 	}
@@ -273,7 +286,8 @@ int bch2_move_extent(struct moving_context *ctxt,
 	bch2_data_update_opts_normalize(k, &data_opts);
 
 	if (!data_opts.rewrite_ptrs &&
-	    !data_opts.extra_replicas) {
+	    !data_opts.extra_replicas &&
+	    !data_opts.scrub) {
 		if (data_opts.kill_ptrs)
 			return bch2_extent_drop_ptrs(trans, iter, k, &io_opts, &data_opts);
 		return 0;
@@ -319,12 +333,18 @@ int bch2_move_extent(struct moving_context *ctxt,
 	io->rbio.bio.bi_iter.bi_sector	= bkey_start_offset(k.k);
 	io->rbio.bio.bi_end_io		= move_read_endio;
 
-	ret = bch2_data_update_init(trans, iter, ctxt, &io->write, ctxt->wp,
-				    io_opts, data_opts, iter->btree_id, k);
-	if (ret)
-		goto err_free_pages;
+	if (!data_opts.scrub) {
+		ret = bch2_data_update_init(trans, iter, ctxt, &io->write, ctxt->wp,
+					    io_opts, data_opts, iter->btree_id, k);
+		if (ret)
+			goto err_free_pages;
 
-	io->write.op.end_io = move_write_done;
+		io->write.op.end_io	= move_write_done;
+	} else {
+		bch2_bkey_buf_init(&io->write.k);
+		io->write.op.c		= c;
+		io->write.data_opts	= data_opts;
+	}
 
 	if (ctxt->rate)
 		bch2_ratelimit_increment(ctxt->rate, k.k->size);
@@ -356,11 +376,14 @@ int bch2_move_extent(struct moving_context *ctxt,
 	 * ctxt when doing wakeup
 	 */
 	closure_get(&ctxt->cl);
-	bch2_read_extent(trans, &io->rbio,
-			 bkey_start_pos(k.k),
-			 iter->btree_id, k, 0,
-			 BCH_READ_NODECODE|
-			 BCH_READ_LAST_FRAGMENT);
+	__bch2_read_extent(trans, &io->rbio,
+			   io->rbio.bio.bi_iter,
+			   bkey_start_pos(k.k),
+			   iter->btree_id, k, 0,
+			   NULL,
+			   BCH_READ_NODECODE|
+			   BCH_READ_LAST_FRAGMENT,
+			   data_opts.scrub ?  data_opts.read_dev : -1);
 	return 0;
 err_free_pages:
 	bio_free_pages(&io->write.op.wbio.bio);
@@ -703,6 +726,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 			unsigned dev,
 			u64 bucket_start,
 			u64 bucket_end,
+			unsigned data_types,
 			move_pred_fn pred, void *arg)
 {
 	struct btree_trans *trans = ctxt->trans;
@@ -773,6 +797,9 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		if (ctxt->stats)
 			ctxt->stats->offset = bp.k->p.offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT;
 
+		if (!(data_types & BIT(bp.v->data_type)))
+			goto next;
+
 		k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
 		ret = bkey_err(k);
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
@@ -796,17 +823,25 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 			goto next;
 		}
 
+		if (data_opts.scrub &&
+		    !bch2_dev_idx_is_online(c, data_opts.read_dev)) {
+			bch2_trans_iter_exit(trans, &iter);
+			ret = -BCH_ERR_device_offline;
+			break;
+		}
+
 		bch2_bkey_buf_reassemble(&sk, c, k);
 		k = bkey_i_to_s_c(sk.k);
 
 		/* move_extent will drop locks */
-		unsigned sectors = !bp.v->level
-			? bp.v->bucket_len
-			: btree_ptr_sectors_written(k);
+		unsigned sectors = bp.v->bucket_len;
 
-		ret = !bp.v->level
-			? bch2_move_extent(ctxt, bucket_in_flight, &iter, k, io_opts, data_opts)
-			: bch2_btree_node_rewrite_key(trans, bp.v->btree_id, bp.v->level, k.k->p, 0);
+		if (!bp.v->level)
+			ret = bch2_move_extent(ctxt, bucket_in_flight, &iter, k, io_opts, data_opts);
+		else if (!data_opts.scrub)
+			ret = bch2_btree_node_rewrite_key(trans, bp.v->btree_id, bp.v->level, k.k->p, 0);
+		else
+			ret = bch2_btree_node_scrub(trans, bp.v->btree_id, bp.v->level, k, data_opts.read_dev);
 
 		bch2_trans_iter_exit(trans, &iter);
 
@@ -835,6 +870,30 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 	return ret;
 }
 
+static int bch2_move_data_phys(struct bch_fs *c,
+			       unsigned dev,
+			       u64 start,
+			       u64 end,
+			       unsigned data_types,
+			       struct bch_ratelimit *rate,
+			       struct bch_move_stats *stats,
+			       struct write_point_specifier wp,
+			       bool wait_on_copygc,
+			       move_pred_fn pred, void *arg)
+{
+	struct moving_context ctxt;
+
+	bch2_trans_run(c, bch2_btree_write_buffer_flush_sync(trans));
+
+	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
+	ctxt.stats->phys = true;
+
+	int ret = __bch2_move_data_phys(&ctxt, NULL, dev, start, end, data_types, pred, arg);
+	bch2_moving_ctxt_exit(&ctxt);
+
+	return ret;
+}
+
 struct evacuate_bucket_arg {
 	struct bpos		bucket;
 	int			gen;
@@ -870,6 +929,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 				   bucket.inode,
 				   bucket.offset,
 				   bucket.offset + 1,
+				   ~0,
 				   evacuate_bucket_pred, &arg);
 }
 
@@ -1111,6 +1171,30 @@ static bool drop_extra_replicas_btree_pred(struct bch_fs *c, void *arg,
 	return drop_extra_replicas_pred(c, arg, bkey_i_to_s_c(&b->key), io_opts, data_opts);
 }
 
+static bool scrub_pred(struct bch_fs *c, void *_arg,
+		       struct bkey_s_c k,
+		       struct bch_io_opts *io_opts,
+		       struct data_update_opts *data_opts)
+{
+	struct bch_ioctl_data *arg = _arg;
+
+	if (k.k->type != KEY_TYPE_btree_ptr_v2) {
+		struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+		const union bch_extent_entry *entry;
+		struct extent_ptr_decoded p;
+		bkey_for_each_ptr_decode(k.k, ptrs, p, entry)
+			if (p.ptr.dev == arg->migrate.dev) {
+				if (!p.crc.csum_type)
+					return false;
+				break;
+			}
+	}
+
+	data_opts->scrub	= true;
+	data_opts->read_dev	= arg->migrate.dev;
+	return true;
+}
+
 int bch2_data_job(struct bch_fs *c,
 		  struct bch_move_stats *stats,
 		  struct bch_ioctl_data op)
@@ -1126,6 +1210,13 @@ int bch2_data_job(struct bch_fs *c,
 
 	switch (op.op) {
 	case BCH_DATA_OP_scrub:
+		ret = bch2_move_data_phys(c, op.scrub.dev, 0, U64_MAX,
+					  op.scrub.data_types,
+					  NULL,
+					  stats,
+					  writepoint_hashed((unsigned long) current),
+					  false,
+					  scrub_pred, &op) ?: ret;
 		break;
 
 	case BCH_DATA_OP_rereplicate:
diff --git a/fs/bcachefs/move_types.h b/fs/bcachefs/move_types.h
index 15d1f7f3d1dc..82e473ed48d2 100644
--- a/fs/bcachefs/move_types.h
+++ b/fs/bcachefs/move_types.h
@@ -3,11 +3,12 @@
 #define _BCACHEFS_MOVE_TYPES_H
 
 #include "bbpos_types.h"
+#include "bcachefs_ioctl.h"
 
 struct bch_move_stats {
 	char			name[32];
 	bool			phys;
-	bool			done;
+	enum bch_ioctl_data_event_ret	ret;
 
 	union {
 	struct {
@@ -25,6 +26,8 @@ struct bch_move_stats {
 	atomic64_t		sectors_seen;
 	atomic64_t		sectors_moved;
 	atomic64_t		sectors_raced;
+	atomic64_t		sectors_error_corrected;
+	atomic64_t		sectors_error_uncorrected;
 };
 
 struct move_bucket_key {
diff --git a/fs/bcachefs/sb-members.h b/fs/bcachefs/sb-members.h
index 762083b564ee..b29b6c6c21dd 100644
--- a/fs/bcachefs/sb-members.h
+++ b/fs/bcachefs/sb-members.h
@@ -23,6 +23,18 @@ static inline bool bch2_dev_is_online(struct bch_dev *ca)
 	return !percpu_ref_is_zero(&ca->io_ref);
 }
 
+static inline struct bch_dev *bch2_dev_rcu(struct bch_fs *, unsigned);
+
+static inline bool bch2_dev_idx_is_online(struct bch_fs *c, unsigned dev)
+{
+	rcu_read_lock();
+	struct bch_dev *ca = bch2_dev_rcu(c, dev);
+	bool ret = ca && bch2_dev_is_online(ca);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static inline bool bch2_dev_is_readable(struct bch_dev *ca)
 {
 	return bch2_dev_is_online(ca) &&
-- 
2.45.2

