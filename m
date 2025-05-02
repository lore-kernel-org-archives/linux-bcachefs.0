Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB16D20C026
	for <linux-bcachefs@vger.kernel.org>; Fri,  2 May 2025 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746216021; cv=none; b=BuAGm7aPI4NNnuiFGpSSp4MCMkdcu9cGnLaG+lKs1AGHWknpOCsbxbgQxvA0YafFTNdHAmF73hw2kDsaaHB2LI5JBBeLb3+/R8smGhDlz9BgLHcobN1ib/7KMfbZq4nskRBFdOvY2V2JTQdzbHV5y+ZxManYwGy8vECVJWltcTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746216021; c=relaxed/simple;
	bh=olfLATCqt7MYlXIiSukI3idO0XtyHFLFR+HrqBPxAOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8PFhw0fy4BWcazGrV5NDr7fqfL6tPoLguxN5xSSCmr0eoGnRAwPh6HiLhJKZgW3KHTqDF/gnITFEVWRtig8K/P5EOGnQP1Hs5Zl+q2PjKDUNtvINmS6hoii+Zy6LQo0Oas25ly6wdIvPrr3ERMPxXn9P1U+XEDAAxVsnlYJ410=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n53WbPyX; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n53WbPyX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746216015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Icd2jt5qAGvJ0P+TDlSTRon6g9asG4XriI8ehob+oLU=;
	b=n53WbPyXqYfS7huHyfTbwHRzsquUPdee7TXk/TUeZGIyqj6zJkLtBXzeOoTte9mb1WyvCR
	15CJUoMDJFx340f80+4TAKXdGwbTNIMFmmQiQbCwWO9gv4VfbaOP32CAn2+bKvHq3ZrJBN
	oox1PAzJhbkMnoiMoxd4jcSFxvO0GCY=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 8/8] bcachefs: delete_dead_snapshot_keys_v2()
Date: Fri,  2 May 2025 16:00:00 -0400
Message-ID: <20250502200002.1309862-9-kent.overstreet@linux.dev>
In-Reply-To: <20250502200002.1309862-1-kent.overstreet@linux.dev>
References: <20250502200002.1309862-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Since extents, dirents and xattrs require an inode with the
corresponding snapshot ID to exists, we can avoid a lot of scanning by
only scanning those trees for keys to process if the correspending inode
exists.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/snapshot.c | 160 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 133 insertions(+), 27 deletions(-)

diff --git a/fs/bcachefs/snapshot.c b/fs/bcachefs/snapshot.c
index f074b9de5024..83b95269d38d 100644
--- a/fs/bcachefs/snapshot.c
+++ b/fs/bcachefs/snapshot.c
@@ -1427,6 +1427,12 @@ static unsigned live_child(struct bch_fs *c, u32 id)
 	return ret;
 }
 
+static bool snapshot_id_dying(struct snapshot_delete *d, unsigned id)
+{
+	return snapshot_list_has_id(&d->delete_leaves, id) ||
+		interior_delete_has_id(&d->delete_interior, id) != 0;
+}
+
 static int delete_dead_snapshots_process_key(struct btree_trans *trans,
 					     struct btree_iter *iter,
 					     struct bkey_s_c k)
@@ -1486,6 +1492,126 @@ static bool skip_unrelated_snapshot_tree(struct btree_trans *trans, struct btree
 	return ret;
 }
 
+static int delete_dead_snapshot_keys_v1(struct btree_trans *trans)
+{
+	struct bch_fs *c = trans->c;
+	struct snapshot_delete *d = &c->snapshot_delete;
+
+	for (d->pos.btree = 0; d->pos.btree < BTREE_ID_NR; d->pos.btree++) {
+		struct disk_reservation res = { 0 };
+
+		d->pos.pos = POS_MIN;
+
+		if (!btree_type_has_snapshots(d->pos.btree))
+			continue;
+
+		int ret = for_each_btree_key_commit(trans, iter,
+				d->pos.btree, POS_MIN,
+				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
+				&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+			d->pos.pos = iter.pos;
+
+			if (skip_unrelated_snapshot_tree(trans, &iter))
+				continue;
+
+			delete_dead_snapshots_process_key(trans, &iter, k);
+		}));
+
+		bch2_disk_reservation_put(c, &res);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int delete_dead_snapshot_keys_range(struct btree_trans *trans, enum btree_id btree,
+					   struct bpos start, struct bpos end)
+{
+	struct bch_fs *c = trans->c;
+	struct snapshot_delete *d = &c->snapshot_delete;
+	struct disk_reservation res = { 0 };
+
+	d->pos.btree	= btree;
+	d->pos.pos	= POS_MIN;
+
+	int ret = for_each_btree_key_max_commit(trans, iter,
+			btree, start, end,
+			BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
+			&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+		d->pos.pos = iter.pos;
+		delete_dead_snapshots_process_key(trans, &iter, k);
+	}));
+
+	bch2_disk_reservation_put(c, &res);
+	return ret;
+}
+
+static int delete_dead_snapshot_keys_v2(struct btree_trans *trans)
+{
+	struct bch_fs *c = trans->c;
+	struct snapshot_delete *d = &c->snapshot_delete;
+	struct disk_reservation res = { 0 };
+	int ret = 0;
+
+	struct btree_iter iter;
+	bch2_trans_iter_init(trans, &iter, BTREE_ID_inodes, POS_MIN,
+			     BTREE_ITER_prefetch|BTREE_ITER_all_snapshots);
+
+	while (1) {
+		struct bkey_s_c k;
+		ret = lockrestart_do(trans,
+				bkey_err(k = bch2_btree_iter_peek(trans, &iter)));
+		if (ret)
+			break;
+
+		if (!k.k)
+			break;
+
+		d->pos.btree	= iter.btree_id;
+		d->pos.pos	= iter.pos;
+
+		if (skip_unrelated_snapshot_tree(trans, &iter))
+			continue;
+
+		if (snapshot_id_dying(d, k.k->p.snapshot)) {
+			struct bpos start	= POS(k.k->p.offset, 0);
+			struct bpos end		= POS(k.k->p.offset, U64_MAX);
+
+			ret   = delete_dead_snapshot_keys_range(trans, BTREE_ID_extents, start, end) ?:
+				delete_dead_snapshot_keys_range(trans, BTREE_ID_dirents, start, end) ?:
+				delete_dead_snapshot_keys_range(trans, BTREE_ID_xattrs, start, end);
+			if (ret)
+				break;
+
+			bch2_btree_iter_set_pos(trans, &iter, POS(0, k.k->p.offset + 1));
+		} else {
+			bch2_btree_iter_advance(trans, &iter);
+		}
+	}
+	bch2_trans_iter_exit(trans, &iter);
+
+	if (ret)
+		goto err;
+
+	ret = for_each_btree_key_commit(trans, iter,
+			BTREE_ID_inodes, POS_MIN,
+			BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
+			&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
+		d->pos.btree	= iter.btree_id;
+		d->pos.pos	= iter.pos;
+
+		if (skip_unrelated_snapshot_tree(trans, &iter))
+			continue;
+
+		delete_dead_snapshots_process_key(trans, &iter, k);
+	}));
+err:
+	bch2_disk_reservation_put(c, &res);
+	return ret;
+}
+
 /*
  * For a given snapshot, if it doesn't have a subvolume that points to it, and
  * it doesn't have child snapshot nodes - it's now redundant and we can mark it
@@ -1666,33 +1792,13 @@ int bch2_delete_dead_snapshots(struct bch_fs *c)
 			goto err;
 	}
 
-	for (d->pos.btree = 0; d->pos.btree < BTREE_ID_NR; d->pos.btree++) {
-		struct disk_reservation res = { 0 };
-
-		d->pos.pos = POS_MIN;
-
-		if (!btree_type_has_snapshots(d->pos.btree))
-			continue;
-
-		ret = for_each_btree_key_commit(trans, iter,
-				d->pos.btree, POS_MIN,
-				BTREE_ITER_prefetch|BTREE_ITER_all_snapshots, k,
-				&res, NULL, BCH_TRANS_COMMIT_no_enospc, ({
-			d->pos.pos = iter.pos;
-
-			if (skip_unrelated_snapshot_tree(trans, &iter))
-				continue;
-
-			delete_dead_snapshots_process_key(trans, &iter, k);
-		}));
-
-		bch2_disk_reservation_put(c, &res);
-
-		if (!bch2_err_matches(ret, EROFS))
-			bch_err_msg(c, ret, "deleting keys from dying snapshots");
-		if (ret)
-			goto err;
-	}
+	ret = !bch2_request_incompat_feature(c, bcachefs_metadata_version_snapshot_deletion_v2)
+		? delete_dead_snapshot_keys_v2(trans)
+		: delete_dead_snapshot_keys_v1(trans);
+	if (!bch2_err_matches(ret, EROFS))
+		bch_err_msg(c, ret, "deleting keys from dying snapshots");
+	if (ret)
+		goto err;
 
 	darray_for_each(d->delete_leaves, i) {
 		ret = commit_do(trans, NULL, NULL, 0,
-- 
2.49.0

