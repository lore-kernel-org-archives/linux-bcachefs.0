Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4628F20E6E2
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 14:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742309838; cv=none; b=tFNHtrVLGZVS4Xho/eIxthNi7BjWrkZzkKhQX8UI+/OEgE0JncKR9SCu1XOLl1gfpTI9fRlrubSpcygWlA5zVCusJIuNzJnyHW3rDHDMv688AyC4rFYP/wgAKLE4/FY0tAKrjthgPzXQoB+e2eCGOqLdUrt14Wc+q52YliAtl9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742309838; c=relaxed/simple;
	bh=5MeCKu2D7YTXp683k5BVUKZ7rUlSjODZOfA1mpxJmwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=osneLX8hGYyoi8RI26FGH5uccJwSJnfT9erEuhIVIdFcAWqTWMzJmpuJN+dv4XffwJpFmPD8L9J3eDhndLUYLHFikSPZPZuNOjl6ED7t+Om8TDAvqF0y6862Pp/PbqHcn37aXu6cfMWqLNOn6lRbykaSZhujqfwvh/xLYbsRK+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XvrvX0rG; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XvrvX0rG"
Date: Tue, 18 Mar 2025 10:57:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742309830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vYd6byRtXdPW+3tJeyfMAdazZaHNqVH+PpXWAJ8o+XU=;
	b=XvrvX0rGkyNd1vz5DVX80039eCXHCEslWfL5DnjRZxvNdJLHJmPHOhRXaNTb70w1oj11Gs
	2ajiWN1IZ5g+xwYjcLf4NpT0roTnf6Ak41kaU38aHCdIpHG4F8s8zL7FH5bm/lcWsPRPm8
	nNRilhHacfSH2TCK5eYnKGFjHTzDBZE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: John Stoffel <john@stoffel.org>
Cc: Alan Huang <mmpgouride@gmail.com>, linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] bcachefs: Increase blacklist range
Message-ID: <gogyhxsomty6ooldwglk36qa2rqn6iwwwhopslmui2k3naky2i@4vzz3myybst5>
References: <20250315073942.1909895-1-mmpgouride@gmail.com>
 <26584.36082.936426.143774@quad.stoffel.home>
 <gchq6w4tyrx4wxjepyfoerprnsp3jlzm2acel4hfaf4z3jp4iw@53mpn6u5edc7>
 <26585.33403.270413.729999@quad.stoffel.home>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26585.33403.270413.729999@quad.stoffel.home>
X-Migadu-Flow: FLOW_OUT

On Tue, Mar 18, 2025 at 10:26:03AM -0400, John Stoffel wrote:
> >>>>> "Kent" == Kent Overstreet <kent.overstreet@linux.dev> writes:
> 
> > On Mon, Mar 17, 2025 at 04:58:26PM -0400, John Stoffel wrote:
> >> >>>>> "Alan" == Alan Huang <mmpgouride@gmail.com> writes:
> >> 
> >> > Now there are 16 journal buffers, 8 is too small to be enough.
> >> > Signed-off-by: Alan Huang <mmpgouride@gmail.com>
> >> > ---
> >> >  fs/bcachefs/recovery.c | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> >> > index 71c786cdb192..a6e26733854d 100644
> >> > --- a/fs/bcachefs/recovery.c
> >> > +++ b/fs/bcachefs/recovery.c
> >> > @@ -899,7 +899,7 @@ int bch2_fs_recovery(struct bch_fs *c)
> >> >  	 * journal sequence numbers:
> >> >  	 */
> >> >  	if (!c->sb.clean)
> >> > -		journal_seq += 8;
> >> > +		journal_seq += JOURNAL_BUF_NR * 4;
> >> 
> >> Instead of magic numbers, could you put in a define with an
> >> explanation of how you arrived at this number?  Just to document the
> >> assumptions better?
> >> 
> >> John
> 
> > The * 4 is a fudge factor.
> 
> Ok.
> 
> > But actually, I was giving this more thought and I don't think we have
> > the correct number.
> 
> We have a WAG here.  :-)
> 
> > The real bound is "number of unflushed journal entries that might have
> > been allocated, and have other items (btree nodes) referring to that
> > sequence number, but which don't hit because beacuse they weren't
> > flushed".
> 
> > And we don't have an actual bound on that.
> 
> So what happens if journal_seq overflows?  I don't know the code and
> haven't looked.   

In the olden days, in the before times, blacklisting insufficient
sequence numbers would mean btree node entries could become visible
after a crash that should've been ignored, because they were newer than
the newest (flush) journal entry.

That can't happen anymore because pointers to btree nodes now indicate
how many sectors we've written and completed within that node, and
they're updated after every btree node write (log append).

IOW - our mechanism for sequential consistency now is that the b-tree
behaves like a pure COW btree.

So I retract what I said before :) Having just checked the journal read
path, and the recovery path that creates the blacklist entries, I think
we're good.

The only reason we'd need to blacklist more is if we want some kind of a
double check on the modern sequential consistency mechanism, and I don't
think we need that.
