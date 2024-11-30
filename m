Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F30D481AF
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930781; cv=none; b=Q7Beq5MCPVK6+N7cv0caDayCk1hYKxZH+DalNPpu9X4QEAUsLXBH7MbsYQ9WLswnc1KHoJ8xUQvfpJw/DIPCt2zCyC2dGT//ukWJPsOX3ZlOJz4CE05tnDbmD2NNubOvGEDZpHLxosc9dAJI2ewt/Wr8Kv7+hxvDI16QRvAgkkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930781; c=relaxed/simple;
	bh=pZoTOiBL697ksEkXICPnJXjEhv5z45SxnvxdLzOnLWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRCCFEAvJjMghMGLDUKpdF/a8jvsqDFOBz630EZr6fSxfRMuzF2Gu6iDkLINIun2sCj+K210uaP7YmhpKQKbeDgO3sqreiDMaNhCqs5rXCEq152VVMEj5pmLheWPOwwsJWo8i89uKvYfz940xek5gY5bAuabb/hUyaZQmZbdyaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d19nmJR1; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d19nmJR1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgmddCRL4z7h9Ze88p31JdLvAF4jgBM+pm+aA/TN9i8=;
	b=d19nmJR1U96D1YCaXpq8f93eqOfeMB91xCP53dlUeyC1Y7PIcW5p+OWwsGlLKAQTpLkup8
	daRaZ4PGHwyHu6EUOyCSNPP1sAne37p+Tuj66qpCJ9GzEeCnTg6QvRD+RLjVoAGbJkLtXb
	nneUztPh37GwjxdDfvnfHwQTdFIymyU=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/8] bcachefs: Add write buffer flush param to backpointer_get_key()
Date: Fri, 29 Nov 2024 20:39:18 -0500
Message-ID: <20241130013922.3135792-7-kent.overstreet@linux.dev>
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

In an upcoming patch bch2_backpointer_get_key() will be repairing when
it finds a dangling backpointer; it will need to flush the btree write
buffer before it can definitively say there's an error.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c | 12 +++++++-----
 fs/bcachefs/backpointers.h |  5 +++--
 fs/bcachefs/ec.c           | 14 ++++++++++----
 fs/bcachefs/move.c         |  8 ++++++--
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 719781470633..81dff1819cb8 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -217,7 +217,8 @@ static void backpointer_target_not_found(struct btree_trans *trans,
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 					 struct bkey_s_c_backpointer bp,
 					 struct btree_iter *iter,
-					 unsigned iter_flags)
+					 unsigned iter_flags,
+					 struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
 
@@ -244,7 +245,7 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 		backpointer_target_not_found(trans, bp, k);
 		return bkey_s_c_null;
 	} else {
-		struct btree *b = bch2_backpointer_get_node(trans, bp, iter);
+		struct btree *b = bch2_backpointer_get_node(trans, bp, iter, last_flushed);
 
 		if (IS_ERR_OR_NULL(b)) {
 			bch2_trans_iter_exit(trans, iter);
@@ -256,7 +257,8 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 
 struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 					struct bkey_s_c_backpointer bp,
-					struct btree_iter *iter)
+					struct btree_iter *iter,
+					struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
 
@@ -485,7 +487,7 @@ static int check_bp_exists(struct btree_trans *trans,
 	struct bkey_s_c_backpointer other_bp = bkey_s_c_to_backpointer(bp_k);
 
 	struct bkey_s_c other_extent =
-		bch2_backpointer_get_key(trans, other_bp, &other_extent_iter, 0);
+		bch2_backpointer_get_key(trans, other_bp, &other_extent_iter, 0, &s->last_flushed);
 	ret = bkey_err(other_extent);
 	if (ret == -BCH_ERR_backpointer_to_overwritten_btree_node)
 		ret = 0;
@@ -1107,7 +1109,7 @@ static int check_one_backpointer(struct btree_trans *trans,
 		return 0;
 
 	struct btree_iter iter;
-	struct bkey_s_c k = bch2_backpointer_get_key(trans, bp, &iter, 0);
+	struct bkey_s_c k = bch2_backpointer_get_key(trans, bp, &iter, 0, last_flushed);
 	int ret = bkey_err(k);
 	if (ret == -BCH_ERR_backpointer_to_overwritten_btree_node)
 		return 0;
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 65ede8adbc36..060dad1521ee 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -158,10 +158,11 @@ static inline void bch2_extent_ptr_to_bp(struct bch_fs *c,
 	};
 }
 
+struct bkey_buf;
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *, struct bkey_s_c_backpointer,
-					 struct btree_iter *, unsigned);
+					 struct btree_iter *, unsigned, struct bkey_buf *);
 struct btree *bch2_backpointer_get_node(struct btree_trans *, struct bkey_s_c_backpointer,
-					struct btree_iter *);
+					struct btree_iter *, struct bkey_buf *);
 
 int bch2_check_btree_backpointers(struct bch_fs *);
 int bch2_check_extents_to_backpointers(struct bch_fs *);
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 250e73897d95..6b297f90d6ec 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1276,7 +1276,8 @@ static int ec_stripe_update_extent(struct btree_trans *trans,
 				   struct bch_dev *ca,
 				   struct bpos bucket, u8 gen,
 				   struct ec_stripe_buf *s,
-				   struct bkey_s_c_backpointer bp)
+				   struct bkey_s_c_backpointer bp,
+				   struct bkey_buf *last_flushed)
 {
 	struct bch_stripe *v = &bkey_i_to_stripe(&s->key)->v;
 	struct bch_fs *c = trans->c;
@@ -1293,7 +1294,7 @@ static int ec_stripe_update_extent(struct btree_trans *trans,
 		struct btree_iter node_iter;
 		struct btree *b;
 
-		b = bch2_backpointer_get_node(trans, bp, &node_iter);
+		b = bch2_backpointer_get_node(trans, bp, &node_iter, last_flushed);
 		bch2_trans_iter_exit(trans, &node_iter);
 
 		if (!b)
@@ -1307,7 +1308,7 @@ static int ec_stripe_update_extent(struct btree_trans *trans,
 		return -EIO;
 	}
 
-	k = bch2_backpointer_get_key(trans, bp, &iter, BTREE_ITER_intent);
+	k = bch2_backpointer_get_key(trans, bp, &iter, BTREE_ITER_intent, last_flushed);
 	ret = bkey_err(k);
 	if (ret)
 		return ret;
@@ -1374,6 +1375,10 @@ static int ec_stripe_update_bucket(struct btree_trans *trans, struct ec_stripe_b
 
 	struct bpos bucket_pos = PTR_BUCKET_POS(ca, &ptr);
 
+	struct bkey_buf last_flushed;
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
+
 	ret = for_each_btree_key_max_commit(trans, bp_iter, BTREE_ID_backpointers,
 			bucket_pos_to_bp_start(ca, bucket_pos),
 			bucket_pos_to_bp_end(ca, bucket_pos), 0, bp_k,
@@ -1387,9 +1392,10 @@ static int ec_stripe_update_bucket(struct btree_trans *trans, struct ec_stripe_b
 			continue;
 
 		ec_stripe_update_extent(trans, ca, bucket_pos, ptr.gen, s,
-					bkey_s_c_to_backpointer(bp_k));
+					bkey_s_c_to_backpointer(bp_k), &last_flushed);
 	}));
 
+	bch2_bkey_buf_exit(&last_flushed, c);
 	bch2_dev_put(ca);
 	return ret;
 }
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 460175464762..1aedde75fb83 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -675,6 +675,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	struct bkey_s_c k;
 	struct data_update_opts data_opts;
 	unsigned sectors_moved = 0;
+	struct bkey_buf last_flushed;
 	int ret = 0;
 
 	struct bch_dev *ca = bch2_dev_tryget(c, bucket.inode);
@@ -683,6 +684,8 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 
 	trace_bucket_evacuate(c, &bucket);
 
+	bch2_bkey_buf_init(&last_flushed);
+	bkey_init(&last_flushed.k->k);
 	bch2_bkey_buf_init(&sk);
 
 	/*
@@ -724,7 +727,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		struct bkey_s_c_backpointer bp = bkey_s_c_to_backpointer(k);
 
 		if (!bp.v->level) {
-			k = bch2_backpointer_get_key(trans, bp, &iter, 0);
+			k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
 			ret = bkey_err(k);
 			if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 				continue;
@@ -782,7 +785,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 		} else {
 			struct btree *b;
 
-			b = bch2_backpointer_get_node(trans, bp, &iter);
+			b = bch2_backpointer_get_node(trans, bp, &iter, &last_flushed);
 			ret = PTR_ERR_OR_ZERO(b);
 			if (ret == -BCH_ERR_backpointer_to_overwritten_btree_node)
 				continue;
@@ -820,6 +823,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 	bch2_trans_iter_exit(trans, &bp_iter);
 	bch2_dev_put(ca);
 	bch2_bkey_buf_exit(&sk, c);
+	bch2_bkey_buf_exit(&last_flushed, c);
 	return ret;
 }
 
-- 
2.45.2

