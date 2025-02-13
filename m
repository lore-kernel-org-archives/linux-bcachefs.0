Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35A524A041
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472389; cv=none; b=bcCg0uLB87aBKj1ry72mYKccmEGtMSa883VvaC9RjfLfb6pJ2WUq4dzforboAjAk5ehH/xxalzjhV2DOyPPyzCLyUr4oIrUU3KKzlnwb8beIxFeFjpkWjc3KS5+lgbePcm6kms5ZbEhdUAeiozWyfypkD32iBOmUDiyZJG0/04A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472389; c=relaxed/simple;
	bh=BD7Rc6K+QawUehC4No6C0+L+U30lLbXtskUg28zBdD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZlLnNkg1djGUaJVL30YaFwREA9nZgeSnVsXxqkAN2SslxM3TJtBU9IBRB+JjSs5i8tyFGzpd+QDGwk5yOXUfoyMx1uPp7NGoEMhsNfvtBl071clELl5sEhogbxu5uMgCA9ueH0jK+2Sn/Z9kTX5zD8BjrZgwHFYrX/Wyxs6+fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zj4gEBJP; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zj4gEBJP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5GsUia0TBbgARPCyvyy3dFoSlrvUD71KM9IiQXLgOSY=;
	b=Zj4gEBJPVHPF1nhWZYCbtWh4ap3YtT3M6GOX6i6yyhnnWVr7B85Dr3s8iQO1EQltIZelIO
	TfNGaIOBo7jRdR8d2Yn3h9WeAg7acgbVkHvmVKfg4hhlbrsNXxNo6qP/T++z/Y71+1wZ9a
	et5XZyl24uBkZWFq1VJQuE70+/nWK+8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 14/18] bcachefs: get_existing_stripe() uses new stripe lru
Date: Thu, 13 Feb 2025 13:45:59 -0500
Message-ID: <20250213184607.18237-15-kent.overstreet@linux.dev>
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

Convert to the new persistent stripe LRU.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c | 88 ++++++++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 37 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index f9bb835c1d57..bd47b8f0f705 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1978,39 +1978,44 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 	return 0;
 }
 
-static s64 get_existing_stripe(struct bch_fs *c,
-			       struct ec_stripe_head *head)
+static int __get_existing_stripe(struct btree_trans *trans,
+				 struct ec_stripe_head *head,
+				 struct ec_stripe_buf *stripe,
+				 u64 idx)
 {
-	ec_stripes_heap *h = &c->ec_stripes_heap;
-	struct stripe *m;
-	size_t heap_idx;
-	u64 stripe_idx;
-	s64 ret = -1;
+	struct bch_fs *c = trans->c;
 
-	if (may_create_new_stripe(c))
-		return -1;
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter,
+					  BTREE_ID_stripes, POS(0, idx), 0);
+	int ret = bkey_err(k);
+	if (ret)
+		goto err;
 
-	mutex_lock(&c->ec_stripes_heap_lock);
-	for (heap_idx = 0; heap_idx < h->nr; heap_idx++) {
-		/* No blocks worth reusing, stripe will just be deleted: */
-		if (!h->data[heap_idx].blocks_nonempty)
-			continue;
+	/* We expect write buffer races here */
+	if (k.k->type != KEY_TYPE_stripe)
+		goto out;
 
-		stripe_idx = h->data[heap_idx].idx;
+	struct bkey_s_c_stripe s = bkey_s_c_to_stripe(k);
+	if (stripe_lru_pos(s.v) == 1)
+		goto out;
 
-		m = genradix_ptr(&c->stripes, stripe_idx);
+	unsigned blocks_nonempty = 0;
+	for (unsigned i = 0; i < s.v->nr_blocks; i++)
+		blocks_nonempty	+= !!stripe_blockcount_get(s.v, i);
 
-		if (m->disk_label	== head->disk_label &&
-		    m->algorithm	== head->algo &&
-		    m->nr_redundant	== head->redundancy &&
-		    m->sectors		== head->blocksize &&
-		    m->blocks_nonempty	< m->nr_blocks - m->nr_redundant &&
-		    bch2_try_open_stripe(c, head->s, stripe_idx)) {
-			ret = stripe_idx;
-			break;
-		}
+	if (s.v->disk_label	== head->disk_label &&
+	    s.v->algorithm	== head->algo &&
+	    s.v->nr_redundant	== head->redundancy &&
+	    s.v->sectors	== head->blocksize &&
+	    bch2_try_open_stripe(c, head->s, idx)) {
+		bkey_reassemble(&stripe->key, k);
+		ret = 1;
 	}
-	mutex_unlock(&c->ec_stripes_heap_lock);
+out:
+	bch2_set_btree_iter_dontneed(&iter);
+err:
+	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
 
@@ -2062,24 +2067,33 @@ static int __bch2_ec_stripe_head_reuse(struct btree_trans *trans, struct ec_stri
 				       struct ec_stripe_new *s)
 {
 	struct bch_fs *c = trans->c;
-	s64 idx;
-	int ret;
 
 	/*
 	 * If we can't allocate a new stripe, and there's no stripes with empty
 	 * blocks for us to reuse, that means we have to wait on copygc:
 	 */
-	idx = get_existing_stripe(c, h);
-	if (idx < 0)
-		return -BCH_ERR_stripe_alloc_blocked;
+	if (may_create_new_stripe(c))
+		return -1;
 
-	ret = get_stripe_key_trans(trans, idx, &s->existing_stripe);
-	bch2_fs_fatal_err_on(ret && !bch2_err_matches(ret, BCH_ERR_transaction_restart), c,
-			     "reading stripe key: %s", bch2_err_str(ret));
-	if (ret) {
-		bch2_stripe_close(c, s);
-		return ret;
+	struct btree_iter lru_iter;
+	struct bkey_s_c lru_k;
+	int ret = 0;
+
+	for_each_btree_key_max_norestart(trans, lru_iter, BTREE_ID_lru,
+			lru_pos(BCH_LRU_STRIPE_FRAGMENTATION, 2, 0),
+			lru_pos(BCH_LRU_STRIPE_FRAGMENTATION, 2, LRU_TIME_MAX),
+			0, lru_k, ret) {
+		ret = __get_existing_stripe(trans, h, &s->existing_stripe, lru_k.k->p.offset);
+		if (ret)
+			break;
 	}
+	bch2_trans_iter_exit(trans, &lru_iter);
+	if (!ret)
+		ret = -BCH_ERR_stripe_alloc_blocked;
+	if (ret == 1)
+		ret = 0;
+	if (ret)
+		return ret;
 
 	return init_new_stripe_from_existing(c, s);
 }
-- 
2.45.2

