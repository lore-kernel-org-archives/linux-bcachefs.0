Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683768460
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730059100; cv=none; b=sjO0hehaWwd2aY1ELJO5/KhHknsrRfpf3WBLcTJQtNyNMJZ9jiNj6UbDI0XMeV5IdbYl8sT++tYW1IMaRkZ1NnnnP1fb0YKocPP998hTPLsMKXdjUwNuxV+2kQWALJsDEgXwyfDY7SHQWE6QcSNTRgvuGdpDS9TLNbNEi/AEY6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730059100; c=relaxed/simple;
	bh=8bE01uUBLzFJ4PrLpVxfeHVNDk2HpZahgtSel7W0b/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYx8z24w4ATJNFBhz3gpDqZbMIlKZ5ceVs0bnWdVdFMqI+TEi713AMcMsx2fIVjhUMnFwf3W9uUH9csoS2etwjTWW4+hNJTkrXyG2uDIqk0fG43K1pi/piO4VfoXPPYp2oPlXbNPq/YysKWmUCHX81sLpKunntkhw1BibwggSsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dR/OPLl4; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dR/OPLl4"
Date: Sun, 27 Oct 2024 15:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730059095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jl9RE+0N8YfJ1XW1XaPbXD0GLkglTkP7Mz1u51Q5s38=;
	b=dR/OPLl47aKrncYYRCAx9bV0BcETFA8FZrlmxQdGTsYgqFEzVPEqyiB5XKMIDaMiXyiS9D
	7byBKaC4s9E+jfLi4BPsGm+MPtuOFNbOOZKqM3sNx9M8w5DuFDuoAEnEt0mtDLaApSZjBB
	BDyOVHUWpJz82smsUY0VTbL4gTF8JKA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	linux-bcachefs@vger.kernel.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: Drop INT_MAX limit from kvmalloc()
Message-ID: <la4btdzbgouyyyggx2h67keldt4ak5mhbn3huxygwpa5tooh5w@dutiusw5jz6n>
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
> There's a very real reason many places don't use filesystems that do
> fsck any more.

So fsck has been on my mind a lot lately - seems like all I'm working on
lately is fsck related things - incidentally, "filesystems that don't
need fsck" is a myth.

The reason is that filesystems have mutable global state, and that state
has to be consistent for the filesystem to work correctly: at a minumum,
global usage counters that have to be correct for -ENOSPC to work, and
allocation/free space maps that have to be correct to not double
allocate.

The only way out of this is to do a pure logging filesystem, i.e. nilfs,
and there's a reason those never took off - compacting overhead is too
high, they don't scale with real world usage (and you still have to give
up on posix -ENOSPC, not that that's any real loss).

Even in distributed land, they may get away without a traditional
precise fsck, but they get away with that by leaving the heavy lifting
(precise allocation information) to something like a traditional local
filesystem that does have that. And they still need, at a minumum, a
global GC operation - but GC is just a toy version of fsck to the
filesystem developer; it'll have the same algorithmic complexity as
traditional fsck but without having to be precise.

(Incidentally, the main check allocations fsck pass in bcachefs is
directly descended from the runtime GC code in bcache, even if barely
recognizable now).

And a filesystem needs to be able to cope with extreme damage to be
considered fit for purpose - we need to degrade gracefully if there's
corruption, not tell the user "oops, your filesystem is inaccessible" if
something got scribbled over. I consider it flatly inacceptable to not
be able to recover a filesystem if there's data on it. If you blew away
the superblock and all the backup superblocks by running mkfs, /that's/
pretty much unrecoverable because there's too much in the superblock we
really need, but literally anything else we should be able to recover
from - and automatically is the goal.

So there's a lot of interesting challanges in fsck.

- Scaling: fsck is pretty much the limiting factor on filesystem
  scalability, If it wasn't for fsck bcachefs would probably scale up to
  an exabyte fairly trivially. Making fsck scale to exabyte range
  filesystems is going to take a _lot_ of clever sharding and clever
  algorithms.

- Continuing to run gracefully in the presence of damage wherever
  possible, instead of forcing fsck to be run right away.

  If allocation info is corrupt in the wrong ways such that we might
  double allocate, that's a problem, or if interior btree nodes are
  toast that requires expensive repair, but we should be able to
  continue running with most other types of corruption. That hasn't been
  the priority while in development - in development, we want to fail
  fast and noisily so that bugs are reported and the filesystem is left
  in a state where we can see what happened - but this is an area I'm
  starting to work on now.

- Making sure that fsck never makes things worse

  You really don't want fsck to ever delete anything, this could be
  absolutely tragic in the event of any sort of transient error (or
  bug). We've still got a bit of work to do here with pointers to
  indirect extents, and there's probably some other cases that need to
  be looked at - I think XFS is ahead of bcachefs here, I know
  Darrick has a notion of "tainted" metadata, the idea being that if a
  pointer to an indirect extent points to a missing extent, we don't
  delete it, we just flag it as tainted: don't log more fsck errors,
  just return -EIO when reading from it; then if we're able to recover
  the indirect extent later we can just clear the tainted flag.

We've got some fun tricks for getting back online as quickly as possible
even in the event of catastrophic damage. If alloc info is suspect, we
can do very quick pass that walks all pointers and just marks a "bucket
is currently allocated, don't use" bitmap and defer repairing or
rebuilding the actual alloc info until we're online, in the background.
And if interior btree nodes are toast and we need to scan (which
shouldn't ever happen, but users are users and hardware is hardware, and
I haven't done btrfs dup style replication because you can't trust SSDs
to lay writes out on different erase units) there's a bitmap in the
superblock of ranges that have btree nodes so the scan pass on a modern
filesystem shouldn't take too long.
