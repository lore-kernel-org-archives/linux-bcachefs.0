Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4D9C001E0
	for <linux-bcachefs@archiver.kernel.org>; Thu,  3 Aug 2023 08:01:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjHCIBx (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 3 Aug 2023 04:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjHCIAs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 3 Aug 2023 04:00:48 -0400
Received: from out-66.mta1.migadu.com (out-66.mta1.migadu.com [IPv6:2001:41d0:203:375::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31A646AD
        for <linux-bcachefs@vger.kernel.org>; Thu,  3 Aug 2023 00:50:27 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1691049026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=D7uJ3QiLUVDZoxImj1DQye3S7hiicHQAVTw1918bqjY=;
        b=HQn80dqYPyGNZsvcjdCtm276kKND3Rz/wFJ4KOeIKYl0Ot2W7lFF0N+qdVmK79WcSjIhrT
        xP4WgSEb0JrsCT2/vFjcbagqZbIvK7tdBwbcMCadgmyTXYcST7Yz5QATZ3Mk8iqGAkq9Qj
        KsCrDIPuOK6UEZj6eBkKvp/BHkpZYQw=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix lock thrashing in __bchfs_fallocate()
Date:   Thu,  3 Aug 2023 03:50:18 -0400
Message-Id: <20230803075018.3771018-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

We've observed significant lock thrashing on fstests generic/083 in
fallocate, due to dropping and retaking btree locks when checking the
pagecache for data.

This adds a nonblocking mode to bch2_clamp_data_hole(), where we only
use folio_trylock(), and can thus be used safely while btree locks are
held - thus we only have to drop btree locks as a fallback, on actual
lock contention.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io.c | 80 +++++++++++++++++++++++++++++++--------------
 1 file changed, 55 insertions(+), 25 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index dcaf7aad79..d433f4d566 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -35,7 +35,7 @@
 
 #include <trace/events/writeback.h>
 
-static void bch2_clamp_data_hole(struct inode *, u64 *, u64 *, unsigned);
+static int bch2_clamp_data_hole(struct inode *, u64 *, u64 *, unsigned, bool);
 
 struct folio_vec {
 	struct folio	*fv_folio;
@@ -3410,11 +3410,15 @@ static int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 		}
 
 		if (!(mode & FALLOC_FL_ZERO_RANGE)) {
-			ret = drop_locks_do(&trans,
-				(bch2_clamp_data_hole(&inode->v,
-						      &hole_start,
-						      &hole_end,
-						      opts.data_replicas), 0));
+			if (bch2_clamp_data_hole(&inode->v,
+						 &hole_start,
+						 &hole_end,
+						 opts.data_replicas, true))
+				ret = drop_locks_do(&trans,
+					(bch2_clamp_data_hole(&inode->v,
+							      &hole_start,
+							      &hole_end,
+							      opts.data_replicas, false), 0));
 			bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, hole_start));
 
 			if (ret)
@@ -3714,7 +3718,8 @@ static int folio_data_offset(struct folio *folio, loff_t pos,
 static loff_t bch2_seek_pagecache_data(struct inode *vinode,
 				       loff_t start_offset,
 				       loff_t end_offset,
-				       unsigned min_replicas)
+				       unsigned min_replicas,
+				       bool nonblock)
 {
 	struct folio_batch fbatch;
 	pgoff_t start_index	= start_offset >> PAGE_SHIFT;
@@ -3731,7 +3736,13 @@ static loff_t bch2_seek_pagecache_data(struct inode *vinode,
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 
-			folio_lock(folio);
+			if (!nonblock) {
+				folio_lock(folio);
+			} else if (!folio_trylock(folio)) {
+				folio_batch_release(&fbatch);
+				return -EAGAIN;
+			}
+
 			offset = folio_data_offset(folio,
 					max(folio_pos(folio), start_offset),
 					min_replicas);
@@ -3796,7 +3807,7 @@ static loff_t bch2_seek_data(struct file *file, u64 offset)
 
 	if (next_data > offset)
 		next_data = bch2_seek_pagecache_data(&inode->v,
-						     offset, next_data, 0);
+					offset, next_data, 0, false);
 
 	if (next_data >= isize)
 		return -ENXIO;
@@ -3804,18 +3815,24 @@ static loff_t bch2_seek_data(struct file *file, u64 offset)
 	return vfs_setpos(file, next_data, MAX_LFS_FILESIZE);
 }
 
-static bool folio_hole_offset(struct address_space *mapping, loff_t *offset,
-			      unsigned min_replicas)
+static int folio_hole_offset(struct address_space *mapping, loff_t *offset,
+			      unsigned min_replicas, bool nonblock)
 {
 	struct folio *folio;
 	struct bch_folio *s;
 	unsigned i, sectors;
 	bool ret = true;
 
-	folio = filemap_lock_folio(mapping, *offset >> PAGE_SHIFT);
+	folio = __filemap_get_folio(mapping, *offset >> PAGE_SHIFT,
+				    !nonblock ? FGP_LOCK : 0, 0);
 	if (IS_ERR_OR_NULL(folio))
 		return true;
 
+	if (nonblock && !folio_trylock(folio)) {
+		folio_put(folio);
+		return -EAGAIN;
+	}
+
 	s = bch2_folio(folio);
 	if (!s)
 		goto unlock;
@@ -3840,31 +3857,44 @@ static bool folio_hole_offset(struct address_space *mapping, loff_t *offset,
 static loff_t bch2_seek_pagecache_hole(struct inode *vinode,
 				       loff_t start_offset,
 				       loff_t end_offset,
-				       unsigned min_replicas)
+				       unsigned min_replicas,
+				       bool nonblock)
 {
 	struct address_space *mapping = vinode->i_mapping;
 	loff_t offset = start_offset;
 
 	while (offset < end_offset &&
-	       !folio_hole_offset(mapping, &offset, min_replicas))
+	       !folio_hole_offset(mapping, &offset, min_replicas, nonblock))
 		;
 
 	return min(offset, end_offset);
 }
 
-static void bch2_clamp_data_hole(struct inode *inode,
-				 u64 *hole_start,
-				 u64 *hole_end,
-				 unsigned min_replicas)
+static int bch2_clamp_data_hole(struct inode *inode,
+				u64 *hole_start,
+				u64 *hole_end,
+				unsigned min_replicas,
+				bool nonblock)
 {
-	*hole_start = bch2_seek_pagecache_hole(inode,
-		*hole_start << 9, *hole_end << 9, min_replicas) >> 9;
+	loff_t ret;
+
+	ret = bch2_seek_pagecache_hole(inode,
+		*hole_start << 9, *hole_end << 9, min_replicas, nonblock) >> 9;
+	if (ret < 0)
+		return ret;
+
+	*hole_start = ret;
 
 	if (*hole_start == *hole_end)
-		return;
+		return 0;
 
-	*hole_end = bch2_seek_pagecache_data(inode,
-		*hole_start << 9, *hole_end << 9, min_replicas) >> 9;
+	ret = bch2_seek_pagecache_data(inode,
+		*hole_start << 9, *hole_end << 9, min_replicas, nonblock) >> 9;
+	if (ret < 0)
+		return ret;
+
+	*hole_end = ret;
+	return 0;
 }
 
 static loff_t bch2_seek_hole(struct file *file, u64 offset)
@@ -3896,12 +3926,12 @@ static loff_t bch2_seek_hole(struct file *file, u64 offset)
 			   BTREE_ITER_SLOTS, k, ret) {
 		if (k.k->p.inode != inode->v.i_ino) {
 			next_hole = bch2_seek_pagecache_hole(&inode->v,
-					offset, MAX_LFS_FILESIZE, 0);
+					offset, MAX_LFS_FILESIZE, 0, false);
 			break;
 		} else if (!bkey_extent_is_data(k.k)) {
 			next_hole = bch2_seek_pagecache_hole(&inode->v,
 					max(offset, bkey_start_offset(k.k) << 9),
-					k.k->p.offset << 9, 0);
+					k.k->p.offset << 9, 0, false);
 
 			if (next_hole < k.k->p.offset << 9)
 				break;
-- 
2.40.1

