Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7408D188CAD
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728577238; cv=none; b=MfrjKkPMJjGoZHWBLlxIv+fc1Oac1KLUc8Bqf+iXQkhgYxtLcr39qiOynUsZHUSJ9xoWf+TCK9GWuZ11ifCzOAWRHe45UXuqOrfc4lfvve+nuxwv/cfeWlOkYAsj7kKjSYxy9MQyRXNsalEY7Dzpzk/G7uo73zjNMvxDPBxvu70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728577238; c=relaxed/simple;
	bh=1u6Wh4dylgkaWa/VeAfQjG1eWx9KadBj/TIffTkkonI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DyQwkoy56MVIlizUFvbXruieeozbgEErH5io+Pt7KaqSutVWgnH34pK1+Y6Rr7zLzcwAke3QwEK9aJ12IMBtYxaHXPcNfHzZ2FWodYe/rz33F1ikI3Ybcitg5/JRCcE+WhejG542VEA1BS4D7ZyLZ1S3cBqnhovygQeaP63PT0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XBarVh4y; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XBarVh4y"
Date: Thu, 10 Oct 2024 12:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728577233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bWVWVUa3wuiR0c8OjkkIPE8mW7ek/rVE4LwRLDKHINU=;
	b=XBarVh4yP0DJ7mSPvPYh0tzbqtwJNxyKyBeu4fukJcKqD9GSCcdB+URRa/i7iWiE7RZ1pk
	rj5kWZHlPvu6CCjZaOYS2/H7WJmypNjWaJP1PlFskGngfrahKMd43wFJN/U7+AIr4tCyKX
	FVgH0NJvjLBYPubE6P5DtKEuowunapo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Do not allow no fail lock request to fail
Message-ID: <fdu4feezls66tsqjf5hgegnthczntpj3jfl2mo62rcyvekk56u@w32hjbtyvqax>
References: <20241010132150.1814411-1-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010132150.1814411-1-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 10, 2024 at 09:21:50PM GMT, Alan Huang wrote:
> If the transaction chose itself as a victim before and restarted, it
> might request a no fail lock request this time. But it might be added to
> others' lock graph and be chose as the victim again, it's no longer safe
> without additional check. We can also convert the cycle detector to be
> fully RCU-based to solve that unsoundness, but the latency added to trans_put
> and additional memory required may not worth it.

This is going to need ascii art diagrams...

I would expect the lock waitlist locks and sequence numbers to protect
against this kind of race, do they not?

> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> ---
>  fs/bcachefs/btree_locking.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/btree_locking.c b/fs/bcachefs/btree_locking.c
> index bf25fd0a1cca..fff176382e30 100644
> --- a/fs/bcachefs/btree_locking.c
> +++ b/fs/bcachefs/btree_locking.c
> @@ -293,7 +293,7 @@ int bch2_check_for_deadlock(struct btree_trans *trans, struct printbuf *cycle)
>  
>  	g.nr = 0;
>  
> -	if (trans->lock_must_abort) {
> +	if (trans->lock_must_abort && !trans->lock_may_not_fail) {
>  		if (cycle)
>  			return -1;
>  
> -- 
> 2.45.2
> 
