Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049D4158D63
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Oct 2024 18:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728153013; cv=none; b=f0gr35liNkG1YbKxYLJrV3pJ4DfFSQFbi2tmssnkUv7KLiD14vJ8uHQpkALQf7g3sCkhWnBjCJqbWUKuTnADIKldl12FokicjFfsS0O59M0ud2U9TtHSdt9lgcyA9Vy3bzOAre2FhWBfsg6OVid/llaADqJyftX1ui87JATucLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728153013; c=relaxed/simple;
	bh=+M/m4V+N+aIvRnX2mZbIOaKFkRKHIu781ld7F3TXMuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hs/OirL2qCpPO2jUc2i+UEFW5+MAyOM3fLz3+xm1QUvmepNowkSmDg2/5ZciQ/XHc3Bo+R/VsLkOvGiPwecMyKKrlOYIuvS9m1M/E04gV8OcPIMU5X1eXM4UE+9CCl3ty6Os63gZdgqI0SIi3r6eEO3z3I8eHgpHq9BIPKKeIjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nSIbXQo5; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nSIbXQo5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728153009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ELWMaLftOjfsusUhJQiO+m/VxjLqgb471WQdCgBaqkI=;
	b=nSIbXQo5Ko7owjcdvvDj9qxfETbc05qxkrwZDWb4x1HppHbNGWcM+h+bZ9SnMkV+YXuEcm
	HOKrcNMVW0IPK4fSNDhbmTHSiU0aVGiQz90qJjy7ptAkqAj6bX1iv57TkjuLOSuXHBd7SF
	eW41BM85HDir9bHqsS14BZpwvgbTVVs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/5] bcachefs: Delete vestigal check_inode() checks
Date: Sat,  5 Oct 2024 14:29:51 -0400
Message-ID: <20241005182955.1588763-5-kent.overstreet@linux.dev>
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

BCH_INODE_i_size_dirty dates from before we had logged operations for
truncate (as well as finsert) - it hasn't been needed since before
bcachefs was mainlined.

BCH_INODE_i_sectors_dirty hasn't been needed since we started always
updating i_sectors transactionally - it's been unused for even longer.

BCH_INODE_backptr_untrusted also hasn't been used since prior to
mainlining; when unlinking a hardling, we zero out the backpointer
fields if they're for the dirent being removed.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 80 +++-------------------------------------------
 1 file changed, 5 insertions(+), 75 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 92f9cabb6eae..171e3e47db5c 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1085,7 +1085,6 @@ static int check_inode_dirent_inode(struct btree_trans *trans,
 		 */
 		inode->bi_dir = 0;
 		inode->bi_dir_offset = 0;
-		inode->bi_flags &= ~BCH_INODE_backptr_untrusted;
 		*write_inode = true;
 	}
 
@@ -1117,8 +1116,7 @@ static int check_inode(struct btree_trans *trans,
 		       struct btree_iter *iter,
 		       struct bkey_s_c k,
 		       struct bch_inode_unpacked *prev,
-		       struct snapshots_seen *s,
-		       bool full)
+		       struct snapshots_seen *s)
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
@@ -1141,12 +1139,6 @@ static int check_inode(struct btree_trans *trans,
 
 	BUG_ON(bch2_inode_unpack(k, &u));
 
-	if (!full &&
-	    !(u.bi_flags & (BCH_INODE_i_size_dirty|
-			    BCH_INODE_i_sectors_dirty|
-			    BCH_INODE_unlinked)))
-		return 0;
-
 	if (prev->bi_inum != u.bi_inum)
 		*prev = u;
 
@@ -1192,7 +1184,7 @@ static int check_inode(struct btree_trans *trans,
 		ret = 0;
 	}
 
-	if ((u.bi_flags & (BCH_INODE_i_size_dirty|BCH_INODE_unlinked)) &&
+	if ((u.bi_flags & BCH_INODE_unlinked) &&
 	    bch2_key_has_snapshot_overwrites(trans, BTREE_ID_inodes, k.k->p)) {
 		struct bpos new_min_pos;
 
@@ -1200,7 +1192,7 @@ static int check_inode(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		u.bi_flags &= ~BCH_INODE_i_size_dirty|BCH_INODE_unlinked;
+		u.bi_flags &= ~BCH_INODE_unlinked;
 
 		ret = __bch2_fsck_write_inode(trans, &u);
 
@@ -1249,66 +1241,6 @@ static int check_inode(struct btree_trans *trans,
 		}
 	}
 
-	/* i_size_dirty is vestigal, since we now have logged ops for truncate * */
-	if (u.bi_flags & BCH_INODE_i_size_dirty &&
-	    (!test_bit(BCH_FS_clean_recovery, &c->flags) ||
-	     fsck_err(trans, inode_i_size_dirty_but_clean,
-		      "filesystem marked clean, but inode %llu has i_size dirty",
-		      u.bi_inum))) {
-		bch_verbose(c, "truncating inode %llu", u.bi_inum);
-
-		/*
-		 * XXX: need to truncate partial blocks too here - or ideally
-		 * just switch units to bytes and that issue goes away
-		 */
-		ret = bch2_btree_delete_range_trans(trans, BTREE_ID_extents,
-				SPOS(u.bi_inum, round_up(u.bi_size, block_bytes(c)) >> 9,
-				     iter->pos.snapshot),
-				POS(u.bi_inum, U64_MAX),
-				0, NULL);
-		bch_err_msg(c, ret, "in fsck truncating inode");
-		if (ret)
-			return ret;
-
-		/*
-		 * We truncated without our normal sector accounting hook, just
-		 * make sure we recalculate it:
-		 */
-		u.bi_flags |= BCH_INODE_i_sectors_dirty;
-
-		u.bi_flags &= ~BCH_INODE_i_size_dirty;
-		do_update = true;
-	}
-
-	/* i_sectors_dirty is vestigal, i_sectors is always updated transactionally */
-	if (u.bi_flags & BCH_INODE_i_sectors_dirty &&
-	    (!test_bit(BCH_FS_clean_recovery, &c->flags) ||
-	     fsck_err(trans, inode_i_sectors_dirty_but_clean,
-		      "filesystem marked clean, but inode %llu has i_sectors dirty",
-		      u.bi_inum))) {
-		s64 sectors;
-
-		bch_verbose(c, "recounting sectors for inode %llu",
-			    u.bi_inum);
-
-		sectors = bch2_count_inode_sectors(trans, u.bi_inum, iter->pos.snapshot);
-		if (sectors < 0) {
-			bch_err_msg(c, sectors, "in fsck recounting inode sectors");
-			return sectors;
-		}
-
-		u.bi_sectors = sectors;
-		u.bi_flags &= ~BCH_INODE_i_sectors_dirty;
-		do_update = true;
-	}
-
-	if (u.bi_flags & BCH_INODE_backptr_untrusted) {
-		u.bi_dir = 0;
-		u.bi_dir_offset = 0;
-		u.bi_flags &= ~BCH_INODE_backptr_untrusted;
-		do_update = true;
-	}
-
 	if (fsck_err_on(u.bi_parent_subvol &&
 			(u.bi_subvol == 0 ||
 			 u.bi_subvol == BCACHEFS_ROOT_SUBVOL),
@@ -1365,7 +1297,6 @@ static int check_inode(struct btree_trans *trans,
 
 int bch2_check_inodes(struct bch_fs *c)
 {
-	bool full = c->opts.fsck;
 	struct bch_inode_unpacked prev = { 0 };
 	struct snapshots_seen s;
 
@@ -1376,7 +1307,7 @@ int bch2_check_inodes(struct bch_fs *c)
 				POS_MIN,
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
 				NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-			check_inode(trans, &iter, k, &prev, &s, full)));
+			check_inode(trans, &iter, k, &prev, &s)));
 
 	snapshots_seen_exit(&s);
 	bch_err_fn(c, ret);
@@ -1876,8 +1807,7 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 			    !key_visible_in_snapshot(c, s, i->snapshot, k.k->p.snapshot))
 				continue;
 
-			if (fsck_err_on(!(i->inode.bi_flags & BCH_INODE_i_size_dirty) &&
-					k.k->p.offset > round_up(i->inode.bi_size, block_bytes(c)) >> 9 &&
+			if (fsck_err_on(k.k->p.offset > round_up(i->inode.bi_size, block_bytes(c)) >> 9 &&
 					!bkey_extent_is_reservation(k),
 					trans, extent_past_end_of_inode,
 					"extent type past end of inode %llu:%u, i_size %llu\n  %s",
-- 
2.45.2

