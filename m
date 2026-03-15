Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AEE372EE9
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Mar 2026 17:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773594408; cv=none; b=SzEpdXSAdt/Yk1vhAfLcJsyCBRrTmjpwYPsyWcD/LcFz+3DnKldsga5jIVHrud5MYb6/Og3Wsgg3YEtW8Z8bfW/GOeVvNf41uhZGo1Q+XNsKMjLBI8orgYsnulNC3E9Ac6XpecyCApyi6IFnkAJSovn5BlhFHsCbSOxFujXNfsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773594408; c=relaxed/simple;
	bh=HWa/1Nd3KstykfM1F0qL/ax2EKg59QUTP2h4BKzh1sI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=An+ITH/Rw0V0e7oy+5mO5BWncTV3IuVbMnPJrTWpk57ORC98SC4zPCUYSoMnuG9o4I1Il4fTtitCuflbiDECh0LGCOG1aaN9iMMwjAJ/KD3yMCbK8FE/kuA602zTw454d7O31V+ppq4uukj2kkaNhd5Hep0wxghuvIBWT5aml/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JKzuVlhP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JKzuVlhP"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4852e9ca034so34321895e9.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Mar 2026 10:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773594404; x=1774199204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=70K/jXTqjKva1WrU3OIkwUbaoc+5tgMJDmiLGmjO9TY=;
        b=JKzuVlhPSJPDXUEvnxDlRoykcMTrl98YXI2W1UJc8w4RnklcCS8wRcxQ011BdxiqPS
         OBAkTAEczW4NkbodQXfU2tVQmW0yo3W3wraMk3VIeyHQm2pjfUo+HnSYWGr3G2OunDnZ
         Panp5vbCC6YdWlyP9Ua2RE1ZNZgtdc1N6HvJFLPisx902dVWPux/HJCd4un97e0HUrkU
         8fFRlFpteXAsqjelMVvoYLTlFBEICMbV321p+uugCie3ooJsJorK2hpPr7JUaa8bombR
         EfyFOW01v9aPvNHp1pNL95v6hgn0SS/bPlqNMt7RILtNbPAAUPzCoZaSswgP5cqAe3jU
         04jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773594404; x=1774199204;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=70K/jXTqjKva1WrU3OIkwUbaoc+5tgMJDmiLGmjO9TY=;
        b=CdD6y+5vWxCixXnARSXWLZ9Kbk0/WUqLW1djBoOBKWX4qSgcK10nexqjNczFJHQos7
         XnZIs0yCj67xrP4rUg2vqt0U5AhDT5D7gmPzk1M3nM6rlTc8ifE0PKlqT9Xd13vQe/Zq
         8hed1Zu77gvS36iiVdJX5yafKfKMh4Rau5sG+/AlEjtKh27gSVvrFrFnh1BGiEeJcJ6/
         G41S2OZ6NEZjoR0T7jiFOh8oE3dNpFRuw2r0T2KfZP/qBtSRVKLzD9NtOJ3/uvsdRpvQ
         t7mVu8OsZqJNIn/xyUfO4dpBvDRgc7KEHV9Er1WsXaqovLbLBF0owXwIYH1zKkCzz0qN
         AEBQ==
X-Gm-Message-State: AOJu0Yz9A+sE1u7OfxGxMouiLaMnVdkJYL/wDEUljLcZxOAMJd3jLomu
	VsELm8NCnxAKoPVEtN8DCBY+Y1aOWx2q3d/I/2EQbR2UB89EWMM+50luvc0oorDVhng=
X-Gm-Gg: ATEYQzyfOOOODvxm7h0EClql3y4NGqqt4BhVKT3K8fR7MD3iT0/jCIgEQDUYBfu/01f
	Q0HU3tDxVYJB2n0MC2SRDKgtjlvax7OjMCiqIn/+oRF4vI0EO+qKNiVz54d6E64qmFG/zlPPRFV
	ffcvSrZJTLlHakUKr0Bu3lisN/tLMPV90PKxIV0F9BWjKQ7RpSfa69QZqG6KkWZBXXfXkbX6Ipk
	JoPV86gk9Aa9HHtzvmJBFWHOLO7N+R3rI+ncqnMSjVsLlz8RYVzueeRGxmQmrQNKMLGICK9yRes
	1A5Z4ZC0bm9BH8JL0/Pe2qK8wonBaJBF5l3KAM16t98sxEmJ5I9DXm9ZKZ3pK8pBbbJ/hYN1YA0
	LWsvIo5sl33hs03Gly3G47K5cmd6R/dyl2NAJMV7zE/fjk/GycA3qTRhlNfw8Gskb8YOQz8juWT
	tcbwghRh0P80/fCpuqImTQprFuF3+l2ufcR99NC3Orp16TLn34RqtHROYUSVcjhVNuihc3Jxwfv
	GUC6A+ux7YxaIpowRwFxUwuEm15+A==
X-Received: by 2002:a05:600c:4689:b0:477:9b35:3e49 with SMTP id 5b1f17b1804b1-485566cf80dmr167876495e9.3.1773594404020;
        Sun, 15 Mar 2026 10:06:44 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48557777105sm119905905e9.4.2026.03.15.10.06.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 10:06:43 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] closures: add missing kernel-doc for closure API functions
Date: Sun, 15 Mar 2026 18:06:34 +0100
Message-ID: <20260315170634.64804-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Document all missing parameters across 9 functions and macros:
closure_sync(), closure_get(), closure_get_not_zero(),
closure_wake_up(), continue_at(), closure_return(),
continue_at_nobarrier(), closure_return_with_destructor(), and
closure_call().

Also fix a duplicated word in the closure_sync() description.

Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 include/linux/closure.h | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/include/linux/closure.h b/include/linux/closure.h
index 880fe85e35e9..12f44945a523 100644
--- a/include/linux/closure.h
+++ b/include/linux/closure.h
@@ -180,7 +180,8 @@ static inline unsigned closure_nr_remaining(struct closure *cl)
 }
 
 /**
- * closure_sync - sleep until a closure a closure has nothing left to wait on
+ * closure_sync - sleep until a closure has nothing left to wait on
+ * @cl: closure to wait on
  *
  * Sleeps until the refcount hits 1 - the thread that's running the closure owns
  * the last refcount.
@@ -272,6 +273,7 @@ static inline void closure_queue(struct closure *cl)
 
 /**
  * closure_get - increment a closure's refcount
+ * @cl: closure to increment the refcount of
  */
 static inline void closure_get(struct closure *cl)
 {
@@ -286,7 +288,8 @@ static inline void closure_get(struct closure *cl)
 }
 
 /**
- * closure_get_not_zero
+ * closure_get_not_zero - increment a closure's refcount if non-zero
+ * @cl: closure to increment the refcount of
  */
 static inline bool closure_get_not_zero(struct closure *cl)
 {
@@ -341,6 +344,7 @@ static inline void closure_init_stack_release(struct closure *cl)
 /**
  * closure_wake_up - wake up all closures on a wait list,
  *		     with memory barrier
+ * @list: wait list to wake up
  */
 static inline void closure_wake_up(struct closure_waitlist *list)
 {
@@ -356,8 +360,11 @@ static inline void closure_wake_up(struct closure_waitlist *list)
 
 /**
  * continue_at - jump to another function with barrier
+ * @_cl: closure to set the continuation on
+ * @_fn: function to resume execution at
+ * @_wq: workqueue to run @_fn out of (or NULL for synchronous)
  *
- * After @cl is no longer waiting on anything (i.e. all outstanding refs have
+ * After @_cl is no longer waiting on anything (i.e. all outstanding refs have
  * been dropped with closure_put()), it will resume execution at @fn running out
  * of @wq (or, if @wq is NULL, @fn will be called by closure_put() directly).
  *
@@ -375,8 +382,9 @@ do {									\
 
 /**
  * closure_return - finish execution of a closure
+ * @_cl: closure to return from
  *
- * This is used to indicate that @cl is finished: when all outstanding refs on
+ * This is used to indicate that @_cl is finished: when all outstanding refs on
  * @cl have been dropped @cl's ref on its parent closure (as passed to
  * closure_init()) will be dropped, if one was specified - thus this can be
  * thought of as returning to the parent closure.
@@ -387,8 +395,11 @@ void closure_return_sync(struct closure *cl);
 
 /**
  * continue_at_nobarrier - jump to another function without barrier
+ * @_cl: closure to set the continuation on
+ * @_fn: function to resume execution at
+ * @_wq: workqueue to run @_fn out of (or NULL for synchronous)
  *
- * Causes @fn to be executed out of @cl, in @wq context (or called directly if
+ * Causes @_fn to be executed out of @_cl, in @_wq context (or called directly if
  * @wq is NULL).
  *
  * The ref the caller of continue_at_nobarrier() had on @cl is now owned by @fn,
@@ -404,8 +415,10 @@ do {									\
 /**
  * closure_return_with_destructor - finish execution of a closure,
  *				    with destructor
+ * @_cl: closure to return from
+ * @_destructor: function to call when all refs are dropped
  *
- * Works like closure_return(), except @destructor will be called when all
+ * Works like closure_return(), except @_destructor will be called when all
  * outstanding refs on @cl have been dropped; @destructor may be used to safely
  * free the memory occupied by @cl, and it is called with the ref on the parent
  * closure still held - so @destructor could safely return an item to a
@@ -419,6 +432,10 @@ do {									\
 
 /**
  * closure_call - execute @fn out of a new, uninitialized closure
+ * @cl: closure to initialize and run
+ * @fn: function to execute
+ * @wq: workqueue to run @fn out of (or NULL for synchronous)
+ * @parent: parent closure, @cl will take a refcount on it (may be NULL)
  *
  * Typically used when running out of one closure, and we want to run @fn
  * asynchronously out of a new closure - @parent will then wait for @cl to
-- 
2.53.0

