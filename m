Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CC9627E7D1
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283704; cv=none; b=r1Oz8Q+xSj0IiZ9M+sk0SfwbP+UXzeY2drNhM09GbQVadu0DoUI31eQ1i3Yj9WD/wwSo271wBdWc5yYjr/zZRe/9QfhXZ6ETii+uhpf0xlCOtnMgxC9/roVZ3O3ntIpcDkXRYXX14gsrA1GrJoOj9xGnzrXyPwoIRQcBNF69Gwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283704; c=relaxed/simple;
	bh=5gPu52pzp80cbn6uehb9xw+c05sTG3qnFcDTSr5Ett4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+4+XeWOfFgOok86nzUNxR5WKvdV7+r1QeEpyU9mk7uIwLNfGl9A3d7imAi2LU5l7JMoVCFqlHvXnCcf/dfIyJyANALAJ6YXkiL6BsrHG9PFJJyKzf9J3du7qG/bubXjGZlnUlvKVb3/qbxL07dtn7sO3IkGB0cTqM6vrIOqVLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAXDrFYR; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAXDrFYR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fo8U30NDDZowTntEwXaF3KzgahfjONagT42neYzdekA=;
	b=EAXDrFYRpBqyFmuYYsM3LAVJdIWxCtWUw3kgr63q14ZcHxTkKSOUFp/FL+M7Sjbrx30BJp
	B2xCXUT+iwqaa3w3kwNqpd8pCR0G3K23NBoKWYGqs10vA+Bat7++Sg+akbKmuqLVSt10kn
	yXRmHhY7DHqgaf/maJEA5d3iXp0uJJ0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 21/37] bcachefs: fsck: Improve check_key_has_inode()
Date: Wed, 18 Jun 2025 17:54:12 -0400
Message-ID: <20250618215431.738317-22-kent.overstreet@linux.dev>
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

Print out more info when we find a key (extent, dirent, xattr) for a
missing inode - was there a good inode in an older snapshot, full(ish)
list of keys for that missing inode, so we can make better decisions on
how to repair.

If it looks like it should've been deleted, autofix it. If we ever hit
the non-autofix cases, we'll want to write more repair code (possibly
reconstituting the inode).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c             | 108 ++++++++++++++++++++++++++-------
 fs/bcachefs/sb-errors_format.h |   2 +-
 2 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 48810a8e5d4b..f25d33fb3e23 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1436,6 +1436,7 @@ static int check_key_has_inode(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
+	struct btree_iter iter2 = {};
 	int ret = PTR_ERR_OR_ZERO(i);
 	if (ret)
 		return ret;
@@ -1445,40 +1446,105 @@ static int check_key_has_inode(struct btree_trans *trans,
 
 	bool have_inode = i && !i->whiteout;
 
-	if (!have_inode && (c->sb.btrees_lost_data & BIT_ULL(BTREE_ID_inodes))) {
-		ret =   reconstruct_inode(trans, iter->btree_id, k.k->p.snapshot, k.k->p.inode) ?:
-			bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
-		if (ret)
-			goto err;
+	if (!have_inode && (c->sb.btrees_lost_data & BIT_ULL(BTREE_ID_inodes)))
+		goto reconstruct;
 
-		inode->last_pos.inode--;
-		ret = bch_err_throw(c, transaction_restart_nested);
-		goto err;
+	if (have_inode && btree_matches_i_mode(iter->btree_id, i->inode.bi_mode))
+		goto out;
+
+	prt_printf(&buf, ", ");
+
+	bool have_old_inode = false;
+	darray_for_each(inode->inodes, i2)
+		if (!i2->whiteout &&
+		    bch2_snapshot_is_ancestor(c, k.k->p.snapshot, i2->inode.bi_snapshot) &&
+		    btree_matches_i_mode(iter->btree_id, i2->inode.bi_mode)) {
+			prt_printf(&buf, "but found good inode in older snapshot\n");
+			bch2_inode_unpacked_to_text(&buf, &i2->inode);
+			prt_newline(&buf);
+			have_old_inode = true;
+			break;
+		}
+
+	struct bkey_s_c k2;
+	unsigned nr_keys = 0;
+
+	prt_printf(&buf, "found keys:\n");
+
+	for_each_btree_key_max_norestart(trans, iter2, iter->btree_id,
+					 SPOS(k.k->p.inode, 0, k.k->p.snapshot),
+					 POS(k.k->p.inode, U64_MAX),
+					 0, k2, ret) {
+		nr_keys++;
+		if (nr_keys <= 10) {
+			bch2_bkey_val_to_text(&buf, c, k2);
+			prt_newline(&buf);
+		}
+		if (nr_keys >= 100)
+			break;
 	}
 
-	if (fsck_err_on(!have_inode,
-			trans, key_in_missing_inode,
-			"key in missing inode:\n%s",
-			(printbuf_reset(&buf),
-			 bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
-		goto delete;
+	if (ret)
+		goto err;
 
-	if (fsck_err_on(have_inode && !btree_matches_i_mode(iter->btree_id, i->inode.bi_mode),
-			trans, key_in_wrong_inode_type,
-			"key for wrong inode mode %o:\n%s",
-			i->inode.bi_mode,
-			(printbuf_reset(&buf),
-			 bch2_bkey_val_to_text(&buf, c, k), buf.buf)))
-		goto delete;
+	if (nr_keys > 100)
+		prt_printf(&buf, "found > %u keys for this missing inode\n", nr_keys);
+	else if (nr_keys > 10)
+		prt_printf(&buf, "found %u keys for this missing inode\n", nr_keys);
+
+	if (!have_inode) {
+		if (fsck_err_on(!have_inode,
+				trans, key_in_missing_inode,
+				"key in missing inode%s", buf.buf)) {
+			/*
+			 * Maybe a deletion that raced with data move, or something
+			 * weird like that? But if we know the inode was deleted, or
+			 * it's just a few keys, we can safely delete them.
+			 *
+			 * If it's many keys, we should probably recreate the inode
+			 */
+			if (have_old_inode || nr_keys <= 2)
+				goto delete;
+			else
+				goto reconstruct;
+		}
+	} else {
+		/*
+		 * not autofix, this one would be a giant wtf - bit error in the
+		 * inode corrupting i_mode?
+		 *
+		 * may want to try repairing inode instead of deleting
+		 */
+		if (fsck_err_on(!btree_matches_i_mode(iter->btree_id, i->inode.bi_mode),
+				trans, key_in_wrong_inode_type,
+				"key for wrong inode mode %o%s",
+				i->inode.bi_mode, buf.buf))
+			goto delete;
+	}
 out:
 err:
 fsck_err:
+	bch2_trans_iter_exit(trans, &iter2);
 	printbuf_exit(&buf);
 	bch_err_fn(c, ret);
 	return ret;
 delete:
+	/*
+	 * XXX: print out more info
+	 * count up extents for this inode, check if we have different inode in
+	 * an older snapshot version, perhaps decide if we want to reconstitute
+	 */
 	ret = bch2_btree_delete_at(trans, iter, BTREE_UPDATE_internal_snapshot_node);
 	goto out;
+reconstruct:
+	ret =   reconstruct_inode(trans, iter->btree_id, k.k->p.snapshot, k.k->p.inode) ?:
+		bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
+	if (ret)
+		goto err;
+
+	inode->last_pos.inode--;
+	ret = bch_err_throw(c, transaction_restart_nested);
+	goto out;
 }
 
 static int check_i_sectors_notnested(struct btree_trans *trans, struct inode_walker *w)
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 56971ebe0f78..f1aa40542a0e 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -251,7 +251,7 @@ enum bch_fsck_flags {
 	x(deleted_inode_not_unlinked,				214,	FSCK_AUTOFIX)	\
 	x(deleted_inode_has_child_snapshots,			288,	FSCK_AUTOFIX)	\
 	x(extent_overlapping,					215,	0)		\
-	x(key_in_missing_inode,					216,	0)		\
+	x(key_in_missing_inode,					216,	FSCK_AUTOFIX)	\
 	x(key_in_wrong_inode_type,				217,	0)		\
 	x(extent_past_end_of_inode,				218,	FSCK_AUTOFIX)	\
 	x(dirent_empty_name,					219,	0)		\
-- 
2.50.0

