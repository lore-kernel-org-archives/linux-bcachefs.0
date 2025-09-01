Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D472E1E260D
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Sep 2025 22:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756766556; cv=none; b=omcmg53A0/vzjq/0No9HYgaTpCSg0abHIo9wZ97FDP4oNrTM99PVnIIR80xT1MKkI3s4brPbvFChQqXKOTAswNi1CpXq48g9m4oTm/0Kk5GHlMRl4Z6HVPQ02tM9Ihza3wrf5Tr1houHt7kz9hFuJzD421ZCz9yn6sbszgVT8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756766556; c=relaxed/simple;
	bh=8f0MarOG+EW9fdGutCHufUv++8qATArPyw/q+K7eJHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P4JuRm3DTz611Bysm1+ddT8CPChsg6efPke5qzFTWEN90pIRxXikHtDShz1N4vquoTD5+R60VbM0PbG1Zjp+QmTsLH3v1/8Bui3IIr+zKN8gucHtR5VGjKURAY7jEd7b+WdERUj5n5AxLBh+9j/o1xtkvXeUKHwNjW0TmoqCuek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GvzplqQ0; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GvzplqQ0"
Date: Mon, 1 Sep 2025 18:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756766553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DBqJNjxpfYZURa43b8ZcnAOQPgC3ygB5rI1DGuS76Eg=;
	b=GvzplqQ06n+jgwuFPR35Podw0DBr2mVKa58BWtUJ8EjiXZ1lmhHebC9zDFpW87nXDtEQZh
	4FlaMk+eROQMU3CXFGAKlgHQlFghTk553vJ+y2x/bH+sw0vxJi85QIBFi0gygbGTazzrrp
	qM4Iq4xXcCNdYoUo2nuBcZDWP9Jqo9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Kill duplicate error code
Message-ID: <frmmbj6oawjwb4dklf4rqico3ajauud6jqw3hspfdewkxhs5qj@b42regdayqhy>
References: <20250823184132.235684-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250823184132.235684-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 24, 2025 at 02:41:32AM +0800, Alan Huang wrote:
> btree_node_read_error is duplicate of btree_node_read_err, which impacts
> repair path if misused.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/btree_io.c         | 2 +-
>  fs/bcachefs/errcode.h          | 1 -
>  fs/bcachefs/sb-errors_format.h | 2 +-
>  3 files changed, 2 insertions(+), 3 deletions(-)

So the patch builds, but this still doesn't make sense, because

> 
> diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
> index 2e3dd9bacac5..3d594c4ae9d8 100644
> --- a/fs/bcachefs/btree_io.c
> +++ b/fs/bcachefs/btree_io.c
> @@ -1902,7 +1902,7 @@ static int __bch2_btree_root_read(struct btree_trans *trans, enum btree_id id,
>  		scoped_guard(mutex, &c->btree_cache.lock)
>  			bch2_btree_node_hash_remove(&c->btree_cache, b);
>  
> -		ret = bch_err_throw(c, btree_node_read_error);
> +		ret = bch_err_throw(c, btree_node_read_err);

this references an errcode.h error

>  		goto err;
>  	}
>  
> diff --git a/fs/bcachefs/errcode.h b/fs/bcachefs/errcode.h
> index adc1f9315eab..7106d72fca80 100644
> --- a/fs/bcachefs/errcode.h
> +++ b/fs/bcachefs/errcode.h
> @@ -295,7 +295,6 @@
>  	x(BCH_ERR_btree_node_read_err,	btree_node_read_err_cached)		\
>  	x(EIO,				sb_not_downgraded)			\
>  	x(EIO,				btree_node_write_all_failed)		\
> -	x(EIO,				btree_node_read_error)			\

which you delete

>  	x(EIO,				btree_need_topology_repair)		\
>  	x(EIO,				bucket_ref_update)			\
>  	x(EIO,				trigger_alloc)				\
> diff --git a/fs/bcachefs/sb-errors_format.h b/fs/bcachefs/sb-errors_format.h
> index aa0ea1ec9f10..483358588abc 100644
> --- a/fs/bcachefs/sb-errors_format.h
> +++ b/fs/bcachefs/sb-errors_format.h
> @@ -73,7 +73,7 @@ enum bch_fsck_flags {
>  	x(btree_root_read_error,				 59,	FSCK_AUTOFIX)	\
>  	x(btree_root_bad_min_key,				 60,	0)		\
>  	x(btree_root_bad_max_key,				 61,	0)		\
> -	x(btree_node_read_error,				 62,	FSCK_AUTOFIX)	\
> +	x(btree_node_read_err,				 	 62,	FSCK_AUTOFIX)	\

and rename the persistent error?

>  	x(btree_node_topology_bad_min_key,			 63,	FSCK_AUTOFIX)	\
>  	x(btree_node_topology_bad_max_key,			 64,	FSCK_AUTOFIX)	\
>  	x(btree_node_topology_bad_root_min_key,			 323,	FSCK_AUTOFIX)	\
> -- 
> 2.49.0
> 
