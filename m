Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC92EC761AF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjCUNT4 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCUNTz (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F944DBCA
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=toDS+N7SH2L21kSuyIYK5CL6VfvyAUj21vFS13UMA+8=;
        b=MikgL/5DMuob1mGaEnIa3fBk7IF0zFe8CVbYeD+8XZHsKbxx8nfsC4+25fIKEq08vr0rKj
        UTNoJpYe1eZzN8q75vIO+bQ4w261fEPCj3+THRGzdqVujY5CXWLG1CqoiXF3iCwbOk0MO8
        7teqfI4j22YHHJemP08Evg0t90q37Bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-1jKy6VF0Pvmv3Rxww8azBQ-1; Tue, 21 Mar 2023 09:18:29 -0400
X-MC-Unique: 1jKy6VF0Pvmv3Rxww8azBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C1DE802D2E
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 14B6E85768
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 4/5] bcachefs: drop unnecessary journal stuck check from space calculation
Date:   Tue, 21 Mar 2023 09:20:13 -0400
Message-Id: <20230321132014.1438249-5-bfoster@redhat.com>
In-Reply-To: <20230321132014.1438249-1-bfoster@redhat.com>
References: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The journal stucking check in bch2_journal_space_available() is
particularly aggressive and can lead to premature shutdown in some
rare cases. This is difficult to reproduce, but also comes along
with a fatal error and so is worthwhile to be cautious.

For example, we've seen instances where the journal is under heavy
reservation pressure, the journal allocation path transitions into
the final available journal bucket, the journal write path
immediately consumes that bucket and calls into
bch2_journal_space_available(), which then in turn flags the journal
as stuck because there is no available space and shuts down the
filesystem instead of submitting the journal write (that would have
otherwise succeeded).

To avoid this problem, simplify the journal stuck checking by just
relying on the higher level logic in the journal reservation path.
This produces more useful debug output and is a more reliable
indicator that things have bogged down.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal_reclaim.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 8c88884c74a5..37c6846a30aa 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -210,24 +210,7 @@ void bch2_journal_space_available(struct journal *j)
 	clean		= j->space[journal_space_clean].total;
 	total		= j->space[journal_space_total].total;
 
-	if (!clean_ondisk &&
-	    journal_cur_seq(j) == j->seq_ondisk) {
-		struct printbuf buf = PRINTBUF;
-
-		__bch2_journal_debug_to_text(&buf, j);
-		bch_err(c, "journal stuck\n%s", buf.buf);
-		printbuf_exit(&buf);
-
-		/*
-		 * Hack: bch2_fatal_error() calls bch2_journal_halt() which
-		 * takes journal lock:
-		 */
-		spin_unlock(&j->lock);
-		bch2_fatal_error(c);
-		spin_lock(&j->lock);
-
-		ret = JOURNAL_ERR_journal_stuck;
-	} else if (!j->space[journal_space_discarded].next_entry)
+	if (!j->space[journal_space_discarded].next_entry)
 		ret = JOURNAL_ERR_journal_full;
 
 	if ((j->space[journal_space_clean_ondisk].next_entry <
-- 
2.39.2

