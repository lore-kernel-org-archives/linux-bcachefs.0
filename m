Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E776C74A5B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:20:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbjCUNUA (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCUNT7 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E974DBFB
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=npeoNWmxpsEhR1aQo4du7VLhqRsQARrCqu8l4xHn4pU=;
        b=UgnQNYs8tip/uFwlzYLeK6phte9ptk/az9zFW6vbw2MSJxuiOBLaqLWAKObkTy6QZ6G0zA
        IpuyUN/FTXHZdK3fVjxd6PpVkJoPbqVXn5MsVM1lwAkOSAy5FaOimL/pgffnSry0OHwpLz
        DfXpeA1ihBehBO85nvacpKQ4lo6nEW4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-1-TZipKvaTNiuWwjtVzXRlRA-1; Tue, 21 Mar 2023 09:18:29 -0400
X-MC-Unique: TZipKvaTNiuWwjtVzXRlRA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B16F13C10147
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9947685768
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/5] bcachefs: more aggressive fast path write buffer key flushing
Date:   Tue, 21 Mar 2023 09:20:10 -0400
Message-Id: <20230321132014.1438249-2-bfoster@redhat.com>
In-Reply-To: <20230321132014.1438249-1-bfoster@redhat.com>
References: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The btree write buffer flush code is prone to causing journal
deadlock due to inefficient use and release of reservation space.
Reservation is not pre-reserved for write buffered keys (as is done
for key cache keys, for example), because the write buffer flush
side uses a fast path that attempts insertion without need for any
reservation at all.

The write buffer flush attempts to deal with this by inserting keys
using the BTREE_INSERT_JOURNAL_RECLAIM flag to return an error on
journal reservations that require blocking. Upon first error, it
falls back to a slow path that inserts in journal order and supports
moving the associated journal pin forward.

The problem is that under pathological conditions (i.e. smaller log,
larger write buffer and journal reservation pressure), we've seen
instances where the fast path fails fairly quickly without having
completed many insertions, and then the slow path is unable to push
the journal pin forward enough to free up the space it needs to
completely flush the buffer. This problem is occasionally reproduced
by fstest generic/333.

To avoid this problem, update the fast path algorithm to skip key
inserts that fail due to inability to acquire needed journal
reservation without immediately breaking out of the loop. Instead,
insert as many keys as possible, zap the sequence numbers to mark
them as processed, and then fall back to the slow path to process
the remaining set in journal order. This reduces the amount of
journal reservation that might be required to flush the entire
buffer and increases the odds that the slow path is able to move the
journal pin forward and free up space as keys are processed.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/btree_write_buffer.c | 41 ++++++++++++++++----------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/fs/bcachefs/btree_write_buffer.c b/fs/bcachefs/btree_write_buffer.c
index 80f4b9839bc2..32f20e631de0 100644
--- a/fs/bcachefs/btree_write_buffer.c
+++ b/fs/bcachefs/btree_write_buffer.c
@@ -111,7 +111,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 	struct journal_entry_pin pin;
 	struct btree_write_buffered_key *i, *dst, *keys;
 	struct btree_iter iter = { NULL };
-	size_t nr = 0, skipped = 0, fast = 0;
+	size_t nr = 0, skipped = 0, fast = 0, slowpath = 0;
 	bool write_locked = false;
 	union btree_write_buffer_state s;
 	int ret = 0;
@@ -135,15 +135,13 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 	 *
 	 * However, since we're not flushing in the order they appear in the
 	 * journal we won't be able to drop our journal pin until everything is
-	 * flushed - which means this could deadlock the journal, if we weren't
-	 * passing BTREE_INSERT_JORUNAL_RECLAIM. This causes the update to fail
+	 * flushed - which means this could deadlock the journal if we weren't
+	 * passing BTREE_INSERT_JOURNAL_RECLAIM. This causes the update to fail
 	 * if it would block taking a journal reservation.
 	 *
-	 * If that happens, we sort them by the order they appeared in the
-	 * journal - after dropping redundant entries - and then restart
-	 * flushing, this time dropping journal pins as we go.
+	 * If that happens, simply skip the key so we can optimistically insert
+	 * as many keys as possible in the fast path.
 	 */
-
 	sort(keys, nr, sizeof(keys[0]),
 	     btree_write_buffered_key_cmp, NULL);
 
@@ -152,6 +150,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 		    i[0].btree == i[1].btree &&
 		    bpos_eq(i[0].k.k.p, i[1].k.k.p)) {
 			skipped++;
+			i->journal_seq = 0;
 			continue;
 		}
 
@@ -177,8 +176,14 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 				bch2_trans_begin(trans);
 		} while (bch2_err_matches(ret, BCH_ERR_transaction_restart));
 
+		if (ret == -BCH_ERR_journal_reclaim_would_deadlock) {
+			slowpath++;
+			continue;
+		}
 		if (ret)
 			break;
+
+		i->journal_seq = 0;
 	}
 
 	if (write_locked)
@@ -187,7 +192,7 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 
 	trace_write_buffer_flush(trans, nr, skipped, fast, wb->size);
 
-	if (ret == -BCH_ERR_journal_reclaim_would_deadlock)
+	if (slowpath)
 		goto slowpath;
 
 	bch2_fs_fatal_err_on(ret, c, "%s: insert error %s", __func__, bch2_err_str(ret));
@@ -198,23 +203,19 @@ int __bch2_btree_write_buffer_flush(struct btree_trans *trans, unsigned commit_f
 slowpath:
 	trace_write_buffer_flush_slowpath(trans, i - keys, nr);
 
-	dst = keys;
-	for (; i < keys + nr; i++) {
-		if (i + 1 < keys + nr &&
-		    i[0].btree == i[1].btree &&
-		    bpos_eq(i[0].k.k.p, i[1].k.k.p))
-			continue;
-
-		*dst = *i;
-		dst++;
-	}
-	nr = dst - keys;
-
+	/*
+	 * Now sort the rest by journal seq and bump the journal pin as we go.
+	 * The slowpath zapped the seq of keys that were successfully flushed so
+	 * we can skip those here.
+	 */
 	sort(keys, nr, sizeof(keys[0]),
 	     btree_write_buffered_journal_cmp,
 	     NULL);
 
 	for (i = keys; i < keys + nr; i++) {
+		if (!i->journal_seq)
+			continue;
+
 		if (i->journal_seq > pin.seq) {
 			struct journal_entry_pin pin2;
 
-- 
2.39.2

