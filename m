Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087132D5A14
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039102; cv=none; b=Pl2TWmbPnfbn3c2IVZPCJAGxRaS/pKCn8wPoVEGM8LJgcPtUii5t1H1aVoscqlQW9wCW89JDPRkcFXmZHJgrW0hmJHgm9/L2uPhq0YxXSTHNGgbRJHteDts+FU350yyKsjoxxI3Bs+cZyohxcaIpETVzJ3pr2bOaVu3L6mjLRh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039102; c=relaxed/simple;
	bh=3HaJit+JTEjKA7wJ/fvSI5z6+NmPVf2iGRVWIuo/i1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7i4t1l9VRAZxudsbnTs7TfvrihyUhR4F+FDZXToKz0FWAZoIjlOK+2EZwV/W1Th0DrX8NIKDnJZkH684hlsiy2JuAkbJ3XkHznWpw4hrlLVfoCKx7PMTdNXMEr+lhfu8MVjKjejtHklg+FoJpUuUPLcNsYU+Z6rgglBW/IyqYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UDq8eSNs; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UDq8eSNs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9vc+0Hm7cqggHZeZcT09TQrJQe8mK2RyK4Z96LjPRBE=;
	b=UDq8eSNsMfpVh1Wvts3Qok34ByknPinPcN296kcuIFj3jTefsvPZSJirbhcWrm2k6vi9KF
	J5ZDhWjzRzGqsqhPn0Cc3n/XUHl+YMYRkdVVjHxyJyXtUGqLqinLalgKqbxCPSQkmSRBeU
	/dh4XSqGMlTPKTbHNWAeFtW9GBcM0W0=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/21] bcachefs: bkey_should_have_rb_opts()
Date: Sun, 24 Aug 2025 08:37:48 -0400
Message-ID: <20250824123800.1617669-12-kent.overstreet@linux.dev>
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

Factor out a small helper.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c | 43 ++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 22 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 932998864ad2..9e22ff0e2d28 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -145,20 +145,11 @@ u64 bch2_bkey_sectors_need_rebalance(struct bch_fs *c, struct bkey_s_c k)
 	return sectors;
 }
 
-static bool bch2_bkey_rebalance_needs_update(struct bch_fs *c, struct bch_inode_opts *opts,
-					     struct bkey_s_c k)
+static inline bool bkey_should_have_rb_opts(struct bch_fs *c,
+					    struct bch_inode_opts *opts,
+					    struct bkey_s_c k)
 {
-	if (!bkey_extent_is_direct_data(k.k))
-		return 0;
-
-	const struct bch_extent_rebalance *old = bch2_bkey_rebalance_opts(k);
-
-	if (k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k)) {
-		struct bch_extent_rebalance new = io_opts_to_rebalance_opts(c, opts);
-		return old == NULL || memcmp(old, &new, sizeof(new));
-	} else {
-		return old != NULL;
-	}
+	return k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k);
 }
 
 int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
@@ -173,7 +164,7 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 	struct bch_extent_rebalance *old =
 		(struct bch_extent_rebalance *) bch2_bkey_rebalance_opts(k.s_c);
 
-	if (k.k->type == KEY_TYPE_reflink_v || bch2_bkey_ptrs_need_rebalance(c, opts, k.s_c)) {
+	if (bkey_should_have_rb_opts(c, opts, k.s_c)) {
 		if (!old) {
 			old = bkey_val_end(k);
 			k.k->u64s += sizeof(*old) / sizeof(u64);
@@ -194,9 +185,14 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 					  struct bkey_s_c k,
 					  enum set_needs_rebalance_ctx ctx)
 {
+	struct bch_fs *c = trans->c;
+
 	BUG_ON(iter->flags & BTREE_ITER_is_extents);
 	BUG_ON(iter->flags & BTREE_ITER_filter_snapshots);
 
+	if (!bkey_extent_is_direct_data(k.k))
+		return 0;
+
 	bool may_update_indirect = ctx == SET_NEEDS_REBALANCE_opt_change_indirect;
 
 	/*
@@ -206,20 +202,23 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 	 * the inode and may_update_indirect is true (walked from a
 	 * REFLINK_P_MAY_UPDATE_OPTIONS pointer).
 	 */
-	const struct bch_extent_rebalance *r = k.k->type == KEY_TYPE_reflink_v
-		? bch2_bkey_rebalance_opts(k) : NULL;
-	if (r) {
+	const struct bch_extent_rebalance *old = bch2_bkey_rebalance_opts(k);
+	if (old && k.k->type == KEY_TYPE_reflink_v) {
 #define x(_name)								\
-		if (r->_name##_from_inode &&					\
+		if (old->_name##_from_inode &&					\
 		    !(may_update_indirect && io_opts->_name##_from_inode)) {	\
-			io_opts->_name = r->_name;				\
+			io_opts->_name = old->_name;				\
 			io_opts->_name##_from_inode = true;			\
 		}
 		BCH_REBALANCE_OPTS()
 #undef x
 	}
 
-	if (!bch2_bkey_rebalance_needs_update(trans->c, io_opts, k))
+	struct bch_extent_rebalance new = io_opts_to_rebalance_opts(c, io_opts);
+
+	if (bkey_should_have_rb_opts(c, io_opts, k)
+	    ? old && !memcmp(old, &new, sizeof(new))
+	    : !old)
 		return 0;
 
 	struct bkey_i *n = bch2_trans_kmalloc(trans, bkey_bytes(k.k) + 8);
@@ -231,10 +230,10 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	return bch2_bkey_set_needs_rebalance(trans->c, io_opts, n, ctx, 0) ?:
+	return bch2_bkey_set_needs_rebalance(c, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
-		bch_err_throw(trans->c, transaction_restart_commit);
+		bch_err_throw(c, transaction_restart_commit);
 }
 
 static struct bch_inode_opts *bch2_extent_get_io_opts(struct btree_trans *trans,
-- 
2.50.1

