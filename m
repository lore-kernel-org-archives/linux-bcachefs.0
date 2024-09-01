Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DF51859
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Sep 2024 01:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725152983; cv=none; b=D/Njd0+PB/mEJKuJceQF9bd69qfQXAtUkcau9RvW0K421Y6oi1F7pQjif8BGOdVyowUOC8PaBBqEjeTvW3Zw4QRvkQ1CjoneWYXuBNc+P/RF6ff5BkF3RpxYE9pfVbb8vYOutRJ+xxP6H7eQrwSAg2Zx6HI3rUm30boDtGmty3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725152983; c=relaxed/simple;
	bh=TLWE6BRdR8Gz0Fhpy+vu84d556joGv5fewRbETjCTNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WE8aaiP4f0E0rMGCy535tlqyrgE/kiwuWtu/FSlAuK8ZfPK5Qm0pqzMixXxwlmKw8K2HgtqBQ9iZpL+v3rtQIQuSVaBJ/x4i6G9Nm+sGSyqL6UmU2c4BX+tJTa/JCVq82gYKoeat1ZsyAYOb2qlg8U5kTQToU34BU0EDHOs9i2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SHDBbAda; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SHDBbAda"
Date: Sat, 31 Aug 2024 21:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725152977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XKDU2rcJLZoZ3QUtQpYeZh5HP0gAqCN+GxQ+HiQEYeU=;
	b=SHDBbAda6uW+BAateiYGWWVn7q+PO5c+KEBjbWSppcWYnooqh/1yfoaz7mnJbaJ1gbTcnZ
	VMO/fombbQH4+4JkZXFzO55dzH0bJZCzWKYunOEQOCMfmd5im1QHTG64Lv5cwDb6d+6MkV
	KkWHHyM3xILh0nNbQksi7oWatlPVCHk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix lost wake up
Message-ID: <hp2wa4k32nej5x5rgp6l2ffxsrdmgg2x5nxhuaqjzw7l24xmr3@pzticjr576mf>
References: <20240827151448.680522-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827151448.680522-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Aug 27, 2024 at 11:14:48PM GMT, Alan Huang wrote:
> If the reader acquires the read lock and then the writer enters the slow
> path, while the reader proceeds to the unlock path, the following scenario
> can occur without the change:
> 
> writer: pcpu_read_count(lock) return 1 (so __do_six_trylock will return 0)
> reader: this_cpu_dec(*lock->readers)
> reader: smp_mb()
> reader: state = atomic_read(&lock->state) (there is no waiting flag set)
> writer: six_set_bitmask()
> 
> then the writer will sleep forever.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/six.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 3a494c5d1247..b3583c50ef04 100644
> --- a/fs/bcachefs/six.c
> +++ b/fs/bcachefs/six.c
> @@ -169,11 +169,17 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>  				ret = -1 - SIX_LOCK_write;
>  		}
>  	} else if (type == SIX_LOCK_write && lock->readers) {
> -		if (try) {
> +		if (try)
>  			atomic_add(SIX_LOCK_HELD_write, &lock->state);
> -			smp_mb__after_atomic();
> -		}
>  
> +		/*
> +		 * Make sure atomic_add happens before pcpu_read_count and
> +		 * six_set_bitmask in slow path happens before pcpu_read_count.
> +		 *
> +		 * Paired with the smp_mb() in read lock fast path (per-cpu mode)
> +		 * and the one before atomic_read in read unlock path.
> +		 */
> +		smp_mb();

What is this barrier ordering?

This is only a change in the !try case, and we didn't do anything before
checking pcpu_read_count() - except way back in six_lock_slowpath()
where we set SIX_LOCK_HELD_write, but that does have a barrier.

>  		ret = !pcpu_read_count(lock);
>  
>  		if (try && !ret) {
> -- 
> 2.45.2
> 
