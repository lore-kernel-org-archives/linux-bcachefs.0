Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B43197531
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482092; cv=none; b=VAMbO+HGdNS409rEyfswN/Co2UX9eJ+iYGXQn4yCz8dWs7/8f8vIA2U3if3bgPv4sF6gKjK2N39TZIaJVqNS2yld5LNSvXzlErt1KHb/6mJllpa+PW9kOAiie+BIVE6zyFro611LaTH2x/X3rUVuC+aHqGWCasom8K7SK/kpVDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482092; c=relaxed/simple;
	bh=Osz067ihqFKmom4yx/9Zwi7cGj9qdrsvoqWMonoHv0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUHSzL6/2/7fkRRCDdaEB2i1EcFYw61T2c2Iq5MaV/wXs/Rbg1VZbTrgLbDvQhUw/V+sOPOvB/TYTGLBOejJzVRrqD4isiDhDyI6Y5RHyAmvkSH5BWPQNcV0V6ohwuAvOXh7uAbzQ701HVghpNsXOYmRiu8YRCh6a2TgHdWvpEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GHhl6JYy; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GHhl6JYy"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbwstcZ0po+QUQW1jjX0V1VOWiHVTMUuGwM/e6AqakM=;
	b=GHhl6JYys4tVyE+7QiqM89n/FKJ+BUMtwbWQnYB7IC0ghlyBIkMwo20Ix9ADcDZ+u/DjOa
	vyzJ6Y2djyZL8dmcDC3gRNr0FQL6PHO9zB2ouBjHgE77OpLnRNqHtrDMp0zgoue8Vugkdn
	YkTlSyZZ95vADHjYYWCzTiRY+zLlFaM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 10/12] bcachefs: New bch_extent_rebalance fields
Date: Sun, 20 Oct 2024 23:41:01 -0400
Message-ID: <20241021034106.384756-11-kent.overstreet@linux.dev>
In-Reply-To: <20241021034106.384756-1-kent.overstreet@linux.dev>
References: <20241021034106.384756-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

- Add more io path options to bch_extent_rebalance
- For each option, track whether it came from the filesystem or the
  inode

This lets us do some new things:

bch2_move_get_io_opts() now synchronizes options loaded from the
filesystem and inode (if present, i.e. not walking the reflink btree
directly) with options from the bch_extent_rebalance_entry, updating the
extent if necessary.

Since bch_extent_rebalance tracks where its option came from we can
preserve "inode options override filesystem options", even for indirect
extents where we don't have access to the inode the options came from.

Since bch2_move_get_io_opts() now synchronizes io_opts with options from
bch_extent_rebalance, that also lets us delete the ad-hoc logic in
rebalance.c that previously did this.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/extents.c        | 33 ++++++++++----
 fs/bcachefs/extents.h        |  4 +-
 fs/bcachefs/extents_format.h | 34 ++++++++++++--
 fs/bcachefs/move.c           | 88 ++++++++++++++++++++++++++----------
 fs/bcachefs/move.h           |  5 +-
 fs/bcachefs/opts.h           |  3 +-
 fs/bcachefs/rebalance.c      | 44 +++++-------------
 7 files changed, 138 insertions(+), 73 deletions(-)

diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index b12c251669f9..be39318ca298 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1401,14 +1401,15 @@ const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c k)
 	return NULL;
 }
 
-unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
-				       unsigned target, unsigned compression)
+unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c,
+				       struct bch_io_opts *opts,
+				       struct bkey_s_c k)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	unsigned rewrite_ptrs = 0;
 
-	if (compression) {
-		unsigned compression_type = bch2_compression_opt_to_type(compression);
+	if (opts->background_compression) {
+		unsigned compression_type = bch2_compression_opt_to_type(opts->background_compression);
 		const union bch_extent_entry *entry;
 		struct extent_ptr_decoded p;
 		unsigned ptr_bit = 1;
@@ -1426,11 +1427,12 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *c, struct bkey_s_c k,
 		}
 	}
 incompressible:
-	if (target && bch2_target_accepts_data(c, BCH_DATA_user, target)) {
+	if (opts->background_target &&
+	    bch2_target_accepts_data(c, BCH_DATA_user, opts->background_target)) {
 		unsigned ptr_bit = 1;
 
 		bkey_for_each_ptr(ptrs, ptr) {
-			if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, target))
+			if (!ptr->cached && !bch2_dev_in_target(c, ptr->dev, opts->background_target))
 				rewrite_ptrs |= ptr_bit;
 			ptr_bit <<= 1;
 		}
@@ -1475,6 +1477,22 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 	return sectors;
 }
 
+bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_io_opts *opts,
+				      struct bkey_s_c k)
+{
+	if (!bkey_extent_is_direct_data(k.k))
+		return 0;
+
+	const struct bch_extent_rebalance *old = bch2_bkey_rebalance_opts(k);
+
+	if (k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k)) {
+		struct bch_extent_rebalance new = io_opts_to_rebalance_opts(opts);
+		return old == NULL || memcmp(old, &new, sizeof(new));
+	} else {
+		return old != NULL;
+	}
+}
+
 int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
 				  struct bkey_i *_k)
 {
@@ -1485,8 +1503,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
 	struct bch_extent_rebalance *old =
 		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
 
-	if (k.k->type == KEY_TYPE_reflink_v ||
-	    bch2_bkey_ptrs_need_rebalance(c, k.s_c, opts->background_target, opts->background_compression)) {
+	if (k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k.s_c)) {
 		if (!old) {
 			old = bkey_val_end(k);
 			k.k->u64s += sizeof(*old) / sizeof(u64);
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 97af0d6e4319..156fbb8e04d5 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -711,10 +711,10 @@ static inline bool bch2_extent_ptr_eq(struct bch_extent_ptr ptr1,
 void bch2_ptr_swab(struct bkey_s);
 
 const struct bch_extent_rebalance *bch2_bkey_rebalance_opts(struct bkey_s_c);
-unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *, struct bkey_s_c,
-				       unsigned, unsigned);
+unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *, struct bch_io_opts *, struct bkey_s_c);
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
 
+bool bch2_bkey_rebalance_needs_update(struct bch_fs *, struct bch_io_opts *, struct bkey_s_c);
 int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_io_opts *, struct bkey_i *);
 
 /* Generic extent code: */
diff --git a/fs/bcachefs/extents_format.h b/fs/bcachefs/extents_format.h
index 520697f236c0..222eed6b46d8 100644
--- a/fs/bcachefs/extents_format.h
+++ b/fs/bcachefs/extents_format.h
@@ -204,21 +204,49 @@ struct bch_extent_stripe_ptr {
 struct bch_extent_rebalance {
 #if defined(__LITTLE_ENDIAN_BITFIELD)
 	__u64			type:6,
-				unused:34,
+				unused:3,
+
+				promote_target_from_inode:1,
+				erasure_code_from_inode:1,
+				data_checksum_from_inode:1,
+				background_compression_from_inode:1,
+				data_replicas_from_inode:1,
+				background_target_from_inode:1,
+
+				promote_target:16,
+				erasure_code:1,
+				data_checksum:4,
+				data_replicas:4,
 				background_compression:8, /* enum bch_compression_opt */
 				background_target:16;
 #elif defined (__BIG_ENDIAN_BITFIELD)
 	__u64			background_target:16,
 				background_compression:8,
-				unused:34,
+				data_replicas:4,
+				data_checksum:4,
+				erasure_code:1,
+				promote_target:16,
+
+				background_target_from_inode:1,
+				data_replicas_from_inode:1,
+				background_compression_from_inode:1,
+				data_checksum_from_inode:1,
+				erasure_code_from_inode:1,
+				promote_target_from_inode:1,
+
+				unused:3,
 				type:6;
 #endif
 };
 
 /* subset of BCH_INODE_OPTS */
 #define BCH_REBALANCE_OPTS()			\
+	x(data_checksum)			\
 	x(background_compression)		\
-	x(background_target)
+	x(data_replicas)			\
+	x(promote_target)			\
+	x(background_target)			\
+	x(erasure_code)
 
 union bch_extent_entry {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__ ||  __BITS_PER_LONG == 64
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 0ef4a86850bb..060c0b8fc6d1 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -379,14 +379,51 @@ int bch2_move_extent(struct moving_context *ctxt,
 	return ret;
 }
 
-struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
+static int get_update_rebalance_opts(struct btree_trans *trans,
+				     struct bch_io_opts *io_opts,
+				     struct btree_iter *iter,
+				     struct bkey_s_c k)
+{
+	BUG_ON(iter->flags & BTREE_ITER_is_extents);
+	BUG_ON(!(iter->flags & BTREE_ITER_all_snapshots));
+
+	const struct bch_extent_rebalance *r = k.k->type == KEY_TYPE_reflink_v
+		? bch2_bkey_rebalance_opts(k) : NULL;
+	if (r) {
+#define x(_name)							\
+		if (r->_name##_from_inode) {				\
+			io_opts->_name = r->_name;			\
+			io_opts->_name##_from_inode = true;		\
+		}
+		BCH_REBALANCE_OPTS()
+#undef x
+	}
+
+	if (!bch2_bkey_rebalance_needs_update(trans->c, io_opts, k))
+		return 0;
+
+	struct bkey_i *n = __bch2_bkey_make_mut(trans,
+					iter, &k,
+					BTREE_UPDATE_internal_snapshot_node,
+					0, bkey_bytes(k.k) + 8);
+	return  PTR_ERR_OR_ZERO(n) ?:
+		bch2_bkey_set_needs_rebalance(trans->c, io_opts, n) ?:
+		bch2_trans_commit(trans, NULL, NULL, 0);
+}
+
+static struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 			  struct per_snapshot_io_opts *io_opts,
+			  struct btree_iter *extent_iter,
 			  struct bkey_s_c extent_k)
 {
 	struct bch_fs *c = trans->c;
 	u32 restart_count = trans->restart_count;
+	struct bch_io_opts *opts_ret = &io_opts->fs_io_opts;
 	int ret = 0;
 
+	if (extent_k.k->type == KEY_TYPE_reflink_v)
+		goto out;
+
 	if (io_opts->cur_inum != extent_k.k->p.inode) {
 		io_opts->d.nr = 0;
 
@@ -415,43 +452,46 @@ struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *trans,
 
 	if (extent_k.k->p.snapshot)
 		darray_for_each(io_opts->d, i)
-			if (bch2_snapshot_is_ancestor(c, extent_k.k->p.snapshot, i->snapshot))
-				return &i->io_opts;
-
-	return &io_opts->fs_io_opts;
+			if (bch2_snapshot_is_ancestor(c, extent_k.k->p.snapshot, i->snapshot)) {
+				opts_ret = &i->io_opts;
+				break;
+			}
+out:
+	ret = get_update_rebalance_opts(trans, opts_ret, extent_iter, extent_k);
+	if (ret)
+		return ERR_PTR(ret);
+	return opts_ret;
 }
 
 int bch2_move_get_io_opts_one(struct btree_trans *trans,
 			      struct bch_io_opts *io_opts,
+			      struct btree_iter *extent_iter,
 			      struct bkey_s_c extent_k)
 {
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	int ret;
+	struct bch_fs *c = trans->c;
+
+	*io_opts = bch2_opts_to_inode_opts(c->opts);
 
 	/* reflink btree? */
-	if (!extent_k.k->p.inode) {
-		*io_opts = bch2_opts_to_inode_opts(trans->c->opts);
-		return 0;
-	}
+	if (extent_k.k->type == KEY_TYPE_reflink_v)
+		goto out;
 
-	k = bch2_bkey_get_iter(trans, &iter, BTREE_ID_inodes,
+	struct btree_iter inode_iter;
+	struct bkey_s_c inode_k = bch2_bkey_get_iter(trans, &inode_iter, BTREE_ID_inodes,
 			       SPOS(0, extent_k.k->p.inode, extent_k.k->p.snapshot),
 			       BTREE_ITER_cached);
-	ret = bkey_err(k);
+	int ret = bkey_err(inode_k);
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		return ret;
 
-	if (!ret && bkey_is_inode(k.k)) {
+	if (!ret && bkey_is_inode(inode_k.k)) {
 		struct bch_inode_unpacked inode;
-		bch2_inode_unpack(k, &inode);
-		bch2_inode_opts_get(io_opts, trans->c, &inode);
-	} else {
-		*io_opts = bch2_opts_to_inode_opts(trans->c->opts);
+		bch2_inode_unpack(inode_k, &inode);
+		bch2_inode_opts_get(io_opts, c, &inode);
 	}
-
-	bch2_trans_iter_exit(trans, &iter);
-	return 0;
+	bch2_trans_iter_exit(trans, &inode_iter);
+out:
+	return get_update_rebalance_opts(trans, io_opts, extent_iter, extent_k);
 }
 
 int bch2_move_ratelimit(struct moving_context *ctxt)
@@ -552,7 +592,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 		if (!bkey_extent_is_direct_data(k.k))
 			goto next_nondata;
 
-		io_opts = bch2_move_get_io_opts(trans, &snapshot_io_opts, k);
+		io_opts = bch2_move_get_io_opts(trans, &snapshot_io_opts, &iter, k);
 		ret = PTR_ERR_OR_ZERO(io_opts);
 		if (ret)
 			continue;
@@ -728,7 +768,7 @@ int bch2_evacuate_bucket(struct moving_context *ctxt,
 			bch2_bkey_buf_reassemble(&sk, c, k);
 			k = bkey_i_to_s_c(sk.k);
 
-			ret = bch2_move_get_io_opts_one(trans, &io_opts, k);
+			ret = bch2_move_get_io_opts_one(trans, &io_opts, &iter, k);
 			if (ret) {
 				bch2_trans_iter_exit(trans, &iter);
 				continue;
diff --git a/fs/bcachefs/move.h b/fs/bcachefs/move.h
index 9baf3093a678..51e0505a8156 100644
--- a/fs/bcachefs/move.h
+++ b/fs/bcachefs/move.h
@@ -110,9 +110,8 @@ static inline void per_snapshot_io_opts_exit(struct per_snapshot_io_opts *io_opt
 	darray_exit(&io_opts->d);
 }
 
-struct bch_io_opts *bch2_move_get_io_opts(struct btree_trans *,
-				struct per_snapshot_io_opts *, struct bkey_s_c);
-int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_io_opts *, struct bkey_s_c);
+int bch2_move_get_io_opts_one(struct btree_trans *, struct bch_io_opts *,
+			      struct btree_iter *, struct bkey_s_c);
 
 int bch2_scan_old_btree_nodes(struct bch_fs *, struct bch_move_stats *);
 
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index 918eb6730117..725de97148bc 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -652,7 +652,8 @@ static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_i
 	return (struct bch_extent_rebalance) {
 		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
 #define x(_name)							\
-		._name = opts->_name,
+		._name = opts->_name,					\
+		._name##_from_inode = opts->_name##_from_inode,
 		BCH_REBALANCE_OPTS()
 #undef x
 	};
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index dc70e6feaf79..d094dcd72fb4 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -134,31 +134,27 @@ static int bch2_bkey_clear_needs_rebalance(struct btree_trans *trans,
 static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 			struct bpos work_pos,
 			struct btree_iter *extent_iter,
+			struct bch_io_opts *io_opts,
 			struct data_update_opts *data_opts)
 {
 	struct bch_fs *c = trans->c;
-	struct bkey_s_c k;
 
 	bch2_trans_iter_exit(trans, extent_iter);
 	bch2_trans_iter_init(trans, extent_iter,
 			     work_pos.inode ? BTREE_ID_extents : BTREE_ID_reflink,
 			     work_pos,
 			     BTREE_ITER_all_snapshots);
-	k = bch2_btree_iter_peek_slot(extent_iter);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(extent_iter);
 	if (bkey_err(k))
 		return k;
 
-	const struct bch_extent_rebalance *r = k.k ? bch2_bkey_rebalance_opts(k) : NULL;
-	if (!r) {
-		/* raced due to btree write buffer, nothing to do */
-		return bkey_s_c_null;
-	}
+	int ret = bch2_move_get_io_opts_one(trans, io_opts, extent_iter, k);
+	if (ret)
+		return bkey_s_c_err(ret);
 
 	memset(data_opts, 0, sizeof(*data_opts));
-
-	data_opts->rewrite_ptrs		=
-		bch2_bkey_ptrs_need_rebalance(c, k, r->background_target, r->background_compression);
-	data_opts->target		= r->background_target;
+	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, io_opts, k);
+	data_opts->target		= io_opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_ONLY_SPECIFIED_DEVS;
 
 	if (!data_opts->rewrite_ptrs) {
@@ -179,9 +175,9 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 		struct printbuf buf = PRINTBUF;
 
 		prt_str(&buf, "target=");
-		bch2_target_to_text(&buf, c, r->background_target);
+		bch2_target_to_text(&buf, c, io_opts->background_target);
 		prt_str(&buf, " compression=");
-		bch2_compression_opt_to_text(&buf, r->background_compression);
+		bch2_compression_opt_to_text(&buf, io_opts->background_compression);
 		prt_str(&buf, " ");
 		bch2_bkey_val_to_text(&buf, c, k);
 
@@ -212,14 +208,10 @@ static int do_rebalance_extent(struct moving_context *ctxt,
 	bch2_bkey_buf_init(&sk);
 
 	ret = bkey_err(k = next_rebalance_extent(trans, work_pos,
-						 extent_iter, &data_opts));
+				extent_iter, &io_opts, &data_opts));
 	if (ret || !k.k)
 		goto out;
 
-	ret = bch2_move_get_io_opts_one(trans, &io_opts, k);
-	if (ret)
-		goto out;
-
 	atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
 
 	/*
@@ -253,20 +245,8 @@ static bool rebalance_pred(struct bch_fs *c, void *arg,
 			   struct bch_io_opts *io_opts,
 			   struct data_update_opts *data_opts)
 {
-	unsigned target, compression;
-
-	if (k.k->p.inode) {
-		target		= io_opts->background_target;
-		compression	= io_opts->background_compression;
-	} else {
-		const struct bch_extent_rebalance *r = bch2_bkey_rebalance_opts(k);
-
-		target		= r ? r->background_target : io_opts->background_target;
-		compression	= r ? r->background_compression : io_opts->background_compression;
-	}
-
-	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, k, target, compression);
-	data_opts->target		= target;
+	data_opts->rewrite_ptrs		= bch2_bkey_ptrs_need_rebalance(c, io_opts, k);
+	data_opts->target		= io_opts->background_target;
 	data_opts->write_flags		|= BCH_WRITE_ONLY_SPECIFIED_DEVS;
 	return data_opts->rewrite_ptrs != 0;
 }
-- 
2.45.2

