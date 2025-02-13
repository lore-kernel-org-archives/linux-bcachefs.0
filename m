Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD8C245AEC
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472389; cv=none; b=aAjaQS3/soJXfj2Lfgzgv3YlpxViX668gaZ/UA5iIhN2z3GsSI6YO88OqGZFG/FRr6RLmy9oh8tfv81w2t8YLbNEOEpGKUaBgSpROfnU7H0Fd+yXok9h1B9oJfXDcGYIN1HNjIsPRLDR7eywVryiui/VI4utRmNmRrOIJX4d0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472389; c=relaxed/simple;
	bh=ciSFDXcZAP03OM0WBPr2YW01zg9OSEY+ScinjIj+Wm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn3iGHPOn1aZpIuXuUTZ4DsNk6IkLeVQhF36FgO5vx1ezbPHppvYFbX+NWHSlnoVxfcKEV8PrAQF8mgeQ77JmL2wdCX2UNYf7H0W7MfXfGtX5WgxQa87WOEJ9YCC5Zk7nYum/gT/Nv1FexWea9uovgYOM/hFPPB29w69aZg12Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GxMFG+o+; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GxMFG+o+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee27cCihh9/228MA7YuER6YsWO1EAVxljm8oBxM4uTs=;
	b=GxMFG+o+XQb4k4Rw1h2JoYLvDKCXGgDH5GFyfEl4lf95qDvHuVyxu+PM3QT4DyAhXYPx1U
	HAwHdxdZ8a8sXseVs0WDBJWg/+aJvNutrojM4Lgya8JYuRmM6UyH8BO4rVlXOTewHO05ii
	ozLCTkvfnpoguNQ4T+7v2KVlAnUwjmo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 13/18] bcachefs: ec_stripe_delete() uses new stripe lru
Date: Thu, 13 Feb 2025 13:45:58 -0500
Message-ID: <20250213184607.18237-14-kent.overstreet@linux.dev>
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
 fs/bcachefs/ec.c | 64 +++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 42 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 1090cdb7d5cc..f9bb835c1d57 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1149,37 +1149,22 @@ void bch2_stripes_heap_update(struct bch_fs *c,
 
 static int ec_stripe_delete(struct btree_trans *trans, u64 idx)
 {
-	struct bch_fs *c = trans->c;
 	struct btree_iter iter;
-	struct bkey_s_c k;
-	struct bkey_s_c_stripe s;
-	int ret;
-
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_stripes, POS(0, idx),
-			       BTREE_ITER_intent);
-	ret = bkey_err(k);
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter,
+					       BTREE_ID_stripes, POS(0, idx),
+					       BTREE_ITER_intent);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
-	if (k.k->type != KEY_TYPE_stripe) {
-		bch2_fs_inconsistent(c, "attempting to delete nonexistent stripe %llu", idx);
-		ret = -EINVAL;
-		goto err;
-	}
-
-	s = bkey_s_c_to_stripe(k);
-	for (unsigned i = 0; i < s.v->nr_blocks; i++)
-		if (stripe_blockcount_get(s.v, i)) {
-			struct printbuf buf = PRINTBUF;
-
-			bch2_bkey_val_to_text(&buf, c, k);
-			bch2_fs_inconsistent(c, "attempting to delete nonempty stripe %s", buf.buf);
-			printbuf_exit(&buf);
-			ret = -EINVAL;
-			goto err;
-		}
-
-	ret = bch2_btree_delete_at(trans, &iter, 0);
+	/*
+	 * We expect write buffer races here
+	 * Important: check stripe_is_open with stripe key locked:
+	 */
+	if (k.k->type == KEY_TYPE_stripe &&
+	    !bch2_stripe_is_open(trans->c, idx) &&
+	    stripe_lru_pos(bkey_s_c_to_stripe(k).v) == 1)
+		ret = bch2_btree_delete_at(trans, &iter, 0);
 err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -1194,21 +1179,16 @@ static void ec_stripe_delete_work(struct work_struct *work)
 	struct bch_fs *c =
 		container_of(work, struct bch_fs, ec_stripe_delete_work);
 
-	while (1) {
-		mutex_lock(&c->ec_stripes_heap_lock);
-		u64 idx = stripe_idx_to_delete(c);
-		mutex_unlock(&c->ec_stripes_heap_lock);
-
-		if (!idx)
-			break;
-
-		int ret = bch2_trans_commit_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-					ec_stripe_delete(trans, idx));
-		bch_err_fn(c, ret);
-		if (ret)
-			break;
-	}
-
+	bch2_trans_run(c,
+		bch2_btree_write_buffer_tryflush(trans) ?:
+		for_each_btree_key_max_commit(trans, lru_iter, BTREE_ID_lru,
+				lru_pos(BCH_LRU_STRIPE_FRAGMENTATION, 1, 0),
+				lru_pos(BCH_LRU_STRIPE_FRAGMENTATION, 1, LRU_TIME_MAX),
+				0, lru_k,
+				NULL, NULL,
+				BCH_TRANS_COMMIT_no_enospc, ({
+			ec_stripe_delete(trans, lru_k.k->p.offset);
+		})));
 	bch2_write_ref_put(c, BCH_WRITE_REF_stripe_delete);
 }
 
-- 
2.45.2

