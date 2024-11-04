Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF9E18E04C
	for <linux-bcachefs@vger.kernel.org>; Mon,  4 Nov 2024 07:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730704329; cv=none; b=KyQGnovrTsYLcjT+EpMr5fRp/6b3N7Tf5gM2z8LErLFYDf4+2yV4t6b1pRuW1TKmaqYisI4Z2PRoHS4V6ovkqtNw5SMbDbNLRMtEKuUpJM7nIq4ZVXznN9fqDODHYgCc2F4EkjGHqei88d0Zrt9/FO4PtdpMy8LRMu9fCIgOnXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730704329; c=relaxed/simple;
	bh=gXPAQZk5QjwXWc0zJiMUZhapEm52rji5tppWcwjGtoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ov2T9iCgfK02PNaoA9YkXftIQj8tmRBCi1YtC/J7Y2LaV55it8Z4kwkOPPGGPPwjLn4ltt4dLjSB+H/+A9ffWJlezqtW3EM1Obw0Rs79Ad0GGlO3GFn1nwa2SUs0Ra49UtyqYq55EtfOVVGpjrAeIVjstxQ7B8T6oHIYT1m8u9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=me7VkFSO; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="me7VkFSO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730704321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRGPpXsh99m1B+rwnKkzI2AKGMrcd0m0cgJjxQLUQMs=;
	b=me7VkFSOK/rx3DLrAnQ45pOY+TQ9FMSRig2AfZ/VziFXRgYg/9gQwsIHoLnbONvF2LYp4g
	zpDqcZiv9y3YYSblJwWOdrUVM/AxlR+lcFSziIkci72BXwisMYF4MRPiwdxjfI3808XryH
	4jxCfD3YcdF2skMcXmilVyUicnrZ5oQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: Don't delete reflink pointers to missing indirect extents
Date: Mon,  4 Nov 2024 02:11:46 -0500
Message-ID: <20241104071146.11926-3-kent.overstreet@linux.dev>
In-Reply-To: <20241104071146.11926-1-kent.overstreet@linux.dev>
References: <20241104071146.11926-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To avoid tragic loss in the event of transient errors (i.e., a btree
node topology error that was later corrected by btree node scan), we
can't delete reflink pointers to correct errors.

This adds a new error bit to bch_reflink_p, indicating that it is known
to point to a missing indirect extent, and the error has already been
reported.

Indirect extent lookups now use bch2_lookup_indirect_extent(), which on
error reports it as a fsck_err() and sets the error bit, and clears it
if necessary on succesful lookup.

This also gets rid of the bch2_inconsistent_error() call in
__bch2_read_indirect_extent, and in the reflink_p trigger: part of the
online self healing project.

An on disk format change isn't necessary here: setting the error bit
will be interpreted by older versions as pointing to a different index,
which will also be missing - which is fine.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-buffered.c   |   5 +-
 fs/bcachefs/fs.c               |   8 +-
 fs/bcachefs/io_read.c          |  45 +-----
 fs/bcachefs/io_read.h          |  28 +++-
 fs/bcachefs/reflink.c          | 241 +++++++++++++++++++++++++--------
 fs/bcachefs/reflink.h          |   4 +
 fs/bcachefs/reflink_format.h   |   1 +
 fs/bcachefs/sb-errors_format.h |   3 +-
 8 files changed, 224 insertions(+), 111 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 0923f38a2fcd..419927e3d560 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -164,7 +164,8 @@ static void bchfs_read(struct btree_trans *trans,
 			     BTREE_ITER_slots);
 	while (1) {
 		struct bkey_s_c k;
-		unsigned bytes, sectors, offset_into_extent;
+		unsigned bytes, sectors;
+		s64 offset_into_extent;
 		enum btree_id data_btree = BTREE_ID_extents;
 
 		bch2_trans_begin(trans);
@@ -197,7 +198,7 @@ static void bchfs_read(struct btree_trans *trans,
 
 		k = bkey_i_to_s_c(sk.k);
 
-		sectors = min(sectors, k.k->size - offset_into_extent);
+		sectors = min_t(unsigned, sectors, k.k->size - offset_into_extent);
 
 		if (readpages_iter) {
 			ret = readpage_bio_extend(trans, readpages_iter, &rbio->bio, sectors,
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4f5034073453..3d78f66c7d8d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -1263,7 +1263,6 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 	struct btree_iter iter;
 	struct bkey_s_c k;
 	struct bkey_buf cur, prev;
-	unsigned offset_into_extent, sectors;
 	bool have_extent = false;
 	int ret = 0;
 
@@ -1310,9 +1309,8 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 			continue;
 		}
 
-		offset_into_extent	= iter.pos.offset -
-			bkey_start_offset(k.k);
-		sectors			= k.k->size - offset_into_extent;
+		s64 offset_into_extent	= iter.pos.offset - bkey_start_offset(k.k);
+		unsigned sectors	= k.k->size - offset_into_extent;
 
 		bch2_bkey_buf_reassemble(&cur, c, k);
 
@@ -1324,7 +1322,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		k = bkey_i_to_s_c(cur.k);
 		bch2_bkey_buf_realloc(&prev, c, k.k->u64s);
 
-		sectors = min(sectors, k.k->size - offset_into_extent);
+		sectors = min_t(unsigned, sectors, k.k->size - offset_into_extent);
 
 		bch2_cut_front(POS(k.k->p.inode,
 				   bkey_start_offset(k.k) +
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 8ec4314d11ab..2e61833d1f3a 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -21,6 +21,7 @@
 #include "io_read.h"
 #include "io_misc.h"
 #include "io_write.h"
+#include "reflink.h"
 #include "subvolume.h"
 #include "trace.h"
 
@@ -749,41 +750,6 @@ static void bch2_read_endio(struct bio *bio)
 	bch2_rbio_punt(rbio, __bch2_read_endio, context, wq);
 }
 
-int __bch2_read_indirect_extent(struct btree_trans *trans,
-				unsigned *offset_into_extent,
-				struct bkey_buf *orig_k)
-{
-	struct bkey_i_reflink_p *p = bkey_i_to_reflink_p(orig_k->k);
-	u64 reflink_offset = REFLINK_P_IDX(&p->v) + *offset_into_extent;
-
-	struct btree_iter iter;
-	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_reflink,
-			       POS(0, reflink_offset), 0);
-	int ret = bkey_err(k);
-	if (ret)
-		goto err;
-
-	if (k.k->type != KEY_TYPE_reflink_v &&
-	    k.k->type != KEY_TYPE_indirect_inline_data) {
-		bch_err_inum_offset_ratelimited(trans->c,
-			orig_k->k->k.p.inode,
-			orig_k->k->k.p.offset << 9,
-			"%llu len %u points to nonexistent indirect extent %llu",
-			orig_k->k->k.p.offset,
-			orig_k->k->k.size,
-			reflink_offset);
-		bch2_inconsistent_error(trans->c);
-		ret = -BCH_ERR_missing_indirect_extent;
-		goto err;
-	}
-
-	*offset_into_extent = iter.pos.offset - bkey_start_offset(k.k);
-	bch2_bkey_buf_reassemble(orig_k, trans->c, k);
-err:
-	bch2_trans_iter_exit(trans, &iter);
-	return ret;
-}
-
 static noinline void read_from_stale_dirty_pointer(struct btree_trans *trans,
 						   struct bch_dev *ca,
 						   struct bkey_s_c k,
@@ -1159,7 +1125,6 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 			     BTREE_ITER_slots);
 
 	while (1) {
-		unsigned bytes, sectors, offset_into_extent;
 		enum btree_id data_btree = BTREE_ID_extents;
 
 		bch2_trans_begin(trans);
@@ -1179,9 +1144,9 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		if (ret)
 			goto err;
 
-		offset_into_extent = iter.pos.offset -
+		s64 offset_into_extent = iter.pos.offset -
 			bkey_start_offset(k.k);
-		sectors = k.k->size - offset_into_extent;
+		unsigned sectors = k.k->size - offset_into_extent;
 
 		bch2_bkey_buf_reassemble(&sk, c, k);
 
@@ -1196,9 +1161,9 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 		 * With indirect extents, the amount of data to read is the min
 		 * of the original extent and the indirect extent:
 		 */
-		sectors = min(sectors, k.k->size - offset_into_extent);
+		sectors = min_t(unsigned, sectors, k.k->size - offset_into_extent);
 
-		bytes = min(sectors, bvec_iter_sectors(bvec_iter)) << 9;
+		unsigned bytes = min(sectors, bvec_iter_sectors(bvec_iter)) << 9;
 		swap(bvec_iter.bi_size, bytes);
 
 		if (bvec_iter.bi_size == bytes)
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index d9c18bb7d403..a82e8a94ccb6 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -3,6 +3,7 @@
 #define _BCACHEFS_IO_READ_H
 
 #include "bkey_buf.h"
+#include "reflink.h"
 
 struct bch_read_bio {
 	struct bch_fs		*c;
@@ -79,19 +80,32 @@ struct bch_devs_mask;
 struct cache_promote_op;
 struct extent_ptr_decoded;
 
-int __bch2_read_indirect_extent(struct btree_trans *, unsigned *,
-				struct bkey_buf *);
-
 static inline int bch2_read_indirect_extent(struct btree_trans *trans,
 					    enum btree_id *data_btree,
-					    unsigned *offset_into_extent,
-					    struct bkey_buf *k)
+					    s64 *offset_into_extent,
+					    struct bkey_buf *extent)
 {
-	if (k->k->k.type != KEY_TYPE_reflink_p)
+	if (extent->k->k.type != KEY_TYPE_reflink_p)
 		return 0;
 
 	*data_btree = BTREE_ID_reflink;
-	return __bch2_read_indirect_extent(trans, offset_into_extent, k);
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_lookup_indirect_extent(trans, &iter,
+						offset_into_extent,
+						bkey_i_to_s_c_reflink_p(extent->k),
+						true, 0);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	if (bkey_deleted(k.k)) {
+		bch2_trans_iter_exit(trans, &iter);
+		return -BCH_ERR_missing_indirect_extent;
+	}
+
+	bch2_bkey_buf_reassemble(extent, trans->c, k);
+	bch2_trans_iter_exit(trans, &iter);
+	return 0;
 }
 
 enum bch_read_flags {
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 36fb1e9473ff..38db5a011702 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -15,6 +15,17 @@
 
 #include <linux/sched/signal.h>
 
+static inline bool bkey_extent_is_reflink_data(const struct bkey *k)
+{
+	switch (k->type) {
+	case KEY_TYPE_reflink_v:
+	case KEY_TYPE_indirect_inline_data:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline unsigned bkey_type_to_indirect(const struct bkey *k)
 {
 	switch (k->type) {
@@ -68,6 +79,9 @@ bool bch2_reflink_p_merge(struct bch_fs *c, struct bkey_s _l, struct bkey_s_c _r
 	if (REFLINK_P_IDX(l.v) + l.k->size != REFLINK_P_IDX(r.v))
 		return false;
 
+	if (REFLINK_P_ERROR(l.v) != REFLINK_P_ERROR(r.v))
+		return false;
+
 	bch2_key_resize(l.k, l.k->size + r.k->size);
 	return true;
 }
@@ -130,6 +144,144 @@ void bch2_indirect_inline_data_to_text(struct printbuf *out,
 	       min(datalen, 32U), d.v->data);
 }
 
+/* lookup */
+
+static int bch2_indirect_extent_not_missing(struct btree_trans *trans, struct bkey_s_c_reflink_p p,
+					    bool should_commit)
+{
+	struct bkey_i_reflink_p *new = bch2_bkey_make_mut_noupdate_typed(trans, p.s_c, reflink_p);
+	int ret = PTR_ERR_OR_ZERO(new);
+	if (ret)
+		return ret;
+
+	SET_REFLINK_P_ERROR(&new->v, false);
+	ret = bch2_btree_insert_trans(trans, BTREE_ID_extents, &new->k_i, BTREE_TRIGGER_norun);
+	if (ret)
+		return ret;
+
+	if (!should_commit)
+		return 0;
+
+	return bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc) ?:
+		-BCH_ERR_transaction_restart_nested;
+}
+
+static int bch2_indirect_extent_missing_error(struct btree_trans *trans,
+					      struct bkey_s_c_reflink_p p,
+					      u64 missing_start, u64 missing_end,
+					      bool should_commit)
+{
+	if (REFLINK_P_ERROR(p.v))
+		return -BCH_ERR_missing_indirect_extent;
+
+	struct bch_fs *c = trans->c;
+	u64 live_start	= REFLINK_P_IDX(p.v);
+	u64 live_end	= REFLINK_P_IDX(p.v) + p.k->size;
+	u64 refd_start	= live_start	- le32_to_cpu(p.v->front_pad);
+	u64 refd_end	= live_end	+ le32_to_cpu(p.v->back_pad);
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	BUG_ON(missing_start	< refd_start);
+	BUG_ON(missing_end	> refd_end);
+
+	if (fsck_err(trans, reflink_p_to_missing_reflink_v,
+		     "pointer to missing indirect extent\n"
+		     "  %s\n"
+		     "  missing range %llu-%llu",
+		     (bch2_bkey_val_to_text(&buf, c, p.s_c), buf.buf),
+		     missing_start, missing_end)) {
+		struct bkey_i_reflink_p *new = bch2_bkey_make_mut_noupdate_typed(trans, p.s_c, reflink_p);
+		ret = PTR_ERR_OR_ZERO(new);
+		if (ret)
+			goto err;
+
+		/*
+		 * Is the missing range not actually needed?
+		 *
+		 * p.v->idx refers to the data that we actually want, but if the
+		 * indirect extent we point to was bigger, front_pad and back_pad
+		 * indicate the range we took a reference on.
+		 */
+
+		if (missing_end <= live_start) {
+			new->v.front_pad = cpu_to_le32(live_start - missing_end);
+		} else if (missing_start >= live_end) {
+			new->v.back_pad = cpu_to_le32(missing_start - live_end);
+		} else {
+			struct bpos new_start	= bkey_start_pos(&new->k);
+			struct bpos new_end	= new->k.p;
+
+			if (missing_start > live_start)
+				new_start.offset += missing_start - live_start;
+			if (missing_end < live_end)
+				new_end.offset -= live_end - missing_end;
+
+			bch2_cut_front(new_start, &new->k_i);
+			bch2_cut_back(new_end, &new->k_i);
+
+			SET_REFLINK_P_ERROR(&new->v, true);
+		}
+
+		ret = bch2_btree_insert_trans(trans, BTREE_ID_extents, &new->k_i, BTREE_TRIGGER_norun);
+		if (ret)
+			goto err;
+
+		if (should_commit)
+			ret =   bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc) ?:
+				-BCH_ERR_transaction_restart_nested;
+	}
+err:
+fsck_err:
+	printbuf_exit(&buf);
+	return ret;
+}
+
+/*
+ * This is used from the read path, which doesn't expect to have to do a
+ * transaction commit, and from triggers, which should not be doing a commit:
+ */
+struct bkey_s_c bch2_lookup_indirect_extent(struct btree_trans *trans,
+					    struct btree_iter *iter,
+					    s64 *offset_into_extent,
+					    struct bkey_s_c_reflink_p p,
+					    bool should_commit,
+					    unsigned iter_flags)
+{
+	BUG_ON(*offset_into_extent < -((s64) le32_to_cpu(p.v->front_pad)));
+	BUG_ON(*offset_into_extent >= p.k->size + le32_to_cpu(p.v->back_pad));
+
+	u64 reflink_offset = REFLINK_P_IDX(p.v) + *offset_into_extent;
+
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, iter, BTREE_ID_reflink,
+				       POS(0, reflink_offset), iter_flags);
+	if (bkey_err(k))
+		return k;
+
+	if (unlikely(!bkey_extent_is_reflink_data(k.k))) {
+		bch2_trans_iter_exit(trans, iter);
+
+		unsigned size = min((u64) k.k->size,
+				    REFLINK_P_IDX(p.v) + p.k->size + le32_to_cpu(p.v->back_pad) -
+				    reflink_offset);
+		bch2_key_resize(&iter->k, size);
+
+		int ret = bch2_indirect_extent_missing_error(trans, p, reflink_offset,
+							     k.k->p.offset, should_commit);
+		if (ret)
+			return bkey_s_c_err(ret);
+	} else if (unlikely(REFLINK_P_ERROR(p.v))) {
+		bch2_trans_iter_exit(trans, iter);
+
+		int ret = bch2_indirect_extent_not_missing(trans, p, should_commit);
+		if (ret)
+			return bkey_s_c_err(ret);
+	}
+
+	*offset_into_extent = reflink_offset - bkey_start_offset(k.k);
+	return k;
+}
+
 /* reflink pointer trigger */
 
 static int trans_trigger_reflink_p_segment(struct btree_trans *trans,
@@ -137,37 +289,37 @@ static int trans_trigger_reflink_p_segment(struct btree_trans *trans,
 			enum btree_iter_update_trigger_flags flags)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter;
-	struct bkey_i *k;
-	__le64 *refcount;
-	int add = !(flags & BTREE_TRIGGER_overwrite) ? 1 : -1;
 	struct printbuf buf = PRINTBUF;
-	int ret;
 
-	k = bch2_bkey_get_mut_noupdate(trans, &iter,
-			BTREE_ID_reflink, POS(0, *idx),
-			BTREE_ITER_with_updates);
-	ret = PTR_ERR_OR_ZERO(k);
+	s64 offset_into_extent = *idx - REFLINK_P_IDX(p.v);
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_lookup_indirect_extent(trans, &iter, &offset_into_extent, p, false,
+							BTREE_ITER_intent|
+							BTREE_ITER_with_updates);
+	int ret = bkey_err(k);
 	if (ret)
-		goto err;
+		return ret;
 
-	refcount = bkey_refcount(bkey_i_to_s(k));
-	if (!refcount) {
-		bch2_bkey_val_to_text(&buf, c, p.s_c);
-		bch2_trans_inconsistent(trans,
-			"nonexistent indirect extent at %llu while marking\n  %s",
-			*idx, buf.buf);
-		ret = -EIO;
-		goto err;
+	if (bkey_deleted(k.k)) {
+		if (!(flags & BTREE_TRIGGER_overwrite))
+			ret = -BCH_ERR_missing_indirect_extent;
+		goto next;
 	}
 
+	struct bkey_i *new = bch2_bkey_make_mut_noupdate(trans, k);
+	ret = PTR_ERR_OR_ZERO(new);
+	if (ret)
+		goto err;
+
+	__le64 *refcount = bkey_refcount(bkey_i_to_s(new));
 	if (!*refcount && (flags & BTREE_TRIGGER_overwrite)) {
 		bch2_bkey_val_to_text(&buf, c, p.s_c);
-		bch2_trans_inconsistent(trans,
-			"indirect extent refcount underflow at %llu while marking\n  %s",
-			*idx, buf.buf);
-		ret = -EIO;
-		goto err;
+		prt_printf(&buf, "\n  ");
+		bch2_bkey_val_to_text(&buf, c, k);
+		log_fsck_err(trans, reflink_refcount_underflow,
+			     "indirect extent refcount underflow while marking\n  %s",
+			   buf.buf);
+		goto next;
 	}
 
 	if (flags & BTREE_TRIGGER_insert) {
@@ -175,25 +327,26 @@ static int trans_trigger_reflink_p_segment(struct btree_trans *trans,
 		u64 pad;
 
 		pad = max_t(s64, le32_to_cpu(v->front_pad),
-			    REFLINK_P_IDX(v) - bkey_start_offset(&k->k));
+			    REFLINK_P_IDX(v) - bkey_start_offset(&new->k));
 		BUG_ON(pad > U32_MAX);
 		v->front_pad = cpu_to_le32(pad);
 
 		pad = max_t(s64, le32_to_cpu(v->back_pad),
-			    k->k.p.offset - p.k->size - REFLINK_P_IDX(v));
+			    new->k.p.offset - p.k->size - REFLINK_P_IDX(v));
 		BUG_ON(pad > U32_MAX);
 		v->back_pad = cpu_to_le32(pad);
 	}
 
-	le64_add_cpu(refcount, add);
+	le64_add_cpu(refcount, !(flags & BTREE_TRIGGER_overwrite) ? 1 : -1);
 
 	bch2_btree_iter_set_pos_to_extent_start(&iter);
-	ret = bch2_trans_update(trans, &iter, k, 0);
+	ret = bch2_trans_update(trans, &iter, new, 0);
 	if (ret)
 		goto err;
-
-	*idx = k->k.p.offset;
+next:
+	*idx = k.k->p.offset;
 err:
+fsck_err:
 	bch2_trans_iter_exit(trans, &iter);
 	printbuf_exit(&buf);
 	return ret;
@@ -207,9 +360,7 @@ static s64 gc_trigger_reflink_p_segment(struct btree_trans *trans,
 	struct bch_fs *c = trans->c;
 	struct reflink_gc *r;
 	int add = !(flags & BTREE_TRIGGER_overwrite) ? 1 : -1;
-	u64 start = REFLINK_P_IDX(p.v);
-	u64 end = start + p.k->size;
-	u64 next_idx = end + le32_to_cpu(p.v->back_pad);
+	u64 next_idx = REFLINK_P_IDX(p.v) + p.k->size + le32_to_cpu(p.v->back_pad);
 	s64 ret = 0;
 	struct printbuf buf = PRINTBUF;
 
@@ -228,36 +379,14 @@ static s64 gc_trigger_reflink_p_segment(struct btree_trans *trans,
 	*idx = r->offset;
 	return 0;
 not_found:
-	BUG_ON(!(flags & BTREE_TRIGGER_check_repair));
-
-	if (fsck_err(trans, reflink_p_to_missing_reflink_v,
-		     "pointer to missing indirect extent\n"
-		     "  %s\n"
-		     "  missing range %llu-%llu",
-		     (bch2_bkey_val_to_text(&buf, c, p.s_c), buf.buf),
-		     *idx, next_idx)) {
-		struct bkey_i *update = bch2_bkey_make_mut_noupdate(trans, p.s_c);
-		ret = PTR_ERR_OR_ZERO(update);
+	if (flags & BTREE_TRIGGER_check_repair) {
+		ret = bch2_indirect_extent_missing_error(trans, p, *idx, next_idx, false);
 		if (ret)
 			goto err;
-
-		if (next_idx <= start) {
-			bkey_i_to_reflink_p(update)->v.front_pad = cpu_to_le32(start - next_idx);
-		} else if (*idx >= end) {
-			bkey_i_to_reflink_p(update)->v.back_pad = cpu_to_le32(*idx - end);
-		} else {
-			bkey_error_init(update);
-			update->k.p		= p.k->p;
-			update->k.size		= p.k->size;
-			set_bkey_val_u64s(&update->k, 0);
-		}
-
-		ret = bch2_btree_insert_trans(trans, BTREE_ID_extents, update, BTREE_TRIGGER_norun);
 	}
 
 	*idx = next_idx;
 err:
-fsck_err:
 	printbuf_exit(&buf);
 	return ret;
 }
diff --git a/fs/bcachefs/reflink.h b/fs/bcachefs/reflink.h
index 6ec3a9ea6bb4..b61a4bdd8e82 100644
--- a/fs/bcachefs/reflink.h
+++ b/fs/bcachefs/reflink.h
@@ -73,6 +73,10 @@ static inline __le64 *bkey_refcount(struct bkey_s k)
 	}
 }
 
+struct bkey_s_c bch2_lookup_indirect_extent(struct btree_trans *, struct btree_iter *,
+					    s64 *, struct bkey_s_c_reflink_p,
+					    bool, unsigned);
+
 s64 bch2_remap_range(struct bch_fs *, subvol_inum, u64,
 		     subvol_inum, u64, u64, u64, s64 *);
 
diff --git a/fs/bcachefs/reflink_format.h b/fs/bcachefs/reflink_format.h
index 0d8de13b9ddf..53502627b2c5 100644
--- a/fs/bcachefs/reflink_format.h
+++ b/fs/bcachefs/reflink_format.h
@@ -18,6 +18,7 @@ struct bch_reflink_p {
 } __packed __aligned(8);
 
 LE64_BITMASK(REFLINK_P_IDX,	struct bch_reflink_p, idx_flags,  0, 56);
+LE64_BITMASK(REFLINK_P_ERROR,	struct bch_reflink_p, idx_flags, 56, 57);
 
 struct bch_reflink_v {
 	struct bch_val		v;
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index 45455d31aef7..2b714f297070 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -179,6 +179,7 @@ enum bch_fsck_flags {
 	x(reflink_v_refcount_wrong,				165,	0)		\
 	x(reflink_v_pos_bad,					292,	0)		\
 	x(reflink_p_to_missing_reflink_v,			166,	0)		\
+	x(reflink_refcount_underflow,				293,	0)		\
 	x(stripe_pos_bad,					167,	0)		\
 	x(stripe_val_size_bad,					168,	0)		\
 	x(stripe_csum_granularity_bad,				290,	0)		\
@@ -303,7 +304,7 @@ enum bch_fsck_flags {
 	x(accounting_key_replicas_devs_unsorted,		280,	FSCK_AUTOFIX)	\
 	x(accounting_key_version_0,				282,	FSCK_AUTOFIX)	\
 	x(logged_op_but_clean,					283,	FSCK_AUTOFIX)	\
-	x(MAX,							293,	0)
+	x(MAX,							294,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.46.0

