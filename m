Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6C33FB16
	for <linux-bcachefs@vger.kernel.org>; Wed, 31 Jan 2024 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706732195; cv=none; b=CAIqlhQisX7esJ1H+vjQuRFLGwpHl6B91IyiBxb4AIX49TirDojbZYKkXOMtV4N50OeZZaVcJueuB7IxBH/SNycQ6kJUOUl3QUSS3wX2e6doQ5yAIxeQ8s4hSSLeV3V9LobJbt/jy7S7RHbhoCe0JZunoHvaREzp5wCwGTSb8nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706732195; c=relaxed/simple;
	bh=QzcKjj4Uiz6NxL/sLJYiP+Ldj2RFPGlkgPmCNo9o6mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nm8IsASHV1/2iGD2gAc3Fgm1BSc3XOo2JCx2l+HrUV1X+Ti59iC2T88dtCtEfe77H8a8/kXlpi3+4Q/m74OlnT2mEvpvwp678oE932eoDgwGc9Wn977VaNxtRZsP4RWkHi1Bi6YlDy1Ca54ZxekR4WLSb875kC/eMvtw3au/gfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sbLlGU3s; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sbLlGU3s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706732190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lrh9eXq/dcfoqzEkb2vR3AWPVLJSRhUwn9ODWvIzgxM=;
	b=sbLlGU3sewpfhEYCM1swV8UQG2Y2bVjTzNJ1dgeac0eZMIoAKFs6K9chHRXCz5SZX/Yg2z
	s0rFF7aT4dqqKu+YQdsWjI4BbaJgfN6jXn/OrG1xFSAlJXbH8rCm5svTKidNsk6+IZzktN
	6k6TJge4h2Za1k2ZRP7tABhDXEzRHzA=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/3] bcachefs: closure per journal buf
Date: Wed, 31 Jan 2024 15:16:21 -0500
Message-ID: <20240131201622.3409726-2-kent.overstreet@linux.dev>
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

Prep work for having multiple journal writes in flight.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c       | 18 ++++++++++++------
 fs/bcachefs/journal_io.c    | 34 +++++++++++++++++++---------------
 fs/bcachefs/journal_types.h | 12 ++++++++++--
 3 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 306d46654df3..3508871cfd8a 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -186,8 +186,10 @@ void bch2_journal_buf_put_final(struct journal *j, u64 seq, bool write)
 
 	if (__bch2_journal_pin_put(j, seq))
 		bch2_journal_reclaim_fast(j);
-	if (write)
-		closure_call(&j->io, bch2_journal_write, j->wq, NULL);
+	if (write) {
+		struct journal_buf *w = j->buf + (seq & JOURNAL_BUF_MASK);
+		closure_call(&w->io, bch2_journal_write, j->wq, NULL);
+	}
 }
 
 /*
@@ -1273,10 +1275,14 @@ int bch2_dev_journal_init(struct bch_dev *ca, struct bch_sb *sb)
 	unsigned nr_bvecs = DIV_ROUND_UP(JOURNAL_ENTRY_SIZE_MAX, PAGE_SIZE);
 
 	for (unsigned i = 0; i < ARRAY_SIZE(ja->bio); i++) {
-		ja->bio[i] = bio_kmalloc(nr_bvecs, GFP_KERNEL);
+		ja->bio[i] = kmalloc(struct_size(ja->bio[i], bio.bi_inline_vecs,
+				     nr_bvecs), GFP_KERNEL);
 		if (!ja->bio[i])
 			return -BCH_ERR_ENOMEM_dev_journal_init;
-		bio_init(ja->bio[i], NULL, ja->bio[i]->bi_inline_vecs, nr_bvecs, 0);
+
+		ja->bio[i]->ca = ca;
+		ja->bio[i]->buf_idx = i;
+		bio_init(&ja->bio[i]->bio, NULL, ja->bio[i]->bio.bi_inline_vecs, nr_bvecs, 0);
 	}
 
 	ja->buckets = kcalloc(ja->nr, sizeof(u64), GFP_KERNEL);
@@ -1339,6 +1345,7 @@ int bch2_fs_journal_init(struct journal *j)
 		j->buf[i].data = kvpmalloc(j->buf[i].buf_size, GFP_KERNEL);
 		if (!j->buf[i].data)
 			return -BCH_ERR_ENOMEM_journal_buf;
+		j->buf[i].idx = i;
 	}
 
 	j->pin.front = j->pin.back = 1;
@@ -1458,7 +1465,6 @@ bool bch2_journal_seq_pins_to_text(struct printbuf *out, struct journal *j, u64
 {
 	struct journal_entry_pin_list *pin_list;
 	struct journal_entry_pin *pin;
-	unsigned i;
 
 	spin_lock(&j->lock);
 	*seq = max(*seq, j->pin.front);
@@ -1476,7 +1482,7 @@ bool bch2_journal_seq_pins_to_text(struct printbuf *out, struct journal *j, u64
 	prt_newline(out);
 	printbuf_indent_add(out, 2);
 
-	for (i = 0; i < ARRAY_SIZE(pin_list->list); i++)
+	for (unsigned i = 0; i < ARRAY_SIZE(pin_list->list); i++)
 		list_for_each_entry(pin, &pin_list->list[i], list) {
 			prt_printf(out, "\t%px %ps", pin, pin->flush);
 			prt_newline(out);
diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index 92efacad80e6..8dbf3b3fac32 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1595,9 +1595,9 @@ static inline struct journal_buf *journal_last_unwritten_buf(struct journal *j)
 
 static CLOSURE_CALLBACK(journal_write_done)
 {
-	closure_type(j, struct journal, io);
+	closure_type(w, struct journal_buf, io);
+	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	struct journal_buf *w = journal_last_unwritten_buf(j);
 	struct bch_replicas_padded replicas;
 	union journal_res_state old, new;
 	u64 v, seq;
@@ -1673,8 +1673,9 @@ static CLOSURE_CALLBACK(journal_write_done)
 
 	if (!journal_state_count(new, new.unwritten_idx) &&
 	    journal_last_unwritten_seq(j) <= journal_cur_seq(j)) {
+		struct journal_buf *w = j->buf + (journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK);
 		spin_unlock(&j->lock);
-		closure_call(&j->io, bch2_journal_write, j->wq, NULL);
+		closure_call(&w->io, bch2_journal_write, j->wq, NULL);
 	} else if (journal_last_unwritten_seq(j) == journal_cur_seq(j) &&
 		   new.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL) {
 		struct journal_buf *buf = journal_cur_buf(j);
@@ -1695,31 +1696,32 @@ static CLOSURE_CALLBACK(journal_write_done)
 
 static void journal_write_endio(struct bio *bio)
 {
-	struct bch_dev *ca = bio->bi_private;
+	struct journal_bio *jbio = container_of(bio, struct journal_bio, bio);
+	struct bch_dev *ca = jbio->ca;
 	struct journal *j = &ca->fs->journal;
-	struct journal_buf *w = journal_last_unwritten_buf(j);
-	unsigned long flags;
+	struct journal_buf *w = j->buf + jbio->buf_idx;
 
 	if (bch2_dev_io_err_on(bio->bi_status, ca, BCH_MEMBER_ERROR_write,
 			       "error writing journal entry %llu: %s",
 			       le64_to_cpu(w->data->seq),
 			       bch2_blk_status_to_str(bio->bi_status)) ||
 	    bch2_meta_write_fault("journal")) {
+		unsigned long flags;
+
 		spin_lock_irqsave(&j->err_lock, flags);
 		bch2_dev_list_drop_dev(&w->devs_written, ca->dev_idx);
 		spin_unlock_irqrestore(&j->err_lock, flags);
 	}
 
-	closure_put(&j->io);
+	closure_put(&w->io);
 	percpu_ref_put(&ca->io_ref);
 }
 
 static CLOSURE_CALLBACK(do_journal_write)
 {
-	closure_type(j, struct journal, io);
+	closure_type(w, struct journal_buf, io);
+	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	unsigned buf_idx = journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK;
-	struct journal_buf *w = j->buf + buf_idx;
 	unsigned sectors = vstruct_sectors(w->data, c->block_bits);
 
 	extent_for_each_ptr(bkey_i_to_s_extent(&w->key), ptr) {
@@ -1735,7 +1737,7 @@ static CLOSURE_CALLBACK(do_journal_write)
 		this_cpu_add(ca->io_done->sectors[WRITE][BCH_DATA_journal],
 			     sectors);
 
-		struct bio *bio = ja->bio[buf_idx];
+		struct bio *bio = &ja->bio[w->idx]->bio;
 		bio_reset(bio, ca->disk_sb.bdev, REQ_OP_WRITE|REQ_SYNC|REQ_META);
 		bio->bi_iter.bi_sector	= ptr->offset;
 		bio->bi_end_io		= journal_write_endio;
@@ -1934,10 +1936,9 @@ static int bch2_journal_write_pick_flush(struct journal *j, struct journal_buf *
 
 CLOSURE_CALLBACK(bch2_journal_write)
 {
-	closure_type(j, struct journal, io);
+	closure_type(w, struct journal_buf, io);
+	struct journal *j = container_of(w, struct journal, buf[w->idx]);
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-	unsigned buf_idx = journal_last_unwritten_seq(j) & JOURNAL_BUF_MASK;
-	struct journal_buf *w = j->buf + buf_idx;
 	struct bch_replicas_padded replicas;
 	struct printbuf journal_debug_buf = PRINTBUF;
 	unsigned nr_rw_members = 0;
@@ -2016,12 +2017,15 @@ CLOSURE_CALLBACK(bch2_journal_write)
 	if (ret)
 		goto err;
 
+	if (!JSET_NO_FLUSH(w->data))
+		closure_wait_event(&j->async_wait, j->seq_ondisk + 1 == le64_to_cpu(w->data->seq));
+
 	if (!JSET_NO_FLUSH(w->data) && w->separate_flush) {
 		for_each_rw_member(c, ca) {
 			percpu_ref_get(&ca->io_ref);
 
 			struct journal_device *ja = &ca->journal;
-			struct bio *bio = ja->bio[buf_idx];
+			struct bio *bio = &ja->bio[w->idx]->bio;
 			bio_reset(bio, ca->disk_sb.bdev,
 				  REQ_OP_WRITE|REQ_SYNC|REQ_META|REQ_PREFLUSH);
 			bio->bi_end_io		= journal_write_endio;
diff --git a/fs/bcachefs/journal_types.h b/fs/bcachefs/journal_types.h
index a4b07e5b5710..4f7769aede33 100644
--- a/fs/bcachefs/journal_types.h
+++ b/fs/bcachefs/journal_types.h
@@ -18,6 +18,7 @@
  * the journal that are being staged or in flight.
  */
 struct journal_buf {
+	struct closure		io;
 	struct jset		*data;
 
 	__BKEY_PADDED(key, BCH_REPLICAS_MAX);
@@ -37,6 +38,7 @@ struct journal_buf {
 	bool			must_flush;	/* something wants a flush */
 	bool			separate_flush;
 	bool			need_flush_to_write_buffer;
+	u8			idx;
 };
 
 /*
@@ -150,6 +152,13 @@ enum journal_errors {
 
 typedef DARRAY(u64)		darray_u64;
 
+struct journal_bio {
+	struct bch_dev		*ca;
+	unsigned		buf_idx;
+
+	struct bio		bio;
+};
+
 /* Embedded in struct bch_fs */
 struct journal {
 	/* Fastpath stuff up front: */
@@ -204,7 +213,6 @@ struct journal {
 	wait_queue_head_t	wait;
 	struct closure_waitlist	async_wait;
 
-	struct closure		io;
 	struct delayed_work	write_work;
 	struct workqueue_struct *wq;
 
@@ -310,7 +318,7 @@ struct journal_device {
 	u64			*buckets;
 
 	/* Bio for journal reads/writes to this device */
-	struct bio		*bio[JOURNAL_BUF_NR];
+	struct journal_bio	*bio[JOURNAL_BUF_NR];
 
 	/* for bch_journal_read_device */
 	struct closure		read;
-- 
2.43.0

