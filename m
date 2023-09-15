Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 200D3EE6457
	for <linux-bcachefs@archiver.kernel.org>; Fri, 15 Sep 2023 12:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbjIOMwd (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 15 Sep 2023 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234962AbjIOMwc (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 15 Sep 2023 08:52:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE07F173A
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694782301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UphxWAA8MaHGbMVdk287zg67CkBcopACibFdR0o/fnY=;
        b=gB5kjOcfxcB82SOcM7HO/xx58kBAF3Q+O4iQ47y23ZF9hvnA1l8UaKs7ztbCy3gZFKxtk7
        xrtfzQVhRIlhS7F/1QaDxcWh4Y99SDT8l6fORgEKpRnRZhoY0S0QAu6ub+1nJeb2HLoRld
        UWEhFGZX0ubxj43/bVVimWlFv+4EEK8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-1OTGJQR_OR-705kJjdvIdw-1; Fri, 15 Sep 2023 08:51:40 -0400
X-MC-Unique: 1OTGJQR_OR-705kJjdvIdw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1547D185A78E
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:40 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE92E10F1BE7
        for <linux-bcachefs@vger.kernel.org>; Fri, 15 Sep 2023 12:51:39 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH v2 1/4] bcachefs: refactor pin put helpers
Date:   Fri, 15 Sep 2023 08:51:51 -0400
Message-ID: <20230915125154.307450-2-bfoster@redhat.com>
In-Reply-To: <20230915125154.307450-1-bfoster@redhat.com>
References: <20230915125154.307450-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

We have a couple journal pin put helpers to handle cases where the
journal lock is already held or not. Refactor the helpers to lock
and reclaim from the highest level and open code the reclaim from
the one caller of the internal variant. The latter call will be
moved into the journal buf release helper in a later patch.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c         |  3 ++-
 fs/bcachefs/journal_reclaim.c | 11 ++++-------
 fs/bcachefs/journal_reclaim.h |  3 ++-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index ad80618d1740..210a2b90bb50 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -204,7 +204,8 @@ static void __journal_entry_close(struct journal *j, unsigned closed_val)
 	buf->data->last_seq	= cpu_to_le64(buf->last_seq);
 	BUG_ON(buf->last_seq > le64_to_cpu(buf->data->seq));
 
-	__bch2_journal_pin_put(j, le64_to_cpu(buf->data->seq));
+	if (__bch2_journal_pin_put(j, le64_to_cpu(buf->data->seq)))
+		bch2_journal_reclaim_fast(j);
 
 	cancel_delayed_work(&j->write_work);
 
diff --git a/fs/bcachefs/journal_reclaim.c b/fs/bcachefs/journal_reclaim.c
index 1f3d5890ff11..9a584aaaa2eb 100644
--- a/fs/bcachefs/journal_reclaim.c
+++ b/fs/bcachefs/journal_reclaim.c
@@ -290,7 +290,7 @@ void bch2_journal_do_discards(struct journal *j)
  * entry, holding it open to ensure it gets replayed during recovery:
  */
 
-static void bch2_journal_reclaim_fast(struct journal *j)
+void bch2_journal_reclaim_fast(struct journal *j)
 {
 	bool popped = false;
 
@@ -310,19 +310,16 @@ static void bch2_journal_reclaim_fast(struct journal *j)
 		bch2_journal_space_available(j);
 }
 
-void __bch2_journal_pin_put(struct journal *j, u64 seq)
+bool __bch2_journal_pin_put(struct journal *j, u64 seq)
 {
 	struct journal_entry_pin_list *pin_list = journal_seq_pin(j, seq);
 
-	if (atomic_dec_and_test(&pin_list->count))
-		bch2_journal_reclaim_fast(j);
+	return atomic_dec_and_test(&pin_list->count);
 }
 
 void bch2_journal_pin_put(struct journal *j, u64 seq)
 {
-	struct journal_entry_pin_list *pin_list = journal_seq_pin(j, seq);
-
-	if (atomic_dec_and_test(&pin_list->count)) {
+	if (__bch2_journal_pin_put(j, seq)) {
 		spin_lock(&j->lock);
 		bch2_journal_reclaim_fast(j);
 		spin_unlock(&j->lock);
diff --git a/fs/bcachefs/journal_reclaim.h b/fs/bcachefs/journal_reclaim.h
index 0fd1af120db5..494d1a6eddb0 100644
--- a/fs/bcachefs/journal_reclaim.h
+++ b/fs/bcachefs/journal_reclaim.h
@@ -31,7 +31,8 @@ journal_seq_pin(struct journal *j, u64 seq)
 	return &j->pin.data[seq & j->pin.mask];
 }
 
-void __bch2_journal_pin_put(struct journal *, u64);
+void bch2_journal_reclaim_fast(struct journal *);
+bool __bch2_journal_pin_put(struct journal *, u64);
 void bch2_journal_pin_put(struct journal *, u64);
 void bch2_journal_pin_drop(struct journal *, struct journal_entry_pin *);
 
-- 
2.41.0

