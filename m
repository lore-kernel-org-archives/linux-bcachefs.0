Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF002AE77
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739299; cv=none; b=exdAV5eQ6G9/RrhJXLe2rmMyLi/lMAp7ERt8VnwFhyZp06/DTXZtY/f0nT8tZEeU6n9u2Ef+ISAofZsnUBtd2MtiFmPZPsWsKt8QtE79yl2K5PSftOu2+ZqQ1XUHqe7FTVuj3UG2WbPzXlDJoGiudBSGOB+WTqwg5KaBZO0RaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739299; c=relaxed/simple;
	bh=nLPIspk4JPQbKCxODNBB2q8TNWLF9+m4rI5+/szTJtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOdCMDUZLZCrfVjrzEY7MmK9TwTNkzG6y5LBGyES1wm1Ouh55IXAzAm0lPIMqidMZNYE2ppxW0DMg/nstZRv5iz4dXkjl8buq5MbU/elSB+lguJnLZp4SyfsE/EK7OLHHat8h5kHRm/XrUXgVgQ1BR73jioedWXgCAXYooCvHfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PtuMi/OT; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PtuMi/OT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z4xVWuMAJaz5jRsptlL+XtA87kJqKKaINwr8Aeo5JjM=;
	b=PtuMi/OTtIxg3/yV/QgQi+1XAMpiOnZbj4V4ub3NPb8SVMW0k31jTf3tYF3Y10yRLkDXi8
	YI1DJEFmENZNKP9NLirHufppO3J/92DYXzCaLn9JvRZ/CK269J7Ek4/7Vmhon8ZTmgMsZO
	VOtTQkImAcwaDcdphxDD5T0gyv4wJx8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/8] bcachefs: alloc_request.data_type
Date: Sun, 23 Mar 2025 10:14:41 -0400
Message-ID: <20250323141445.566595-8-kent.overstreet@linux.dev>
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
 fs/bcachefs/alloc_foreground.c | 10 +++++-----
 fs/bcachefs/alloc_foreground.h |  4 ++--
 fs/bcachefs/ec.c               | 12 ++++--------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index ecbf25888806..7de52cabbef3 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -689,7 +689,6 @@ static int add_new_bucket(struct bch_fs *c,
 int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
 				struct alloc_request *req,
 				struct dev_stripe_state *stripe,
-				enum bch_data_type data_type,
 				struct closure *cl)
 {
 	struct bch_fs *c = trans->c;
@@ -710,7 +709,7 @@ int bch2_bucket_alloc_set_trans(struct btree_trans *trans,
 
 		struct bch_dev_usage usage;
 		struct open_bucket *ob = bch2_bucket_alloc_trans(trans, ca,
-							req->watermark, data_type,
+							req->watermark, req->data_type,
 							cl, req->flags & BCH_WRITE_alloc_nowait,
 							&usage);
 		if (!IS_ERR(ob))
@@ -906,8 +905,7 @@ static int __open_bucket_add_buckets(struct btree_trans *trans,
 		 * Try nonblocking first, so that if one device is full we'll try from
 		 * other devices:
 		 */
-		ret = bch2_bucket_alloc_set_trans(trans, req, &req->wp->stripe,
-						  req->wp->data_type, cl);
+		ret = bch2_bucket_alloc_set_trans(trans, req, &req->wp->stripe, cl);
 		if (ret &&
 		    !bch2_err_matches(ret, BCH_ERR_transaction_restart) &&
 		    !bch2_err_matches(ret, BCH_ERR_insufficient_devices) &&
@@ -1258,12 +1256,14 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
 
 	*wp_ret = req.wp = writepoint_find(trans, write_point.v);
 
+	req.data_type		= req.wp->data_type;
+
 	ret = bch2_trans_relock(trans);
 	if (ret)
 		goto err;
 
 	/* metadata may not allocate on cache devices: */
-	if (req.wp->data_type != BCH_DATA_user)
+	if (req.data_type != BCH_DATA_user)
 		req.have_cache = true;
 
 	if (target && !(flags & BCH_WRITE_only_specified_devs)) {
diff --git a/fs/bcachefs/alloc_foreground.h b/fs/bcachefs/alloc_foreground.h
index 741d81611f92..15135b6b63ce 100644
--- a/fs/bcachefs/alloc_foreground.h
+++ b/fs/bcachefs/alloc_foreground.h
@@ -30,6 +30,7 @@ struct alloc_request {
 	bool			ec;
 	enum bch_watermark	watermark;
 	enum bch_write_flags	flags;
+	enum bch_data_type	data_type;
 	struct bch_devs_list	*devs_have;
 
 	struct write_point	*wp;
@@ -189,8 +190,7 @@ static inline bool bch2_bucket_is_open_safe(struct bch_fs *c, unsigned dev, u64
 
 enum bch_write_flags;
 int bch2_bucket_alloc_set_trans(struct btree_trans *, struct alloc_request *,
-				struct dev_stripe_state *, enum bch_data_type,
-				struct closure *);
+				struct dev_stripe_state *, struct closure *);
 
 int bch2_alloc_sectors_start_trans(struct btree_trans *,
 				   unsigned, unsigned,
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index c2a8781fc154..e8e63902a438 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1757,11 +1757,9 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 	if (nr_have_parity < s->nr_parity) {
 		req.nr_replicas		= s->nr_parity;
 		req.nr_effective	= nr_have_parity;
+		req.data_type		= BCH_DATA_parity;
 
-		ret = bch2_bucket_alloc_set_trans(trans, &req,
-					    &h->parity_stripe,
-					    BCH_DATA_parity,
-					    cl);
+		ret = bch2_bucket_alloc_set_trans(trans, &req, &h->parity_stripe, cl);
 
 		open_bucket_for_each(c, &req.ptrs, ob, i) {
 			j = find_next_zero_bit(s->blocks_gotten,
@@ -1782,11 +1780,9 @@ static int new_stripe_alloc_buckets(struct btree_trans *trans,
 	if (nr_have_data < s->nr_data) {
 		req.nr_replicas		= s->nr_data;
 		req.nr_effective	= nr_have_data;
+		req.data_type		= BCH_DATA_user;
 
-		ret = bch2_bucket_alloc_set_trans(trans, &req,
-					    &h->block_stripe,
-					    BCH_DATA_user,
-					    cl);
+		ret = bch2_bucket_alloc_set_trans(trans, &req, &h->block_stripe, cl);
 
 		open_bucket_for_each(c, &req.ptrs, ob, i) {
 			j = find_next_zero_bit(s->blocks_gotten,
-- 
2.49.0

