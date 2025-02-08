Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D33241129
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 18:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739038159; cv=none; b=kXXkpJHuGpiZlBgkunR6aljDSo22k57WjCWu6GP5cYMRwpjGoakQYnbcOnYvlzFu7o+Nwlc2ox78R669I97heabQkhKCuI4N6pif1LMZPPTO787bK7zJERR/x0qu7swczFjHz+DqY1BkIF0smedbAiHqPXGqlh9iSJ4LMSgenVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739038159; c=relaxed/simple;
	bh=TlZHGQlD8pBpsmEg099cD8SmdqBzUCW6hYBlQSEgb+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=euQ95sVX+U7m+0bOBFgerPkOk0pLeH2zTvzP9mTjG+DR+9cu1dQOIjKiqDgWfRalKJp/cicwOo7ysARE0gIliSRAZeBzIUY6CT55DWstBNa++Q3zUxvEJaU03kvF4IlnPpjtyh+XH/cSghYtYVysMzSKTXV2Z1q2UBowYhfRbPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=w784MNNd; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w784MNNd"
Date: Sat, 8 Feb 2025 13:09:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1739038151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jZthaIofDN6aphSJXBymk5TwGHbsIThrT3nQS73QIeM=;
	b=w784MNNdCB8DfAGdRWc3/qtKuE90FJs27nfOaLVPo4Dpc9hCXsauDksDSuYIAcidOgJy6B
	Yhwz9081z5YHpmpyt5z3KYjBco1fAibhTA2PLO2fwkEmBEgDLQZbA8OGaWZCTMS1olGKcj
	BAFGmvB2R8krsXslwdvNbFd28o5GenI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 00/21] bcachefs: eytzinger code
Message-ID: <cwcbgdj36zs3rrjcwcjpb6zmx6e23ogfgwpfeppcokrnk775ec@jxs5l5lfhacl>
References: <20250208110119.546961-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250208110119.546961-1-agruenba@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Feb 08, 2025 at 12:00:57PM +0100, Andreas Gruenbacher wrote:
> Kent,
> 
> here is another update.  Changes:
> 
> * Added a self test for eytzinger0_find().
> 
> * The patches are now in fully bisectable order, with slightly improved
>   patch descriptions.
> 
> * The patch that runs the self tests on modprobe has been moved to the
>   end of the patch queue.  This patch is useful for testing, but it
>   SHOULD NOT BE MERGED.
> 
> 
> A git tree of the patches can again be found here:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/agruen/linux.git/log/?h=bcachefs
> 
> Base: v6.13
> Head: d79258df8791 ("bcachefs: Run the eytzinger tests on modprobe")
> 
> 
> The previous CI test results at:
> 
>   https://evilpiepirate.org/~testdashboard/ci?user=kmo&branch=eytzinger
> 
> against the previous version of this patch queue and with head:
> 
>   94865378e1a3 ("bcachefs: eytzinger1_{next,prev} cleanup")
> 
> show a large number of passed as well as failed tests even for upstream
> v6.13, so I don't know what to conclude from that.
> 
> In any case, there is one failure reporting that eytzinger0_find_ge()
> didn't find the first matching element in an array with duplicate
> elements:
> 
>   https://evilpiepirate.org/~testdashboard/ci?user=kmo&branch=eytzinger&commit=c31c7c659278bc2581ef0c7c4119fe14c7476ea3
> 
> This is imtentional and expected because at this point in the patch
> queue, eytzinger0_find_ge() hasn't been fixed to always return the first
> matching element.  The current version of the patch queue adds the fix
> before adding the test, so this failure will be gone.
> 
> That being said, as per request, the updated patch queue only enables
> the self tests in the last patch, so we wouldn't see failures of that
> kind anymore, anyway.

Thanks! Applied to my master & for-next branches.
