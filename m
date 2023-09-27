Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CD7BE810D3
	for <linux-bcachefs@archiver.kernel.org>; Wed, 27 Sep 2023 11:24:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjI0LYM (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 27 Sep 2023 07:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjI0LYL (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 27 Sep 2023 07:24:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715841A8
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 04:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695813802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ilW3W6hRwqOqqVSueVCyUYjt972Lek54waw1yQiuBn0=;
        b=fubuPtx0t/kEfWqlhEB/7GfZ9rL3PnxzdFobzKJL+lxbXr78TQGDpcPzLBN8DzU0N9KbjW
        Ogsi59lLVfblI2uATitHipCJeW3HBNLt5WesBmx5kwBaSMXiZKHaEo3oabq0BnBpun9Wdt
        Q3xmkWxIvVsXyp+0L4La6y7WljQ+kT0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-6GXcJZG-Mt6oE0eO_v_8pA-1; Wed, 27 Sep 2023 07:23:21 -0400
X-MC-Unique: 6GXcJZG-Mt6oE0eO_v_8pA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E909A280FEC6
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE7EE2156A27
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Sep 2023 11:23:20 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: remove writeback bio size limit
Date:   Wed, 27 Sep 2023 07:23:38 -0400
Message-ID: <20230927112338.262207-3-bfoster@redhat.com>
In-Reply-To: <20230927112338.262207-1-bfoster@redhat.com>
References: <20230927112338.262207-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The bcachefs folio writeback code includes a bio full check as well
as a fixed size check when it determines whether to submit the
current write op or continue to add to the current bio. The current
code submits prematurely when the current folio fits exactly in the
remaining space allowed in the current bio, which typically results
in an extent merge that would have otherwise been unnecessary. This
can be observed with a buffered write sized exactly to the current
maximum value (1MB) and with key_merging_disabled=1. The latter
prevents the merge from the second write such that a subsequent
check of the extent list shows a 1020k extent followed by a
contiguous 4k extent.

It's not totally clear why the fixed write size check exists.
bio_full() already checks that the bio can accommodate the current
dirty range being processed, so the only other concern is write
latency. Even then, a 1MB cap seems rather small. For reference,
iomap includes a folio batch size (of 4k) to mitigate latency
associated with writeback completion folio processing, but that
restricts writeback bios to somewhere in the range of 16MB-256MB
depending on folio size (i.e. considering 4k to 64k pages). Unless
there is some known reason for it, remove the size limit and rely on
bio_full() to cap the size of the bio.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs-io-buffered.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/bcachefs/fs-io-buffered.c b/fs/bcachefs/fs-io-buffered.c
index 58ccc7b91ac7..d438b93a3a30 100644
--- a/fs/bcachefs/fs-io-buffered.c
+++ b/fs/bcachefs/fs-io-buffered.c
@@ -607,8 +607,6 @@ static int __bch2_writepage(struct folio *folio,
 		if (w->io &&
 		    (w->io->op.res.nr_replicas != nr_replicas_this_write ||
 		     bio_full(&w->io->op.wbio.bio, sectors << 9) ||
-		     w->io->op.wbio.bio.bi_iter.bi_size + (sectors << 9) >=
-		     (BIO_MAX_VECS * PAGE_SIZE) ||
 		     bio_end_sector(&w->io->op.wbio.bio) != sector))
 			bch2_writepage_do_io(w);
 
-- 
2.41.0

