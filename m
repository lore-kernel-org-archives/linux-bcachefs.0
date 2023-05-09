Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4046FC7EE2F
	for <linux-bcachefs@archiver.kernel.org>; Tue,  9 May 2023 16:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbjEIQ5W (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 9 May 2023 12:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbjEIQ5R (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 9 May 2023 12:57:17 -0400
Received: from out-56.mta1.migadu.com (out-56.mta1.migadu.com [95.215.58.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B3830D5
        for <linux-bcachefs@vger.kernel.org>; Tue,  9 May 2023 09:57:13 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683651431;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZW9aTms42T46/dSvQYESAhkOAQjGvYQLSdyAX7h+W6s=;
        b=oPneXlUL5Qng7vxH10AO/hWFlZlWqRuLgPD4Xj67JKkDqbHoCKWj8RiBBZ2u0qdoMotROK
        8MIYFSyqk4psf12fOel+CldcoNyYMIAcEhhPk6a/CXVe/Z2fCA404A36ou5D++qDPkcHzF
        AkOhN+4hig+zKd5aX1NbEdZ3+BlhFSY=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 02/32] locking/lockdep: lock_class_is_held()
Date:   Tue,  9 May 2023 12:56:27 -0400
Message-Id: <20230509165657.1735798-3-kent.overstreet@linux.dev>
In-Reply-To: <20230509165657.1735798-1-kent.overstreet@linux.dev>
References: <20230509165657.1735798-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

From: Kent Overstreet <kent.overstreet@gmail.com>

This patch adds lock_class_is_held(), which can be used to assert that a
particular type of lock is not held.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Will Deacon <will@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 include/linux/lockdep.h  |  4 ++++
 kernel/locking/lockdep.c | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 1023f349af..e858c288c7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -339,6 +339,8 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 #define lockdep_repin_lock(l,c)	lock_repin_lock(&(l)->dep_map, (c))
 #define lockdep_unpin_lock(l,c)	lock_unpin_lock(&(l)->dep_map, (c))
 
+int lock_class_is_held(struct lock_class_key *key);
+
 #else /* !CONFIG_LOCKDEP */
 
 static inline void lockdep_init_task(struct task_struct *task)
@@ -427,6 +429,8 @@ extern int lockdep_is_held(const void *);
 #define lockdep_repin_lock(l, c)		do { (void)(l); (void)(c); } while (0)
 #define lockdep_unpin_lock(l, c)		do { (void)(l); (void)(c); } while (0)
 
+static inline int lock_class_is_held(struct lock_class_key *key) { return 0; }
+
 #endif /* !LOCKDEP */
 
 enum xhlock_context_t {
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 50d4863974..e631464070 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6487,6 +6487,26 @@ void debug_check_no_locks_held(void)
 }
 EXPORT_SYMBOL_GPL(debug_check_no_locks_held);
 
+#ifdef CONFIG_LOCKDEP
+int lock_class_is_held(struct lock_class_key *key)
+{
+	struct task_struct *curr = current;
+	struct held_lock *hlock;
+
+	if (unlikely(!debug_locks))
+		return 0;
+
+	for (hlock = curr->held_locks;
+	     hlock < curr->held_locks + curr->lockdep_depth;
+	     hlock++)
+		if (hlock->instance->key == key)
+			return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(lock_class_is_held);
+#endif
+
 #ifdef __KERNEL__
 void debug_show_all_locks(void)
 {
-- 
2.40.1

