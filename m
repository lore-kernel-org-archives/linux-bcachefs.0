Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237FD41C71
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 20:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732739049; cv=none; b=DTzaBZU8Wjiv3ZcPH6vPFnC3Sy+gervbL/IVZy/iJFWht2lXTg4UPa8WIrI+qnfXq/dxvYLueQgIVaudD0SDFtz7wHHqCUV//BxitLFtRJ2Rpci9bC9VhlJINA3p2RGzqDHMpKgUtOmkzsuND8xUP3R2lmoLQr9M1nFcHBGMoz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732739049; c=relaxed/simple;
	bh=3kQAA6tjOG3i3hymlIKv4AqsvYPm+nWbOIv+s3MvJf0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGn5UBMTc9RypBwjAzadG7wF4UPSOFjCUiSwICRTP8jSEzTyN1fznJSBqnNpgi8G7tQl1XfH+bvlV5yfsRgxCU/udzLFwfvYGjmvNL9FDOEo6xnBx+VtBbpYXkpjjZYbZ8VOR7w+HT/ETE/mfyQh4nRdxBlEkGKJ4e6gZX/gyyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gy34Dnyl; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gy34Dnyl"
Date: Wed, 27 Nov 2024 15:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732739044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69vJdznNDa6rQiLJ94o22HONq7hUB59zt/CYuIV9Hjs=;
	b=gy34Dnylj+PE4PxQOKTnRdL9hWmKcy0O4wPNqSjaZiq3l6itNtByxi1NMNbIfIBDRjyx8D
	P1QqRlmaH+Dv76oCfRzsBcWsGLHaF2PA1bNrGHji3I7zIEIfa+gQIwpZPoe44mcbkaw6j4
	UHrb7nlIxCmPwLrNyXMtA1ecFmiPGSU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jann Horn <jannh@google.com>
Cc: linux-bcachefs@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, io-uring <io-uring@vger.kernel.org>
Subject: Re: bcachefs: suspicious mm pointer in struct dio_write
Message-ID: <5jvih6bn7pv5p4btf65bvuxnnt4hli7gf2zlibejyjswmnk5dg@xwfuf3womp5b>
References: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez21ZtMJ6gcUND6bLV6XD6b--CXmKSRjKq+D33jhRh1LPw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 27, 2024 at 05:57:03PM +0100, Jann Horn wrote:
> Hi!
> 
> In fs/bcachefs/fs-io-direct.c, "struct dio_write" contains a pointer
> to an mm_struct. This pointer is grabbed in bch2_direct_write()
> (without any kind of refcount increment), and used in
> bch2_dio_write_continue() for kthread_use_mm()/kthread_unuse_mm()
> which are used to enable userspace memory access from kthread context.
> I believe kthread_use_mm()/kthread_unuse_mm() require that the caller
> guarantees that the MM hasn't gone through exit_mmap() yet (normally
> by holding an mmget() reference).
> 
> If we reach this codepath via io_uring, do we have a guarantee that
> the mm_struct that called bch2_direct_write() is still alive and
> hasn't yet gone through exit_mmap() when it is accessed from
> bch2_dio_write_continue()?
> 
> I don't know the async direct I/O codepath particularly well, so I
> cc'ed the uring maintainers, who probably know this better than me.

I don't know about io_uring but aio guarantees that outstanding kiocbs
are completed before exiting the mm_struct - I would expect some sort of
similar guarantee to hold, because otherwise where are we going to
deliver the completion?
