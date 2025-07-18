Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CF64689
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 06:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821251; cv=none; b=kQZXZLK8jQhXEscsUsKKA6RwX7kgs4l7lsUnpzgWRud97KeCTZR2P3nkWD+lwyOciTL87/8+NT9WIHqRvM3n2MjotkMvY8N8Us4xOaXa/cIYVaFL8Y6CE/6fWpGDeUf5KHVPqpR5MqXcvrkSZja2ZSKWsjgs9HeXdN/qyja8HIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821251; c=relaxed/simple;
	bh=XGBuAtCpsCCcqiAucJpFR0FVJDKohx3RMx3fbPz0H5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+vcyt1a6XFp86iCuYb7+wyoxdUa9gvJMa3p5zfTk5LqWk87ItdSBGJf/rhMgAJuBQmiYd7PrEu/ek/BKpeARO2g5f+hWZcADvblweWadglp+s3z/XNhjOCYROtt3vSqAR5/V1mNcMY5MvuqPVcnMwfdyiSa99mlJZItH2qluMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PHedr93N; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PHedr93N"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752821246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/P4GQEsNiQG2sbg5qQDFNMMb+BkOJBzJWJwtPw1lIY4=;
	b=PHedr93NNjZODGF5ejP2kd2+B16MQwZR0ur+FGLrZb0PoMTJHjPH3UTAE82ly3Kw3HKwiU
	0lNUzHo5S4s2qxcY/rw4gW/mMJH4owCpnFgB4ZG8Pl6cxFIodrX0klf9heeE2HLnNLqbIS
	+i/QRudAeQKJmIv5ZfN25eIVTaTUWNc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] bcachefs: bch2_move_data() now walks btree nodes
Date: Fri, 18 Jul 2025 02:47:13 -0400
Message-ID: <20250718064715.333124-2-kent.overstreet@linux.dev>
In-Reply-To: <20250718064715.333124-1-kent.overstreet@linux.dev>
References: <20250718064715.333124-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

bch2_move_data_btree() can already walk btree nodes, and it properly
handles btree roots.

This is a code cleanup - and it fixes the rereplicate2 test, we can now
reliably rerereplicate in one psas.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/move.c | 95 ++++++++++++++++++----------------------------
 fs/bcachefs/move.h | 12 ------
 2 files changed, 36 insertions(+), 71 deletions(-)

diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 3f44bb54f91a..3419e406f0c7 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -795,50 +795,50 @@ int bch2_move_data_btree(struct moving_context *ctxt,
 	return ret;
 }
 
-int __bch2_move_data(struct moving_context *ctxt,
-		     struct bbpos start,
-		     struct bbpos end,
-		     move_pred_fn pred, void *arg)
+static int bch2_move_data(struct bch_fs *c,
+			  struct bbpos start,
+			  struct bbpos end,
+			  unsigned min_depth,
+			  struct bch_ratelimit *rate,
+			  struct bch_move_stats *stats,
+			  struct write_point_specifier wp,
+			  bool wait_on_copygc,
+			  move_pred_fn pred, void *arg)
 {
-	struct bch_fs *c = ctxt->trans->c;
-	enum btree_id id;
 	int ret = 0;
 
-	for (id = start.btree;
+	struct moving_context ctxt;
+	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
+
+	for (enum btree_id id = start.btree;
 	     id <= min_t(unsigned, end.btree, btree_id_nr_alive(c) - 1);
 	     id++) {
-		ctxt->stats->pos = BBPOS(id, POS_MIN);
+		ctxt.stats->pos = BBPOS(id, POS_MIN);
 
-		if (!btree_type_has_ptrs(id) ||
-		    !bch2_btree_id_root(c, id)->b)
+		if (!bch2_btree_id_root(c, id)->b)
 			continue;
 
-		ret = bch2_move_data_btree(ctxt,
-				       id == start.btree ? start.pos : POS_MIN,
-				       id == end.btree   ? end.pos   : POS_MAX,
-				       pred, arg, id, 0);
+		unsigned min_depth_this_btree = min_depth;
+
+		if (!btree_type_has_ptrs(id))
+			min_depth_this_btree = max(min_depth_this_btree, 1);
+
+		for (unsigned level = min_depth_this_btree;
+		     level < BTREE_MAX_DEPTH;
+		     level++) {
+			ret = bch2_move_data_btree(&ctxt,
+						   id == start.btree ? start.pos : POS_MIN,
+						   id == end.btree   ? end.pos   : POS_MAX,
+						   pred, arg, id, level);
+			if (ret)
+				break;
+		}
+
 		if (ret)
 			break;
 	}
 
-	return ret;
-}
-
-int bch2_move_data(struct bch_fs *c,
-		   struct bbpos start,
-		   struct bbpos end,
-		   struct bch_ratelimit *rate,
-		   struct bch_move_stats *stats,
-		   struct write_point_specifier wp,
-		   bool wait_on_copygc,
-		   move_pred_fn pred, void *arg)
-{
-	struct moving_context ctxt;
-
-	bch2_moving_ctxt_init(&ctxt, c, rate, stats, wp, wait_on_copygc);
-	int ret = __bch2_move_data(&ctxt, start, end, pred, arg);
 	bch2_moving_ctxt_exit(&ctxt);
-
 	return ret;
 }
 
@@ -1206,14 +1206,6 @@ static bool migrate_pred(struct bch_fs *c, void *arg,
 	return data_opts->rewrite_ptrs != 0;
 }
 
-static bool rereplicate_btree_pred(struct bch_fs *c, void *arg,
-				   struct btree *b,
-				   struct bch_io_opts *io_opts,
-				   struct data_update_opts *data_opts)
-{
-	return rereplicate_pred(c, arg, b->c.btree_id, bkey_i_to_s_c(&b->key), io_opts, data_opts);
-}
-
 /*
  * Ancient versions of bcachefs produced packed formats which could represent
  * keys that the in memory format cannot represent; this checks for those
@@ -1293,15 +1285,6 @@ static bool drop_extra_replicas_pred(struct bch_fs *c, void *arg,
 	return data_opts->kill_ptrs != 0;
 }
 
-static bool drop_extra_replicas_btree_pred(struct bch_fs *c, void *arg,
-				   struct btree *b,
-				   struct bch_io_opts *io_opts,
-				   struct data_update_opts *data_opts)
-{
-	return drop_extra_replicas_pred(c, arg, b->c.btree_id, bkey_i_to_s_c(&b->key),
-					io_opts, data_opts);
-}
-
 static bool scrub_pred(struct bch_fs *c, void *_arg,
 		       enum btree_id btree, struct bkey_s_c k,
 		       struct bch_io_opts *io_opts,
@@ -1359,11 +1342,7 @@ int bch2_data_job(struct bch_fs *c,
 	case BCH_DATA_OP_rereplicate:
 		stats->data_type = BCH_DATA_journal;
 		ret = bch2_journal_flush_device_pins(&c->journal, -1);
-		ret = bch2_move_btree(c, start, end,
-				      rereplicate_btree_pred, c, stats) ?: ret;
-		ret = bch2_move_data(c, start, end,
-				     NULL,
-				     stats,
+		ret = bch2_move_data(c, start, end, 0, NULL, stats,
 				     writepoint_hashed((unsigned long) current),
 				     true,
 				     rereplicate_pred, c) ?: ret;
@@ -1389,12 +1368,10 @@ int bch2_data_job(struct bch_fs *c,
 		ret = bch2_scan_old_btree_nodes(c, stats);
 		break;
 	case BCH_DATA_OP_drop_extra_replicas:
-		ret = bch2_move_btree(c, start, end,
-				drop_extra_replicas_btree_pred, c, stats) ?: ret;
-		ret = bch2_move_data(c, start, end, NULL, stats,
-				writepoint_hashed((unsigned long) current),
-				true,
-				drop_extra_replicas_pred, c) ?: ret;
+		ret = bch2_move_data(c, start, end, 0, NULL, stats,
+				     writepoint_hashed((unsigned long) current),
+				     true,
+				     drop_extra_replicas_pred, c) ?: ret;
 		ret = bch2_replicas_gc2(c) ?: ret;
 		break;
 	default:
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index fe92ca6d418d..481026ff99ab 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -128,18 +128,6 @@ struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *,
 
 int bch2_move_data_btree(struct moving_context *, struct bpos, struct bpos,
 			 move_pred_fn, void *, enum btree_id, unsigned);
-int __bch2_move_data(struct moving_context *,
-		     struct bbpos,
-		     struct bbpos,
-		     move_pred_fn, void *);
-int bch2_move_data(struct bch_fs *,
-		   struct bbpos start,
-		   struct bbpos end,
-		   struct bch_ratelimit *,
-		   struct bch_move_stats *,
-		   struct write_point_specifier,
-		   bool,
-		   move_pred_fn, void *);
 
 int bch2_move_data_phys(struct bch_fs *, unsigned, u64, u64, unsigned,
 			struct bch_ratelimit *, struct bch_move_stats *,
-- 
2.50.0

