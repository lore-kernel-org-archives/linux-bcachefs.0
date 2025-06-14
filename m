Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F93A19D8AC
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Jun 2025 17:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749923942; cv=none; b=t8V0ty/gWYGrLDqfhLAeRslzoLySxiFp5uXwP2bvugllWtPJSBLuJaJeUcA9IH0O89q+IEU43P1Ytff8MYOdVaG0oIDnn4lA42bP9E+Wp3wLUro10N/HsGBDAKzDPzOo5DbltJ2hOF4kfs7yj8/YuoRdiMDTy9Tjxxg9nDnDeyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749923942; c=relaxed/simple;
	bh=/iP0hbdHdpufEEP2MdnSxNgvPbyqNsCHGlznFr6ODw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dnjdObk6VimAGvE0mu6l8G3HeuaTt/ieugwGya53vtJ9Ybgj8T7eWmey0izzfa6NwI36JDaHdr2MQOh9ImdG7vzZVlWAv5LaotA3U7AVzuHIoWyjl39uEfwBQu5X+ddJ72AYr8wfG4E8qGmlnwEhedZJ4okTOKE1Yz/0WGvkCdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KRlCCNFP; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KRlCCNFP"
Date: Sat, 14 Jun 2025 13:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749923937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RwnMgHWh2yxYuot42Ei4j7qupSkFCPl25c1E4Kj8lS0=;
	b=KRlCCNFPEjD/waEb8zAlL/wJL1cEL3/QaOQNdpc8NsrXdrm/fxeijH2Y4nEnb61+x6vZFT
	NDwkZcXX5bllth+ImyLQJd4979B2Ym1tBAz0G+lnjbEsWpqqo67myNYs2cAIzxRQimfgNu
	YSOiA7Q8t0Ra3DpkRhXjFhf04KA20/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix pool->alloc NULL pointer dereference
Message-ID: <sihjc7q7hylvplgghtcv5bzxpm5ikygm5y5csnhg24uisxwcze@tclvjhdpksmv>
References: <20250614135505.406931-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250614135505.406931-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 14, 2025 at 09:55:05PM +0800, Alan Huang wrote:
> btree_interior_update_pool has not been initialized before the
> filesystem becomes read-write, thus mempool_alloc in bch2_btree_update_start
> will trigger pool->alloc NULL pointer dereference in mempool_alloc_noprof
> 
> Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/chardev.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/chardev.c b/fs/bcachefs/chardev.c
> index fde3c2380e28..ec8d0719a543 100644
> --- a/fs/bcachefs/chardev.c
> +++ b/fs/bcachefs/chardev.c
> @@ -378,6 +378,9 @@ static long bch2_ioctl_data(struct bch_fs *c,
>  	struct bch_data_ctx *ctx;
>  	int ret;
>  
> +	if (!test_bit(BCH_FS_rw, &c->flags))
> +		return -EINVAL;
> +

this isn't the right fix - we need to do a tryget and take a ref on
c->writes

>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -- 
> 2.48.1
> 
