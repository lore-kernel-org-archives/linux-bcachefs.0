Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FE15B0FE
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 04:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729226179; cv=none; b=A85LTnmgPfytaoRxS14oMaqbPWnBu93logXAroSocnJLK9JCk0uYtKgaGW2W4rMDqmi6o5EUtMcXBVHY9nJzEqUNWYwkNAkCQK4rYx3ea4mddaZMbm32rpj/h9idzO8fvjmAMQSstFzRnm71HvVD47qBhBGTKSLJ6MYI2qDHCv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729226179; c=relaxed/simple;
	bh=KX389xwfODUCv7yxRpiwhdCc+x+nhpP/FJ7vlO0bC8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOv2xT4bx1K1wpaRhGwWTluMM1p5AjrfXJQJfsSTdB+5jlxARE6WA+33gMY5x6y6x0NK9iQz6IeJ0vHBsUAgkJq6Ly0r8gxcO8Cvmxy9LkVnG74olr3pM2/LdQNhA2T6F8sypto8HlE0WGkfTiWJAVoTcmrsSfWX+fI/z2j2Oac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DqrzpjSs; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DqrzpjSs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729226175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LfLtSr0z4SmiH1Ffc8WZbdR4ZmmhHSNKyibmOD4AIeU=;
	b=DqrzpjSsTXjZQUQAYyfywOg9+p9aOZF1TYrfBcxhROlQ5EBUiIP5JVewV6oubTNbNmL2su
	eSXwOY3Htaz38LMgtcnD3Z37YFk3KxZrDXkyexeFS3by5rgPAIMwWHq556jRvLBASiBBdN
	PpiIgZByVj4o/oinWKJiQOHUxlOFfJk=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 9/9] bcachefs: Don't use commit_do() unnecessarily
Date: Fri, 18 Oct 2024 00:35:59 -0400
Message-ID: <20241018043602.4067344-10-kent.overstreet@linux.dev>
In-Reply-To: <20241018043602.4067344-1-kent.overstreet@linux.dev>
References: <20241018043602.4067344-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Using commit_do() to call alloc_sectors_start_trans() breaks when we're
randomly injecting transaction restarts - the restart in the commit
causes us to leak the lock that alloc_sectorS_start_trans() takes.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c      |  2 +-
 fs/bcachefs/alloc_foreground.c      |  2 +-
 fs/bcachefs/btree_io.c              |  2 +-
 fs/bcachefs/btree_iter.h            |  2 ++
 fs/bcachefs/btree_update.c          |  4 ++--
 fs/bcachefs/btree_update.h          |  2 +-
 fs/bcachefs/btree_update_interior.c |  4 +---
 fs/bcachefs/disk_accounting.c       |  6 ++++--
 fs/bcachefs/ec.c                    | 18 +++++++++---------
 fs/bcachefs/fs.c                    |  2 +-
 fs/bcachefs/fsck.c                  |  2 +-
 fs/bcachefs/inode.c                 |  3 +--
 fs/bcachefs/io_read.c               |  4 ++--
 fs/bcachefs/io_write.c              |  4 ++--
 fs/bcachefs/quota.c                 |  2 +-
 fs/bcachefs/rebalance.c             |  4 +++-
 fs/bcachefs/recovery.c              |  2 +-
 fs/bcachefs/subvolume.c             |  7 +++----
 fs/bcachefs/super.c                 |  2 +-
 fs/bcachefs/tests.c                 |  4 ++--
 fs/bcachefs/xattr.c                 |  2 +-
 21 files changed, 41 insertions(+), 39 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 69c7fc97e467..c84a91572a1d 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1977,7 +1977,7 @@ static void bch2_do_discards_fast_work(struct work_struct *work)
 					     ca->mi.bucket_size,
 					     GFP_KERNEL);
 
-		int ret = bch2_trans_do(c, NULL, NULL,
+		int ret = bch2_trans_commit_do(c, NULL, NULL,
 			BCH_WATERMARK_btree|
 			BCH_TRANS_COMMIT_no_enospc,
 			bch2_clear_bucket_needs_discard(trans, POS(ca->dev_idx, bucket)));
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index d0e0b56892e3..5836870ab882 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -684,7 +684,7 @@ struct open_bucket *bch2_bucket_alloc(struct bch_fs *c, struct bch_dev *ca,
 	struct bch_dev_usage usage;
 	struct open_bucket *ob;
 
-	bch2_trans_do(c, NULL, NULL, 0,
+	bch2_trans_do(c,
 		      PTR_ERR_OR_ZERO(ob = bch2_bucket_alloc_trans(trans, ca, watermark,
 							data_type, cl, false, &usage)));
 	return ob;
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index cf933409d385..6296a11ccb09 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1871,7 +1871,7 @@ static void btree_node_write_work(struct work_struct *work)
 
 		}
 	} else {
-		ret = bch2_trans_do(c, NULL, NULL, 0,
+		ret = bch2_trans_do(c,
 			bch2_btree_node_update_key_get_iter(trans, b, &wbio->key,
 					BCH_WATERMARK_interior_updates|
 					BCH_TRANS_COMMIT_journal_reclaim|
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 31a58bf46fdb..0bda054f80d7 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -912,6 +912,8 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
 	_ret;								\
 })
 
+#define bch2_trans_do(_c, _do)	bch2_trans_run(_c, lockrestart_do(trans, _do))
+
 struct btree_trans *__bch2_trans_get(struct bch_fs *, unsigned);
 void bch2_trans_put(struct btree_trans *);
 
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 514df618548e..5d809e8bd170 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -668,7 +668,7 @@ int bch2_btree_insert(struct bch_fs *c, enum btree_id id, struct bkey_i *k,
 		      struct disk_reservation *disk_res, int flags,
 		      enum btree_iter_update_trigger_flags iter_flags)
 {
-	return bch2_trans_do(c, disk_res, NULL, flags,
+	return bch2_trans_commit_do(c, disk_res, NULL, flags,
 			     bch2_btree_insert_trans(trans, id, k, iter_flags));
 }
 
@@ -865,7 +865,7 @@ __bch2_fs_log_msg(struct bch_fs *c, unsigned commit_flags, const char *fmt,
 		memcpy(l->d, buf.buf, buf.pos);
 		c->journal.early_journal_entries.nr += jset_u64s(u64s);
 	} else {
-		ret = bch2_trans_do(c, NULL, NULL,
+		ret = bch2_trans_commit_do(c, NULL, NULL,
 			BCH_TRANS_COMMIT_lazy_rw|commit_flags,
 			__bch2_trans_log_msg(trans, &buf, u64s));
 	}
diff --git a/fs/bcachefs/btree_update.h b/fs/bcachefs/btree_update.h
index 6a454f2fa005..70b3c989fac2 100644
--- a/fs/bcachefs/btree_update.h
+++ b/fs/bcachefs/btree_update.h
@@ -192,7 +192,7 @@ static inline int bch2_trans_commit(struct btree_trans *trans,
 	nested_lockrestart_do(_trans, _do ?: bch2_trans_commit(_trans, (_disk_res),\
 					(_journal_seq), (_flags)))
 
-#define bch2_trans_do(_c, _disk_res, _journal_seq, _flags, _do)		\
+#define bch2_trans_commit_do(_c, _disk_res, _journal_seq, _flags, _do)		\
 	bch2_trans_run(_c, commit_do(trans, _disk_res, _journal_seq, _flags, _do))
 
 #define trans_for_each_update(_trans, _i)				\
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 190bc1e81756..64f0928e1137 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2239,10 +2239,8 @@ static void async_btree_node_rewrite_work(struct work_struct *work)
 	struct async_btree_rewrite *a =
 		container_of(work, struct async_btree_rewrite, work);
 	struct bch_fs *c = a->c;
-	int ret;
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
-		      async_btree_node_rewrite_trans(trans, a));
+	int ret = bch2_trans_do(c, async_btree_node_rewrite_trans(trans, a));
 	bch_err_fn_ratelimited(c, ret);
 	bch2_write_ref_put(c, BCH_WRITE_REF_node_rewrite);
 	kfree(a);
diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index e309fb78529b..07eb8fa1b026 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -856,8 +856,10 @@ int bch2_dev_usage_init(struct bch_dev *ca, bool gc)
 	};
 	u64 v[3] = { ca->mi.nbuckets - ca->mi.first_bucket, 0, 0 };
 
-	int ret = bch2_trans_do(c, NULL, NULL, 0,
-			bch2_disk_accounting_mod(trans, &acc, v, ARRAY_SIZE(v), gc));
+	int ret = bch2_trans_do(c, ({
+		bch2_disk_accounting_mod(trans, &acc, v, ARRAY_SIZE(v), gc) ?:
+		(!gc ? bch2_trans_commit(trans, NULL, NULL, 0) : 0);
+	}));
 	bch_err_fn(c, ret);
 	return ret;
 }
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index e410cfe37b1a..a2303425959d 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1186,7 +1186,7 @@ static void ec_stripe_delete_work(struct work_struct *work)
 		if (!idx)
 			break;
 
-		int ret = bch2_trans_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+		int ret = bch2_trans_commit_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
 					ec_stripe_delete(trans, idx));
 		bch_err_fn(c, ret);
 		if (ret)
@@ -1519,14 +1519,14 @@ static void ec_stripe_create(struct ec_stripe_new *s)
 		goto err;
 	}
 
-	ret = bch2_trans_do(c, &s->res, NULL,
-			    BCH_TRANS_COMMIT_no_check_rw|
-			    BCH_TRANS_COMMIT_no_enospc,
-			    ec_stripe_key_update(trans,
-					s->have_existing_stripe
-					? bkey_i_to_stripe(&s->existing_stripe.key)
-					: NULL,
-					bkey_i_to_stripe(&s->new_stripe.key)));
+	ret = bch2_trans_commit_do(c, &s->res, NULL,
+		BCH_TRANS_COMMIT_no_check_rw|
+		BCH_TRANS_COMMIT_no_enospc,
+		ec_stripe_key_update(trans,
+				     s->have_existing_stripe
+				     ? bkey_i_to_stripe(&s->existing_stripe.key)
+				     : NULL,
+				     bkey_i_to_stripe(&s->new_stripe.key)));
 	bch_err_msg(c, ret, "creating stripe key");
 	if (ret) {
 		goto err;
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 165d95994bd2..506b9a2b5bd7 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -658,7 +658,7 @@ static struct dentry *bch2_lookup(struct inode *vdir, struct dentry *dentry,
 	struct bch_hash_info hash = bch2_hash_info_init(c, &dir->ei_inode);
 
 	struct bch_inode_info *inode;
-	bch2_trans_do(c, NULL, NULL, 0,
+	bch2_trans_do(c,
 		PTR_ERR_OR_ZERO(inode = bch2_lookup_trans(trans, inode_inum(dir),
 							  &hash, &dentry->d_name)));
 	if (IS_ERR(inode))
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index a1087fd292e4..807098e76e7a 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -2509,7 +2509,7 @@ static int check_root_trans(struct btree_trans *trans)
 /* Get root directory, create if it doesn't exist: */
 int bch2_check_root(struct bch_fs *c)
 {
-	int ret = bch2_trans_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+	int ret = bch2_trans_commit_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
 		check_root_trans(trans));
 	bch_err_fn(c, ret);
 	return ret;
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 2c037e84fbae..47544dc91d9e 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -1087,8 +1087,7 @@ int bch2_inode_find_by_inum_trans(struct btree_trans *trans,
 int bch2_inode_find_by_inum(struct bch_fs *c, subvol_inum inum,
 			    struct bch_inode_unpacked *inode)
 {
-	return bch2_trans_do(c, NULL, NULL, 0,
-		bch2_inode_find_by_inum_trans(trans, inum, inode));
+	return bch2_trans_do(c, bch2_inode_find_by_inum_trans(trans, inum, inode));
 }
 
 int bch2_inode_nlink_inc(struct bch_inode_unpacked *bi)
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index f00beff9ca0e..fc246f342820 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -557,8 +557,8 @@ static int __bch2_rbio_narrow_crcs(struct btree_trans *trans,
 
 static noinline void bch2_rbio_narrow_crcs(struct bch_read_bio *rbio)
 {
-	bch2_trans_do(rbio->c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
-		      __bch2_rbio_narrow_crcs(trans, rbio));
+	bch2_trans_commit_do(rbio->c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc,
+			     __bch2_rbio_narrow_crcs(trans, rbio));
 }
 
 /* Inner part that may run in process context */
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index b5fe9e0dc155..8609e25e450f 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -1437,7 +1437,7 @@ static void __bch2_write(struct bch_write_op *op)
 		 * freeing up space on specific disks, which means that
 		 * allocations for specific disks may hang arbitrarily long:
 		 */
-		ret = bch2_trans_do(c, NULL, NULL, 0,
+		ret = bch2_trans_run(c, lockrestart_do(trans,
 			bch2_alloc_sectors_start_trans(trans,
 				op->target,
 				op->opts.erasure_code && !(op->flags & BCH_WRITE_CACHED),
@@ -1447,7 +1447,7 @@ static void __bch2_write(struct bch_write_op *op)
 				op->nr_replicas_required,
 				op->watermark,
 				op->flags,
-				&op->cl, &wp));
+				&op->cl, &wp)));
 		if (unlikely(ret)) {
 			if (bch2_err_matches(ret, BCH_ERR_operation_blocked))
 				break;
diff --git a/fs/bcachefs/quota.c b/fs/bcachefs/quota.c
index c32a05e252e2..74f45a8162ad 100644
--- a/fs/bcachefs/quota.c
+++ b/fs/bcachefs/quota.c
@@ -869,7 +869,7 @@ static int bch2_set_quota(struct super_block *sb, struct kqid qid,
 	bkey_quota_init(&new_quota.k_i);
 	new_quota.k.p = POS(qid.type, from_kqid(&init_user_ns, qid));
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 			    bch2_set_quota_trans(trans, &new_quota, qdq)) ?:
 		__bch2_quota_set(c, bkey_i_to_s_c(&new_quota.k_i), qdq);
 
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 2d299a37cf07..cd6647374353 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -70,7 +70,9 @@ static int __bch2_set_rebalance_needs_scan(struct btree_trans *trans, u64 inum)
 
 int bch2_set_rebalance_needs_scan(struct bch_fs *c, u64 inum)
 {
-	int ret = bch2_trans_do(c, NULL, NULL, BCH_TRANS_COMMIT_no_enospc|BCH_TRANS_COMMIT_lazy_rw,
+	int ret = bch2_trans_commit_do(c, NULL, NULL,
+				       BCH_TRANS_COMMIT_no_enospc|
+				       BCH_TRANS_COMMIT_lazy_rw,
 			    __bch2_set_rebalance_needs_scan(trans, inum));
 	rebalance_wakeup(c);
 	return ret;
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 55e1504a8130..454b5a32dd7f 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1091,7 +1091,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 
 	bch2_inode_init_early(c, &lostfound_inode);
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 		bch2_create_trans(trans,
 				  BCACHEFS_ROOT_SUBVOL_INUM,
 				  &root_inode, &lostfound_inode,
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index 91d8187ee168..80e5efaff524 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -319,8 +319,7 @@ int bch2_subvol_is_ro_trans(struct btree_trans *trans, u32 subvol)
 
 int bch2_subvol_is_ro(struct bch_fs *c, u32 subvol)
 {
-	return bch2_trans_do(c, NULL, NULL, 0,
-		bch2_subvol_is_ro_trans(trans, subvol));
+	return bch2_trans_do(c, bch2_subvol_is_ro_trans(trans, subvol));
 }
 
 int bch2_snapshot_get_subvol(struct btree_trans *trans, u32 snapshot,
@@ -676,8 +675,8 @@ static int __bch2_fs_upgrade_for_subvolumes(struct btree_trans *trans)
 /* set bi_subvol on root inode */
 int bch2_fs_upgrade_for_subvolumes(struct bch_fs *c)
 {
-	int ret = bch2_trans_do(c, NULL, NULL, BCH_TRANS_COMMIT_lazy_rw,
-				__bch2_fs_upgrade_for_subvolumes(trans));
+	int ret = bch2_trans_commit_do(c, NULL, NULL, BCH_TRANS_COMMIT_lazy_rw,
+				       __bch2_fs_upgrade_for_subvolumes(trans));
 	bch_err_fn(c, ret);
 	return ret;
 }
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 77d811a539af..657fd3759e7b 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1972,7 +1972,7 @@ int bch2_dev_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
 		};
 		u64 v[3] = { nbuckets - old_nbuckets, 0, 0 };
 
-		ret   = bch2_trans_do(ca->fs, NULL, NULL, 0,
+		ret   = bch2_trans_commit_do(ca->fs, NULL, NULL, 0,
 				bch2_disk_accounting_mod(trans, &acc, v, ARRAY_SIZE(v), false)) ?:
 			bch2_dev_freespace_init(c, ca, old_nbuckets, nbuckets);
 		if (ret)
diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index b2f209743afe..315038a0a92d 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -450,7 +450,7 @@ static int insert_test_overlapping_extent(struct bch_fs *c, u64 inum, u64 start,
 	k.k_i.k.p.snapshot = snapid;
 	k.k_i.k.size = len;
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 		bch2_btree_insert_nonextent(trans, BTREE_ID_extents, &k.k_i,
 					    BTREE_UPDATE_internal_snapshot_node));
 	bch_err_fn(c, ret);
@@ -510,7 +510,7 @@ static int test_snapshots(struct bch_fs *c, u64 nr)
 	if (ret)
 		return ret;
 
-	ret = bch2_trans_do(c, NULL, NULL, 0,
+	ret = bch2_trans_commit_do(c, NULL, NULL, 0,
 		      bch2_snapshot_node_create(trans, U32_MAX,
 						snapids,
 						snapid_subvols,
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index 56c8d3fe55a4..952aca400faf 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -330,7 +330,7 @@ static int bch2_xattr_get_handler(const struct xattr_handler *handler,
 {
 	struct bch_inode_info *inode = to_bch_ei(vinode);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	int ret = bch2_trans_do(c, NULL, NULL, 0,
+	int ret = bch2_trans_do(c,
 		bch2_xattr_get_trans(trans, inode, name, buffer, size, handler->flags));
 
 	if (ret < 0 && bch2_err_matches(ret, ENOENT))
-- 
2.45.2

