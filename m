Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB3A2F43
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729455060; cv=none; b=BWOsCugxMgWRoxIztqbWwzj4bEUw6WyTyhu/kr+lUBb8ebn35cS+dVIz1qGSPBgQuIqSxIrArq5dczfL4e4YdYgqEyfa36NumeozKlPu3X1myAEGC3pZYVY0+CGnFKiB+VakfJ3ZHWJMX+YC6eFQpwWrun+khkrXeO5lslTogzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729455060; c=relaxed/simple;
	bh=VI0a+N0yQCwmluEhV+XmzA4N3iwYITwLz/ODfctIRfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IMf1e/UgVV83HlmGgTOVvaiH+bxHBGawp2ykcpBVOAm8gOterKWz71g9bNW/VoM9NGphxRUv6k9PI5RC1dPBhrL1w/khnwgQDqfGXJjXXq/5WyWFfVLBa5PLOeGvbVt+0+5CNj6eOxkTeb2IPceHyyrgSohnVGt3LZkbuN0Lhq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NJVHQ6+v; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NJVHQ6+v"
Date: Sun, 20 Oct 2024 16:10:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729455054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8+WUrAZeDaIfbm/rwydenH45/8qy5IlgB9W6a1mjdNA=;
	b=NJVHQ6+v6yJzktHOsnTnuF8lJjdzyyIfznULlRHL5+tBOEzTsuVpyoRuIqyNMI90CtcZo/
	VfaOefsg9jg47fn19aWId97sxXNosr09NaBbfKLelH5ozJo5HCrIxVc/05qi45YAnCVbyU
	nOJvHSutEPMZ5WoX1k//rPfz9g1WlMU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 12:09:58PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 12:09, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > How about you limit the amount of memory you use in the first place instead?
> 
> .. and to clarify: we're not making other parts of the kernel less
> robust because *you* are doing something stupid and odd.

But back to the actual topic at hand, the security angle - while we
don't have ubsan style checks for integer truncation (the real concern),
we do have sysbot + kasan, which does cover this pretty thoroughly.

And the INT_MAX check wouldn't catch truncation anyways - it'd only
catch integer _underflow_, but allocation size calculations pretty much
as a rule never use subtractions, so I don't think this check was ever
worth much to begin with.
