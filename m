Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA60EE645C
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbjIOMwd (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbjIOMwc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1CF0173B
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694782302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ePy7LacSxdU4Wgs9AZ3mJ3ccjX0V6OD6LcJvuJtlyCE=;
        b=T+2M/VOneNha1b3f++Nxnm2SXfebMpIsaOEn3pX73+NzT+WWtT7/r1nfJd95eA8Yr6xX2l
        MmFq5ZYZTFH60sl0rI6P+0QzqSh9zG7aHm/QXi81S8xJpSM6hdszzFSSvQJmvmAFLGc7Ts
        DJUGyzDnbmECVKeB8vhXARF1ii5P7Wc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-qFsfIfJpMnCxW-SFdKHclw-1; Fri, 15 Sep 2023 08:51:40 -0400
X-MC-Unique: qFsfIfJpMnCxW-SFdKHclw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E50185A5BF
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43C1C1004145
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 3/4] bcachefs: fix race between journal entry close and pin set
Date:   Fri, 15 Sep 2023 08:51:53 -0400
Message-ID: <20230915125154.307450-4-bfoster@redhat.com>
In-Reply-To: <20230915125154.307450-1-bfoster@redhat.com>
References: <20230915125154.307450-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs freeze testing via fstests generic/390 occasionally
reproduces the following BUG from bch2_fs_read_only():

  BUG_ON(atomic_long_read(&c->btree_key_cache.nr_dirty));

This indicates that one or more dirty key cache keys still exist
after the attempt to flush and quiesce the fs. The sequence that
leads to this problem actually occurs on unfreeze (ro->rw), and
looks something like the following:

- Task A begins a transaction commit and acquires journal_res for
  the current seq. This transaction intends to perform key cache
  insertion.
- Task B begins a bch2_journal_flush() via bch2_sync_fs(). This ends
  up in journal_entry_want_write(), which closes the current journal
  entry and drops the reference to the pin list created on entry open.
  The pin put pops the front of the journal via fast reclaim since the
  reference count has dropped to 0.
- Task A attempts to set the journal pin for the associated cached
  key, but bch2_journal_pin_set() skips the pin insert because the
  seq of the transaction reservation is behind the front of the pin
  list fifo.

The end result is that the pin associated with the cached key is not
added, which prevents a subsequent reclaim from processing the key
and thus leaves it dangling at freeze time. The fundamental cause of
this problem is that the front of the journal is allowed to pop
before a transaction with outstanding reservation on the associated
journal seq is able to add a pin. The count for the pin list
associated with the seq drops to zero and is prematurely reclaimed
as a result.

The logical fix for this problem lies in how the journal buffer is
managed in similar scenarios where the entry might have been closed
before a transaction with outstanding reservations happens to be
committed.

When a journal entry is opened, the current sequence number is
bumped, the associated pin list is initialized with a reference
count of 1, and the journal buffer reference count is bumped (via
journal_state_inc()). When a journal reservation is acquired, the
reservation also acquires a reference on the associated buffer. If
the journal entry is closed in the meantime, it drops both the pin
and buffer references held by the open entry, but the buffer still
has references held by outstanding reservation. After the associated
transaction commits, the reservation release drops the associated
buffer references and the buffer is written out once the reference
count has dropped to zero.

The fundamental problem here is that the lifecycle of the pin list
reference held by an open journal entry is too short to cover the
processing of transactions with outstanding reservations. The
simplest way to address this is to expand the pin list reference to
the lifecycle of the buffer vs. the shorter lifecycle of the open
journal entry. This ensures the pin list for a seq with outstanding
reservation cannot be popped and reclaimed before all outstanding
reservations have been released, even if the associated journal
entry has been closed for further reservations.

Move the pin put from journal entry close to where final processing
of the journal buffer occurs. Create a duplicate helper to cover the
case where the caller doesn't already hold the journal lock. This
allows generic/390 to pass reliably.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c | 21 +++++++++++++--------
 fs/bcachefs/journal.h | 20 +++++++++++++++-----
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index be61d43458eb..fc3dd5bef386 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -132,13 +132,21 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	return stuck;
 }
 
-/* journal entry close/open: */
-
-void bch2_journal_buf_put_final(struct journal *j)
+/*
+ * Final processing when the last reference of a journal buffer has been
+ * dropped. Drop the pin list reference acquired at journal entry open and write
+ * the buffer, if requested.
+ */
+void bch2_journal_buf_put_final(struct journal *j, u64 seq, bool write)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 
-	closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
+	lockdep_assert_held(&j->lock);
+
+	if (__bch2_journal_pin_put(j, seq))
+		bch2_journal_reclaim_fast(j);
+	if (write)
+		closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
 }
 
 /*
@@ -204,14 +212,11 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val)
 	buf->data->last_seq	= cpu_to_le64(buf->last_seq);
 	BUG_ON(buf->last_seq > le64_to_cpu(buf->data->seq));
 
-	if (__bch2_journal_pin_put(j, le64_to_cpu(buf->data->seq)))
-		bch2_journal_reclaim_fast(j);
-
 	cancel_delayed_work(&j->write_work);
 
 	bch2_journal_space_available(j);
 
-	bch2_journal_buf_put(j, old.idx);
+	__bch2_journal_buf_put(j, old.idx, le64_to_cpu(buf->data->seq));
 }
 
 void bch2_journal_halt(struct journal *j)
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 0a53a2142594..491133cc52f3 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -268,16 +268,26 @@ static inline union journal_res_state journal_state_buf_put(struct journal *j, u
 	return s;
 }
 
-void bch2_journal_buf_put_final(struct journal *);
+void bch2_journal_buf_put_final(struct journal *, u64, bool);
 
-static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
+static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
+{
+	union journal_res_state s;
+
+	s = journal_state_buf_put(j, idx);
+	if (!journal_state_count(s, idx))
+		bch2_journal_buf_put_final(j, seq, idx == s.unwritten_idx);
+}
+
+static inline void bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
 {
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
 	if (!journal_state_count(s, idx)) {
-		if (idx == s.unwritten_idx)
-			bch2_journal_buf_put_final(j);
+		spin_lock(&j->lock);
+		bch2_journal_buf_put_final(j, seq, idx == s.unwritten_idx);
+		spin_unlock(&j->lock);
 	}
 }
 
@@ -298,7 +308,7 @@ static inline void bch2_journal_res_put(struct journal *j,
 				       BCH_JSET_ENTRY_btree_keys,
 				       0, 0, 0);
 
-	bch2_journal_buf_put(j, res->idx);
+	bch2_journal_buf_put(j, res->idx, res->seq);
 
 	res->ref = 0;
 }
-- 
2.41.0

