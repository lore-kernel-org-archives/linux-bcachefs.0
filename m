Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27211F666B
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216016; cv=none; b=rbY7rGhEFxOPOjJzB2tq8OGzkhL/tvGo73mRmlInDLizremtEg2As+ipRv8qT3Sm0kGnDT/d7SgTYOvwmRR0TPFL1iCUz2A6oR++cMNIyu72xHTeURmJKAqPDlD1bag6+WBKFxF26LnmjtfEUBrLiqyLznAkFMPvdf8DFt2O6s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216016; c=relaxed/simple;
	bh=RcKkJtsoCg4JEJhBqrBT9I2/p66KBZXHKCNjzceiIgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2ekakYDGHgrTzMqx4hlo4ZCENesMqiKHbUkWXmghXU4S5l7KEUv1DGap8gvU7TGcyxfMchwxnd5kMMMc0JlO8YZdecO08OM/T2aAgCLPfRk0UAKAe9bz6Sb+n//Okcqws+dt4bojEdIAwg4lFshOMJZS5RztC3yJTBKishasRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RwqluP+B; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RwqluP+B"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ReUYFSWRiMLieiP4blFnICzA1f5cEZz7EuEF3waNFEM=;
	b=RwqluP+BwPz7xncWNhvsjsnXmyLwSsGI7x0539bGRwn3aakoLktYiUgKr5RVUvO3nuGe0a
	ILEjYgLn08Jci8WzMMuASOxnpgtvHA8ZMfpWgCLmimtYQLb/7kpoSMPHdAfVchx1EhshZt
	4tE6se55T/y6xsYXb1QVeOBbFKicSYA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/8] bcachefs: kill inode_walker_entry.snapshot
Date: Fri,  2 May 2025 15:59:55 -0400
Message-ID: <20250502200002.1309862-4-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

redundant

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 46 ++++++++++++++++++++++------------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 7d3dd1a0ae4f..f0aa3c7479e1 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -785,12 +785,11 @@ static int ref_visible2(struct bch_fs *c,
 
 #define for_each_visible_inode(_c, _s, _w, _snapshot, _i)				\
 	for (_i = (_w)->inodes.data; _i < (_w)->inodes.data + (_w)->inodes.nr &&	\
-	     (_i)->snapshot <= (_snapshot); _i++)					\
-		if (key_visible_in_snapshot(_c, _s, _i->snapshot, _snapshot))
+	     (_i)->inode.bi_snapshot <= (_snapshot); _i++)				\
+		if (key_visible_in_snapshot(_c, _s, _i->inode.bi_snapshot, _snapshot))
 
 struct inode_walker_entry {
 	struct bch_inode_unpacked inode;
-	u32			snapshot;
 	u64			count;
 	u64			i_size;
 };
@@ -824,7 +823,6 @@ static int add_inode(struct bch_fs *c, struct inode_walker *w,
 	return bch2_inode_unpack(inode, &u) ?:
 		darray_push(&w->inodes, ((struct inode_walker_entry) {
 		.inode		= u,
-		.snapshot	= inode.k->p.snapshot,
 	}));
 }
 
@@ -870,19 +868,19 @@ lookup_inode_for_snapshot(struct bch_fs *c, struct inode_walker *w, struct bkey_
 
 	struct inode_walker_entry *i;
 	__darray_for_each(w->inodes, i)
-		if (bch2_snapshot_is_ancestor(c, k.k->p.snapshot, i->snapshot))
+		if (bch2_snapshot_is_ancestor(c, k.k->p.snapshot, i->inode.bi_snapshot))
 			goto found;
 
 	return NULL;
 found:
-	BUG_ON(k.k->p.snapshot > i->snapshot);
+	BUG_ON(k.k->p.snapshot > i->inode.bi_snapshot);
 
-	if (k.k->p.snapshot != i->snapshot && !is_whiteout) {
+	if (k.k->p.snapshot != i->inode.bi_snapshot && !is_whiteout) {
 		struct inode_walker_entry new = *i;
 
-		new.snapshot	= k.k->p.snapshot;
-		new.count	= 0;
-		new.i_size	= 0;
+		new.inode.bi_snapshot	= k.k->p.snapshot;
+		new.count		= 0;
+		new.i_size		= 0;
 
 		struct printbuf buf = PRINTBUF;
 		bch2_bkey_val_to_text(&buf, c, k);
@@ -890,10 +888,10 @@ lookup_inode_for_snapshot(struct bch_fs *c, struct inode_walker *w, struct bkey_
 		bch_info(c, "have key for inode %llu:%u but have inode in ancestor snapshot %u\n"
 			 "unexpected because we should always update the inode when we update a key in that inode\n"
 			 "%s",
-			 w->last_pos.inode, k.k->p.snapshot, i->snapshot, buf.buf);
+			 w->last_pos.inode, k.k->p.snapshot, i->inode.bi_snapshot, buf.buf);
 		printbuf_exit(&buf);
 
-		while (i > w->inodes.data && i[-1].snapshot > k.k->p.snapshot)
+		while (i > w->inodes.data && i[-1].inode.bi_snapshot > k.k->p.snapshot)
 			--i;
 
 		size_t pos = i - w->inodes.data;
@@ -1496,21 +1494,21 @@ static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_wal
 		if (i->inode.bi_sectors == i->count)
 			continue;
 
-		count2 = bch2_count_inode_sectors(trans, w->last_pos.inode, i->snapshot);
+		count2 = bch2_count_inode_sectors(trans, w->last_pos.inode, i->inode.bi_snapshot);
 
 		if (w->recalculate_sums)
 			i->count = count2;
 
 		if (i->count != count2) {
 			bch_err_ratelimited(c, "fsck counted i_sectors wrong for inode %llu:%u: got %llu should be %llu",
-					    w->last_pos.inode, i->snapshot, i->count, count2);
+					    w->last_pos.inode, i->inode.bi_snapshot, i->count, count2);
 			i->count = count2;
 		}
 
 		if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_sectors_dirty),
 				trans, inode_i_sectors_wrong,
 				"inode %llu:%u has incorrect i_sectors: got %llu, should be %llu",
-				w->last_pos.inode, i->snapshot,
+				w->last_pos.inode, i->inode.bi_snapshot,
 				i->inode.bi_sectors, i->count)) {
 			i->inode.bi_sectors = i->count;
 			ret = bch2_fsck_write_inode(trans, &i->inode);
@@ -1821,20 +1819,20 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 		for (struct inode_walker_entry *i = extent_i ?: &darray_last(inode->inodes);
 		     inode->inodes.data && i >= inode->inodes.data;
 		     --i) {
-			if (i->snapshot > k.k->p.snapshot ||
-			    !key_visible_in_snapshot(c, s, i->snapshot, k.k->p.snapshot))
+			if (i->inode.bi_snapshot > k.k->p.snapshot ||
+			    !key_visible_in_snapshot(c, s, i->inode.bi_snapshot, k.k->p.snapshot))
 				continue;
 
 			if (fsck_err_on(k.k->p.offset > round_up(i->inode.bi_size, block_bytes(c)) >> 9 &&
 					!bkey_extent_is_reservation(k),
 					trans, extent_past_end_of_inode,
 					"extent type past end of inode %llu:%u, i_size %llu\n%s",
-					i->inode.bi_inum, i->snapshot, i->inode.bi_size,
+					i->inode.bi_inum, i->inode.bi_snapshot, i->inode.bi_size,
 					(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
 				struct btree_iter iter2;
 
 				bch2_trans_copy_iter(trans, &iter2, iter);
-				bch2_btree_iter_set_snapshot(trans, &iter2, i->snapshot);
+				bch2_btree_iter_set_snapshot(trans, &iter2, i->inode.bi_snapshot);
 				ret =   bch2_btree_iter_traverse(trans, &iter2) ?:
 					bch2_btree_delete_at(trans, &iter2,
 						BTREE_UPDATE_internal_snapshot_node);
@@ -1856,8 +1854,8 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 		for (struct inode_walker_entry *i = extent_i ?: &darray_last(inode->inodes);
 		     inode->inodes.data && i >= inode->inodes.data;
 		     --i) {
-			if (i->snapshot > k.k->p.snapshot ||
-			    !key_visible_in_snapshot(c, s, i->snapshot, k.k->p.snapshot))
+			if (i->inode.bi_snapshot > k.k->p.snapshot ||
+			    !key_visible_in_snapshot(c, s, i->inode.bi_snapshot, k.k->p.snapshot))
 				continue;
 
 			i->count += k.k->size;
@@ -1939,13 +1937,13 @@ static int check_subdir_count_notnested(struct btree_trans *trans, struct inode_
 		if (i->inode.bi_nlink == i->count)
 			continue;
 
-		count2 = bch2_count_subdirs(trans, w->last_pos.inode, i->snapshot);
+		count2 = bch2_count_subdirs(trans, w->last_pos.inode, i->inode.bi_snapshot);
 		if (count2 < 0)
 			return count2;
 
 		if (i->count != count2) {
 			bch_err_ratelimited(c, "fsck counted subdirectories wrong for inum %llu:%u: got %llu should be %llu",
-					    w->last_pos.inode, i->snapshot, i->count, count2);
+					    w->last_pos.inode, i->inode.bi_snapshot, i->count, count2);
 			i->count = count2;
 			if (i->inode.bi_nlink == i->count)
 				continue;
@@ -1954,7 +1952,7 @@ static int check_subdir_count_notnested(struct btree_trans *trans, struct inode_
 		if (fsck_err_on(i->inode.bi_nlink != i->count,
 				trans, inode_dir_wrong_nlink,
 				"directory %llu:%u with wrong i_nlink: got %u, should be %llu",
-				w->last_pos.inode, i->snapshot, i->inode.bi_nlink, i->count)) {
+				w->last_pos.inode, i->inode.bi_snapshot, i->inode.bi_nlink, i->count)) {
 			i->inode.bi_nlink = i->count;
 			ret = bch2_fsck_write_inode(trans, &i->inode);
 			if (ret)
-- 
2.49.0

