Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C938DD1
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="crFpk1v0"
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A909B3EB09
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:08 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nxYyIpq36J2wdQbVhSZIDT+/AA9cElXZvm94c7OQRHg=;
	b=crFpk1v0yvf3b+hgfws+eQC1lu7oGvk3oNCKmWkUtiRi9R1tlax59ewbBbXPEwnlTemmTI
	f05XYSEtSkKmYoH+4DaRAk334GcmGJVP8Z05u+Za1QM2adN5dVhb7garVOffJff2raYDpF
	ffsIMwj/ndf7geYmbQD/i34pnrxCMZc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/17] bcachefs: Kill BTREE_UPDATE_PREJOURNAL
Date: Fri, 10 Nov 2023 11:31:42 -0500
Message-ID: <20231110163157.2736111-6-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

With the previous patch that reworks BTREE_INSERT_JOURNAL_REPLAY, we can
now switch the btree write buffer to use it for flushing.

This has the advantage that transaction commits don't need to take a
journal reservation at all.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bkey_methods.h       |  2 --
 fs/bcachefs/btree_trans_commit.c |  7 +------
 fs/bcachefs/btree_types.h        |  1 -
 fs/bcachefs/btree_update.c       | 23 -----------------------
 fs/bcachefs/btree_write_buffer.c | 14 ++++++++++----
 5 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/fs/bcachefs/bkey_methods.h b/fs/bcachefs/bkey_methods.h
index 3a370b7087ac..912adadfb4dd 100644
--- a/fs/bcachefs/bkey_methods.h
+++ b/fs/bcachefs/bkey_methods.h
@@ -93,7 +93,6 @@ static inline int bch2_mark_key(struct btree_trans *trans,
 enum btree_update_flags {
 	__BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE = __BTREE_ITER_FLAGS_END,
 	__BTREE_UPDATE_NOJOURNAL,
-	__BTREE_UPDATE_PREJOURNAL,
 	__BTREE_UPDATE_KEY_CACHE_RECLAIM,
 
 	__BTREE_TRIGGER_NORUN,		/* Don't run triggers at all */
@@ -108,7 +107,6 @@ enum btree_update_flags {
 
 #define BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE (1U << __BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE)
 #define BTREE_UPDATE_NOJOURNAL		(1U << __BTREE_UPDATE_NOJOURNAL)
-#define BTREE_UPDATE_PREJOURNAL		(1U << __BTREE_UPDATE_PREJOURNAL)
 #define BTREE_UPDATE_KEY_CACHE_RECLAIM	(1U << __BTREE_UPDATE_KEY_CACHE_RECLAIM)
 
 #define BTREE_TRIGGER_NORUN		(1U << __BTREE_TRIGGER_NORUN)
diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index ec90a06a6cf9..f231f01072c2 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -779,12 +779,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
 
 	trans_for_each_update(trans, i) {
 		if (!i->cached) {
-			u64 seq = trans->journal_res.seq;
-
-			if (i->flags & BTREE_UPDATE_PREJOURNAL)
-				seq = i->seq;
-
-			bch2_btree_insert_key_leaf(trans, i->path, i->k, seq);
+			bch2_btree_insert_key_leaf(trans, i->path, i->k, trans->journal_res.seq);
 		} else if (!i->key_cache_already_flushed)
 			bch2_btree_insert_key_cached(trans, flags, i);
 		else {
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 0c97b4ef78fb..a3f24cd0043d 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -366,7 +366,6 @@ struct btree_insert_entry {
 	u8			old_btree_u64s;
 	struct bkey_i		*k;
 	struct btree_path	*path;
-	u64			seq;
 	/* key being overwritten: */
 	struct bkey		old_k;
 	const struct bch_val	*old_v;
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 324767c0ddcc..001198f15730 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -380,21 +380,12 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 {
 	struct bch_fs *c = trans->c;
 	struct btree_insert_entry *i, n;
-	u64 seq = 0;
 	int cmp;
 
 	EBUG_ON(!path->should_be_locked);
 	EBUG_ON(trans->nr_updates >= BTREE_ITER_MAX);
 	EBUG_ON(!bpos_eq(k->k.p, path->pos));
 
-	/*
-	 * The transaction journal res hasn't been allocated at this point.
-	 * That occurs at commit time. Reuse the seq field to pass in the seq
-	 * of a prejournaled key.
-	 */
-	if (flags & BTREE_UPDATE_PREJOURNAL)
-		seq = trans->journal_res.seq;
-
 	n = (struct btree_insert_entry) {
 		.flags		= flags,
 		.bkey_type	= __btree_node_type(path->level, path->btree_id),
@@ -403,7 +394,6 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 		.cached		= path->cached,
 		.path		= path,
 		.k		= k,
-		.seq		= seq,
 		.ip_allocated	= ip,
 	};
 
@@ -431,7 +421,6 @@ bch2_trans_update_by_path(struct btree_trans *trans, struct btree_path *path,
 		i->cached	= n.cached;
 		i->k		= n.k;
 		i->path		= n.path;
-		i->seq		= n.seq;
 		i->ip_allocated	= n.ip_allocated;
 	} else {
 		array_insert_item(trans->updates, trans->nr_updates,
@@ -542,18 +531,6 @@ int __must_check bch2_trans_update(struct btree_trans *trans, struct btree_iter
 	return bch2_trans_update_by_path(trans, path, k, flags, _RET_IP_);
 }
 
-/*
- * Add a transaction update for a key that has already been journaled.
- */
-int __must_check bch2_trans_update_seq(struct btree_trans *trans, u64 seq,
-				       struct btree_iter *iter, struct bkey_i *k,
-				       enum btree_update_flags flags)
-{
-	trans->journal_res.seq = seq;
-	return bch2_trans_update(trans, iter, k, flags|BTREE_UPDATE_NOJOURNAL|
-						 BTREE_UPDATE_PREJOURNAL);
-}
-
 int __must_check bch2_trans_update_buffered(struct btree_trans *trans,
 					    enum btree_id btree,
 					    struct bkey_i *k)
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 9e3107187e1d..f40ac365620f 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -76,12 +76,15 @@ static int bch2_btree_write_buffer_flush_one(struct btree_trans *trans,
 	(*fast)++;
 	return 0;
 trans_commit:
-	return  bch2_trans_update_seq(trans, wb->journal_seq, iter, &wb->k,
-				      BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
+	trans->journal_res.seq = wb->journal_seq;
+
+	return  bch2_trans_update(trans, iter, &wb->k,
+				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE) ?:
 		bch2_trans_commit(trans, NULL, NULL,
 				  commit_flags|
 				  BTREE_INSERT_NOCHECK_RW|
 				  BTREE_INSERT_NOFAIL|
+				  BTREE_INSERT_JOURNAL_REPLAY|
 				  BTREE_INSERT_JOURNAL_RECLAIM);
 }
 
@@ -125,9 +128,11 @@ btree_write_buffered_insert(struct btree_trans *trans,
 	bch2_trans_iter_init(trans, &iter, wb->btree, bkey_start_pos(&wb->k.k),
 			     BTREE_ITER_CACHED|BTREE_ITER_INTENT);
 
+	trans->journal_res.seq = wb->journal_seq;
+
 	ret   = bch2_btree_iter_traverse(&iter) ?:
-		bch2_trans_update_seq(trans, wb->journal_seq, &iter, &wb->k,
-				      BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE);
+		bch2_trans_update(trans, &iter, &wb->k,
+				  BTREE_UPDATE_INTERNAL_SNAPSHOT_NODE);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
@@ -260,6 +265,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 		ret = commit_do(trans, NULL, NULL,
 				commit_flags|
 				BTREE_INSERT_NOFAIL|
+				BTREE_INSERT_JOURNAL_REPLAY|
 				BTREE_INSERT_JOURNAL_RECLAIM,
 				btree_write_buffered_insert(trans, i));
 		if (bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret)))
-- 
2.42.0

