Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6772D978B
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Aug 2025 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756039103; cv=none; b=CPiTL21LF9C4JXeoq7hBexslNOuiBIhfrkLkyJR1hmU/QjtSsA68pQHIr/DyUHtabt4WrTs8oYv+HyoR/TV+Pws58xRcutYcgCPLlzVKQTvIw8n97/SW3RPsU27xRpgK8f0Dj26kMHl3qHWIQ36OtmIHRRph4K3+XdaCXDaTj+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756039103; c=relaxed/simple;
	bh=H9B7Qgjl/jGd06bQ8m+sMuwplS4lNbXL01/IDUjzuWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b81a2XmbXzqiMCKi6Gd7uHvfFvdvrCWmJfxC8b8f7g47RudTKwbGs0ji6Z3naYjEBvDVYXBamFmGDlTbr6jWie8cEmOcQqn1EngGmoZdxrL+CpPE6egLmPwy1up/1cWf7SgihYFsxA06D4OSe2TZ0ebw/qsMCuURYOO6j2460kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oYnaLl10; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oYnaLl10"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756039096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=00yjHRcJoJKCgNE6w5FXp7ZUQRXmATwJJiaIMDJWGtI=;
	b=oYnaLl10Zmab2E267sQBWyh3Bo53BxB5us5NC77+Rhxk1nZA2r2GjS+wYKOveYX7lwCTbU
	wZ/isSw701wSRg0DQ0/DP8Ef+/0eR8+iVPLXowH3Lw2I4Po4ljtpo2tgqnL8Gen1oUYeAm
	d6BaStbfG/mN+2gQABDBgVqUYQDyAOo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 14/21] bcachefs: Consistency checking for bch_extent_rebalance opts
Date: Sun, 24 Aug 2025 08:37:51 -0400
Message-ID: <20250824123800.1617669-15-kent.overstreet@linux.dev>
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

bch2_get_update_rebalance_opts() now checks for consistency between
bch_extent_rebalance and the io path options from the inode and
filesystem; unless an option has been recently changed (and a scan to
propagate new options queued), they should match.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/rebalance.c        | 65 +++++++++++++++++++++++++++++++---
 fs/bcachefs/sb-errors_format.h |  3 +-
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index a2fb2f1cec70..872fff940c5a 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -25,6 +25,8 @@
 #include <linux/kthread.h>
 #include <linux/sched/cputime.h>
 
+#define REBALANCE_WORK_SCAN_OFFSET	(U64_MAX - 1)
+
 /* bch_extent_rebalance: */
 
 static const struct bch_extent_rebalance *bch2_bkey_ptrs_rebalance_opts(struct bkey_ptrs_c ptrs)
@@ -178,6 +180,35 @@ int bch2_bkey_set_needs_rebalance(struct bch_fs *c, struct bch_inode_opts *opts,
 	return 0;
 }
 
+static int have_rebalance_scan_cookie(struct btree_trans *trans, u64 inum)
+{
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
+	if (k.k->type == KEY_TYPE_cookie)
+		return 1;
+
+	if (!inum)
+		return 0;
+
+	bch2_btree_iter_set_pos(&iter, SPOS(0, REBALANCE_WORK_SCAN_OFFSET, U32_MAX));
+	k = bch2_btree_iter_peek_slot(&iter);
+	ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	return k.k->type == KEY_TYPE_cookie;
+}
+
 static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 					  struct bch_inode_opts *io_opts,
 					  struct btree_iter *iter,
@@ -185,6 +216,7 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 					  enum set_needs_rebalance_ctx ctx)
 {
 	struct bch_fs *c = trans->c;
+	int ret = 0;
 
 	BUG_ON(iter->flags & BTREE_ITER_is_extents);
 	BUG_ON(iter->flags & BTREE_ITER_filter_snapshots);
@@ -220,8 +252,33 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 	    : !old)
 		return 0;
 
+	if (k.k->type != KEY_TYPE_reflink_v) {
+		ret = have_rebalance_scan_cookie(trans, k.k->p.inode);
+		if (ret < 0)
+			return ret;
+
+		if (!ret) {
+			CLASS(printbuf, buf)();
+
+			prt_printf(&buf, "extent with incorrect/missing rebalance opts:\n");
+			bch2_bkey_val_to_text(&buf, c, k);
+
+			const struct bch_extent_rebalance _old = {};
+			if (!old)
+				old = &_old;
+#define x(_name)								\
+			if (old->_name != new._name)				\
+				prt_printf(&buf, "\n" #_name " %u != %u",	\
+					   old->_name, new._name);		\
+			BCH_REBALANCE_OPTS()
+#undef x
+
+			fsck_err(trans, extent_io_opts_not_set, "%s", buf.buf);
+		}
+	}
+
 	struct bkey_i *n = bch2_trans_kmalloc(trans, bkey_bytes(k.k) + 8);
-	int ret = PTR_ERR_OR_ZERO(n);
+	ret = PTR_ERR_OR_ZERO(n);
 	if (ret)
 		return ret;
 
@@ -229,10 +286,12 @@ static int bch2_get_update_rebalance_opts(struct btree_trans *trans,
 
 	/* On successfull transaction commit, @k was invalidated: */
 
-	return bch2_bkey_set_needs_rebalance(c, io_opts, n, ctx, 0) ?:
+	ret = bch2_bkey_set_needs_rebalance(c, io_opts, n, ctx, 0) ?:
 		bch2_trans_update(trans, iter, n, BTREE_UPDATE_internal_snapshot_node) ?:
 		bch2_trans_commit(trans, NULL, NULL, 0) ?:
 		bch_err_throw(c, transaction_restart_commit);
+fsck_err:
+	return ret;
 }
 
 static struct bch_inode_opts *bch2_extent_get_io_opts(struct btree_trans *trans,
@@ -335,8 +394,6 @@ int bch2_extent_get_io_opts_one(struct btree_trans *trans,
 					      ctx);
 }
 
-#define REBALANCE_WORK_SCAN_OFFSET	(U64_MAX - 1)
-
 static const char * const bch2_rebalance_state_strs[] = {
 #define x(t) #t,
 	BCH_REBALANCE_STATES()
diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
index aa0ea1ec9f10..4816c4150261 100644
--- a/fs/bcachefs/sb-errors_format.h
+++ b/fs/bcachefs/sb-errors_format.h
@@ -337,7 +337,8 @@ enum bch_fsck_flags {
 	x(dirent_stray_data_after_cf_name,			305,	0)		\
 	x(rebalance_work_incorrectly_set,			309,	FSCK_AUTOFIX)	\
 	x(rebalance_work_incorrectly_unset,			310,	FSCK_AUTOFIX)	\
-	x(MAX,							326,	0)
+	x(extent_io_opts_not_set,				326,	FSCK_AUTOFIX)	\
+	x(MAX,							327,	0)
 
 enum bch_sb_error_id {
 #define x(t, n, ...) BCH_FSCK_ERR_##t = n,
-- 
2.50.1

