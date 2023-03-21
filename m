Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D55C6FD1D
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjCUNTy (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCUNTv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39052E0C9
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eq67/g5v+uH6Xa6jPtXOrA+DLt5+rSpvnouO9OjlTDs=;
        b=Bxq7kkGSRi4KS4GF83wQqSav0EMbSvCYgorC0jcFr9+cdCfox0+1YbvSdvrG64OxgqZuey
        COEQnimm9Ld89ObwYk0mtck7tPwyTfD5IsEvpDlclPzKfE8c0BdIza8xnu217WKPlE6bYQ
        dDugzscAE3jFnsKT1dsWQ7CS640vtlA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-612-NSgDUmllN0apZZryEe6-FA-1; Tue, 21 Mar 2023 09:18:29 -0400
X-MC-Unique: NSgDUmllN0apZZryEe6-FA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4EB243C10144
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:29 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 372D01731B
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:29 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 5/5] RFC: bcachefs: use a timeout for the journal stuck condition
Date:   Tue, 21 Mar 2023 09:20:14 -0400
Message-Id: <20230321132014.1438249-6-bfoster@redhat.com>
In-Reply-To: <20230321132014.1438249-1-bfoster@redhat.com>
References: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

This is currently just a thought/experiment on how to make the
journal checking logic a bit more reliable. I've seen this actually
still result in blocked tasks in the journal reservation slow path,
which I think is actually due to the timeout allowing tasks to wind down
long enough after a legitimate stall such that there are no more journal
wake events to allow any one of the tasks to detect the stuck condition
and shut down the fs.

This would need to be addressed somehow or another for this sort of
thing to be useful. One approach could be a timer of some sort to
monitor things as the journal becomes full, but I think that is
approaching overkill given this is a rare enough problem. This is
primarily posted for thought and discussion.

Not-Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 3f0e6d71aa32..a83b753fbc3f 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -85,7 +85,8 @@ static void journal_pin_list_init(struct journal_entry_pin_list *p, int count)
  *
  * Consider the journal stuck when it appears full with no ability to commit
  * btree transactions, to discard journal buckets, nor acquire priority
- * (reserved watermark) reservation.
+ * (reserved watermark) reservation, and we have not been able to open a new
+ * journal entry for at least 30s.
  */
 static inline bool
 journal_error_check_stuck(struct journal *j, int error, unsigned flags)
@@ -93,6 +94,7 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 	bool stuck = false;
 	struct printbuf buf = PRINTBUF;
+	u64 stuck_ts;
 
 	if (!(error == JOURNAL_ERR_journal_full ||
 	      error == JOURNAL_ERR_journal_pin_full) ||
@@ -102,7 +104,8 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 
 	spin_lock(&j->lock);
 
-	if (j->can_discard) {
+	stuck_ts = j->res_get_blocked_start + (NSEC_PER_SEC * 30);
+	if (j->can_discard || time_before64(local_clock(), stuck_ts)) {
 		spin_unlock(&j->lock);
 		return stuck;
 	}
-- 
2.39.2

