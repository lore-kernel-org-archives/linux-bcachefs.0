Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B072E20D500
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 13:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742304942; cv=none; b=R+fSj9X7wljB7HnXk7P9PTy72Vg8lbwjozeB0QVf3OHRF9oysIQMab8Y9UaylZwKJAMse4odTv6oA0SANV/bz316e2Kuzi7OUgnYj+E12EzePCwQi8OVnyUGvlG4IFrnTzhWp895qbR4AWuurRPxEHayQO5H2dPEKf5cgeyxQsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742304942; c=relaxed/simple;
	bh=vQCklNT3MLYMDCR8r1eT6hEx5fm1uXJTonPKDoQCfUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nGAwiAPnLEupiWpI3Xm4n50lNnYJLSBABYukykaxfbPHpagCuWreX+gxmy+jILVYBC0/cQboD1Vk+tTl7OFPhH3Ac7rc18g2kJ0TnbUzfNdOc2fbB/8evr/rRwJ7Ecy+sQLNcCXkDD5SEVwICkQIVTtSLxKmBtIU8glHckOKwrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XmvoX8my; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XmvoX8my"
Date: Tue, 18 Mar 2025 09:35:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742304937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AJSavv9AAl6r17rhxfE4NudnYaRJtifNbGjRQO2VazY=;
	b=XmvoX8myJxb5diITbcGBFJ161pnCWLDFsRhZHULyFZQBqdjNuOyIOWYLEwMVhhKNls/U3T
	k+lyxUu0nBO9qEDbbFzGgsD7hZo3JW2MPG2YHr/EYXjSe2b1I5ANvkZoT1t7Z8+csDJBpg
	hVxULC3LqWW2JMQluWURblbGnyr5f+0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Alan Huang <mmpgouride@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 2/2] bcachefs: Remove spurious smp_mb()
Message-ID: <rwpznwn3yj2y3ypjjpbm4hwahlmc4kigw4lv5u7qrsp4aiy2wy@ucqlvqfblqbv>
References: <20250318075001.1976165-1-mmpgouride@gmail.com>
 <20250318075001.1976165-2-mmpgouride@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318075001.1976165-2-mmpgouride@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 03:50:01PM +0800, Alan Huang wrote:
> The smp_mb() is paired with nothing.
> 
> Signed-off-by: Alan Huang <mmpgouride@gmail.com>

Applied

> ---
>  fs/bcachefs/journal.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
> index 8d4f3bfaa228..fc15644c9f24 100644
> --- a/fs/bcachefs/journal.c
> +++ b/fs/bcachefs/journal.c
> @@ -761,7 +761,6 @@ void bch2_journal_entry_res_resize(struct journal *j,
>  		goto out;
>  
>  	j->cur_entry_u64s = max_t(int, 0, j->cur_entry_u64s - d);
> -	smp_mb();
>  	state = READ_ONCE(j->reservations);
>  
>  	if (state.cur_entry_offset < JOURNAL_ENTRY_CLOSED_VAL &&
> -- 
> 2.48.1
> 
