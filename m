Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C434C00528
	for <linux-bcachefs@archiver.kernel.org>; Sun,  9 Jul 2023 17:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjGIRQJ (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 9 Jul 2023 13:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbjGIRQI (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 9 Jul 2023 13:16:08 -0400
Received: from out-10.mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BE3126
        for <linux-bcachefs@vger.kernel.org>; Sun,  9 Jul 2023 10:16:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688922965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8uQhkjhkSyLvOCusm652wU44MyStXw9SzmADmyXAv4=;
        b=KdAPfpnBGOoZ2ralD/KCvxRwr2UYIiG+ZEq3Wva/MWwVYOWXOnU4eUpyNN9BS4SX6w3pQT
        cIjvGF2W34RHf6yGXRyxV3R8wl3BPHAHoYR72PEJaR+vrTtS9bX4vOgdO2fxu9rWr6/jGm
        7HcUMllwNg6F4qpA/nCAnEqcTOAGkto=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>, bfoster@redhat.com,
        sandeen@redhat.com
Subject: [PATCH 07/10] bcachefs: Kill bch2_bucket_gens_read()
Date:   Sun,  9 Jul 2023 13:15:48 -0400
Message-Id: <20230709171551.2349961-8-kent.overstreet@linux.dev>
In-Reply-To: <20230709171551.2349961-1-kent.overstreet@linux.dev>
References: <20230709171551.2349961-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This folds bch2_bucket_gens_read() into bch2_alloc_read(), doing the
version check there.

This is prep work for enumarating all recovery passes: we need some
cleanup first to make calling all the recovery passes consistent.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 100 +++++++++++++++------------------
 fs/bcachefs/alloc_background.h |   1 -
 fs/bcachefs/recovery.c         |   6 +-
 3 files changed, 45 insertions(+), 62 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index b1dfe300d9..291d97f837 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -551,40 +551,6 @@ bch2_trans_start_alloc_update(struct btree_trans *trans, struct btree_iter *iter
 	return ERR_PTR(ret);
 }
 
-int bch2_alloc_read(struct bch_fs *c)
-{
-	struct btree_trans trans;
-	struct btree_iter iter;
-	struct bkey_s_c k;
-	struct bch_alloc_v4 a;
-	struct bch_dev *ca;
-	int ret;
-
-	bch2_trans_init(&trans, c, 0, 0);
-
-	for_each_btree_key(&trans, iter, BTREE_ID_alloc, POS_MIN,
-			   BTREE_ITER_PREFETCH, k, ret) {
-		/*
-		 * Not a fsck error because this is checked/repaired by
-		 * bch2_check_alloc_key() which runs later:
-		 */
-		if (!bch2_dev_bucket_exists(c, k.k->p))
-			continue;
-
-		ca = bch_dev_bkey_exists(c, k.k->p.inode);
-
-		*bucket_gen(ca, k.k->p.offset) = bch2_alloc_to_v4(k, &a)->gen;
-	}
-	bch2_trans_iter_exit(&trans, &iter);
-
-	bch2_trans_exit(&trans);
-
-	if (ret)
-		bch_err_fn(c, ret);
-
-	return ret;
-}
-
 static struct bpos alloc_gens_pos(struct bpos pos, unsigned *offset)
 {
 	*offset = pos.offset & KEY_TYPE_BUCKET_GENS_MASK;
@@ -692,45 +658,67 @@ int bch2_bucket_gens_init(struct bch_fs *c)
 	return ret;
 }
 
-int bch2_bucket_gens_read(struct bch_fs *c)
+int bch2_alloc_read(struct bch_fs *c)
 {
 	struct btree_trans trans;
 	struct btree_iter iter;
 	struct bkey_s_c k;
-	const struct bch_bucket_gens *g;
 	struct bch_dev *ca;
-	u64 b;
 	int ret;
 
+	down_read(&c->gc_lock);
 	bch2_trans_init(&trans, c, 0, 0);
 
-	for_each_btree_key(&trans, iter, BTREE_ID_bucket_gens, POS_MIN,
-			   BTREE_ITER_PREFETCH, k, ret) {
-		u64 start = bucket_gens_pos_to_alloc(k.k->p, 0).offset;
-		u64 end = bucket_gens_pos_to_alloc(bpos_nosnap_successor(k.k->p), 0).offset;
+	if (c->sb.version_upgrade_complete >= bcachefs_metadata_version_bucket_gens) {
+		const struct bch_bucket_gens *g;
+		u64 b;
 
-		if (k.k->type != KEY_TYPE_bucket_gens)
-			continue;
+		for_each_btree_key(&trans, iter, BTREE_ID_bucket_gens, POS_MIN,
+				   BTREE_ITER_PREFETCH, k, ret) {
+			u64 start = bucket_gens_pos_to_alloc(k.k->p, 0).offset;
+			u64 end = bucket_gens_pos_to_alloc(bpos_nosnap_successor(k.k->p), 0).offset;
 
-		g = bkey_s_c_to_bucket_gens(k).v;
+			if (k.k->type != KEY_TYPE_bucket_gens)
+				continue;
 
-		/*
-		 * Not a fsck error because this is checked/repaired by
-		 * bch2_check_alloc_key() which runs later:
-		 */
-		if (!bch2_dev_exists2(c, k.k->p.inode))
-			continue;
+			g = bkey_s_c_to_bucket_gens(k).v;
+
+			/*
+			 * Not a fsck error because this is checked/repaired by
+			 * bch2_check_alloc_key() which runs later:
+			 */
+			if (!bch2_dev_exists2(c, k.k->p.inode))
+				continue;
 
-		ca = bch_dev_bkey_exists(c, k.k->p.inode);
+			ca = bch_dev_bkey_exists(c, k.k->p.inode);
+
+			for (b = max_t(u64, ca->mi.first_bucket, start);
+			     b < min_t(u64, ca->mi.nbuckets, end);
+			     b++)
+				*bucket_gen(ca, b) = g->gens[b & KEY_TYPE_BUCKET_GENS_MASK];
+		}
+		bch2_trans_iter_exit(&trans, &iter);
+	} else {
+		struct bch_alloc_v4 a;
 
-		for (b = max_t(u64, ca->mi.first_bucket, start);
-		     b < min_t(u64, ca->mi.nbuckets, end);
-		     b++)
-			*bucket_gen(ca, b) = g->gens[b & KEY_TYPE_BUCKET_GENS_MASK];
+		for_each_btree_key(&trans, iter, BTREE_ID_alloc, POS_MIN,
+				   BTREE_ITER_PREFETCH, k, ret) {
+			/*
+			 * Not a fsck error because this is checked/repaired by
+			 * bch2_check_alloc_key() which runs later:
+			 */
+			if (!bch2_dev_bucket_exists(c, k.k->p))
+				continue;
+
+			ca = bch_dev_bkey_exists(c, k.k->p.inode);
+
+			*bucket_gen(ca, k.k->p.offset) = bch2_alloc_to_v4(k, &a)->gen;
+		}
+		bch2_trans_iter_exit(&trans, &iter);
 	}
-	bch2_trans_iter_exit(&trans, &iter);
 
 	bch2_trans_exit(&trans);
+	up_read(&c->gc_lock);
 
 	if (ret)
 		bch_err_fn(c, ret);
diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index d1bf45a4b4..c0914feb54 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -212,7 +212,6 @@ static inline bool bkey_is_alloc(const struct bkey *k)
 }
 
 int bch2_alloc_read(struct bch_fs *);
-int bch2_bucket_gens_read(struct bch_fs *);
 
 int bch2_trans_mark_alloc(struct btree_trans *, enum btree_id, unsigned,
 			  struct bkey_s_c, struct bkey_i *, unsigned);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index c90205aa22..4c61a28e49 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1309,11 +1309,7 @@ int bch2_fs_recovery(struct bch_fs *c)
 		goto err;
 
 	bch_verbose(c, "starting alloc read");
-	down_read(&c->gc_lock);
-	ret = c->sb.version < bcachefs_metadata_version_bucket_gens
-		? bch2_alloc_read(c)
-		: bch2_bucket_gens_read(c);
-	up_read(&c->gc_lock);
+	ret = bch2_alloc_read(c);
 	if (ret)
 		goto err;
 	bch_verbose(c, "alloc read done");
-- 
2.40.1

