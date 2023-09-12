Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 107C2CA0EC7
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 01:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235083AbjILBhv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Sep 2023 21:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235546AbjILBhm (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Sep 2023 21:37:42 -0400
Received: from out-224.mta0.migadu.com (out-224.mta0.migadu.com [91.218.175.224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE91EADF2
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Sep 2023 17:32:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694478251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wJo1P9ymUqJNuuJ8JvWgRs2PoNCDUB0qE4s1BWESv20=;
        b=ZM1l/DerhQsF4BX03SSt+2CfBg5nMpoV/KfGwLhEouvtVLbUbSOvcAoB1uAIXNzh86wR+y
        NCsOPAMHR7k15UEZuwr3lXK+REU8V+5MNqVe+FPsAst8bulf/Qsn7oAVXQDAY3RCl/wbgh
        4b362DphnST1sAks0OaxRMkOHM3zv5c=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/3] bcachefs: BTREE_ID_logged_ops
Date:   Mon, 11 Sep 2023 20:23:54 -0400
Message-Id: <20230912002356.566674-2-kent.overstreet@linux.dev>
In-Reply-To: <20230912002356.566674-1-kent.overstreet@linux.dev>
References: <20230912002356.566674-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Add a new btree for long running logged operations - i.e. for logging
operations that we can't do within a single btree transaction, so that
they can be resumed if we crash.

Keys in the logged operations btree will represent operations in
progress, with the state of the operation stored in the value.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/Makefile          |   1 +
 fs/bcachefs/bcachefs.h        |   1 +
 fs/bcachefs/bcachefs_format.h |   4 +-
 fs/bcachefs/btree_update.c    |  18 ++++++
 fs/bcachefs/btree_update.h    |   1 +
 fs/bcachefs/logged_ops.c      | 109 ++++++++++++++++++++++++++++++++++
 fs/bcachefs/logged_ops.h      |  18 ++++++
 fs/bcachefs/recovery.c        |   1 +
 fs/bcachefs/recovery_types.h  |   1 +
 fs/bcachefs/super.c           |   1 +
 10 files changed, 154 insertions(+), 1 deletion(-)
 create mode 100644 fs/bcachefs/logged_ops.c
 create mode 100644 fs/bcachefs/logged_ops.h

diff --git a/fs/bcachefs/Makefile b/fs/bcachefs/Makefile
index 2f1fa4c2735f..e8e49f96e360 100644
--- a/fs/bcachefs/Makefile
+++ b/fs/bcachefs/Makefile
@@ -55,6 +55,7 @@ bcachefs-y		:=	\
 	journal_sb.o		\
 	journal_seq_blacklist.o	\
 	keylist.o		\
+	logged_ops.o		\
 	lru.o			\
 	migrate.o		\
 	move.o			\
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 30b3d7b9f9dc..e80fef1537c9 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -454,6 +454,7 @@ enum gc_phase {
 	GC_PHASE_BTREE_bucket_gens,
 	GC_PHASE_BTREE_snapshot_trees,
 	GC_PHASE_BTREE_deleted_inodes,
+	GC_PHASE_BTREE_logged_ops,
 
 	GC_PHASE_PENDING_DELETE,
 };
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 1cce2504bca6..31efa9e381ce 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -2249,7 +2249,9 @@ enum btree_id_flags {
 	x(snapshot_trees,	15,	0,					\
 	  BIT_ULL(KEY_TYPE_snapshot_tree))					\
 	x(deleted_inodes,	16,	BTREE_ID_SNAPSHOTS,			\
-	  BIT_ULL(KEY_TYPE_set))
+	  BIT_ULL(KEY_TYPE_set))						\
+	x(logged_ops,		17,	0,					\
+	  0)
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 606e7050a84a..823f0da2f502 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -653,6 +653,7 @@ int bch2_btree_insert_nonextent(struct btree_trans *trans,
 	int ret;
 
 	bch2_trans_iter_init(trans, &iter, btree, k->k.p,
+			     BTREE_ITER_CACHED|
 			     BTREE_ITER_NOT_EXTENTS|
 			     BTREE_ITER_INTENT);
 	ret   = bch2_btree_iter_traverse(&iter) ?:
@@ -727,6 +728,23 @@ int bch2_btree_delete_at_buffered(struct btree_trans *trans,
 	return bch2_trans_update_buffered(trans, btree, k);
 }
 
+int bch2_btree_delete(struct btree_trans *trans,
+		      enum btree_id btree, struct bpos pos,
+		      unsigned update_flags)
+{
+	struct btree_iter iter;
+	int ret;
+
+	bch2_trans_iter_init(trans, &iter, btree, pos,
+			     BTREE_ITER_CACHED|
+			     BTREE_ITER_INTENT);
+	ret   = bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_delete_at(trans, &iter, update_flags);
+	bch2_trans_iter_exit(trans, &iter);
+
+	return ret;
+}
+
 int bch2_btree_delete_range_trans(struct btree_trans *trans, enum btree_id id,
 				  struct bpos start, struct bpos end,
 				  unsigned update_flags,
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index 78a92a1cfb47..0596c5e73a3e 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -58,6 +58,7 @@ int bch2_btree_delete_extent_at(struct btree_trans *, struct btree_iter *,
 				unsigned, unsigned);
 int bch2_btree_delete_at(struct btree_trans *, struct btree_iter *, unsigned);
 int bch2_btree_delete_at_buffered(struct btree_trans *, enum btree_id, struct bpos);
+int bch2_btree_delete(struct btree_trans *, enum btree_id, struct bpos, unsigned);
 
 int bch2_btree_insert_nonextent(struct btree_trans *, enum btree_id,
 				struct bkey_i *, enum btree_update_flags);
diff --git a/fs/bcachefs/logged_ops.c b/fs/bcachefs/logged_ops.c
new file mode 100644
index 000000000000..818ada1f46a3
--- /dev/null
+++ b/fs/bcachefs/logged_ops.c
@@ -0,0 +1,109 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "bcachefs.h"
+#include "bkey_buf.h"
+#include "btree_update.h"
+#include "error.h"
+#include "logged_ops.h"
+
+struct bch_logged_op_fn {
+	u8		type;
+	int		(*resume)(struct btree_trans *, struct bkey_i *);
+};
+
+static const struct bch_logged_op_fn logged_op_fns[] = {
+#define x(n)		{					\
+	.type		= KEY_TYPE_logged_op_##n,		\
+	.resume		= bch2_resume_logged_op_##n,		\
+},
+	BCH_LOGGED_OPS()
+#undef x
+};
+
+static const struct bch_logged_op_fn *logged_op_fn(enum bch_bkey_type type)
+{
+	for (unsigned i = 0; i < ARRAY_SIZE(logged_op_fns); i++)
+		if (logged_op_fns[i].type == type)
+			return logged_op_fns + i;
+	return NULL;
+}
+
+static int resume_logged_op(struct btree_trans *trans, struct btree_iter *iter,
+			    struct bkey_s_c k)
+{
+	struct bch_fs *c = trans->c;
+	const struct bch_logged_op_fn *fn = logged_op_fn(k.k->type);
+	struct bkey_buf sk;
+	u32 restart_count = trans->restart_count;
+	int ret;
+
+	if (!fn)
+		return 0;
+
+	bch2_bkey_buf_init(&sk);
+	bch2_bkey_buf_reassemble(&sk, c, k);
+
+	ret = fn->resume(trans, sk.k) ?: trans_was_restarted(trans, restart_count);
+
+	bch2_bkey_buf_exit(&sk, c);
+	return ret;
+}
+
+int bch2_resume_logged_ops(struct bch_fs *c)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k;
+	int ret;
+
+	ret = bch2_trans_run(c,
+		for_each_btree_key2(&trans, iter,
+				BTREE_ID_logged_ops, POS_MIN, BTREE_ITER_PREFETCH, k,
+			resume_logged_op(&trans, &iter, k)));
+	if (ret)
+		bch_err_fn(c, ret);
+	return ret;
+}
+
+static int __bch2_logged_op_start(struct btree_trans *trans, struct bkey_i *k)
+{
+	struct btree_iter iter;
+	int ret;
+
+	ret = bch2_bkey_get_empty_slot(trans, &iter, BTREE_ID_logged_ops, POS_MAX);
+	if (ret)
+		return ret;
+
+	k->k.p = iter.pos;
+
+	ret = bch2_trans_update(trans, &iter, k, 0);
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+int bch2_logged_op_start(struct btree_trans *trans, struct bkey_i *k)
+{
+	return commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+			 __bch2_logged_op_start(trans, k));
+}
+
+void bch2_logged_op_finish(struct btree_trans *trans, struct bkey_i *k)
+{
+	int ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+			    bch2_btree_delete(trans, BTREE_ID_logged_ops, k->k.p, 0));
+	/*
+	 * This needs to be a fatal error because we've left an unfinished
+	 * operation in the logged ops btree.
+	 *
+	 * We should only ever see an error here if the filesystem has already
+	 * been shut down, but make sure of that here:
+	 */
+	if (ret) {
+		struct bch_fs *c = trans->c;
+		struct printbuf buf = PRINTBUF;
+
+		bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(k));
+		bch2_fs_fatal_error(c, "%s: error deleting logged operation %s: %s",
+				     __func__, buf.buf, bch2_err_str(ret));
+		printbuf_exit(&buf);
+	}
+}
diff --git a/fs/bcachefs/logged_ops.h b/fs/bcachefs/logged_ops.h
new file mode 100644
index 000000000000..9b758008c6bd
--- /dev/null
+++ b/fs/bcachefs/logged_ops.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BCACHEFS_LOGGED_OPS_H
+#define _BCACHEFS_LOGGED_OPS_H
+
+#include "bkey.h"
+
+#define BCH_LOGGED_OPS()
+
+static inline int bch2_logged_op_update(struct btree_trans *trans, struct bkey_i *op)
+{
+	return bch2_btree_insert_nonextent(trans, BTREE_ID_logged_ops, op, 0);
+}
+
+int bch2_resume_logged_ops(struct bch_fs *);
+int bch2_logged_op_start(struct btree_trans *, struct bkey_i *);
+void bch2_logged_op_finish(struct btree_trans *, struct bkey_i *);
+
+#endif /* _BCACHEFS_LOGGED_OPS_H */
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 30efb3c90560..f5f6eea2cbae 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -20,6 +20,7 @@
 #include "journal_reclaim.h"
 #include "journal_seq_blacklist.h"
 #include "lru.h"
+#include "logged_ops.h"
 #include "move.h"
 #include "quota.h"
 #include "recovery.h"
diff --git a/fs/bcachefs/recovery_types.h b/fs/bcachefs/recovery_types.h
index abf1f834ec7a..f3c9ea7720ca 100644
--- a/fs/bcachefs/recovery_types.h
+++ b/fs/bcachefs/recovery_types.h
@@ -24,6 +24,7 @@
 	x(check_alloc_to_lru_refs,	PASS_FSCK)						\
 	x(fs_freespace_init,		PASS_ALWAYS|PASS_SILENT)				\
 	x(bucket_gens_init,		0)							\
+	x(resume_logged_ops,		PASS_ALWAYS)						\
 	x(check_snapshot_trees,		PASS_FSCK)						\
 	x(check_snapshots,		PASS_FSCK)						\
 	x(check_subvols,		PASS_FSCK)						\
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 55176023f15b..ef11cede1dba 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -791,6 +791,7 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 	c->btree_key_cache_btrees |= 1U << BTREE_ID_alloc;
 	if (c->opts.inodes_use_key_cache)
 		c->btree_key_cache_btrees |= 1U << BTREE_ID_inodes;
+	c->btree_key_cache_btrees |= 1U << BTREE_ID_logged_ops;
 
 	c->block_bits		= ilog2(block_sectors(c));
 	c->btree_foreground_merge_threshold = BTREE_FOREGROUND_MERGE_THRESHOLD(c);
-- 
2.40.1

