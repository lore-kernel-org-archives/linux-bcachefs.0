Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68050CA0EC3
	for <linux-bcachefs@archiver.kernel.org>; Tue, 12 Sep 2023 01:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjILBQA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 11 Sep 2023 21:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjILBPs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 11 Sep 2023 21:15:48 -0400
Received: from out-212.mta0.migadu.com (out-212.mta0.migadu.com [IPv6:2001:41d0:1004:224b::d4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91BB6167DBA
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Sep 2023 18:01:37 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694478251;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xazxXrXkfRhRmjwo4s+OLC/HBMuWITHPVoZt/zbstiE=;
        b=EyFvpXfwscN+JDdYqdL0J+jdYFAp1V6djRqOLwi932gO0ejJczpqWXGb5BS3XqG7XXo1O0
        dR4QPA8jCDzTq/f+/jpXHPnfn2ohz99FVg9dpZS0ooXyaLrHcIEfCaKYKjJHkG8u4rOBE4
        1II/Sn+QQR4Y4Cxv3GVsj7frBPV3xIw=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: Log truncate operations
Date:   Mon, 11 Sep 2023 20:23:55 -0400
Message-Id: <20230912002356.566674-3-kent.overstreet@linux.dev>
In-Reply-To: <20230912002356.566674-1-kent.overstreet@linux.dev>
References: <20230912002356.566674-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Previously, we guaranteed atomicity of truncate after unclean shutdown
with the BCH_INODE_I_SIZE_DIRTY flag - which required a full scan of the
inodes btree.

Recently the deleted inodes btree was added so that we no longer have to
scan for deleted inodes, but truncate was unfinished and that change
left it broken.

This patch uses the new logged operations btree to fix truncate
atomicity; we now log an operation that can be replayed at the start of
a truncate.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h | 19 ++++++++---
 fs/bcachefs/bkey_methods.c    |  1 +
 fs/bcachefs/io_misc.c         | 64 +++++++++++++++++++++++++----------
 fs/bcachefs/io_misc.h         |  9 +++++
 fs/bcachefs/logged_ops.c      |  1 +
 fs/bcachefs/logged_ops.h      |  3 +-
 6 files changed, 75 insertions(+), 22 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index 31efa9e381ce..3c9e788f1c9d 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -370,7 +370,8 @@ static inline void bkey_init(struct bkey *k)
 	x(backpointer,		28)			\
 	x(inode_v3,		29)			\
 	x(bucket_gens,		30)			\
-	x(snapshot_tree,	31)
+	x(snapshot_tree,	31)			\
+	x(logged_op_truncate,	32)
 
 enum bch_bkey_type {
 #define x(name, nr) KEY_TYPE_##name	= nr,
@@ -847,8 +848,8 @@ enum {
 	__BCH_INODE_NODUMP		= 3,
 	__BCH_INODE_NOATIME		= 4,
 
-	__BCH_INODE_I_SIZE_DIRTY	= 5,
-	__BCH_INODE_I_SECTORS_DIRTY	= 6,
+	__BCH_INODE_I_SIZE_DIRTY	= 5, /* obsolete */
+	__BCH_INODE_I_SECTORS_DIRTY	= 6, /* obsolete */
 	__BCH_INODE_UNLINKED		= 7,
 	__BCH_INODE_BACKPTR_UNTRUSTED	= 8,
 
@@ -1183,6 +1184,16 @@ struct bch_lru {
 
 #define LRU_ID_STRIPES		(1U << 16)
 
+/* Logged operations btree: */
+
+struct bch_logged_op_truncate {
+	struct bch_val		v;
+	__le32			subvol;
+	__le32			pad;
+	__le64			inum;
+	__le64			new_i_size;
+};
+
 /* Optional/variable size superblock sections: */
 
 struct bch_sb_field {
@@ -2251,7 +2262,7 @@ enum btree_id_flags {
 	x(deleted_inodes,	16,	BTREE_ID_SNAPSHOTS,			\
 	  BIT_ULL(KEY_TYPE_set))						\
 	x(logged_ops,		17,	0,					\
-	  0)
+	  BIT_ULL(KEY_TYPE_logged_op_truncate))
 
 enum btree_id {
 #define x(name, nr, ...) BTREE_ID_##name = nr,
diff --git a/fs/bcachefs/bkey_methods.c b/fs/bcachefs/bkey_methods.c
index 6547142db428..91e28ee3efff 100644
--- a/fs/bcachefs/bkey_methods.c
+++ b/fs/bcachefs/bkey_methods.c
@@ -10,6 +10,7 @@
 #include "error.h"
 #include "extents.h"
 #include "inode.h"
+#include "io_misc.h"
 #include "lru.h"
 #include "quota.h"
 #include "reflink.h"
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 1afea613df4a..327b3dd642de 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -15,6 +15,7 @@
 #include "inode.h"
 #include "io_misc.h"
 #include "io_write.h"
+#include "logged_ops.h"
 #include "subvolume.h"
 
 /* Overwrites whatever was present with zeroes: */
@@ -217,6 +218,17 @@ int bch2_fpunch(struct bch_fs *c, subvol_inum inum, u64 start, u64 end,
 	return ret;
 }
 
+/* truncate: */
+
+void bch2_logged_op_truncate_to_text(struct printbuf *out, struct bch_fs *c, struct bkey_s_c k)
+{
+	struct bkey_s_c_logged_op_truncate op = bkey_s_c_to_logged_op_truncate(k);
+
+	prt_printf(out, "subvol=%u", le32_to_cpu(op.v->subvol));
+	prt_printf(out, " inum=%llu", le64_to_cpu(op.v->inum));
+	prt_printf(out, " new_i_size=%llu", le64_to_cpu(op.v->new_i_size));
+}
+
 static int truncate_set_isize(struct btree_trans *trans,
 			      subvol_inum inum,
 			      u64 new_i_size)
@@ -233,36 +245,54 @@ static int truncate_set_isize(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_truncate(struct bch_fs *c, subvol_inum inum, u64 new_i_size, u64 *i_sectors_delta)
+static int __bch2_resume_logged_op_truncate(struct btree_trans *trans,
+					    struct bkey_i *op_k,
+					    u64 *i_sectors_delta)
 {
-	struct btree_trans trans;
+	struct bch_fs *c = trans->c;
 	struct btree_iter fpunch_iter;
+	struct bkey_i_logged_op_truncate *op = bkey_i_to_logged_op_truncate(op_k);
+	subvol_inum inum = { le32_to_cpu(op->v.subvol), le64_to_cpu(op->v.inum) };
+	u64 new_i_size = le64_to_cpu(op->v.new_i_size);
 	int ret;
 
-	bch2_trans_init(&trans, c, BTREE_ITER_MAX, 1024);
-	bch2_trans_iter_init(&trans, &fpunch_iter, BTREE_ID_extents,
-			     POS(inum.inum, round_up(new_i_size, block_bytes(c)) >> 9),
-			     BTREE_ITER_INTENT);
-
-	ret = commit_do(&trans, NULL, NULL, BTREE_INSERT_NOFAIL,
-			truncate_set_isize(&trans, inum, new_i_size));
+	ret = commit_do(trans, NULL, NULL, BTREE_INSERT_NOFAIL,
+			truncate_set_isize(trans, inum, new_i_size));
 	if (ret)
 		goto err;
 
-	ret = bch2_fpunch_at(&trans, &fpunch_iter, inum, U64_MAX, i_sectors_delta);
+	bch2_trans_iter_init(trans, &fpunch_iter, BTREE_ID_extents,
+			     POS(inum.inum, round_up(new_i_size, block_bytes(c)) >> 9),
+			     BTREE_ITER_INTENT);
+	ret = bch2_fpunch_at(trans, &fpunch_iter, inum, U64_MAX, i_sectors_delta);
+	bch2_trans_iter_exit(trans, &fpunch_iter);
+
 	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 		ret = 0;
-	if (ret)
-		goto err;
 err:
-	bch2_trans_iter_exit(&trans, &fpunch_iter);
-	bch2_trans_exit(&trans);
-
-	bch2_fs_fatal_err_on(ret, c, "%s: error truncating %u:%llu: %s",
-			    __func__, inum.subvol, inum.inum, bch2_err_str(ret));
+	bch2_logged_op_finish(trans, op_k);
 	return ret;
 }
 
+int bch2_resume_logged_op_truncate(struct btree_trans *trans, struct bkey_i *op_k)
+{
+	return __bch2_resume_logged_op_truncate(trans, op_k, NULL);
+}
+
+int bch2_truncate(struct bch_fs *c, subvol_inum inum, u64 new_i_size, u64 *i_sectors_delta)
+{
+	struct bkey_i_logged_op_truncate op;
+
+	bkey_logged_op_truncate_init(&op.k_i);
+	op.v.subvol	= cpu_to_le32(inum.subvol);
+	op.v.inum	= cpu_to_le64(inum.inum);
+	op.v.new_i_size	= cpu_to_le64(new_i_size);
+
+	return bch2_trans_run(c,
+		bch2_logged_op_start(&trans, &op.k_i) ?:
+		__bch2_resume_logged_op_truncate(&trans, &op.k_i, i_sectors_delta));
+}
+
 static int adjust_i_size(struct btree_trans *trans, subvol_inum inum, u64 offset, s64 len)
 {
 	struct btree_iter iter;
diff --git a/fs/bcachefs/io_misc.h b/fs/bcachefs/io_misc.h
index 3c6abedd4452..688d9048604e 100644
--- a/fs/bcachefs/io_misc.h
+++ b/fs/bcachefs/io_misc.h
@@ -18,6 +18,15 @@ int bch2_fpunch_at(struct btree_trans *, struct btree_iter *,
 		   subvol_inum, u64, s64 *);
 int bch2_fpunch(struct bch_fs *c, subvol_inum, u64, u64, s64 *);
 
+void bch2_logged_op_truncate_to_text(struct printbuf *, struct bch_fs *, struct bkey_s_c);
+
+#define bch2_bkey_ops_logged_op_truncate ((struct bkey_ops) {	\
+	.val_to_text	= bch2_logged_op_truncate_to_text,	\
+	.min_val_size	= 24,					\
+})
+
+int bch2_resume_logged_op_truncate(struct btree_trans *, struct bkey_i *);
+
 int bch2_truncate(struct bch_fs *, subvol_inum, u64, u64 *);
 int bch2_fcollapse_finsert(struct bch_fs *, subvol_inum, u64, u64, bool, s64 *);
 
diff --git a/fs/bcachefs/logged_ops.c b/fs/bcachefs/logged_ops.c
index 818ada1f46a3..6b52e6ec588a 100644
--- a/fs/bcachefs/logged_ops.c
+++ b/fs/bcachefs/logged_ops.c
@@ -4,6 +4,7 @@
 #include "bkey_buf.h"
 #include "btree_update.h"
 #include "error.h"
+#include "io_misc.h"
 #include "logged_ops.h"
 
 struct bch_logged_op_fn {
diff --git a/fs/bcachefs/logged_ops.h b/fs/bcachefs/logged_ops.h
index 9b758008c6bd..b2f2ebea54b6 100644
--- a/fs/bcachefs/logged_ops.h
+++ b/fs/bcachefs/logged_ops.h
@@ -4,7 +4,8 @@
 
 #include "bkey.h"
 
-#define BCH_LOGGED_OPS()
+#define BCH_LOGGED_OPS()			\
+	x(truncate)
 
 static inline int bch2_logged_op_update(struct btree_trans *trans, struct bkey_i *op)
 {
-- 
2.40.1

