Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FA91C83F32
	for <linux-bcachefs@archiver.kernel.org>; Thu, 31 Aug 2023 11:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245215AbjHaLIv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbjHaLIv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 31 Aug 2023 07:08:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF77E61
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 04:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693480048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBcTuDtXQ0q4BJE9RWgMQDm8xhdI1vEv3Q6UAVKzKPA=;
        b=i/SkZGItUgf5r+C3lVcVJ81IfOpWc2MHwOccvSCiJGLEsqDmDimmDBwXdgkpNUIAg+afwB
        uhr9wkWnQwC+HyYD5+uTpJ+8dvuV1g9x7i8dOn2ewIKiqxOBZ1JshIDyUmBZpxsGIGZERx
        brJh0eJvnqLmQTrHEU0Fkrd91tUBR7A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-PhGhvo66NRaGMi443BbZGg-1; Thu, 31 Aug 2023 07:07:27 -0400
X-MC-Unique: PhGhvo66NRaGMi443BbZGg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3A739823D66
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 21D2C40C6F4C
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:27 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/3] bcachefs: prepare journal buf put to handle pin put
Date:   Thu, 31 Aug 2023 07:07:33 -0400
Message-ID: <20230831110734.787212-3-bfoster@redhat.com>
In-Reply-To: <20230831110734.787212-1-bfoster@redhat.com>
References: <20230831110734.787212-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs freeze testing has uncovered some raciness between journal
entry open/close and pin list reference count management. The
details of the problem are described in a separate patch. In
preparation for the associated fix, refactor the journal buffer put
path a bit to allow it to eventually handle dropping the pin list
reference currently held by an open journal entry. Open code the
journal write dispatch since it is essentially a single line and
instead factor out the journal state update to be reused, consistent
with other journal state update helpers. No functional changes in
this patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c |  9 ---------
 fs/bcachefs/journal.h | 22 +++++++++++++++++-----
 2 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 055920c26da6..76ebcdb3e3b4 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -132,15 +132,6 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 	return stuck;
 }
 
-/* journal entry close/open: */
-
-void __bch2_journal_buf_put(struct journal *j)
-{
-	struct bch_fs *c = container_of(j, struct bch_fs, journal);
-
-	closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
-}
-
 /*
  * Returns true if journal entry is now closed:
  *
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 008a2e25a4fa..c7a31da077c9 100644
--- a/fs/bcachefs/journal.h
+++ b/fs/bcachefs/journal.h
@@ -252,9 +252,10 @@ static inline bool journal_entry_empty(struct jset *j)
 	return true;
 }
 
-void __bch2_journal_buf_put(struct journal *);
-
-static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
+/*
+ * Drop reference on a buffer index and return true if the count has hit zero.
+ */
+static inline union journal_res_state journal_state_buf_put(struct journal *j, unsigned idx)
 {
 	union journal_res_state s;
 
@@ -264,9 +265,20 @@ static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
 				    .buf2_count = idx == 2,
 				    .buf3_count = idx == 3,
 				    }).v, &j->reservations.counter);
+	return s;
+}
 
-	if (!journal_state_count(s, idx) && idx == s.unwritten_idx)
-		__bch2_journal_buf_put(j);
+void bch2_journal_write(struct closure *);
+static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
+{
+	struct bch_fs *c = container_of(j, struct bch_fs, journal);
+	union journal_res_state s;
+
+	s = journal_state_buf_put(j, idx);
+	if (!journal_state_count(s, idx)) {
+		if (idx == s.unwritten_idx)
+			closure_call(&j->io, bch2_journal_write, c->io_complete_wq, NULL);
+	}
 }
 
 /*
-- 
2.41.0

