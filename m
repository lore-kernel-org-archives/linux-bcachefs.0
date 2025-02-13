Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AEC28A2D5
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472385; cv=none; b=g627158IybMKIxg4a5+GQGnFpEBtn/k1cko61e2SxjZrl8ybhgpr3a7/Odyrqlph3RgPIQ1k4F0lhzNyuBKpFfA4KbZgl33o9HCh+0X7kZ4XH59rBEc2SjzRS9maEddZJ488xBRzcJkii21fjQF4DqbGgV/PUlnmCgMA6mHERi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472385; c=relaxed/simple;
	bh=/yQielVPTZ+miUruVEOSEMoMh53MFajeVeuzNR57gb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAW3fT0LqldwfLhWvr/n2RkNk97jNA+aZwyqaNRRzVMVTrm1pZgt44e2THvHI+s3eKRkFhYrqPQIpovhGLofhwyK25ByukHk8crGn8S3qLOaVFs0ETV0SU9nU03uvuHW0XOoxr73sUAuabQ0gJEtdjNuWbRWqPzHGZlWknYXa2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oRfyg+p3; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oRfyg+p3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5EqA4qa/uMM3zJjtlSaMEH40cZPzVUa3J7/U0QVEzOo=;
	b=oRfyg+p3yZI6aTgMg45llWGW4Lq+Hya8JUX9GM7I/RJhinkNTpyKNts9Ii7y0HEJXkG22O
	toF2Eqb/Ls8a6kBgNNE43S5e+3dM5Sf1v5zNz1RtoZHfUliir7WH4oYHtFoDwp1RKHJHIA
	vzdgMdWZpZk7cychphkS//3uAVw6l7Q=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/18] bcachefs: rework bch2_trans_commit_run_triggers()
Date: Thu, 13 Feb 2025 13:45:52 -0500
Message-ID: <20250213184607.18237-8-kent.overstreet@linux.dev>
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

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 89 ++++++++++++--------------------
 fs/bcachefs/btree_update.c       |  2 +-
 2 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index c4f524b2ca9a..892d20a50a52 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -336,6 +336,7 @@ static inline void btree_insert_entry_checks(struct btree_trans *trans,
 	BUG_ON(i->cached	!= path->cached);
 	BUG_ON(i->level		!= path->level);
 	BUG_ON(i->btree_id	!= path->btree_id);
+	BUG_ON(i->bkey_type	!= __btree_node_type(path->level, path->btree_id));
 	EBUG_ON(!i->level &&
 		btree_type_has_snapshots(i->btree_id) &&
 		!(i->flags & BTREE_UPDATE_internal_snapshot_node) &&
@@ -517,69 +518,45 @@ static int run_one_trans_trigger(struct btree_trans *trans, struct btree_insert_
 	}
 }
 
-static int run_btree_triggers(struct btree_trans *trans, enum btree_id btree_id,
-			      unsigned *btree_id_updates_start)
+static int bch2_trans_commit_run_triggers(struct btree_trans *trans)
 {
-	bool trans_trigger_run;
+	unsigned sort_id_start = 0;
 
-	/*
-	 * Running triggers will append more updates to the list of updates as
-	 * we're walking it:
-	 */
-	do {
-		trans_trigger_run = false;
+	while (sort_id_start < trans->nr_updates) {
+		unsigned i, sort_id = trans->updates[sort_id_start].sort_order;
+		bool trans_trigger_run;
 
-		for (unsigned i = *btree_id_updates_start;
-		     i < trans->nr_updates && trans->updates[i].btree_id <= btree_id;
-		     i++) {
-			if (trans->updates[i].btree_id < btree_id) {
-				*btree_id_updates_start = i;
-				continue;
+		/*
+		 * For a given btree, this algorithm runs insert triggers before
+		 * overwrite triggers: this is so that when extents are being
+		 * moved (e.g. by FALLOCATE_FL_INSERT_RANGE), we don't drop
+		 * references before they are re-added.
+		 *
+		 * Running triggers will append more updates to the list of
+		 * updates as we're walking it:
+		 */
+		do {
+			trans_trigger_run = false;
+
+			for (i = sort_id_start;
+			     i < trans->nr_updates && trans->updates[i].sort_order <= sort_id;
+			     i++) {
+				if (trans->updates[i].sort_order < sort_id) {
+					sort_id_start = i;
+					continue;
+				}
+
+				int ret = run_one_trans_trigger(trans, trans->updates + i);
+				if (ret < 0)
+					return ret;
+				if (ret)
+					trans_trigger_run = true;
 			}
+		} while (trans_trigger_run);
 
-			int ret = run_one_trans_trigger(trans, trans->updates + i);
-			if (ret < 0)
-				return ret;
-			if (ret)
-				trans_trigger_run = true;
-		}
-	} while (trans_trigger_run);
-
-	trans_for_each_update(trans, i)
-		BUG_ON(!(i->flags & BTREE_TRIGGER_norun) &&
-		       i->btree_id == btree_id &&
-		       btree_node_type_has_trans_triggers(i->bkey_type) &&
-		       (!i->insert_trigger_run || !i->overwrite_trigger_run));
-
-	return 0;
-}
-
-static int bch2_trans_commit_run_triggers(struct btree_trans *trans)
-{
-	unsigned btree_id = 0, btree_id_updates_start = 0;
-	int ret = 0;
-
-	/*
-	 *
-	 * For a given btree, this algorithm runs insert triggers before
-	 * overwrite triggers: this is so that when extents are being moved
-	 * (e.g. by FALLOCATE_FL_INSERT_RANGE), we don't drop references before
-	 * they are re-added.
-	 */
-	for (btree_id = 0; btree_id < BTREE_ID_NR; btree_id++) {
-		if (btree_id == BTREE_ID_alloc)
-			continue;
-
-		ret = run_btree_triggers(trans, btree_id, &btree_id_updates_start);
-		if (ret)
-			return ret;
+		sort_id_start = i;
 	}
 
-	btree_id_updates_start = 0;
-	ret = run_btree_triggers(trans, BTREE_ID_alloc, &btree_id_updates_start);
-	if (ret)
-		return ret;
-
 #ifdef CONFIG_BCACHEFS_DEBUG
 	trans_for_each_update(trans, i)
 		BUG_ON(!(i->flags & BTREE_TRIGGER_norun) &&
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 47e54eedd0bc..b3e346b5f8d7 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -17,7 +17,7 @@
 static inline int btree_insert_entry_cmp(const struct btree_insert_entry *l,
 					 const struct btree_insert_entry *r)
 {
-	return   cmp_int(l->btree_id,	r->btree_id) ?:
+	return   cmp_int(l->sort_order,	r->sort_order) ?:
 		 cmp_int(l->cached,	r->cached) ?:
 		 -cmp_int(l->level,	r->level) ?:
 		 bpos_cmp(l->k->k.p,	r->k->k.p);
-- 
2.45.2

