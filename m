Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9F27DA7F
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Apr 2025 17:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743960388; cv=none; b=r2T7/9OtoOO0Qt1fx9gx9LGb6czMiqCxaWvntFk0PG9wq9sjT9ud+YGSFU1y74laEgHZmdyLssk9Zelr3h/chHXEusauUf1gNXhmv4tSPl9jiR1Boy59uc/ha6369yYiGpJQXR11UFTVYBBBIZtER3XXOXGyBu4vOrsFSuC5lxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743960388; c=relaxed/simple;
	bh=IQD2uMYm0VdicIsri6U+XrvP/ma6PNlN1XAS6ghLTRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9zY8jgABRMPJtp4+LReDwuF07LEIw6HZcgIjozPBxlVaQC7ggLuWEQPLeLQyN6tgBeL/17Wq2LTfovYJUuf4RK3YOqdb/pxcI8xikoIL8cpUEoOuQU/fqhL6sYHqSnEXMkmj+VZbdXxpDJVKPPLy8xWBasg5O4Cf8P/70YCTW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rlhP0s4V; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rlhP0s4V"
Date: Sun, 6 Apr 2025 13:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743960383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YgAXDMjAExFolysJWmD+ac3Y9JLrzwMRq++noKLcT/k=;
	b=rlhP0s4VPfnYsLdJ05OboGkIbDweX2sD/0msBaj32wIvVyS4sPsFFJhmU7AfKELVo0Okc0
	p7zLyY5c3p1XLhJYQWn1mDXg2lCsm7wSrdJF086871wC4cGUzqcyXUEvNovO9/K9IJEr5k
	2ZXFVWsMGvbMZ/g2n7/hH3zfR+brF4g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: early return for negative values when
 parsing BCH_OPT_UINT
Message-ID: <khrsd3ey6hiedccufg2xhy734vdxzagg4eym3gotjxaizgrx7x@7bo4fpsj7n7f>
References: <hepk5mxy7zfr534i4mbqbjr3jzkqytbnfz66lelzcewwu5h47h@df7qq7laaypr>
 <20250406145327.191479-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250406145327.191479-2-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 06, 2025 at 10:53:28PM +0800, Integral wrote:
> Currently, when passing a negative integer as argument, the error
> message is "too big" due to casting to an unsigned integer:
> 
>     > bcachefs format --block_size=-1 bcachefs.img
>     invalid option: block_size: too big (max 65536)
> 
> When negative value in argument detected, return early before
> calling bch2_opt_validate().
> 
> A new error code `BCH_ERR_option_negative` is added.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Applied

> ---
>  fs/bcachefs/errcode.h |  1 +
>  fs/bcachefs/opts.c    | 12 +++++++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index c4eb0ed9838d..e3c85288fd6d 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -213,6 +213,7 @@
>  	x(EINVAL,			inode_unpack_error)			\
>  	x(EINVAL,			varint_decode_error)			\
>  	x(EINVAL,			erasure_coding_found_btree_node)	\
> +	x(EINVAL,			option_negative)			\
>  	x(EOPNOTSUPP,			may_not_use_incompat_feature)		\
>  	x(EROFS,			erofs_trans_commit)			\
>  	x(EROFS,			erofs_no_writes)			\
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index e64777ecf44f..1bf2580ab735 100644
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
> +			return -BCH_ERR_option_negative;
> +		}
> +
>  		if (ret < 0) {
>  			if (err)
>  				prt_printf(err, "%s: must be a number",
> -- 
> 2.49.0
> 
