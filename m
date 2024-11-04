Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA3C16190C
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Nov 2024 07:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730704326; cv=none; b=h+8HuO8xASGLEezWfenG4iL7y4OjiF9SXhYxjbdjF4Mmuf3HIfgYCKZLyv1BayW18lSpyPyBI88uKf2SmaJCdnvX3j4vOMtz0nmKx5bL/HDHYHuhsGvqgkyJbxFdTTvEij/47jNPfVctZQaUGl06hb537Vf+v1PpN/xrfsrRIXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730704326; c=relaxed/simple;
	bh=4Om/3E+bkKP2tNsxh/9/aauWlnGnkXTzQc3+r7nuQ0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UftFAhqcprz7iQac+/E8cUpTKYUqTNjtnJiZYA7nq4cCa8/6GKtHgRI21VhJXoaOKn1trkG/9UB/19gpYQcsSKW3dxNdR24k5nGCSCfwm3q/sxFO777I6vrkyYUE/ef1AhZ3BPO140w6u9RjJbIHnDIZtqsxCJwy1cOf1HaNnQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n21kKwAV; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n21kKwAV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730704318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=XQrRih5r+lIgmjnblU3WwNlPyDE2W1vNRwVL5IP73oM=;
	b=n21kKwAVZh4vE8QYqkdXTOaAKslxTIIhj1T5V14IJTHP3y179JmSiFlrgMKEzr/1EJJ8dh
	W4iltN+/zY6fCULK8EOlyNc5yE6Aanq3sK5W8z6P10xxBruj9NT8DlFrQ7wYGS9KQpIreN
	oTP2LXTKcbGMOFn3LaHpHVko6I/bRmE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: Reserve 8 bits in bch_reflink_p
Date: Mon,  4 Nov 2024 02:11:44 -0500
Message-ID: <20241104071146.11926-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Better repair for reflink pointers, as well as propagating new inode
options to indirect extents, are going to require a few extra bits
bch_reflink_p: so claim a few from the high end of the destination
index.

Also add some missing bounds checking.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extent_update.c    |  2 +-
 fs/bcachefs/extents.c          |  2 +-
 fs/bcachefs/io_read.c          | 14 ++++-------
 fs/bcachefs/reflink.c          | 45 +++++++++++++++++++++++-----------
 fs/bcachefs/reflink_format.h   |  4 ++-
 fs/bcachefs/sb-errors_format.h |  3 ++-
 6 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/extent_update.c b/fs/bcachefs/extent_update.c
index 45c87c019f6b..6aac579a692a 100644
--- a/fs/bcachefs/extent_update.c
+++ b/fs/bcachefs/extent_update.c
@@ -64,7 +64,7 @@ static int count_iters_for_insert(struct btree_trans *trans,
 		break;
 	case KEY_TYPE_reflink_p: {
 		struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
-		u64 idx = le64_to_cpu(p.v->idx);
+		u64 idx = REFLINK_P_IDX(p.v);
 		unsigned sectors = bpos_min(*end, p.k->p).offset -
 			bkey_start_offset(p.k);
 		struct btree_iter iter;
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 58e4644d43c4..38cd9335df7d 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1492,7 +1492,7 @@ int bch2_cut_front_s(struct bpos where, struct bkey_s k)
 	case KEY_TYPE_reflink_p: {
 		struct bkey_s_reflink_p p = bkey_s_to_reflink_p(k);
 
-		le64_add_cpu(&p.v->idx, sub);
+		SET_REFLINK_P_IDX(p.v, REFLINK_P_IDX(p.v) + sub);
 		break;
 	}
 	case KEY_TYPE_inline_data:
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 9b03421451cb..8ec4314d11ab 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -753,17 +753,13 @@ int __bch2_read_indirect_extent(struct btree_trans *trans,
 				unsigned *offset_into_extent,
 				struct bkey_buf *orig_k)
 {
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	u64 reflink_offset;
-	int ret;
+	struct bkey_i_reflink_p *p = bkey_i_to_reflink_p(orig_k->k);
+	u64 reflink_offset = REFLINK_P_IDX(&p->v) + *offset_into_extent;
 
-	reflink_offset = le64_to_cpu(bkey_i_to_reflink_p(orig_k->k)->v.idx) +
-		*offset_into_extent;
-
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_reflink,
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_reflink,
 			       POS(0, reflink_offset), 0);
-	ret = bkey_err(k);
+	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 96cf50f4705d..addaf5f74624 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -35,10 +35,10 @@ int bch2_reflink_p_validate(struct bch_fs *c, struct bkey_s_c k,
 	struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
 	int ret = 0;
 
-	bkey_fsck_err_on(le64_to_cpu(p.v->idx) < le32_to_cpu(p.v->front_pad),
+	bkey_fsck_err_on(REFLINK_P_IDX(p.v) < le32_to_cpu(p.v->front_pad),
 			 c, reflink_p_front_pad_bad,
 			 "idx < front_pad (%llu < %u)",
-			 le64_to_cpu(p.v->idx), le32_to_cpu(p.v->front_pad));
+			 REFLINK_P_IDX(p.v), le32_to_cpu(p.v->front_pad));
 fsck_err:
 	return ret;
 }
@@ -49,7 +49,7 @@ void bch2_reflink_p_to_text(struct printbuf *out, struct bch_fs *c,
 	struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
 
 	prt_printf(out, "idx %llu front_pad %u back_pad %u",
-	       le64_to_cpu(p.v->idx),
+	       REFLINK_P_IDX(p.v),
 	       le32_to_cpu(p.v->front_pad),
 	       le32_to_cpu(p.v->back_pad));
 }
@@ -65,7 +65,7 @@ bool bch2_reflink_p_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r
 	 */
 	return false;
 
-	if (le64_to_cpu(l.v->idx) + l.k->size != le64_to_cpu(r.v->idx))
+	if (REFLINK_P_IDX(l.v) + l.k->size != REFLINK_P_IDX(r.v))
 		return false;
 
 	bch2_key_resize(l.k, l.k->size + r.k->size);
@@ -115,12 +115,12 @@ static int trans_trigger_reflink_p_segment(struct btree_trans *trans,
 		u64 pad;
 
 		pad = max_t(s64, le32_to_cpu(v->front_pad),
-			    le64_to_cpu(v->idx) - bkey_start_offset(&k->k));
+			    REFLINK_P_IDX(v) - bkey_start_offset(&k->k));
 		BUG_ON(pad > U32_MAX);
 		v->front_pad = cpu_to_le32(pad);
 
 		pad = max_t(s64, le32_to_cpu(v->back_pad),
-			    k->k.p.offset - p.k->size - le64_to_cpu(v->idx));
+			    k->k.p.offset - p.k->size - REFLINK_P_IDX(v));
 		BUG_ON(pad > U32_MAX);
 		v->back_pad = cpu_to_le32(pad);
 	}
@@ -147,8 +147,8 @@ static s64 gc_trigger_reflink_p_segment(struct btree_trans *trans,
 	struct bch_fs *c = trans->c;
 	struct reflink_gc *r;
 	int add = !(flags & BTREE_TRIGGER_overwrite) ? 1 : -1;
-	u64 start = le64_to_cpu(p.v->idx);
-	u64 end = le64_to_cpu(p.v->idx) + p.k->size;
+	u64 start = REFLINK_P_IDX(p.v);
+	u64 end = start + p.k->size;
 	u64 next_idx = end + le32_to_cpu(p.v->back_pad);
 	s64 ret = 0;
 	struct printbuf buf = PRINTBUF;
@@ -210,8 +210,8 @@ static int __trigger_reflink_p(struct btree_trans *trans,
 	struct bkey_s_c_reflink_p p = bkey_s_c_to_reflink_p(k);
 	int ret = 0;
 
-	u64 idx = le64_to_cpu(p.v->idx) - le32_to_cpu(p.v->front_pad);
-	u64 end = le64_to_cpu(p.v->idx) + p.k->size + le32_to_cpu(p.v->back_pad);
+	u64 idx = REFLINK_P_IDX(p.v) - le32_to_cpu(p.v->front_pad);
+	u64 end = REFLINK_P_IDX(p.v) + p.k->size + le32_to_cpu(p.v->back_pad);
 
 	if (flags & BTREE_TRIGGER_transactional) {
 		while (idx < end && !ret)
@@ -258,7 +258,16 @@ int bch2_trigger_reflink_p(struct btree_trans *trans,
 int bch2_reflink_v_validate(struct bch_fs *c, struct bkey_s_c k,
 			    enum bch_validate_flags flags)
 {
-	return bch2_bkey_ptrs_validate(c, k, flags);
+	int ret = 0;
+
+	bkey_fsck_err_on(bkey_gt(k.k->p, POS(0, REFLINK_P_IDX_MAX)),
+			 c, reflink_v_pos_bad,
+			 "indirect extent above maximum position 0:%llu",
+			 REFLINK_P_IDX_MAX);
+
+	ret = bch2_bkey_ptrs_validate(c, k, flags);
+fsck_err:
+	return ret;
 }
 
 void bch2_reflink_v_to_text(struct printbuf *out, struct bch_fs *c,
@@ -358,6 +367,14 @@ static int bch2_make_extent_indirect(struct btree_trans *trans,
 	if (ret)
 		goto err;
 
+	/*
+	 * XXX: we're assuming that 56 bits will be enough for the life of the
+	 * filesystem: we need to implement wraparound, with a cursor in the
+	 * logged ops btree:
+	 */
+	if (bkey_ge(reflink_iter.pos, POS(0, REFLINK_P_IDX_MAX - orig->k.size)))
+		return -ENOSPC;
+
 	r_v = bch2_trans_kmalloc(trans, sizeof(__le64) + bkey_bytes(&orig->k));
 	ret = PTR_ERR_OR_ZERO(r_v);
 	if (ret)
@@ -394,7 +411,7 @@ static int bch2_make_extent_indirect(struct btree_trans *trans,
 	memset(&r_p->v, 0, sizeof(r_p->v));
 #endif
 
-	r_p->v.idx = cpu_to_le64(bkey_start_offset(&r_v->k));
+	SET_REFLINK_P_IDX(&r_p->v, bkey_start_offset(&r_v->k));
 
 	ret = bch2_trans_update(trans, extent_iter, &r_p->k_i,
 				BTREE_UPDATE_internal_snapshot_node);
@@ -533,11 +550,11 @@ s64 bch2_remap_range(struct bch_fs *c,
 			struct bkey_i_reflink_p *dst_p =
 				bkey_reflink_p_init(new_dst.k);
 
-			u64 offset = le64_to_cpu(src_p.v->idx) +
+			u64 offset = REFLINK_P_IDX(src_p.v) +
 				(src_want.offset -
 				 bkey_start_offset(src_k.k));
 
-			dst_p->v.idx = cpu_to_le64(offset);
+			SET_REFLINK_P_IDX(&dst_p->v, offset);
 		} else {
 			BUG();
 		}
diff --git a/fs/bcachefs/reflink_format.h b/fs/bcachefs/reflink_format.h
index 6772eebb1fc6..0d8de13b9ddf 100644
--- a/fs/bcachefs/reflink_format.h
+++ b/fs/bcachefs/reflink_format.h
@@ -4,7 +4,7 @@
 
 struct bch_reflink_p {
 	struct bch_val		v;
-	__le64			idx;
+	__le64			idx_flags;
 	/*
 	 * A reflink pointer might point to an indirect extent which is then
 	 * later split (by copygc or rebalance). If we only pointed to part of
@@ -17,6 +17,8 @@ struct bch_reflink_p {
 	__le32			back_pad;
 } __packed __aligned(8);
 
+LE64_BITMASK(REFLINK_P_IDX,	struct bch_reflink_p, idx_flags,  0, 56);
+
 struct bch_reflink_v {
 	struct bch_val		v;
 	__le64			refcount;
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 3ada94a42a68..45455d31aef7 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -177,6 +177,7 @@ enum bch_fsck_flags {
 	x(ptr_stripe_redundant,					163,	0)		\
 	x(reservation_key_nr_replicas_invalid,			164,	0)		\
 	x(reflink_v_refcount_wrong,				165,	0)		\
+	x(reflink_v_pos_bad,					292,	0)		\
 	x(reflink_p_to_missing_reflink_v,			166,	0)		\
 	x(stripe_pos_bad,					167,	0)		\
 	x(stripe_val_size_bad,					168,	0)		\
@@ -302,7 +303,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							292,	0)
+	x(MAX,							293,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.46.0

