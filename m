Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7BFC41535
	for <linux-bcachefs@archiver.kernel.org>; Wed,  1 Nov 2023 19:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjKATDG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 1 Nov 2023 15:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjKATDE (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 1 Nov 2023 15:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0578F7
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 12:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698865331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f0Yf5miKQ2u0WyI49z2G29Fn/XB3EFcIITgPXzLSY18=;
        b=egH15POzmobX2RH6h3kW1PfYAQDtW7Bminwo4Lm2sORkFyJBfdpoks87Qh6gyrg2vE7zo5
        w4WiKpZCr/rgm5xUQZS52v7z+fdk/jlWIVbX/BQflrdctHvb1IGuzL3nFmPp2YFa/9SoHV
        uC/HyWckLga3CWp8Qq6vr+OnEtfb+CM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-4PXNYuVRP0eAy6rg_IJrsQ-1; Wed,
 01 Nov 2023 15:02:09 -0400
X-MC-Unique: 4PXNYuVRP0eAy6rg_IJrsQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C4602806674
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:09 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.16.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2FC8140C6EBC
        for <linux-bcachefs@vger.kernel.org>; Wed,  1 Nov 2023 19:02:09 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: update alloc cursor in early bucket allocator
Date:   Wed,  1 Nov 2023 15:02:45 -0400
Message-ID: <20231101190245.478567-3-bfoster@redhat.com>
In-Reply-To: <20231101190245.478567-1-bfoster@redhat.com>
References: <20231101190245.478567-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
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

Update the early allocator code to set the alloc cursor to the last
processed position in the tree, similar to how the freelist
allocator behaves. With the alloc_cursor being updated, the retry
logic also needs to be updated to restart from the beginning of the
device when a free bucket is not available between the cursor and
the end of the device. Track the restart position in a first_bucket
variable to make the code a bit more easily readable and consistent
with the freelist allocator.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/alloc_foreground.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
index 75ecfc3472ce..b85c7765272f 100644
--- a/fs/bcachefs/alloc_foreground.c
+++ b/fs/bcachefs/alloc_foreground.c
@@ -402,8 +402,9 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	struct btree_iter iter, citer;
 	struct bkey_s_c k, ck;
 	struct open_bucket *ob = NULL;
-	u64 alloc_start = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
-	u64 alloc_cursor = max(alloc_start, READ_ONCE(ca->alloc_cursor));
+	u64 first_bucket = max_t(u64, ca->mi.first_bucket, ca->new_fs_bucket_idx);
+	u64 alloc_start = max(first_bucket, READ_ONCE(ca->alloc_cursor));
+	u64 alloc_cursor = alloc_start;
 	int ret;
 
 	/*
@@ -453,13 +454,14 @@ bch2_bucket_alloc_early(struct btree_trans *trans,
 	}
 	bch2_trans_iter_exit(trans, &iter);
 
+	alloc_cursor = iter.pos.offset;
 	ca->alloc_cursor = alloc_cursor;
 
 	if (!ob && ret)
 		ob = ERR_PTR(ret);
 
-	if (!ob && alloc_cursor > alloc_start) {
-		alloc_cursor = alloc_start;
+	if (!ob && alloc_start > first_bucket) {
+		alloc_cursor = alloc_start = first_bucket;
 		goto again;
 	}
 
-- 
2.41.0

