Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E74538DD1
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SL3rlI0q"
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [IPv6:2001:41d0:1004:224b::b4])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B893EB03
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Nov 2023 08:32:11 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699633930;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/dDUz52QBAudFxMUHsk8Wzp5IttQVxZ3e38yHrs3nKU=;
	b=SL3rlI0q9oP43Dg97aU4hEKWmV00dchqpFE+4AWh5kkGyAzMjVehq9YujyH/pPIgu8+T5Y
	chf+iYX54faFH0pBH54j5KC1QMlI6p7Biv5hQpWjusLNQG7Pnpn++8tNDGCgV49fZnIPp0
	JvMeUwUtOqbPJeahxfDZquqJ2pNbYMc=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 11/17] bcachefs: bch2_journal_block_reservations()
Date: Fri, 10 Nov 2023 11:31:48 -0500
Message-ID: <20231110163157.2736111-12-kent.overstreet@linux.dev>
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

Add a new journal method for blocking new journal reservations and
waiting on outstanding reservations, to be used by the btree write
buffer flush path.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/journal.c | 29 +++++++++++++++++++++++++++++
 fs/bcachefs/journal.h |  3 ++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 3a6b73d4ec24..5b390cb91884 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -147,6 +147,7 @@ void bch2_journal_buf_put_final(struct journal *j, u64 seq, bool write)
 		bch2_journal_reclaim_fast(j);
 	if (write)
 		closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
+	wake_up(&j->wait);
 }
 
 /*
@@ -764,6 +765,34 @@ void bch2_journal_block(struct journal *j)
 	journal_quiesce(j);
 }
 
+/*
+ * XXX: ideally this would not be closing the current journal entry, but
+ * otherwise we do not have a way to avoid racing with res_get() - j->blocked
+ * will race.
+ */
+static bool journal_reservations_stopped(struct journal *j)
+{
+	union journal_res_state s;
+
+	journal_entry_close(j);
+
+	s.v = atomic64_read_acquire(&j->reservations.counter);
+
+	return  s.buf0_count == 0 &&
+		s.buf1_count == 0 &&
+		s.buf2_count == 0 &&
+		s.buf3_count == 0;
+}
+
+void bch2_journal_block_reservations(struct journal *j)
+{
+	spin_lock(&j->lock);
+	j->blocked++;
+	spin_unlock(&j->lock);
+
+	wait_event(j->wait, journal_reservations_stopped(j));
+}
+
 /* allocate journal on a device: */
 
 static int __bch2_set_nr_journal_buckets(struct bch_dev *ca, unsigned nr,
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index c85d01cf4948..310654bb74de 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -259,7 +259,7 @@ static inline union journal_res_state journal_state_buf_put(struct journal *j, u
 {
 	union journal_res_state s;
 
-	s.v = atomic64_sub_return(((union journal_res_state) {
+	s.v = atomic64_sub_return_release(((union journal_res_state) {
 				    .buf0_count = idx == 0,
 				    .buf1_count = idx == 1,
 				    .buf2_count = idx == 2,
@@ -427,6 +427,7 @@ static inline void bch2_journal_set_replay_done(struct journal *j)
 
 void bch2_journal_unblock(struct journal *);
 void bch2_journal_block(struct journal *);
+void bch2_journal_block_reservations(struct journal *);
 
 void __bch2_journal_debug_to_text(struct printbuf *, struct journal *);
 void bch2_journal_debug_to_text(struct printbuf *, struct journal *);
-- 
2.42.0

