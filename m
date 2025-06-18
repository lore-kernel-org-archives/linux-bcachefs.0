Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C097927EC76
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283711; cv=none; b=H1ZjnyNGLncz7OAaOKqZTGapYzi9PTicGxo84fy4AgUOU9KJsf3C3K2aoZ+5YZcq053Pa4QpuwMrlAAPMu735VOgfiZumDVqbDBPhOzaw5praNo07DYg7QmSZ8W72C4xRdfqbDx67/09eBCvd4PwnPg9XPbn17Nr9OFS9nLMk2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283711; c=relaxed/simple;
	bh=v3bClKQEX4t7vmSXBOHRLKtE6eubmkXkDnIl5gh4YdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlmsqcS37KrXKYOstcRJs5ii/nBVRkBRhZJ0BKOEGmq4OGrHtBEoOHWXChXdOoSfW0ZZwCUUeXtFIo4QLUnVJPAgrb6+r/INpMM4LIl72WfdnOMPb68tEPfLk1vHCjhycn0Vpuyr4Os/GgxLPRC0h1PXU5KlsLYjS174p7H+ETw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gJfpvGO3; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gJfpvGO3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283708;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ljJ603UxwBo02JRGAeSN1BPHZKhq0VInPukJ1pCNHho=;
	b=gJfpvGO3ICkpskLYTUc+9ER7jw+bMB3sDClGzeMzOAwsuPXhP4CFh2CehR5k+s0baIJzBy
	0mQ/XNRuABDpPVA/+362BZK7HkpKZFOEaJxCt7ghDpn8wujlLFM96y4JBFq/8GKSRwgyfE
	EsZo+jaFbnuYBwhMMs0mL2pN2v6yfyQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 30/37] bcachefs: fsck: Fix check_path_loop() + snapshots
Date: Wed, 18 Jun 2025 17:54:21 -0400
Message-ID: <20250618215431.738317-31-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A path exists in a particular snapshot: we should do the pathwalk in the
snapshot ID of the inode we started from, _not_ change snapshot ID as we
walk inodes and dirents.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 62 +++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 36 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 96b9ea58705f..73cff24598ed 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2689,19 +2689,13 @@ int bch2_check_subvolume_structure(struct bch_fs *c)
 	return ret;
 }
 
-struct pathbuf_entry {
-	u64	inum;
-	u32	snapshot;
-};
-
-typedef DARRAY(struct pathbuf_entry) pathbuf;
-
-static int bch2_bi_depth_renumber_one(struct btree_trans *trans, struct pathbuf_entry *p,
+static int bch2_bi_depth_renumber_one(struct btree_trans *trans,
+				      u64 inum, u32 snapshot,
 				      u32 new_depth)
 {
 	struct btree_iter iter;
 	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_inodes,
-					       SPOS(0, p->inum, p->snapshot), 0);
+					       SPOS(0, inum, snapshot), 0);
 
 	struct bch_inode_unpacked inode;
 	int ret = bkey_err(k) ?:
@@ -2720,14 +2714,15 @@ static int bch2_bi_depth_renumber_one(struct btree_trans *trans, struct pathbuf_
 	return ret;
 }
 
-static int bch2_bi_depth_renumber(struct btree_trans *trans, pathbuf *path, u32 new_bi_depth)
+static int bch2_bi_depth_renumber(struct btree_trans *trans, darray_u64 *path,
+				  u32 snapshot, u32 new_bi_depth)
 {
 	u32 restart_count = trans->restart_count;
 	int ret = 0;
 
 	darray_for_each_reverse(*path, i) {
 		ret = nested_lockrestart_do(trans,
-				bch2_bi_depth_renumber_one(trans, i, new_bi_depth));
+				bch2_bi_depth_renumber_one(trans, *i, snapshot, new_bi_depth));
 		bch_err_fn(trans->c, ret);
 		if (ret)
 			break;
@@ -2738,26 +2733,19 @@ static int bch2_bi_depth_renumber(struct btree_trans *trans, pathbuf *path, u32
 	return ret ?: trans_was_restarted(trans, restart_count);
 }
 
-static bool path_is_dup(pathbuf *p, u64 inum, u32 snapshot)
-{
-	darray_for_each(*p, i)
-		if (i->inum	== inum &&
-		    i->snapshot	== snapshot)
-			return true;
-	return false;
-}
-
 static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 {
 	struct bch_fs *c = trans->c;
 	struct btree_iter inode_iter = {};
-	pathbuf path = {};
+	darray_u64 path = {};
 	struct printbuf buf = PRINTBUF;
 	u32 snapshot = inode_k.k->p.snapshot;
 	bool redo_bi_depth = false;
 	u32 min_bi_depth = U32_MAX;
 	int ret = 0;
 
+	struct bpos start = inode_k.k->p;
+
 	struct bch_inode_unpacked inode;
 	ret = bch2_inode_unpack(inode_k, &inode);
 	if (ret)
@@ -2766,9 +2754,9 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 	while (!inode.bi_subvol) {
 		struct btree_iter dirent_iter;
 		struct bkey_s_c_dirent d;
-		u32 parent_snapshot = snapshot;
 
-		d = inode_get_dirent(trans, &dirent_iter, &inode, &parent_snapshot);
+		d = dirent_get_by_pos(trans, &dirent_iter,
+				      SPOS(inode.bi_dir, inode.bi_dir_offset, snapshot));
 		ret = bkey_err(d.s_c);
 		if (ret && !bch2_err_matches(ret, ENOENT))
 			goto out;
@@ -2786,15 +2774,10 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 
 		bch2_trans_iter_exit(trans, &dirent_iter);
 
-		ret = darray_push(&path, ((struct pathbuf_entry) {
-			.inum		= inode.bi_inum,
-			.snapshot	= snapshot,
-		}));
+		ret = darray_push(&path, inode.bi_inum);
 		if (ret)
 			return ret;
 
-		snapshot = parent_snapshot;
-
 		bch2_trans_iter_exit(trans, &inode_iter);
 		inode_k = bch2_bkey_get_iter(trans, &inode_iter, BTREE_ID_inodes,
 					     SPOS(0, inode.bi_dir, snapshot), 0);
@@ -2816,15 +2799,22 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 			break;
 
 		inode = parent_inode;
-		snapshot = inode_k.k->p.snapshot;
 		redo_bi_depth = true;
 
-		if (path_is_dup(&path, inode.bi_inum, snapshot)) {
+		if (darray_find(path, inode.bi_inum)) {
 			printbuf_reset(&buf);
-			prt_printf(&buf, "directory structure loop:\n");
-			darray_for_each_reverse(path, i)
-				prt_printf(&buf, "%llu:%u ", i->inum, i->snapshot);
-			prt_printf(&buf, "%llu:%u", inode.bi_inum, snapshot);
+			prt_printf(&buf, "directory structure loop in snapshot %u: ",
+				   snapshot);
+
+			ret = bch2_inum_snapshot_to_path(trans, start.offset, start.snapshot, NULL, &buf);
+			if (ret)
+				goto out;
+
+			if (c->opts.verbose) {
+				prt_newline(&buf);
+				darray_for_each(path, i)
+					prt_printf(&buf, "%llu ", *i);
+			}
 
 			if (fsck_err(trans, dir_loop, "%s", buf.buf)) {
 				ret = remove_backpointer(trans, &inode);
@@ -2844,7 +2834,7 @@ static int check_path_loop(struct btree_trans *trans, struct bkey_s_c inode_k)
 		min_bi_depth = 0;
 
 	if (redo_bi_depth)
-		ret = bch2_bi_depth_renumber(trans, &path, min_bi_depth);
+		ret = bch2_bi_depth_renumber(trans, &path, snapshot, min_bi_depth);
 out:
 fsck_err:
 	bch2_trans_iter_exit(trans, &inode_iter);
-- 
2.50.0

