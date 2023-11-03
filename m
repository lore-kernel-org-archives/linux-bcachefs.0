Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DD64C0018A
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 13:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbjKCNJw (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 09:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233010AbjKCNJv (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 09:09:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E250BD4C
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699016939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EWw/g4mHbPRnAD0n7ej1Tkp9hDjfxZYHfrdEr5QC0pg=;
        b=H3IMukx7IsBjNcoDDHcPoMIkURXarPbA/Rhtrc+Qdc3WsMcbVuIGQXcc8wlgFLR2ZG/o/Q
        7pPZa/ofmd/k7z7VOsQ+2Lkn39icYk7Im3hNgirzm2r2tIJDtUplh78gF+0kbRRFUyjhYd
        bnxVCWeB4sCN25TYFAfoqdcGN32SAh4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-308-6ZSBZ3kQN4ONm20wtFRoFA-1; Fri,
 03 Nov 2023 09:08:58 -0400
X-MC-Unique: 6ZSBZ3kQN4ONm20wtFRoFA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5341F3C0E202
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37E971C060BA
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 0/3] bcachefs: writeback and byte-order misc fixes
Date:   Fri,  3 Nov 2023 09:09:35 -0400
Message-ID: <20231103130938.8925-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Hi all,

This series is a repost of a handful of patches that happened to have
fallen through the cracks. Patch 1 relates back to the discussion[1] on
increasing the writeback bio size limit. We can't safely do that until
the bounce path can be enhanced to handle larger sizes, but we can at
least fix the writeback code to completely fill the bio. Patches 2-3 are
a couple more byte order fixes that were uncovered by swapping an
on-disk filesystem between big and little endian machines. As of these
two, I've not encountered any further byte-order issues via this sort of
test.

All three of these patches have been soaking in my test branch [2] for
quite some time. Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-bcachefs/20230927112338.262207-3-bfoster@redhat.com/
[2] https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian Foster (3):
  bcachefs: allow writeback to fill bio completely
  bcachefs: byte order swap bch_alloc_v4.fragmentation_lru field
  bcachefs: use swab40 for bch_backpointer.bucket_offset bitfield

 fs/bcachefs/alloc_background.c | 10 +---------
 fs/bcachefs/backpointers.c     |  2 +-
 fs/bcachefs/backpointers.h     |  9 +++++++++
 fs/bcachefs/fs-io-buffered.c   | 19 ++++++++++++++++---
 4 files changed, 27 insertions(+), 13 deletions(-)

-- 
2.41.0

