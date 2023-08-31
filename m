Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B87C83F01
	for <linux-bcachefs@archiver.kernel.org>; Thu, 31 Aug 2023 11:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbjHaLIp (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 31 Aug 2023 07:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245215AbjHaLIo (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 31 Aug 2023 07:08:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DED1E66
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 04:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693480050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aa5xn8qOUyRCiX/9aptwXKDmS8oBNKPPMMj6LtID4+s=;
        b=OQp0pbsmUxahhpmwOw5bRgDPSFPEKgSyoBpR9KgWAfPvBoiYcxy9V7r0mwt7kvls0Yu1LV
        qN+aTTiLRBFNryssU16XzZ/bUR5ug+acA/Iq19n0UDv6Pjw/LWIJ+HXleoRobBc4TDyRIH
        lnanNL5zYX+O4dJpXBFXQ/6Y7ECPjy0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-161-9Owv0NqbM6i1H6AxGuCdVQ-1; Thu, 31 Aug 2023 07:07:27 -0400
X-MC-Unique: 9Owv0NqbM6i1H6AxGuCdVQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1489F80CC34
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:27 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF9C240C6F4C
        for <linux-bcachefs@vger.kernel.org>; Thu, 31 Aug 2023 11:07:26 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/3] bcachefs: restart journal reclaim thread on ro->rw transitions
Date:   Thu, 31 Aug 2023 07:07:32 -0400
Message-ID: <20230831110734.787212-2-bfoster@redhat.com>
In-Reply-To: <20230831110734.787212-1-bfoster@redhat.com>
References: <20230831110734.787212-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Commit c2d5ff36065a4 ("bcachefs: Start journal reclaim thread
earlier") tweaked reclaim thread management to start a bit earlier
in the mount sequence by moving the start call from
__bch2_fs_read_write() to bch2_fs_journal_start(). This has the side
effect of never starting the reclaim thread on a ro->rw transition,
which can be observed by monitoring reclaim behavior via the
journal_reclaim tracepoints. I.e. once an fs has remounted ro->rw,
we only ever rely on direct reclaim from that point forward.

Since bch2_journal_reclaim_start() properly handles the case where
the reclaim thread has already been created, restore the start call
in the read-write helper. This allows the reclaim thread to start
early when appropriate and also exit/restart on remounts or freeze
cycles. In the latter case it may be possible to simply allow the
task to freeze rather than destroy it, but for now just fix the
immediate bug.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/bcachefs/super.c b/fs/bcachefs/super.c
index 60424865980d..29cd71445a94 100644
--- a/fs/bcachefs/super.c
+++ b/fs/bcachefs/super.c
@@ -421,6 +421,10 @@ static int __bch2_fs_read_write(struct bch_fs *c, bool early)
 		return ret;
 	}
 
+	ret = bch2_journal_reclaim_start(&c->journal);
+	if (ret)
+		goto err;
+
 	if (!early) {
 		ret = bch2_fs_read_write_late(c);
 		if (ret)
-- 
2.41.0

