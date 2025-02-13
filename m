Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED1024292F
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Feb 2025 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739472388; cv=none; b=Wb4K/zD8tTOZpeGIJ5m1HapyJXKh3quf52I6h5KE3sp31CTlvGdrjlS487K9TSxcmy6KaIrdRPE3uSxAgY6jWUaxSOFkKY1Y5H7xnO6ttIRmmMso4JdzMywBKIazx6oUfSzjPeX7QgLlTEG7J/QiCRiF9a3HIzbqxf77pzkmJDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739472388; c=relaxed/simple;
	bh=iGi4N5k0StGJqpz5HkCh8z52L1cJ+CF8Ig3FRQRyB+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0u+E9FSj7/93rnB8pJvqKzR8WveAYhd7Wlxu922bnYHwi6qm00b7RUualfyVZnllFQExKaF1WVUza3/DvS1GnSs0Ql8Gv2eEMR24LfjHaGqD21vWNTthf0mP0/ulFE72vqGhlmg1OyTWJhL0xYWz7eJdYLGvGBsolWZ1UaY+5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h94VbgMX; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h94VbgMX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739472384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6T9bggrAv3uFsjx84P4yQFPlHfOeVCpAk4/opTbug8=;
	b=h94VbgMXDqW9PqdXoLaXe4jAHzqyaPklwoV4ZyREkDKjoaptXwNwYsCSwqz/rHMQg7o06w
	7TwlrgFYXn22IdkvrF8xctzGtZ72bBwIlZ5q3/cEPhzrzsqT3o4A8U6djM3/YUEEozi+Rm
	bCd7pg0u1nK9ShmgB5srZjkMNjaICYk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/18] bcachefs: bcachefs_metadata_version_stripe_backpointers
Date: Thu, 13 Feb 2025 13:45:56 -0500
Message-ID: <20250213184607.18237-12-kent.overstreet@linux.dev>
In-Reply-To: <20250213184607.18237-1-kent.overstreet@linux.dev>
References: <20250213184607.18237-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Stripes now have backpointers.

This is needed for proper scrub - stripe checksums need to be verified,
separately from extents within the stripe, since a block may not be full
of live extents but it's still needed for reconstruct.

And this will be needed for (efficient) evacuate/repair paths.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.h    | 15 ++++++++++++++-
 fs/bcachefs/bcachefs_format.h |  3 ++-
 fs/bcachefs/ec.c              | 16 ++++++++++++++--
 fs/bcachefs/move.c            |  3 +++
 fs/bcachefs/sb-downgrade.c    |  3 +++
 5 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 7786731d4ada..16575dbc5736 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -152,7 +152,20 @@ static inline void bch2_extent_ptr_to_bp(struct bch_fs *c,
 			   struct bkey_i_backpointer *bp)
 {
 	bkey_backpointer_init(&bp->k_i);
-	bp->k.p = POS(p.ptr.dev, ((u64) p.ptr.offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset);
+	bp->k.p.inode = p.ptr.dev;
+
+	if (k.k->type != KEY_TYPE_stripe)
+		bp->k.p.offset = ((u64) p.ptr.offset << MAX_EXTENT_COMPRESS_RATIO_SHIFT) + p.crc.offset;
+	else {
+		/*
+		 * Put stripe backpointers where they won't collide with the
+		 * extent backpointers within the stripe:
+		 */
+		struct bkey_s_c_stripe s = bkey_s_c_to_stripe(k);
+		bp->k.p.offset = ((u64) (p.ptr.offset + le16_to_cpu(s.v->sectors)) <<
+				  MAX_EXTENT_COMPRESS_RATIO_SHIFT) - 1;
+	}
+
 	bp->v	= (struct bch_backpointer) {
 		.btree_id	= btree_id,
 		.level		= level,
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index ef5009b18dd5..bf3723a2bca4 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -687,7 +687,8 @@ struct bch_sb_field_ext {
 	x(persistent_inode_cursors,	BCH_VERSION(1, 18))		\
 	x(autofix_errors,		BCH_VERSION(1, 19))		\
 	x(directory_size,		BCH_VERSION(1, 20))		\
-	x(cached_backpointers,		BCH_VERSION(1, 21))
+	x(cached_backpointers,		BCH_VERSION(1, 21))		\
+	x(stripe_backpointers,		BCH_VERSION(1, 22))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index 1aa56d28de33..36590c0ce09f 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -298,10 +298,22 @@ static int mark_stripe_bucket(struct btree_trans *trans,
 	struct bpos bucket = PTR_BUCKET_POS(ca, ptr);
 
 	if (flags & BTREE_TRIGGER_transactional) {
+		struct extent_ptr_decoded p = {
+			.ptr = *ptr,
+			.crc = bch2_extent_crc_unpack(s.k, NULL),
+		};
+		struct bkey_i_backpointer bp;
+		bch2_extent_ptr_to_bp(c, BTREE_ID_stripes, 0, s.s_c, p,
+				      (const union bch_extent_entry *) ptr, &bp);
+
 		struct bkey_i_alloc_v4 *a =
 			bch2_trans_start_alloc_update(trans, bucket, 0);
-		ret = PTR_ERR_OR_ZERO(a) ?:
-			__mark_stripe_bucket(trans, ca, s, ptr_idx, deleting, bucket, &a->v, flags);
+		ret   = PTR_ERR_OR_ZERO(a) ?:
+			__mark_stripe_bucket(trans, ca, s, ptr_idx, deleting, bucket, &a->v, flags) ?:
+			bch2_bucket_backpointer_mod(trans, s.s_c, &bp,
+						    !(flags & BTREE_TRIGGER_overwrite));
+		if (ret)
+			goto err;
 	}
 
 	if (flags & BTREE_TRIGGER_gc) {
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index e0e10deaea73..e944f2791546 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -774,6 +774,9 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		if (!(data_types & BIT(bp.v->data_type)))
 			goto next;
 
+		if (!bp.v->level && bp.v->btree_id == BTREE_ID_stripes)
+			goto next;
+
 		k = bch2_backpointer_get_key(trans, bp, &iter, 0, &last_flushed);
 		ret = bkey_err(k);
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 34fd897680b3..c587334ffb55 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -95,6 +95,9 @@
 	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
 	  BCH_FSCK_ERR_directory_size_mismatch)			\
 	x(cached_backpointers,					\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)		\
+	x(stripe_backpointers,					\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
 	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
 
-- 
2.45.2

