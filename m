Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B6A3B2BB
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894316; cv=none; b=J/0x1Zsm0nN2KY5G9EbU4C74O8p9Qp7Ukiej0tlwnud2RoqMtnevtQZP8jXbFRPDWjVfYNki8MeDDceDwxNk1zLmkoby3cP6p/NbRTC0zSi8xrq7xq9sqVIJL0iU1M2IFEDuaytjE01qxNDWiOsWecchrT2Jo7TneV4Q1S57vzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894316; c=relaxed/simple;
	bh=Uv2nPjB6vFFFRBIqSQruZsub2wTG6afhMnMdzE1i2/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXSC03FyjteC5RQkleJWjhRCYeVcPuV+IOcOfm8BueUwDmWmvh512VGONPiOAE5lp5F6cwJ0IbOhPe76SieTV+37ukTLLuJ98+eRX3p/eWq3r3gLQbjfkf6zppQvTFkQjRsAPuk4IbP0eIWOjTKb3ifVfZq2dFaj55NgI+Bmng8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TKtRvUUz; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TKtRvUUz"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731894312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2zZGXts4zCeKfmbNqXLgv/HEic4N4p9r7sHGHqXWq6E=;
	b=TKtRvUUzQkQ+xmxB/KfL9hsR5cQIcj3ossf4RfqyULr256I5GrN/U/zc3kfZZo1ObPswQv
	GErFVzlxvjkc/fi/ccYUQ05NvgcMnPR4+6eq4ZtX6tFYC904/+tagu6IWXGAm6SM7YJvS/
	KGbx0GXgz38zZeLyxyVrR52I7XuukZ4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 6/7] bcachefs: kill __bch2_extent_ptr_to_bp()
Date: Sun, 17 Nov 2024 20:44:47 -0500
Message-ID: <20241118014451.2275941-7-kent.overstreet@linux.dev>
In-Reply-To: <20241118014451.2275941-1-kent.overstreet@linux.dev>
References: <20241118014451.2275941-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.h | 18 +++---------------
 fs/bcachefs/buckets.c      |  7 +++----
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index d8a15f5fa767..4b7758a82eb4 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -139,12 +139,11 @@ static inline enum bch_data_type bch2_bkey_ptr_data_type(struct bkey_s_c k,
 	}
 }
 
-static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
+static inline void bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 			   enum btree_id btree_id, unsigned level,
 			   struct bkey_s_c k, struct extent_ptr_decoded p,
 			   const union bch_extent_entry *entry,
-			   struct bpos *bucket, struct bkey_i_backpointer *bp,
-			   u64 sectors)
+			   struct bpos *bucket, struct bkey_i_backpointer *bp)
 {
 	u32 bucket_offset;
 	*bucket = PTR_BUCKET_POS_OFFSET(ca, &p.ptr, &bucket_offset);
@@ -158,22 +157,11 @@ static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 		.level		= level,
 		.data_type	= bch2_bkey_ptr_data_type(k, p, entry),
 		.bucket_offset	= bp_bucket_offset,
-		.bucket_len	= sectors,
+		.bucket_len	= ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p),
 		.pos		= k.k->p,
 	};
 }
 
-static inline void bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
-			   enum btree_id btree_id, unsigned level,
-			   struct bkey_s_c k, struct extent_ptr_decoded p,
-			   const union bch_extent_entry *entry,
-			   struct bpos *bucket_pos, struct bkey_i_backpointer *bp)
-{
-	u64 sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
-
-	__bch2_extent_ptr_to_bp(c, ca, btree_id, level, k, p, entry, bucket_pos, bp, sectors);
-}
-
 struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *, struct bkey_s_c_backpointer,
 					 struct btree_iter *, unsigned);
 struct btree *bch2_backpointer_get_node(struct btree_trans *, struct bkey_s_c_backpointer,
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 1547141ba2a0..81a217587413 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -574,9 +574,6 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
 
-	u64 abs_sectors = ptr_disk_sectors(level ? btree_sectors(c) : k.k->size, p);
-	*sectors = insert ? abs_sectors : -abs_sectors;
-
 	struct bch_dev *ca = bch2_dev_tryget(c, p.ptr.dev);
 	if (unlikely(!ca)) {
 		if (insert && p.ptr.dev != BCH_SB_MEMBER_INVALID)
@@ -586,7 +583,9 @@ static int bch2_trigger_pointer(struct btree_trans *trans,
 
 	struct bpos bucket;
 	struct bkey_i_backpointer bp;
-	__bch2_extent_ptr_to_bp(trans->c, ca, btree_id, level, k, p, entry, &bucket, &bp, abs_sectors);
+	bch2_extent_ptr_to_bp(trans->c, ca, btree_id, level, k, p, entry, &bucket, &bp);
+
+	*sectors = insert ? bp.v.bucket_len : -(s64) bp.v.bucket_len;
 
 	if (flags & BTREE_TRIGGER_transactional) {
 		struct bkey_i_alloc_v4 *a = bch2_trans_start_alloc_update(trans, bucket, 0);
-- 
2.45.2

