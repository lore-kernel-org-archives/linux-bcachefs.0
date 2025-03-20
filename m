Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05C581E5B7E
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Mar 2025 21:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742505732; cv=none; b=ie2dfncmsPiC0umQXK4Gqr81YzR2Y5Y1Rnq0FzqImj93yXm4guTlun8/ZxdKiNi/eUoEk33YZhnahNnYAwlfT6cbnDqXRQnXJ1oXjZ+iiPVVWMvfiQXWexpfS7bAUGxU6w3md2AqTqRGMceVBtYcr/7IUbfX2mmTD9B16s6X7pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742505732; c=relaxed/simple;
	bh=MS4BP3ffU8mtTPVYQ84tPan9C8k6rXUtx3yjhoGD31s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=krPtexpcGuzx8fMVSirTEXKOLMvMZi7+eTBtdXT1r9LiRX9hOmLZ4kB2uA7zdh0OY42uiFxS+SjHSnHTNI7QG52bNOEQS3caEss9XJBNMKRBCrUIX2KTgmMWT17ISEPZ1ehcjncNdprMcOXjg48ho3Msl/AovbN7H3KR7YV+uL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QSGBD/Ys; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QSGBD/Ys"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742505728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3MEG5qjUWmxikwBg3XALhBTwOwpAwniWXG73z22ry8I=;
	b=QSGBD/YsqkUMgKefeov+5BrNfgbM1WRcglVjFd/JEk80lLyVfksKJ51Doe3/CnG6DD0j8X
	mZtfLIFpZ7PnPeC44dOHbAGFI4DV6wLceb+4nVUqiITSVJg67eJmoIk7rFnbuR9w6DdY5e
	vR0R5pCVFGtG61h/yk0o0O/CzeAf2XI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] bcachefs: Kill JOURNAL_ERRORS()
Date: Thu, 20 Mar 2025 17:21:59 -0400
Message-ID: <20250320212159.3359248-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Convert these to standard error codes, which means we can pass them
outside the journal code, they're easier to pass to tracepoints, etc.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c | 30 +++++++-------
 fs/bcachefs/errcode.h            | 16 ++++++--
 fs/bcachefs/journal.c            | 69 ++++++++++++++------------------
 fs/bcachefs/journal_reclaim.c    |  4 +-
 fs/bcachefs/journal_types.h      | 21 +---------
 5 files changed, 62 insertions(+), 78 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 892d20a50a52..d50dc31d0bea 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -880,18 +880,7 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 	struct bch_fs *c = trans->c;
 	enum bch_watermark watermark = flags & BCH_WATERMARK_MASK;
 
-	switch (ret) {
-	case -BCH_ERR_btree_insert_btree_node_full:
-		ret = bch2_btree_split_leaf(trans, i->path, flags);
-		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
-			trace_and_count(c, trans_restart_btree_node_split, trans,
-					trace_ip, trans->paths + i->path);
-		break;
-	case -BCH_ERR_btree_insert_need_mark_replicas:
-		ret = drop_locks_do(trans,
-			bch2_accounting_update_sb(trans));
-		break;
-	case -BCH_ERR_journal_res_get_blocked:
+	if (bch2_err_matches(ret, BCH_ERR_journal_res_blocked)) {
 		/*
 		 * XXX: this should probably be a separate BTREE_INSERT_NONBLOCK
 		 * flag
@@ -899,13 +888,26 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 		if ((flags & BCH_TRANS_COMMIT_journal_reclaim) &&
 		    watermark < BCH_WATERMARK_reclaim) {
 			ret = -BCH_ERR_journal_reclaim_would_deadlock;
-			break;
+			goto out;
 		}
 
 		ret = drop_locks_do(trans,
 			bch2_trans_journal_res_get(trans,
 					(flags & BCH_WATERMARK_MASK)|
 					JOURNAL_RES_GET_CHECK));
+		goto out;
+	}
+
+	switch (ret) {
+	case -BCH_ERR_btree_insert_btree_node_full:
+		ret = bch2_btree_split_leaf(trans, i->path, flags);
+		if (bch2_err_matches(ret, BCH_ERR_transaction_restart))
+			trace_and_count(c, trans_restart_btree_node_split, trans,
+					trace_ip, trans->paths + i->path);
+		break;
+	case -BCH_ERR_btree_insert_need_mark_replicas:
+		ret = drop_locks_do(trans,
+			bch2_accounting_update_sb(trans));
 		break;
 	case -BCH_ERR_btree_insert_need_journal_reclaim:
 		bch2_trans_unlock(trans);
@@ -927,7 +929,7 @@ int bch2_trans_commit_error(struct btree_trans *trans, unsigned flags,
 		BUG_ON(ret >= 0);
 		break;
 	}
-
+out:
 	BUG_ON(bch2_err_matches(ret, BCH_ERR_transaction_restart) != !!trans->restarted);
 
 	bch2_fs_inconsistent_on(bch2_err_matches(ret, ENOSPC) &&
diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
index cb27de6ffad6..c179954aaf33 100644
--- a/fs/bcachefs/errcode.h
+++ b/fs/bcachefs/errcode.h
@@ -218,10 +218,18 @@
 	x(EROFS,			insufficient_devices)			\
 	x(0,				operation_blocked)			\
 	x(BCH_ERR_operation_blocked,	btree_cache_cannibalize_lock_blocked)	\
-	x(BCH_ERR_operation_blocked,	journal_res_get_blocked)		\
-	x(BCH_ERR_operation_blocked,	journal_preres_get_blocked)		\
-	x(BCH_ERR_operation_blocked,	bucket_alloc_blocked)			\
-	x(BCH_ERR_operation_blocked,	stripe_alloc_blocked)			\
+	x(BCH_ERR_operation_blocked,	journal_res_blocked)			\
+	x(BCH_ERR_journal_res_blocked,	journal_blocked)			\
+	x(BCH_ERR_journal_res_blocked,	journal_max_in_flight)			\
+	x(BCH_ERR_journal_res_blocked,	journal_max_open)			\
+	x(BCH_ERR_journal_res_blocked,	journal_full)				\
+	x(BCH_ERR_journal_res_blocked,	journal_pin_full)			\
+	x(BCH_ERR_journal_res_blocked,	journal_buf_enomem)			\
+	x(BCH_ERR_journal_res_blocked,	journal_stuck)				\
+	x(BCH_ERR_journal_res_blocked,	journal_retry_open)			\
+	x(BCH_ERR_journal_res_blocked,	journal_preres_get_blocked)		\
+	x(BCH_ERR_journal_res_blocked,	bucket_alloc_blocked)			\
+	x(BCH_ERR_journal_res_blocked,	stripe_alloc_blocked)			\
 	x(BCH_ERR_invalid,		invalid_sb)				\
 	x(BCH_ERR_invalid_sb,		invalid_sb_magic)			\
 	x(BCH_ERR_invalid_sb,		invalid_sb_version)			\
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index fc15644c9f24..ce7302695547 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -20,13 +20,6 @@
 #include "journal_seq_blacklist.h"
 #include "trace.h"
 
-static const char * const bch2_journal_errors[] = {
-#define x(n)	#n,
-	JOURNAL_ERRORS()
-#undef x
-	NULL
-};
-
 static inline bool journal_seq_unwritten(struct journal *j, u64 seq)
 {
 	return seq > j->seq_ondisk;
@@ -149,8 +142,8 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	bool stuck = false;
 	struct printbuf buf = PRINTBUF;
 
-	if (!(error == JOURNAL_ERR_journal_full ||
-	      error == JOURNAL_ERR_journal_pin_full) ||
+	if (!(error == -BCH_ERR_journal_full ||
+	      error == -BCH_ERR_journal_pin_full) ||
 	    nr_unwritten_journal_entries(j) ||
 	    (flags & BCH_WATERMARK_MASK) != BCH_WATERMARK_reclaim)
 		return stuck;
@@ -177,7 +170,7 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	spin_unlock(&j->lock);
 
 	bch_err(c, "Journal stuck! Hava a pre-reservation but journal full (error %s)",
-		bch2_journal_errors[error]);
+		bch2_err_str(error));
 	bch2_journal_debug_to_text(&buf, j);
 	bch_err(c, "%s", buf.buf);
 
@@ -388,32 +381,33 @@ static int journal_entry_open(struct journal *j)
 	BUG_ON(BCH_SB_CLEAN(c->disk_sb.sb));
 
 	if (j->blocked)
-		return JOURNAL_ERR_blocked;
+		return -BCH_ERR_journal_blocked;
 
 	if (j->cur_entry_error)
 		return j->cur_entry_error;
 
-	if (bch2_journal_error(j))
-		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+	int ret = bch2_journal_error(j);
+	if (unlikely(ret))
+		return ret;
 
 	if (!fifo_free(&j->pin))
-		return JOURNAL_ERR_journal_pin_full;
+		return -BCH_ERR_journal_pin_full;
 
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
-		return JOURNAL_ERR_max_in_flight;
+		return -BCH_ERR_journal_max_in_flight;
 
 	if (atomic64_read(&j->seq) - j->seq_write_started == JOURNAL_STATE_BUF_NR)
-		return JOURNAL_ERR_max_open;
+		return -BCH_ERR_journal_max_open;
 
 	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
 		bch_err(c, "cannot start: journal seq overflow");
 		if (bch2_fs_emergency_read_only_locked(c))
 			bch_err(c, "fatal error - emergency read only");
-		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
+		return -BCH_ERR_journal_shutdown;
 	}
 
 	if (!j->free_buf && !buf->data)
-		return JOURNAL_ERR_enomem; /* will retry after write completion frees up a buf */
+		return -BCH_ERR_journal_buf_enomem; /* will retry after write completion frees up a buf */
 
 	BUG_ON(!j->cur_entry_sectors);
 
@@ -437,7 +431,7 @@ static int journal_entry_open(struct journal *j)
 	u64s = clamp_t(int, u64s, 0, JOURNAL_ENTRY_CLOSED_VAL - 1);
 
 	if (u64s <= (ssize_t) j->early_journal_entries.nr)
-		return JOURNAL_ERR_journal_full;
+		return -BCH_ERR_journal_full;
 
 	if (fifo_empty(&j->pin) && j->reclaim_thread)
 		wake_up_process(j->reclaim_thread);
@@ -574,20 +568,21 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 	if (journal_res_get_fast(j, res, flags))
 		return 0;
 
-	if (bch2_journal_error(j))
-		return -BCH_ERR_erofs_journal_err;
+	ret = bch2_journal_error(j);
+	if (unlikely(ret))
+		return ret;
 
 	if (j->blocked)
-		return -BCH_ERR_journal_res_get_blocked;
+		return -BCH_ERR_journal_blocked;
 
 	if ((flags & BCH_WATERMARK_MASK) < j->watermark) {
-		ret = JOURNAL_ERR_journal_full;
+		ret = -BCH_ERR_journal_full;
 		can_discard = j->can_discard;
 		goto out;
 	}
 
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf) && !journal_entry_is_open(j)) {
-		ret = JOURNAL_ERR_max_in_flight;
+		ret = -BCH_ERR_journal_max_in_flight;
 		goto out;
 	}
 
@@ -617,20 +612,20 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 		j->buf_size_want = max(j->buf_size_want, buf->buf_size << 1);
 
 	__journal_entry_close(j, JOURNAL_ENTRY_CLOSED_VAL, false);
-	ret = journal_entry_open(j) ?: JOURNAL_ERR_retry;
+	ret = journal_entry_open(j) ?: -BCH_ERR_journal_retry_open;
 unlock:
 	can_discard = j->can_discard;
 	spin_unlock(&j->lock);
 out:
 	if (likely(!ret))
 		return 0;
-	if (ret == JOURNAL_ERR_retry)
+	if (ret == -BCH_ERR_journal_retry_open)
 		goto retry;
 
 	if (journal_error_check_stuck(j, ret, flags))
-		ret = -BCH_ERR_journal_res_get_blocked;
+		ret = -BCH_ERR_journal_stuck;
 
-	if (ret == JOURNAL_ERR_max_in_flight &&
+	if (ret == -BCH_ERR_journal_max_in_flight &&
 	    track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight], true) &&
 	    trace_journal_entry_full_enabled()) {
 		struct printbuf buf = PRINTBUF;
@@ -647,7 +642,7 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 		count_event(c, journal_entry_full);
 	}
 
-	if (ret == JOURNAL_ERR_max_open &&
+	if (ret == -BCH_ERR_journal_max_open &&
 	    track_event_change(&c->times[BCH_TIME_blocked_journal_max_open], true) &&
 	    trace_journal_entry_full_enabled()) {
 		struct printbuf buf = PRINTBUF;
@@ -668,8 +663,8 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 	 * Journal is full - can't rely on reclaim from work item due to
 	 * freezing:
 	 */
-	if ((ret == JOURNAL_ERR_journal_full ||
-	     ret == JOURNAL_ERR_journal_pin_full) &&
+	if ((ret == -BCH_ERR_journal_full ||
+	     ret == -BCH_ERR_journal_pin_full) &&
 	    !(flags & JOURNAL_RES_GET_NONBLOCK)) {
 		if (can_discard) {
 			bch2_journal_do_discards(j);
@@ -682,9 +677,7 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 		}
 	}
 
-	return ret == JOURNAL_ERR_insufficient_devices
-		? -BCH_ERR_erofs_journal_err
-		: -BCH_ERR_journal_res_get_blocked;
+	return ret;
 }
 
 static unsigned max_dev_latency(struct bch_fs *c)
@@ -714,7 +707,7 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 	int ret;
 
 	if (closure_wait_event_timeout(&j->async_wait,
-		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
+		   !bch2_err_matches(ret = __journal_res_get(j, res, flags), BCH_ERR_operation_blocked) ||
 		   (flags & JOURNAL_RES_GET_NONBLOCK),
 		   HZ))
 		return ret;
@@ -728,7 +721,7 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 	remaining_wait = max(0, remaining_wait - HZ);
 
 	if (closure_wait_event_timeout(&j->async_wait,
-		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
+		   !bch2_err_matches(ret = __journal_res_get(j, res, flags), BCH_ERR_operation_blocked) ||
 		   (flags & JOURNAL_RES_GET_NONBLOCK),
 		   remaining_wait))
 		return ret;
@@ -740,7 +733,7 @@ int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
 	printbuf_exit(&buf);
 
 	closure_wait_event(&j->async_wait,
-		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
+		   !bch2_err_matches(ret = __journal_res_get(j, res, flags), BCH_ERR_operation_blocked) ||
 		   (flags & JOURNAL_RES_GET_NONBLOCK));
 	return ret;
 }
@@ -1647,7 +1640,7 @@ void __bch2_journal_debug_to_text(struct printbuf *out, struct journal *j)
 	       ? jiffies_to_msecs(j->next_reclaim - jiffies) : 0);
 	prt_printf(out, "blocked:\t%u\n",			j->blocked);
 	prt_printf(out, "current entry sectors:\t%u\n",		j->cur_entry_sectors);
-	prt_printf(out, "current entry error:\t%s\n",		bch2_journal_errors[j->cur_entry_error]);
+	prt_printf(out, "current entry error:\t%s\n",		bch2_err_str(j->cur_entry_error));
 	prt_printf(out, "current entry:\t");
 
 	switch (s.cur_entry_offset) {
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index d373cd181a7f..3ed31492e1aa 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -226,7 +226,7 @@ void bch2_journal_space_available(struct journal *j)
 
 		bch_err(c, "%s", buf.buf);
 		printbuf_exit(&buf);
-		ret = JOURNAL_ERR_insufficient_devices;
+		ret = -BCH_ERR_insufficient_journal_devices;
 		goto out;
 	}
 
@@ -240,7 +240,7 @@ void bch2_journal_space_available(struct journal *j)
 	total		= j->space[journal_space_total].total;
 
 	if (!j->space[journal_space_discarded].next_entry)
-		ret = JOURNAL_ERR_journal_full;
+		ret = -BCH_ERR_journal_full;
 
 	if ((j->space[journal_space_clean_ondisk].next_entry <
 	     j->space[journal_space_clean_ondisk].total) &&
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index fd82f5d80355..8e0eba776b9d 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -151,25 +151,6 @@ enum journal_flags {
 #undef x
 };
 
-/* Reasons we may fail to get a journal reservation: */
-#define JOURNAL_ERRORS()		\
-	x(ok)				\
-	x(retry)			\
-	x(blocked)			\
-	x(max_in_flight)		\
-	x(max_open)			\
-	x(journal_full)			\
-	x(journal_pin_full)		\
-	x(journal_stuck)		\
-	x(enomem)			\
-	x(insufficient_devices)
-
-enum journal_errors {
-#define x(n)	JOURNAL_ERR_##n,
-	JOURNAL_ERRORS()
-#undef x
-};
-
 typedef DARRAY(u64)		darray_u64;
 
 struct journal_bio {
@@ -204,7 +185,7 @@ struct journal {
 	 * 0, or -ENOSPC if waiting on journal reclaim, or -EROFS if
 	 * insufficient devices:
 	 */
-	enum journal_errors	cur_entry_error;
+	int			cur_entry_error;
 	unsigned		cur_entry_offset_if_blocked;
 
 	unsigned		buf_size_want;
-- 
2.49.0

