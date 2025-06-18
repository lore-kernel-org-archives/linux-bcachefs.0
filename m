Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5094C28682
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 21:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750283696; cv=none; b=aaw2sFQoREu3Ioo6yX5ecqeNkmOFSRsw4rDeUJPLJVSykRrxxv4hVb6bgxuTcyy86bVGNvaQn10FU4rUCEM7mUaTFrLEZMuhWDj0CmugX9gOE7OYXeCTqRJzvgmfrQBql8iHeyFDTQYajHvpjbEywOxgDAvHvg3FPIweAKMk07s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750283696; c=relaxed/simple;
	bh=Lss+ch1fpRmKs1mSWQqFDa31OdqxedTwsE0eEwf33xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBJVPMA2N/NarQQptQYvNFTZ0elvA9Ubm6DcN6ONQgImPrKA/DgLRNuppX83Pk4s1D2iy9EVlMlYv7UvYH2/xzW7xXZh3clV1sFIaMvByuqrdYuyMEVtjVliIAkO/FUQe7o9YcZvlIHdIzrI1f5QB3Xcj3yVErmIs3m6Ji6a+Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=P9psPwu0; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="P9psPwu0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750283693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hpd7b8xC84ACppWBtwMfA7+/VALO08bNcvkltig477A=;
	b=P9psPwu0EqKS6Wbwjzk+2AvgyBGT4jQNsTNjAGiJQNgOwezeYzAag/tjzJMGA9/VCgeby5
	Th4PLrXwsqZWh/CFBdzN0Y1AH8rd+DdljM1eo0vqOVQZNutRw+nVKi7GJQqkoHxiw5HwUz
	H1IuOoUFLJ4Qv5lm/qg5r48jSD8yQNM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 14/37] bcachefs: fsck: fix extent past end of inode repair
Date: Wed, 18 Jun 2025 17:54:05 -0400
Message-ID: <20250618215431.738317-15-kent.overstreet@linux.dev>
In-Reply-To: <20250618215431.738317-1-kent.overstreet@linux.dev>
References: <20250618215431.738317-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix the case where we're deleting in a different snapshot and need to
emit a whiteout - that requires a regular BTREE_ITER_filter_snapshots
iterator.

Also, only delete the part of the extent that extents past i_size.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fsck.c | 31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 28ca07c0e029..48810a8e5d4b 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1820,18 +1820,39 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 			    !key_visible_in_snapshot(c, s, i->inode.bi_snapshot, k.k->p.snapshot))
 				continue;
 
-			if (fsck_err_on(k.k->p.offset > round_up(i->inode.bi_size, block_bytes(c)) >> 9 &&
+			u64 last_block = round_up(i->inode.bi_size, block_bytes(c)) >> 9;
+
+			if (fsck_err_on(k.k->p.offset > last_block &&
 					!bkey_extent_is_reservation(k),
 					trans, extent_past_end_of_inode,
 					"extent type past end of inode %llu:%u, i_size %llu\n%s",
 					i->inode.bi_inum, i->inode.bi_snapshot, i->inode.bi_size,
 					(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
-				struct btree_iter iter2;
+				struct bkey_i *whiteout = bch2_trans_kmalloc(trans, sizeof(*whiteout));
+				ret = PTR_ERR_OR_ZERO(whiteout);
+				if (ret)
+					goto err;
 
-				bch2_trans_copy_iter(trans, &iter2, iter);
-				bch2_btree_iter_set_snapshot(trans, &iter2, i->inode.bi_snapshot);
+				bkey_init(&whiteout->k);
+				whiteout->k.p = SPOS(k.k->p.inode,
+						     last_block,
+						     i->inode.bi_snapshot);
+				bch2_key_resize(&whiteout->k,
+						min(KEY_SIZE_MAX & (~0 << c->block_bits),
+						    U64_MAX - whiteout->k.p.offset));
+
+
+				/*
+				 * Need a normal (not BTREE_ITER_all_snapshots)
+				 * iterator, if we're deleting in a different
+				 * snapshot and need to emit a whiteout
+				 */
+				struct btree_iter iter2;
+				bch2_trans_iter_init(trans, &iter2, BTREE_ID_extents,
+						     bkey_start_pos(&whiteout->k),
+						     BTREE_ITER_intent);
 				ret =   bch2_btree_iter_traverse(trans, &iter2) ?:
-					bch2_btree_delete_at(trans, &iter2,
+					bch2_trans_update(trans, &iter2, whiteout,
 						BTREE_UPDATE_internal_snapshot_node);
 				bch2_trans_iter_exit(trans, &iter2);
 				if (ret)
-- 
2.50.0

