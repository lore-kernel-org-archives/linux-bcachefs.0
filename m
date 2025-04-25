Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD38D25229A
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 14:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745591931; cv=none; b=BnlsWsJvsrkh9/mltT91m3AkOcrCfMRfH+E6ktoX5VryaFCWlGIH7BS2TVQa0Tzxl1M7LsOG0PXSNe1DCZX82IHvzhTRKygui/kzqrpw5R0GmAhXEUvAgAcdjKM3F9uzc3xBTto7kSCSddeSbcTI1cnh6WazscJwocxzehKinhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745591931; c=relaxed/simple;
	bh=epHY68MFyyZIzqi7KiPXF3G+r54SPxkENTQ4L7ZBe04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmhzoajSibBH5neWRpdiRePRbFFz3a14ZHbmB5j6T8IqjtSO2iA5vxA9ycla1RmFiMohv9BJIg7d59fC2B3oaF/ZH0TBrGa/8swfg2Yfz5gSJOG0maTi0a1+iVxYiUIkV2uI67B3tZju8s6Qr8mNoWM9jOvE1PdYKrln4keTFlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C6bmfSLk; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C6bmfSLk"
Date: Fri, 25 Apr 2025 10:38:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745591925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2fPaVzy2yD5b5bKnwNMaNyI6R4gquNpfiFjlJ13rZX8=;
	b=C6bmfSLkqpGDGxbeek5XFUlohSmmPuXO6L0OwRkRhcW025L0GLgh77iVoRRau9lwWEzcdh
	XwRBBSp3KTjDYTLx5hGX773PIu9dZO5+bKfI/Kd+OFmWG2GS8AWexmZb0HT+2qD14q9QTQ
	tnYA6MTkxfaB+vpWXuWz72WMJwItJGA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gabriel de Perthuis <g2p.code@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Don't pretty-print options in /proc/mounts
Message-ID: <fbvjt2yfcjwyffic3f4k7fhdt2ag7vjilrwnbl26g3qjv27rly@7awwgxnljyex>
References: <03c6436f10a17e4e520c611d8dbca0b5a56532c8.1745590098.git.g2p.code@gmail.com>
 <fd204ad5-b8bc-45aa-b761-fc2ef91abd27@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd204ad5-b8bc-45aa-b761-fc2ef91abd27@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 25, 2025 at 04:15:18PM +0200, Gabriel de Perthuis wrote:
> 
> Pretty printing of sizes could introduce spaces and break
> the expected space-separated format.

we shoudldn't be including spaces when we print human readable numbers,
that's the bug...


> 
> Signed-off-by: Gabriel de Perthuis <g2p.code@gmail.com>
> ---
> v2: Tested and working this time
> 
>  fs/bcachefs/opts.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/opts.c b/fs/bcachefs/opts.c
> index b1cf88905b816..633137567f463 100644
> --- a/fs/bcachefs/opts.c
> +++ b/fs/bcachefs/opts.c
> @@ -452,25 +452,29 @@ int bch2_opt_parse(struct bch_fs *c,
>  void bch2_opt_to_text(struct printbuf *out,
>  		      struct bch_fs *c, struct bch_sb *sb,
>  		      const struct bch_option *opt, u64 v,
>  		      unsigned flags)
>  {
> +	enum opt_flags opt_flags = opt->flags;
> +
>  	if (flags & OPT_SHOW_MOUNT_STYLE) {
>  		if (opt->type == BCH_OPT_BOOL) {
>  			prt_printf(out, "%s%s",
>  			       v ? "" : "no",
>  			       opt->attr.name);
>  			return;
>  		}
>  
>  		prt_printf(out, "%s=", opt->attr.name);
> +		// OPT_HUMAN_READABLE can introduce spaces which break the expected tabular format
> +		opt_flags &= ~OPT_HUMAN_READABLE;
>  	}
>  
>  	switch (opt->type) {
>  	case BCH_OPT_BOOL:
>  	case BCH_OPT_UINT:
> -		if (opt->flags & OPT_HUMAN_READABLE)
> +		if (opt_flags & OPT_HUMAN_READABLE)
>  			prt_human_readable_u64(out, v);
>  		else
>  			prt_printf(out, "%lli", v);
>  		break;
>  	case BCH_OPT_STR:
> -- 
> 2.45.2
> 
