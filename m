Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56814CD5BC9
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Sep 2023 14:26:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjISO0p (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Sep 2023 10:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbjISO0p (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Sep 2023 10:26:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56152AD
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 07:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695133556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2FOK+Bs/gXCXsCPCYXsOmRdxL+Gv8dhHGTz37tSAPXg=;
        b=Oi6ysTH/yQeLFHbBM4Z7aAK9jZ2OSdw5RAgCQto78QupsDKHMKbNm3gCu/8Xh85mxbpgWa
        xoo7e13LBeBCmwIS4ARwaBHZJhfm9hLPBaGdC5YCmtrhoZcZz+GfvLwhS8Flc9MsPWlxNW
        1kUwSXqMY0UEr5cIBKmfHhCBrSRGFXo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-333-DxZ2bWPQNL2b8kOpZE_XyQ-1; Tue, 19 Sep 2023 10:25:54 -0400
X-MC-Unique: DxZ2bWPQNL2b8kOpZE_XyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 644CC3822E87
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 14:25:54 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.32.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B81540C6EBF
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Sep 2023 14:25:54 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-bcachefs@vger.kernel.org
Subject: [PATCH RFC] bcachefs-tools: fix endian problems between bit spinlocks and futexes
Date:   Tue, 19 Sep 2023 10:26:11 -0400
Message-ID: <20230919142611.36445-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

bcachefs format on a big-endian (s390x) machine crashes down in the
rhashtable code imported from the kernel. The reason this occurs
lies within the rht_lock() -> bit_spin_lock() code, the latter of
which casts bitmaps down to 32-bits to satisfy the requirements of
the futex interface.

The specific problem here is that a 64 -> 32 bit cast doesn't refer
to the lower 8 bytes on a big endian machine, which means setting
bit number 0 in the 32-bit map actually corresponds to bit 32 in the
64-bit map. The rhashtable code specifically uses bit zero of the
bucket pointer for exclusion and uses native bitops elsewhere (i.e.
__rht_ptr()) to identify NULL pointers. If bit 32 of the pointer is
set by the locking code instead of bit 0, an otherwise NULL pointer
looks like a non-NULL value and results in a segfault.

The bit spinlock code imported by the kernel is originally intended
to work with unsigned long. The kernel code is able to throttle the
cpu directly when under lock contention, while the userspace
implementation relies on the futex primitives to emulate reliable
blocking. Since the futex interface introduces the 32-bit
requirement, isolate the associated userspace hack to that
particular code.

Restore the native bitmap behavior of the bit spinlock code to
address the rhashtable problem described above. Since this is not
compatible with the futex interface, create a futex wrapper
specifically to convert the native bitmap type to a 32-bit virtual
address and mask value for the purposes of waiting/waking when under
lock contention.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

This is definitely hacky a la [1], but seems generally cleaner than the
current approach of casting all of the bitlock code to u32. It seems to
work in my testing so far, but we'll see if anybody has other ideas. I'm
not sure if anything in userspace currently produces enough contention
to rely on futexes frequently enough, so my testing so far has mainly
been utilizing the debugger to instrument some hacky behavior like
forcing an extra loop in bit_spin_lock() such that I can 1. observe the
values being passed along and 2. confirm that the futex actually blocks.
I've run through that sort of sequence on both x86_64 and s390x, and in
both cases using either bit 0 or a bit number larger than 32 (which
obviously subsequently breaks the rhashtable code, but at least allows
unit testing of the bit lock code).

Anyways, with this patch combined with Kent's bucket lock fix [1] (to
avoid an illegal instruction error) and the superblock feature endian
fix [2], I'm able to at least format and mount a bcachefs volume on
s390x. I still need to look into some runtime issues beyond that..

Brian

[1] https://lore.kernel.org/linux-bcachefs/20230914003746.1039787-1-kent.overstreet@linux.dev/
[2] https://lore.kernel.org/linux-bcachefs/20230915134025.317931-1-bfoster@redhat.com/

 include/linux/bit_spinlock.h | 62 +++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/include/linux/bit_spinlock.h b/include/linux/bit_spinlock.h
index 62b91af..873f08c 100644
--- a/include/linux/bit_spinlock.h
+++ b/include/linux/bit_spinlock.h
@@ -6,38 +6,78 @@
 #include <linux/futex.h>
 #include <urcu/futex.h>
 
+/*
+ * The futex wait op wants an explicit 32-bit address and value. If the bitmap
+ * used for the spinlock is 64-bit, cast down and pass the right 32-bit region
+ * for the in-kernel checks. The value is the copy that has already been read
+ * from the atomic op.
+ *
+ * The futex wake op interprets the value as the number of waiters to wake (up
+ * to INT_MAX), so pass that along directly.
+ */
+static inline void do_futex(int nr, unsigned long *addr, unsigned long v, int futex_flags)
+{
+	u32 *addr32 = (u32 *) addr;
+	u32 *v32 = (u32 *) &v;
+	int shift = 0;
+
+	futex_flags |= FUTEX_PRIVATE_FLAG;
+
+#if BITS_PER_LONG == 64
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	shift = (nr >= 32) ? 1 : 0;
+#else
+	shift = (nr < 32) ? 1 : 0;
+#endif
+#endif
+	if (shift) {
+		addr32 += shift;
+		v32 += shift;
+	}
+	/*
+	 * The shift to determine the futex address may have cast away a
+	 * literal wake count value. The value is capped to INT_MAX and thus
+	 * always in the low bytes of v regardless of bit nr. Copy in the wake
+	 * count to whatever 32-bit range was selected.
+	 */
+	if (futex_flags == FUTEX_WAKE_PRIVATE)
+		*v32 = (u32) v;
+	futex(addr32, futex_flags, *v32, NULL, NULL, 0);
+}
+
 static inline void bit_spin_lock(int nr, unsigned long *_addr)
 {
-	u32 mask, *addr = ((u32 *) _addr) + (nr / 32), v;
+	unsigned long mask;
+	unsigned long *addr = _addr + (nr / BITS_PER_LONG);
+	unsigned long v;
 
-	nr &= 31;
-	mask = 1U << nr;
+	nr &= BITS_PER_LONG - 1;
+	mask = 1UL << nr;
 
 	while (1) {
 		v = __atomic_fetch_or(addr, mask, __ATOMIC_ACQUIRE);
 		if (!(v & mask))
 			break;
 
-		futex(addr, FUTEX_WAIT|FUTEX_PRIVATE_FLAG, v, NULL, NULL, 0);
+		do_futex(nr, addr, v, FUTEX_WAIT);
 	}
 }
 
 static inline void bit_spin_wake(int nr, unsigned long *_addr)
 {
-	u32 *addr = ((u32 *) _addr) + (nr / 32);
-
-	futex(addr, FUTEX_WAKE|FUTEX_PRIVATE_FLAG, INT_MAX, NULL, NULL, 0);
+	do_futex(nr, _addr, INT_MAX, FUTEX_WAKE);
 }
 
 static inline void bit_spin_unlock(int nr, unsigned long *_addr)
 {
-	u32 mask, *addr = ((u32 *) _addr) + (nr / 32);
+	unsigned long mask;
+	unsigned long *addr = _addr + (nr / BITS_PER_LONG);
 
-	nr &= 31;
-	mask = 1U << nr;
+	nr &= BITS_PER_LONG - 1;
+	mask = 1UL << nr;
 
 	__atomic_and_fetch(addr, ~mask, __ATOMIC_RELEASE);
-	futex(addr, FUTEX_WAKE|FUTEX_PRIVATE_FLAG, INT_MAX, NULL, NULL, 0);
+	do_futex(nr, addr, INT_MAX, FUTEX_WAKE);
 }
 
 #endif /* __LINUX_BIT_SPINLOCK_H */
-- 
2.41.0

