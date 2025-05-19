Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5F927586A
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 12:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747656994; cv=none; b=WAeS38EIeUyh3H/C4j61jR1du6k9udUtk34a06alNUMpJ3ECRR7gquGRxPbwmuNmVf0V0Zua3AE2pKUiPJGAr33UFJOdnHHj4nx7FQWfROZ57cyMX9W3rcypVWlpzsK1CI0Cz45wK3f2naW+7SvkyWUeW7EZRluVIUiYNYH0qQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747656994; c=relaxed/simple;
	bh=+g+W9fV+kx0hL2RG7W5oBTDtVu9JCSAZrkR3FA45dG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xv40UiwT0/oxuIAyC4le8gSWMlr25PM0uOkhYEKS7Q6RdCV2+jL+Twrsk6e4wO7/Qx9XVCgBe5riykOec2BzKFQPhoR4FoOv67CVTrp4zbNxqK217st8hzsYEo/goG4B2xM6OR6QXHFb54lMLtr5IZtpMIDFerhpbGdq9BTG2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=c6qhpjii; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="c6qhpjii"
Date: Mon, 19 May 2025 08:16:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747656989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v0HRSl9gWyit9iSTmjNUi3ApGJAzXVxmBd8VVoP5rTE=;
	b=c6qhpjii5n9KbEjwgyC+Y5RoRb8SrK+srMaDtZ6Ya7aB+YgbDv2K/LSr3loMwOyr8c5Lhc
	3nScHsJDptLp/PTc0b/bIO6sTJsgwZPnMcRaTnXufLIT3K/ijUwkw9AKwteBE2JrqfO9kJ
	gDBPpPxDnvSm5uEnMxJSX1yeUAOPSaE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Remove duplicate call to bch2_trans_begin()
Message-ID: <w4kw7l2lgrze7qtjf5m36keme5uzygbjpilmoci7k3aoh7tgf2@f5jwmzkkqecj>
References: <20250519115104.449188-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519115104.449188-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 19, 2025 at 07:51:04PM +0800, Alan Huang wrote:
> There is one in for_each_btree_key_max().
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/movinggc.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/bcachefs/movinggc.c b/fs/bcachefs/movinggc.c
> index 7cb0b3d347b4..e7a2a13554d7 100644
> --- a/fs/bcachefs/movinggc.c
> +++ b/fs/bcachefs/movinggc.c
> @@ -154,8 +154,6 @@ static int bch2_copygc_get_buckets(struct moving_context *ctxt,
>  	if (bch2_fs_fatal_err_on(ret, c, "%s: from bch2_btree_write_buffer_tryflush()", bch2_err_str(ret)))
>  		return ret;
>  
> -	bch2_trans_begin(trans);
> -
>  	ret = for_each_btree_key_max(trans, iter, BTREE_ID_lru,
>  				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, 0, 0),
>  				  lru_pos(BCH_LRU_BUCKET_FRAGMENTATION, U64_MAX, LRU_TIME_MAX),
> -- 
> 2.48.1
> 
