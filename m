Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF6C1CEEBB
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 03:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729482090; cv=none; b=JPkGhq8hZGfYS6Yt4u6BW5SlBfv1eiXmi8oEsoeX4JAyudKsK6x8x5RLqhZZnXeSCjzm5HBe1E6SUVhaaE7W6Ao7KR6HXkg6uZp2FqHyQRpvpQ3GgHYfoWWHyIVpsPv9R4K+/0tcjEZB+nnWeUjqHCxGu0+FSm2JdbKi5v3RcCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729482090; c=relaxed/simple;
	bh=V+C4HY+Z8vSkycd7nVBBK4dmzn2ZIJH6u+M+NvYgC4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLKtS91sOdC1WtGinY4FoKxklVQ7HrA5NcIsy3Z6KVNttkZwRyTk0rhjuXaBVzzZlm8FqSjcdoeQJ+75OQk1ASP6mz13nu2tYcJrPMDfpmWWzb3hHqq89nCbf/LA0dglYfgJeg26Qwj9PWp6ZPeGmc1rZJCJoT/Ti2gEs/55KTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cfpiyB6w; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cfpiyB6w"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729482086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y5NRmciOHj6J4cICDU/2148ul+PN2oYa/U4HFy5YpDM=;
	b=cfpiyB6wUxiiz5zdEfwPCmeE4hUHFLeAHBDbgWOp6fVVi1Gf3fvHdP/I7ZJRnaINPpHnES
	6FxGCYjB8Q4VJwMd+llM+9T9st5i2JakFBHjF4CBEyeca44k15LLALxExiQW6BSjMCQy/B
	4a4XqeuynybSSfxMxLO36cbDEiMc7Ts=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/12] bcachefs: io_opts_to_rebalance_opts()
Date: Sun, 20 Oct 2024 23:40:59 -0400
Message-ID: <20241021034106.384756-9-kent.overstreet@linux.dev>
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

New helper to simplify bch2_bkey_set_needs_rebalance()

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/data_update.c    |  2 +-
 fs/bcachefs/extents.c        | 60 ++++++++++--------------------------
 fs/bcachefs/extents.h        |  3 +-
 fs/bcachefs/extents_format.h |  5 +++
 fs/bcachefs/io_misc.c        |  2 +-
 fs/bcachefs/io_write.c       |  2 +-
 fs/bcachefs/opts.h           | 13 ++++++++
 fs/bcachefs/reflink.c        |  2 +-
 8 files changed, 39 insertions(+), 50 deletions(-)

diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 90da57a26962..e4af2ccdf4c8 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -357,7 +357,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 						k.k->p, bkey_start_pos(&insert->k)) ?:
 			bch2_insert_snapshot_whiteouts(trans, m->btree_id,
 						k.k->p, insert->k.p) ?:
-			bch2_bkey_set_needs_rebalance(c, insert, &op->opts) ?:
+			bch2_bkey_set_needs_rebalance(c, &op->opts, insert) ?:
 			bch2_trans_update(trans, &iter, insert,
 				BTREE_UPDATE_internal_snapshot_node) ?:
 			bch2_trans_commit(trans, &op->res,
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 132669ee7aaa..b12c251669f9 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -1475,55 +1475,27 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 	return sectors;
 }
 
-int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bkey_i *_k,
-				  struct bch_io_opts *opts)
+int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_io_opts *opts,
+				  struct bkey_i *_k)
 {
-	struct bkey_s k = bkey_i_to_s(_k);
-	struct bch_extent_rebalance *r;
-	unsigned target = opts->background_target;
-	unsigned compression = opts->background_compression;
-	bool needs_rebalance;
-
-	if (!bkey_extent_is_direct_data(k.k))
+	if (!bkey_extent_is_direct_data(&_k->k))
 		return 0;
 
-	/* get existing rebalance entry: */
-	r = (struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
-	if (r) {
-		if (k.k->type == KEY_TYPE_reflink_v) {
-			/*
-			 * indirect extents: existing options take precedence,
-			 * so that we don't move extents back and forth if
-			 * they're referenced by different inodes with different
-			 * options:
-			 */
-			if (r->background_target)
-				target = r->background_target;
-			if (r->background_compression)
-				compression = r->background_compression;
+	struct bkey_s k = bkey_i_to_s(_k);
+	struct bch_extent_rebalance *old =
+		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
+
+	if (k.k->type == KEY_TYPE_reflink_v ||
+	    bch2_bkey_ptrs_need_rebalance(c, k.s_c, opts->background_target, opts->background_compression)) {
+		if (!old) {
+			old = bkey_val_end(k);
+			k.k->u64s += sizeof(*old) / sizeof(u64);
 		}
 
-		r->background_target		= target;
-		r->background_compression	= compression;
-	}
-
-	needs_rebalance = bch2_bkey_ptrs_need_rebalance(c, k.s_c, target, compression);
-
-	if (needs_rebalance && !r) {
-		union bch_extent_entry *new = bkey_val_end(k);
-
-		new->rebalance.type			= 1U << BCH_EXTENT_ENTRY_rebalance;
-		new->rebalance.background_compression	= compression;
-		new->rebalance.background_target	= target;
-		new->rebalance.unused			= 0;
-		k.k->u64s += extent_entry_u64s(new);
-	} else if (!needs_rebalance && r && k.k->type != KEY_TYPE_reflink_v) {
-		/*
-		 * For indirect extents, don't delete the rebalance entry when
-		 * we're finished so that we know we specifically moved it or
-		 * compressed it to its current location/compression type
-		 */
-		extent_entry_drop(k, (union bch_extent_entry *) r);
+		*old = io_opts_to_rebalance_opts(opts);
+	} else {
+		if (old)
+			extent_entry_drop(k, (union bch_extent_entry *) old);
 	}
 
 	return 0;
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 9374599b384d..97af0d6e4319 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -715,8 +715,7 @@ unsigned bch2_bkey_ptrs_need_rebalance(struct bch_fs *, struct bkey_s_c,
 				       unsigned, unsigned);
 u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *, struct bkey_s_c);
 
-int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bkey_i *,
-				  struct bch_io_opts *);
+int bch2_bkey_set_needs_rebalance(struct bch_fs *, struct bch_io_opts *, struct bkey_i *);
 
 /* Generic extent code: */
 
diff --git a/fs/bcachefs/extents_format.h b/fs/bcachefs/extents_format.h
index 2cc3e60f3b12..520697f236c0 100644
--- a/fs/bcachefs/extents_format.h
+++ b/fs/bcachefs/extents_format.h
@@ -215,6 +215,11 @@ struct bch_extent_rebalance {
 #endif
 };
 
+/* subset of BCH_INODE_OPTS */
+#define BCH_REBALANCE_OPTS()			\
+	x(background_compression)		\
+	x(background_target)
+
 union bch_extent_entry {
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__ ||  __BITS_PER_LONG == 64
 	unsigned long			type;
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index f283051758d6..e2acf21ac9b0 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -461,7 +461,7 @@ case LOGGED_OP_FINSERT_shift_extents:
 
 		op->v.pos = cpu_to_le64(insert ? bkey_start_offset(&delete.k) : delete.k.p.offset);
 
-		ret =   bch2_bkey_set_needs_rebalance(c, copy, &opts) ?:
+		ret =   bch2_bkey_set_needs_rebalance(c, &opts, copy) ?:
 			bch2_btree_insert_trans(trans, BTREE_ID_extents, &delete, 0) ?:
 			bch2_btree_insert_trans(trans, BTREE_ID_extents, copy, 0) ?:
 			bch2_logged_op_update(trans, &op->k_i) ?:
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 8609e25e450f..a6b7d97540db 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -369,7 +369,7 @@ static int bch2_write_index_default(struct bch_write_op *op)
 				     bkey_start_pos(&sk.k->k),
 				     BTREE_ITER_slots|BTREE_ITER_intent);
 
-		ret =   bch2_bkey_set_needs_rebalance(c, sk.k, &op->opts) ?:
+		ret =   bch2_bkey_set_needs_rebalance(c, &op->opts, sk.k) ?:
 			bch2_extent_update(trans, inum, &iter, sk.k,
 					&op->res,
 					op->new_i_size, &op->i_sectors_delta,
diff --git a/fs/bcachefs/opts.h b/fs/bcachefs/opts.h
index dd27ef556611..13555bc35f00 100644
--- a/fs/bcachefs/opts.h
+++ b/fs/bcachefs/opts.h
@@ -642,4 +642,17 @@ static inline void bch2_io_opts_fixups(struct bch_io_opts *opts)
 struct bch_io_opts bch2_opts_to_inode_opts(struct bch_opts);
 bool bch2_opt_is_inode_opt(enum bch_opt_id);
 
+/* rebalance opts: */
+
+static inline struct bch_extent_rebalance io_opts_to_rebalance_opts(struct bch_io_opts *opts)
+{
+	return (struct bch_extent_rebalance) {
+		.type = BIT(BCH_EXTENT_ENTRY_rebalance),
+#define x(_name)							\
+		._name = opts->_name,
+		BCH_REBALANCE_OPTS()
+#undef x
+	};
+};
+
 #endif /* _BCACHEFS_OPTS_H */
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index f457925fa362..8a36ebd9dd9c 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -547,7 +547,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 				min(src_k.k->p.offset - src_want.offset,
 				    dst_end.offset - dst_iter.pos.offset));
 
-		ret =   bch2_bkey_set_needs_rebalance(c, new_dst.k, &opts) ?:
+		ret =   bch2_bkey_set_needs_rebalance(c, &opts, new_dst.k) ?:
 			bch2_extent_update(trans, dst_inum, &dst_iter,
 					new_dst.k, &disk_res,
 					new_i_size, i_sectors_delta,
-- 
2.45.2

