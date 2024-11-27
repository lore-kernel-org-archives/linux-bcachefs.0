Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019E620010A
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732743425; cv=none; b=DsPyfFwdYngVJJAjol/pIHYY4+Oj0WFSvB52tCk+LgDk1PrYk8OQEFhG0ZOem7ELV3AEy6x//0baVRkwA8EIJmZNvXEruI/hOp6p1LVgpOBneQRXqdFp60zn4hTm53MQvnP7axV7ZOzKGCRAL/B5p7ZExXCdxvaqEWPLaWVU72M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732743425; c=relaxed/simple;
	bh=zhqSJQtimRMIBeM6nX6ewuByP2NEpAeIxm3h/LclZgo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qoFYCGJlQosIpxePFilQFso9mvyTMT0yukHDTSFB45uG+TdL2px8+XGL/5oYP50m/RSqerczJz30nhp/CODMONIU3rZRcw9I2nQzZIyez5BwswyeON6q85c70LirhLZw85Zx4HY8L7KSpKx1VU3Fr6KhpeoKNOCKvZtKGWtHqFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QZCNUTws; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QZCNUTws"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732743418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OfDwKYAZ/6VNcx6QGfi+56GA8ZezCy+G2/+LfXLmkC4=;
	b=QZCNUTwseJVjbog71jB93yQgRLZqJYAehR5Def4Ny3P/9/Ksw8Sn4zyR8GnpZttNSj2aUX
	EKAOt/QQjZiNkZGfcyRiyEwOPl7gf6GLrk59Dv+H+X+FlEAlVqTVgqsyRSPyDdjEMTsCBJ
	9atGp0RqVR0paKftSbJ2Hg1JWkfcwyM=
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] bcachefs: dio write: Take ref on mm_struct when using asynchronously
Date: Wed, 27 Nov 2024 16:36:49 -0500
Message-ID: <20241127213649.1615078-1-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When invoked from aio, mm_struct is guaranteed to outlive the request
since its lifetime is tied to the io_context - but that's not the case
for io_uring, it's possible that a process could be killed and mm_struct
goes away while a request is in flight.

So if we're submitting the rest of the io asynchronously, we may need a
ref on mm_struct.

Per Jens, this is not actually a bug because we're not yet flipping on
FMODE_NOWAIT, meaning io_uring will do the submission from an io_worker
kthread - but this patch is necessary for safely flipping on
FMODE_NOWAIT for more efficient submissions in the future.

Reported-by: Jann Horn <jannh@google.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
---
 fs/bcachefs/fs-io-direct.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 2089c36b5866..cea4dd9a0745 100644
--- a/fs/bcachefs/fs-io-direct.c
+++ b/fs/bcachefs/fs-io-direct.c
@@ -226,6 +226,7 @@ struct dio_write {
 	struct mm_struct		*mm;
 	const struct iovec		*iov;
 	unsigned			loop:1,
+					have_mm_ref:1,
 					extending:1,
 					sync:1,
 					flush:1;
@@ -390,6 +391,9 @@ static __always_inline long bch2_dio_write_done(struct dio_write *dio)
 
 	kfree(dio->iov);
 
+	if (dio->have_mm_ref)
+		mmput(dio->mm);
+
 	ret = dio->op.error ?: ((long) dio->written << 9);
 	bio_put(&dio->op.wbio.bio);
 
@@ -529,9 +533,24 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
 
 		if (unlikely(dio->iter.count) &&
 		    !dio->sync &&
-		    !dio->loop &&
-		    bch2_dio_write_copy_iov(dio))
-			dio->sync = sync = true;
+		    !dio->loop) {
+			/*
+			 * Rest of write will be submitted asynchronously -
+			 * unless copying the iov fails:
+			 */
+			if (likely(!bch2_dio_write_copy_iov(dio))) {
+				/*
+				 * aio guarantees that mm_struct outlives the
+				 * request, but io_uring does not
+				 */
+				if (dio->mm) {
+					mmgrab(dio->mm);
+					dio->have_mm_ref = true;
+				}
+			} else {
+				dio->sync = sync = true;
+			}
+		}
 
 		dio->loop = true;
 		closure_call(&dio->op.cl, bch2_write, NULL, NULL);
@@ -559,7 +578,7 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
 
 static noinline __cold void bch2_dio_write_continue(struct dio_write *dio)
 {
-	struct mm_struct *mm = dio->mm;
+	struct mm_struct *mm = dio->have_mm_ref ? dio->mm: NULL;
 
 	bio_reset(&dio->op.wbio.bio, NULL, REQ_OP_WRITE);
 
-- 
2.45.2

