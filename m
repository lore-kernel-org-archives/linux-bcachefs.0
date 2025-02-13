Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FDE245AED
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472383; cv=none; b=SIUG7Oat8vk+9rzNMFxTMsZ//ywmdLfm7gMInWAYW1G4e/Y5gUBC+w5ZPoJpi04mEMqOYi2cKPEfWVvAf6UlBh5N/v44KKp0Vcr7oX3N8I8Y0bxFqSaVKgWrq4sFigvJM26rtlr1ygjk12RV6wa0G+U0a8HptbmfvT+o8uGfYXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472383; c=relaxed/simple;
	bh=QJ8bBiB0TNfNk0b7S8iqqsdJNlv6hTYREgTmT9PjSqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZEas2iqW7wFFVrJXgy920jgrxOYzx3hUBX5pZxBjf4HygE8/7CpUzyQg2bME0QZeRBZWw7jBufpTa5mbkIuw3fnNKbepmtzVmYpZ7w6GvHhgZlI3Dtx3uBNphXkRt+5AIjmsvHNEljZAfbJb0vZ8i6x1y9Zf+dioFiMXSw/ulM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jtrOoYcH; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jtrOoYcH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al0FbHUHW/Bq0zPogMgJpJ+D4JQ9dWOP2Ig5BNuax8k=;
	b=jtrOoYcHrlsgmuSXrODlsZUlvI7OH9IVux2y0dhFyfVImboZEftHtFxKQazHK+O2gE9hSi
	Q2g4oWg2wAmA772C+OWAXj+wJRHj5k1opQtecmnd5l0SV+9lffomnbcGsOr/wmsD8ZFub0
	D6gnnEC9479Tf7rRhFmcnhPNQFEXVXI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/18] bcachefs: Rework bch2_check_lru_key()
Date: Thu, 13 Feb 2025 13:45:49 -0500
Message-ID: <20250213184607.18237-5-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It's now easier to add new LRU types.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/lru.c | 77 +++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 30 deletions(-)

diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index dc6b9a80a8b5..98ab8496f29d 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -116,49 +116,67 @@ int bch2_lru_check_set(struct btree_trans *trans,
 	return ret;
 }
 
+static struct bbpos lru_pos_to_bp(struct bkey_s_c lru_k)
+{
+	enum bch_lru_type type = lru_type(lru_k);
+
+	switch (type) {
+	case BCH_LRU_read:
+	case BCH_LRU_fragmentation:
+		return BBPOS(BTREE_ID_alloc, u64_to_bucket(lru_k.k->p.offset));
+	default:
+		BUG();
+	}
+}
+
+static u64 bkey_lru_type_idx(struct bch_fs *c,
+			     enum bch_lru_type type,
+			     struct bkey_s_c k)
+{
+	struct bch_alloc_v4 a_convert;
+	const struct bch_alloc_v4 *a;
+
+	switch (type) {
+	case BCH_LRU_read:
+		a = bch2_alloc_to_v4(k, &a_convert);
+		return alloc_lru_idx_read(*a);
+	case BCH_LRU_fragmentation: {
+		a = bch2_alloc_to_v4(k, &a_convert);
+
+		rcu_read_lock();
+		struct bch_dev *ca = bch2_dev_rcu_noerror(c, k.k->p.inode);
+		u64 idx = ca
+			? alloc_lru_idx_fragmentation(*a, ca)
+			: 0;
+		rcu_read_unlock();
+		return idx;
+	}
+	default:
+		BUG();
+	}
+}
+
 static int bch2_check_lru_key(struct btree_trans *trans,
 			      struct btree_iter *lru_iter,
 			      struct bkey_s_c lru_k,
 			      struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	struct bch_alloc_v4 a_convert;
-	const struct bch_alloc_v4 *a;
 	struct printbuf buf1 = PRINTBUF;
 	struct printbuf buf2 = PRINTBUF;
-	enum bch_lru_type type = lru_type(lru_k);
-	struct bpos alloc_pos = u64_to_bucket(lru_k.k->p.offset);
-	u64 idx;
-	int ret;
-
-	struct bch_dev *ca = bch2_dev_bucket_tryget_noerror(c, alloc_pos);
 
-	if (fsck_err_on(!ca,
-			trans, lru_entry_to_invalid_bucket,
-			"lru key points to nonexistent device:bucket %llu:%llu",
-			alloc_pos.inode, alloc_pos.offset))
-		return bch2_btree_bit_mod_buffered(trans, BTREE_ID_lru, lru_iter->pos, false);
+	struct bbpos bp = lru_pos_to_bp(lru_k);
 
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_alloc, alloc_pos, 0);
-	ret = bkey_err(k);
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, bp.btree, bp.pos, 0);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
-	a = bch2_alloc_to_v4(k, &a_convert);
-
-	switch (type) {
-	case BCH_LRU_read:
-		idx = alloc_lru_idx_read(*a);
-		break;
-	case BCH_LRU_fragmentation:
-		idx = alloc_lru_idx_fragmentation(*a, ca);
-		break;
-	}
+	enum bch_lru_type type = lru_type(lru_k);
+	u64 idx = bkey_lru_type_idx(c, type, k);
 
-	if (lru_k.k->type != KEY_TYPE_set ||
-	    lru_pos_time(lru_k.k->p) != idx) {
+	if (lru_pos_time(lru_k.k->p) != idx) {
 		ret = bch2_btree_write_buffer_maybe_flush(trans, lru_k, last_flushed);
 		if (ret)
 			goto err;
@@ -176,7 +194,6 @@ static int bch2_check_lru_key(struct btree_trans *trans,
 err:
 fsck_err:
 	bch2_trans_iter_exit(trans, &iter);
-	bch2_dev_put(ca);
 	printbuf_exit(&buf2);
 	printbuf_exit(&buf1);
 	return ret;
-- 
2.45.2

