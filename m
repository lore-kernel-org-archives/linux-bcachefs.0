Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86533F8F9
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 20:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706732196; cv=none; b=aM/JMPe7SLH/766yM0CFwuZju445Fq2qEGOrg6HaKZlvZo8xZJimsHExj3j0Hb1OzDqKfxc/MaVC5bHExka6ez7wPL1BT85dmYENuhYQrUZvw9/DkO8lhhr7D2jFj6qUXDwaZ0PCkYYIIiQmn3rmBNBlZxkwYcuwxXcrlc+fhJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706732196; c=relaxed/simple;
	bh=8aHFuptKC6eaiuDaDoOszomKmC7n/MTeZCcnoMnqpPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDKFHHEplfL3FCJ+544CY8+3RebGl79tHjancUXAOV/I+CtgQkay2HzycL0ir4yLDmqpyw5t5fQeK+ev8oDQHp6diFhnwibE8K3NlILxCJIXWbscDrpjckysVeE9joYFusJjCvdVze4aVjFG7M2pdieGOBaHJETdJXrVSJWLgrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bZfwXPtW; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bZfwXPtW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706732191;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o5AFlVsfpI9ux20q5I/u+z5eVr7t6v/zdjKe5aw7sW0=;
	b=bZfwXPtWMGYw9jFn6nk9xUvcb6tpnOfbmnHjeyr8dFkkeBQDulhknEo8oXjbBFJWlQvgYP
	AWBMTkPz+pJWvQ5Py6BYDK2ff9sOVSI24aMjirljhdImbWYnjwiekVjtiwQtF5P1XexWwT
	dO1FmWWFJINGQRGKJKBXWFy484iJcFo=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 3/3] bcachefs: better journal pipelining
Date: Wed, 31 Jan 2024 15:16:22 -0500
Message-ID: <20240131201622.3409726-3-kent.overstreet@linux.dev>
In-Reply-To: <20240131201622.3409726-1-kent.overstreet@linux.dev>
References: <20240131201622.3409726-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Recently a severe performance regression was discovered, which bisected
to

  a6548c8b5eb5 bcachefs: Avoid flushing the journal in the discard path

It turns out the old behaviour, which issued excessive journal flushes,
worked around a performance issue where queueing delays would cause the
journal to not be able to write quickly enough and stall.

The journal flushes masked the issue because they periodically flushed
the device write cache, reducing write latency for non flushes.

This patch reworks the journalling code to allow more than one
(non-flush) write to be in flight at a time. With this patch, doing 4k
random writes and an iodepth of 128, we are now able to hit 560k iops to
a Samsung 970 EVO Plus - previously, we were stuck in the ~200k range.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 47 +++++++++++++++----
 fs/bcachefs/journal.h       |  7 +--
 fs/bcachefs/journal_io.c    | 94 ++++++++++++++++++++-----------------
 fs/bcachefs/journal_types.h | 11 +++--
 4 files changed, 99 insertions(+), 60 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 3508871cfd8a..c040f69dfb5c 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -74,6 +74,13 @@ static void bch2_journal_buf_to_text(struct printbuf *out, struct journal *j, u6
 	prt_printf(out, "%li jiffies", buf->expires - jiffies);
 	prt_newline(out);
 
+	if (buf->write_done)
+		prt_printf(out, "write done\n");
+	else if (buf->write_allocated)
+		prt_printf(out, "write allocated\n");
+	else if (buf->write_started)
+		prt_printf(out, "write started\n");
+
 	printbuf_indent_sub(out, 2);
 }
 
@@ -175,21 +182,40 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	return stuck;
 }
 
+void bch2_journal_do_writes(struct journal *j)
+{
+	for (u64 seq = journal_last_unwritten_seq(j);
+	     seq <= journal_cur_seq(j);
+	     seq++) {
+		unsigned idx = seq & JOURNAL_BUF_MASK;
+		struct journal_buf *w = j->buf + idx;
+
+		if (w->write_started && !w->write_allocated)
+			break;
+		if (w->write_started)
+			continue;
+
+		if (!journal_state_count(j->reservations, idx)) {
+			w->write_started = true;
+			closure_call(&w->io, bch2_journal_write, j->wq, NULL);
+		}
+
+		break;
+	}
+}
+
 /*
  * Final processing when the last reference of a journal buffer has been
  * dropped. Drop the pin list reference acquired at journal entry open and write
  * the buffer, if requested.
  */
-void bch2_journal_buf_put_final(struct journal *j, u64 seq, bool write)
+void bch2_journal_buf_put_final(struct journal *j, u64 seq)
 {
 	lockdep_assert_held(&j->lock);
 
 	if (__bch2_journal_pin_put(j, seq))
 		bch2_journal_reclaim_fast(j);
-	if (write) {
-		struct journal_buf *w = j->buf + (seq & JOURNAL_BUF_MASK);
-		closure_call(&w->io, bch2_journal_write, j->wq, NULL);
-	}
+	bch2_journal_do_writes(j);
 }
 
 /*
@@ -381,11 +407,14 @@ static int journal_entry_open(struct journal *j)
 	BUG_ON(j->buf + (journal_cur_seq(j) & JOURNAL_BUF_MASK) != buf);
 
 	bkey_extent_init(&buf->key);
-	buf->noflush	= false;
-	buf->must_flush	= false;
-	buf->separate_flush = false;
-	buf->flush_time	= 0;
+	buf->noflush		= false;
+	buf->must_flush		= false;
+	buf->separate_flush	= false;
+	buf->flush_time		= 0;
 	buf->need_flush_to_write_buffer = true;
+	buf->write_started	= false;
+	buf->write_allocated	= false;
+	buf->write_done		= false;
 
 	memset(buf->data, 0, sizeof(*buf->data));
 	buf->data->seq	= cpu_to_le64(journal_cur_seq(j));
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 4544ce24bb8a..7c7528f839c5 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -264,7 +264,8 @@ static inline union journal_res_state journal_state_buf_put(struct journal *j, u
 }
 
 bool bch2_journal_entry_close(struct journal *);
-void bch2_journal_buf_put_final(struct journal *, u64, bool);
+void bch2_journal_do_writes(struct journal *);
+void bch2_journal_buf_put_final(struct journal *, u64);
 
 static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
 {
@@ -272,7 +273,7 @@ static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 s
 
 	s = journal_state_buf_put(j, idx);
 	if (!journal_state_count(s, idx))
-		bch2_journal_buf_put_final(j, seq, idx == s.unwritten_idx);
+		bch2_journal_buf_put_final(j, seq);
 }
 
 static inline void bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
@@ -282,7 +283,7 @@ static inline void bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq
 	s = journal_state_buf_put(j, idx);
 	if (!journal_state_count(s, idx)) {
 		spin_lock(&j->lock);
-		bch2_journal_buf_put_final(j, seq, idx == s.unwritten_idx);
+		bch2_journal_buf_put_final(j, seq);
 		spin_unlock(&j->lock);
 	}
 }
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 8dbf3b3fac32..388e8e15691a 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1600,12 +1600,12 @@ static CLOSURE_CALLBACK(journal_write_done)
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	struct bch_replicas_padded replicas;
 	union journal_res_state old, new;
-	u64 v, seq;
+	u64 v, seq = le64_to_cpu(w->data->seq);
 	int err = 0;
 
 	time_stats_update(!JSET_NO_FLUSH(w->data)
-			       ? j->flush_write_time
-			       : j->noflush_write_time, j->write_start_time);
+			  ? j->flush_write_time
+			  : j->noflush_write_time, j->write_start_time);
 
 	if (!w->devs_written.nr) {
 		bch_err(c, "unable to write journal to sufficient devices");
@@ -1620,63 +1620,68 @@ static CLOSURE_CALLBACK(journal_write_done)
 	if (err)
 		bch2_fatal_error(c);
 
-	spin_lock(&j->lock);
-	seq = le64_to_cpu(w->data->seq);
+	closure_debug_destroy(cl);
 
+	spin_lock(&j->lock);
 	if (seq >= j->pin.front)
 		journal_seq_pin(j, seq)->devs = w->devs_written;
+	if (err && (!j->err_seq || seq < j->err_seq))
+		j->err_seq	= seq;
+	w->write_done = true;
+
+	bool completed = false;
+
+	for (seq = journal_last_unwritten_seq(j);
+	     seq <= journal_cur_seq(j);
+	     seq++) {
+		w = j->buf + (seq & JOURNAL_BUF_MASK);
+		if (!w->write_done)
+			break;
 
-	if (!err) {
-		if (!JSET_NO_FLUSH(w->data)) {
+		if (!j->err_seq && !JSET_NO_FLUSH(w->data)) {
 			j->flushed_seq_ondisk = seq;
 			j->last_seq_ondisk = w->last_seq;
 
 			bch2_do_discards(c);
 			closure_wake_up(&c->freelist_wait);
-
 			bch2_reset_alloc_cursors(c);
 		}
-	} else if (!j->err_seq || seq < j->err_seq)
-		j->err_seq	= seq;
 
-	j->seq_ondisk		= seq;
+		j->seq_ondisk = seq;
 
-	/*
-	 * Updating last_seq_ondisk may let bch2_journal_reclaim_work() discard
-	 * more buckets:
-	 *
-	 * Must come before signaling write completion, for
-	 * bch2_fs_journal_stop():
-	 */
-	if (j->watermark != BCH_WATERMARK_stripe)
-		journal_reclaim_kick(&c->journal);
+		/*
+		 * Updating last_seq_ondisk may let bch2_journal_reclaim_work() discard
+		 * more buckets:
+		 *
+		 * Must come before signaling write completion, for
+		 * bch2_fs_journal_stop():
+		 */
+		if (j->watermark != BCH_WATERMARK_stripe)
+			journal_reclaim_kick(&c->journal);
 
-	/* also must come before signalling write completion: */
-	closure_debug_destroy(cl);
+		v = atomic64_read(&j->reservations.counter);
+		do {
+			old.v = new.v = v;
+			BUG_ON(journal_state_count(new, new.unwritten_idx));
+			BUG_ON(new.unwritten_idx != (seq & JOURNAL_BUF_MASK));
 
-	v = atomic64_read(&j->reservations.counter);
-	do {
-		old.v = new.v = v;
-		BUG_ON(journal_state_count(new, new.unwritten_idx));
+			new.unwritten_idx++;
+		} while ((v = atomic64_cmpxchg(&j->reservations.counter, old.v, new.v)) != old.v);
 
-		new.unwritten_idx++;
-	} while ((v = atomic64_cmpxchg(&j->reservations.counter,
-				       old.v, new.v)) != old.v);
+		completed = true;
+	}
 
-	bch2_journal_reclaim_fast(j);
-	bch2_journal_space_available(j);
+	if (completed) {
+		bch2_journal_reclaim_fast(j);
+		bch2_journal_space_available(j);
 
-	track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight], false);
+		track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight], false);
 
-	closure_wake_up(&w->wait);
-	journal_wake(j);
+		closure_wake_up(&w->wait);
+		journal_wake(j);
+	}
 
-	if (!journal_state_count(new, new.unwritten_idx) &&
-	    journal_last_unwritten_seq(j) <= journal_cur_seq(j)) {
-		struct journal_buf *w = j->buf + (journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK);
-		spin_unlock(&j->lock);
-		closure_call(&w->io, bch2_journal_write, j->wq, NULL);
-	} else if (journal_last_unwritten_seq(j) == journal_cur_seq(j) &&
+	if (journal_last_unwritten_seq(j) == journal_cur_seq(j) &&
 		   new.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL) {
 		struct journal_buf *buf = journal_cur_buf(j);
 		long delta = buf->expires - jiffies;
@@ -1686,12 +1691,10 @@ static CLOSURE_CALLBACK(journal_write_done)
 		 * previous entries still in flight - the current journal entry
 		 * might want to be written now:
 		 */
-
-		spin_unlock(&j->lock);
 		mod_delayed_work(j->wq, &j->write_work, max(0L, delta));
-	} else {
-		spin_unlock(&j->lock);
 	}
+
+	spin_unlock(&j->lock);
 }
 
 static void journal_write_endio(struct bio *bio)
@@ -1945,6 +1948,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
 	int ret;
 
 	BUG_ON(BCH_SB_CLEAN(c->disk_sb.sb));
+	BUG_ON(w->write_allocated);
 
 	j->write_start_time = local_clock();
 
@@ -1988,12 +1992,14 @@ CLOSURE_CALLBACK(bch2_journal_write)
 	 * bch2_journal_space_available():
 	 */
 	w->sectors = 0;
+	w->write_allocated = true;
 
 	/*
 	 * journal entry has been compacted and allocated, recalculate space
 	 * available:
 	 */
 	bch2_journal_space_available(j);
+	bch2_journal_do_writes(j);
 	spin_unlock(&j->lock);
 
 	w->devs_written = bch2_bkey_devs(bkey_i_to_s_c(&w->key));
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 4f7769aede33..011f7a0d4ebd 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -34,10 +34,13 @@ struct journal_buf {
 	unsigned		disk_sectors;	/* maximum size entry could have been, if
 						   buf_size was bigger */
 	unsigned		u64s_reserved;
-	bool			noflush;	/* write has already been kicked off, and was noflush */
-	bool			must_flush;	/* something wants a flush */
-	bool			separate_flush;
-	bool			need_flush_to_write_buffer;
+	bool			noflush:1;	/* write has already been kicked off, and was noflush */
+	bool			must_flush:1;	/* something wants a flush */
+	bool			separate_flush:1;
+	bool			need_flush_to_write_buffer:1;
+	bool			write_started:1;
+	bool			write_allocated:1;
+	bool			write_done:1;
 	u8			idx;
 };
 
-- 
2.43.0

