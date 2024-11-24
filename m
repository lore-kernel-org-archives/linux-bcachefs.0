Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA01CD2C
	for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 19:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732476255; cv=none; b=hyVQJjAuy0l8Ne8GETPlDj9oU+djtTGF952mDnxQSsJ+A8O51BUHknTV2OmMLQ2AYdHohed5i2/veJnPoHyk2miSdWlIoZ/8KmvQ2/Ur6KvVvWybXTg41/Nik7U0wrTp4s5PxKzyy/7VwIJAf/v04zvFuZF8GOZOMU4bITqaiJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732476255; c=relaxed/simple;
	bh=+PKGtoTgP3OBsQAafVbvC0lugSESD0smpdfBSbpxw3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q1YtU/SypPPeQuycxplaK8+8W86ZsFvD0+IvjssZ5Ph6LYo8dlNwHS363tfkCLaQECGU8ld9Z1ODnmf6vaQKB6WhweoJIUugrBrT3USeVndNgTPWAtdGJ7ocR92Rw1tb4MO5YR8L+IHTLWBaaMdJbHi52LmKsl9I+MEcq2zPvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LYWNkWgg; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LYWNkWgg"
Date: Sun, 24 Nov 2024 14:24:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732476250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8uiq/rWUVlpxosWtehfBoPGKjIeHdTzuoaxUN8ArLw=;
	b=LYWNkWggOltpq8czkS0x0Xd0BqnayfkfhOdVmYyceHvBHFi3FILCf9vDlHVPQkoOjb14/7
	/vBcWrTeZqMPe+eplhCpYegeMtlw4UgfbYOsM/QdJqGtgSWpV+gSWepoOJjl6iXOynRJ3z
	kkzq5DcQkOp6QbIMm/EECbP2Own0QE4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
Subject: Re: [PATCH] bcachefs: eytzinger1_{next,prev} cleanup
Message-ID: <atjh756n4ykf6syi3uxzb6mdxsfdbpfya5mx77bfcxgzl6proj@mrqvwcmdhd62>
References: <20241124131147.1057922-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241124131147.1057922-1-agruenba@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Nov 24, 2024 at 02:11:47PM +0100, Andreas Gruenbacher wrote:
> From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
> 
> In this place in the code, eytzinger1_next() is trying to move the
> lowest child on the left, which is equivalent to doubling i until the
> next doubling would cause it to be greater than size.  This is
> implemented by shifting i to the left so that the most significant bits
> of both numbers align, and then shifting i right by one if it is greater
> than size.
> 
> The code accidentally computes the most significant bit of (size + 1)
> instead of size.  This happens to be harmless because in that case, the
> right shifting will compensate, but it is confusing and unnecessary.
> 
> Likewise, eytzinger1_prev() is trying to move the lowest child on the
> right.  The same applies here.
> 
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>

Looks correct. There's eytzinger tests in fs/bcachefs/util.c, could you
run those?

If you're doing any more work with the eytzinger code we could also turn
those tests into more standard unit tests, right now there's no harness
to drive them.


> ---
>  fs/bcachefs/eytzinger.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/eytzinger.h b/fs/bcachefs/eytzinger.h
> index 0541192d7bc0..9fa63a624c92 100644
> --- a/fs/bcachefs/eytzinger.h
> +++ b/fs/bcachefs/eytzinger.h
> @@ -73,7 +73,7 @@ static inline unsigned eytzinger1_next(unsigned i, unsigned size)
>  	if (eytzinger1_right_child(i) <= size) {
>  		i = eytzinger1_right_child(i);
>  
> -		i <<= __fls(size + 1) - __fls(i);
> +		i <<= __fls(size) - __fls(i);
>  		i >>= i > size;
>  	} else {
>  		i >>= ffz(i) + 1;
> @@ -89,7 +89,7 @@ static inline unsigned eytzinger1_prev(unsigned i, unsigned size)
>  	if (eytzinger1_left_child(i) <= size) {
>  		i = eytzinger1_left_child(i) + 1;
>  
> -		i <<= __fls(size + 1) - __fls(i);
> +		i <<= __fls(size) - __fls(i);
>  		i -= 1;
>  		i >>= i > size;
>  	} else {
> -- 
> 2.46.2
> 
