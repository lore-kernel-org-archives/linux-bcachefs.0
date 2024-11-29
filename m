Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D3E1A38E1
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912101; cv=none; b=lCxlK9IsC3cCh0Y9NT6emuyMYMMt1mQCp9NJvY2D9BLrVbInG7XCLWLDRQyjPzeYGzAZGMlHXo2FCezQJouSsJ+Zxb4wxq/DwxUzQFRt2omF7MRtfifwOL0ofFSzX/j/BesbKbs18sEjtgVtnsgxi6de2N3NXL2tp3R+XDiwozA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912101; c=relaxed/simple;
	bh=mwTkr6+M1UuSEnIeI8wUH069Y1gZd7S3uLtVXRvxvE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pNXZT/XGYvFFlvNDF1g6ygDm2uYYXZQXiDUlcZzsb5F4VenqaJ4PaSVGI7vVSl7s2iuyPFQ5CvLMHaB+BFTVkm6vqFcQW/fJxSv4BHwTMgSQ+yLUZns6djSJLK8zeORMrm3og0mmAsTZld+wp2z9lR8sOV197vu5ZiZ6piXgseE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 34/34] bcachefs: Don't recurse in check_discard_freespace_key
Date: Fri, 29 Nov 2024 15:27:33 -0500
Message-ID: <20241129202736.2713679-35-kent.overstreet@linux.dev>
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

When calling check_discard_freeespace_key from the allocator, we can't
repair without recursing - run it asynchronously instead.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c | 72 ++++++++++++++++++++++++++++++----
 fs/bcachefs/alloc_background.h |  2 +-
 fs/bcachefs/alloc_foreground.c |  2 +-
 fs/bcachefs/bcachefs.h         |  1 +
 4 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index e8c246e5803c..b2d570453351 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1338,7 +1338,40 @@ int bch2_check_alloc_hole_bucket_gens(struct btree_trans *trans,
 	return ret;
 }
 
-int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_iter *iter, u8 *gen)
+struct check_discard_freespace_key_async {
+	struct work_struct	work;
+	struct bch_fs		*c;
+	struct bbpos		pos;
+};
+
+static int bch2_recheck_discard_freespace_key(struct btree_trans *trans, struct bbpos pos)
+{
+	struct btree_iter iter;
+	struct bkey_s_c k = bch2_bkey_get_iter(trans, &iter, pos.btree, pos.pos, 0);
+	int ret = bkey_err(k);
+	if (ret)
+		return ret;
+
+	u8 gen;
+	ret = k.k->type != KEY_TYPE_set
+		? bch2_check_discard_freespace_key(trans, &iter, &gen, false)
+		: 0;
+	bch2_trans_iter_exit(trans, &iter);
+	return ret;
+}
+
+static void check_discard_freespace_key_work(struct work_struct *work)
+{
+	struct check_discard_freespace_key_async *w =
+		container_of(work, struct check_discard_freespace_key_async, work);
+
+	bch2_trans_do(w->c, bch2_recheck_discard_freespace_key(trans, w->pos));
+	bch2_write_ref_put(w->c, BCH_WRITE_REF_check_discard_freespace_key);
+	kfree(w);
+}
+
+int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_iter *iter, u8 *gen,
+				     bool async_repair)
 {
 	struct bch_fs *c = trans->c;
 	enum bch_data_type state = iter->btree_id == BTREE_ID_need_discard
@@ -1351,7 +1384,8 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 	u64 genbits = iter->pos.offset & (~0ULL << 56);
 
 	struct btree_iter alloc_iter;
-	struct bkey_s_c alloc_k = bch2_bkey_get_iter(trans, &alloc_iter, BTREE_ID_alloc, bucket, BTREE_ITER_cached);
+	struct bkey_s_c alloc_k = bch2_bkey_get_iter(trans, &alloc_iter,
+						     BTREE_ID_alloc, bucket, BTREE_ITER_cached);
 	int ret = bkey_err(alloc_k);
 	if (ret)
 		return ret;
@@ -1392,17 +1426,39 @@ int bch2_check_discard_freespace_key(struct btree_trans *trans, struct btree_ite
 	printbuf_exit(&buf);
 	return ret;
 delete:
-	ret =   bch2_btree_bit_mod_iter(trans, iter, false) ?:
-		bch2_trans_commit(trans, NULL, NULL,
-			BCH_TRANS_COMMIT_no_enospc) ?:
-		-BCH_ERR_transaction_restart_commit;
-	goto out;
+	if (!async_repair) {
+		ret =   bch2_btree_bit_mod_iter(trans, iter, false) ?:
+			bch2_trans_commit(trans, NULL, NULL,
+				BCH_TRANS_COMMIT_no_enospc) ?:
+			-BCH_ERR_transaction_restart_commit;
+		goto out;
+	} else {
+		/*
+		 * We can't repair here when called from the allocator path: the
+		 * commit will recurse back into the allocator
+		 */
+		struct check_discard_freespace_key_async *w =
+			kzalloc(sizeof(*w), GFP_KERNEL);
+		if (!w)
+			goto out;
+
+		if (!bch2_write_ref_tryget(c, BCH_WRITE_REF_check_discard_freespace_key)) {
+			kfree(w);
+			goto out;
+		}
+
+		INIT_WORK(&w->work, check_discard_freespace_key_work);
+		w->c = c;
+		w->pos = BBPOS(iter->btree_id, iter->pos);
+		queue_work(c->write_ref_wq, &w->work);
+		goto out;
+	}
 }
 
 static int bch2_check_discard_freespace_key_fsck(struct btree_trans *trans, struct btree_iter *iter)
 {
 	u8 gen;
-	int ret = bch2_check_discard_freespace_key(trans, iter, &gen);
+	int ret = bch2_check_discard_freespace_key(trans, iter, &gen, false);
 	return ret < 0 ? ret : 0;
 }
 
diff --git a/fs/bcachefs/alloc_background.h b/fs/bcachefs/alloc_background.h
index 8cacddd188f4..de25ba4ee94b 100644
--- a/fs/bcachefs/alloc_background.h
+++ b/fs/bcachefs/alloc_background.h
@@ -310,7 +310,7 @@ int bch2_trigger_alloc(struct btree_trans *, enum btree_id, unsigned,
 		       struct bkey_s_c, struct bkey_s,
 		       enum btree_iter_update_trigger_flags);
 
-int bch2_check_discard_freespace_key(struct btree_trans *, struct btree_iter *, u8 *);
+int bch2_check_discard_freespace_key(struct btree_trans *, struct btree_iter *, u8 *, bool);
 int bch2_check_alloc_info(struct bch_fs *);
 int bch2_check_alloc_to_lru_refs(struct bch_fs *);
 void bch2_dev_do_discards(struct bch_dev *);
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 4d1ff7f1f302..c40a76df76b8 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -281,7 +281,7 @@ static struct open_bucket *try_alloc_bucket(struct btree_trans *trans, struct bc
 	u64 b = freespace_iter->pos.offset & ~(~0ULL << 56);
 	u8 gen;
 
-	int ret = bch2_check_discard_freespace_key(trans, freespace_iter, &gen);
+	int ret = bch2_check_discard_freespace_key(trans, freespace_iter, &gen, true);
 	if (ret < 0)
 		return ERR_PTR(ret);
 	if (ret)
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index d88129503bc5..c16937e54734 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -680,6 +680,7 @@ struct btree_trans_buf {
 	x(dio_write)							\
 	x(discard)							\
 	x(discard_fast)							\
+	x(check_discard_freespace_key)					\
 	x(invalidate)							\
 	x(delete_dead_snapshots)					\
 	x(gc_gens)							\
-- 
2.45.2

