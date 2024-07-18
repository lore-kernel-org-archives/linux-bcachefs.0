Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3F11442E8
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 22:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721343034; cv=none; b=FYkV1H71RCpHD6p34omL8XluvuCHzm0U3of/tp7NFFAuu8rlgOt1WEG3tBwOZUPVFORr41BViagtbIPlX2Q5ttCuSXFbkq0z2HDsJDnJ0LEo1mGi+kdwzD7i1hnb6so3hg4BNDBEKzmezaqpE+Wx4j++Lca4TwSWvyaMbCdc/QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721343034; c=relaxed/simple;
	bh=FdHt5mRFaP2eZC75yEVcuRY2Ou+dWKJhANRy0FLS20o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UDqESwXv5m/lDdyWYBXGRPFf21vPOwXKi6nHovfkB2I865W9kBpQdTe0HZvYf9nA7lYqkMPvdXIqqYkP+rH58X6dU29iF3VtiGDeFQVjGo739qHpqdN1DSs4Phalk8vOIyAt5QoaUBsWc1Be81jgc7e/uV5wNGo+nqT7RkTcL9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MQ68ZBc6; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MQ68ZBc6"
X-Envelope-To: integral@murena.io
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721343031;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Isv/8V+gy75BMbJnjjlilzfyt5zl5pVKaUDgvyKoPs=;
	b=MQ68ZBc6uY9y70E4q9znzvSRt2IL2w7D+Y0qRe5ha50mwcZS8Si2jzZBNZTcuLR7JdDNB/
	WatRVlNrd/mbK+0lJV7j517V9wEh/p34dFgUtRCHlXe8/FAxf35yyVEeIYb1IER3i71ScZ
	zTeS/J5Du/e0A2UT5BB5GN1xA57KV3c=
X-Envelope-To: lihongbo22@huawei.com
X-Envelope-To: kent.overstreet@gmail.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
Date: Thu, 18 Jul 2024 18:50:29 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@murena.io>
Cc: lihongbo22@huawei.com, kent.overstreet@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] Add support for true/false, yes/no & on/off in bool-type
 options
Message-ID: <u3wl6277ljmgqlbjw5pxu3oeljgftekeati6xcsyfden25umo6@p3z3z4yc6drg>
References: <7f1b35b2-437c-42b2-950b-556ce272c745@huawei.com>
 <20240718122926.99326-3-integral@murena.io>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718122926.99326-3-integral@murena.io>
X-Migadu-Flow: FLOW_OUT

On Thu, Jul 18, 2024 at 08:29:28PM GMT, Integral wrote:
> Here is the new patch:
> 
> Currently, when using bcachefs-tools to set options, bool-type options can
> only accept 1 or 0. Add support for accepting true/false, yes/no &
> on/off for these options.
> 
> Signed-off-by: Integral <integral@murena.io>
> ---
>  fs/bcachefs/opts.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index 0770aebef6d8..0e4cd6984eda 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -332,17 +332,21 @@ int bch2_opt_parse(struct bch_fs *c,
>  	switch (opt->type) {
>  	case BCH_OPT_BOOL:
>  		if (val) {
> -			ret = kstrtou64(val, 10, res);
> +			if (!strcasecmp(val, "1") || !strcasecmp(val, "true") ||
> +				!strcasecmp(val, "yes") || !strcasecmp(val, "on")) {
> +				*res = 1;
> +			} else if (!strcasecmp(val, "0") || !strcasecmp(val, "false") ||
> +				!strcasecmp(val, "no") || !strcasecmp(val, "off")) {
> +				*res = 0;
> +			} else {
> +				if (err)
> +					prt_printf(err, "%s: must be bool", opt->attr.name);
> +				return -BCH_ERR_option_not_bool;
> +			}

There _should_ be something more standard in the kernel for parsing bool
options (commandline options, module options) - please hunt around for
that and see if it works; report back on what you find.

We want to be consistent on how we parse bools throughout the kernel.
