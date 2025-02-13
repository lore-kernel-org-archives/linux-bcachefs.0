Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34C5245AF3
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472390; cv=none; b=TWVKFvHXvnUB99Q2DCl5HBvcBGdoSdO8HoALYfTdr2qYWO7NxpG+05g+IWy1wduwSM8h7xVoDCu5M8sAVNNWHmhiVtCLVPQ4L/mELsqNVc0a3w4G6RcUAfZkf/MUDWdAWVaIr8TXGF0ZygCf6IwA2b9+Q613hZQXzwvwLhGI99k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472390; c=relaxed/simple;
	bh=umGTtUO1RSXF82+sY511cAeJQEwmnnnjka22sWf+0BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRL3rwY9xLTrJmGRLp5MLBwqnJ9DLbLlbPTwfGeafe3Mn7W45Prfw8iU5WHmFE4Tn7l+ZdnkbN6OqvKHJKnjELn6O8Z9XVLkKwhaTyt30eQkQb9o3d6HiLmZ3TWhYUxFicpDRAy8jrQPewGQ3Y2KQWQMEKzYdWICnFkGeyi7m/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fMdVoXyJ; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fMdVoXyJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1tpetgLRcyVaUHw4+8tHs1osvPeT3zXowoLZbu+Gus=;
	b=fMdVoXyJ1cRuyaX6pO5eToNlVADrr5wydmAPf0xUjzA/hIeLOor9Pkgrl/uEgfO/jEEXnJ
	OfrNdVqcPYKtRJ9mYncgeFzIXppFxQw7+NX3qhAv9GyukXNH9gVc3chSCtlY55xk2HOxVr
	fLkhV+3PeLdpFIiffFLV2pRBF0J96uk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 12/18] bcachefs: bcachefs_metadata_version_stripe_lru
Date: Thu, 13 Feb 2025 13:45:57 -0500
Message-ID: <20250213184607.18237-13-kent.overstreet@linux.dev>
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

Add a persistent LRU for stripes, ordered by "number of empty blocks",
i.e. order in which we wish to reuse them.

This will replace the in-memory stripes heap, so we can kill off reading
stripes into memory at startup.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  3 +-
 fs/bcachefs/bcachefs_format.h  |  3 +-
 fs/bcachefs/ec.c               | 51 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/ec.h               | 27 ++++++++++++++++++
 fs/bcachefs/lru.c              |  7 +++++
 fs/bcachefs/lru.h              |  9 ++++--
 fs/bcachefs/lru_format.h       |  4 ++-
 7 files changed, 99 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index c5c8497a6339..ecad4a78c3f7 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1757,7 +1757,8 @@ int bch2_check_alloc_to_lru_refs(struct bch_fs *c)
 		for_each_btree_key_commit(trans, iter, BTREE_ID_alloc,
 				POS_MIN, BTREE_ITER_prefetch, k,
 				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-			bch2_check_alloc_to_lru_ref(trans, &iter, &last_flushed)));
+			bch2_check_alloc_to_lru_ref(trans, &iter, &last_flushed))) ?:
+		bch2_check_stripe_to_lru_refs(c);
 
 	bch2_bkey_buf_exit(&last_flushed, c);
 	bch_err_fn(c, ret);
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index bf3723a2bca4..b4ac311f21a1 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -688,7 +688,8 @@ struct bch_sb_field_ext {
 	x(autofix_errors,		BCH_VERSION(1, 19))		\
 	x(directory_size,		BCH_VERSION(1, 20))		\
 	x(cached_backpointers,		BCH_VERSION(1, 21))		\
-	x(stripe_backpointers,		BCH_VERSION(1, 22))
+	x(stripe_backpointers,		BCH_VERSION(1, 22))		\
+	x(stripe_lru,			BCH_VERSION(1, 23))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 36590c0ce09f..1090cdb7d5cc 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -20,6 +20,7 @@
 #include "io_read.h"
 #include "io_write.h"
 #include "keylist.h"
+#include "lru.h"
 #include "recovery.h"
 #include "replicas.h"
 #include "super-io.h"
@@ -411,6 +412,15 @@ int bch2_trigger_stripe(struct btree_trans *trans,
 	       (new_s->nr_blocks	!= old_s->nr_blocks ||
 		new_s->nr_redundant	!= old_s->nr_redundant));
 
+	if (flags & BTREE_TRIGGER_transactional) {
+		int ret = bch2_lru_change(trans,
+					  BCH_LRU_STRIPE_FRAGMENTATION,
+					  idx,
+					  stripe_lru_pos(old_s),
+					  stripe_lru_pos(new_s));
+		if (ret)
+			return ret;
+	}
 
 	if (flags & (BTREE_TRIGGER_transactional|BTREE_TRIGGER_gc)) {
 		/*
@@ -1175,6 +1185,10 @@ static int ec_stripe_delete(struct btree_trans *trans, u64 idx)
 	return ret;
 }
 
+/*
+ * XXX
+ * can we kill this and delete stripes from the trigger?
+ */
 static void ec_stripe_delete_work(struct work_struct *work)
 {
 	struct bch_fs *c =
@@ -2519,3 +2533,40 @@ int bch2_fs_ec_init(struct bch_fs *c)
 	return bioset_init(&c->ec_bioset, 1, offsetof(struct ec_bio, bio),
 			   BIOSET_NEED_BVECS);
 }
+
+static int bch2_check_stripe_to_lru_ref(struct btree_trans *trans,
+					struct bkey_s_c k,
+					struct bkey_buf *last_flushed)
+{
+	if (k.k->type != KEY_TYPE_stripe)
+		return 0;
+
+	struct bkey_s_c_stripe s = bkey_s_c_to_stripe(k);
+
+	u64 lru_idx = stripe_lru_pos(s.v);
+	if (lru_idx) {
+		int ret = bch2_lru_check_set(trans, BCH_LRU_STRIPE_FRAGMENTATION,
+					     k.k->p.offset, lru_idx, k, last_flushed);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+int bch2_check_stripe_to_lru_refs(struct bch_fs *c)
+{
+	struct bkey_buf last_flushed;
+
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
+	int ret = bch2_trans_run(c,
+		for_each_btree_key_commit(trans, iter, BTREE_ID_stripes,
+				POS_MIN, BTREE_ITER_prefetch, k,
+				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+			bch2_check_stripe_to_lru_ref(trans, k, &last_flushed)));
+
+	bch2_bkey_buf_exit(&last_flushed, c);
+	bch_err_fn(c, ret);
+	return ret;
+}
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index 4c9511887655..cd1c837e4933 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -92,6 +92,31 @@ static inline void stripe_csum_set(struct bch_stripe *s,
 	memcpy(stripe_csum(s, block, csum_idx), &csum, bch_crc_bytes[s->csum_type]);
 }
 
+#define STRIPE_LRU_POS_EMPTY	1
+
+static inline u64 stripe_lru_pos(const struct bch_stripe *s)
+{
+	if (!s)
+		return 0;
+
+	unsigned blocks_empty = 0, blocks_nonempty = 0;
+
+	for (unsigned i = 0; i < s->nr_blocks; i++) {
+		blocks_empty	+=  !stripe_blockcount_get(s, i);
+		blocks_nonempty	+= !!stripe_blockcount_get(s, i);
+	}
+
+	/* Will be picked up by the stripe_delete worker */
+	if (!blocks_nonempty)
+		return STRIPE_LRU_POS_EMPTY;
+
+	if (!blocks_empty)
+		return 0;
+
+	/* invert: more blocks empty = reuse first */
+	return LRU_TIME_MAX - blocks_empty;
+}
+
 static inline bool __bch2_ptr_matches_stripe(const struct bch_extent_ptr *stripe_ptr,
 					     const struct bch_extent_ptr *data_ptr,
 					     unsigned sectors)
@@ -282,4 +307,6 @@ void bch2_fs_ec_exit(struct bch_fs *);
 void bch2_fs_ec_init_early(struct bch_fs *);
 int bch2_fs_ec_init(struct bch_fs *);
 
+int bch2_check_stripe_to_lru_refs(struct bch_fs *);
+
 #endif /* _BCACHEFS_EC_H */
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index 98ab8496f29d..a299d9ec8ee4 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -6,6 +6,7 @@
 #include "btree_iter.h"
 #include "btree_update.h"
 #include "btree_write_buffer.h"
+#include "ec.h"
 #include "error.h"
 #include "lru.h"
 #include "recovery.h"
@@ -124,6 +125,8 @@ static struct bbpos lru_pos_to_bp(struct bkey_s_c lru_k)
 	case BCH_LRU_read:
 	case BCH_LRU_fragmentation:
 		return BBPOS(BTREE_ID_alloc, u64_to_bucket(lru_k.k->p.offset));
+	case BCH_LRU_stripes:
+		return BBPOS(BTREE_ID_stripes, POS(0, lru_k.k->p.offset));
 	default:
 		BUG();
 	}
@@ -151,6 +154,10 @@ static u64 bkey_lru_type_idx(struct bch_fs *c,
 		rcu_read_unlock();
 		return idx;
 	}
+	case BCH_LRU_stripes:
+		return k.k->type == KEY_TYPE_stripe
+			? stripe_lru_pos(bkey_s_c_to_stripe(k).v)
+			: 0;
 	default:
 		BUG();
 	}
diff --git a/fs/bcachefs/lru.h b/fs/bcachefs/lru.h
index dea1d75cc9c1..8abd0aa2083a 100644
--- a/fs/bcachefs/lru.h
+++ b/fs/bcachefs/lru.h
@@ -28,9 +28,14 @@ static inline enum bch_lru_type lru_type(struct bkey_s_c l)
 {
 	u16 lru_id = l.k->p.inode >> 48;
 
-	if (lru_id == BCH_LRU_BUCKET_FRAGMENTATION)
+	switch (lru_id) {
+	case BCH_LRU_BUCKET_FRAGMENTATION:
 		return BCH_LRU_fragmentation;
-	return BCH_LRU_read;
+	case BCH_LRU_STRIPE_FRAGMENTATION:
+		return BCH_LRU_stripes;
+	default:
+		return BCH_LRU_read;
+	}
 }
 
 int bch2_lru_validate(struct bch_fs *, struct bkey_s_c, struct bkey_validate_context);
diff --git a/fs/bcachefs/lru_format.h b/fs/bcachefs/lru_format.h
index 353a352d3fb9..b7392ad8e41f 100644
--- a/fs/bcachefs/lru_format.h
+++ b/fs/bcachefs/lru_format.h
@@ -9,7 +9,8 @@ struct bch_lru {
 
 #define BCH_LRU_TYPES()		\
 	x(read)			\
-	x(fragmentation)
+	x(fragmentation)	\
+	x(stripes)
 
 enum bch_lru_type {
 #define x(n) BCH_LRU_##n,
@@ -18,6 +19,7 @@ enum bch_lru_type {
 };
 
 #define BCH_LRU_BUCKET_FRAGMENTATION	((1U << 16) - 1)
+#define BCH_LRU_STRIPE_FRAGMENTATION	((1U << 16) - 2)
 
 #define LRU_TIME_BITS			48
 #define LRU_TIME_MAX			((1ULL << LRU_TIME_BITS) - 1)
-- 
2.45.2

