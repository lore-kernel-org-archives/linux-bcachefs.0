Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4792D5A14
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039094; cv=none; b=lafVSYiyxtH0UCprIdv5Gq7ZW476QC0SaaBxshjrhJkd8ZS7YY0T1K/O2WeN4nKvrETYRayZe3MuSdTpA4suvuxVW5PWDC/uFtI9ojIHCBu16Au030IqZE+4e1lmWl1A6zkAGwgx2PENulFhhrIQny2vqI3jSraVtpuR9UujLeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039094; c=relaxed/simple;
	bh=akP87mUgB/TXCJ+Hh0IYT5EWdu5DAfHWybJuGXFXMPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9hW/hfmQn+AcYkkwDVpvUDEVGQbZZjgwRBKYTHgsSHvXwSrPnlbuNSGITH0luX1bBCKrooFO6F4heIH9sUtRpWQ5wjFg1nVQ1KrHdC2apUZFFj6mzQK9ZgzHBzzH16RefZRSa8Zwf1O7aS43NoT7DUJzty0gNCuk5USk7Txed8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WVpennUT; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WVpennUT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2sAMJK+CBqrTjduLiJ80Jfsc1pt0O5Lhz9iFFY8mKWc=;
	b=WVpennUTcApOvKPF+32Rto/BfR3tgJxxfn/morNoBLqrOXYnj6LcdzCsAeuJRQ4UxjGtin
	vVOvlJ8Z1Q0XeJus8O63/LrJMCrFZslITEFvvB2BaKzsTVoQyv6RP871ZOULlEa1w96DhE
	S2Ng8K+44V82bNk7dE6cKNCWd/eudwg=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 04/21] bcachefs: Transactional consistency for set_needs_rebalance
Date: Sun, 24 Aug 2025 08:37:41 -0400
Message-ID: <20250824123800.1617669-5-kent.overstreet@linux.dev>
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

We're going to be strictly enforcing that extents match the IO path
options, as defined by the filesystem/inode options: that means when we
call set_needs_rebalance(), we need to pass it the opts we got from the
inode in that same transaction.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c |  6 +++++-
 fs/bcachefs/inode.c       | 28 ++++++++++++++++++---------
 fs/bcachefs/inode.h       |  2 +-
 fs/bcachefs/io_misc.c     |  8 +-------
 fs/bcachefs/io_write.c    | 40 ++++++++++++++++++++++++++++-----------
 fs/bcachefs/reflink.c     | 16 +++++-----------
 6 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 968850da0d23..43d318ff488e 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -11,6 +11,7 @@
 #include "ec.h"
 #include "error.h"
 #include "extents.h"
+#include "inode.h"
 #include "io_write.h"
 #include "keylist.h"
 #include "move.h"
@@ -428,13 +429,16 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 			goto out;
 		}
 
+		struct bch_inode_opts opts;
+
 		ret =   bch2_trans_log_str(trans, bch2_data_update_type_strs[m->type]) ?:
 			bch2_trans_log_bkey(trans, m->btree_id, 0, m->k.k) ?:
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, bkey_start_pos(&insert->k)) ?:
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, insert->k.p) ?:
-			bch2_bkey_set_needs_rebalance(c, &op->opts, insert) ?:
+			bch2_inum_snapshot_opts_get(trans, k.k->p.inode, k.k->p.snapshot, &opts) ?:
+			bch2_bkey_set_needs_rebalance(c, &opts, insert) ?:
 			bch2_trans_update(trans, &iter, insert,
 				BTREE_UPDATE_internal_snapshot_node);
 		if (ret)
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index c1d673374e02..d1ec33edcc0b 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -369,9 +369,9 @@ int __bch2_inode_peek(struct btree_trans *trans,
 }
 
 int bch2_inode_find_by_inum_snapshot(struct btree_trans *trans,
-					    u64 inode_nr, u32 snapshot,
-					    struct bch_inode_unpacked *inode,
-					    unsigned flags)
+				     u64 inode_nr, u32 snapshot,
+				     struct bch_inode_unpacked *inode,
+				     unsigned flags)
 {
 	CLASS(btree_iter, iter)(trans, BTREE_ID_inodes, SPOS(0, inode_nr, snapshot), flags);
 	struct bkey_s_c k = bch2_btree_iter_peek_slot(&iter);
@@ -1244,15 +1244,25 @@ void bch2_inode_opts_get_inode(struct bch_fs *c,
 	bch2_io_opts_fixups(ret);
 }
 
-int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_inode_opts *opts)
+int bch2_inum_snapshot_opts_get(struct btree_trans *trans,
+				u64 inum, u32 snapshot,
+				struct bch_inode_opts *opts)
 {
-	struct bch_inode_unpacked inode;
-	int ret = lockrestart_do(trans, bch2_inode_find_by_inum_trans(trans, inum, &inode));
+	if (inum) {
+		struct bch_inode_unpacked inode;
+		int ret = bch2_inode_find_by_inum_snapshot(trans, inum, snapshot, &inode, 0);
+		if (ret)
+			return ret;
 
-	if (ret)
-		return ret;
+		bch2_inode_opts_get_inode(trans->c, &inode, opts);
+	} else {
+		/*
+		 * data_update_index_update may call us for reflink btree extent
+		 * updates, inum will be 0
+		 */
 
-	bch2_inode_opts_get_inode(trans->c, &inode, opts);
+		bch2_inode_opts_get(trans->c, opts);
+	}
 	return 0;
 }
 
diff --git a/fs/bcachefs/inode.h b/fs/bcachefs/inode.h
index 12e0a104c196..63b7088811fb 100644
--- a/fs/bcachefs/inode.h
+++ b/fs/bcachefs/inode.h
@@ -290,7 +290,7 @@ void bch2_inode_nlink_dec(struct btree_trans *, struct bch_inode_unpacked *);
 
 struct bch_opts bch2_inode_opts_to_opts(struct bch_inode_unpacked *);
 void bch2_inode_opts_get_inode(struct bch_fs *, struct bch_inode_unpacked *, struct bch_inode_opts *);
-int bch2_inum_opts_get(struct btree_trans *, subvol_inum, struct bch_inode_opts *);
+int bch2_inum_snapshot_opts_get(struct btree_trans *, u64, u32, struct bch_inode_opts *);
 int bch2_inode_set_casefold(struct btree_trans *, subvol_inum,
 			    struct bch_inode_unpacked *, unsigned);
 
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 5e03574059e0..6d204b980f76 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -373,7 +373,6 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	struct btree_iter iter;
 	struct bkey_i_logged_op_finsert *op = bkey_i_to_logged_op_finsert(op_k);
 	subvol_inum inum = { le32_to_cpu(op->v.subvol), le64_to_cpu(op->v.inum) };
-	struct bch_inode_opts opts;
 	u64 dst_offset = le64_to_cpu(op->v.dst_offset);
 	u64 src_offset = le64_to_cpu(op->v.src_offset);
 	s64 shift = dst_offset - src_offset;
@@ -384,10 +383,6 @@ static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
 	bool warn_errors = i_sectors_delta != NULL;
 	int ret = 0;
 
-	ret = bch2_inum_opts_get(trans, inum, &opts);
-	if (ret)
-		return ret;
-
 	/*
 	 * check for missing subvolume before fpunch, as in resume we don't want
 	 * it to be a fatal error
@@ -476,8 +471,7 @@ case LOGGED_OP_FINSERT_shift_extents:
 
 		op->v.pos = cpu_to_le64(insert ? bkey_start_offset(&delete.k) : delete.k.p.offset);
 
-		ret =   bch2_bkey_set_needs_rebalance(c, &opts, copy) ?:
-			bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
+		ret =   bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
 			bch2_btree_insert_trans(trans, BTREE_ID_extents, copy, 0) ?:
 			bch2_logged_op_update(trans, &op->k_i) ?:
 			bch2_trans_commit(trans, &disk_res, NULL, BCH_TRANS_COMMIT_no_enospc);
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 1d83dcc9731e..a0cb5d2dd0f8 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -205,7 +205,8 @@ int bch2_sum_sector_overwrites(struct btree_trans *trans,
 static inline int bch2_extent_update_i_size_sectors(struct btree_trans *trans,
 						    struct btree_iter *extent_iter,
 						    u64 new_i_size,
-						    s64 i_sectors_delta)
+						    s64 i_sectors_delta,
+						    struct bch_inode_unpacked *inode_u)
 {
 	/*
 	 * Crazy performance optimization:
@@ -227,7 +228,13 @@ static inline int bch2_extent_update_i_size_sectors(struct btree_trans *trans,
 				BTREE_ITER_intent|
 				BTREE_ITER_cached);
 	struct bkey_s_c k = bch2_btree_iter_peek_slot(&iter);
-	int ret = bkey_err(k);
+
+	/*
+	 * XXX: we currently need to unpack the inode on every write because we
+	 * need the current io_opts, for transactional consistency - inode_v4?
+	 */
+	int ret = bkey_err(k) ?:
+		  bch2_inode_unpack(k, inode_u);
 	if (unlikely(ret))
 		return ret;
 
@@ -305,6 +312,7 @@ int bch2_extent_update(struct btree_trans *trans,
 		       s64 *i_sectors_delta_total,
 		       bool check_enospc)
 {
+	struct bch_fs *c = trans->c;
 	struct bpos next_pos;
 	bool usage_increasing;
 	s64 i_sectors_delta = 0, disk_sectors_delta = 0;
@@ -335,7 +343,7 @@ int bch2_extent_update(struct btree_trans *trans,
 
 	if (disk_res &&
 	    disk_sectors_delta > (s64) disk_res->sectors) {
-		ret = bch2_disk_reservation_add(trans->c, disk_res,
+		ret = bch2_disk_reservation_add(c, disk_res,
 					disk_sectors_delta - disk_res->sectors,
 					!check_enospc || !usage_increasing
 					? BCH_DISK_RESERVATION_NOFAIL : 0);
@@ -349,9 +357,14 @@ int bch2_extent_update(struct btree_trans *trans,
 	 * aren't changing - for fsync to work properly; fsync relies on
 	 * inode->bi_journal_seq which is updated by the trigger code:
 	 */
+	struct bch_inode_unpacked inode;
+	struct bch_inode_opts opts;
+
 	ret =   bch2_extent_update_i_size_sectors(trans, iter,
 						  min(k->k.p.offset << 9, new_i_size),
-						  i_sectors_delta) ?:
+						  i_sectors_delta, &inode) ?:
+		(bch2_inode_opts_get_inode(c, &inode, &opts),
+		 bch2_bkey_set_needs_rebalance(c, &opts, k)) ?:
 		bch2_trans_update(trans, iter, k, 0) ?:
 		bch2_trans_commit(trans, disk_res, NULL,
 				BCH_TRANS_COMMIT_no_check_rw|
@@ -792,10 +805,6 @@ static void init_append_extent(struct bch_write_op *op,
 
 	bch2_alloc_sectors_append_ptrs_inlined(op->c, wp, &e->k_i, crc.compressed_size,
 				       op->flags & BCH_WRITE_cached);
-
-	if (!(op->flags & BCH_WRITE_move))
-		bch2_bkey_set_needs_rebalance(op->c, &op->opts, &e->k_i);
-
 	bch2_keylist_push(&op->insert_keys);
 }
 
@@ -1225,6 +1234,7 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 		return 0;
 	}
 
+	struct bch_fs *c = trans->c;
 	struct bkey_i *new = bch2_trans_kmalloc_nomemzero(trans,
 				bkey_bytes(k.k) + sizeof(struct bch_extent_rebalance));
 	int ret = PTR_ERR_OR_ZERO(new);
@@ -1239,8 +1249,6 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 	bkey_for_each_ptr(ptrs, ptr)
 		ptr->unwritten = 0;
 
-	bch2_bkey_set_needs_rebalance(op->c, &op->opts, new);
-
 	/*
 	 * Note that we're not calling bch2_subvol_get_snapshot() in this path -
 	 * that was done when we kicked off the write, and here it's important
@@ -1248,8 +1256,18 @@ static int bch2_nocow_write_convert_one_unwritten(struct btree_trans *trans,
 	 * since been created. The write is still outstanding, so we're ok
 	 * w.r.t. snapshot atomicity:
 	 */
+
+	/*
+	 * For transactional consistency, set_needs_rebalance() has to be called
+	 * with the io_opts from the btree in the same transaction:
+	 */
+	struct bch_inode_unpacked inode;
+	struct bch_inode_opts opts;
+
 	return  bch2_extent_update_i_size_sectors(trans, iter,
-					min(new->k.p.offset << 9, new_i_size), 0) ?:
+					min(new->k.p.offset << 9, new_i_size), 0, &inode) ?:
+		(bch2_inode_opts_get_inode(c, &inode, &opts),
+		 bch2_bkey_set_needs_rebalance(c, &opts, new)) ?:
 		bch2_trans_update(trans, iter, new,
 				  BTREE_UPDATE_internal_snapshot_node);
 }
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 55ad8ab7a148..5e62eddf30ba 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -589,7 +589,6 @@ s64 bch2_remap_range(struct bch_fs *c,
 	struct bpos dst_start = POS(dst_inum.inum, dst_offset);
 	struct bpos src_start = POS(src_inum.inum, src_offset);
 	struct bpos dst_end = dst_start, src_end = src_start;
-	struct bch_inode_opts opts;
 	struct bpos src_want;
 	u64 dst_done = 0;
 	u32 dst_snapshot, src_snapshot;
@@ -609,10 +608,6 @@ s64 bch2_remap_range(struct bch_fs *c,
 	bch2_bkey_buf_init(&new_src);
 	CLASS(btree_trans, trans)(c);
 
-	ret = bch2_inum_opts_get(trans, src_inum, &opts);
-	if (ret)
-		goto err;
-
 	bch2_trans_iter_init(trans, &src_iter, BTREE_ID_extents, src_start,
 			     BTREE_ITER_intent);
 	bch2_trans_iter_init(trans, &dst_iter, BTREE_ID_extents, dst_start,
@@ -709,11 +704,10 @@ s64 bch2_remap_range(struct bch_fs *c,
 				min(src_k.k->p.offset - src_want.offset,
 				    dst_end.offset - dst_iter.pos.offset));
 
-		ret =   bch2_bkey_set_needs_rebalance(c, &opts, new_dst.k) ?:
-			bch2_extent_update(trans, dst_inum, &dst_iter,
-					new_dst.k, &disk_res,
-					new_i_size, i_sectors_delta,
-					true);
+		ret = bch2_extent_update(trans, dst_inum, &dst_iter,
+					 new_dst.k, &disk_res,
+					 new_i_size, i_sectors_delta,
+					 true);
 		bch2_disk_reservation_put(c, &disk_res);
 	}
 	bch2_trans_iter_exit(&dst_iter);
@@ -744,7 +738,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 
 		bch2_trans_iter_exit(&inode_iter);
 	} while (bch2_err_matches(ret2, BCH_ERR_transaction_restart));
-err:
+
 	bch2_bkey_buf_exit(&new_src, c);
 	bch2_bkey_buf_exit(&new_dst, c);
 
-- 
2.50.1

