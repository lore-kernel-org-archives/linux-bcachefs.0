Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF6A2AC17
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 01:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738805359; cv=none; b=ua6OocP+xHVYxl88iaRP5579O4viwQp/aOKVLaDPk8YpOlFxu1CfU5YQLkVjebg9Ojvh8FQ7gt6LMhsTQWjajVwnKoSU4euHLjR+mLhbDo4puyflWbzdX1p+jGvNREaMUNNmKPQJKkgSf+SWIyhEtEZZahiU4saNv33wrEyc5js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738805359; c=relaxed/simple;
	bh=p9EU3hKQgpQtG/fnF/W7aq5R2f7ecTkyZgu8WgFMoGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DnMeVQyG9aii7uKeBIEoPidmM/n0vJ24XfvJwXHPMpIzTeUi6tjVReH+IpvnJAIgi6dNEQjPhxtsv5DHj1pGatdqK7zqqKJoxUe04S37lGjOjXzewUkKvaYo8cuXwmRWi0foM1QSSLl444NwBsSAbT8DLjTcIFLeVcojiGbPWH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=A3/P2rhb; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="A3/P2rhb"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738805356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pydqTVGCm9v6Ipr2v/C2B0HSzOSw1NWBjyDyaBd/RbI=;
	b=A3/P2rhbjfMD16HKNdsfvP8o/ibV2io8BkchU87/il3gFnnE+kZ1FN3eGxADzocHDkTqho
	FwBE1XIGRy2EiWjapbBfDuoyqhymVmkfpX/b2/rOIGO0CFa0wf+wnIbQn9gaAiQ2zip5GE
	9bsAMtRW7ZzdoznEDWZoOc3mUtnl708=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org,
	linux-kerenl@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/5] bcachefs: Free journal bufs when not in use
Date: Wed,  5 Feb 2025 20:28:49 -0500
Message-ID: <20250206012852.1658754-5-kent.overstreet@linux.dev>
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

Since we're increasing the number of 'struct journal_bufs', we don't
want them all permanently holding onto buffers for the journal data -
that'd be 16 * 2MB = 32MB, or potentially more.

Add a single-element mempool (open coded, since buffer size varies),
this also means we won't be hitting the memory allocator every time we
open and close a journal entry/buffer.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 63 +++++++++++++++++++++++++++++++------
 fs/bcachefs/journal_io.c    | 15 ++++++++-
 fs/bcachefs/journal_types.h |  3 ++
 3 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 20b748f61b21..8fbdb0bbb536 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -58,9 +58,12 @@ static void bch2_journal_buf_to_text(struct printbuf *out, struct journal *j, u6
 
 	prt_printf(out, "refcount:\t%u\n", journal_state_count(s, i));
 
-	prt_printf(out, "size:\t");
-	prt_human_readable_u64(out, vstruct_bytes(buf->data));
-	prt_newline(out);
+	struct jset *data = READ_ONCE(buf->data);
+	if (data) {
+		prt_printf(out, "size:\t");
+		prt_human_readable_u64(out, vstruct_bytes(data));
+		prt_newline(out);
+	}
 
 	prt_printf(out, "expires:\t");
 	prt_printf(out, "%li jiffies\n", buf->expires - jiffies);
@@ -398,8 +401,16 @@ static int journal_entry_open(struct journal *j)
 		return JOURNAL_ERR_insufficient_devices; /* -EROFS */
 	}
 
+	if (!j->free_buf && !buf->data)
+		return JOURNAL_ERR_enomem; /* will retry after write completion frees up a buf */
+
 	BUG_ON(!j->cur_entry_sectors);
 
+	if (!buf->data) {
+		swap(buf->data,		j->free_buf);
+		swap(buf->buf_size,	j->free_buf_size);
+	}
+
 	buf->expires		=
 		(journal_cur_seq(j) == j->flushed_seq_ondisk
 		 ? jiffies
@@ -514,6 +525,33 @@ static void journal_write_work(struct work_struct *work)
 	spin_unlock(&j->lock);
 }
 
+static void journal_buf_prealloc(struct journal *j)
+{
+	if (j->free_buf &&
+	    j->free_buf_size >= j->buf_size_want)
+		return;
+
+	unsigned buf_size = j->buf_size_want;
+
+	spin_unlock(&j->lock);
+	void *buf = kvmalloc(buf_size, GFP_NOFS);
+	spin_lock(&j->lock);
+
+	if (buf &&
+	    (!j->free_buf ||
+	     buf_size > j->free_buf_size)) {
+		swap(buf,	j->free_buf);
+		swap(buf_size,	j->free_buf_size);
+	}
+
+	if (unlikely(buf)) {
+		spin_unlock(&j->lock);
+		/* kvfree can sleep */
+		kvfree(buf);
+		spin_lock(&j->lock);
+	}
+}
+
 static int __journal_res_get(struct journal *j, struct journal_res *res,
 			     unsigned flags)
 {
@@ -544,6 +582,8 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 
 	spin_lock(&j->lock);
 
+	journal_buf_prealloc(j);
+
 	/*
 	 * Recheck after taking the lock, so we don't race with another thread
 	 * that just did journal_entry_open() and call bch2_journal_entry_close()
@@ -951,7 +991,8 @@ static void __bch2_journal_block(struct journal *j)
 			new.cur_entry_offset = JOURNAL_ENTRY_BLOCKED_VAL;
 		} while (!atomic64_try_cmpxchg(&j->reservations.counter, &old.v, new.v));
 
-		journal_cur_buf(j)->data->u64s = cpu_to_le32(old.cur_entry_offset);
+		if (old.cur_entry_offset < JOURNAL_ENTRY_BLOCKED_VAL)
+			journal_cur_buf(j)->data->u64s = cpu_to_le32(old.cur_entry_offset);
 	}
 }
 
@@ -1474,6 +1515,7 @@ void bch2_fs_journal_exit(struct journal *j)
 
 	for (unsigned i = 0; i < ARRAY_SIZE(j->buf); i++)
 		kvfree(j->buf[i].data);
+	kvfree(j->free_buf);
 	free_fifo(&j->pin);
 }
 
@@ -1500,13 +1542,13 @@ int bch2_fs_journal_init(struct journal *j)
 	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)))
 		return -BCH_ERR_ENOMEM_journal_pin_fifo;
 
-	for (unsigned i = 0; i < ARRAY_SIZE(j->buf); i++) {
-		j->buf[i].buf_size = JOURNAL_ENTRY_SIZE_MIN;
-		j->buf[i].data = kvmalloc(j->buf[i].buf_size, GFP_KERNEL);
-		if (!j->buf[i].data)
-			return -BCH_ERR_ENOMEM_journal_buf;
+	j->free_buf_size = j->buf_size_want = JOURNAL_ENTRY_SIZE_MIN;
+	j->free_buf = kvmalloc(j->free_buf_size, GFP_KERNEL);
+	if (!j->free_buf)
+		return -BCH_ERR_ENOMEM_journal_buf;
+
+	for (unsigned i = 0; i < ARRAY_SIZE(j->buf); i++)
 		j->buf[i].idx = i;
-	}
 
 	j->pin.front = j->pin.back = 1;
 
@@ -1556,6 +1598,7 @@ void __bch2_journal_debug_to_text(struct printbuf *out, struct journal *j)
 	prt_printf(out, "average write size:\t");
 	prt_human_readable_u64(out, nr_writes ? div64_u64(j->entry_bytes_written, nr_writes) : 0);
 	prt_newline(out);
+	prt_printf(out, "free buf:\t%u\n",			j->free_buf ? j->free_buf_size : 0);
 	prt_printf(out, "nr direct reclaim:\t%llu\n",		j->nr_direct_reclaim);
 	prt_printf(out, "nr background reclaim:\t%llu\n",	j->nr_background_reclaim);
 	prt_printf(out, "reclaim kicked:\t%u\n",		j->reclaim_kicked);
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index f2ff28e6697c..3ff6563b7dd2 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1640,6 +1640,19 @@ static CLOSURE_CALLBACK(journal_write_done)
 		j->err_seq	= seq;
 	w->write_done = true;
 
+	if (!j->free_buf || j->free_buf_size < w->buf_size) {
+		swap(j->free_buf,	w->data);
+		swap(j->free_buf_size,	w->buf_size);
+	}
+
+	if (w->data) {
+		spin_unlock(&j->lock);
+		kvfree(w->data);
+		w->data = NULL;
+		w->buf_size = 0;
+		spin_lock(&j->lock);
+	}
+
 	bool completed = false;
 
 	for (seq = journal_last_unwritten_seq(j);
@@ -1649,7 +1662,7 @@ static CLOSURE_CALLBACK(journal_write_done)
 		if (!w->write_done)
 			break;
 
-		if (!j->err_seq && !JSET_NO_FLUSH(w->data)) {
+		if (!j->err_seq && !w->noflush) {
 			j->flushed_seq_ondisk = seq;
 			j->last_seq_ondisk = w->last_seq;
 
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index 6a098c7e3f2e..cd8440868d38 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -153,6 +153,7 @@ enum journal_flags {
 	x(journal_full)			\
 	x(journal_pin_full)		\
 	x(journal_stuck)		\
+	x(enomem)			\
 	x(insufficient_devices)
 
 enum journal_errors {
@@ -215,6 +216,8 @@ struct journal {
 	 * other is possibly being written out.
 	 */
 	struct journal_buf	buf[JOURNAL_BUF_NR];
+	void			*free_buf;
+	unsigned		free_buf_size;
 
 	spinlock_t		lock;
 
-- 
2.45.2

