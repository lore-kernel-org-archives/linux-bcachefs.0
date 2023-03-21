Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB8B2C74A5B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCUNTz (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCUNTv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C904DBC0
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U/uGJeavUMHIz30YmByoO4WPQV0D23qcxSKtx1nGTNs=;
        b=PuqVT08JXkR86p7Oan0y+NG5fhv5RSSFVLL4z03iPW1wl//C29qNYMksbb0TIggJe0E9TK
        vrcjp0ak9v6c59IQ600MvtNtAN7e7csW3W9LseKvJQhriu/HkAprCoGflu+0GDuDc5VS26
        n+nzLaePRzl92tFMLGN2uSiG2zPT+aY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-8f9KJj0VNTq7n75IHov2Zg-1; Tue, 21 Mar 2023 09:18:29 -0400
X-MC-Unique: 8f9KJj0VNTq7n75IHov2Zg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06CF1101A551
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E2B2485768
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 3/5] bcachefs: refactor journal stuck checking into standalone helper
Date:   Tue, 21 Mar 2023 09:20:12 -0400
Message-Id: <20230321132014.1438249-4-bfoster@redhat.com>
In-Reply-To: <20230321132014.1438249-1-bfoster@redhat.com>
References: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs checks for journal stuck conditions both in the journal
space calculation code and the journal reservation slow path. The
logic in both places is rather tricky and can result in
non-deterministic failure characteristics and debug output.

In preparation to condense journal stuck handling to a single place,
refactor the __journal_res_get() logic into a standalone helper.
Since multiple callers into the reservation code can result in
duplicate reports, use the ->err_seq field as a serialization
mechanism for the debug dump. Finally, add some comments to help
explain the logic and hopefully facilitate further improvements in
the future.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c | 85 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index f521f733e180..3f0e6d71aa32 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -76,6 +76,67 @@ static void journal_pin_list_init(struct journal_entry_pin_list *p, int count)
 	p->devs.nr = 0;
 }
 
+/*
+ * Detect stuck journal conditions and trigger shutdown. Technically the journal
+ * can end up stuck for a variety of reasons, such as a blocked I/O, journal
+ * reservation lockup, etc. Since this is a fatal error with potentially
+ * unpredictable characteristics, we want to be fairly conservative before we
+ * decide to shut things down.
+ *
+ * Consider the journal stuck when it appears full with no ability to commit
+ * btree transactions, to discard journal buckets, nor acquire priority
+ * (reserved watermark) reservation.
+ */
+static inline bool
+journal_error_check_stuck(struct journal *j, int error, unsigned flags)
+{
+	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	bool stuck = false;
+	struct printbuf buf = PRINTBUF;
+
+	if (!(error == JOURNAL_ERR_journal_full ||
+	      error == JOURNAL_ERR_journal_pin_full) ||
+	    nr_unwritten_journal_entries(j) ||
+	    (flags & JOURNAL_WATERMARK_MASK) != JOURNAL_WATERMARK_reserved)
+		return stuck;
+
+	spin_lock(&j->lock);
+
+	if (j->can_discard) {
+		spin_unlock(&j->lock);
+		return stuck;
+	}
+
+	stuck = true;
+
+	/*
+	 * The journal shutdown path will set ->err_seq, but do it here first to
+	 * serialize against concurrent failures and avoid duplicate error
+	 * reports.
+	 */
+	if (j->err_seq) {
+		spin_unlock(&j->lock);
+		return stuck;
+	}
+	j->err_seq = journal_cur_seq(j);
+	spin_unlock(&j->lock);
+
+	bch_err(c, "Journal stuck! Hava a pre-reservation but journal full (error %s)",
+		bch2_journal_errors[error]);
+	bch2_journal_debug_to_text(&buf, j);
+	bch_err(c, "%s", buf.buf);
+
+	printbuf_reset(&buf);
+	bch2_journal_pins_to_text(&buf, j);
+	bch_err(c, "Journal pins:\n%s", buf.buf);
+	printbuf_exit(&buf);
+
+	bch2_fatal_error(c);
+	dump_stack();
+
+	return stuck;
+}
+
 /* journal entry close/open: */
 
 void __bch2_journal_buf_put(struct journal *j)
@@ -417,28 +478,8 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 
 	if (!ret)
 		goto retry;
-
-	if ((ret == JOURNAL_ERR_journal_full ||
-	     ret == JOURNAL_ERR_journal_pin_full) &&
-	    !can_discard &&
-	    !nr_unwritten_journal_entries(j) &&
-	    (flags & JOURNAL_WATERMARK_MASK) == JOURNAL_WATERMARK_reserved) {
-		struct printbuf buf = PRINTBUF;
-
-		bch_err(c, "Journal stuck! Hava a pre-reservation but journal full (ret %s)",
-			bch2_journal_errors[ret]);
-
-		bch2_journal_debug_to_text(&buf, j);
-		bch_err(c, "%s", buf.buf);
-
-		printbuf_reset(&buf);
-		bch2_journal_pins_to_text(&buf, j);
-		bch_err(c, "Journal pins:\n%s", buf.buf);
-
-		printbuf_exit(&buf);
-		bch2_fatal_error(c);
-		dump_stack();
-	}
+	if (journal_error_check_stuck(j, ret, flags))
+		ret = -BCH_ERR_journal_res_get_blocked;
 
 	/*
 	 * Journal is full - can't rely on reclaim from work item due to
-- 
2.39.2

