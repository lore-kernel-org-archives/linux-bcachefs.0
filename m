Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9592BAF9
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894315; cv=none; b=PDXeRLUTvoQPw8SXtJK2LwpjCKvN8CoGTzZeqztEIOmzQbU29gJZCxQFY/pIPKQeItUuxqYIIHxpHQjgT9KKNwmIR24NLbCCvtoNnuMycq8FQCEcUdoJ16LxPYlGZCCgdAcTDVxr1Z0C2jcZYrAslvpROHzATF0KEMwyojr0zaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894315; c=relaxed/simple;
	bh=A5a2A8Jkuuy7ba/AHVWDx5g4vCLE/sqrm0OuxiQjEdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjJkFSoND9eBxWlSyhUdpQu+ELjJNnqmFSo4R46wY4jW8pGooR4ey4ywjypq48O2nXU2MIoBIl1mUulEAAdh3b997lDoq+acC8s21I1KDdXUbhy5iHFQl7pXpVVLoX52moHHfCKeLhozBgXET81uK4ycqGzZaSGQzJYD/S41fLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YSS9XxeI; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YSS9XxeI"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aJFwAE/rKUk3W9mPwJmjta3M/KBt+EkO0PPpkcIXu/U=;
	b=YSS9XxeIMEmo+aqYiknpucujwGL0GhceOpF9mmUnWtZXqT7+x8L0PHilCTitXnb+7r+OxZ
	9w4Zo4ZXsjEox3UxfRrm6iTLXnQePlKuab/llIsccHyj/SguT/jV1buegXkOE66OlaOL6f
	tz5YvhwB/TGzFM44keE2JmMO9yykLF0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/7] bcachefs: bch_backpointer -> bkey_i_backpointer
Date: Sun, 17 Nov 2024 20:44:45 -0500
Message-ID: <20241118014451.2275941-5-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since we no longer store backpointers in alloc keys, there's no reason
not to pass around bkey_i_backpointers; this means we don't have to pass
the bucket pos separately.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 215 +++++++++++++++----------------------
 fs/bcachefs/backpointers.h |  51 ++++-----
 fs/bcachefs/buckets.c      |   8 +-
 fs/bcachefs/ec.c           |   2 +-
 4 files changed, 111 insertions(+), 165 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index a9ffbea277bd..d5f17767a72c 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -14,40 +14,6 @@
 
 #include <linux/mm.h>
 
-static bool extent_matches_bp(struct bch_fs *c,
-			      enum btree_id btree_id, unsigned level,
-			      struct bkey_s_c k,
-			      struct bpos bucket,
-			      struct bch_backpointer bp)
-{
-	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-	const union bch_extent_entry *entry;
-	struct extent_ptr_decoded p;
-
-	rcu_read_lock();
-	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		struct bpos bucket2;
-		struct bch_backpointer bp2;
-
-		if (p.ptr.cached)
-			continue;
-
-		struct bch_dev *ca = bch2_dev_rcu(c, p.ptr.dev);
-		if (!ca)
-			continue;
-
-		bch2_extent_ptr_to_bp(c, ca, btree_id, level, k, p, entry, &bucket2, &bp2);
-		if (bpos_eq(bucket, bucket2) &&
-		    !memcmp(&bp, &bp2, sizeof(bp))) {
-			rcu_read_unlock();
-			return true;
-		}
-	}
-	rcu_read_unlock();
-
-	return false;
-}
-
 int bch2_backpointer_validate(struct bch_fs *c, struct bkey_s_c k,
 			      enum bch_validate_flags flags)
 {
@@ -74,23 +40,15 @@ int bch2_backpointer_validate(struct bch_fs *c, struct bkey_s_c k,
 	bkey_fsck_err_on((bp.v->bucket_offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT) >= ca->mi.bucket_size ||
 			 !bpos_eq(bp.k->p, bp_pos),
 			 c, backpointer_bucket_offset_wrong,
-			 "backpointer bucket_offset wrong");
+			 "backpointer bucket_offset wrong (%llu)", (u64) bp.v->bucket_offset);
 fsck_err:
 	return ret;
 }
 
-void bch2_backpointer_to_text(struct printbuf *out, const struct bch_backpointer *bp)
+void bch2_backpointer_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
 {
-	bch2_btree_id_level_to_text(out, bp->btree_id, bp->level);
-	prt_printf(out, " offset=%llu:%u len=%u pos=",
-		   (u64) (bp->bucket_offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT),
-		   (u32) bp->bucket_offset & ~(~0U << MAX_EXTENT_COMPRESS_RATIO_SHIFT),
-		   bp->bucket_len);
-	bch2_bpos_to_text(out, bp->pos);
-}
+	struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 
-void bch2_backpointer_k_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
-{
 	rcu_read_lock();
 	struct bch_dev *ca = bch2_dev_rcu_noerror(c, k.k->p.inode);
 	if (ca) {
@@ -103,7 +61,12 @@ void bch2_backpointer_k_to_text(struct printbuf *out, struct bch_fs *c, struct b
 		rcu_read_unlock();
 	}
 
-	bch2_backpointer_to_text(out, bkey_s_c_to_backpointer(k).v);
+	bch2_btree_id_level_to_text(out, bp.v->btree_id, bp.v->level);
+	prt_printf(out, " offset=%llu:%u len=%u pos=",
+		   (u64) (bp.v->bucket_offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT),
+		   (u32) bp.v->bucket_offset & ~(~0U << MAX_EXTENT_COMPRESS_RATIO_SHIFT),
+		   bp.v->bucket_len);
+	bch2_bpos_to_text(out, bp.v->pos);
 }
 
 void bch2_backpointer_swab(struct bkey_s k)
@@ -115,10 +78,43 @@ void bch2_backpointer_swab(struct bkey_s k)
 	bch2_bpos_swab(&bp.v->pos);
 }
 
+static bool extent_matches_bp(struct bch_fs *c,
+			      enum btree_id btree_id, unsigned level,
+			      struct bkey_s_c k,
+			      struct bkey_s_c_backpointer bp)
+{
+	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
+	const union bch_extent_entry *entry;
+	struct extent_ptr_decoded p;
+
+	rcu_read_lock();
+	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
+		struct bpos bucket2;
+		struct bkey_i_backpointer bp2;
+
+		if (p.ptr.cached)
+			continue;
+
+		struct bch_dev *ca = bch2_dev_rcu(c, p.ptr.dev);
+		if (!ca)
+			continue;
+
+		bch2_extent_ptr_to_bp(c, ca, btree_id, level, k, p, entry, &bucket2, &bp2);
+		if (bpos_eq(bp.k->p, bp2.k.p) &&
+		    !memcmp(bp.v, &bp2.v, sizeof(bp2.v))) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+
+	return false;
+}
+
 static noinline int backpointer_mod_err(struct btree_trans *trans,
-					struct bch_backpointer bp,
-					struct bkey_s_c bp_k,
 					struct bkey_s_c orig_k,
+					struct bkey_i_backpointer *new_bp,
+					struct bkey_s_c found_bp,
 					bool insert)
 {
 	struct bch_fs *c = trans->c;
@@ -126,12 +122,12 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 
 	if (insert) {
 		prt_printf(&buf, "existing backpointer found when inserting ");
-		bch2_backpointer_to_text(&buf, &bp);
+		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&new_bp->k_i));
 		prt_newline(&buf);
 		printbuf_indent_add(&buf, 2);
 
 		prt_printf(&buf, "found ");
-		bch2_bkey_val_to_text(&buf, c, bp_k);
+		bch2_bkey_val_to_text(&buf, c, found_bp);
 		prt_newline(&buf);
 
 		prt_printf(&buf, "for ");
@@ -143,11 +139,11 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 		printbuf_indent_add(&buf, 2);
 
 		prt_printf(&buf, "searching for ");
-		bch2_backpointer_to_text(&buf, &bp);
+		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&new_bp->k_i));
 		prt_newline(&buf);
 
 		prt_printf(&buf, "got ");
-		bch2_bkey_val_to_text(&buf, c, bp_k);
+		bch2_bkey_val_to_text(&buf, c, found_bp);
 		prt_newline(&buf);
 
 		prt_printf(&buf, "for ");
@@ -166,50 +162,35 @@ static noinline int backpointer_mod_err(struct btree_trans *trans,
 }
 
 int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *trans,
-				struct bch_dev *ca,
-				struct bpos bucket,
-				struct bch_backpointer bp,
 				struct bkey_s_c orig_k,
+				struct bkey_i_backpointer *bp,
 				bool insert)
 {
 	struct btree_iter bp_iter;
-	struct bkey_s_c k;
-	struct bkey_i_backpointer *bp_k;
-	int ret;
-
-	bp_k = bch2_trans_kmalloc_nomemzero(trans, sizeof(struct bkey_i_backpointer));
-	ret = PTR_ERR_OR_ZERO(bp_k);
-	if (ret)
-		return ret;
-
-	bkey_backpointer_init(&bp_k->k_i);
-	bp_k->k.p = bucket_pos_to_bp(ca, bucket, bp.bucket_offset);
-	bp_k->v = bp;
-
-	if (!insert) {
-		bp_k->k.type = KEY_TYPE_deleted;
-		set_bkey_val_u64s(&bp_k->k, 0);
-	}
-
-	k = bch2_bkey_get_iter(trans, &bp_iter, BTREE_ID_backpointers,
-			       bp_k->k.p,
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &bp_iter, BTREE_ID_backpointers,
+			       bp->k.p,
 			       BTREE_ITER_intent|
 			       BTREE_ITER_slots|
 			       BTREE_ITER_with_updates);
-	ret = bkey_err(k);
+	int ret = bkey_err(k);
 	if (ret)
-		goto err;
+		return ret;
 
 	if (insert
 	    ? k.k->type
 	    : (k.k->type != KEY_TYPE_backpointer ||
-	       memcmp(bkey_s_c_to_backpointer(k).v, &bp, sizeof(bp)))) {
-		ret = backpointer_mod_err(trans, bp, k, orig_k, insert);
+	       memcmp(bkey_s_c_to_backpointer(k).v, &bp->v, sizeof(bp->v)))) {
+		ret = backpointer_mod_err(trans, orig_k, bp, k, insert);
 		if (ret)
 			goto err;
 	}
 
-	ret = bch2_trans_update(trans, &bp_iter, &bp_k->k_i, 0);
+	if (!insert) {
+		bp->k.type = KEY_TYPE_deleted;
+		set_bkey_val_u64s(&bp->k, 0);
+	}
+
+	ret = bch2_trans_update(trans, &bp_iter, &bp->k_i, 0);
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
 	return ret;
@@ -230,22 +211,11 @@ static void backpointer_target_not_found(struct btree_trans *trans,
 	if (likely(!bch2_backpointers_no_use_write_buffer))
 		return;
 
-	struct bpos bucket;
-	if (!bp_pos_to_bucket_nodev(c, bp.k->p, &bucket))
-		return;
-
 	prt_printf(&buf, "backpointer doesn't match %s it points to:\n  ",
 		   bp.v->level ? "btree node" : "extent");
-	prt_printf(&buf, "bucket: ");
-	bch2_bpos_to_text(&buf, bucket);
-	prt_printf(&buf, "\n  ");
-
-	prt_printf(&buf, "backpointer pos: ");
-	bch2_bpos_to_text(&buf, bp.k->p);
+	bch2_bkey_val_to_text(&buf, c, bp.s_c);
 	prt_printf(&buf, "\n  ");
 
-	bch2_backpointer_to_text(&buf, bp.v);
-	prt_printf(&buf, "\n  ");
 	bch2_bkey_val_to_text(&buf, c, target_k);
 	if (c->curr_recovery_pass >= BCH_RECOVERY_PASS_check_extents_to_backpointers)
 		bch_err_ratelimited(c, "%s", buf.buf);
@@ -263,10 +233,6 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 	if (likely(!bp.v->level)) {
 		struct bch_fs *c = trans->c;
 
-		struct bpos bucket;
-		if (!bp_pos_to_bucket_nodev(c, bp.k->p, &bucket))
-			return bkey_s_c_err(-EIO);
-
 		bch2_trans_node_iter_init(trans, iter,
 					  bp.v->btree_id,
 					  bp.v->pos,
@@ -279,7 +245,7 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 		}
 
 		if (k.k &&
-		    extent_matches_bp(c, bp.v->btree_id, bp.v->level, k, bucket, *bp.v))
+		    extent_matches_bp(c, bp.v->btree_id, bp.v->level, k, bp))
 			return k;
 
 		bch2_trans_iter_exit(trans, iter);
@@ -304,10 +270,6 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 
 	BUG_ON(!bp.v->level);
 
-	struct bpos bucket;
-	if (!bp_pos_to_bucket_nodev(c, bp.k->p, &bucket))
-		return ERR_PTR(-EIO);
-
 	bch2_trans_node_iter_init(trans, iter,
 				  bp.v->btree_id,
 				  bp.v->pos,
@@ -321,8 +283,7 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 	BUG_ON(b->c.level != bp.v->level - 1);
 
 	if (extent_matches_bp(c, bp.v->btree_id, bp.v->level,
-			      bkey_i_to_s_c(&b->key),
-			      bucket, *bp.v))
+			      bkey_i_to_s_c(&b->key), bp))
 		return b;
 
 	if (btree_node_will_make_reachable(b)) {
@@ -476,8 +437,7 @@ static int check_extent_checksum(struct btree_trans *trans,
 
 static int check_bp_exists(struct btree_trans *trans,
 			   struct extents_to_bp_state *s,
-			   struct bpos bucket,
-			   struct bch_backpointer bp,
+			   struct bkey_i_backpointer *bp,
 			   struct bkey_s_c orig_k)
 {
 	struct bch_fs *c = trans->c;
@@ -487,30 +447,28 @@ static int check_bp_exists(struct btree_trans *trans,
 	struct bkey_s_c bp_k;
 	int ret = 0;
 
-	struct bch_dev *ca = bch2_dev_bucket_tryget(c, bucket);
+	struct bch_dev *ca = bch2_dev_tryget_noerror(c, bp->k.p.inode);
 	if (!ca) {
-		prt_str(&buf, "extent for nonexistent device:bucket ");
-		bch2_bpos_to_text(&buf, bucket);
-		prt_str(&buf, "\n  ");
+		prt_printf(&buf, "extent for nonexistent device %llu\n", bp->k.p.inode);
 		bch2_bkey_val_to_text(&buf, c, orig_k);
 		bch_err(c, "%s", buf.buf);
 		ret = -BCH_ERR_fsck_repair_unimplemented;
 		goto err;
 	}
 
+	struct bpos bucket = bp_pos_to_bucket(ca, bp->k.p);
+
 	if (bpos_lt(bucket, s->bucket_start) ||
 	    bpos_gt(bucket, s->bucket_end))
 		goto out;
 
-	bp_k = bch2_bkey_get_iter(trans, &bp_iter, BTREE_ID_backpointers,
-				  bucket_pos_to_bp(ca, bucket, bp.bucket_offset),
-				  0);
+	bp_k = bch2_bkey_get_iter(trans, &bp_iter, BTREE_ID_backpointers, bp->k.p, 0);
 	ret = bkey_err(bp_k);
 	if (ret)
 		goto err;
 
 	if (bp_k.k->type != KEY_TYPE_backpointer ||
-	    memcmp(bkey_s_c_to_backpointer(bp_k).v, &bp, sizeof(bp))) {
+	    memcmp(bkey_s_c_to_backpointer(bp_k).v, &bp->v, sizeof(bp->v))) {
 		ret = bch2_btree_write_buffer_maybe_flush(trans, orig_k, &s->last_flushed);
 		if (ret)
 			goto err;
@@ -557,14 +515,17 @@ static int check_bp_exists(struct btree_trans *trans,
 				goto err;
 			goto out;
 		} else {
-			ret = drop_dev_and_update(trans, bp.btree_id, orig_k, bucket.inode);
+			ret = drop_dev_and_update(trans, bp->v.btree_id, orig_k, bucket.inode);
 			if (ret)
 				goto err;
 			goto missing;
 		}
 	}
 
-	ret = check_extent_checksum(trans, other_bp.v->btree_id, other_extent, bp.btree_id, orig_k, bucket.inode);
+	ret = check_extent_checksum(trans,
+				    other_bp.v->btree_id, other_extent,
+				    bp->v.btree_id, orig_k,
+				    bucket.inode);
 	if (ret < 0)
 		goto err;
 	if (ret) {
@@ -572,7 +533,8 @@ static int check_bp_exists(struct btree_trans *trans,
 		goto missing;
 	}
 
-	ret = check_extent_checksum(trans, bp.btree_id, orig_k, other_bp.v->btree_id, other_extent, bucket.inode);
+	ret = check_extent_checksum(trans, bp->v.btree_id, orig_k,
+				    other_bp.v->btree_id, other_extent, bucket.inode);
 	if (ret < 0)
 		goto err;
 	if (ret) {
@@ -590,22 +552,15 @@ static int check_bp_exists(struct btree_trans *trans,
 	goto err;
 missing:
 	printbuf_reset(&buf);
-	prt_str(&buf, "missing backpointer for btree=");
-	bch2_btree_id_to_text(&buf, bp.btree_id);
-	prt_printf(&buf, " l=%u ", bp.level);
+	prt_str(&buf, "missing backpointer ");
+	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&bp->k_i));
+	prt_newline(&buf);
 	bch2_bkey_val_to_text(&buf, c, orig_k);
 	prt_printf(&buf, "\n  got:   ");
 	bch2_bkey_val_to_text(&buf, c, bp_k);
 
-	struct bkey_i_backpointer n_bp_k;
-	bkey_backpointer_init(&n_bp_k.k_i);
-	n_bp_k.k.p = bucket_pos_to_bp(ca, bucket, bp.bucket_offset);
-	n_bp_k.v = bp;
-	prt_printf(&buf, "\n  want:  ");
-	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&n_bp_k.k_i));
-
 	if (fsck_err(trans, ptr_to_missing_backpointer, "%s", buf.buf))
-		ret = bch2_bucket_backpointer_mod(trans, ca, bucket, bp, orig_k, true);
+		ret = bch2_bucket_backpointer_mod(trans, orig_k, bp, true);
 
 	goto out;
 }
@@ -623,8 +578,8 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 
 	ptrs = bch2_bkey_ptrs_c(k);
 	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		struct bpos bucket_pos = POS_MIN;
-		struct bch_backpointer bp;
+		struct bpos bucket_pos;
+		struct bkey_i_backpointer bp;
 
 		if (p.ptr.cached)
 			continue;
@@ -638,7 +593,7 @@ static int check_extent_to_backpointers(struct btree_trans *trans,
 		if (!ca)
 			continue;
 
-		ret = check_bp_exists(trans, s, bucket_pos, bp, k);
+		ret = check_bp_exists(trans, s, &bp, k);
 		if (ret)
 			return ret;
 	}
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 595db7960939..5f34a25b599a 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -19,13 +19,12 @@ static inline u64 swab40(u64 x)
 }
 
 int bch2_backpointer_validate(struct bch_fs *, struct bkey_s_c k, enum bch_validate_flags);
-void bch2_backpointer_to_text(struct printbuf *, const struct bch_backpointer *);
-void bch2_backpointer_k_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
+void bch2_backpointer_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
 void bch2_backpointer_swab(struct bkey_s);
 
 #define bch2_bkey_ops_backpointer ((struct bkey_ops) {	\
 	.key_validate	= bch2_backpointer_validate,	\
-	.val_to_text	= bch2_backpointer_k_to_text,	\
+	.val_to_text	= bch2_backpointer_to_text,	\
 	.swab		= bch2_backpointer_swab,	\
 	.min_val_size	= 32,				\
 })
@@ -53,12 +52,6 @@ static inline bool bp_pos_to_bucket_nodev_noerror(struct bch_fs *c, struct bpos
 	return ca != NULL;
 }
 
-static inline bool bp_pos_to_bucket_nodev(struct bch_fs *c, struct bpos bp_pos, struct bpos *bucket)
-{
-	return !bch2_fs_inconsistent_on(!bp_pos_to_bucket_nodev_noerror(c, bp_pos, bucket),
-					c, "backpointer for missing device %llu", bp_pos.inode);
-}
-
 static inline struct bpos bucket_pos_to_bp_noerror(const struct bch_dev *ca,
 						   struct bpos bucket,
 						   u64 bucket_offset)
@@ -90,31 +83,25 @@ static inline struct bpos bucket_pos_to_bp_end(const struct bch_dev *ca, struct
 	return bpos_nosnap_predecessor(bucket_pos_to_bp(ca, bpos_nosnap_successor(bucket), 0));
 }
 
-int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *, struct bch_dev *,
-				struct bpos bucket, struct bch_backpointer, struct bkey_s_c, bool);
+int bch2_bucket_backpointer_mod_nowritebuffer(struct btree_trans *,
+				struct bkey_s_c,
+				struct bkey_i_backpointer *,
+				bool);
 
 static inline int bch2_bucket_backpointer_mod(struct btree_trans *trans,
-				struct bch_dev *ca,
-				struct bpos bucket,
-				struct bch_backpointer bp,
 				struct bkey_s_c orig_k,
+				struct bkey_i_backpointer *bp,
 				bool insert)
 {
 	if (unlikely(bch2_backpointers_no_use_write_buffer))
-		return bch2_bucket_backpointer_mod_nowritebuffer(trans, ca, bucket, bp, orig_k, insert);
-
-	struct bkey_i_backpointer bp_k;
-
-	bkey_backpointer_init(&bp_k.k_i);
-	bp_k.k.p = bucket_pos_to_bp(ca, bucket, bp.bucket_offset);
-	bp_k.v = bp;
+		return bch2_bucket_backpointer_mod_nowritebuffer(trans, orig_k, bp, insert);
 
 	if (!insert) {
-		bp_k.k.type = KEY_TYPE_deleted;
-		set_bkey_val_u64s(&bp_k.k, 0);
+		bp->k.type = KEY_TYPE_deleted;
+		set_bkey_val_u64s(&bp->k, 0);
 	}
 
-	return bch2_trans_update_buffered(trans, BTREE_ID_backpointers, &bp_k.k_i);
+	return bch2_trans_update_buffered(trans, BTREE_ID_backpointers, &bp->k_i);
 }
 
 static inline enum bch_data_type bch2_bkey_ptr_data_type(struct bkey_s_c k,
@@ -148,17 +135,21 @@ static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bpos *bucket_pos, struct bch_backpointer *bp,
+			   struct bpos *bucket, struct bkey_i_backpointer *bp,
 			   u64 sectors)
 {
 	u32 bucket_offset;
-	*bucket_pos = PTR_BUCKET_POS_OFFSET(ca, &p.ptr, &bucket_offset);
-	*bp = (struct bch_backpointer) {
+	*bucket = PTR_BUCKET_POS_OFFSET(ca, &p.ptr, &bucket_offset);
+
+	u64 bp_bucket_offset = ((u64) bucket_offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset;
+
+	bkey_backpointer_init(&bp->k_i);
+	bp->k.p = bucket_pos_to_bp(ca, *bucket, bp_bucket_offset);
+	bp->v	= (struct bch_backpointer) {
 		.btree_id	= btree_id,
 		.level		= level,
 		.data_type	= bch2_bkey_ptr_data_type(k, p, entry),
-		.bucket_offset	= ((u64) bucket_offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) +
-			p.crc.offset,
+		.bucket_offset	= bp_bucket_offset,
 		.bucket_len	= sectors,
 		.pos		= k.k->p,
 	};
@@ -168,7 +159,7 @@ static inline void bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bpos *bucket_pos, struct bch_backpointer *bp)
+			   struct bpos *bucket_pos, struct bkey_i_backpointer *bp)
 {
 	u64 sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
 
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 5b42f0a7b0cb..1547141ba2a0 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -585,18 +585,18 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 	}
 
 	struct bpos bucket;
-	struct bch_backpointer bp;
+	struct bkey_i_backpointer bp;
 	__bch2_extent_ptr_to_bp(trans->c, ca, btree_id, level, k, p, entry, &bucket, &bp, abs_sectors);
 
 	if (flags & BTREE_TRIGGER_transactional) {
 		struct bkey_i_alloc_v4 *a = bch2_trans_start_alloc_update(trans, bucket, 0);
 		ret = PTR_ERR_OR_ZERO(a) ?:
-			__mark_pointer(trans, ca, k, &p, *sectors, bp.data_type, &a->v);
+			__mark_pointer(trans, ca, k, &p, *sectors, bp.v.data_type, &a->v);
 		if (ret)
 			goto err;
 
 		if (!p.ptr.cached) {
-			ret = bch2_bucket_backpointer_mod(trans, ca, bucket, bp, k, insert);
+			ret = bch2_bucket_backpointer_mod(trans, k, &bp, insert);
 			if (ret)
 				goto err;
 		}
@@ -614,7 +614,7 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 
 		bucket_lock(g);
 		struct bch_alloc_v4 old = bucket_m_to_alloc(*g), new = old;
-		ret = __mark_pointer(trans, ca, k, &p, *sectors, bp.data_type, &new);
+		ret = __mark_pointer(trans, ca, k, &p, *sectors, bp.v.data_type, &new);
 		alloc_to_bucket(g, new);
 		bucket_unlock(g);
 err_unlock:
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index a4a2555d7c4f..f6b7b8b54f62 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1300,7 +1300,7 @@ static int ec_stripe_update_extent(struct btree_trans *trans,
 			return 0;
 
 		prt_printf(&buf, "found btree node in erasure coded bucket: b=%px\n", b);
-		bch2_backpointer_to_text(&buf, bp.v);
+		bch2_bkey_val_to_text(&buf, c, bp.s_c);
 
 		bch2_fs_inconsistent(c, "%s", buf.buf);
 		printbuf_exit(&buf);
-- 
2.45.2

