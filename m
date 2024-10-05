Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10015AADB
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153011; cv=none; b=cF4WaMxbKO2WUAw08XCgm3KVvDX+OV3q4A64TjoBgIwrPbHvubRPpiY+ju5oLMd90VcE6elydMG/+VmmpDyC87uLQatsJFex1vy0n2sSbZayd7/fIQArLsZT2PmreXMJvA2f4OgnRH/ZAG9ID0q37rJZkfsF7zf04A2o+n/V5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153011; c=relaxed/simple;
	bh=ZXPWCoRrCdc7xKxR3JgiustaxdlBtUBGB7bigEZ9pC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iR2vI+xmPoHV1LiwFc8FqIXWldSuNXaqIMRBhW39C6xjNXbb/rLC7t5l0r/hFSCKKs84poOuaMUcuNmAN8iwo3TwJ2RijWa+ru3hl0vJn/X8NQctv4tciEEq4mOdkjb4IVoZbagenkGSp1PBvRL8tCJibeQGPOa73ILLeHlW5yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TtvOZQ6l; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TtvOZQ6l"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=804T43rN4/NODs51Vgt9FMEYSYP2eTOM7ilW5Vtx7hk=;
	b=TtvOZQ6lq9rAgz9T/Bey+NU1HH82ftBlBQU10Nazp80MeSG2NdeiR2WMFNnQbDiDaQdYh1
	jg6ZuX1LhGfkBiWEm+a1BAug/aRrP8oYiOQEICuFxhJZlxnNY6ikNjXaxF6F3vIsd7Y4GZ
	N9g0Dfrrz8r2y1+83KII8VdkSA8Q9Ps=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Christopher Snowhill <chris@kode54.net>
Subject: [PATCH 2/5] bcachefs: reattach_inode() now correctly handles interior snapshot nodes
Date: Sat,  5 Oct 2024 14:29:49 -0400
Message-ID: <20241005182955.1588763-3-kent.overstreet@linux.dev>
In-Reply-To: <20241005182955.1588763-1-kent.overstreet@linux.dev>
References: <20241005182955.1588763-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When we find an unreachable inode, we now reattach it in the oldest
version that needs to be reattached (thus avoiding redundant work
reattaching every single version), and we now fix up inode -> dirent
backpointers in newer versions as needed - or white out the reattaching
dirent in newer versions, if the newer version isn't supposed to be
reattached.

This results in the second verify fsck now passing cleanly after
repairing on a user-provided filesystem image with thousands of
different snapshots.

Reported-by: Christopher Snowhill <chris@kode54.net>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_iter.h |   8 ++
 fs/bcachefs/fsck.c       | 170 ++++++++++++++++++++++++++++++++++-----
 2 files changed, 158 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 78e63ad7d380..31a58bf46fdb 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -857,6 +857,14 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 	for_each_btree_key_upto_norestart(_trans, _iter, _btree_id, _start,\
 					  SPOS_MAX, _flags, _k, _ret)
 
+#define for_each_btree_key_reverse_norestart(_trans, _iter, _btree_id,	\
+					     _start, _flags, _k, _ret)	\
+	for (bch2_trans_iter_init((_trans), &(_iter), (_btree_id),	\
+				  (_start), (_flags));			\
+	     (_k) = bch2_btree_iter_peek_prev_type(&(_iter), _flags),	\
+	     !((_ret) = bkey_err(_k)) && (_k).k;			\
+	     bch2_btree_iter_rewind(&(_iter)))
+
 #define for_each_btree_key_continue_norestart(_iter, _flags, _k, _ret)	\
 	for_each_btree_key_upto_continue_norestart(_iter, SPOS_MAX, _flags, _k, _ret)
 
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 257366ec7939..92f9cabb6eae 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -326,17 +326,54 @@ static int lookup_lostfound(struct btree_trans *trans, u32 snapshot,
 	return ret;
 }
 
+static inline bool inode_should_reattach(struct bch_inode_unpacked *inode)
+{
+	if (inode->bi_inum == BCACHEFS_ROOT_INO &&
+	    inode->bi_subvol == BCACHEFS_ROOT_SUBVOL)
+		return false;
+
+	return !inode->bi_dir && !(inode->bi_flags & BCH_INODE_unlinked);
+}
+
+static int maybe_delete_dirent(struct btree_trans *trans, struct bpos d_pos, u32 snapshot)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_dirents,
+					SPOS(d_pos.inode, d_pos.offset, snapshot),
+					BTREE_ITER_intent|
+					BTREE_ITER_with_updates);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	if (bpos_eq(k.k->p, d_pos)) {
+		/*
+		 * delet_at() doesn't work because the update path doesn't
+		 * internally use BTREE_ITER_with_updates yet
+		 */
+		struct bkey_i *k = bch2_trans_kmalloc(trans, sizeof(*k));
+		ret = PTR_ERR_OR_ZERO(k);
+		if (ret)
+			goto err;
+
+		bkey_init(&k->k);
+		k->k.type = KEY_TYPE_whiteout;
+		k->k.p = iter.pos;
+		ret = bch2_trans_update(trans, &iter, k, BTREE_UPDATE_internal_snapshot_node);
+	}
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
 static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *inode)
 {
 	struct bch_fs *c = trans->c;
-	struct bch_hash_info dir_hash;
 	struct bch_inode_unpacked lostfound;
 	char name_buf[20];
-	struct qstr name;
-	u64 dir_offset = 0;
-	u32 dirent_snapshot = inode->bi_snapshot;
 	int ret;
 
+	u32 dirent_snapshot = inode->bi_snapshot;
 	if (inode->bi_subvol) {
 		inode->bi_parent_subvol = BCACHEFS_ROOT_SUBVOL;
 
@@ -367,9 +404,10 @@ static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *
 	if (ret)
 		return ret;
 
-	dir_hash = bch2_hash_info_init(c, &lostfound);
+	struct bch_hash_info dir_hash = bch2_hash_info_init(c, &lostfound);
+	struct qstr name = (struct qstr) QSTR(name_buf);
 
-	name = (struct qstr) QSTR(name_buf);
+	inode->bi_dir = lostfound.bi_inum;
 
 	ret = bch2_dirent_create_snapshot(trans,
 				inode->bi_parent_subvol, lostfound.bi_inum,
@@ -378,17 +416,70 @@ static int reattach_inode(struct btree_trans *trans, struct bch_inode_unpacked *
 				inode_d_type(inode),
 				&name,
 				inode->bi_subvol ?: inode->bi_inum,
-				&dir_offset,
+				&inode->bi_dir_offset,
 				STR_HASH_must_create);
 	if (ret) {
 		bch_err_msg(c, ret, "error creating dirent");
 		return ret;
 	}
 
-	inode->bi_dir		= lostfound.bi_inum;
-	inode->bi_dir_offset	= dir_offset;
+	ret = __bch2_fsck_write_inode(trans, inode);
+	if (ret)
+		return ret;
+
+	/*
+	 * Fix up inodes in child snapshots: if they should also be reattached
+	 * update the backpointer field, if they should not be we need to emit
+	 * whiteouts for the dirent we just created.
+	 */
+	if (!inode->bi_subvol && bch2_snapshot_is_leaf(c, inode->bi_snapshot) <= 0) {
+		snapshot_id_list whiteouts_done;
+		struct btree_iter iter;
+		struct bkey_s_c k;
+
+		darray_init(&whiteouts_done);
 
-	return __bch2_fsck_write_inode(trans, inode);
+		for_each_btree_key_reverse_norestart(trans, iter,
+				BTREE_ID_inodes, SPOS(0, inode->bi_inum, inode->bi_snapshot - 1),
+				BTREE_ITER_all_snapshots|BTREE_ITER_intent, k, ret) {
+			if (k.k->p.offset != inode->bi_inum)
+				break;
+
+			if (!bkey_is_inode(k.k) ||
+			    !bch2_snapshot_is_ancestor(c, k.k->p.snapshot, inode->bi_snapshot) ||
+			    snapshot_list_has_ancestor(c, &whiteouts_done, k.k->p.snapshot))
+				continue;
+
+			struct bch_inode_unpacked child_inode;
+			bch2_inode_unpack(k, &child_inode);
+
+			if (!inode_should_reattach(&child_inode)) {
+				ret = maybe_delete_dirent(trans,
+							  SPOS(lostfound.bi_inum, inode->bi_dir_offset,
+							       dirent_snapshot),
+							  k.k->p.snapshot);
+				if (ret)
+					break;
+
+				ret = snapshot_list_add(c, &whiteouts_done, k.k->p.snapshot);
+				if (ret)
+					break;
+			} else {
+				iter.snapshot = k.k->p.snapshot;
+				child_inode.bi_dir = inode->bi_dir;
+				child_inode.bi_dir_offset = inode->bi_dir_offset;
+
+				ret = bch2_inode_write_flags(trans, &iter, &child_inode,
+							     BTREE_UPDATE_internal_snapshot_node);
+				if (ret)
+					break;
+			}
+		}
+		darray_exit(&whiteouts_done);
+		bch2_trans_iter_exit(trans, &iter);
+	}
+
+	return ret;
 }
 
 static int remove_backpointer(struct btree_trans *trans,
@@ -1292,11 +1383,49 @@ int bch2_check_inodes(struct bch_fs *c)
 	return ret;
 }
 
+static int find_oldest_inode_needs_reattach(struct btree_trans *trans,
+					    struct bch_inode_unpacked *inode)
+{
+	struct bch_fs *c = trans->c;
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret = 0;
+
+	/*
+	 * We look for inodes to reattach in natural key order, leaves first,
+	 * but we should do the reattach at the oldest version that needs to be
+	 * reattached:
+	 */
+	for_each_btree_key_norestart(trans, iter,
+				     BTREE_ID_inodes,
+				     SPOS(0, inode->bi_inum, inode->bi_snapshot + 1),
+				     BTREE_ITER_all_snapshots, k, ret) {
+		if (k.k->p.offset != inode->bi_inum)
+			break;
+
+		if (!bch2_snapshot_is_ancestor(c, inode->bi_snapshot, k.k->p.snapshot))
+			continue;
+
+		if (!bkey_is_inode(k.k))
+			break;
+
+		struct bch_inode_unpacked parent_inode;
+		bch2_inode_unpack(k, &parent_inode);
+
+		if (!inode_should_reattach(&parent_inode))
+			break;
+
+		*inode = parent_inode;
+	}
+	bch2_trans_iter_exit(trans, &iter);
+
+	return ret;
+}
+
 static int check_unreachable_inode(struct btree_trans *trans,
 				   struct btree_iter *iter,
 				   struct bkey_s_c k)
 {
-	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
 
@@ -1306,18 +1435,17 @@ static int check_unreachable_inode(struct btree_trans *trans,
 	struct bch_inode_unpacked inode;
 	BUG_ON(bch2_inode_unpack(k, &inode));
 
-	if (inode.bi_subvol)
+	if (!inode_should_reattach(&inode))
 		return 0;
 
-	if (inode.bi_flags & BCH_INODE_unlinked)
-		return 0;
+	ret = find_oldest_inode_needs_reattach(trans, &inode);
+	if (ret)
+		return ret;
 
-	if (fsck_err_on(!inode.bi_dir,
-			trans, inode_unreachable,
-			"unreachable inode:\n%s",
-			(printbuf_reset(&buf),
-			 bch2_bkey_val_to_text(&buf, c, k),
-			 buf.buf)))
+	if (fsck_err(trans, inode_unreachable,
+		     "unreachable inode:\n%s",
+		     (bch2_inode_unpacked_to_text(&buf, &inode),
+		      buf.buf)))
 		ret = reattach_inode(trans, &inode);
 fsck_err:
 	printbuf_exit(&buf);
@@ -1331,6 +1459,8 @@ static int check_unreachable_inode(struct btree_trans *trans,
  * backpointer fields point to valid dirents, and every inode that has a dirent
  * that points to it has its backpointer field set - so we're just looking for
  * non-unlinked inodes without backpointers:
+ *
+ * XXX: this is racy w.r.t. hardlink removal in online fsck
  */
 int bch2_check_unreachable_inodes(struct bch_fs *c)
 {
-- 
2.45.2

