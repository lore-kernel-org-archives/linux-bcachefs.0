Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8981C6FFD
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Mar 2025 20:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724141; cv=none; b=QTm35yseH+aAXD71723hcjvPYYD5HrZW5hIpiBJBePufLT9/F05Zd5jzpJdQDFbFIc2I3rgzNVHIrBes9A64geOtkW2WuRDHnY37AdoHCxaI4o8mmBHhFusbzalaPiHkpa47oXh6GOPtzAFFXmlaoORxxAsdPoqw8kC4coAXpCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724141; c=relaxed/simple;
	bh=R8G/F0zGChZqrfKL7tKsgDKLgYV7O38QWBXN/47qNKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsgWoicJp5LlCcXGf67OKLGeF51GIjy35DNUtMWMWcZSCxNioD381MZWGCpM8inPkfExY7eYFeim/f9UVpX2B0wcgKadku+eHjzAB6ksog8lVsUgJotJQErOLXhKlIu/YVaomoORDNqkSoJLIq3HhunaJsSttJY3omg0igyU9yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mdJhTsLy; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mdJhTsLy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741724137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CcuroDwJE7yw6bbSfa4eh3ydcLmDYVvfPs0W7uBBb4o=;
	b=mdJhTsLySuSLY+ENTppuxGbUjrmSR2jdVTPzLU/FyCwkrUZmvyxYvScQ1TudkhfPmUXj40
	mT0JQMJHxhLYs1iVRl3s+PvxXzAqHeackDdqc9+uMdih7fJsn8OL9Rxz5Nl390X42N0SIF
	uMjL5XzNf4xo/o144cz8wYqy3kOQF5A=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/14] bcachefs: Debug params for data corruption injection
Date: Tue, 11 Mar 2025 16:15:14 -0400
Message-ID: <20250311201518.3573009-13-kent.overstreet@linux.dev>
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

dm-flakey is busted, and this is simpler anyways - this lets us test the
checksum error retry ptahs

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/io_read.c  |  8 ++++++++
 fs/bcachefs/io_write.c | 24 ++++++++++++++++++++++++
 fs/bcachefs/util.c     | 21 +++++++++++++++++++++
 fs/bcachefs/util.h     | 12 ++++++++++++
 4 files changed, 65 insertions(+)

diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 1ff4edac7e81..69c1422685e0 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -27,6 +27,12 @@
 
 #include <linux/sched/mm.h>
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+static unsigned bch2_read_corrupt_ratio;
+module_param_named(read_corrupt_ratio, bch2_read_corrupt_ratio, uint, 0644);
+MODULE_PARM_DESC(read_corrupt_ratio, "");
+#endif
+
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
 
 static bool bch2_target_congested(struct bch_fs *c, u16 target)
@@ -807,6 +813,8 @@ static void __bch2_read_endio(struct work_struct *work)
 		src->bi_iter			= rbio->bvec_iter;
 	}
 
+	bch2_maybe_corrupt_bio(src, bch2_read_corrupt_ratio);
+
 	csum = bch2_checksum_bio(c, crc.csum_type, nonce, src);
 	bool csum_good = !bch2_crc_cmp(csum, rbio->pick.crc.csum) || c->opts.no_data_io;
 
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index dbfcb28f003d..48befbae0226 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -34,6 +34,12 @@
 #include <linux/random.h>
 #include <linux/sched/mm.h>
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+static unsigned bch2_write_corrupt_ratio;
+module_param_named(write_corrupt_ratio, bch2_write_corrupt_ratio, uint, 0644);
+MODULE_PARM_DESC(write_corrupt_ratio, "");
+#endif
+
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
 
 static inline void bch2_congested_acct(struct bch_dev *ca, u64 io_latency,
@@ -1005,6 +1011,15 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 		bounce = true;
 	}
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+	unsigned write_corrupt_ratio = READ_ONCE(bch2_write_corrupt_ratio);
+	if (!bounce && write_corrupt_ratio) {
+		dst = bch2_write_bio_alloc(c, wp, src,
+					   &page_alloc_failed,
+					   ec_buf);
+		bounce = true;
+	}
+#endif
 	saved_iter = dst->bi_iter;
 
 	do {
@@ -1114,6 +1129,14 @@ static int bch2_write_extent(struct bch_write_op *op, struct write_point *wp,
 
 		init_append_extent(op, wp, version, crc);
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+		if (write_corrupt_ratio) {
+			swap(dst->bi_iter.bi_size, dst_len);
+			bch2_maybe_corrupt_bio(dst, write_corrupt_ratio);
+			swap(dst->bi_iter.bi_size, dst_len);
+		}
+#endif
+
 		if (dst != src)
 			bio_advance(dst, dst_len);
 		bio_advance(src, src_len);
@@ -1394,6 +1417,7 @@ static void bch2_nocow_write(struct bch_write_op *op)
 		bio->bi_private	= &op->cl;
 		bio->bi_opf |= REQ_OP_WRITE;
 		closure_get(&op->cl);
+
 		bch2_submit_wbio_replicas(to_wbio(bio), c, BCH_DATA_user,
 					  op->insert_keys.top, true);
 
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 50a90e48f6dd..7623cf6f75ae 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -698,6 +698,27 @@ void memcpy_from_bio(void *dst, struct bio *src, struct bvec_iter src_iter)
 	}
 }
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+void bch2_corrupt_bio(struct bio *bio)
+{
+	struct bvec_iter iter;
+	struct bio_vec bv;
+	unsigned offset = get_random_u32_below(bio->bi_iter.bi_size / sizeof(u64));
+
+	bio_for_each_segment(bv, bio, iter) {
+		unsigned u64s = bv.bv_len / sizeof(u64);
+
+		if (offset < u64s) {
+			u64 *segment = bvec_kmap_local(&bv);
+			segment[offset] = get_random_u64();
+			kunmap_local(segment);
+			return;
+		}
+		offset -= u64s;
+	}
+}
+#endif
+
 #if 0
 void eytzinger1_test(void)
 {
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index e7c3541b38f3..fd74fafac297 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -406,6 +406,18 @@ size_t bch2_rand_range(size_t);
 void memcpy_to_bio(struct bio *, struct bvec_iter, const void *);
 void memcpy_from_bio(void *, struct bio *, struct bvec_iter);
 
+#ifdef CONFIG_BCACHEFS_DEBUG
+void bch2_corrupt_bio(struct bio *);
+
+static inline void bch2_maybe_corrupt_bio(struct bio *bio, unsigned ratio)
+{
+	if (ratio && !get_random_u32_below(ratio))
+		bch2_corrupt_bio(bio);
+}
+#else
+#define bch2_maybe_corrupt_bio(...)	do {} while (0)
+#endif
+
 static inline void memcpy_u64s_small(void *dst, const void *src,
 				     unsigned u64s)
 {
-- 
2.47.2

