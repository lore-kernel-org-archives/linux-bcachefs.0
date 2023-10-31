Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2F9C4167D
	for <linux-bcachefs@archiver.kernel.org>; Tue, 31 Oct 2023 16:25:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345161AbjJaQZL (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 31 Oct 2023 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345155AbjJaQZK (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 31 Oct 2023 12:25:10 -0400
Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D6CFE
        for <linux-bcachefs@vger.kernel.org>; Tue, 31 Oct 2023 09:25:05 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698769504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uqS4BEhMwIAHIltUcK28FXSk9fUQ8Tpbi82lSqupklQ=;
        b=K5Mp9HWE+8OC7T5meVobLfJ1oI2LVTPbvxBoqgjHcOCONI7BRC5vOSnUg9GleKvbB4J/2z
        L6LeEXjLzfOQMxtlyd3dcCu2phfMvDR6Dz+2DagJft6vfXhQM6ufOLoiTQhICndN4WDQ0a
        PFRdpoinlHfyiB6W41aR/04eh5AMpvY=
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     linux-bcache@vger.kernel.org, linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 1/2] closures: Better memory barriers
Date:   Tue, 31 Oct 2023 12:24:51 -0400
Message-ID: <20231031162454.3761482-2-kent.overstreet@linux.dev>
In-Reply-To: <20231031162454.3761482-1-kent.overstreet@linux.dev>
References: <20231031162454.3761482-1-kent.overstreet@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

atomic_(dec|sub)_return_release() are a thing now - use them.

Also, delete the useless barrier in set_closure_fn(): it's redundant
with the memory barrier in closure_put(0.

Since closure_put() would now otherwise just have a release barrier, we
also need a new barrier when the ref hits 0 -
smp_acquire__after_ctrl_dep().

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 include/linux/closure.h | 2 --
 lib/closure.c           | 6 ++++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 722a586bb224..bdab17050bc8 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -233,8 +233,6 @@ static inline void set_closure_fn(struct closure *cl, closure_fn *fn,
 	closure_set_ip(cl);
 	cl->fn = fn;
 	cl->wq = wq;
-	/* between atomic_dec() in closure_put() */
-	smp_mb__before_atomic();
 }
 
 static inline void closure_queue(struct closure *cl)
diff --git a/lib/closure.c b/lib/closure.c
index 0855e698ced1..501dfa277b59 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -21,6 +21,8 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 	BUG_ON(!r && (flags & ~CLOSURE_DESTRUCTOR));
 
 	if (!r) {
+		smp_acquire__after_ctrl_dep();
+
 		if (cl->fn && !(flags & CLOSURE_DESTRUCTOR)) {
 			atomic_set(&cl->remaining,
 				   CLOSURE_REMAINING_INITIALIZER);
@@ -43,7 +45,7 @@ static inline void closure_put_after_sub(struct closure *cl, int flags)
 /* For clearing flags with the same atomic op as a put */
 void closure_sub(struct closure *cl, int v)
 {
-	closure_put_after_sub(cl, atomic_sub_return(v, &cl->remaining));
+	closure_put_after_sub(cl, atomic_sub_return_release(v, &cl->remaining));
 }
 EXPORT_SYMBOL(closure_sub);
 
@@ -52,7 +54,7 @@ EXPORT_SYMBOL(closure_sub);
  */
 void closure_put(struct closure *cl)
 {
-	closure_put_after_sub(cl, atomic_dec_return(&cl->remaining));
+	closure_put_after_sub(cl, atomic_dec_return_release(&cl->remaining));
 }
 EXPORT_SYMBOL(closure_put);
 
-- 
2.42.0

