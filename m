Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C8F36F42A
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Mar 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773589582; cv=none; b=Zzp1n1IXsEiwH93mneDeNb9ntngoXc4Gja1xiDwhkA0PgZloVzl23H/21W1o61zJ2DEGXzocWbt7kJgERNZEJQxrsX1DHu13KOrlJbaVlbpkEtbC7qNAY6++dQNzlSNqPrzM2VGHm9rL6jZseLgxdfVW7srLrNVG5EHvzdGTk7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773589582; c=relaxed/simple;
	bh=/4TxCRmAFVjj0HQMyo988GTmjzUI/GgwkZk6foJDDP8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nuFR/1juqjEi52Di0t5xvvUThRaDN1oDE0dYQs9tzeY+MFAyLAZf03q5eLSWQmSSjZ0t+Nx1vov+XcT51eld0VvI1yx/pPlAn7UP8ljTt9J7p7IZWEqIyJjphsT6iKC7YjcoyMa8PXpGaRGp2+AGQBe787WEYyKDT8t4fynjb/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0N8G9GV; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0N8G9GV"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-439b790af67so3588073f8f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Mar 2026 08:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773589579; x=1774194379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GHiZfFMU5597hEQav2iGD+pMwvYCiesjxK+AXpnt3o8=;
        b=B0N8G9GVIyxjAWhkxFvsfDaZ3T2MXZSLC/pK2nVFXavFbK5D7C5o946JVDKfkAtNAs
         p/FDZocIaUvB7lTWxLOkvrWygDBvFEsyIPOHeDC+ra0ElbcQDizKVEeVJUqLdx0hMdbW
         8XkgpXVGmraOyrDIDLrA3DKuXihlFq/NncguRQpIqae1fYm/XTMTQ3NzuZpCUlPlT1oL
         kDAokObqB/LspjUkaY97ku2Q2zrs7rQQ7gC+VXFO4zHl5L2Q7GWpYa1xmLPEOcQSIfs+
         JtOQkh+tTAkUMY6YBAOBmHR1hTgWrOfm0dohaQt1bRp3qfj3WG4DFzJ8CFd41NcAOq5b
         qTYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773589579; x=1774194379;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GHiZfFMU5597hEQav2iGD+pMwvYCiesjxK+AXpnt3o8=;
        b=fDeiKrWFUuHO3jsMAyR5qOtP220ArW4onKoKdqRKkptFY8SDcj6Ux2Pc0esgUtrLn4
         7SKCmgHeZaxa/7iFS1v5gnqIvYZ4H951BL7RFLFvc9yL7QEWyarorD3vaDMKZU4Eymdw
         Uomjp26k4+ISbVeply0OsdGXcxSIIlvPyEZksescx7mTI2LclMq5gcWksKKITZAFcetF
         LL915mXdXNFULhyFU9K4xmNgCK+rn9BgReT4CfB5I/QzCalpX1/WR9GFQyBJBVokPog/
         613W8wMfYrxm6Ug5A8vSd63ESfGzAY16zDQNiDI3j6LE0CFb9TI43O19UqA3RAONw3xC
         MsyA==
X-Gm-Message-State: AOJu0YxMy3T/qVf1sfUg3AYOt0c2AOR8a/the3aXH/P5gNwrX9/mMh65
	q/It4Xf7KkR6JAH2+nZ3YAov3fBlVaHH4nvLo2DpZtTR8y+Zk9V+bO8i
X-Gm-Gg: ATEYQzzFx702B0CCqhRZSLGv/BrpvywPPaPdXkuX6YtvL0fO/Sos3Re9evbXJZLNKvs
	7kRehsSubEcnHpArsTM3ZsSjDtTsmRoUp3Ma/YZ8NHz5Jqd63JLy1LzWyyrk4Kq04bk2LHMhrBf
	O9M6jEgUJukiHO+MZs7nCEJkMucfnFuxjoC2Fu9EOsb9M811ZW2cTsKwDVqQhD0uHW/80uTJmm4
	IBuyICeq7e5WZSHfiq5AkVGUTPUGADOYWVITUMaDv+MczMhuFw0d96rIFOviL8LsweGuSu4GgeI
	XRSKjA4PAvwZGht94xxe2hmSBFun9qhA1m/rG4P7OR/OlM6GHse2ZIG5kypJRMsxlvkRBWOeAus
	5m22iWYdN0QxgvkCxLCRc07c2aaxWsFOFgRN6nGn7jbO2UGtU9NFxLk56OfpcFx4TbUc7KIY06C
	d4qjVlja8A71UhXcf/cUp0bPapZ/De2xTtZYcGZsA9D+g5sh59NdXeL3ZqEdMgyV5HEh/oJVNlL
	Xkhqccifggkc9H0aFsBxXb+9Mi1Yw==
X-Received: by 2002:a05:6000:2309:b0:43b:4166:b855 with SMTP id ffacd0b85a97d-43b4166ba79mr2927251f8f.14.1773589579328;
        Sun, 15 Mar 2026 08:46:19 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b43761bddsm2357954f8f.38.2026.03.15.08.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 08:46:18 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>,
	Claude <noreply@anthropic.com>
Subject: [PATCH 1/3] closures: add missing kernel-doc for closure API functions
Date: Sun, 15 Mar 2026 16:46:09 +0100
Message-ID: <20260315154609.50917-1-xaum.io@gmail.com>
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

Assisted-by: Claude <noreply@anthropic.com>
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

