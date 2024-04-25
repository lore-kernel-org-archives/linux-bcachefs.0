Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BAA17550
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Apr 2024 03:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714016367; cv=none; b=WXnZVTYf/3boADp5eB0op3Ad+S1C/lIXEOHdXwWbQblSC8BssVCKKGIkjk92lITDuvTqVBjUCW/GaahbhjAuhjUxnP2ZiXwuwbrVisMPBjsN7ZpJd3eueG32HoqnA5J2UfmesYURVSnJ/Jg0O9diUyj5Auy37jcYZ+aF58/KYno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714016367; c=relaxed/simple;
	bh=IqLB9icIhFAwEWAvudJjpfSpeG7/Y3sse5fFRlBfjjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MSN2I5WyM5bF0RH//bJs54Lxv3vH7QxTVAQw8niZ1iEoaUrwe+DAmJIkDaxT8kbNEgxc9+PDlAehWh3bpsmkcVs5cFSAHoQSYOh6SH6z87XA0U/pmhzYIEF9IK329n7JgVgAI8+6FfNwfCRxVn4+TRta1xG7OHMCMF+vEJ5ovZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MEyb8PEZ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MEyb8PEZ"
Date: Wed, 24 Apr 2024 23:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714016362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjKEWbZRfIl+Ux0Os9r1IiKrahmeMMidHIwzNSkPl0g=;
	b=MEyb8PEZfiJfTII6bemYqYOkhXjnYVKG5UBhj316Sg3QsERIUZLzkMhc8AvrWGn/2/Eq8q
	HRVPe/G+V95SuqhI4lG1yWIJLt9bLspNYDgwvFgWVit3LxF/Np+n7G09lEUlCiU6luHaML
	0Ojaw5my7WNUz4Q3ndeBhsUshb5J28w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: eliminate the uninitialized compilation
 warning in __do_six_trylock
Message-ID: <thqa55x6czurhymdrpb5he2pshphxwyrikouport4blcfpcqbp@w23bie4t5ufa>
References: <20240419074851.1583392-1-lihongbo22@huawei.com>
 <20240419074851.1583392-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240419074851.1583392-3-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 19, 2024 at 03:48:51PM +0800, Hongbo Li wrote:
> When compiling the bcachefs-tools, the following compilation warning
> is reported:
>     libbcachefs/six.c: In function ‘__do_six_trylock’:
>     libbcachefs/six.c:90:12: warning: ‘old’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>        90 |  if (!(old & SIX_LOCK_HELD_intent)) {
>         |       ~~~~~^~~~~~~~~~~~~~~~~~~~~~~
> 
> This is also a false altert. Only when @type=SIX_LOCK_write and @try=false
> are passed in __do_six_trylock, the second condition branch would enter
> which does not initialize the @old variable. But six_set_owner will not
> use @old if @type is not SIX_LOCK_intent. There should be nothing wrong
> in logical too.
> 
> Although the report itself is a false alert, we can elimate the unitialize
> compilation warning by assigning @old in front.
> 
> Fixes: 84a37cbf62e0 ("six locks: Wakeup now takes lock on behalf of waiter")
> Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
> ---
>  fs/bcachefs/six.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 3a494c5d1247..9f782e4e3ca9 100644
> --- a/fs/bcachefs/six.c
> +++ b/fs/bcachefs/six.c
> @@ -118,11 +118,11 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>  			    struct task_struct *task, bool try)
>  {
>  	int ret;
> -	u32 old;
> +	u32 old = atomic_read(&lock->state);
>  
>  	EBUG_ON(type == SIX_LOCK_write && lock->owner != task);
>  	EBUG_ON(type == SIX_LOCK_write &&
> -		(try != !(atomic_read(&lock->state) & SIX_LOCK_HELD_write)));
> +		(try != !(old & SIX_LOCK_HELD_write)));
>  
>  	/*
>  	 * Percpu reader mode:
> @@ -157,7 +157,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>  
>  		smp_mb();
>  
> -		old = atomic_read(&lock->state);

Nope, this is wrong. That smp_mb() is there for a reason.

>  		ret = !(old & l[type].lock_fail);
>  
>  		this_cpu_sub(*lock->readers, !ret);
> @@ -182,7 +181,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
>  				ret = -1 - SIX_LOCK_read;
>  		}
>  	} else {
> -		old = atomic_read(&lock->state);
>  		do {
>  			ret = !(old & l[type].lock_fail);
>  			if (!ret || (type == SIX_LOCK_write && !try)) {
> -- 
> 2.34.1
> 
