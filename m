Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D353193425
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729450440; cv=none; b=rbSpD7d53SHkZby1uhhCq2U4BdVaax1MS19/oZEeZ1kYI/In1rfnVPxlegzgUGziSxAcvLtl6B+rxmgMpLYNOd86v9Xw9Q3L2+gLqMNYy72i6FjRXpPjlGesoXHcOjjAQtatXij+7cFKmxIdCoHY7a0MiOD26FvjxToLvVJyJrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729450440; c=relaxed/simple;
	bh=RMGfGbWGRSKaof+xJGvInP8h0PRUFrmT9ymCvzOqlE4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ImrX/vj4f9v5fPrroPgL5G/Sc0n1xlqhLZbuCreQWTwhwUlYYYLDxXbS2lvfGJStBNHAdjzjsTkyrKbqgK6g6Ehr7q1sBV3C0PgrSbXH6efnRZFOC5d1TXcvPklCiqlRMZhFKFK04xkhyZk1UEdgAACaZjSrp9Kj5Nz3H7HgO1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HQEtbAp2; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HQEtbAp2"
Date: Sun, 20 Oct 2024 14:53:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729450435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=88nKpjSii+8FZBtg4/D+7ialdSkZyzZjLExZxeMz0+U=;
	b=HQEtbAp2YII6KOCVbkhQnqSll79ia4rsR4rQ0zM5XKRYQzMsNI28ELPmCtcwNCiqq11hye
	6hrBbn7S7Yp1dDXKn0uz55NuahiT35+5FnLDhuiOILOMZBJrowGgJSEeVWdcvDCkPqXMTd
	Wd3mtzwlt/swTU4zp6KaVyf0tsWJitI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
References: <20241019210037.146825-1-kent.overstreet@linux.dev>
 <90bc0794-4cab-415f-a442-4af85a32eed8@lucifer.local>
 <ucbcmk4kr7tbvj6uqnjke5662kerawbr4ghtlbw4zim7mdm3fg@vjawfne5rdkp>
 <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 11:46:11AM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 10:04, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > But given that vmalloc() already supports > INT_MAX requests, and memory
> > sizes keep growing so 2GB is getting pretty small - I think it's time,
> > this is going to come up in other places sooner or later.
> 
> No.
> 
> If you need 2GB+ memory for filesystem operations, you fix your code.

This is for journal replay, where we've got a big array of keys and we
need to sort them.

The keys have to fit in memory (and had to fit in memory previously, for
them to be dirty in the journal); this array is just _references_ to
those keys.

> 2GB is more than you *can* allocate on 32-bit platforms, and even on
> 64-bit ones it is often quite a lot.

This came up on a machine with 128GB of ram.
