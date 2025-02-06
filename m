Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B580C2A8D0
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805361; cv=none; b=jNLxfpxoaEKiad+ds0eeucwtiztZxQLHPTxTMKinS50YtYPtUQ/k5vN6YrqMDmYLLSv/H8shS/sWizUp2psOocl7zh0zZcJ6M6H2jsjNQUK39rtOTvjFgM/L43Ao41n+pYhs2tw3ceetQUciXJ3gIWgkSybyJJPCVBy2Nqo3umY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805361; c=relaxed/simple;
	bh=p8LHTMjMn5BjzZzdYRckWdqzLpkPnGXlMLHq0zbWT2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgRQGoEXD+QfC+GDgHsi4NVPjH801Tf3rmI1rn2EdkkOESgdGTnRsk46nEFmiNW0iPA0jwhCZHt+6q5JhbLuoF7vsiX/f9Ka/Sh6weEwGn37vURRPpvVInrIRe9SHEu1uwvOk9JBYGulUe99hJQVvrEwtROm6zWVDDOGFj2Z/1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t+8et6GS; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t+8et6GS"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=obI8abJ1O1mIqhJ3dZTTvVspAdVekZoJD3rSE7UbJtc=;
	b=t+8et6GSYeVxRh2UzTmKANrqqu3oDGV08Ez595YSOjwWrCmrPSW+0FTJ2FjpnvjR1tXmPT
	9DPdGRUzKQH2E8sfRXGwLJX6/Cuecg4rZjxvtY6FrsWuWQVAMkrjt/FHLOiaqE68ucd16J
	UCeIjFy1p7hWkoFUcV9B6f0QQxCOZh8=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 5/5] bcachefs: Increase JOURNAL_BUF_NR
Date: Wed,  5 Feb 2025 20:28:50 -0500
Message-ID: <20250206012852.1658754-6-kent.overstreet@linux.dev>
In-Reply-To: <20250206012852.1658754-1-kent.overstreet@linux.dev>
References: <20250206012852.1658754-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Increase journal pipelining.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h      |  1 +
 fs/bcachefs/journal.c       | 27 +++++++++++++++++++++++----
 fs/bcachefs/journal.h       | 32 ++++++++++++++++++++++----------
 fs/bcachefs/journal_types.h |  8 +++++++-
 4 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 13acfbf3852a..9791bfe08895 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -456,6 +456,7 @@ BCH_DEBUG_PARAMS_DEBUG()
 	x(blocked_journal_low_on_space)		\
 	x(blocked_journal_low_on_pin)		\
 	x(blocked_journal_max_in_flight)	\
+	x(blocked_journal_max_open)		\
 	x(blocked_key_cache_flush)		\
 	x(blocked_allocate)			\
 	x(blocked_allocate_open_bucket)		\
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 8fbdb0bbb536..66f2fe357719 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -56,7 +56,12 @@ static void bch2_journal_buf_to_text(struct printbuf *out, struct journal *j, u6
 	prt_printf(out, "seq:\t%llu\n", seq);
 	printbuf_indent_add(out, 2);
 
-	prt_printf(out, "refcount:\t%u\n", journal_state_count(s, i));
+	if (!buf->write_started)
+		prt_printf(out, "refcount:\t%u\n", journal_state_count(s, i & JOURNAL_STATE_BUF_MASK));
+
+	struct closure *cl = &buf->io;
+	int r = atomic_read(&cl->remaining);
+	prt_printf(out, "io:\t%pS r %i\n", cl->fn, r & CLOSURE_REMAINING_MASK);
 
 	struct jset *data = READ_ONCE(buf->data);
 	if (data) {
@@ -198,7 +203,8 @@ void bch2_journal_do_writes(struct journal *j)
 		if (w->write_started)
 			continue;
 
-		if (!journal_state_count(j->reservations, idx)) {
+		if (!journal_state_seq_count(j, j->reservations, seq)) {
+			j->seq_write_started = seq;
 			w->write_started = true;
 			closure_call(&w->io, bch2_journal_write, j->wq, NULL);
 		}
@@ -394,6 +400,9 @@ static int journal_entry_open(struct journal *j)
 	if (nr_unwritten_journal_entries(j) == ARRAY_SIZE(j->buf))
 		return JOURNAL_ERR_max_in_flight;
 
+	if (atomic64_read(&j->seq) - j->seq_write_started == JOURNAL_STATE_BUF_NR)
+		return JOURNAL_ERR_max_open;
+
 	if (journal_cur_seq(j) >= JOURNAL_SEQ_MAX) {
 		bch_err(c, "cannot start: journal seq overflow");
 		if (bch2_fs_emergency_read_only_locked(c))
@@ -475,7 +484,7 @@ static int journal_entry_open(struct journal *j)
 
 		new.idx++;
 		BUG_ON(journal_state_count(new, new.idx));
-		BUG_ON(new.idx != (journal_cur_seq(j) & JOURNAL_BUF_MASK));
+		BUG_ON(new.idx != (journal_cur_seq(j) & JOURNAL_STATE_BUF_MASK));
 
 		journal_state_inc(&new);
 
@@ -621,7 +630,16 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 
 	if (ret == JOURNAL_ERR_max_in_flight &&
 	    track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight], true)) {
+		struct printbuf buf = PRINTBUF;
+		prt_printf(&buf, "seq %llu\n", journal_cur_seq(j));
+		bch2_journal_bufs_to_text(&buf, j);
+		trace_journal_entry_full(c, buf.buf);
+		printbuf_exit(&buf);
+		count_event(c, journal_entry_full);
+	}
 
+	if (ret == JOURNAL_ERR_max_open &&
+	    track_event_change(&c->times[BCH_TIME_blocked_journal_max_open], true)) {
 		struct printbuf buf = PRINTBUF;
 		prt_printf(&buf, "seq %llu\n", journal_cur_seq(j));
 		bch2_journal_bufs_to_text(&buf, j);
@@ -1033,7 +1051,7 @@ static struct journal_buf *__bch2_next_write_buffer_flush_journal_buf(struct jou
 				*blocked = true;
 			}
 
-			ret = journal_state_count(s, idx) > open
+			ret = journal_state_count(s, idx & JOURNAL_STATE_BUF_MASK) > open
 				? ERR_PTR(-EAGAIN)
 				: buf;
 			break;
@@ -1383,6 +1401,7 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_seq)
 	j->replay_journal_seq_end = cur_seq;
 	j->last_seq_ondisk	= last_seq;
 	j->flushed_seq_ondisk	= cur_seq - 1;
+	j->seq_write_started	= cur_seq - 1;
 	j->seq_ondisk		= cur_seq - 1;
 	j->pin.front		= last_seq;
 	j->pin.back		= cur_seq;
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index e514d664b8ae..1c460ded2a11 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -121,11 +121,6 @@ static inline void journal_wake(struct journal *j)
 	closure_wake_up(&j->async_wait);
 }
 
-static inline struct journal_buf *journal_cur_buf(struct journal *j)
-{
-	return j->buf + j->reservations.idx;
-}
-
 /* Sequence number of oldest dirty journal entry */
 
 static inline u64 journal_last_seq(struct journal *j)
@@ -143,6 +138,15 @@ static inline u64 journal_last_unwritten_seq(struct journal *j)
 	return j->seq_ondisk + 1;
 }
 
+static inline struct journal_buf *journal_cur_buf(struct journal *j)
+{
+	unsigned idx = (journal_cur_seq(j) &
+			JOURNAL_BUF_MASK &
+			~JOURNAL_STATE_BUF_MASK) + j->reservations.idx;
+
+	return j->buf + idx;
+}
+
 static inline int journal_state_count(union journal_res_state s, int idx)
 {
 	switch (idx) {
@@ -154,6 +158,15 @@ static inline int journal_state_count(union journal_res_state s, int idx)
 	BUG();
 }
 
+static inline int journal_state_seq_count(struct journal *j,
+					  union journal_res_state s, u64 seq)
+{
+	if (journal_cur_seq(j) - seq <= JOURNAL_STATE_BUF_NR)
+		return journal_state_count(s, seq & JOURNAL_STATE_BUF_MASK);
+	else
+		return 0;
+}
+
 static inline void journal_state_inc(union journal_res_state *s)
 {
 	s->buf0_count += s->idx == 0;
@@ -269,7 +282,7 @@ void bch2_journal_buf_put_final(struct journal *, u64);
 
 static inline void __bch2_journal_buf_put(struct journal *j, u64 seq)
 {
-	unsigned idx = seq & JOURNAL_BUF_MASK;
+	unsigned idx = seq & JOURNAL_STATE_BUF_MASK;
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
@@ -279,7 +292,7 @@ static inline void __bch2_journal_buf_put(struct journal *j, u64 seq)
 
 static inline void bch2_journal_buf_put(struct journal *j, u64 seq)
 {
-	unsigned idx = seq & JOURNAL_BUF_MASK;
+	unsigned idx = seq & JOURNAL_STATE_BUF_MASK;
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
@@ -365,9 +378,7 @@ static inline int journal_res_get_fast(struct journal *j,
 	res->ref	= true;
 	res->offset	= old.cur_entry_offset;
 	res->seq	= journal_cur_seq(j);
-	res->seq -= (res->seq - old.idx) & JOURNAL_BUF_MASK;
-
-	EBUG_ON(res->seq != le64_to_cpu(j->buf[old.idx].data->seq));
+	res->seq -= (res->seq - old.idx) & JOURNAL_STATE_BUF_MASK;
 	return 1;
 }
 
@@ -394,6 +405,7 @@ static inline int bch2_journal_res_get(struct journal *j, struct journal_res *re
 				    (flags & JOURNAL_RES_GET_NONBLOCK) != 0,
 				    NULL, _THIS_IP_);
 		EBUG_ON(!res->ref);
+		BUG_ON(!res->seq);
 	}
 	return 0;
 }
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index cd8440868d38..060ec991dd2b 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -12,7 +12,11 @@
 /* btree write buffer steals 8 bits for its own purposes: */
 #define JOURNAL_SEQ_MAX		((1ULL << 56) - 1)
 
-#define JOURNAL_BUF_BITS	2
+#define JOURNAL_STATE_BUF_BITS	2
+#define JOURNAL_STATE_BUF_NR	(1U << JOURNAL_STATE_BUF_BITS)
+#define JOURNAL_STATE_BUF_MASK	(JOURNAL_STATE_BUF_NR - 1)
+
+#define JOURNAL_BUF_BITS	4
 #define JOURNAL_BUF_NR		(1U << JOURNAL_BUF_BITS)
 #define JOURNAL_BUF_MASK	(JOURNAL_BUF_NR - 1)
 
@@ -150,6 +154,7 @@ enum journal_flags {
 	x(retry)			\
 	x(blocked)			\
 	x(max_in_flight)		\
+	x(max_open)			\
 	x(journal_full)			\
 	x(journal_pin_full)		\
 	x(journal_stuck)		\
@@ -235,6 +240,7 @@ struct journal {
 	/* Sequence number of most recent journal entry (last entry in @pin) */
 	atomic64_t		seq;
 
+	u64			seq_write_started;
 	/* seq, last_seq from the most recent journal entry successfully written */
 	u64			seq_ondisk;
 	u64			flushed_seq_ondisk;
-- 
2.45.2

