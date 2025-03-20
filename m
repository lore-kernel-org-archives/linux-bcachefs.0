Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC9B221D83
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742506241; cv=none; b=RslD0ax8cdzuJiHHs4y/AtoHr10cKG0ZPxknbPFwjCDPU9IHhSN+KqkMtCsOwxtlIa/YrmUi0SF4f72J2n/aitOznJl/q//gxOskPr6tyubnW/fTUV++b7/2tXD3n8CMTXCAPqfxTrZM/YOqX9z6THumM3fTCmVksQP2J/NddLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742506241; c=relaxed/simple;
	bh=PVyTeA9HBc/84d076dP9CVOGbh2xdMwXljYhGvsLiwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF6q5CylBpHInJwrzuRGkGYOhwG1JkR9wNcpQCzT395fkZP8yaJeEsyeherFZaMBOXklnmWp2FcLCFwIoY4aOjeEzfYJqZdNn8hpGwR87l9bHyx41MZyLZgtdvroEWSkxG8TFjEHbH/F+8i0fpJBZ9SAf/X1zzL9puH+HxH64rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=heligYNo; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="heligYNo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742506237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=69J0PhWzKbwqiNWlP0XJV116QLKtJ0wiZkM+qkH5ESE=;
	b=heligYNoIv/7tR5CkBxsUWnHQ+Niu6tiUimUooznAQqXztCbIag0OaLC4pxFC9ZiNWI2LH
	p6zJ0FwuFG4o7R9T/OTEOpPOmIL6P7suJsO/T96HgwjWpbCw1R9sxJYJ5onBsAdzHON5rI
	dgZ2y47Hw1ycX9uOfsGcoP7bov1l478=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/4] bcachefs: Refactor bch2_check_dirent_target()
Date: Thu, 20 Mar 2025 17:30:18 -0400
Message-ID: <20250320213022.3359645-4-kent.overstreet@linux.dev>
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

Prep work for calling bch2_check_dirent_target() from bch2_lookup().

- Add an inline wrapper, if the target and backpointer match we can skip
  the function call.

- We don't (yet?) want to remove the dirent we did the lookup from (when
  we find a directory or subvol with multiple valid dirents pointing to
  it), we can defer on that until later. For now, add an "are we in
  fsck?" parameter.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c  |   4 +-
 fs/bcachefs/inode.h |   1 +
 fs/bcachefs/namei.c | 129 +++++++++++++++++++++++---------------------
 fs/bcachefs/namei.h |  28 ++++++++--
 4 files changed, 94 insertions(+), 68 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index f3853b741937..091057023fc5 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2072,7 +2072,7 @@ static int check_dirent_to_subvol(struct btree_trans *trans, struct btree_iter *
 			goto err;
 	}
 
-	ret = bch2_check_dirent_target(trans, iter, d, &subvol_root);
+	ret = bch2_check_dirent_target(trans, iter, d, &subvol_root, true);
 	if (ret)
 		goto err;
 out:
@@ -2165,7 +2165,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 		}
 
 		darray_for_each(target->inodes, i) {
-			ret = bch2_check_dirent_target(trans, iter, d, &i->inode);
+			ret = bch2_check_dirent_target(trans, iter, d, &i->inode, true);
 			if (ret)
 				goto err;
 		}
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 428b9be6af34..f82cfbf460d0 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -277,6 +277,7 @@ static inline bool bch2_inode_should_have_single_bp(struct bch_inode_unpacked *i
 	bool inode_has_bp = inode->bi_dir || inode->bi_dir_offset;
 
 	return S_ISDIR(inode->bi_mode) ||
+		inode->bi_subvol ||
 		(!inode->bi_nlink && inode_has_bp);
 }
 
diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index 4d0ee85e5016..93246ad31541 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -659,17 +659,10 @@ int bch2_inum_to_path(struct btree_trans *trans, subvol_inum inum, struct printb
 
 /* fsck */
 
-static bool inode_points_to_dirent(struct bch_inode_unpacked *inode,
-				   struct bkey_s_c_dirent d)
-{
-	return  inode->bi_dir		== d.k->p.inode &&
-		inode->bi_dir_offset	== d.k->p.offset;
-}
-
 static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
-				   struct btree_iter *iter,
-				   struct bkey_s_c_dirent d,
-				   struct bch_inode_unpacked *target)
+					  struct bkey_s_c_dirent d,
+					  struct bch_inode_unpacked *target,
+					  bool in_fsck)
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
@@ -725,52 +718,65 @@ static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
 	bool backpointer_exists = !ret;
 	ret = 0;
 
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
+	if (!backpointer_exists) {
+		if (fsck_err(trans, inode_wrong_backpointer,
+			     "inode %llu:%u has wrong backpointer:\n"
+			     "got       %llu:%llu\n"
+			     "should be %llu:%llu",
+			     target->bi_inum, target->bi_snapshot,
+			     target->bi_dir,
+			     target->bi_dir_offset,
+			     d.k->p.inode,
+			     d.k->p.offset)) {
+			target->bi_dir		= d.k->p.inode;
+			target->bi_dir_offset	= d.k->p.offset;
+			ret = __bch2_fsck_write_inode(trans, target);
+		}
+	} else {
+		bch2_bkey_val_to_text(&buf, c, d.s_c);
+		prt_newline(&buf);
 		bch2_bkey_val_to_text(&buf, c, bp_dirent.s_c);
 
-	if (fsck_err_on(backpointer_exists &&
-			(S_ISDIR(target->bi_mode) ||
-			 target->bi_subvol),
-			trans, inode_dir_multiple_links,
-			"%s %llu:%u with multiple links\n%s",
-			S_ISDIR(target->bi_mode) ? "directory" : "subvolume",
-			target->bi_inum, target->bi_snapshot, buf.buf)) {
-		ret = bch2_fsck_remove_dirent(trans, d.k->p);
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
+		if (S_ISDIR(target->bi_mode) || target->bi_subvol) {
+			/*
+			 * XXX: verify connectivity of the other dirent
+			 * up to the root before removing this one
+			 *
+			 * Additionally, bch2_lookup would need to cope with the
+			 * dirent it found being removed - or should we remove
+			 * the other one, even though the inode points to it?
+			 */
+			if (in_fsck) {
+				if (fsck_err(trans, inode_dir_multiple_links,
+					     "%s %llu:%u with multiple links\n%s",
+					     S_ISDIR(target->bi_mode) ? "directory" : "subvolume",
+					     target->bi_inum, target->bi_snapshot, buf.buf))
+					ret = bch2_fsck_remove_dirent(trans, d.k->p);
+			} else {
+				bch2_fs_inconsistent(c,
+						"%s %llu:%u with multiple links\n%s",
+						S_ISDIR(target->bi_mode) ? "directory" : "subvolume",
+						target->bi_inum, target->bi_snapshot, buf.buf);
+			}
+
+			goto out;
+		} else {
+			/*
+			 * hardlinked file with nlink 0:
+			 * We're just adjusting nlink here so check_nlinks() will pick
+			 * it up, it ignores inodes with nlink 0
+			 */
+			if (fsck_err_on(!target->bi_nlink,
+					trans, inode_multiple_links_but_nlink_0,
+					"inode %llu:%u type %s has multiple links but i_nlink 0\n%s",
+					target->bi_inum, target->bi_snapshot, bch2_d_types[d.v->d_type], buf.buf)) {
+				target->bi_nlink++;
+				target->bi_flags &= ~BCH_INODE_unlinked;
+				ret = __bch2_fsck_write_inode(trans, target);
+				if (ret)
+					goto err;
+			}
+		}
 	}
 out:
 err:
@@ -781,16 +787,17 @@ static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_check_dirent_target(struct btree_trans *trans,
-			     struct btree_iter *iter,
-			     struct bkey_s_c_dirent d,
-			     struct bch_inode_unpacked *target)
+int __bch2_check_dirent_target(struct btree_trans *trans,
+			       struct btree_iter *dirent_iter,
+			       struct bkey_s_c_dirent d,
+			       struct bch_inode_unpacked *target,
+			       bool in_fsck)
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
 
-	ret = bch2_check_dirent_inode_dirent(trans, iter, d, target);
+	ret = bch2_check_dirent_inode_dirent(trans, d, target, in_fsck);
 	if (ret)
 		goto err;
 
@@ -815,11 +822,9 @@ int bch2_check_dirent_target(struct btree_trans *trans,
 			n->v.d_inum = cpu_to_le64(target->bi_inum);
 		}
 
-		ret = bch2_trans_update(trans, iter, &n->k_i, 0);
+		ret = bch2_trans_update(trans, dirent_iter, &n->k_i, 0);
 		if (ret)
 			goto err;
-
-		d = dirent_i_to_s_c(n);
 	}
 err:
 fsck_err:
diff --git a/fs/bcachefs/namei.h b/fs/bcachefs/namei.h
index 48a2c8cb5fa9..2e6f6364767f 100644
--- a/fs/bcachefs/namei.h
+++ b/fs/bcachefs/namei.h
@@ -44,9 +44,29 @@ bool bch2_reinherit_attrs(struct bch_inode_unpacked *,
 
 int bch2_inum_to_path(struct btree_trans *, subvol_inum, struct printbuf *);
 
-int bch2_check_dirent_target(struct btree_trans *,
-			     struct btree_iter *,
-			     struct bkey_s_c_dirent,
-			     struct bch_inode_unpacked *);
+int __bch2_check_dirent_target(struct btree_trans *,
+			       struct btree_iter *,
+			       struct bkey_s_c_dirent,
+			       struct bch_inode_unpacked *, bool);
+
+static inline bool inode_points_to_dirent(struct bch_inode_unpacked *inode,
+					  struct bkey_s_c_dirent d)
+{
+	return  inode->bi_dir		== d.k->p.inode &&
+		inode->bi_dir_offset	== d.k->p.offset;
+}
+
+static inline int bch2_check_dirent_target(struct btree_trans *trans,
+					   struct btree_iter *dirent_iter,
+					   struct bkey_s_c_dirent d,
+					   struct bch_inode_unpacked *target,
+					   bool in_fsck)
+{
+	if (likely(inode_points_to_dirent(target, d) &&
+		   d.v->d_type == inode_d_type(target)))
+		return 0;
+
+	return __bch2_check_dirent_target(trans, dirent_iter, d, target, in_fsck);
+}
 
 #endif /* _BCACHEFS_NAMEI_H */
-- 
2.49.0

