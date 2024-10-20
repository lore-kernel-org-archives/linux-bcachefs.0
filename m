Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C42173
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729443845; cv=none; b=F+OHDjfZlG06BpNR8F69+5M5ym5Yd0tZkrS6YigQDU/grqDllnPawWHm1cbKQ+9kSZifwNIuCCX0QeBYFmRxAkdw6uWd6nQN73lRXP3WQ7TYp93tQR8IwqXqJzViTrcH3PHkLV6uDwX1bAg6p615pWT0P/maM26kTW96EOFYlPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729443845; c=relaxed/simple;
	bh=b7DQ8V9V21PvzOoEqXVXREPrY2ZkPBYAoTF1zX/aYh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kS8fMErR0HA72ngvbaoZVGz4sxXvEWHbU8iTui++22Q3eTfDlACzJtgZVsMLwvfPy/QHEAv7V0vRB4b9mkXmYn1X9EKNhiU0kRPI5DMXpwaXl+PxVBQd8gnhfzyp4U0WKwz00LC+W85t2Y2dodCYAozMDbsC8WKpHjIPyR9KqUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j4VxDE8o; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j4VxDE8o"
Date: Sun, 20 Oct 2024 13:03:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729443840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uw3xUFK25TlZ9Go2lt1IJL62U2UkNYtZDEVjz3Sg4H0=;
	b=j4VxDE8ogvW0AMlOwC2lxb/0oYjRiAhaBhU9HbgmlKkW7xTWgPaHkXJIhVdEM7tSoS38z0
	bdYfwlaNuuC85Cn0SVJJqihS545RNBOiXTDW4qBQmaeyZdze8YfkvcF3MPJq8ChrS4X9N+
	5XLKDvLJEfoW859cRDzG69S6fbz4YKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 05:44:37PM +0100, Lorenzo Stoakes wrote:
> +cc Linus, vmalloc reviewers
> 
> On Sun, Oct 20, 2024 at 09:00:07AM -0400, Kent Overstreet wrote:
> > On Sun, Oct 20, 2024 at 12:45:33PM +0100, Lorenzo Stoakes wrote:
> > > On Sat, Oct 19, 2024 at 05:00:37PM -0400, Kent Overstreet wrote:
> > > > A user with a 75 TB filesystem reported the following journal replay
> > > > error:
> > > > https://github.com/koverstreet/bcachefs/issues/769
> > > >
> > > > In journal replay we have to sort and dedup all the keys from the
> > > > journal, which means we need a large contiguous allocation. Given that
> > > > the user has 128GB of ram, the 2GB limit on allocation size has become
> > > > far too small.
> > > >
> > > > Cc: Vlastimil Babka <vbabka@suse.cz>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
> > > > ---
> > > >  mm/util.c | 6 ------
> > > >  1 file changed, 6 deletions(-)
> > > >
> > > > diff --git a/mm/util.c b/mm/util.c
> > > > index 4f1275023eb7..c60df7723096 100644
> > > > --- a/mm/util.c
> > > > +++ b/mm/util.c
> > > > @@ -665,12 +665,6 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> > > >  	if (!gfpflags_allow_blocking(flags))
> > > >  		return NULL;
> > > >
> > > > -	/* Don't even allow crazy sizes */
> > > > -	if (unlikely(size > INT_MAX)) {
> > > > -		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
> > > > -		return NULL;
> > > > -	}
> > > > -
> > >
> > > Err, and not replace it with _any_ limit? That seems very unwise.
> >
> > large allocations will go to either the page allocator or vmalloc, and
> > they have their own limits.
> 
> Ah actually I misread it here, I see the allocation gets immediately sent
> off to __kmalloc_node_noprof() and thus that'll apply its own limits before
> doing this check prior to the vmalloc call.
> 
> We actually do have a basic check in __vmalloc_node_range_noprof() that
> prevents _totally_ insane requests, checking that size >> PAGE_SHIFT <=
> totalram_pages(), so we shouldn't get anything too stupid here (I am
> thinking especially of ptr + size overflow type situations).

Yep, exactly.

> But Linus explicitly introduced this INT_MAX check in commit 7661809d493b
> ("mm: don't allow oversized kvmalloc() calls"), presumably for a reason, so
> have cc'd him here in case he has an objection to this which amounts to a
> revert of that patch.

Ah, thanks for adding him.

Yeah, the concern historically has been that integer truncation bugs are
really nasty and entirely too common, and we have little in the way of
tooling that can catch that.

Unfortunately that's still the case today. Kees has been doing work on
catching integer overflow, but I don't think we have anything coming yet
for catching integer truncation.

But given that vmalloc() already supports > INT_MAX requests, and memory
sizes keep growing so 2GB is getting pretty small - I think it's time,
this is going to come up in other places sooner or later.
