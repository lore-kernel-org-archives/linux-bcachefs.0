Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9CA14D428
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912074; cv=none; b=FC3P0Xp0+3/E0+2G88YzPqqHRdCpL4YLlQOTzxWY8bFBaObIjnUVMzo9spagLPKH3MoC+UHfFlqiCF+2f+yql4wM8OhOoOVa3Nrkko9fOGwut68Ew+ZcNzjBD2JYo3oFj9YqTCu50Y3RBlrt1/m4l8a6Lx+VxCrRPMZZb7x8SNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912074; c=relaxed/simple;
	bh=+fcP3F6XXDA2XDygEELwDB+twnUnrlbVgY27a99ujhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUjn8rugBhMzCln/E6zmR/MX+sl0EURM9/hP8ao22GzkDe7dalMMP7QRowPHImdu2ZKcOGUAavYtxF4lsFsWd3bTvAqSxiywHN1SLQ/lBhV7tOtLT8EJ5+DOpPwlLDMkBRuCCzDDRlt/7F7X5s3T9hglj6sMEeLg0YPNdbKefrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	syzbot+592425844580a6598410@syzkaller.appspotmail.com
Subject: [PATCH 08/34] bcachefs: Kill bch2_bucket_alloc_new_fs()
Date: Fri, 29 Nov 2024 15:27:07 -0500
Message-ID: <20241129202736.2713679-9-kent.overstreet@linux.dev>
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

The early-early allocation path, bch2_bucket_alloc_new_fs(), is no
longer needed - and inconsistencies around new_fs_bucket_idx have been a
frequent source of bugs.

Reported-by: syzbot+592425844580a6598410@syzkaller.appspotmail.com
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_foreground.c | 40 ++++++++++++++--------------------
 fs/bcachefs/alloc_foreground.h |  2 --
 fs/bcachefs/bcachefs.h         |  1 -
 fs/bcachefs/buckets.c          | 25 +++++++++++++++++++++
 fs/bcachefs/buckets.h          | 21 +-----------------
 fs/bcachefs/journal.c          | 34 +++++++++++++----------------
 fs/bcachefs/journal_reclaim.c  |  3 +++
 fs/bcachefs/recovery.c         |  5 +----
 fs/bcachefs/super.c            | 12 +++++-----
 9 files changed, 66 insertions(+), 77 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 6d665b720f72..4d1ff7f1f302 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -156,6 +156,14 @@ static struct open_bucket *bch2_open_bucket_alloc(struct bch_fs *c)
 	return ob;
 }
 
+static inline bool is_superblock_bucket(struct bch_fs *c, struct bch_dev *ca, u64 b)
+{
+	if (c->curr_recovery_pass > BCH_RECOVERY_PASS_trans_mark_dev_sbs)
+		return false;
+
+	return bch2_is_superblock_bucket(ca, b);
+}
+
 static void open_bucket_free_unused(struct bch_fs *c, struct open_bucket *ob)
 {
 	BUG_ON(c->open_buckets_partial_nr >=
@@ -175,20 +183,6 @@ static void open_bucket_free_unused(struct bch_fs *c, struct open_bucket *ob)
 	closure_wake_up(&c->freelist_wait);
 }
 
-/* _only_ for allocating the journal on a new device: */
-long bch2_bucket_alloc_new_fs(struct bch_dev *ca)
-{
-	while (ca->new_fs_bucket_idx < ca->mi.nbuckets) {
-		u64 b = ca->new_fs_bucket_idx++;
-
-		if (!is_superblock_bucket(ca, b) &&
-		    (!ca->buckets_nouse || !test_bit(b, ca->buckets_nouse)))
-			return b;
-	}
-
-	return -1;
-}
-
 static inline unsigned open_buckets_reserved(enum bch_watermark watermark)
 {
 	switch (watermark) {
@@ -214,6 +208,9 @@ static struct open_bucket *__try_alloc_bucket(struct bch_fs *c, struct bch_dev *
 {
 	struct open_bucket *ob;
 
+	if (unlikely(is_superblock_bucket(c, ca, bucket)))
+		return NULL;
+
 	if (unlikely(ca->buckets_nouse && test_bit(bucket, ca->buckets_nouse))) {
 		s->skipped_nouse++;
 		return NULL;
@@ -295,9 +292,6 @@ static struct open_bucket *try_alloc_bucket(struct btree_trans *trans, struct bc
 
 /*
  * This path is for before the freespace btree is initialized:
- *
- * If ca->new_fs_bucket_idx is nonzero, we haven't yet marked superblock &
- * journal buckets - journal buckets will be < ca->new_fs_bucket_idx
  */
 static noinline struct open_bucket *
 bch2_bucket_alloc_early(struct btree_trans *trans,
@@ -309,7 +303,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	struct btree_iter iter, citer;
 	struct bkey_s_c k, ck;
 	struct open_bucket *ob = NULL;
-	u64 first_bucket = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
+	u64 first_bucket = ca->mi.first_bucket;
 	u64 *dev_alloc_cursor = &ca->alloc_cursor[s->btree_bitmap];
 	u64 alloc_start = max(first_bucket, *dev_alloc_cursor);
 	u64 alloc_cursor = alloc_start;
@@ -332,10 +326,6 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 		if (bkey_ge(k.k->p, POS(ca->dev_idx, ca->mi.nbuckets)))
 			break;
 
-		if (ca->new_fs_bucket_idx &&
-		    is_superblock_bucket(ca, k.k->p.offset))
-			continue;
-
 		if (s->btree_bitmap != BTREE_BITMAP_ANY &&
 		    s->btree_bitmap != bch2_dev_btree_bitmap_marked_sectors(ca,
 				bucket_to_sector(ca, bucket), ca->mi.bucket_size)) {
@@ -406,8 +396,6 @@ static struct open_bucket *bch2_bucket_alloc_freelist(struct btree_trans *trans,
 	u64 alloc_start = max_t(u64, ca->mi.first_bucket, READ_ONCE(*dev_alloc_cursor));
 	u64 alloc_cursor = alloc_start;
 	int ret;
-
-	BUG_ON(ca->new_fs_bucket_idx);
 again:
 	for_each_btree_key_max_norestart(trans, iter, BTREE_ID_freespace,
 					 POS(ca->dev_idx, alloc_cursor),
@@ -551,6 +539,10 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		bch2_dev_do_invalidates(ca);
 
 	if (!avail) {
+		if (watermark > BCH_WATERMARK_normal &&
+		    c->curr_recovery_pass <= BCH_RECOVERY_PASS_check_allocations)
+			goto alloc;
+
 		if (cl && !waiting) {
 			closure_wait(&c->freelist_wait, cl);
 			waiting = true;
diff --git a/fs/bcachefs/alloc_foreground.h b/fs/bcachefs/alloc_foreground.h
index 1a16fd5bd4f8..4f87745df97e 100644
--- a/fs/bcachefs/alloc_foreground.h
+++ b/fs/bcachefs/alloc_foreground.h
@@ -28,8 +28,6 @@ struct dev_alloc_list bch2_dev_alloc_list(struct bch_fs *,
 					  struct bch_devs_mask *);
 void bch2_dev_stripe_increment(struct bch_dev *, struct dev_stripe_state *);
 
-long bch2_bucket_alloc_new_fs(struct bch_dev *);
-
 static inline struct bch_dev *ob_dev(struct bch_fs *c, struct open_bucket *ob)
 {
 	return bch2_dev_have_ref(c, ob->dev);
diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index f1d8c821d27a..a85b3bcc6383 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -560,7 +560,6 @@ struct bch_dev {
 	struct bch_dev_usage __percpu	*usage;
 
 	/* Allocator: */
-	u64			new_fs_bucket_idx;
 	u64			alloc_cursor[3];
 
 	unsigned		nr_open_buckets;
diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
index 1547141ba2a0..afd35c93fcfb 100644
--- a/fs/bcachefs/buckets.c
+++ b/fs/bcachefs/buckets.c
@@ -1161,6 +1161,31 @@ int bch2_trans_mark_dev_sbs(struct bch_fs *c)
 	return bch2_trans_mark_dev_sbs_flags(c, BTREE_TRIGGER_transactional);
 }
 
+bool bch2_is_superblock_bucket(struct bch_dev *ca, u64 b)
+{
+	struct bch_sb_layout *layout = &ca->disk_sb.sb->layout;
+	u64 b_offset	= bucket_to_sector(ca, b);
+	u64 b_end	= bucket_to_sector(ca, b + 1);
+	unsigned i;
+
+	if (!b)
+		return true;
+
+	for (i = 0; i < layout->nr_superblocks; i++) {
+		u64 offset = le64_to_cpu(layout->sb_offset[i]);
+		u64 end = offset + (1 << layout->sb_max_size_bits);
+
+		if (!(offset >= b_end || end <= b_offset))
+			return true;
+	}
+
+	for (i = 0; i < ca->journal.nr; i++)
+		if (b == ca->journal.buckets[i])
+			return true;
+
+	return false;
+}
+
 /* Disk reservations: */
 
 #define SECTORS_CACHE	1024
diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index ccc78bfe2fd4..3bebc4c3044f 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -308,26 +308,7 @@ int bch2_trans_mark_dev_sbs_flags(struct bch_fs *,
 				    enum btree_iter_update_trigger_flags);
 int bch2_trans_mark_dev_sbs(struct bch_fs *);
 
-static inline bool is_superblock_bucket(struct bch_dev *ca, u64 b)
-{
-	struct bch_sb_layout *layout = &ca->disk_sb.sb->layout;
-	u64 b_offset	= bucket_to_sector(ca, b);
-	u64 b_end	= bucket_to_sector(ca, b + 1);
-	unsigned i;
-
-	if (!b)
-		return true;
-
-	for (i = 0; i < layout->nr_superblocks; i++) {
-		u64 offset = le64_to_cpu(layout->sb_offset[i]);
-		u64 end = offset + (1 << layout->sb_max_size_bits);
-
-		if (!(offset >= b_end || end <= b_offset))
-			return true;
-	}
-
-	return false;
-}
+bool bch2_is_superblock_bucket(struct bch_dev *, u64);
 
 static inline const char *bch2_data_type_str(enum bch_data_type type)
 {
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index bbdd0b17ae69..95cccda3b22c 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1002,19 +1002,17 @@ static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
 	}
 
 	for (nr_got = 0; nr_got < nr_want; nr_got++) {
-		if (new_fs) {
-			bu[nr_got] = bch2_bucket_alloc_new_fs(ca);
-			if (bu[nr_got] < 0) {
-				ret = -BCH_ERR_ENOSPC_bucket_alloc;
-				break;
-			}
-		} else {
-			ob[nr_got] = bch2_bucket_alloc(c, ca, BCH_WATERMARK_normal,
-						       BCH_DATA_journal, cl);
-			ret = PTR_ERR_OR_ZERO(ob[nr_got]);
-			if (ret)
-				break;
+		enum bch_watermark watermark = new_fs
+			? BCH_WATERMARK_btree
+			: BCH_WATERMARK_normal;
 
+		ob[nr_got] = bch2_bucket_alloc(c, ca, watermark,
+					       BCH_DATA_journal, cl);
+		ret = PTR_ERR_OR_ZERO(ob[nr_got]);
+		if (ret)
+			break;
+
+		if (!new_fs) {
 			ret = bch2_trans_run(c,
 				bch2_trans_mark_metadata_bucket(trans, ca,
 						ob[nr_got]->bucket, BCH_DATA_journal,
@@ -1024,9 +1022,9 @@ static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
 				bch_err_msg(c, ret, "marking new journal buckets");
 				break;
 			}
-
-			bu[nr_got] = ob[nr_got]->bucket;
 		}
+
+		bu[nr_got] = ob[nr_got]->bucket;
 	}
 
 	if (!nr_got)
@@ -1066,8 +1064,7 @@ static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
 	if (ret)
 		goto err_unblock;
 
-	if (!new_fs)
-		bch2_write_super(c);
+	bch2_write_super(c);
 
 	/* Commit: */
 	if (c)
@@ -1101,9 +1098,8 @@ static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
 						bu[i], BCH_DATA_free, 0,
 						BTREE_TRIGGER_transactional));
 err_free:
-	if (!new_fs)
-		for (i = 0; i < nr_got; i++)
-			bch2_open_bucket_put(c, ob[i]);
+	for (i = 0; i < nr_got; i++)
+		bch2_open_bucket_put(c, ob[i]);
 
 	kfree(new_bucket_seq);
 	kfree(new_buckets);
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 3d8fc2642425..1aabbbe328d9 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -38,6 +38,9 @@ unsigned bch2_journal_dev_buckets_available(struct journal *j,
 					    struct journal_device *ja,
 					    enum journal_space_from from)
 {
+	if (!ja->nr)
+		return 0;
+
 	unsigned available = (journal_space_from(ja, from) -
 			      ja->cur_idx - 1 + ja->nr) % ja->nr;
 
diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
index 7086a7226989..547c78a323f7 100644
--- a/fs/bcachefs/recovery.c
+++ b/fs/bcachefs/recovery.c
@@ -1070,7 +1070,6 @@ int bch2_fs_initialize(struct bch_fs *c)
 	bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
-	c->curr_recovery_pass = BCH_RECOVERY_PASS_NR;
 	set_bit(BCH_FS_btree_running, &c->flags);
 	set_bit(BCH_FS_may_go_rw, &c->flags);
 
@@ -1111,9 +1110,6 @@ int bch2_fs_initialize(struct bch_fs *c)
 	if (ret)
 		goto err;
 
-	for_each_online_member(c, ca)
-		ca->new_fs_bucket_idx = 0;
-
 	ret = bch2_fs_freespace_init(c);
 	if (ret)
 		goto err;
@@ -1172,6 +1168,7 @@ int bch2_fs_initialize(struct bch_fs *c)
 	bch2_write_super(c);
 	mutex_unlock(&c->sb_lock);
 
+	c->curr_recovery_pass = BCH_RECOVERY_PASS_NR;
 	return 0;
 err:
 	bch_err_fn(c, ret);
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 08170a3d524f..14157820705d 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -1750,11 +1750,6 @@ int bch2_dev_add(struct bch_fs *c, const char *path)
 	if (ret)
 		goto err;
 
-	ret = bch2_dev_journal_alloc(ca, true);
-	bch_err_msg(c, ret, "allocating journal");
-	if (ret)
-		goto err;
-
 	down_write(&c->state_lock);
 	mutex_lock(&c->sb_lock);
 
@@ -1805,11 +1800,14 @@ int bch2_dev_add(struct bch_fs *c, const char *path)
 	if (ret)
 		goto err_late;
 
-	ca->new_fs_bucket_idx = 0;
-
 	if (ca->mi.state == BCH_MEMBER_STATE_rw)
 		__bch2_dev_read_write(c, ca);
 
+	ret = bch2_dev_journal_alloc(ca, false);
+	bch_err_msg(c, ret, "allocating journal");
+	if (ret)
+		goto err_late;
+
 	up_write(&c->state_lock);
 	return 0;
 
-- 
2.45.2

