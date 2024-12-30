Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A3F19CC29
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 21:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735594986; cv=none; b=pfb6vhlncxQr3YXFKx443Szonwg3VHKofozFebKBS1TTDWKjzkfr2yUDFBp7NAEYRGS7vb6GwfYV1EtVVD/Ey8M75saw3Hqg860/fylyAoxxl5x1hPtCq+qi4GTqhXmlG+G5QbmslKtfV1BtG3UCYlEWbxwaqUmJ1/7vaWuVUpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735594986; c=relaxed/simple;
	bh=oBkHn1p3xBb8iSk2aDKtRVE7WCUk8vKacpN5ivZe5JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJnMDlxPMIpUHMizGKVvSPF9MGWVCOAYefXNsFfYzYCLx7nytS/9AMAur3Th8Zqkwdd41qWzbbzcYL50FSQXrAJ++Jr/Ne9ICLvLB22opRJtP3qY82GUPsO9xzMywBJZlbw8ci08qLtmz3pnmjZbmBqBOndhD6fR8qvoAHE+uQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qis3m5qU; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qis3m5qU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735594982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKURB2dyIIr/yUgz8MJaNJ7WbYbXlbcbfF3tnTv/vCc=;
	b=qis3m5qUBXu0El77cScBtA03IePUUmgv+44haAc4G04J+Onl3l4+GIPQVVtvKvjWC12H4A
	MxO5eDw55iBH46uGJtEnz18o5WsfdtoaHfm+NtUwyQmdMlD7ZiXm1zD5B1XFFtzMvh/Evn
	39TepptrAocRqHHMK/qyJzQev7uEbv8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 07/11] bcachefs: bch2_bkey_pick_read_device() can now specify a device
Date: Mon, 30 Dec 2024 16:42:45 -0500
Message-ID: <20241230214249.242966-7-kent.overstreet@linux.dev>
In-Reply-To: <20241230214249.242966-1-kent.overstreet@linux.dev>
References: <20241230214249.242966-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

To be used for scrub, where we want the read to come from a specific
device.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_io.c | 4 ++--
 fs/bcachefs/debug.c    | 2 +-
 fs/bcachefs/extents.c  | 9 +++++++--
 fs/bcachefs/extents.h  | 2 +-
 fs/bcachefs/io_read.c  | 8 ++++----
 fs/bcachefs/io_read.h  | 4 ++--
 6 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index e371e60e3133..73f75e38da7f 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1352,7 +1352,7 @@ static void btree_node_read_work(struct work_struct *work)
 
 		can_retry = bch2_bkey_pick_read_device(c,
 				bkey_i_to_s_c(&b->key),
-				&failed, &rb->pick) > 0;
+				&failed, &rb->pick, -1) > 0;
 
 		if (!bio->bi_status &&
 		    !bch2_btree_node_read_done(c, ca, b, can_retry, &saw_error)) {
@@ -1697,7 +1697,7 @@ void bch2_btree_node_read(struct btree_trans *trans, struct btree *b,
 		return;
 
 	ret = bch2_bkey_pick_read_device(c, bkey_i_to_s_c(&b->key),
-					 NULL, &pick);
+					 NULL, &pick, -1);
 
 	if (ret <= 0) {
 		struct printbuf buf = PRINTBUF;
diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index b5de52a50d10..3722c2ac725b 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -189,7 +189,7 @@ void bch2_btree_node_ondisk_to_text(struct printbuf *out, struct bch_fs *c,
 	unsigned offset = 0;
 	int ret;
 
-	if (bch2_bkey_pick_read_device(c, bkey_i_to_s_c(&b->key), NULL, &pick) <= 0) {
+	if (bch2_bkey_pick_read_device(c, bkey_i_to_s_c(&b->key), NULL, &pick, -1) <= 0) {
 		prt_printf(out, "error getting device to read from: invalid device\n");
 		return;
 	}
diff --git a/fs/bcachefs/extents.c b/fs/bcachefs/extents.c
index 05d5f71a7ca9..78a51d96bd2d 100644
--- a/fs/bcachefs/extents.c
+++ b/fs/bcachefs/extents.c
@@ -114,8 +114,9 @@ static inline bool ptr_better(struct bch_fs *c,
  * other devices, it will still pick a pointer from avoid.
  */
 int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
-			       struct bch_io_failures *failed,
-			       struct extent_ptr_decoded *pick)
+			      struct bch_io_failures *failed,
+			      struct extent_ptr_decoded *pick,
+			      int dev)
 {
 	struct bkey_ptrs_c ptrs = bch2_bkey_ptrs_c(k);
 	const union bch_extent_entry *entry;
@@ -137,6 +138,10 @@ int bch2_bkey_pick_read_device(struct bch_fs *c, struct bkey_s_c k,
 			break;
 		}
 
+		/* Are we being asked to read from a specific device? */
+		if (dev >= 0 && p.ptr.dev != dev)
+			continue;
+
 		/*
 		 * If there are any dirty pointers it's an error if we can't
 		 * read:
diff --git a/fs/bcachefs/extents.h b/fs/bcachefs/extents.h
index 620b284aa34f..8fae6b23a341 100644
--- a/fs/bcachefs/extents.h
+++ b/fs/bcachefs/extents.h
@@ -404,7 +404,7 @@ void bch2_mark_io_failure(struct bch_io_failures *,
 			  struct extent_ptr_decoded *);
 int bch2_bkey_pick_read_device(struct bch_fs *, struct bkey_s_c,
 			       struct bch_io_failures *,
-			       struct extent_ptr_decoded *);
+			       struct extent_ptr_decoded *, int);
 
 /* KEY_TYPE_btree_ptr: */
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 34a3569d085a..17a6a3159917 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -444,7 +444,7 @@ static void bch2_read_retry_nodecode(struct bch_fs *c, struct bch_read_bio *rbio
 	ret = __bch2_read_extent(trans, rbio, bvec_iter,
 				 rbio->read_pos,
 				 rbio->data_btree,
-				 k, 0, failed, flags);
+				 k, 0, failed, flags, -1);
 	if (ret == READ_RETRY)
 		goto retry;
 	if (ret)
@@ -878,7 +878,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		       struct bvec_iter iter, struct bpos read_pos,
 		       enum btree_id data_btree, struct bkey_s_c k,
 		       unsigned offset_into_extent,
-		       struct bch_io_failures *failed, unsigned flags)
+		       struct bch_io_failures *failed, unsigned flags, int dev)
 {
 	struct bch_fs *c = trans->c;
 	struct extent_ptr_decoded pick;
@@ -900,7 +900,7 @@ int __bch2_read_extent(struct btree_trans *trans, struct bch_read_bio *orig,
 		goto out_read_done;
 	}
 retry_pick:
-	pick_ret = bch2_bkey_pick_read_device(c, k, failed, &pick);
+	pick_ret = bch2_bkey_pick_read_device(c, k, failed, &pick, dev);
 
 	/* hole or reservation - just zero fill: */
 	if (!pick_ret)
@@ -1261,7 +1261,7 @@ void __bch2_read(struct bch_fs *c, struct bch_read_bio *rbio,
 
 		ret = __bch2_read_extent(trans, rbio, bvec_iter, iter.pos,
 					 data_btree, k,
-					 offset_into_extent, failed, flags);
+					 offset_into_extent, failed, flags, -1);
 		if (ret)
 			goto err;
 
diff --git a/fs/bcachefs/io_read.h b/fs/bcachefs/io_read.h
index a82e8a94ccb6..ce94a71394f2 100644
--- a/fs/bcachefs/io_read.h
+++ b/fs/bcachefs/io_read.h
@@ -124,7 +124,7 @@ enum bch_read_flags {
 int __bch2_read_extent(struct btree_trans *, struct bch_read_bio *,
 		       struct bvec_iter, struct bpos, enum btree_id,
 		       struct bkey_s_c, unsigned,
-		       struct bch_io_failures *, unsigned);
+		       struct bch_io_failures *, unsigned, int);
 
 static inline void bch2_read_extent(struct btree_trans *trans,
 			struct bch_read_bio *rbio, struct bpos read_pos,
@@ -132,7 +132,7 @@ static inline void bch2_read_extent(struct btree_trans *trans,
 			unsigned offset_into_extent, unsigned flags)
 {
 	__bch2_read_extent(trans, rbio, rbio->bio.bi_iter, read_pos,
-			   data_btree, k, offset_into_extent, NULL, flags);
+			   data_btree, k, offset_into_extent, NULL, flags, -1);
 }
 
 void __bch2_read(struct bch_fs *, struct bch_read_bio *, struct bvec_iter,
-- 
2.45.2

