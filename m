Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3934198823
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727653; cv=none; b=pryjI3FAKbKV+5hvmeAt+8qe4r1h+dm4lybAmOnjig+XAP6VhdLP41ISWjINpBCUKDr/aCeGZA1zU28mowv2OtsVmESGfv7zD4JxivGpWBlyCYr6QdzxbAItzFEpEoiudEVDvuEinOYRxoVXDcEe9ZsvUvo04jMtn1W4e71xnSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727653; c=relaxed/simple;
	bh=SD3jTY1SgjbfsvsJidwkTZ1qfv/0ng+CFt95wnhDNZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=idWDJIM0ihcN4LWcuryHPQTRR4RhWfIYEM3JaFptPmnjuTlG5US123rf9rxqvT+64lpsDCgtQjihJy7CedM+/SODhJ4yLCUhpUcvnBvvzbGR8/TkzcUPOZ8DAVB8DhIUCsMqdYWVOUrsWfUyzBXiksNWxb6xnEmX3WI+tOOR3Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=N4CLtgZY; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="N4CLtgZY"
Date: Tue, 15 Apr 2025 10:34:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727649;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZddXHy/TD8b+d1+XC4sRgPJy3nJiYmLvllVl5ZFXHhg=;
	b=N4CLtgZYiHDskyQPdTKR1tU6V9CRjq3l2QoJpPwfXNqzgnaZzP6DJfnbuR6jsTJYHcZhgV
	SfmjncUpPYeTOVjL2M/AntWkHqzqHm1ecfGmKqdMBCroagEVwN3HuYmm/RvrLT4j9wewNs
	HjciBLgN8TO4BI/jrIxCO8knBb9vImI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/4] bcachefs: mark_btree_node_locked_noreset ->
 mark_btree_node_locked_reset
Message-ID: <lvfufohffjiyabs6avgajstqnfi2va4u4hy3ct73yhcowq4nzo@okzc4pohf4eh>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-3-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415053307.81354-3-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 15, 2025 at 01:33:05PM +0800, Alan Huang wrote:
> The semantic is reset now, rename the function to reflect that.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

erm, are you sure?

mark_btree_node_locked() is the outer, more 'standard' interface, we
generally do the more specialized naming for the inner, more
specialized, 'are you sure this is the one you want' helper

> ---
>  fs/bcachefs/btree_key_cache.c       |  6 +++---
>  fs/bcachefs/btree_locking.c         |  6 +++---
>  fs/bcachefs/btree_locking.h         | 10 +++++-----
>  fs/bcachefs/btree_update_interior.c |  4 ++--
>  4 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 2b186584a291..c7ad01c1355c 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -240,7 +240,7 @@ static int btree_key_cache_create(struct btree_trans *trans,
>  	ck->flags		= 1U << BKEY_CACHED_ACCESSED;
>  
>  	if (unlikely(key_u64s > ck->u64s)) {
> -		mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
> +		mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
>  
>  		struct bkey_i *new_k = allocate_dropping_locks(trans, ret,
>  				kmalloc(key_u64s * sizeof(u64), _gfp));
> @@ -282,7 +282,7 @@ static int btree_key_cache_create(struct btree_trans *trans,
>  	return 0;
>  err:
>  	bkey_cached_free(bc, ck);
> -	mark_btree_node_locked_noreset(ck_path, 0, BTREE_NODE_UNLOCKED);
> +	mark_btree_node_locked_reset(ck_path, 0, BTREE_NODE_UNLOCKED);
>  
>  	return ret;
>  }
> @@ -500,7 +500,7 @@ static int btree_key_cache_flush_pos(struct btree_trans *trans,
>  			atomic_long_dec(&c->btree_key_cache.nr_dirty);
>  		}
>  
> -		mark_btree_node_locked_noreset(path, 0, BTREE_NODE_UNLOCKED);
> +		mark_btree_node_locked_reset(path, 0, BTREE_NODE_UNLOCKED);
>  		if (bkey_cached_evict(&c->btree_key_cache, ck)) {
>  			bkey_cached_free(&c->btree_key_cache, ck);
>  		} else {
> diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
> index f4f563944340..71dbac0bcd58 100644
> --- a/fs/bcachefs/btree_locking.c
> +++ b/fs/bcachefs/btree_locking.c
> @@ -435,7 +435,7 @@ int __bch2_btree_node_lock_write(struct btree_trans *trans, struct btree_path *p
>  	six_lock_readers_add(&b->lock, readers);
>  
>  	if (ret)
> -		mark_btree_node_locked_noreset(path, b->level, BTREE_NODE_INTENT_LOCKED);
> +		mark_btree_node_locked_reset(path, b->level, BTREE_NODE_INTENT_LOCKED);
>  
>  	return ret;
>  }
> @@ -564,7 +564,7 @@ bool bch2_btree_node_upgrade(struct btree_trans *trans,
>  	trace_and_count(trans->c, btree_path_upgrade_fail, trans, _RET_IP_, path, level);
>  	return false;
>  success:
> -	mark_btree_node_locked_noreset(path, level, BTREE_NODE_INTENT_LOCKED);
> +	mark_btree_node_locked_reset(path, level, BTREE_NODE_INTENT_LOCKED);
>  	return true;
>  }
>  
> @@ -693,7 +693,7 @@ void __bch2_btree_path_downgrade(struct btree_trans *trans,
>  		} else {
>  			if (btree_node_intent_locked(path, l)) {
>  				six_lock_downgrade(&path->l[l].b->c.lock);
> -				mark_btree_node_locked_noreset(path, l, BTREE_NODE_READ_LOCKED);
> +				mark_btree_node_locked_reset(path, l, BTREE_NODE_READ_LOCKED);
>  			}
>  			break;
>  		}
> diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
> index 66b27c0853a5..8978f7969bef 100644
> --- a/fs/bcachefs/btree_locking.h
> +++ b/fs/bcachefs/btree_locking.h
> @@ -63,7 +63,7 @@ static inline bool btree_node_locked(struct btree_path *path, unsigned level)
>  	return btree_node_locked_type(path, level) != BTREE_NODE_UNLOCKED;
>  }
>  
> -static inline void mark_btree_node_locked_noreset(struct btree_path *path,
> +static inline void mark_btree_node_locked_reset(struct btree_path *path,
>  						  unsigned level,
>  						  enum btree_node_locked_type type)
>  {
> @@ -80,7 +80,7 @@ static inline void mark_btree_node_locked(struct btree_trans *trans,
>  					  unsigned level,
>  					  enum btree_node_locked_type type)
>  {
> -	mark_btree_node_locked_noreset(path, level, (enum btree_node_locked_type) type);
> +	mark_btree_node_locked_reset(path, level, (enum btree_node_locked_type) type);
>  #ifdef CONFIG_BCACHEFS_LOCK_TIME_STATS
>  	path->l[level].lock_taken_time = local_clock();
>  #endif
> @@ -134,7 +134,7 @@ static inline void btree_node_unlock(struct btree_trans *trans,
>  		}
>  		six_unlock_type(&path->l[level].b->c.lock, lock_type);
>  		btree_trans_lock_hold_time_update(trans, path, level);
> -		mark_btree_node_locked_noreset(path, level, BTREE_NODE_UNLOCKED);
> +		mark_btree_node_locked_reset(path, level, BTREE_NODE_UNLOCKED);
>  	}
>  }
>  
> @@ -183,7 +183,7 @@ bch2_btree_node_unlock_write_inlined(struct btree_trans *trans, struct btree_pat
>  	EBUG_ON(path->l[b->c.level].lock_seq != six_lock_seq(&b->c.lock));
>  	EBUG_ON(btree_node_locked_type(path, b->c.level) != SIX_LOCK_write);
>  
> -	mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
> +	mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
>  	__bch2_btree_node_unlock_write(trans, b);
>  }
>  
> @@ -315,7 +315,7 @@ static inline int __btree_node_lock_write(struct btree_trans *trans,
>  	 * write lock: thus, we need to tell the cycle detector we have a write
>  	 * lock _before_ taking the lock:
>  	 */
> -	mark_btree_node_locked_noreset(path, b->level, BTREE_NODE_WRITE_LOCKED);
> +	mark_btree_node_locked_reset(path, b->level, BTREE_NODE_WRITE_LOCKED);
>  
>  	return likely(six_trylock_write(&b->lock))
>  		? 0
> diff --git a/fs/bcachefs/btree_update_interior.c b/fs/bcachefs/btree_update_interior.c
> index 55fbeeb8eaaa..29e03408a019 100644
> --- a/fs/bcachefs/btree_update_interior.c
> +++ b/fs/bcachefs/btree_update_interior.c
> @@ -245,7 +245,7 @@ static void bch2_btree_node_free_inmem(struct btree_trans *trans,
>  	mutex_unlock(&c->btree_cache.lock);
>  
>  	six_unlock_write(&b->c.lock);
> -	mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
> +	mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
>  
>  	bch2_trans_node_drop(trans, b);
>  }
> @@ -788,7 +788,7 @@ static void btree_update_nodes_written(struct btree_update *as)
>  
>  		mutex_unlock(&c->btree_interior_update_lock);
>  
> -		mark_btree_node_locked_noreset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
> +		mark_btree_node_locked_reset(path, b->c.level, BTREE_NODE_INTENT_LOCKED);
>  		six_unlock_write(&b->c.lock);
>  
>  		btree_node_write_if_need(trans, b, SIX_LOCK_intent);
> -- 
> 2.48.1
> 
