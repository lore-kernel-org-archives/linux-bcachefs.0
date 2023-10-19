Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A460C46CA1
	for <linux-bcachefs@archiver.kernel.org>; Thu, 19 Oct 2023 13:28:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345960AbjJSN2I (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345945AbjJSN2H (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 19 Oct 2023 09:28:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E631106
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 06:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697722045;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=E0V07jbBBQkty44/FK72sIAtNozZ9GYKewpoNL4M+d0=;
        b=AsYoV6iwGmjJRSM6Y69jatat4TtGfbiYxNZJVh74oa7Xyd6bF7GcIXvDclbtFN/NOte67R
        inKGnNiPJR+SUCoyre5EcIU6JO72NOiN6F7VmU3t6WwS8mHFdCLCmoqlsGrl9/EgmPTqrz
        lJ/UsLxj2Ng2+Yjj1xjBDxrm1Of66FU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-YcA6s83VP4uzkrjTwKQ_dg-1; Thu, 19 Oct 2023 09:27:19 -0400
X-MC-Unique: YcA6s83VP4uzkrjTwKQ_dg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF38C1C07563
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 13:27:18 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82777492BEE
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Oct 2023 13:27:18 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: update alloc cursor in early bucket allocator
Date:   Thu, 19 Oct 2023 09:27:46 -0400
Message-ID: <20231019132746.279256-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

A recent bug report uncovered a scenario where a filesystem never
runs with freespace_initialized, and therefore the user observes
significantly degraded write performance by virtue of running the
early bucket allocator. The associated bug aside, the primary cause
of the performance drop in this particular instance is that the
early bucket allocator does not update the allocation cursor. This
means that every allocation walks the alloc btree from the first
bucket of the associated device looking for a bucket marked as free
space.

Update the early allocator code to set the alloc cursor to the
prospectively allocated bucket, similar to how the freelist
allocator behaves. This improves performance of the early bucket
allocator dramatically (even though it should be bypassed in favor
of the freelist allocator in most cases).

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

cshepherd on #bcache originally reported the early bucket allocator
problem and helped chase it down to what looks like a members_v2
regression. I believe he was planning to post a patch for that one.

Brian

 fs/bcachefs/alloc_foreground.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 3bc4abd3d7d5..be3fc0f38c79 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -431,7 +431,7 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	}
 	bch2_trans_iter_exit(trans, &iter);
 
-	ca->alloc_cursor = alloc_cursor;
+	ca->alloc_cursor = IS_ERR_OR_NULL(ob) ? alloc_cursor : ob->bucket;
 
 	if (!ob && ret)
 		ob = ERR_PTR(ret);
-- 
2.41.0

