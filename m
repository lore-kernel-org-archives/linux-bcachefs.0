Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC76284679
	for <linux-bcachefs@vger.kernel.org>; Tue, 15 Apr 2025 14:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744727697; cv=none; b=m5im6PfEOPOYV9FyWOjxHSZLbAkYsFHyEaVQaqcWjLT/mBmu94ZWHQZrfpgomwmoBtGk8zd7XEMudcAv2E20V9lCACHdJntMqni+PEDqG4nu2t/ui+yWSwWBk0oONeKJgz2/+PZsjQklbbj2btKl4mr8ZXzaxAcr8emy1+bQUA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744727697; c=relaxed/simple;
	bh=SAjJufDI010GmfPJgy25eqrCRxTvJKroV4fRDeuSYio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LalkunMJXQDZ8CzVSDJgguoXH9Wdfdt8Tp4H00KJfyKhosV2mjlcHQ76rt4xNOE0CbsFvRIYjtxh78dx/g5phQaVZRIzuuhWAmQI+QXC2KvZ8oyZO216zAccl+F/BRfP3MnmstSJg9HoagpYo6N0f37z4blXqbo5cBnkNV2PDXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I0fcUXH4; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I0fcUXH4"
Date: Tue, 15 Apr 2025 10:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744727693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AliRf5qFqU7m3+JfOohUK0d4Zy8RMZgfFm/GH/ZgPd4=;
	b=I0fcUXH4dlpOk2hkw3SBStBNl1WNWy2jQjzjgBiZ6KgV9fpeVejrrwEn8Njso1id06HYUs
	ExjBUA3Vd3qDmcpuGA5EIhM6mohssf3Qfx8601WybBdfM0wNqDWyWgOSILx6TGu5R+ZHa4
	ROW2+sd0nj6WtNgfsRtVUe0ouZiF5Qc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/4] bcachefs: Kill bch2_trans_unlock_noassert
Message-ID: <vc4yte7ckpteyv4z3utyycz53ue5z4ztsdzmu3tzszk54wzoy5@tigszoetyvan>
References: <20250415053307.81354-1-mmpgouride@gmail.com>
 <20250415053307.81354-2-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415053307.81354-2-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 15, 2025 at 01:33:04PM +0800, Alan Huang wrote:
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/btree_cache.c   | 2 +-
>  fs/bcachefs/btree_locking.c | 7 -------
>  fs/bcachefs/btree_locking.h | 1 -
>  3 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/fs/bcachefs/btree_cache.c b/fs/bcachefs/btree_cache.c
> index 9b80201c7982..153980a9a1cc 100644
> --- a/fs/bcachefs/btree_cache.c
> +++ b/fs/bcachefs/btree_cache.c
> @@ -978,7 +978,7 @@ static noinline struct btree *bch2_btree_node_fill(struct btree_trans *trans,
>  
>  		/* Unlock before doing IO: */
>  		six_unlock_intent(&b->c.lock);
> -		bch2_trans_unlock_noassert(trans);
> +		bch2_trans_unlock(trans);
>  
>  		bch2_btree_node_read(trans, b, sync);
>  
> diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
> index 94eb2b73a843..f4f563944340 100644
> --- a/fs/bcachefs/btree_locking.c
> +++ b/fs/bcachefs/btree_locking.c
> @@ -799,13 +799,6 @@ int bch2_trans_relock_notrace(struct btree_trans *trans)
>  	return __bch2_trans_relock(trans, false);
>  }
>  
> -void bch2_trans_unlock_noassert(struct btree_trans *trans)
> -{
> -	__bch2_trans_unlock(trans);
> -
> -	trans_set_unlocked(trans);
> -}
> -
>  void bch2_trans_unlock(struct btree_trans *trans)
>  {
>  	__bch2_trans_unlock(trans);
> diff --git a/fs/bcachefs/btree_locking.h b/fs/bcachefs/btree_locking.h
> index b33ab7af8440..66b27c0853a5 100644
> --- a/fs/bcachefs/btree_locking.h
> +++ b/fs/bcachefs/btree_locking.h
> @@ -15,7 +15,6 @@
>  
>  void bch2_btree_lock_init(struct btree_bkey_cached_common *, enum six_lock_init_flags, gfp_t gfp);
>  
> -void bch2_trans_unlock_noassert(struct btree_trans *);
>  void bch2_trans_unlock_write(struct btree_trans *);
>  
>  static inline bool is_btree_node(struct btree_path *path, unsigned l)
> -- 
> 2.48.1
> 
