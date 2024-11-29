Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE2F1A3A8D
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 20:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732912087; cv=none; b=tj3NhyCE8eKpe/SJ7KURKpG6SWPU5u8Qb4OJd68gMB9Yz+hz9+wk3Nse+JvFN4qm4ApllkG5WBXyb0+aX7u1rYX9QMIWIBsAkgke7+tb0PvuWsWzxsa+VWGjc7t3JqcGlF/lQYW8jE/DR6QiDWtsjCgO3LSsjDuytHF7VvRlVlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732912087; c=relaxed/simple;
	bh=ik+8P9P4NE7GcFEZzHSV7mNNkrNiyld+P6TA2RCdZGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJmLz3zLDtPm01lGs4bzJ7qNmn1T/lSIp83B/mtR1mEHawbBMbjAHwnuNrPvcvPtNCv/YBlxraCY/pLF1VKLKtApfH+wa4XweUBy48WM+Tl1HhX/20UPmEzEoyRM2groi1vC8qa/LsNofJwEv5gTdGllAnqUMsEVm84YSnOGcAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 20/34] bcachefs: dio write: Take ref on mm_struct when using asynchronously
Date: Fri, 29 Nov 2024 15:27:19 -0500
Message-ID: <20241129202736.2713679-21-kent.overstreet@linux.dev>
In-Reply-To: <20241129202736.2713679-1-kent.overstreet@linux.dev>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
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
 fs/bcachefs/fs-io-direct.c | 42 ++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 2089c36b5866..b0367b9d9e07 100644
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
+		mmdrop(dio->mm);
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
@@ -559,15 +578,25 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
 
 static noinline __cold void bch2_dio_write_continue(struct dio_write *dio)
 {
-	struct mm_struct *mm = dio->mm;
+	struct mm_struct *mm = dio->have_mm_ref ? dio->mm: NULL;
 
 	bio_reset(&dio->op.wbio.bio, NULL, REQ_OP_WRITE);
 
-	if (mm)
+	if (mm) {
+		if (unlikely(!mmget_not_zero(mm))) {
+			/* process exited */
+			dio->op.error = -ESRCH;
+			bch2_dio_write_done(dio);
+			return;
+		}
+
 		kthread_use_mm(mm);
+	}
 	bch2_dio_write_loop(dio);
-	if (mm)
+	if (mm) {
 		kthread_unuse_mm(mm);
+		mmput(mm);
+	}
 }
 
 static void bch2_dio_write_loop_async(struct bch_write_op *op)
@@ -641,6 +670,7 @@ ssize_t bch2_direct_write(struct kiocb *req, struct iov_iter *iter)
 	dio->mm			= current->mm;
 	dio->iov		= NULL;
 	dio->loop		= false;
+	dio->have_mm_ref	= false;
 	dio->extending		= extending;
 	dio->sync		= is_sync_kiocb(req) || extending;
 	dio->flush		= iocb_is_dsync(req) && !c->opts.journal_flush_disabled;
-- 
2.45.2

