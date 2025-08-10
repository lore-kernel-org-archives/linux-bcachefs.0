Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9CE1F5435
	for <linux-bcachefs@vger.kernel.org>; Sun, 10 Aug 2025 19:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754853873; cv=none; b=Ce011ftACgq0ZnpeNlfAiWQNxplXgCIUqT45Uk/A3mlJta466pWWDKjzclA5zf83nG+V5SKMvwPvLMPHQ6PmNKQ9xZKABf+yAK1I1OfD7Nn2ZTUO/W3qF0PCsT5710r8tAk826pewSl67hEz/zWdXtM4bIg11DzMPxWNUIuQgAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754853873; c=relaxed/simple;
	bh=HtpGJp0ZbFCE1rIx90n7t0c5hjbie7VCoaqeoLMvIfA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUldDvfLVVKfTK4JiW771TLDKgGMWwXO1gAyTVpJoCWkDadK4UJuCDqJL5wmAi59bNokXaIlQPn/W66OA8/GdyL3v9b0+LVFKrLgEy0g8tqIFhLt9nttSAsMhrmLtbsu6ArvArg7CMJ/ZfvBW2UYgqx05g6/AcUh3Q80Ov0a6NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sLxfdIHw; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sLxfdIHw"
Date: Sun, 10 Aug 2025 15:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754853857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9HmsXbpwqlaW/GkSlDbz9l1p4JHFHsrJneC/npDv+Ac=;
	b=sLxfdIHw2H7Zks/e58rzcGJMUukyJd/GyxHD8rJpT8uGSZCXEyyNYX8lt/6uwu5JAFFDRU
	IuUIbfwjHZcpZ4J71a6+NdkwIVkEjr3Ra4xvlfOHsX3+dTCMgVc0z07z/8h4QilWj8oMh0
	8KOdnDlPKs9mXmIaSRx4O6iP/GF7Bxg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Gopi Krishna Menon <krishnagopi487@gmail.com>
Cc: corbet@lwn.net, skhan@linuxfoundation.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] docs: filesystems: bcachefs: Fix spelling mistake in
 idle_work page
Message-ID: <a2dvoh6sbqvxbueljd6xbbwytkydu6zgdvzkootojdgddvj4ke@trypmesssyiw>
References: <20250810104654.90962-1-krishnagopi487@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250810104654.90962-1-krishnagopi487@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 10, 2025 at 04:16:48PM +0530, Gopi Krishna Menon wrote:
> Specifically, fix spelling mistake of "hierarchy"
> 
> Signed-off-by: Gopi Krishna Menon <krishnagopi487@gmail.com>

Applied

> ---
>  Documentation/filesystems/bcachefs/future/idle_work.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/bcachefs/future/idle_work.rst b/Documentation/filesystems/bcachefs/future/idle_work.rst
> index 59a332509dcd..f1202113dde0 100644
> --- a/Documentation/filesystems/bcachefs/future/idle_work.rst
> +++ b/Documentation/filesystems/bcachefs/future/idle_work.rst
> @@ -11,10 +11,10 @@ idle" so the system can go to sleep. We don't want to be dribbling out
>  background work while the system should be idle.
>  
>  The complicating factor is that there are a number of background tasks, which
> -form a heirarchy (or a digraph, depending on how you divide it up) - one
> +form a hierarchy (or a digraph, depending on how you divide it up) - one
>  background task may generate work for another.
>  
> -Thus proper idle detection needs to model this heirarchy.
> +Thus proper idle detection needs to model this hierarchy.
>  
>  - Foreground writes
>  - Page cache writeback
> @@ -51,7 +51,7 @@ IDLE REGIME
>  When the system becomes idle, we should start flushing our pending work
>  quicker so the system can go to sleep.
>  
> -Note that the definition of "idle" depends on where in the heirarchy a task
> +Note that the definition of "idle" depends on where in the hierarchy a task
>  is - a task should start flushing work more quickly when the task above it has
>  stopped generating new work.
>  
> -- 
> 2.43.0
> 
