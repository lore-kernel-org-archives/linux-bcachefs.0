Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA08D20330
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930778; cv=none; b=XAUDsiRsWzt0FvhyCO0NfiPes75uHkbr3C1MQg75WJXSjRxLLDCiL9PiTSUIPErQOi7WXLD2V961n+BQ0jL1MwRjXiYrAu3AdbpgmNfZBkoo1GQNXP3EukdunjpllrLGVAd9R6XPCTdzcMw+8dIMf40gNRlsaWNuADLhKL71TsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930778; c=relaxed/simple;
	bh=ZVb0RjuUome+hVvaONpOY08Ux2jG6hVlqrqhnVDSepY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX6RDRxWuUP2bvtlFX29pBbZGRMmymnTKebyG80sc9tNu1StKaEvu3ZDJrnuNMukb+Mwiyut9U9Wyj3qVWKkNKiOCh182uIIB4O0K0swC1gn4IhjGdWjwG9tTqTe+4tfE0qNLnGf0V/hMfnZwNEYOxq4xn9Wbx9gsOMm5XgbrXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hd8wh+bn; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hd8wh+bn"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3W7mS1WAFhAcfVt0gUSXegNs0+tkjedPnDk/k+f5hkQ=;
	b=Hd8wh+bnWvLS6G2zGRtcsvGMIQOIFBiGufYnH1WmZN239olVHhMcGD4TBipr/UXC+DbqpV
	jnvifuACgUEn1H8xgy6lxgoGVIBdOuvKMbhov1VOuJl/94wy7NllZWpsMs39jei5uKl2jO
	T4pYsUoVTJClNTqbdtvDhdVbx9C2efA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/8] bcachefs: bch2_extent_ptr_to_bp() no longer depends on device
Date: Fri, 29 Nov 2024 20:39:15 -0500
Message-ID: <20241130013922.3135792-4-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch_backpointer no longer contains the bucket_offset field, it's just a
direct LBA mapping (with low bits to account for compressed extent
splitting), so we don't need to refer to the device to construct it
anymore.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 26 ++++----------------------
 fs/bcachefs/backpointers.h | 17 ++++++-----------
 fs/bcachefs/buckets.c      |  7 ++++---
 3 files changed, 14 insertions(+), 36 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index b53d98c762ed..7e2ae07b9df8 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -72,26 +72,14 @@ static bool extent_matches_bp(struct bch_fs *c,
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
 
-	rcu_read_lock();
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		struct bpos bucket2;
 		struct bkey_i_backpointer bp2;
+		bch2_extent_ptr_to_bp(c, btree_id, level, k, p, entry, &bp2);
 
-		if (p.ptr.cached)
-			continue;
-
-		struct bch_dev *ca = bch2_dev_rcu(c, p.ptr.dev);
-		if (!ca)
-			continue;
-
-		bch2_extent_ptr_to_bp(c, ca, btree_id, level, k, p, entry, &bucket2, &bp2);
 		if (bpos_eq(bp.k->p, bp2.k.p) &&
-		    !memcmp(bp.v, &bp2.v, sizeof(bp2.v))) {
-			rcu_read_unlock();
+		    !memcmp(bp.v, &bp2.v, sizeof(bp2.v)))
 			return true;
-		}
 	}
-	rcu_read_unlock();
 
 	return false;
 }
@@ -585,21 +573,15 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 
 	ptrs = bch2_bkey_ptrs_c(k);
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		struct bpos bucket_pos;
 		struct bkey_i_backpointer bp;
 
 		if (p.ptr.cached)
 			continue;
 
-		rcu_read_lock();
-		struct bch_dev *ca = bch2_dev_rcu_noerror(c, p.ptr.dev);
-		if (ca)
-			bch2_extent_ptr_to_bp(c, ca, btree, level, k, p, entry, &bucket_pos, &bp);
-		rcu_read_unlock();
-
-		if (!ca)
+		if (p.ptr.dev == BCH_SB_MEMBER_INVALID)
 			continue;
 
+		bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
 		ret = check_bp_exists(trans, s, &bp, k);
 		if (ret)
 			return ret;
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index caffc68407ab..d126d40dda99 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -140,20 +140,15 @@ static inline enum bch_data_type bch2_bkey_ptr_data_type(struct bkey_s_c k,
 	}
 }
 
-static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
+static inline void __bch2_extent_ptr_to_bp(
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bpos *bucket, struct bkey_i_backpointer *bp,
+			   struct bkey_i_backpointer *bp,
 			   u64 sectors)
 {
-	u32 bucket_offset;
-	*bucket = PTR_BUCKET_POS_OFFSET(ca, &p.ptr, &bucket_offset);
-
-	u64 bp_bucket_offset = ((u64) bucket_offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset;
-
 	bkey_backpointer_init(&bp->k_i);
-	bp->k.p = bucket_pos_to_bp(ca, *bucket, bp_bucket_offset);
+	bp->k.p = POS(p.ptr.dev, ((u64) p.ptr.offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset);
 	bp->v	= (struct bch_backpointer) {
 		.btree_id	= btree_id,
 		.level		= level,
@@ -164,15 +159,15 @@ static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 	};
 }
 
-static inline void bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
+static inline void bch2_extent_ptr_to_bp(struct bch_fs *c,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bpos *bucket_pos, struct bkey_i_backpointer *bp)
+			   struct bkey_i_backpointer *bp)
 {
 	u64 sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
 
-	__bch2_extent_ptr_to_bp(c, ca, btree_id, level, k, p, entry, bucket_pos, bp, sectors);
+	__bch2_extent_ptr_to_bp(btree_id, level, k, p, entry, bp, sectors);
 }
 
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *, struct bkey_s_c_backpointer,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index afd35c93fcfb..0365f10f3ba5 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -577,6 +577,9 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 	u64 abs_sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
 	*sectors = insert ? abs_sectors : -abs_sectors;
 
+	struct bkey_i_backpointer bp;
+	__bch2_extent_ptr_to_bp(btree_id, level, k, p, entry, &bp, abs_sectors);
+
 	struct bch_dev *ca = bch2_dev_tryget(c, p.ptr.dev);
 	if (unlikely(!ca)) {
 		if (insert && p.ptr.dev != BCH_SB_MEMBER_INVALID)
@@ -584,9 +587,7 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 		goto err;
 	}
 
-	struct bpos bucket;
-	struct bkey_i_backpointer bp;
-	__bch2_extent_ptr_to_bp(trans->c, ca, btree_id, level, k, p, entry, &bucket, &bp, abs_sectors);
+	struct bpos bucket = PTR_BUCKET_POS(ca, &p.ptr);
 
 	if (flags & BTREE_TRIGGER_transactional) {
 		struct bkey_i_alloc_v4 *a = bch2_trans_start_alloc_update(trans, bucket, 0);
-- 
2.45.2

