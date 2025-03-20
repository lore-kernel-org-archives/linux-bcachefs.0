Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440F11EA7DE
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505872; cv=none; b=ufeAuTSiNmRoNKdHcaJu4oBIvfcASnkkU9VZ/QGgPLsOEzkxylS9jIPKGabwmJl7efIKLe0QqfsZbzT4aFkH+rC/u364hYci0/GH621DYZIefBC0ODB4EAnkIMO8tC2HPPDvD22iMAlg5mg/NzlHA7+6TCglC60nAZaVuipecj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505872; c=relaxed/simple;
	bh=mwb7W84QwemIJKUFCM2lEvAz6SWmqwX9xSgRBbRsy9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrXwjhrEjMdYmeLcfbP+BmwDrL2qLXPh2np5ms+OL2goT2QL3LvcURPXBQbnrp0jx+NHZn+dDsMQ0/N0POKtYpVOWTDdEU5LFaCQ0Oyq+0PTEV0yiDuD3MjRHrUBkN5doh7wY+uJI9HvO1NccwuPxx89Ch4wBPJkRJ655Q3S1sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=q+HVCdrC; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="q+HVCdrC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gtUa3+B3vOTcMpQ2c1eslUET/ir9w19rKBwk7RBcvAA=;
	b=q+HVCdrCFbTTagQp0NWhoqmK/qgQS4tKTw+YTm9R1h2qhjrslyDg83g1bko9A5/L9mhS0s
	Vj7gddfs4MfBuNzWKDEoVq0VSCrcNLXPx6ndV2SBFCiVMqS2BOYXAcIqN18yknjP6jfwIP
	big3OlhmakPBnfygLezXo13PmxUAkcM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: bch2_write_prep_encoded_data() now returns errcode
Date: Thu, 20 Mar 2025 17:24:17 -0400
Message-ID: <20250320212419.3359422-3-kent.overstreet@linux.dev>
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

Prep work for killing off EIO and replacing them with proper private
error codes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_write.c | 159 ++++++++++++++++++-----------------------
 1 file changed, 71 insertions(+), 88 deletions(-)

diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 09df19654458..a861f786c3db 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -434,6 +434,12 @@ void bch2_write_op_error(struct bch_write_op *op, u64 offset, const char *fmt, .
 	printbuf_exit(&buf);
 }
 
+static void bch2_write_csum_err_msg(struct bch_write_op *op)
+{
+	bch2_write_op_error(op, op->pos.offset,
+			    "error verifying existing checksum while rewriting existing data (memory corruption?)");
+}
+
 void bch2_submit_wbio_replicas(struct bch_write_bio *wbio, struct bch_fs *c,
 			       enum bch_data_type type,
 			       const struct bkey_i *k,
@@ -809,7 +815,6 @@ static int bch2_write_rechecksum(struct bch_fs *c,
 {
 	struct bio *bio = &op->wbio.bio;
 	struct bch_extent_crc_unpacked new_crc;
-	int ret;
 
 	/* bch2_rechecksum_bio() can't encrypt or decrypt data: */
 
@@ -817,10 +822,10 @@ static int bch2_write_rechecksum(struct bch_fs *c,
 	    bch2_csum_type_is_encryption(new_csum_type))
 		new_csum_type = op->crc.csum_type;
 
-	ret = bch2_rechecksum_bio(c, bio, op->version, op->crc,
-				  NULL, &new_crc,
-				  op->crc.offset, op->crc.live_size,
-				  new_csum_type);
+	int ret = bch2_rechecksum_bio(c, bio, op->version, op->crc,
+				      NULL, &new_crc,
+				      op->crc.offset, op->crc.live_size,
+				      new_csum_type);
 	if (ret)
 		return ret;
 
@@ -830,44 +835,12 @@ static int bch2_write_rechecksum(struct bch_fs *c,
 	return 0;
 }
 
-static int bch2_write_decrypt(struct bch_write_op *op)
-{
-	struct bch_fs *c = op->c;
-	struct nonce nonce = extent_nonce(op->version, op->crc);
-	struct bch_csum csum;
-	int ret;
-
-	if (!bch2_csum_type_is_encryption(op->crc.csum_type))
-		return 0;
-
-	/*
-	 * If we need to decrypt data in the write path, we'll no longer be able
-	 * to verify the existing checksum (poly1305 mac, in this case) after
-	 * it's decrypted - this is the last point we'll be able to reverify the
-	 * checksum:
-	 */
-	csum = bch2_checksum_bio(c, op->crc.csum_type, nonce, &op->wbio.bio);
-	if (bch2_crc_cmp(op->crc.csum, csum) && !c->opts.no_data_io)
-		return -EIO;
-
-	ret = bch2_encrypt_bio(c, op->crc.csum_type, nonce, &op->wbio.bio);
-	op->crc.csum_type = 0;
-	op->crc.csum = (struct bch_csum) { 0, 0 };
-	return ret;
-}
-
-static enum prep_encoded_ret {
-	PREP_ENCODED_OK,
-	PREP_ENCODED_ERR,
-	PREP_ENCODED_CHECKSUM_ERR,
-	PREP_ENCODED_DO_WRITE,
-} bch2_write_prep_encoded_data(struct bch_write_op *op, struct write_point *wp)
+static noinline int bch2_write_prep_encoded_data(struct bch_write_op *op, struct write_point *wp)
 {
 	struct bch_fs *c = op->c;
 	struct bio *bio = &op->wbio.bio;
-
-	if (!(op->flags & BCH_WRITE_data_encoded))
-		return PREP_ENCODED_OK;
+	struct nonce nonce = extent_nonce(op->version, op->crc);
+	int ret = 0;
 
 	BUG_ON(bio_sectors(bio) != op->crc.compressed_size);
 
@@ -878,12 +851,13 @@ static enum prep_encoded_ret {
 	    (op->crc.compression_type == bch2_compression_opt_to_type(op->compression_opt) ||
 	     op->incompressible)) {
 		if (!crc_is_compressed(op->crc) &&
-		    op->csum_type != op->crc.csum_type &&
-		    bch2_write_rechecksum(c, op, op->csum_type) &&
-		    !c->opts.no_data_io)
-			return PREP_ENCODED_CHECKSUM_ERR;
+		    op->csum_type != op->crc.csum_type) {
+			ret = bch2_write_rechecksum(c, op, op->csum_type);
+			if (ret)
+				return ret;
+		}
 
-		return PREP_ENCODED_DO_WRITE;
+		return 1;
 	}
 
 	/*
@@ -891,20 +865,23 @@ static enum prep_encoded_ret {
 	 * is, we have to decompress it:
 	 */
 	if (crc_is_compressed(op->crc)) {
-		struct bch_csum csum;
-
-		if (bch2_write_decrypt(op))
-			return PREP_ENCODED_CHECKSUM_ERR;
-
 		/* Last point we can still verify checksum: */
-		csum = bch2_checksum_bio(c, op->crc.csum_type,
-					 extent_nonce(op->version, op->crc),
-					 bio);
+		struct bch_csum csum = bch2_checksum_bio(c, op->crc.csum_type, nonce, bio);
 		if (bch2_crc_cmp(op->crc.csum, csum) && !c->opts.no_data_io)
-			return PREP_ENCODED_CHECKSUM_ERR;
+			goto csum_err;
 
-		if (bch2_bio_uncompress_inplace(op, bio))
-			return PREP_ENCODED_ERR;
+		if (bch2_csum_type_is_encryption(op->crc.csum_type)) {
+			ret = bch2_encrypt_bio(c, op->crc.csum_type, nonce, bio);
+			if (ret)
+				return ret;
+
+			op->crc.csum_type = 0;
+			op->crc.csum = (struct bch_csum) { 0, 0 };
+		}
+
+		ret = bch2_bio_uncompress_inplace(op, bio);
+		if (ret)
+			return ret;
 	}
 
 	/*
@@ -916,22 +893,34 @@ static enum prep_encoded_ret {
 	 * If the data is checksummed and we're only writing a subset,
 	 * rechecksum and adjust bio to point to currently live data:
 	 */
-	if ((op->crc.live_size != op->crc.uncompressed_size ||
-	     op->crc.csum_type != op->csum_type) &&
-	    bch2_write_rechecksum(c, op, op->csum_type) &&
-	    !c->opts.no_data_io)
-		return PREP_ENCODED_CHECKSUM_ERR;
+	if (op->crc.live_size != op->crc.uncompressed_size ||
+	    op->crc.csum_type != op->csum_type) {
+		ret = bch2_write_rechecksum(c, op, op->csum_type);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * If we want to compress the data, it has to be decrypted:
 	 */
-	if ((op->compression_opt ||
-	     bch2_csum_type_is_encryption(op->crc.csum_type) !=
-	     bch2_csum_type_is_encryption(op->csum_type)) &&
-	    bch2_write_decrypt(op))
-		return PREP_ENCODED_CHECKSUM_ERR;
+	if (bch2_csum_type_is_encryption(op->crc.csum_type) &&
+	    (op->compression_opt || op->crc.csum_type != op->csum_type)) {
+		struct bch_csum csum = bch2_checksum_bio(c, op->crc.csum_type, nonce, bio);
+		if (bch2_crc_cmp(op->crc.csum, csum) && !c->opts.no_data_io)
+			goto csum_err;
+
+		ret = bch2_encrypt_bio(c, op->crc.csum_type, nonce, bio);
+		if (ret)
+			return ret;
 
-	return PREP_ENCODED_OK;
+		op->crc.csum_type = 0;
+		op->crc.csum = (struct bch_csum) { 0, 0 };
+	}
+
+	return 0;
+csum_err:
+	bch2_write_csum_err_msg(op);
+	return -EIO;
 }
 
 static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
@@ -950,25 +939,21 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 
 	ec_buf = bch2_writepoint_ec_buf(c, wp);
 
-	switch (bch2_write_prep_encoded_data(op, wp)) {
-	case PREP_ENCODED_OK:
-		break;
-	case PREP_ENCODED_ERR:
-		ret = -EIO;
-		goto err;
-	case PREP_ENCODED_CHECKSUM_ERR:
-		goto csum_err;
-	case PREP_ENCODED_DO_WRITE:
-		/* XXX look for bug here */
-		if (ec_buf) {
-			dst = bch2_write_bio_alloc(c, wp, src,
-						   &page_alloc_failed,
-						   ec_buf);
-			bio_copy_data(dst, src);
-			bounce = true;
+	if (unlikely(op->flags & BCH_WRITE_data_encoded)) {
+		ret = bch2_write_prep_encoded_data(op, wp);
+		if (ret < 0)
+			goto err;
+		if (ret) {
+			if (ec_buf) {
+				dst = bch2_write_bio_alloc(c, wp, src,
+							   &page_alloc_failed,
+							   ec_buf);
+				bio_copy_data(dst, src);
+				bounce = true;
+			}
+			init_append_extent(op, wp, op->version, op->crc);
+			goto do_write;
 		}
-		init_append_extent(op, wp, op->version, op->crc);
-		goto do_write;
 	}
 
 	if (ec_buf ||
@@ -1141,9 +1126,7 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 	*_dst = dst;
 	return more;
 csum_err:
-	bch2_write_op_error(op, op->pos.offset,
-			    "error verifying existing checksum while rewriting existing data (memory corruption?)");
-
+	bch2_write_csum_err_msg(op);
 	ret = -EIO;
 err:
 	if (to_wbio(dst)->bounce)
-- 
2.49.0

