Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C403B1F873E
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216016; cv=none; b=d2nnuMTUJRNQxz9o+m+7hkt44eMSa86VV4v6s4VEn4b0LBnZ+L+pPuCh5AgibjNi9GugOA/DAjaNYIHiilUv+IY1eob8bf57pQsxJVn4tQ9yeVI4RcAVQyzNmsJZV3IOPoNgAbB5od4O2mpAvXJkZCRgFXN2xJje5neWZsxUX/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216016; c=relaxed/simple;
	bh=1S6uzaRBa0FtSxA9MxLj/7q3+opFssceFjQyClReKl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tb0qYTkxCj7DbATQ+SWXJBU4n4OpqR8AEkJVe88zdhPoYpMfEMsr2axSbEqhihaVe+lGv0FTuaj8RRujdQWbKH/F19Jv6hKLxOx5B2FiYc5ttUaswrBSkaEt9YpBB7j/c3jJpdHhClrk3SC35PlJ0HVk7PS5jjg7nkRWss6tDSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v/7x32wP; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v/7x32wP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216012;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MZFpD/v/lwWIJu11j483vAie+phHYD55UN+mWXSFa1c=;
	b=v/7x32wPaX2xCjkcuyxBeWCh+y6lrc8/7WRTWV+nNsLj9wf4KndpxMEAllTBUkRxTp19ok
	WRn5NOx6oBWW5B26b8037BpV+O85+5fqkQ4DrI1W897wnwsReBvVlqW3bM50I9JmEOkkMG
	5eMrxJJzEH2Ct7fpf4JP0wb7uBIAaf4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/8] bcachefs: BCH_FSCK_ERR_snapshot_key_missing_inode_snapshot
Date: Fri,  2 May 2025 15:59:56 -0400
Message-ID: <20250502200002.1309862-5-kent.overstreet@linux.dev>
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

We're going to be doing some snapshot deletion performance improvements,
and those will strictly require that if an extent/dirent/xattr is
present, an inode is present in that snapshot ID.

We already check for this, but we don't repair it on disk: this patch
adds that repair and turns it into a real fsck_err().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c             | 44 ++++++++++++++++------------------
 fs/bcachefs/sb-errors_format.h |  3 ++-
 2 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index f0aa3c7479e1..dd88113a7c70 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -862,9 +862,9 @@ static int get_inodes_all_snapshots(struct btree_trans *trans,
 }
 
 static struct inode_walker_entry *
-lookup_inode_for_snapshot(struct bch_fs *c, struct inode_walker *w, struct bkey_s_c k)
+lookup_inode_for_snapshot(struct btree_trans *trans, struct inode_walker *w, struct bkey_s_c k)
 {
-	bool is_whiteout = k.k->type == KEY_TYPE_whiteout;
+	struct bch_fs *c = trans->c;
 
 	struct inode_walker_entry *i;
 	__darray_for_each(w->inodes, i)
@@ -875,34 +875,32 @@ lookup_inode_for_snapshot(struct bch_fs *c, struct inode_walker *w, struct bkey_
 found:
 	BUG_ON(k.k->p.snapshot > i->inode.bi_snapshot);
 
-	if (k.k->p.snapshot != i->inode.bi_snapshot && !is_whiteout) {
-		struct inode_walker_entry new = *i;
-
-		new.inode.bi_snapshot	= k.k->p.snapshot;
-		new.count		= 0;
-		new.i_size		= 0;
-
-		struct printbuf buf = PRINTBUF;
-		bch2_bkey_val_to_text(&buf, c, k);
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
 
-		bch_info(c, "have key for inode %llu:%u but have inode in ancestor snapshot %u\n"
+	if (fsck_err_on(k.k->p.snapshot != i->inode.bi_snapshot,
+			trans, snapshot_key_missing_inode_snapshot,
+			 "have key for inode %llu:%u but have inode in ancestor snapshot %u\n"
 			 "unexpected because we should always update the inode when we update a key in that inode\n"
 			 "%s",
-			 w->last_pos.inode, k.k->p.snapshot, i->inode.bi_snapshot, buf.buf);
-		printbuf_exit(&buf);
+			 w->last_pos.inode, k.k->p.snapshot, i->inode.bi_snapshot,
+			 (bch2_bkey_val_to_text(&buf, c, k),
+			  buf.buf))) {
+		struct bch_inode_unpacked new = i->inode;
 
-		while (i > w->inodes.data && i[-1].inode.bi_snapshot > k.k->p.snapshot)
-			--i;
+		new.bi_snapshot = k.k->p.snapshot;
 
-		size_t pos = i - w->inodes.data;
-		int ret = darray_insert_item(&w->inodes, pos, new);
-		if (ret)
-			return ERR_PTR(ret);
-
-		i = w->inodes.data + pos;
+		ret = __bch2_fsck_write_inode(trans, &new) ?:
+			bch2_trans_commit(trans, NULL, NULL, 0) ?:
+			-BCH_ERR_transaction_restart_nested;
+		goto fsck_err;
 	}
 
+	printbuf_exit(&buf);
 	return i;
+fsck_err:
+	printbuf_exit(&buf);
+	return ERR_PTR(ret);
 }
 
 static struct inode_walker_entry *walk_inode(struct btree_trans *trans,
@@ -917,7 +915,7 @@ static struct inode_walker_entry *walk_inode(struct btree_trans *trans,
 
 	w->last_pos = k.k->p;
 
-	return lookup_inode_for_snapshot(trans->c, w, k);
+	return lookup_inode_for_snapshot(trans, w, k);
 }
 
 static int get_visible_inodes(struct btree_trans *trans,
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 6389f6e0f8dc..82bc1906aa00 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -216,6 +216,7 @@ enum bch_fsck_flags {
 	x(inode_str_hash_invalid,				194,	0)		\
 	x(inode_v3_fields_start_bad,				195,	0)		\
 	x(inode_snapshot_mismatch,				196,	0)		\
+	x(snapshot_key_missing_inode_snapshot,			314,	FSCK_AUTOFIX)	\
 	x(inode_unlinked_but_clean,				197,	0)		\
 	x(inode_unlinked_but_nlink_nonzero,			198,	0)		\
 	x(inode_unlinked_and_not_open,				281,	0)		\
@@ -323,7 +324,7 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							314,	0)
+	x(MAX,							315,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.49.0

