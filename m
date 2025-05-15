Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75C71D79A6
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 May 2025 17:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747328766; cv=none; b=DvdfNRwfenSKiXKEGWXQJDpJinJie1opTf0RU6mvw3ywcNIr6Eft35Wu6sjDnfWY0J620Fk+82A24mNz7lgkEY2hEa1bLq74zXBTTPO/ZSJ1Ggs/+hNYIt+uK0MZ2xfFUGpyWsasG0hZttHSRcRBAtE5IQX2OxtuaWgfgqYe2GQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747328766; c=relaxed/simple;
	bh=ZnphpeyzmL5FF8G8AjQtwp1eD+tTc2zqrM9xgNbzPxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sj+sXfRv2Yy8iwWduWPmzbtII8YQ/n4Is10sQLwbbL3Pdc1/4dmTvbyYjt7oXggIUd2ofQYqRFYqRjzkzw9/lIhu0q6Iq12lgmp1DOMbyoZQ0yJNvYWZ8k08ZP8b21+kRG+1vGR5e+rP5APFkqSy8oBg+9DGPA56u5hRH26Ofng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iKlO+upA; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iKlO+upA"
Date: Thu, 15 May 2025 13:05:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747328759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5chk7E4x3h1R+A5Xl3j2s/JOuBnrO0n5tz6zd+9lyOg=;
	b=iKlO+upAKJh78b3H8aTULIJmmMOuP9z7qA55iDK4Vo1ZXg5ww2/Mp+K/glsiNN7wnM+WCq
	Nom/wEi/tNGHA0inZ5SeVBSKh34sZ4coT4vSqY7NcNjZALVzzBqcyUGHpb7z4+sn74uzyi
	ZSy2l+cAtLG2eH0yNAHgCBGFwjhqItY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Kill BTREE_TRIGGER_bucket_invalidate
Message-ID: <dpv2m7opow2uo2flilsrezjupnkkve6nnszizn2amqqag5x5sp@vyamfk7nv7tz>
References: <20250515142950.375479-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250515142950.375479-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, May 15, 2025 at 10:29:50PM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/alloc_background.c | 9 ---------
>  fs/bcachefs/btree_types.h      | 6 +-----
>  2 files changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/fs/bcachefs/alloc_background.c b/fs/bcachefs/alloc_background.c
> index 81e2ae4bb400..51dfd2f24c20 100644
> --- a/fs/bcachefs/alloc_background.c
> +++ b/fs/bcachefs/alloc_background.c
> @@ -914,15 +914,6 @@ int bch2_trigger_alloc(struct btree_trans *trans,
>  				goto err;
>  		}
>  
> -		if ((flags & BTREE_TRIGGER_bucket_invalidate) &&
> -		    old_a->cached_sectors) {
> -			ret = bch2_mod_dev_cached_sectors(trans, ca->dev_idx,
> -					 -((s64) old_a->cached_sectors),
> -					 flags & BTREE_TRIGGER_gc);
> -			if (ret)
> -				goto err;
> -		}
> -
>  		ret = bch2_alloc_key_to_dev_counters(trans, ca, old_a, new_a, flags);
>  		if (ret)
>  			goto err;
> diff --git a/fs/bcachefs/btree_types.h b/fs/bcachefs/btree_types.h
> index 3acccca3b3a3..e5a965db68b4 100644
> --- a/fs/bcachefs/btree_types.h
> +++ b/fs/bcachefs/btree_types.h
> @@ -258,9 +258,6 @@ struct btree_node_iter {
>   *
>   * BTREE_TRIGGER_insert - @new is entering the btree
>   * BTREE_TRIGGER_overwrite - @old is leaving the btree
> - *
> - * BTREE_TRIGGER_bucket_invalidate - signal from bucket invalidate path to alloc
> - * trigger
>   */
>  #define BTREE_TRIGGER_FLAGS()			\
>  	x(norun)				\
> @@ -270,8 +267,7 @@ struct btree_node_iter {
>  	x(gc)					\
>  	x(insert)				\
>  	x(overwrite)				\
> -	x(is_root)				\
> -	x(bucket_invalidate)
> +	x(is_root)
>  
>  enum {
>  #define x(n) BTREE_ITER_FLAG_BIT_##n,
> -- 
> 2.48.1
> 
