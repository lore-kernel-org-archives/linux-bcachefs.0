Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40021CA0EC3
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 01:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbjILBM7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Sep 2023 21:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233243AbjILBMp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Sep 2023 21:12:45 -0400
Received: from out-210.mta0.migadu.com (out-210.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4B61B3136
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Sep 2023 18:06:45 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694478252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RK2a1LEfwNN2FlOyVJryiuXHvieIUqUHGenUnyEThXk=;
        b=QvAb1VIXV/ynU2MbMxSbTxt+187gIQjVC5nDyCQOX5/faV2OV6BXDOf6+324gQPvDssV6N
        QH/3X2UbfGuKazsxR8RujSVrYWEJ32a5nv5wneI9xZlOLU+A8gTqy9+hJJgmqIHCGSAn8w
        JviBqzZCWkUxARMHelB79tKYEDo9wvU=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Log finsert/fcollapse operations
Date:   Mon, 11 Sep 2023 20:23:56 -0400
Message-Id: <20230912002356.566674-4-kent.overstreet@linux.dev>
In-Reply-To: <20230912002356.566674-1-kent.overstreet@linux.dev>
References: <20230912002356.566674-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Now that we have the logged operations btree, we can make
finsert/fcollapse atomic w.r.t. unclean shutdown as well.

This adds bch_logged_op_finsert to represent the state of an finsert or
fcollapse, which is a bit more complicated than truncate since we need
to track our position in the "shift extents" operation.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  23 +++-
 fs/bcachefs/io_misc.c         | 211 +++++++++++++++++++---------------
 fs/bcachefs/io_misc.h         |  10 ++
 fs/bcachefs/logged_ops.h      |   3 +-
 4 files changed, 152 insertions(+), 95 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 3c9e788f1c9d..c434202f351a 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -371,7 +371,8 @@ static inline void bkey_init(struct bkey *k)
 	x(inode_v3,		29)			\
 	x(bucket_gens,		30)			\
 	x(snapshot_tree,	31)			\
-	x(logged_op_truncate,	32)
+	x(logged_op_truncate,	32)			\
+	x(logged_op_finsert,	33)
 
 enum bch_bkey_type {
 #define x(name, nr) KEY_TYPE_##name	= nr,
@@ -1194,6 +1195,23 @@ struct bch_logged_op_truncate {
 	__le64			new_i_size;
 };
 
+enum logged_op_finsert_state {
+	LOGGED_OP_FINSERT_start,
+	LOGGED_OP_FINSERT_shift_extents,
+	LOGGED_OP_FINSERT_finish,
+};
+
+struct bch_logged_op_finsert {
+	struct bch_val		v;
+	__u8			state;
+	__u8			pad[3];
+	__le32			subvol;
+	__le64			inum;
+	__le64			dst_offset;
+	__le64			src_offset;
+	__le64			pos;
+};
+
 /* Optional/variable size superblock sections: */
 
 struct bch_sb_field {
@@ -2262,7 +2280,8 @@ enum btree_id_flags {
 	x(deleted_inodes,	16,	BTREE_ID_SNAPSHOTS,			\
 	  BIT_ULL(KEY_TYPE_set))						\
 	x(logged_ops,		17,	0,					\
-	  BIT_ULL(KEY_TYPE_logged_op_truncate))
+	  BIT_ULL(KEY_TYPE_logged_op_truncate)|					\
+	  BIT_ULL(KEY_TYPE_logged_op_finsert))
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 327b3dd642de..b1be70e15c60 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -293,6 +293,18 @@ int bch2_truncate(struct bch_fs *c, subvol_inum inum, u64 new_i_size, u64 *i_sec
 		__bch2_resume_logged_op_truncate(&trans, &op.k_i, i_sectors_delta));
 }
 
+/* finsert/fcollapse: */
+
+void bch2_logged_op_finsert_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
+{
+	struct bkey_s_c_logged_op_finsert op = bkey_s_c_to_logged_op_finsert(k);
+
+	prt_printf(out, "subvol=%u",		le32_to_cpu(op.v->subvol));
+	prt_printf(out, " inum=%llu",		le64_to_cpu(op.v->inum));
+	prt_printf(out, " dst_offset=%lli",	le64_to_cpu(op.v->dst_offset));
+	prt_printf(out, " src_offset=%llu",	le64_to_cpu(op.v->src_offset));
+}
+
 static int adjust_i_size(struct btree_trans *trans, subvol_inum inum, u64 offset, s64 len)
 {
 	struct btree_iter iter;
@@ -327,145 +339,160 @@ static int adjust_i_size(struct btree_trans *trans, subvol_inum inum, u64 offset
 	return ret;
 }
 
-int bch2_fcollapse_finsert(struct bch_fs *c, subvol_inum inum,
-			   u64 offset, u64 len, bool insert,
-			   s64 *i_sectors_delta)
+static int __bch2_resume_logged_op_finsert(struct btree_trans *trans,
+					   struct bkey_i *op_k,
+					   u64 *i_sectors_delta)
 {
-	struct bkey_buf copy;
-	struct btree_trans trans;
-	struct btree_iter src = { NULL }, dst = { NULL }, del = { NULL };
-	s64 shift = insert ? len : -len;
+	struct bch_fs *c = trans->c;
+	struct btree_iter iter;
+	struct bkey_i_logged_op_finsert *op = bkey_i_to_logged_op_finsert(op_k);
+	subvol_inum inum = { le32_to_cpu(op->v.subvol), le64_to_cpu(op->v.inum) };
+	u64 dst_offset = le64_to_cpu(op->v.dst_offset);
+	u64 src_offset = le64_to_cpu(op->v.src_offset);
+	s64 shift = dst_offset - src_offset;
+	u64 len = abs(shift);
+	u64 pos = le64_to_cpu(op->v.pos);
+	bool insert = shift > 0;
 	int ret = 0;
 
-	bch2_bkey_buf_init(&copy);
-	bch2_trans_init(&trans, c, 0, 1024);
-
-	bch2_trans_iter_init(&trans, &src, BTREE_ID_extents,
-			     POS(inum.inum, U64_MAX),
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_extents,
+			     POS(inum.inum, 0),
 			     BTREE_ITER_INTENT);
-	bch2_trans_copy_iter(&dst, &src);
-	bch2_trans_copy_iter(&del, &src);
+
+	switch (op->v.state) {
+case LOGGED_OP_FINSERT_start:
+	op->v.state = LOGGED_OP_FINSERT_shift_extents;
 
 	if (insert) {
-		ret = commit_do(&trans, NULL, NULL, BTREE_INSERT_NOFAIL,
-				adjust_i_size(&trans, inum, offset, len));
+		ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+				adjust_i_size(trans, inum, src_offset, len) ?:
+				bch2_logged_op_update(trans, &op->k_i));
 		if (ret)
 			goto err;
 	} else {
-		bch2_btree_iter_set_pos(&src, POS(inum.inum, offset));
+		bch2_btree_iter_set_pos(&iter, POS(inum.inum, src_offset));
 
-		ret = bch2_fpunch_at(&trans, &src, inum, offset + len, i_sectors_delta);
+		ret = bch2_fpunch_at(trans, &iter, inum, src_offset + len, i_sectors_delta);
 		if (ret && !bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			goto err;
 
-		bch2_btree_iter_set_pos(&src, POS(inum.inum, offset + len));
+		ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+				bch2_logged_op_update(trans, &op->k_i));
 	}
 
-	while (ret == 0 || bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
+	fallthrough;
+case LOGGED_OP_FINSERT_shift_extents:
+	while (1) {
 		struct disk_reservation disk_res =
 			bch2_disk_reservation_init(c, 0);
-		struct bkey_i delete;
+		struct bkey_i delete, *copy;
 		struct bkey_s_c k;
-		struct bpos next_pos;
-		struct bpos move_pos = POS(inum.inum, offset);
-		struct bpos atomic_end;
-		unsigned trigger_flags = 0;
+		struct bpos src_pos = POS(inum.inum, src_offset);
 		u32 snapshot;
 
-		bch2_trans_begin(&trans);
+		bch2_trans_begin(trans);
 
-		ret = bch2_subvolume_get_snapshot(&trans, inum.subvol, &snapshot);
+		ret = bch2_subvolume_get_snapshot(trans, inum.subvol, &snapshot);
 		if (ret)
-			continue;
+			goto btree_err;
 
-		bch2_btree_iter_set_snapshot(&src, snapshot);
-		bch2_btree_iter_set_snapshot(&dst, snapshot);
-		bch2_btree_iter_set_snapshot(&del, snapshot);
-
-		bch2_trans_begin(&trans);
+		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_pos(&iter, SPOS(inum.inum, pos, snapshot));
 
 		k = insert
-			? bch2_btree_iter_peek_prev(&src)
-			: bch2_btree_iter_peek_upto(&src, POS(inum.inum, U64_MAX));
+			? bch2_btree_iter_peek_prev(&iter)
+			: bch2_btree_iter_peek_upto(&iter, POS(inum.inum, U64_MAX));
 		if ((ret = bkey_err(k)))
-			continue;
+			goto btree_err;
 
-		if (!k.k || k.k->p.inode != inum.inum)
+		if (!k.k ||
+		    k.k->p.inode != inum.inum ||
+		    bkey_le(k.k->p, POS(inum.inum, src_offset)))
 			break;
 
-		if (insert &&
-		    bkey_le(k.k->p, POS(inum.inum, offset)))
-			break;
-reassemble:
-		bch2_bkey_buf_reassemble(&copy, c, k);
+		copy = bch2_bkey_make_mut_noupdate(trans, k);
+		if ((ret = PTR_ERR_OR_ZERO(copy)))
+			goto btree_err;
 
 		if (insert &&
-		    bkey_lt(bkey_start_pos(k.k), move_pos))
-			bch2_cut_front(move_pos, copy.k);
-
-		copy.k->k.p.offset += shift;
-		bch2_btree_iter_set_pos(&dst, bkey_start_pos(&copy.k->k));
+		    bkey_lt(bkey_start_pos(k.k), src_pos)) {
+			bch2_cut_front(src_pos, copy);
 
-		ret = bch2_extent_atomic_end(&trans, &dst, copy.k, &atomic_end);
-		if (ret)
-			continue;
-
-		if (!bkey_eq(atomic_end, copy.k->k.p)) {
-			if (insert) {
-				move_pos = atomic_end;
-				move_pos.offset -= shift;
-				goto reassemble;
-			} else {
-				bch2_cut_back(atomic_end, copy.k);
-			}
+			/* Splitting compressed extent? */
+			bch2_disk_reservation_add(c, &disk_res,
+					copy->k.size *
+					bch2_bkey_nr_ptrs_allocated(bkey_i_to_s_c(copy)),
+					BCH_DISK_RESERVATION_NOFAIL);
 		}
 
 		bkey_init(&delete.k);
-		delete.k.p = copy.k->k.p;
-		delete.k.size = copy.k->k.size;
-		delete.k.p.offset -= shift;
-		bch2_btree_iter_set_pos(&del, bkey_start_pos(&delete.k));
+		delete.k.p = copy->k.p;
+		delete.k.p.snapshot = snapshot;
+		delete.k.size = copy->k.size;
 
-		next_pos = insert ? bkey_start_pos(&delete.k) : delete.k.p;
+		copy->k.p.offset += shift;
+		copy->k.p.snapshot = snapshot;
 
-		if (copy.k->k.size != k.k->size) {
-			/* We might end up splitting compressed extents: */
-			unsigned nr_ptrs =
-				bch2_bkey_nr_ptrs_allocated(bkey_i_to_s_c(copy.k));
+		op->v.pos = cpu_to_le64(insert ? bkey_start_offset(&delete.k) : delete.k.p.offset);
 
-			ret = bch2_disk_reservation_get(c, &disk_res,
-					copy.k->k.size, nr_ptrs,
-					BCH_DISK_RESERVATION_NOFAIL);
-			BUG_ON(ret);
-		}
-
-		ret =   bch2_btree_iter_traverse(&del) ?:
-			bch2_trans_update(&trans, &del, &delete, trigger_flags) ?:
-			bch2_trans_update(&trans, &dst, copy.k, trigger_flags) ?:
-			bch2_trans_commit(&trans, &disk_res, NULL,
-					  BTREE_INSERT_NOFAIL);
+		ret =   bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
+			bch2_btree_insert_trans(trans, BTREE_ID_extents, copy, 0) ?:
+			bch2_logged_op_update(trans, &op->k_i) ?:
+			bch2_trans_commit(trans, &disk_res, NULL, BTREE_INSERT_NOFAIL);
+btree_err:
 		bch2_disk_reservation_put(c, &disk_res);
 
-		if (!ret)
-			bch2_btree_iter_set_pos(&src, next_pos);
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			continue;
+		if (ret)
+			goto err;
+
+		pos = le64_to_cpu(op->v.pos);
 	}
 
-	if (ret && !bch2_err_matches(ret, BCH_ERR_transaction_restart))
-		goto err;
+	op->v.state = LOGGED_OP_FINSERT_finish;
 
 	if (!insert) {
-		ret = commit_do(&trans, NULL, NULL, BTREE_INSERT_NOFAIL,
-				adjust_i_size(&trans, inum, offset, -len));
+		ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+				adjust_i_size(trans, inum, src_offset, shift) ?:
+				bch2_logged_op_update(trans, &op->k_i));
 	} else {
 		/* We need an inode update to update bi_journal_seq for fsync: */
-		ret = commit_do(&trans, NULL, NULL, BTREE_INSERT_NOFAIL,
-				adjust_i_size(&trans, inum, 0, 0));
+		ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+				adjust_i_size(trans, inum, 0, 0) ?:
+				bch2_logged_op_update(trans, &op->k_i));
+	}
+
+	fallthrough;
+case LOGGED_OP_FINSERT_finish:
+	ret = ret;
 	}
 err:
-	bch2_trans_iter_exit(&trans, &del);
-	bch2_trans_iter_exit(&trans, &dst);
-	bch2_trans_iter_exit(&trans, &src);
-	bch2_trans_exit(&trans);
-	bch2_bkey_buf_exit(&copy, c);
+	bch2_logged_op_finish(trans, op_k);
+	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
+
+int bch2_resume_logged_op_finsert(struct btree_trans *trans, struct bkey_i *op_k)
+{
+	return __bch2_resume_logged_op_finsert(trans, op_k, NULL);
+}
+
+int bch2_fcollapse_finsert(struct bch_fs *c, subvol_inum inum,
+			   u64 offset, u64 len, bool insert,
+			   s64 *i_sectors_delta)
+{
+	struct bkey_i_logged_op_finsert op;
+	s64 shift = insert ? len : -len;
+
+	bkey_logged_op_finsert_init(&op.k_i);
+	op.v.subvol	= cpu_to_le32(inum.subvol);
+	op.v.inum	= cpu_to_le64(inum.inum);
+	op.v.dst_offset	= cpu_to_le64(offset + shift);
+	op.v.src_offset	= cpu_to_le64(offset);
+	op.v.pos	= cpu_to_le64(insert ? U64_MAX : offset);
+
+	return bch2_trans_run(c,
+		bch2_logged_op_start(&trans, &op.k_i) ?:
+		__bch2_resume_logged_op_finsert(&trans, &op.k_i, i_sectors_delta));
+}
diff --git a/fs/bcachefs/io_misc.h b/fs/bcachefs/io_misc.h
index 688d9048604e..36275c97b7b2 100644
--- a/fs/bcachefs/io_misc.h
+++ b/fs/bcachefs/io_misc.h
@@ -28,6 +28,16 @@ void bch2_logged_op_truncate_to_text(struct printbuf *, struct bch_fs *, struct
 int bch2_resume_logged_op_truncate(struct btree_trans *, struct bkey_i *);
 
 int bch2_truncate(struct bch_fs *, subvol_inum, u64, u64 *);
+
+void bch2_logged_op_finsert_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
+
+#define bch2_bkey_ops_logged_op_finsert ((struct bkey_ops) {	\
+	.val_to_text	= bch2_logged_op_finsert_to_text,	\
+	.min_val_size	= 24,					\
+})
+
+int bch2_resume_logged_op_finsert(struct btree_trans *, struct bkey_i *);
+
 int bch2_fcollapse_finsert(struct bch_fs *, subvol_inum, u64, u64, bool, s64 *);
 
 #endif /* _BCACHEFS_IO_MISC_H */
diff --git a/fs/bcachefs/logged_ops.h b/fs/bcachefs/logged_ops.h
index b2f2ebea54b6..4d1e786a27a8 100644
--- a/fs/bcachefs/logged_ops.h
+++ b/fs/bcachefs/logged_ops.h
@@ -5,7 +5,8 @@
 #include "bkey.h"
 
 #define BCH_LOGGED_OPS()			\
-	x(truncate)
+	x(truncate)				\
+	x(finsert)
 
 static inline int bch2_logged_op_update(struct btree_trans *trans, struct bkey_i *op)
 {
-- 
2.40.1

