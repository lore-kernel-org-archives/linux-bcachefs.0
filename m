Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDA6157A48
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 Jan 2025 04:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737951181; cv=none; b=NHK6/lqV6pepf6Q+Jc2Eo9WWAqs7+DdoJtykNq63nuusIFojLcD7gl3vSsQTXtoP+YAjhade8NFry/xF9J9qohZVSZ18B0EYnjN4DA1Cvp7Q6l9s/odwLQ+LtJMeQ9Q/uz3RFPOyvIyfVgXDoz9t1F7fjwcRlrhVFl2QBBb7XSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737951181; c=relaxed/simple;
	bh=XC6fDOBmLXOd9ROR7WqDdsg9Gq/H4FEbYj4naiTJCHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIKPdfIFfdPbUAVxXshmpx75ELuEuaIbSZwazrAJ3Q54U51uQxhi1jaLfGmeH3sHlfxMP1mmU7niiR4JQsKpWX9Et7pEqW8e61KTcwZvsXgtuZKt4nIwmvEVuqJAZPXg1DDRC2NH3nEWuqMHMZltGigSY4RvatH1Jk5XlyORP8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uYnSXSta; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uYnSXSta"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1737951176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VOpx2/zzM80iSicBJQSXRkqN6C3Po2jSaE63Uj5wlos=;
	b=uYnSXStas3OzLKEM5rWng+E1DSIT3aWXIuHW9I+BfvZZ3DAP9S0tqfN+qqAqGTeqJ1/hen
	X0zXHgWMddnRAGlisa21r3MotIRsUFjP5P8HzNPH1ggHw7lDOvIDoPkViHJZa3oQ3ets2a
	Z5cromNI82tX2uWD4udGUsI/aU9ozgE=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 08/11] bcachefs: Improve journal pin flushing
Date: Sun, 26 Jan 2025 23:12:34 -0500
Message-ID: <20250127041239.2693707-9-kent.overstreet@linux.dev>
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

Running the preempt tiering tests with a lower than normal journal
reclaim delay turned up a shutdown hang - a lost wakeup, caused because
flushing a journal pin (e.g. key cache/write buffer) can generate a new
journal pin.

The "simple" fix of adding the correct wakeup didn't work because of
ordering issues; if we flush btree node pins too aggressively before
other pins have completed, we end up spinning where each flush iteration
generates new work.

So to fix this correctly:
- The list of flushed journal pins is now broken out by type, so that
  we can wait for key cache/write buffer pin flushing to complete
  before flushing dirty btree nodes

- A new closure_waitlist is added for bch2_journal_flush_pins; this one
  is only used under or when we're taking the journal lock, so it's
  pretty cheap to add rigorously correct wakeups to journal_pin_set()
  and journal_pin_drop().

Additionally, bch2_journal_seq_pins_to_text() is moved to
journal_reclaim.c, where it belongs, along with a bit of other small
renaming and refactoring.

Besides fixing the hang, the better ordering between key cache/write
buffer flushing and btree node flushing should help or fix the "unmount
taking excessively long" a few users have been noticing.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/debug.c           |   1 +
 fs/bcachefs/journal.c         |  60 +-------------
 fs/bcachefs/journal.h         |   2 -
 fs/bcachefs/journal_reclaim.c | 142 +++++++++++++++++++++++++++++-----
 fs/bcachefs/journal_reclaim.h |   3 +
 fs/bcachefs/journal_types.h   |  13 ++--
 6 files changed, 136 insertions(+), 85 deletions(-)

diff --git a/fs/bcachefs/debug.c b/fs/bcachefs/debug.c
index b5de52a50d10..55333e82d1fe 100644
--- a/fs/bcachefs/debug.c
+++ b/fs/bcachefs/debug.c
@@ -20,6 +20,7 @@
 #include "extents.h"
 #include "fsck.h"
 #include "inode.h"
+#include "journal_reclaim.h"
 #include "super.h"
 
 #include <linux/console.h>
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 46d53d3ba018..cb2c3722f674 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -113,11 +113,10 @@ journal_seq_to_buf(struct journal *j, u64 seq)
 
 static void journal_pin_list_init(struct journal_entry_pin_list *p, int count)
 {
-	unsigned i;
-
-	for (i = 0; i < ARRAY_SIZE(p->list); i++)
-		INIT_LIST_HEAD(&p->list[i]);
-	INIT_LIST_HEAD(&p->flushed);
+	for (unsigned i = 0; i < ARRAY_SIZE(p->unflushed); i++)
+		INIT_LIST_HEAD(&p->unflushed[i]);
+	for (unsigned i = 0; i < ARRAY_SIZE(p->flushed); i++)
+		INIT_LIST_HEAD(&p->flushed[i]);
 	atomic_set(&p->count, count);
 	p->devs.nr = 0;
 }
@@ -1626,54 +1625,3 @@ void bch2_journal_debug_to_text(struct printbuf *out, struct journal *j)
 	__bch2_journal_debug_to_text(out, j);
 	spin_unlock(&j->lock);
 }
-
-bool bch2_journal_seq_pins_to_text(struct printbuf *out, struct journal *j, u64 *seq)
-{
-	struct journal_entry_pin_list *pin_list;
-	struct journal_entry_pin *pin;
-
-	spin_lock(&j->lock);
-	if (!test_bit(JOURNAL_running, &j->flags)) {
-		spin_unlock(&j->lock);
-		return true;
-	}
-
-	*seq = max(*seq, j->pin.front);
-
-	if (*seq >= j->pin.back) {
-		spin_unlock(&j->lock);
-		return true;
-	}
-
-	out->atomic++;
-
-	pin_list = journal_seq_pin(j, *seq);
-
-	prt_printf(out, "%llu: count %u\n", *seq, atomic_read(&pin_list->count));
-	printbuf_indent_add(out, 2);
-
-	for (unsigned i = 0; i < ARRAY_SIZE(pin_list->list); i++)
-		list_for_each_entry(pin, &pin_list->list[i], list)
-			prt_printf(out, "\t%px %ps\n", pin, pin->flush);
-
-	if (!list_empty(&pin_list->flushed))
-		prt_printf(out, "flushed:\n");
-
-	list_for_each_entry(pin, &pin_list->flushed, list)
-		prt_printf(out, "\t%px %ps\n", pin, pin->flush);
-
-	printbuf_indent_sub(out, 2);
-
-	--out->atomic;
-	spin_unlock(&j->lock);
-
-	return false;
-}
-
-void bch2_journal_pins_to_text(struct printbuf *out, struct journal *j)
-{
-	u64 seq = 0;
-
-	while (!bch2_journal_seq_pins_to_text(out, j, &seq))
-		seq++;
-}
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index a01dae1a57e3..dccddd5420ad 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -430,8 +430,6 @@ struct journal_buf *bch2_next_write_buffer_flush_journal_buf(struct journal *, u
 
 void __bch2_journal_debug_to_text(struct printbuf *, struct journal *);
 void bch2_journal_debug_to_text(struct printbuf *, struct journal *);
-void bch2_journal_pins_to_text(struct printbuf *, struct journal *);
-bool bch2_journal_seq_pins_to_text(struct printbuf *, struct journal *, u64 *);
 
 int bch2_set_nr_journal_buckets(struct bch_fs *, struct bch_dev *,
 				unsigned nr);
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 3c8242606da7..6a9cefb635d6 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -327,8 +327,10 @@ void bch2_journal_reclaim_fast(struct journal *j)
 		popped = true;
 	}
 
-	if (popped)
+	if (popped) {
 		bch2_journal_space_available(j);
+		__closure_wake_up(&j->reclaim_flush_wait);
+	}
 }
 
 bool __bch2_journal_pin_put(struct journal *j, u64 seq)
@@ -362,6 +364,9 @@ static inline bool __journal_pin_drop(struct journal *j,
 	pin->seq = 0;
 	list_del_init(&pin->list);
 
+	if (j->reclaim_flush_wait.list.first)
+		__closure_wake_up(&j->reclaim_flush_wait);
+
 	/*
 	 * Unpinning a journal entry may make journal_next_bucket() succeed, if
 	 * writing a new last_seq will now make another bucket available:
@@ -383,11 +388,11 @@ static enum journal_pin_type journal_pin_type(journal_pin_flush_fn fn)
 {
 	if (fn == bch2_btree_node_flush0 ||
 	    fn == bch2_btree_node_flush1)
-		return JOURNAL_PIN_btree;
+		return JOURNAL_PIN_TYPE_btree;
 	else if (fn == bch2_btree_key_cache_journal_flush)
-		return JOURNAL_PIN_key_cache;
+		return JOURNAL_PIN_TYPE_key_cache;
 	else
-		return JOURNAL_PIN_other;
+		return JOURNAL_PIN_TYPE_other;
 }
 
 static inline void bch2_journal_pin_set_locked(struct journal *j, u64 seq,
@@ -406,7 +411,12 @@ static inline void bch2_journal_pin_set_locked(struct journal *j, u64 seq,
 	atomic_inc(&pin_list->count);
 	pin->seq	= seq;
 	pin->flush	= flush_fn;
-	list_add(&pin->list, &pin_list->list[type]);
+
+	if (list_empty(&pin_list->unflushed[type]) &&
+	    j->reclaim_flush_wait.list.first)
+		__closure_wake_up(&j->reclaim_flush_wait);
+
+	list_add(&pin->list, &pin_list->unflushed[type]);
 }
 
 void bch2_journal_pin_copy(struct journal *j,
@@ -499,16 +509,15 @@ journal_get_next_pin(struct journal *j,
 {
 	struct journal_entry_pin_list *pin_list;
 	struct journal_entry_pin *ret = NULL;
-	unsigned i;
 
 	fifo_for_each_entry_ptr(pin_list, &j->pin, *seq) {
 		if (*seq > seq_to_flush && !allowed_above_seq)
 			break;
 
-		for (i = 0; i < JOURNAL_PIN_NR; i++)
-			if ((((1U << i) & allowed_below_seq) && *seq <= seq_to_flush) ||
-			    ((1U << i) & allowed_above_seq)) {
-				ret = list_first_entry_or_null(&pin_list->list[i],
+		for (unsigned i = 0; i < JOURNAL_PIN_TYPE_NR; i++)
+			if (((BIT(i) & allowed_below_seq) && *seq <= seq_to_flush) ||
+			    (BIT(i) & allowed_above_seq)) {
+				ret = list_first_entry_or_null(&pin_list->unflushed[i],
 					struct journal_entry_pin, list);
 				if (ret)
 					return ret;
@@ -544,8 +553,8 @@ static size_t journal_flush_pins(struct journal *j,
 		}
 
 		if (min_key_cache) {
-			allowed_above |= 1U << JOURNAL_PIN_key_cache;
-			allowed_below |= 1U << JOURNAL_PIN_key_cache;
+			allowed_above |= BIT(JOURNAL_PIN_TYPE_key_cache);
+			allowed_below |= BIT(JOURNAL_PIN_TYPE_key_cache);
 		}
 
 		cond_resched();
@@ -553,7 +562,9 @@ static size_t journal_flush_pins(struct journal *j,
 		j->last_flushed = jiffies;
 
 		spin_lock(&j->lock);
-		pin = journal_get_next_pin(j, seq_to_flush, allowed_below, allowed_above, &seq);
+		pin = journal_get_next_pin(j, seq_to_flush,
+					   allowed_below,
+					   allowed_above, &seq);
 		if (pin) {
 			BUG_ON(j->flush_in_progress);
 			j->flush_in_progress = pin;
@@ -576,7 +587,7 @@ static size_t journal_flush_pins(struct journal *j,
 		spin_lock(&j->lock);
 		/* Pin might have been dropped or rearmed: */
 		if (likely(!err && !j->flush_in_progress_dropped))
-			list_move(&pin->list, &journal_seq_pin(j, seq)->flushed);
+			list_move(&pin->list, &journal_seq_pin(j, seq)->flushed[journal_pin_type(flush_fn)]);
 		j->flush_in_progress = NULL;
 		j->flush_in_progress_dropped = false;
 		spin_unlock(&j->lock);
@@ -816,10 +827,41 @@ int bch2_journal_reclaim_start(struct journal *j)
 	return 0;
 }
 
+static bool journal_pins_still_flushing(struct journal *j, u64 seq_to_flush,
+					unsigned types)
+{
+	struct journal_entry_pin_list *pin_list;
+	u64 seq;
+
+	spin_lock(&j->lock);
+	fifo_for_each_entry_ptr(pin_list, &j->pin, seq) {
+		if (seq > seq_to_flush)
+			break;
+
+		for (unsigned i = 0; i < JOURNAL_PIN_TYPE_NR; i++)
+			if ((BIT(i) & types) &&
+			    (!list_empty(&pin_list->unflushed[i]) ||
+			     !list_empty(&pin_list->flushed[i]))) {
+				spin_unlock(&j->lock);
+				return true;
+			}
+	}
+	spin_unlock(&j->lock);
+
+	return false;
+}
+
+static bool journal_flush_pins_or_still_flushing(struct journal *j, u64 seq_to_flush,
+						 unsigned types)
+{
+	return  journal_flush_pins(j, seq_to_flush, types, 0, 0, 0) ||
+		journal_pins_still_flushing(j, seq_to_flush, types);
+}
+
 static int journal_flush_done(struct journal *j, u64 seq_to_flush,
 			      bool *did_work)
 {
-	int ret;
+	int ret = 0;
 
 	ret = bch2_journal_error(j);
 	if (ret)
@@ -827,12 +869,18 @@ static int journal_flush_done(struct journal *j, u64 seq_to_flush,
 
 	mutex_lock(&j->reclaim_lock);
 
-	if (journal_flush_pins(j, seq_to_flush,
-			       (1U << JOURNAL_PIN_key_cache)|
-			       (1U << JOURNAL_PIN_other), 0, 0, 0) ||
-	    journal_flush_pins(j, seq_to_flush,
-			       (1U << JOURNAL_PIN_btree), 0, 0, 0))
+	if (journal_flush_pins_or_still_flushing(j, seq_to_flush,
+			       BIT(JOURNAL_PIN_TYPE_key_cache)|
+			       BIT(JOURNAL_PIN_TYPE_other))) {
+		*did_work = true;
+		goto unlock;
+	}
+
+	if (journal_flush_pins_or_still_flushing(j, seq_to_flush,
+			       BIT(JOURNAL_PIN_TYPE_btree))) {
 		*did_work = true;
+		goto unlock;
+	}
 
 	if (seq_to_flush > journal_cur_seq(j))
 		bch2_journal_entry_close(j);
@@ -847,6 +895,7 @@ static int journal_flush_done(struct journal *j, u64 seq_to_flush,
 		!fifo_used(&j->pin);
 
 	spin_unlock(&j->lock);
+unlock:
 	mutex_unlock(&j->reclaim_lock);
 
 	return ret;
@@ -860,7 +909,7 @@ bool bch2_journal_flush_pins(struct journal *j, u64 seq_to_flush)
 	if (!test_bit(JOURNAL_running, &j->flags))
 		return false;
 
-	closure_wait_event(&j->async_wait,
+	closure_wait_event(&j->reclaim_flush_wait,
 		journal_flush_done(j, seq_to_flush, &did_work));
 
 	return did_work;
@@ -926,3 +975,54 @@ int bch2_journal_flush_device_pins(struct journal *j, int dev_idx)
 
 	return ret;
 }
+
+bool bch2_journal_seq_pins_to_text(struct printbuf *out, struct journal *j, u64 *seq)
+{
+	struct journal_entry_pin_list *pin_list;
+	struct journal_entry_pin *pin;
+
+	spin_lock(&j->lock);
+	if (!test_bit(JOURNAL_running, &j->flags)) {
+		spin_unlock(&j->lock);
+		return true;
+	}
+
+	*seq = max(*seq, j->pin.front);
+
+	if (*seq >= j->pin.back) {
+		spin_unlock(&j->lock);
+		return true;
+	}
+
+	out->atomic++;
+
+	pin_list = journal_seq_pin(j, *seq);
+
+	prt_printf(out, "%llu: count %u\n", *seq, atomic_read(&pin_list->count));
+	printbuf_indent_add(out, 2);
+
+	prt_printf(out, "unflushed:\n");
+	for (unsigned i = 0; i < ARRAY_SIZE(pin_list->unflushed); i++)
+		list_for_each_entry(pin, &pin_list->unflushed[i], list)
+			prt_printf(out, "\t%px %ps\n", pin, pin->flush);
+
+	prt_printf(out, "flushed:\n");
+	for (unsigned i = 0; i < ARRAY_SIZE(pin_list->flushed); i++)
+		list_for_each_entry(pin, &pin_list->flushed[i], list)
+			prt_printf(out, "\t%px %ps\n", pin, pin->flush);
+
+	printbuf_indent_sub(out, 2);
+
+	--out->atomic;
+	spin_unlock(&j->lock);
+
+	return false;
+}
+
+void bch2_journal_pins_to_text(struct printbuf *out, struct journal *j)
+{
+	u64 seq = 0;
+
+	while (!bch2_journal_seq_pins_to_text(out, j, &seq))
+		seq++;
+}
diff --git a/fs/bcachefs/journal_reclaim.h b/fs/bcachefs/journal_reclaim.h
index ec84c3345281..0a73d7134e1c 100644
--- a/fs/bcachefs/journal_reclaim.h
+++ b/fs/bcachefs/journal_reclaim.h
@@ -78,4 +78,7 @@ static inline bool bch2_journal_flush_all_pins(struct journal *j)
 
 int bch2_journal_flush_device_pins(struct journal *, int);
 
+void bch2_journal_pins_to_text(struct printbuf *, struct journal *);
+bool bch2_journal_seq_pins_to_text(struct printbuf *, struct journal *, u64 *);
+
 #endif /* _BCACHEFS_JOURNAL_RECLAIM_H */
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index e9bd716fbb71..3ba433a48eb8 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -53,15 +53,15 @@ struct journal_buf {
  */
 
 enum journal_pin_type {
-	JOURNAL_PIN_btree,
-	JOURNAL_PIN_key_cache,
-	JOURNAL_PIN_other,
-	JOURNAL_PIN_NR,
+	JOURNAL_PIN_TYPE_btree,
+	JOURNAL_PIN_TYPE_key_cache,
+	JOURNAL_PIN_TYPE_other,
+	JOURNAL_PIN_TYPE_NR,
 };
 
 struct journal_entry_pin_list {
-	struct list_head		list[JOURNAL_PIN_NR];
-	struct list_head		flushed;
+	struct list_head		unflushed[JOURNAL_PIN_TYPE_NR];
+	struct list_head		flushed[JOURNAL_PIN_TYPE_NR];
 	atomic_t			count;
 	struct bch_devs_list		devs;
 };
@@ -226,6 +226,7 @@ struct journal {
 	/* Used when waiting because the journal was full */
 	wait_queue_head_t	wait;
 	struct closure_waitlist	async_wait;
+	struct closure_waitlist	reclaim_flush_wait;
 
 	struct delayed_work	write_work;
 	struct workqueue_struct *wq;
-- 
2.45.2

