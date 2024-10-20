Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E443FB64A
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729451458; cv=none; b=ZwsBAxIoLE0eRXVcawXsyYWsBq0CZi9NcZUMqb5+vPwk/i+kaSVFm5ZGDtvip9pRSITPmw+gvRzEbtj5VguuLZhruHl9IGQ/RfgF7KUxW0RBNb+7GUCcXEkmH/C9YrcagneGkQRr9HnVDB8pZVWe7uPj/d78T03+TMcjJIEge2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729451458; c=relaxed/simple;
	bh=w6RD4HkoyotoaXKbtMMxYS6yJ0l6hzBQJcNOtVOzacw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k/sFlBKcJF2r41mjMbPimnZ8XGasvC4Gp2/y2UWAUHnQ1YfXbaJqhK6dmL+/FRpVRtX6OUqlvRjVQiqAj2Y3Mfu7JojvF61JjSLrbeksnlAOgEQu1sGqXUbhla2PuHtcSISWVfPXURcWD1Wv2I07eGJK8BEEORxAkHJWH9xbG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HXTEAD1H; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HXTEAD1H"
Date: Sun, 20 Oct 2024 15:10:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729451453;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pe6VA/eWg6CR22QgYCq4rGcK+R4NzZy7J78Mhkk5xuY=;
	b=HXTEAD1HsNRaKm5YnNqMkfZxuIhTwd/AYedOGgNhBPuEwzYf3K+CTlKG8LuMwsm8DKUf4v
	EvpRQ4ZCghz+wl0WGNd8rIcT6LFmT5YkwAVHKIEYrv8PUHjJduA7U0lezaXcRTGzoTSeN6
	Lf0jSaLwPpE8eKoQ+LL8X1Jm+bLwCAA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <i756neh3jhdq7f2v2a2ctbgrgt7dy2qnoanig7ps44lw4f2bvj@u5bzcykjxqug>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 12:09:02PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 11:53, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > This came up on a machine with 128GB of ram.
> 
> So?
> 
> Your argument is "we're using a ton of memory, so we can use a ton more".

Datasets are going to grow as machines grow, yes. Otherwise, what are we
building them for?

> How about you limit the amount of memory you use in the first place instead?

That'd be an artificial cap on performance.
