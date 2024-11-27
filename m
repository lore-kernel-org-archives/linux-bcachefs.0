Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC7202F9C
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 22:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732745514; cv=none; b=P8PXPhdAZR5/AxsrLZARKsaIVb7B2UqchKvY6w5l473nvHW8RpvNKNHxzoh9JpGrakMK2vfCH0PWimVIj9STVCZKiI58+TEQqbORsAJysgwCgGXJOLR6nCHCRKkhLXZ/IdT1OfBNLz0g/v+72aPsAoXY8Ue/K9R6aYvN1ejTFlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732745514; c=relaxed/simple;
	bh=nQdLRfI6YRV/UC1rHOz6SeuJ3D1ZQcTQWVt9BydU658=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4WOLVsWW4hAHBehFeXu2dL9dsxHHIFxLa4jxH76vOueTgcERcGNI47rOWBPHFqfcQ0NQva4DB1OtUmLtwK/J7+gEAtXoHP06RxPXOKevkf9JzHecWllbi7SGW81EczmH91dpkOLCReh80C/EmiICB4fmdNuVXCRwtjGUnJNLmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uOq7lcOr; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uOq7lcOr"
Date: Wed, 27 Nov 2024 17:11:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732745508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1fibBjHm6NLaCVvdza4cupNN+iqTzHIRoCpQaC3awek=;
	b=uOq7lcOrOMNfUL0lIC44jzcEFWWBBnUWcn2ItLmn6N9by5mUcCIXyI0dQmWpAoluU8sYkI
	Rcy1VRl5kJHu4y11hTvHfQ1fE3GxW4YUDPC7ll7EV2PIeQuy+co59U/aHTrK01M2jUvNUN
	0ZrH5NBB7yn4OZkQ/XL05pZ1P8vYQl8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bcachefs: dio write: Take ref on mm_struct when using
 asynchronously
Message-ID: <xrjd4otiojkszczc2u2buwbnb6sw2z7u2p66evivsgxrpkidxq@55yc6lbcnhh2>
References: <20241127213649.1615078-1-kent.overstreet@linux.dev>
 <CAG48ez2CXiAieL5-htj86p0cwVOoD5S5Pq=-E+Sf03ifzfYqdQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2CXiAieL5-htj86p0cwVOoD5S5Pq=-E+Sf03ifzfYqdQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 10:48:03PM +0100, Jann Horn wrote:
> On Wed, Nov 27, 2024 at 10:36 PM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> > When invoked from aio, mm_struct is guaranteed to outlive the request
> > since its lifetime is tied to the io_context - but that's not the case
> > for io_uring, it's possible that a process could be killed and mm_struct
> > goes away while a request is in flight.
> >
> > So if we're submitting the rest of the io asynchronously, we may need a
> > ref on mm_struct.
> >
> > Per Jens, this is not actually a bug because we're not yet flipping on
> > FMODE_NOWAIT, meaning io_uring will do the submission from an io_worker
> > kthread - but this patch is necessary for safely flipping on
> > FMODE_NOWAIT for more efficient submissions in the future.
> 
> Ah, one thing to look out for is that mm_struct has two types of
> refcounting, this patch mixes them up - I don't think my explanation
> of that was very clear:
> 
>  - mmgrab()/mmdrop() prevent the mm_struct itself being freed, but
> don't properly keep the mappings in it alive
>  - mmget()/mmput() fully keep the MM alive
> 
> An mmget() reference automatically also holds an mmgrab() reference, basically.
> 
> For kthread_use_mm(), you need an mmget() reference; so the most
> straightforward option would be to mmget() when creating the
> asynchronous work and mmput() when you're done. But that has the
> disadvantage that the reference keeps the entire mm_struct with all
> the mappings inside it alive, and it even indirectly holds a reference
> to all the files mapped in the MM; though I don't know if that's
> really a problem here.
> 
> If you want to avoid keeping the MM of an exiting process alive while
> the I/O is running, the neater pattern is to use mmgrab()/mmdrop() for
> your long-term reference, and then use mmget_not_zero()/mmput() around
> kthread_use_mm()/kthread_unuse_mm() (and bail if mmget_not_zero()
> fails). You can see this pattern in places like
> vfio_iommu_type1_dma_rw_chunk().

gotcha...

From 3ef3067690d838dfc9a12686caa015e85e217f01 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Wed, 27 Nov 2024 16:32:26 -0500
Subject: [PATCH] bcachefs: dio write: Take ref on mm_struct when using
 asynchronously

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

diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
index 2089c36b5866..8da0577411e8 100644
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
+		mmput(mm);
 		kthread_unuse_mm(mm);
+	}
 }
 
 static void bch2_dio_write_loop_async(struct bch_write_op *op)
