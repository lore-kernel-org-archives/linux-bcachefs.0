Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07CA2147F0
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509963; cv=none; b=f5kTmXrt5VTwjirFlqsQ10tiGGtPwblLTeEWYIpw5PRHQstmNZpqiVFXhB3UN3XbreKenNIwL1TdRxIFHSdcXJaegE+s4umTzVPENXXN2Of7UIj1mHBayUw9aHQDUjKpwDL2gKRTuJfHAQ4WNY/Z0Vpo/jTKl6pqHJdLJYS6okI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509963; c=relaxed/simple;
	bh=TGcMuuAj7i+rWzKXf/MF3YpOoQtt/SF+lYynnOxvhvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkEI6sJjOBwWKGgan/Rmyx8WZo2ccRd9g9VY4Y1fW3/dMO6pfqA/Ynq/qDVb+U/pSPIxQH9WUCCQ2W8fClsZsKeJjSoL3PmD7vVZ6MBdoOk2xnocmI4rlzl2n2cjBuOEgODHjD6zs1awCy87iIU0yb9ywN649PZ6C8qey5R8kII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Y7frtzaO; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Y7frtzaO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=djXkxfV3WhL+jxj8QkUmquBtKoHpkPQ0PtesuZFfHg0=;
	b=Y7frtzaONm9/mTi/9El5nyKRzGcOEMNjy4tN7+o2Q3Ip8UYPy3qM7p0hk87+pqABZiNKRQ
	avU8AqL6jUY8qUylVfuuSG5xXl0QcFW3kpFEquZrF1wBCDswufcuiVMDP68ZBUh8hdzfiT
	RuIrApP+plcdhgPop04S7Ip60o7iEoQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 7/8] bcachefs: Improve bucket_bitmap code
Date: Sat, 17 May 2025 15:25:44 -0400
Message-ID: <20250517192547.3849149-8-kent.overstreet@linux.dev>
In-Reply-To: <20250517192547.3849149-1-kent.overstreet@linux.dev>
References: <20250517192547.3849149-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add some more helpers, and mismatches is now a superset of the empty
bitmap - simplifies most checks.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 123 ++++++++++++++++++++++---------------
 fs/bcachefs/backpointers.h |   7 +++
 fs/bcachefs/bcachefs.h     |   3 +-
 fs/bcachefs/buckets.c      |  25 ++------
 fs/bcachefs/movinggc.c     |   6 +-
 fs/bcachefs/super.c        |   8 +--
 6 files changed, 92 insertions(+), 80 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index d9ddfc4b5dcc..6b98ce1ed6c9 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -15,6 +15,8 @@
 
 #include <linux/mm.h>
 
+static int bch2_bucket_bitmap_set(struct bch_dev *, struct bucket_bitmap *, u64);
+
 static inline struct bbpos bp_to_bbpos(struct bch_backpointer bp)
 {
 	return (struct bbpos) {
@@ -685,31 +687,28 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 			continue;
 		}
 
-		u64 b = PTR_BUCKET_NR(ca, &p.ptr);
-		bool set[2];
-
-		for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++) {
-			unsigned long *bitmap =
-				READ_ONCE(ca->bucket_backpointer_mismatches[i].buckets);
-			set[i] = bitmap && test_bit(b, bitmap);
+		if (p.ptr.cached && dev_ptr_stale_rcu(ca, &p.ptr)) {
+			rcu_read_unlock();
+			continue;
 		}
 
-		bool check = set[0];
-		bool empty = set[1];
+		u64 b = PTR_BUCKET_NR(ca, &p.ptr);
+		if (!bch2_bucket_bitmap_test(&ca->bucket_backpointer_mismatch, b)) {
+			rcu_read_unlock();
+			continue;
+		}
 
-		bool stale = p.ptr.cached && (!ca || dev_ptr_stale_rcu(ca, &p.ptr));
+		bool empty = bch2_bucket_bitmap_test(&ca->bucket_backpointer_empty, b);
 		rcu_read_unlock();
 
-		if ((check || empty) && !stale) {
-			struct bkey_i_backpointer bp;
-			bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
+		struct bkey_i_backpointer bp;
+		bch2_extent_ptr_to_bp(c, btree, level, k, p, entry, &bp);
 
-			int ret = check
-				? check_bp_exists(trans, s, &bp, k)
-				: bch2_bucket_backpointer_mod(trans, k, &bp, true);
-			if (ret)
-				return ret;
-		}
+		int ret = !empty
+			? check_bp_exists(trans, s, &bp, k)
+			: bch2_bucket_backpointer_mod(trans, k, &bp, true);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -952,21 +951,12 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 			      sectors[ALLOC_stripe] +
 			      sectors[ALLOC_cached]) == 0;
 
-		struct bucket_bitmap *bitmap = &ca->bucket_backpointer_mismatches[empty];
-
-		mutex_lock(&bitmap->lock);
-		if (!bitmap->buckets) {
-			bitmap->buckets = kvcalloc(BITS_TO_LONGS(ca->mi.nbuckets),
-						   sizeof(unsigned long), GFP_KERNEL);
-			if (!bitmap->buckets) {
-				mutex_unlock(&bitmap->lock);
-				ret = -BCH_ERR_ENOMEM_backpointer_mismatches_bitmap;
-				goto err;
-			}
-		}
-
-		bitmap->nr += !__test_and_set_bit(alloc_k.k->p.offset, bitmap->buckets);
-		mutex_unlock(&bitmap->lock);
+		ret = bch2_bucket_bitmap_set(ca, &ca->bucket_backpointer_mismatch,
+					     alloc_k.k->p.offset) ?:
+			(empty
+			 ? bch2_bucket_bitmap_set(ca, &ca->bucket_backpointer_empty,
+						  alloc_k.k->p.offset)
+			 : 0);
 	}
 err:
 	bch2_dev_put(ca);
@@ -992,15 +982,10 @@ static bool backpointer_node_has_missing(struct bch_fs *c, struct bkey_s_c k)
 			struct bpos bucket = bp_pos_to_bucket(ca, pos);
 			u64 next = ca->mi.nbuckets;
 
-			for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++) {
-				unsigned long *bitmap =
-					READ_ONCE(ca->bucket_backpointer_mismatches[i].buckets);
-				if (bitmap)
-					next = min_t(u64, next,
-						     find_next_bit(bitmap,
-								   ca->mi.nbuckets,
-								   bucket.offset));
-			}
+			unsigned long *bitmap = READ_ONCE(ca->bucket_backpointer_mismatch.buckets);
+			if (bitmap)
+				next = min_t(u64, next,
+					     find_next_bit(bitmap, ca->mi.nbuckets, bucket.offset));
 
 			bucket.offset = next;
 			if (bucket.offset == ca->mi.nbuckets)
@@ -1124,18 +1109,17 @@ int bch2_check_extents_to_backpointers(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	u64 nr_buckets = 0, nr_mismatches = 0, nr_empty = 0;
+	u64 nr_buckets = 0, nr_mismatches = 0;
 	for_each_member_device(c, ca) {
 		nr_buckets	+= ca->mi.nbuckets;
-		nr_mismatches	+= ca->bucket_backpointer_mismatches[0].nr;
-		nr_empty	+= ca->bucket_backpointer_mismatches[1].nr;
+		nr_mismatches	+= ca->bucket_backpointer_mismatch.nr;
 	}
 
-	if (!nr_mismatches && !nr_empty)
+	if (!nr_mismatches)
 		goto err;
 
 	bch_info(c, "scanning for missing backpointers in %llu/%llu buckets",
-		 nr_mismatches + nr_empty, nr_buckets);
+		 nr_mismatches, nr_buckets);
 
 	while (1) {
 		ret = bch2_pin_backpointer_nodes_with_missing(trans, s.bp_start, &s.bp_end);
@@ -1171,9 +1155,10 @@ int bch2_check_extents_to_backpointers(struct bch_fs *c)
 	bch2_bkey_buf_exit(&s.last_flushed, c);
 	bch2_btree_cache_unpin(c);
 
-	for_each_member_device(c, ca)
-		for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++)
-			bch2_bucket_bitmap_free(&ca->bucket_backpointer_mismatches[i]);
+	for_each_member_device(c, ca) {
+		bch2_bucket_bitmap_free(&ca->bucket_backpointer_mismatch);
+		bch2_bucket_bitmap_free(&ca->bucket_backpointer_empty);
+	}
 
 	bch_err_fn(c, ret);
 	return ret;
@@ -1297,6 +1282,42 @@ int bch2_check_backpointers_to_extents(struct bch_fs *c)
 	return ret;
 }
 
+static int bch2_bucket_bitmap_set(struct bch_dev *ca, struct bucket_bitmap *b, u64 bit)
+{
+	scoped_guard(mutex, &b->lock) {
+		if (!b->buckets) {
+			b->buckets = kvcalloc(BITS_TO_LONGS(ca->mi.nbuckets),
+					      sizeof(unsigned long), GFP_KERNEL);
+			if (!b->buckets)
+				return -BCH_ERR_ENOMEM_backpointer_mismatches_bitmap;
+		}
+
+		b->nr += !__test_and_set_bit(bit, b->buckets);
+	}
+
+	return 0;
+}
+
+int bch2_bucket_bitmap_resize(struct bucket_bitmap *b, u64 old_size, u64 new_size)
+{
+	scoped_guard(mutex, &b->lock) {
+		if (!b->buckets)
+			return 0;
+
+		unsigned long *n = kvcalloc(BITS_TO_LONGS(new_size),
+					    sizeof(unsigned long), GFP_KERNEL);
+		if (!n)
+			return -BCH_ERR_ENOMEM_backpointer_mismatches_bitmap;
+
+		memcpy(n, b->buckets,
+		       BITS_TO_LONGS(min(old_size, new_size)) * sizeof(unsigned long));
+		kvfree(b->buckets);
+		b->buckets = n;
+	}
+
+	return 0;
+}
+
 void bch2_bucket_bitmap_free(struct bucket_bitmap *b)
 {
 	mutex_lock(&b->lock);
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index f57098c32143..fe7149a2fbf5 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -188,6 +188,13 @@ int bch2_check_btree_backpointers(struct bch_fs *);
 int bch2_check_extents_to_backpointers(struct bch_fs *);
 int bch2_check_backpointers_to_extents(struct bch_fs *);
 
+static inline bool bch2_bucket_bitmap_test(struct bucket_bitmap *b, u64 i)
+{
+	unsigned long *bitmap = READ_ONCE(b->buckets);
+	return bitmap && test_bit(i, bitmap);
+}
+
+int bch2_bucket_bitmap_resize(struct bucket_bitmap *, u64, u64);
 void bch2_bucket_bitmap_free(struct bucket_bitmap *);
 
 #endif /* _BCACHEFS_BACKPOINTERS_BACKGROUND_H */
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index e1680b635fe1..b58fad743fc4 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -626,7 +626,8 @@ struct bch_dev {
 	u8			*oldest_gen;
 	unsigned long		*buckets_nouse;
 
-	struct bucket_bitmap	bucket_backpointer_mismatches[2];
+	struct bucket_bitmap	bucket_backpointer_mismatch;
+	struct bucket_bitmap	bucket_backpointer_empty;
 
 	struct bch_dev_usage_full __percpu
 				*usage;
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index ca6e58d6fbc8..8bb6384190c5 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1324,27 +1324,10 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 		       sizeof(bucket_gens->b[0]) * copy);
 	}
 
-	for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++) {
-		struct bucket_bitmap *bitmap = &ca->bucket_backpointer_mismatches[i];
-
-		mutex_lock(&bitmap->lock);
-		if (bitmap->buckets) {
-			unsigned long *n = kvcalloc(BITS_TO_LONGS(nbuckets),
-						    sizeof(unsigned long), GFP_KERNEL);
-			if (!n) {
-				mutex_unlock(&bitmap->lock);
-				ret = -BCH_ERR_ENOMEM_backpointer_mismatches_bitmap;
-				goto err;
-			}
-
-			memcpy(n, bitmap->buckets,
-			       BITS_TO_LONGS(ca->mi.nbuckets) * sizeof(unsigned long));
-			kvfree(bitmap->buckets);
-			bitmap->buckets = n;
-
-		}
-		mutex_unlock(&bitmap->lock);
-	}
+	ret =   bch2_bucket_bitmap_resize(&ca->bucket_backpointer_mismatch,
+					  ca->mi.nbuckets, nbuckets) ?:
+		bch2_bucket_bitmap_resize(&ca->bucket_backpointer_empty,
+					  ca->mi.nbuckets, nbuckets);
 
 	rcu_assign_pointer(ca->bucket_gens, bucket_gens);
 	bucket_gens	= old_bucket_gens;
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 4bfdb1befb9a..0a751a65386f 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -8,6 +8,7 @@
 #include "bcachefs.h"
 #include "alloc_background.h"
 #include "alloc_foreground.h"
+#include "backpointers.h"
 #include "btree_iter.h"
 #include "btree_update.h"
 #include "btree_write_buffer.h"
@@ -76,7 +77,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 
 	if (ca->mi.state != BCH_MEMBER_STATE_rw ||
 	    !bch2_dev_is_online(ca))
-		goto out_put;
+		goto out;
 
 	struct bch_alloc_v4 _a;
 	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k, &_a);
@@ -85,9 +86,8 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 	u64 lru_idx	= alloc_lru_idx_fragmentation(*a, ca);
 
 	ret = lru_idx && lru_idx <= time;
-out_put:
-	bch2_dev_put(ca);
 out:
+	bch2_dev_put(ca);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 170b0f26c018..24658bf450ab 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1366,8 +1366,8 @@ static void bch2_dev_free(struct bch_dev *ca)
 	if (ca->kobj.state_in_sysfs)
 		kobject_del(&ca->kobj);
 
-	for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++)
-		bch2_bucket_bitmap_free(&ca->bucket_backpointer_mismatches[i]);
+	bch2_bucket_bitmap_free(&ca->bucket_backpointer_mismatch);
+	bch2_bucket_bitmap_free(&ca->bucket_backpointer_empty);
 
 	bch2_free_super(&ca->disk_sb);
 	bch2_dev_allocator_background_exit(ca);
@@ -1499,8 +1499,8 @@ static struct bch_dev *__bch2_dev_alloc(struct bch_fs *c,
 	atomic_long_set(&ca->ref, 1);
 #endif
 
-	for (unsigned i = 0; i < ARRAY_SIZE(ca->bucket_backpointer_mismatches); i++)
-		mutex_init(&ca->bucket_backpointer_mismatches[i].lock);
+	mutex_init(&ca->bucket_backpointer_mismatch.lock);
+	mutex_init(&ca->bucket_backpointer_empty.lock);
 
 	bch2_dev_allocator_background_init(ca);
 
-- 
2.49.0

