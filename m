Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBCB2F43
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 21:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729459762; cv=none; b=IlOLwyaxSmbDfcKoA3pGc7AJ6jWUJxBsE20n9tfaCd51yvPNWJhOY7SPYMs9D/YPxg5fJk+2117UYVM6Ho+a3LrJRXomqWmg/LNDe10FKj+4vZ9ySqYMDpX10QraZfTfwVKtxxdfOvsuVKWYEcsK9TugrQAf9KcZdz88TLOuXpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729459762; c=relaxed/simple;
	bh=BMvgOYcJ+pKuxW+WDR3U+FEvmlNNyO7BTbakG337yYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i7WObb6hXQZJqDXOGeytx644wcBtvFFUGhDZeyhRxoHM6++WdZ0ZcEoRGwa1ltNZeLbSnuyel8QPu5DIKn4lLrWSkXk/6R79/AGhTUogU1lrMirNf/VNq62s1xGSD8KTf43h7QpvfmCKzfS/0sYXYtqsoyLf4FfnatywuTPrnB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RQADfpaJ; arc=none smtp.client-ip=91.218.175.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RQADfpaJ"
Date: Sun, 20 Oct 2024 17:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729459752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H+x1QYWsKIp+/U+DoH74I4GoWs22ZXBV1HmFZFT8djc=;
	b=RQADfpaJF+2TXDO5NdSVmDQSbpPrrwULz8iwL10zEJdaQ6jJi8w4SOCmFxjl0H9Er64Ke/
	WNdqggYOS6Jv4PuKOaX1I6giVe6kur1wGpMZZgQu/RWZpmf+xbcTd9vWX9PS29r9JWLa6g
	gUJ7qnFYMwDZEPAh74CbBD51pYQi7j4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <zsx7jruj2lefbippol3zgagkw3sk33pgli476y2rumq3k25xkm@rt6ady5gnkrv>
References: <ebe58a08-2371-403c-a0d7-6280160b6848@lucifer.local>
 <zfr4sh3wtzi4viladlgwyon6voqhcj5fe3fv2nc3hqyyxdw5wd@onyj3r2m3usz>
 <CAHk-=wi=PrbZnwnvhKEF6UUQNCZdNsUbr+hk-jOWGr-q4Mmz=Q@mail.gmail.com>
 <m46mlvv57oypstekojhkdwpts6mi4r63l4kugs4lpry3d2r7dq@kbmied6nzsc3>
 <CAHk-=wg8iZWDbX_MAujGtqHJYQneKBwDJnVAY94siNr1gLmtaA@mail.gmail.com>
 <CAHk-=wiW_QZ9VS3Ho2Ff8ZDp-T6SomDFrVPWG3abs45LMZpxZQ@mail.gmail.com>
 <6eo3gekf6twbnzhpsi2emz2s6sgtof6iba2rvbor7himmejoq5@qbfwtpbpvqoe>
 <CAHk-=wga3FXReWVhU2eid8+sXhBF1QgP1iMJu1jnSX6fapoyXQ@mail.gmail.com>
 <ikaf72w2oap3crjrybbd5jp267slnb7dygz4m62dfw3edu2ppj@f7dv2qdx3yga>
 <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wggLED-UmxS0gXrtOXBVWexCkyudYCr5zXNh8p5PB9bng@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 01:54:17PM -0700, Linus Torvalds wrote:
> On Sun, 20 Oct 2024 at 13:30, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > Latency for journal replay?
> 
> No, latency for the journaling itself.
> 
> You're the one who claimed that a 2G cap on just the *index* to the
> journal would be an "artificial cap on performance" when I suggested
> just limiting the amount of memory you use on the journaling.

That's the same as limiting the amount of dirty metadata.

Any filesystem wouldn't want an artificial cap on dirty metadata,
because so long as it's dirty you can buffer up more updates, but for
bcachefs it's a bit different.

Btree nodes are log structured: this was a dumb idea that turned out to
be utterly brilliant, because it enabled eytzinger search trees, and
because pure b-trees and pure compacting data structures (the leveldb
lineage) have weakness. Pure b-trees (with a more typical 4k node size)
mean you have no opportunity to compact random updates, so writing them
out to disk is inefficient. The compacting data structures solve that at
the cost of terrible multithreaded update performance, and the resort
overhead also in practice becomes quite costly.

So, log structured btree nodes mean we can _reasonably_ efficiently
write out just the 4k/8k/whatever out of a 256k btree node - i.e. we can
spray random updates across an enormous btree and serialize them with
decent efficiency, and because the compacting only happens within a
btree node it doesn't destroy multithreaded update performance, the
resorts are much cheaper (they fit in cache), and we get to use
eytzinger search trees for most lookups.

But: it's still much better if we can do btree node writes that are as
big as possible, for all the obvious reasons - and journal size is a
major factor on real world performance. All the performance testing I do
where we're filling up a filesystem with mostly metadata, the first
thing the tests do is increase the journal size...

> Other filesystems happily limit the amount of dirty data because of
> latency concerns. And yes, it shows in benchmarks, where the
> difference between having huge amounts of data pending in memory and
> actually writing it back in a timely manner can be a noticeable
> performance penalty.

Well, ext3 historically had major architectural issues with journal
latency - I never really studied that but from what I gather there were
lots of issues around dependent write ordering. bcachefs doesn't have
any of that - broadly speaking, dirty stuff can just be written out, and
i.e. memory reclaim might flush dirty btree nodes before the journal
does.

(The one exception being interior nodes that have pointers to btree
nodes that have just been created but not yet written).

The only real latency concern we have with the journal is if it fills
up entirely. That will cause latency spikes, because journal reclaim has
to free up entire buckets at a time. They shouldn't be massive ones,
because of the lack of dependent write issues (journal reclaim itself
can run full tilt and won't be getting blocked, and it starts running
full tilt once the journal is more than half full), and with the default
journal size I doubt it'll happen much in real world usage.

But it is something people looking at performance should watch for, and
we've got time stats in sysfs for this:
/sys/fs/bcachefs/<uuid>/time_stats/blocked_journal_low_on_space

Also worth watching is 
/sys/fs/bcachefs/<uuid>/time_stats/blocked_journal_max_in_flight

This one tracks when we can't open a new journal entry because we
already have the max (4) in flight, closing or writing - it'll happen if
something is doing constant fsyncs, forcing us to write much smaller
journal entries than we'd like. That was coming up in conversation the
other day, and I might be doing another XFS-like thing to address it if
it starts becoming an issue in real world usage.

If latency due to the journal filling up starts being an issue for
people, the first thing to do will be to just resize the journal (we can
do that online, and I might make that happen automatically at some
point) - and if for some reason that's not an option we'll need to add
more intelligent throttling, so that the latencies happen bit by bit
instead of all at once.

But the next thing I need to do in that area has nothing to with
throughput: a common complaint has been that we trickle out writes when
the system is idle, and that behaviour dates from the days when bcache
was designed for servers optimized for throughput and smoothing out
bursty workloads. Nowadays, a lot of people are running it on their
desktops or laptops, and we need to be able to do a "rush to idle" type
thing.

I have a design doc for that I wrote fully a year ago and haven't gotten
to yet... https://github.com/koverstreet/bcachefs/commit/98a70eef3d46397a085069531fc503dae20d63fb
