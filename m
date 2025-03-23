Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B337E38F82
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Mar 2025 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742739300; cv=none; b=DnuimIBP3CAljra40wAwNka9i3poZxBESc/qH4cka5LHc8KrfXBJBocOVfMyajd8pogWqa9Q6kj8UMVVf9zR70v//pkip51bhs17lcBjePJyd4fyJWSTpn75qEm2SlHxzBPNDAWjtgdSA97nTArIrf29YQuLD9qfF+mZ2IJ5I7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742739300; c=relaxed/simple;
	bh=MXWJN8Bi1mJ209MlRYpHO2q9GRXjcVGWQQTIghjIQiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=do2xRpOpinuum5+5wpEHY3rjm/Igw5njIdCQ4zIKiUaJAXrLV5RSj36uVfMvZKQuIe3YW0+w8zv5eHkcIU2SetyztQgiCnrT7L0D1MadKeE/aNi+3wz1vzEWTf5KZCGLMhS79w6IDcBMWWnkoIhm1li4uTnP9N0NiO8zvUveO3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d76CXQlC; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d76CXQlC"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742739292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8fsGlPCVQusbzQyy0RcNDmSfhHisKAk47egbNxUziEU=;
	b=d76CXQlCedKKbQxeeX+lpSeHMaZ5T/EHBaRMFzKLFBRdJHfrDgS7cgwnIGNfsMnybC4LQw
	G4erov410Ywcs8hhY6KA73uTK6Zimki6cx1f2MIWDIg4n4TkO3iI9OPEsYm5ycZInobC5G
	YSFxmvAA5eSrroVK+RC6g/W4uSjvfvQ=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/8] bcachefs: Kill btree_iter.trans
Date: Sun, 23 Mar 2025 10:14:36 -0400
Message-ID: <20250323141445.566595-3-kent.overstreet@linux.dev>
In-Reply-To: <20250323141445.566595-1-kent.overstreet@linux.dev>
References: <20250323141445.566595-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This was planned to be done ages ago, now finally completed; there are
places where we have quite a few btree_trans objects on the stack, so
this reduces stack usage somewhat.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/acl.c                   |   4 +-
 fs/bcachefs/alloc_background.c      |  78 ++++++------
 fs/bcachefs/alloc_foreground.c      |   8 +-
 fs/bcachefs/backpointers.c          |  10 +-
 fs/bcachefs/btree_gc.c              |   4 +-
 fs/bcachefs/btree_io.c              |   3 +-
 fs/bcachefs/btree_iter.c            | 184 +++++++++++++---------------
 fs/bcachefs/btree_iter.h            | 122 +++++++++---------
 fs/bcachefs/btree_key_cache.c       |   8 +-
 fs/bcachefs/btree_types.h           |   1 -
 fs/bcachefs/btree_update.c          |  26 ++--
 fs/bcachefs/btree_update_interior.c |  12 +-
 fs/bcachefs/btree_write_buffer.c    |  10 +-
 fs/bcachefs/buckets.c               |   2 +-
 fs/bcachefs/data_update.c           |   8 +-
 fs/bcachefs/dirent.c                |  16 +--
 fs/bcachefs/disk_accounting.c       |   4 +-
 fs/bcachefs/ec.c                    |   4 +-
 fs/bcachefs/extent_update.c         |   6 +-
 fs/bcachefs/fs-io-buffered.c        |   6 +-
 fs/bcachefs/fs-io.c                 |  10 +-
 fs/bcachefs/fs.c                    |  22 ++--
 fs/bcachefs/fsck.c                  |  30 ++---
 fs/bcachefs/inode.c                 |  18 +--
 fs/bcachefs/io_misc.c               |  18 +--
 fs/bcachefs/io_read.c               |   8 +-
 fs/bcachefs/io_write.c              |  12 +-
 fs/bcachefs/migrate.c               |   4 +-
 fs/bcachefs/move.c                  |  12 +-
 fs/bcachefs/namei.c                 |  38 +++---
 fs/bcachefs/quota.c                 |   2 +-
 fs/bcachefs/rebalance.c             |  12 +-
 fs/bcachefs/recovery.c              |   6 +-
 fs/bcachefs/reflink.c               |  23 ++--
 fs/bcachefs/snapshot.c              |  10 +-
 fs/bcachefs/str_hash.c              |   2 +-
 fs/bcachefs/str_hash.h              |   8 +-
 fs/bcachefs/subvolume.c             |   4 +-
 fs/bcachefs/subvolume.h             |  14 +--
 fs/bcachefs/tests.c                 |  30 ++---
 fs/bcachefs/xattr.c                 |   2 +-
 41 files changed, 400 insertions(+), 401 deletions(-)

diff --git a/fs/bcachefs/acl.c b/fs/bcachefs/acl.c
index 99487727ae64..d03adc36100e 100644
--- a/fs/bcachefs/acl.c
+++ b/fs/bcachefs/acl.c
@@ -273,7 +273,7 @@ struct posix_acl *bch2_get_acl(struct inode *vinode, int type, bool rcu)
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	struct bch_hash_info hash = bch2_hash_info_init(c, &inode->ei_inode);
 	struct xattr_search_key search = X_SEARCH(acl_to_xattr_type(type), "", 0);
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct posix_acl *acl = NULL;
 
 	if (rcu)
@@ -344,7 +344,7 @@ int bch2_set_acl(struct mnt_idmap *idmap,
 {
 	struct bch_inode_info *inode = to_bch_ei(dentry->d_inode);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter inode_iter = {};
 	struct bch_inode_unpacked inode_u;
 	struct posix_acl *acl;
 	umode_t mode;
diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 5fb396be9127..8b6051d19abf 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -608,7 +608,7 @@ int bch2_alloc_read(struct bch_fs *c)
 			 * bch2_check_alloc_key() which runs later:
 			 */
 			if (!ca) {
-				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode + 1, 0));
+				bch2_btree_iter_set_pos(trans, &iter, POS(k.k->p.inode + 1, 0));
 				continue;
 			}
 
@@ -629,17 +629,17 @@ int bch2_alloc_read(struct bch_fs *c)
 			 * bch2_check_alloc_key() which runs later:
 			 */
 			if (!ca) {
-				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode + 1, 0));
+				bch2_btree_iter_set_pos(trans, &iter, POS(k.k->p.inode + 1, 0));
 				continue;
 			}
 
 			if (k.k->p.offset < ca->mi.first_bucket) {
-				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode, ca->mi.first_bucket));
+				bch2_btree_iter_set_pos(trans, &iter, POS(k.k->p.inode, ca->mi.first_bucket));
 				continue;
 			}
 
 			if (k.k->p.offset >= ca->mi.nbuckets) {
-				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode + 1, 0));
+				bch2_btree_iter_set_pos(trans, &iter, POS(k.k->p.inode + 1, 0));
 				continue;
 			}
 
@@ -1037,9 +1037,10 @@ int bch2_trigger_alloc(struct btree_trans *trans,
  * This synthesizes deleted extents for holes, similar to BTREE_ITER_slots for
  * extents style btrees, but works on non-extents btrees:
  */
-static struct bkey_s_c bch2_get_key_or_hole(struct btree_iter *iter, struct bpos end, struct bkey *hole)
+static struct bkey_s_c bch2_get_key_or_hole(struct btree_trans *trans, struct btree_iter *iter,
+					    struct bpos end, struct bkey *hole)
 {
-	struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(trans, iter);
 
 	if (bkey_err(k))
 		return k;
@@ -1050,9 +1051,9 @@ static struct bkey_s_c bch2_get_key_or_hole(struct btree_iter *iter, struct bpos
 		struct btree_iter iter2;
 		struct bpos next;
 
-		bch2_trans_copy_iter(&iter2, iter);
+		bch2_trans_copy_iter(trans, &iter2, iter);
 
-		struct btree_path *path = btree_iter_path(iter->trans, iter);
+		struct btree_path *path = btree_iter_path(trans, iter);
 		if (!bpos_eq(path->l[0].b->key.k.p, SPOS_MAX))
 			end = bkey_min(end, bpos_nosnap_successor(path->l[0].b->key.k.p));
 
@@ -1062,9 +1063,9 @@ static struct bkey_s_c bch2_get_key_or_hole(struct btree_iter *iter, struct bpos
 		 * btree node min/max is a closed interval, upto takes a half
 		 * open interval:
 		 */
-		k = bch2_btree_iter_peek_max(&iter2, end);
+		k = bch2_btree_iter_peek_max(trans, &iter2, end);
 		next = iter2.pos;
-		bch2_trans_iter_exit(iter->trans, &iter2);
+		bch2_trans_iter_exit(trans, &iter2);
 
 		BUG_ON(next.offset >= iter->pos.offset + U32_MAX);
 
@@ -1105,13 +1106,14 @@ static bool next_bucket(struct bch_fs *c, struct bch_dev **ca, struct bpos *buck
 	return *ca != NULL;
 }
 
-static struct bkey_s_c bch2_get_key_or_real_bucket_hole(struct btree_iter *iter,
-					struct bch_dev **ca, struct bkey *hole)
+static struct bkey_s_c bch2_get_key_or_real_bucket_hole(struct btree_trans *trans,
+							struct btree_iter *iter,
+							struct bch_dev **ca, struct bkey *hole)
 {
-	struct bch_fs *c = iter->trans->c;
+	struct bch_fs *c = trans->c;
 	struct bkey_s_c k;
 again:
-	k = bch2_get_key_or_hole(iter, POS_MAX, hole);
+	k = bch2_get_key_or_hole(trans, iter, POS_MAX, hole);
 	if (bkey_err(k))
 		return k;
 
@@ -1124,7 +1126,7 @@ static struct bkey_s_c bch2_get_key_or_real_bucket_hole(struct btree_iter *iter,
 			if (!next_bucket(c, ca, &hole_start))
 				return bkey_s_c_null;
 
-			bch2_btree_iter_set_pos(iter, hole_start);
+			bch2_btree_iter_set_pos(trans, iter, hole_start);
 			goto again;
 		}
 
@@ -1165,8 +1167,8 @@ int bch2_check_alloc_key(struct btree_trans *trans,
 
 	a = bch2_alloc_to_v4(alloc_k, &a_convert);
 
-	bch2_btree_iter_set_pos(discard_iter, alloc_k.k->p);
-	k = bch2_btree_iter_peek_slot(discard_iter);
+	bch2_btree_iter_set_pos(trans, discard_iter, alloc_k.k->p);
+	k = bch2_btree_iter_peek_slot(trans, discard_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -1179,8 +1181,8 @@ int bch2_check_alloc_key(struct btree_trans *trans,
 			goto err;
 	}
 
-	bch2_btree_iter_set_pos(freespace_iter, alloc_freespace_pos(alloc_k.k->p, *a));
-	k = bch2_btree_iter_peek_slot(freespace_iter);
+	bch2_btree_iter_set_pos(trans, freespace_iter, alloc_freespace_pos(alloc_k.k->p, *a));
+	k = bch2_btree_iter_peek_slot(trans, freespace_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -1193,8 +1195,8 @@ int bch2_check_alloc_key(struct btree_trans *trans,
 			goto err;
 	}
 
-	bch2_btree_iter_set_pos(bucket_gens_iter, alloc_gens_pos(alloc_k.k->p, &gens_offset));
-	k = bch2_btree_iter_peek_slot(bucket_gens_iter);
+	bch2_btree_iter_set_pos(trans, bucket_gens_iter, alloc_gens_pos(alloc_k.k->p, &gens_offset));
+	k = bch2_btree_iter_peek_slot(trans, bucket_gens_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -1248,9 +1250,9 @@ int bch2_check_alloc_hole_freespace(struct btree_trans *trans,
 	if (!ca->mi.freespace_initialized)
 		return 0;
 
-	bch2_btree_iter_set_pos(freespace_iter, start);
+	bch2_btree_iter_set_pos(trans, freespace_iter, start);
 
-	k = bch2_btree_iter_peek_slot(freespace_iter);
+	k = bch2_btree_iter_peek_slot(trans, freespace_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -1299,9 +1301,9 @@ int bch2_check_alloc_hole_bucket_gens(struct btree_trans *trans,
 	unsigned i, gens_offset, gens_end_offset;
 	int ret;
 
-	bch2_btree_iter_set_pos(bucket_gens_iter, alloc_gens_pos(start, &gens_offset));
+	bch2_btree_iter_set_pos(trans, bucket_gens_iter, alloc_gens_pos(start, &gens_offset));
 
-	k = bch2_btree_iter_peek_slot(bucket_gens_iter);
+	k = bch2_btree_iter_peek_slot(trans, bucket_gens_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -1434,7 +1436,7 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 	*gen = a->gen;
 out:
 fsck_err:
-	bch2_set_btree_iter_dontneed(&alloc_iter);
+	bch2_set_btree_iter_dontneed(trans, &alloc_iter);
 	bch2_trans_iter_exit(trans, &alloc_iter);
 	printbuf_exit(&buf);
 	return ret;
@@ -1571,7 +1573,7 @@ int bch2_check_alloc_info(struct bch_fs *c)
 
 		bch2_trans_begin(trans);
 
-		k = bch2_get_key_or_real_bucket_hole(&iter, &ca, &hole);
+		k = bch2_get_key_or_real_bucket_hole(trans, &iter, &ca, &hole);
 		ret = bkey_err(k);
 		if (ret)
 			goto bkey_err;
@@ -1609,7 +1611,7 @@ int bch2_check_alloc_info(struct bch_fs *c)
 		if (ret)
 			goto bkey_err;
 
-		bch2_btree_iter_set_pos(&iter, next);
+		bch2_btree_iter_set_pos(trans, &iter, next);
 bkey_err:
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			continue;
@@ -1637,7 +1639,7 @@ int bch2_check_alloc_info(struct bch_fs *c)
 			     BTREE_ITER_prefetch);
 	while (1) {
 		bch2_trans_begin(trans);
-		k = bch2_btree_iter_peek(&iter);
+		k = bch2_btree_iter_peek(trans, &iter);
 		if (!k.k)
 			break;
 
@@ -1656,7 +1658,7 @@ int bch2_check_alloc_info(struct bch_fs *c)
 			break;
 		}
 
-		bch2_btree_iter_set_pos(&iter, bpos_nosnap_successor(iter.pos));
+		bch2_btree_iter_set_pos(trans, &iter, bpos_nosnap_successor(iter.pos));
 	}
 	bch2_trans_iter_exit(trans, &iter);
 	if (ret)
@@ -1684,7 +1686,7 @@ static int bch2_check_alloc_to_lru_ref(struct btree_trans *trans,
 	struct printbuf buf = PRINTBUF;
 	int ret;
 
-	alloc_k = bch2_btree_iter_peek(alloc_iter);
+	alloc_k = bch2_btree_iter_peek(trans, alloc_iter);
 	if (!alloc_k.k)
 		return 0;
 
@@ -1826,7 +1828,7 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	struct bpos pos = need_discard_iter->pos;
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct bkey_s_c k;
 	struct bkey_i_alloc_v4 *a;
 	struct printbuf buf = PRINTBUF;
@@ -2199,9 +2201,9 @@ static struct bkey_s_c next_lru_key(struct btree_trans *trans, struct btree_iter
 {
 	struct bkey_s_c k;
 again:
-	k = bch2_btree_iter_peek_max(iter, lru_pos(ca->dev_idx, U64_MAX, LRU_TIME_MAX));
+	k = bch2_btree_iter_peek_max(trans, iter, lru_pos(ca->dev_idx, U64_MAX, LRU_TIME_MAX));
 	if (!k.k && !*wrapped) {
-		bch2_btree_iter_set_pos(iter, lru_pos(ca->dev_idx, 0, 0));
+		bch2_btree_iter_set_pos(trans, iter, lru_pos(ca->dev_idx, 0, 0));
 		*wrapped = true;
 		goto again;
 	}
@@ -2251,7 +2253,7 @@ static void bch2_do_invalidates_work(struct work_struct *work)
 		if (ret)
 			break;
 
-		bch2_btree_iter_advance(&iter);
+		bch2_btree_iter_advance(trans, &iter);
 	}
 	bch2_trans_iter_exit(trans, &iter);
 err:
@@ -2321,7 +2323,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
 			break;
 		}
 
-		k = bch2_get_key_or_hole(&iter, end, &hole);
+		k = bch2_get_key_or_hole(trans, &iter, end, &hole);
 		ret = bkey_err(k);
 		if (ret)
 			goto bkey_err;
@@ -2340,7 +2342,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
 			if (ret)
 				goto bkey_err;
 
-			bch2_btree_iter_advance(&iter);
+			bch2_btree_iter_advance(trans, &iter);
 		} else {
 			struct bkey_i *freespace;
 
@@ -2360,7 +2362,7 @@ int bch2_dev_freespace_init(struct bch_fs *c, struct bch_dev *ca,
 			if (ret)
 				goto bkey_err;
 
-			bch2_btree_iter_set_pos(&iter, k.k->p);
+			bch2_btree_iter_set_pos(trans, &iter, k.k->p);
 		}
 bkey_err:
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 0cac65347a5d..5c824b368fe2 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -327,7 +327,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 			bucket = sector_to_bucket(ca,
 					round_up(bucket_to_sector(ca, bucket) + 1,
 						 1ULL << ca->mi.btree_bitmap_shift));
-			bch2_btree_iter_set_pos(&iter, POS(ca->dev_idx, bucket));
+			bch2_btree_iter_set_pos(trans, &iter, POS(ca->dev_idx, bucket));
 			s->buckets_seen++;
 			s->skipped_mi_btree_bitmap++;
 			continue;
@@ -355,7 +355,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 					     watermark, s, cl)
 			: NULL;
 next:
-		bch2_set_btree_iter_dontneed(&citer);
+		bch2_set_btree_iter_dontneed(trans, &citer);
 		bch2_trans_iter_exit(trans, &citer);
 		if (ob)
 			break;
@@ -417,7 +417,7 @@ static struct open_bucket *bch2_bucket_alloc_freelist(struct btree_trans *trans,
 							 1ULL << ca->mi.btree_bitmap_shift));
 				alloc_cursor = bucket|(iter.pos.offset & (~0ULL << 56));
 
-				bch2_btree_iter_set_pos(&iter, POS(ca->dev_idx, alloc_cursor));
+				bch2_btree_iter_set_pos(trans, &iter, POS(ca->dev_idx, alloc_cursor));
 				s->skipped_mi_btree_bitmap++;
 				goto next;
 			}
@@ -426,7 +426,7 @@ static struct open_bucket *bch2_bucket_alloc_freelist(struct btree_trans *trans,
 			if (ob) {
 				if (!IS_ERR(ob))
 					*dev_alloc_cursor = iter.pos.offset;
-				bch2_set_btree_iter_dontneed(&iter);
+				bch2_set_btree_iter_dontneed(trans, &iter);
 				break;
 			}
 
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 20c497f0c2cb..e177f0980ead 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -253,7 +253,7 @@ struct bkey_s_c bch2_backpointer_get_key(struct btree_trans *trans,
 				  0,
 				  bp.v->level,
 				  iter_flags);
-	struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(trans, iter);
 	if (bkey_err(k)) {
 		bch2_trans_iter_exit(trans, iter);
 		return k;
@@ -294,7 +294,7 @@ struct btree *bch2_backpointer_get_node(struct btree_trans *trans,
 				  0,
 				  bp.v->level - 1,
 				  0);
-	struct btree *b = bch2_btree_iter_peek_node(iter);
+	struct btree *b = bch2_btree_iter_peek_node(trans, iter);
 	if (IS_ERR_OR_NULL(b))
 		goto err;
 
@@ -322,7 +322,7 @@ static int bch2_check_backpointer_has_valid_bucket(struct btree_trans *trans, st
 		return 0;
 
 	struct bch_fs *c = trans->c;
-	struct btree_iter alloc_iter = { NULL };
+	struct btree_iter alloc_iter = {};
 	struct bkey_s_c alloc_k;
 	struct printbuf buf = PRINTBUF;
 	int ret = 0;
@@ -652,7 +652,7 @@ static int check_btree_root_to_backpointers(struct btree_trans *trans,
 retry:
 	bch2_trans_node_iter_init(trans, &iter, btree_id, POS_MIN,
 				  0, bch2_btree_id_root(c, btree_id)->b->c.level, 0);
-	b = bch2_btree_iter_peek_node(&iter);
+	b = bch2_btree_iter_peek_node(trans, &iter);
 	ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
 		goto err;
@@ -936,7 +936,7 @@ static int btree_node_get_and_pin(struct btree_trans *trans, struct bkey_i *k,
 {
 	struct btree_iter iter;
 	bch2_trans_node_iter_init(trans, &iter, btree, k->k.p, 0, level, 0);
-	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	struct btree *b = bch2_btree_iter_peek_node(trans, &iter);
 	int ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/btree_gc.c b/fs/bcachefs/btree_gc.c
index ff681e733598..e05cc02274be 100644
--- a/fs/bcachefs/btree_gc.c
+++ b/fs/bcachefs/btree_gc.c
@@ -692,7 +692,7 @@ static int bch2_gc_btree(struct btree_trans *trans,
 		struct btree_iter iter;
 		bch2_trans_node_iter_init(trans, &iter, btree, POS_MIN,
 					  0, bch2_btree_id_root(c, btree)->b->c.level, 0);
-		struct btree *b = bch2_btree_iter_peek_node(&iter);
+		struct btree *b = bch2_btree_iter_peek_node(trans, &iter);
 		ret = PTR_ERR_OR_ZERO(b);
 		if (ret)
 			goto err_root;
@@ -1200,7 +1200,7 @@ int bch2_gc_gens(struct bch_fs *c)
 				BCH_TRANS_COMMIT_no_enospc, ({
 			ca = bch2_dev_iterate(c, ca, k.k->p.inode);
 			if (!ca) {
-				bch2_btree_iter_set_pos(&iter, POS(k.k->p.inode + 1, 0));
+				bch2_btree_iter_set_pos(trans, &iter, POS(k.k->p.inode + 1, 0));
 				continue;
 			}
 			bch2_alloc_write_oldest_gen(trans, ca, &iter, k);
diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 2ba33ffc9795..97bce73ed4c8 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -1907,7 +1907,8 @@ static void btree_node_scrub_work(struct work_struct *work)
 					  scrub->key.k->k.p, 0, scrub->level - 1, 0);
 
 		struct btree *b;
-		int ret = lockrestart_do(trans, PTR_ERR_OR_ZERO(b = bch2_btree_iter_peek_node(&iter)));
+		int ret = lockrestart_do(trans,
+			PTR_ERR_OR_ZERO(b = bch2_btree_iter_peek_node(trans, &iter)));
 		if (ret)
 			goto err;
 
diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 7542c6f9c88e..2ed89b4ceb02 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -244,10 +244,8 @@ void bch2_trans_verify_paths(struct btree_trans *trans)
 		bch2_btree_path_verify(trans, path);
 }
 
-static void bch2_btree_iter_verify(struct btree_iter *iter)
+static void bch2_btree_iter_verify(struct btree_trans *trans, struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
-
 	BUG_ON(!!(iter->flags & BTREE_ITER_cached) != btree_iter_path(trans, iter)->cached);
 
 	BUG_ON((iter->flags & BTREE_ITER_is_extents) &&
@@ -276,9 +274,9 @@ static void bch2_btree_iter_verify_entry_exit(struct btree_iter *iter)
 		bkey_gt(iter->pos, iter->k.p)));
 }
 
-static int bch2_btree_iter_verify_ret(struct btree_iter *iter, struct bkey_s_c k)
+static int bch2_btree_iter_verify_ret(struct btree_trans *trans,
+				      struct btree_iter *iter, struct bkey_s_c k)
 {
-	struct btree_trans *trans = iter->trans;
 	struct btree_iter copy;
 	struct bkey_s_c prev;
 	int ret = 0;
@@ -299,7 +297,7 @@ static int bch2_btree_iter_verify_ret(struct btree_iter *iter, struct bkey_s_c k
 	bch2_trans_iter_init(trans, &copy, iter->btree_id, iter->pos,
 			     BTREE_ITER_nopreserve|
 			     BTREE_ITER_all_snapshots);
-	prev = bch2_btree_iter_prev(&copy);
+	prev = bch2_btree_iter_prev(trans, &copy);
 	if (!prev.k)
 		goto out;
 
@@ -365,9 +363,11 @@ static inline void bch2_btree_path_verify_level(struct btree_trans *trans,
 						struct btree_path *path, unsigned l) {}
 static inline void bch2_btree_path_verify(struct btree_trans *trans,
 					  struct btree_path *path) {}
-static inline void bch2_btree_iter_verify(struct btree_iter *iter) {}
+static inline void bch2_btree_iter_verify(struct btree_trans *trans,
+					  struct btree_iter *iter) {}
 static inline void bch2_btree_iter_verify_entry_exit(struct btree_iter *iter) {}
-static inline int bch2_btree_iter_verify_ret(struct btree_iter *iter, struct bkey_s_c k) { return 0; }
+static inline int bch2_btree_iter_verify_ret(struct btree_trans *trans, struct btree_iter *iter,
+					     struct bkey_s_c k) { return 0; }
 
 #endif
 
@@ -1863,10 +1863,8 @@ struct bkey_s_c bch2_btree_path_peek_slot(struct btree_path *path, struct bkey *
 	return (struct bkey_s_c) { u, NULL };
 }
 
-void bch2_set_btree_iter_dontneed(struct btree_iter *iter)
+void bch2_set_btree_iter_dontneed(struct btree_trans *trans, struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
-
 	if (!iter->path || trans->restarted)
 		return;
 
@@ -1878,17 +1876,14 @@ void bch2_set_btree_iter_dontneed(struct btree_iter *iter)
 /* Btree iterators: */
 
 int __must_check
-__bch2_btree_iter_traverse(struct btree_iter *iter)
+__bch2_btree_iter_traverse(struct btree_trans *trans, struct btree_iter *iter)
 {
-	return bch2_btree_path_traverse(iter->trans, iter->path, iter->flags);
+	return bch2_btree_path_traverse(trans, iter->path, iter->flags);
 }
 
 int __must_check
-bch2_btree_iter_traverse(struct btree_iter *iter)
+bch2_btree_iter_traverse(struct btree_trans *trans, struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
-	int ret;
-
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
 
 	iter->path = bch2_btree_path_set_pos(trans, iter->path,
@@ -1896,7 +1891,7 @@ bch2_btree_iter_traverse(struct btree_iter *iter)
 					iter->flags & BTREE_ITER_intent,
 					btree_iter_ip_allocated(iter));
 
-	ret = bch2_btree_path_traverse(iter->trans, iter->path, iter->flags);
+	int ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
 	if (ret)
 		return ret;
 
@@ -1908,14 +1903,14 @@ bch2_btree_iter_traverse(struct btree_iter *iter)
 
 /* Iterate across nodes (leaf and interior nodes) */
 
-struct btree *bch2_btree_iter_peek_node(struct btree_iter *iter)
+struct btree *bch2_btree_iter_peek_node(struct btree_trans *trans,
+					struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
 	struct btree *b = NULL;
 	int ret;
 
 	EBUG_ON(trans->paths[iter->path].cached);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
 	if (ret)
@@ -1937,7 +1932,7 @@ struct btree *bch2_btree_iter_peek_node(struct btree_iter *iter)
 	btree_path_set_should_be_locked(trans, btree_iter_path(trans, iter));
 out:
 	bch2_btree_iter_verify_entry_exit(iter);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	return b;
 err:
@@ -1946,26 +1941,26 @@ struct btree *bch2_btree_iter_peek_node(struct btree_iter *iter)
 }
 
 /* Only kept for -tools */
-struct btree *bch2_btree_iter_peek_node_and_restart(struct btree_iter *iter)
+struct btree *bch2_btree_iter_peek_node_and_restart(struct btree_trans *trans,
+						    struct btree_iter *iter)
 {
 	struct btree *b;
 
-	while (b = bch2_btree_iter_peek_node(iter),
+	while (b = bch2_btree_iter_peek_node(trans, iter),
 	       bch2_err_matches(PTR_ERR_OR_ZERO(b), BCH_ERR_transaction_restart))
-		bch2_trans_begin(iter->trans);
+		bch2_trans_begin(trans);
 
 	return b;
 }
 
-struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
+struct btree *bch2_btree_iter_next_node(struct btree_trans *trans, struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
 	struct btree *b = NULL;
 	int ret;
 
 	EBUG_ON(trans->paths[iter->path].cached);
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
 	if (ret)
@@ -2032,7 +2027,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
 	EBUG_ON(btree_iter_path(trans, iter)->uptodate);
 out:
 	bch2_btree_iter_verify_entry_exit(iter);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	return b;
 err:
@@ -2042,7 +2037,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
 
 /* Iterate across keys (in leaf nodes only) */
 
-inline bool bch2_btree_iter_advance(struct btree_iter *iter)
+inline bool bch2_btree_iter_advance(struct btree_trans *trans, struct btree_iter *iter)
 {
 	struct bpos pos = iter->k.p;
 	bool ret = !(iter->flags & BTREE_ITER_all_snapshots
@@ -2051,11 +2046,11 @@ inline bool bch2_btree_iter_advance(struct btree_iter *iter)
 
 	if (ret && !(iter->flags & BTREE_ITER_is_extents))
 		pos = bkey_successor(iter, pos);
-	bch2_btree_iter_set_pos(iter, pos);
+	bch2_btree_iter_set_pos(trans, iter, pos);
 	return ret;
 }
 
-inline bool bch2_btree_iter_rewind(struct btree_iter *iter)
+inline bool bch2_btree_iter_rewind(struct btree_trans *trans, struct btree_iter *iter)
 {
 	struct bpos pos = bkey_start_pos(&iter->k);
 	bool ret = !(iter->flags & BTREE_ITER_all_snapshots
@@ -2064,7 +2059,7 @@ inline bool bch2_btree_iter_rewind(struct btree_iter *iter)
 
 	if (ret && !(iter->flags & BTREE_ITER_is_extents))
 		pos = bkey_predecessor(iter, pos);
-	bch2_btree_iter_set_pos(iter, pos);
+	bch2_btree_iter_set_pos(trans, iter, pos);
 	return ret;
 }
 
@@ -2191,9 +2186,9 @@ void btree_trans_peek_prev_journal(struct btree_trans *trans,
  * bkey_s_c_null:
  */
 static noinline
-struct bkey_s_c btree_trans_peek_key_cache(struct btree_iter *iter, struct bpos pos)
+struct bkey_s_c btree_trans_peek_key_cache(struct btree_trans *trans, struct btree_iter *iter,
+					   struct bpos pos)
 {
-	struct btree_trans *trans = iter->trans;
 	struct bch_fs *c = trans->c;
 	struct bkey u;
 	struct bkey_s_c k;
@@ -2239,14 +2234,14 @@ struct bkey_s_c btree_trans_peek_key_cache(struct btree_iter *iter, struct bpos
 	return k;
 }
 
-static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bpos search_key)
+static struct bkey_s_c __bch2_btree_iter_peek(struct btree_trans *trans, struct btree_iter *iter,
+					      struct bpos search_key)
 {
-	struct btree_trans *trans = iter->trans;
 	struct bkey_s_c k, k2;
 	int ret;
 
 	EBUG_ON(btree_iter_path(trans, iter)->cached);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	while (1) {
 		iter->path = bch2_btree_path_set_pos(trans, iter->path, search_key,
@@ -2256,7 +2251,7 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 		ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
 		if (unlikely(ret)) {
 			/* ensure that iter->k is consistent with iter->pos: */
-			bch2_btree_iter_set_pos(iter, iter->pos);
+			bch2_btree_iter_set_pos(trans, iter, iter->pos);
 			k = bkey_s_c_err(ret);
 			break;
 		}
@@ -2266,7 +2261,7 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 
 		if (unlikely(!l->b)) {
 			/* No btree nodes at requested level: */
-			bch2_btree_iter_set_pos(iter, SPOS_MAX);
+			bch2_btree_iter_set_pos(trans, iter, SPOS_MAX);
 			k = bkey_s_c_null;
 			break;
 		}
@@ -2277,10 +2272,10 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 
 		if (unlikely(iter->flags & BTREE_ITER_with_key_cache) &&
 		    k.k &&
-		    (k2 = btree_trans_peek_key_cache(iter, k.k->p)).k) {
+		    (k2 = btree_trans_peek_key_cache(trans, iter, k.k->p)).k) {
 			k = k2;
 			if (bkey_err(k)) {
-				bch2_btree_iter_set_pos(iter, iter->pos);
+				bch2_btree_iter_set_pos(trans, iter, iter->pos);
 				break;
 			}
 		}
@@ -2313,13 +2308,13 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
 			search_key = bpos_successor(l->b->key.k.p);
 		} else {
 			/* End of btree: */
-			bch2_btree_iter_set_pos(iter, SPOS_MAX);
+			bch2_btree_iter_set_pos(trans, iter, SPOS_MAX);
 			k = bkey_s_c_null;
 			break;
 		}
 	}
 
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 	return k;
 }
 
@@ -2331,9 +2326,9 @@ static struct bkey_s_c __bch2_btree_iter_peek(struct btree_iter *iter, struct bp
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos end)
+struct bkey_s_c bch2_btree_iter_peek_max(struct btree_trans *trans, struct btree_iter *iter,
+					 struct bpos end)
 {
-	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = btree_iter_search_key(iter);
 	struct bkey_s_c k;
 	struct bpos iter_pos = iter->pos;
@@ -2356,7 +2351,7 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 	}
 
 	while (1) {
-		k = __bch2_btree_iter_peek(iter, search_key);
+		k = __bch2_btree_iter_peek(trans, iter, search_key);
 		if (unlikely(!k.k))
 			goto end;
 		if (unlikely(bkey_err(k)))
@@ -2470,9 +2465,9 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 	if (!(iter->flags & BTREE_ITER_all_snapshots))
 		iter->pos.snapshot = iter->snapshot;
 
-	ret = bch2_btree_iter_verify_ret(iter, k);
+	ret = bch2_btree_iter_verify_ret(trans, iter, k);
 	if (unlikely(ret)) {
-		bch2_btree_iter_set_pos(iter, iter->pos);
+		bch2_btree_iter_set_pos(trans, iter, iter->pos);
 		k = bkey_s_c_err(ret);
 	}
 
@@ -2480,7 +2475,7 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
 
 	return k;
 end:
-	bch2_btree_iter_set_pos(iter, end);
+	bch2_btree_iter_set_pos(trans, iter, end);
 	k = bkey_s_c_null;
 	goto out_no_locked;
 }
@@ -2492,20 +2487,20 @@ struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *iter, struct bpos en
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_next(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_next(struct btree_trans *trans, struct btree_iter *iter)
 {
-	if (!bch2_btree_iter_advance(iter))
+	if (!bch2_btree_iter_advance(trans, iter))
 		return bkey_s_c_null;
 
-	return bch2_btree_iter_peek(iter);
+	return bch2_btree_iter_peek(trans, iter);
 }
 
-static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, struct bpos search_key)
+static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_trans *trans, struct btree_iter *iter,
+						   struct bpos search_key)
 {
-	struct btree_trans *trans = iter->trans;
 	struct bkey_s_c k, k2;
 
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 
 	while (1) {
 		iter->path = bch2_btree_path_set_pos(trans, iter->path, search_key,
@@ -2515,7 +2510,7 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
 		int ret = bch2_btree_path_traverse(trans, iter->path, iter->flags);
 		if (unlikely(ret)) {
 			/* ensure that iter->k is consistent with iter->pos: */
-			bch2_btree_iter_set_pos(iter, iter->pos);
+			bch2_btree_iter_set_pos(trans, iter, iter->pos);
 			k = bkey_s_c_err(ret);
 			break;
 		}
@@ -2525,7 +2520,7 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
 
 		if (unlikely(!l->b)) {
 			/* No btree nodes at requested level: */
-			bch2_btree_iter_set_pos(iter, SPOS_MAX);
+			bch2_btree_iter_set_pos(trans, iter, SPOS_MAX);
 			k = bkey_s_c_null;
 			break;
 		}
@@ -2541,10 +2536,10 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
 
 		if (unlikely(iter->flags & BTREE_ITER_with_key_cache) &&
 		    k.k &&
-		    (k2 = btree_trans_peek_key_cache(iter, k.k->p)).k) {
+		    (k2 = btree_trans_peek_key_cache(trans, iter, k.k->p)).k) {
 			k = k2;
 			if (bkey_err(k2)) {
-				bch2_btree_iter_set_pos(iter, iter->pos);
+				bch2_btree_iter_set_pos(trans, iter, iter->pos);
 				break;
 			}
 		}
@@ -2565,13 +2560,13 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
 			search_key = bpos_predecessor(path->l[0].b->data->min_key);
 		} else {
 			/* Start of btree: */
-			bch2_btree_iter_set_pos(iter, POS_MIN);
+			bch2_btree_iter_set_pos(trans, iter, POS_MIN);
 			k = bkey_s_c_null;
 			break;
 		}
 	}
 
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 	return k;
 }
 
@@ -2583,7 +2578,8 @@ static struct bkey_s_c __bch2_btree_iter_peek_prev(struct btree_iter *iter, stru
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bpos end)
+struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_trans *trans, struct btree_iter *iter,
+					      struct bpos end)
 {
 	if ((iter->flags & (BTREE_ITER_is_extents|BTREE_ITER_filter_snapshots)) &&
 	   !bkey_eq(iter->pos, POS_MAX)) {
@@ -2595,7 +2591,7 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 		 * real visible extents - easiest to just use peek_slot() (which
 		 * internally uses peek() for extents)
 		 */
-		struct bkey_s_c k = bch2_btree_iter_peek_slot(iter);
+		struct bkey_s_c k = bch2_btree_iter_peek_slot(trans, iter);
 		if (bkey_err(k))
 			return k;
 
@@ -2605,7 +2601,6 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 			return k;
 	}
 
-	struct btree_trans *trans = iter->trans;
 	struct bpos search_key = iter->pos;
 	struct bkey_s_c k;
 	btree_path_idx_t saved_path = 0;
@@ -2621,7 +2616,7 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 	}
 
 	while (1) {
-		k = __bch2_btree_iter_peek_prev(iter, search_key);
+		k = __bch2_btree_iter_peek_prev(trans, iter, search_key);
 		if (unlikely(!k.k))
 			goto end;
 		if (unlikely(bkey_err(k)))
@@ -2712,10 +2707,10 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
 		bch2_path_put_nokeep(trans, saved_path, iter->flags & BTREE_ITER_intent);
 
 	bch2_btree_iter_verify_entry_exit(iter);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 	return k;
 end:
-	bch2_btree_iter_set_pos(iter, end);
+	bch2_btree_iter_set_pos(trans, iter, end);
 	k = bkey_s_c_null;
 	goto out_no_locked;
 }
@@ -2727,23 +2722,22 @@ struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *iter, struct bp
  *
  * Returns:	key if found, or an error extractable with bkey_err().
  */
-struct bkey_s_c bch2_btree_iter_prev(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_prev(struct btree_trans *trans, struct btree_iter *iter)
 {
-	if (!bch2_btree_iter_rewind(iter))
+	if (!bch2_btree_iter_rewind(trans, iter))
 		return bkey_s_c_null;
 
-	return bch2_btree_iter_peek_prev(iter);
+	return bch2_btree_iter_peek_prev(trans, iter);
 }
 
-struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_trans *trans, struct btree_iter *iter)
 {
-	struct btree_trans *trans = iter->trans;
 	struct bpos search_key;
 	struct bkey_s_c k;
 	int ret;
 
 	bch2_trans_verify_not_unlocked_or_in_restart(trans);
-	bch2_btree_iter_verify(iter);
+	bch2_btree_iter_verify(trans, iter);
 	bch2_btree_iter_verify_entry_exit(iter);
 	EBUG_ON(btree_iter_path(trans, iter)->level && (iter->flags & BTREE_ITER_with_key_cache));
 
@@ -2759,7 +2753,7 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 		if (iter->pos.inode == KEY_INODE_MAX)
 			return bkey_s_c_null;
 
-		bch2_btree_iter_set_pos(iter, bpos_nosnap_successor(iter->pos));
+		bch2_btree_iter_set_pos(trans, iter, bpos_nosnap_successor(iter->pos));
 	}
 
 	search_key = btree_iter_search_key(iter);
@@ -2793,7 +2787,7 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 			goto out;
 
 		if (unlikely(iter->flags & BTREE_ITER_with_key_cache) &&
-		    (k = btree_trans_peek_key_cache(iter, iter->pos)).k) {
+		    (k = btree_trans_peek_key_cache(trans, iter, iter->pos)).k) {
 			if (!bkey_err(k))
 				iter->k = *k.k;
 			/* We're not returning a key from iter->path: */
@@ -2820,8 +2814,8 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 		if (iter->flags & BTREE_ITER_intent) {
 			struct btree_iter iter2;
 
-			bch2_trans_copy_iter(&iter2, iter);
-			k = bch2_btree_iter_peek_max(&iter2, end);
+			bch2_trans_copy_iter(trans, &iter2, iter);
+			k = bch2_btree_iter_peek_max(trans, &iter2, end);
 
 			if (k.k && !bkey_err(k)) {
 				swap(iter->key_cache_path, iter2.key_cache_path);
@@ -2832,9 +2826,9 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 		} else {
 			struct bpos pos = iter->pos;
 
-			k = bch2_btree_iter_peek_max(iter, end);
+			k = bch2_btree_iter_peek_max(trans, iter, end);
 			if (unlikely(bkey_err(k)))
-				bch2_btree_iter_set_pos(iter, pos);
+				bch2_btree_iter_set_pos(trans, iter, pos);
 			else
 				iter->pos = pos;
 		}
@@ -2865,39 +2859,39 @@ struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *iter)
 	btree_path_set_should_be_locked(trans, btree_iter_path(trans, iter));
 out_no_locked:
 	bch2_btree_iter_verify_entry_exit(iter);
-	bch2_btree_iter_verify(iter);
-	ret = bch2_btree_iter_verify_ret(iter, k);
+	bch2_btree_iter_verify(trans, iter);
+	ret = bch2_btree_iter_verify_ret(trans, iter, k);
 	if (unlikely(ret))
 		return bkey_s_c_err(ret);
 
 	return k;
 }
 
-struct bkey_s_c bch2_btree_iter_next_slot(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_next_slot(struct btree_trans *trans, struct btree_iter *iter)
 {
-	if (!bch2_btree_iter_advance(iter))
+	if (!bch2_btree_iter_advance(trans, iter))
 		return bkey_s_c_null;
 
-	return bch2_btree_iter_peek_slot(iter);
+	return bch2_btree_iter_peek_slot(trans, iter);
 }
 
-struct bkey_s_c bch2_btree_iter_prev_slot(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_prev_slot(struct btree_trans *trans, struct btree_iter *iter)
 {
-	if (!bch2_btree_iter_rewind(iter))
+	if (!bch2_btree_iter_rewind(trans, iter))
 		return bkey_s_c_null;
 
-	return bch2_btree_iter_peek_slot(iter);
+	return bch2_btree_iter_peek_slot(trans, iter);
 }
 
 /* Obsolete, but still used by rust wrapper in -tools */
-struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *iter)
+struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_trans *trans, struct btree_iter *iter)
 {
 	struct bkey_s_c k;
 
-	while (btree_trans_too_many_iters(iter->trans) ||
-	       (k = bch2_btree_iter_peek_type(iter, iter->flags),
+	while (btree_trans_too_many_iters(trans) ||
+	       (k = bch2_btree_iter_peek_type(trans, iter, iter->flags),
 		bch2_err_matches(bkey_err(k), BCH_ERR_transaction_restart)))
-		bch2_trans_begin(iter->trans);
+		bch2_trans_begin(trans);
 
 	return k;
 }
@@ -3043,7 +3037,6 @@ void bch2_trans_iter_exit(struct btree_trans *trans, struct btree_iter *iter)
 	iter->path		= 0;
 	iter->update_path	= 0;
 	iter->key_cache_path	= 0;
-	iter->trans		= NULL;
 }
 
 void bch2_trans_iter_init_outlined(struct btree_trans *trans,
@@ -3083,10 +3076,9 @@ void bch2_trans_node_iter_init(struct btree_trans *trans,
 	BUG_ON(iter->min_depth	!= depth);
 }
 
-void bch2_trans_copy_iter(struct btree_iter *dst, struct btree_iter *src)
+void bch2_trans_copy_iter(struct btree_trans *trans,
+			  struct btree_iter *dst, struct btree_iter *src)
 {
-	struct btree_trans *trans = src->trans;
-
 	*dst = *src;
 #ifdef TRACK_PATH_ALLOCATED
 	dst->ip_allocated = _RET_IP_;
diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
index 8823eec6b284..33d26f648b97 100644
--- a/fs/bcachefs/btree_iter.h
+++ b/fs/bcachefs/btree_iter.h
@@ -394,36 +394,37 @@ void bch2_trans_node_add(struct btree_trans *trans, struct btree_path *, struct
 void bch2_trans_node_drop(struct btree_trans *trans, struct btree *);
 void bch2_trans_node_reinit_iter(struct btree_trans *, struct btree *);
 
-int __must_check __bch2_btree_iter_traverse(struct btree_iter *iter);
-int __must_check bch2_btree_iter_traverse(struct btree_iter *);
+int __must_check __bch2_btree_iter_traverse(struct btree_trans *, struct btree_iter *);
+int __must_check bch2_btree_iter_traverse(struct btree_trans *, struct btree_iter *);
 
-struct btree *bch2_btree_iter_peek_node(struct btree_iter *);
-struct btree *bch2_btree_iter_peek_node_and_restart(struct btree_iter *);
-struct btree *bch2_btree_iter_next_node(struct btree_iter *);
+struct btree *bch2_btree_iter_peek_node(struct btree_trans *, struct btree_iter *);
+struct btree *bch2_btree_iter_peek_node_and_restart(struct btree_trans *, struct btree_iter *);
+struct btree *bch2_btree_iter_next_node(struct btree_trans *, struct btree_iter *);
 
-struct bkey_s_c bch2_btree_iter_peek_max(struct btree_iter *, struct bpos);
-struct bkey_s_c bch2_btree_iter_next(struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_peek_max(struct btree_trans *, struct btree_iter *, struct bpos);
+struct bkey_s_c bch2_btree_iter_next(struct btree_trans *, struct btree_iter *);
 
-static inline struct bkey_s_c bch2_btree_iter_peek(struct btree_iter *iter)
+static inline struct bkey_s_c bch2_btree_iter_peek(struct btree_trans *trans,
+						   struct btree_iter *iter)
 {
-	return bch2_btree_iter_peek_max(iter, SPOS_MAX);
+	return bch2_btree_iter_peek_max(trans, iter, SPOS_MAX);
 }
 
-struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_iter *, struct bpos);
+struct bkey_s_c bch2_btree_iter_peek_prev_min(struct btree_trans *, struct btree_iter *, struct bpos);
 
-static inline struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_iter *iter)
+static inline struct bkey_s_c bch2_btree_iter_peek_prev(struct btree_trans *trans, struct btree_iter *iter)
 {
-	return bch2_btree_iter_peek_prev_min(iter, POS_MIN);
+	return bch2_btree_iter_peek_prev_min(trans, iter, POS_MIN);
 }
 
-struct bkey_s_c bch2_btree_iter_prev(struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_prev(struct btree_trans *, struct btree_iter *);
 
-struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_iter *);
-struct bkey_s_c bch2_btree_iter_next_slot(struct btree_iter *);
-struct bkey_s_c bch2_btree_iter_prev_slot(struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_peek_slot(struct btree_trans *, struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_next_slot(struct btree_trans *, struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_prev_slot(struct btree_trans *, struct btree_iter *);
 
-bool bch2_btree_iter_advance(struct btree_iter *);
-bool bch2_btree_iter_rewind(struct btree_iter *);
+bool bch2_btree_iter_advance(struct btree_trans *, struct btree_iter *);
+bool bch2_btree_iter_rewind(struct btree_trans *, struct btree_iter *);
 
 static inline void __bch2_btree_iter_set_pos(struct btree_iter *iter, struct bpos new_pos)
 {
@@ -434,10 +435,9 @@ static inline void __bch2_btree_iter_set_pos(struct btree_iter *iter, struct bpo
 	iter->k.size = 0;
 }
 
-static inline void bch2_btree_iter_set_pos(struct btree_iter *iter, struct bpos new_pos)
+static inline void bch2_btree_iter_set_pos(struct btree_trans *trans,
+					   struct btree_iter *iter, struct bpos new_pos)
 {
-	struct btree_trans *trans = iter->trans;
-
 	if (unlikely(iter->update_path))
 		bch2_path_put(trans, iter->update_path,
 			      iter->flags & BTREE_ITER_intent);
@@ -455,13 +455,14 @@ static inline void bch2_btree_iter_set_pos_to_extent_start(struct btree_iter *it
 	iter->pos = bkey_start_pos(&iter->k);
 }
 
-static inline void bch2_btree_iter_set_snapshot(struct btree_iter *iter, u32 snapshot)
+static inline void bch2_btree_iter_set_snapshot(struct btree_trans *trans,
+						struct btree_iter *iter, u32 snapshot)
 {
 	struct bpos pos = iter->pos;
 
 	iter->snapshot = snapshot;
 	pos.snapshot = snapshot;
-	bch2_btree_iter_set_pos(iter, pos);
+	bch2_btree_iter_set_pos(trans, iter, pos);
 }
 
 void bch2_trans_iter_exit(struct btree_trans *, struct btree_iter *);
@@ -503,7 +504,6 @@ static inline void bch2_trans_iter_init_common(struct btree_trans *trans,
 					  unsigned flags,
 					  unsigned long ip)
 {
-	iter->trans		= trans;
 	iter->update_path	= 0;
 	iter->key_cache_path	= 0;
 	iter->btree_id		= btree_id;
@@ -540,9 +540,9 @@ static inline void bch2_trans_iter_init(struct btree_trans *trans,
 void bch2_trans_node_iter_init(struct btree_trans *, struct btree_iter *,
 			       enum btree_id, struct bpos,
 			       unsigned, unsigned, unsigned);
-void bch2_trans_copy_iter(struct btree_iter *, struct btree_iter *);
+void bch2_trans_copy_iter(struct btree_trans *, struct btree_iter *, struct btree_iter *);
 
-void bch2_set_btree_iter_dontneed(struct btree_iter *);
+void bch2_set_btree_iter_dontneed(struct btree_trans *, struct btree_iter *);
 
 void *__bch2_trans_kmalloc(struct btree_trans *, size_t);
 
@@ -589,7 +589,7 @@ static inline struct bkey_s_c __bch2_bkey_get_iter(struct btree_trans *trans,
 	struct bkey_s_c k;
 
 	bch2_trans_iter_init(trans, iter, btree_id, pos, flags);
-	k = bch2_btree_iter_peek_slot(iter);
+	k = bch2_btree_iter_peek_slot(trans, iter);
 
 	if (!bkey_err(k) && type && k.k->type != type)
 		k = bkey_s_c_err(-BCH_ERR_ENOENT_bkey_type_mismatch);
@@ -659,14 +659,14 @@ u32 bch2_trans_begin(struct btree_trans *);
 	int _ret3 = 0;								\
 	do {									\
 		_ret3 = lockrestart_do((_trans), ({				\
-			struct btree *_b = bch2_btree_iter_peek_node(&_iter);	\
+			struct btree *_b = bch2_btree_iter_peek_node(_trans, &_iter);\
 			if (!_b)						\
 				break;						\
 										\
 			PTR_ERR_OR_ZERO(_b) ?: (_do);				\
 		})) ?:								\
 		lockrestart_do((_trans),					\
-			PTR_ERR_OR_ZERO(bch2_btree_iter_next_node(&_iter)));	\
+			PTR_ERR_OR_ZERO(bch2_btree_iter_next_node(_trans, &_iter)));\
 	} while (!_ret3);							\
 										\
 	bch2_trans_iter_exit((_trans), &(_iter));				\
@@ -678,31 +678,34 @@ u32 bch2_trans_begin(struct btree_trans *);
 	__for_each_btree_node(_trans, _iter, _btree_id, _start,	\
 			      0, 0, _flags, _b, _do)
 
-static inline struct bkey_s_c bch2_btree_iter_peek_prev_type(struct btree_iter *iter,
+static inline struct bkey_s_c bch2_btree_iter_peek_prev_type(struct btree_trans *trans,
+							     struct btree_iter *iter,
 							     unsigned flags)
 {
-	return  flags & BTREE_ITER_slots      ? bch2_btree_iter_peek_slot(iter) :
-						bch2_btree_iter_peek_prev(iter);
+	return  flags & BTREE_ITER_slots      ? bch2_btree_iter_peek_slot(trans, iter) :
+						bch2_btree_iter_peek_prev(trans, iter);
 }
 
-static inline struct bkey_s_c bch2_btree_iter_peek_type(struct btree_iter *iter,
+static inline struct bkey_s_c bch2_btree_iter_peek_type(struct btree_trans *trans,
+							struct btree_iter *iter,
 							unsigned flags)
 {
-	return  flags & BTREE_ITER_slots      ? bch2_btree_iter_peek_slot(iter) :
-						bch2_btree_iter_peek(iter);
+	return  flags & BTREE_ITER_slots      ? bch2_btree_iter_peek_slot(trans, iter) :
+						bch2_btree_iter_peek(trans, iter);
 }
 
-static inline struct bkey_s_c bch2_btree_iter_peek_max_type(struct btree_iter *iter,
-							     struct bpos end,
-							     unsigned flags)
+static inline struct bkey_s_c bch2_btree_iter_peek_max_type(struct btree_trans *trans,
+							    struct btree_iter *iter,
+							    struct bpos end,
+							    unsigned flags)
 {
 	if (!(flags & BTREE_ITER_slots))
-		return bch2_btree_iter_peek_max(iter, end);
+		return bch2_btree_iter_peek_max(trans, iter, end);
 
 	if (bkey_gt(iter->pos, end))
 		return bkey_s_c_null;
 
-	return bch2_btree_iter_peek_slot(iter);
+	return bch2_btree_iter_peek_slot(trans, iter);
 }
 
 int __bch2_btree_trans_too_many_iters(struct btree_trans *);
@@ -769,14 +772,14 @@ transaction_restart:							\
 									\
 	do {								\
 		_ret3 = lockrestart_do(_trans, ({			\
-			(_k) = bch2_btree_iter_peek_max_type(&(_iter),	\
+			(_k) = bch2_btree_iter_peek_max_type(_trans, &(_iter),	\
 						_end, (_flags));	\
 			if (!(_k).k)					\
 				break;					\
 									\
 			bkey_err(_k) ?: (_do);				\
 		}));							\
-	} while (!_ret3 && bch2_btree_iter_advance(&(_iter)));		\
+	} while (!_ret3 && bch2_btree_iter_advance(_trans, &(_iter)));	\
 									\
 	bch2_trans_iter_exit((_trans), &(_iter));			\
 	_ret3;								\
@@ -814,14 +817,14 @@ transaction_restart:							\
 									\
 	do {								\
 		_ret3 = lockrestart_do(_trans, ({			\
-			(_k) = bch2_btree_iter_peek_prev_type(&(_iter),	\
+			(_k) = bch2_btree_iter_peek_prev_type(_trans, &(_iter),	\
 							(_flags));	\
 			if (!(_k).k)					\
 				break;					\
 									\
 			bkey_err(_k) ?: (_do);				\
 		}));							\
-	} while (!_ret3 && bch2_btree_iter_rewind(&(_iter)));		\
+	} while (!_ret3 && bch2_btree_iter_rewind(_trans, &(_iter)));	\
 									\
 	bch2_trans_iter_exit((_trans), &(_iter));			\
 	_ret3;								\
@@ -851,37 +854,38 @@ transaction_restart:							\
 			    (_do) ?: bch2_trans_commit(_trans, (_disk_res),\
 					(_journal_seq), (_commit_flags)))
 
-struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_iter *);
+struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_trans *,
+							  struct btree_iter *);
 
 #define for_each_btree_key_max_norestart(_trans, _iter, _btree_id,	\
 			   _start, _end, _flags, _k, _ret)		\
 	for (bch2_trans_iter_init((_trans), &(_iter), (_btree_id),	\
 				  (_start), (_flags));			\
-	     (_k) = bch2_btree_iter_peek_max_type(&(_iter), _end, _flags),\
+	     (_k) = bch2_btree_iter_peek_max_type(_trans, &(_iter), _end, _flags),\
 	     !((_ret) = bkey_err(_k)) && (_k).k;			\
-	     bch2_btree_iter_advance(&(_iter)))
+	     bch2_btree_iter_advance(_trans, &(_iter)))
 
-#define for_each_btree_key_max_continue_norestart(_iter, _end, _flags, _k, _ret)\
+#define for_each_btree_key_max_continue_norestart(_trans, _iter, _end, _flags, _k, _ret)\
 	for (;									\
-	     (_k) = bch2_btree_iter_peek_max_type(&(_iter), _end, _flags),	\
+	     (_k) = bch2_btree_iter_peek_max_type(_trans, &(_iter), _end, _flags),	\
 	     !((_ret) = bkey_err(_k)) && (_k).k;				\
-	     bch2_btree_iter_advance(&(_iter)))
+	     bch2_btree_iter_advance(_trans, &(_iter)))
 
 #define for_each_btree_key_norestart(_trans, _iter, _btree_id,		\
 			   _start, _flags, _k, _ret)			\
 	for_each_btree_key_max_norestart(_trans, _iter, _btree_id, _start,\
 					  SPOS_MAX, _flags, _k, _ret)
 
-#define for_each_btree_key_reverse_norestart(_trans, _iter, _btree_id,	\
-					     _start, _flags, _k, _ret)	\
-	for (bch2_trans_iter_init((_trans), &(_iter), (_btree_id),	\
-				  (_start), (_flags));			\
-	     (_k) = bch2_btree_iter_peek_prev_type(&(_iter), _flags),	\
-	     !((_ret) = bkey_err(_k)) && (_k).k;			\
-	     bch2_btree_iter_rewind(&(_iter)))
+#define for_each_btree_key_reverse_norestart(_trans, _iter, _btree_id,		\
+					     _start, _flags, _k, _ret)		\
+	for (bch2_trans_iter_init((_trans), &(_iter), (_btree_id),		\
+				  (_start), (_flags));				\
+	     (_k) = bch2_btree_iter_peek_prev_type(_trans, &(_iter), _flags),	\
+	     !((_ret) = bkey_err(_k)) && (_k).k;				\
+	     bch2_btree_iter_rewind(_trans, &(_iter)))
 
-#define for_each_btree_key_continue_norestart(_iter, _flags, _k, _ret)	\
-	for_each_btree_key_max_continue_norestart(_iter, SPOS_MAX, _flags, _k, _ret)
+#define for_each_btree_key_continue_norestart(_trans, _iter, _flags, _k, _ret)	\
+	for_each_btree_key_max_continue_norestart(_trans, _iter, SPOS_MAX, _flags, _k, _ret)
 
 /*
  * This should not be used in a fastpath, without first trying _do in
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index edce59433375..b6b64af826be 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -306,7 +306,7 @@ static noinline int btree_key_cache_fill(struct btree_trans *trans,
 			     BTREE_ITER_key_cache_fill|
 			     BTREE_ITER_cached_nofill);
 	iter.flags &= ~BTREE_ITER_with_journal;
-	k = bch2_btree_iter_peek_slot(&iter);
+	k = bch2_btree_iter_peek_slot(trans, &iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -331,7 +331,7 @@ static noinline int btree_key_cache_fill(struct btree_trans *trans,
 	}
 out:
 	/* We're not likely to need this iterator again: */
-	bch2_set_btree_iter_dontneed(&iter);
+	bch2_set_btree_iter_dontneed(trans, &iter);
 err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -412,7 +412,7 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 			     BTREE_ITER_intent);
 	b_iter.flags &= ~BTREE_ITER_with_key_cache;
 
-	ret = bch2_btree_iter_traverse(&c_iter);
+	ret = bch2_btree_iter_traverse(trans, &c_iter);
 	if (ret)
 		goto out;
 
@@ -444,7 +444,7 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
 	    !test_bit(JOURNAL_space_low, &c->journal.flags))
 		commit_flags |= BCH_TRANS_COMMIT_no_journal_res;
 
-	struct bkey_s_c btree_k = bch2_btree_iter_peek_slot(&b_iter);
+	struct bkey_s_c btree_k = bch2_btree_iter_peek_slot(trans, &b_iter);
 	ret = bkey_err(btree_k);
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
index 77578da2d23f..023c472dc9ee 100644
--- a/fs/bcachefs/btree_types.h
+++ b/fs/bcachefs/btree_types.h
@@ -367,7 +367,6 @@ static inline unsigned long btree_path_ip_allocated(struct btree_path *path)
  * @nodes_intent_locked	- bitmask indicating which locks are intent locks
  */
 struct btree_iter {
-	struct btree_trans	*trans;
 	btree_path_idx_t	path;
 	btree_path_idx_t	update_path;
 	btree_path_idx_t	key_cache_path;
diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index bd2eb42edb24..7727a501cb4e 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -126,7 +126,7 @@ int __bch2_insert_snapshot_whiteouts(struct btree_trans *trans,
 				   struct bpos new_pos)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter old_iter, new_iter = { NULL };
+	struct btree_iter old_iter, new_iter = {};
 	struct bkey_s_c old_k, new_k;
 	snapshot_id_list s;
 	struct bkey_i *update;
@@ -140,7 +140,7 @@ int __bch2_insert_snapshot_whiteouts(struct btree_trans *trans,
 	bch2_trans_iter_init(trans, &old_iter, id, old_pos,
 			     BTREE_ITER_not_extents|
 			     BTREE_ITER_all_snapshots);
-	while ((old_k = bch2_btree_iter_prev(&old_iter)).k &&
+	while ((old_k = bch2_btree_iter_prev(trans, &old_iter)).k &&
 	       !(ret = bkey_err(old_k)) &&
 	       bkey_eq(old_pos, old_k.k->p)) {
 		struct bpos whiteout_pos =
@@ -296,7 +296,7 @@ static int bch2_trans_update_extent(struct btree_trans *trans,
 			     BTREE_ITER_intent|
 			     BTREE_ITER_with_updates|
 			     BTREE_ITER_not_extents);
-	k = bch2_btree_iter_peek_max(&iter, POS(insert->k.p.inode, U64_MAX));
+	k = bch2_btree_iter_peek_max(trans, &iter, POS(insert->k.p.inode, U64_MAX));
 	if ((ret = bkey_err(k)))
 		goto err;
 	if (!k.k)
@@ -322,8 +322,8 @@ static int bch2_trans_update_extent(struct btree_trans *trans,
 		if (done)
 			goto out;
 next:
-		bch2_btree_iter_advance(&iter);
-		k = bch2_btree_iter_peek_max(&iter, POS(insert->k.p.inode, U64_MAX));
+		bch2_btree_iter_advance(trans, &iter);
+		k = bch2_btree_iter_peek_max(trans, &iter, POS(insert->k.p.inode, U64_MAX));
 		if ((ret = bkey_err(k)))
 			goto err;
 		if (!k.k)
@@ -592,13 +592,13 @@ int bch2_bkey_get_empty_slot(struct btree_trans *trans, struct btree_iter *iter,
 			     enum btree_id btree, struct bpos end)
 {
 	bch2_trans_iter_init(trans, iter, btree, end, BTREE_ITER_intent);
-	struct bkey_s_c k = bch2_btree_iter_peek_prev(iter);
+	struct bkey_s_c k = bch2_btree_iter_peek_prev(trans, iter);
 	int ret = bkey_err(k);
 	if (ret)
 		goto err;
 
-	bch2_btree_iter_advance(iter);
-	k = bch2_btree_iter_peek_slot(iter);
+	bch2_btree_iter_advance(trans, iter);
+	k = bch2_btree_iter_peek_slot(trans, iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -634,7 +634,7 @@ int bch2_btree_insert_nonextent(struct btree_trans *trans,
 			     BTREE_ITER_cached|
 			     BTREE_ITER_not_extents|
 			     BTREE_ITER_intent);
-	ret   = bch2_btree_iter_traverse(&iter) ?:
+	ret   = bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_trans_update(trans, &iter, k, flags);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -646,7 +646,7 @@ int bch2_btree_insert_trans(struct btree_trans *trans, enum btree_id id,
 	struct btree_iter iter;
 	bch2_trans_iter_init(trans, &iter, id, bkey_start_pos(&k->k),
 			     BTREE_ITER_intent|flags);
-	int ret = bch2_btree_iter_traverse(&iter) ?:
+	int ret = bch2_btree_iter_traverse(trans, &iter) ?:
 		  bch2_trans_update(trans, &iter, k, flags);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -695,7 +695,7 @@ int bch2_btree_delete(struct btree_trans *trans,
 	bch2_trans_iter_init(trans, &iter, btree, pos,
 			     BTREE_ITER_cached|
 			     BTREE_ITER_intent);
-	ret   = bch2_btree_iter_traverse(&iter) ?:
+	ret   = bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_btree_delete_at(trans, &iter, update_flags);
 	bch2_trans_iter_exit(trans, &iter);
 
@@ -713,7 +713,7 @@ int bch2_btree_delete_range_trans(struct btree_trans *trans, enum btree_id id,
 	int ret = 0;
 
 	bch2_trans_iter_init(trans, &iter, id, start, BTREE_ITER_intent);
-	while ((k = bch2_btree_iter_peek_max(&iter, end)).k) {
+	while ((k = bch2_btree_iter_peek_max(trans, &iter, end)).k) {
 		struct disk_reservation disk_res =
 			bch2_disk_reservation_init(trans->c, 0);
 		struct bkey_i delete;
@@ -808,7 +808,7 @@ int bch2_btree_bit_mod(struct btree_trans *trans, enum btree_id btree,
 	struct btree_iter iter;
 	bch2_trans_iter_init(trans, &iter, btree, pos, BTREE_ITER_intent);
 
-	int ret = bch2_btree_iter_traverse(&iter) ?:
+	int ret = bch2_btree_iter_traverse(trans, &iter) ?:
 		  bch2_btree_bit_mod_iter(trans, &iter, set);
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
index 67f1e3202835..548145f8f521 100644
--- a/fs/bcachefs/btree_update_interior.c
+++ b/fs/bcachefs/btree_update_interior.c
@@ -2132,7 +2132,7 @@ static int get_iter_to_node(struct btree_trans *trans, struct btree_iter *iter,
 	bch2_trans_node_iter_init(trans, iter, b->c.btree_id, b->key.k.p,
 				  BTREE_MAX_DEPTH, b->c.level,
 				  BTREE_ITER_intent);
-	int ret = bch2_btree_iter_traverse(iter);
+	int ret = bch2_btree_iter_traverse(trans, iter);
 	if (ret)
 		goto err;
 
@@ -2224,7 +2224,7 @@ static int bch2_btree_node_rewrite_key(struct btree_trans *trans,
 	bch2_trans_node_iter_init(trans, &iter,
 				  btree, k->k.p,
 				  BTREE_MAX_DEPTH, level, 0);
-	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	struct btree *b = bch2_btree_iter_peek_node(trans, &iter);
 	int ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
 		goto out;
@@ -2247,7 +2247,7 @@ int bch2_btree_node_rewrite_pos(struct btree_trans *trans,
 	/* Traverse one depth lower to get a pointer to the node itself: */
 	struct btree_iter iter;
 	bch2_trans_node_iter_init(trans, &iter, btree, pos, 0, level - 1, 0);
-	struct btree *b = bch2_btree_iter_peek_node(&iter);
+	struct btree *b = bch2_btree_iter_peek_node(trans, &iter);
 	int ret = PTR_ERR_OR_ZERO(b);
 	if (ret)
 		goto err;
@@ -2389,7 +2389,7 @@ static int __bch2_btree_node_update_key(struct btree_trans *trans,
 					bool skip_triggers)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter2 = { NULL };
+	struct btree_iter iter2 = {};
 	struct btree *parent;
 	int ret;
 
@@ -2413,7 +2413,7 @@ static int __bch2_btree_node_update_key(struct btree_trans *trans,
 
 	parent = btree_node_parent(btree_iter_path(trans, iter), b);
 	if (parent) {
-		bch2_trans_copy_iter(&iter2, iter);
+		bch2_trans_copy_iter(trans, &iter2, iter);
 
 		iter2.path = bch2_btree_path_make_mut(trans, iter2.path,
 				iter2.flags & BTREE_ITER_intent,
@@ -2427,7 +2427,7 @@ static int __bch2_btree_node_update_key(struct btree_trans *trans,
 
 		trans->paths_sorted = false;
 
-		ret   = bch2_btree_iter_traverse(&iter2) ?:
+		ret   = bch2_btree_iter_traverse(trans, &iter2) ?:
 			bch2_trans_update(trans, &iter2, new_key, BTREE_TRIGGER_norun);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 2c09d19dd621..adbe576ec77e 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -144,7 +144,7 @@ static inline int wb_flush_one(struct btree_trans *trans, struct btree_iter *ite
 	EBUG_ON(!trans->c->btree_write_buffer.flushing.pin.seq);
 	EBUG_ON(trans->c->btree_write_buffer.flushing.pin.seq > wb->journal_seq);
 
-	ret = bch2_btree_iter_traverse(iter);
+	ret = bch2_btree_iter_traverse(trans, iter);
 	if (ret)
 		return ret;
 
@@ -208,7 +208,7 @@ btree_write_buffered_insert(struct btree_trans *trans,
 
 	trans->journal_res.seq = wb->journal_seq;
 
-	ret   = bch2_btree_iter_traverse(&iter) ?:
+	ret   = bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_trans_update(trans, &iter, &wb->k,
 				  BTREE_UPDATE_internal_snapshot_node);
 	bch2_trans_iter_exit(trans, &iter);
@@ -285,7 +285,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 	struct bch_fs *c = trans->c;
 	struct journal *j = &c->journal;
 	struct btree_write_buffer *wb = &c->btree_write_buffer;
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	size_t overwritten = 0, fast = 0, slowpath = 0, could_not_insert = 0;
 	bool write_locked = false;
 	bool accounting_replay_done = test_bit(BCH_FS_accounting_replay_done, &c->flags);
@@ -368,7 +368,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 				write_locked = false;
 
 				ret = lockrestart_do(trans,
-					bch2_btree_iter_traverse(&iter) ?:
+					bch2_btree_iter_traverse(trans, &iter) ?:
 					bch2_foreground_maybe_merge(trans, iter.path, 0,
 							BCH_WATERMARK_reclaim|
 							BCH_TRANS_COMMIT_journal_reclaim|
@@ -385,7 +385,7 @@ static int bch2_btree_write_buffer_flush_locked(struct btree_trans *trans)
 					     BTREE_ITER_intent|BTREE_ITER_all_snapshots);
 		}
 
-		bch2_btree_iter_set_pos(&iter, k->k.k.p);
+		bch2_btree_iter_set_pos(trans, &iter, k->k.k.p);
 		btree_iter_path(trans, &iter)->preserve = false;
 
 		bool accounting_accumulated = false;
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index e56ef623ebc1..c36f1d62b220 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -365,7 +365,7 @@ int bch2_check_fix_ptrs(struct btree_trans *trans,
 		struct btree_iter iter;
 		bch2_trans_node_iter_init(trans, &iter, btree, new->k.p, 0, level,
 					  BTREE_ITER_intent|BTREE_ITER_all_snapshots);
-		ret =   bch2_btree_iter_traverse(&iter) ?:
+		ret =   bch2_btree_iter_traverse(trans, &iter) ?:
 			bch2_trans_update(trans, &iter, new,
 					  BTREE_UPDATE_internal_snapshot_node|
 					  BTREE_TRIGGER_norun);
diff --git a/fs/bcachefs/data_update.c b/fs/bcachefs/data_update.c
index 0ec273daccb7..8fcbe979dc3f 100644
--- a/fs/bcachefs/data_update.c
+++ b/fs/bcachefs/data_update.c
@@ -208,7 +208,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 
 		bch2_trans_begin(trans);
 
-		k = bch2_btree_iter_peek_slot(&iter);
+		k = bch2_btree_iter_peek_slot(trans, &iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
@@ -385,7 +385,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 				BCH_TRANS_COMMIT_no_enospc|
 				m->data_opts.btree_insert_flags);
 		if (!ret) {
-			bch2_btree_iter_set_pos(&iter, next_pos);
+			bch2_btree_iter_set_pos(trans, &iter, next_pos);
 
 			this_cpu_add(c->counters[BCH_COUNTER_io_move_finish], new->k.size);
 			if (trace_io_move_finish_enabled())
@@ -413,7 +413,7 @@ static int __bch2_data_update_index_update(struct btree_trans *trans,
 
 		count_event(c, io_move_fail);
 
-		bch2_btree_iter_advance(&iter);
+		bch2_btree_iter_advance(trans, &iter);
 		goto next;
 	}
 out:
@@ -483,7 +483,7 @@ static int bch2_update_unwritten_extent(struct btree_trans *trans,
 		bch2_trans_iter_init(trans, &iter, update->btree_id, update->op.pos,
 				     BTREE_ITER_slots);
 		ret = lockrestart_do(trans, ({
-			k = bch2_btree_iter_peek_slot(&iter);
+			k = bch2_btree_iter_peek_slot(trans, &iter);
 			bkey_err(k);
 		}));
 		bch2_trans_iter_exit(trans, &iter);
diff --git a/fs/bcachefs/dirent.c b/fs/bcachefs/dirent.c
index d7f9f79318a2..bf53a029f356 100644
--- a/fs/bcachefs/dirent.c
+++ b/fs/bcachefs/dirent.c
@@ -417,8 +417,8 @@ int bch2_dirent_rename(struct btree_trans *trans,
 		enum bch_rename_mode mode)
 {
 	struct qstr src_name_lookup, dst_name_lookup;
-	struct btree_iter src_iter = { NULL };
-	struct btree_iter dst_iter = { NULL };
+	struct btree_iter src_iter = {};
+	struct btree_iter dst_iter = {};
 	struct bkey_s_c old_src, old_dst = bkey_s_c_null;
 	struct bkey_i_dirent *new_src = NULL, *new_dst = NULL;
 	struct bpos dst_pos =
@@ -586,16 +586,16 @@ int bch2_dirent_rename(struct btree_trans *trans,
 	}
 
 	if (delete_src) {
-		bch2_btree_iter_set_snapshot(&src_iter, old_src.k->p.snapshot);
-		ret =   bch2_btree_iter_traverse(&src_iter) ?:
+		bch2_btree_iter_set_snapshot(trans, &src_iter, old_src.k->p.snapshot);
+		ret =   bch2_btree_iter_traverse(trans, &src_iter) ?:
 			bch2_btree_delete_at(trans, &src_iter, BTREE_UPDATE_internal_snapshot_node);
 		if (ret)
 			goto out;
 	}
 
 	if (delete_dst) {
-		bch2_btree_iter_set_snapshot(&dst_iter, old_dst.k->p.snapshot);
-		ret =   bch2_btree_iter_traverse(&dst_iter) ?:
+		bch2_btree_iter_set_snapshot(trans, &dst_iter, old_dst.k->p.snapshot);
+		ret =   bch2_btree_iter_traverse(trans, &dst_iter) ?:
 			bch2_btree_delete_at(trans, &dst_iter, BTREE_UPDATE_internal_snapshot_node);
 		if (ret)
 			goto out;
@@ -642,7 +642,7 @@ u64 bch2_dirent_lookup(struct bch_fs *c, subvol_inum dir,
 		       const struct qstr *name, subvol_inum *inum)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 
 	int ret = lockrestart_do(trans,
 		bch2_dirent_lookup_trans(trans, &iter, dir, hash_info, name, inum, 0));
@@ -771,7 +771,7 @@ int bch2_fsck_remove_dirent(struct btree_trans *trans, struct bpos pos)
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_dirents, pos, BTREE_ITER_intent);
 
-	ret =   bch2_btree_iter_traverse(&iter) ?:
+	ret =   bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
 				    &dir_hash_info, &iter,
 				    BTREE_UPDATE_internal_snapshot_node);
diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
index b32e91ba8be8..1edc68c254d4 100644
--- a/fs/bcachefs/disk_accounting.c
+++ b/fs/bcachefs/disk_accounting.c
@@ -727,7 +727,7 @@ int bch2_accounting_read(struct bch_fs *c)
 
 			if (!bch2_accounting_is_mem(acc_k)) {
 				struct disk_accounting_pos next = { .type = acc_k.type + 1 };
-				bch2_btree_iter_set_pos(&iter, disk_accounting_pos_to_bpos(&next));
+				bch2_btree_iter_set_pos(trans, &iter, disk_accounting_pos_to_bpos(&next));
 				continue;
 			}
 
@@ -918,7 +918,7 @@ void bch2_verify_accounting_clean(struct bch_fs *c)
 
 			if (!bch2_accounting_is_mem(acc_k)) {
 				struct disk_accounting_pos next = { .type = acc_k.type + 1 };
-				bch2_btree_iter_set_pos(&iter, disk_accounting_pos_to_bpos(&next));
+				bch2_btree_iter_set_pos(trans, &iter, disk_accounting_pos_to_bpos(&next));
 				continue;
 			}
 
diff --git a/fs/bcachefs/ec.c b/fs/bcachefs/ec.c
index f2b9225fe0bc..a65c90bdd425 100644
--- a/fs/bcachefs/ec.c
+++ b/fs/bcachefs/ec.c
@@ -1836,7 +1836,7 @@ static int __get_existing_stripe(struct btree_trans *trans,
 		ret = 1;
 	}
 out:
-	bch2_set_btree_iter_dontneed(&iter);
+	bch2_set_btree_iter_dontneed(trans, &iter);
 err:
 	bch2_trans_iter_exit(trans, &iter);
 	return ret;
@@ -1949,7 +1949,7 @@ static int __bch2_ec_stripe_head_reserve(struct btree_trans *trans, struct ec_st
 		if (bkey_gt(k.k->p, POS(0, U32_MAX))) {
 			if (start_pos.offset) {
 				start_pos = min_pos;
-				bch2_btree_iter_set_pos(&iter, start_pos);
+				bch2_btree_iter_set_pos(trans, &iter, start_pos);
 				continue;
 			}
 
diff --git a/fs/bcachefs/extent_update.c b/fs/bcachefs/extent_update.c
index 6aac579a692a..6bb42985306e 100644
--- a/fs/bcachefs/extent_update.c
+++ b/fs/bcachefs/extent_update.c
@@ -112,7 +112,7 @@ int bch2_extent_atomic_end(struct btree_trans *trans,
 	unsigned nr_iters = 0;
 	int ret;
 
-	ret = bch2_btree_iter_traverse(iter);
+	ret = bch2_btree_iter_traverse(trans, iter);
 	if (ret)
 		return ret;
 
@@ -126,9 +126,9 @@ int bch2_extent_atomic_end(struct btree_trans *trans,
 	if (ret < 0)
 		return ret;
 
-	bch2_trans_copy_iter(&copy, iter);
+	bch2_trans_copy_iter(trans, &copy, iter);
 
-	for_each_btree_key_max_continue_norestart(copy, insert->k.p, 0, k, ret) {
+	for_each_btree_key_max_continue_norestart(trans, copy, insert->k.p, 0, k, ret) {
 		unsigned offset = 0;
 
 		if (bkey_gt(bkey_start_pos(&insert->k), bkey_start_pos(k.k)))
diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 5ab1c73c8d4c..dee8c1f1e6d6 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -183,12 +183,12 @@ static void bchfs_read(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
 
-		bch2_btree_iter_set_pos(&iter,
+		bch2_btree_iter_set_pos(trans, &iter,
 				POS(inum.inum, rbio->bio.bi_iter.bi_sector));
 
-		k = bch2_btree_iter_peek_slot(&iter);
+		k = bch2_btree_iter_peek_slot(trans, &iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 717e7b94c66f..8dc0b14a4e10 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -636,9 +636,9 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 		if (ret)
 			goto bkey_err;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
 
-		k = bch2_btree_iter_peek_slot(&iter);
+		k = bch2_btree_iter_peek_slot(trans, &iter);
 		if ((ret = bkey_err(k)))
 			goto bkey_err;
 
@@ -649,13 +649,13 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 		/* already reserved */
 		if (bkey_extent_is_reservation(k) &&
 		    bch2_bkey_nr_ptrs_fully_allocated(k) >= opts.data_replicas) {
-			bch2_btree_iter_advance(&iter);
+			bch2_btree_iter_advance(trans, &iter);
 			continue;
 		}
 
 		if (bkey_extent_is_data(k.k) &&
 		    !(mode & FALLOC_FL_ZERO_RANGE)) {
-			bch2_btree_iter_advance(&iter);
+			bch2_btree_iter_advance(trans, &iter);
 			continue;
 		}
 
@@ -676,7 +676,7 @@ static noinline int __bchfs_fallocate(struct bch_inode_info *inode, int mode,
 				if (ret)
 					goto bkey_err;
 			}
-			bch2_btree_iter_set_pos(&iter, POS(iter.pos.inode, hole_start));
+			bch2_btree_iter_set_pos(trans, &iter, POS(iter.pos.inode, hole_start));
 
 			if (ret)
 				goto bkey_err;
diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index fbca200f7636..9eb8525b4976 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -88,7 +88,7 @@ int __must_check bch2_write_inode(struct bch_fs *c,
 				  void *p, unsigned fields)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct bch_inode_unpacked inode_u;
 	int ret;
 retry:
@@ -1075,7 +1075,7 @@ int bch2_setattr_nonsize(struct mnt_idmap *idmap,
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
 	struct bch_qid qid;
 	struct btree_trans *trans;
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter inode_iter = {};
 	struct bch_inode_unpacked inode_u;
 	struct posix_acl *acl = NULL;
 	kuid_t kuid;
@@ -1330,9 +1330,9 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		if (ret)
 			continue;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
 
-		k = bch2_btree_iter_peek_max(&iter, end);
+		k = bch2_btree_iter_peek_max(trans, &iter, end);
 		ret = bkey_err(k);
 		if (ret)
 			continue;
@@ -1342,7 +1342,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 
 		if (!bkey_extent_is_data(k.k) &&
 		    k.k->type != KEY_TYPE_reservation) {
-			bch2_btree_iter_advance(&iter);
+			bch2_btree_iter_advance(trans, &iter);
 			continue;
 		}
 
@@ -1380,7 +1380,7 @@ static int bch2_fiemap(struct inode *vinode, struct fiemap_extent_info *info,
 		bkey_copy(prev.k, cur.k);
 		have_extent = true;
 
-		bch2_btree_iter_set_pos(&iter,
+		bch2_btree_iter_set_pos(trans, &iter,
 			POS(iter.pos.inode, iter.pos.offset + sectors));
 	}
 	bch2_trans_iter_exit(trans, &iter);
@@ -1697,17 +1697,17 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 	if (ret)
 		goto err;
 
-	bch2_btree_iter_set_snapshot(&iter1, snapshot);
-	bch2_btree_iter_set_snapshot(&iter2, snapshot);
+	bch2_btree_iter_set_snapshot(trans, &iter1, snapshot);
+	bch2_btree_iter_set_snapshot(trans, &iter2, snapshot);
 
 	ret = bch2_inode_find_by_inum_trans(trans, inode_inum(inode), &inode_u);
 	if (ret)
 		goto err;
 
 	if (inode_u.bi_dir == dir->ei_inode.bi_inum) {
-		bch2_btree_iter_set_pos(&iter1, POS(inode_u.bi_dir, inode_u.bi_dir_offset));
+		bch2_btree_iter_set_pos(trans, &iter1, POS(inode_u.bi_dir, inode_u.bi_dir_offset));
 
-		k = bch2_btree_iter_peek_slot(&iter1);
+		k = bch2_btree_iter_peek_slot(trans, &iter1);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
@@ -1731,7 +1731,7 @@ static int bch2_get_name(struct dentry *parent, char *name, struct dentry *child
 		 * File with multiple hardlinks and our backref is to the wrong
 		 * directory - linear search:
 		 */
-		for_each_btree_key_continue_norestart(iter2, 0, k, ret) {
+		for_each_btree_key_continue_norestart(trans, iter2, 0, k, ret) {
 			if (k.k->p.inode > dir->ei_inode.bi_inum)
 				break;
 
diff --git a/fs/bcachefs/fsck.c b/fs/bcachefs/fsck.c
index 091057023fc5..9d20b8e9fc4a 100644
--- a/fs/bcachefs/fsck.c
+++ b/fs/bcachefs/fsck.c
@@ -186,7 +186,7 @@ static int lookup_lostfound(struct btree_trans *trans, u32 snapshot,
 {
 	struct bch_fs *c = trans->c;
 	struct qstr lostfound_str = QSTR("lost+found");
-	struct btree_iter lostfound_iter = { NULL };
+	struct btree_iter lostfound_iter = {};
 	u64 inum = 0;
 	unsigned d_type = 0;
 	int ret;
@@ -295,8 +295,8 @@ static int lookup_lostfound(struct btree_trans *trans, u32 snapshot,
 	if (ret)
 		goto err;
 
-	bch2_btree_iter_set_snapshot(&lostfound_iter, snapshot);
-	ret = bch2_btree_iter_traverse(&lostfound_iter);
+	bch2_btree_iter_set_snapshot(trans, &lostfound_iter, snapshot);
+	ret = bch2_btree_iter_traverse(trans, &lostfound_iter);
 	if (ret)
 		goto err;
 
@@ -544,7 +544,7 @@ static int reconstruct_subvol(struct btree_trans *trans, u32 snapshotid, u32 sub
 		new_inode.bi_subvol = subvolid;
 
 		int ret = bch2_inode_create(trans, &inode_iter, &new_inode, snapshotid, cpu) ?:
-			  bch2_btree_iter_traverse(&inode_iter) ?:
+			  bch2_btree_iter_traverse(trans, &inode_iter) ?:
 			  bch2_inode_write(trans, &inode_iter, &new_inode);
 		bch2_trans_iter_exit(trans, &inode_iter);
 		if (ret)
@@ -609,7 +609,7 @@ static int reconstruct_inode(struct btree_trans *trans, enum btree_id btree, u32
 		struct btree_iter iter = {};
 
 		bch2_trans_iter_init(trans, &iter, BTREE_ID_extents, SPOS(inum, U64_MAX, snapshot), 0);
-		struct bkey_s_c k = bch2_btree_iter_peek_prev_min(&iter, POS(inum, 0));
+		struct bkey_s_c k = bch2_btree_iter_peek_prev_min(trans, &iter, POS(inum, 0));
 		bch2_trans_iter_exit(trans, &iter);
 		int ret = bkey_err(k);
 		if (ret)
@@ -1557,7 +1557,7 @@ static int overlapping_extents_found(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
-	struct btree_iter iter1, iter2 = { NULL };
+	struct btree_iter iter1, iter2 = {};
 	struct bkey_s_c k1, k2;
 	int ret;
 
@@ -1566,7 +1566,7 @@ static int overlapping_extents_found(struct btree_trans *trans,
 	bch2_trans_iter_init(trans, &iter1, btree, pos1,
 			     BTREE_ITER_all_snapshots|
 			     BTREE_ITER_not_extents);
-	k1 = bch2_btree_iter_peek_max(&iter1, POS(pos1.inode, U64_MAX));
+	k1 = bch2_btree_iter_peek_max(trans, &iter1, POS(pos1.inode, U64_MAX));
 	ret = bkey_err(k1);
 	if (ret)
 		goto err;
@@ -1586,12 +1586,12 @@ static int overlapping_extents_found(struct btree_trans *trans,
 		goto err;
 	}
 
-	bch2_trans_copy_iter(&iter2, &iter1);
+	bch2_trans_copy_iter(trans, &iter2, &iter1);
 
 	while (1) {
-		bch2_btree_iter_advance(&iter2);
+		bch2_btree_iter_advance(trans, &iter2);
 
-		k2 = bch2_btree_iter_peek_max(&iter2, POS(pos1.inode, U64_MAX));
+		k2 = bch2_btree_iter_peek_max(trans, &iter2, POS(pos1.inode, U64_MAX));
 		ret = bkey_err(k2);
 		if (ret)
 			goto err;
@@ -1789,9 +1789,9 @@ static int check_extent(struct btree_trans *trans, struct btree_iter *iter,
 					(bch2_bkey_val_to_text(&buf, c, k), buf.buf))) {
 				struct btree_iter iter2;
 
-				bch2_trans_copy_iter(&iter2, iter);
-				bch2_btree_iter_set_snapshot(&iter2, i->snapshot);
-				ret =   bch2_btree_iter_traverse(&iter2) ?:
+				bch2_trans_copy_iter(trans, &iter2, iter);
+				bch2_btree_iter_set_snapshot(trans, &iter2, i->snapshot);
+				ret =   bch2_btree_iter_traverse(trans, &iter2) ?:
 					bch2_btree_delete_at(trans, &iter2,
 						BTREE_UPDATE_internal_snapshot_node);
 				bch2_trans_iter_exit(trans, &iter2);
@@ -2183,7 +2183,7 @@ static int check_dirent(struct btree_trans *trans, struct btree_iter *iter,
 						     BTREE_ID_dirents,
 						     SPOS(k.k->p.inode, k.k->p.offset, *i),
 						     BTREE_ITER_intent);
-				ret =   bch2_btree_iter_traverse(&delete_iter) ?:
+				ret =   bch2_btree_iter_traverse(trans, &delete_iter) ?:
 					bch2_hash_delete_at(trans, bch2_dirent_hash_desc,
 							  hash_info,
 							  &delete_iter,
@@ -2410,7 +2410,7 @@ static int check_subvol_path(struct btree_trans *trans, struct btree_iter *iter,
 		bch2_trans_iter_exit(trans, &parent_iter);
 		bch2_trans_iter_init(trans, &parent_iter,
 				     BTREE_ID_subvolumes, POS(0, parent), 0);
-		k = bch2_btree_iter_peek_slot(&parent_iter);
+		k = bch2_btree_iter_peek_slot(trans, &parent_iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/inode.c b/fs/bcachefs/inode.c
index 80051073f613..b51d98cf8a80 100644
--- a/fs/bcachefs/inode.c
+++ b/fs/bcachefs/inode.c
@@ -940,7 +940,7 @@ int bch2_inode_create(struct btree_trans *trans,
 			     BTREE_ITER_intent);
 	struct bkey_s_c k;
 again:
-	while ((k = bch2_btree_iter_peek(iter)).k &&
+	while ((k = bch2_btree_iter_peek(trans, iter)).k &&
 	       !(ret = bkey_err(k)) &&
 	       bkey_lt(k.k->p, POS(0, max))) {
 		if (pos < iter->pos.offset)
@@ -951,7 +951,7 @@ int bch2_inode_create(struct btree_trans *trans,
 		 * we've found just one:
 		 */
 		pos = iter->pos.offset + 1;
-		bch2_btree_iter_set_pos(iter, POS(0, pos));
+		bch2_btree_iter_set_pos(trans, iter, POS(0, pos));
 	}
 
 	if (!ret && pos < max)
@@ -967,12 +967,12 @@ int bch2_inode_create(struct btree_trans *trans,
 
 	/* Retry from start */
 	pos = start = min;
-	bch2_btree_iter_set_pos(iter, POS(0, pos));
+	bch2_btree_iter_set_pos(trans, iter, POS(0, pos));
 	le32_add_cpu(&cursor->v.gen, 1);
 	goto again;
 found_slot:
-	bch2_btree_iter_set_pos(iter, SPOS(0, pos, snapshot));
-	k = bch2_btree_iter_peek_slot(iter);
+	bch2_btree_iter_set_pos(trans, iter, SPOS(0, pos, snapshot));
+	k = bch2_btree_iter_peek_slot(trans, iter);
 	ret = bkey_err(k);
 	if (ret) {
 		bch2_trans_iter_exit(trans, iter);
@@ -1009,9 +1009,9 @@ static int bch2_inode_delete_keys(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
 
-		k = bch2_btree_iter_peek_max(&iter, end);
+		k = bch2_btree_iter_peek_max(trans, &iter, end);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
@@ -1042,7 +1042,7 @@ static int bch2_inode_delete_keys(struct btree_trans *trans,
 int bch2_inode_rm(struct bch_fs *c, subvol_inum inum)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct bkey_s_c k;
 	u32 snapshot;
 	int ret;
@@ -1207,7 +1207,7 @@ int bch2_inum_opts_get(struct btree_trans *trans, subvol_inum inum, struct bch_i
 static noinline int __bch2_inode_rm_snapshot(struct btree_trans *trans, u64 inum, u32 snapshot)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct bkey_i_inode_generation delete;
 	struct bch_inode_unpacked inode_u;
 	struct bkey_s_c k;
diff --git a/fs/bcachefs/io_misc.c b/fs/bcachefs/io_misc.c
index 6b842c8d21be..cc07729a4b62 100644
--- a/fs/bcachefs/io_misc.c
+++ b/fs/bcachefs/io_misc.c
@@ -43,7 +43,7 @@ int bch2_extent_fallocate(struct btree_trans *trans,
 	bch2_bkey_buf_init(&new);
 	closure_init_stack(&cl);
 
-	k = bch2_btree_iter_peek_slot(iter);
+	k = bch2_btree_iter_peek_slot(trans, iter);
 	ret = bkey_err(k);
 	if (ret)
 		return ret;
@@ -164,12 +164,12 @@ int bch2_fpunch_at(struct btree_trans *trans, struct btree_iter *iter,
 		if (ret)
 			continue;
 
-		bch2_btree_iter_set_snapshot(iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, iter, snapshot);
 
 		/*
 		 * peek_max() doesn't have ideal semantics for extents:
 		 */
-		k = bch2_btree_iter_peek_max(iter, end_pos);
+		k = bch2_btree_iter_peek_max(trans, iter, end_pos);
 		if (!k.k)
 			break;
 
@@ -230,7 +230,7 @@ static int truncate_set_isize(struct btree_trans *trans,
 			      u64 new_i_size,
 			      bool warn)
 {
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct bch_inode_unpacked inode_u;
 	int ret;
 
@@ -399,7 +399,7 @@ case LOGGED_OP_FINSERT_start:
 		if (ret)
 			goto err;
 	} else {
-		bch2_btree_iter_set_pos(&iter, POS(inum.inum, src_offset));
+		bch2_btree_iter_set_pos(trans, &iter, POS(inum.inum, src_offset));
 
 		ret = bch2_fpunch_at(trans, &iter, inum, src_offset + len, i_sectors_delta);
 		if (ret && !bch2_err_matches(ret, BCH_ERR_transaction_restart))
@@ -425,12 +425,12 @@ case LOGGED_OP_FINSERT_shift_extents:
 		if (ret)
 			goto btree_err;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
-		bch2_btree_iter_set_pos(&iter, SPOS(inum.inum, pos, snapshot));
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
+		bch2_btree_iter_set_pos(trans, &iter, SPOS(inum.inum, pos, snapshot));
 
 		k = insert
-			? bch2_btree_iter_peek_prev_min(&iter, POS(inum.inum, 0))
-			: bch2_btree_iter_peek_max(&iter, POS(inum.inum, U64_MAX));
+			? bch2_btree_iter_peek_prev_min(trans, &iter, POS(inum.inum, 0))
+			: bch2_btree_iter_peek_max(trans, &iter, POS(inum.inum, U64_MAX));
 		if ((ret = bkey_err(k)))
 			goto btree_err;
 
diff --git a/fs/bcachefs/io_read.c b/fs/bcachefs/io_read.c
index 4fb279f12ae4..32e9df30ff23 100644
--- a/fs/bcachefs/io_read.c
+++ b/fs/bcachefs/io_read.c
@@ -908,7 +908,7 @@ static noinline void read_from_stale_dirty_pointer(struct btree_trans *trans,
 
 		prt_printf(&buf, "memory gen: %u", gen);
 
-		ret = lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_slot(&iter)));
+		ret = lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_slot(trans, &iter)));
 		if (!ret) {
 			prt_newline(&buf);
 			bch2_bkey_val_to_text(&buf, c, k);
@@ -1288,12 +1288,12 @@ int __bch2_read(struct btree_trans *trans, struct bch_read_bio *rbio,
 		if (ret)
 			goto err;
 
-		bch2_btree_iter_set_snapshot(&iter, snapshot);
+		bch2_btree_iter_set_snapshot(trans, &iter, snapshot);
 
-		bch2_btree_iter_set_pos(&iter,
+		bch2_btree_iter_set_pos(trans, &iter,
 				POS(inum.inum, bvec_iter.bi_sector));
 
-		k = bch2_btree_iter_peek_slot(&iter);
+		k = bch2_btree_iter_peek_slot(trans, &iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/io_write.c b/fs/bcachefs/io_write.c
index 29671075e3f1..4b72d3382abf 100644
--- a/fs/bcachefs/io_write.c
+++ b/fs/bcachefs/io_write.c
@@ -168,9 +168,9 @@ int bch2_sum_sector_overwrites(struct btree_trans *trans,
 	*i_sectors_delta	= 0;
 	*disk_sectors_delta	= 0;
 
-	bch2_trans_copy_iter(&iter, extent_iter);
+	bch2_trans_copy_iter(trans, &iter, extent_iter);
 
-	for_each_btree_key_max_continue_norestart(iter,
+	for_each_btree_key_max_continue_norestart(trans, iter,
 				new->k.p, BTREE_ITER_slots, old, ret) {
 		s64 sectors = min(new->k.p.offset, old.k->p.offset) -
 			max(bkey_start_offset(&new->k),
@@ -292,7 +292,7 @@ int bch2_extent_update(struct btree_trans *trans,
 	 * path already traversed at iter->pos because
 	 * bch2_trans_extent_update() will use it to attempt extent merging
 	 */
-	ret = __bch2_btree_iter_traverse(iter);
+	ret = __bch2_btree_iter_traverse(trans, iter);
 	if (ret)
 		return ret;
 
@@ -337,7 +337,7 @@ int bch2_extent_update(struct btree_trans *trans,
 
 	if (i_sectors_delta_total)
 		*i_sectors_delta_total += i_sectors_delta;
-	bch2_btree_iter_set_pos(iter, next_pos);
+	bch2_btree_iter_set_pos(trans, iter, next_pos);
 	return 0;
 }
 
@@ -1287,7 +1287,7 @@ static void bch2_nocow_write(struct bch_write_op *op)
 		if (ret)
 			break;
 
-		k = bch2_btree_iter_peek_slot(&iter);
+		k = bch2_btree_iter_peek_slot(trans, &iter);
 		ret = bkey_err(k);
 		if (ret)
 			break;
@@ -1371,7 +1371,7 @@ static void bch2_nocow_write(struct bch_write_op *op)
 		bch2_keylist_push(&op->insert_keys);
 		if (op->flags & BCH_WRITE_submitted)
 			break;
-		bch2_btree_iter_advance(&iter);
+		bch2_btree_iter_advance(trans, &iter);
 	}
 out:
 	bch2_trans_iter_exit(trans, &iter);
diff --git a/fs/bcachefs/migrate.c b/fs/bcachefs/migrate.c
index 57ad662871ba..90dcf80bd64a 100644
--- a/fs/bcachefs/migrate.c
+++ b/fs/bcachefs/migrate.c
@@ -130,7 +130,7 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 retry:
 		ret = 0;
 		while (bch2_trans_begin(trans),
-		       (b = bch2_btree_iter_peek_node(&iter)) &&
+		       (b = bch2_btree_iter_peek_node(trans, &iter)) &&
 		       !(ret = PTR_ERR_OR_ZERO(b))) {
 			bch2_progress_update_iter(trans, progress, &iter, "dropping metadata");
 
@@ -154,7 +154,7 @@ static int bch2_dev_metadata_drop(struct bch_fs *c,
 			if (ret)
 				break;
 next:
-			bch2_btree_iter_next_node(&iter);
+			bch2_btree_iter_next_node(trans, &iter);
 		}
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			goto retry;
diff --git a/fs/bcachefs/move.c b/fs/bcachefs/move.c
index 8fcdc6984f6e..409f76d9ef7f 100644
--- a/fs/bcachefs/move.c
+++ b/fs/bcachefs/move.c
@@ -572,7 +572,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 
 		bch2_trans_begin(trans);
 
-		k = bch2_btree_iter_peek(&iter);
+		k = bch2_btree_iter_peek(trans, &iter);
 		if (!k.k)
 			break;
 
@@ -652,7 +652,7 @@ static int bch2_move_data_btree(struct moving_context *ctxt,
 		if (ctxt->stats)
 			atomic64_add(k.k->size, &ctxt->stats->sectors_seen);
 next_nondata:
-		bch2_btree_iter_advance(&iter);
+		bch2_btree_iter_advance(trans, &iter);
 	}
 
 	bch2_trans_iter_exit(trans, &reflink_iter);
@@ -765,7 +765,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 
 		bch2_trans_begin(trans);
 
-		k = bch2_btree_iter_peek(&bp_iter);
+		k = bch2_btree_iter_peek(trans, &bp_iter);
 		ret = bkey_err(k);
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			continue;
@@ -847,7 +847,7 @@ static int __bch2_move_data_phys(struct moving_context *ctxt,
 		if (ctxt->stats)
 			atomic64_add(sectors, &ctxt->stats->sectors_seen);
 next:
-		bch2_btree_iter_advance(&bp_iter);
+		bch2_btree_iter_advance(trans, &bp_iter);
 	}
 err:
 	bch2_trans_iter_exit(trans, &bp_iter);
@@ -962,7 +962,7 @@ static int bch2_move_btree(struct bch_fs *c,
 retry:
 		ret = 0;
 		while (bch2_trans_begin(trans),
-		       (b = bch2_btree_iter_peek_node(&iter)) &&
+		       (b = bch2_btree_iter_peek_node(trans, &iter)) &&
 		       !(ret = PTR_ERR_OR_ZERO(b))) {
 			if (kthread && kthread_should_stop())
 				break;
@@ -982,7 +982,7 @@ static int bch2_move_btree(struct bch_fs *c,
 			if (ret)
 				break;
 next:
-			bch2_btree_iter_next_node(&iter);
+			bch2_btree_iter_next_node(trans, &iter);
 		}
 		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
 			goto retry;
diff --git a/fs/bcachefs/namei.c b/fs/bcachefs/namei.c
index 93246ad31541..d3e2f47ebafc 100644
--- a/fs/bcachefs/namei.c
+++ b/fs/bcachefs/namei.c
@@ -28,8 +28,8 @@ int bch2_create_trans(struct btree_trans *trans,
 		      unsigned flags)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter dir_iter = { NULL };
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter dir_iter = {};
+	struct btree_iter inode_iter = {};
 	subvol_inum new_inum = dir;
 	u64 now = bch2_current_time(c);
 	u64 cpu = raw_smp_processor_id();
@@ -127,8 +127,8 @@ int bch2_create_trans(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		bch2_btree_iter_set_snapshot(&dir_iter, dir_snapshot);
-		ret = bch2_btree_iter_traverse(&dir_iter);
+		bch2_btree_iter_set_snapshot(trans, &dir_iter, dir_snapshot);
+		ret = bch2_btree_iter_traverse(trans, &dir_iter);
 		if (ret)
 			goto err;
 	}
@@ -177,9 +177,9 @@ int bch2_create_trans(struct btree_trans *trans,
 		new_inode->bi_depth = dir_u->bi_depth + 1;
 
 	inode_iter.flags &= ~BTREE_ITER_all_snapshots;
-	bch2_btree_iter_set_snapshot(&inode_iter, snapshot);
+	bch2_btree_iter_set_snapshot(trans, &inode_iter, snapshot);
 
-	ret   = bch2_btree_iter_traverse(&inode_iter) ?:
+	ret   = bch2_btree_iter_traverse(trans, &inode_iter) ?:
 		bch2_inode_write(trans, &inode_iter, new_inode);
 err:
 	bch2_trans_iter_exit(trans, &inode_iter);
@@ -193,8 +193,8 @@ int bch2_link_trans(struct btree_trans *trans,
 		    const struct qstr *name)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter dir_iter = { NULL };
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter dir_iter = {};
+	struct btree_iter inode_iter = {};
 	struct bch_hash_info dir_hash;
 	u64 now = bch2_current_time(c);
 	u64 dir_offset = 0;
@@ -253,9 +253,9 @@ int bch2_unlink_trans(struct btree_trans *trans,
 		      bool deleting_subvol)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter dir_iter = { NULL };
-	struct btree_iter dirent_iter = { NULL };
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter dir_iter = {};
+	struct btree_iter dirent_iter = {};
+	struct btree_iter inode_iter = {};
 	struct bch_hash_info dir_hash;
 	subvol_inum inum;
 	u64 now = bch2_current_time(c);
@@ -301,7 +301,7 @@ int bch2_unlink_trans(struct btree_trans *trans,
 		if (ret)
 			goto err;
 
-		k = bch2_btree_iter_peek_slot(&dirent_iter);
+		k = bch2_btree_iter_peek_slot(trans, &dirent_iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
@@ -310,8 +310,8 @@ int bch2_unlink_trans(struct btree_trans *trans,
 		 * If we're deleting a subvolume, we need to really delete the
 		 * dirent, not just emit a whiteout in the current snapshot:
 		 */
-		bch2_btree_iter_set_snapshot(&dirent_iter, k.k->p.snapshot);
-		ret = bch2_btree_iter_traverse(&dirent_iter);
+		bch2_btree_iter_set_snapshot(trans, &dirent_iter, k.k->p.snapshot);
+		ret = bch2_btree_iter_traverse(trans, &dirent_iter);
 		if (ret)
 			goto err;
 	} else {
@@ -390,10 +390,10 @@ int bch2_rename_trans(struct btree_trans *trans,
 		      enum bch_rename_mode mode)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter src_dir_iter = { NULL };
-	struct btree_iter dst_dir_iter = { NULL };
-	struct btree_iter src_inode_iter = { NULL };
-	struct btree_iter dst_inode_iter = { NULL };
+	struct btree_iter src_dir_iter = {};
+	struct btree_iter dst_dir_iter = {};
+	struct btree_iter src_inode_iter = {};
+	struct btree_iter dst_inode_iter = {};
 	struct bch_hash_info src_hash, dst_hash;
 	subvol_inum src_inum, dst_inum;
 	u64 src_offset, dst_offset;
@@ -666,7 +666,7 @@ static int bch2_check_dirent_inode_dirent(struct btree_trans *trans,
 {
 	struct bch_fs *c = trans->c;
 	struct printbuf buf = PRINTBUF;
-	struct btree_iter bp_iter = { NULL };
+	struct btree_iter bp_iter = {};
 	int ret = 0;
 
 	if (inode_points_to_dirent(target, d))
diff --git a/fs/bcachefs/quota.c b/fs/bcachefs/quota.c
index 8b857fc33244..3d4755d73af7 100644
--- a/fs/bcachefs/quota.c
+++ b/fs/bcachefs/quota.c
@@ -516,7 +516,7 @@ static int bch2_fs_quota_read_inode(struct btree_trans *trans,
 	bch2_quota_acct(c, bch_qid(&u), Q_INO, 1,
 			KEY_TYPE_QUOTA_NOCHECK);
 advance:
-	bch2_btree_iter_set_pos(iter, bpos_nosnap_successor(iter->pos));
+	bch2_btree_iter_set_pos(trans, iter, bpos_nosnap_successor(iter->pos));
 	return 0;
 }
 
diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
index 29a569384146..f12084da71c5 100644
--- a/fs/bcachefs/rebalance.c
+++ b/fs/bcachefs/rebalance.c
@@ -233,7 +233,7 @@ int bch2_set_rebalance_needs_scan_trans(struct btree_trans *trans, u64 inum)
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_rebalance_work,
 			     SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
 			     BTREE_ITER_intent);
-	k = bch2_btree_iter_peek_slot(&iter);
+	k = bch2_btree_iter_peek_slot(trans, &iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -281,7 +281,7 @@ static int bch2_clear_rebalance_needs_scan(struct btree_trans *trans, u64 inum,
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_rebalance_work,
 			     SPOS(inum, REBALANCE_WORK_SCAN_OFFSET, U32_MAX),
 			     BTREE_ITER_intent);
-	k = bch2_btree_iter_peek_slot(&iter);
+	k = bch2_btree_iter_peek_slot(trans, &iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -301,7 +301,7 @@ static struct bkey_s_c next_rebalance_entry(struct btree_trans *trans,
 					    struct btree_iter *work_iter)
 {
 	return !kthread_should_stop()
-		? bch2_btree_iter_peek(work_iter)
+		? bch2_btree_iter_peek(trans, work_iter)
 		: bkey_s_c_null;
 }
 
@@ -335,7 +335,7 @@ static struct bkey_s_c next_rebalance_extent(struct btree_trans *trans,
 			     work_pos.inode ? BTREE_ID_extents : BTREE_ID_reflink,
 			     work_pos,
 			     BTREE_ITER_all_snapshots);
-	struct bkey_s_c k = bch2_btree_iter_peek_slot(extent_iter);
+	struct bkey_s_c k = bch2_btree_iter_peek_slot(trans, extent_iter);
 	if (bkey_err(k))
 		return k;
 
@@ -511,7 +511,7 @@ static int do_rebalance(struct moving_context *ctxt)
 	struct btree_trans *trans = ctxt->trans;
 	struct bch_fs *c = trans->c;
 	struct bch_fs_rebalance *r = &c->rebalance;
-	struct btree_iter rebalance_work_iter, extent_iter = { NULL };
+	struct btree_iter rebalance_work_iter, extent_iter = {};
 	struct bkey_s_c k;
 	int ret = 0;
 
@@ -552,7 +552,7 @@ static int do_rebalance(struct moving_context *ctxt)
 		if (ret)
 			break;
 
-		bch2_btree_iter_advance(&rebalance_work_iter);
+		bch2_btree_iter_advance(trans, &rebalance_work_iter);
 	}
 
 	bch2_trans_iter_exit(trans, &extent_iter);
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 266c5770c824..79fd18a5a07c 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -198,7 +198,7 @@ static int bch2_journal_replay_accounting_key(struct btree_trans *trans,
 	bch2_trans_node_iter_init(trans, &iter, k->btree_id, k->k->k.p,
 				  BTREE_MAX_DEPTH, k->level,
 				  BTREE_ITER_intent);
-	int ret = bch2_btree_iter_traverse(&iter);
+	int ret = bch2_btree_iter_traverse(trans, &iter);
 	if (ret)
 		goto out;
 
@@ -261,7 +261,7 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 	bch2_trans_node_iter_init(trans, &iter, k->btree_id, k->k->k.p,
 				  BTREE_MAX_DEPTH, k->level,
 				  iter_flags);
-	ret = bch2_btree_iter_traverse(&iter);
+	ret = bch2_btree_iter_traverse(trans, &iter);
 	if (ret)
 		goto out;
 
@@ -270,7 +270,7 @@ static int bch2_journal_replay_key(struct btree_trans *trans,
 		bch2_trans_iter_exit(trans, &iter);
 		bch2_trans_node_iter_init(trans, &iter, k->btree_id, k->k->k.p,
 					  BTREE_MAX_DEPTH, 0, iter_flags);
-		ret =   bch2_btree_iter_traverse(&iter) ?:
+		ret =   bch2_btree_iter_traverse(trans, &iter) ?:
 			bch2_btree_increase_depth(trans, iter.path, 0) ?:
 			-BCH_ERR_transaction_restart_nested;
 		goto out;
diff --git a/fs/bcachefs/reflink.c b/fs/bcachefs/reflink.c
index 68172c6eba21..dd80b106d0f7 100644
--- a/fs/bcachefs/reflink.c
+++ b/fs/bcachefs/reflink.c
@@ -495,7 +495,7 @@ static int bch2_make_extent_indirect(struct btree_trans *trans,
 				     bool reflink_p_may_update_opts_field)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter reflink_iter = { NULL };
+	struct btree_iter reflink_iter = {};
 	struct bkey_s_c k;
 	struct bkey_i *r_v;
 	struct bkey_i_reflink_p *r_p;
@@ -507,7 +507,7 @@ static int bch2_make_extent_indirect(struct btree_trans *trans,
 
 	bch2_trans_iter_init(trans, &reflink_iter, BTREE_ID_reflink, POS_MAX,
 			     BTREE_ITER_intent);
-	k = bch2_btree_iter_peek_prev(&reflink_iter);
+	k = bch2_btree_iter_peek_prev(trans, &reflink_iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
@@ -569,12 +569,13 @@ static int bch2_make_extent_indirect(struct btree_trans *trans,
 	return ret;
 }
 
-static struct bkey_s_c get_next_src(struct btree_iter *iter, struct bpos end)
+static struct bkey_s_c get_next_src(struct btree_trans *trans,
+				    struct btree_iter *iter, struct bpos end)
 {
 	struct bkey_s_c k;
 	int ret;
 
-	for_each_btree_key_max_continue_norestart(*iter, end, 0, k, ret) {
+	for_each_btree_key_max_continue_norestart(trans, *iter, end, 0, k, ret) {
 		if (bkey_extent_is_unwritten(k))
 			continue;
 
@@ -583,7 +584,7 @@ static struct bkey_s_c get_next_src(struct btree_iter *iter, struct bpos end)
 	}
 
 	if (bkey_ge(iter->pos, end))
-		bch2_btree_iter_set_pos(iter, end);
+		bch2_btree_iter_set_pos(trans, iter, end);
 	return ret ? bkey_s_c_err(ret) : bkey_s_c_null;
 }
 
@@ -647,27 +648,27 @@ s64 bch2_remap_range(struct bch_fs *c,
 		if (ret)
 			continue;
 
-		bch2_btree_iter_set_snapshot(&src_iter, src_snapshot);
+		bch2_btree_iter_set_snapshot(trans, &src_iter, src_snapshot);
 
 		ret = bch2_subvolume_get_snapshot(trans, dst_inum.subvol,
 						  &dst_snapshot);
 		if (ret)
 			continue;
 
-		bch2_btree_iter_set_snapshot(&dst_iter, dst_snapshot);
+		bch2_btree_iter_set_snapshot(trans, &dst_iter, dst_snapshot);
 
 		if (dst_inum.inum < src_inum.inum) {
 			/* Avoid some lock cycle transaction restarts */
-			ret = bch2_btree_iter_traverse(&dst_iter);
+			ret = bch2_btree_iter_traverse(trans, &dst_iter);
 			if (ret)
 				continue;
 		}
 
 		dst_done = dst_iter.pos.offset - dst_start.offset;
 		src_want = POS(src_start.inode, src_start.offset + dst_done);
-		bch2_btree_iter_set_pos(&src_iter, src_want);
+		bch2_btree_iter_set_pos(trans, &src_iter, src_want);
 
-		src_k = get_next_src(&src_iter, src_end);
+		src_k = get_next_src(trans, &src_iter, src_end);
 		ret = bkey_err(src_k);
 		if (ret)
 			continue;
@@ -738,7 +739,7 @@ s64 bch2_remap_range(struct bch_fs *c,
 
 	do {
 		struct bch_inode_unpacked inode_u;
-		struct btree_iter inode_iter = { NULL };
+		struct btree_iter inode_iter = {};
 
 		bch2_trans_begin(trans);
 
diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index e7f197896db1..d7427a35cddf 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1074,9 +1074,9 @@ static inline void normalize_snapshot_child_pointers(struct bch_snapshot *s)
 static int bch2_snapshot_node_delete(struct btree_trans *trans, u32 id)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter, p_iter = (struct btree_iter) { NULL };
-	struct btree_iter c_iter = (struct btree_iter) { NULL };
-	struct btree_iter tree_iter = (struct btree_iter) { NULL };
+	struct btree_iter iter, p_iter = {};
+	struct btree_iter c_iter = {};
+	struct btree_iter tree_iter = {};
 	struct bkey_s_c_snapshot s;
 	u32 parent_id, child_id;
 	unsigned i;
@@ -1193,13 +1193,13 @@ static int create_snapids(struct btree_trans *trans, u32 parent, u32 tree,
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_snapshots,
 			     POS_MIN, BTREE_ITER_intent);
-	k = bch2_btree_iter_peek(&iter);
+	k = bch2_btree_iter_peek(trans, &iter);
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
 
 	for (i = 0; i < nr_snapids; i++) {
-		k = bch2_btree_iter_prev_slot(&iter);
+		k = bch2_btree_iter_prev_slot(trans, &iter);
 		ret = bkey_err(k);
 		if (ret)
 			goto err;
diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
index 93e71119e5a4..996dca5e0880 100644
--- a/fs/bcachefs/str_hash.c
+++ b/fs/bcachefs/str_hash.c
@@ -195,7 +195,7 @@ int __bch2_str_hash_check_key(struct btree_trans *trans,
 			      struct btree_iter *k_iter, struct bkey_s_c hash_k)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter iter = { NULL };
+	struct btree_iter iter = {};
 	struct printbuf buf = PRINTBUF;
 	struct bkey_s_c k;
 	int ret = 0;
diff --git a/fs/bcachefs/str_hash.h b/fs/bcachefs/str_hash.h
index 575ad1e03904..09a354a26c3b 100644
--- a/fs/bcachefs/str_hash.h
+++ b/fs/bcachefs/str_hash.h
@@ -231,11 +231,11 @@ int bch2_hash_needs_whiteout(struct btree_trans *trans,
 	struct bkey_s_c k;
 	int ret;
 
-	bch2_trans_copy_iter(&iter, start);
+	bch2_trans_copy_iter(trans, &iter, start);
 
-	bch2_btree_iter_advance(&iter);
+	bch2_btree_iter_advance(trans, &iter);
 
-	for_each_btree_key_continue_norestart(iter, BTREE_ITER_slots, k, ret) {
+	for_each_btree_key_continue_norestart(trans, iter, BTREE_ITER_slots, k, ret) {
 		if (k.k->type != desc.key_type &&
 		    k.k->type != KEY_TYPE_hash_whiteout)
 			break;
@@ -280,7 +280,7 @@ struct bkey_s_c bch2_hash_set_or_get_in_snapshot(struct btree_trans *trans,
 		}
 
 		if (!slot.path && !(flags & STR_HASH_must_replace))
-			bch2_trans_copy_iter(&slot, iter);
+			bch2_trans_copy_iter(trans, &slot, iter);
 
 		if (k.k->type != KEY_TYPE_hash_whiteout)
 			goto not_found;
diff --git a/fs/bcachefs/subvolume.c b/fs/bcachefs/subvolume.c
index b7b96283c316..34bc646a3099 100644
--- a/fs/bcachefs/subvolume.c
+++ b/fs/bcachefs/subvolume.c
@@ -275,7 +275,7 @@ int bch2_subvol_has_children(struct btree_trans *trans, u32 subvol)
 	struct btree_iter iter;
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_subvolume_children, POS(subvol, 0), 0);
-	struct bkey_s_c k = bch2_btree_iter_peek(&iter);
+	struct bkey_s_c k = bch2_btree_iter_peek(trans, &iter);
 	bch2_trans_iter_exit(trans, &iter);
 
 	return bkey_err(k) ?: k.k && k.k->p.inode == subvol
@@ -573,7 +573,7 @@ int bch2_subvolume_create(struct btree_trans *trans, u64 inode,
 			  bool ro)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter dst_iter, src_iter = (struct btree_iter) { NULL };
+	struct btree_iter dst_iter, src_iter = {};
 	struct bkey_i_subvolume *new_subvol = NULL;
 	struct bkey_i_subvolume *src_subvol = NULL;
 	u32 parent = 0, new_nodes[2], snapshot_subvols[2];
diff --git a/fs/bcachefs/subvolume.h b/fs/bcachefs/subvolume.h
index 910f6196700e..f640c1e3d639 100644
--- a/fs/bcachefs/subvolume.h
+++ b/fs/bcachefs/subvolume.h
@@ -33,16 +33,16 @@ int bch2_subvol_is_ro_trans(struct btree_trans *, u32);
 int bch2_subvol_is_ro(struct bch_fs *, u32);
 
 static inline struct bkey_s_c
-bch2_btree_iter_peek_in_subvolume_max_type(struct btree_iter *iter, struct bpos end,
-					    u32 subvolid, unsigned flags)
+bch2_btree_iter_peek_in_subvolume_max_type(struct btree_trans *trans, struct btree_iter *iter,
+					   struct bpos end, u32 subvolid, unsigned flags)
 {
 	u32 snapshot;
-	int ret = bch2_subvolume_get_snapshot(iter->trans, subvolid, &snapshot);
+	int ret = bch2_subvolume_get_snapshot(trans, subvolid, &snapshot);
 	if (ret)
 		return bkey_s_c_err(ret);
 
-	bch2_btree_iter_set_snapshot(iter, snapshot);
-	return bch2_btree_iter_peek_max_type(iter, end, flags);
+	bch2_btree_iter_set_snapshot(trans, iter, snapshot);
+	return bch2_btree_iter_peek_max_type(trans, iter, end, flags);
 }
 
 #define for_each_btree_key_in_subvolume_max_continue(_trans, _iter,		\
@@ -53,14 +53,14 @@ bch2_btree_iter_peek_in_subvolume_max_type(struct btree_iter *iter, struct bpos
 										\
 	do {									\
 		_ret3 = lockrestart_do(_trans, ({				\
-			(_k) = bch2_btree_iter_peek_in_subvolume_max_type(&(_iter),	\
+			(_k) = bch2_btree_iter_peek_in_subvolume_max_type(trans, &(_iter),\
 						_end, _subvolid, (_flags));	\
 			if (!(_k).k)						\
 				break;						\
 										\
 			bkey_err(_k) ?: (_do);					\
 		}));								\
-	} while (!_ret3 && bch2_btree_iter_advance(&(_iter)));			\
+	} while (!_ret3 && bch2_btree_iter_advance(_trans, &(_iter)));		\
 										\
 	bch2_trans_iter_exit((_trans), &(_iter));				\
 	_ret3;									\
diff --git a/fs/bcachefs/tests.c b/fs/bcachefs/tests.c
index 6c6469814637..c265b102267a 100644
--- a/fs/bcachefs/tests.c
+++ b/fs/bcachefs/tests.c
@@ -43,7 +43,7 @@ static int test_delete(struct bch_fs *c, u64 nr)
 			     BTREE_ITER_intent);
 
 	ret = commit_do(trans, NULL, NULL, 0,
-		bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_trans_update(trans, &iter, &k.k_i, 0));
 	bch_err_msg(c, ret, "update error");
 	if (ret)
@@ -51,7 +51,7 @@ static int test_delete(struct bch_fs *c, u64 nr)
 
 	pr_info("deleting once");
 	ret = commit_do(trans, NULL, NULL, 0,
-		bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_btree_delete_at(trans, &iter, 0));
 	bch_err_msg(c, ret, "delete error (first)");
 	if (ret)
@@ -59,7 +59,7 @@ static int test_delete(struct bch_fs *c, u64 nr)
 
 	pr_info("deleting twice");
 	ret = commit_do(trans, NULL, NULL, 0,
-		bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_btree_delete_at(trans, &iter, 0));
 	bch_err_msg(c, ret, "delete error (second)");
 	if (ret)
@@ -84,7 +84,7 @@ static int test_delete_written(struct bch_fs *c, u64 nr)
 			     BTREE_ITER_intent);
 
 	ret = commit_do(trans, NULL, NULL, 0,
-		bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_trans_update(trans, &iter, &k.k_i, 0));
 	bch_err_msg(c, ret, "update error");
 	if (ret)
@@ -94,7 +94,7 @@ static int test_delete_written(struct bch_fs *c, u64 nr)
 	bch2_journal_flush_all_pins(&c->journal);
 
 	ret = commit_do(trans, NULL, NULL, 0,
-		bch2_btree_iter_traverse(&iter) ?:
+		bch2_btree_iter_traverse(trans, &iter) ?:
 		bch2_btree_delete_at(trans, &iter, 0));
 	bch_err_msg(c, ret, "delete error");
 	if (ret)
@@ -349,10 +349,10 @@ static int test_peek_end(struct bch_fs *c, u64 nr)
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs,
 			     SPOS(0, 0, U32_MAX), 0);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
 	bch2_trans_iter_exit(trans, &iter);
@@ -369,10 +369,10 @@ static int test_peek_end_extents(struct bch_fs *c, u64 nr)
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_extents,
 			     SPOS(0, 0, U32_MAX), 0);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX))));
 	BUG_ON(k.k);
 
 	bch2_trans_iter_exit(trans, &iter);
@@ -488,7 +488,7 @@ static int test_snapshot_filter(struct bch_fs *c, u32 snapid_lo, u32 snapid_hi)
 	trans = bch2_trans_get(c);
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs,
 			     SPOS(0, 0, snapid_lo), 0);
-	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX))));
+	lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX))));
 
 	BUG_ON(k.k->p.snapshot != U32_MAX);
 
@@ -602,9 +602,9 @@ static int rand_lookup(struct bch_fs *c, u64 nr)
 			     SPOS(0, 0, U32_MAX), 0);
 
 	for (i = 0; i < nr; i++) {
-		bch2_btree_iter_set_pos(&iter, SPOS(0, test_rand(), U32_MAX));
+		bch2_btree_iter_set_pos(trans, &iter, SPOS(0, test_rand(), U32_MAX));
 
-		lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek(&iter)));
+		lockrestart_do(trans, bkey_err(k = bch2_btree_iter_peek(trans, &iter)));
 		ret = bkey_err(k);
 		if (ret)
 			break;
@@ -623,9 +623,9 @@ static int rand_mixed_trans(struct btree_trans *trans,
 	struct bkey_s_c k;
 	int ret;
 
-	bch2_btree_iter_set_pos(iter, SPOS(0, pos, U32_MAX));
+	bch2_btree_iter_set_pos(trans, iter, SPOS(0, pos, U32_MAX));
 
-	k = bch2_btree_iter_peek(iter);
+	k = bch2_btree_iter_peek(trans, iter);
 	ret = bkey_err(k);
 	bch_err_msg(trans->c, ret, "lookup error");
 	if (ret)
@@ -672,7 +672,7 @@ static int __do_delete(struct btree_trans *trans, struct bpos pos)
 
 	bch2_trans_iter_init(trans, &iter, BTREE_ID_xattrs, pos,
 			     BTREE_ITER_intent);
-	k = bch2_btree_iter_peek_max(&iter, POS(0, U64_MAX));
+	k = bch2_btree_iter_peek_max(trans, &iter, POS(0, U64_MAX));
 	ret = bkey_err(k);
 	if (ret)
 		goto err;
diff --git a/fs/bcachefs/xattr.c b/fs/bcachefs/xattr.c
index f9667b944c0d..651da52b2cbc 100644
--- a/fs/bcachefs/xattr.c
+++ b/fs/bcachefs/xattr.c
@@ -168,7 +168,7 @@ int bch2_xattr_set(struct btree_trans *trans, subvol_inum inum,
 		   int type, int flags)
 {
 	struct bch_fs *c = trans->c;
-	struct btree_iter inode_iter = { NULL };
+	struct btree_iter inode_iter = {};
 	int ret;
 
 	ret   = bch2_subvol_is_ro_trans(trans, inum.subvol) ?:
-- 
2.49.0

