Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86108230278
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743566085; cv=none; b=dwwJRU1eLv/+N2OFTkRzPxq6kV0q+EGdfllIfQAivhGQsKebvTaC7Ix7J9/pvQO4GQ+U7juCB1Nx3lQ74QIvBNR1DTKzVkQcXeHE21S1SfzV0PQWftt670Dc0JE+Au0myAHe+uWoaje60Azgc5pBZXJyatCxN6tQ3HwYGEuhoJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743566085; c=relaxed/simple;
	bh=4+cGx2pNMVm4OPG6tmF/87u7sH0DkOSHI9P7BTtgk5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8eSP17VPKb18wANP2IT16NCp3XX/zdnwvflEdEOXlN/28xufSt50TEaCoX+kNq7Dol84pLvBq1UeLcSvUVWALOtLwzYvrsulOILrFpishJBqCpZ31I+l9S/NW6wcQpaK7Py1nXq52sfgsS7V4kM+mHaL7S5kfj/eEsHa6hbSkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wxBPD4nQ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wxBPD4nQ"
Date: Tue, 1 Apr 2025 23:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743566080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=56GehfYKWv13sZo5D3tbWDapDfFWFoTHEsxQe/ua+z0=;
	b=wxBPD4nQNhg9vQGFJGhdfis0LWSDknpL9ZTRgiObOdcQDg3D6eF7R5lReJrFH5MpmP9gwk
	N54j/jpCNhNiLLuh1j0ARKVhCpjWiv5u+tPoTwz/fTtNeNgQ+15acK62vUYMIPP8dC7m4O
	JI+NU/ZISHBZyuVS1+Y5lEqoUS+23Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] bcachefs: add missing selection of XARRAY_MULTI
Message-ID: <zs5jhkw4vkgtevtthtur4n5tq3bjud2d5da6ubeuoutxvoti22@627me7xalpwr>
References: <20250402032648.266034-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402032648.266034-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 01, 2025 at 08:26:48PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When CONFIG_XARRAY_MULTI is not set, reading from a bcachefs file hits
> the 'BUG_ON(order > 0);' in xas_set_order(), because it tries to insert
> a large folio in the page cache.  Fix this by making bcachefs select
> XARRAY_MULTI.
> 
> Fixes: be212d86b19c ("bcachefs: bs > ps support")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'm not entirely sure this is the correct fix; if it's not, please treat
> this as a bug report...

Seems reasonable - if there's a better way to do that, we can do that as
a cleanup later, I'm applying it and queueing it up for the next pull
request.

> 
>  fs/bcachefs/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
> index c9798750202d3..bf1c94e51dd06 100644
> --- a/fs/bcachefs/Kconfig
> +++ b/fs/bcachefs/Kconfig
> @@ -24,10 +24,11 @@ config BCACHEFS_FS
>  	select XOR_BLOCKS
>  	select XXHASH
>  	select SRCU
>  	select SYMBOLIC_ERRNAME
>  	select MIN_HEAP
> +	select XARRAY_MULTI
>  	help
>  	The bcachefs filesystem - a modern, copy on write filesystem, with
>  	support for multiple devices, compression, checksumming, etc.
>  
>  config BCACHEFS_QUOTA
> 
> base-commit: 88eeda35f19bab3a247ca25d99bc82ac710bc09f
> -- 
> 2.49.0
> 
