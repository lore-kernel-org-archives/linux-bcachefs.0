Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81557C83F10
	for <linux-bcachefs@archiver.kernel.org>; Thu, 31 Aug 2023 11:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbjHaLIs (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345062AbjHaLIs (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 31 Aug 2023 07:08:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E9DE63
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 04:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693480049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cSecafUPMj8xamcyXwgWw8KJQRWcfhaAg0ySTaKVMK4=;
        b=TVcEc2wPsamhAtxUhGAjabi/6NVafj0ej7g55NL2dVR6TY782+Hf1vK0ozQ2ofCp4Xete8
        P+/WxOUe+4DYbsO3ZaYbgJil9UURJOlSv1iINUH/goNfOqf3dyiO0KxTatfrMkIh2kz10W
        eRcCbLY1Om9UCdwEkRo7zLBuAPkZ8Vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-pyOP-EfUPXivl-pQuzW_1w-1; Thu, 31 Aug 2023 07:07:27 -0400
X-MC-Unique: pyOP-EfUPXivl-pQuzW_1w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72641823D62
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 482E340C6F4C
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 3/3] bcachefs: fix race between journal entry close and pin set
Date:   Thu, 31 Aug 2023 07:07:34 -0400
Message-ID: <20230831110734.787212-4-bfoster@redhat.com>
In-Reply-To: <20230831110734.787212-1-bfoster@redhat.com>
References: <20230831110734.787212-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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
reference held by an open journal entry is too short to cover
the processing of transactions with outstanding reservations. The
simplest way to address this is to expand the pin list reference
to the lifecycle of the buffer vs. the shorter lifecycle of the
open journal entry. This allows a journal entry to closer for
whatever reason, but ensures the pin list for the seq with
outstanding reservation cannot be popped and reclaimed before all
outstanding reservations have been released.

Move the pin put from journal entry close to where final reference
count processing of the journal buffer occurs. Create a duplicate
helper to cover the case where the caller doesn't already hold the
journal lock. This allows generic/390 to pass reliably.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c |  4 +---
 fs/bcachefs/journal.h | 19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 76ebcdb3e3b4..21f97d48931d 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -195,13 +195,11 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val)
 	buf->data->last_seq	= cpu_to_le64(buf->last_seq);
 	BUG_ON(buf->last_seq > le64_to_cpu(buf->data->seq));
 
-	__bch2_journal_pin_put(j, le64_to_cpu(buf->data->seq));
-
 	cancel_delayed_work(&j->write_work);
 
 	bch2_journal_space_available(j);
 
-	bch2_journal_buf_put(j, old.idx);
+	__bch2_journal_buf_put(j, old.idx, le64_to_cpu(buf->data->seq));
 }
 
 void bch2_journal_halt(struct journal *j)
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index c7a31da077c9..5dea5d46c616 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -112,6 +112,7 @@
 #include <linux/hash.h>
 
 #include "journal_types.h"
+#include "journal_reclaim.h"
 
 struct bch_fs;
 
@@ -269,13 +270,27 @@ static inline union journal_res_state journal_state_buf_put(struct journal *j, u
 }
 
 void bch2_journal_write(struct closure *);
-static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
+static inline void __bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	union journal_res_state s;
 
 	s = journal_state_buf_put(j, idx);
 	if (!journal_state_count(s, idx)) {
+		__bch2_journal_pin_put(j, seq);
+		if (idx == s.unwritten_idx)
+			closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
+	}
+}
+
+static inline void bch2_journal_buf_put(struct journal *j, unsigned idx, u64 seq)
+{
+	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	union journal_res_state s;
+
+	s = journal_state_buf_put(j, idx);
+	if (!journal_state_count(s, idx)) {
+		bch2_journal_pin_put(j, seq);
 		if (idx == s.unwritten_idx)
 			closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
 	}
@@ -298,7 +313,7 @@ static inline void bch2_journal_res_put(struct journal *j,
 				       BCH_JSET_ENTRY_btree_keys,
 				       0, 0, 0);
 
-	bch2_journal_buf_put(j, res->idx);
+	bch2_journal_buf_put(j, res->idx, res->seq);
 
 	res->ref = 0;
 }
-- 
2.41.0

