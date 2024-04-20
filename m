Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF16CA32
	for <linux-bcachefs@vger.kernel.org>; Sat, 20 Apr 2024 02:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713578531; cv=none; b=phqmCX/4Mux9HO4uwTw8zHxJVDWCRj3LmrVx9F38JqsxtfdfpA89cpfF9Ixegj/wJ4yu5RSiG7MeEseLautSW2ZSImyFrNWdxgw45bRhDZ2GZUvxNHGRM1wkRMSjrHSTRVj1HjijJphSWQCX9sd2jZ284iyCogeDeE1clgHyqMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713578531; c=relaxed/simple;
	bh=6XNCcwKth7yvvw9OQq+HIBbfBCa6PvjjHHqlGRmbdBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s0eZ0k7SpxcA/HPzIzMmELooaJ2O9+bQKiw9+NBeZMimNH25rl09UGBEgnmpBG3yk0xpKgArhH4ihnTzrroo96mMr0p5bY+wSZdQ51s/OLA/0OwNbGp4nimSP156h5RoxBYLwYkf7BvO9LLF/g9A+d1g6FU+fT3kkNbuZ20o4rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ao2P/6Pa; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ao2P/6Pa"
Date: Fri, 19 Apr 2024 22:02:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1713578528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7II7UynI5MHCNCZjvVL6A2rjQJ304jI8YNfRFOQn6TE=;
	b=ao2P/6PaqcZbzTFOX7d0KuWESyeYrpwCONa1KshJiEQIJoumcD0Fbknp9DqhwBeJZs27/q
	gUE5z9cQLPmGPnICCbaMD7vn6KazxCDwuiy47rTf92Jbsy/MhYJcmxcCtaIsQF/xOho8LN
	4cKnod9jaRYStin8bRUOoCqU25FSgWA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH v3 4/4] bcachefs: add fiemap delalloc extent detection
Message-ID: <beal6cp4ekfzyonwlwy2cjuxuvugnt5dl5x6vyyxumxua43fno@i5v2tanc42wp>
References: <20240408144846.1001243-1-bfoster@redhat.com>
 <20240408144846.1001243-5-bfoster@redhat.com>
 <ZiEyPYV52CKVpOpS@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZiEyPYV52CKVpOpS@bfoster>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 18, 2024 at 10:46:21AM -0400, Brian Foster wrote:
> So Kent had pointed out in an earlier chat that this needs to be a
> little more robust wrt to transaction restart because there is the
> potential for spinning under folio lock contention. I think there are a
> couple ways to do this that don't necessarily require reworking a bunch
> more of this code. One is to simply run a serialization sequence where
> we drop trans locks, run a blocking pagecache scan, and then restart
> this particular iteration of the loop to account for the fact that the
> extent btree may have changed since the btree locks were dropped.

The problem there was using bch2_trans_unlock() and relock() (basically
you were doing an open coded drop_locks_do()) without first attempting a
nonblocking version of the thing in the do.

drop_lock_do() has to be a slowpath thing; if it's something you always
do in a given transaction it causes livelocks.

the "try nonblocking; then drop_locks_do()" pattern works well because
for most use cases (allocating memory, taking a lock), if we end up
calling trans_unlock(), doing the blocking do, and then take a
transaction restart, the success of the blocking do means the
nonblocking do will likely succeed on the next iteration.

> When thinking about that, it occurred to me that this is roughly
> equivalent to the TOCTOU nature of fiemap in general, where we may or
> may not have caught a delalloc extent before or after it was written
> back. Therefore, it seems reasonable to just do the lock cycle, grab the
> range of folios covering what was previously identified as a hole
> (before dropping locks), and then just report it as delalloc as we would
> have had we not dropped locks at all. The code for that seems less
> kludgy and follows the allocate_dropping_locks() pattern.
> 
> So this is the relevant bit of code I'm working with currently:
> 
>                 /*
>                  * If a hole exists before the start of the extent key, scan the
>                  * range for pagecache data that might be pending writeback and
>                  * thus not yet exist in the extent tree.
>                  *
>                  * Since we hold extent btree locks here, we must trylock the
>                  * folios to avoid deadlocks with the write path. On trylock
>                  * failure, redo the scan with blocking locks in proper lock
>                  * order.
>                  *
>                  * Technically this means that the extent btree could have been
>                  * updated from folio writeback, but this is a TOCTOU race and
>                  * so we just report the delalloc extent based on the state of
>                  * the iter prior to the unlock.
>                  */
>                 if (iter.pos.offset > start) {
>                         ret = bch2_fiemap_hole(vinode, start << 9,
>                                                iter.pos.offset << 9, &cur, true);
>                         if (ret == -EAGAIN) {
>                                 ret = drop_locks_do(trans,
>                                         bch2_fiemap_hole(vinode, start << 9,
>                                                          iter.pos.offset << 9,
>                                                          &cur, false));
>                         }
>                         if (!ret)
>                                 have_delalloc = true;
>                         else if (ret != -ENOENT)
>                                 break;
>                 }
> 
> Note that the last param to bch2_fiemap_hole() is the nonblock param
> lifted up from bch2_seek_pagecache_[data|hole](). I also haven't done
> anything with -EAGAIN because it originates from the latter and is more
> isolated than it was previously (actually I'm thinking about pushing
> trans and the whole drop locks sequence down into bch2_fiemap_hole() if
> this otherwise seems reasonable). Thoughts?

this will give us tight synchronization between the extents btree and
the pagecache - it's as if we're locking both at the same time, no need
to think about TOCTOU issues - nice.
