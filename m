Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E83414F9D9
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 20:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730926647; cv=none; b=l5YIH510JwCS8n+e0wlipYSQrZhHby+2uH6x+YmoxDxqUEKgoJWX4sqW/tBXD1r2jI97+zgIQWiiGYNnYt6ZTZNmb0fyPw9tBistEtYWAel7o+Kyk3z0MB/eBxM9J3snOp05oEJiDa2fYlxaeOvZjJUmwfCBGZ0ReTXIFaqAN6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730926647; c=relaxed/simple;
	bh=dZuvF83IXYJXupxHZE099aiodPb+Z5AqCA56iv4qUB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jr9awTgqLmfyi9ht6dHMEIyUVHZHug+1VwntXPW6dalsoH1dVTu90eEZr6Q0PWlWR5M475yCO/QOwzNTGPPVaJmtIjkGih/F6r+em2CuqWRxvutbmIVJZihhljXGFyCAO9vXDkcOvMrt9LcqgFIyZHLCeFDfi0sQofk1EMOpLTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vcq1KOGi; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vcq1KOGi"
Date: Wed, 6 Nov 2024 15:57:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730926642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LE7GTXlvS9azbZbdUMiTosoynBaaDsHv9uOptO4TBrg=;
	b=vcq1KOGiykDrS+Uo+0erUxlROqlrje+d/lucdoA4/XIJ1Q3NjRLLvxy1Gjs+9yavewjEG/
	0/Sqf2Q5rYWMROwbN8X+sjQ07DYu1SQA6TVugAp40RN+KTO2J6nRlvpQ52jCpduH0noAo8
	K37oJrmZPDRymV/9wMPJG2T5es/mU5I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	skhan@linuxfoundation.org, syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] Change OPT_STR max to be 1 less than the size of
 choices array
Message-ID: <sxtugjw3gbifdvountioelfdpeqa7hnx4jxd3a76nh5uklf3du@vd7wof7b7nge>
References: <20241106193443.307896-2-pZ010001011111@proton.me>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106193443.307896-2-pZ010001011111@proton.me>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 07:46:30PM +0000, Piotr Zalewski wrote:
> Change OPT_STR max value to be 1 less than the "ARRAY_SIZE" of "_choices"
> array. As a result, remove -1 from (opt->max-1) in bch2_opt_to_text.
> 
> The "_choices" array is a null-terminated array, so computing the maximum
> using "ARRAY_SIZE" without subtracting 1 yields an incorrect result. Since
> bch2_opt_validate don't subtract 1, as bch2_opt_to_text does, values
> bigger than the actual maximum would pass through option validation.
> 
> Reported-by: syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bee87a0c3291c06aa8c6
> Fixes: 63c4b2545382 ("bcachefs: Better superblock opt validation")
> Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>

Thanks! Applied

> ---
> 
> Notes:
>     Changes in v2:
>         - Instead of subtracting 1 in bch2_opt_validate as in
>           bch2_opt_to_text add -1 in OPT_STR macro definition
>           and remove subtraction in bch2_opt_to_text.
> 
>     link to v1: https://lore.kernel.org/linux-bcachefs/20241031231823.688918-2-pZ010001011111@proton.me/
> 
>  fs/bcachefs/opts.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 83f55cf99d46..49c59aec6954 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -227,7 +227,7 @@ const struct bch_option bch2_opt_table[] = {
>  #define OPT_UINT(_min, _max)	.type = BCH_OPT_UINT,			\
>  				.min = _min, .max = _max
>  #define OPT_STR(_choices)	.type = BCH_OPT_STR,			\
> -				.min = 0, .max = ARRAY_SIZE(_choices),	\
> +				.min = 0, .max = ARRAY_SIZE(_choices) - 1, \
>  				.choices = _choices
>  #define OPT_STR_NOLIMIT(_choices)	.type = BCH_OPT_STR,		\
>  				.min = 0, .max = U64_MAX,		\
> @@ -429,7 +429,7 @@ void bch2_opt_to_text(struct printbuf *out,
>  			prt_printf(out, "%lli", v);
>  		break;
>  	case BCH_OPT_STR:
> -		if (v < opt->min || v >= opt->max - 1)
> +		if (v < opt->min || v >= opt->max)
>  			prt_printf(out, "(invalid option %lli)", v);
>  		else if (flags & OPT_SHOW_FULL_LIST)
>  			prt_string_option(out, opt->choices, v);
> -- 
> 2.47.0
> 
> 
