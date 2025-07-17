Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C8B2B2D7
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752783543; cv=none; b=V4UcOrX+C70mxNlmrVcG3M6m//o3JIRDGLOaLWkbCOPBRy2hKu1CLKiOiJOV4cUXK9TxO84sfYa+naAGcX2ZgHMczL7ApU70IkXELdcIJtgvZozYbdtDPF28UIiHOJ7u19n9fvH+uIeq9ym5r75ErYcoFJ5rVC418DhVBkLqSKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752783543; c=relaxed/simple;
	bh=s/uX0RKC1iQc2SbxZx3HQqhPEzZbw1t2aBHVO01DgPY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ETUmsyzByabEeswqVtn+t+GzmZzfpt39959qkK7cADblsIgLjazU2YD+DeriN5qH/8cH4B+MWP6f1etF4GYzwnr/8j0eRTrLkYD3+MuAkd2nWjSbb1L9j2IlAjRRpTQmGlh4z7+x1d3Rqvu1pHBvNIj8P1ja0P0/r4IRkNrKm5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PNn/NMr6; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PNn/NMr6"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752783538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hvi/cw7EUb/dwDmcIzU6Tx/IEkPYeUTtXtfmiym6mIY=;
	b=PNn/NMr6mptsPVbKzZnPIw0MpWhuzfFEsORRMCnnzdn/ll/lUq6c9DALTpLEzqUnfKCdUp
	7RH7krLiOvxPr5TI9IFQpT9MP9UPSwHSSCvLqElpNmGPNtqI1BD3zXLcdnv0oduTKn08bJ
	03Zp7uJP2m5bn9XUpGhv5FQSVvZsG2s=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH] closures: Improve warnings on bad put
Date: Thu, 17 Jul 2025 16:18:52 -0400
Message-ID: <20250717201852.2160727-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Print out cl->fn - this narrows down the codepaths to look at.

See https://syzkaller.appspot.com/bug?extid=0ea2c41a649240197795

Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 lib/closure.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/closure.c b/lib/closure.c
index 2bfe7d2a0048..4fb78d18ee1b 100644
--- a/lib/closure.c
+++ b/lib/closure.c
@@ -13,23 +13,25 @@
 #include <linux/seq_file.h>
 #include <linux/sched/debug.h>
 
-static inline void closure_put_after_sub_checks(int flags)
+static inline void closure_put_after_sub_checks(struct closure *cl, int flags)
 {
 	int r = flags & CLOSURE_REMAINING_MASK;
 
 	if (WARN(flags & CLOSURE_GUARD_MASK,
-		 "closure has guard bits set: %x (%u)",
+		 "closure %ps has guard bits set: %x (%u)",
+		 cl->fn,
 		 flags & CLOSURE_GUARD_MASK, (unsigned) __fls(r)))
 		r &= ~CLOSURE_GUARD_MASK;
 
 	WARN(!r && (flags & ~CLOSURE_DESTRUCTOR),
-	     "closure ref hit 0 with incorrect flags set: %x (%u)",
+	     "closure %ps ref hit 0 with incorrect flags set: %x (%u)",
+	     cl->fn,
 	     flags & ~CLOSURE_DESTRUCTOR, (unsigned) __fls(flags));
 }
 
 static inline void closure_put_after_sub(struct closure *cl, int flags)
 {
-	closure_put_after_sub_checks(flags);
+	closure_put_after_sub_checks(cl, flags);
 
 	if (!(flags & CLOSURE_REMAINING_MASK)) {
 		smp_acquire__after_ctrl_dep();
@@ -167,7 +169,7 @@ void __sched closure_return_sync(struct closure *cl)
 	unsigned flags = atomic_sub_return_release(1 + CLOSURE_RUNNING - CLOSURE_DESTRUCTOR,
 						   &cl->remaining);
 
-	closure_put_after_sub_checks(flags);
+	closure_put_after_sub_checks(cl, flags);
 
 	if (unlikely(flags & CLOSURE_REMAINING_MASK)) {
 		while (1) {
-- 
2.50.0

