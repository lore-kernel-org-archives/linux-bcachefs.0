Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E281C5D53
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 18:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752864123; cv=none; b=h1EoHfTbwjypSkuPTaiJ+IJLGI+xsT9DYf2xLUGRTwHmRt7W/rJ6hWMU9k2TwS80WzdQCdKQzJmuAJXvqV8MfRbun/wSeNPwCCsZxh2rOYeJmQPD2IZf/Jd28rf6WHAyW968Uin0SC7Xao3B3O5ytcPcuPbfVA6Ro9mmTjAaA1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752864123; c=relaxed/simple;
	bh=NsRyXq3nGl1Ez6AbqO4hPZJhKFGmgVhs4X4mLVQcdJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnhuvFBzB0+CrlbfzutfeZc0W5qayGqNucOcfFfytimDztPXk3rxflGnEAdPxnUy7jT4k5hX8jOvpi+V0fxUoy/MuzB00If4sUJulILBvlSN22yWhOTG9Ou87ZENvsnUsF9dhpvMjXZPoEbeXaPOE35XEDy2jn0ykIR+f/QspMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XtyLL49C; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XtyLL49C"
Date: Fri, 18 Jul 2025 14:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752864118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ne/IIscPw7/rV0m8HcCGstUw8hGWx1dItLqcoo17YeU=;
	b=XtyLL49CQkatEDxnaHx3I8OTz/rZKJhrVexzkmHzeh+rJjuS91kvRRJ2YTcy23QcR5Ruxr
	zYHvv4m54dtIdYjRFzXckkDazjMqs2ihH9eQE6kHXQtdmNN3oHi0ZO+T2dqlMrX36wm2Qe
	NgX1SCEkdytRHB9DAKOoAKpVAha/5mc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2] bcachefs: Use user_backed_iter instead of
 iter_is_iovec
Message-ID: <rhrmugmgagllcouktp3em5pteu3i7ot6uiik5ifrl2gi54eabd@gwks7vd66zzd>
References: <20250718181635.1502126-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250718181635.1502126-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jul 19, 2025 at 02:16:35AM +0800, Alan Huang wrote:
> ITER_UBUF is also one of the user backed iter, which is equivalent
> of single-segment iovec. DIO handling should use user_backed_iter.

Applied...

> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
> 
> V2: imporve commit message
> 
> 
>  fs/bcachefs/fs-io-direct.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/fs-io-direct.c b/fs/bcachefs/fs-io-direct.c
> index 1f5154d9676b..6fdc477c81af 100644
> --- a/fs/bcachefs/fs-io-direct.c
> +++ b/fs/bcachefs/fs-io-direct.c
> @@ -127,7 +127,7 @@ static int bch2_direct_IO_read(struct kiocb *req, struct iov_iter *iter)
>  	 * the dirtying of requests that are internal from the kernel (i.e. from
>  	 * loopback), because we'll deadlock on page_lock.
>  	 */
> -	dio->should_dirty = iter_is_iovec(iter);
> +	dio->should_dirty = user_backed_iter(iter);
>  
>  	blk_start_plug(&plug);
>  
> -- 
> 2.48.1
> 
