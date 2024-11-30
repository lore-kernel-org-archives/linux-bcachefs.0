Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A82433D9
	for <linux-bcachefs@vger.kernel.org>; Sat, 30 Nov 2024 01:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732930778; cv=none; b=i3UwDsxGq2wk2E3E1gnqcfcp+tzGC/twdXqDRJqQzQEyyVjEklfSscGajFesmHRGgGt/OWfbzxYLyh1NRGiCkneFtpTggw+ZSGvistWBwRHw9hkv5NJlcLOIjZFx75+kJqtfPS+cGW/SZxbubj17eE4OVR7nu7fOHdHNHewKJC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732930778; c=relaxed/simple;
	bh=srSlcw1sDL5lOkj0iOWIxp3n1DEIYQQ7jI3hmgp053g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmMP/rle36kFVnJXCy3GDKnPdVYsBKdg1D5F6Bwu0thk+9QkSVXXg+jJuEkgEgX6B3iG4fiLfEIHyHFB4cj71CEge0//Az88U+1vQtMVECS2WgCE/xAnDIQPgg9rXTvRIj67VrlG+b+SG+Op46HyOEptvo4MgXmNfcXON0DZxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Hsu6Hq4o; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Hsu6Hq4o"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732930773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KcyKtPNIr6i9d1sXTrBQNpoPI9znIWvtSEtjbHLKDdI=;
	b=Hsu6Hq4oICA2XRcjNHrnI6TWYN3lWhQNHS3W5tTupYtlb/SuLI2/mSZCtwTQK8G7O61Vnt
	D3c482+fN2A1TX7jaHfO0pmCo1DLNqSnwvBxVlG/2vsprlsTaTO4H/EvKP/sEe+1YvIWiR
	iuYrZYiXucd8QrZ+aH+2dCCYnCMMqfM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/8] bcachefs: bcachefs_metadata_version_disk_accounting_big_endian
Date: Fri, 29 Nov 2024 20:39:14 -0500
Message-ID: <20241130013922.3135792-3-kent.overstreet@linux.dev>
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

Fix sort order for disk accounting keys.

The typetag is now the most significant byte of the key, meaning disk
accounting keys of the same type now sort together.

This lets us skip over disk accounting keys that aren't mirrored in
memory when reading accounting at startup, instead of having them
interleaved with other counter types.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs_format.h |  3 ++-
 fs/bcachefs/disk_accounting.c | 25 +++++++++++++++++++++----
 fs/bcachefs/disk_accounting.h | 25 +++++++++++++++++--------
 fs/bcachefs/sb-downgrade.c    | 14 ++++++++++++--
 fs/bcachefs/util.h            |  9 +++++++++
 5 files changed, 61 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/bcachefs_format.h b/fs/bcachefs/bcachefs_format.h
index e4bb74d6f439..cef22c15c256 100644
--- a/fs/bcachefs/bcachefs_format.h
+++ b/fs/bcachefs/bcachefs_format.h
@@ -679,7 +679,8 @@ struct bch_sb_field_ext {
 	x(disk_accounting_inum,		BCH_VERSION(1, 11))		\
 	x(rebalance_work_acct_fix,	BCH_VERSION(1, 12))		\
 	x(inode_has_child_snapshots,	BCH_VERSION(1, 13))		\
-	x(backpointer_bucket_gen,	BCH_VERSION(1, 14))
+	x(backpointer_bucket_gen,	BCH_VERSION(1, 14))		\
+	x(disk_accounting_big_endian,	BCH_VERSION(1, 15))
 
 enum bcachefs_metadata_version {
 	bcachefs_metadata_version_min = 9,
diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index 71c49a7ee2fe..77534838497f 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -716,11 +716,23 @@ int bch2_accounting_read(struct bch_fs *c)
 	percpu_memset(c->usage, 0, sizeof(*c->usage));
 	percpu_up_write(&c->mark_lock);
 
-	int ret = for_each_btree_key(trans, iter,
-				BTREE_ID_accounting, POS_MIN,
+	struct btree_iter iter;
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_accounting, POS_MIN,
+			     BTREE_ITER_prefetch|BTREE_ITER_all_snapshots);
+	iter.flags &= ~BTREE_ITER_with_journal;
+	int ret = for_each_btree_key_continue(trans, iter,
 				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k, ({
-			struct bkey u;
-			struct bkey_s_c k = bch2_btree_path_peek_slot_exact(btree_iter_path(trans, &iter), &u);
+			if (k.k->type != KEY_TYPE_accounting)
+				continue;
+
+			struct disk_accounting_pos acc_k;
+			bpos_to_disk_accounting_pos(&acc_k, k.k->p);
+			if (!bch2_accounting_is_mem(acc_k)) {
+				struct disk_accounting_pos next = { .type = acc_k.type + 1 };
+				bch2_btree_iter_set_pos(&iter, disk_accounting_pos_to_bpos(&next));
+				continue;
+			}
+
 			accounting_read_key(trans, k);
 		}));
 	if (ret)
@@ -732,6 +744,11 @@ int bch2_accounting_read(struct bch_fs *c)
 
 	darray_for_each(*keys, i) {
 		if (i->k->k.type == KEY_TYPE_accounting) {
+			struct disk_accounting_pos acc_k;
+			bpos_to_disk_accounting_pos(&acc_k, i->k->k.p);
+			if (!bch2_accounting_is_mem(acc_k))
+				continue;
+
 			struct bkey_s_c k = bkey_i_to_s_c(i->k);
 			unsigned idx = eytzinger0_find(acc->k.data, acc->k.nr,
 						sizeof(acc->k.data[0]),
diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
index 566aa2a8539d..cb20f723b410 100644
--- a/fs/bcachefs/disk_accounting.h
+++ b/fs/bcachefs/disk_accounting.h
@@ -63,20 +63,24 @@ static inline void fs_usage_data_type_to_base(struct bch_fs_usage_base *fs_usage
 
 static inline void bpos_to_disk_accounting_pos(struct disk_accounting_pos *acc, struct bpos p)
 {
-	acc->_pad = p;
+	BUILD_BUG_ON(sizeof(*acc) != sizeof(p));
+
 #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	bch2_bpos_swab(&acc->_pad);
+	acc->_pad = p;
+#else
+	memcpy_swab(acc, &p, sizeof(p));
 #endif
 }
 
-static inline struct bpos disk_accounting_pos_to_bpos(struct disk_accounting_pos *k)
+static inline struct bpos disk_accounting_pos_to_bpos(struct disk_accounting_pos *acc)
 {
-	struct bpos ret = k->_pad;
-
+	struct bpos p;
 #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	bch2_bpos_swab(&ret);
+	p = acc->_pad;
+#else
+	memcpy_swab(&p, acc, sizeof(p));
 #endif
-	return ret;
+	return p;
 }
 
 int bch2_disk_accounting_mod(struct btree_trans *, struct disk_accounting_pos *,
@@ -114,6 +118,11 @@ enum bch_accounting_mode {
 int bch2_accounting_mem_insert(struct bch_fs *, struct bkey_s_c_accounting, enum bch_accounting_mode);
 void bch2_accounting_mem_gc(struct bch_fs *);
 
+static inline bool bch2_accounting_is_mem(struct disk_accounting_pos acc)
+{
+	return acc.type != BCH_DISK_ACCOUNTING_inum;
+}
+
 /*
  * Update in memory counters so they match the btree update we're doing; called
  * from transaction commit path
@@ -130,7 +139,7 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
 
 	EBUG_ON(gc && !acc->gc_running);
 
-	if (acc_k.type == BCH_DISK_ACCOUNTING_inum)
+	if (!bch2_accounting_is_mem(acc_k))
 		return 0;
 
 	if (mode == BCH_ACCOUNTING_normal) {
diff --git a/fs/bcachefs/sb-downgrade.c b/fs/bcachefs/sb-downgrade.c
index a2ae0bee99bb..fe453e178ea8 100644
--- a/fs/bcachefs/sb-downgrade.c
+++ b/fs/bcachefs/sb-downgrade.c
@@ -86,7 +86,12 @@
 	  BIT_ULL(BCH_RECOVERY_PASS_check_backpointers_to_extents)|\
 	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
 	  BCH_FSCK_ERR_backpointer_to_missing_ptr,		\
-	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)		\
+	x(disk_accounting_big_endian,				\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
+	  BCH_FSCK_ERR_accounting_mismatch,			\
+	  BCH_FSCK_ERR_accounting_key_replicas_nr_devs_0,	\
+	  BCH_FSCK_ERR_accounting_key_junk_at_end)
 
 #define DOWNGRADE_TABLE()					\
 	x(bucket_stripe_sectors,				\
@@ -129,7 +134,12 @@
 	  BIT_ULL(BCH_RECOVERY_PASS_check_extents_to_backpointers),\
 	  BCH_FSCK_ERR_backpointer_bucket_offset_wrong,		\
 	  BCH_FSCK_ERR_backpointer_to_missing_ptr,		\
-	  BCH_FSCK_ERR_ptr_to_missing_backpointer)
+	  BCH_FSCK_ERR_ptr_to_missing_backpointer)		\
+	x(disk_accounting_big_endian,				\
+	  BIT_ULL(BCH_RECOVERY_PASS_check_allocations),		\
+	  BCH_FSCK_ERR_accounting_mismatch,			\
+	  BCH_FSCK_ERR_accounting_key_replicas_nr_devs_0,	\
+	  BCH_FSCK_ERR_accounting_key_junk_at_end)
 
 struct upgrade_downgrade_entry {
 	u64		recovery_passes;
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 5e4820c8fa44..c292b9ce8240 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -709,4 +709,13 @@ static inline bool test_bit_le64(size_t bit, __le64 *addr)
 	return (addr[bit / 64] & cpu_to_le64(BIT_ULL(bit % 64))) != 0;
 }
 
+static inline void memcpy_swab(void *_dst, void *_src, size_t len)
+{
+	u8 *dst = _dst + len;
+	u8 *src = _src;
+
+	while (len--)
+		*--dst = *src++;
+}
+
 #endif /* _BCACHEFS_UTIL_H */
-- 
2.45.2

