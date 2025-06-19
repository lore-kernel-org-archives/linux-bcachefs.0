Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC721ADA2
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Jun 2025 20:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750365329; cv=none; b=a41XAUayzHj1tKJSJcAaiZLrXfgI1Rvq+/XWg/GnhXMEkSBDto0CpmnOokX1fGaETghwm/Aq/da1jo1Dz6QB5HP7I9QiAJaIc3RiW1k3YrxfCiirARJWiuRnNtXbLSrmd3Nl1LARO8/XiJOTW8OlPoktEcUBf8j2dlLd9Ypp5SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750365329; c=relaxed/simple;
	bh=2ovME8dikyt9L6WLDkWn0i/tpfMkH649gWb7wUNE4wU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKmHODft33eIGI1ZvlCzghTLP/aQ2OVHR7s+OUWAPn4YPl5OALpyU+watrjwR7grYcl2VL1KkrvbQlPgOYnStmomA8cG3O/cky3o20Cf+KuM6KeOSB6W0mPC4iuuGwWtWrxhbupo3vGlVwkumq9SWPHTLLdzg/wTP7L/hUUO/+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O0DL7ZjY; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O0DL7ZjY"
Date: Thu, 19 Jun 2025 16:35:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750365321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SM8LLgyzPk4hinXh2z2evUlPMi9oVTzNqhM+LKMY3B8=;
	b=O0DL7ZjYk62jJIQsSiAyoK7C8eUqqE874qlanqo1w9yfeufwHwVRMk/OPrid3ghq6iRgAc
	wnv6ptDLZAKNQHEo8XTKg/CthOTsicwbeRLzuO0f7p326GCd46I8A0qD42/jIIuGImesSu
	xu9UHhWq0Cy4MFXaOaWBjbVcA4TXloE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Refactor trans->mem allocation
Message-ID: <c37jfoo6eldcxjhe5uyyxwtwb4koegnw5euetnlrs5nkxkyxbz@kiehaju5g7ek>
References: <20250619195826.983765-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619195826.983765-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 03:58:26AM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/btree_iter.c | 65 ++++++++++++++++++++--------------------
>  fs/bcachefs/btree_iter.h | 14 +++++++++
>  2 files changed, 46 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 352f9cd2634f..0168c4023c74 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -3238,32 +3238,30 @@ void *__bch2_trans_kmalloc(struct btree_trans *trans, size_t size, unsigned long
>  	}
>  
>  	EBUG_ON(trans->mem);
> +	EBUG_ON(trans->mem_bytes);
> +	EBUG_ON(trans->mem_top);

???

> +	EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);

This can't be a BUG_ON(), it's not something we can prove can't happen
with static analysis. It needs to be a warning (with debug info! like
the previous warning provided!)

> +	
> +	bool lock_dropped = false;
> +	new_mem = allocate_dropping_locks_norelock(trans, lock_dropped, kmalloc(new_bytes, _gfp));
> +	if (!new_mem) {
> +		new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
> +		new_bytes = BTREE_TRANS_MEM_MAX;
> +		trans->used_mempool = true;
> +	}
>  
> -	new_mem = kmalloc(new_bytes, GFP_NOWAIT|__GFP_NOWARN);
> -	if (unlikely(!new_mem)) {
> -		bch2_trans_unlock(trans);
> -
> -		new_mem = kmalloc(new_bytes, GFP_KERNEL);
> -		if (!new_mem && new_bytes <= BTREE_TRANS_MEM_MAX) {
> -			new_mem = mempool_alloc(&c->btree_trans_mem_pool, GFP_KERNEL);
> -			new_bytes = BTREE_TRANS_MEM_MAX;
> -			trans->used_mempool = true;
> -		}
> -
> -		EBUG_ON(!new_mem);
> +	EBUG_ON(!new_mem);
>  
> -		trans->mem = new_mem;
> -		trans->mem_bytes = new_bytes;
> +	trans->mem = new_mem;
> +	trans->mem_bytes = new_bytes;
>  
> +	if (unlikely(lock_dropped)) {
>  		ret = bch2_trans_relock(trans);
>  		if (ret)
>  			return ERR_PTR(ret);
>  	}
>  
> -	trans->mem = new_mem;
> -	trans->mem_bytes = new_bytes;
> -
> -	p = trans->mem + trans->mem_top;
> +	p = trans->mem;
>  	trans->mem_top += size;
>  	memset(p, 0, size);
>  	return p;
> @@ -3324,22 +3322,23 @@ u32 bch2_trans_begin(struct btree_trans *trans)
>  	trans->mem_top			= 0;
>  
>  	if (trans->restarted == BCH_ERR_transaction_restart_mem_realloced) {
> -		EBUG_ON(!trans->mem || !trans->mem_bytes);
>  		unsigned new_bytes = trans->realloc_bytes_required;
> -		void *new_mem = krealloc(trans->mem, new_bytes, GFP_NOWAIT|__GFP_NOWARN);
> -		if (unlikely(!new_mem)) {
> -			bch2_trans_unlock(trans);
> -			new_mem = krealloc(trans->mem, new_bytes, GFP_KERNEL);
> -
> -			EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
> -
> -			if (!new_mem) {
> -				new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
> -				new_bytes = BTREE_TRANS_MEM_MAX;
> -				trans->used_mempool = true;
> -				kfree(trans->mem);
> -			}
> -                }
> +		EBUG_ON(new_bytes > BTREE_TRANS_MEM_MAX);
> +		EBUG_ON(!trans->mem);
> +		EBUG_ON(!trans->mem_bytes);

Not sure what the purpose of these assertions even is

> +
> +		bool lock_dropped = false;
> +		void *new_mem = allocate_dropping_locks_norelock(trans, lock_dropped,
> +					krealloc(trans->mem, new_bytes, _gfp));
> +		if (!new_mem) {
> +			new_mem = mempool_alloc(&trans->c->btree_trans_mem_pool, GFP_KERNEL);
> +			new_bytes = BTREE_TRANS_MEM_MAX;
> +			trans->used_mempool = true;
> +			kfree(trans->mem);
> +		}
> +
> +		EBUG_ON(!new_mem);
> +
>  		trans->mem = new_mem;
>  		trans->mem_bytes = new_bytes;
>  	}
> diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
> index 09dd3e52622e..cc2c6bb6b6a8 100644
> --- a/fs/bcachefs/btree_iter.h
> +++ b/fs/bcachefs/btree_iter.h
> @@ -963,6 +963,20 @@ struct bkey_s_c bch2_btree_iter_peek_and_restart_outlined(struct btree_trans *,
>  	_p;								\
>  })
>  
> +#define allocate_dropping_locks_norelock(_trans, _lock_dropped, _do)	\
> +({									\
> +	gfp_t _gfp = GFP_NOWAIT|__GFP_NOWARN;				\
> +	typeof(_do) _p = _do;						\
> +	_lock_dropped = false;						\
> +	if (unlikely(!_p)) {						\
> +		bch2_trans_unlock(_trans);				\
> +		_lock_dropped = true;					\
> +		_gfp = GFP_KERNEL;					\
> +		_p = _do;						\
> +	}								\
> +	_p;								\
> +})

This helper is fine

> +
>  struct btree_trans *__bch2_trans_get(struct bch_fs *, unsigned);
>  void bch2_trans_put(struct btree_trans *);
>  
> -- 
> 2.48.1
> 
