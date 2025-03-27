Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B02219A72
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 17:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743098321; cv=none; b=PHwjOlGuGYUy2PLZytx+cRmZEqDxg23VH+v5hTP0P9QjDo+hTu1hxC6w+mo1FedbkPCaCGAd1k5JWF2/dJtn48O8hqmV9MQn0Z+6CXL++V660DHWw1hbT0o0NVtlgkIFohAQEtGKzsuxM3M2zRwdOBlaoPIqZbXh8j8I3RAzh7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743098321; c=relaxed/simple;
	bh=b7SFmwX1qTesT4ml3DcWBfbdIuSiI7gCh0m1CkXvt5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=suOdt1KivDSwvum0n5+CQCvo5UhaPWUyQLjdCMqypdfpDyJmqLRfi8f0Yu8aGT9F7dCwYCosFEDKdwzPV+NlTMrl3UHYvz7I0XWOwsicWpoTX+yeeZNCq4mT3cYV2/U+ypouMoffBEGkIqg9xsIkUhfkGvaFwUza1NW3O5qYNWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B0nNNT4J; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B0nNNT4J"
Date: Thu, 27 Mar 2025 13:58:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743098316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JOVhDXpP/KqWZ7OO1AFqBvmPmkpgnhYxipQlmgQyaSM=;
	b=B0nNNT4JKkQaQPtjh9TaWCTmk3LIycbvqArmHHoT9poyDUQ+jNEJxavQI0kV00/0mwLpbd
	vspNudfCkGUd2I1DY6ZNbYGgOGg4T52sFHW6irrFZ+d3yuSu2L0ySjdSQnEpIh47ezIpnE
	kI3FHoGkcZfLtQ63QWnpMoVmFePNrfE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] [PATCH resend] bcachefs-tools: make targets of subvolume
 create/delete required
Message-ID: <szbowulci4mbwb75vo5ld4wyhrhqk4pm5d7kumv3wujjsknxyy@ur6hga6vigxy>
References: <20250327063718.211541-2-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250327063718.211541-2-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Thu, Mar 27, 2025 at 02:37:19PM +0800, Integral wrote:
> Currently, when no targets are provided for "bcachefs subvolume create" or
> "bcachefs subvolume delete", it will exit silently with code 0. Make targets
> (arguments) required to solve this problem.
> 
> This patch solves issue https://github.com/koverstreet/bcachefs/issues/766.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Thanks, applied

> ---
>  src/commands/subvolume.rs | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/src/commands/subvolume.rs b/src/commands/subvolume.rs
> index 7df20819..6f5f2f2b 100644
> --- a/src/commands/subvolume.rs
> +++ b/src/commands/subvolume.rs
> @@ -18,12 +18,14 @@ enum Subcommands {
>      #[command(visible_aliases = ["new"])]
>      Create {
>          /// Paths
> +        #[arg(required = true)]
>          targets: Vec<PathBuf>,
>      },
>  
>      #[command(visible_aliases = ["del"])]
>      Delete {
>          /// Path
> +        #[arg(required = true)]
>          targets: Vec<PathBuf>,
>      },
>  
> -- 
> 2.49.0
> 
