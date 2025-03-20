Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C0422173C
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506241; cv=none; b=PAg/JBXksjw/dip/S4bVURIXQULbVfUqPnUhT0VelCYrQrQxvcQE75EDbhhN6RptBtOl4vOdMnxB/HvDrwJjA9mXFX5pJmkGahi7Fuwrtq8lEf+HUZAxRNQKy8PPGF3hNalPDsrdazQv5/0jfRf/FTqPIYIcuoxGVvY0WSzNmW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506241; c=relaxed/simple;
	bh=GhhMJJ2fW0xIFLPUDSD6p9OygdDFgcK/PEVDJM4tSl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRIiXESKFilcLjH30eGzqV13xTZxOnCxirbCUZ3JYtuDlFO0uejXsFPPFYEytD+kN6KmkvpvAVQFxEOOfueQ5l91b0tNYyijQbPRrjK8Zjrq7Vbhozj2iVo88R/sMJHXt5TjumA3Tb7ncZv49G2WuX3xVRCw27W18e24h+7dW94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xoMc4agH; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xoMc4agH"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O/+DZZRmHbBDNHAt4GFH/gXoYky3IlI1nnigmj7mpbc=;
	b=xoMc4agHbcyC7ulwDwLHPK52XfpIy3LwnQy74/+f/pNn93g90t6xvv795I5bf8p1GDS+yA
	hHTpZKkzYJ4EJgBEa7ffG4QDgDBPc4rtkMZrtbuX5VvA1z3XrM7RdUvBIQOpUvD7sRiMvE
	gP/YBbJCUQdBV+KltkyDTydKVJZU1hg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/4] bcachefs: Move bch2_check_dirent_target() to namei.c
Date: Thu, 20 Mar 2025 17:30:17 -0400
Message-ID: <20250320213022.3359645-3-kent.overstreet@linux.dev>
In-Reply-To: <20250320213022.3359645-1-kent.overstreet@linux.dev>
References: <20250320213022.3359645-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We're gradually running more and more fsck.c checks at runtime,
whereever applicable; when we do so they get moved out of fsck.c.

Next patch will call bch2_check_dirent_target() from bch2_lookup().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/dirent.c |  51 ++++++++++
 fs/bcachefs/dirent.h |   2 +
 fs/bcachefs/fsck.c   | 229 +------------------------------------------
 fs/bcachefs/namei.c  | 173 ++++++++++++++++++++++++++++++++
 fs/bcachefs/namei.h  |   5 +
 5 files changed, 236 insertions(+), 224 deletions(-)

diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index f4c283d1e86a..d7f9f79318a2 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -729,3 +729,54 @@ int bch2_readdir(struct bch_fs *c, subvol_inum inum, struct dir_context *ctx)
 
 	return ret < 0 ? ret : 0;
 }
+
+/* fsck */
+
+static int lookup_first_inode(struct btree_trans *trans, u64 inode_nr,
+			      struct bch_inode_unpacked *inode)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret;
+
+	for_each_btree_key_norestart(trans, iter, BTREE_ID_inodes, POS(0, inode_nr),
+				     BTREE_ITER_all_snapshots, k, ret) {
+		if (k.k->p.offset != inode_nr)
+			break;
+		if (!bkey_is_inode(k.k))
+			continue;
+		ret = bch2_inode_unpack(k, inode);
+		goto found;
+	}
+	ret = -BCH_ERR_ENOENT_inode;
+found:
+	bch_err_msg(trans->c, ret, "fetching inode %llu", inode_nr);
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+int bch2_fsck_remove_dirent(struct btree_trans *trans, struct bpos pos)
+{
+	struct bch_fs *c = trans->c;
+	struct btree_iter iter;
+	struct bch_inode_unpacked dir_inode;
+	struct bch_hash_info dir_hash_info;
+	int ret;
+
+	ret = lookup_first_inode(trans, pos.inode, &dir_inode);
+	if (ret)
+		goto err;
+
+	dir_hash_info = bch2_hash_info_init(c, &dir_inode);
+
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_dirents, pos, BTREE_ITER_intent);
+
+	ret =   bch2_btree_iter_traverse(&iter) ?:
+		bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
+				    &dir_hash_info, &iter,
+				    BTREE_UPDATE_internal_snapshot_node);
+	bch2_trans_iter_exit(trans, &iter);
+err:
+	bch_err_fn(c, ret);
+	return ret;
+}
diff --git a/fs/bcachefs/dirent.h b/fs/bcachefs/dirent.h
index a6e15a012936..0880772b80a9 100644
--- a/fs/bcachefs/dirent.h
+++ b/fs/bcachefs/dirent.h
@@ -82,4 +82,6 @@ int bch2_empty_dir_snapshot(struct btree_trans *, u64, u32, u32);
 int bch2_empty_dir_trans(struct btree_trans *, subvol_inum);
 int bch2_readdir(struct bch_fs *, subvol_inum, struct dir_context *);
 
+int bch2_fsck_remove_dirent(struct btree_trans *, struct bpos);
+
 #endif /* _BCACHEFS_DIRENT_H */
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 4271ce4a4c8c..f3853b741937 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -23,13 +23,6 @@
 #include <linux/bsearch.h>
 #include <linux/dcache.h> /* struct qstr */
 
-static bool inode_points_to_dirent(struct bch_inode_unpacked *inode,
-				   struct bkey_s_c_dirent d)
-{
-	return  inode->bi_dir		== d.k->p.inode &&
-		inode->bi_dir_offset	== d.k->p.offset;
-}
-
 static int dirent_points_to_inode_nowarn(struct bkey_s_c_dirent d,
 					 struct bch_inode_unpacked *inode)
 {
@@ -116,29 +109,6 @@ static int subvol_lookup(struct btree_trans *trans, u32 subvol,
 	return ret;
 }
 
-static int lookup_first_inode(struct btree_trans *trans, u64 inode_nr,
-			      struct bch_inode_unpacked *inode)
-{
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	int ret;
-
-	for_each_btree_key_norestart(trans, iter, BTREE_ID_inodes, POS(0, inode_nr),
-				     BTREE_ITER_all_snapshots, k, ret) {
-		if (k.k->p.offset != inode_nr)
-			break;
-		if (!bkey_is_inode(k.k))
-			continue;
-		ret = bch2_inode_unpack(k, inode);
-		goto found;
-	}
-	ret = -BCH_ERR_ENOENT_inode;
-found:
-	bch_err_msg(trans->c, ret, "fetching inode %llu", inode_nr);
-	bch2_trans_iter_exit(trans, &iter);
-	return ret;
-}
-
 static int lookup_inode(struct btree_trans *trans, u64 inode_nr, u32 snapshot,
 			struct bch_inode_unpacked *inode)
 {
@@ -179,32 +149,6 @@ static int lookup_dirent_in_snapshot(struct btree_trans *trans,
 	return 0;
 }
 
-static int __remove_dirent(struct btree_trans *trans, struct bpos pos)
-{
-	struct bch_fs *c = trans->c;
-	struct btree_iter iter;
-	struct bch_inode_unpacked dir_inode;
-	struct bch_hash_info dir_hash_info;
-	int ret;
-
-	ret = lookup_first_inode(trans, pos.inode, &dir_inode);
-	if (ret)
-		goto err;
-
-	dir_hash_info = bch2_hash_info_init(c, &dir_inode);
-
-	bch2_trans_iter_init(trans, &iter, BTREE_ID_dirents, pos, BTREE_ITER_intent);
-
-	ret =   bch2_btree_iter_traverse(&iter) ?:
-		bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
-				    &dir_hash_info, &iter,
-				    BTREE_UPDATE_internal_snapshot_node);
-	bch2_trans_iter_exit(trans, &iter);
-err:
-	bch_err_fn(c, ret);
-	return ret;
-}
-
 /*
  * Find any subvolume associated with a tree of snapshots
  * We can't rely on master_subvol - it might have been deleted.
@@ -548,7 +492,7 @@ static int remove_backpointer(struct btree_trans *trans,
 				     SPOS(inode->bi_dir, inode->bi_dir_offset, inode->bi_snapshot));
 	int ret = bkey_err(d) ?:
 		  dirent_points_to_inode(c, d, inode) ?:
-		  __remove_dirent(trans, d.k->p);
+		  bch2_fsck_remove_dirent(trans, d.k->p);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
@@ -1985,169 +1929,6 @@ static int check_subdir_dirents_count(struct btree_trans *trans, struct inode_wa
 		trans_was_restarted(trans, restart_count);
 }
 
-noinline_for_stack
-static int check_dirent_inode_dirent(struct btree_trans *trans,
-				   struct btree_iter *iter,
-				   struct bkey_s_c_dirent d,
-				   struct bch_inode_unpacked *target)
-{
-	struct bch_fs *c = trans->c;
-	struct printbuf buf = PRINTBUF;
-	struct btree_iter bp_iter = { NULL };
-	int ret = 0;
-
-	if (inode_points_to_dirent(target, d))
-		return 0;
-
-	if (!target->bi_dir &&
-	    !target->bi_dir_offset) {
-		fsck_err_on(S_ISDIR(target->bi_mode),
-			    trans, inode_dir_missing_backpointer,
-			    "directory with missing backpointer\n%s",
-			    (printbuf_reset(&buf),
-			     bch2_bkey_val_to_text(&buf, c, d.s_c),
-			     prt_printf(&buf, "\n"),
-			     bch2_inode_unpacked_to_text(&buf, target),
-			     buf.buf));
-
-		fsck_err_on(target->bi_flags & BCH_INODE_unlinked,
-			    trans, inode_unlinked_but_has_dirent,
-			    "inode unlinked but has dirent\n%s",
-			    (printbuf_reset(&buf),
-			     bch2_bkey_val_to_text(&buf, c, d.s_c),
-			     prt_printf(&buf, "\n"),
-			     bch2_inode_unpacked_to_text(&buf, target),
-			     buf.buf));
-
-		target->bi_flags &= ~BCH_INODE_unlinked;
-		target->bi_dir		= d.k->p.inode;
-		target->bi_dir_offset	= d.k->p.offset;
-		return __bch2_fsck_write_inode(trans, target);
-	}
-
-	if (bch2_inode_should_have_single_bp(target) &&
-	    !fsck_err(trans, inode_wrong_backpointer,
-		      "dirent points to inode that does not point back:\n  %s",
-		      (bch2_bkey_val_to_text(&buf, c, d.s_c),
-		       prt_printf(&buf, "\n  "),
-		       bch2_inode_unpacked_to_text(&buf, target),
-		       buf.buf)))
-		goto err;
-
-	struct bkey_s_c_dirent bp_dirent = dirent_get_by_pos(trans, &bp_iter,
-			      SPOS(target->bi_dir, target->bi_dir_offset, target->bi_snapshot));
-	ret = bkey_err(bp_dirent);
-	if (ret && !bch2_err_matches(ret, ENOENT))
-		goto err;
-
-	bool backpointer_exists = !ret;
-	ret = 0;
-
-	if (fsck_err_on(!backpointer_exists,
-			trans, inode_wrong_backpointer,
-			"inode %llu:%u has wrong backpointer:\n"
-			"got       %llu:%llu\n"
-			"should be %llu:%llu",
-			target->bi_inum, target->bi_snapshot,
-			target->bi_dir,
-			target->bi_dir_offset,
-			d.k->p.inode,
-			d.k->p.offset)) {
-		target->bi_dir		= d.k->p.inode;
-		target->bi_dir_offset	= d.k->p.offset;
-		ret = __bch2_fsck_write_inode(trans, target);
-		goto out;
-	}
-
-	bch2_bkey_val_to_text(&buf, c, d.s_c);
-	prt_newline(&buf);
-	if (backpointer_exists)
-		bch2_bkey_val_to_text(&buf, c, bp_dirent.s_c);
-
-	if (fsck_err_on(backpointer_exists &&
-			(S_ISDIR(target->bi_mode) ||
-			 target->bi_subvol),
-			trans, inode_dir_multiple_links,
-			"%s %llu:%u with multiple links\n%s",
-			S_ISDIR(target->bi_mode) ? "directory" : "subvolume",
-			target->bi_inum, target->bi_snapshot, buf.buf)) {
-		ret = __remove_dirent(trans, d.k->p);
-		goto out;
-	}
-
-	/*
-	 * hardlinked file with nlink 0:
-	 * We're just adjusting nlink here so check_nlinks() will pick
-	 * it up, it ignores inodes with nlink 0
-	 */
-	if (fsck_err_on(backpointer_exists && !target->bi_nlink,
-			trans, inode_multiple_links_but_nlink_0,
-			"inode %llu:%u type %s has multiple links but i_nlink 0\n%s",
-			target->bi_inum, target->bi_snapshot, bch2_d_types[d.v->d_type], buf.buf)) {
-		target->bi_nlink++;
-		target->bi_flags &= ~BCH_INODE_unlinked;
-		ret = __bch2_fsck_write_inode(trans, target);
-		if (ret)
-			goto err;
-	}
-out:
-err:
-fsck_err:
-	bch2_trans_iter_exit(trans, &bp_iter);
-	printbuf_exit(&buf);
-	bch_err_fn(c, ret);
-	return ret;
-}
-
-noinline_for_stack
-static int check_dirent_target(struct btree_trans *trans,
-			       struct btree_iter *iter,
-			       struct bkey_s_c_dirent d,
-			       struct bch_inode_unpacked *target)
-{
-	struct bch_fs *c = trans->c;
-	struct bkey_i_dirent *n;
-	struct printbuf buf = PRINTBUF;
-	int ret = 0;
-
-	ret = check_dirent_inode_dirent(trans, iter, d, target);
-	if (ret)
-		goto err;
-
-	if (fsck_err_on(d.v->d_type != inode_d_type(target),
-			trans, dirent_d_type_wrong,
-			"incorrect d_type: got %s, should be %s:\n%s",
-			bch2_d_type_str(d.v->d_type),
-			bch2_d_type_str(inode_d_type(target)),
-			(printbuf_reset(&buf),
-			 bch2_bkey_val_to_text(&buf, c, d.s_c), buf.buf))) {
-		n = bch2_trans_kmalloc(trans, bkey_bytes(d.k));
-		ret = PTR_ERR_OR_ZERO(n);
-		if (ret)
-			goto err;
-
-		bkey_reassemble(&n->k_i, d.s_c);
-		n->v.d_type = inode_d_type(target);
-		if (n->v.d_type == DT_SUBVOL) {
-			n->v.d_parent_subvol = cpu_to_le32(target->bi_parent_subvol);
-			n->v.d_child_subvol = cpu_to_le32(target->bi_subvol);
-		} else {
-			n->v.d_inum = cpu_to_le64(target->bi_inum);
-		}
-
-		ret = bch2_trans_update(trans, iter, &n->k_i, 0);
-		if (ret)
-			goto err;
-
-		d = dirent_i_to_s_c(n);
-	}
-err:
-fsck_err:
-	printbuf_exit(&buf);
-	bch_err_fn(c, ret);
-	return ret;
-}
-
 /* find a subvolume that's a descendent of @snapshot: */
 static int find_snapshot_subvol(struct btree_trans *trans, u32 snapshot, u32 *subvolid)
 {
@@ -2247,7 +2028,7 @@ static int check_dirent_to_subvol(struct btree_trans *trans, struct btree_iter *
 		if (fsck_err(trans, dirent_to_missing_subvol,
 			     "dirent points to missing subvolume\n%s",
 			     (bch2_bkey_val_to_text(&buf, c, d.s_c), buf.buf)))
-			return __remove_dirent(trans, d.k->p);
+			return bch2_fsck_remove_dirent(trans, d.k->p);
 		ret = 0;
 		goto out;
 	}
@@ -2291,7 +2072,7 @@ static int check_dirent_to_subvol(struct btree_trans *trans, struct btree_iter *
 			goto err;
 	}
 
-	ret = check_dirent_target(trans, iter, d, &subvol_root);
+	ret = bch2_check_dirent_target(trans, iter, d, &subvol_root);
 	if (ret)
 		goto err;
 out:
@@ -2378,13 +2159,13 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 				(printbuf_reset(&buf),
 				 bch2_bkey_val_to_text(&buf, c, k),
 				 buf.buf))) {
-			ret = __remove_dirent(trans, d.k->p);
+			ret = bch2_fsck_remove_dirent(trans, d.k->p);
 			if (ret)
 				goto err;
 		}
 
 		darray_for_each(target->inodes, i) {
-			ret = check_dirent_target(trans, iter, d, &i->inode);
+			ret = bch2_check_dirent_target(trans, iter, d, &i->inode);
 			if (ret)
 				goto err;
 		}
diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index bc83acbf5414..4d0ee85e5016 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -564,6 +564,8 @@ int bch2_rename_trans(struct btree_trans *trans,
 	return ret;
 }
 
+/* inum_to_path */
+
 static inline void prt_bytes_reversed(struct printbuf *out, const void *b, unsigned n)
 {
 	bch2_printbuf_make_room(out, n);
@@ -654,3 +656,174 @@ int bch2_inum_to_path(struct btree_trans *trans, subvol_inum inum, struct printb
 	prt_str_reversed(path, "(disconnected)");
 	goto out;
 }
+
+/* fsck */
+
+static bool inode_points_to_dirent(struct bch_inode_unpacked *inode,
+				   struct bkey_s_c_dirent d)
+{
+	return  inode->bi_dir		== d.k->p.inode &&
+		inode->bi_dir_offset	== d.k->p.offset;
+}
+
+static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
+				   struct btree_iter *iter,
+				   struct bkey_s_c_dirent d,
+				   struct bch_inode_unpacked *target)
+{
+	struct bch_fs *c = trans->c;
+	struct printbuf buf = PRINTBUF;
+	struct btree_iter bp_iter = { NULL };
+	int ret = 0;
+
+	if (inode_points_to_dirent(target, d))
+		return 0;
+
+	if (!target->bi_dir &&
+	    !target->bi_dir_offset) {
+		fsck_err_on(S_ISDIR(target->bi_mode),
+			    trans, inode_dir_missing_backpointer,
+			    "directory with missing backpointer\n%s",
+			    (printbuf_reset(&buf),
+			     bch2_bkey_val_to_text(&buf, c, d.s_c),
+			     prt_printf(&buf, "\n"),
+			     bch2_inode_unpacked_to_text(&buf, target),
+			     buf.buf));
+
+		fsck_err_on(target->bi_flags & BCH_INODE_unlinked,
+			    trans, inode_unlinked_but_has_dirent,
+			    "inode unlinked but has dirent\n%s",
+			    (printbuf_reset(&buf),
+			     bch2_bkey_val_to_text(&buf, c, d.s_c),
+			     prt_printf(&buf, "\n"),
+			     bch2_inode_unpacked_to_text(&buf, target),
+			     buf.buf));
+
+		target->bi_flags &= ~BCH_INODE_unlinked;
+		target->bi_dir		= d.k->p.inode;
+		target->bi_dir_offset	= d.k->p.offset;
+		return __bch2_fsck_write_inode(trans, target);
+	}
+
+	if (bch2_inode_should_have_single_bp(target) &&
+	    !fsck_err(trans, inode_wrong_backpointer,
+		      "dirent points to inode that does not point back:\n  %s",
+		      (bch2_bkey_val_to_text(&buf, c, d.s_c),
+		       prt_printf(&buf, "\n  "),
+		       bch2_inode_unpacked_to_text(&buf, target),
+		       buf.buf)))
+		goto err;
+
+	struct bkey_s_c_dirent bp_dirent =
+		bch2_bkey_get_iter_typed(trans, &bp_iter, BTREE_ID_dirents,
+			      SPOS(target->bi_dir, target->bi_dir_offset, target->bi_snapshot),
+			      0, dirent);
+	ret = bkey_err(bp_dirent);
+	if (ret && !bch2_err_matches(ret, ENOENT))
+		goto err;
+
+	bool backpointer_exists = !ret;
+	ret = 0;
+
+	if (fsck_err_on(!backpointer_exists,
+			trans, inode_wrong_backpointer,
+			"inode %llu:%u has wrong backpointer:\n"
+			"got       %llu:%llu\n"
+			"should be %llu:%llu",
+			target->bi_inum, target->bi_snapshot,
+			target->bi_dir,
+			target->bi_dir_offset,
+			d.k->p.inode,
+			d.k->p.offset)) {
+		target->bi_dir		= d.k->p.inode;
+		target->bi_dir_offset	= d.k->p.offset;
+		ret = __bch2_fsck_write_inode(trans, target);
+		goto out;
+	}
+
+	bch2_bkey_val_to_text(&buf, c, d.s_c);
+	prt_newline(&buf);
+	if (backpointer_exists)
+		bch2_bkey_val_to_text(&buf, c, bp_dirent.s_c);
+
+	if (fsck_err_on(backpointer_exists &&
+			(S_ISDIR(target->bi_mode) ||
+			 target->bi_subvol),
+			trans, inode_dir_multiple_links,
+			"%s %llu:%u with multiple links\n%s",
+			S_ISDIR(target->bi_mode) ? "directory" : "subvolume",
+			target->bi_inum, target->bi_snapshot, buf.buf)) {
+		ret = bch2_fsck_remove_dirent(trans, d.k->p);
+		goto out;
+	}
+
+	/*
+	 * hardlinked file with nlink 0:
+	 * We're just adjusting nlink here so check_nlinks() will pick
+	 * it up, it ignores inodes with nlink 0
+	 */
+	if (fsck_err_on(backpointer_exists && !target->bi_nlink,
+			trans, inode_multiple_links_but_nlink_0,
+			"inode %llu:%u type %s has multiple links but i_nlink 0\n%s",
+			target->bi_inum, target->bi_snapshot, bch2_d_types[d.v->d_type], buf.buf)) {
+		target->bi_nlink++;
+		target->bi_flags &= ~BCH_INODE_unlinked;
+		ret = __bch2_fsck_write_inode(trans, target);
+		if (ret)
+			goto err;
+	}
+out:
+err:
+fsck_err:
+	bch2_trans_iter_exit(trans, &bp_iter);
+	printbuf_exit(&buf);
+	bch_err_fn(c, ret);
+	return ret;
+}
+
+int bch2_check_dirent_target(struct btree_trans *trans,
+			     struct btree_iter *iter,
+			     struct bkey_s_c_dirent d,
+			     struct bch_inode_unpacked *target)
+{
+	struct bch_fs *c = trans->c;
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	ret = bch2_check_dirent_inode_dirent(trans, iter, d, target);
+	if (ret)
+		goto err;
+
+	if (fsck_err_on(d.v->d_type != inode_d_type(target),
+			trans, dirent_d_type_wrong,
+			"incorrect d_type: got %s, should be %s:\n%s",
+			bch2_d_type_str(d.v->d_type),
+			bch2_d_type_str(inode_d_type(target)),
+			(printbuf_reset(&buf),
+			 bch2_bkey_val_to_text(&buf, c, d.s_c), buf.buf))) {
+		struct bkey_i_dirent *n = bch2_trans_kmalloc(trans, bkey_bytes(d.k));
+		ret = PTR_ERR_OR_ZERO(n);
+		if (ret)
+			goto err;
+
+		bkey_reassemble(&n->k_i, d.s_c);
+		n->v.d_type = inode_d_type(target);
+		if (n->v.d_type == DT_SUBVOL) {
+			n->v.d_parent_subvol = cpu_to_le32(target->bi_parent_subvol);
+			n->v.d_child_subvol = cpu_to_le32(target->bi_subvol);
+		} else {
+			n->v.d_inum = cpu_to_le64(target->bi_inum);
+		}
+
+		ret = bch2_trans_update(trans, iter, &n->k_i, 0);
+		if (ret)
+			goto err;
+
+		d = dirent_i_to_s_c(n);
+	}
+err:
+fsck_err:
+	printbuf_exit(&buf);
+	bch_err_fn(c, ret);
+	return ret;
+}
diff --git a/fs/bcachefs/namei.h b/fs/bcachefs/namei.h
index 7383b76270e9..48a2c8cb5fa9 100644
--- a/fs/bcachefs/namei.h
+++ b/fs/bcachefs/namei.h
@@ -44,4 +44,9 @@ bool bch2_reinherit_attrs(struct bch_inode_unpacked *,
 
 int bch2_inum_to_path(struct btree_trans *, subvol_inum, struct printbuf *);
 
+int bch2_check_dirent_target(struct btree_trans *,
+			     struct btree_iter *,
+			     struct bkey_s_c_dirent,
+			     struct bch_inode_unpacked *);
+
 #endif /* _BCACHEFS_NAMEI_H */
-- 
2.49.0

