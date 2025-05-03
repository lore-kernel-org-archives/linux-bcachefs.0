Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64228269CE0
	for <linux-bcachefs@vger.kernel.org>; Sat,  3 May 2025 20:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746302932; cv=none; b=nzuGw+nrgZSLYID/+dmVQJLgxvfUsObkUdjlNZiL8LA9thBpRTz1g4dv0VEGs3IB5Ed2U9k2x574L2GjfO/DGYNkuLnCXrXa8DZinJrncA184eG0Bg9jTcLlSPEtxb1ZOs6XoupsNreykziNpzrZN8AWySvkEfrLPFjo1FxpfCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746302932; c=relaxed/simple;
	bh=k9Stho2vzTYi2rfeOS5j4YPOhOOJdaVcvSzA0DCFMDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HaWkht4BIV4vPcfHk/l/uSrjvwKmzUUmboY0sRw+3neT907SoniUSk5mndIntwGO4G853Kpo/hBvr41/tEWwyrPl9nKGwodNld1aT0SdP6MV81pA2LRJsgPFakRXE/QsgC6cHfVVEnPz+8FVPagPA2elpTTijQBwX1c/EiTT9Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WcRhHEiz; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WcRhHEiz"
Date: Sat, 3 May 2025 16:08:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1746302927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Kzc49f3uM2YMXWUAyQLNEwEifA+Q7/9Z00weHWYRYKE=;
	b=WcRhHEizqZyt6pwYJ2Ah7BeMfsw12xvkOETBtqOJVWhrKn+4NtcjDERtiStmL3R3IAZkOd
	ucy0wriQMG+XI4H7/fzhH1bjIryTER69a1db1bM0iIKdnHlmZc7o2cLEceC6LH0irAV9fJ
	wsvE3QRF8DWQlFhxgFIZuHGE8UxdkCY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix inconsistent req->ec
Message-ID: <3gl7cmujetrnnd5tyot54odlo2n4sdni3mxesrcrsngwngjudy@y5wpe6zdyvr7>
References: <20250503200342.251303-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250503200342.251303-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, May 04, 2025 at 04:03:42AM +0800, Alan Huang wrote:
> There is req->ec = erasure_code above.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Thanks, I screwed this up when I was reducing stack usage in the
allocator path - it was only busted in -next, fortunately.

> ---
>  fs/bcachefs/alloc_foreground.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/alloc_foreground.c b/fs/bcachefs/alloc_foreground.c
> index a0f92daa44cf..c17c5733526d 100644
> --- a/fs/bcachefs/alloc_foreground.c
> +++ b/fs/bcachefs/alloc_foreground.c
> @@ -1255,6 +1255,9 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
>  	if (unlikely(ret))
>  		return ret;
>  
> +	if (!IS_ENABLED(CONFIG_BCACHEFS_ERASURE_CODING))
> +		erasure_code = false;
> +
>  	req->nr_replicas	= nr_replicas;
>  	req->target		= target;
>  	req->ec			= erasure_code;
> @@ -1262,9 +1265,6 @@ int bch2_alloc_sectors_start_trans(struct btree_trans *trans,
>  	req->flags		= flags;
>  	req->devs_have		= devs_have;
>  
> -	if (!IS_ENABLED(CONFIG_BCACHEFS_ERASURE_CODING))
> -		erasure_code = false;
> -
>  	BUG_ON(!nr_replicas || !nr_replicas_required);
>  retry:
>  	req->ptrs.nr		= 0;
> -- 
> 2.48.1
> 
