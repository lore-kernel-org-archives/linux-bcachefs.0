Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BF82F56
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Dec 2024 01:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733363729; cv=none; b=nTjPNpkgce7b7Jpyuq97cBmZmYWRVUWjc/QgWxJd/NuxXzd+QLT1dBvvgERupvKdo+XaXSS7mspR1iVkEQRa5Ng+MVfzsCBb3Z2YBxTjl82WDiKxOhtIX8wf+mMm2ot8I1lTGrv6FkA/ZGsilDVAZ+41JyLEwiIXF68iVNV2Ulo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733363729; c=relaxed/simple;
	bh=OxLANGodBnrPUrKA00yMyFwzyPQQrzIak325/hr/bio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rs+Vc974mN2y32jfrlrQjEdCkjboZ+ZksT8etcPdmwX5L/LhZ8w0yT89F4xPT2UQSCBU3BtJYCLQc3fSctHdg7YnW26pPfBH7p1PScFPdk8Cp5JvtOvPpYYqpcs4OOQd8Fk4jyNjGEFU4UsuMP6YuiHN8M3tLrfQR+6JZHeKwCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=b4AmCARS; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="b4AmCARS"
Date: Wed, 4 Dec 2024 20:55:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733363723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=krFDp3IO0s/Yqmjk2xsc464Bq6KUzGYe66aQVaRyM4I=;
	b=b4AmCARSzgpuv7+lYIddSrHmSF7wyelQYxuUvOn0GPuoCZxHZQGIhoQdmZtB1t0FG1TX1E
	XxSCO/up3/KdmTO7JTj8a85MJkbQXkWKFte/Vl2E1lMoEYcJdzLo9gXVo0zJz5ONtRho/x
	OIRFdHJH2WlvnHdFsnzK9Xh43P6Xsyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: linux-bcachefs@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 20/34] bcachefs: dio write: Take ref on mm_struct when
 using asynchronously
Message-ID: <aju7xoha5k54uf2hwlrgpor4jf72yw4dt7tddyz5p3he72yr42@q5ezmbbeeesn>
References: <20241129202736.2713679-1-kent.overstreet@linux.dev>
 <20241129202736.2713679-21-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241129202736.2713679-21-kent.overstreet@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Fri, Nov 29, 2024 at 03:27:19PM -0500, Kent Overstreet wrote:
> When invoked from aio, mm_struct is guaranteed to outlive the request
> since its lifetime is tied to the io_context - but that's not the case
> for io_uring, it's possible that a process could be killed and mm_struct
> goes away while a request is in flight.
> 
> So if we're submitting the rest of the io asynchronously, we may need a
> ref on mm_struct.
> 
> Per Jens, this is not actually a bug because we're not yet flipping on
> FMODE_NOWAIT, meaning io_uring will do the submission from an io_worker
> kthread - but this patch is necessary for safely flipping on
> FMODE_NOWAIT for more efficient submissions in the future.
> 
> Reported-by: Jann Horn <jannh@google.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

turns out this introduces a rare deadlock in exit_aio() 

> ---
>  fs/bcachefs/fs-io-direct.c | 42 ++++++++++++++++++++++++++++++++------
>  1 file changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index 2089c36b5866..b0367b9d9e07 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -226,6 +226,7 @@ struct dio_write {
>  	struct mm_struct		*mm;
>  	const struct iovec		*iov;
>  	unsigned			loop:1,
> +					have_mm_ref:1,
>  					extending:1,
>  					sync:1,
>  					flush:1;
> @@ -390,6 +391,9 @@ static __always_inline long bch2_dio_write_done(struct dio_write *dio)
>  
>  	kfree(dio->iov);
>  
> +	if (dio->have_mm_ref)
> +		mmdrop(dio->mm);
> +
>  	ret = dio->op.error ?: ((long) dio->written << 9);
>  	bio_put(&dio->op.wbio.bio);
>  
> @@ -529,9 +533,24 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
>  
>  		if (unlikely(dio->iter.count) &&
>  		    !dio->sync &&
> -		    !dio->loop &&
> -		    bch2_dio_write_copy_iov(dio))
> -			dio->sync = sync = true;
> +		    !dio->loop) {
> +			/*
> +			 * Rest of write will be submitted asynchronously -
> +			 * unless copying the iov fails:
> +			 */
> +			if (likely(!bch2_dio_write_copy_iov(dio))) {
> +				/*
> +				 * aio guarantees that mm_struct outlives the
> +				 * request, but io_uring does not
> +				 */
> +				if (dio->mm) {
> +					mmgrab(dio->mm);
> +					dio->have_mm_ref = true;
> +				}
> +			} else {
> +				dio->sync = sync = true;
> +			}
> +		}
>  
>  		dio->loop = true;
>  		closure_call(&dio->op.cl, bch2_write, NULL, NULL);
> @@ -559,15 +578,25 @@ static __always_inline long bch2_dio_write_loop(struct dio_write *dio)
>  
>  static noinline __cold void bch2_dio_write_continue(struct dio_write *dio)
>  {
> -	struct mm_struct *mm = dio->mm;
> +	struct mm_struct *mm = dio->have_mm_ref ? dio->mm: NULL;
>  
>  	bio_reset(&dio->op.wbio.bio, NULL, REQ_OP_WRITE);
>  
> -	if (mm)
> +	if (mm) {
> +		if (unlikely(!mmget_not_zero(mm))) {
> +			/* process exited */
> +			dio->op.error = -ESRCH;
> +			bch2_dio_write_done(dio);
> +			return;
> +		}
> +
>  		kthread_use_mm(mm);
> +	}
>  	bch2_dio_write_loop(dio);
> -	if (mm)
> +	if (mm) {
>  		kthread_unuse_mm(mm);
> +		mmput(mm);
> +	}
>  }
>  
>  static void bch2_dio_write_loop_async(struct bch_write_op *op)
> @@ -641,6 +670,7 @@ ssize_t bch2_direct_write(struct kiocb *req, struct iov_iter *iter)
>  	dio->mm			= current->mm;
>  	dio->iov		= NULL;
>  	dio->loop		= false;
> +	dio->have_mm_ref	= false;
>  	dio->extending		= extending;
>  	dio->sync		= is_sync_kiocb(req) || extending;
>  	dio->flush		= iocb_is_dsync(req) && !c->opts.journal_flush_disabled;
> -- 
> 2.45.2
> 
