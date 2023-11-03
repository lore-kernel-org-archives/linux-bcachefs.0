Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54D72C4332F
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 13:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjKCNJv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 09:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjKCNJu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 09:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2607D4D
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 06:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699016940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBYbB4/30EWmdzwXoo3J7fCQ4Fnytzo0GPKfDe0OJ/E=;
        b=hzVlrqkDKVi9Uu5yCbzLqnpAewGQjb/7cnsjG5eRNDGuApVzYWAv4BIHlZxs00dQwrUSUG
        6godl2pm8txH/OqJSza4gr0WvYnY8PSIOq/wlXRTCUgne9ua3JJFZ7QUC9CziHXEV5pyos
        eYNHHp9vDpKzwO8xnQybzJWrAtQyO6Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-kk7iqVhPNJqiXwM5Hcidpg-1; Fri, 03 Nov 2023 09:08:58 -0400
X-MC-Unique: kk7iqVhPNJqiXwM5Hcidpg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A2F9D185A784
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87F7B1C060BA
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/3] bcachefs: byte order swap bch_alloc_v4.fragmentation_lru field
Date:   Fri,  3 Nov 2023 09:09:37 -0400
Message-ID: <20231103130938.8925-3-bfoster@redhat.com>
In-Reply-To: <20231103130938.8925-1-bfoster@redhat.com>
References: <20231103130938.8925-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
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
 fs/bcachefs/alloc_background.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index bcfae91667af..ad256a88cb5c 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -319,6 +319,7 @@ void bch2_alloc_v4_swab(struct bkey_s k)
 	a->io_time[1]		= swab64(a->io_time[1]);
 	a->stripe		= swab32(a->stripe);
 	a->nr_external_backpointers = swab32(a->nr_external_backpointers);
+	a->fragmentation_lru	= swab64(a->fragmentation_lru);
 
 	bps = alloc_v4_backpointers(a);
 	for (bp = bps; bp < bps + BCH_ALLOC_V4_NR_BACKPOINTERS(a); bp++) {
-- 
2.41.0

