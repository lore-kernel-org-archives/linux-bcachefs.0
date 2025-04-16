Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFDB1C5486
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811041; cv=none; b=MzCjNOQqmPAggBPmQLUgrxXPum8IYgIYbnJRwVsfMKfClzyGBjXdlSGSKs+KKWPeDcCxzUCwQwpcgH1Pqn+Tp3lWKCAx47kSAc1Q6i2mEq7LuMM+uP0DBwxYnq7cS2LXbHZABlAr3Kl8I5OdIdbWdgv+lUB6M3Y6GgNoauDzMfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811041; c=relaxed/simple;
	bh=KIy9YhKLptjStCTojrNuA7YgBsezNVGzTHeY+d1dOEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8fcGgynvj9R8bPG0kEg/Ec5q9uhXKIzzQGkw0AyyEQ8mACkqPcEKcP4gbtnQkhJ6wLtnrIpZH8odiOXN7RgeYzgUkxIvUwOiDV+vxZcKFivCtAbP3grtmKSsPXdNOO+PERLMCtFxRW2Zcja5NdWSKSdBaaWChqCCoaVKSvLHwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=henVTBV0; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="henVTBV0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744811036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=leBCIzgLeMOc4GtB9qPlVKytWLMW26KuOO+xpN3sNSI=;
	b=henVTBV05Fm7IFj63uwsSUJWi7sblmQxPZlegLqhcnN861RwI9MJzYqFhzn8G3HFJY1fwV
	WLG5FDL5a3YRI9/H0A9cXMUoDIveftXL89nNYXnLHnbqQBdAR3kqSb4h8uyQxeaKDePxZ2
	Q9I89slc6Tl1l7A771lc3nyhKjSWzD4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/4] bcachefs: Plumb target parameter through btree_node_rewrite_pos()
Date: Wed, 16 Apr 2025 09:43:46 -0400
Message-ID: <20250416134352.3654545-2-kent.overstreet@linux.dev>
In-Reply-To: <20250416134352.3654545-1-kent.overstreet@linux.dev>
References: <20250416134352.3654545-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c              |  2 +-
 fs/bcachefs/btree_update_interior.c | 37 +++++++++++++++++++----------
 fs/bcachefs/btree_update_interior.h |  4 ++--
 fs/bcachefs/move.c                  |  5 ++--
 4 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 79cf1392f83a..a261e8563da4 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1914,7 +1914,7 @@ static void btree_node_scrub_work(struct work_struct *work)
 			bch_err(c, "error validating btree node during scrub on %s at btree %s",
 				scrub->ca->name, err.buf);
 
-			ret = bch2_btree_node_rewrite(trans, &iter, b, 0);
+			ret = bch2_btree_node_rewrite(trans, &iter, b, 0, 0);
 		}
 err:
 		bch2_trans_iter_exit(trans, &iter);
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 953fb3338d70..8b8fdbaca6c0 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -284,6 +284,7 @@ static struct btree *__bch2_btree_node_alloc(struct btree_trans *trans,
 					     struct disk_reservation *res,
 					     struct closure *cl,
 					     bool interior_node,
+					     unsigned target,
 					     unsigned flags)
 {
 	struct bch_fs *c = trans->c;
@@ -317,6 +318,7 @@ static struct btree *__bch2_btree_node_alloc(struct btree_trans *trans,
 	mutex_unlock(&c->btree_reserve_cache_lock);
 retry:
 	ret = bch2_alloc_sectors_start_trans(trans,
+				      target ?:
 				      c->opts.metadata_target ?:
 				      c->opts.foreground_target,
 				      0,
@@ -325,7 +327,9 @@ static struct btree *__bch2_btree_node_alloc(struct btree_trans *trans,
 				      res->nr_replicas,
 				      min(res->nr_replicas,
 					  c->opts.metadata_replicas_required),
-				      watermark, 0, cl, &wp);
+				      watermark,
+				      target ? BCH_WRITE_only_specified_devs : 0,
+				      cl, &wp);
 	if (unlikely(ret))
 		goto err;
 
@@ -505,6 +509,7 @@ static void bch2_btree_reserve_put(struct btree_update *as, struct btree_trans *
 static int bch2_btree_reserve_get(struct btree_trans *trans,
 				  struct btree_update *as,
 				  unsigned nr_nodes[2],
+				  unsigned target,
 				  unsigned flags,
 				  struct closure *cl)
 {
@@ -527,7 +532,7 @@ static int bch2_btree_reserve_get(struct btree_trans *trans,
 
 		while (p->nr < nr_nodes[interior]) {
 			b = __bch2_btree_node_alloc(trans, &as->disk_res, cl,
-						    interior, flags);
+						    interior, target, flags);
 			if (IS_ERR(b)) {
 				ret = PTR_ERR(b);
 				goto err;
@@ -1116,7 +1121,8 @@ static void bch2_btree_update_done(struct btree_update *as, struct btree_trans *
 
 static struct btree_update *
 bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
-			unsigned level_start, bool split, unsigned flags)
+			unsigned level_start, bool split,
+			unsigned target, unsigned flags)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_update *as;
@@ -1226,7 +1232,7 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 	if (ret)
 		goto err;
 
-	ret = bch2_btree_reserve_get(trans, as, nr_nodes, flags, NULL);
+	ret = bch2_btree_reserve_get(trans, as, nr_nodes, target, flags, NULL);
 	if (bch2_err_matches(ret, ENOSPC) ||
 	    bch2_err_matches(ret, ENOMEM)) {
 		struct closure cl;
@@ -1245,7 +1251,7 @@ bch2_btree_update_start(struct btree_trans *trans, struct btree_path *path,
 		closure_init_stack(&cl);
 
 		do {
-			ret = bch2_btree_reserve_get(trans, as, nr_nodes, flags, &cl);
+			ret = bch2_btree_reserve_get(trans, as, nr_nodes, target, flags, &cl);
 
 			bch2_trans_unlock(trans);
 			bch2_wait_on_allocator(c, &cl);
@@ -1863,7 +1869,7 @@ int bch2_btree_split_leaf(struct btree_trans *trans,
 
 	as = bch2_btree_update_start(trans, trans->paths + path,
 				     trans->paths[path].level,
-				     true, flags);
+				     true, 0, flags);
 	if (IS_ERR(as))
 		return PTR_ERR(as);
 
@@ -1933,7 +1939,8 @@ int bch2_btree_increase_depth(struct btree_trans *trans, btree_path_idx_t path,
 		return bch2_btree_split_leaf(trans, path, flags);
 
 	struct btree_update *as =
-		bch2_btree_update_start(trans, trans->paths + path, b->c.level, true, flags);
+		bch2_btree_update_start(trans, trans->paths + path, b->c.level,
+					true, 0, flags);
 	if (IS_ERR(as))
 		return PTR_ERR(as);
 
@@ -2062,7 +2069,7 @@ int __bch2_foreground_maybe_merge(struct btree_trans *trans,
 
 	parent = btree_node_parent(trans->paths + path, b);
 	as = bch2_btree_update_start(trans, trans->paths + path, level, false,
-				     BCH_TRANS_COMMIT_no_enospc|flags);
+				     0, BCH_TRANS_COMMIT_no_enospc|flags);
 	ret = PTR_ERR_OR_ZERO(as);
 	if (ret)
 		goto err;
@@ -2169,6 +2176,7 @@ static int get_iter_to_node(struct btree_trans *trans, struct btree_iter *iter,
 int bch2_btree_node_rewrite(struct btree_trans *trans,
 			    struct btree_iter *iter,
 			    struct btree *b,
+			    unsigned target,
 			    unsigned flags)
 {
 	struct bch_fs *c = trans->c;
@@ -2181,7 +2189,8 @@ int bch2_btree_node_rewrite(struct btree_trans *trans,
 
 	struct btree_path *path = btree_iter_path(trans, iter);
 	parent = btree_node_parent(path, b);
-	as = bch2_btree_update_start(trans, path, b->c.level, false, flags);
+	as = bch2_btree_update_start(trans, path, b->c.level,
+				     false, target, flags);
 	ret = PTR_ERR_OR_ZERO(as);
 	if (ret)
 		goto out;
@@ -2246,7 +2255,7 @@ static int bch2_btree_node_rewrite_key(struct btree_trans *trans,
 
 	bool found = b && btree_ptr_hash_val(&b->key) == btree_ptr_hash_val(k);
 	ret = found
-		? bch2_btree_node_rewrite(trans, &iter, b, flags)
+		? bch2_btree_node_rewrite(trans, &iter, b, 0, flags)
 		: -ENOENT;
 out:
 	bch2_trans_iter_exit(trans, &iter);
@@ -2255,7 +2264,9 @@ static int bch2_btree_node_rewrite_key(struct btree_trans *trans,
 
 int bch2_btree_node_rewrite_pos(struct btree_trans *trans,
 				enum btree_id btree, unsigned level,
-				struct bpos pos, unsigned flags)
+				struct bpos pos,
+				unsigned target,
+				unsigned flags)
 {
 	BUG_ON(!level);
 
@@ -2267,7 +2278,7 @@ int bch2_btree_node_rewrite_pos(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
-	ret = bch2_btree_node_rewrite(trans, &iter, b, flags);
+	ret = bch2_btree_node_rewrite(trans, &iter, b, target, flags);
 err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -2281,7 +2292,7 @@ int bch2_btree_node_rewrite_key_get_iter(struct btree_trans *trans,
 	if (ret)
 		return ret == -BCH_ERR_btree_node_dying ? 0 : ret;
 
-	ret = bch2_btree_node_rewrite(trans, &iter, b, flags);
+	ret = bch2_btree_node_rewrite(trans, &iter, b, 0, flags);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
diff --git a/fs/bcachefs/btree_update_interior.h b/fs/bcachefs/btree_update_interior.h
index be71cd73b864..ff9b95aac554 100644
--- a/fs/bcachefs/btree_update_interior.h
+++ b/fs/bcachefs/btree_update_interior.h
@@ -168,10 +168,10 @@ static inline int bch2_foreground_maybe_merge(struct btree_trans *trans,
 }
 
 int bch2_btree_node_rewrite(struct btree_trans *, struct btree_iter *,
-			    struct btree *, unsigned);
+			    struct btree *, unsigned, unsigned);
 int bch2_btree_node_rewrite_pos(struct btree_trans *,
 				enum btree_id, unsigned,
-				struct bpos, unsigned);
+				struct bpos, unsigned, unsigned);
 int bch2_btree_node_rewrite_key_get_iter(struct btree_trans *,
 					 struct btree *, unsigned);
 
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index ce050ef3af4f..983dbba2d3c4 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -871,7 +871,8 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		if (!bp.v->level)
 			ret = bch2_move_extent(ctxt, bucket_in_flight, &iter, k, io_opts, data_opts);
 		else if (!data_opts.scrub)
-			ret = bch2_btree_node_rewrite_pos(trans, bp.v->btree_id, bp.v->level, k.k->p, 0);
+			ret = bch2_btree_node_rewrite_pos(trans, bp.v->btree_id, bp.v->level,
+							  k.k->p, data_opts.target, 0);
 		else
 			ret = bch2_btree_node_scrub(trans, bp.v->btree_id, bp.v->level, k, data_opts.read_dev);
 
@@ -1021,7 +1022,7 @@ static int bch2_move_btree(struct bch_fs *c,
 			if (!pred(c, arg, b, &io_opts, &data_opts))
 				goto next;
 
-			ret = bch2_btree_node_rewrite(trans, &iter, b, 0) ?: ret;
+			ret = bch2_btree_node_rewrite(trans, &iter, b, 0, 0) ?: ret;
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 				continue;
 			if (ret)
-- 
2.49.0

