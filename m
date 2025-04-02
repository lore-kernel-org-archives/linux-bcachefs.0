Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3A533993
	for <linux-bcachefs@vger.kernel.org>; Wed,  2 Apr 2025 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603356; cv=none; b=uIXjGmYB5VbCQN0vpf1ToLLKZCt23wa3SMJ9KL2L8QiXwNa1q+3g4xjZaxkyDyW0jRbfsJRaWffbiYjzSbk8A2ybi5AwdSWx/f5anZU/0OsU356qclfmUlmExb61djo2jq7qRJZJi2tJT37kjm+g8+pHkLCq/inWAIkTbn8kM/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603356; c=relaxed/simple;
	bh=HmxXuuLvTGRW2v0lSm/MV17CTpYebj+3WV1Y2S95tAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJKkK+8N5H6gBQHZhTFmiC7e7KalJcUWNQ6/FvIuA+8aNS9QGPrV4bFs/1oK+sJYV6+j9CSnPzdN9oEDz+eLBva79ILFLrtAPL05urNignbsE6JK+rCZKAMSKzU3cyKyMOXeJ/Uht8Hn8UXJuNshtQcGYn3HUK1KAgEUnT4fLbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cJaMMfMJ; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cJaMMfMJ"
Date: Wed, 2 Apr 2025 10:15:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743603342;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CM4At2M6VUr7hqgzQbMZ99RPNNt354raBAzhLjuv9tY=;
	b=cJaMMfMJzHtPeZSRikn8f6yctUS9lY7DG5BJtz3NWsqYcgD7NrJlYzXUdVwLCn1MvdI4bt
	Oa6xIOTFBbcUJkoMDapN9DDPaxurXFHBNoMxSEkwWCn0a/xJl1Vqfz++jGYwQeEN+xzBuj
	/RxPxYdFUypswelsB0pxamJoN4mGtEc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Add error handling for zlib_deflateInit2()
Message-ID: <xjtejtaya3znotupznz4eywstkjvucxwyo2gf4b6phcwq6a2i5@pqicczp3ty5g>
References: <20250402134544.3550-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402134544.3550-1-vulab@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT

On Wed, Apr 02, 2025 at 09:45:44PM +0800, Wentao Liang wrote:
> In attempt_compress(), the return value of zlib_deflateInit2() needs to be
> checked. A proper implementation can be found in  pstore_compress().
> 
> Add an error check and return 0 immediately if the initialzation fails.
> 
> Fixes: 986e9842fb68 ("bcachefs: Compression levels")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Applied

> ---
>  fs/bcachefs/compress.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/bcachefs/compress.c b/fs/bcachefs/compress.c
> index f99ff1819597..5af37c40cef0 100644
> --- a/fs/bcachefs/compress.c
> +++ b/fs/bcachefs/compress.c
> @@ -365,13 +365,14 @@ static int attempt_compress(struct bch_fs *c,
>  		};
>  
>  		zlib_set_workspace(&strm, workspace);
> -		zlib_deflateInit2(&strm,
> +		if (zlib_deflateInit2(&strm,
>  				  compression.level
>  				  ? clamp_t(unsigned, compression.level,
>  					    Z_BEST_SPEED, Z_BEST_COMPRESSION)
>  				  : Z_DEFAULT_COMPRESSION,
>  				  Z_DEFLATED, -MAX_WBITS, DEF_MEM_LEVEL,
> -				  Z_DEFAULT_STRATEGY);
> +				  Z_DEFAULT_STRATEGY) != Z_OK)
> +			return 0;
>  
>  		if (zlib_deflate(&strm, Z_FINISH) != Z_STREAM_END)
>  			return 0;
> -- 
> 2.42.0.windows.2
> 
