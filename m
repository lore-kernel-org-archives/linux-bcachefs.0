Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2C225740
	for <linux-bcachefs@vger.kernel.org>; Fri, 23 Aug 2024 03:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724383218; cv=none; b=KSqi7fgWhPYVdTQaqbKYgmXZDZ13ARpTtUNxpCO4CNyIYGzxsIGBZhjQbHNK9U066cZiqCKFzDHnLQz4/7VtCq/ElnQtZ7XmyN1X/A3L/ckNd+YVeF2KiW0+5y87VAUg22T8BI+HjmCYEj/IGmSOiD8bgPqAaw6cJYrS7FMB9TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724383218; c=relaxed/simple;
	bh=eB58hHDqk1em9OZVfRdeIxjwv+XgL7FEdMCZMChYpC0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ELDVzR8a17ykkgZ+jmlbGkCj62SLtCdlQ+YPJpmLkUdINPjVV1oqKkHiXKN7mnaWaWb+GUJH99p1F7sRC6SvWaVuv2CkAjhbgVD82S9P6bBJ9I5Mgp3ItzUJ+Cd8otBh/GhioRUvtxNX0CfFy99rfVrLH/iP0odBo2vVYFOQqTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sRqJLCG4; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sRqJLCG4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724383213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1G+1z+3fDUC9nUFepNnbT58XaeAXVmyPg6wTBI+VKAg=;
	b=sRqJLCG4+1Tvv4Dq4Gd2MAePGR1kXtnbcI3lB3FtHuK5LsfX5fP157Kl5OJRWxiNhm2gMT
	Ub1tP5uzZP1/nFprc6kWnUQ32gE7yHZ3ZISMrq47pwCOYM5bUumXW9VN1Pcit32TCrdlaW
	2vFCtF/G1Jc5ApSXNAlmyP8mb7m0xsw=
From: Youling Tang <youling.tang@linux.dev>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	youling.tang@linux.dev,
	Youling Tang <tangyouling@kylinos.cn>
Subject: [PATCH] bcachefs: Remove the handling of bch2_trans_iter_exit() in __bch2_bkey_get_iter()
Date: Fri, 23 Aug 2024 11:19:55 +0800
Message-Id: <20240823031955.202795-1-youling.tang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Youling Tang <tangyouling@kylinos.cn>

- Reduces bkey_err() calls.
- Avoid redundant calls to bch2_trans_iter_exit() in some functions.

Signed-off-by: Youling Tang <tangyouling@kylinos.cn>
---
 fs/bcachefs/alloc_background.c | 9 +++++----
 fs/bcachefs/btree_iter.h       | 5 ++---
 fs/bcachefs/fsck.c             | 5 +++--
 fs/bcachefs/inode.c            | 4 ++--
 fs/bcachefs/io_write.c         | 2 +-
 fs/bcachefs/lru.c              | 2 +-
 fs/bcachefs/move.c             | 4 +++-
 fs/bcachefs/movinggc.c         | 3 ++-
 fs/bcachefs/quota.c            | 3 ++-
 fs/bcachefs/subvolume.c        | 5 +++--
 10 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index fd3a2522bc3e..9ac5c0a62041 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -460,7 +460,7 @@ bch2_trans_start_alloc_update_noupdate(struct btree_trans *trans, struct btree_i
 					       BTREE_ITER_intent);
 	int ret = bkey_err(k);
 	if (unlikely(ret))
-		return ERR_PTR(ret);
+		goto err;
 
 	struct bkey_i_alloc_v4 *a = bch2_alloc_to_v4_mut_inlined(trans, k);
 	ret = PTR_ERR_OR_ZERO(a);
@@ -693,7 +693,7 @@ static int bch2_bucket_do_index(struct btree_trans *trans,
 			     BTREE_ITER_intent);
 	ret = bkey_err(old);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (ca->mi.freespace_initialized &&
 	    c->curr_recovery_pass > BCH_RECOVERY_PASS_check_alloc_info &&
@@ -738,7 +738,7 @@ static noinline int bch2_bucket_gen_update(struct btree_trans *trans,
 			       BTREE_ITER_with_updates);
 	ret = bkey_err(k);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (k.k->type != KEY_TYPE_bucket_gens) {
 		bkey_bucket_gens_init(&g->k_i);
@@ -750,6 +750,7 @@ static noinline int bch2_bucket_gen_update(struct btree_trans *trans,
 	g->v.gens[offset] = gen;
 
 	ret = bch2_trans_update(trans, &iter, &g->k_i, 0);
+out:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
@@ -1373,7 +1374,7 @@ static noinline_for_stack int bch2_check_discard_freespace_key(struct btree_tran
 	alloc_k = bch2_bkey_get_iter(trans, &alloc_iter, BTREE_ID_alloc, pos, 0);
 	ret = bkey_err(alloc_k);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (fsck_err_on(!bch2_dev_bucket_exists(c, pos),
 			trans, need_discard_freespace_key_to_invalid_dev_bucket,
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index dca62375d7d3..7fbc5a796c4c 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -552,8 +552,7 @@ static inline struct bkey_s_c __bch2_bkey_get_iter(struct btree_trans *trans,
 
 	if (!bkey_err(k) && type && k.k->type != type)
 		k = bkey_s_c_err(-BCH_ERR_ENOENT_bkey_type_mismatch);
-	if (unlikely(bkey_err(k)))
-		bch2_trans_iter_exit(trans, iter);
+
 	return k;
 }
 
@@ -586,9 +585,9 @@ static inline int __bch2_bkey_get_val_typed(struct btree_trans *trans,
 		memcpy(val, k.v, b);
 		if (unlikely(b < sizeof(*val)))
 			memset((void *) val + b, 0, sizeof(*val) - b);
-		bch2_trans_iter_exit(trans, &iter);
 	}
 
+	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
 
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 9138944c5ae6..83a343f1e186 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -930,7 +930,7 @@ static int check_inode_dirent_inode(struct btree_trans *trans, struct bkey_s_c i
 	struct bkey_s_c_dirent d = inode_get_dirent(trans, &dirent_iter, inode, &inode_snapshot);
 	int ret = bkey_err(d);
 	if (ret && !bch2_err_matches(ret, ENOENT))
-		return ret;
+		goto err;
 
 	if (fsck_err_on(ret,
 			trans, inode_points_to_missing_dirent,
@@ -955,6 +955,7 @@ static int check_inode_dirent_inode(struct btree_trans *trans, struct bkey_s_c i
 	}
 
 	ret = 0;
+err:
 fsck_err:
 	bch2_trans_iter_exit(trans, &dirent_iter);
 	printbuf_exit(&buf);
@@ -1971,7 +1972,7 @@ static int check_dirent_to_subvol(struct btree_trans *trans, struct btree_iter *
 					 0, subvolume);
 	ret = bkey_err(s.s_c);
 	if (ret && !bch2_err_matches(ret, ENOENT))
-		return ret;
+		goto out;
 
 	if (ret) {
 		if (fsck_err(trans, dirent_to_missing_subvol,
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 2be6be33afa3..6cb4028f6f60 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -343,7 +343,7 @@ int bch2_inode_peek_nowarn(struct btree_trans *trans,
 			       flags|BTREE_ITER_cached);
 	ret = bkey_err(k);
 	if (ret)
-		return ret;
+		goto err;
 
 	ret = bkey_is_inode(k.k) ? 0 : -BCH_ERR_ENOENT_inode;
 	if (ret)
@@ -1081,7 +1081,7 @@ static int may_delete_deleted_inode(struct btree_trans *trans,
 	k = bch2_bkey_get_iter(trans, &inode_iter, BTREE_ID_inodes, pos, BTREE_ITER_cached);
 	ret = bkey_err(k);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = bkey_is_inode(k.k) ? 0 : -BCH_ERR_ENOENT_inode;
 	if (fsck_err_on(!bkey_is_inode(k.k),
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 1d4761d15002..3ba374b47f4b 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -219,7 +219,7 @@ static inline int bch2_extent_update_i_size_sectors(struct btree_trans *trans,
 			      BTREE_ITER_cached);
 	int ret = bkey_err(k);
 	if (unlikely(ret))
-		return ret;
+		goto err;
 
 	/*
 	 * varint_decode_fast(), in the inode .invalid method, reads up to 7
diff --git a/fs/bcachefs/lru.c b/fs/bcachefs/lru.c
index 96f2f4f8c397..40bc732e996f 100644
--- a/fs/bcachefs/lru.c
+++ b/fs/bcachefs/lru.c
@@ -91,7 +91,7 @@ int bch2_lru_check_set(struct btree_trans *trans,
 					   time), 0);
 	int ret = bkey_err(lru_k);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (lru_k.k->type != KEY_TYPE_set) {
 		ret = bch2_btree_write_buffer_maybe_flush(trans, referring_k, last_flushed);
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 7d3920e03742..4148fc312ab2 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -439,8 +439,10 @@ int bch2_move_get_io_opts_one(struct btree_trans *trans,
 			       SPOS(0, extent_k.k->p.inode, extent_k.k->p.snapshot),
 			       BTREE_ITER_cached);
 	ret = bkey_err(k);
-	if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+	if (bch2_err_matches(ret, BCH_ERR_transaction_restart)) {
+		bch2_trans_iter_exit(trans, &iter);
 		return ret;
+	}
 
 	if (!ret && bkey_is_inode(k.k)) {
 		struct bch_inode_unpacked inode;
diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
index deef4f024d20..7ee2e74eb7fc 100644
--- a/fs/bcachefs/movinggc.c
+++ b/fs/bcachefs/movinggc.c
@@ -88,7 +88,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 			       b->k.bucket, BTREE_ITER_cached);
 	ret = bkey_err(k);
 	if (ret)
-		return ret;
+		goto out;
 
 	a = bch2_alloc_to_v4(k, &_a);
 	b->k.gen	= a->gen;
@@ -98,6 +98,7 @@ static int bch2_bucket_is_movable(struct btree_trans *trans,
 		a->fragmentation_lru &&
 		a->fragmentation_lru <= time;
 
+out:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
diff --git a/fs/bcachefs/quota.c b/fs/bcachefs/quota.c
index c32a05e252e2..504d39a9da65 100644
--- a/fs/bcachefs/quota.c
+++ b/fs/bcachefs/quota.c
@@ -828,7 +828,7 @@ static int bch2_set_quota_trans(struct btree_trans *trans,
 			       BTREE_ITER_slots|BTREE_ITER_intent);
 	ret = bkey_err(k);
 	if (unlikely(ret))
-		return ret;
+		goto err;
 
 	if (k.k->type == KEY_TYPE_quota)
 		new_quota->v = *bkey_s_c_to_quota(k).v;
@@ -844,6 +844,7 @@ static int bch2_set_quota_trans(struct btree_trans *trans,
 		new_quota->v.c[Q_INO].hardlimit = cpu_to_le64(qdq->d_ino_hardlimit);
 
 	ret = bch2_trans_update(trans, &iter, &new_quota->k_i, 0);
+err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index dbe834cb349f..c5358f452fc1 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -419,12 +419,13 @@ static int __bch2_subvolume_delete(struct btree_trans *trans, u32 subvolid)
 	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOENT), trans->c,
 				"missing subvolume %u", subvolid);
 	if (ret)
-		return ret;
+		goto err;
 
 	snapid = le32_to_cpu(subvol.v->snapshot);
 
 	ret =   bch2_btree_delete_at(trans, &iter, 0) ?:
 		bch2_snapshot_node_set_deleted(trans, snapid);
+err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
 }
@@ -648,7 +649,7 @@ static int __bch2_fs_upgrade_for_subvolumes(struct btree_trans *trans)
 			       SPOS(0, BCACHEFS_ROOT_INO, U32_MAX), 0);
 	ret = bkey_err(k);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (!bkey_is_inode(k.k)) {
 		bch_err(trans->c, "root inode not found");
-- 
2.34.1

