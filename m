Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC39FEEBD
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 00:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739839206; cv=none; b=V3h0AgyfpoLp++dypGmlLYe3WblG9YHg7cXbNh36tEd37hgHjiB9M6z/xidDdNUpjQyPP5dI4LBHkes/J1LmNz+S9c/ctWSI96OXbtR5OGJKBPuZg0xk17Wqw+ww0HL84zaynadLGAPwV26x0LiPSrVtae907K6W0rW3Vwg5GKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739839206; c=relaxed/simple;
	bh=wUT0X8uPRwtw+hsBCJlXeeyV+lqzWLNXOvMSod3fiv4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KbBmQHtfKp7LjLYrmg2VMfiXzD2OupQZiVQVwLTwKJDIBNVPt9+UbgY8e7u9NIeAZY/uQc0dFB/XKOTetiBmxDuGJZFURCye6hb1lef192L6NfAB0t5NlqBXYfTAV9BeTSl4qhby2CWVS3shuZD93cvlvEt8QQoH0t9VYmOJnkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wpkJ2K42; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wpkJ2K42"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739839200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5NhyvfuCFjZtG9KRJ8AfJMWYw7WHYoX8LmGijaIMWYE=;
	b=wpkJ2K42ChblkMGdQMH3xogFyzAYhHgtjKDfX+m6H7oAQePENeghqNkQaNBmchpPkCXJ8k
	qOjzShadqI0Mbr5JAG/viQ81vcByz1Mt0S3FlT2uGYhDuSg7xADV7ps6EmeJrHrQo7TUS6
	17sgxIQTFCzJBxFOucyI7gICDcMaw/0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH] bcachefs: Fix fsck directory i_size checking
Date: Mon, 17 Feb 2025 19:39:48 -0500
Message-ID: <20250218003948.757888-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hongbo - please go over this thoroughly. It turns out (and I should've
caught this before I merged it) your check code in fsck.c was completely
fubar, and wouldn't ever log an error when i_size was off, so bugs
elsewhere would have been masked.

-- >8 --

Error handling was wrong, causing unhandled transaction restart errors.

check_directory_size() was also inefficient, since keys in multiple
snapshots would be iterated over once for every snapshot. Convert it to
the same scheme used for i_sectors and subdir count checking.

Cc: Hongbo Li <lihongbo22@huawei.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 78 ++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 47 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 53a421ff136d..d406336e9a0a 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -823,6 +823,7 @@ struct inode_walker_entry {
 	struct bch_inode_unpacked inode;
 	u32			snapshot;
 	u64			count;
+	u64			i_size;
 };
 
 struct inode_walker {
@@ -910,8 +911,9 @@ lookup_inode_for_snapshot(struct bch_fs *c, struct inode_walker *w, struct bkey_
 	if (k.k->p.snapshot != i->snapshot && !is_whiteout) {
 		struct inode_walker_entry new = *i;
 
-		new.snapshot = k.k->p.snapshot;
-		new.count = 0;
+		new.snapshot	= k.k->p.snapshot;
+		new.count	= 0;
+		new.i_size	= 0;
 
 		struct printbuf buf = PRINTBUF;
 		bch2_bkey_val_to_text(&buf, c, k);
@@ -1116,37 +1118,6 @@ static int get_snapshot_root_inode(struct btree_trans *trans,
 	return ret;
 }
 
-static int check_directory_size(struct btree_trans *trans,
-				struct bch_inode_unpacked *inode_u,
-				struct bkey_s_c inode_k, bool *write_inode)
-{
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	u64 new_size = 0;
-	int ret;
-
-	for_each_btree_key_max_norestart(trans, iter, BTREE_ID_dirents,
-			SPOS(inode_k.k->p.offset, 0, inode_k.k->p.snapshot),
-			POS(inode_k.k->p.offset, U64_MAX),
-			0, k, ret) {
-		if (k.k->type != KEY_TYPE_dirent)
-			continue;
-
-		struct bkey_s_c_dirent dirent = bkey_s_c_to_dirent(k);
-		struct qstr name = bch2_dirent_get_name(dirent);
-
-		new_size += dirent_occupied_size(&name);
-	}
-	bch2_trans_iter_exit(trans, &iter);
-
-	if (!ret && inode_u->bi_size != new_size) {
-		inode_u->bi_size = new_size;
-		*write_inode = true;
-	}
-
-	return ret;
-}
-
 static int check_inode(struct btree_trans *trans,
 		       struct btree_iter *iter,
 		       struct bkey_s_c k,
@@ -1335,16 +1306,6 @@ static int check_inode(struct btree_trans *trans,
 		u.bi_journal_seq = journal_cur_seq(&c->journal);
 		do_update = true;
 	}
-
-	if (S_ISDIR(u.bi_mode)) {
-		ret = check_directory_size(trans, &u, k, &do_update);
-
-		fsck_err_on(ret,
-			    trans, directory_size_mismatch,
-			    "directory inode %llu:%u with the mismatch directory size",
-			    u.bi_inum, k.k->p.snapshot);
-		ret = 0;
-	}
 do_update:
 	if (do_update) {
 		ret = __bch2_fsck_write_inode(trans, &u);
@@ -2017,10 +1978,31 @@ static int check_subdir_count_notnested(struct btree_trans *trans, struct inode_
 	return ret;
 }
 
-static int check_subdir_count(struct btree_trans *trans, struct inode_walker *w)
+static int check_dir_i_size_notnested(struct btree_trans *trans, struct inode_walker *w)
+{
+	struct bch_fs *c = trans->c;
+	int ret = 0;
+
+	darray_for_each(w->inodes, i)
+		if (fsck_err_on(i->inode.bi_size != i->i_size,
+				trans, inode_dir_wrong_nlink,
+				"directory %llu:%u with wrong i_nlink: got %u, should be %llu",
+				w->last_pos.inode, i->snapshot, i->inode.bi_nlink, i->count)) {
+			i->inode.bi_size = i->i_size;
+			ret = bch2_fsck_write_inode(trans, &i->inode);
+			if (ret)
+				break;
+		}
+fsck_err:
+	bch_err_fn(c, ret);
+	return ret;
+}
+
+static int check_subdir_dirents_count(struct btree_trans *trans, struct inode_walker *w)
 {
 	u32 restart_count = trans->restart_count;
 	return check_subdir_count_notnested(trans, w) ?:
+		check_dir_i_size_notnested(trans, w) ?:
 		trans_was_restarted(trans, restart_count);
 }
 
@@ -2367,7 +2349,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 		goto out;
 
 	if (dir->last_pos.inode != k.k->p.inode && dir->have_inodes) {
-		ret = check_subdir_count(trans, dir);
+		ret = check_subdir_dirents_count(trans, dir);
 		if (ret)
 			goto err;
 	}
@@ -2457,9 +2439,11 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 	if (ret)
 		goto err;
 
-	if (d.v->d_type == DT_DIR)
-		for_each_visible_inode(c, s, dir, d.k->p.snapshot, i)
+	for_each_visible_inode(c, s, dir, d.k->p.snapshot, i) {
+		if (d.v->d_type == DT_DIR)
 			i->count++;
+		i->i_size += bkey_bytes(d.k);
+	}
 out:
 err:
 fsck_err:
-- 
2.47.2

