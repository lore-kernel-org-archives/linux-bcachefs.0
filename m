Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1CF2D97BD
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039104; cv=none; b=eLM21tbELJu/y8tNPq+UISqFT0ewW7UGea9G4DJL67pvTu68Bzh1Z78MrXcciZijbheiacH6YDSdrCBGJ1yE/g5Zwxzpgx4XfuyG1vjtFTw7jjtuu1SKEPpzFAMwqnTsuhmjezocWtfvFq2etKL1wAOahqC+mehBem1a5rPc+vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039104; c=relaxed/simple;
	bh=xDAf4a3sTdUPn8gZditjGwFyE12/r2djUpftN5rKCHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf+4XzYr58//MxZGebJOpwDn2kV4LiR/NKV3grBsF+pUibcASINwMW9Rgr9aKPWmesgt2uiEc9zy87WJ4Suu2h7D70hBwHG7s36X0M8WIjpDPxj8TbQ3MG/FRJMYD6LGyOZPbSNIURmQtcVL7yr/OB30MRFY+BM+YsQf4qA5Bcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RHk3Jb5b; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RHk3Jb5b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=44acOhCUAtmVVAO876s1kbYSx43CCtb3vjnt4XGQRCY=;
	b=RHk3Jb5bu/bvP6f6t9KX5V9a6Q6epbxUHt4sivH+3eg56l6uuCffFAkkQOZl8WscxQkPT9
	FFi5aiD9Jh2z2xX99gAfVo7Xz7HCouiAw5RvfCNMRztOWurrrUAkUG/w74C14Ay32szBZy
	b0jnUJ/SZMyvxvDxQ1cEvBsQUruQCkI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 17/21] bcachefs: bch_extent_rebalance changes
Date: Sun, 24 Aug 2025 08:37:54 -0400
Message-ID: <20250824123800.1617669-18-kent.overstreet@linux.dev>
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

"Extent needs rebalance for data_replicas" cannot be a pure function of
the extent with the current bch_extent_rebalance, which is required for
the triggers - they would create inconsistencies in the rebalance_work
accounting and btrees when e.g. device durability changes.

So: this adds bch_extent_rebalance.needs_rb, which has flags for all the
reasons rebalance may need to process an extent: the trigger now uses
just these flags instead of running the full "does this extent need
rebalance" calculations in bch2_bkey_sectors_need_rebalance().

Additionally:
- Instead of a single accounting counter for pending rebalance work,
  this is now split out into different counters for the different io
  path options rebalance handles (compression, data_checksum, replicas,
  erasure_code, etc.)

- "Does this extent need to be rebalanced?" is now centralized in
  bch2_bkey_set_needs_rebalance()

- "Is new rebalance_work allowed in this context" is
  new_needs_rb_allowed() - this enforces that extents match the
  specified io path options, with clearly defined exceptions (e.g.
  accounting for races with option changes, and foreground writes are
  allowed to add background_compression and background_target work)

XXX: split this patch up more

XXX: define a new on disk format version, and upgrade/downgrade table
entries

Compatibility notes: still undecided if we'll stick with redefining the
existing bch_extent_rebalance, or add a new extent entry type for
bch_extent_rebalance_v2 - there are pros and cons to both

If we redefine the existing bch_extent_rebalance, on upgrade
check_rebalance_work will correct all the existing bch_extent_rebalance
entries (along with accounting, rebalance_work btrees) - except indirect
extents will need special handling, which we likely need anyways

On downgrade, old versions don't have a recovery pass that
checks/fixes bch_extent_rebalance from the io path options - but they do
that on data move, so we're probably more or less ok; some wonkiness in
rebalance_work accounting would be expected

Adding a bch_extent_rebalance_v2 would be an incompatible upgrade
(adding new extent entry types is always an incompatible upgrade,
unfortunately) - and it'd require keeping around compatibility code for
e.g. the triggers to handle the old bch_extent_rebalance...

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/buckets.c                |  50 ++--
 fs/bcachefs/data_update.c            |  26 --
 fs/bcachefs/disk_accounting_format.h |   1 +
 fs/bcachefs/rebalance.c              | 403 ++++++++++++++-------------
 fs/bcachefs/rebalance.h              |  21 +-
 fs/bcachefs/rebalance_format.h       |  62 +++--
 fs/bcachefs/trace.h                  |   5 -
 7 files changed, 288 insertions(+), 280 deletions(-)

diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 6be1cc9ba0da..436634a5f77c 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -871,7 +871,6 @@ int bch2_trigger_extent(struct btree_trans *trans,
 			struct bkey_s_c old, struct bkey_s new,
 			enum btree_iter_update_trigger_flags flags)
 {
-	struct bch_fs *c = trans->c;
 	struct bkey_ptrs_c new_ptrs = bch2_bkey_ptrs_c(new.s_c);
 	struct bkey_ptrs_c old_ptrs = bch2_bkey_ptrs_c(old);
 	unsigned new_ptrs_bytes = (void *) new_ptrs.end - (void *) new_ptrs.start;
@@ -902,29 +901,34 @@ int bch2_trigger_extent(struct btree_trans *trans,
 				return ret;
 		}
 
-		int need_rebalance_delta = 0;
-		s64 need_rebalance_sectors_delta[1] = { 0 };
-
-		s64 s = bch2_bkey_sectors_need_rebalance(c, old);
-		need_rebalance_delta -= s != 0;
-		need_rebalance_sectors_delta[0] -= s;
-
-		s = bch2_bkey_sectors_need_rebalance(c, new.s_c);
-		need_rebalance_delta += s != 0;
-		need_rebalance_sectors_delta[0] += s;
-
-		if ((flags & BTREE_TRIGGER_transactional) && need_rebalance_delta) {
-			int ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_rebalance_work,
-							  new.k->p, need_rebalance_delta > 0);
-			if (ret)
-				return ret;
-		}
+		unsigned old_r = bch2_bkey_needs_rb(old);
+		unsigned new_r = bch2_bkey_needs_rb(new.s_c);
+		if (old_r != new_r) {
+			/* XXX: slowpath, put in a a separate function */
+			int delta = (int) !!new_r - (int) !!old_r;
+			if ((flags & BTREE_TRIGGER_transactional) && delta) {
+				int ret = bch2_btree_bit_mod_buffered(trans, BTREE_ID_rebalance_work,
+								  new.k->p, delta > 0);
+				if (ret)
+					return ret;
+			}
 
-		if (need_rebalance_sectors_delta[0]) {
-			int ret = bch2_disk_accounting_mod2(trans, flags & BTREE_TRIGGER_gc,
-							    need_rebalance_sectors_delta, rebalance_work);
-			if (ret)
-				return ret;
+			s64 v[1] = { 0 };
+#define x(n)										\
+			if ((old_r ^ new_r) & BIT(BCH_REBALANCE_##n)) {			\
+				v[0] = old_r & BIT(BCH_REBALANCE_##n)			\
+					? -(s64) old.k->size				\
+					:        new.k->size;				\
+											\
+				int ret = bch2_disk_accounting_mod2(trans,		\
+							flags & BTREE_TRIGGER_gc,	\
+							v, rebalance_work,		\
+							BCH_REBALANCE_##n);		\
+				if (ret)						\
+					return ret;					\
+			}
+			BCH_REBALANCE_OPTS()
+#undef x
 		}
 	}
 
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 0f968bab7d93..2466f7a1c9e6 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -207,28 +207,6 @@ static void trace_data_update2(struct data_update *m,
 	trace_data_update(c, buf.buf);
 }
 
-noinline_for_stack
-static void trace_io_move_created_rebalance2(struct data_update *m,
-					     struct bkey_s_c old, struct bkey_s_c k,
-					     struct bkey_i *insert)
-{
-	struct bch_fs *c = m->op.c;
-	CLASS(printbuf, buf)();
-
-	bch2_data_update_opts_to_text(&buf, c, &m->op.opts, &m->data_opts);
-
-	prt_str(&buf, "\nold: ");
-	bch2_bkey_val_to_text(&buf, c, old);
-	prt_str(&buf, "\nk:   ");
-	bch2_bkey_val_to_text(&buf, c, k);
-	prt_str(&buf, "\nnew: ");
-	bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(insert));
-
-	trace_io_move_created_rebalance(c, buf.buf);
-
-	count_event(c, io_move_created_rebalance);
-}
-
 noinline_for_stack
 static int data_update_invalid_bkey(struct data_update *m,
 				    struct bkey_s_c old, struct bkey_s_c k,
@@ -449,10 +427,6 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 		if (trace_data_update_enabled())
 			trace_data_update2(m, old, k, insert);
 
-		if (bch2_bkey_sectors_need_rebalance(c, bkey_i_to_s_c(insert)) * k.k->size >
-		    bch2_bkey_sectors_need_rebalance(c, k) * insert->k.size)
-			trace_io_move_created_rebalance2(m, old, k, insert);
-
 		ret =   bch2_trans_commit(trans, &op->res,
 				NULL,
 				BCH_TRANS_COMMIT_no_check_rw|
diff --git a/fs/bcachefs/disk_accounting_format.h b/fs/bcachefs/disk_accounting_format.h
index 8269af1dbe2a..4aa7f83f5d75 100644
--- a/fs/bcachefs/disk_accounting_format.h
+++ b/fs/bcachefs/disk_accounting_format.h
@@ -200,6 +200,7 @@ struct bch_acct_inum {
  * move, extents counted here are also in the rebalance_work btree.
  */
 struct bch_acct_rebalance_work {
+	__u8			opt;
 };
 
 struct disk_accounting_pos {
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 33bddbd33088..3a6cd54613a1 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -40,49 +40,54 @@ static const struct bch_extent_rebalance *bch2_bkey_ptrs_rebalance_opts(struct b
 	return NULL;
 }
 
-static const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c k)
+const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c k)
 {
 	return bch2_bkey_ptrs_rebalance_opts(bch2_bkey_ptrs_c(k));
 }
 
-static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
-				      struct bch_inode_opts *io_opts,
-				      unsigned *move_ptrs,
-				      unsigned *compress_ptrs,
-				      unsigned *csum_ptrs,
-				      u64 *sectors)
+static struct bch_extent_rebalance
+bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
+			  struct bch_inode_opts *opts,
+			  unsigned *move_ptrs,
+			  unsigned *compress_ptrs,
+			  unsigned *csum_ptrs,
+			  bool may_update_indirect)
 {
 	*move_ptrs	= 0;
 	*compress_ptrs	= 0;
 	*csum_ptrs	= 0;
-	*sectors	= 0;
 
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
-
-	const struct bch_extent_rebalance *rb_opts = bch2_bkey_ptrs_rebalance_opts(ptrs);
-	if (!io_opts && !rb_opts)
-		return;
+	struct bch_extent_rebalance r = { .type = BIT(BCH_EXTENT_ENTRY_rebalance) };
 
 	if (bch2_bkey_extent_ptrs_flags(ptrs) & BIT_ULL(BCH_EXTENT_FLAG_poisoned))
-		return;
-
-	unsigned compression_type =
-		bch2_compression_opt_to_type(io_opts
-					     ? io_opts->background_compression
-					     : rb_opts->background_compression);
-	unsigned csum_type = bch2_csum_opt_to_type(io_opts
-						   ? io_opts->data_checksum
-						   : rb_opts->data_checksum, true);
-	unsigned target = io_opts
-		? io_opts->background_target
-		: rb_opts->background_target;
+		return r;
+
+	const struct bch_extent_rebalance *old_r = bch2_bkey_ptrs_rebalance_opts(ptrs);
+	if (old_r)
+		r = *old_r;
+
+#define x(_name)							\
+	if (k.k->type != KEY_TYPE_reflink_v ||				\
+	    may_update_indirect ||					\
+	    (!opts->_name##_from_inode && !r._name##_from_inode)) {	\
+		r._name			= opts->_name;			\
+		r._name##_from_inode	= opts->_name##_from_inode;	\
+	}
+	BCH_REBALANCE_OPTS()
+#undef x
+
+	unsigned compression_type = bch2_compression_opt_to_type(r.background_compression);
+	unsigned csum_type	= bch2_csum_opt_to_type(r.data_checksum, true);
+	unsigned target		= r.background_target;
 	if (target && !bch2_target_accepts_data(c, BCH_DATA_user, target))
 		target = 0;
 
+	bool incompressible = false, unwritten = false, ec = false;
+	unsigned durability = 0, min_durability = INT_MAX;
+
 	const union bch_extent_entry *entry;
 	struct extent_ptr_decoded p;
-	bool incompressible = false, unwritten = false;
-
 	unsigned ptr_idx = 1;
 
 	guard(rcu)();
@@ -99,6 +104,12 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 
 			if (target && !bch2_dev_in_target(c, p.ptr.dev, target))
 				*move_ptrs |= ptr_idx;
+
+			unsigned d = bch2_extent_ptr_durability(c, &p);
+			durability += d;
+			min_durability = min(min_durability, d);
+
+			ec |= p.has_ec;
 		}
 
 		ptr_idx <<= 1;
@@ -109,48 +120,123 @@ static void bch2_bkey_needs_rebalance(struct bch_fs *c, struct bkey_s_c k,
 	if (incompressible)
 		*compress_ptrs = 0;
 
-	unsigned rb_ptrs = *move_ptrs | *compress_ptrs | *csum_ptrs;
-
-	if (!rb_ptrs)
-		return;
-
-	ptr_idx = 1;
-	bkey_for_each_ptr_decode(k.k, ptrs, p, entry) {
-		if (rb_ptrs & ptr_idx)
-			*sectors += p.crc.compressed_size;
-		ptr_idx <<= 1;
-	}
+	if (*csum_ptrs)
+		r.need_rb |= BIT(BCH_REBALANCE_data_checksum);
+	if (*compress_ptrs)
+		r.need_rb |= BIT(BCH_REBALANCE_background_compression);
+	if (r.erasure_code != ec)
+		r.need_rb |= BIT(BCH_REBALANCE_erasure_code);
+	if (durability < r.data_replicas || durability >= r.data_replicas + min_durability)
+		r.need_rb |= BIT(BCH_REBALANCE_data_replicas);
+	if (*move_ptrs)
+		r.need_rb |= BIT(BCH_REBALANCE_background_target);
+	return r;
 }
 
-u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
+static int check_rebalance_scan_cookie(struct btree_trans *trans, u64 inum, bool *v)
 {
-	unsigned move_ptrs	= 0;
-	unsigned compress_ptrs	= 0;
-	unsigned csum_ptrs	= 0;
-	u64 sectors		= 0;
+	if (*v)
+		return 0;
 
-	bch2_bkey_needs_rebalance(c, k, NULL, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
-	return sectors;
+	/*
+	 * If opts need to be propagated to the extent, a scan cookie should be
+	 * present:
+	 */
+	CLASS(btree_iter, iter)(trans, BTREE_ID_rebalance_work,
+				SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
+				BTREE_ITER_intent);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(&iter);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	*v = k.k->type == KEY_TYPE_cookie;
+	return 0;
 }
 
-static unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
-					      struct bch_inode_opts *opts,
-					      struct bkey_s_c k)
+static int new_needs_rb_allowed(struct btree_trans *trans,
+				struct per_snapshot_io_opts *s,
+				struct bkey_s_c k,
+				enum set_needs_rebalance_ctx ctx,
+				unsigned opt_change_cookie,
+				const struct bch_extent_rebalance *old,
+				const struct bch_extent_rebalance *new,
+				unsigned new_need_rb)
 {
-	unsigned move_ptrs	= 0;
-	unsigned compress_ptrs	= 0;
-	unsigned csum_ptrs	= 0;
-	u64 sectors		= 0;
+	struct bch_fs *c = trans->c;
+	/*
+	 * New need_rb - pointers that don't match the current io path options -
+	 * are only allowed in certain situations:
+	 *
+	 * Propagating new options: from bch2_set_rebalance_needs_scan
+	 *
+	 * Foreground writes: background_compression and background_target are
+	 * allowed
+	 *
+	 * Foreground writes: we may have raced with an option change:
+	 * opt_change_cookie checks for this
+	 *
+	 * XXX: foreground writes should still match compression,
+	 * foreground_target - figure out how to check for this
+	 */
+	if (ctx == SET_NEEDS_REBALANCE_opt_change ||
+	    ctx == SET_NEEDS_REBALANCE_opt_change_indirect)
+		return 0;
 
-	bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
-	return move_ptrs|compress_ptrs|csum_ptrs;
-}
+	if (ctx == SET_NEEDS_REBALANCE_foreground) {
+		new_need_rb &= ~(BIT(BCH_REBALANCE_background_compression)|
+				 BIT(BCH_REBALANCE_background_target));
+		if (!new_need_rb)
+			return 0;
 
-static inline bool bkey_should_have_rb_opts(struct bch_fs *c,
-					    struct bch_inode_opts *opts,
-					    struct bkey_s_c k)
-{
-	return k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k);
+		if (opt_change_cookie != atomic_read(&c->opt_change_cookie))
+			return 0;
+	}
+
+	/*
+	 * Either the extent data or the extent io options (from
+	 * bch_extent_rebalance) should match the io_opts from the
+	 * inode/filesystem, unless
+	 *
+	 * - There's a scan pending to propagate new options
+	 * - It's an indirect extent: it may be referenced by inodes
+	 *   with inconsistent options
+	 *
+	 * For efficiency (so that we can cache checking for scan
+	 * cookies), only check option consistency when we're called
+	 * with snapshot_io_opts - don't bother when we're called from
+	 * move_data_phys() -> get_io_opts_one()
+	 *
+	 * Note that we can cache the existence of a cookie, but not the
+	 * non-existence, to avoid spurious false positives.
+	 */
+	bool scan_cookie = false;
+	int ret = check_rebalance_scan_cookie(trans, 0,			s ? &s->fs_scan_cookie : &scan_cookie) ?:
+		  check_rebalance_scan_cookie(trans, k.k->p.inode,	s ? &s->inum_scan_cookie : &scan_cookie);
+	if (ret)
+		return ret;
+
+	if (scan_cookie)
+		return 0;
+
+	CLASS(printbuf, buf)();
+
+	prt_printf(&buf, "extent with incorrect/missing rebalance opts:\n");
+	bch2_bkey_val_to_text(&buf, c, k);
+
+	const struct bch_extent_rebalance _old = {};
+	if (!old)
+		old = &_old;
+
+#define x(_name)								\
+	if (new_need_rb & BIT(BCH_REBALANCE_##_name))				\
+		prt_printf(&buf, "\n" #_name " %u != %u", old->_name, new->_name);
+	BCH_REBALANCE_OPTS()
+#undef x
+
+	fsck_err(trans, extent_io_opts_not_set, "%s", buf.buf);
+fsck_err:
+	return ret;
 }
 
 int bch2_bkey_set_needs_rebalance(struct btree_trans *trans,
@@ -158,7 +244,7 @@ int bch2_bkey_set_needs_rebalance(struct btree_trans *trans,
 				  struct bch_inode_opts *opts,
 				  struct bkey_i *_k,
 				  enum set_needs_rebalance_ctx ctx,
-				  u32 change_cookie)
+				  unsigned opt_change_cookie)
 {
 	if (!bkey_extent_is_direct_data(&_k->k))
 		return 0;
@@ -168,51 +254,44 @@ int bch2_bkey_set_needs_rebalance(struct btree_trans *trans,
 	struct bch_extent_rebalance *old =
 		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
 
-	if (bkey_should_have_rb_opts(c, opts, k.s_c)) {
-		if (!old) {
-			old = bkey_val_end(k);
-			k.k->u64s += sizeof(*old) / sizeof(u64);
-		}
+	unsigned move_ptrs	= 0;
+	unsigned compress_ptrs	= 0;
+	unsigned csum_ptrs	= 0;
+	struct bch_extent_rebalance new =
+		bch2_bkey_needs_rebalance(c, k.s_c, opts, &move_ptrs, &compress_ptrs, &csum_ptrs,
+					  ctx == SET_NEEDS_REBALANCE_opt_change_indirect);
 
-		*old = io_opts_to_rebalance_opts(c, opts);
-	} else {
-		if (old)
-			extent_entry_drop(k, (union bch_extent_entry *) old);
-	}
+	bool should_have_rb = k.k->type == KEY_TYPE_reflink_v || new.need_rb;
 
-	return 0;
-}
+	if (should_have_rb == !!old &&
+	    (should_have_rb ? !memcmp(old, &new, sizeof(new)) : !old))
+		return 0;
 
-static int have_rebalance_scan_cookie(struct btree_trans *trans, u64 inum)
-{
-	/*
-	 * If opts need to be propagated to the extent, a scan cookie should be
-	 * present:
-	 */
-	CLASS(btree_iter, iter)(trans, BTREE_ID_rebalance_work,
-				SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
-				BTREE_ITER_intent);
-	struct bkey_s_c k = bch2_btree_iter_peek_slot(&iter);
-	int ret = bkey_err(k);
-	if (ret)
-		return ret;
+	unsigned new_need_rb = new.need_rb & ~(old ? old->need_rb : 0);
 
-	if (k.k->type == KEY_TYPE_cookie)
-		return 1;
+	if (unlikely(new_need_rb)) {
+		int ret = new_needs_rb_allowed(trans, snapshot_io_opts,
+					       k.s_c, ctx, opt_change_cookie,
+					       old, &new, new_need_rb);
+		if (ret)
+			return ret;
+	}
 
-	if (!inum)
-		return 0;
+	if (should_have_rb) {
+		if (!old) {
+			old = bkey_val_end(k);
+			k.k->u64s += sizeof(*old) / sizeof(u64);
+		}
 
-	bch2_btree_iter_set_pos(&iter, SPOS(0, REBALANCE_WORK_SCAN_OFFSET, U32_MAX));
-	k = bch2_btree_iter_peek_slot(&iter);
-	ret = bkey_err(k);
-	if (ret)
-		return ret;
+		*old = new;
+	} else if (old)
+		extent_entry_drop(k, (union bch_extent_entry *) old);
 
-	return k.k->type == KEY_TYPE_cookie;
+	return 0;
 }
 
 static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
+					  struct per_snapshot_io_opts *snapshot_io_opts,
 					  struct bch_inode_opts *io_opts,
 					  struct btree_iter *iter,
 					  struct bkey_s_c k,
@@ -227,59 +306,22 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 	if (!bkey_extent_is_direct_data(k.k))
 		return 0;
 
-	bool may_update_indirect = ctx == SET_NEEDS_REBALANCE_opt_change_indirect;
+	struct bch_extent_rebalance *old =
+		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k);
 
-	/*
-	 * If it's an indirect extent, and we walked to it directly, we won't
-	 * have the options from the inode that were directly applied: options
-	 * from the extent take precedence - unless the io_opts option came from
-	 * the inode and may_update_indirect is true (walked from a
-	 * REFLINK_P_MAY_UPDATE_OPTIONS pointer).
-	 */
-	const struct bch_extent_rebalance *old = bch2_bkey_rebalance_opts(k);
-	if (old && k.k->type == KEY_TYPE_reflink_v) {
-#define x(_name)								\
-		if (old->_name##_from_inode &&					\
-		    !(may_update_indirect && io_opts->_name##_from_inode)) {	\
-			io_opts->_name = old->_name;				\
-			io_opts->_name##_from_inode = true;			\
-		}
-		BCH_REBALANCE_OPTS()
-#undef x
-	}
+	unsigned move_ptrs	= 0;
+	unsigned compress_ptrs	= 0;
+	unsigned csum_ptrs	= 0;
+	struct bch_extent_rebalance new =
+		bch2_bkey_needs_rebalance(c, k, io_opts, &move_ptrs, &compress_ptrs, &csum_ptrs,
+					  ctx == SET_NEEDS_REBALANCE_opt_change_indirect);
 
-	struct bch_extent_rebalance new = io_opts_to_rebalance_opts(c, io_opts);
+	bool should_have_rb = k.k->type == KEY_TYPE_reflink_v || new.need_rb;
 
-	if (bkey_should_have_rb_opts(c, io_opts, k)
-	    ? old && !memcmp(old, &new, sizeof(new))
-	    : !old)
+	if (should_have_rb == !!old &&
+	    (should_have_rb ? !memcmp(old, &new, sizeof(new)) : !old))
 		return 0;
 
-	if (k.k->type != KEY_TYPE_reflink_v) {
-		ret = have_rebalance_scan_cookie(trans, k.k->p.inode);
-		if (ret < 0)
-			return ret;
-
-		if (!ret) {
-			CLASS(printbuf, buf)();
-
-			prt_printf(&buf, "extent with incorrect/missing rebalance opts:\n");
-			bch2_bkey_val_to_text(&buf, c, k);
-
-			const struct bch_extent_rebalance _old = {};
-			if (!old)
-				old = &_old;
-#define x(_name)								\
-			if (old->_name != new._name)				\
-				prt_printf(&buf, "\n" #_name " %u != %u",	\
-					   old->_name, new._name);		\
-			BCH_REBALANCE_OPTS()
-#undef x
-
-			fsck_err(trans, extent_io_opts_not_set, "%s", buf.buf);
-		}
-	}
-
 	struct bkey_i *n = bch2_trans_kmalloc(trans, bkey_bytes(k.k) + 8);
 	ret = PTR_ERR_OR_ZERO(n);
 	if (ret)
@@ -289,12 +331,10 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	ret = bch2_bkey_set_needs_rebalance(trans, NULL, io_opts, n, ctx, 0) ?:
+	return  bch2_bkey_set_needs_rebalance(trans, snapshot_io_opts, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
 		bch_err_throw(c, transaction_restart_commit);
-fsck_err:
-	return ret;
 }
 
 static struct bch_inode_opts *bch2_extent_get_io_opts(struct btree_trans *trans,
@@ -334,7 +374,8 @@ static struct bch_inode_opts *bch2_extent_get_io_opts(struct btree_trans *trans,
 
 			darray_push(&io_opts->d, e);
 		}));
-		io_opts->cur_inum = extent_pos.inode;
+		io_opts->cur_inum		= extent_pos.inode;
+		io_opts->inum_scan_cookie	= false;
 	}
 
 	ret = ret ?: trans_was_restarted(trans, restart_count);
@@ -357,12 +398,13 @@ struct bch_inode_opts *bch2_extent_get_apply_io_opts(struct btree_trans *trans,
 			  enum set_needs_rebalance_ctx ctx)
 {
 	struct bch_inode_opts *opts =
-		bch2_extent_get_io_opts(trans, snapshot_io_opts, extent_pos, extent_iter, extent_k);
+		bch2_extent_get_io_opts(trans, snapshot_io_opts,
+					extent_pos, extent_iter, extent_k);
 	if (IS_ERR(opts) || btree_iter_path(trans, extent_iter)->level)
 		return opts;
 
-	int ret = bch2_get_update_rebalance_opts(trans, opts, extent_iter, extent_k,
-						 SET_NEEDS_REBALANCE_other);
+	int ret = bch2_get_update_rebalance_opts(trans, snapshot_io_opts, opts,
+						 extent_iter, extent_k, ctx);
 	return ret ? ERR_PTR(ret) : opts;
 }
 
@@ -393,8 +435,7 @@ int bch2_extent_get_io_opts_one(struct btree_trans *trans,
 		}
 	}
 
-	return bch2_get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k,
-					      ctx);
+	return bch2_get_update_rebalance_opts(trans, NULL, io_opts, extent_iter, extent_k, ctx);
 }
 
 static const char * const bch2_rebalance_state_strs[] = {
@@ -507,23 +548,6 @@ static struct bkey_i *next_rebalance_entry(struct btree_trans *trans,
 	return &(&darray_pop(buf))->k_i;
 }
 
-static int bch2_bkey_clear_needs_rebalance(struct btree_trans *trans,
-					   struct btree_iter *iter,
-					   struct bkey_s_c k)
-{
-	if (k.k->type == KEY_TYPE_reflink_v || !bch2_bkey_rebalance_opts(k))
-		return 0;
-
-	struct bkey_i *n = bch2_bkey_make_mut(trans, iter, &k, 0);
-	int ret = PTR_ERR_OR_ZERO(n);
-	if (ret)
-		return ret;
-
-	extent_entry_drop(bkey_i_to_s(n),
-			  (void *) bch2_bkey_rebalance_opts(bkey_i_to_s_c(n)));
-	return bch2_trans_commit(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc);
-}
-
 static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 			struct per_snapshot_io_opts *snapshot_io_opts,
 			struct bpos work_pos,
@@ -552,22 +576,23 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 
 	*opts_ret = opts;
 
+	unsigned move_ptrs	= 0;
+	unsigned compress_ptrs	= 0;
+	unsigned csum_ptrs	= 0;
+	struct bch_extent_rebalance r =
+		bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &csum_ptrs, false);
+
 	memset(data_opts, 0, sizeof(*data_opts));
-	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, opts, k);
+	data_opts->rewrite_ptrs		= move_ptrs|compress_ptrs|csum_ptrs;
 	data_opts->target		= opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_only_specified_devs;
 
-	if (!data_opts->rewrite_ptrs) {
-		/*
-		 * device we would want to write to offline? devices in target
-		 * changed?
-		 *
-		 * We'll now need a full scan before this extent is picked up
-		 * again:
-		 */
-		int ret = bch2_bkey_clear_needs_rebalance(trans, extent_iter, k);
-		if (ret)
-			return bkey_s_c_err(ret);
+	if (!data_opts->rewrite_ptrs &&
+	    !data_opts->kill_ptrs &&
+	    !data_opts->kill_ec_ptrs &&
+	    !data_opts->extra_replicas) {
+		/* XXX: better error message */
+		bch_err(c, "goto extent to rebalance but nothing to do, confused");
 		return bkey_s_c_null;
 	}
 
@@ -577,13 +602,6 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 		bch2_bkey_val_to_text(&buf, c, k);
 		prt_newline(&buf);
 
-		unsigned move_ptrs	= 0;
-		unsigned compress_ptrs	= 0;
-		unsigned csum_ptrs	= 0;
-		u64 sectors		= 0;
-
-		bch2_bkey_needs_rebalance(c, k, opts, &move_ptrs, &compress_ptrs, &csum_ptrs, &sectors);
-
 		if (move_ptrs) {
 			prt_str(&buf, "move=");
 			bch2_target_to_text(&buf, c, opts->background_target);
@@ -671,6 +689,7 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 
 static int do_rebalance_scan_indirect(struct btree_trans *trans,
 				      struct bkey_s_c_reflink_p p,
+				      struct per_snapshot_io_opts *snapshot_io_opts,
 				      struct bch_inode_opts *opts)
 {
 	u64 idx = REFLINK_P_IDX(p.v) - le32_to_cpu(p.v->front_pad);
@@ -681,7 +700,7 @@ static int do_rebalance_scan_indirect(struct btree_trans *trans,
 				     POS(0, idx), BTREE_ITER_not_extents, k, ({
 		if (bpos_ge(bkey_start_pos(k.k), POS(0, end)))
 			break;
-		bch2_get_update_rebalance_opts(trans, opts, &iter, k,
+		bch2_get_update_rebalance_opts(trans, snapshot_io_opts, opts, &iter, k,
 					       SET_NEEDS_REBALANCE_opt_change_indirect);
 	}));
 	if (ret)
@@ -726,7 +745,8 @@ static int do_rebalance_scan(struct moving_context *ctxt,
 		(inum &&
 		 k.k->type == KEY_TYPE_reflink_p &&
 		 REFLINK_P_MAY_UPDATE_OPTIONS(bkey_s_c_to_reflink_p(k).v)
-		 ? do_rebalance_scan_indirect(trans, bkey_s_c_to_reflink_p(k), opts)
+		 ? do_rebalance_scan_indirect(trans, bkey_s_c_to_reflink_p(k),
+					      snapshot_io_opts, opts)
 		 : 0);
 	})) ?:
 	commit_do(trans, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
@@ -1047,8 +1067,7 @@ static int check_rebalance_work_one(struct btree_trans *trans,
 		extent_k.k = &deleted;
 	}
 
-	bool should_have_rebalance =
-		bch2_bkey_sectors_need_rebalance(c, extent_k) != 0;
+	bool should_have_rebalance = bch2_bkey_needs_rb(extent_k);
 	bool have_rebalance = rebalance_k.k->type == KEY_TYPE_set;
 
 	if (should_have_rebalance != have_rebalance) {
diff --git a/fs/bcachefs/rebalance.h b/fs/bcachefs/rebalance.h
index fd873894c8b6..dde7e4cb9533 100644
--- a/fs/bcachefs/rebalance.h
+++ b/fs/bcachefs/rebalance.h
@@ -10,7 +10,7 @@
 static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_fs *c,
 								    struct bch_inode_opts *opts)
 {
-	struct bch_extent_rebalance r = {
+	return (struct bch_extent_rebalance) {
 		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
 #define x(_name)							\
 		._name = opts->_name,					\
@@ -18,15 +18,15 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_f
 		BCH_REBALANCE_OPTS()
 #undef x
 	};
-
-	if (r.background_target &&
-	    !bch2_target_accepts_data(c, BCH_DATA_user, r.background_target))
-		r.background_target = 0;
-
-	return r;
 };
 
-u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
+const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
+
+static inline int bch2_bkey_needs_rb(struct bkey_s_c k)
+{
+	const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
+	return r ? r->need_rb : 0;
+}
 
 /* Inodes in different snapshots may have different IO options: */
 struct snapshot_io_opts_entry {
@@ -36,6 +36,9 @@ struct snapshot_io_opts_entry {
 
 struct per_snapshot_io_opts {
 	u64			cur_inum;
+	bool			fs_scan_cookie;
+	bool			inum_scan_cookie;
+
 	struct bch_inode_opts	fs_io_opts;
 	DARRAY(struct snapshot_io_opts_entry) d;
 };
@@ -60,7 +63,7 @@ enum set_needs_rebalance_ctx {
 
 int bch2_bkey_set_needs_rebalance(struct btree_trans *,
 				  struct per_snapshot_io_opts *, struct bch_inode_opts *,
-				  struct bkey_i *, enum set_needs_rebalance_ctx, u32);
+				  struct bkey_i *, enum set_needs_rebalance_ctx, unsigned);
 
 struct bch_inode_opts *bch2_extent_get_apply_io_opts(struct btree_trans *,
 			  struct per_snapshot_io_opts *, struct bpos,
diff --git a/fs/bcachefs/rebalance_format.h b/fs/bcachefs/rebalance_format.h
index ff9a1342a22b..c744a29c8fa5 100644
--- a/fs/bcachefs/rebalance_format.h
+++ b/fs/bcachefs/rebalance_format.h
@@ -2,52 +2,64 @@
 #ifndef _BCACHEFS_REBALANCE_FORMAT_H
 #define _BCACHEFS_REBALANCE_FORMAT_H
 
+/* subset of BCH_INODE_OPTS */
+#define BCH_REBALANCE_OPTS()			\
+	x(data_replicas)			\
+	x(data_checksum)			\
+	x(erasure_code)				\
+	x(background_compression)		\
+	x(background_target)			\
+	x(promote_target)
+
+enum bch_rebalance_opts {
+#define x(n)	BCH_REBALANCE_##n,
+	BCH_REBALANCE_OPTS()
+#undef x
+};
+
 struct bch_extent_rebalance {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u64			type:6,
-				unused:3,
+				unused:5,
+				hipri:1,
+				pending:1,
+				need_rb:5,
 
-				promote_target_from_inode:1,
-				erasure_code_from_inode:1,
+				data_replicas_from_inode:1,
 				data_checksum_from_inode:1,
+				erasure_code_from_inode:1,
 				background_compression_from_inode:1,
-				data_replicas_from_inode:1,
 				background_target_from_inode:1,
+				promote_target_from_inode:1,
 
-				promote_target:16,
-				erasure_code:1,
+				data_replicas:3,
 				data_checksum:4,
-				data_replicas:4,
+				erasure_code:1,
 				background_compression:8, /* enum bch_compression_opt */
-				background_target:16;
+				background_target:12,
+				promote_target:12;
 #elif defined (__BIG_ENDIAN_BITFIELD)
-	__u64			background_target:16,
+	__u64			promote_target:12,
+				background_target:12,
 				background_compression:8,
-				data_replicas:4,
-				data_checksum:4,
 				erasure_code:1,
-				promote_target:16,
+				data_checksum:4,
+				data_replicas:3,
 
+				promote_target_from_inode:1,
 				background_target_from_inode:1,
-				data_replicas_from_inode:1,
 				background_compression_from_inode:1,
-				data_checksum_from_inode:1,
 				erasure_code_from_inode:1,
-				promote_target_from_inode:1,
+				data_checksum_from_inode:1,
+				data_replicas_from_inode:1,
 
-				unused:3,
+				need_rb:5,
+				pending:1,
+				hipri:1,
+				unused:5,
 				type:6;
 #endif
 };
 
-/* subset of BCH_INODE_OPTS */
-#define BCH_REBALANCE_OPTS()			\
-	x(data_checksum)			\
-	x(background_compression)		\
-	x(data_replicas)			\
-	x(promote_target)			\
-	x(background_target)			\
-	x(erasure_code)
-
 #endif /* _BCACHEFS_REBALANCE_FORMAT_H */
 
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 269cdf1a87a4..915c3201fe16 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -1331,11 +1331,6 @@ DEFINE_EVENT(fs_str, io_move_pred,
 	TP_ARGS(c, str)
 );
 
-DEFINE_EVENT(fs_str, io_move_created_rebalance,
-	TP_PROTO(struct bch_fs *c, const char *str),
-	TP_ARGS(c, str)
-);
-
 DEFINE_EVENT(fs_str, io_move_evacuate_bucket,
 	TP_PROTO(struct bch_fs *c, const char *str),
 	TP_ARGS(c, str)
-- 
2.50.1

