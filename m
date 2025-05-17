Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E501D212FB8
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 19:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747509964; cv=none; b=MlzS8si0/iSVF/VLGOqHhXu85X/p/06YHMEno8BEvVhN/lslkZuiBawztWYVcby7n7I/90AwlJ/3dP+hihmCNzhKfis45OYLz5uZJ1vbrgyxQge4IluNP8cZLYQfZInXFxh6RRklaUAqW2dlullblNwwgCJYLmi9zZeOlVB3w08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747509964; c=relaxed/simple;
	bh=AbxitVDH1xWaOHmL5+NuuvPu4ku3LwdOx0FfuxlYavI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agDJfCgfdn4eN0r/sNMfMvml/v2jThkh4pvaY1XkF9FP4TSqXNKlWpajNYL1MHDDHi8n5xb2qcwLyphRIhiREufLNrhl5zWvfyd9XckocPgpz3nIBKokq2M8ktc4gZOzyRr8yjAjLaXNQtT17Pa6+uDOih8ibivkA7yaPkKWY9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=daUjXcx0; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="daUjXcx0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747509959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q3q6PlL2kwuERDrJG6bea9F6pwSDOStwgtlnBD0sfvs=;
	b=daUjXcx0O05gEnUhC6ijE0nBRjYxbeImKMDpbhQbRGt25KA46LZ4Ot8RHy9ngG7EoCQgGs
	wxmC8KRhPbnjb4CpRiRZRrSfd9mzgLPZ3kQNCDDtLUjyJoy6+qN4HceIZ2HbJPKVZn1JTX
	YPBwyXpgsB9+SLc0wjCOTPTjkzoYUgY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/8] bcachefs: bch2_check_bucket_backpointer_mismatch()
Date: Sat, 17 May 2025 15:25:45 -0400
Message-ID: <20250517192547.3849149-9-kent.overstreet@linux.dev>
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

Detect buckets with missing backpointers, and run repair on demand.

__bch2_move_data_phys() now calls
bch2_check_bucket_backpointer_mismatch() as it walks buckets, which
checks for missing backpointers by comparing backpointers against bucket
sector counts.

When missing backpointers are detected, we kick off
bch2_check_extents_to_backpointers() asynchronously - right away if
we're trying to evacuate, or with a threshold if we're just running
copygc.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c |  7 +++-
 fs/bcachefs/backpointers.c     | 75 +++++++++++++++++++++++++++++++---
 fs/bcachefs/backpointers.h     |  3 +-
 fs/bcachefs/move.c             | 21 ++++++++--
 fs/bcachefs/movinggc.c         |  3 ++
 5 files changed, 98 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 88e710ba2685..a38b9c6c891e 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -2175,8 +2175,11 @@ static int invalidate_one_bucket(struct btree_trans *trans,
 	BUG_ON(a->data_type != BCH_DATA_cached);
 	BUG_ON(a->dirty_sectors);
 
-	if (!a->cached_sectors)
-		bch_err(c, "invalidating empty bucket, confused");
+	if (!a->cached_sectors) {
+		bch2_check_bucket_backpointer_mismatch(trans, ca, bucket.offset,
+						       true, last_flushed);
+		goto out;
+	}
 
 	unsigned cached_sectors = a->cached_sectors;
 	u8 gen = a->gen;
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 6b98ce1ed6c9..c08bc6685078 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -12,6 +12,7 @@
 #include "disk_accounting.h"
 #include "error.h"
 #include "progress.h"
+#include "recovery_passes.h"
 
 #include <linux/mm.h>
 
@@ -804,6 +805,13 @@ static int bch2_get_btree_in_memory_pos(struct btree_trans *trans,
 	return ret;
 }
 
+static inline int bch2_fs_going_ro(struct bch_fs *c)
+{
+	return test_bit(BCH_FS_going_ro, &c->flags)
+		? -EROFS
+		: 0;
+}
+
 static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 						   struct extents_to_bp_state *s)
 {
@@ -831,6 +839,7 @@ static int bch2_check_extents_to_backpointers_pass(struct btree_trans *trans,
 
 			ret = for_each_btree_key_continue(trans, iter, 0, k, ({
 				bch2_progress_update_iter(trans, &progress, &iter, "extents_to_backpointers");
+				bch2_fs_going_ro(c) ?:
 				check_extent_to_backpointers(trans, s, btree_id, level, k) ?:
 				bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
 			}));
@@ -870,6 +879,7 @@ static int data_type_to_alloc_counter(enum bch_data_type t)
 static int check_bucket_backpointers_to_extents(struct btree_trans *, struct bch_dev *, struct bpos);
 
 static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct bkey_s_c alloc_k,
+					     bool *had_mismatch,
 					     struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
@@ -877,6 +887,8 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(alloc_k, &a_convert);
 	bool need_commit = false;
 
+	*had_mismatch = false;
+
 	if (a->data_type == BCH_DATA_sb ||
 	    a->data_type == BCH_DATA_journal ||
 	    a->data_type == BCH_DATA_parity)
@@ -957,6 +969,8 @@ static int check_bucket_backpointer_mismatch(struct btree_trans *trans, struct b
 			 ? bch2_bucket_bitmap_set(ca, &ca->bucket_backpointer_empty,
 						  alloc_k.k->p.offset)
 			 : 0);
+
+		*had_mismatch = true;
 	}
 err:
 	bch2_dev_put(ca);
@@ -1104,7 +1118,9 @@ int bch2_check_extents_to_backpointers(struct bch_fs *c)
 
 	ret = for_each_btree_key(trans, iter, BTREE_ID_alloc,
 				 POS_MIN, BTREE_ITER_prefetch, k, ({
-		check_bucket_backpointer_mismatch(trans, k, &s.last_flushed);
+		bool had_mismatch;
+		bch2_fs_going_ro(c) ?:
+		check_bucket_backpointer_mismatch(trans, k, &had_mismatch, &s.last_flushed);
 	}));
 	if (ret)
 		goto err;
@@ -1150,20 +1166,69 @@ int bch2_check_extents_to_backpointers(struct bch_fs *c)
 
 		s.bp_start = bpos_successor(s.bp_end);
 	}
-err:
-	bch2_trans_put(trans);
-	bch2_bkey_buf_exit(&s.last_flushed, c);
-	bch2_btree_cache_unpin(c);
 
 	for_each_member_device(c, ca) {
 		bch2_bucket_bitmap_free(&ca->bucket_backpointer_mismatch);
 		bch2_bucket_bitmap_free(&ca->bucket_backpointer_empty);
 	}
+err:
+	bch2_trans_put(trans);
+	bch2_bkey_buf_exit(&s.last_flushed, c);
+	bch2_btree_cache_unpin(c);
 
 	bch_err_fn(c, ret);
 	return ret;
 }
 
+static int check_bucket_backpointer_pos_mismatch(struct btree_trans *trans,
+						 struct bpos bucket,
+						 bool *had_mismatch,
+						 struct bkey_buf *last_flushed)
+{
+	struct btree_iter alloc_iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &alloc_iter,
+					       BTREE_ID_alloc, bucket,
+					       BTREE_ITER_cached);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	ret = check_bucket_backpointer_mismatch(trans, k, had_mismatch, last_flushed);
+	bch2_trans_iter_exit(trans, &alloc_iter);
+	return ret;
+}
+
+int bch2_check_bucket_backpointer_mismatch(struct btree_trans *trans,
+					   struct bch_dev *ca, u64 bucket,
+					   bool copygc,
+					   struct bkey_buf *last_flushed)
+{
+	struct bch_fs *c = trans->c;
+	bool had_mismatch;
+	int ret = lockrestart_do(trans,
+		check_bucket_backpointer_pos_mismatch(trans, POS(ca->dev_idx, bucket),
+						      &had_mismatch, last_flushed));
+	if (ret || !had_mismatch)
+		return ret;
+
+	u64 nr = ca->bucket_backpointer_mismatch.nr;
+	u64 allowed = copygc ? ca->mi.nbuckets >> 7 : 0;
+
+	struct printbuf buf = PRINTBUF;
+	__bch2_log_msg_start(ca->name, &buf);
+
+	prt_printf(&buf, "Detected missing backpointers in bucket %llu, now have %llu/%llu with missing\n",
+		   bucket, nr, ca->mi.nbuckets);
+
+	bch2_run_explicit_recovery_pass(c, &buf,
+			BCH_RECOVERY_PASS_check_extents_to_backpointers,
+			nr < allowed ? RUN_RECOVERY_PASS_ratelimit : 0);
+
+	bch2_print_str(c, KERN_ERR, buf.buf);
+	printbuf_exit(&buf);
+	return 0;
+}
+
 /* backpointers -> extents */
 
 static int check_one_backpointer(struct btree_trans *trans,
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index fe7149a2fbf5..6840561084ce 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -182,7 +182,8 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *, struct bkey_s_c_b
 struct btree *bch2_backpointer_get_node(struct btree_trans *, struct bkey_s_c_backpointer,
 					struct btree_iter *, struct bkey_buf *);
 
-int bch2_check_bucket_backpointer_mismatch(struct btree_trans *, struct bpos, struct bkey_buf *);
+int bch2_check_bucket_backpointer_mismatch(struct btree_trans *, struct bch_dev *, u64,
+					   bool, struct bkey_buf *);
 
 int bch2_check_btree_backpointers(struct bch_fs *);
 int bch2_check_extents_to_backpointers(struct bch_fs *);
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 49898d5743d4..0dd3bec3acff 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -815,6 +815,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 			u64 bucket_start,
 			u64 bucket_end,
 			unsigned data_types,
+			bool copygc,
 			move_pred_fn pred, void *arg)
 {
 	struct btree_trans *trans = ctxt->trans;
@@ -825,6 +826,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 	struct bkey_buf sk;
 	struct bkey_s_c k;
 	struct bkey_buf last_flushed;
+	u64 check_mismatch_done = bucket_start;
 	int ret = 0;
 
 	struct bch_dev *ca = bch2_dev_tryget(c, dev);
@@ -835,8 +837,6 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 
 	struct bpos bp_start	= bucket_pos_to_bp_start(ca, POS(dev, bucket_start));
 	struct bpos bp_end	= bucket_pos_to_bp_end(ca, POS(dev, bucket_end));
-	bch2_dev_put(ca);
-	ca = NULL;
 
 	bch2_bkey_buf_init(&last_flushed);
 	bkey_init(&last_flushed.k->k);
@@ -871,6 +871,14 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		if (!k.k || bkey_gt(k.k->p, bp_end))
 			break;
 
+		if (check_mismatch_done < bp_pos_to_bucket(ca, k.k->p).offset) {
+			while (check_mismatch_done < bp_pos_to_bucket(ca, k.k->p).offset) {
+				bch2_check_bucket_backpointer_mismatch(trans, ca, check_mismatch_done++,
+								       copygc, &last_flushed);
+			}
+			continue;
+		}
+
 		if (k.k->type != KEY_TYPE_backpointer)
 			goto next;
 
@@ -946,10 +954,15 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 next:
 		bch2_btree_iter_advance(trans, &bp_iter);
 	}
+
+	while (check_mismatch_done < bucket_end)
+		bch2_check_bucket_backpointer_mismatch(trans, ca, check_mismatch_done++,
+						       copygc, &last_flushed);
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
 	bch2_bkey_buf_exit(&sk, c);
 	bch2_bkey_buf_exit(&last_flushed, c);
+	bch2_dev_put(ca);
 	return ret;
 }
 
@@ -974,7 +987,8 @@ int bch2_move_data_phys(struct bch_fs *c,
 		ctxt.stats->data_type = (int) DATA_PROGRESS_DATA_TYPE_phys;
 	}
 
-	int ret = __bch2_move_data_phys(&ctxt, NULL, dev, start, end, data_types, pred, arg);
+	int ret = __bch2_move_data_phys(&ctxt, NULL, dev, start, end,
+					data_types, false, pred, arg);
 	bch2_moving_ctxt_exit(&ctxt);
 
 	return ret;
@@ -1019,6 +1033,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 				   bucket.offset,
 				   bucket.offset + 1,
 				   ~0,
+				   true,
 				   evacuate_bucket_pred, &arg);
 }
 
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 0a751a65386f..7cb0b3d347b4 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -75,6 +75,9 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 	if (!ca)
 		goto out;
 
+	if (bch2_bucket_bitmap_test(&ca->bucket_backpointer_mismatch, b->k.bucket.offset))
+		goto out;
+
 	if (ca->mi.state != BCH_MEMBER_STATE_rw ||
 	    !bch2_dev_is_online(ca))
 		goto out;
-- 
2.49.0

