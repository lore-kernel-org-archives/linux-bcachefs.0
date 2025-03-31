Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3404757F3
	for <linux-bcachefs@vger.kernel.org>; Mon, 31 Mar 2025 18:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743446907; cv=none; b=VuYovzg0GYWl3Eb8VDEEdLViQjjqXm4p5bfKXyqrJSh38feJ+UYEAVUPeaj2xCaE4iKWndqt7/B40x+peYTKqbw2XFA5X2a3zNVa8DH/9tJ02MxtZt6Ui31+HD5BDW5EG+YPoqUqwD6e2sQL5JPPui5tLLaYax/4UziM7LC5ugc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743446907; c=relaxed/simple;
	bh=unqEZwi2atuLdssigP/ZEm9NIVzsIX3bliyuRp11/9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N8F8B4kOeD2Z2UGc7ai2kB9GIpR97IFobbmzqWLvwPEeX+NHQjaMNgDw8iCRJrDfO6kBqbpCp9iG1xPCBfm+D1UcrAp7FoLshCvSxXNjA3El+My5Xu+nXjJfuIOHJOf+rcGGIkRaWCRCKBu7UT5SIQB7WMArfH6G0W+p84vDYUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n17C1uqp; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n17C1uqp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743446904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=YVbwvqZcUcMYwY9Di0+ZCfDwvlCtag0r+dze2iL6qVs=;
	b=n17C1uqpt2rNrjzPI2Y4r72Yh/H8WSBpc7/zzFDkU9wQdjmx/3DMDiPVcKFTAmN6T9pKo4
	9RLaUcxTKyZXXCi+fJCTvaegqsCSJowT0fqUKNu4e+h6FWHzAAJ80Oa29ODDOAGzmyjAOz
	9jJP4dOYh2vp4U0GWcgZ5aFyQn+lB0k=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix striping behaviour
Date: Mon, 31 Mar 2025 14:48:18 -0400
Message-ID: <20250331184818.431245-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

For striping across devices, we maintain "clocks", and we advance them
by the inverse of "how much free space this device has left", so that we
round robin biased in favor of devices with more free space.

This code was originally trying to do EWMA-ish stuff when originally
written, ~10 years ago, and was never properly cleaned up when it was
realized that an EWMA is not the right approach here.

That left a bug, when we rescale to keep all the clocks in the correct
range and prevent overflow.

It was assumed that we'd always be allocated from the device with the
smallest clock hand, but that's actually not correct: with the target
options, allocations will be first tried from a subset of devices, and
then the entire filesystem if that fails.

Thus, the rescale from the first allocation - allocating from a subset
of devices - can pick the wrong rescale value and cause the rest of the
clocks to go to 0, losing information.

This resuls in incorrect striping behaviour when the desired number of
replicas doesn't fit on the foreground target.

Link: https://www.reddit.com/r/bcachefs/comments/1jn3t26/replica_allocation_not_evenly_distributed_among/
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 60 +++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index da0d72928b5b..1a25a8a4ae09 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -606,8 +606,7 @@ struct open_bucket *bch2_bucket_alloc(struct bch_fs *c, struct bch_dev *ca,
 static int __dev_stripe_cmp(struct dev_stripe_state *stripe,
 			    unsigned l, unsigned r)
 {
-	return ((stripe->next_alloc[l] > stripe->next_alloc[r]) -
-		(stripe->next_alloc[l] < stripe->next_alloc[r]));
+	return cmp_int(stripe->next_alloc[l], stripe->next_alloc[r]);
 }
 
 #define dev_stripe_cmp(l, r) __dev_stripe_cmp(stripe, l, r)
@@ -626,25 +625,62 @@ struct dev_alloc_list bch2_dev_alloc_list(struct bch_fs *c,
 	return ret;
 }
 
+static const u64 stripe_clock_hand_rescale	= 1ULL << 62; /* trigger rescale at */
+static const u64 stripe_clock_hand_max		= 1ULL << 56; /* max after rescale */
+static const u64 stripe_clock_hand_inv		= 1ULL << 52; /* max increment, if a device is empty */
+
+static noinline void bch2_stripe_state_rescale(struct dev_stripe_state *stripe)
+{
+	/*
+	 * Avoid underflowing clock hands if at all possible, if clock hands go
+	 * to 0 then we lose information - clock hands can be in a wide range if
+	 * we have devices we rarely try to allocate from, if we generally
+	 * allocate from a specified target but only sometimes have to fall back
+	 * to the whole filesystem.
+	 */
+	u64 scale_max = U64_MAX;	/* maximum we can subtract without underflow */
+	u64 scale_min = 0;		/* minumum we must subtract to avoid overflow */
+
+	for (u64 *v = stripe->next_alloc;
+	     v < stripe->next_alloc + ARRAY_SIZE(stripe->next_alloc); v++) {
+		if (*v)
+			scale_max = min(scale_max, *v);
+		if (*v > stripe_clock_hand_max)
+			scale_min = max(scale_min, *v - stripe_clock_hand_max);
+	}
+
+	u64 scale = max(scale_min, scale_max);
+
+	for (u64 *v = stripe->next_alloc;
+	     v < stripe->next_alloc + ARRAY_SIZE(stripe->next_alloc); v++)
+		*v = *v < scale ? 0 : *v - scale;
+}
+
 static inline void bch2_dev_stripe_increment_inlined(struct bch_dev *ca,
 			       struct dev_stripe_state *stripe,
 			       struct bch_dev_usage *usage)
 {
+	/*
+	 * Stripe state has a per device clock hand: we allocate from the device
+	 * with the smallest clock hand.
+	 *
+	 * When we allocate, we don't do a simple increment; we add the inverse
+	 * of the device's free space. This results in round robin behavior that
+	 * biases in favor of the device(s) with more free space.
+	 */
+
 	u64 *v = stripe->next_alloc + ca->dev_idx;
 	u64 free_space = __dev_buckets_available(ca, *usage, BCH_WATERMARK_normal);
 	u64 free_space_inv = free_space
-		? div64_u64(1ULL << 48, free_space)
-		: 1ULL << 48;
-	u64 scale = *v / 4;
+		? div64_u64(stripe_clock_hand_inv, free_space)
+		: stripe_clock_hand_inv;
 
-	if (*v + free_space_inv >= *v)
-		*v += free_space_inv;
-	else
-		*v = U64_MAX;
+	/* Saturating add, avoid overflow: */
+	u64 sum = *v + free_space_inv;
+	*v = sum >= *v ? sum : U64_MAX;
 
-	for (v = stripe->next_alloc;
-	     v < stripe->next_alloc + ARRAY_SIZE(stripe->next_alloc); v++)
-		*v = *v < scale ? 0 : *v - scale;
+	if (unlikely(*v > stripe_clock_hand_rescale))
+		bch2_stripe_state_rescale(stripe);
 }
 
 void bch2_dev_stripe_increment(struct bch_dev *ca,
-- 
2.49.0

