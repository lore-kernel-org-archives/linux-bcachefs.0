Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D881A2846
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Feb 2025 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740504911; cv=none; b=cVlMcLY/0D9jGQG0NfmCfQ6UMsb//n80ktO2HsBU2qxFbSR4xWQ2LLUENeYapl6Mig99K1+jRv81Na8vWaJcDDcTzjQob+95UqQmQHNqfjYwMJOKsiSvn+VZA/kXuWKwzoxpNN9pX6Wt59Cn21RqOtL+1zNtSVaGVymgk1A5Ees=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740504911; c=relaxed/simple;
	bh=oh1DMf5SkFpsfebYS9StGPdKKD/xdT5nDUlS+Hgu9T8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pBHOLlxbPiJ9zsvEu+Ld4C8rORbjzfYzMJfWrMt45DAvb/68UgQ9ucMNxUB9RuqjLtHsZs8BAyPNVJhv4fWVCrEqe6OxZ6O4iJsSNtxnaPcnxc+tAPNoFfo6eulwtN6DRX3kyawkZ5AkRvudBpJBPogvQp4uexjFXf2XhNrsLVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GbR4jlBe; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GbR4jlBe"
Date: Tue, 25 Feb 2025 12:34:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740504905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b33rIP7mQZimf4flRmyUY2DmIT2Wy44AmGqjSggBzNk=;
	b=GbR4jlBeLYd7hIsMZuP2yxg+GdFrxKuWY/UB4K0IEj4IZXwYVet3aQEd72eoLiDPHr3Vrk
	wRAoo7OKzWcV8PbO1j+XU3DWESUtJYk0jc8Iea2E4rWD/o9rZ7cHELK9l+WIvjmXVhgeVi
	lJFB4J3ojBYVCARyP7wUJRd3DfdT5Ek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix deadlock
Message-ID: <twyjpaqakvgmfei3gfpgt5ss2vpohxjgwytbn6jtctds54rrph@y3bvk7o45cdw>
References: <20250225100936.1222701-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225100936.1222701-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 25, 2025 at 06:09:35PM +0800, Alan Huang wrote:
> This fixes two deadlocks:
> 
> 1.pcpu_alloc_mutex involved one as pointed by syzbot[1]
> 2.recursion deadlock.
> 
> The root cause is that we hold the bc lock during alloc_percpu, fix it
> by following the pattern used by __btree_node_mem_alloc().
> 
> [1] https://lore.kernel.org/all/66f97d9a.050a0220.6bad9.001d.GAE@google.com/T/
> 
> Reported-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> Tested-by: syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
> 
> syzbot test: https://lore.kernel.org/all/66f97d9a.050a0220.6bad9.001d.GAE@google.com/T/#m92500622db70f4e4974576c390a51697e9e46314
> 
>  fs/bcachefs/btree_cache.c | 7 ++++---
>  fs/bcachefs/six.c         | 8 +++++++-
>  fs/bcachefs/six.h         | 1 +
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
> index ca755e8d1a37..87be42fc889c 100644
> --- a/fs/bcachefs/btree_cache.c
> +++ b/fs/bcachefs/btree_cache.c
> @@ -795,17 +795,18 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
>  		}
>  
>  	b = __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
> -	if (!b) {
> +	if (b) {
> +		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU|SIX_LOCK_INIT_NOWAIT : 0);
> +	} else {
>  		mutex_unlock(&bc->lock);
>  		bch2_trans_unlock(trans);
>  		b = __btree_node_mem_alloc(c, GFP_KERNEL);
>  		if (!b)
>  			goto err;
> +		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
>  		mutex_lock(&bc->lock);
>  	}
>  
> -	bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
> -
>  	BUG_ON(!six_trylock_intent(&b->c.lock));
>  	BUG_ON(!six_trylock_write(&b->c.lock));
>  
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 7e7c66a1e1a6..81c832061331 100644
> --- a/fs/bcachefs/six.c
> +++ b/fs/bcachefs/six.c
> @@ -865,6 +865,9 @@ void __six_lock_init(struct six_lock *lock, const char *name,
>  	 * userspace:
>  	 */
>  #ifdef __KERNEL__
> +	EBUG_ON(!(flags & SIX_LOCK_INIT_PCPU) &&
> +		(flags & SIX_LOCK_INIT_NOWAIT));
> +
>  	if (flags & SIX_LOCK_INIT_PCPU) {
>  		/*
>  		 * We don't return an error here on memory allocation failure
> @@ -873,7 +876,10 @@ void __six_lock_init(struct six_lock *lock, const char *name,
>  		 * failure if they wish by checking lock->readers, but generally
>  		 * will not want to treat it as an error.
>  		 */
> -		lock->readers = alloc_percpu(unsigned);
> +		if (flags & SIX_LOCK_INIT_NOWAIT)
> +			lock->readers = alloc_percpu_gfp(unsigned, GFP_NOWAIT);
> +		else
> +			lock->readers = alloc_percpu(unsigned);
>  	}
>  #endif
>  }
> diff --git a/fs/bcachefs/six.h b/fs/bcachefs/six.h
> index c142e06b7a3a..d188f699339f 100644
> --- a/fs/bcachefs/six.h
> +++ b/fs/bcachefs/six.h
> @@ -161,6 +161,7 @@ void six_lock_exit(struct six_lock *lock);
>  
>  enum six_lock_init_flags {
>  	SIX_LOCK_INIT_PCPU	= 1U << 0,
> +	SIX_LOCK_INIT_NOWAIT	= 1U << 1,

Don't do this, just plumb the gfp flags param through...

It makes it harder to see the data flow and make sure a param is
threaded correctly when you're converting the format
