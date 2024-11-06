Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECF1190468
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 03:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730864305; cv=none; b=h3/eIZQyHBzYHbS+yKhJ6xEOq/6SPrIhyLZ1YdYeX1Eex1f+ZqfQqlnRP93Qr49mRvLfDepQuIQpLCVUhkfLVE5h4H4ltOM2x8pHbacTm0nG6sgno8KRGrJNaiXxbxwDoycRYX43z8uuU7oreKky51lnD+ujwzDxiC8BPqetfvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730864305; c=relaxed/simple;
	bh=p3npJk3c05p/EFyOnZz3q417c+p13zXz1VeJEHRhTyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV/dyaQzz0EyVqrKlxjnmjQPTiLV5NOxDeEXz+ocqjEp/p0lfxaAKOaJj9iFVNs3CxGKwsUgSI80O7u1SiF+cPE1PYzsntghaGJVLLebNWUCPlejtJi29AVfagbEsbctnfEomqAPbxJhPBEiuQf8Ao87bnvBq8yplU6NK0zPBCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZZhO8DIl; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZZhO8DIl"
Date: Tue, 5 Nov 2024 22:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730864299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yKh8gXqYH6+UY9V74ED4SH8z5zchZcYD9d1ZNH7NW5I=;
	b=ZZhO8DIlImCI7ryT7h17K4M2+9JuBdVIn5D6DNVV6DS5yBfB9IEfNPLJ0sANPeYwqIrFP6
	udkNdKojkOIJxFTw1UIt00Tc5Cd67ZR46s9MG9nYpKi/P5Gs/+g0g4SHUfF5A5xCnloVek
	H3obJfTdGB6h+6siZOPT/Xs3FTay1mo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: fix uninitialized percpu variable
Message-ID: <sumw2e7tjowymn2tj2dlhdh6ejkgos75zbco4kj7gzgykb4inq@vxbhflrqa5ev>
References: <20241106020541.2421993-1-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106020541.2421993-1-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 06, 2024 at 10:05:41AM +0800, Hongbo Li wrote:
> When alloc percpu counters in bch2_fs_counters_init, we do not
> initialize it. When nr < BCH_COUNTER_NR, the variables after
> counters[nr - 1] are not initialized. Considering __GFP_ZERO flags
> aren't guaranteed to be all zeros on different archs for percpu
> allocations, so here initialize this variable explicitly.

???

mm/percpu.c:1898

> 
> Fixes: 104c69745fdf ("bcachefs: Add persistent counters")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/sb-counters.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/sb-counters.c b/fs/bcachefs/sb-counters.c
> index 6992e7469112..92cb3745d1c2 100644
> --- a/fs/bcachefs/sb-counters.c
> +++ b/fs/bcachefs/sb-counters.c
> @@ -50,7 +50,7 @@ int bch2_sb_counters_to_cpu(struct bch_fs *c)
>  
>  	for (i = 0; i < min_t(unsigned int, nr, BCH_COUNTER_NR); i++) {
>  		val = le64_to_cpu(ctrs->d[i]);
> -		percpu_u64_set(&c->counters[i], val);
> +		this_cpu_write(c->counters[i], val);
>  		c->counters_on_mount[i] = val;
>  	}
>  	return 0;
> @@ -86,10 +86,15 @@ void bch2_fs_counters_exit(struct bch_fs *c)
>  
>  int bch2_fs_counters_init(struct bch_fs *c)
>  {
> +	unsigned int i;
> +
>  	c->counters = __alloc_percpu(sizeof(u64) * BCH_COUNTER_NR, sizeof(u64));
>  	if (!c->counters)
>  		return -BCH_ERR_ENOMEM_fs_counters_init;
>  
> +	for (i = 0; i < BCH_COUNTER_NR; i++)
> +		percpu_u64_set(&c->counters[i], 0);
> +
>  	return bch2_sb_counters_to_cpu(c);
>  }
>  
> -- 
> 2.34.1
> 
