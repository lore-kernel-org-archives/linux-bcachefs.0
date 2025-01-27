Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3315ADB4
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951180; cv=none; b=QURTrmuvmt4WuBzyahHsEo342RYZBNksp1NYQPm1+muEG3pS+hOaizixY+i6exfKD6s9VSBLiLgrBZI6gci50NFtYhSqYpUROan4pKTSmWSlXOY0k+xg1JTypt2pwurYW75j6UNvbSCWHjv/hrSNGiu1RCudGHeiuK4FroSLm40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951180; c=relaxed/simple;
	bh=TLdBdpCX/Ix+uZy2N8Z2lN1B8G9GuOjvdfz0la4NLIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrqoPDsH45c4V71P00eY9lv1V4AY/10EF68kw41iZgsbiCxwzRHf0nzyoIkDhii+oSJ8bggVRJnfpOC2bFEguON+x6sZNGDe5gYCzrmc3Ax4elTkW8ytMa0EncxZVVSZ0xlw427Uj9cfkwvvd8T9/zlPSBZUIVwLmXOs6TPPjjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=F51FtR1G; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="F51FtR1G"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nO0uj1+nPRRE6WadeUotFYTKGJindwm+3GJXrSwTfuY=;
	b=F51FtR1G4EmKuHDu2ohoN2bz4DLAp8XusgfzhwfvyRyvCl8o+HzavKv0W+CzA590btFE3T
	B1ruI43zemUeJ7s0YLwaB5IZG811Y42zQdE5m0baS7KQeAJtvIErDXAwXZUbviRbXfaIvr
	YdrqJ4gL46/My5Ad9TpcrVm971nMIhQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/11] bcachefs: Improve decompression error messages
Date: Sun, 26 Jan 2025 23:12:31 -0500
Message-ID: <20250127041239.2693707-6-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Ratelimit them, and use the new bch2_write_op_error() helper that prints
path and file offset.

Reported-by: https://github.com/koverstreet/bcachefs/issues/819
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/compress.c | 31 ++++++++++++++++++++++---------
 fs/bcachefs/compress.h |  4 ++--
 fs/bcachefs/io_write.c |  4 ++--
 fs/bcachefs/io_write.h |  2 ++
 4 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
index f99ff1819597..114bf2f3879f 100644
--- a/fs/bcachefs/compress.c
+++ b/fs/bcachefs/compress.c
@@ -4,6 +4,7 @@
 #include "compress.h"
 #include "error.h"
 #include "extents.h"
+#include "io_write.h"
 #include "opts.h"
 #include "super-io.h"
 
@@ -254,11 +255,14 @@ static int __bio_uncompress(struct bch_fs *c, struct bio *src,
 	goto out;
 }
 
-int bch2_bio_uncompress_inplace(struct bch_fs *c, struct bio *bio,
-				struct bch_extent_crc_unpacked *crc)
+int bch2_bio_uncompress_inplace(struct bch_write_op *op,
+				struct bio *bio)
 {
+	struct bch_fs *c = op->c;
+	struct bch_extent_crc_unpacked *crc = &op->crc;
 	struct bbuf data = { NULL };
 	size_t dst_len = crc->uncompressed_size << 9;
+	int ret = 0;
 
 	/* bio must own its pages: */
 	BUG_ON(!bio->bi_vcnt);
@@ -266,17 +270,26 @@ int bch2_bio_uncompress_inplace(struct bch_fs *c, struct bio *bio,
 
 	if (crc->uncompressed_size << 9	> c->opts.encoded_extent_max ||
 	    crc->compressed_size << 9	> c->opts.encoded_extent_max) {
-		bch_err(c, "error rewriting existing data: extent too big");
+		struct printbuf buf = PRINTBUF;
+		bch2_write_op_error(&buf, op);
+		prt_printf(&buf, "error rewriting existing data: extent too big");
+		bch_err_ratelimited(c, "%s", buf.buf);
+		printbuf_exit(&buf);
 		return -EIO;
 	}
 
 	data = __bounce_alloc(c, dst_len, WRITE);
 
 	if (__bio_uncompress(c, bio, data.b, *crc)) {
-		if (!c->opts.no_data_io)
-			bch_err(c, "error rewriting existing data: decompression error");
-		bio_unmap_or_unbounce(c, data);
-		return -EIO;
+		if (!c->opts.no_data_io) {
+			struct printbuf buf = PRINTBUF;
+			bch2_write_op_error(&buf, op);
+			prt_printf(&buf, "error rewriting existing data: decompression error");
+			bch_err_ratelimited(c, "%s", buf.buf);
+			printbuf_exit(&buf);
+		}
+		ret = -EIO;
+		goto err;
 	}
 
 	/*
@@ -293,9 +306,9 @@ int bch2_bio_uncompress_inplace(struct bch_fs *c, struct bio *bio,
 	crc->uncompressed_size	= crc->live_size;
 	crc->offset		= 0;
 	crc->csum		= (struct bch_csum) { 0, 0 };
-
+err:
 	bio_unmap_or_unbounce(c, data);
-	return 0;
+	return ret;
 }
 
 int bch2_bio_uncompress(struct bch_fs *c, struct bio *src,
diff --git a/fs/bcachefs/compress.h b/fs/bcachefs/compress.h
index 607fd5e232c9..bec2f05bfd52 100644
--- a/fs/bcachefs/compress.h
+++ b/fs/bcachefs/compress.h
@@ -47,8 +47,8 @@ static inline enum bch_compression_type bch2_compression_opt_to_type(unsigned v)
 	return __bch2_compression_opt_to_type[bch2_compression_decode(v).type];
 }
 
-int bch2_bio_uncompress_inplace(struct bch_fs *, struct bio *,
-				struct bch_extent_crc_unpacked *);
+struct bch_write_op;
+int bch2_bio_uncompress_inplace(struct bch_write_op *, struct bio *);
 int bch2_bio_uncompress(struct bch_fs *, struct bio *, struct bio *,
 		       struct bvec_iter, struct bch_extent_crc_unpacked);
 unsigned bch2_bio_compress(struct bch_fs *, struct bio *, size_t *,
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 3e71860f66b9..dd508d93e9fc 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -406,7 +406,7 @@ static void __bch2_write_op_error(struct printbuf *out, struct bch_write_op *op,
 		   op->flags & BCH_WRITE_MOVE ? "(internal move)" : "");
 }
 
-static void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op)
+void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op)
 {
 	__bch2_write_op_error(out, op, op->pos.offset);
 }
@@ -873,7 +873,7 @@ static enum prep_encoded_ret {
 		if (bch2_crc_cmp(op->crc.csum, csum) && !c->opts.no_data_io)
 			return PREP_ENCODED_CHECKSUM_ERR;
 
-		if (bch2_bio_uncompress_inplace(c, bio, &op->crc))
+		if (bch2_bio_uncompress_inplace(op, bio))
 			return PREP_ENCODED_ERR;
 	}
 
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 5400ce94ee57..b4626013abc8 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -20,6 +20,8 @@ static inline void bch2_latency_acct(struct bch_dev *ca, u64 submit_time, int rw
 void bch2_submit_wbio_replicas(struct bch_write_bio *, struct bch_fs *,
 			       enum bch_data_type, const struct bkey_i *, bool);
 
+void bch2_write_op_error(struct printbuf *out, struct bch_write_op *op);
+
 #define BCH_WRITE_FLAGS()		\
 	x(ALLOC_NOWAIT)			\
 	x(CACHED)			\
-- 
2.45.2

