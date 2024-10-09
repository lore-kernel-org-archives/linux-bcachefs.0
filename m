Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAE1149C4F
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Oct 2024 23:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728518035; cv=none; b=bTKvcG4j5bCyOS1a+14RNm/XlVLfUq55X3iyRF+YHg2sTA8HWzxCeWoWQvkC6FZgC+Lut4TKLptcHlq2JE98cBZnY0UAprLOfb62iQ3SO+Xi79KVQYDNilQcSIPST+Jghou55vNKkEsCfz0MzEXTXA9DO/guVd2ohb74kNXp1SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728518035; c=relaxed/simple;
	bh=ArLhJePNKvcN+XzY5ILFyLfJ3MW5yzFo3O7Jn/aRWwM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ESVt25nK+N3yUM5Bw6s+9l57/aa/WpK4k6K84Uxi4GMt4mhAXxAJIrnN/WPw+exLzrcrqB2v4vJKCC5e2v6o3pcOiJ6xhHHNXYoweWubRVrLvfhP/PBOiKXadEzQzDnvklcmdM8XpT2tXHmWAgtuUTEkf7JLQJg4YlCz4hwTV2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OLyFx8TT; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OLyFx8TT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728518031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uAXBiJCx05V2cSkkgiW+msDSz4SC+RVhWS9+DTyhrAs=;
	b=OLyFx8TTOrpFv7mFQJ0DSLdZZNI+pPisnxWMOi9891lylFAw9KR/UFaZUu5irUFmXQkzdl
	Seq1NpuJxsSginydT0sjBooKhVRPwYrEfq7VXdtolA579sv4z5x0MRDD0f/J/nTPNgZtFD
	Od7nBGpDD3R9Q+fWwFtRdlPEOBU/BcE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: bch2_inode_or_descendents_is_open()
Date: Wed,  9 Oct 2024 19:53:42 -0400
Message-ID: <20241009235342.2249766-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

fsck can now correctly check if inodes in interior snapshot nodes are
open/in use.

- Tweak the vfs inode rhashtable so that the subvolume ID isn't hashed,
  meaning inums in different subvolumes will hash to the same slot. Note
  that this is a hack, and will cause problems if anyone ever has the
  same file in many different snapshots open all at the same time.

- Then check if any of those subvolumes is a descendent of the snapshot
  ID being checked

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs.c    | 106 +++++++++++++++++++++++++++++++++++++-------
 fs/bcachefs/fs.h    |   6 +--
 fs/bcachefs/fsck.c  |   7 ++-
 fs/bcachefs/inode.c |   5 ++-
 4 files changed, 103 insertions(+), 21 deletions(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 23cae92d313d..e9e32d21f82d 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -157,6 +157,20 @@ static bool subvol_inum_eq(subvol_inum a, subvol_inum b)
 	return a.subvol == b.subvol && a.inum == b.inum;
 }
 
+static u32 bch2_vfs_inode_hash_fn(const void *data, u32 len, u32 seed)
+{
+	const subvol_inum *inum = data;
+
+	return jhash(&inum->inum, sizeof(inum->inum), seed);
+}
+
+static u32 bch2_vfs_inode_obj_hash_fn(const void *data, u32 len, u32 seed)
+{
+	const struct bch_inode_info *inode = data;
+
+	return bch2_vfs_inode_hash_fn(&inode->ei_inum, sizeof(inode->ei_inum), seed);
+}
+
 static int bch2_vfs_inode_cmp_fn(struct rhashtable_compare_arg *arg,
 				 const void *obj)
 {
@@ -170,32 +184,93 @@ static const struct rhashtable_params bch2_vfs_inodes_params = {
 	.head_offset		= offsetof(struct bch_inode_info, hash),
 	.key_offset		= offsetof(struct bch_inode_info, ei_inum),
 	.key_len		= sizeof(subvol_inum),
+	.hashfn			= bch2_vfs_inode_hash_fn,
+	.obj_hashfn		= bch2_vfs_inode_obj_hash_fn,
 	.obj_cmpfn		= bch2_vfs_inode_cmp_fn,
 	.automatic_shrinking	= true,
 };
 
-static struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
+int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p)
 {
-	return rhashtable_lookup_fast(&c->vfs_inodes_table, &inum, bch2_vfs_inodes_params);
-}
+	struct bch_fs *c = trans->c;
+	struct rhashtable *ht = &c->vfs_inodes_table;
+	subvol_inum inum = (subvol_inum) { .inum = p.offset };
+	DARRAY(u32) subvols;
+	int ret = 0;
 
-bool bch2_inode_is_open(struct bch_fs *c, struct bpos p)
-{
 	if (!test_bit(BCH_FS_started, &c->flags))
 		return false;
 
-	subvol_inum inum = {
-		.subvol = snapshot_t(c, p.snapshot)->subvol,
-		.inum	= p.offset,
-	};
+	darray_init(&subvols);
+restart_from_top:
+
+	/*
+	 * Tweaked version of __rhashtable_lookup(); we need to get a list of
+	 * subvolumes in which the given inode number is open.
+	 *
+	 * For this to work, we don't include the subvolume ID in the key that
+	 * we hash - all inodes with the same inode number regardless of
+	 * subvolume will hash to the same slot.
+	 *
+	 * This will be less than ideal if the same file is ever open
+	 * simultaneously in many different snapshots:
+	 */
+	rcu_read_lock();
+	struct rhash_lock_head __rcu *const *bkt;
+	struct rhash_head *he;
+	unsigned int hash;
+	struct bucket_table *tbl = rht_dereference_rcu(ht->tbl, ht);
+restart:
+	hash = rht_key_hashfn(ht, tbl, &inum, bch2_vfs_inodes_params);
+	bkt = rht_bucket(tbl, hash);
+	do {
+		struct bch_inode_info *inode;
+
+		rht_for_each_entry_rcu_from(inode, he, rht_ptr_rcu(bkt), tbl, hash, hash) {
+			if (inode->ei_inum.inum == inum.inum) {
+				ret = darray_push_gfp(&subvols, inode->ei_inum.subvol,
+						      GFP_NOWAIT|__GFP_NOWARN);
+				if (ret) {
+					rcu_read_unlock();
+					ret = darray_make_room(&subvols, 1);
+					if (ret)
+						goto err;
+					subvols.nr = 0;
+					goto restart_from_top;
+				}
+			}
+		}
+		/* An object might have been moved to a different hash chain,
+		 * while we walk along it - better check and retry.
+		 */
+	} while (he != RHT_NULLS_MARKER(bkt));
+
+	/* Ensure we see any new tables. */
+	smp_rmb();
+
+	tbl = rht_dereference_rcu(tbl->future_tbl, ht);
+	if (unlikely(tbl))
+		goto restart;
+	rcu_read_unlock();
+
+	darray_for_each(subvols, i) {
+		u32 snap;
+		ret = bch2_subvolume_get_snapshot(trans, *i, &snap);
+		if (ret)
+			goto err;
 
-	/* snapshot tree interior node, can't safely delete while online (yet) */
-	if (!inum.subvol) {
-		bch_warn_ratelimited(c, "%s(): snapshot %u has no subvol, unlinked but can't safely delete", __func__, p.snapshot);
-		return true;
+		ret = bch2_snapshot_is_ancestor(c, snap, p.snapshot);
+		if (ret)
+			break;
 	}
+err:
+	darray_exit(&subvols);
+	return ret;
+}
 
-	return __bch2_inode_hash_find(c, inum) != NULL;
+static struct bch_inode_info *__bch2_inode_hash_find(struct bch_fs *c, subvol_inum inum)
+{
+	return rhashtable_lookup_fast(&c->vfs_inodes_table, &inum, bch2_vfs_inodes_params);
 }
 
 static void __wait_on_freeing_inode(struct bch_fs *c,
@@ -271,7 +346,8 @@ static struct bch_inode_info *bch2_inode_hash_insert(struct bch_fs *c,
 
 	set_bit(EI_INODE_HASHED, &inode->ei_flags);
 retry:
-	if (unlikely(rhashtable_lookup_insert_fast(&c->vfs_inodes_table,
+	if (unlikely(rhashtable_lookup_insert_key(&c->vfs_inodes_table,
+					&inode->ei_inum,
 					&inode->hash,
 					bch2_vfs_inodes_params))) {
 		old = bch2_inode_hash_find(c, trans, inode->ei_inum);
diff --git a/fs/bcachefs/fs.h b/fs/bcachefs/fs.h
index 40dbd5774d0b..59f9f7ae728d 100644
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -146,6 +146,8 @@ struct bch_inode_info *
 __bch2_create(struct mnt_idmap *, struct bch_inode_info *,
 	      struct dentry *, umode_t, dev_t, subvol_inum, unsigned);
 
+int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p);
+
 int bch2_fs_quota_transfer(struct bch_fs *,
 			   struct bch_inode_info *,
 			   struct bch_qid,
@@ -179,8 +181,6 @@ void bch2_inode_update_after_write(struct btree_trans *,
 int __must_check bch2_write_inode(struct bch_fs *, struct bch_inode_info *,
 				  inode_set_fn, void *, unsigned);
 
-bool bch2_inode_is_open(struct bch_fs *c, struct bpos p);
-
 int bch2_setattr_nonsize(struct mnt_idmap *,
 			 struct bch_inode_info *,
 			 struct iattr *);
@@ -198,7 +198,7 @@ int bch2_vfs_init(void);
 
 #define bch2_inode_update_after_write(_trans, _inode, _inode_u, _fields)	({ do {} while (0); })
 
-static inline bool bch2_inode_is_open(struct bch_fs *c, struct bpos p) { return false; }
+static inline int bch2_inode_or_descendents_is_open(struct btree_trans *trans, struct bpos p) { return 0; }
 
 static inline void bch2_evict_subvolume_inodes(struct bch_fs *c,
 					       snapshot_id_list *s) {}
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index f00a36f62323..a1087fd292e4 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -1213,7 +1213,11 @@ static int check_inode(struct btree_trans *trans,
 			if (ret)
 				goto err;
 		} else {
-			if (fsck_err_on(!bch2_inode_is_open(c, k.k->p),
+			ret = bch2_inode_or_descendents_is_open(trans, k.k->p);
+			if (ret < 0)
+				goto err;
+
+			if (fsck_err_on(!ret,
 					trans, inode_unlinked_and_not_open,
 				      "inode %llu%u unlinked and not open",
 				      u.bi_inum, u.bi_snapshot)) {
@@ -1221,6 +1225,7 @@ static int check_inode(struct btree_trans *trans,
 				bch_err_msg(c, ret, "in fsck deleting inode");
 				goto err_noprint;
 			}
+			ret = 0;
 		}
 	}
 
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 9d6040d4ba39..2c037e84fbae 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1244,8 +1244,9 @@ static int delete_ancestor_snapshot_inodes(struct btree_trans *trans, struct bpo
 	if (!unlinked)
 		return 0;
 
-	if (bch2_inode_is_open(trans->c, pos))
-		return 0;
+	ret = lockrestart_do(trans, bch2_inode_or_descendents_is_open(trans, pos));
+	if (ret)
+		return ret < 0 ? ret : 0;
 
 	ret = __bch2_inode_rm_snapshot(trans, pos.offset, pos.snapshot);
 	if (ret)
-- 
2.45.2

