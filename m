Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE8F524B7
	for <linux-bcachefs@vger.kernel.org>; Wed, 20 Mar 2024 17:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710956360; cv=none; b=HrDmvf9ztHmNb/nYkOXT9WjYrJo2y/7M5+nf7gB75DUz5scOMuDSKNp095R5AyT0kvCjkAllbH9nz5zyMpePdR+nylKdNZzIH2dJdM6Ktv+A28p/6EbrNxcR4J57WJHDq9JfQs3N9M2huhCROHnlAljvRNY96yQ+/dmseI7pn8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710956360; c=relaxed/simple;
	bh=nNcbximUicEluOrbp2uE1jhe0xDSyoXXpAO5GqQmM/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCR+yvL0IZeXCHJJgXc5r2xjE369s9i4vrSfAfzhRAyr9SzhViWhs7pbyFftlOBINMuqz9cU3ZARNt13i2maQYJblPgxOR6KMEOei06/vnJ0uuJ54KguA0pKD5G1l7ChXI1K+SucIEim75h5nLz+vYZGP0rQji5KNWTSm+YQbWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dug/XYvh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dug/XYvh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710956357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6YhOBxxlsYFmwfao+i0LZ0i2FlSE8agrGc7yHwvY0Zk=;
	b=Dug/XYvhGJmX38UZ0Bb/66VTnmKxW1DmV9hE5KTAAo37cVv7cfu2WHlfstKKsyWL/s8x0P
	bYGt/APAd8dvQH3w6vbHuiEEfiUvY+sGChUl6vfC/1bz6wlwF07r5hGGJEQOb5uKF9/mTY
	XiGjIJAwFxPPrXiUtth7tr9OpUxxpoc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-567-JpIJgMZaPNmBdkm5vZlH2A-1; Wed,
 20 Mar 2024 13:39:15 -0400
X-MC-Unique: JpIJgMZaPNmBdkm5vZlH2A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5783629AA396;
	Wed, 20 Mar 2024 17:39:15 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.57])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1104DC15773;
	Wed, 20 Mar 2024 17:39:15 +0000 (UTC)
Date: Wed, 20 Mar 2024 13:41:09 -0400
From: Brian Foster <bfoster@redhat.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] bcachefs: optimize btree_path status
 representation
Message-ID: <ZfsftT1Wd0K6daOy@bfoster>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

On Wed, Mar 20, 2024 at 02:29:23PM +0800, Hongbo Li wrote:
> UPTODATE means btree_path is useable, so here use
> btree_path_is_uptodate to check this status. And the old
> function btree_path_set_dirty cannot represent what it really
> does (such as if UPTODATE is passed into it, btree_path sometime
> wasn't dirty).
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
...
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

Hmm.. I'm kind of neutral on the update_state() rename, but I like the
btree_path_is_uptodate() helper to clean up some of the wonky logic.

My initial thought was to wonder whether it's worth creating some macro
helpers for each state, but after looking through the code a bit that
seems like overkill. In fact AFAICT, the only purpose of the
NEED_TRAVERSE state is so that a lock cycle doesn't return the path back
to UPTODATE in that particular case. Otherwise nothing else actually
seems to explicitly check for NEED_TRAVERSE state.

Am I missing something there? If not, I'd say just replace the enum with
an explicit 2-bit field called something like 'path_invalid' and define
the states as corresponding flags. For example:

#define BTREE_PATH_INVALID		(1 << 0)
#define BTREE_PATH_INVALID_LOCKS	(1 << 1)

Then the helpers just manage the validation flags appropriately (i.e.
is_uptodate() means path_invalid == 0). I suppose you could also invert
that logic and call the field path_valid or whatever too. Thoughts, or
other ideas?

Brian

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

