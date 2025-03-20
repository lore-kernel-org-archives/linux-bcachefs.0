Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F70A21CA07
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505871; cv=none; b=n+IoH5ApOfSbHGMZxJAQpMx8+UuGB/lEAlJZ5kMDqHYD78uzGSJrNgIt73+xBewazWtVQBcPiQCLqQMjZBhI+Rny4qz37v9PLxIjLE6LDo3hSAKnr2OW6A/AHXsu6iP+zVn1bqCFhZHxiM5RhvPBuSZM3cnxMM4lRaZd/VuYAuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505871; c=relaxed/simple;
	bh=fPhHyHkxQYDG9lcQ7a43Q2OnzL3qNrmOv4vJky/URL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTG9BoRwSMam8ATYcUAQSjE6AWy0lJG3Xg9R6+p+hf6xf0/mdC4CG/2xHBwKikIJauWE5isg8chA5U+vOEr7Xlq5d5j7V4ldDRQxQ2h0X+sVPrAJcPH84TeANJVn61ynygLgI+FOWnv1QiAeV/8l6U0mqVRvge1AIGNLN211Jyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m1pATMbE; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m1pATMbE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OQLJIzgHuoOjlfM2ZJe3AKbIoYhwv4oM98th/6zqHEg=;
	b=m1pATMbELmKtgYD3sKQwYiztmBoAuk6fb/G+7GDExGvtTsb+Zcrf4dP4sy0I4Q2UGHZo/L
	rNKs4/BsjXvBjjPBcklH711A9qt/yRENm8fho8eEb25V+Inx81NrlJ7nJ9ZaxZ2R8GnCQ1
	wJ7nezVZJ2Y/bbH4eq2gJuW0l4Zmhms=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Simplify bch2_write_op_error()
Date: Thu, 20 Mar 2025 17:24:16 -0400
Message-ID: <20250320212419.3359422-2-kent.overstreet@linux.dev>
In-Reply-To: <20250320212419.3359422-1-kent.overstreet@linux.dev>
References: <20250320212419.3359422-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There's no reason for the caller to do the actual logging, it's all done
the same.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/compress.c |  15 ++----
 fs/bcachefs/io_write.c | 110 ++++++++++++-----------------------------
 fs/bcachefs/io_write.h |   9 +---
 3 files changed, 37 insertions(+), 97 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index 31467f77930f..91483f83eb59 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -270,24 +270,15 @@ int bch2_bio_uncompress_inplace(struct bch_write_op *op,
 
 	if (crc->uncompressed_size << 9	> c->opts.encoded_extent_max ||
 	    crc->compressed_size << 9	> c->opts.encoded_extent_max) {
-		struct printbuf buf = PRINTBUF;
-		bch2_write_op_error(&buf, op, op->pos.offset,
-				    "extent too big to decompress");
-		bch_err_ratelimited(c, "%s", buf.buf);
-		printbuf_exit(&buf);
+		bch2_write_op_error(op, op->pos.offset, "extent too big to decompress");
 		return -EIO;
 	}
 
 	data = __bounce_alloc(c, dst_len, WRITE);
 
 	if (__bio_uncompress(c, bio, data.b, *crc)) {
-		if (!c->opts.no_data_io) {
-			struct printbuf buf = PRINTBUF;
-			bch2_write_op_error(&buf, op, op->pos.offset,
-					    "decompression error");
-			bch_err_ratelimited(c, "%s", buf.buf);
-			printbuf_exit(&buf);
-		}
+		if (!c->opts.no_data_io)
+			bch2_write_op_error(op, op->pos.offset, "decompression error");
 		ret = -EIO;
 		goto err;
 	}
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index a2e6b30530e3..09df19654458 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -402,61 +402,36 @@ static int bch2_write_index_default(struct bch_write_op *op)
 
 /* Writes */
 
-void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
-			       struct bch_write_op *op, u64 offset, const char *fmt, ...)
+void bch2_write_op_error(struct bch_write_op *op, u64 offset, const char *fmt, ...)
 {
-	if (op->subvol)
-		lockrestart_do(trans,
-			bch2_inum_offset_err_msg_trans(trans, out,
-						       (subvol_inum) { op->subvol, op->pos.inode, },
-						       offset << 9));
-	else {
-		struct bpos pos = op->pos;
-		pos.offset = offset;
-		lockrestart_do(trans, bch2_inum_snap_offset_err_msg_trans(trans, out, pos));
-	}
-
-	prt_str(out, "write error: ");
-
-	va_list args;
-	va_start(args, fmt);
-	prt_vprintf(out, fmt, args);
-	va_end(args);
-
-	if (op->flags & BCH_WRITE_move) {
-		struct data_update *u = container_of(op, struct data_update, op);
-
-		prt_printf(out, "\n  from internal move ");
-		bch2_bkey_val_to_text(out, op->c, bkey_i_to_s_c(u->k.k));
-	}
-}
+	struct printbuf buf = PRINTBUF;
 
-void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64 offset,
-			 const char *fmt, ...)
-{
-	if (op->subvol)
-		bch2_inum_offset_err_msg(op->c, out,
+	if (op->subvol) {
+		bch2_inum_offset_err_msg(op->c, &buf,
 					 (subvol_inum) { op->subvol, op->pos.inode, },
 					 offset << 9);
-	else {
+	} else {
 		struct bpos pos = op->pos;
 		pos.offset = offset;
-		bch2_inum_snap_offset_err_msg(op->c, out, pos);
+		bch2_inum_snap_offset_err_msg(op->c, &buf, pos);
 	}
 
-	prt_str(out, "write error: ");
+	prt_str(&buf, "write error: ");
 
 	va_list args;
 	va_start(args, fmt);
-	prt_vprintf(out, fmt, args);
+	prt_vprintf(&buf, fmt, args);
 	va_end(args);
 
 	if (op->flags & BCH_WRITE_move) {
 		struct data_update *u = container_of(op, struct data_update, op);
 
-		prt_printf(out, "\n  from internal move ");
-		bch2_bkey_val_to_text(out, op->c, bkey_i_to_s_c(u->k.k));
+		prt_printf(&buf, "\n  from internal move ");
+		bch2_bkey_val_to_text(&buf, op->c, bkey_i_to_s_c(u->k.k));
 	}
+
+	bch_err_ratelimited(op->c, "%s", buf.buf);
+	printbuf_exit(&buf);
 }
 
 void bch2_submit_wbio_replicas(struct bch_write_bio *wbio, struct bch_fs *c,
@@ -598,11 +573,8 @@ static void __bch2_write_index(struct bch_write_op *op)
 		if (unlikely(ret && !bch2_err_matches(ret, EROFS))) {
 			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
 
-			struct printbuf buf = PRINTBUF;
-			bch2_write_op_error(&buf, op, bkey_start_offset(&insert->k),
+			bch2_write_op_error(op, bkey_start_offset(&insert->k),
 					    "btree update error: %s", bch2_err_str(ret));
-			bch_err_ratelimited(c, "%s", buf.buf);
-			printbuf_exit(&buf);
 		}
 
 		if (ret)
@@ -1169,13 +1141,8 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 	*_dst = dst;
 	return more;
 csum_err:
-	{
-		struct printbuf buf = PRINTBUF;
-		bch2_write_op_error(&buf, op, op->pos.offset,
-				    "error verifying existing checksum while rewriting existing data (memory corruption?)");
-		bch_err_ratelimited(c, "%s", buf.buf);
-		printbuf_exit(&buf);
-	}
+	bch2_write_op_error(op, op->pos.offset,
+			    "error verifying existing checksum while rewriting existing data (memory corruption?)");
 
 	ret = -EIO;
 err:
@@ -1255,32 +1222,29 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
 {
 	struct bch_fs *c = op->c;
 	struct btree_trans *trans = bch2_trans_get(c);
+	int ret = 0;
 
 	for_each_keylist_key(&op->insert_keys, orig) {
-		int ret = for_each_btree_key_max_commit(trans, iter, BTREE_ID_extents,
+		ret = for_each_btree_key_max_commit(trans, iter, BTREE_ID_extents,
 				     bkey_start_pos(&orig->k), orig->k.p,
 				     BTREE_ITER_intent, k,
 				     NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
 			bch2_nocow_write_convert_one_unwritten(trans, &iter, orig, k, op->new_i_size);
 		}));
-
-		if (ret && !bch2_err_matches(ret, EROFS)) {
-			struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
-
-			struct printbuf buf = PRINTBUF;
-			bch2_write_op_error_trans(trans, &buf, op, bkey_start_offset(&insert->k),
-						  "btree update error: %s", bch2_err_str(ret));
-			bch_err_ratelimited(c, "%s", buf.buf);
-			printbuf_exit(&buf);
-		}
-
-		if (ret) {
-			op->error = ret;
+		if (ret)
 			break;
-		}
 	}
 
 	bch2_trans_put(trans);
+
+	if (ret && !bch2_err_matches(ret, EROFS)) {
+		struct bkey_i *insert = bch2_keylist_front(&op->insert_keys);
+		bch2_write_op_error(op, bkey_start_offset(&insert->k),
+				    "btree update error: %s", bch2_err_str(ret));
+	}
+
+	if (ret)
+		op->error = ret;
 }
 
 static void __bch2_nocow_write_done(struct bch_write_op *op)
@@ -1436,11 +1400,8 @@ static void bch2_nocow_write(struct bch_write_op *op)
 	darray_exit(&buckets);
 
 	if (ret) {
-		struct printbuf buf = PRINTBUF;
-		bch2_write_op_error(&buf, op, op->pos.offset,
+		bch2_write_op_error(op, op->pos.offset,
 				    "%s(): btree lookup error: %s", __func__, bch2_err_str(ret));
-		bch_err_ratelimited(c, "%s", buf.buf);
-		printbuf_exit(&buf);
 		op->error = ret;
 		op->flags |= BCH_WRITE_submitted;
 	}
@@ -1558,13 +1519,9 @@ static void __bch2_write(struct bch_write_op *op)
 			op->flags |= BCH_WRITE_submitted;
 
 			if (unlikely(ret < 0)) {
-				if (!(op->flags & BCH_WRITE_alloc_nowait)) {
-					struct printbuf buf = PRINTBUF;
-					bch2_write_op_error(&buf, op, op->pos.offset,
+				if (!(op->flags & BCH_WRITE_alloc_nowait))
+					bch2_write_op_error(op, op->pos.offset,
 							    "%s(): %s", __func__, bch2_err_str(ret));
-					bch_err_ratelimited(c, "%s", buf.buf);
-					printbuf_exit(&buf);
-				}
 				op->error = ret;
 				break;
 			}
@@ -1691,10 +1648,7 @@ CLOSURE_CALLBACK(bch2_write)
 	wbio_init(bio)->put_bio = false;
 
 	if (unlikely(bio->bi_iter.bi_size & (c->opts.block_size - 1))) {
-		struct printbuf buf = PRINTBUF;
-		bch2_write_op_error(&buf, op, op->pos.offset,
-				    "misaligned write");
-		printbuf_exit(&buf);
+		bch2_write_op_error(op, op->pos.offset, "misaligned write");
 		op->error = -EIO;
 		goto err;
 	}
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 627730537752..b8ab19a1e1da 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -14,13 +14,8 @@ void bch2_bio_alloc_pages_pool(struct bch_fs *, struct bio *, size_t);
 void bch2_submit_wbio_replicas(struct bch_write_bio *, struct bch_fs *,
 			       enum bch_data_type, const struct bkey_i *, bool);
 
-__printf(5, 6)
-void bch2_write_op_error_trans(struct btree_trans *trans, struct printbuf *out,
-			       struct bch_write_op *op, u64, const char *, ...);
-
-__printf(4, 5)
-void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op, u64,
-			 const char *, ...);
+__printf(3, 4)
+void bch2_write_op_error(struct bch_write_op *op, u64, const char *, ...);
 
 #define BCH_WRITE_FLAGS()		\
 	x(alloc_nowait)			\
-- 
2.49.0

