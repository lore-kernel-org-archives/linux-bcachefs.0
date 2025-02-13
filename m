Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCADF24503A
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472382; cv=none; b=J7RIffElVDB7+rWDM4/iQdKn0LrlhnM6oHDYIhdKXjryoap8Z3I3jtBq+m3P4EMrGFVQqGBjjhhbHn/ObEYAyLkPzYruz81eYeeLlFC2R/j+GU2fg5o05rr/IBOdJnnkNWoUn2brr94zdVYs4r7St3svHgy8rVRFW0ojcvmuo6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472382; c=relaxed/simple;
	bh=TmuEZfe00w8V9W8kVfKiZ8Ovo7r14aKR1oq5lnpqv6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+CfA1I6a65WrzWG05qO/TbnLZjjMTIKsVZRPJ2JQnFLHvKLV5Mi7YfkdEi+TnXxy0vnV04SC6fshcCc64k7U8siiOJpMBWfylnWt3FT+p2mUXeke8dq3ImElvRq6UDx4yyp4lCGLE6TB5vFb7RhUm2Ktasx5zNnB4ouNi8If3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uGleRds1; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uGleRds1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O4UEVyYS/mWqDtuavAd/zojgUcND5iQQWzxZ6k/gtMc=;
	b=uGleRds1D+vyoZ2yKRUpodYK0GOc7/W+d9G7AOtAIWngMLcb9uTy6cv1rXzAasrW7HfjZq
	irAI89AnnXy4tnYSiWeQ0y+nr8IsDXcDL9310Q+o/fdU8Bwb4lbIgagNFdhJfM8iNwRKAY
	2De91EeMBnDSMdh1jSahhXsBEg/tsCQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/18] bcachefs: decouple bch2_lru_check_set() from alloc btree
Date: Thu, 13 Feb 2025 13:45:48 -0500
Message-ID: <20250213184607.18237-4-kent.overstreet@linux.dev>
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

Pass in the backpointer explicitly, instead of assuming 'referring_k' is
an alloc key and calculating it.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  5 ++++-
 fs/bcachefs/lru.c              | 10 +++++-----
 fs/bcachefs/lru.h              |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 87ff50a3cd81..58cdb6a0acf9 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1700,6 +1700,7 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 	u64 lru_idx = alloc_lru_idx_fragmentation(*a, ca);
 	if (lru_idx) {
 		ret = bch2_lru_check_set(trans, BCH_LRU_BUCKET_FRAGMENTATION,
+					 bucket_to_u64(alloc_k.k->p),
 					 lru_idx, alloc_k, last_flushed);
 		if (ret)
 			goto err;
@@ -1729,7 +1730,9 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 		a = &a_mut->v;
 	}
 
-	ret = bch2_lru_check_set(trans, alloc_k.k->p.inode, a->io_time[READ],
+	ret = bch2_lru_check_set(trans, alloc_k.k->p.inode,
+				 bucket_to_u64(alloc_k.k->p),
+				 a->io_time[READ],
 				 alloc_k, last_flushed);
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index 8ec16ae8daa6..dc6b9a80a8b5 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -78,7 +78,9 @@ static const char * const bch2_lru_types[] = {
 };
 
 int bch2_lru_check_set(struct btree_trans *trans,
-		       u16 lru_id, u64 time,
+		       u16 lru_id,
+		       u64 dev_bucket,
+		       u64 time,
 		       struct bkey_s_c referring_k,
 		       struct bkey_buf *last_flushed)
 {
@@ -87,9 +89,7 @@ int bch2_lru_check_set(struct btree_trans *trans,
 	struct btree_iter lru_iter;
 	struct bkey_s_c lru_k =
 		bch2_bkey_get_iter(trans, &lru_iter, BTREE_ID_lru,
-				   lru_pos(lru_id,
-					   bucket_to_u64(referring_k.k->p),
-					   time), 0);
+				   lru_pos(lru_id, dev_bucket, time), 0);
 	int ret = bkey_err(lru_k);
 	if (ret)
 		return ret;
@@ -104,7 +104,7 @@ int bch2_lru_check_set(struct btree_trans *trans,
 			     "  %s",
 			     bch2_lru_types[lru_type(lru_k)],
 			     (bch2_bkey_val_to_text(&buf, c, referring_k), buf.buf))) {
-			ret = bch2_lru_set(trans, lru_id, bucket_to_u64(referring_k.k->p), time);
+			ret = bch2_lru_set(trans, lru_id, dev_bucket, time);
 			if (ret)
 				goto err;
 		}
diff --git a/fs/bcachefs/lru.h b/fs/bcachefs/lru.h
index 398cc25db459..dea1d75cc9c1 100644
--- a/fs/bcachefs/lru.h
+++ b/fs/bcachefs/lru.h
@@ -58,7 +58,7 @@ static inline int bch2_lru_change(struct btree_trans *trans,
 }
 
 struct bkey_buf;
-int bch2_lru_check_set(struct btree_trans *, u16, u64, struct bkey_s_c, struct bkey_buf *);
+int bch2_lru_check_set(struct btree_trans *, u16, u64, u64, struct bkey_s_c, struct bkey_buf *);
 
 int bch2_check_lrus(struct bch_fs *);
 
-- 
2.45.2

