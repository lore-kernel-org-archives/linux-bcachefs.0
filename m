Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0653B796
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930777; cv=none; b=l+4qNcPZ8cfzfR4yE2ta4sv6PQ1z5qzW/bcrJUmvczXrp6LIPk6ZoLgwPkn8NCSWyYsgH0yYlpcg2PHSBEoN2IaDgWFAFk3p1+NQN/4HnWaq4eb5hIm2EO8Y7cDhHbRZild6EmiKu5NT8cOjn6CbJRAv5Yv1Q+mOtIcHIpyL3cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930777; c=relaxed/simple;
	bh=f5bwUzWiFNSiCKl/YwId582DMtVpqEfhZlbYu1s8mAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LOXMBFG+uDCHtzXhQkAl0rvb7RFrU0wMXOPftrf9dQBmOn/ul63AEQQlhGfnGgRh4W19kscuObNpL1VDcNovvznp+uxc0J5UmzdTPALfceeVPaQK24XwttdZEoy5YVVzmencgNLay+QFZPTlzwDhRW1YDrua9yx2LJ0fK2wqT8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I/SGNEHF; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I/SGNEHF"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PwOeENLSVv/pzpgyoiIPCw8eTAMjbfvwUhqEPT0dqvc=;
	b=I/SGNEHFz2uzopfTGBKGQitPAQ5yBfbButG9mAX3VSV68VCIZyjaxETbkQW8G8dhOejSkQ
	zkaZ0LfWPluAJ+tqZgsyBpnKPWNv0WmkpwRsZgX8mn57xHwVVejFQEwUOCQuP73eKPXHhW
	PpTrF4iDEi9In3KYN/kWK10gS2GenIM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/8] bcachefs: bcachefs_metadata_version_backpointer_bucket_gen
Date: Fri, 29 Nov 2024 20:39:13 -0500
Message-ID: <20241130013922.3135792-2-kent.overstreet@linux.dev>
In-Reply-To: <20241130013922.3135792-1-kent.overstreet@linux.dev>
References: <20241130013922.3135792-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

New on disk format version: backpointers new include the generation
number of the bucket they refer to, and the obsolete bucket_offset field
(no longer needed because we no longer store backpointers in alloc keys)
is gone.

This is an expensive forced upgrade - hopefully the last; we have to run
the extents_to_backpointers recovery pass to regenerate backpointers.

It's a forced incompatible upgrade because the alternative would've been
permamently making backpointers bigger, and as one of the biggest btrees
(along with the extents btree) that's not an ideal option.

It's worth it though, because this allows us to make the
check_extents_to_backpointers pass drastically cheaper: an upcoming
patch changes it to sum up backpointers in a bucket and check the sum
against the sector counts for that bucket, only looking for missing
backpointers if they don't match (and then only for specific buckets).

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/backpointers.c    | 18 ------------------
 fs/bcachefs/backpointers.h    |  2 +-
 fs/bcachefs/bcachefs_format.h |  6 ++++--
 fs/bcachefs/sb-downgrade.c    | 16 ++++++++++++++--
 4 files changed, 19 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 702bf62d7fa7..b53d98c762ed 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -28,23 +28,6 @@ int bch2_backpointer_validate(struct bch_fs *c, struct bkey_s_c k,
 	bkey_fsck_err_on(bp.k->p.inode == BCH_SB_MEMBER_INVALID,
 			 c, backpointer_dev_bad,
 			 "backpointer for BCH_SB_MEMBER_INVALID");
-
-	rcu_read_lock();
-	struct bch_dev *ca = bch2_dev_rcu_noerror(c, bp.k->p.inode);
-	if (!ca) {
-		/* these will be caught by fsck */
-		rcu_read_unlock();
-		return 0;
-	}
-
-	struct bpos bucket = bp_pos_to_bucket(ca, bp.k->p);
-	struct bpos bp_pos = bucket_pos_to_bp_noerror(ca, bucket, bp.v->bucket_offset);
-	rcu_read_unlock();
-
-	bkey_fsck_err_on((bp.v->bucket_offset >> MAX_EXTENT_COMPRESS_RATIO_SHIFT) >= ca->mi.bucket_size ||
-			 !bpos_eq(bp.k->p, bp_pos),
-			 c, backpointer_bucket_offset_wrong,
-			 "backpointer bucket_offset wrong (%llu)", (u64) bp.v->bucket_offset);
 fsck_err:
 	return ret;
 }
@@ -76,7 +59,6 @@ void bch2_backpointer_swab(struct bkey_s k)
 {
 	struct bkey_s_backpointer bp = bkey_s_to_backpointer(k);
 
-	bp.v->bucket_offset	= swab40(bp.v->bucket_offset);
 	bp.v->bucket_len	= swab32(bp.v->bucket_len);
 	bch2_bpos_swab(&bp.v->pos);
 }
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 95caeabb8978..caffc68407ab 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -158,7 +158,7 @@ static inline void __bch2_extent_ptr_to_bp(struct bch_fs *c, struct bch_dev *ca,
 		.btree_id	= btree_id,
 		.level		= level,
 		.data_type	= bch2_bkey_ptr_data_type(k, p, entry),
-		.bucket_offset	= bp_bucket_offset,
+		.bucket_gen	= p.ptr.gen,
 		.bucket_len	= sectors,
 		.pos		= k.k->p,
 	};
diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index dc14bfe37e3b..e4bb74d6f439 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -463,7 +463,8 @@ struct bch_backpointer {
 	__u8			btree_id;
 	__u8			level;
 	__u8			data_type;
-	__u64			bucket_offset:40;
+	__u8			bucket_gen;
+	__u32			pad;
 	__u32			bucket_len;
 	struct bpos		pos;
 } __packed __aligned(8);
@@ -677,7 +678,8 @@ struct bch_sb_field_ext {
 	x(disk_accounting_v3,		BCH_VERSION(1, 10))		\
 	x(disk_accounting_inum,		BCH_VERSION(1, 11))		\
 	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))		\
-	x(inode_has_child_snapshots,	BCH_VERSION(1, 13))
+	x(inode_has_child_snapshots,	BCH_VERSION(1, 13))		\
+	x(backpointer_bucket_gen,	BCH_VERSION(1, 14))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index 8767c33c2b51..a2ae0bee99bb 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -81,7 +81,12 @@
 	  BCH_FSCK_ERR_accounting_mismatch)			\
 	x(inode_has_child_snapshots,				\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_inodes),		\
-	  BCH_FSCK_ERR_inode_has_child_snapshots_wrong)
+	  BCH_FSCK_ERR_inode_has_child_snapshots_wrong)		\
+	x(backpointer_bucket_gen,				\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_backpointers_to_extents)|\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
+	  BCH_FSCK_ERR_backpointer_to_missing_ptr,		\
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
@@ -117,7 +122,14 @@
 	  BCH_FSCK_ERR_bkey_version_in_future)			\
 	x(rebalance_work_acct_fix,				\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
-	  BCH_FSCK_ERR_accounting_mismatch)
+	  BCH_FSCK_ERR_accounting_mismatch,			\
+	  BCH_FSCK_ERR_accounting_key_replicas_nr_devs_0,	\
+	  BCH_FSCK_ERR_accounting_key_junk_at_end)		\
+	x(backpointer_bucket_gen,				\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
+	  BCH_FSCK_ERR_backpointer_bucket_offset_wrong,		\
+	  BCH_FSCK_ERR_backpointer_to_missing_ptr,		\
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
 
 struct upgrade_downgrade_entry {
 	u64		recovery_passes;
-- 
2.45.2

