Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA8D5C4167B
	for <linux-bcachefs@archiver.kernel.org>; Fri,  3 Nov 2023 13:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbjKCNJv (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Fri, 3 Nov 2023 09:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjKCNJu (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Fri, 3 Nov 2023 09:09:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2535219D
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 06:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699016940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87NNK3e9taFp9JChUoPMrDpr+In+DWmOXuT+IJc5Zxo=;
        b=am4rEEJ8R/Ghs2j2+25aBGK1uj3WyC3/H9lzJ784GYRg7oxMI9aXscL/WzCldwo97XUyMh
        7Y+5TgAsMvvUsuSVcLYDTXuhNyyShPYsfSobktQbu9/qLftnV5CAwJWa86kFYQkoo7+1+E
        5YzQeTloZoTpXAproEXqWmZ32PFBd14=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-33-38LOE4D9MMiXuwQRsXU7zw-1; Fri, 03 Nov 2023 09:08:59 -0400
X-MC-Unique: 38LOE4D9MMiXuwQRsXU7zw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C9790810FC2
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF0891C060BA
        for <linux-bcachefs@vger.kernel.org>; Fri,  3 Nov 2023 13:08:58 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 3/3] bcachefs: use swab40 for bch_backpointer.bucket_offset bitfield
Date:   Fri,  3 Nov 2023 09:09:38 -0400
Message-ID: <20231103130938.8925-4-bfoster@redhat.com>
In-Reply-To: <20231103130938.8925-1-bfoster@redhat.com>
References: <20231103130938.8925-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

The bucket_offset field of bch_backpointer is a 40-bit bitfield, but the
bch2_backpointer_swab() helper uses swab32. This leads to inconsistency
when an on-disk fs is accessed from an opposite endian machine.

As it turns out, we already have an internal swab40() helper that is
used from the bch_alloc_v4 swab callback. Lift it into the backpointers
header file and use it consistently in both places.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/bcachefs/alloc_background.c | 9 ---------
 fs/bcachefs/backpointers.c     | 2 +-
 fs/bcachefs/backpointers.h     | 9 +++++++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index ad256a88cb5c..1fec0e67891f 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -297,15 +297,6 @@ int bch2_alloc_v4_invalid(struct bch_fs *c, struct bkey_s_c k,
 	return ret;
 }
 
-static inline u64 swab40(u64 x)
-{
-	return (((x & 0x00000000ffULL) << 32)|
-		((x & 0x000000ff00ULL) << 16)|
-		((x & 0x0000ff0000ULL) >>  0)|
-		((x & 0x00ff000000ULL) >> 16)|
-		((x & 0xff00000000ULL) >> 32));
-}
-
 void bch2_alloc_v4_swab(struct bkey_s k)
 {
 	struct bch_alloc_v4 *a = bkey_s_to_alloc_v4(k).v;
diff --git a/fs/bcachefs/backpointers.c b/fs/bcachefs/backpointers.c
index 3b79bde1ce2f..5ed96dddae08 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -77,7 +77,7 @@ void bch2_backpointer_swab(struct bkey_s k)
 {
 	struct bkey_s_backpointer bp = bkey_s_to_backpointer(k);
 
-	bp.v->bucket_offset	= swab32(bp.v->bucket_offset);
+	bp.v->bucket_offset	= swab40(bp.v->bucket_offset);
 	bp.v->bucket_len	= swab32(bp.v->bucket_len);
 	bch2_bpos_swab(&bp.v->pos);
 }
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 4ab9f3562912..ab866feeaf66 100644
--- a/fs/bcachefs/backpointers.h
+++ b/fs/bcachefs/backpointers.h
@@ -7,6 +7,15 @@
 #include "buckets.h"
 #include "super.h"
 
+static inline u64 swab40(u64 x)
+{
+	return (((x & 0x00000000ffULL) << 32)|
+		((x & 0x000000ff00ULL) << 16)|
+		((x & 0x0000ff0000ULL) >>  0)|
+		((x & 0x00ff000000ULL) >> 16)|
+		((x & 0xff00000000ULL) >> 32));
+}
+
 int bch2_backpointer_invalid(struct bch_fs *, struct bkey_s_c k,
 			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_backpointer_to_text(struct printbuf *, const struct bch_backpointer *);
-- 
2.41.0

