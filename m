Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 219EFE95A8E
	for <linux-bcachefs@archiver.kernel.org>; Mon,  9 Oct 2023 12:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346429AbjJIMVR (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 9 Oct 2023 08:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346380AbjJIMVN (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 9 Oct 2023 08:21:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445B9132
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 05:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696854016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eNXrHJ4qVeZ1OmAcNnKvcZizCbbzjdgJxxkS3feNTe4=;
        b=G/w5vW5AS6YwzA26i+2s+42bm/vgVIuSkpI5ZLOB5e57Bz79hf+3No50MjzD8XY6fdhBOO
        fbwiebcUDal6VUcsCSBRHzCUUTtIEmZBX7Hp1KVfAug5TX0iIwjZmk+MspWplZTwPI1Mg9
        vyVKkOVQefkn0BnTne7EKF8xn9QoXgE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-rwoZzo4DMmOQAV1xJ_zqIQ-1; Mon, 09 Oct 2023 08:20:15 -0400
X-MC-Unique: rwoZzo4DMmOQAV1xJ_zqIQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DE0229AA3B2
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 12:20:15 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23C9640C6EA8
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 12:20:15 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: byte order swap bch_alloc_v4.fragmentation_lru field
Date:   Mon,  9 Oct 2023 08:20:33 -0400
Message-ID: <20231009122033.772265-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

A simple test to populate a filesystem on one CPU architecture and
fsck on an arch of the opposite byte order produces errors related
to the fragmentation LRU. This occurs because the 64-bit
fragmentation_lru field is not byte-order swapped when reads detect
that the on-disk/bset key values were written in opposite byte-order
of the current CPU.

Update the bch2_alloc_v4 swab callback to handle fragmentation_lru
as is done for other multi-byte fields. This doesn't affect existing
filesystems when accessed by CPUs of the same endianness because the
->swab() callback is only called when the bset flags indicate an
endianness mismatch between the CPU and on-disk data.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Pushed to my CI branch as well (on top of the writeback fix I sent a few
days or so ago...):

  https://evilpiepirate.org/~testdashboard/ci?branch=bfoster

Brian

 fs/bcachefs/alloc_background.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index d1c323fd3f0b..26b19ccad89b 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -324,6 +324,7 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 	a->io_time[1]		= swab64(a->io_time[1]);
 	a->stripe		= swab32(a->stripe);
 	a->nr_external_backpointers = swab32(a->nr_external_backpointers);
+	a->fragmentation_lru	= swab64(a->fragmentation_lru);
 
 	bps = alloc_v4_backpointers(a);
 	for (bp = bps; bp < bps + BCH_ALLOC_V4_NR_BACKPOINTERS(a); bp++) {
-- 
2.41.0

