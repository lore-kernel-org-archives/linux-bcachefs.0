Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1EAFEB64DD
	for <linux-bcachefs@archiver.kernel.org>; Wed, 12 Jul 2023 21:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjGLVMG (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 12 Jul 2023 17:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjGLVLn (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 12 Jul 2023 17:11:43 -0400
Received: from out-14.mta1.migadu.com (out-14.mta1.migadu.com [IPv6:2001:41d0:203:375::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD12117
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Jul 2023 14:11:36 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1689196295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0hovXn5ip36DS/VfaxiJk0ApcnzjAAiHK50gEPXD0AU=;
        b=WcemNL3t7opXlf9AhNpewUVTMjWvJl+V8SwttlLTiaj6COPlMXyPbeCKoU9XJvFnhhNOa9
        roGp+n2upHMzzwVHvO+a6XfY+n/LuQyLHaxs/1510WsHWDp3rxHTHr7XUAw4xTJ6tWIquM
        F6FxDnRwkEQJVObpHKdZtYvQYn4pPD0=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: [PATCH 06/20] block: Bring back zero_fill_bio_iter
Date:   Wed, 12 Jul 2023 17:11:01 -0400
Message-Id: <20230712211115.2174650-7-kent.overstreet@linux.dev>
In-Reply-To: <20230712211115.2174650-1-kent.overstreet@linux.dev>
References: <20230712211115.2174650-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

This reverts 6f822e1b5d9dda3d20e87365de138046e3baa03a - this helper is
used by bcachefs.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org
---
 block/bio.c         | 6 +++---
 include/linux/bio.h | 7 ++++++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e74a04ea14..70b5c987bc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -606,15 +606,15 @@ struct bio *bio_kmalloc(unsigned short nr_vecs, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(bio_kmalloc);
 
-void zero_fill_bio(struct bio *bio)
+void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
 {
 	struct bio_vec bv;
 	struct bvec_iter iter;
 
-	bio_for_each_segment(bv, bio, iter)
+	__bio_for_each_segment(bv, bio, iter, start)
 		memzero_bvec(&bv);
 }
-EXPORT_SYMBOL(zero_fill_bio);
+EXPORT_SYMBOL(zero_fill_bio_iter);
 
 /**
  * bio_truncate - truncate the bio to small size of @new_size
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b3e7529ff5..f2620f8d18 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -484,7 +484,12 @@ extern void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern void bio_free_pages(struct bio *bio);
 void guard_bio_eod(struct bio *bio);
-void zero_fill_bio(struct bio *bio);
+void zero_fill_bio_iter(struct bio *bio, struct bvec_iter iter);
+
+static inline void zero_fill_bio(struct bio *bio)
+{
+	zero_fill_bio_iter(bio, bio->bi_iter);
+}
 
 static inline void bio_release_pages(struct bio *bio, bool mark_dirty)
 {
-- 
2.40.1

