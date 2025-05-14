Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FF32749EA
	for <linux-bcachefs@vger.kernel.org>; Wed, 14 May 2025 15:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236932; cv=none; b=ouqjF5SY93dROkVqhS9FUSKTI5BHFfM8So3pLenhLwfpxKNRUL+tWYdV7a0nRz4RRc5wdDTOuMUiRuSUWwDKMq4nKwJHLcwi1zRlSa9Gl+KdJh0F+1sF3d/igYgMeRsU5aPR18rcO56kVKoFgazcmDZHbtMk8qbIZUX3WE59MjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236932; c=relaxed/simple;
	bh=IUF/L1kZ2gLD+JcuN2ecZDPpmY5dWyVceGkC0bbVeqo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l9Dwoaqh24Yy52akWqhbJDQKl7tclNKexEIvhyCracuvaMoprU8W9typqBHJyhOXcMQp3KgoOBOTCxK6EVE7+dYsw8612gUhgamx+MyJPjwVVydegNyeBeUWIOSrIwII3ARICFS49w7sssgChIG8OcT8N9UtUB13jA9rr4gCo6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mJc1VQYg; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mJc1VQYg"
Date: Wed, 14 May 2025 11:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1747236926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TUuhZS8g/Td8D4VbVMOsmA8zcejLrlgwAuj1yZX2+Wo=;
	b=mJc1VQYgEK518jbCkniS/2SnCIfniO3CgU2bN+8mxBHNUuvI3GyXVFZklXZkwnM3RjvI35
	CJpsfdXKYswajqA/XkpN5LhMJnwGFXPbHwHkGbQPuI0vH0yn5Rc9gfmsuq0AEj/SvFEeFY
	+lhBj6PoXUCCa0mJjaI8ma1jGNmjYSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Fix self deadlock
Message-ID: <awy77u26ityq4jhkyym7oj5ibomae7h37wdh63wmybujlmzicu@45576bv6r6hm>
References: <20250513105426.239043-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250513105426.239043-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, May 13, 2025 at 06:54:26PM +0800, Alan Huang wrote:
> Before invoking bch2_accounting_mem_mod_locked in
> bch2_gc_accounting_done, we already write locked mark_lock,
> in bch2_accounting_mem_insert, we lock mark_lock again.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied, queued up for 6.15

> ---
>  fs/bcachefs/disk_accounting.c | 17 +++++++++++++++--
>  fs/bcachefs/disk_accounting.h | 16 +++++++++++-----
>  2 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/bcachefs/disk_accounting.c b/fs/bcachefs/disk_accounting.c
> index 2dcccf1edbb9..195dc3fcec1d 100644
> --- a/fs/bcachefs/disk_accounting.c
> +++ b/fs/bcachefs/disk_accounting.c
> @@ -376,6 +376,19 @@ int bch2_accounting_mem_insert(struct bch_fs *c, struct bkey_s_c_accounting a,
>  	return ret;
>  }
>  
> +int bch2_accounting_mem_insert_locked(struct bch_fs *c, struct bkey_s_c_accounting a,
> +			       enum bch_accounting_mode mode)
> +{
> +	union bch_replicas_padded r;
> +
> +	if (mode != BCH_ACCOUNTING_read &&
> +	    accounting_to_replicas(&r.e, a.k->p) &&
> +	    !bch2_replicas_marked_locked(c, &r.e))
> +		return -BCH_ERR_btree_insert_need_mark_replicas;
> +
> +	return __bch2_accounting_mem_insert(c, a);
> +}
> +
>  static bool accounting_mem_entry_is_zero(struct accounting_mem_entry *e)
>  {
>  	for (unsigned i = 0; i < e->nr_counters; i++)
> @@ -585,7 +598,7 @@ int bch2_gc_accounting_done(struct bch_fs *c)
>  					accounting_key_init(&k_i.k, &acc_k, src_v, nr);
>  					bch2_accounting_mem_mod_locked(trans,
>  								bkey_i_to_s_c_accounting(&k_i.k),
> -								BCH_ACCOUNTING_normal);
> +								BCH_ACCOUNTING_normal, true);
>  
>  					preempt_disable();
>  					struct bch_fs_usage_base *dst = this_cpu_ptr(c->usage);
> @@ -614,7 +627,7 @@ static int accounting_read_key(struct btree_trans *trans, struct bkey_s_c k)
>  
>  	percpu_down_read(&c->mark_lock);
>  	int ret = bch2_accounting_mem_mod_locked(trans, bkey_s_c_to_accounting(k),
> -						 BCH_ACCOUNTING_read);
> +						 BCH_ACCOUNTING_read, false);
>  	percpu_up_read(&c->mark_lock);
>  	return ret;
>  }
> diff --git a/fs/bcachefs/disk_accounting.h b/fs/bcachefs/disk_accounting.h
> index 6524cb14a58a..54cb8a5b117d 100644
> --- a/fs/bcachefs/disk_accounting.h
> +++ b/fs/bcachefs/disk_accounting.h
> @@ -136,6 +136,7 @@ enum bch_accounting_mode {
>  };
>  
>  int bch2_accounting_mem_insert(struct bch_fs *, struct bkey_s_c_accounting, enum bch_accounting_mode);
> +int bch2_accounting_mem_insert_locked(struct bch_fs *, struct bkey_s_c_accounting, enum bch_accounting_mode);
>  void bch2_accounting_mem_gc(struct bch_fs *);
>  
>  static inline bool bch2_accounting_is_mem(struct disk_accounting_pos *acc)
> @@ -150,7 +151,8 @@ static inline bool bch2_accounting_is_mem(struct disk_accounting_pos *acc)
>   */
>  static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
>  						 struct bkey_s_c_accounting a,
> -						 enum bch_accounting_mode mode)
> +						 enum bch_accounting_mode mode,
> +						 bool write_locked)
>  {
>  	struct bch_fs *c = trans->c;
>  	struct bch_accounting_mem *acc = &c->accounting;
> @@ -189,7 +191,11 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
>  
>  	while ((idx = eytzinger0_find(acc->k.data, acc->k.nr, sizeof(acc->k.data[0]),
>  				      accounting_pos_cmp, &a.k->p)) >= acc->k.nr) {
> -		int ret = bch2_accounting_mem_insert(c, a, mode);
> +		int ret = 0;
> +		if (unlikely(write_locked))
> +			ret = bch2_accounting_mem_insert_locked(c, a, mode);
> +		else
> +			ret = bch2_accounting_mem_insert(c, a, mode);
>  		if (ret)
>  			return ret;
>  	}
> @@ -206,7 +212,7 @@ static inline int bch2_accounting_mem_mod_locked(struct btree_trans *trans,
>  static inline int bch2_accounting_mem_add(struct btree_trans *trans, struct bkey_s_c_accounting a, bool gc)
>  {
>  	percpu_down_read(&trans->c->mark_lock);
> -	int ret = bch2_accounting_mem_mod_locked(trans, a, gc ? BCH_ACCOUNTING_gc : BCH_ACCOUNTING_normal);
> +	int ret = bch2_accounting_mem_mod_locked(trans, a, gc ? BCH_ACCOUNTING_gc : BCH_ACCOUNTING_normal, false);
>  	percpu_up_read(&trans->c->mark_lock);
>  	return ret;
>  }
> @@ -259,7 +265,7 @@ static inline int bch2_accounting_trans_commit_hook(struct btree_trans *trans,
>  	EBUG_ON(bversion_zero(a->k.bversion));
>  
>  	return likely(!(commit_flags & BCH_TRANS_COMMIT_skip_accounting_apply))
> -		? bch2_accounting_mem_mod_locked(trans, accounting_i_to_s_c(a), BCH_ACCOUNTING_normal)
> +		? bch2_accounting_mem_mod_locked(trans, accounting_i_to_s_c(a), BCH_ACCOUNTING_normal, false)
>  		: 0;
>  }
>  
> @@ -271,7 +277,7 @@ static inline void bch2_accounting_trans_commit_revert(struct btree_trans *trans
>  		struct bkey_s_accounting a = accounting_i_to_s(a_i);
>  
>  		bch2_accounting_neg(a);
> -		bch2_accounting_mem_mod_locked(trans, a.c, BCH_ACCOUNTING_normal);
> +		bch2_accounting_mem_mod_locked(trans, a.c, BCH_ACCOUNTING_normal, false);
>  		bch2_accounting_neg(a);
>  	}
>  }
> -- 
> 2.48.1
> 
