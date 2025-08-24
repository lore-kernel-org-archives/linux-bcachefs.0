Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C3528980A
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039094; cv=none; b=BsJGJhlr+8ULDDB8fbzWVmsDg/YYGmPEI+IgIMSf1kHcmd3JWZXKGNmw9DF7aPb+CHrSI1nFcn9b1pPE0sooxvuEMYC3t2CGVwuSJZY86pPPtPdEwNnlaLsu8RuJg5ikhhDViro7OhGNXEq+8UdVlRRNqQaU7iC8pRJwiknVOro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039094; c=relaxed/simple;
	bh=ldfofiVx2hGx8EXcxiC2OytmsT757ge+pgcI6OzbVYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6X8m5sFZU8WnQ7i/hMrSCRVup4hxhkjhngyNnirRK1Wd6XBPg841ZMd3t75TI0vzrRFXhhhQuxqsRwR9x6bAzCYofm/zLqyeZCz/I0YG9eR365qvrfq1mMmuhC7sjGQvhJcQCVYSkCejK5Hnqt89iI3oJqDZGoX+ERl6yQdiI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Itk01zWa; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Itk01zWa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039090;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vZ9S85Nb0R9o3C+J8lDcoSfFXemOOQkSHgSggfSCwzg=;
	b=Itk01zWar4ygHYizllVcm/kyhZ5Z8qoj3/U17I/15THDfnhb587FOOvs/syBkSw6jBmAYG
	n4C1iNoTG3xAU4DKe6dKjvLyu7z2HF0vamfCd4c2UXd7SrcSNQvuS3kOuQyrjaZC7sZaOS
	+0TtwXhRshYr2NuUL1CdRJ5jgC5wLyk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 05/21] bcachefs: Plumb bch_inode_opts.change_cookie
Date: Sun, 24 Aug 2025 08:37:42 -0400
Message-ID: <20250824123800.1617669-6-kent.overstreet@linux.dev>
In-Reply-To: <20250824123800.1617669-1-kent.overstreet@linux.dev>
References: <20250824123800.1617669-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  3 ++-
 fs/bcachefs/inode.c       |  2 +-
 fs/bcachefs/io_misc.c     |  4 ++--
 fs/bcachefs/io_write.c    | 11 +++++++----
 fs/bcachefs/io_write.h    |  2 +-
 fs/bcachefs/opts.c        |  2 +-
 fs/bcachefs/opts.h        |  2 +-
 fs/bcachefs/rebalance.c   |  4 ++--
 fs/bcachefs/rebalance.h   |  2 +-
 fs/bcachefs/reflink.c     |  2 +-
 10 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 43d318ff488e..b62d890003ec 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -438,7 +438,8 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, insert->k.p) ?:
 			bch2_inum_snapshot_opts_get(trans, k.k->p.inode, k.k->p.snapshot, &opts) ?:
-			bch2_bkey_set_needs_rebalance(c, &opts, insert) ?:
+			bch2_bkey_set_needs_rebalance(c, &opts, insert,
+						      m->op.opts.change_cookie) ?:
 			bch2_trans_update(trans, &iter, insert,
 				BTREE_UPDATE_internal_snapshot_node);
 		if (ret)
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index d1ec33edcc0b..c222fb8a7d07 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1239,7 +1239,7 @@ void bch2_inode_opts_get_inode(struct bch_fs *c,
 	BCH_INODE_OPTS()
 #undef x
 
-	ret->opt_change_cookie = atomic_read(&c->opt_change_cookie);
+	ret->change_cookie = atomic_read(&c->opt_change_cookie);
 
 	bch2_io_opts_fixups(ret);
 }
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 6d204b980f76..04eb5ecd102b 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -109,7 +109,7 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 	}
 
 	ret = bch2_extent_update(trans, inum, iter, new.k, &disk_res,
-				 0, i_sectors_delta, true);
+				 0, i_sectors_delta, true, 0);
 err:
 	if (!ret && sectors_allocated)
 		bch2_increment_clock(c, sectors_allocated, WRITE);
@@ -211,7 +211,7 @@ int bch2_fpunch_at(struct btree_trans *trans, struct btree_iter *iter,
 		bch2_cut_back(end_pos, &delete);
 
 		ret = bch2_extent_update(trans, inum, iter, &delete,
-				&disk_res, 0, i_sectors_delta, false);
+				&disk_res, 0, i_sectors_delta, false, 0);
 		bch2_disk_reservation_put(c, &disk_res);
 	}
 
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index a0cb5d2dd0f8..0122d8b3292a 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -310,7 +310,8 @@ int bch2_extent_update(struct btree_trans *trans,
 		       struct disk_reservation *disk_res,
 		       u64 new_i_size,
 		       s64 *i_sectors_delta_total,
-		       bool check_enospc)
+		       bool check_enospc,
+		       u32 change_cookie)
 {
 	struct bch_fs *c = trans->c;
 	struct bpos next_pos;
@@ -364,7 +365,8 @@ int bch2_extent_update(struct btree_trans *trans,
 						  min(k->k.p.offset << 9, new_i_size),
 						  i_sectors_delta, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
-		 bch2_bkey_set_needs_rebalance(c, &opts, k)) ?:
+		 bch2_bkey_set_needs_rebalance(c, &opts, k,
+					       change_cookie)) ?:
 		bch2_trans_update(trans, iter, k, 0) ?:
 		bch2_trans_commit(trans, disk_res, NULL,
 				BCH_TRANS_COMMIT_no_check_rw|
@@ -415,7 +417,8 @@ static int bch2_write_index_default(struct bch_write_op *op)
 		ret =   bch2_extent_update(trans, inum, &iter, sk.k,
 					&op->res,
 					op->new_i_size, &op->i_sectors_delta,
-					op->flags & BCH_WRITE_check_enospc);
+					op->flags & BCH_WRITE_check_enospc,
+					op->opts.change_cookie);
 
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			continue;
@@ -1267,7 +1270,7 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 	return  bch2_extent_update_i_size_sectors(trans, iter,
 					min(new->k.p.offset << 9, new_i_size), 0, &inode) ?:
 		(bch2_inode_opts_get_inode(c, &inode, &opts),
-		 bch2_bkey_set_needs_rebalance(c, &opts, new)) ?:
+		 bch2_bkey_set_needs_rebalance(c, &opts, new, op->opts.change_cookie)) ?:
 		bch2_trans_update(trans, iter, new,
 				  BTREE_UPDATE_internal_snapshot_node);
 }
diff --git a/fs/bcachefs/io_write.h b/fs/bcachefs/io_write.h
index 6c05ba6e15d6..692529bf401d 100644
--- a/fs/bcachefs/io_write.h
+++ b/fs/bcachefs/io_write.h
@@ -28,7 +28,7 @@ int bch2_sum_sector_overwrites(struct btree_trans *, struct btree_iter *,
 			       struct bkey_i *, bool *, s64 *, s64 *);
 int bch2_extent_update(struct btree_trans *, subvol_inum,
 		       struct btree_iter *, struct bkey_i *,
-		       struct disk_reservation *, u64, s64 *, bool);
+		       struct disk_reservation *, u64, s64 *, bool, u32);
 
 static inline void bch2_write_op_init(struct bch_write_op *op, struct bch_fs *c,
 				      struct bch_inode_opts opts)
diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
index 16d210cbc849..9f5684ec056a 100644
--- a/fs/bcachefs/opts.c
+++ b/fs/bcachefs/opts.c
@@ -812,7 +812,7 @@ void bch2_inode_opts_get(struct bch_fs *c, struct bch_inode_opts *ret)
 	BCH_INODE_OPTS()
 #undef x
 
-	ret->opt_change_cookie = atomic_read(&c->opt_change_cookie);
+	ret->change_cookie = atomic_read(&c->opt_change_cookie);
 
 	bch2_io_opts_fixups(ret);
 }
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 2425ba247201..f0f3483c1aab 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -679,7 +679,7 @@ struct bch_inode_opts {
 	BCH_INODE_OPTS()
 #undef x
 
-	u32 opt_change_cookie;
+	u32 change_cookie;
 };
 
 static inline void bch2_io_opts_fixups(struct bch_inode_opts *opts)
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 9590c57798c6..d8e214e6f671 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -162,7 +162,7 @@ static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_inode_
 }
 
 int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
-				  struct bkey_i *_k)
+				  struct bkey_i *_k, u32 change_cookie)
 {
 	if (!bkey_extent_is_direct_data(&_k->k))
 		return 0;
@@ -218,7 +218,7 @@ int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n) ?:
+	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
 		bch_err_throw(trans->c, transaction_restart_nested);
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index 9f2839ddb60e..62b7f0b3aec7 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -27,7 +27,7 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 };
 
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
-int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *, struct bkey_i *);
+int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_inode_opts *, struct bkey_i *, u32);
 int bch2_get_update_rebalance_opts(struct btree_trans *,
 				   struct bch_inode_opts *,
 				   struct btree_iter *,
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 5e62eddf30ba..d54468fdcb18 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -707,7 +707,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 		ret = bch2_extent_update(trans, dst_inum, &dst_iter,
 					 new_dst.k, &disk_res,
 					 new_i_size, i_sectors_delta,
-					 true);
+					 true, 0);
 		bch2_disk_reservation_put(c, &disk_res);
 	}
 	bch2_trans_iter_exit(&dst_iter);
-- 
2.50.1

