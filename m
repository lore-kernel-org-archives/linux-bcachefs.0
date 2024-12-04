Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3A9848C
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Dec 2024 02:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733279049; cv=none; b=Tfm6vNWk21QS1Wl9XO1wEaQvceLHLU4i9bFS5IW1N2hE5eeFFe90GVkthaVxaedjy5UXR1Z7JE88AJZHJuGkByH3I2oq1gKnKBIwhG83qUGhvCDMMiwlLvf2nC1JgBstZHp4IPNR8e7Wny33yfwvm/0pFpztwjA5Fdpu4DLeha0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733279049; c=relaxed/simple;
	bh=6kj4sx7kUK6/t0DyEjE1u2rA1e/k19OPIQkCxRDBG2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LolG3011zE6w96hKPFGLioCiEsAP8USqru4TXPHK/5ao4y4MLIjFgVB1gUJHidtQlhG12hPVCeE6rMbHAinfi8rImI+QQ2hT6tvwsX2/eSKUgjWuJllEtiHnBY9iB7xMQoKoOhMVaorH0C/51kYsNb2aWT2Uwwkide4Yy24qAf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NL1G7SVL; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NL1G7SVL"
Date: Tue, 3 Dec 2024 21:23:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733279034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Erq8KHqMTiHk2SkHdDw3umySOz3AJFP/y3LhXC2ABUg=;
	b=NL1G7SVLrn4G82Se+3iwOIxOvlFDv471C3bN/t56vcZhoyWexvqSmebD2Ol/Qh5okSRjG8
	kMiBoIvr82besJESsC931Z49QhxWymZc9ePSSIAux1h5ZpZkF0jChFN5eGwmR144w0qgyz
	FKyhn04lQngC8hllFiLNfyVc9LsIMIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	linux-bcachefs@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] bcachefs: BCACHEFS_PATH_TRACEPOINTS should depend
 on TRACING
Message-ID: <jdp4jdy7cj266m5xhrbodosfbj2lxoeykhkcugnbare5dbgkfw@xkpknsymnapl>
References: <2d26d15c39b72c815f14593b8cc916d47e82402d.1733243875.git.geert@linux-m68k.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d26d15c39b72c815f14593b8cc916d47e82402d.1733243875.git.geert@linux-m68k.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 03, 2024 at 05:40:10PM +0100, Geert Uytterhoeven wrote:
> When tracing is disabled, there is no point in asking the user about
> enabling extra btree_path tracepoints in bcachefs.
> 
> Fixes: 32ed4a620c5405be ("bcachefs: Btree path tracepoints")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Thanks, applied

> ---
>  fs/bcachefs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/Kconfig b/fs/bcachefs/Kconfig
> index ab6c95b895b33591..464b927e4fffd1f2 100644
> --- a/fs/bcachefs/Kconfig
> +++ b/fs/bcachefs/Kconfig
> @@ -90,7 +90,7 @@ config BCACHEFS_SIX_OPTIMISTIC_SPIN
>  
>  config BCACHEFS_PATH_TRACEPOINTS
>  	bool "Extra btree_path tracepoints"
> -	depends on BCACHEFS_FS
> +	depends on BCACHEFS_FS && TRACING
>  	help
>  	Enable extra tracepoints for debugging btree_path operations; we don't
>  	normally want these enabled because they happen at very high rates.
> -- 
> 2.34.1
> 
