Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE6F1CD37
	for <linux-bcachefs@vger.kernel.org>; Mon, 22 Jul 2024 21:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721682073; cv=none; b=A+OjOqWituUi+Znx1IlYYjZp/1Gjh0R4r42j0zVwD4zufaVmnT4cClikyvVFREe4QZSK8pGm6SIem6cHziQn4hdteNIGuYgKJKgjm5ZCdsl69IzPqHk2uBUpOpQMGPOhB5wcEBsl+AvZB2SMXyfzPygMo6CaDSTOJQ2hQwoqowg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721682073; c=relaxed/simple;
	bh=0s/cU3L9WX3PLpyNg9iirymSco4CaAn5s+JUbVuoN8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MuK2Sjx2M8EmGqqVCuu21VyGny3TweToRR7syPx3yhFSKQB/MeBVIlRFEAc4WmN6UOFwu/JPkiIosWFbpd/lxSSSO2bjFNCRqVMqhkoZ0XScmQx8uu9tZyP0s4lTS45+5r4znw/tf5iTXVfLuCGnRdSEzlHSmkdfATCb7HZt2+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kLMqJMnu; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kLMqJMnu"
X-Envelope-To: integral@murena.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721682067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jYVi85O95aR1XZ8j5lo1UfaGA2F/qEjt/HqzgEaPLAk=;
	b=kLMqJMnuuILhh/2ezKk4RvJ3d1ZHg/8xWS5hWeJdTidAg6VFT9rLBYK/4Z524jOrdE9jmW
	KU0utvSMhUuc5hNekNb/lbkbDIJ49rFURHaykEiaNEM0TbXo/j6vZrpN8zW4y0WZJwnwEy
	mYmgY5Hreu/vDg1TnPAkeUQgtWe07Ug=
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Mon, 22 Jul 2024 17:01:03 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@murena.io>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] Add support for true/false & yes/no in bool-type options
Message-ID: <25nuibtkw7cpleosdjbpa5bnofluy25x5yxrdoc6sucka3lzor@fisvpldzhemx>
References: <20240718062835.58037-2-integral@murena.io>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718062835.58037-2-integral@murena.io>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 02:28:36PM GMT, Integral wrote:
> Currently, when using bcachefs-tools to set options, bool-type options can
> only accept 1 or 0. Add support for accepting true/false and yes/no for
> these options.

this needs to be against the kernel repo, fs/bcachefs/; tools is
imported from there

> 
> ---
>  libbcachefs/opts.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/libbcachefs/opts.c b/libbcachefs/opts.c
> index 0770aebe..2c0113fb 100644
> --- a/libbcachefs/opts.c
> +++ b/libbcachefs/opts.c
> @@ -332,6 +332,11 @@ int bch2_opt_parse(struct bch_fs *c,
>  	switch (opt->type) {
>  	case BCH_OPT_BOOL:
>  		if (val) {
> +			if (!strcmp(val, "true") || !strcmp(val, "yes"))
> +				val = "1";
> +			else if (!strcmp(val, "false") || !strcmp(val, "no"))
> +				val = "0";
> +
>  			ret = kstrtou64(val, 10, res);
>  		} else {
>  			ret = 0;
> -- 
> 2.45.2
> 
