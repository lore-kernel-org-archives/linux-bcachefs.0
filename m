Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AF420E31F
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226178; cv=none; b=jEFaWH2by/KAbJQPc54WWnpdw/0OgutU4OVQSvQtjv2ZhTOEXsbKPbGZCgBOYEzxv/McpelYf+fRdVncYA6iGDdE5Vm/oP7mD4YqqKZlzNmuoIFQBWi8xFr+Wd8i9+xlW32JVfgM2GCMbJkRVzDnzliIdMVYEB0dkDQyeVKK9+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226178; c=relaxed/simple;
	bh=Hl2iaadkeYxC808tCvls2s8twOFLKeQMFLhwsWm0jRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtFZvtgJ8pk98DMzVccLZ/Cf0W6HTw3C4JlzQjdgyAbD/1Ph6y/jltb/SDJX+YuZIuLVA1i0UVlvt7VMsta2YVeyN2D7eXVkJYesbyvE0EVuvaUMqfhlHgsGXsj+LgeCjVPZs8clLgib2JwlenJfw4zLysNT1eVKNt9Fmz7O5NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a5QFQD9P; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a5QFQD9P"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HgBbqLQo0Sq7scsWFw2bgRMgGzS8mZpTmpj01i51DOU=;
	b=a5QFQD9PKGTkmZ2nrkrVe/5NFn0SD28Lyb93bWw2HhpVVXkZdJOrQ1ANVXZmx9p5yanMSF
	AUyrBdxu2rlPKACnT5BX2PdBcmq4b0L9mRDWC8BU4jEiiDh465yQQTiMDuHWKDFODR3Lm6
	/Vrx80FT/0tsrsiahKoDnGRHjGRkbSI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/9] bcachefs: handle restarts in bch2_bucket_io_time_reset()
Date: Fri, 18 Oct 2024 00:35:58 -0400
Message-ID: <20241018043602.4067344-9-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_bucket_io_time_reset() doesn't need to succeed, which is why it
didn't previously retry on transaction restart - but we're now treating
these as errors.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 50f1919f4cbf..69c7fc97e467 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -2351,24 +2351,19 @@ int bch2_dev_remove_alloc(struct bch_fs *c, struct bch_dev *ca)
 
 /* Bucket IO clocks: */
 
-int bch2_bucket_io_time_reset(struct btree_trans *trans, unsigned dev,
-			      size_t bucket_nr, int rw)
+static int __bch2_bucket_io_time_reset(struct btree_trans *trans, unsigned dev,
+				size_t bucket_nr, int rw)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter;
-	struct bkey_i_alloc_v4 *a;
-	u64 now;
-	int ret = 0;
 
-	if (bch2_trans_relock(trans))
-		bch2_trans_begin(trans);
-
-	a = bch2_trans_start_alloc_update_noupdate(trans, &iter, POS(dev, bucket_nr));
-	ret = PTR_ERR_OR_ZERO(a);
+	struct btree_iter iter;
+	struct bkey_i_alloc_v4 *a =
+		bch2_trans_start_alloc_update_noupdate(trans, &iter, POS(dev, bucket_nr));
+	int ret = PTR_ERR_OR_ZERO(a);
 	if (ret)
 		return ret;
 
-	now = bch2_current_io_time(c, rw);
+	u64 now = bch2_current_io_time(c, rw);
 	if (a->v.io_time[rw] == now)
 		goto out;
 
@@ -2381,6 +2376,15 @@ int bch2_bucket_io_time_reset(struct btree_trans *trans, unsigned dev,
 	return ret;
 }
 
+int bch2_bucket_io_time_reset(struct btree_trans *trans, unsigned dev,
+			      size_t bucket_nr, int rw)
+{
+	if (bch2_trans_relock(trans))
+		bch2_trans_begin(trans);
+
+	return nested_lockrestart_do(trans, __bch2_bucket_io_time_reset(trans, dev, bucket_nr, rw));
+}
+
 /* Startup/shutdown (ro/rw): */
 
 void bch2_recalc_capacity(struct bch_fs *c)
-- 
2.45.2

