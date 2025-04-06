Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF01C18DB2F
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Apr 2025 17:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743961039; cv=none; b=cwsCgwCS3ue/mqo4r8Dkoly+hZMlrhpPTZZsVctWAeTELaKnsCTwoC5wrj/dvNrIX1J6i4BMjgnXNiQ5JhHW4bK8i4Xg/bEA3dp4MNtDkKJ+eLVlICbkTAH2ag70kN5c/nr7W2UAQk8JPyOJKaBGoo87+5l2gNRlpdoveqHyfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743961039; c=relaxed/simple;
	bh=sH2Ny93X2vyJnTcewpo1S2IF8GKfBxc4fWMa58Kg9mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hi+Qy9NM/dtr2cdHln1soz5M6YzOqWFznECY5QilIKgGY0LYmcLDYqgTNFfo3+iJ5X+n6LZ4MQnLn/XjGc9M+bRWHFfNJdqwdktVHILmmzfmReJIbfFsZ2yPTgPLntNy5g2Ze1AE/iT/cakP4MoeqIQ9azGRBcd98dvNYMWaoN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ceZYQpWl; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ceZYQpWl"
Date: Sun, 6 Apr 2025 13:37:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743961033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7uHlHes3zQj3Ipe3BYOH+iLJ9DR2l41JdYucAC4FPjU=;
	b=ceZYQpWlSfm+KQS7gHMEln5VIbroDBCQR8xcHq9KhfW9KNmJQtNx0CrVLc0iFA3omQ/GCs
	kTx2DuyBhXTFA0eDsNcQIDXD+71rZ//UTgVaaF7QR1MiQplC/9zJxYzOAhYzFwmvqMwm/a
	/7mttALNDLz9mhTU34XDUKcaCtJ2QPc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: refactor if statements in
 bch2_opt_compression_parse()
Message-ID: <cxiovbh5tdwvt2k33bmdaonyncrdipbt6qj3h3gjyyi5mbzf4z@ss532ksrku46>
References: <20250406152659.205997-2-integral@archlinuxcn.org>
 <20250406152659.205997-3-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250406152659.205997-3-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 06, 2025 at 11:27:00PM +0800, Integral wrote:
> Refactor if statements in bch2_opt_compression_parse() to make it
> simpler & clearer.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>
> ---
>  fs/bcachefs/compress.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
> index d68c3c7896a3..adf939b47107 100644
> --- a/fs/bcachefs/compress.c
> +++ b/fs/bcachefs/compress.c
> @@ -713,10 +713,11 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
>  	level_str = p;
>  
>  	ret = match_string(bch2_compression_opts, -1, type_str);
> -	if (ret < 0 && err)
> -		prt_str(err, "invalid compression type\n");
> -	if (ret < 0)
> +	if (ret < 0) {
> +		if (err)
> +			prt_str(err, "invalid compression type\n");
>  		goto err;
> +	}

I prefer the old code for this one

>  
>  	opt.type = ret;
>  
> @@ -724,14 +725,13 @@ int bch2_opt_compression_parse(struct bch_fs *c, const char *_val, u64 *res,
>  		unsigned level;
>  
>  		ret = kstrtouint(level_str, 10, &level);
> -		if (!ret && !opt.type && level)
> -			ret = -EINVAL;
> -		if (!ret && level > 15)
> +		if (!ret && ((!opt.type && level) || level > 15))
>  			ret = -EINVAL;

This part does look better, though.

> -		if (ret < 0 && err)
> -			prt_str(err, "invalid compression level\n");
> -		if (ret < 0)
> +		if (ret < 0) {
> +			if (err)
> +				prt_str(err, "invalid compression level\n");
>  			goto err;
> +		}
>  
>  		opt.level = level;
>  	}
> -- 
> 2.49.0
> 
