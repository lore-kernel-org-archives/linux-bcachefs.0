Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F4385929
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 20:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710965204; cv=none; b=GYM+gB6qNf2H36lbX/Avvt8mueg3oAVZ9MCq0au+wJXXlni+Y9nbYFXTzxRuYNDZLnOU5oP+kLOqM8shKskHfZwZrUVh7dw3OrXfuI5NVKwt0j6AuqMmcmfPV2NFVGulV/bmmdcxrawDcVDEgvI30wniCCQ9xWfnFfM/GdMwN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710965204; c=relaxed/simple;
	bh=vSna76pEbMJwdtOu6c6bY5BtpoH8I49lhfRGaqAizxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRIp9dtZEYKEsQHXP+NYLRyusvtwb4vAKKuchi4goOmxtwe4v1QfxFvzMmFxnSlEzMV09fDH8HpqiBiPZcoAfJ3lDwEfRBMVPfaAaKjLyn543/Q08270YDWD/kOinlnOaIM2byEzY6Tqc/367UH27Ot6t7yZ/dGFsKJDevzoF18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TFlIJvtu; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TFlIJvtu"
Date: Wed, 20 Mar 2024 16:06:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710965200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pBM0bD2mNzByrFtTW79y+JXYpEwhQwkIlQ/UoIr1844=;
	b=TFlIJvtu2VfAOq3CXvyFdVB3I3Vuj/TiaJZbLv+g1thzliOSyR8GjF9HV5SIPKe9eDolRT
	Xy14yCCuOOiJWCgtzaYmH6zizLPHzegYC3HMe22gBjeISghd2SEgiH69YAvBr5j+fauQVJ
	mhlt6GOPwqO/G6Jb/1mZ/JwTVuOOe7Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] bcachefs: optimize btree_path status
 representation
Message-ID: <3tha6rntacqyanpcdjvucaqepn45oirb753pkbys37hb7wuxh4@5kscx5omadx5>
References: <20240320062923.305431-1-lihongbo22@huawei.com>
 <20240320062923.305431-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240320062923.305431-3-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 20, 2024 at 02:29:23PM +0800, Hongbo Li wrote:
> UPTODATE means btree_path is useable, so here use
> btree_path_is_uptodate to check this status. And the old
> function btree_path_set_dirty cannot represent what it really
> does (such as if UPTODATE is passed into it, btree_path sometime
> wasn't dirty).

So - btree_path refactoring - that's ambitious :)

When we're refactoring tricky code like this, two guidelines:

I often don't care too much about how much a patch is split up, but the
btree iterator and btree path code is some of the trickiest, most
subtle, and hardest to debug code in the entire codebase - so this is
very much where we go in very small incremental steps that do just one
thing.

In this situation, a non functional change (like this one) should be as
close to a simple search and replace as possible, and the commit message
should say, clearly
 - what the search and replace operation was

   example commit messages:
   s/btree_path_set_dirty/btree_path_update_state/
   s/path->status == BTREE_PATH_UPTODATE/btree_path_is_uptodate/

   those are clear, simple, and unambiguous. A simple search and replace
   like that is not going to introduce bugs, and by splitting the series
   up so that every search and replace is its own patch it becomes much
   easier to review.

 - a bit of context about why, what this is leading up to. Not essential
   in every patch, but it should be in one of the commit messages in the
   series.

This patch could've been split up a bit more - I may take it as is, but
if there's another revision of the series please do that.

> 
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/btree_iter.c         | 16 ++++++++--------
>  fs/bcachefs/btree_iter.h         | 13 +++++++++----
>  fs/bcachefs/btree_key_cache.c    |  2 +-
>  fs/bcachefs/btree_locking.c      | 10 +++++-----
>  fs/bcachefs/btree_locking.h      |  8 ++++----
>  fs/bcachefs/btree_trans_commit.c |  2 +-
>  6 files changed, 28 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> index 2202b3571c81..513142e68f89 100644
> --- a/fs/bcachefs/btree_iter.c
> +++ b/fs/bcachefs/btree_iter.c
> @@ -693,7 +693,7 @@ void bch2_trans_node_add(struct btree_trans *trans,
>  	for (;
>  	     path && btree_path_pos_in_node(path, b);
>  	     path = next_btree_path(trans, path))
> -		if (path->status == UPTODATE && !path->cached) {
> +		if (btree_path_is_uptodate(path) && !path->cached) {
>  			enum btree_node_locked_type t =
>  				btree_lock_want(path, b->c.level);
>  
> @@ -1007,7 +1007,7 @@ static int bch2_btree_path_traverse_all(struct btree_trans *trans)
>  		 * Traversing a path can cause another path to be added at about
>  		 * the same position:
>  		 */
> -		if (trans->paths[idx].status) {
> +		if (!btree_path_is_uptodate(&trans->paths[idx])) {
>  			__btree_path_get(&trans->paths[idx], false);
>  			ret = bch2_btree_path_traverse_one(trans, idx, 0, _THIS_IP_);
>  			__btree_path_put(&trans->paths[idx], false);
> @@ -1068,7 +1068,7 @@ static void btree_path_set_level_down(struct btree_trans *trans,
>  		if (btree_lock_want(path, l) == BTREE_NODE_UNLOCKED)
>  			btree_node_unlock(trans, path, l);
>  
> -	btree_path_set_dirty(path, NEED_TRAVERSE);
> +	btree_path_update_state(path, NEED_TRAVERSE);
>  	bch2_btree_path_verify(trans, path);
>  }
>  
> @@ -1245,7 +1245,7 @@ __bch2_btree_path_set_pos(struct btree_trans *trans,
>  	if (unlikely(path->cached)) {
>  		btree_node_unlock(trans, path, 0);
>  		path->l[0].b = ERR_PTR(-BCH_ERR_no_btree_node_up);
> -		btree_path_set_dirty(path, NEED_TRAVERSE);
> +		btree_path_update_state(path, NEED_TRAVERSE);
>  		goto out;
>  	}
>  
> @@ -1274,7 +1274,7 @@ __bch2_btree_path_set_pos(struct btree_trans *trans,
>  	}
>  
>  	if (unlikely(level != path->level)) {
> -		btree_path_set_dirty(path, NEED_TRAVERSE);
> +		btree_path_update_state(path, NEED_TRAVERSE);
>  		__bch2_btree_path_unlock(trans, path);
>  	}
>  out:
> @@ -1675,7 +1675,7 @@ struct bkey_s_c bch2_btree_path_peek_slot(struct btree_path *path, struct bkey *
>  	if (unlikely(!l->b))
>  		return bkey_s_c_null;
>  
> -	EBUG_ON(path->status != UPTODATE);
> +	EBUG_ON(!btree_path_is_uptodate(path));
>  	EBUG_ON(!btree_node_locked(path, path->level));
>  
>  	if (!path->cached) {
> @@ -1811,7 +1811,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
>  		__bch2_btree_path_unlock(trans, path);
>  		path->l[path->level].b		= ERR_PTR(-BCH_ERR_no_btree_node_relock);
>  		path->l[path->level + 1].b	= ERR_PTR(-BCH_ERR_no_btree_node_relock);
> -		btree_path_set_dirty(path, NEED_TRAVERSE);
> +		btree_path_update_state(path, NEED_TRAVERSE);
>  		trace_and_count(trans->c, trans_restart_relock_next_node, trans, _THIS_IP_, path);
>  		ret = btree_trans_restart(trans, BCH_ERR_transaction_restart_relock);
>  		goto err;
> @@ -1849,7 +1849,7 @@ struct btree *bch2_btree_iter_next_node(struct btree_iter *iter)
>  					iter->flags & BTREE_ITER_INTENT,
>  					btree_iter_ip_allocated(iter));
>  	btree_path_set_should_be_locked(btree_iter_path(trans, iter));
> -	EBUG_ON(btree_iter_path(trans, iter)->status);
> +	EBUG_ON(!btree_path_is_uptodate(btree_iter_path(trans, iter)));
>  out:
>  	bch2_btree_iter_verify_entry_exit(iter);
>  	bch2_btree_iter_verify(iter);
> diff --git a/fs/bcachefs/btree_iter.h b/fs/bcachefs/btree_iter.h
> index c76070494284..f9ed8c44ab5a 100644
> --- a/fs/bcachefs/btree_iter.h
> +++ b/fs/bcachefs/btree_iter.h
> @@ -27,10 +27,15 @@ static inline bool __btree_path_put(struct btree_path *path, bool intent)
>  	return --path->ref == 0;
>  }
>  
> -static inline void btree_path_set_dirty(struct btree_path *path,
> -					enum btree_path_state u)
> +static inline bool btree_path_is_uptodate(struct btree_path *path)
>  {
> -	path->status = max_t(unsigned, path->status, u);
> +    return path->status == UPTODATE;
> +}
> +
> +static inline void btree_path_update_state(struct btree_path *path,
> +                    enum btree_path_state u)
> +{
> +    path->status = max_t(unsigned, path->status, u);
>  }
>  
>  static inline struct btree *btree_path_node(struct btree_path *path,
> @@ -219,7 +224,7 @@ int __must_check bch2_btree_path_traverse_one(struct btree_trans *,
>  static inline int __must_check bch2_btree_path_traverse(struct btree_trans *trans,
>  					  btree_path_idx_t path, unsigned flags)
>  {
> -	if (trans->paths[path].status < NEED_RELOCK)
> +	if (btree_path_is_uptodate(&trans->paths[path]))
>  		return 0;
>  
>  	return bch2_btree_path_traverse_one(trans, path, flags, _RET_IP_);
> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
> index 47cf735f24a0..d178b197dc17 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -540,7 +540,7 @@ bch2_btree_path_traverse_cached_slowpath(struct btree_trans *trans, struct btree
>  		set_bit(BKEY_CACHED_ACCESSED, &ck->flags);
>  
>  	BUG_ON(btree_node_locked_type(path, 0) != btree_lock_want(path, 0));
> -	BUG_ON(path->status);
> +	BUG_ON(!btree_path_is_uptodate(path));
>  
>  	return ret;
>  err:
> diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
> index 8d8e3207ca7a..0f18aacb9b5e 100644
> --- a/fs/bcachefs/btree_locking.c
> +++ b/fs/bcachefs/btree_locking.c
> @@ -462,7 +462,7 @@ void bch2_btree_node_lock_write_nofail(struct btree_trans *trans,
>  		for (i = 0; i < BTREE_MAX_DEPTH; i++)
>  			if (btree_node_read_locked(linked, i)) {
>  				btree_node_unlock(trans, linked, i);
> -				btree_path_set_dirty(linked, NEED_RELOCK);
> +				btree_path_update_state(linked, NEED_RELOCK);
>  			}
>  	}
>  
> @@ -505,7 +505,7 @@ static inline bool btree_path_get_locks(struct btree_trans *trans,
>  	 */
>  	if (fail_idx >= 0) {
>  		__bch2_btree_path_unlock(trans, path);
> -		btree_path_set_dirty(path, NEED_TRAVERSE);
> +		btree_path_update_state(path, NEED_TRAVERSE);
>  
>  		do {
>  			path->l[fail_idx].b = upgrade
> @@ -520,7 +520,7 @@ static inline bool btree_path_get_locks(struct btree_trans *trans,
>  
>  	bch2_trans_verify_locks(trans);
>  
> -	return path->status < NEED_RELOCK;
> +	return btree_path_is_uptodate(path);
>  }
>  
>  bool __bch2_btree_node_relock(struct btree_trans *trans,
> @@ -621,7 +621,7 @@ int bch2_btree_path_relock_intent(struct btree_trans *trans,
>  	     l++) {
>  		if (!bch2_btree_node_relock(trans, path, l)) {
>  			__bch2_btree_path_unlock(trans, path);
> -			btree_path_set_dirty(path, NEED_TRAVERSE);
> +			btree_path_update_state(path, NEED_TRAVERSE);
>  			trace_and_count(trans->c, trans_restart_relock_path_intent, trans, _RET_IP_, path);
>  			return btree_trans_restart(trans, BCH_ERR_transaction_restart_relock_path_intent);
>  		}
> @@ -865,7 +865,7 @@ void bch2_btree_path_verify_locks(struct btree_path *path)
>  	unsigned l;
>  
>  	if (!path->nodes_locked) {
> -		BUG_ON(path->status == UPTODATE &&
> +		BUG_ON(btree_path_is_uptodate(path) &&
>  		       btree_path_node(path, path->level));
>  		return;
>  	}
> diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
> index f3f03292a675..f58f769c0f19 100644
> --- a/fs/bcachefs/btree_locking.h
> +++ b/fs/bcachefs/btree_locking.h
> @@ -157,7 +157,7 @@ static inline int btree_path_highest_level_locked(struct btree_path *path)
>  static inline void __bch2_btree_path_unlock(struct btree_trans *trans,
>  					    struct btree_path *path)
>  {
> -	btree_path_set_dirty(path, NEED_RELOCK);
> +	btree_path_update_state(path, NEED_RELOCK);
>  
>  	while (path->nodes_locked)
>  		btree_node_unlock(trans, path, btree_path_lowest_level_locked(path));
> @@ -371,7 +371,7 @@ static inline int bch2_btree_path_upgrade(struct btree_trans *trans,
>  
>  	if (path->locks_want < new_locks_want
>  	    ? __bch2_btree_path_upgrade(trans, path, new_locks_want, &f)
> -	    : path->status == UPTODATE)
> +	    : btree_path_is_uptodate(path))
>  		return 0;
>  
>  	trace_and_count(trans->c, trans_restart_upgrade, trans, _THIS_IP_, path,
> @@ -384,7 +384,7 @@ static inline int bch2_btree_path_upgrade(struct btree_trans *trans,
>  static inline void btree_path_set_should_be_locked(struct btree_path *path)
>  {
>  	EBUG_ON(!btree_node_locked(path, path->level));
> -	EBUG_ON(path->status);
> +	EBUG_ON(!btree_path_is_uptodate(path));
>  
>  	path->should_be_locked = true;
>  }
> @@ -401,7 +401,7 @@ static inline void btree_path_set_level_up(struct btree_trans *trans,
>  				    struct btree_path *path)
>  {
>  	__btree_path_set_level_up(trans, path, path->level++);
> -	btree_path_set_dirty(path, NEED_TRAVERSE);
> +	btree_path_update_state(path, NEED_TRAVERSE);
>  }
>  
>  /* debug */
> diff --git a/fs/bcachefs/btree_trans_commit.c b/fs/bcachefs/btree_trans_commit.c
> index 0c94a885b567..222c52c1d949 100644
> --- a/fs/bcachefs/btree_trans_commit.c
> +++ b/fs/bcachefs/btree_trans_commit.c
> @@ -745,7 +745,7 @@ bch2_trans_commit_write_locked(struct btree_trans *trans, unsigned flags,
>  			bch2_btree_insert_key_cached(trans, flags, i);
>  		else {
>  			bch2_btree_key_cache_drop(trans, path);
> -			btree_path_set_dirty(path, NEED_TRAVERSE);
> +			btree_path_update_state(path, NEED_TRAVERSE);
>  		}
>  	}
>  
> -- 
> 2.34.1
> 
