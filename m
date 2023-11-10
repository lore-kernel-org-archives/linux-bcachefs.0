Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0DA38DCB
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FtnGp7py"
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DDD23EB04
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:06 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fWFpJ3joTuAHmJpqfqCcvvdjQT/2i5NARZ1vVC3E/HY=;
	b=FtnGp7pypXQ1HRubtsTiymhvquD5jKGAxm4NaGe+Yu441sahFIcqM/o3XMnxVlFqboUU09
	KvbrTZYPwQhOCfdZtMlqH1Mwu8LPj+2Hy07cNPViYmrIp6MhQ6amvjcys+xSAMq/WuHvEg
	ze06UuK/kXmZqj4Zd9ck15mN1ndc3NI=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 02/17] bcachefs: track_event_change()
Date: Fri, 10 Nov 2023 11:31:39 -0500
Message-ID: <20231110163157.2736111-3-kent.overstreet@linux.dev>
In-Reply-To: <20231110163157.2736111-1-kent.overstreet@linux.dev>
References: <20231110163157.2736111-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This introduces a new helper for connecting time_stats to state changes,
i.e. when taking journal reservations is blocked for some reason.

We use this to track separately the different reasons the journal might
be blocked - i.e. space in the journal full, or the journal pin fifo
full.

Also do some cleanup and improvements on the time stats code.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/bcachefs.h        |   4 +-
 fs/bcachefs/journal.c         |  16 +---
 fs/bcachefs/journal_io.c      |   3 +
 fs/bcachefs/journal_reclaim.c |  27 ++++---
 fs/bcachefs/journal_types.h   |   6 +-
 fs/bcachefs/super.c           |   3 +-
 fs/bcachefs/util.c            | 140 +++++++++++++++++++---------------
 fs/bcachefs/util.h            |  33 +++++++-
 8 files changed, 140 insertions(+), 92 deletions(-)

diff --git a/fs/bcachefs/bcachefs.h b/fs/bcachefs/bcachefs.h
index 403aa3389fcc..3117ab4426a7 100644
--- a/fs/bcachefs/bcachefs.h
+++ b/fs/bcachefs/bcachefs.h
@@ -401,7 +401,9 @@ BCH_DEBUG_PARAMS_DEBUG()
 	x(journal_flush_write)			\
 	x(journal_noflush_write)		\
 	x(journal_flush_seq)			\
-	x(blocked_journal)			\
+	x(blocked_journal_low_on_space)		\
+	x(blocked_journal_low_on_pin)		\
+	x(blocked_journal_max_in_flight)	\
 	x(blocked_allocate)			\
 	x(blocked_allocate_open_bucket)		\
 	x(nocow_lock_contended)
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 46eba1072940..7d448136434b 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -361,11 +361,6 @@ static int journal_entry_open(struct journal *j)
 	} while ((v = atomic64_cmpxchg(&j->reservations.counter,
 				       old.v, new.v)) != old.v);
 
-	if (j->res_get_blocked_start)
-		bch2_time_stats_update(j->blocked_time,
-				       j->res_get_blocked_start);
-	j->res_get_blocked_start = 0;
-
 	mod_delayed_work(c->io_complete_wq,
 			 &j->write_work,
 			 msecs_to_jiffies(c->opts.journal_flush_delay));
@@ -465,15 +460,12 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 	__journal_entry_close(j, JOURNAL_ENTRY_CLOSED_VAL);
 	ret = journal_entry_open(j);
 
-	if (ret == JOURNAL_ERR_max_in_flight)
+	if (ret == JOURNAL_ERR_max_in_flight) {
+		track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight],
+				   &j->max_in_flight_start, true);
 		trace_and_count(c, journal_entry_full, c);
-unlock:
-	if ((ret && ret != JOURNAL_ERR_insufficient_devices) &&
-	    !j->res_get_blocked_start) {
-		j->res_get_blocked_start = local_clock() ?: 1;
-		trace_and_count(c, journal_full, c);
 	}
-
+unlock:
 	can_discard = j->can_discard;
 	spin_unlock(&j->lock);
 
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 25dbeb0396b2..52a59770d8d0 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1585,6 +1585,9 @@ static void journal_write_done(struct closure *cl)
 
 	bch2_journal_space_available(j);
 
+	track_event_change(&c->times[BCH_TIME_blocked_journal_max_in_flight],
+			   &j->max_in_flight_start, false);
+
 	closure_wake_up(&w->wait);
 	journal_wake(j);
 
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index b3b822170b2c..79a6fdc6e6ef 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -50,17 +50,21 @@ unsigned bch2_journal_dev_buckets_available(struct journal *j,
 	return available;
 }
 
-static inline void journal_set_watermark(struct journal *j, bool low_on_space)
+static inline void journal_set_watermark(struct journal *j)
 {
-	unsigned watermark = BCH_WATERMARK_stripe;
-
-	if (low_on_space)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
-	if (fifo_free(&j->pin) < j->pin.size / 4)
-		watermark = max_t(unsigned, watermark, BCH_WATERMARK_reclaim);
-
-	if (watermark == j->watermark)
-		return;
+	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	bool low_on_space = j->space[journal_space_clean].total * 4 <=
+		j->space[journal_space_total].total;
+	bool low_on_pin = fifo_free(&j->pin) < j->pin.size / 4;
+	unsigned watermark = low_on_space || low_on_pin
+		? BCH_WATERMARK_reclaim
+		: BCH_WATERMARK_stripe;
+
+	if (track_event_change(&c->times[BCH_TIME_blocked_journal_low_on_space],
+			       &j->low_on_space_start, low_on_space) ||
+	    track_event_change(&c->times[BCH_TIME_blocked_journal_low_on_pin],
+			       &j->low_on_pin_start, low_on_pin))
+		trace_and_count(c, journal_full, c);
 
 	swap(watermark, j->watermark);
 	if (watermark > j->watermark)
@@ -226,7 +230,7 @@ void bch2_journal_space_available(struct journal *j)
 	else
 		clear_bit(JOURNAL_MAY_SKIP_FLUSH, &j->flags);
 
-	journal_set_watermark(j, clean * 4 <= total);
+	journal_set_watermark(j);
 out:
 	j->cur_entry_sectors	= !ret ? j->space[journal_space_discarded].next_entry : 0;
 	j->cur_entry_error	= ret;
@@ -828,6 +832,7 @@ static int journal_flush_done(struct journal *j, u64 seq_to_flush,
 
 bool bch2_journal_flush_pins(struct journal *j, u64 seq_to_flush)
 {
+	/* time_stats this */
 	bool did_work = false;
 
 	if (!test_bit(JOURNAL_STARTED, &j->flags))
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 1acce6ecfca0..2427cce64fed 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -262,16 +262,18 @@ struct journal {
 
 	unsigned long		last_flush_write;
 
-	u64			res_get_blocked_start;
 	u64			write_start_time;
 
 	u64			nr_flush_writes;
 	u64			nr_noflush_writes;
 	u64			entry_bytes_written;
 
+	u64			low_on_space_start;
+	u64			low_on_pin_start;
+	u64			max_in_flight_start;
+
 	struct bch2_time_stats	*flush_write_time;
 	struct bch2_time_stats	*noflush_write_time;
-	struct bch2_time_stats	*blocked_time;
 	struct bch2_time_stats	*flush_seq_time;
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 24672bb31cbe..bb9451082e87 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -641,7 +641,9 @@ static int bch2_fs_online(struct bch_fs *c)
 	ret = kobject_add(&c->kobj, NULL, "%pU", c->sb.user_uuid.b) ?:
 	    kobject_add(&c->internal, &c->kobj, "internal") ?:
 	    kobject_add(&c->opts_dir, &c->kobj, "options") ?:
+#ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
 	    kobject_add(&c->time_stats, &c->kobj, "time_stats") ?:
+#endif
 	    kobject_add(&c->counters_kobj, &c->kobj, "counters") ?:
 	    bch2_opts_create_sysfs_files(&c->opts_dir);
 	if (ret) {
@@ -750,7 +752,6 @@ static struct bch_fs *bch2_fs_alloc(struct bch_sb *sb, struct bch_opts opts)
 
 	c->journal.flush_write_time	= &c->times[BCH_TIME_journal_flush_write];
 	c->journal.noflush_write_time	= &c->times[BCH_TIME_journal_noflush_write];
-	c->journal.blocked_time		= &c->times[BCH_TIME_blocked_journal];
 	c->journal.flush_seq_time	= &c->times[BCH_TIME_journal_flush_seq];
 
 	bch2_fs_btree_cache_init_early(&c->btree_cache);
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index eefe7b42a20a..2ff9cdfb006c 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -315,6 +315,57 @@ int bch2_prt_task_backtrace(struct printbuf *out, struct task_struct *task)
 	return ret;
 }
 
+#ifndef __KERNEL__
+#include <time.h>
+void bch2_prt_datetime(struct printbuf *out, time64_t sec)
+{
+	time_t t = sec;
+	char buf[64];
+	ctime_r(&t, buf);
+	prt_str(out, buf);
+}
+#else
+void bch2_prt_datetime(struct printbuf *out, time64_t sec)
+{
+	char buf[64];
+	snprintf(buf, sizeof(buf), "%ptT", &sec);
+	prt_u64(out, sec);
+}
+#endif
+
+static const struct time_unit {
+	const char	*name;
+	u64		nsecs;
+} time_units[] = {
+	{ "ns",		1		 },
+	{ "us",		NSEC_PER_USEC	 },
+	{ "ms",		NSEC_PER_MSEC	 },
+	{ "s",		NSEC_PER_SEC	 },
+	{ "m",          (u64) NSEC_PER_SEC * 60},
+	{ "h",          (u64) NSEC_PER_SEC * 3600},
+	{ "eon",        U64_MAX          },
+};
+
+static const struct time_unit *pick_time_units(u64 ns)
+{
+	const struct time_unit *u;
+
+	for (u = time_units;
+	     u + 1 < time_units + ARRAY_SIZE(time_units) &&
+	     ns >= u[1].nsecs << 1;
+	     u++)
+		;
+
+	return u;
+}
+
+void bch2_pr_time_units(struct printbuf *out, u64 ns)
+{
+	const struct time_unit *u = pick_time_units(ns);
+
+	prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+}
+
 /* time stats: */
 
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
@@ -359,6 +410,7 @@ static inline void bch2_time_stats_update_one(struct bch2_time_stats *stats,
 		mean_and_variance_weighted_update(&stats->duration_stats_weighted, duration);
 		stats->max_duration = max(stats->max_duration, duration);
 		stats->min_duration = min(stats->min_duration, duration);
+		stats->total_duration += duration;
 		bch2_quantiles_update(&stats->quantiles, duration);
 	}
 
@@ -372,20 +424,24 @@ static inline void bch2_time_stats_update_one(struct bch2_time_stats *stats,
 	}
 }
 
+static void __bch2_time_stats_clear_buffer(struct bch2_time_stats *stats,
+					   struct bch2_time_stat_buffer *b)
+{
+	for (struct bch2_time_stat_buffer_entry *i = b->entries;
+	     i < b->entries + ARRAY_SIZE(b->entries);
+	     i++)
+		bch2_time_stats_update_one(stats, i->start, i->end);
+	b->nr = 0;
+}
+
 static noinline void bch2_time_stats_clear_buffer(struct bch2_time_stats *stats,
 						  struct bch2_time_stat_buffer *b)
 {
-	struct bch2_time_stat_buffer_entry *i;
 	unsigned long flags;
 
 	spin_lock_irqsave(&stats->lock, flags);
-	for (i = b->entries;
-	     i < b->entries + ARRAY_SIZE(b->entries);
-	     i++)
-		bch2_time_stats_update_one(stats, i->start, i->end);
+	__bch2_time_stats_clear_buffer(stats, b);
 	spin_unlock_irqrestore(&stats->lock, flags);
-
-	b->nr = 0;
 }
 
 void __bch2_time_stats_update(struct bch2_time_stats *stats, u64 start, u64 end)
@@ -423,40 +479,6 @@ void __bch2_time_stats_update(struct bch2_time_stats *stats, u64 start, u64 end)
 		preempt_enable();
 	}
 }
-#endif
-
-static const struct time_unit {
-	const char	*name;
-	u64		nsecs;
-} time_units[] = {
-	{ "ns",		1		 },
-	{ "us",		NSEC_PER_USEC	 },
-	{ "ms",		NSEC_PER_MSEC	 },
-	{ "s",		NSEC_PER_SEC	 },
-	{ "m",          (u64) NSEC_PER_SEC * 60},
-	{ "h",          (u64) NSEC_PER_SEC * 3600},
-	{ "eon",        U64_MAX          },
-};
-
-static const struct time_unit *pick_time_units(u64 ns)
-{
-	const struct time_unit *u;
-
-	for (u = time_units;
-	     u + 1 < time_units + ARRAY_SIZE(time_units) &&
-	     ns >= u[1].nsecs << 1;
-	     u++)
-		;
-
-	return u;
-}
-
-void bch2_pr_time_units(struct printbuf *out, u64 ns)
-{
-	const struct time_unit *u = pick_time_units(ns);
-
-	prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
-}
 
 static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
 {
@@ -467,26 +489,6 @@ static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
 	prt_printf(out, "%s", u->name);
 }
 
-#ifndef __KERNEL__
-#include <time.h>
-void bch2_prt_datetime(struct printbuf *out, time64_t sec)
-{
-	time_t t = sec;
-	char buf[64];
-	ctime_r(&t, buf);
-	prt_str(out, buf);
-}
-#else
-void bch2_prt_datetime(struct printbuf *out, time64_t sec)
-{
-	char buf[64];
-	snprintf(buf, sizeof(buf), "%ptT", &sec);
-	prt_u64(out, sec);
-}
-#endif
-
-#define TABSTOP_SIZE 12
-
 static inline void pr_name_and_units(struct printbuf *out, const char *name, u64 ns)
 {
 	prt_str(out, name);
@@ -495,12 +497,24 @@ static inline void pr_name_and_units(struct printbuf *out, const char *name, u64
 	prt_newline(out);
 }
 
+#define TABSTOP_SIZE 12
+
 void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats)
 {
 	const struct time_unit *u;
 	s64 f_mean = 0, d_mean = 0;
 	u64 q, last_q = 0, f_stddev = 0, d_stddev = 0;
 	int i;
+
+	if (stats->buffer) {
+		int cpu;
+
+		spin_lock_irq(&stats->lock);
+		for_each_possible_cpu(cpu)
+			__bch2_time_stats_clear_buffer(stats, per_cpu_ptr(stats->buffer, cpu));
+		spin_unlock_irq(&stats->lock);
+	}
+
 	/*
 	 * avoid divide by zero
 	 */
@@ -546,6 +560,7 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
 
 	pr_name_and_units(out, "min:", stats->min_duration);
 	pr_name_and_units(out, "max:", stats->max_duration);
+	pr_name_and_units(out, "total:", stats->total_duration);
 
 	prt_printf(out, "mean:");
 	prt_tab(out);
@@ -603,6 +618,9 @@ void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats
 		last_q = q;
 	}
 }
+#else
+void bch2_time_stats_to_text(struct printbuf *out, struct bch2_time_stats *stats) {}
+#endif
 
 void bch2_time_stats_exit(struct bch2_time_stats *stats)
 {
diff --git a/fs/bcachefs/util.h b/fs/bcachefs/util.h
index 977e1d9fa453..54e309d94b9b 100644
--- a/fs/bcachefs/util.h
+++ b/fs/bcachefs/util.h
@@ -372,8 +372,9 @@ struct bch2_time_stat_buffer {
 struct bch2_time_stats {
 	spinlock_t	lock;
 	/* all fields are in nanoseconds */
-	u64		max_duration;
 	u64             min_duration;
+	u64		max_duration;
+	u64		total_duration;
 	u64             max_freq;
 	u64             min_freq;
 	u64		last_event;
@@ -388,15 +389,39 @@ struct bch2_time_stats {
 
 #ifndef CONFIG_BCACHEFS_NO_LATENCY_ACCT
 void __bch2_time_stats_update(struct bch2_time_stats *stats, u64, u64);
-#else
-static inline void __bch2_time_stats_update(struct bch2_time_stats *stats, u64 start, u64 end) {}
-#endif
 
 static inline void bch2_time_stats_update(struct bch2_time_stats *stats, u64 start)
 {
 	__bch2_time_stats_update(stats, start, local_clock());
 }
 
+static inline bool track_event_change(struct bch2_time_stats *stats,
+				      u64 *start, bool v)
+{
+	if (v != !!*start) {
+		if (!v) {
+			bch2_time_stats_update(stats, *start);
+			*start = 0;
+		} else {
+			*start = local_clock() ?: 1;
+			return true;
+		}
+	}
+
+	return false;
+}
+#else
+static inline void __bch2_time_stats_update(struct bch2_time_stats *stats, u64 start, u64 end) {}
+static inline void bch2_time_stats_update(struct bch2_time_stats *stats, u64 start) {}
+static inline bool track_event_change(struct bch2_time_stats *stats,
+				      u64 *start, bool v)
+{
+	bool ret = v && !*start;
+	*start = v;
+	return ret;
+}
+#endif
+
 void bch2_time_stats_to_text(struct printbuf *, struct bch2_time_stats *);
 
 void bch2_time_stats_exit(struct bch2_time_stats *);
-- 
2.42.0

