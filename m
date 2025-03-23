Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B67761FFE
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739300; cv=none; b=WkC1WhaEeSmBbrz/cjxZftvYTX4evTjhmrqY2fmWLKkwHukF23qw8ZYaq5ozK3z5GzWc8MGj956nwNX0CZ89ySaX6UnrEwvM8LOxxBSojnAqGtfxv2r1SZmE3RcYKSf/vviycWFZ4AfHy1FHtlTF+AQC52M/yZzbPB9vcuxBSuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739300; c=relaxed/simple;
	bh=4073Zcltbb90lwK1CSexF4dbHeshJIeOh1ytIwNUb/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFN6n6SokqkUu6fmfQkN77x7jyNbsdLwti4mGuKbdoK4uPwaKX+dnzWKnhn+YOH0JwB0KYwLt834fOKaHxA6+hse74ztP0SrNyqypPXnM90vp/UOMu8kMIFHWfdbrYEKbRyrck8/x6Noi6FhUP0ovuDLcVtMmAq5W5WJ5iIvgWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ht1BfG3h; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ht1BfG3h"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E23E6HkQ6oBnrlfBAwuH4jdmx55lUBuSEfGzk95DQFE=;
	b=Ht1BfG3hOk8tiF3UCPG/ZH3Yl2A1MFqAopUIv/YdMfWoEm5Bl9dcPbze0mp53rD40aoQCc
	5rXjqaHcoKdB7B+YHUP3qiOGGEdQ+QHl+Hp6li4dnxhzfbCW6MhAz4yMa5tmAaGCX5UGKn
	cB9AOXbWE//etyVmSsSe0SMJ6COfzjI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/8] bcachefs: struct alloc_request
Date: Sun, 23 Mar 2025 10:14:40 -0400
Message-ID: <20250323141445.566595-7-kent.overstreet@linux.dev>
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

Add a struct for common state for satisfying an on disk allocation,
instead of passing the same long list of items to every function.

This will help with stack usage, performance, and perhaps enable some
code cleanups.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 286 ++++++++++++---------------------
 fs/bcachefs/alloc_foreground.h |  25 ++-
 fs/bcachefs/ec.c               |  46 +++---
 fs/bcachefs/io_write.h         |  28 ----
 fs/bcachefs/io_write_types.h   |  28 ++++
 5 files changed, 176 insertions(+), 237 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 8f96f3231214..ecbf25888806 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -666,24 +666,20 @@ void bch2_dev_stripe_increment(struct bch_dev *ca,
 }
 
 static int add_new_bucket(struct bch_fs *c,
-			   struct open_buckets *ptrs,
-			   struct bch_devs_mask *devs_may_alloc,
-			   unsigned nr_replicas,
-			   unsigned *nr_effective,
-			   bool *have_cache,
-			   struct open_bucket *ob)
+			  struct alloc_request *req,
+			  struct open_bucket *ob)
 {
 	unsigned durability = ob_dev(c, ob)->mi.durability;
 
-	BUG_ON(*nr_effective >= nr_replicas);
+	BUG_ON(req->nr_effective >= req->nr_replicas);
 
-	__clear_bit(ob->dev, devs_may_alloc->d);
-	*nr_effective	+= durability;
-	*have_cache	|= !durability;
+	__clear_bit(ob->dev, req->devs_may_alloc.d);
+	req->nr_effective	+= durability;
+	req->have_cache	|= !durability;
 
-	ob_push(c, ptrs, ob);
+	ob_push(c, &req->ptrs, ob);
 
-	if (*nr_effective >= nr_replicas)
+	if (req->nr_effective >= req->nr_replicas)
 		return 1;
 	if (ob->ec)
 		return 1;
@@ -691,36 +687,32 @@ static int add_new_bucket(struct bch_fs *c,
 }
 
 int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
-		      struct open_buckets *ptrs,
-		      struct dev_stripe_state *stripe,
-		      struct bch_devs_mask *devs_may_alloc,
-		      unsigned nr_replicas,
-		      unsigned *nr_effective,
-		      bool *have_cache,
-		      enum bch_write_flags flags,
-		      enum bch_data_type data_type,
-		      enum bch_watermark watermark,
-		      struct closure *cl)
+				struct alloc_request *req,
+				struct dev_stripe_state *stripe,
+				enum bch_data_type data_type,
+				struct closure *cl)
 {
 	struct bch_fs *c = trans->c;
 	int ret = -BCH_ERR_insufficient_devices;
 
-	BUG_ON(*nr_effective >= nr_replicas);
+	BUG_ON(req->nr_effective >= req->nr_replicas);
 
-	struct dev_alloc_list devs_sorted = bch2_dev_alloc_list(c, stripe, devs_may_alloc);
+	struct dev_alloc_list devs_sorted = bch2_dev_alloc_list(c, stripe, &req->devs_may_alloc);
 	darray_for_each(devs_sorted, i) {
 		struct bch_dev *ca = bch2_dev_tryget_noerror(c, *i);
 		if (!ca)
 			continue;
 
-		if (!ca->mi.durability && *have_cache) {
+		if (!ca->mi.durability && req->have_cache) {
 			bch2_dev_put(ca);
 			continue;
 		}
 
 		struct bch_dev_usage usage;
-		struct open_bucket *ob = bch2_bucket_alloc_trans(trans, ca, watermark, data_type,
-						     cl, flags & BCH_WRITE_alloc_nowait, &usage);
+		struct open_bucket *ob = bch2_bucket_alloc_trans(trans, ca,
+							req->watermark, data_type,
+							cl, req->flags & BCH_WRITE_alloc_nowait,
+							&usage);
 		if (!IS_ERR(ob))
 			bch2_dev_stripe_increment_inlined(ca, stripe, &usage);
 		bch2_dev_put(ca);
@@ -732,9 +724,7 @@ int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
 			continue;
 		}
 
-		if (add_new_bucket(c, ptrs, devs_may_alloc,
-				   nr_replicas, nr_effective,
-				   have_cache, ob)) {
+		if (add_new_bucket(c, req, ob)) {
 			ret = 0;
 			break;
 		}
@@ -752,34 +742,27 @@ int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
  */
 
 static int bucket_alloc_from_stripe(struct btree_trans *trans,
-			 struct open_buckets *ptrs,
-			 struct write_point *wp,
-			 struct bch_devs_mask *devs_may_alloc,
-			 u16 target,
-			 unsigned nr_replicas,
-			 unsigned *nr_effective,
-			 bool *have_cache,
-			 enum bch_watermark watermark,
-			 enum bch_write_flags flags,
-			 struct closure *cl)
+				    struct alloc_request *req,
+				    struct closure *cl)
 {
 	struct bch_fs *c = trans->c;
 	int ret = 0;
 
-	if (nr_replicas < 2)
+	if (req->nr_replicas < 2)
 		return 0;
 
-	if (ec_open_bucket(c, ptrs))
+	if (ec_open_bucket(c, &req->ptrs))
 		return 0;
 
 	struct ec_stripe_head *h =
-		bch2_ec_stripe_head_get(trans, target, 0, nr_replicas - 1, watermark, cl);
+		bch2_ec_stripe_head_get(trans, req->target, 0, req->nr_replicas - 1, req->watermark, cl);
 	if (IS_ERR(h))
 		return PTR_ERR(h);
 	if (!h)
 		return 0;
 
-	struct dev_alloc_list devs_sorted = bch2_dev_alloc_list(c, &wp->stripe, devs_may_alloc);
+	struct dev_alloc_list devs_sorted =
+		bch2_dev_alloc_list(c, &req->wp->stripe, &req->devs_may_alloc);
 	darray_for_each(devs_sorted, i)
 		for (unsigned ec_idx = 0; ec_idx < h->s->nr_data; ec_idx++) {
 			if (!h->s->blocks[ec_idx])
@@ -791,9 +774,7 @@ static int bucket_alloc_from_stripe(struct btree_trans *trans,
 				ob->ec		= h->s;
 				ec_stripe_new_get(h->s, STRIPE_REF_io);
 
-				ret = add_new_bucket(c, ptrs, devs_may_alloc,
-						     nr_replicas, nr_effective,
-						     have_cache, ob);
+				ret = add_new_bucket(c, req, ob);
 				goto out;
 			}
 		}
@@ -805,65 +786,48 @@ static int bucket_alloc_from_stripe(struct btree_trans *trans,
 /* Sector allocator */
 
 static bool want_bucket(struct bch_fs *c,
-			struct write_point *wp,
-			struct bch_devs_mask *devs_may_alloc,
-			bool *have_cache, bool ec,
+			struct alloc_request *req,
 			struct open_bucket *ob)
 {
 	struct bch_dev *ca = ob_dev(c, ob);
 
-	if (!test_bit(ob->dev, devs_may_alloc->d))
+	if (!test_bit(ob->dev, req->devs_may_alloc.d))
 		return false;
 
-	if (ob->data_type != wp->data_type)
+	if (ob->data_type != req->wp->data_type)
 		return false;
 
 	if (!ca->mi.durability &&
-	    (wp->data_type == BCH_DATA_btree || ec || *have_cache))
+	    (req->wp->data_type == BCH_DATA_btree || req->ec || req->have_cache))
 		return false;
 
-	if (ec != (ob->ec != NULL))
+	if (req->ec != (ob->ec != NULL))
 		return false;
 
 	return true;
 }
 
 static int bucket_alloc_set_writepoint(struct bch_fs *c,
-				       struct open_buckets *ptrs,
-				       struct write_point *wp,
-				       struct bch_devs_mask *devs_may_alloc,
-				       unsigned nr_replicas,
-				       unsigned *nr_effective,
-				       bool *have_cache,
-				       bool ec)
+				       struct alloc_request *req)
 {
 	struct open_buckets ptrs_skip = { .nr = 0 };
 	struct open_bucket *ob;
 	unsigned i;
 	int ret = 0;
 
-	open_bucket_for_each(c, &wp->ptrs, ob, i) {
-		if (!ret && want_bucket(c, wp, devs_may_alloc,
-					have_cache, ec, ob))
-			ret = add_new_bucket(c, ptrs, devs_may_alloc,
-				       nr_replicas, nr_effective,
-				       have_cache, ob);
+	open_bucket_for_each(c, &req->wp->ptrs, ob, i) {
+		if (!ret && want_bucket(c, req, ob))
+			ret = add_new_bucket(c, req, ob);
 		else
 			ob_push(c, &ptrs_skip, ob);
 	}
-	wp->ptrs = ptrs_skip;
+	req->wp->ptrs = ptrs_skip;
 
 	return ret;
 }
 
 static int bucket_alloc_set_partial(struct bch_fs *c,
-				    struct open_buckets *ptrs,
-				    struct write_point *wp,
-				    struct bch_devs_mask *devs_may_alloc,
-				    unsigned nr_replicas,
-				    unsigned *nr_effective,
-				    bool *have_cache, bool ec,
-				    enum bch_watermark watermark)
+				    struct alloc_request *req)
 {
 	int i, ret = 0;
 
@@ -878,13 +842,13 @@ static int bucket_alloc_set_partial(struct bch_fs *c,
 	for (i = c->open_buckets_partial_nr - 1; i >= 0; --i) {
 		struct open_bucket *ob = c->open_buckets + c->open_buckets_partial[i];
 
-		if (want_bucket(c, wp, devs_may_alloc, have_cache, ec, ob)) {
+		if (want_bucket(c, req, ob)) {
 			struct bch_dev *ca = ob_dev(c, ob);
 			struct bch_dev_usage usage;
 			u64 avail;
 
 			bch2_dev_usage_read_fast(ca, &usage);
-			avail = dev_buckets_free(ca, usage, watermark) + ca->nr_partial_buckets;
+			avail = dev_buckets_free(ca, usage, req->watermark) + ca->nr_partial_buckets;
 			if (!avail)
 				continue;
 
@@ -897,9 +861,7 @@ static int bucket_alloc_set_partial(struct bch_fs *c,
 			bch2_dev_rcu(c, ob->dev)->nr_partial_buckets--;
 			rcu_read_unlock();
 
-			ret = add_new_bucket(c, ptrs, devs_may_alloc,
-					     nr_replicas, nr_effective,
-					     have_cache, ob);
+			ret = add_new_bucket(c, req, ob);
 			if (ret)
 				break;
 		}
@@ -910,61 +872,42 @@ static int bucket_alloc_set_partial(struct bch_fs *c,
 }
 
 static int __open_bucket_add_buckets(struct btree_trans *trans,
-			struct open_buckets *ptrs,
-			struct write_point *wp,
-			struct bch_devs_list *devs_have,
-			u16 target,
-			bool erasure_code,
-			unsigned nr_replicas,
-			unsigned *nr_effective,
-			bool *have_cache,
-			enum bch_watermark watermark,
-			enum bch_write_flags flags,
-			struct closure *_cl)
+				     struct alloc_request *req,
+				     struct closure *_cl)
 {
 	struct bch_fs *c = trans->c;
-	struct bch_devs_mask devs;
 	struct open_bucket *ob;
 	struct closure *cl = NULL;
 	unsigned i;
 	int ret;
 
-	devs = target_rw_devs(c, wp->data_type, target);
+	req->devs_may_alloc = target_rw_devs(c, req->wp->data_type, req->target);
 
 	/* Don't allocate from devices we already have pointers to: */
-	darray_for_each(*devs_have, i)
-		__clear_bit(*i, devs.d);
+	darray_for_each(*req->devs_have, i)
+		__clear_bit(*i, req->devs_may_alloc.d);
 
-	open_bucket_for_each(c, ptrs, ob, i)
-		__clear_bit(ob->dev, devs.d);
+	open_bucket_for_each(c, &req->ptrs, ob, i)
+		__clear_bit(ob->dev, req->devs_may_alloc.d);
 
-	ret = bucket_alloc_set_writepoint(c, ptrs, wp, &devs,
-				 nr_replicas, nr_effective,
-				 have_cache, erasure_code);
+	ret = bucket_alloc_set_writepoint(c, req);
 	if (ret)
 		return ret;
 
-	ret = bucket_alloc_set_partial(c, ptrs, wp, &devs,
-				 nr_replicas, nr_effective,
-				 have_cache, erasure_code, watermark);
+	ret = bucket_alloc_set_partial(c, req);
 	if (ret)
 		return ret;
 
-	if (erasure_code) {
-		ret = bucket_alloc_from_stripe(trans, ptrs, wp, &devs,
-					 target,
-					 nr_replicas, nr_effective,
-					 have_cache,
-					 watermark, flags, _cl);
+	if (req->ec) {
+		ret = bucket_alloc_from_stripe(trans, req, _cl);
 	} else {
 retry_blocking:
 		/*
 		 * Try nonblocking first, so that if one device is full we'll try from
 		 * other devices:
 		 */
-		ret = bch2_bucket_alloc_set_trans(trans, ptrs, &wp->stripe, &devs,
-					nr_replicas, nr_effective, have_cache,
-					flags, wp->data_type, watermark, cl);
+		ret = bch2_bucket_alloc_set_trans(trans, req, &req->wp->stripe,
+						  req->wp->data_type, cl);
 		if (ret &&
 		    !bch2_err_matches(ret, BCH_ERR_transaction_restart) &&
 		    !bch2_err_matches(ret, BCH_ERR_insufficient_devices) &&
@@ -978,38 +921,27 @@ static int __open_bucket_add_buckets(struct btree_trans *trans,
 }
 
 static int open_bucket_add_buckets(struct btree_trans *trans,
-			struct open_buckets *ptrs,
-			struct write_point *wp,
-			struct bch_devs_list *devs_have,
-			u16 target,
-			unsigned erasure_code,
-			unsigned nr_replicas,
-			unsigned *nr_effective,
-			bool *have_cache,
-			enum bch_watermark watermark,
-			enum bch_write_flags flags,
-			struct closure *cl)
+				   struct alloc_request *req,
+				   struct closure *cl)
 {
 	int ret;
 
-	if (erasure_code && !ec_open_bucket(trans->c, ptrs)) {
-		ret = __open_bucket_add_buckets(trans, ptrs, wp,
-				devs_have, target, erasure_code,
-				nr_replicas, nr_effective, have_cache,
-				watermark, flags, cl);
+	if (req->ec && !ec_open_bucket(trans->c, &req->ptrs)) {
+		ret = __open_bucket_add_buckets(trans, req, cl);
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart) ||
 		    bch2_err_matches(ret, BCH_ERR_operation_blocked) ||
 		    bch2_err_matches(ret, BCH_ERR_freelist_empty) ||
 		    bch2_err_matches(ret, BCH_ERR_open_buckets_empty))
 			return ret;
-		if (*nr_effective >= nr_replicas)
+		if (req->nr_effective >= req->nr_replicas)
 			return 0;
 	}
 
-	ret = __open_bucket_add_buckets(trans, ptrs, wp,
-			devs_have, target, false,
-			nr_replicas, nr_effective, have_cache,
-			watermark, flags, cl);
+	bool ec = false;
+	swap(ec, req->ec);
+	ret = __open_bucket_add_buckets(trans, req, cl);
+	swap(ec, req->ec);
+
 	return ret < 0 ? ret : 0;
 }
 
@@ -1300,51 +1232,49 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 			     struct write_point **wp_ret)
 {
 	struct bch_fs *c = trans->c;
-	struct write_point *wp;
 	struct open_bucket *ob;
-	struct open_buckets ptrs;
-	unsigned nr_effective, write_points_nr;
-	bool have_cache;
+	unsigned write_points_nr;
 	int ret;
 	int i;
 
+	struct alloc_request req = {
+		.nr_replicas	= nr_replicas,
+		.target		= target,
+		.ec		= erasure_code,
+		.watermark	= watermark,
+		.flags		= flags,
+		.devs_have	= devs_have,
+	};
+
 	if (!IS_ENABLED(CONFIG_BCACHEFS_ERASURE_CODING))
 		erasure_code = false;
 
 	BUG_ON(!nr_replicas || !nr_replicas_required);
 retry:
-	ptrs.nr		= 0;
-	nr_effective	= 0;
-	write_points_nr = c->write_points_nr;
-	have_cache	= false;
+	req.ptrs.nr		= 0;
+	req.nr_effective	= 0;
+	req.have_cache		= false;
+	write_points_nr		= c->write_points_nr;
 
-	*wp_ret = wp = writepoint_find(trans, write_point.v);
+	*wp_ret = req.wp = writepoint_find(trans, write_point.v);
 
 	ret = bch2_trans_relock(trans);
 	if (ret)
 		goto err;
 
 	/* metadata may not allocate on cache devices: */
-	if (wp->data_type != BCH_DATA_user)
-		have_cache = true;
+	if (req.wp->data_type != BCH_DATA_user)
+		req.have_cache = true;
 
 	if (target && !(flags & BCH_WRITE_only_specified_devs)) {
-		ret = open_bucket_add_buckets(trans, &ptrs, wp, devs_have,
-					      target, erasure_code,
-					      nr_replicas, &nr_effective,
-					      &have_cache, watermark,
-					      flags, NULL);
+		ret = open_bucket_add_buckets(trans, &req, NULL);
 		if (!ret ||
 		    bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			goto alloc_done;
 
 		/* Don't retry from all devices if we're out of open buckets: */
 		if (bch2_err_matches(ret, BCH_ERR_open_buckets_empty)) {
-			int ret2 = open_bucket_add_buckets(trans, &ptrs, wp, devs_have,
-					      target, erasure_code,
-					      nr_replicas, &nr_effective,
-					      &have_cache, watermark,
-					      flags, cl);
+			int ret2 = open_bucket_add_buckets(trans, &req, cl);
 			if (!ret2 ||
 			    bch2_err_matches(ret2, BCH_ERR_transaction_restart) ||
 			    bch2_err_matches(ret2, BCH_ERR_open_buckets_empty)) {
@@ -1357,59 +1287,53 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 		 * Only try to allocate cache (durability = 0 devices) from the
 		 * specified target:
 		 */
-		have_cache = true;
+		req.have_cache	= true;
+		req.target	= 0;
 
-		ret = open_bucket_add_buckets(trans, &ptrs, wp, devs_have,
-					      0, erasure_code,
-					      nr_replicas, &nr_effective,
-					      &have_cache, watermark,
-					      flags, cl);
+		ret = open_bucket_add_buckets(trans, &req, cl);
 	} else {
-		ret = open_bucket_add_buckets(trans, &ptrs, wp, devs_have,
-					      target, erasure_code,
-					      nr_replicas, &nr_effective,
-					      &have_cache, watermark,
-					      flags, cl);
+		ret = open_bucket_add_buckets(trans, &req, cl);
 	}
 alloc_done:
-	BUG_ON(!ret && nr_effective < nr_replicas);
+	BUG_ON(!ret && req.nr_effective < req.nr_replicas);
 
-	if (erasure_code && !ec_open_bucket(c, &ptrs))
+	if (erasure_code && !ec_open_bucket(c, &req.ptrs))
 		pr_debug("failed to get ec bucket: ret %u", ret);
 
 	if (ret == -BCH_ERR_insufficient_devices &&
-	    nr_effective >= nr_replicas_required)
+	    req.nr_effective >= nr_replicas_required)
 		ret = 0;
 
 	if (ret)
 		goto err;
 
-	if (nr_effective > nr_replicas)
-		deallocate_extra_replicas(c, &ptrs, &wp->ptrs, nr_effective - nr_replicas);
+	if (req.nr_effective > req.nr_replicas)
+		deallocate_extra_replicas(c, &req.ptrs, &req.wp->ptrs,
+					  req.nr_effective - req.nr_replicas);
 
 	/* Free buckets we didn't use: */
-	open_bucket_for_each(c, &wp->ptrs, ob, i)
+	open_bucket_for_each(c, &req.wp->ptrs, ob, i)
 		open_bucket_free_unused(c, ob);
 
-	wp->ptrs = ptrs;
+	req.wp->ptrs = req.ptrs;
 
-	wp->sectors_free = UINT_MAX;
+	req.wp->sectors_free = UINT_MAX;
 
-	open_bucket_for_each(c, &wp->ptrs, ob, i)
-		wp->sectors_free = min(wp->sectors_free, ob->sectors_free);
+	open_bucket_for_each(c, &req.wp->ptrs, ob, i)
+		req.wp->sectors_free = min(req.wp->sectors_free, ob->sectors_free);
 
-	BUG_ON(!wp->sectors_free || wp->sectors_free == UINT_MAX);
+	BUG_ON(!req.wp->sectors_free || req.wp->sectors_free == UINT_MAX);
 
 	return 0;
 err:
-	open_bucket_for_each(c, &wp->ptrs, ob, i)
-		if (ptrs.nr < ARRAY_SIZE(ptrs.v))
-			ob_push(c, &ptrs, ob);
+	open_bucket_for_each(c, &req.wp->ptrs, ob, i)
+		if (req.ptrs.nr < ARRAY_SIZE(req.ptrs.v))
+			ob_push(c, &req.ptrs, ob);
 		else
 			open_bucket_free_unused(c, ob);
-	wp->ptrs = ptrs;
+	req.wp->ptrs = req.ptrs;
 
-	mutex_unlock(&wp->lock);
+	mutex_unlock(&req.wp->lock);
 
 	if (bch2_err_matches(ret, BCH_ERR_freelist_empty) &&
 	    try_decrease_writepoints(trans, write_points_nr))
diff --git a/fs/bcachefs/alloc_foreground.h b/fs/bcachefs/alloc_foreground.h
index 69ec6a012898..741d81611f92 100644
--- a/fs/bcachefs/alloc_foreground.h
+++ b/fs/bcachefs/alloc_foreground.h
@@ -5,6 +5,7 @@
 #include "bcachefs.h"
 #include "alloc_types.h"
 #include "extents.h"
+#include "io_write_types.h"
 #include "sb-members.h"
 
 #include <linux/hash.h>
@@ -23,6 +24,22 @@ struct dev_alloc_list {
 	u8		data[BCH_SB_MEMBERS_MAX];
 };
 
+struct alloc_request {
+	unsigned		nr_replicas;
+	unsigned		target;
+	bool			ec;
+	enum bch_watermark	watermark;
+	enum bch_write_flags	flags;
+	struct bch_devs_list	*devs_have;
+
+	struct write_point	*wp;
+	struct open_buckets	ptrs;
+	unsigned		nr_effective;
+	bool			have_cache;
+
+	struct bch_devs_mask	devs_may_alloc;
+};
+
 struct dev_alloc_list bch2_dev_alloc_list(struct bch_fs *,
 					  struct dev_stripe_state *,
 					  struct bch_devs_mask *);
@@ -171,11 +188,9 @@ static inline bool bch2_bucket_is_open_safe(struct bch_fs *c, unsigned dev, u64
 }
 
 enum bch_write_flags;
-int bch2_bucket_alloc_set_trans(struct btree_trans *, struct open_buckets *,
-		      struct dev_stripe_state *, struct bch_devs_mask *,
-		      unsigned, unsigned *, bool *, enum bch_write_flags,
-		      enum bch_data_type, enum bch_watermark,
-		      struct closure *);
+int bch2_bucket_alloc_set_trans(struct btree_trans *, struct alloc_request *,
+				struct dev_stripe_state *, enum bch_data_type,
+				struct closure *);
 
 int bch2_alloc_sectors_start_trans(struct btree_trans *,
 				   unsigned, unsigned,
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 16cca83e504e..c2a8781fc154 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1716,19 +1716,23 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 				    enum bch_watermark watermark, struct closure *cl)
 {
 	struct bch_fs *c = trans->c;
-	struct bch_devs_mask devs = h->devs;
 	struct open_bucket *ob;
-	struct open_buckets buckets;
 	struct bch_stripe *v = &bkey_i_to_stripe(&s->new_stripe.key)->v;
 	unsigned i, j, nr_have_parity = 0, nr_have_data = 0;
-	bool have_cache = true;
 	int ret = 0;
 
+	struct alloc_request req = {
+		.watermark	= watermark,
+		.devs_may_alloc	= h->devs,
+		.have_cache	= true,
+	};
+
 	BUG_ON(v->nr_blocks	!= s->nr_data + s->nr_parity);
 	BUG_ON(v->nr_redundant	!= s->nr_parity);
 
 	/* * We bypass the sector allocator which normally does this: */
-	bitmap_and(devs.d, devs.d, c->rw_devs[BCH_DATA_user].d, BCH_SB_MEMBERS_MAX);
+	bitmap_and(req.devs_may_alloc.d, req.devs_may_alloc.d,
+		   c->rw_devs[BCH_DATA_user].d, BCH_SB_MEMBERS_MAX);
 
 	for_each_set_bit(i, s->blocks_gotten, v->nr_blocks) {
 		/*
@@ -1738,7 +1742,7 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 		 * block when updating the stripe
 		 */
 		if (v->ptrs[i].dev != BCH_SB_MEMBER_INVALID)
-			__clear_bit(v->ptrs[i].dev, devs.d);
+			__clear_bit(v->ptrs[i].dev, req.devs_may_alloc.d);
 
 		if (i < s->nr_data)
 			nr_have_data++;
@@ -1749,25 +1753,23 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 	BUG_ON(nr_have_data	> s->nr_data);
 	BUG_ON(nr_have_parity	> s->nr_parity);
 
-	buckets.nr = 0;
+	req.ptrs.nr = 0;
 	if (nr_have_parity < s->nr_parity) {
-		ret = bch2_bucket_alloc_set_trans(trans, &buckets,
+		req.nr_replicas		= s->nr_parity;
+		req.nr_effective	= nr_have_parity;
+
+		ret = bch2_bucket_alloc_set_trans(trans, &req,
 					    &h->parity_stripe,
-					    &devs,
-					    s->nr_parity,
-					    &nr_have_parity,
-					    &have_cache, 0,
 					    BCH_DATA_parity,
-					    watermark,
 					    cl);
 
-		open_bucket_for_each(c, &buckets, ob, i) {
+		open_bucket_for_each(c, &req.ptrs, ob, i) {
 			j = find_next_zero_bit(s->blocks_gotten,
 					       s->nr_data + s->nr_parity,
 					       s->nr_data);
 			BUG_ON(j >= s->nr_data + s->nr_parity);
 
-			s->blocks[j] = buckets.v[i];
+			s->blocks[j] = req.ptrs.v[i];
 			v->ptrs[j] = bch2_ob_ptr(c, ob);
 			__set_bit(j, s->blocks_gotten);
 		}
@@ -1776,24 +1778,22 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 			return ret;
 	}
 
-	buckets.nr = 0;
+	req.ptrs.nr = 0;
 	if (nr_have_data < s->nr_data) {
-		ret = bch2_bucket_alloc_set_trans(trans, &buckets,
+		req.nr_replicas		= s->nr_data;
+		req.nr_effective	= nr_have_data;
+
+		ret = bch2_bucket_alloc_set_trans(trans, &req,
 					    &h->block_stripe,
-					    &devs,
-					    s->nr_data,
-					    &nr_have_data,
-					    &have_cache, 0,
 					    BCH_DATA_user,
-					    watermark,
 					    cl);
 
-		open_bucket_for_each(c, &buckets, ob, i) {
+		open_bucket_for_each(c, &req.ptrs, ob, i) {
 			j = find_next_zero_bit(s->blocks_gotten,
 					       s->nr_data, 0);
 			BUG_ON(j >= s->nr_data);
 
-			s->blocks[j] = buckets.v[i];
+			s->blocks[j] = req.ptrs.v[i];
 			v->ptrs[j] = bch2_ob_ptr(c, ob);
 			__set_bit(j, s->blocks_gotten);
 		}
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index b8ab19a1e1da..2c0a8f35ee1f 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -17,34 +17,6 @@ void bch2_submit_wbio_replicas(struct bch_write_bio *, struct bch_fs *,
 __printf(3, 4)
 void bch2_write_op_error(struct bch_write_op *op, u64, const char *, ...);
 
-#define BCH_WRITE_FLAGS()		\
-	x(alloc_nowait)			\
-	x(cached)			\
-	x(data_encoded)			\
-	x(pages_stable)			\
-	x(pages_owned)			\
-	x(only_specified_devs)		\
-	x(wrote_data_inline)		\
-	x(check_enospc)			\
-	x(sync)				\
-	x(move)				\
-	x(in_worker)			\
-	x(submitted)			\
-	x(io_error)			\
-	x(convert_unwritten)
-
-enum __bch_write_flags {
-#define x(f)	__BCH_WRITE_##f,
-	BCH_WRITE_FLAGS()
-#undef x
-};
-
-enum bch_write_flags {
-#define x(f)	BCH_WRITE_##f = BIT(__BCH_WRITE_##f),
-	BCH_WRITE_FLAGS()
-#undef x
-};
-
 static inline struct workqueue_struct *index_update_wq(struct bch_write_op *op)
 {
 	return op->watermark == BCH_WATERMARK_copygc
diff --git a/fs/bcachefs/io_write_types.h b/fs/bcachefs/io_write_types.h
index 3ef6df9145ef..b4a6a44a45d0 100644
--- a/fs/bcachefs/io_write_types.h
+++ b/fs/bcachefs/io_write_types.h
@@ -13,6 +13,34 @@
 #include <linux/llist.h>
 #include <linux/workqueue.h>
 
+#define BCH_WRITE_FLAGS()		\
+	x(alloc_nowait)			\
+	x(cached)			\
+	x(data_encoded)			\
+	x(pages_stable)			\
+	x(pages_owned)			\
+	x(only_specified_devs)		\
+	x(wrote_data_inline)		\
+	x(check_enospc)			\
+	x(sync)				\
+	x(move)				\
+	x(in_worker)			\
+	x(submitted)			\
+	x(io_error)			\
+	x(convert_unwritten)
+
+enum __bch_write_flags {
+#define x(f)	__BCH_WRITE_##f,
+	BCH_WRITE_FLAGS()
+#undef x
+};
+
+enum bch_write_flags {
+#define x(f)	BCH_WRITE_##f = BIT(__BCH_WRITE_##f),
+	BCH_WRITE_FLAGS()
+#undef x
+};
+
 struct bch_write_bio {
 	struct_group(wbio,
 	struct bch_fs		*c;
-- 
2.49.0

