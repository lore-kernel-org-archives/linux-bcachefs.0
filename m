Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE22C4167B
	for <linux-bcachefs@archiver.kernel.org>; Mon, 12 Dec 2022 19:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232880AbiLLTG7 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 12 Dec 2022 14:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiLLTG5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 12 Dec 2022 14:06:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72C61B7A
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Dec 2022 11:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670871960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cnfghsS4Hleqd3MOjvi7pAkRK4BrhF0XAHWzyjPgVL8=;
        b=S6emihivQwqcv0rDm8LpWOw6pAinFPQpY8mZ7UFptHt4cTZgqlG35zLbccdOkt4rwVv8Pw
        YreyjcuNrx+rk6/FDu+bGYCsdt6L/nAyDfKiT9ozVdAPfKVQHKhniGL0BgbqEUFuZTpR0b
        PPXVOIOm9ph1sVoBSA2dps44dzm+TIw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-xhioR_lSMxaoWu1sNs7qDA-1; Mon, 12 Dec 2022 14:05:58 -0500
X-MC-Unique: xhioR_lSMxaoWu1sNs7qDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3642B806003
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Dec 2022 19:05:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E24A4085720
        for <linux-bcachefs@vger.kernel.org>; Mon, 12 Dec 2022 19:05:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH RFC] bcachefs: use inode as write point index instead of task
Date:   Mon, 12 Dec 2022 14:06:02 -0500
Message-Id: <20221212190602.1388127-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Use the pointer to the current in-core inode object as the hash of
the write point associated with block allocation for buffered
writes.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi bcachefs folks,

I'm posting this RFC more as a discussion point than a direct proposal.
I've been poking around a bit at bcachefs just to grok some of the
basics and whatnot and ended up digging down into the block allocation
code a bit. From there I was trying to make sense of the bucket and
write point abstractions, and then noticed that the write point
structure used to track allocation/write contexts is hashed by task.
IIUC, that means a single task that might be writing to multiple files
will do so via a single write point, or conversely multiple tasks that
might be writing to a single file would do so with multiple write points
(one associated with each task). In turn, that means the allocation
layout of a particular file might be a characteristic of the set of
tasks that initially wrote the file as opposed to something more
traditional based on inode locality.

In thinking about this a bit more, it seems logical that this derives
from bcache because it seems like a perfectly good cache allocation
policy. I suppose it might make sense in certain filesystem workloads
where per-file contiguity might no longer necessarily be the most
important thing in the world, but I'm curious if that is intentional for
bcachefs (the approach is documented, after all) and if there are any
particular workloads or use cases in mind for that sort of approach?

Even if it makes sense in some cases, I wonder whether it's the ideal
approach across the board. For example, consider how the task is tracked
through the inode from buffered write to writeback contexts so the
latter can locate the write point for the last task that wrote to the
file. Even if multiple tasks perform buffered writes to a file, we only
really use the last task that wrote to the file before the current
writeback cycle. Absent frequent writebacks, wouldn't it make some sense
to just associate the write point with the current inode pointer and use
that to minimize per-inode fragmentation?

FWIW, I was able to run some oddball workloads that produce excessive
fragmentation by forcing frequent writeback activity, but my tests so
far are ad hoc and moreso just playing around to help understand
behavior. To be fair, more traditional filesystems don't necessarily
handle the same sort of tests terribly well either. What I found more
interesting is that with the small tweak from this RFC, the allocation
layout from bcachefs went from notably worse to notably better in that
kind of pathological workload. Thoughts?

Brian

 fs/bcachefs/fs-io.c | 5 +----
 fs/bcachefs/fs.h    | 1 -
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index e7ebb01b4d09..f0cb32f2c437 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -1389,7 +1389,7 @@ static void bch2_writepage_io_alloc(struct bch_fs *c,
 	op->target		= w->opts.foreground_target;
 	op->nr_replicas		= nr_replicas;
 	op->res.nr_replicas	= nr_replicas;
-	op->write_point		= writepoint_hashed(inode->ei_last_dirtied);
+	op->write_point		= writepoint_hashed((unsigned long) inode);
 	op->subvol		= inode->ei_subvol;
 	op->pos			= POS(inode->v.i_ino, sector);
 	op->end_io		= bch2_writepage_io_done;
@@ -1669,8 +1669,6 @@ int bch2_write_end(struct file *file, struct address_space *mapping,
 			SetPageUptodate(page);
 
 		bch2_set_page_dirty(c, inode, page, res, offset, copied);
-
-		inode->ei_last_dirtied = (unsigned long) current;
 	}
 
 	unlock_page(page);
@@ -1823,7 +1821,6 @@ static int __bch2_buffered_write(struct bch_inode_info *inode,
 	}
 
 	nr_pages_copied = DIV_ROUND_UP(offset + copied, PAGE_SIZE);
-	inode->ei_last_dirtied = (unsigned long) current;
 out:
 	for (i = nr_pages_copied; i < nr_pages; i++) {
 		unlock_page(pages[i]);
diff --git a/fs/bcachefs/fs.h b/fs/bcachefs/fs.h
index 6b91bbe91116..c963994a104a 100644
--- a/fs/bcachefs/fs.h
+++ b/fs/bcachefs/fs.h
@@ -17,7 +17,6 @@ struct bch_inode_info {
 
 	struct mutex		ei_update_lock;
 	u64			ei_quota_reserved;
-	unsigned long		ei_last_dirtied;
 
 	two_state_lock_t	ei_pagecache_lock;
 
-- 
2.37.3

