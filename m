Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB3925F984
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Aug 2025 06:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756450461; cv=none; b=cuxABH4+N5czTnN2qbGlHnmgKWgon2gIlqAL5Yl8o9eERwiTZmoPfCB3TNCIjv2qolPeoa5hCKIqpYbaWSU3m6wfVeBZbIzckAm1G7sxdAizPEzZXRRmdscnORTVX5HL2f5bkZRh+wpDY5RDgaVBdCwNTw4wt8RdeW5vCXaulRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756450461; c=relaxed/simple;
	bh=1aBFSe1fPLxzeZsXjaJzwFMlqXQdjWdKYaMek9EFNoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fg8KM+Un53S2/J3/vflRCnf0xfqfEzMvM8SaopXWvELOCycoTSxFwZqa5p0Yr0FFQ6jdS2oGjINPEhm0P+P0yH3jiagg+rXLPGokxM95xYHaq52x+DpRY0kBhpfH3VGTbqbAMDr1mHR+VHzBaxo3xPlSkuZ9gNgOkYrL8kORiBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dBov31HC; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dBov31HC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756450456;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ShV1QNoRLgcm3GFz/JY61+F1aA6JKcdngjT8vQyYc6c=;
	b=dBov31HC3uiGzCuRxlSQwkmwobMqBvTADQ+nyfvOcCP7WIhjw+8q17CdeevChai3M2JwrY
	Jw+AoAbM8LC5/ck4e5zdHUXVOLZAKP486OxyuyF1IHm/Dann28mZxeN8BFXa4eS2QIMFg4
	/jvNy4xVSMqR2lcQ6n/7QU5DFRf6ZWI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Plumb error messages through data drop paths
Date: Fri, 29 Aug 2025 02:54:07 -0400
Message-ID: <20250829065409.3248746-4-kent.overstreet@linux.dev>
In-Reply-To: <20250829065409.3248746-1-kent.overstreet@linux.dev>
References: <20250829065409.3248746-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The ioctl v2 rework added the ability to return error messages to
userspace directly - instead of via the dmesg log.

This lets us return more informative error messages: we can now return a
message with the key we failed on.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/ec.c      | 23 ++++++++++++------
 fs/bcachefs/ec.h      |  5 ++--
 fs/bcachefs/migrate.c | 55 ++++++++++++++++++++++++-------------------
 fs/bcachefs/migrate.h |  4 ++--
 fs/bcachefs/super.c   |  6 ++---
 5 files changed, 55 insertions(+), 38 deletions(-)

diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index c2840cb674b2..271e252152da 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2040,7 +2040,7 @@ int bch2_invalidate_stripe_to_dev(struct btree_trans *trans,
 				  struct btree_iter *iter,
 				  struct bkey_s_c k,
 				  unsigned dev_idx,
-				  unsigned flags)
+				  unsigned flags, struct printbuf *err)
 {
 	if (k.k->type != KEY_TYPE_stripe)
 		return 0;
@@ -2081,13 +2081,21 @@ int bch2_invalidate_stripe_to_dev(struct btree_trans *trans,
 			nr_good += ca && ca->mi.state != BCH_MEMBER_STATE_failed;
 		}
 
-	if (nr_good < s->v.nr_blocks && !(flags & BCH_FORCE_IF_DATA_DEGRADED))
+	if (nr_good < s->v.nr_blocks && !(flags & BCH_FORCE_IF_DATA_DEGRADED)) {
+		prt_str(err, "cannot drop device without degrading\n  ");
+		bch2_bkey_val_to_text(err, c, k);
+		prt_newline(err);
 		return bch_err_throw(c, remove_would_lose_data);
+	}
 
 	unsigned nr_data = s->v.nr_blocks - s->v.nr_redundant;
 
-	if (nr_good < nr_data && !(flags & BCH_FORCE_IF_DATA_LOST))
+	if (nr_good < nr_data && !(flags & BCH_FORCE_IF_DATA_LOST)) {
+		prt_str(err, "cannot drop device without losing data\n  ");
+		bch2_bkey_val_to_text(err, c, k);
+		prt_newline(err);
 		return bch_err_throw(c, remove_would_lose_data);
+	}
 
 	sectors = -sectors;
 
@@ -2099,7 +2107,7 @@ int bch2_invalidate_stripe_to_dev(struct btree_trans *trans,
 }
 
 static int bch2_invalidate_stripe_to_dev_from_alloc(struct btree_trans *trans, struct bkey_s_c k_a,
-						    unsigned flags)
+						    unsigned flags, struct printbuf *err)
 {
 	struct bch_alloc_v4 a_convert;
 	const struct bch_alloc_v4 *a = bch2_alloc_to_v4(k_a, &a_convert);
@@ -2119,17 +2127,18 @@ static int bch2_invalidate_stripe_to_dev_from_alloc(struct btree_trans *trans, s
 	if (ret)
 		return ret;
 
-	return bch2_invalidate_stripe_to_dev(trans, &iter, s.s_c, k_a.k->p.inode, flags);
+	return bch2_invalidate_stripe_to_dev(trans, &iter, s.s_c, k_a.k->p.inode, flags, err);
 }
 
-int bch2_dev_remove_stripes(struct bch_fs *c, unsigned dev_idx, unsigned flags)
+int bch2_dev_remove_stripes(struct bch_fs *c, unsigned dev_idx,
+			    unsigned flags, struct printbuf *err)
 {
 	CLASS(btree_trans, trans)(c);
 	int ret = for_each_btree_key_max_commit(trans, iter,
 				  BTREE_ID_alloc, POS(dev_idx, 0), POS(dev_idx, U64_MAX),
 				  BTREE_ITER_intent, k,
 				  NULL, NULL, 0, ({
-			bch2_invalidate_stripe_to_dev_from_alloc(trans, k, flags);
+		bch2_invalidate_stripe_to_dev_from_alloc(trans, k, flags, err);
 	}));
 	bch_err_fn(c, ret);
 	return ret;
diff --git a/fs/bcachefs/ec.h b/fs/bcachefs/ec.h
index e807e7027d7a..cc778da99030 100644
--- a/fs/bcachefs/ec.h
+++ b/fs/bcachefs/ec.h
@@ -289,8 +289,9 @@ static inline void ec_stripe_new_put(struct bch_fs *c, struct ec_stripe_new *s,
 }
 
 int bch2_invalidate_stripe_to_dev(struct btree_trans *, struct btree_iter *,
-				  struct bkey_s_c, unsigned, unsigned);
-int bch2_dev_remove_stripes(struct bch_fs *, unsigned, unsigned);
+				  struct bkey_s_c, unsigned,
+				  unsigned, struct printbuf *);
+int bch2_dev_remove_stripes(struct bch_fs *, unsigned, unsigned, struct printbuf *);
 
 void bch2_ec_stop_dev(struct bch_fs *, struct bch_dev *);
 void bch2_fs_ec_stop(struct bch_fs *);
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 892990b4a6a6..5b4c3f4b1c25 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -22,8 +22,8 @@
 #include "replicas.h"
 #include "super-io.h"
 
-static int drop_dev_ptrs(struct bch_fs *c, struct bkey_s k,
-			 unsigned dev_idx, unsigned flags, bool metadata)
+static int drop_dev_ptrs(struct bch_fs *c, struct bkey_s k, unsigned dev_idx,
+			 unsigned flags, struct printbuf *err, bool metadata)
 {
 	unsigned replicas = metadata ? c->opts.metadata_replicas : c->opts.data_replicas;
 	unsigned lost = metadata ? BCH_FORCE_IF_METADATA_LOST : BCH_FORCE_IF_DATA_LOST;
@@ -34,14 +34,19 @@ static int drop_dev_ptrs(struct bch_fs *c, struct bkey_s k,
 
 	nr_good = bch2_bkey_durability(c, k.s_c);
 	if ((!nr_good && !(flags & lost)) ||
-	    (nr_good < replicas && !(flags & degraded)))
+	    (nr_good < replicas && !(flags & degraded))) {
+		prt_str(err, "cannot drop device without degrading/losing data\n  ");
+		bch2_bkey_val_to_text(err, c, k.s_c);
+		prt_newline(err);
 		return bch_err_throw(c, remove_would_lose_data);
+	}
 
 	return 0;
 }
 
 static int drop_btree_ptrs(struct btree_trans *trans, struct btree_iter *iter,
-			   struct btree *b, unsigned dev_idx, unsigned flags)
+			   struct btree *b, unsigned dev_idx,
+			   unsigned flags, struct printbuf *err)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_buf k;
@@ -49,10 +54,9 @@ static int drop_btree_ptrs(struct btree_trans *trans, struct btree_iter *iter,
 	bch2_bkey_buf_init(&k);
 	bch2_bkey_buf_copy(&k, c, &b->key);
 
-	int ret = drop_dev_ptrs(c, bkey_i_to_s(k.k), dev_idx, flags, true) ?:
+	int ret = drop_dev_ptrs(c, bkey_i_to_s(k.k), dev_idx, flags, err, true) ?:
 		bch2_btree_node_update_key(trans, iter, b, k.k, 0, false);
 
-	bch_err_fn(c, ret);
 	bch2_bkey_buf_exit(&k, c);
 	return ret;
 }
@@ -61,7 +65,7 @@ static int bch2_dev_usrdata_drop_key(struct btree_trans *trans,
 				     struct btree_iter *iter,
 				     struct bkey_s_c k,
 				     unsigned dev_idx,
-				     unsigned flags)
+				     unsigned flags, struct printbuf *err)
 {
 	struct bch_fs *c = trans->c;
 	struct bkey_i *n;
@@ -75,7 +79,7 @@ static int bch2_dev_usrdata_drop_key(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	ret = drop_dev_ptrs(c, bkey_i_to_s(n), dev_idx, flags, false);
+	ret = drop_dev_ptrs(c, bkey_i_to_s(n), dev_idx, flags, err, false);
 	if (ret)
 		return ret;
 
@@ -101,7 +105,7 @@ static int bch2_dev_btree_drop_key(struct btree_trans *trans,
 				   struct bkey_s_c_backpointer bp,
 				   unsigned dev_idx,
 				   struct bkey_buf *last_flushed,
-				   unsigned flags)
+				   unsigned flags, struct printbuf *err)
 {
 	struct btree_iter iter;
 	struct btree *b = bch2_backpointer_get_node(trans, bp, &iter, last_flushed);
@@ -109,7 +113,7 @@ static int bch2_dev_btree_drop_key(struct btree_trans *trans,
 	if (ret)
 		return ret == -BCH_ERR_backpointer_to_overwritten_btree_node ? 0 : ret;
 
-	ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags);
+	ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags, err);
 
 	bch2_trans_iter_exit(&iter);
 	return ret;
@@ -117,7 +121,8 @@ static int bch2_dev_btree_drop_key(struct btree_trans *trans,
 
 static int bch2_dev_usrdata_drop(struct bch_fs *c,
 				 struct progress_indicator_state *progress,
-				 unsigned dev_idx, unsigned flags)
+				 unsigned dev_idx,
+				 unsigned flags, struct printbuf *err)
 {
 	CLASS(btree_trans, trans)(c);
 
@@ -133,7 +138,7 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 				NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
 			bch2_progress_update_iter(trans, progress, &iter, "dropping user data");
-			bch2_dev_usrdata_drop_key(trans, &iter, k, dev_idx, flags);
+			bch2_dev_usrdata_drop_key(trans, &iter, k, dev_idx, flags, err);
 		}));
 		if (ret)
 			return ret;
@@ -144,7 +149,8 @@ static int bch2_dev_usrdata_drop(struct bch_fs *c,
 
 static int bch2_dev_metadata_drop(struct bch_fs *c,
 				  struct progress_indicator_state *progress,
-				  unsigned dev_idx, unsigned flags)
+				  unsigned dev_idx,
+				  unsigned flags, struct printbuf *err)
 {
 	struct btree_iter iter;
 	struct closure cl;
@@ -174,7 +180,7 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 			if (!bch2_bkey_has_device_c(bkey_i_to_s_c(&b->key), dev_idx))
 				goto next;
 
-			ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags);
+			ret = drop_btree_ptrs(trans, &iter, b, dev_idx, flags, err);
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
 				ret = 0;
 				continue;
@@ -206,7 +212,7 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 
 static int data_drop_bp(struct btree_trans *trans, unsigned dev_idx,
 			struct bkey_s_c_backpointer bp, struct bkey_buf *last_flushed,
-			unsigned flags)
+			unsigned flags, struct printbuf *err)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k = bch2_backpointer_get_key(trans, bp, &iter, BTREE_ITER_intent,
@@ -226,17 +232,18 @@ static int data_drop_bp(struct btree_trans *trans, unsigned dev_idx,
 	 */
 
 	if (bkey_is_btree_ptr(k.k))
-		ret = bch2_dev_btree_drop_key(trans, bp, dev_idx, last_flushed, flags);
+		ret = bch2_dev_btree_drop_key(trans, bp, dev_idx, last_flushed, flags, err);
 	else if (k.k->type == KEY_TYPE_stripe)
-		ret = bch2_invalidate_stripe_to_dev(trans, &iter, k, dev_idx, flags);
+		ret = bch2_invalidate_stripe_to_dev(trans, &iter, k, dev_idx, flags, err);
 	else
-		ret = bch2_dev_usrdata_drop_key(trans, &iter, k, dev_idx, flags);
+		ret = bch2_dev_usrdata_drop_key(trans, &iter, k, dev_idx, flags, err);
 out:
 	bch2_trans_iter_exit(&iter);
 	return ret;
 }
 
-int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsigned flags)
+int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsigned flags,
+				       struct printbuf *err)
 {
 	CLASS(btree_trans, trans)(c);
 
@@ -253,22 +260,22 @@ int bch2_dev_data_drop_by_backpointers(struct bch_fs *c, unsigned dev_idx, unsig
 				continue;
 
 			data_drop_bp(trans, dev_idx, bkey_s_c_to_backpointer(k),
-				     &last_flushed, flags);
+				     &last_flushed, flags, err);
 
 	}));
 
 	bch2_bkey_buf_exit(&last_flushed, trans->c);
-	bch_err_fn(c, ret);
 	return ret;
 }
 
-int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx, unsigned flags)
+int bch2_dev_data_drop(struct bch_fs *c, unsigned dev_idx,
+		       unsigned flags, struct printbuf *err)
 {
 	struct progress_indicator_state progress;
 	bch2_progress_init(&progress, c,
 			   BIT_ULL(BTREE_ID_extents)|
 			   BIT_ULL(BTREE_ID_reflink));
 
-	return bch2_dev_usrdata_drop(c, &progress, dev_idx, flags) ?:
-		bch2_dev_metadata_drop(c, &progress, dev_idx, flags);
+	return bch2_dev_usrdata_drop(c, &progress, dev_idx, flags, err) ?:
+		bch2_dev_metadata_drop(c, &progress, dev_idx, flags, err);
 }
diff --git a/fs/bcachefs/migrate.h b/fs/bcachefs/migrate.h
index 30018140711b..ff4567fb5a83 100644
--- a/fs/bcachefs/migrate.h
+++ b/fs/bcachefs/migrate.h
@@ -2,7 +2,7 @@
 #ifndef _BCACHEFS_MIGRATE_H
 #define _BCACHEFS_MIGRATE_H
 
-int bch2_dev_data_drop_by_backpointers(struct bch_fs *, unsigned, unsigned);
-int bch2_dev_data_drop(struct bch_fs *, unsigned, unsigned);
+int bch2_dev_data_drop_by_backpointers(struct bch_fs *, unsigned, unsigned, struct printbuf *);
+int bch2_dev_data_drop(struct bch_fs *, unsigned, unsigned, struct printbuf *);
 
 #endif /* _BCACHEFS_MIGRATE_H */
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 793c16fa8b09..d640ae188722 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1992,9 +1992,9 @@ int bch2_dev_remove(struct bch_fs *c, struct bch_dev *ca, int flags,
 	__bch2_dev_read_only(c, ca);
 
 	ret = fast_device_removal
-		? bch2_dev_data_drop_by_backpointers(c, ca->dev_idx, flags)
-		: (bch2_dev_data_drop(c, ca->dev_idx, flags) ?:
-		   bch2_dev_remove_stripes(c, ca->dev_idx, flags));
+		? bch2_dev_data_drop_by_backpointers(c, ca->dev_idx, flags, err)
+		: (bch2_dev_data_drop(c, ca->dev_idx, flags, err) ?:
+		   bch2_dev_remove_stripes(c, ca->dev_idx, flags, err));
 	if (ret)
 		goto err;
 
-- 
2.50.1

