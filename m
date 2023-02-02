Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CE7C05027
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Feb 2023 15:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231485AbjBBPpV (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Feb 2023 10:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbjBBPpK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Feb 2023 10:45:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE504C16
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 07:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675352589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Meed+2Wr2I71l5H23/pgUPFDxlpFeWoxa7x6RZonw+g=;
        b=eu7V8X5ap8p3BGzpECheCcqhoTElXp78y7vypN2DJ6INq6h3V27D+iLx+9V3wJ+PioLK8n
        7rrdnpTnU+Vd4K6nO0CSyVm6F05UdnV4eu5mHA8WdL/kJ20F8+w+IY8ZtqiPRwRshYbl92
        VH1AyJOZ8B+S0tTx7Lgb8yv+lYacgWY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-XA88tBsMO66ErQLbTXcKEg-1; Thu, 02 Feb 2023 10:37:03 -0500
X-MC-Unique: XA88tBsMO66ErQLbTXcKEg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDB6D101AA63
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 15:37:02 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.154])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A0B57492C18
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Feb 2023 15:37:02 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: return from fsync on writeback error to avoid early shutdown
Date:   Thu,  2 Feb 2023 10:38:19 -0500
Message-Id: <20230202153819.536496-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

When investigating transient failures of generic/441 on bcachefs, it
was determined that the cause of the failure was a combination of
unconditional emergency shutdown and racing between background
journal activity and the test switchover from a working device
mapper table to an error injecting table.

Part of the reason for this sequence of events is that bcachefs
aggressively flushes as much as possible during fsync(), regardless
of errors. While this is reasonable behavior, it is technically
unnecessary because once an error is returned from fsync(), the
caller cannot make any assumptions about the resilience of data.

Tweak the bch2_fsync() logic to return an error on failure of any of
the steps involved in the flush. Note that this change alone does
not prevent generic/441 failure, but in combination with a test
tweak to avoid racing during the dm-error table switchover it avoids
the unnecessary shutdowns and allows the test to pass reliably on
bcachefs.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/fs-io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index c32ac17e2d28..86f2a5e46ffd 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -2579,13 +2579,17 @@ int bch2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct bch_inode_info *inode = file_bch_inode(file);
 	struct bch_fs *c = inode->v.i_sb->s_fs_info;
-	int ret, ret2, ret3;
+	int ret;
 
 	ret = file_write_and_wait_range(file, start, end);
-	ret2 = sync_inode_metadata(&inode->v, 1);
-	ret3 = bch2_flush_inode(c, inode);
-
-	return bch2_err_class(ret ?: ret2 ?: ret3);
+	if (ret)
+		goto out;
+	ret = sync_inode_metadata(&inode->v, 1);
+	if (ret)
+		goto out;
+	ret = bch2_flush_inode(c, inode);
+out:
+	return bch2_err_class(ret);
 }
 
 /* truncate: */
-- 
2.39.1

