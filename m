Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405521C6FFD
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724135; cv=none; b=fJpSfdLYGBpiAfgiXNYkLAoOQo15V2jr3rsH/Fb0/kTNSx3IQt6pr6sL88z6pqRy9dvSoBDATaA975nxGwOLBLcQL4qXyEFmoAnU5qW9XPzRdJ7x7JW/MqV/HcKZBO8LnqaMsZquO1LcYvvKLPLlj9DGE0LlYus235nj3NAFtck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724135; c=relaxed/simple;
	bh=EAONH5U8DLqed07KuSs4gweIrles8yRNoPMI1+LKB4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIg+ZS2FF+ENU7zoNFWKkvKerKMDKWZGXd9NoK6ugYXi6mqseejjfDuMq0+q2XDmZ9gI2Q6YfTrwdFgMrAvXIvwvaizocVbUb0mULLRDKiI54FFpMX0qFIfudozxSmm4fQaeDDtZjz4oDVG0LnuB7C9vSApfKsRqqpXa5mERSvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fn4Np8W/; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fn4Np8W/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yX00jLS5fAKZNUiHyXpxKMUsAzooLqXqKrf3eJdf0KI=;
	b=fn4Np8W/C1prhqEFROEbm/NjrG5bSh9owURMLInfsFs2OyBhNxLkOvcGPhUvuErOMNKtx8
	eL18tNG5ht2Ojg0Qr75Q/3nx6ob3Spq5gZoJGy8lDcB5SNy1/iSnEHCL/aD3tMEazBH0uD
	QuGiJBraD5Rk4L9+6a+rBx/aFnNo8IE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 01/14] bcachefs: Convert read path to standard error codes
Date: Tue, 11 Mar 2025 16:15:03 -0400
Message-ID: <20250311201518.3573009-2-kent.overstreet@linux.dev>
In-Reply-To: <20250311201518.3573009-1-kent.overstreet@linux.dev>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Kill the READ_ERR/READ_RETRY/READ_RETRY_AVOID enums, and add standard
error codes that describe precisely which error occured.

This is going to be used for the data move path, to move but poison
extents with checksum errors.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/errcode.h | 13 ++++++
 fs/bcachefs/io_read.c | 93 ++++++++++++++++++++++++-------------------
 fs/bcachefs/io_read.h |  4 +-
 3 files changed, 67 insertions(+), 43 deletions(-)

diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index e14e0d1cc93d..5050d978624b 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -282,6 +282,19 @@
 	x(EIO,				EIO_fault_injected)			\
 	x(EIO,				ec_block_read)				\
 	x(EIO,				ec_block_write)				\
+	x(EIO,				data_read)				\
+	x(BCH_ERR_data_read,		data_read_retry)			\
+	x(BCH_ERR_data_read_retry,	data_read_retry_avoid)			\
+	x(BCH_ERR_data_read_retry_avoid,data_read_retry_device_offline)		\
+	x(BCH_ERR_data_read_retry_avoid,data_read_retry_io_err)			\
+	x(BCH_ERR_data_read_retry_avoid,data_read_retry_ec_reconstruct_err)	\
+	x(BCH_ERR_data_read_retry_avoid,data_read_retry_csum_err)		\
+	x(BCH_ERR_data_read_retry,	data_read_retry_csum_err_maybe_userspace)\
+	x(BCH_ERR_data_read,		data_read_decompress_err)		\
+	x(BCH_ERR_data_read,		data_read_decrypt_err)			\
+	x(BCH_ERR_data_read,		data_read_ptr_stale_race)		\
+	x(BCH_ERR_data_read_retry,	data_read_ptr_stale_retry)		\
+	x(BCH_ERR_data_read,		data_read_no_encryption_key)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_fixable)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_want_retry)		\
 	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_must_retry)		\
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 97df07add2cc..72a0a6f643d8 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -341,10 +341,6 @@ static void bch2_read_err_msg(struct bch_fs *c, struct printbuf *out,
 	bch2_trans_run(c, bch2_read_err_msg_trans(trans, out, rbio, read_pos));
 }
 
-#define READ_RETRY_AVOID	1
-#define READ_RETRY		2
-#define READ_ERR		3
-
 enum rbio_context {
 	RBIO_CONTEXT_NULL,
 	RBIO_CONTEXT_HIGHPRI,
@@ -446,7 +442,7 @@ static noinline void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_
 err:
 	bch2_trans_iter_exit(trans, &iter);
 
-	if (ret == READ_RETRY)
+	if (bch2_err_matches(ret, BCH_ERR_data_read_retry))
 		goto retry;
 	if (ret)
 		rbio->bio.bi_status = BLK_STS_IOERR;
@@ -473,11 +469,13 @@ static void bch2_rbio_retry(struct work_struct *work)
 	this_cpu_add(c->counters[BCH_COUNTER_io_read_retry],
 		     bvec_iter_sectors(rbio->bvec_iter));
 
-	if (rbio->retry == READ_RETRY_AVOID)
+	if (bch2_err_matches(rbio->ret, BCH_ERR_data_read_retry_avoid))
 		bch2_mark_io_failure(&failed, &rbio->pick);
 
-	if (!rbio->split)
-		rbio->bio.bi_status = 0;
+	if (!rbio->split) {
+		rbio->bio.bi_status	= 0;
+		rbio->ret		= 0;
+	}
 
 	rbio = bch2_rbio_free(rbio);
 
@@ -492,23 +490,29 @@ static void bch2_rbio_retry(struct work_struct *work)
 		__bch2_read(c, rbio, iter, inum, &failed, flags);
 }
 
-static void bch2_rbio_error(struct bch_read_bio *rbio, int retry,
-			    blk_status_t error)
+static void bch2_rbio_error(struct bch_read_bio *rbio,
+			    int ret, blk_status_t blk_error)
 {
-	rbio->retry = retry;
-	rbio->saw_error = true;
+	BUG_ON(ret >= 0);
+
+	rbio->ret		= ret;
+	rbio->bio.bi_status	= blk_error;
+
+	bch2_rbio_parent(rbio)->saw_error = true;
 
 	if (rbio->flags & BCH_READ_in_retry)
 		return;
 
-	if (retry == READ_ERR) {
+	if (bch2_err_matches(ret, BCH_ERR_data_read_retry)) {
+		bch2_rbio_punt(rbio, bch2_rbio_retry,
+			       RBIO_CONTEXT_UNBOUND, system_unbound_wq);
+	} else {
 		rbio = bch2_rbio_free(rbio);
 
-		rbio->bio.bi_status = error;
+		rbio->ret		= ret;
+		rbio->bio.bi_status	= blk_error;
+
 		bch2_rbio_done(rbio);
-	} else {
-		bch2_rbio_punt(rbio, bch2_rbio_retry,
-			       RBIO_CONTEXT_UNBOUND, system_unbound_wq);
 	}
 }
 
@@ -530,7 +534,7 @@ static void bch2_read_io_err(struct work_struct *work)
 		bch_err_ratelimited(c, "%s", buf.buf);
 
 	printbuf_exit(&buf);
-	bch2_rbio_error(rbio, READ_RETRY_AVOID, bio->bi_status);
+	bch2_rbio_error(rbio, -BCH_ERR_data_read_retry_io_err, bio->bi_status);
 }
 
 static int __bch2_rbio_narrow_crcs(struct btree_trans *trans,
@@ -617,7 +621,7 @@ static void bch2_read_csum_err(struct work_struct *work)
 	else
 		bch_err_ratelimited(c, "%s", buf.buf);
 
-	bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
+	bch2_rbio_error(rbio, -BCH_ERR_data_read_retry_csum_err, BLK_STS_IOERR);
 	printbuf_exit(&buf);
 }
 
@@ -637,7 +641,7 @@ static void bch2_read_decompress_err(struct work_struct *work)
 	else
 		bch_err_ratelimited(c, "%s", buf.buf);
 
-	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
+	bch2_rbio_error(rbio, -BCH_ERR_data_read_decompress_err, BLK_STS_IOERR);
 	printbuf_exit(&buf);
 }
 
@@ -657,7 +661,7 @@ static void bch2_read_decrypt_err(struct work_struct *work)
 	else
 		bch_err_ratelimited(c, "%s", buf.buf);
 
-	bch2_rbio_error(rbio, READ_ERR, BLK_STS_IOERR);
+	bch2_rbio_error(rbio, -BCH_ERR_data_read_decrypt_err, BLK_STS_IOERR);
 	printbuf_exit(&buf);
 }
 
@@ -698,7 +702,8 @@ static void __bch2_read_endio(struct work_struct *work)
 	 */
 	if (!csum_good && !rbio->bounce && (rbio->flags & BCH_READ_user_mapped)) {
 		rbio->flags |= BCH_READ_must_bounce;
-		bch2_rbio_error(rbio, READ_RETRY, BLK_STS_IOERR);
+		bch2_rbio_error(rbio, -BCH_ERR_data_read_retry_csum_err_maybe_userspace,
+				BLK_STS_IOERR);
 		goto out;
 	}
 
@@ -812,9 +817,9 @@ static void bch2_read_endio(struct bio *bio)
 		trace_and_count(c, io_read_reuse_race, &rbio->bio);
 
 		if (rbio->flags & BCH_READ_retry_if_stale)
-			bch2_rbio_error(rbio, READ_RETRY, BLK_STS_AGAIN);
+			bch2_rbio_error(rbio, -BCH_ERR_data_read_ptr_stale_retry, BLK_STS_AGAIN);
 		else
-			bch2_rbio_error(rbio, READ_ERR, BLK_STS_AGAIN);
+			bch2_rbio_error(rbio, -BCH_ERR_data_read_ptr_stale_race, BLK_STS_AGAIN);
 		return;
 	}
 
@@ -887,7 +892,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	struct bch_read_bio *rbio = NULL;
 	bool bounce = false, read_full = false, narrow_crcs = false;
 	struct bpos data_pos = bkey_start_pos(k.k);
-	int pick_ret;
+	int ret = 0;
 
 	if (bkey_extent_is_inline_data(k.k)) {
 		unsigned bytes = min_t(unsigned, iter.bi_size,
@@ -903,16 +908,16 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		goto out_read_done;
 	}
 retry_pick:
-	pick_ret = bch2_bkey_pick_read_device(c, k, failed, &pick, dev);
+	ret = bch2_bkey_pick_read_device(c, k, failed, &pick, dev);
 
 	/* hole or reservation - just zero fill: */
-	if (!pick_ret)
+	if (!ret)
 		goto hole;
 
-	if (unlikely(pick_ret < 0)) {
+	if (unlikely(ret < 0)) {
 		struct printbuf buf = PRINTBUF;
 		bch2_read_err_msg_trans(trans, &buf, orig, read_pos);
-		prt_printf(&buf, "no device to read from: %s\n  ", bch2_err_str(pick_ret));
+		prt_printf(&buf, "%s\n  ", bch2_err_str(ret));
 		bch2_bkey_val_to_text(&buf, c, k);
 
 		bch_err_ratelimited(c, "%s", buf.buf);
@@ -928,6 +933,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 
 		bch_err_ratelimited(c, "%s", buf.buf);
 		printbuf_exit(&buf);
+		ret = -BCH_ERR_data_read_no_encryption_key;
 		goto err;
 	}
 
@@ -1063,7 +1069,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	rbio->have_ioref	= ca != NULL;
 	rbio->narrow_crcs	= narrow_crcs;
 	rbio->hole		= 0;
-	rbio->retry		= 0;
+	rbio->ret		= 0;
 	rbio->context		= 0;
 	rbio->pick		= pick;
 	rbio->subvol		= orig->subvol;
@@ -1118,7 +1124,9 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 			bch_err_ratelimited(c, "%s", buf.buf);
 			printbuf_exit(&buf);
 
-			bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
+			bch2_rbio_error(rbio,
+					-BCH_ERR_data_read_retry_device_offline,
+					BLK_STS_IOERR);
 			goto out;
 		}
 
@@ -1144,7 +1152,8 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 	} else {
 		/* Attempting reconstruct read: */
 		if (bch2_ec_read_extent(trans, rbio, k)) {
-			bch2_rbio_error(rbio, READ_RETRY_AVOID, BLK_STS_IOERR);
+			bch2_rbio_error(rbio, -BCH_ERR_data_read_retry_ec_reconstruct_err,
+					BLK_STS_IOERR);
 			goto out;
 		}
 
@@ -1162,13 +1171,11 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		rbio->context = RBIO_CONTEXT_UNBOUND;
 		bch2_read_endio(&rbio->bio);
 
-		ret = rbio->retry;
+		ret = rbio->ret;
 		rbio = bch2_rbio_free(rbio);
 
-		if (ret == READ_RETRY_AVOID) {
+		if (bch2_err_matches(ret, BCH_ERR_data_read_retry_avoid))
 			bch2_mark_io_failure(failed, &pick);
-			ret = READ_RETRY;
-		}
 
 		if (!ret)
 			goto out_read_done;
@@ -1178,9 +1185,10 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 
 err:
 	if (flags & BCH_READ_in_retry)
-		return READ_ERR;
+		return ret;
 
-	orig->bio.bi_status = BLK_STS_IOERR;
+	orig->bio.bi_status	= BLK_STS_IOERR;
+	orig->ret		= ret;
 	goto out_read_done;
 
 hole:
@@ -1277,8 +1285,7 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 err:
 		if (ret &&
 		    !bch2_err_matches(ret, BCH_ERR_transaction_restart) &&
-		    ret != READ_RETRY &&
-		    ret != READ_RETRY_AVOID)
+		    !bch2_err_matches(ret, BCH_ERR_data_read_retry))
 			break;
 	}
 
@@ -1289,11 +1296,13 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		lockrestart_do(trans,
 			bch2_inum_offset_err_msg_trans(trans, &buf, inum,
 						       bvec_iter.bi_sector << 9));
-		prt_printf(&buf, "read error %i from btree lookup", ret);
+		prt_printf(&buf, "read error %s from btree lookup", bch2_err_str(ret));
 		bch_err_ratelimited(c, "%s", buf.buf);
 		printbuf_exit(&buf);
 
-		rbio->bio.bi_status = BLK_STS_IOERR;
+		rbio->bio.bi_status	= BLK_STS_IOERR;
+		rbio->ret		= ret;
+
 		bch2_rbio_done(rbio);
 	}
 
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index 73275da5d2c4..dd6694c2cf3f 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -42,11 +42,11 @@ struct bch_read_bio {
 				narrow_crcs:1,
 				hole:1,
 				saw_error:1,
-				retry:2,
 				context:2;
 	};
 	u16			_state;
 	};
+	s16			ret;
 
 	struct extent_ptr_decoded pick;
 
@@ -166,6 +166,7 @@ static inline struct bch_read_bio *rbio_init_fragment(struct bio *bio,
 
 	rbio->c		= orig->c;
 	rbio->_state	= 0;
+	rbio->ret	= 0;
 	rbio->split	= true;
 	rbio->parent	= orig;
 	rbio->opts	= orig->opts;
@@ -182,6 +183,7 @@ static inline struct bch_read_bio *rbio_init(struct bio *bio,
 	rbio->start_time	= local_clock();
 	rbio->c			= c;
 	rbio->_state		= 0;
+	rbio->ret	= 0;
 	rbio->opts		= opts;
 	rbio->bio.bi_end_io	= end_io;
 	return rbio;
-- 
2.47.2

