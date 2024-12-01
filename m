Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFA413B5A9
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Dec 2024 23:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733096672; cv=none; b=qxs+V4KQa+7vUD+yQmM4RcNN1y0q9yFehMmF4Sf1bI6pJi//vudAIE+dDofuk4SI3Hn9Ij/FfG5zi5ivmrX2XvX0MY7rCU/Kg5F6f0AOGKljfFougHf8gQgJ6D/sGSj2fIQLWko+WIke/ZwhjKO+nQgHBOfv5EaXOuEZVS4WZeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733096672; c=relaxed/simple;
	bh=EayNyllgCCSGx55QR4wwqF4bjAPSD0XUvNmMS5NETwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVxGgGjOKr/79/Ul3navIpBfII6XXRv/2UmaOaY7dVZ2Tb381XKFtRmaI48b73jDJbX5KXq/hDNEyG92Iwpx1NEWHudDGwq8b5PrVxF7U93oFFIi6AGEdItc44rbRDv1SJxMMZxRxJ/7s/QRxD5ROM5dm048oF0+mHfiDGgVDq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TSB3hYiZ; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TSB3hYiZ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733096666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=76J6gXbyRpwvZ1COdZyNwEIltX/8pXP29fS1re1WTA0=;
	b=TSB3hYiZktq0cbBAuwzuEpTd1H9IXd/4Dc0ROnfO0/KFjMbbxsKkxht5CGPisJQF8A7LwF
	4l5zUfytneTdENMUYppCX9VLpvdOJ6Cd0bKzFWQljxliCe7zHXMLkre3iqCv97dVglMtlf
	oKQ1nIqZwy+UtQeuWVs8X9DsBeJxGFQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: bcachefs_metadata_version_inode_depth
Date: Sun,  1 Dec 2024 18:44:17 -0500
Message-ID: <20241201234417.3746539-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This adds a new inode field, bi_depth, for directory inodes: this allows
us to make the check_directory_structure pass much more efficient.

Currently, to ensure the filesystem is fully connect and has no loops,
for every directory we follow backpointers until we find the root. But
by adding a depth counter, it sufficies to only check the parent of each
directory, and check that the parent's bi_depth is smaller.

(fsck doesn't require that bi_depth = parent->bi_depth + 1; if a rename
causes bi_depth off, but the chain to the root is still strictly
decreasing, then the algorithm still works and there's no need for fsck
to fixup the bi_depth fields).

We've already checked backpointers, so we know that every directory
(excluding the root)has a valid parent: if bi_depth is always
decreasing, every chain must terminate, and terminate at the root
directory.

bi_depth will not necessarily be correct when fsck runs, due to
directory renames - we can't change bi_depth on every child directory
when renaming a directory. That's ok; fsck will silently fix the
bi_depth field as needed, and future fsck runs will be much faster.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  3 +-
 fs/bcachefs/fs-common.c       | 13 +++++
 fs/bcachefs/fsck.c            | 91 ++++++++++++++++++++++++++++-------
 fs/bcachefs/inode.h           | 14 ++++++
 fs/bcachefs/inode_format.h    |  3 +-
 5 files changed, 104 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index c6cc2690aa26..f140c3366e65 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -681,7 +681,8 @@ struct bch_sb_field_ext {
 	x(inode_has_child_snapshots,	BCH_VERSION(1, 13))		\
 	x(backpointer_bucket_gen,	BCH_VERSION(1, 14))		\
 	x(disk_accounting_big_endian,	BCH_VERSION(1, 15))		\
-	x(reflink_p_may_update_opts,	BCH_VERSION(1, 16))
+	x(reflink_p_may_update_opts,	BCH_VERSION(1, 16))		\
+	x(inode_depth,			BCH_VERSION(1, 17))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/fs-common.c b/fs/bcachefs/fs-common.c
index dcaa47f68f31..d2966b670633 100644
--- a/fs/bcachefs/fs-common.c
+++ b/fs/bcachefs/fs-common.c
@@ -172,6 +172,10 @@ int bch2_create_trans(struct btree_trans *trans,
 		new_inode->bi_dir_offset	= dir_offset;
 	}
 
+	if (S_ISDIR(mode) &&
+	    !new_inode->bi_subvol)
+		new_inode->bi_depth = dir_u->bi_depth + 1;
+
 	inode_iter.flags &= ~BTREE_ITER_all_snapshots;
 	bch2_btree_iter_set_snapshot(&inode_iter, snapshot);
 
@@ -512,6 +516,15 @@ int bch2_rename_trans(struct btree_trans *trans,
 		dst_dir_u->bi_nlink++;
 	}
 
+	if (S_ISDIR(src_inode_u->bi_mode) &&
+	    !src_inode_u->bi_subvol)
+		src_inode_u->bi_depth = dst_dir_u->bi_depth + 1;
+
+	if (mode == BCH_RENAME_EXCHANGE &&
+	    S_ISDIR(dst_inode_u->bi_mode) &&
+	    !dst_inode_u->bi_subvol)
+		dst_inode_u->bi_depth = src_dir_u->bi_depth + 1;
+
 	if (dst_inum.inum && is_subdir_for_nlink(dst_inode_u)) {
 		dst_dir_u->bi_nlink--;
 		src_dir_u->bi_nlink += mode == BCH_RENAME_EXCHANGE;
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 1a5a07112779..d67a3f52dca7 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2791,6 +2791,48 @@ struct pathbuf_entry {
 
 typedef DARRAY(struct pathbuf_entry) pathbuf;
 
+static int bch2_bi_depth_renumber_one(struct btree_trans *trans, struct pathbuf_entry *p,
+				      u32 new_depth)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_inodes,
+					       SPOS(0, p->inum, p->snapshot), 0);
+
+	struct bch_inode_unpacked inode;
+	int ret = bkey_err(k) ?:
+		!bkey_is_inode(k.k) ? -BCH_ERR_ENOENT_inode
+		: bch2_inode_unpack(k, &inode);
+	if (ret)
+		goto err;
+
+	if (inode.bi_depth != new_depth) {
+		inode.bi_depth = new_depth;
+		ret = __bch2_fsck_write_inode(trans, &inode) ?:
+			bch2_trans_commit(trans, NULL, NULL, 0);
+	}
+err:
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+static int bch2_bi_depth_renumber(struct btree_trans *trans, pathbuf *path, u32 new_bi_depth)
+{
+	u32 restart_count = trans->restart_count;
+	int ret = 0;
+
+	darray_for_each_reverse(*path, i) {
+		ret = nested_lockrestart_do(trans,
+				bch2_bi_depth_renumber_one(trans, i, new_bi_depth));
+		bch_err_fn(trans->c, ret);
+		if (ret)
+			break;
+
+		new_bi_depth++;
+	}
+
+	return ret ?: trans_was_restarted(trans, restart_count);
+}
+
 static bool path_is_dup(pathbuf *p, u64 inum, u32 snapshot)
 {
 	darray_for_each(*p, i)
@@ -2800,22 +2842,20 @@ static bool path_is_dup(pathbuf *p, u64 inum, u32 snapshot)
 	return false;
 }
 
-static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c inode_k)
+static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter inode_iter = {};
-	struct bch_inode_unpacked inode;
+	pathbuf path = {};
 	struct printbuf buf = PRINTBUF;
 	u32 snapshot = inode_k.k->p.snapshot;
+	bool redo_bi_depth = false;
+	u32 min_bi_depth = U32_MAX;
 	int ret = 0;
 
-	p->nr = 0;
-
+	struct bch_inode_unpacked inode;
 	BUG_ON(bch2_inode_unpack(inode_k, &inode));
 
-	if (!S_ISDIR(inode.bi_mode))
-		return 0;
-
 	while (!inode.bi_subvol) {
 		struct btree_iter dirent_iter;
 		struct bkey_s_c_dirent d;
@@ -2839,7 +2879,7 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 
 		bch2_trans_iter_exit(trans, &dirent_iter);
 
-		ret = darray_push(p, ((struct pathbuf_entry) {
+		ret = darray_push(&path, ((struct pathbuf_entry) {
 			.inum		= inode.bi_inum,
 			.snapshot	= snapshot,
 		}));
@@ -2851,22 +2891,32 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 		bch2_trans_iter_exit(trans, &inode_iter);
 		inode_k = bch2_bkey_get_iter(trans, &inode_iter, BTREE_ID_inodes,
 					     SPOS(0, inode.bi_dir, snapshot), 0);
+
+		struct bch_inode_unpacked parent_inode;
 		ret = bkey_err(inode_k) ?:
 			!bkey_is_inode(inode_k.k) ? -BCH_ERR_ENOENT_inode
-			: bch2_inode_unpack(inode_k, &inode);
+			: bch2_inode_unpack(inode_k, &parent_inode);
 		if (ret) {
 			/* Should have been caught in dirents pass */
 			bch_err_msg(c, ret, "error looking up parent directory");
 			break;
 		}
 
+		min_bi_depth = parent_inode.bi_depth;
+
+		if (parent_inode.bi_depth < inode.bi_depth &&
+		    min_bi_depth < U16_MAX)
+			break;
+
+		inode = parent_inode;
 		snapshot = inode_k.k->p.snapshot;
+		redo_bi_depth = true;
 
-		if (path_is_dup(p, inode.bi_inum, snapshot)) {
+		if (path_is_dup(&path, inode.bi_inum, snapshot)) {
 			/* XXX print path */
 			bch_err(c, "directory structure loop");
 
-			darray_for_each(*p, i)
+			darray_for_each(path, i)
 				pr_err("%llu:%u", i->inum, i->snapshot);
 			pr_err("%llu:%u", inode.bi_inum, snapshot);
 
@@ -2879,12 +2929,21 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 				ret = reattach_inode(trans, &inode);
 				bch_err_msg(c, ret, "reattaching inode %llu", inode.bi_inum);
 			}
+
+			redo_bi_depth = false;
 			break;
 		}
 	}
+
+	if (inode.bi_subvol)
+		min_bi_depth = 0;
+
+	if (redo_bi_depth)
+		ret = bch2_bi_depth_renumber(trans, &path, min_bi_depth);
 out:
 fsck_err:
 	bch2_trans_iter_exit(trans, &inode_iter);
+	darray_exit(&path);
 	printbuf_exit(&buf);
 	bch_err_fn(c, ret);
 	return ret;
@@ -2896,24 +2955,20 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
  */
 int bch2_check_directory_structure(struct bch_fs *c)
 {
-	pathbuf path = { 0, };
-	int ret;
-
-	ret = bch2_trans_run(c,
+	int ret = bch2_trans_run(c,
 		for_each_btree_key_commit(trans, iter, BTREE_ID_inodes, POS_MIN,
 					  BTREE_ITER_intent|
 					  BTREE_ITER_prefetch|
 					  BTREE_ITER_all_snapshots, k,
 					  NULL, NULL, BCH_TRANS_COMMIT_no_enospc, ({
-			if (!bkey_is_inode(k.k))
+			if (!S_ISDIR(bkey_inode_mode(k)))
 				continue;
 
 			if (bch2_inode_flags(k) & BCH_INODE_unlinked)
 				continue;
 
-			check_path(trans, &path, k);
+			check_path_loop(trans, k);
 		})));
-	darray_exit(&path);
 
 	bch_err_fn(c, ret);
 	return ret;
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 927c875976da..5bca6950f20e 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -219,6 +219,20 @@ static inline u32 bch2_inode_flags(struct bkey_s_c k)
 	}
 }
 
+static inline unsigned bkey_inode_mode(struct bkey_s_c k)
+{
+	switch (k.k->type) {
+	case KEY_TYPE_inode:
+		return le16_to_cpu(bkey_s_c_to_inode(k).v->bi_mode);
+	case KEY_TYPE_inode_v2:
+		return le16_to_cpu(bkey_s_c_to_inode_v2(k).v->bi_mode);
+	case KEY_TYPE_inode_v3:
+		return INODEv3_MODE(bkey_s_c_to_inode_v3(k).v);
+	default:
+		return 0;
+	}
+}
+
 /* i_nlink: */
 
 static inline unsigned nlink_bias(umode_t mode)
diff --git a/fs/bcachefs/inode_format.h b/fs/bcachefs/inode_format.h
index 7928d0c6954f..be1e747629d2 100644
--- a/fs/bcachefs/inode_format.h
+++ b/fs/bcachefs/inode_format.h
@@ -101,7 +101,8 @@ struct bch_inode_generation {
 	x(bi_dir_offset,		64)	\
 	x(bi_subvol,			32)	\
 	x(bi_parent_subvol,		32)	\
-	x(bi_nocow,			8)
+	x(bi_nocow,			8)	\
+	x(bi_depth,			32)
 
 /* subset of BCH_INODE_FIELDS */
 #define BCH_INODE_OPTS()			\
-- 
2.45.2

