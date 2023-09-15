Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 998FAEE645B
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235128AbjIOMwc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235023AbjIOMwc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC5D4E7E
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694782301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jWzSGU82bDQ12DKJ8YpgGd8CTll1dTigc+PqAKopkZI=;
        b=PZjLdmXdg1MUHKmpKFR2WNRiLmcV5wobjcy3ogrCyGxW2Wtkoeakp8vuLA91hpBZGHooRn
        xva5KB9ASreD8Vl3l2dQIqtMI4P4H+YBUK8hA5jZTbNj8SFoI+S6aJnnddKHwT+T16rakd
        Yf29NFNDtQ3DFV12sjJcT1B4yuEqGmE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-EgGeTRnPPwyGo_yWIQRQ2A-1; Fri, 15 Sep 2023 08:51:40 -0400
X-MC-Unique: EgGeTRnPPwyGo_yWIQRQ2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 394AE185A790
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F5A81004145
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 2/4] bcachefs: prepare journal buf put to handle pin put
Date:   Fri, 15 Sep 2023 08:51:52 -0400
Message-ID: <20230915125154.307450-3-bfoster@redhat.com>
In-Reply-To: <20230915125154.307450-1-bfoster@redhat.com>
References: <20230915125154.307450-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs freeze testing has uncovered some raciness between journal
entry open/close and pin list reference count management. The
details of the problem are described in a separate patch. In
preparation for the associated fix, refactor the journal buffer put
path a bit to allow it to eventually handle dropping the pin list
reference currently held by an open journal entry.

Retain the journal write dispatch helper since the closure code is
inlined and we don't want to increase the amount of inline code in
the transaction commit path, but rename the function to reflect
the purpose of final processing of the journal buffer.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c |  2 +-
 fs/bcachefs/journal.h | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 210a2b90bb50..be61d43458eb 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -134,7 +134,7 @@ journal_error_check_stuck(struct journal *j, int error, unsigned flags)
 
 /* journal entry close/open: */
 
-void __bch2_journal_buf_put(struct journal *j)
+void bch2_journal_buf_put_final(struct journal *j)
 {
 	struct bch_fs *c = container_of(j, struct bch_fs, journal);
 
diff --git a/fs/bcachefs/journal.h b/fs/bcachefs/journal.h
index 008a2e25a4fa..0a53a2142594 100644
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
+
+void bch2_journal_buf_put_final(struct journal *);
 
-	if (!journal_state_count(s, idx) && idx == s.unwritten_idx)
-		__bch2_journal_buf_put(j);
+static inline void bch2_journal_buf_put(struct journal *j, unsigned idx)
+{
+	union journal_res_state s;
+
+	s = journal_state_buf_put(j, idx);
+	if (!journal_state_count(s, idx)) {
+		if (idx == s.unwritten_idx)
+			bch2_journal_buf_put_final(j);
+	}
 }
 
 /*
-- 
2.41.0

