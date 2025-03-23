Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ED83C6BA
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739300; cv=none; b=ArufGY4sDMICdHUcuHoayFdZURy9SHiv1NU3FOgOqR7CLIgK11fJW+QXBcYGSFQNw4eVW+/KbZoYY1yBSKvNCt4WPgGS89YA5oH+9Wa9Y8Zc1sr605Uqg2fhUELW1b9FllVV5Eyz3kp7Ehs4kPdNHJEBfkhC6lwXxlC+sRpyJFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739300; c=relaxed/simple;
	bh=7e4ZAHjx5XcCDkkHSqWMg9qLCxouixYBwOgijysQv/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO0Tm2mnzEWfYrcPh19005mCVfbu0JgYChVXQozfm6qOmmFMNebt5Pc57NFHfhVMziY4UxYyueKMf/DxpOg5Y3FKD/REndYLwH7kN9ycAu1szop/DRkNg95qAA0uep8MbEpBDlZRUHtoepBb0YogrLWxHtV9FTmM2ELldDF8Two=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dpOYhY2a; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dpOYhY2a"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AjqoBVU/LpCeNbhDF+GuZPrZ427cH4CERjzLAxVwr4=;
	b=dpOYhY2a0QXj94RwPSzza0QIWzu0L8n4DJy8TN3KAislHTrsnEKzY1dHfp+abrpwdiHpy5
	PqicsVvZHuZm1NsgmysPGXm4fRTyOx4nQVW+h6bnA3s4j7osjYa1JJeiPwkT1a8w7YZIWZ
	wNnq0cbIV6PYXupySXGIgVHjR5YRix0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/8] bcachefs: bch2_bucket_alloc_trans() takes alloc_request
Date: Sun, 23 Mar 2025 10:14:42 -0400
Message-ID: <20250323141445.566595-9-kent.overstreet@linux.dev>
In-Reply-To: <20250323141445.566595-1-kent.overstreet@linux.dev>
References: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 37 +++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 7de52cabbef3..598b32b1f281 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -514,24 +514,23 @@ static noinline void trace_bucket_alloc2(struct bch_fs *c, struct bch_dev *ca,
  * Returns:	an open_bucket on success, or an ERR_PTR() on failure.
  */
 static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
-				      struct bch_dev *ca,
-				      enum bch_watermark watermark,
-				      enum bch_data_type data_type,
-				      struct closure *cl,
-				      bool nowait,
-				      struct bch_dev_usage *usage)
+						   struct alloc_request *req,
+						   struct bch_dev *ca,
+						   struct closure *cl,
+						   bool nowait,
+						   struct bch_dev_usage *usage)
 {
 	struct bch_fs *c = trans->c;
 	struct open_bucket *ob = NULL;
 	bool freespace = READ_ONCE(ca->mi.freespace_initialized);
 	u64 avail;
 	struct bucket_alloc_state s = {
-		.btree_bitmap = data_type == BCH_DATA_btree,
+		.btree_bitmap = req->data_type == BCH_DATA_btree,
 	};
 	bool waiting = nowait;
 again:
 	bch2_dev_usage_read_fast(ca, usage);
-	avail = dev_buckets_free(ca, *usage, watermark);
+	avail = dev_buckets_free(ca, *usage, req->watermark);
 
 	if (usage->d[BCH_DATA_need_discard].buckets > avail)
 		bch2_dev_do_discards(ca);
@@ -543,7 +542,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		bch2_dev_do_invalidates(ca);
 
 	if (!avail) {
-		if (watermark > BCH_WATERMARK_normal &&
+		if (req->watermark > BCH_WATERMARK_normal &&
 		    c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations)
 			goto alloc;
 
@@ -563,8 +562,8 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		closure_wake_up(&c->freelist_wait);
 alloc:
 	ob = likely(freespace)
-		? bch2_bucket_alloc_freelist(trans, ca, watermark, &s, cl)
-		: bch2_bucket_alloc_early(trans, ca, watermark, &s, cl);
+		? bch2_bucket_alloc_freelist(trans, ca, req->watermark, &s, cl)
+		: bch2_bucket_alloc_early(trans, ca, req->watermark, &s, cl);
 
 	if (s.need_journal_commit * 2 > avail)
 		bch2_journal_flush_async(&c->journal, NULL);
@@ -583,7 +582,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		ob = ERR_PTR(-BCH_ERR_no_buckets_found);
 
 	if (!IS_ERR(ob))
-		ob->data_type = data_type;
+		ob->data_type = req->data_type;
 
 	if (!IS_ERR(ob))
 		count_event(c, bucket_alloc);
@@ -593,7 +592,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 	if (!IS_ERR(ob)
 	    ? trace_bucket_alloc_enabled()
 	    : trace_bucket_alloc_fail_enabled())
-		trace_bucket_alloc2(c, ca, watermark, data_type, cl, usage, &s, ob);
+		trace_bucket_alloc2(c, ca, req->watermark, req->data_type, cl, usage, &s, ob);
 
 	return ob;
 }
@@ -605,10 +604,13 @@ struct open_bucket *bch2_bucket_alloc(struct bch_fs *c, struct bch_dev *ca,
 {
 	struct bch_dev_usage usage;
 	struct open_bucket *ob;
+	struct alloc_request req = {
+		.watermark	= watermark,
+		.data_type	= data_type,
+	};
 
 	bch2_trans_do(c,
-		      PTR_ERR_OR_ZERO(ob = bch2_bucket_alloc_trans(trans, ca, watermark,
-							data_type, cl, false, &usage)));
+		PTR_ERR_OR_ZERO(ob = bch2_bucket_alloc_trans(trans, &req, ca, cl, false, &usage)));
 	return ob;
 }
 
@@ -708,9 +710,8 @@ int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
 		}
 
 		struct bch_dev_usage usage;
-		struct open_bucket *ob = bch2_bucket_alloc_trans(trans, ca,
-							req->watermark, req->data_type,
-							cl, req->flags & BCH_WRITE_alloc_nowait,
+		struct open_bucket *ob = bch2_bucket_alloc_trans(trans, req, ca, cl,
+							req->flags & BCH_WRITE_alloc_nowait,
 							&usage);
 		if (!IS_ERR(ob))
 			bch2_dev_stripe_increment_inlined(ca, stripe, &usage);
-- 
2.49.0

