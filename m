Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668A31DFD1
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729460465; cv=none; b=HDtMrBMPPTx02hoeU7SjBgAnvtsoy3gAbjjFh+kztakyIIbk360IEB6OexbM1HXWNPXAer0w1bwQbuMXK61D3HZfa21WR7HnhtnyG/Vj/4qd1CKIrj0PbWWdesHHfA0QSKeVws4rosQLONHtnQRdQr4SSEbIDAugySWCvX8yDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729460465; c=relaxed/simple;
	bh=G9LigEMa2BaVMk7D1r8PuZhJcy7klblt9ExoTv5XCAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tipeuhl2LmlxzHRX4r1tuiC+siyAkjrFyADe7iP7eVQWGOQr02DcScZvGfg4RvD2/qdA1jJbbUcnMzfGvBAuWfzUHqpzEcJIKWinE6yUjJrcMVZjlGQuJUg1UbUX2lC6zxa13FJZUAPinu9g9FHfzSbyYf1p7GPGNaYFWANazrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oREiYfM2; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oREiYfM2"
Date: Sun, 20 Oct 2024 17:40:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729460459;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O78mJ5Puv0eo89e0YAxj37dhhuMOGm/UqefbI9GPIUI=;
	b=oREiYfM2VF2rmGPYMb6/32WQUY2Nb7kROI1rkk/6cGlitmchyO0bH+zMUa8i+q0xl3cOEL
	nxqtRALaNh6Q+GnlFn9qhIkVqZHgqKHa39djZqPP2MzFnUJxBBIRtPbGyOhTWX5LoHwV+U
	uJxXK2GNXvHlU2HsPL9Jtpx5MOb2PCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <yp6bt4ux2nemboyytvv2vyd32em53gvcipty6xsqm7yfu7inoe@x4vrz4es2z25>
References: <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
 <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
 <CAHk-=wjQDCtzBUiRPuKfyjGFiR9JZi82ENyzdvKei4W3pxt=tA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjQDCtzBUiRPuKfyjGFiR9JZi82ENyzdvKei4W3pxt=tA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 02:21:50PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 13:54, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, 20 Oct 2024 at 13:30, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > Latency for journal replay?
> >
> > No, latency for the journaling itself.
> 
> Side note: latency of the journal replay can actually be quite
> critical indeed for any "five nines" operation, and big journals are
> not necessarily a good idea for that reason.
> 
> There's a very real reason many places don't use filesystems that do
> fsck any more.

I need to ask one of the guys with a huge filesystem (if you're
listening and have numbers, please chime in), but I don't think journal
replay is bad compared to system boot time.

At this point it would be completely trivial to do journal replay in the
background, after the filesystem is mounted: all we need to do prior to
mount is read the journal and sort+dedup the keys, replaying all the
updates is the expensive part - but like I mentioned the btree API
transparently overlays the journal keys until journal replay is
finished, and this was necessary for solving various bootstrap issues.
So if someone complains, I'll flip that on and we'll start testing it.

Fsck is the real concern, yes, and there's lots to be done there. I have
the majority of the work completed for online fsck, but that isn't
enough - because if fsck takes a week to complete and it takes most of
system capacity while it's running, that's not acceptable either (and
that would be the case today if you tried bcachefs on a petabyte
filesystem).

So for that, we need to be making as many of the consistency checks and
repair things that fsck does things that we can do whenever other
operations are touching that metadata (and this is mainly what I mean
when I mean self healing), and we need to either reduce our dependency
on passes that go "walk everything and check references", or add ways to
shard them (and only check parts of the filesystem that are suspected to
have damage). Checking extent backpointers is the big offender, and
fortunately that's the easiest one to fix.
