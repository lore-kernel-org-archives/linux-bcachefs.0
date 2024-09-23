Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C45F1CA84
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 19:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727121419; cv=none; b=FoNbdEE+ko9rmuIZGquc8uUVZmGxEcRKbHfFm0XP39mWw0Deact/iZA9NI3ReAPI7AKLrv1Xh0UsF1uGgYoaBOBjI2irIVHyLTgPfxxfnq87DYj2orCb/8Cyu3pJdcNGAe2QccukmMqlFTm6FQW03NOHTwJgSuhEqbPsGpb2wEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727121419; c=relaxed/simple;
	bh=yioyKrHUsrhpPPufYVkl6oLIP1GDj9d1PKWTIrF1+zA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spUCo/nEayrCTeNAgxPrkgqNQ1QbWJFPRouaPwu8slRW95IabhJs8uYNGw2G9uvjDKsx2Khxu81atlrtE48rqOsao4xFGy86GYXpLKnP93Z36OM1spggE1EIql+Nwa7pSFSenHrWWn0iVd9Y10Of8qDK/v14cuEgkNpdfvNDLLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hH0lD9XK; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hH0lD9XK"
Date: Mon, 23 Sep 2024 15:56:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727121415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3e4DCekOHk5Rai6aJWYF2CY+CpXsl/gUdUFSHk9AhaQ=;
	b=hH0lD9XKymoDizKVyS5DIxZfDl7bMP0NwKRvN4Jo5JH9x012Bu3UVZM2LIje/hA5yKVInH
	sQDlqZrhTeIZlOLrqUCwyvjb7FK/tKiH+3xB54YGHJ9aXA6qmIg9HNkJ/xd/rgR8WGc4hI
	yyazIzMSA/IgXZkiEc04luPcKVYg8Q0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [GIT PULL] bcachefs changes for 6.12-rc1
Message-ID: <6vizzdoktqzzkyyvxqupr6jgzqcd4cclc24pujgx53irxtsy4h@lzevj646ccmg>
References: <dtolpfivc4fvdfbqgmljygycyqfqoranpsjty4sle7ouydycez@aw7v34oibdhm>
 <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whQTx4xmWp9nGiFofSC-T0U_zfZ9L8yt9mG5Qvx8w=_RQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 23, 2024 at 10:18:57AM GMT, Linus Torvalds wrote:
> On Sat, 21 Sept 2024 at 12:28, Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > We're now using an rhashtable instead of the system inode hash table;
> > this is another significant performance improvement on multithreaded
> > metadata workloads, eliminating more lock contention.
> 
> So I've pulled this, but I reacted to this issue - what is the load
> where the inode hash table is actually causing issues?
> 
> Because honestly, the reason we're using that "one single lock" for
> the inode hash table is that nobody has ever bothered.
> 
> In particular, it *should* be reasonably straightforward (lots of
> small details, but not fundamentally hard) to just make the inode hash
> table be a "bl" hash - with the locking done per-bucket, not using one
> global lock.

Dave was working on that - he posted patches and it seemed like they
were mostly done, not sure what happened with those.

> But nobody has ever seemed to care before. Because the inode hash just
> isn't all that heavily used, since normal loads don't look up inodes
> directly (they look up dentries, and you find the inodes off those -
> and the *dentry* hash scales well thanks to both RCU and doing the
> bucket lock thing).
> 
> So the fact that bcachefs cares makes me go "Why?"

I've seen benchmarks (not just on bcachefs, ext4 as well) where it was
actually _really_ heavy. They were synthetics, but I'd expect to see the
same effect from workloads where we're streaming a lot of inodes through
the cache - think rsync.

Another data point is that the btree key cache work I just did was also
for exactly this type of situation - it addressed lock contention when
streaming items into and out of the key cache, which are mostly inodes
(it's also used for the alloc btree) - and I had reports from multiple
users it was a drastic improvement, much more than expected, and
eliminated the main source of our "srcu lock held too long" warnings -
and if lock contention is bad enough to trip a 10 second warning, you
know it's bad, heh.

I try to really jump on these sorts of lock contention issues because
I've seen many instances where they caused performance cliffs - in
practice they're often O(n^2) issues because as your workload scales up
it's usually not just number of instances where you take the lock that
increases, usually something else is scaling too - even just increased
cacheline bouncing from the lock contention itself will be problematic.
