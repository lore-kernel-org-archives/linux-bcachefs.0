Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB63C17C22A
	for <linux-bcachefs@vger.kernel.org>; Fri, 15 Nov 2024 05:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731649433; cv=none; b=qFVbPsUD1Y3WxHs3dy7a7BpojSE2VHbnSHhiCK0A8jEKQZBGZHDQ7SWPhPafeRXMgxyJ8YAcX/Afi6ajwZrVDNhApJUtwWCwSjPOuOOld4Gergnd3l/3dK60y4FZ7AgKnl+9iFpytxjBctQn0bui3VN8amXrnGQuVtYaqXY+gbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731649433; c=relaxed/simple;
	bh=o1EAXMFhZAFzNQ7ugbfiPsmzCAK4NmKTTAbtuEB9lng=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PNy+XJRp4U1nrWrhWkg7G7GaJWUohL1/qY9EWpZVi904NATbWo4AMKS5fmkvoaijmRTBw1QZLpVNeya86YUVun51CSnMYV8fRlDf0+QCh2BgR+n4RBIH2YkNuWmxzFDsPMolWdBiGB9dg6q2YNodEx6CSqKwkRqpcIeZeOZ3gBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=e2hiBD97; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="e2hiBD97"
Date: Fri, 15 Nov 2024 00:43:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731649426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lfn77qVXTLEiEsvEgL4FH5NA40V1Wz25aECHqcC9F9o=;
	b=e2hiBD97eQMVLDykTO28AWrPxV615DI3suJNd74+J2WHL4k/mBW43RI9HIzztqd/PI2pXr
	j7Cmv0zp40IqJSII8lT7uGH94DtMX1crxAozw51Xumx3PWwVx/UujiWUkFeEGw1d9plrXL
	3Ez85ZuTOlK+IDlLnPyVoTreNMI218c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Florian Schmaus <flo@geekplace.eu>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: Set rebalance thread to SCHED_BATCH and
 nice 19
Message-ID: <kycrjg4nlgwxb6b6wph3uolmh45t7ivmoi5jpy4pakvh74wnoo@wp7hlbcbtwyw>
References: <20241114210649.71377-1-flo@geekplace.eu>
 <20241114210649.71377-2-flo@geekplace.eu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241114210649.71377-2-flo@geekplace.eu>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 14, 2024 at 10:06:48PM +0100, Florian Schmaus wrote:
> Set the rebalance thread's scheduling class to BATCH, which means it
> could experience a higher scheduling latency. However, it reduces
> preemption events of running threads.
> 
> And while the rebalance thread is ually not compute bound, it does
> cause a considerable amount of I/O. By increasing its nice level from
> 0 to 19 we also implicitly reduce the thread's best-effort I/O
> scheduling class level from 4 to 7. Therefore, the rebalance thread's
> I/O operations will be deprioritized over standard I/O operations.

Is there a patch 1/2?

> 
> Signed-off-by: Florian Schmaus <flo@geekplace.eu>
> ---
>  fs/bcachefs/rebalance.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/bcachefs/rebalance.c b/fs/bcachefs/rebalance.c
> index 4adc74cd3f70..b26c68007c5a 100644
> --- a/fs/bcachefs/rebalance.c
> +++ b/fs/bcachefs/rebalance.c
> @@ -22,6 +22,7 @@
>  
>  #include <linux/freezer.h>
>  #include <linux/kthread.h>
> +#include <linux/sched.h>
>  #include <linux/sched/cputime.h>
>  
>  /* bch_extent_rebalance: */
> @@ -662,6 +663,8 @@ int bch2_rebalance_start(struct bch_fs *c)
>  	if (ret)
>  		return ret;
>  
> +	sched_set_batch(p, 19);
> +
>  	get_task_struct(p);
>  	rcu_assign_pointer(c->rebalance.thread, p);
>  	wake_up_process(p);
> -- 
> 2.45.2
> 
