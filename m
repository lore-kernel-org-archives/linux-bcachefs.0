Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1EB24292F
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472385; cv=none; b=gFA3PTN2qLjCKmdZ5x32tapWGSViIFRL1Szc9AjBrTeucKUJJoSlkqbaQzhbGwwSJ2YPmSOu/rmw2vlZDTCHQsBmDWDP0+NdOrH9PuZkaaIQGKOTZjKFbUEXvMom/TiDars5osbEMWaXQgVLk7uAVUJ+YmmSD6ZradZxsc1BRkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472385; c=relaxed/simple;
	bh=0WwUCTcuw0NcKeV591sS/XNriTXP5CqlXPbZ1MERXE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpEm+D3XwewqG1m+SCBBvmPWa9Hbq6OFJ9HhKo0uYz4+6gQWwc1dT88wk62RCmFOEpHGRmoDBB2PXWPu2UiKcyB+0WEKnqTobo95G6xu5Q0UyX/cNGyDisneacaKX/E3YqaNDNRJqfG4AujhqYs7SIMWZMauVmvUInlvzswrGoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=etnceylD; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="etnceylD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zsTACzhi/U3UjySmvyF2vbkYEiYZ39ZsDz8YCz1/7d8=;
	b=etnceylDpinIjSLFSUWbK1dB0UHXrXT6ujQGNBIhSqs5EpBaedVDPgif2QdGYXmUhQZEu8
	4JGLQGTMfadQ9dPEYj2Q8ejTo8/cMagMaow8I6iiWMUH++ChE2gipdrRHMkvl2MwnqZsm3
	T1eAE9mJA82ED+V4/d6/H3v0+rEDaD8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/18] bcachefs: bcachefs_metadata_version_cached_backpointers
Date: Thu, 13 Feb 2025 13:45:53 -0500
Message-ID: <20250213184607.18237-9-kent.overstreet@linux.dev>
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

Cached pointers now have backpointers.

This means that we'll be able to kill cached pointers in the
bucket_invalidate path, when invalidating/reusing buckets containing
cached data, instead of leaving them around to be cleaned up by gc_gens
garbago collection - which requires a full metadata scan.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c    | 14 +++++++-------
 fs/bcachefs/bcachefs_format.h |  3 ++-
 fs/bcachefs/buckets.c         |  8 +++-----
 fs/bcachefs/sb-downgrade.c    |  3 +++
 4 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index bb799b86aa69..c9dfc3657696 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -611,9 +611,6 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 	struct extent_ptr_decoded p;
 
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		if (p.ptr.cached)
-			continue;
-
 		if (p.ptr.dev == BCH_SB_MEMBER_INVALID)
 			continue;
 
@@ -621,9 +618,11 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 		struct bch_dev *ca = bch2_dev_rcu_noerror(c, p.ptr.dev);
 		bool check = ca && test_bit(PTR_BUCKET_NR(ca, &p.ptr), ca->bucket_backpointer_mismatches);
 		bool empty = ca && test_bit(PTR_BUCKET_NR(ca, &p.ptr), ca->bucket_backpointer_empty);
+
+		bool stale = p.ptr.cached && (!ca || dev_ptr_stale_rcu(ca, &p.ptr));
 		rcu_read_unlock();
 
-		if (check || empty) {
+		if ((check || empty) && !stale) {
 			struct bkey_i_backpointer bp;
 			bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
 
@@ -857,9 +856,8 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 			goto err;
 	}
 
-	/* Cached pointers don't have backpointers: */
-
 	if (sectors[ALLOC_dirty]  != a->dirty_sectors ||
+	    sectors[ALLOC_cached] != a->cached_sectors ||
 	    sectors[ALLOC_stripe] != a->stripe_sectors) {
 		if (c->sb.version_upgrade_complete >= bcachefs_metadata_version_backpointer_bucket_gen) {
 			ret = bch2_backpointers_maybe_flush(trans, alloc_k, last_flushed);
@@ -868,6 +866,7 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 		}
 
 		if (sectors[ALLOC_dirty]  > a->dirty_sectors ||
+		    sectors[ALLOC_cached] > a->cached_sectors ||
 		    sectors[ALLOC_stripe] > a->stripe_sectors) {
 			ret = check_bucket_backpointers_to_extents(trans, ca, alloc_k.k->p) ?:
 				-BCH_ERR_transaction_restart_nested;
@@ -875,7 +874,8 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 		}
 
 		if (!sectors[ALLOC_dirty] &&
-		    !sectors[ALLOC_stripe])
+		    !sectors[ALLOC_stripe] &&
+		    !sectors[ALLOC_cached])
 			__set_bit(alloc_k.k->p.offset, ca->bucket_backpointer_empty);
 		else
 			__set_bit(alloc_k.k->p.offset, ca->bucket_backpointer_mismatches);
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index f70f0108401f..ef5009b18dd5 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -686,7 +686,8 @@ struct bch_sb_field_ext {
 	x(inode_depth,			BCH_VERSION(1, 17))		\
 	x(persistent_inode_cursors,	BCH_VERSION(1, 18))		\
 	x(autofix_errors,		BCH_VERSION(1, 19))		\
-	x(directory_size,		BCH_VERSION(1, 20))
+	x(directory_size,		BCH_VERSION(1, 20))		\
+	x(cached_backpointers,		BCH_VERSION(1, 21))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 88af61bc799d..bb7742cf0014 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -590,11 +590,9 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		if (!p.ptr.cached) {
-			ret = bch2_bucket_backpointer_mod(trans, k, &bp, insert);
-			if (ret)
-				goto err;
-		}
+		ret = bch2_bucket_backpointer_mod(trans, k, &bp, insert);
+		if (ret)
+			goto err;
 	}
 
 	if (flags & BTREE_TRIGGER_gc) {
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 14f6b6a5fb38..34fd897680b3 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -94,6 +94,9 @@
 	x(directory_size,					\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
 	  BCH_FSCK_ERR_directory_size_mismatch)			\
+	x(cached_backpointers,					\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
-- 
2.45.2

