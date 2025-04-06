Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7878421767A
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Apr 2025 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743948733; cv=none; b=Y1aw4FVMJ2VAVfn+sYzZSEmHSqa4+6K1zwLvrZT6fePVxJ6RA17jH/bOVwAwOZYMiPOdTvsU6Nfld1QJV6PUsL70IWYdEeEilcTH24QHftPS8XPyzigl1rWZTeCYaERiZYC7i3wkfrxr0rao30aq9tbGoN7tsplKU1KNjKnU+Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743948733; c=relaxed/simple;
	bh=lqZbfkbk0ZcA2LIuruKYg/F+tzBLHT//KF3zOSp5VXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WBURraBxjpFynU38d/2L7w0buKZjoTFMsyqfNzX57jFaNBgMEpE9gfm1cjEs0XiBDl8IxbF6WdzbiJN81yOxEv/NMWsCA74eplHXkNzl4exfOiws+ZMl4axF00swhrhyYqZHrvTvqSEY3HP6nqMJPFQL03VqFZuV3hsnoEm54R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DsXbdsi1; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DsXbdsi1"
Date: Sun, 6 Apr 2025 10:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743948718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pWF83rzDf1eFbwOMCuQAlihrrS/Vai0y6L2bpP28ty8=;
	b=DsXbdsi1+soakr/Bj8mmB2XEYgYjZuirj4x2fqzYuyKqzYnvdJhPZRCXllmqLVEpETamBb
	LTaT0Ie3gaRtZZUfyLDYdsJiroLtG8UZKdjOEo3Q607mt4oLMD83sQ0N+3cPtPXRWcaLyN
	MwsZ5/6n33LS+nwT/vyKBgLSiZQtmfA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcachefs: return early for negative values when parsing
 BCH_OPT_UINT
Message-ID: <hepk5mxy7zfr534i4mbqbjr3jzkqytbnfz66lelzcewwu5h47h@df7qq7laaypr>
References: <20250406135929.178583-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250406135929.178583-2-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 06, 2025 at 09:59:30PM +0800, Integral wrote:
> Currently, when a negative integer is passed as an argument, the error
> message incorrectly states "too big" due to the value being cast to an
> unsigned integer:
> 
>     > bcachefs format --block_size=-1 bcachefs.img
>     invalid option: block_size: too big (max 65536)
> 
> To resolve this issue, return early for negative values before calling
> bch2_opt_validate().
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

No new -EINVAL in kernel code :)

> ---
>  fs/bcachefs/opts.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index e64777ecf44f..31f90c177c6c 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -360,9 +360,15 @@ int bch2_opt_parse(struct bch_fs *c,
>  			return -EINVAL;
>  		}
>  
> -		ret = opt->flags & OPT_HUMAN_READABLE
> -			? bch2_strtou64_h(val, res)
> -			: kstrtou64(val, 10, res);
> +		if (*val != '-') {
> +			ret = opt->flags & OPT_HUMAN_READABLE
> +			    ? bch2_strtou64_h(val, res)
> +			    : kstrtou64(val, 10, res);
> +		} else {
> +			prt_printf(err, "%s: must be a non-negative number", opt->attr.name);
> +			return -EINVAL;
> +		}
> +
>  		if (ret < 0) {
>  			if (err)
>  				prt_printf(err, "%s: must be a number",
> -- 
> 2.49.0
> 
