Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE66ECC
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 00:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729989042; cv=none; b=C6dGEjhMu4YGl11MDUgql67aBOkLa1sZcf0cQ0c19WxME2kWk6l0XFnQQmTVjHd4cPa4JodX8nIQt3urlt17IylNaFCPrnTQCN7KHpRybTDTZqou2vUs9J352dt/SysAJueFLv87bqZSvnos5XlXh9JPgiWQjdNHC8w/hRgbeM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729989042; c=relaxed/simple;
	bh=cFuIVbQy2B24Jp/ykmabzeKZiZBEkNzbXU/PvCrvMUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C1OVxsQ+HmYNDOU8KalDSe7DddzesUhIgWSNb4V8Tm22qS6zI0K+WZLpF4x5igrx1pQz6qJsRf8efTvFujXg4s7wtk2HrrL5U1XU0kfkllXvheFAtZ6o8JGkDzkje/b8XCRqMcwokp5rCUfmeADSe1QdHVoMpm0v4Kw1vWcLQn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oVXf50TQ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oVXf50TQ"
Date: Sat, 26 Oct 2024 20:30:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729989035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oMtTkbAQEQRyJV9OAy1+Os+nlL7XX3CSHBY5FldPT/E=;
	b=oVXf50TQsnDjAMApLzvVZsfu6a+WUgiThFgfrrLBnUjkuOLPoNuJHDU75iDvTj8CGlvl2o
	OFhyJH/lcOn98cvLSIvZPuzcllXLbLZKbF2ca67eo/Tl5O2DhgeHwr3umAK2WLPT/TlSAh
	u1AB/42zt7yxkYyiIwGkfROte1Pz30A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Subject: Re: [RESEND PATCH] bcachefs: Annotate struct bucket_gens with
 __counted_by()
Message-ID: <ctariwoo6do3ergs4p7smzjbil7mwq744spzyzcphu2apwnkjn@hndqzlxejzvz>
References: <20241026154704.159305-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241026154704.159305-2-thorsten.blum@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Sat, Oct 26, 2024 at 05:47:04PM +0200, Thorsten Blum wrote:
> Add the __counted_by compiler attribute to the flexible array member b
> to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Use struct_size() to calculate the number of bytes to be allocated.
> 
> Update bucket_gens->nbuckets and bucket_gens->nbuckets_minus_first when
> resizing.
> 
> Compile-tested only.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

I can take this patch without it being tested, but please have a look at
ktest:
https://evilpiepirate.org/git/ktest.git/

that's where all the bcachefs tests live, and it's a nice testing and
debugging tool. The CI runs the same tests, and I can give you an
account there as well.

> ---
>  fs/bcachefs/buckets.c       | 13 ++++++++-----
>  fs/bcachefs/buckets_types.h |  2 +-
>  2 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/bcachefs/buckets.c b/fs/bcachefs/buckets.c
> index ec7d9a59bea9..8bd17667e243 100644
> --- a/fs/bcachefs/buckets.c
> +++ b/fs/bcachefs/buckets.c
> @@ -1266,8 +1266,9 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
>  
>  	BUG_ON(resize && ca->buckets_nouse);
>  
> -	if (!(bucket_gens	= kvmalloc(sizeof(struct bucket_gens) + nbuckets,
> -					   GFP_KERNEL|__GFP_ZERO))) {
> +	bucket_gens = kvmalloc(struct_size(bucket_gens, b, nbuckets),
> +			       GFP_KERNEL|__GFP_ZERO);
> +	if (!bucket_gens) {
>  		ret = -BCH_ERR_ENOMEM_bucket_gens;
>  		goto err;
>  	}
> @@ -1285,11 +1286,13 @@ int bch2_dev_buckets_resize(struct bch_fs *c, struct bch_dev *ca, u64 nbuckets)
>  	old_bucket_gens = rcu_dereference_protected(ca->bucket_gens, 1);
>  
>  	if (resize) {
> -		size_t n = min(bucket_gens->nbuckets, old_bucket_gens->nbuckets);
> -
> +		bucket_gens->nbuckets = min(bucket_gens->nbuckets,
> +					    old_bucket_gens->nbuckets);
> +		bucket_gens->nbuckets_minus_first =
> +			bucket_gens->nbuckets - bucket_gens->first_bucket;
>  		memcpy(bucket_gens->b,
>  		       old_bucket_gens->b,
> -		       n);
> +		       bucket_gens->nbuckets);
>  	}
>  
>  	rcu_assign_pointer(ca->bucket_gens, bucket_gens);
> diff --git a/fs/bcachefs/buckets_types.h b/fs/bcachefs/buckets_types.h
> index 28bd09a253c8..7174047b8e92 100644
> --- a/fs/bcachefs/buckets_types.h
> +++ b/fs/bcachefs/buckets_types.h
> @@ -24,7 +24,7 @@ struct bucket_gens {
>  	u16			first_bucket;
>  	size_t			nbuckets;
>  	size_t			nbuckets_minus_first;
> -	u8			b[];
> +	u8			b[] __counted_by(nbuckets);
>  };
>  
>  struct bch_dev_usage {
> -- 
> 2.47.0
> 
