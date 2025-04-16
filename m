Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299651F8728
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744811042; cv=none; b=IcgFPxgBN9VJPWXdNDIqnAu/CRHJ35vNy26vddpC2fGIaNAlkjJkjyOykBzhTThBdIXWSGozfD3OE5TVQGP+3lNrymdzGIglfmrTx7QkkpGWZLwtN1VKLwnWqSiD4qoPVI43ulmFqe7iNrUZ5fLA2IUOELE0qP1O8jDwjRo4+G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744811042; c=relaxed/simple;
	bh=gizLG9JpxomjkNwqaO70bI8dWr+3GTtV/3DKfegxwVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmlBNIeoCKlpQrvuJWvygZznTM0AXAs/XQpaavS9wEKuUTh3cj3YGG/QhrpuFav6/rHG6MIcQoKqPROp3WZNra20tv9QIjehqTruz7gdrLjS2h1jNZ3rjNsvlJ6d4v3MBODskWMisFXiIjSHoGrPLrfvsyggVnLZNmW+fEA9op4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g+O6kYys; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g+O6kYys"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744811038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i+OyJrLE4HKw0y9JeTbCQszKWJ6qV8qYk+2cYMhBUA8=;
	b=g+O6kYys9ed8qy17mx7Huk3ceyBS1VB2n34bMpoIkLpIyqqQJkNXXMmfbTdIalK692lOAU
	s5m1nIJJnVjtbbmVgVTO5YxgHqghnHkn0uYcdPOO2KleFj0o41a/QpylYIDfvcuZpb77N9
	N3/Q5Yi3vRpw26q08dRl5gS+YrYnMl0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] bcachefs: bch2_move_data_btree() can move btree nodes
Date: Wed, 16 Apr 2025 09:43:48 -0400
Message-ID: <20250416134352.3654545-4-kent.overstreet@linux.dev>
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
 fs/bcachefs/move.c | 32 +++++++++++++++++++++-----------
 fs/bcachefs/move.h |  2 ++
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index f41913ea85e4..b594c9ed41f8 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -423,6 +423,9 @@ static struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 	struct bch_io_opts *opts_ret = &io_opts->fs_io_opts;
 	int ret = 0;
 
+	if (extent_iter->min_depth)
+		return opts_ret;
+
 	if (extent_k.k->type == KEY_TYPE_reflink_v)
 		goto out;
 
@@ -573,11 +576,11 @@ static struct bkey_s_c bch2_lookup_indirect_extent_for_move(struct btree_trans *
 	return k;
 }
 
-static int bch2_move_data_btree(struct moving_context *ctxt,
-				struct bpos start,
-				struct bpos end,
-				move_pred_fn pred, void *arg,
-				enum btree_id btree_id)
+int bch2_move_data_btree(struct moving_context *ctxt,
+			 struct bpos start,
+			 struct bpos end,
+			 move_pred_fn pred, void *arg,
+			 enum btree_id btree_id, unsigned level)
 {
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
@@ -604,10 +607,10 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 	}
 
 	bch2_trans_begin(trans);
-	bch2_trans_iter_init(trans, &iter, btree_id, start,
-			     BTREE_ITER_prefetch|
-			     BTREE_ITER_not_extents|
-			     BTREE_ITER_all_snapshots);
+	bch2_trans_node_iter_init(trans, &iter, btree_id, start, 0, level,
+				  BTREE_ITER_prefetch|
+				  BTREE_ITER_not_extents|
+				  BTREE_ITER_all_snapshots);
 
 	if (ctxt->rate)
 		bch2_ratelimit_reset(ctxt->rate);
@@ -677,7 +680,14 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 		bch2_bkey_buf_reassemble(&sk, c, k);
 		k = bkey_i_to_s_c(sk.k);
 
-		ret2 = bch2_move_extent(ctxt, NULL, extent_iter, k, *io_opts, data_opts);
+		if (!level)
+			ret2 = bch2_move_extent(ctxt, NULL, extent_iter, k, *io_opts, data_opts);
+		else if (!data_opts.scrub)
+			ret2 = bch2_btree_node_rewrite_pos(trans, btree_id, level,
+							  k.k->p, data_opts.target, 0);
+		else
+			ret2 = bch2_btree_node_scrub(trans, btree_id, level, k, data_opts.read_dev);
+
 		if (ret2) {
 			if (bch2_err_matches(ret2, BCH_ERR_transaction_restart))
 				continue;
@@ -727,7 +737,7 @@ int __bch2_move_data(struct moving_context *ctxt,
 		ret = bch2_move_data_btree(ctxt,
 				       id == start.btree ? start.pos : POS_MIN,
 				       id == end.btree   ? end.pos   : POS_MAX,
-				       pred, arg, id);
+				       pred, arg, id, 0);
 		if (ret)
 			break;
 	}
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 9c6c229e583e..0c620a5f728d 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -122,6 +122,8 @@ int bch2_move_extent(struct moving_context *,
 		     struct bch_io_opts,
 		     struct data_update_opts);
 
+int bch2_move_data_btree(struct moving_context *, struct bpos, struct bpos,
+			 move_pred_fn, void *, enum btree_id, unsigned);
 int __bch2_move_data(struct moving_context *,
 		     struct bbpos,
 		     struct bbpos,
-- 
2.49.0

