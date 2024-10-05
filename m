Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFB215A851
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153011; cv=none; b=k7RfxRdgx9dGuVbpKOXpBBBH36jxMYTAOd+6Tj5oDPeOxDIkdCGS60tmzBjg0uJil/zvLtKoW3iyRzLsA+4dngtbVtN5AklJNENyt/sBvAsw1uGxLhsBKqeQRMriF9a+kmFGHsZjQQvugsD3L3ONZ2LkOHFgp8j4hPEWuNICcSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153011; c=relaxed/simple;
	bh=PTIoWLyQ3g8btbxsWzZJsiG/PlKcUifErXpv0NmaufA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukdjOpLMgq1pdJwUrPnn9OehOp0+aePkaDl/T1WYA009tYGcKg3ft3zdMJvWgMYfWEoYFAVxCTKGaObMTmAdIpCznTvjr6r4xeBbWVP2wQwrUk0CKDlwM7EDQgJD2OVysprIeyFtonVLSnbcxbLThNLvxkrq/OMAteF9/RAwXuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=reo1Yvce; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="reo1Yvce"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hzMaHlaUTO9qsDFS6KUYknzsGqAVf+ovqQ0ICyKwhe0=;
	b=reo1YvceZUV9mWAgy9MYf4KHLaM7FtEeL8mP1Csz/d3KfIBGOmDgX62FY3cejw/RRKSWY+
	/SF95HPA2Hy2gBsQlHSCq7jZnkTeFYpmccD3v/Se68QF8vnWsjak4VwCySXxN8aEsM8Yqe
	sCyWqGgoLPh8Y78sw/qQoqUi+IE/PO8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/5] bcachefs: Split out check_unreachable_inodes() pass
Date: Sat,  5 Oct 2024 14:29:48 -0400
Message-ID: <20241005182955.1588763-2-kent.overstreet@linux.dev>
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

With inode backpointers, we can write a very simple
check_unreachable_inodes() pass that only looks for non-unlinked inodes
that are missing backpointers, and reattaches them.

This simplifies check_directory_structure() so that it's now only
checking for directory structure loops,

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c                  | 100 ++++++++++++++++++----------
 fs/bcachefs/fsck.h                  |   1 +
 fs/bcachefs/recovery_passes_types.h |   1 +
 3 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index b8a6ceb0cc7a..257366ec7939 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1292,6 +1292,58 @@ int bch2_check_inodes(struct bch_fs *c)
 	return ret;
 }
 
+static int check_unreachable_inode(struct btree_trans *trans,
+				   struct btree_iter *iter,
+				   struct bkey_s_c k)
+{
+	struct bch_fs *c = trans->c;
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	if (!bkey_is_inode(k.k))
+		return 0;
+
+	struct bch_inode_unpacked inode;
+	BUG_ON(bch2_inode_unpack(k, &inode));
+
+	if (inode.bi_subvol)
+		return 0;
+
+	if (inode.bi_flags & BCH_INODE_unlinked)
+		return 0;
+
+	if (fsck_err_on(!inode.bi_dir,
+			trans, inode_unreachable,
+			"unreachable inode:\n%s",
+			(printbuf_reset(&buf),
+			 bch2_bkey_val_to_text(&buf, c, k),
+			 buf.buf)))
+		ret = reattach_inode(trans, &inode);
+fsck_err:
+	printbuf_exit(&buf);
+	return ret;
+}
+
+/*
+ * Reattach unreachable (but not unlinked) inodes
+ *
+ * Run after check_inodes() and check_dirents(), so we node that inode
+ * backpointer fields point to valid dirents, and every inode that has a dirent
+ * that points to it has its backpointer field set - so we're just looking for
+ * non-unlinked inodes without backpointers:
+ */
+int bch2_check_unreachable_inodes(struct bch_fs *c)
+{
+	int ret = bch2_trans_run(c,
+		for_each_btree_key_commit(trans, iter, BTREE_ID_inodes,
+				POS_MIN,
+				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
+				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+			check_unreachable_inode(trans, &iter, k)));
+	bch_err_fn(c, ret);
+	return ret;
+}
+
 static inline bool btree_matches_i_mode(enum btree_id btree, unsigned mode)
 {
 	switch (btree) {
@@ -2450,22 +2502,6 @@ static int check_subvol_path(struct btree_trans *trans, struct btree_iter *iter,
 		if (ret)
 			break;
 
-		/*
-		 * We've checked that inode backpointers point to valid dirents;
-		 * here, it's sufficient to check that the subvolume root has a
-		 * dirent:
-		 */
-		if (fsck_err_on(!subvol_root.bi_dir,
-				trans, subvol_unreachable,
-				"unreachable subvolume %s",
-				(bch2_bkey_val_to_text(&buf, c, s.s_c),
-				 prt_newline(&buf),
-				 bch2_inode_unpacked_to_text(&buf, &subvol_root),
-				 buf.buf))) {
-			ret = reattach_subvol(trans, s);
-			break;
-		}
-
 		u32 parent = le32_to_cpu(s.v->fs_path_parent);
 
 		if (darray_u32_has(&subvol_path, parent)) {
@@ -2526,12 +2562,6 @@ static bool path_is_dup(pathbuf *p, u64 inum, u32 snapshot)
 	return false;
 }
 
-/*
- * Check that a given inode is reachable from its subvolume root - we already
- * verified subvolume connectivity:
- *
- * XXX: we should also be verifying that inodes are in the right subvolumes
- */
 static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c inode_k)
 {
 	struct bch_fs *c = trans->c;
@@ -2545,6 +2575,9 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 
 	BUG_ON(bch2_inode_unpack(inode_k, &inode));
 
+	if (!S_ISDIR(inode.bi_mode))
+		return 0;
+
 	while (!inode.bi_subvol) {
 		struct btree_iter dirent_iter;
 		struct bkey_s_c_dirent d;
@@ -2559,21 +2592,15 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 			bch2_trans_iter_exit(trans, &dirent_iter);
 
 		if (bch2_err_matches(ret, ENOENT)) {
-			ret = 0;
-			if (fsck_err(trans, inode_unreachable,
-				     "unreachable inode\n%s",
-				     (printbuf_reset(&buf),
-				      bch2_bkey_val_to_text(&buf, c, inode_k),
-				      buf.buf)))
-				ret = reattach_inode(trans, &inode);
+			printbuf_reset(&buf);
+			bch2_bkey_val_to_text(&buf, c, inode_k);
+			bch_err(c, "unreachable inode in check_directory_structure: %s\n%s",
+				bch2_err_str(ret), buf.buf);
 			goto out;
 		}
 
 		bch2_trans_iter_exit(trans, &dirent_iter);
 
-		if (!S_ISDIR(inode.bi_mode))
-			break;
-
 		ret = darray_push(p, ((struct pathbuf_entry) {
 			.inum		= inode.bi_inum,
 			.snapshot	= snapshot,
@@ -2626,9 +2653,8 @@ static int check_path(struct btree_trans *trans, pathbuf *p, struct bkey_s_c ino
 }
 
 /*
- * Check for unreachable inodes, as well as loops in the directory structure:
- * After bch2_check_dirents(), if an inode backpointer doesn't exist that means it's
- * unreachable:
+ * Check for loops in the directory structure: all other connectivity issues
+ * have been fixed by prior passes
  */
 int bch2_check_directory_structure(struct bch_fs *c)
 {
@@ -2756,6 +2782,10 @@ static int check_nlinks_find_hardlinks(struct bch_fs *c,
 			if (S_ISDIR(u.bi_mode))
 				continue;
 
+			/*
+			 * Previous passes ensured that bi_nlink is nonzero if
+			 * it had multiple hardlinks:
+			 */
 			if (!u.bi_nlink)
 				continue;
 
diff --git a/fs/bcachefs/fsck.h b/fs/bcachefs/fsck.h
index a4ef94271784..1cca31011530 100644
--- a/fs/bcachefs/fsck.h
+++ b/fs/bcachefs/fsck.h
@@ -9,6 +9,7 @@ int bch2_check_dirents(struct bch_fs *);
 int bch2_check_xattrs(struct bch_fs *);
 int bch2_check_root(struct bch_fs *);
 int bch2_check_subvolume_structure(struct bch_fs *);
+int bch2_check_unreachable_inodes(struct bch_fs *);
 int bch2_check_directory_structure(struct bch_fs *);
 int bch2_check_nlinks(struct bch_fs *);
 int bch2_fix_reflink_p(struct bch_fs *);
diff --git a/fs/bcachefs/recovery_passes_types.h b/fs/bcachefs/recovery_passes_types.h
index 50406ce0e4ef..9d96c06e365c 100644
--- a/fs/bcachefs/recovery_passes_types.h
+++ b/fs/bcachefs/recovery_passes_types.h
@@ -46,6 +46,7 @@
 	x(check_dirents,			27, PASS_FSCK)			\
 	x(check_xattrs,				28, PASS_FSCK)			\
 	x(check_root,				29, PASS_ONLINE|PASS_FSCK)	\
+	x(check_unreachable_inodes,		40, PASS_ONLINE|PASS_FSCK)	\
 	x(check_subvolume_structure,		36, PASS_ONLINE|PASS_FSCK)	\
 	x(check_directory_structure,		30, PASS_ONLINE|PASS_FSCK)	\
 	x(check_nlinks,				31, PASS_FSCK)			\
-- 
2.45.2

