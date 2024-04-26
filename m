Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE6D75805
	for <linux-bcachefs@vger.kernel.org>; Fri, 26 Apr 2024 04:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104265; cv=none; b=FoxefEfzqbxE1UMpCAKXCGXz9gQ6ROfeoCuJ+9HsF2L3iKyAI9T4AvWTjvghsYzDv3TNR+ecrQrGCWjE9t5KYxJFWXgVpE2Cm/9f3/vJ8A63tnLhDu8F4Es12o/dpD1VxVKw+IalnkK7O4+OZcdl5P8u8MG1BlNfOx0oiynqrcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104265; c=relaxed/simple;
	bh=BibvzfQz3ALVFPayHF5W3btzLuaWfWwQPCaj6XwmUUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XEpzGaokgvyRbVVi/IKeBQFsrla82ThqECuAVqKV3r5KDDT0gZl0jvnZrasCnzcxOo14rcrblbbBq69+bDmNR4IIi6AGot1R7jxr1NpdKLPCujCGsm5rQHRPLqrvEhAKQLphnE+nq2jBIzr8x9ZfJshRJvTQ764mCbAIJ4CSGww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=svDlu0dn; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="svDlu0dn"
Date: Fri, 26 Apr 2024 00:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714104261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w5NtmtzWn7ZTEF/RZ1D3mMk9Ox7EhbGuYLvl0oXZzDU=;
	b=svDlu0dnBNBQJ0XQ6KzJxQnt+vBH34gWGMwQ1RU9BGBKj/qLBsQAQO7GWlpPBo0vZMUSpG
	LWGGIGhmDfZBjH3D4pk35xTWYYP3ecXfk5NcAmsBRIyaXmkg8nG06iVb8RBEpwVtQZ8a9z
	/XAj4hTDkaP4wlefYenTDlIUvClVIOg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: bfoster@redhat.com, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v2 2/2] bcachefs: eliminate the uninitialized compilation
 warning in __do_six_trylock
Message-ID: <mk6bvhdvbeo5ey7oxlclkgya4ywk3izi4p2anl5n7a7zngneoj@qddrf2si5nfd>
References: <20240426032136.2551471-1-lihongbo22@huawei.com>
 <20240426032136.2551471-3-lihongbo22@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240426032136.2551471-3-lihongbo22@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 26, 2024 at 11:21:36AM +0800, Hongbo Li wrote:
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

let's just delete the assertion - I don't like moving around reading the
lock state for this.

> ---
> v2:
>   - Fix the error about reading lock->state introduced in v1.
> 
> v1: https://lore.kernel.org/all/20240419074851.1583392-3-lihongbo22@huawei.com/T/#u
> ---
> ---
>  fs/bcachefs/six.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/bcachefs/six.c b/fs/bcachefs/six.c
> index 3a494c5d1247..8bfd22a6f771 100644
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
> @@ -182,7 +182,6 @@ static int __do_six_trylock(struct six_lock *lock, enum six_lock_type type,
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
