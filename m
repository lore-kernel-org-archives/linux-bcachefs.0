Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5E5566A
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729990323; cv=none; b=ikj1uhds6xifhJK8anO/Wl+0DWPwihtzrdk95ETuK+DM1ZBDNfTsBQ3MrDn7DlyMHQvX0QM4sj0vWKqkC78+hbXU/Jm3MoOw5u4Jhq18TNv65djczjej7iSxMWj1F+9f2waYxqdydBZ0Ab3xPGcpNzwnOrzAsikWa3/8D6H/bnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729990323; c=relaxed/simple;
	bh=uZzcdTakbvO+bnFig26trpVzVCyQnhzZHuCCluqShv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdPHBuQsSGPgdLf2WjwVmv3tEo8zYIOXipjUkanNIdZCKMd5F62dr4h5Hm3jnmupNSYJ0oxm2GVRBEHKQtIeMqwTovmGfaBVGh3+Hdl3h0hexUSWdQrt7uoOPftnKBp99Gw2L7HDJdLtPYE9rznS/mX1vKI5kKVLANxM/1OsIJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KdmRApqi; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KdmRApqi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729990316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwY13OtfJcDqYV/Nmyk081Y1yRJ/PyloBGFENXqPxYM=;
	b=KdmRApqi4YhtMqVJgkEKWpf6sLYDTIpZgNwSIzCCjOyK5d4OA+y8poz+dH2HHSn6nhjEej
	HpBc9J15FmWs5oyWmADZY0tZYPQ6xRxZgpg3PooLpr0jFWaY8w3errbcZnAEwSJdKtupCZ
	HimrAzwg/dr39lCaplXl6hBY6WVpaNo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/9] bcachefs: Rename btree_iter_peek_upto() -> btree_iter_peek_max()
Date: Sat, 26 Oct 2024 20:51:34 -0400
Message-ID: <20241027005141.2337634-6-kent.overstreet@linux.dev>
In-Reply-To: <20241027005141.2337634-1-kent.overstreet@linux.dev>
References: <20241027005141.2337634-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We'll be introducing btree_iter_peek_prev_min(), so rename for
consistency.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c   |  6 +++---
 fs/bcachefs/btree_gc.c           |  2 +-
 fs/bcachefs/btree_iter.c         | 10 ++++-----
 fs/bcachefs/btree_iter.h         | 36 ++++++++++++++++----------------
 fs/bcachefs/btree_journal_iter.c |  4 ++--
 fs/bcachefs/btree_journal_iter.h |  2 +-
 fs/bcachefs/btree_update.c       |  6 +++---
 fs/bcachefs/dirent.c             |  4 ++--
 fs/bcachefs/ec.c                 |  2 +-
 fs/bcachefs/extent_update.c      |  2 +-
 fs/bcachefs/fs-io-pagecache.c    |  2 +-
 fs/bcachefs/fs-io.c              |  8 +++----
 fs/bcachefs/fs.c                 |  2 +-
 fs/bcachefs/fsck.c               |  8 +++----
 fs/bcachefs/inode.c              |  6 +++---
 fs/bcachefs/io_misc.c            |  6 +++---
 fs/bcachefs/io_write.c           |  4 ++--
 fs/bcachefs/movinggc.c           |  2 +-
 fs/bcachefs/reflink.c            |  2 +-
 fs/bcachefs/str_hash.h           |  6 +++---
 fs/bcachefs/subvolume.h          | 12 +++++------
 fs/bcachefs/tests.c              | 26 +++++++++++------------
 fs/bcachefs/xattr.c              |  2 +-
 23 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index c84a91572a1d..af791f4dab99 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1045,7 +1045,7 @@ static struct bkey_s_c bch2_get_key_or_hole(struct btree_iter *iter, struct bpos
 		 * btree node min/max is a closed interval, upto takes a half
 		 * open interval:
 		 */
-		k = bch2_btree_iter_peek_upto(&iter2, end);
+		k = bch2_btree_iter_peek_max(&iter2, end);
 		next = iter2.pos;
 		bch2_trans_iter_exit(iter->trans, &iter2);
 
@@ -1886,7 +1886,7 @@ static void bch2_do_discards_work(struct work_struct *work)
 	 * successful commit:
 	 */
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter,
+		for_each_btree_key_max(trans, iter,
 				   BTREE_ID_need_discard,
 				   POS(ca->dev_idx, 0),
 				   POS(ca->dev_idx, U64_MAX), 0, k,
@@ -2101,7 +2101,7 @@ static struct bkey_s_c next_lru_key(struct btree_trans *trans, struct btree_iter
 {
 	struct bkey_s_c k;
 again:
-	k = bch2_btree_iter_peek_upto(iter, lru_pos(ca->dev_idx, U64_MAX, LRU_TIME_MAX));
+	k = bch2_btree_iter_peek_max(iter, lru_pos(ca->dev_idx, U64_MAX, LRU_TIME_MAX));
 	if (!k.k && !*wrapped) {
 		bch2_btree_iter_set_pos(iter, lru_pos(ca->dev_idx, 0, 0));
 		*wrapped = true;
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index 7fbf3885b3bb..dbacccbfcbed 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -904,7 +904,7 @@ static int bch2_gc_alloc_done(struct bch_fs *c)
 
 	for_each_member_device(c, ca) {
 		ret = bch2_trans_run(c,
-			for_each_btree_key_upto_commit(trans, iter, BTREE_ID_alloc,
+			for_each_btree_key_max_commit(trans, iter, BTREE_ID_alloc,
 					POS(ca->dev_idx, ca->mi.first_bucket),
 					POS(ca->dev_idx, ca->mi.nbuckets - 1),
 					BTREE_ITER_slots|BTREE_ITER_prefetch, k,
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 2ef3ac463f66..78e370c2b790 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -2095,7 +2095,7 @@ static struct bkey_i *bch2_btree_journal_peek(struct btree_trans *trans,
 {
 	struct btree_path *path = btree_iter_path(trans, iter);
 
-	return bch2_journal_keys_peek_upto(trans->c, iter->btree_id,
+	return bch2_journal_keys_peek_max(trans->c, iter->btree_id,
 					   path->level,
 					   path->pos,
 					   end_pos,
@@ -2274,14 +2274,14 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 }
 
 /**
- * bch2_btree_iter_peek_upto() - returns first key greater than or equal to
+ * bch2_btree_iter_peek_max() - returns first key greater than or equal to
  * iterator's current position
  * @iter:	iterator to peek from
  * @end:	search limit: returns keys less than or equal to @end
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *iter, struct bpos end)
+struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos end)
 {
 	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = btree_iter_search_key(iter);
@@ -2681,7 +2681,7 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 			struct btree_iter iter2;
 
 			bch2_trans_copy_iter(&iter2, iter);
-			k = bch2_btree_iter_peek_upto(&iter2, end);
+			k = bch2_btree_iter_peek_max(&iter2, end);
 
 			if (k.k && !bkey_err(k)) {
 				swap(iter->key_cache_path, iter2.key_cache_path);
@@ -2692,7 +2692,7 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 		} else {
 			struct bpos pos = iter->pos;
 
-			k = bch2_btree_iter_peek_upto(iter, end);
+			k = bch2_btree_iter_peek_max(iter, end);
 			if (unlikely(bkey_err(k)))
 				bch2_btree_iter_set_pos(iter, pos);
 			else
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 286c11b0949c..dfda865cd394 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -401,12 +401,12 @@ struct btree *bch2_btree_iter_peek_node(struct btree_iter *);
 struct btree *bch2_btree_iter_peek_node_and_restart(struct btree_iter *);
 struct btree *bch2_btree_iter_next_node(struct btree_iter *);
 
-struct bkey_s_c bch2_btree_iter_peek_upto(struct btree_iter *, struct bpos);
+struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *, struct bpos);
 struct bkey_s_c bch2_btree_iter_next(struct btree_iter *);
 
 static inline struct bkey_s_c bch2_btree_iter_peek(struct btree_iter *iter)
 {
-	return bch2_btree_iter_peek_upto(iter, SPOS_MAX);
+	return bch2_btree_iter_peek_max(iter, SPOS_MAX);
 }
 
 struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *);
@@ -692,12 +692,12 @@ static inline struct bkey_s_c bch2_btree_iter_peek_type(struct btree_iter *iter,
 						bch2_btree_iter_peek(iter);
 }
 
-static inline struct bkey_s_c bch2_btree_iter_peek_upto_type(struct btree_iter *iter,
+static inline struct bkey_s_c bch2_btree_iter_peek_max_type(struct btree_iter *iter,
 							     struct bpos end,
 							     unsigned flags)
 {
 	if (!(flags & BTREE_ITER_slots))
-		return bch2_btree_iter_peek_upto(iter, end);
+		return bch2_btree_iter_peek_max(iter, end);
 
 	if (bkey_gt(iter->pos, end))
 		return bkey_s_c_null;
@@ -761,7 +761,7 @@ transaction_restart:							\
 	_ret2 ?: trans_was_restarted(_trans, _restart_count);		\
 })
 
-#define for_each_btree_key_upto_continue(_trans, _iter,			\
+#define for_each_btree_key_max_continue(_trans, _iter,			\
 					 _end, _flags, _k, _do)		\
 ({									\
 	struct bkey_s_c _k;						\
@@ -769,7 +769,7 @@ transaction_restart:							\
 									\
 	do {								\
 		_ret3 = lockrestart_do(_trans, ({			\
-			(_k) = bch2_btree_iter_peek_upto_type(&(_iter),	\
+			(_k) = bch2_btree_iter_peek_max_type(&(_iter),	\
 						_end, (_flags));	\
 			if (!(_k).k)					\
 				break;					\
@@ -783,9 +783,9 @@ transaction_restart:							\
 })
 
 #define for_each_btree_key_continue(_trans, _iter, _flags, _k, _do)	\
-	for_each_btree_key_upto_continue(_trans, _iter, SPOS_MAX, _flags, _k, _do)
+	for_each_btree_key_max_continue(_trans, _iter, SPOS_MAX, _flags, _k, _do)
 
-#define for_each_btree_key_upto(_trans, _iter, _btree_id,		\
+#define for_each_btree_key_max(_trans, _iter, _btree_id,		\
 				_start, _end, _flags, _k, _do)		\
 ({									\
 	bch2_trans_begin(trans);					\
@@ -794,12 +794,12 @@ transaction_restart:							\
 	bch2_trans_iter_init((_trans), &(_iter), (_btree_id),		\
 			     (_start), (_flags));			\
 									\
-	for_each_btree_key_upto_continue(_trans, _iter, _end, _flags, _k, _do);\
+	for_each_btree_key_max_continue(_trans, _iter, _end, _flags, _k, _do);\
 })
 
 #define for_each_btree_key(_trans, _iter, _btree_id,			\
 			   _start, _flags, _k, _do)			\
-	for_each_btree_key_upto(_trans, _iter, _btree_id, _start,	\
+	for_each_btree_key_max(_trans, _iter, _btree_id, _start,	\
 				 SPOS_MAX, _flags, _k, _do)
 
 #define for_each_btree_key_reverse(_trans, _iter, _btree_id,		\
@@ -843,33 +843,33 @@ transaction_restart:							\
 			    (_do) ?: bch2_trans_commit(_trans, (_disk_res),\
 					(_journal_seq), (_commit_flags)))
 
-#define for_each_btree_key_upto_commit(_trans, _iter, _btree_id,	\
+#define for_each_btree_key_max_commit(_trans, _iter, _btree_id,	\
 				  _start, _end, _iter_flags, _k,	\
 				  _disk_res, _journal_seq, _commit_flags,\
 				  _do)					\
-	for_each_btree_key_upto(_trans, _iter, _btree_id, _start, _end, _iter_flags, _k,\
+	for_each_btree_key_max(_trans, _iter, _btree_id, _start, _end, _iter_flags, _k,\
 			    (_do) ?: bch2_trans_commit(_trans, (_disk_res),\
 					(_journal_seq), (_commit_flags)))
 
 struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 
-#define for_each_btree_key_upto_norestart(_trans, _iter, _btree_id,	\
+#define for_each_btree_key_max_norestart(_trans, _iter, _btree_id,	\
 			   _start, _end, _flags, _k, _ret)		\
 	for (bch2_trans_iter_init((_trans), &(_iter), (_btree_id),	\
 				  (_start), (_flags));			\
-	     (_k) = bch2_btree_iter_peek_upto_type(&(_iter), _end, _flags),\
+	     (_k) = bch2_btree_iter_peek_max_type(&(_iter), _end, _flags),\
 	     !((_ret) = bkey_err(_k)) && (_k).k;			\
 	     bch2_btree_iter_advance(&(_iter)))
 
-#define for_each_btree_key_upto_continue_norestart(_iter, _end, _flags, _k, _ret)\
+#define for_each_btree_key_max_continue_norestart(_iter, _end, _flags, _k, _ret)\
 	for (;									\
-	     (_k) = bch2_btree_iter_peek_upto_type(&(_iter), _end, _flags),	\
+	     (_k) = bch2_btree_iter_peek_max_type(&(_iter), _end, _flags),	\
 	     !((_ret) = bkey_err(_k)) && (_k).k;				\
 	     bch2_btree_iter_advance(&(_iter)))
 
 #define for_each_btree_key_norestart(_trans, _iter, _btree_id,		\
 			   _start, _flags, _k, _ret)			\
-	for_each_btree_key_upto_norestart(_trans, _iter, _btree_id, _start,\
+	for_each_btree_key_max_norestart(_trans, _iter, _btree_id, _start,\
 					  SPOS_MAX, _flags, _k, _ret)
 
 #define for_each_btree_key_reverse_norestart(_trans, _iter, _btree_id,	\
@@ -881,7 +881,7 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 	     bch2_btree_iter_rewind(&(_iter)))
 
 #define for_each_btree_key_continue_norestart(_iter, _flags, _k, _ret)	\
-	for_each_btree_key_upto_continue_norestart(_iter, SPOS_MAX, _flags, _k, _ret)
+	for_each_btree_key_max_continue_norestart(_iter, SPOS_MAX, _flags, _k, _ret)
 
 /*
  * This should not be used in a fastpath, without first trying _do in
diff --git a/fs/bcachefs/btree_journal_iter.c b/fs/bcachefs/btree_journal_iter.c
index 924b5e3a4390..c9dee4b4627a 100644
--- a/fs/bcachefs/btree_journal_iter.c
+++ b/fs/bcachefs/btree_journal_iter.c
@@ -61,7 +61,7 @@ static size_t bch2_journal_key_search(struct journal_keys *keys,
 }
 
 /* Returns first non-overwritten key >= search key: */
-struct bkey_i *bch2_journal_keys_peek_upto(struct bch_fs *c, enum btree_id btree_id,
+struct bkey_i *bch2_journal_keys_peek_max(struct bch_fs *c, enum btree_id btree_id,
 					   unsigned level, struct bpos pos,
 					   struct bpos end_pos, size_t *idx)
 {
@@ -112,7 +112,7 @@ struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *c, enum btree_id btree
 {
 	size_t idx = 0;
 
-	return bch2_journal_keys_peek_upto(c, btree_id, level, pos, pos, &idx);
+	return bch2_journal_keys_peek_max(c, btree_id, level, pos, pos, &idx);
 }
 
 static void journal_iter_verify(struct journal_iter *iter)
diff --git a/fs/bcachefs/btree_journal_iter.h b/fs/bcachefs/btree_journal_iter.h
index 1653de9d609b..754939f604d5 100644
--- a/fs/bcachefs/btree_journal_iter.h
+++ b/fs/bcachefs/btree_journal_iter.h
@@ -43,7 +43,7 @@ static inline int journal_key_cmp(const struct journal_key *l, const struct jour
 	return __journal_key_cmp(l->btree_id, l->level, l->k->k.p, r);
 }
 
-struct bkey_i *bch2_journal_keys_peek_upto(struct bch_fs *, enum btree_id,
+struct bkey_i *bch2_journal_keys_peek_max(struct bch_fs *, enum btree_id,
 				unsigned, struct bpos, struct bpos, size_t *);
 struct bkey_i *bch2_journal_keys_peek_slot(struct bch_fs *, enum btree_id,
 					   unsigned, struct bpos);
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 79a274dcd17b..4bc0b2d52133 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -296,7 +296,7 @@ static int bch2_trans_update_extent(struct btree_trans *trans,
 			     BTREE_ITER_intent|
 			     BTREE_ITER_with_updates|
 			     BTREE_ITER_not_extents);
-	k = bch2_btree_iter_peek_upto(&iter, POS(insert->k.p.inode, U64_MAX));
+	k = bch2_btree_iter_peek_max(&iter, POS(insert->k.p.inode, U64_MAX));
 	if ((ret = bkey_err(k)))
 		goto err;
 	if (!k.k)
@@ -323,7 +323,7 @@ static int bch2_trans_update_extent(struct btree_trans *trans,
 			goto out;
 next:
 		bch2_btree_iter_advance(&iter);
-		k = bch2_btree_iter_peek_upto(&iter, POS(insert->k.p.inode, U64_MAX));
+		k = bch2_btree_iter_peek_max(&iter, POS(insert->k.p.inode, U64_MAX));
 		if ((ret = bkey_err(k)))
 			goto err;
 		if (!k.k)
@@ -721,7 +721,7 @@ int bch2_btree_delete_range_trans(struct btree_trans *trans, enum btree_id id,
 	int ret = 0;
 
 	bch2_trans_iter_init(trans, &iter, id, start, BTREE_ITER_intent);
-	while ((k = bch2_btree_iter_peek_upto(&iter, end)).k) {
+	while ((k = bch2_btree_iter_peek_max(&iter, end)).k) {
 		struct disk_reservation disk_res =
 			bch2_disk_reservation_init(trans->c, 0);
 		struct bkey_i delete;
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index faffc98d5605..4c22f78b0484 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -500,7 +500,7 @@ int bch2_empty_dir_snapshot(struct btree_trans *trans, u64 dir, u32 subvol, u32
 	struct bkey_s_c k;
 	int ret;
 
-	for_each_btree_key_upto_norestart(trans, iter, BTREE_ID_dirents,
+	for_each_btree_key_max_norestart(trans, iter, BTREE_ID_dirents,
 			   SPOS(dir, 0, snapshot),
 			   POS(dir, U64_MAX), 0, k, ret)
 		if (k.k->type == KEY_TYPE_dirent) {
@@ -549,7 +549,7 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
 	bch2_bkey_buf_init(&sk);
 
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_dirents,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_dirents,
 				   POS(inum.inum, ctx->pos),
 				   POS(inum.inum, U64_MAX),
 				   inum.subvol, 0, k, ({
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 015107e241cc..d6560bccd87c 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -2308,7 +2308,7 @@ static int bch2_invalidate_stripe_to_dev(struct btree_trans *trans, struct bkey_
 int bch2_dev_remove_stripes(struct bch_fs *c, unsigned dev_idx)
 {
 	return bch2_trans_run(c,
-		for_each_btree_key_upto_commit(trans, iter,
+		for_each_btree_key_max_commit(trans, iter,
 				  BTREE_ID_alloc, POS(dev_idx, 0), POS(dev_idx, U64_MAX),
 				  BTREE_ITER_intent, k,
 				  NULL, NULL, 0, ({
diff --git a/fs/bcachefs/extent_update.c b/fs/bcachefs/extent_update.c
index 5f4fecb358da..45c87c019f6b 100644
--- a/fs/bcachefs/extent_update.c
+++ b/fs/bcachefs/extent_update.c
@@ -128,7 +128,7 @@ int bch2_extent_atomic_end(struct btree_trans *trans,
 
 	bch2_trans_copy_iter(&copy, iter);
 
-	for_each_btree_key_upto_continue_norestart(copy, insert->k.p, 0, k, ret) {
+	for_each_btree_key_max_continue_norestart(copy, insert->k.p, 0, k, ret) {
 		unsigned offset = 0;
 
 		if (bkey_gt(bkey_start_pos(&insert->k), bkey_start_pos(k.k)))
diff --git a/fs/bcachefs/fs-io-pagecache.c b/fs/bcachefs/fs-io-pagecache.c
index 1d4910ea0f1d..51a499c5a7b6 100644
--- a/fs/bcachefs/fs-io-pagecache.c
+++ b/fs/bcachefs/fs-io-pagecache.c
@@ -199,7 +199,7 @@ int bch2_folio_set(struct bch_fs *c, subvol_inum inum,
 	unsigned folio_idx = 0;
 
 	return bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_extents,
 				   POS(inum.inum, offset),
 				   POS(inum.inum, U64_MAX),
 				   inum.subvol, BTREE_ITER_slots, k, ({
diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 8cfd17beb171..db303c6b9d84 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -222,7 +222,7 @@ static inline int range_has_data(struct bch_fs *c, u32 subvol,
 				 struct bpos end)
 {
 	return bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_extents, start, end,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_extents, start, end,
 						    subvol, 0, k, ({
 			bkey_extent_is_data(k.k) && !bkey_extent_is_unwritten(k);
 		})));
@@ -800,7 +800,7 @@ static int quota_reserve_range(struct bch_inode_info *inode,
 	u64 sectors = end - start;
 
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter,
+		for_each_btree_key_in_subvolume_max(trans, iter,
 				BTREE_ID_extents,
 				POS(inode->v.i_ino, start),
 				POS(inode->v.i_ino, end - 1),
@@ -916,7 +916,7 @@ static loff_t bch2_seek_data(struct file *file, u64 offset)
 		return -ENXIO;
 
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_extents,
 				   POS(inode->v.i_ino, offset >> 9),
 				   POS(inode->v.i_ino, U64_MAX),
 				   inum.subvol, 0, k, ({
@@ -952,7 +952,7 @@ static loff_t bch2_seek_hole(struct file *file, u64 offset)
 		return -ENXIO;
 
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_extents,
 				   POS(inode->v.i_ino, offset >> 9),
 				   POS(inode->v.i_ino, U64_MAX),
 				   inum.subvol, BTREE_ITER_slots, k, ({
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 9ca001a1d0cb..4f5034073453 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1296,7 +1296,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 
 		bch2_btree_iter_set_snapshot(&iter, snapshot);
 
-		k = bch2_btree_iter_peek_upto(&iter, end);
+		k = bch2_btree_iter_peek_max(&iter, end);
 		ret = bkey_err(k);
 		if (ret)
 			continue;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index c96025b8b65d..2229f0dcc860 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -73,7 +73,7 @@ static s64 bch2_count_inode_sectors(struct btree_trans *trans, u64 inum,
 {
 	u64 sectors = 0;
 
-	int ret = for_each_btree_key_upto(trans, iter, BTREE_ID_extents,
+	int ret = for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 				SPOS(inum, 0, snapshot),
 				POS(inum, U64_MAX),
 				0, k, ({
@@ -90,7 +90,7 @@ static s64 bch2_count_subdirs(struct btree_trans *trans, u64 inum,
 {
 	u64 subdirs = 0;
 
-	int ret = for_each_btree_key_upto(trans, iter, BTREE_ID_dirents,
+	int ret = for_each_btree_key_max(trans, iter, BTREE_ID_dirents,
 				    SPOS(inum, 0, snapshot),
 				    POS(inum, U64_MAX),
 				    0, k, ({
@@ -1751,7 +1751,7 @@ static int overlapping_extents_found(struct btree_trans *trans,
 	bch2_trans_iter_init(trans, &iter1, btree, pos1,
 			     BTREE_ITER_all_snapshots|
 			     BTREE_ITER_not_extents);
-	k1 = bch2_btree_iter_peek_upto(&iter1, POS(pos1.inode, U64_MAX));
+	k1 = bch2_btree_iter_peek_max(&iter1, POS(pos1.inode, U64_MAX));
 	ret = bkey_err(k1);
 	if (ret)
 		goto err;
@@ -1776,7 +1776,7 @@ static int overlapping_extents_found(struct btree_trans *trans,
 	while (1) {
 		bch2_btree_iter_advance(&iter2);
 
-		k2 = bch2_btree_iter_peek_upto(&iter2, POS(pos1.inode, U64_MAX));
+		k2 = bch2_btree_iter_peek_max(&iter2, POS(pos1.inode, U64_MAX));
 		ret = bkey_err(k2);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 62fcc3a0bf69..a9e61bfad186 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -618,7 +618,7 @@ bch2_bkey_get_iter_snapshot_parent(struct btree_trans *trans, struct btree_iter
 	struct bkey_s_c k;
 	int ret = 0;
 
-	for_each_btree_key_upto_norestart(trans, *iter, btree,
+	for_each_btree_key_max_norestart(trans, *iter, btree,
 					  bpos_successor(pos),
 					  SPOS(pos.inode, pos.offset, U32_MAX),
 					  flags|BTREE_ITER_all_snapshots, k, ret)
@@ -653,7 +653,7 @@ int __bch2_inode_has_child_snapshots(struct btree_trans *trans, struct bpos pos)
 	struct bkey_s_c k;
 	int ret = 0;
 
-	for_each_btree_key_upto_norestart(trans, iter,
+	for_each_btree_key_max_norestart(trans, iter,
 			BTREE_ID_inodes, POS(0, pos.offset), bpos_predecessor(pos),
 			BTREE_ITER_all_snapshots|
 			BTREE_ITER_with_updates, k, ret)
@@ -967,7 +967,7 @@ static int bch2_inode_delete_keys(struct btree_trans *trans,
 
 		bch2_btree_iter_set_snapshot(&iter, snapshot);
 
-		k = bch2_btree_iter_peek_upto(&iter, end);
+		k = bch2_btree_iter_peek_max(&iter, end);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index e2acf21ac9b0..ff661a072000 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -164,9 +164,9 @@ int bch2_fpunch_at(struct btree_trans *trans, struct btree_iter *iter,
 		bch2_btree_iter_set_snapshot(iter, snapshot);
 
 		/*
-		 * peek_upto() doesn't have ideal semantics for extents:
+		 * peek_max() doesn't have ideal semantics for extents:
 		 */
-		k = bch2_btree_iter_peek_upto(iter, end_pos);
+		k = bch2_btree_iter_peek_max(iter, end_pos);
 		if (!k.k)
 			break;
 
@@ -427,7 +427,7 @@ case LOGGED_OP_FINSERT_shift_extents:
 
 		k = insert
 			? bch2_btree_iter_peek_prev(&iter)
-			: bch2_btree_iter_peek_upto(&iter, POS(inum.inum, U64_MAX));
+			: bch2_btree_iter_peek_max(&iter, POS(inum.inum, U64_MAX));
 		if ((ret = bkey_err(k)))
 			goto btree_err;
 
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index a6b7d97540db..d3d5cff5daff 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -164,7 +164,7 @@ int bch2_sum_sector_overwrites(struct btree_trans *trans,
 
 	bch2_trans_copy_iter(&iter, extent_iter);
 
-	for_each_btree_key_upto_continue_norestart(iter,
+	for_each_btree_key_max_continue_norestart(iter,
 				new->k.p, BTREE_ITER_slots, old, ret) {
 		s64 sectors = min(new->k.p.offset, old.k->p.offset) -
 			max(bkey_start_offset(&new->k),
@@ -1165,7 +1165,7 @@ static void bch2_nocow_write_convert_unwritten(struct bch_write_op *op)
 	struct btree_trans *trans = bch2_trans_get(c);
 
 	for_each_keylist_key(&op->insert_keys, orig) {
-		int ret = for_each_btree_key_upto_commit(trans, iter, BTREE_ID_extents,
+		int ret = for_each_btree_key_max_commit(trans, iter, BTREE_ID_extents,
 				     bkey_start_pos(&orig->k), orig->k.p,
 				     BTREE_ITER_intent, k,
 				     NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index 725292d69fd6..85c361e78ba5 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -167,7 +167,7 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
 
 	bch2_trans_begin(trans);
 
-	ret = for_each_btree_key_upto(trans, iter, BTREE_ID_lru,
+	ret = for_each_btree_key_max(trans, iter, BTREE_ID_lru,
 				  lru_pos(BCH_LRU_FRAGMENTATION_START, 0, 0),
 				  lru_pos(BCH_LRU_FRAGMENTATION_START, U64_MAX, LRU_TIME_MAX),
 				  0, k, ({
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 61cc67f8636a..82e7418c4145 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -422,7 +422,7 @@ static struct bkey_s_c get_next_src(struct btree_iter *iter, struct bpos end)
 	struct bkey_s_c k;
 	int ret;
 
-	for_each_btree_key_upto_continue_norestart(*iter, end, 0, k, ret) {
+	for_each_btree_key_max_continue_norestart(*iter, end, 0, k, ret) {
 		if (bkey_extent_is_unwritten(k))
 			continue;
 
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index ec2b1feea520..00c785055d22 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -160,7 +160,7 @@ bch2_hash_lookup_in_snapshot(struct btree_trans *trans,
 	struct bkey_s_c k;
 	int ret;
 
-	for_each_btree_key_upto_norestart(trans, *iter, desc.btree_id,
+	for_each_btree_key_max_norestart(trans, *iter, desc.btree_id,
 			   SPOS(inum.inum, desc.hash_key(info, key), snapshot),
 			   POS(inum.inum, U64_MAX),
 			   BTREE_ITER_slots|flags, k, ret) {
@@ -210,7 +210,7 @@ bch2_hash_hole(struct btree_trans *trans,
 	if (ret)
 		return ret;
 
-	for_each_btree_key_upto_norestart(trans, *iter, desc.btree_id,
+	for_each_btree_key_max_norestart(trans, *iter, desc.btree_id,
 			   SPOS(inum.inum, desc.hash_key(info, key), snapshot),
 			   POS(inum.inum, U64_MAX),
 			   BTREE_ITER_slots|BTREE_ITER_intent, k, ret)
@@ -265,7 +265,7 @@ struct bkey_s_c bch2_hash_set_or_get_in_snapshot(struct btree_trans *trans,
 	bool found = false;
 	int ret;
 
-	for_each_btree_key_upto_norestart(trans, *iter, desc.btree_id,
+	for_each_btree_key_max_norestart(trans, *iter, desc.btree_id,
 			   SPOS(insert->k.p.inode,
 				desc.hash_bkey(info, bkey_i_to_s_c(insert)),
 				snapshot),
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index f897d106e142..07b23dc08614 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -34,7 +34,7 @@ int bch2_subvol_is_ro_trans(struct btree_trans *, u32);
 int bch2_subvol_is_ro(struct bch_fs *, u32);
 
 static inline struct bkey_s_c
-bch2_btree_iter_peek_in_subvolume_upto_type(struct btree_iter *iter, struct bpos end,
+bch2_btree_iter_peek_in_subvolume_max_type(struct btree_iter *iter, struct bpos end,
 					    u32 subvolid, unsigned flags)
 {
 	u32 snapshot;
@@ -43,10 +43,10 @@ bch2_btree_iter_peek_in_subvolume_upto_type(struct btree_iter *iter, struct bpos
 		return bkey_s_c_err(ret);
 
 	bch2_btree_iter_set_snapshot(iter, snapshot);
-	return bch2_btree_iter_peek_upto_type(iter, end, flags);
+	return bch2_btree_iter_peek_max_type(iter, end, flags);
 }
 
-#define for_each_btree_key_in_subvolume_upto_continue(_trans, _iter,		\
+#define for_each_btree_key_in_subvolume_max_continue(_trans, _iter,		\
 					 _end, _subvolid, _flags, _k, _do)	\
 ({										\
 	struct bkey_s_c _k;							\
@@ -54,7 +54,7 @@ bch2_btree_iter_peek_in_subvolume_upto_type(struct btree_iter *iter, struct bpos
 										\
 	do {									\
 		_ret3 = lockrestart_do(_trans, ({				\
-			(_k) = bch2_btree_iter_peek_in_subvolume_upto_type(&(_iter),	\
+			(_k) = bch2_btree_iter_peek_in_subvolume_max_type(&(_iter),	\
 						_end, _subvolid, (_flags));	\
 			if (!(_k).k)						\
 				break;						\
@@ -67,14 +67,14 @@ bch2_btree_iter_peek_in_subvolume_upto_type(struct btree_iter *iter, struct bpos
 	_ret3;									\
 })
 
-#define for_each_btree_key_in_subvolume_upto(_trans, _iter, _btree_id,		\
+#define for_each_btree_key_in_subvolume_max(_trans, _iter, _btree_id,		\
 				_start, _end, _subvolid, _flags, _k, _do)	\
 ({										\
 	struct btree_iter _iter;						\
 	bch2_trans_iter_init((_trans), &(_iter), (_btree_id),			\
 			     (_start), (_flags));				\
 										\
-	for_each_btree_key_in_subvolume_upto_continue(_trans, _iter,		\
+	for_each_btree_key_in_subvolume_max_continue(_trans, _iter,		\
 					_end, _subvolid, _flags, _k, _do);	\
 })
 
diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index 315038a0a92d..e94ba5c16c1f 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -131,7 +131,7 @@ static int test_iterate(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_xattrs,
+		for_each_btree_key_max(trans, iter, BTREE_ID_xattrs,
 					SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					0, k, ({
 			BUG_ON(k.k->p.offset != i++);
@@ -186,7 +186,7 @@ static int test_iterate_extents(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 					SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					0, k, ({
 			BUG_ON(bkey_start_offset(k.k) != i);
@@ -242,7 +242,7 @@ static int test_iterate_slots(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_xattrs,
+		for_each_btree_key_max(trans, iter, BTREE_ID_xattrs,
 					  SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					  0, k, ({
 			BUG_ON(k.k->p.offset != i);
@@ -259,7 +259,7 @@ static int test_iterate_slots(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_xattrs,
+		for_each_btree_key_max(trans, iter, BTREE_ID_xattrs,
 					SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					BTREE_ITER_slots, k, ({
 			if (i >= nr * 2)
@@ -302,7 +302,7 @@ static int test_iterate_slots_extents(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 					SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					0, k, ({
 			BUG_ON(bkey_start_offset(k.k) != i + 8);
@@ -320,7 +320,7 @@ static int test_iterate_slots_extents(struct bch_fs *c, u64 nr)
 	i = 0;
 
 	ret = bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_extents,
+		for_each_btree_key_max(trans, iter, BTREE_ID_extents,
 					SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 					BTREE_ITER_slots, k, ({
 			if (i == nr)
@@ -349,10 +349,10 @@ static int test_peek_end(struct bch_fs *c, u64 nr)
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs,
 			     SPOS(0, 0, U32_MAX), 0);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
 	bch2_trans_iter_exit(trans, &iter);
@@ -369,10 +369,10 @@ static int test_peek_end_extents(struct bch_fs *c, u64 nr)
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_extents,
 			     SPOS(0, 0, U32_MAX), 0);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
 	bch2_trans_iter_exit(trans, &iter);
@@ -488,7 +488,7 @@ static int test_snapshot_filter(struct bch_fs *c, u32 snapid_lo, u32 snapid_hi)
 	trans = bch2_trans_get(c);
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs,
 			     SPOS(0, 0, snapid_lo), 0);
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
 
 	BUG_ON(k.k->p.snapshot != U32_MAX);
 
@@ -672,7 +672,7 @@ static int __do_delete(struct btree_trans *trans, struct bpos pos)
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs, pos,
 			     BTREE_ITER_intent);
-	k = bch2_btree_iter_peek_upto(&iter, POS(0, U64_MAX));
+	k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX));
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -726,7 +726,7 @@ static int seq_insert(struct bch_fs *c, u64 nr)
 static int seq_lookup(struct bch_fs *c, u64 nr)
 {
 	return bch2_trans_run(c,
-		for_each_btree_key_upto(trans, iter, BTREE_ID_xattrs,
+		for_each_btree_key_max(trans, iter, BTREE_ID_xattrs,
 				  SPOS(0, 0, U32_MAX), POS(0, U64_MAX),
 				  0, k,
 		0));
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index ed418a747cdd..820c1791545a 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -309,7 +309,7 @@ ssize_t bch2_xattr_list(struct dentry *dentry, char *buffer, size_t buffer_size)
 	u64 offset = 0, inum = inode->ei_inode.bi_inum;
 
 	int ret = bch2_trans_run(c,
-		for_each_btree_key_in_subvolume_upto(trans, iter, BTREE_ID_xattrs,
+		for_each_btree_key_in_subvolume_max(trans, iter, BTREE_ID_xattrs,
 				   POS(inum, offset),
 				   POS(inum, U64_MAX),
 				   inode->ei_inum.subvol, 0, k, ({
-- 
2.45.2

