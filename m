Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BEB241691
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472382; cv=none; b=sOt9A/fbYjsIHWe0Kl0UmEVGLFhfLArmT8Ugdw+PyEDEKUzdT/nI4qLKVxa+QuNq5T3kJ0aQDLX9jEXW//QiuOzyJjkAzPf9n3CBGTO69lt15djqAOiZJsBihGb2iOThpp3AV0FmQ/fA99GIoQPKu0NILyirsrazgbFT13CTfIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472382; c=relaxed/simple;
	bh=4sJEeyxDhPZLR0qvQESu+yDAVDdpsZ+d0cqP9HPqIdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jA6onAGZ+V2DW3vR3dQ66IKm0zk/8fb3hajLpVQZTaVoKuaouEPAUTMGLB2PKFT+qcig7OOS2w92mJMk3jNUYnEco3RGwYmkobpnUojqqEr/xQ+EEXKV6w40RD3I0uPn2HNXzvh7swpuxRt0snXqPJf65qZ27hHFJSlpkKGa+Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gzhoaWSW; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gzhoaWSW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WT+xHEjamVPDwSo5vxWQJzwDrHYvToNkDENEEsHZ3JA=;
	b=gzhoaWSWG0mXVZWm3GtF1hU7LZy8Vhl00LOfYOGF2RchEJOzwn3CwKPf/ui0mRb29tl/th
	aYBFbZw63UNah+2C6T1v8OraK4UZxS05cKpJtBcDr+WyDhLK1b7lNjUmNWvKgyfdN00Xht
	zcWaIAhF8amA1HxpjbQotrnAGYx/4Ek=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/18] bcachefs: s/BCH_LRU_FRAGMENTATION_START/BCH_LRU_BUCKET_FRAGMENTATION/
Date: Thu, 13 Feb 2025 13:45:47 -0500
Message-ID: <20250213184607.18237-3-kent.overstreet@linux.dev>
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

FRAGMENTATION_START was incorrect, there's currently only one
fragmentation LRU (at the end of the reserved bits for LRU type), and
we're getting ready to add a stripe fragmentation lru - so give it a
better name.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 4 ++--
 fs/bcachefs/lru.h              | 2 +-
 fs/bcachefs/lru_format.h       | 2 +-
 fs/bcachefs/movinggc.c         | 4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index e1061524bdf5..87ff50a3cd81 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -897,7 +897,7 @@ int bch2_trigger_alloc(struct btree_trans *trans,
 			goto err;
 
 		ret = bch2_lru_change(trans,
-				      BCH_LRU_FRAGMENTATION_START,
+				      BCH_LRU_BUCKET_FRAGMENTATION,
 				      bucket_to_u64(new.k->p),
 				      alloc_lru_idx_fragmentation(*old_a, ca),
 				      alloc_lru_idx_fragmentation(*new_a, ca));
@@ -1699,7 +1699,7 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 
 	u64 lru_idx = alloc_lru_idx_fragmentation(*a, ca);
 	if (lru_idx) {
-		ret = bch2_lru_check_set(trans, BCH_LRU_FRAGMENTATION_START,
+		ret = bch2_lru_check_set(trans, BCH_LRU_BUCKET_FRAGMENTATION,
 					 lru_idx, alloc_k, last_flushed);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/lru.h b/fs/bcachefs/lru.h
index 2facc0758cb3..398cc25db459 100644
--- a/fs/bcachefs/lru.h
+++ b/fs/bcachefs/lru.h
@@ -28,7 +28,7 @@ static inline enum bch_lru_type lru_type(struct bkey_s_c l)
 {
 	u16 lru_id = l.k->p.inode >> 48;
 
-	if (lru_id == BCH_LRU_FRAGMENTATION_START)
+	if (lru_id == BCH_LRU_BUCKET_FRAGMENTATION)
 		return BCH_LRU_fragmentation;
 	return BCH_LRU_read;
 }
diff --git a/fs/bcachefs/lru_format.h b/fs/bcachefs/lru_format.h
index f372cb3b8cda..353a352d3fb9 100644
--- a/fs/bcachefs/lru_format.h
+++ b/fs/bcachefs/lru_format.h
@@ -17,7 +17,7 @@ enum bch_lru_type {
 #undef x
 };
 
-#define BCH_LRU_FRAGMENTATION_START	((1U << 16) - 1)
+#define BCH_LRU_BUCKET_FRAGMENTATION	((1U << 16) - 1)
 
 #define LRU_TIME_BITS			48
 #define LRU_TIME_MAX			((1ULL << LRU_TIME_BITS) - 1)
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 21805509ab9e..4ecb721cfc85 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -168,8 +168,8 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 	bch2_trans_begin(trans);
 
 	ret = for_each_btree_key_max(trans, iter, BTREE_ID_lru,
-				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
-				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
+				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, 0, 0),
+				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, U64_MAX, LRU_TIME_MAX),
 				  0, k, ({
 		struct move_bucket b = { .k.bucket = u64_to_bucket(k.k->p.offset) };
 		int ret2 = 0;
-- 
2.45.2

