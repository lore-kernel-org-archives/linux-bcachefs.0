Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440361A0BE1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912069; cv=none; b=M9nbv8LWmrd7Tw8qDtnh3jk/GhRfcEoVa8o1f3wXOIVOc2bJJLaUUsvinfeT+E+iy0MLTUQaPG128LoiZr63u5vxfoOO55ILcMQFXtaEe1ze2nGX5oaY+mbHuhrPVcoNKbfEIGlJ/KEOSvDYgbM89KztFFmM3aNjGnmxNQCNTMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912069; c=relaxed/simple;
	bh=fa2mDDO8tUtAoPQLafPD5hwyLuYEbQol6CaKy+argMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Haj3ZY01eCFF/kj15dhDbCJDWcXOtyEKwKwfWOAiCN1kERCAa5L1aH9Fa2jijscTkGBJx3tFmIUeHfNWSn95TS53a3okwzIAttJdB68g5dOJX7MQsjzw1o2cFIZOvOPe4S401mCXlIByFzF283tXlpluakRXdNaX0rIHWcAdJow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/34] bcachefs: Use separate rhltable for bch2_inode_or_descendents_is_open()
Date: Fri, 29 Nov 2024 15:27:01 -0500
Message-ID: <20241129202736.2713679-3-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/bcachefs.h |  1 +
 fs/bcachefs/fs.c       | 39 ++++++++++++++++++++++++++++++---------
 fs/bcachefs/fs.h       |  1 +
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 11f9ed42a9da..f1d8c821d27a 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -1020,6 +1020,7 @@ struct bch_fs {
 	struct list_head	vfs_inodes_list;
 	struct mutex		vfs_inodes_lock;
 	struct rhashtable	vfs_inodes_table;
+	struct rhltable		vfs_inodes_by_inum_table;
 
 	/* VFS IO PATH - fs-io.c */
 	struct bio_set		writepage_bioset;
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 50d323fca001..c6e7df7c67fa 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -39,6 +39,7 @@
 #include <linux/posix_acl.h>
 #include <linux/random.h>
 #include <linux/seq_file.h>
+#include <linux/siphash.h>
 #include <linux/statfs.h>
 #include <linux/string.h>
 #include <linux/xattr.h>
@@ -176,8 +177,9 @@ static bool subvol_inum_eq(subvol_inum a, subvol_inum b)
 static u32 bch2_vfs_inode_hash_fn(const void *data, u32 len, u32 seed)
 {
 	const subvol_inum *inum = data;
+	siphash_key_t k = { .key[0] = seed };
 
-	return jhash(&inum->inum, sizeof(inum->inum), seed);
+	return siphash_2u64(inum->subvol, inum->inum, &k);
 }
 
 static u32 bch2_vfs_inode_obj_hash_fn(const void *data, u32 len, u32 seed)
@@ -206,11 +208,18 @@ static const struct rhashtable_params bch2_vfs_inodes_params = {
 	.automatic_shrinking	= true,
 };
 
+static const struct rhashtable_params bch2_vfs_inodes_by_inum_params = {
+	.head_offset		= offsetof(struct bch_inode_info, by_inum_hash),
+	.key_offset		= offsetof(struct bch_inode_info, ei_inum.inum),
+	.key_len		= sizeof(u64),
+	.automatic_shrinking	= true,
+};
+
 int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p)
 {
 	struct bch_fs *c = trans->c;
-	struct rhashtable *ht = &c->vfs_inodes_table;
-	subvol_inum inum = (subvol_inum) { .inum = p.offset };
+	struct rhltable *ht = &c->vfs_inodes_by_inum_table;
+	u64 inum = p.offset;
 	DARRAY(u32) subvols;
 	int ret = 0;
 
@@ -235,15 +244,15 @@ int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p)
 	struct rhash_lock_head __rcu *const *bkt;
 	struct rhash_head *he;
 	unsigned int hash;
-	struct bucket_table *tbl = rht_dereference_rcu(ht->tbl, ht);
+	struct bucket_table *tbl = rht_dereference_rcu(ht->ht.tbl, &ht->ht);
 restart:
-	hash = rht_key_hashfn(ht, tbl, &inum, bch2_vfs_inodes_params);
+	hash = rht_key_hashfn(&ht->ht, tbl, &inum, bch2_vfs_inodes_by_inum_params);
 	bkt = rht_bucket(tbl, hash);
 	do {
 		struct bch_inode_info *inode;
 
 		rht_for_each_entry_rcu_from(inode, he, rht_ptr_rcu(bkt), tbl, hash, hash) {
-			if (inode->ei_inum.inum == inum.inum) {
+			if (inode->ei_inum.inum == inum) {
 				ret = darray_push_gfp(&subvols, inode->ei_inum.subvol,
 						      GFP_NOWAIT|__GFP_NOWARN);
 				if (ret) {
@@ -264,7 +273,7 @@ int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p)
 	/* Ensure we see any new tables. */
 	smp_rmb();
 
-	tbl = rht_dereference_rcu(tbl->future_tbl, ht);
+	tbl = rht_dereference_rcu(tbl->future_tbl, &ht->ht);
 	if (unlikely(tbl))
 		goto restart;
 	rcu_read_unlock();
@@ -343,7 +352,11 @@ static void bch2_inode_hash_remove(struct bch_fs *c, struct bch_inode_info *inod
 	spin_unlock(&inode->v.i_lock);
 
 	if (remove) {
-		int ret = rhashtable_remove_fast(&c->vfs_inodes_table,
+		int ret = rhltable_remove(&c->vfs_inodes_by_inum_table,
+					&inode->by_inum_hash, bch2_vfs_inodes_by_inum_params);
+		BUG_ON(ret);
+
+		ret = rhashtable_remove_fast(&c->vfs_inodes_table,
 					&inode->hash, bch2_vfs_inodes_params);
 		BUG_ON(ret);
 		inode->v.i_hash.pprev = NULL;
@@ -388,6 +401,11 @@ static struct bch_inode_info *bch2_inode_hash_insert(struct bch_fs *c,
 		discard_new_inode(&inode->v);
 		return old;
 	} else {
+		int ret = rhltable_insert(&c->vfs_inodes_by_inum_table,
+					  &inode->by_inum_hash,
+					  bch2_vfs_inodes_by_inum_params);
+		BUG_ON(ret);
+
 		inode_fake_hash(&inode->v);
 
 		inode_sb_list_add(&inode->v);
@@ -2359,13 +2377,16 @@ static int bch2_init_fs_context(struct fs_context *fc)
 
 void bch2_fs_vfs_exit(struct bch_fs *c)
 {
+	if (c->vfs_inodes_by_inum_table.ht.tbl)
+		rhltable_destroy(&c->vfs_inodes_by_inum_table);
 	if (c->vfs_inodes_table.tbl)
 		rhashtable_destroy(&c->vfs_inodes_table);
 }
 
 int bch2_fs_vfs_init(struct bch_fs *c)
 {
-	return rhashtable_init(&c->vfs_inodes_table, &bch2_vfs_inodes_params);
+	return rhashtable_init(&c->vfs_inodes_table, &bch2_vfs_inodes_params) ?:
+		rhltable_init(&c->vfs_inodes_by_inum_table, &bch2_vfs_inodes_by_inum_params);
 }
 
 static struct file_system_type bcache_fs_type = {
diff --git a/fs/bcachefs/fs.h b/fs/bcachefs/fs.h
index 59f9f7ae728d..dd2198541455 100644
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -14,6 +14,7 @@
 struct bch_inode_info {
 	struct inode		v;
 	struct rhash_head	hash;
+	struct rhlist_head	by_inum_hash;
 	subvol_inum		ei_inum;
 
 	struct list_head	ei_vfs_inode_list;
-- 
2.45.2

