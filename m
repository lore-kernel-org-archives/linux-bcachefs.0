Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856F3381A0
	for <linux-bcachefs@vger.kernel.org>; Sun, 21 Jan 2024 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705854073; cv=none; b=gU6bYmgGkcN3N4aVeyWIZzGq5O9s20nsHShg8U0+Id3yV+xqoKE13sS7f4GoO85+U9TxU4LQ0aJjHlOdO7cyG+ZZqVvgWyR1YSkhDnQEoHDbXuRKR6Z7eoS3UWLceckkTzp/tWI62K5czN9/NzUhMKlagTKiLcA4NFTKYWarmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705854073; c=relaxed/simple;
	bh=yDdC5tBAxvzcikBB9KG2F8MDWDYpBOZB8Jo/oIKCNuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FV2hGAnec0zY9IO5PHWC1dTDF3SF/GdiAA7wTL0DXemtYccS8x8fqMs3m62L3eGk1Ot7yU4Ol/OrZYQl06SNqGkrjaoYuahJVqpYoA6PkPYb7lsD4+svkQyMRQDLz8OXxmjyo0hDdhnlCGX781btvcg5Vs8o5c3+lt44NFYaClQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KYnCihpF; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KYnCihpF"
Date: Sun, 21 Jan 2024 11:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705854068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e9ts6kn1ch6u/0ir7Mzbe1G7MWZ+8nRG72MIJ86Jeik=;
	b=KYnCihpFTfCsgFhHdxx/J8lV5FP+ligV+ws6saJxJOqBolHl83FMgwseDT26tN1g/SadEL
	do0v9oaqcP41dg1KkXfFVxm3cvHBWeT5c9UBGKUbP9iEp93gtFE8KCu1UW/YvDbw3O1fIg
	2zpUL4X4fQ2AzFfJjgbSrbw5FSP4F8Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, bfoster@redhat.com, jserv@ccns.ncku.edu.tw, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 0/5] Optimize number of comparisons for heap/heapsort
 implementaion
Message-ID: <nl6kvjxg4gia5pbfb4jibxusvavmlwumrvy3swfs33ciub32wt@2kmeqnqycxxh>
References: <20240121153649.2733274-1-visitorckw@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240121153649.2733274-1-visitorckw@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jan 21, 2024 at 11:36:44PM +0800, Kuan-Wei Chiu wrote:
> Hello,
> 
> The existing implementations of heap/heapsort follow the conventional
> textbook approach, where each heapify operation requires approximately
> 2*log2(n) comparisons. In this series, I introduce a bottom-up variant
> that reduces the number of comparisons during heapify operations to
> approximately log2(n), while maintaining the same number of swap
> operations.
> 
> Thanks,
> Kuan-Wei
> 
> Kuan-Wei Chiu (5):
>   bcachefs: Optimize eytzinger0_sort() using bottom-up heapsort
>   bcachefs: Introduce parent function for sort_cmp_size()
>   bcachefs: Optimize sort_cmp_size() using bottom-up heapsort
>   bcachefs: Optimize number of comparisons in heap_sift_down
>   bcache: Optimize number of comparisons in heap_sift
> 
>  drivers/md/bcache/util.h |  23 +++++----
>  fs/bcachefs/util.c       | 109 ++++++++++++++++++++++++++-------------
>  fs/bcachefs/util.h       |  23 +++++----
>  3 files changed, 98 insertions(+), 57 deletions(-)

Good stuff

While we're looking at this code, we should be doing some cleanup too -
there's no reason for the heap code to be duplicated in bcache and
bcachefs anymore, and it'd also be nice to get fs/bcachefs/eytzinger.h
moved to include/linux and bcache converted to use it.

I also would not be surprised if there's another heap implementation in
include/linux; we'll want to check for that and if there is decide which
is worth keeping.

Would you or Coli be interested in taking that on as well?
