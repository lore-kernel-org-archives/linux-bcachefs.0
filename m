Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC7117D2
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729429218; cv=none; b=WrbDKXtskF1D7yWTdJEEsyKcWzyoHUpcfvn5E7t5/q2T16RbgJDl67hBUwN+gBMrvj89HJO5TFBeNoatmCnPKoEoRIfNLpy2XK+XPnyYxpsgBCHxRVRlKQAFNL1CcaokFnKOlloJe9UzySELdGJ6i3JX9JObUmwNkVPxc3+HkKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729429218; c=relaxed/simple;
	bh=h63vBvspCrLXGY1ZYTywuJOKQMeDC0mgYRViWlcc9io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xx0wBMYlL/+wNjsGKNy6/tXShXsslus47SDdseZmut1EAqQ/jEpk5TFCL50vFHgc2FaVVoevGYQK/zNulMmdzoP007zhRB32QBFdVSeEmdnpZfwwtNdcAqJupnNcfpiHMZGaHZKi90ZiB609c82EiNThsGYzT2qPfp/1c3K91G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lcyRAnpo; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lcyRAnpo"
Date: Sun, 20 Oct 2024 09:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729429211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fKTO3aGRhIuhtX4NJIjSDqESRx2aC0y8FrcibKpdSIM=;
	b=lcyRAnpoiBD94/wQMCv0kAfHEnMX3SQPWt2IBwEGpmx2qGIgccHoxOfOCboCLMFBzvjL77
	3xG031qTwomz2TWQZA7WszgKxh6u0HUtmFvMiz1ckJabuiax5s+Y/4R1WIpPSqFDrKl+D0
	n9RhGcz4maEdiF1HUoc1PG6u80ClriI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 12:45:33PM +0100, Lorenzo Stoakes wrote:
> On Sat, Oct 19, 2024 at 05:00:37PM -0400, Kent Overstreet wrote:
> > A user with a 75 TB filesystem reported the following journal replay
> > error:
> > https://github.com/koverstreet/bcachefs/issues/769
> >
> > In journal replay we have to sort and dedup all the keys from the
> > journal, which means we need a large contiguous allocation. Given that
> > the user has 128GB of ram, the 2GB limit on allocation size has become
> > far too small.
> >
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > ---
> >  mm/util.c | 6 ------
> >  1 file changed, 6 deletions(-)
> >
> > diff --git a/mm/util.c b/mm/util.c
> > index 4f1275023eb7..c60df7723096 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -665,12 +665,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> >  	if (!gfpflags_allow_blocking(flags))
> >  		return NULL;
> >
> > -	/* Don't even allow crazy sizes */
> > -	if (unlikely(size > INT_MAX)) {
> > -		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> > -		return NULL;
> > -	}
> > -
> 
> Err, and not replace it with _any_ limit? That seems very unwise.

large allocations will go to either the page allocator or vmalloc, and
they have their own limits.

although I should have a look at that, and make sure we're not
triggering the > MAX_ORDER warning in the page allocator unnecessarily w
hen we could just call vmalloc().
