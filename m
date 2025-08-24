Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9392D5A14
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039105; cv=none; b=jxmlWoAtCMEvcZVJzLz4vnNhc4MfaT3v0g9kSJ73EG51qtvWZVILzMBgF99AqAgrED5qiIV6T+AhmUH5h6r/bqA1Fc2SxyNTtteZZOBtQHy6iCExxWNgNGLoLF5TXOkLCHgw66OtZWh9o0+dxOD3MkE57OZpEegHNlFA6SfeUuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039105; c=relaxed/simple;
	bh=TXVbWA9DTwz0wBRuueJDlQayG8sAaj2NyGhenOk13lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amt//Zq9+vFgRFUPjYMkkrNpn8EARrRqnrfPcBYqzstgvND3NnZoGs/QT84wotU/xzukI+qTNqDGeGEM6HvFPB8c4n4UD48XSgKcMTELvwfRspfLQmGiXxFySggVUuHep9BMZASCO+fnAQXMwQ1PSEuo7f71Ldk1EfjUcswNsWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LjTfvjnJ; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LjTfvjnJ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gv33+uSnktOpUU9ylUGu7mVorFds1MqjaNTKQQ/r99g=;
	b=LjTfvjnJAozlwIhPMZHKeqO8tFWnWJmo9YU0GZ9p+viRRDA7YJJHU4vPuxSo4ebLt4Lx45
	W7qNJAR1PxbWGnt41Q0iMdUvsLFf/KDF7DcNUAIkjaYJCSlLAwAhS4zbV33EypezJ1bF8j
	TqCM88ri6YQ9LeOMZs7718Y3/0p3N1I=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 21/21] bcachefs: rebalance_work_(hipri|pending) btrees
Date: Sun, 24 Aug 2025 08:37:58 -0400
Message-ID: <20250824123800.1617669-22-kent.overstreet@linux.dev>
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

Add two more btrees analagous to the rebalance_work btree: bitset btrees
that refer to extents in the extents and reflink btrees.

rebalance_work_hipri: this is for extents that are being moved off of a
BCH_MEMBER_STATE_failed device (device evacuates; we'll likely rename
that member state).

This is to ensure that evacuates aren't blocked by other work, e.g.
background_compression

rebalance_work_pending: this is for extents that we'd like to move but
can't - currently this only happens when the target is full. When we
detect this we can set the pending bit in bch_extent_rebalance; extents
in this btree won't be processed until some external event happens (e.g.
a new device is added to the array).

This fixes a bug where rebalance will spin when more data is stored in
the filesystem than fits in the target specified (e.g. a tiered SSD/HDD
setup with more data than fits on background_target0.

NOTE - we'd really like extents rebalance_work_pending to additionally
be indexed by the target we want to move them to; a large complicated
setup can have many targets with different directories on different
targets. We don't want to have to scan all of rebalance_work_pending,
just the extents for the target that now has free space.

We can't do that yet, though: that will require support for btrees with
larger sized integer keys (currently btree keys are fixed at 160 bit
integers).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |   8 +++
 fs/bcachefs/buckets.c         |  32 +---------
 fs/bcachefs/extents.c         |  10 ----
 fs/bcachefs/extents.h         |  11 ++++
 fs/bcachefs/rebalance.c       | 106 +++++++++++++++++++++++++++++-----
 fs/bcachefs/rebalance.h       |  20 ++++++-
 6 files changed, 129 insertions(+), 58 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index b2de993d802b..28c0c876e14b 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -1425,6 +1425,14 @@ enum btree_id_flags {
 	  BTREE_IS_snapshot_field|						\
 	  BTREE_IS_write_buffer,						\
 	  BIT_ULL(KEY_TYPE_accounting))						\
+	x(rebalance_work_hipri,		21,					\
+	  BTREE_IS_snapshot_field|						\
+	  BTREE_IS_write_buffer,						\
+	  BIT_ULL(KEY_TYPE_set))						\
+	x(rebalance_work_pending,	22,					\
+	  BTREE_IS_snapshot_field|						\
+	  BTREE_IS_write_buffer,						\
+	  BIT_ULL(KEY_TYPE_set))						\
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 436634a5f77c..afa97af1fb8b 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -901,35 +901,9 @@ int bch2_trigger_extent(struct btree_trans *trans,
 				return ret;
 		}
 
-		unsigned old_r = bch2_bkey_needs_rb(old);
-		unsigned new_r = bch2_bkey_needs_rb(new.s_c);
-		if (old_r != new_r) {
-			/* XXX: slowpath, put in a a separate function */
-			int delta = (int) !!new_r - (int) !!old_r;
-			if ((flags & BTREE_TRIGGER_transactional) && delta) {
-				int ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_rebalance_work,
-								  new.k->p, delta > 0);
-				if (ret)
-					return ret;
-			}
-
-			s64 v[1] = { 0 };
-#define x(n)										\
-			if ((old_r ^ new_r) & BIT(BCH_REBALANCE_##n)) {			\
-				v[0] = old_r & BIT(BCH_REBALANCE_##n)			\
-					? -(s64) old.k->size				\
-					:        new.k->size;				\
-											\
-				int ret = bch2_disk_accounting_mod2(trans,		\
-							flags & BTREE_TRIGGER_gc,	\
-							v, rebalance_work,		\
-							BCH_REBALANCE_##n);		\
-				if (ret)						\
-					return ret;					\
-			}
-			BCH_REBALANCE_OPTS()
-#undef x
-		}
+		int ret = bch2_trigger_extent_rebalance(trans, old, new, flags);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 016242ffc98d..6c3964d3efca 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -803,16 +803,6 @@ unsigned bch2_bkey_replicas(struct bch_fs *c, struct bkey_s_c k)
 	return replicas;
 }
 
-static inline unsigned __extent_ptr_durability(struct bch_dev *ca, struct extent_ptr_decoded *p)
-{
-	if (p->ptr.cached)
-		return 0;
-
-	return p->has_ec
-		? p->ec.redundancy + 1
-		: ca->mi.durability;
-}
-
 unsigned bch2_extent_ptr_desired_durability(struct bch_fs *c, struct extent_ptr_decoded *p)
 {
 	struct bch_dev *ca = bch2_dev_rcu_noerror(c, p->ptr.dev);
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 03ea7c689d9a..934754e36854 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -603,6 +603,17 @@ bool bch2_bkey_is_incompressible(struct bkey_s_c);
 unsigned bch2_bkey_sectors_compressed(struct bkey_s_c);
 
 unsigned bch2_bkey_replicas(struct bch_fs *, struct bkey_s_c);
+
+static inline unsigned __extent_ptr_durability(struct bch_dev *ca, struct extent_ptr_decoded *p)
+{
+	if (p->ptr.cached)
+		return 0;
+
+	return p->has_ec
+		? p->ec.redundancy + 1
+		: ca->mi.durability;
+}
+
 unsigned bch2_extent_ptr_desired_durability(struct bch_fs *, struct extent_ptr_decoded *);
 unsigned bch2_extent_ptr_durability(struct bch_fs *, struct extent_ptr_decoded *);
 unsigned bch2_bkey_durability(struct bch_fs *, struct bkey_s_c);
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 525e4d1716c5..b5907e72bcfc 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -46,6 +46,60 @@ const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c k)
 	return bch2_bkey_ptrs_rebalance_opts(bch2_bkey_ptrs_c(k));
 }
 
+static enum btree_id rb_work_btree(const struct bch_extent_rebalance *r)
+{
+	if (!r || !r->need_rb)
+		return 0;
+	if (r->hipri)
+		return BTREE_ID_rebalance_work_hipri;
+	if (r->pending)
+		return BTREE_ID_rebalance_work_pending;
+	return BTREE_ID_rebalance_work;
+}
+
+int __bch2_trigger_extent_rebalance(struct btree_trans *trans,
+				    struct bkey_s_c old, struct bkey_s_c new,
+				    enum btree_iter_update_trigger_flags flags)
+{
+	const struct bch_extent_rebalance *old_r = bch2_bkey_rebalance_opts(old);
+	const struct bch_extent_rebalance *new_r = bch2_bkey_rebalance_opts(new);
+
+	enum btree_id old_btree = rb_work_btree(old_r);
+	enum btree_id new_btree = rb_work_btree(new_r);
+
+	if (old_btree && old_btree != new_btree) {
+		int ret = bch2_btree_bit_mod_buffered(trans, old_btree, old.k->p, false);
+		if (ret)
+			return ret;
+	}
+
+	if (new_btree && old_btree != new_btree) {
+		int ret = bch2_btree_bit_mod_buffered(trans, new_btree, new.k->p, true);
+		if (ret)
+			return ret;
+	}
+
+	unsigned old_n = old_r ? old_r->need_rb : 0;
+	unsigned new_n = new_r ? new_r->need_rb : 0;
+
+	s64 v[1] = { 0 };
+#define x(n)									\
+	if ((old_n ^ new_n) & BIT(BCH_REBALANCE_##n)) {				\
+		v[0] = old_n & BIT(BCH_REBALANCE_##n)				\
+			? -(s64) old.k->size					\
+			:        new.k->size;					\
+										\
+		int ret = bch2_disk_accounting_mod2(trans,			\
+						    flags & BTREE_TRIGGER_gc,	\
+						    v, rebalance_work,		\
+						    BCH_REBALANCE_##n);		\
+		if (ret)							\
+			return ret;						\
+	}
+	BCH_REBALANCE_OPTS()
+#undef x
+}
+
 static struct bch_extent_rebalance
 bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 			  struct bch_inode_opts *opts,
@@ -64,10 +118,6 @@ bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
 		return r;
 
-	const struct bch_extent_rebalance *old_r = bch2_bkey_ptrs_rebalance_opts(ptrs);
-	if (old_r)
-		r = *old_r;
-
 #define x(_name)							\
 	if (k.k->type != KEY_TYPE_reflink_v ||				\
 	    may_update_indirect ||					\
@@ -96,6 +146,10 @@ bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 		incompressible	|= p.crc.compression_type == BCH_COMPRESSION_TYPE_incompressible;
 		unwritten	|= p.ptr.unwritten;
 
+		struct bch_dev *ca = bch2_dev_rcu_noerror(c, p.ptr.dev);
+		if (!ca)
+			goto next;
+
 		if (!p.ptr.cached) {
 			if (p.crc.compression_type != compression_type)
 				*compress_ptrs |= ptr_idx;
@@ -106,13 +160,18 @@ bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 			if (target && !bch2_dev_in_target(c, p.ptr.dev, target))
 				*move_ptrs |= ptr_idx;
 
-			unsigned d = bch2_extent_ptr_durability(c, &p);
+			if (ca->mi.state == BCH_MEMBER_STATE_failed)
+				r.hipri = 1;
+
+			unsigned d = ca->mi.state != BCH_MEMBER_STATE_failed
+				? __extent_ptr_durability(ca, &p)
+				: 0;
 			durability += d;
 			min_durability = min(min_durability, d);
 
 			ec |= p.has_ec;
 		}
-
+next:
 		ptr_idx <<= 1;
 	}
 
@@ -131,6 +190,10 @@ bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 		r.need_rb |= BIT(BCH_REBALANCE_data_replicas);
 	if (*move_ptrs)
 		r.need_rb |= BIT(BCH_REBALANCE_background_target);
+
+	const struct bch_extent_rebalance *old = bch2_bkey_ptrs_rebalance_opts(ptrs);
+	if (old && !(old->need_rb & ~r.need_rb))
+		r.pending = old->pending;
 	return r;
 }
 
@@ -1152,25 +1215,29 @@ int bch2_fs_rebalance_init(struct bch_fs *c)
 	return 0;
 }
 
+/* need better helpers for iterating in parallel */
+
 static int check_rebalance_work_one(struct btree_trans *trans,
 				    struct btree_iter *extent_iter,
 				    struct btree_iter *rebalance_iter,
+				    struct btree_iter *rebalance_hipri_iter,
+				    struct btree_iter *rebalance_pending_iter,
 				    struct per_snapshot_io_opts *snapshot_io_opts,
 				    struct bkey_buf *last_flushed)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_s_c extent_k, rebalance_k;
+	struct bkey_s_c extent_k, rb_k;
 	CLASS(printbuf, buf)();
 
 	int ret = bkey_err(extent_k	= bch2_btree_iter_peek(extent_iter)) ?:
-		  bkey_err(rebalance_k	= bch2_btree_iter_peek(rebalance_iter));
+		  bkey_err(rb_k	= bch2_btree_iter_peek(rebalance_iter));
 	if (ret)
 		return ret;
 
 	if (!extent_k.k &&
 	    extent_iter->btree_id == BTREE_ID_reflink &&
-	    (!rebalance_k.k ||
-	     rebalance_k.k->p.inode >= BCACHEFS_ROOT_INO)) {
+	    (!rb_k.k ||
+	     rb_k.k->p.inode >= BCACHEFS_ROOT_INO)) {
 		bch2_trans_iter_exit(extent_iter);
 		bch2_trans_iter_init(trans, extent_iter,
 				     BTREE_ID_extents, POS_MIN,
@@ -1179,25 +1246,25 @@ static int check_rebalance_work_one(struct btree_trans *trans,
 		return bch_err_throw(c, transaction_restart_nested);
 	}
 
-	if (!extent_k.k && !rebalance_k.k)
+	if (!extent_k.k && !rb_k.k)
 		return 1;
 
 	int cmp = bpos_cmp(extent_k.k	 ? extent_k.k->p    : SPOS_MAX,
-			   rebalance_k.k ? rebalance_k.k->p : SPOS_MAX);
+			   rb_k.k	? rb_k.k->p : SPOS_MAX);
 
 	struct bkey deleted;
 	bkey_init(&deleted);
 
 	if (cmp < 0) {
 		deleted.p = extent_k.k->p;
-		rebalance_k.k = &deleted;
+		rb_k.k = &deleted;
 	} else if (cmp > 0) {
-		deleted.p = rebalance_k.k->p;
+		deleted.p = rb_k.k->p;
 		extent_k.k = &deleted;
 	}
 
 	bool should_have_rebalance = bch2_bkey_needs_rb(extent_k);
-	bool have_rebalance = rebalance_k.k->type == KEY_TYPE_set;
+	bool have_rebalance = rb_k.k->type == KEY_TYPE_set;
 
 	if (should_have_rebalance != have_rebalance) {
 		ret = bch2_btree_write_buffer_maybe_flush(trans, extent_k, last_flushed);
@@ -1248,6 +1315,10 @@ int bch2_check_rebalance_work(struct bch_fs *c)
 				       BTREE_ITER_prefetch);
 	CLASS(btree_iter, rebalance_iter)(trans, BTREE_ID_rebalance_work, POS_MIN,
 					  BTREE_ITER_prefetch);
+	CLASS(btree_iter, rebalance_hipri_iter)(trans, BTREE_ID_rebalance_work_hipri, POS_MIN,
+					  BTREE_ITER_prefetch);
+	CLASS(btree_iter, rebalance_pending_iter)(trans, BTREE_ID_rebalance_work_pending, POS_MIN,
+					  BTREE_ITER_prefetch);
 
 	struct per_snapshot_io_opts snapshot_io_opts;
 	per_snapshot_io_opts_init(&snapshot_io_opts, c);
@@ -1265,7 +1336,10 @@ int bch2_check_rebalance_work(struct bch_fs *c)
 
 		bch2_trans_begin(trans);
 
-		ret = check_rebalance_work_one(trans, &extent_iter, &rebalance_iter,
+		ret = check_rebalance_work_one(trans, &extent_iter,
+					       &rebalance_iter,
+					       &rebalance_hipri_iter,
+					       &rebalance_pending_iter,
 					       &snapshot_io_opts, &last_flushed);
 
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index f6b74d5e1210..27c36568a626 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -22,10 +22,24 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 
 const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
 
-static inline int bch2_bkey_needs_rb(struct bkey_s_c k)
+int __bch2_trigger_extent_rebalance(struct btree_trans *,
+				    struct bkey_s_c, struct bkey_s_c,
+				    enum btree_iter_update_trigger_flags);
+
+static inline int bch2_trigger_extent_rebalance(struct btree_trans *trans,
+				  struct bkey_s_c old, struct bkey_s_c new,
+				  enum btree_iter_update_trigger_flags flags)
 {
-	const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
-	return r ? r->need_rb : 0;
+	const struct bch_extent_rebalance *old_r = bch2_bkey_rebalance_opts(old);
+	const struct bch_extent_rebalance *new_r = bch2_bkey_rebalance_opts(new);
+
+	if ((!old_r && !new_r) ||
+	    (old_r->need_rb	== new_r->need_rb &&
+	     old_r->hipri	== new_r->hipri &&
+	     old_r->pending	== new_r->pending))
+		return 0;
+
+	return __bch2_trigger_extent_rebalance(trans, old, new, flags);
 }
 
 /* Inodes in different snapshots may have different IO options: */
-- 
2.50.1

