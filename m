Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F01C6FF5;
	Wed, 26 Mar 2025 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743005396; cv=none; b=rioAXMg3xPs5dpl3ytMFZL2bj1KlB4zpcgZKMrsMcsuOhR5O93FUcPDnnlZv9n1RW9EhsHjYiVRbDIQ/DYGdnAw4NYOzyYDiNW4QslPu9X43xY7pY58Ke8hk9UKT9G4Wf0WneqzKcM1mqsU6PQinC30uGgY4FrQdwi85Rly9+Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743005396; c=relaxed/simple;
	bh=MOCIvUAI67RHgkKJXVSn6V8VoXiodu7Ha/2Vdh/L9as=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNM/P1nnc7xaqUNrnOil9az+GJ5fpJlsjlFud0yzdVBuENaCRzDO47M7qgZIvHU7wT//MYdRhdw7VkhutzXOxOECe5CFOdYW1MURjQTyPnnUQzHOM++mIT5cNFNVHuQYyw24PUNie9i206Sin1Rq3l6YY9aJ6zCm+XVfd1Y8Xr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=atT0kTqj; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="atT0kTqj"
Date: Wed, 26 Mar 2025 12:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743005390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oez36kKPstPwrWj7Etl2ct5h5B2/MI6TuHvQJIPj6pQ=;
	b=atT0kTqjILhG1GAsHck1trYBy+xksBcwzUD6FNIvKd/40X2CZCmbcS3OYXGSHdKOouQty9
	EhBgUpREWcfu7LKymHxZNY1Qgx+zRxFON9Xn+sNzC8sj/+JUMRapM2sKMUDMliO1HcT/tW
	YnO1LLc1oOrNJlaGKnNYngz4skO0fQA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib/sort.c: Add _nonatomic() variants with cond_resched()
Message-ID: <wbk6ewbqdxhlai2nmeqlrv7g45u5rdrv5hrtoqqkyq7x3gp7pg@uki35d366fe3>
References: <20250326152606.2594920-1-kent.overstreet@linux.dev>
 <Z+QjJxcnAkeGIbCT@visitorckw-System-Product-Name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z+QjJxcnAkeGIbCT@visitorckw-System-Product-Name>
X-Migadu-Flow: FLOW_OUT

On Wed, Mar 26, 2025 at 11:54:15PM +0800, Kuan-Wei Chiu wrote:
> On Wed, Mar 26, 2025 at 11:26:06AM -0400, Kent Overstreet wrote:
> > Andrew - if you're ok with this patch I'd like to get it in soon as a
> > bugfix, I've been getting quite a few reports on this one.
> > 
> > I don't much care for the naming though, thoughts there?
> > 
> > -- >8 --
> > 
> > bcachefs calls sort() during recovery to sort all keys it found in the
> > journal, and this may be very large - gigabytes on large machines.
> > 
> > This has been causing "task blocked" warnings, so needs a
> > cond_resched().
> > 
> > Cc: Kuan-Wei Chiu <visitorckw@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  include/linux/sort.h | 11 +++++++++++
> >  lib/sort.c           | 46 +++++++++++++++++++++++++++++++++++++++-----
> >  2 files changed, 52 insertions(+), 5 deletions(-)
> > 
> 
> I don't have strong opinions on this, but I recall that UBIFS had a
> similar issue with list_sort(), and they addressed it by calling
> cond_resched() within the compare function. Would that approach be
> simpler and more appropriate than introducing a new API in the library
> code?

That'd be an option, but it would be heavier; sort() has nested loops so
it has a more natural place to put it.

And I'd say the nonatomic scheduling version should likely be the
default, anyways; even if other users aren't hitting the 10 second
warning, going 1 second without scheduling isn't good.

Not going to audit all the existing callers, but we should probably
provide it.
