Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78BD9C76195
	for <linux-bcachefs@archiver.kernel.org>; Tue, 21 Mar 2023 13:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCUNTy (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 21 Mar 2023 09:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUNTu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 21 Mar 2023 09:19:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967539ED1
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 06:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679404710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=btjskSVW5ybxLbqsgnWC3rdqjMZFl3uQmt5sPG9n1Io=;
        b=OTXlKpXEg5NWcCq3YyvkA0DtwWPlCVR7kxYTfKK+subuiqwcyMnxgPriOyf3IJwiQWB/qe
        bn3HVCC8Tx98rwXLgTJ62bZ1y4XZmhBQlb/r2ASBn4lwL+sfPHAgEH+LVkrpB1rvrfsodN
        Io1npy5FZD9TU2luSOFgIy8lznOVuC8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-fBo9NuaLOkCFOo-v05faOw-1; Tue, 21 Mar 2023 09:18:29 -0400
X-MC-Unique: fBo9NuaLOkCFOo-v05faOw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D715D85531C
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF12485768
        for <linux-bcachefs@vger.kernel.org>; Tue, 21 Mar 2023 13:18:28 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/5] bcachefs: gracefully unwind journal res slowpath on shutdown
Date:   Tue, 21 Mar 2023 09:20:11 -0400
Message-Id: <20230321132014.1438249-3-bfoster@redhat.com>
In-Reply-To: <20230321132014.1438249-1-bfoster@redhat.com>
References: <20230321132014.1438249-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs detects journal stuck conditions in a couple different
places. If the logic in the journal reservation slow path happens to
detect the problem, I've seen instances where the filesystem remains
deadlocked even though it has been shut down. This is occasionally
reproduced by generic/333, and usually manifests as one or more
tasks stuck in the journal reservation slow path.

To help avoid this problem, repeat the journal error check in
__journal_res_get() once under spinlock to cover the case where the
previous lock holder might have triggered shutdown. This also helps
avoid spurious/duplicate stuck reports. Also, wake the journal from
the halt code to make sure blocked callers of the journal res
slowpath have a chance to wake up and observe the pending error.
This survives an overnight looping run of generic/333 without the
aforementioned lockups.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/journal.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index c9c2ee9c67f6..f521f733e180 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -163,6 +163,7 @@ void bch2_journal_halt(struct journal *j)
 	__journal_entry_close(j, JOURNAL_ENTRY_ERROR_VAL);
 	if (!j->err_seq)
 		j->err_seq = journal_cur_seq(j);
+	journal_wake(j);
 	spin_unlock(&j->lock);
 }
 
@@ -363,6 +364,12 @@ static int __journal_res_get(struct journal *j, struct journal_res *res,
 
 	spin_lock(&j->lock);
 
+	/* check once more in case somebody else shut things down... */
+	if (bch2_journal_error(j)) {
+		spin_unlock(&j->lock);
+		return -BCH_ERR_erofs_journal_err;
+	}
+
 	/*
 	 * Recheck after taking the lock, so we don't race with another thread
 	 * that just did journal_entry_open() and call journal_entry_close()
-- 
2.39.2

