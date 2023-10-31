Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41885C4167B
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 16:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345139AbjJaQZL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345157AbjJaQZK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Oct 2023 12:25:10 -0400
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3779D107
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Oct 2023 09:25:06 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698769504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvYk+9/dG37v3g+Ii65HjWgJMTMFcvuM3jdJSXX0CXk=;
        b=CbdbADqoGEsRct7fWVPKuztstOPiFqViDDm4f8FWAtUUUoMd4aBx0mK0FTsQrA+9Z2QBCz
        c8dZlBlTYQ7jiFzYPN5Tbkt7h2O3TXTNS+Bt2SNkiDBDAJRah5KSWPMCi1eUp0v95p/1yG
        ZI8XLcEdA6jib7sZInXQvBzrxgaM3Xc=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 2/2] closures: Fix race in closure_sync()
Date:   Tue, 31 Oct 2023 12:24:52 -0400
Message-ID: <20231031162454.3761482-3-kent.overstreet@linux.dev>
In-Reply-To: <20231031162454.3761482-1-kent.overstreet@linux.dev>
References: <20231031162454.3761482-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

As pointed out by Linus, closure_sync() was racy; we could skip blocking
immediately after a get() and a put(), but then that would skip any
barrier corresponding to the other thread's put() barrier.

To fix this, always do the full __closure_sync() sequence whenever any
get() has happened and the closure might have been used by other
threads.

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-direct.c |  1 +
 include/linux/closure.h    | 10 +++++++++-
 lib/closure.c              |  3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 6a9557e7ecab..5b42a76c4796 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -113,6 +113,7 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
 	} else {
 		atomic_set(&dio->cl.remaining,
 			   CLOSURE_REMAINING_INITIALIZER + 1);
+		dio->cl.closure_get_happened = true;
 	}
 
 	dio->req	= req;
diff --git a/include/linux/closure.h b/include/linux/closure.h
index bdab17050bc8..de7bb47d8a46 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -154,6 +154,7 @@ struct closure {
 	struct closure		*parent;
 
 	atomic_t		remaining;
+	bool			closure_get_happened;
 
 #ifdef CONFIG_DEBUG_CLOSURES
 #define CLOSURE_MAGIC_DEAD	0xc054dead
@@ -185,7 +186,11 @@ static inline unsigned closure_nr_remaining(struct closure *cl)
  */
 static inline void closure_sync(struct closure *cl)
 {
-	if (closure_nr_remaining(cl) != 1)
+#ifdef CONFIG_DEBUG_CLOSURES
+	BUG_ON(closure_nr_remaining(cl) != 1 && !cl->closure_get_happened);
+#endif
+
+	if (cl->closure_get_happened)
 		__closure_sync(cl);
 }
 
@@ -257,6 +262,8 @@ static inline void closure_queue(struct closure *cl)
  */
 static inline void closure_get(struct closure *cl)
 {
+	cl->closure_get_happened = true;
+
 #ifdef CONFIG_DEBUG_CLOSURES
 	BUG_ON((atomic_inc_return(&cl->remaining) &
 		CLOSURE_REMAINING_MASK) <= 1);
@@ -279,6 +286,7 @@ static inline void closure_init(struct closure *cl, struct closure *parent)
 		closure_get(parent);
 
 	atomic_set(&cl->remaining, CLOSURE_REMAINING_INITIALIZER);
+	cl->closure_get_happened = false;
 
 	closure_debug_create(cl);
 	closure_set_ip(cl);
diff --git a/lib/closure.c b/lib/closure.c
index 501dfa277b59..f86c9eeafb35 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -23,6 +23,8 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 	if (!r) {
 		smp_acquire__after_ctrl_dep();
 
+		cl->closure_get_happened = false;
+
 		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
 			atomic_set(&cl->remaining,
 				   CLOSURE_REMAINING_INITIALIZER);
@@ -92,6 +94,7 @@ bool closure_wait(struct closure_waitlist *waitlist, struct closure *cl)
 	if (atomic_read(&cl->remaining) & CLOSURE_WAITING)
 		return false;
 
+	cl->closure_get_happened = true;
 	closure_set_waiting(cl, _RET_IP_);
 	atomic_add(CLOSURE_WAITING + 1, &cl->remaining);
 	llist_add(&cl->list, &waitlist->list);
-- 
2.42.0

