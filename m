Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A81EE0212
	for <linux-bcachefs@archiver.kernel.org>; Thu, 14 Sep 2023 00:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbjINAiD (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjINAiD (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 13 Sep 2023 20:38:03 -0400
Received: from out-211.mta1.migadu.com (out-211.mta1.migadu.com [95.215.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F44E6A
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Sep 2023 17:37:58 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1694651877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GCLIozWIOZLSUJr4lBeSfbruy0V2JOnAzxKx12zcw6c=;
        b=eTuv2DtlklbDZFIttULxeHHCXqA/jIccGfs3ZEoGsuYxh5uNLltMqQ5O5lY0eH/3+XQh5S
        888YSN61LbZShFXTOUeMtuiolQOajvmC39R4o80GSqyxcfK9pgV41FjwoL6Wpp+tvKHsbY
        hQYTrxJiTI9tc32Ee08jlln+OyJsVb0=
From:   Kent Overstreet <kent.overstreet@linux.dev>
Cc:     Kent Overstreet <kent.overstreet@linux.dev>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH] bcachefs: Change bucket_lock() to use bit_spin_lock()
Date:   Wed, 13 Sep 2023 20:37:46 -0400
Message-Id: <20230914003746.1039787-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bucket_lock() previously open coded a spinlock, because we need to cram
a spinlock into a single byte.

But it turns out not all archs support xchg() on a single byte; since we
need struct bucket to be small, this means we have to play fun games
with casts and ifdefs for endianness.

This fixes building on 32 bit arm, and likely other architectures.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
---
 fs/bcachefs/buckets.h | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/bcachefs/buckets.h b/fs/bcachefs/buckets.h
index f192809f50cf..e055c1076e63 100644
--- a/fs/bcachefs/buckets.h
+++ b/fs/bcachefs/buckets.h
@@ -40,15 +40,35 @@ static inline size_t sector_to_bucket_and_offset(const struct bch_dev *ca, secto
 	for (_b = (_buckets)->b + (_buckets)->first_bucket;	\
 	     _b < (_buckets)->b + (_buckets)->nbuckets; _b++)
 
+/*
+ * Ugly hack alert:
+ *
+ * We need to cram a spinlock in a single byte, because that's what we have left
+ * in struct bucket, and we care about the size of these - during fsck, we need
+ * in memory state for every single bucket on every device.
+ *
+ * We used to do
+ *   while (xchg(&b->lock, 1) cpu_relax();
+ * but, it turns out not all architectures support xchg on a single byte.
+ *
+ * So now we use bit_spin_lock(), with fun games since we can't burn a whole
+ * ulong for this.
+ */
+
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define BUCKET_LOCK_BITNR	0
+#else
+#define BUCKET_LOCK_BITNR	(BITS_PER_LONG - 1)
+#endif
+
 static inline void bucket_unlock(struct bucket *b)
 {
-	smp_store_release(&b->lock, 0);
+	bit_unspin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);
 }
 
 static inline void bucket_lock(struct bucket *b)
 {
-	while (xchg(&b->lock, 1))
-		cpu_relax();
+	bit_spin_lock(BUCKET_LOCK_BITNR, (void *) &b->lock);
 }
 
 static inline struct bucket_array *gc_bucket_array(struct bch_dev *ca)
-- 
2.40.1

