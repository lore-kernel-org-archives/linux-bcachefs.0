Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6048B157A48
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951178; cv=none; b=JfE8u016p9cA6WbwmYg8/ThYIn9HA13k23e1FKEjCe5nF4GEDAcPVT6BmN+EwEqyjoQExfTZZKG0gJcvU0mNz6PYMfcOI9Jh9DxqRmABlUEaey5s9I5DOKyZYS4CLyBuaaYrlv4IDLp4HdLAZxhBE9nXlCe1Jkr7eqArdDpBmDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951178; c=relaxed/simple;
	bh=IlaAjx6ls/qbGapya74MOVyWIh+3TBvKVLcXMietbBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnFP2m5RyvELY+jzQJc7lfPtsgUvfSjuOHzTF1KCl28Xbglrdo9EX9FRBDEgxWH87cr5CuK07tDtAUdxhijpSy6U1Jj6vuZhkhcrA5U8/X5clfcCfOTyzbXNDXkaBXaExdhkwvQhARgErvpUFSLTTIOK+xhKIYh8sLKNCJst5C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C2UBP8d+; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C2UBP8d+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fa+FIEoVOEEj7LjM9y+wtyq3Y2ftZLzff0kesYIZGG8=;
	b=C2UBP8d+6rlVNKhTtY6nzWbUWFQnbvMiJ1M1I3GZ3r5quRDa/wrrcI/q3ZSpC8oFqcvXr3
	yhvoNatCkoM2IZ1hPBg1wRqEXlsVPg72kZ/hGBSm8S+vYdXOL7yUdhm7BzclnH6P0M7F6v
	jJzWrbBGWfurmKkUBpPR2dMikPNvGcs=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 03/11] bcachefs: "Journal stuck" timeout now takes into account device latency
Date: Sun, 26 Jan 2025 23:12:29 -0500
Message-ID: <20250127041239.2693707-4-kent.overstreet@linux.dev>
In-Reply-To: <20250127041239.2693707-1-kent.overstreet@linux.dev>
References: <20250127041239.2693707-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If a block device (e.g. your typical consumer SSD) is taking multiple
seconds for IOs (typically flushes), we don't want to emit the "journal
stuck" message prematurely.

Also, make sure to drop the btree_trans srcu lock if we're blocking for
more than a second.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/btree_trans_commit.c |  2 +-
 fs/bcachefs/journal.c            | 32 ++++++++++++++++++++++++++++----
 fs/bcachefs/journal.h            |  7 ++++---
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
index 6b79b672e0b1..2760dd9569ed 100644
--- a/fs/bcachefs/btree_trans_commit.c
+++ b/fs/bcachefs/btree_trans_commit.c
@@ -348,7 +348,7 @@ static __always_inline int bch2_trans_journal_res_get(struct btree_trans *trans,
 						      unsigned flags)
 {
 	return bch2_journal_res_get(&trans->c->journal, &trans->journal_res,
-				    trans->journal_u64s, flags);
+				    trans->journal_u64s, flags, trans);
 }
 
 #define JSET_ENTRY_LOG_U64s		4
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cd20114b74b..46d53d3ba018 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -601,6 +601,16 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 		: -BCH_ERR_journal_res_get_blocked;
 }
 
+static unsigned max_dev_latency(struct bch_fs *c)
+{
+	u64 nsecs = 0;
+
+	for_each_rw_member(c, ca)
+		nsecs = max(nsecs, ca->io_latency[WRITE].stats.max_duration);
+
+	return nsecs_to_jiffies(nsecs);
+}
+
 /*
  * Essentially the entry function to the journaling code. When bcachefs is doing
  * a btree insert, it calls this function to get the current journal write.
@@ -612,17 +622,31 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
  * btree node write locks.
  */
 int bch2_journal_res_get_slowpath(struct journal *j, struct journal_res *res,
-				  unsigned flags)
+				  unsigned flags,
+				  struct btree_trans *trans)
 {
 	int ret;
 
 	if (closure_wait_event_timeout(&j->async_wait,
 		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
 		   (flags & JOURNAL_RES_GET_NONBLOCK),
-		   HZ * 10))
+		   HZ))
 		return ret;
 
+	if (trans)
+		bch2_trans_unlock_long(trans);
+
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	int remaining_wait = max(max_dev_latency(c) * 2, HZ * 10);
+
+	remaining_wait = max(0, remaining_wait - HZ);
+
+	if (closure_wait_event_timeout(&j->async_wait,
+		   (ret = __journal_res_get(j, res, flags)) != -BCH_ERR_journal_res_get_blocked ||
+		   (flags & JOURNAL_RES_GET_NONBLOCK),
+		   remaining_wait))
+		return ret;
+
 	struct printbuf buf = PRINTBUF;
 	bch2_journal_debug_to_text(&buf, j);
 	bch_err(c, "Journal stuck? Waited for 10 seconds...\n%s",
@@ -727,7 +751,7 @@ int bch2_journal_flush_seq_async(struct journal *j, u64 seq,
 		 * livelock:
 		 */
 		sched_annotate_sleep();
-		ret = bch2_journal_res_get(j, &res, jset_u64s(0), 0);
+		ret = bch2_journal_res_get(j, &res, jset_u64s(0), 0, NULL);
 		if (ret)
 			return ret;
 
@@ -848,7 +872,7 @@ bool bch2_journal_noflush_seq(struct journal *j, u64 start, u64 end)
 static int __bch2_journal_meta(struct journal *j)
 {
 	struct journal_res res = {};
-	int ret = bch2_journal_res_get(j, &res, jset_u64s(0), 0);
+	int ret = bch2_journal_res_get(j, &res, jset_u64s(0), 0, NULL);
 	if (ret)
 		return ret;
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index cb0df0663946..a01dae1a57e3 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -312,7 +312,7 @@ static inline void bch2_journal_res_put(struct journal *j,
 }
 
 int bch2_journal_res_get_slowpath(struct journal *, struct journal_res *,
-				  unsigned);
+				  unsigned, struct btree_trans *);
 
 /* First bits for BCH_WATERMARK: */
 enum journal_res_flags {
@@ -368,7 +368,8 @@ static inline int journal_res_get_fast(struct journal *j,
 }
 
 static inline int bch2_journal_res_get(struct journal *j, struct journal_res *res,
-				       unsigned u64s, unsigned flags)
+				       unsigned u64s, unsigned flags,
+				       struct btree_trans *trans)
 {
 	int ret;
 
@@ -380,7 +381,7 @@ static inline int bch2_journal_res_get(struct journal *j, struct journal_res *re
 	if (journal_res_get_fast(j, res, flags))
 		goto out;
 
-	ret = bch2_journal_res_get_slowpath(j, res, flags);
+	ret = bch2_journal_res_get_slowpath(j, res, flags, trans);
 	if (ret)
 		return ret;
 out:
-- 
2.45.2

