Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BAD2F2E
	for <linux-bcachefs@vger.kernel.org>; Sun,  9 Mar 2025 06:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741503593; cv=none; b=ncW8PoFrcaFkAe6y+yyLFK04fCs1XWf615UPi+3reS+rv70axuB5+nMCfqX1Kg5eLB1DFGMixURKwnthbgjNr9OgKjVxI8y4vb8A1lJiLdZLFm8DoNCvBN347gc/3kYNraaI6worEUoJl9OBOjezojVx/abBQrUILeCiHuMGv18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741503593; c=relaxed/simple;
	bh=xRGQ6EDHw8eAeX4nan1ViHSFHwdVpCV78lHD/6jyYyg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TwoSAkT3AhqqTZTSGWwjK6KYxHbtm3ucuSrtjN17iFMqJ49wU0/EHrTf2T+ImNsqBJVjjS5876yds0qholRVj90r6kdWa0wUqN89fQBveA7ptzSMB1AnlKnEso6vwco5AXyJu0huR6DeKYR2rADM6YcIDjf3CkPJR6DR0xFsm7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RnsERBds; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RnsERBds"
Date: Sun, 9 Mar 2025 01:59:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741503579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mIqL7mncAjmfvoVxE2rueV+w29+V1Dc/DigllQzb3MQ=;
	b=RnsERBdslBu3pIweSmXZGFFVA+PVgEGgx/ak1s1z/l2Qz1Nkco+ZoKOfPkddE11ca8YI8r
	sWU1qds8MjmRrWjWpc4H9aK2AmljX5iN33zMukOEZifU3l2HK/11AngSdmBHwn9bIpnFFm
	lj1czfL7USI+ddAphLw0NjLVa8RZzMo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] bcachefs: Remove unnecessary byte allocation
Message-ID: <whk5wq6xrgseskyam5r2pgvwyremagomvvckz4mrf2z5pbb5io@l2lk6halo73o>
References: <20250308195353.194683-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308195353.194683-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 08, 2025 at 08:53:53PM +0100, Thorsten Blum wrote:
> The extra byte is not used - remove it.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

applied
> ---
>  fs/bcachefs/fs-ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-ioctl.c b/fs/bcachefs/fs-ioctl.c
> index d9f1a7c09e85..9761a365552a 100644
> --- a/fs/bcachefs/fs-ioctl.c
> +++ b/fs/bcachefs/fs-ioctl.c
> @@ -244,7 +244,7 @@ static int bch2_ioc_reinherit_attrs(struct bch_fs *c,
>  	int ret = 0;
>  	subvol_inum inum;
>  
> -	kname = kmalloc(BCH_NAME_MAX + 1, GFP_KERNEL);
> +	kname = kmalloc(BCH_NAME_MAX, GFP_KERNEL);
>  	if (!kname)
>  		return -ENOMEM;
>  
> -- 
> 2.48.1
> 
