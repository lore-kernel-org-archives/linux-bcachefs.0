Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C649212FB4
	for <linux-bcachefs@vger.kernel.org>; Wed, 26 Feb 2025 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740581578; cv=none; b=qJm1EK+3aokhcjpIiU6IPsM0aNsZQRBiGcmuIGZZ21i/4D84aDndzc0/jC7w74+CGhXiEeMbro8gsviQO5MinXMXragoB2TK3h2TvO2o6QXI4Ci6hwQHgiJk1VbRMKwpfvlO7UA+zhL8cZI5wwN9dNys0oj1O3BYqHgr1QPtiuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740581578; c=relaxed/simple;
	bh=MWeHIuB+tea237or3Rgfwv3ykOtnNx30tRQAkIryaPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HcwiZ8LBVs2yMlJ92TpMSluIzQ8tFIShHin+/KNWww1XtLwPn5p+vcmLp3YcLIq+zRsEgynXSNkYPgpiHMZu0NO0p7tUNPJJjcpxKkG6b8Ypca74UueZstxtTrpRqq7S/rEh6+7AMOPahgczEakd2ZpwVGEb4Fmow254C1B90Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ilYOLeFD; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ilYOLeFD"
Date: Wed, 26 Feb 2025 09:52:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740581573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dNKMM3Ib1F6XBir46Uv8Ng6WWtnVhl16TPZZ8VPYEMo=;
	b=ilYOLeFDYPx5blSjArgNf/lwmP1HlYrsvn7c5ph27WUERG19+jf/QxKBayQxzn/N5SQ6FF
	7r/zWclU/P3bW5lEyBjPhpaz15jRS8LlOJVh+z/gY5eJgPk6Fe20wsxc3vMOhf1IMmcUJK
	Qs9e2FzLN+ANoY+wK6a2/Pgttx7CBgc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, 
	syzbot+fe63f377148a6371a9db@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] bcachefs: Fix deadlock
Message-ID: <aqwol7jt2ipwejafbnmbnxjg4u5me5opoxffva6txn53jjaqxp@b6vvricdhhuv>
References: <20250226093323.1243266-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226093323.1243266-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 26, 2025 at 05:33:22PM +0800, Alan Huang wrote:
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

thanks! applied

> ---
>  fs/bcachefs/btree_cache.c     | 9 +++++----
>  fs/bcachefs/btree_key_cache.c | 2 +-
>  fs/bcachefs/btree_locking.c   | 5 +++--
>  fs/bcachefs/btree_locking.h   | 2 +-
>  fs/bcachefs/six.c             | 5 +++--
>  fs/bcachefs/six.h             | 7 ++++---
>  6 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
> index ca755e8d1a37..1ec1f90e0eb3 100644
> --- a/fs/bcachefs/btree_cache.c
> +++ b/fs/bcachefs/btree_cache.c
> @@ -203,7 +203,7 @@ struct btree *__bch2_btree_node_mem_alloc(struct bch_fs *c)
>  		return NULL;
>  	}
>  
> -	bch2_btree_lock_init(&b->c, 0);
> +	bch2_btree_lock_init(&b->c, 0, GFP_KERNEL);
>  
>  	__bch2_btree_node_to_freelist(bc, b);
>  	return b;
> @@ -795,17 +795,18 @@ struct btree *bch2_btree_node_mem_alloc(struct btree_trans *trans, bool pcpu_rea
>  		}
>  
>  	b = __btree_node_mem_alloc(c, GFP_NOWAIT|__GFP_NOWARN);
> -	if (!b) {
> +	if (b) {
> +		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0, GFP_NOWAIT);
> +	} else {
>  		mutex_unlock(&bc->lock);
>  		bch2_trans_unlock(trans);
>  		b = __btree_node_mem_alloc(c, GFP_KERNEL);
>  		if (!b)
>  			goto err;
> +		bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0, GFP_KERNEL);
>  		mutex_lock(&bc->lock);
>  	}
>  
> -	bch2_btree_lock_init(&b->c, pcpu_read_locks ? SIX_LOCK_INIT_PCPU : 0);
> -
>  	BUG_ON(!six_trylock_intent(&b->c.lock));
>  	BUG_ON(!six_trylock_write(&b->c.lock));
>  
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 1821f40c161a..edce59433375 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -156,7 +156,7 @@ bkey_cached_alloc(struct btree_trans *trans, struct btree_path *path, unsigned k
>  	}
>  
>  	if (ck) {
> -		bch2_btree_lock_init(&ck->c, pcpu_readers ? SIX_LOCK_INIT_PCPU : 0);
> +		bch2_btree_lock_init(&ck->c, pcpu_readers ? SIX_LOCK_INIT_PCPU : 0, GFP_KERNEL);
>  		ck->c.cached = true;
>  		goto lock;
>  	}
> diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
> index 10b805a60f52..caef65adeae4 100644
> --- a/fs/bcachefs/btree_locking.c
> +++ b/fs/bcachefs/btree_locking.c
> @@ -7,9 +7,10 @@
>  static struct lock_class_key bch2_btree_node_lock_key;
>  
>  void bch2_btree_lock_init(struct btree_bkey_cached_common *b,
> -			  enum six_lock_init_flags flags)
> +			  enum six_lock_init_flags flags,
> +			  gfp_t gfp)
>  {
> -	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags);
> +	__six_lock_init(&b->lock, "b->c.lock", &bch2_btree_node_lock_key, flags, gfp);
>  	lockdep_set_notrack_class(&b->lock);
>  }
>  
> diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
> index b54ef48eb8cc..b33ab7af8440 100644
> --- a/fs/bcachefs/btree_locking.h
> +++ b/fs/bcachefs/btree_locking.h
> @@ -13,7 +13,7 @@
>  #include "btree_iter.h"
>  #include "six.h"
>  
> -void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags);
> +void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags, gfp_t gfp);
>  
>  void bch2_trans_unlock_noassert(struct btree_trans *);
>  void bch2_trans_unlock_write(struct btree_trans *);
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 7e7c66a1e1a6..7c403427fbdb 100644
> --- a/fs/bcachefs/six.c
> +++ b/fs/bcachefs/six.c
> @@ -850,7 +850,8 @@ void six_lock_exit(struct six_lock *lock)
>  EXPORT_SYMBOL_GPL(six_lock_exit);
>  
>  void __six_lock_init(struct six_lock *lock, const char *name,
> -		     struct lock_class_key *key, enum six_lock_init_flags flags)
> +		     struct lock_class_key *key, enum six_lock_init_flags flags,
> +		     gfp_t gfp)
>  {
>  	atomic_set(&lock->state, 0);
>  	raw_spin_lock_init(&lock->wait_lock);
> @@ -873,7 +874,7 @@ void __six_lock_init(struct six_lock *lock, const char *name,
>  		 * failure if they wish by checking lock->readers, but generally
>  		 * will not want to treat it as an error.
>  		 */
> -		lock->readers = alloc_percpu(unsigned);
> +		lock->readers = alloc_percpu_gfp(unsigned, gfp);
>  	}
>  #endif
>  }
> diff --git a/fs/bcachefs/six.h b/fs/bcachefs/six.h
> index c142e06b7a3a..59b851cf8bac 100644
> --- a/fs/bcachefs/six.h
> +++ b/fs/bcachefs/six.h
> @@ -164,18 +164,19 @@ enum six_lock_init_flags {
>  };
>  
>  void __six_lock_init(struct six_lock *lock, const char *name,
> -		     struct lock_class_key *key, enum six_lock_init_flags flags);
> +		     struct lock_class_key *key, enum six_lock_init_flags flags,
> +		     gfp_t gfp);
>  
>  /**
>   * six_lock_init - initialize a six lock
>   * @lock:	lock to initialize
>   * @flags:	optional flags, i.e. SIX_LOCK_INIT_PCPU
>   */
> -#define six_lock_init(lock, flags)					\
> +#define six_lock_init(lock, flags, gfp)					\
>  do {									\
>  	static struct lock_class_key __key;				\
>  									\
> -	__six_lock_init((lock), #lock, &__key, flags);			\
> +	__six_lock_init((lock), #lock, &__key, flags, gfp);			\
>  } while (0)
>  
>  /**
> -- 
> 2.48.1
> 
