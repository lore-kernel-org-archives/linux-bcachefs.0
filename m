Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8E433062
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Dec 2024 14:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735483216; cv=none; b=NrFdzF8z0HLcI863ymugEltNaiR7SJkLSV+4RJjNnRR8al9Aqj44g3yzWmFpG630B5gC7XVYkgO2oGf69QiLI9Hf6KSGSvq5rOCfZMvZ2BUR+LWvdEsX2p+ZuIybBC7hZLBLTYiRNQr3BknSBSrncDsLfW8JcXqJZIYVEWrfDcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735483216; c=relaxed/simple;
	bh=ApGqcQ1u0B2E5tGXJFYWAjW0ONMDkoBXiTQJE2YgbM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uiPyZYrQZcgjlfY4K6dqZBYtmMHrLN3ocmdIpXfWpZTVaunJEpJNMsmcKXPs6hPA+78epCq+izZuXc8jW4PvAORjh3dwxu2TdsEpiqnQeMVTYMT901QY6PgLpHmkKyttbpYFTb1wn1fFLbkSuq2ZtNduO11NLdtuaFNl+K4aoJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VP1wkn1t; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VP1wkn1t"
Date: Sun, 29 Dec 2024 09:40:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1735483206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k3ZFNzIdi9FobEE6aFTZCLqtFWayM3ZCb+1tE1JTO3k=;
	b=VP1wkn1t4h+WrVp8/RtDtelaUGZMbHi6MHPu3iTxFJRJHSWPTwIP248PIkyHqGFbZzioGe
	zNrnI9jb2aoE65Pz1rFTB3Gd56rguJZH8hBdl+Wewn6JeplOpyljGZ7UoRaOtL7Yt4wdrV
	GS4t2RGftg1YAaaSPUzfrhzmXOrydlA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Integral <integral@archlinuxcn.org>
Cc: kent.overstreet@gmail.com, lihongbo22@huawei.com, mmpgouride@gmail.com, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] Fix build failure on liburcu v0.15.0
Message-ID: <mrmazh77tocyz3fsq3pczzi4zhhsdgq3iwbqqve5canay6st7w@orijhmslke75>
References: <20241229040607.159965-1-integral@archlinuxcn.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241229040607.159965-1-integral@archlinuxcn.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Dec 29, 2024 at 12:06:07PM +0800, Integral wrote:
> After upgrading liburcu to v0.15.0, bcachefs-tools failed to build. This patch
> fixes build errors on liburcu v0.15.0.
> 
> Signed-off-by: Integral <integral@archlinuxcn.org>

Thanks, applied

> ---
>  include/linux/atomic.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> index f7b2619a..128f21f6 100644
> --- a/include/linux/atomic.h
> +++ b/include/linux/atomic.h
> @@ -188,12 +188,12 @@ static inline i_type a_type##_read_acquire(const a_type##_t *v)		\
>  									\
>  static inline void a_type##_set(a_type##_t *v, i_type i)		\
>  {									\
> -	return __ATOMIC_SET(&v->counter, i);				\
> +	__ATOMIC_SET(&v->counter, i);					\
>  }									\
>  									\
>  static inline void a_type##_set_release(a_type##_t *v, i_type i)	\
>  {									\
> -	return __ATOMIC_SET_RELEASE(&v->counter, i);			\
> +	__ATOMIC_SET_RELEASE(&v->counter, i);				\
>  }									\
>  									\
>  static inline i_type a_type##_add_return(i_type i, a_type##_t *v)	\
> --
> 2.47.1
> 
