Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3287E95A8E
	for <linux-bcachefs@archiver.kernel.org>; Mon,  9 Oct 2023 14:29:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376838AbjJIO3b (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 9 Oct 2023 10:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376790AbjJIO3a (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 9 Oct 2023 10:29:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3F4BA
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696861729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XLs5MhCSynMxeWKSlB+STen/pAq6FXJwSAN558Bop9Y=;
        b=cH7dLuTh5MG5lw6fKp51PYnWLGAwom4ytv7ymPvaIEE6mGnQjsZ32Vx1N1J+dOyXfYhQCJ
        enpn+tcVBrvylqYAN4OFARIJ6oBb+cPUE7055MzwTuWcc1N1sfE81PxqPADxDa6/rgNn1w
        fwCC0OAU+j0KzspCOGuY5GKUvEjytgc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-CVDbz3P6PSCndIUT7TALOA-1; Mon, 09 Oct 2023 10:28:37 -0400
X-MC-Unique: CVDbz3P6PSCndIUT7TALOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A040A3C176E4
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 14:28:37 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.8.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D6E492B16
        for <linux-bcachefs@vger.kernel.org>; Mon,  9 Oct 2023 14:28:37 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH 2/2] bcachefs: use swab40 for bch_backpointer.bucket_offset bitfield
Date:   Mon,  9 Oct 2023 10:28:55 -0400
Message-ID: <20231009142855.786953-1-bfoster@redhat.com>
In-Reply-To: <20231009122033.772265-1-bfoster@redhat.com>
References: <20231009122033.772265-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

Here's another one I just tacked on that seems to address the
backpointer related problems when switching CPU byte order...

Brian

 fs/bcachefs/alloc_background.c | 9 ---------
 fs/bcachefs/backpointers.c     | 2 +-
 fs/bcachefs/backpointers.h     | 9 +++++++++
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
index 26b19ccad89b..6380de7cd90f 100644
--- a/fs/bcachefs/alloc_background.c
+++ b/fs/bcachefs/alloc_background.c
@@ -302,15 +302,6 @@ int bch2_alloc_v4_invalid(const struct bch_fs *c, struct bkey_s_c k,
 	return 0;
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
index cc856150a948..b9955f937657 100644
--- a/fs/bcachefs/backpointers.c
+++ b/fs/bcachefs/backpointers.c
@@ -76,7 +76,7 @@ void bch2_backpointer_swab(struct bkey_s k)
 {
 	struct bkey_s_backpointer bp = bkey_s_to_backpointer(k);
 
-	bp.v->bucket_offset	= swab32(bp.v->bucket_offset);
+	bp.v->bucket_offset	= swab40(bp.v->bucket_offset);
 	bp.v->bucket_len	= swab32(bp.v->bucket_len);
 	bch2_bpos_swab(&bp.v->pos);
 }
diff --git a/fs/bcachefs/backpointers.h b/fs/bcachefs/backpointers.h
index 547e0617602a..b0006e656f3a 100644
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
 int bch2_backpointer_invalid(const struct bch_fs *, struct bkey_s_c k,
 			     enum bkey_invalid_flags, struct printbuf *);
 void bch2_backpointer_to_text(struct printbuf *, const struct bch_backpointer *);
-- 
2.41.0

