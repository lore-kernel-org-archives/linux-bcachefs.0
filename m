Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C82187325
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jan 2025 20:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738183732; cv=none; b=V7SVbh5ZL7dw+7c5qjN5mhy1gnFSQ3XW4xuLPBEYpgnQUBBpUUFeqpLscieoVThBuP3nmTmoIXjSKz51ZQz/hyr1nxhs+ZIAKthMcmMGZHO1Z/SzYQhAc4J4d8rBJwjPTWstuWijV+Coy0V9Azt00e+0m23/sOxbiasDM2zlYn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738183732; c=relaxed/simple;
	bh=CJeZniaGO2Mht8yp8Wo/+fJyGPQEMCEXdf2u0CPN3fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RIIZga0b2pWveVSktxVwC6/2FNZhwN5lxUgDhWkhXDXi30bgl8y7x8bpoAJHrjANPMvBOTJfuZK4N1V+yI5tmFiyIRR5FKzJl0IhC65RSHbyWhx4eikvoiRtE4hqcQyrleHs59PuNO3iXeRomCccfekZ0zdn94bhK1IHnHthJAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wJQaTtdO; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wJQaTtdO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738183723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ggzTld9G2r9eFU3AXhiebirFiwLe9z/Z5jBgVIkUmRw=;
	b=wJQaTtdO3tQ8CGWyLORrOm+BZ6sd8iVGDi07576bN/TphzOsWgNy7X5VLefCi/GzkC1bKd
	xyAxDaGWGEUUpbdgtMwq1GJeywci2biDjuDxSbi/qu0VFMTlka3f1rjnLWCh8WCHeYqevb
	iga9tj/6FiQP786C6Wsq63fSYGybBH4=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Fix discard path journal flushing
Date: Wed, 29 Jan 2025 15:48:36 -0500
Message-ID: <20250129204836.222053-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The discard path is supposed to issue journal flushes when there's too
many buckets empty buckets that need a journal commit before they can be
written to again, but at some point this code seems to have been lost.

Bring it back with a new optimization to make sure we don't issue too
many journal flushes: the journal now tracks the sequence number of the
most recent flush in progress, which the discard path uses when deciding
which buckets need a journal flush.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/alloc_background.c            | 48 ++++++++++++-----------
 fs/bcachefs/alloc_foreground.c            | 10 +++--
 fs/bcachefs/alloc_types.h                 |  1 +
 fs/bcachefs/buckets_waiting_for_journal.c | 12 +++---
 fs/bcachefs/buckets_waiting_for_journal.h |  4 +-
 fs/bcachefs/journal.c                     |  1 +
 fs/bcachefs/journal_types.h               |  1 +
 fs/bcachefs/trace.h                       | 14 ++++++-
 8 files changed, 56 insertions(+), 35 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index fc2ef33b67b3..4103dae26239 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -1803,7 +1803,6 @@ struct discard_buckets_state {
 	u64		open;
 	u64		need_journal_commit;
 	u64		discarded;
-	u64		need_journal_commit_this_dev;
 };
 
 static int bch2_discard_one_bucket(struct btree_trans *trans,
@@ -1827,11 +1826,11 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 		goto out;
 	}
 
-	if (bch2_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
-			c->journal.flushed_seq_ondisk,
-			pos.inode, pos.offset)) {
-		s->need_journal_commit++;
-		s->need_journal_commit_this_dev++;
+	u64 seq_ready = bch2_bucket_journal_seq_ready(&c->buckets_waiting_for_journal,
+						      pos.inode, pos.offset);
+	if (seq_ready > c->journal.flushed_seq_ondisk) {
+		if (seq_ready > c->journal.flushing_seq)
+			s->need_journal_commit++;
 		goto out;
 	}
 
@@ -1865,23 +1864,24 @@ static int bch2_discard_one_bucket(struct btree_trans *trans,
 		discard_locked = true;
 	}
 
-	if (!bkey_eq(*discard_pos_done, iter.pos) &&
-	    ca->mi.discard && !c->opts.nochanges) {
-		/*
-		 * This works without any other locks because this is the only
-		 * thread that removes items from the need_discard tree
-		 */
-		bch2_trans_unlock_long(trans);
-		blkdev_issue_discard(ca->disk_sb.bdev,
-				     k.k->p.offset * ca->mi.bucket_size,
-				     ca->mi.bucket_size,
-				     GFP_KERNEL);
-		*discard_pos_done = iter.pos;
+	if (!bkey_eq(*discard_pos_done, iter.pos)) {
 		s->discarded++;
+		*discard_pos_done = iter.pos;
 
-		ret = bch2_trans_relock_notrace(trans);
-		if (ret)
-			goto out;
+		if (ca->mi.discard && !c->opts.nochanges) {
+			/*
+			 * This works without any other locks because this is the only
+			 * thread that removes items from the need_discard tree
+			 */
+			bch2_trans_unlock_long(trans);
+			blkdev_issue_discard(ca->disk_sb.bdev,
+					     k.k->p.offset * ca->mi.bucket_size,
+					     ca->mi.bucket_size,
+					     GFP_KERNEL);
+			ret = bch2_trans_relock_notrace(trans);
+			if (ret)
+				goto out;
+		}
 	}
 
 	SET_BCH_ALLOC_V4_NEED_DISCARD(&a->v, false);
@@ -1929,6 +1929,10 @@ static void bch2_do_discards_work(struct work_struct *work)
 				   POS(ca->dev_idx, U64_MAX), 0, k,
 			bch2_discard_one_bucket(trans, ca, &iter, &discard_pos_done, &s, false)));
 
+	/* XXX ratelimit journal flushes */
+	if (s.need_journal_commit > dev_buckets_available(ca, BCH_WATERMARK_normal))
+		bch2_journal_flush_async(&c->journal, NULL);
+
 	trace_discard_buckets(c, s.seen, s.open, s.need_journal_commit, s.discarded,
 			      bch2_err_str(ret));
 
@@ -2024,7 +2028,7 @@ static void bch2_do_discards_fast_work(struct work_struct *work)
 			break;
 	}
 
-	trace_discard_buckets(c, s.seen, s.open, s.need_journal_commit, s.discarded, bch2_err_str(ret));
+	trace_discard_buckets_fast(c, s.seen, s.open, s.need_journal_commit, s.discarded, bch2_err_str(ret));
 
 	bch2_trans_put(trans);
 	percpu_ref_put(&ca->io_ref);
diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index ecd14962ab01..1759c15a7745 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -188,8 +188,12 @@ static inline bool may_alloc_bucket(struct bch_fs *c,
 		return false;
 	}
 
-	if (bch2_bucket_needs_journal_commit(&c->buckets_waiting_for_journal,
-			c->journal.flushed_seq_ondisk, bucket.inode, bucket.offset)) {
+	u64 journal_seq_ready =
+		bch2_bucket_journal_seq_ready(&c->buckets_waiting_for_journal,
+					      bucket.inode, bucket.offset);
+	if (journal_seq_ready > c->journal.flushed_seq_ondisk) {
+		if (journal_seq_ready > c->journal.flushing_seq)
+			s->need_journal_commit++;
 		s->skipped_need_journal_commit++;
 		return false;
 	}
@@ -553,7 +557,7 @@ static struct open_bucket *bch2_bucket_alloc_trans(struct btree_trans *trans,
 		? bch2_bucket_alloc_freelist(trans, ca, watermark, &s, cl)
 		: bch2_bucket_alloc_early(trans, ca, watermark, &s, cl);
 
-	if (s.skipped_need_journal_commit * 2 > avail)
+	if (s.need_journal_commit * 2 > avail)
 		bch2_journal_flush_async(&c->journal, NULL);
 
 	if (!ob && s.btree_bitmap != BTREE_BITMAP_ANY) {
diff --git a/fs/bcachefs/alloc_types.h b/fs/bcachefs/alloc_types.h
index 9bbb28e90b93..4aa8ee026cb8 100644
--- a/fs/bcachefs/alloc_types.h
+++ b/fs/bcachefs/alloc_types.h
@@ -18,6 +18,7 @@ struct bucket_alloc_state {
 	u64	buckets_seen;
 	u64	skipped_open;
 	u64	skipped_need_journal_commit;
+	u64	need_journal_commit;
 	u64	skipped_nocow;
 	u64	skipped_nouse;
 	u64	skipped_mi_btree_bitmap;
diff --git a/fs/bcachefs/buckets_waiting_for_journal.c b/fs/bcachefs/buckets_waiting_for_journal.c
index f9fb150eda70..c8a488e6b7b8 100644
--- a/fs/bcachefs/buckets_waiting_for_journal.c
+++ b/fs/bcachefs/buckets_waiting_for_journal.c
@@ -22,23 +22,21 @@ static void bucket_table_init(struct buckets_waiting_for_journal_table *t, size_
 	memset(t->d, 0, sizeof(t->d[0]) << t->bits);
 }
 
-bool bch2_bucket_needs_journal_commit(struct buckets_waiting_for_journal *b,
-				      u64 flushed_seq,
-				      unsigned dev, u64 bucket)
+u64 bch2_bucket_journal_seq_ready(struct buckets_waiting_for_journal *b,
+				  unsigned dev, u64 bucket)
 {
 	struct buckets_waiting_for_journal_table *t;
 	u64 dev_bucket = (u64) dev << 56 | bucket;
-	bool ret = false;
-	unsigned i;
+	u64 ret = 0;
 
 	mutex_lock(&b->lock);
 	t = b->t;
 
-	for (i = 0; i < ARRAY_SIZE(t->hash_seeds); i++) {
+	for (unsigned i = 0; i < ARRAY_SIZE(t->hash_seeds); i++) {
 		struct bucket_hashed *h = bucket_hash(t, i, dev_bucket);
 
 		if (h->dev_bucket == dev_bucket) {
-			ret = h->journal_seq > flushed_seq;
+			ret = h->journal_seq;
 			break;
 		}
 	}
diff --git a/fs/bcachefs/buckets_waiting_for_journal.h b/fs/bcachefs/buckets_waiting_for_journal.h
index d2ae19cbe18c..365619ca44c8 100644
--- a/fs/bcachefs/buckets_waiting_for_journal.h
+++ b/fs/bcachefs/buckets_waiting_for_journal.h
@@ -4,8 +4,8 @@
 
 #include "buckets_waiting_for_journal_types.h"
 
-bool bch2_bucket_needs_journal_commit(struct buckets_waiting_for_journal *,
-				      u64, unsigned, u64);
+u64 bch2_bucket_journal_seq_ready(struct buckets_waiting_for_journal *,
+				  unsigned, u64);
 int bch2_set_bucket_needs_journal_commit(struct buckets_waiting_for_journal *,
 					 u64, unsigned, u64, u64);
 
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index cb2c3722f674..ee5cb8f7b5a7 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -783,6 +783,7 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 	}
 
 	buf->must_flush = true;
+	j->flushing_seq = max(j->flushing_seq, seq);
 
 	if (parent && !closure_wait(&buf->wait, parent))
 		BUG();
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 3ba433a48eb8..a198a81d7478 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -237,6 +237,7 @@ struct journal {
 	/* seq, last_seq from the most recent journal entry successfully written */
 	u64			seq_ondisk;
 	u64			flushed_seq_ondisk;
+	u64			flushing_seq;
 	u64			last_seq_ondisk;
 	u64			err_seq;
 	u64			last_empty_seq;
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 56a5a7fbc0fd..c1b51009edf6 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -727,7 +727,7 @@ DEFINE_EVENT(fs_str, bucket_alloc_fail,
 	TP_ARGS(c, str)
 );
 
-TRACE_EVENT(discard_buckets,
+DECLARE_EVENT_CLASS(discard_buckets_class,
 	TP_PROTO(struct bch_fs *c, u64 seen, u64 open,
 		 u64 need_journal_commit, u64 discarded, const char *err),
 	TP_ARGS(c, seen, open, need_journal_commit, discarded, err),
@@ -759,6 +759,18 @@ TRACE_EVENT(discard_buckets,
 		  __entry->err)
 );
 
+DEFINE_EVENT(discard_buckets_class, discard_buckets,
+	TP_PROTO(struct bch_fs *c, u64 seen, u64 open,
+		 u64 need_journal_commit, u64 discarded, const char *err),
+	TP_ARGS(c, seen, open, need_journal_commit, discarded, err)
+);
+
+DEFINE_EVENT(discard_buckets_class, discard_buckets_fast,
+	TP_PROTO(struct bch_fs *c, u64 seen, u64 open,
+		 u64 need_journal_commit, u64 discarded, const char *err),
+	TP_ARGS(c, seen, open, need_journal_commit, discarded, err)
+);
+
 TRACE_EVENT(bucket_invalidate,
 	TP_PROTO(struct bch_fs *c, unsigned dev, u64 bucket, u32 sectors),
 	TP_ARGS(c, dev, bucket, sectors),
-- 
2.45.2

