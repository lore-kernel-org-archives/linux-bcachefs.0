Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFD718800D
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Sep 2024 22:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725316365; cv=none; b=LII3BEBTnvnMPOxwpwTBU+3Y2WkcouuEeGsrdKzMV+zBTXoXrWwhZU2IOu1c3DZhVLUGv33T9gOa2f/htwB8X0qfjnTvwTJfsyHNvXxdd2SGIRPSwS/02VJlD1R2rcV/lTHZLUkFo4Belm7wanER3Ux2srxbGxW1lE2SgfwihYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725316365; c=relaxed/simple;
	bh=yXaIotM8BdESL2nGvdQndlyL1aKaMU+Rp53IfN8oEes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/tJ6pIwbqvzZvsMEln7+fBAqDmKv6VOXOd7JmNvV8NitIas+4lnoOZl3VwdiZ7nH1T2yJ4THQW2r1PkvaL/45rJh31gYU4qiYkkcaddENgIoHw5rwrPanEsQhCfHOBif70vd+WvRureoJnGAXl2olq2FURwDdRNZdEgERs9vsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=umujh2Un; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="umujh2Un"
Date: Mon, 2 Sep 2024 18:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725316359;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CChicL5CaDGtmLSJf1vi34yqR67dtLRNpZXAsSTNcoA=;
	b=umujh2UnaAGmMihjCzRLKqvCZZGmAsBfwXENr0g2sZqZvXzMFKqDXVC1Ve9bQ+0pZkKCnv
	G0IJqpN17zbRBc90S1MhpC5enVZy8Do2D5jEev27oscgRIne9oKA6WuYDHthrtEWX67Dtk
	FclhxdraZegGjTP9EWxLPqAW0kENOL0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Yafang Shao <laoar.shao@gmail.com>, jack@suse.cz, Vlastimil Babka <vbabka@suse.cz>, 
	Dave Chinner <dchinner@redhat.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-bcachefs@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] remove PF_MEMALLOC_NORECLAIM
Message-ID: <yewfyeumr2vj3o6dqcrv6b2giuno66ki7vzib3syitrstjkksk@e2k5rx3xbt67>
References: <20240902095203.1559361-1-mhocko@kernel.org>
 <ggrt5bn2lvxnnebqtzivmge3yjh3dnepqopznmjmkrcllb3b35@4vnnapwr36ur>
 <20240902145252.1d2590dbed417d223b896a00@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240902145252.1d2590dbed417d223b896a00@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Sep 02, 2024 at 02:52:52PM GMT, Andrew Morton wrote:
> On Mon, 2 Sep 2024 05:53:59 -0400 Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > On Mon, Sep 02, 2024 at 11:51:48AM GMT, Michal Hocko wrote:
> > > The previous version has been posted in [1]. Based on the review feedback
> > > I have sent v2 of patches in the same threat but it seems that the
> > > review has mostly settled on these patches. There is still an open
> > > discussion on whether having a NORECLAIM allocator semantic (compare to
> > > atomic) is worthwhile or how to deal with broken GFP_NOFAIL users but
> > > those are not really relevant to this particular patchset as it 1)
> > > doesn't aim to implement either of the two and 2) it aims at spreading
> > > PF_MEMALLOC_NORECLAIM use while it doesn't have a properly defined
> > > semantic now that it is not widely used and much harder to fix.
> > > 
> > > I have collected Reviewed-bys and reposting here. These patches are
> > > touching bcachefs, VFS and core MM so I am not sure which tree to merge
> > > this through but I guess going through Andrew makes the most sense.
> > > 
> > > Changes since v1;
> > > - compile fixes
> > > - rather than dropping PF_MEMALLOC_NORECLAIM alone reverted eab0af905bfc
> > >   ("mm: introduce PF_MEMALLOC_NORECLAIM, PF_MEMALLOC_NOWARN") suggested
> > >   by Matthew.
> > 
> > To reiterate:
> > 
> 
> It would be helpful to summarize your concerns.
> 
> What runtime impact do you expect this change will have upon bcachefs?

For bcachefs: I try really hard to minimize tail latency and make
performance robust in extreme scenarios - thrashing. A large part of
that is that btree locks must be held for no longer than necessary.

We definitely don't want to recurse into other parts of the kernel,
taking other locks (i.e. in memory reclaim) while holding btree locks;
that's a great way to stack up (and potentially multiply) latencies.

But gfp flags don't work with vmalloc allocations (and that's unlikely
to change), and we require vmalloc fallbacks for e.g. btree node
allocation. That's the big reason we want MEMALLOC_PF_NORECLAIM.

Besides that, it's just cleaner, memalloc flags are the direction we
want to be moving in, and it's going to be necessary if we ever want to
do a malloc() that doesn't require a gfp flags parameter. That would be
a win for safety and correctness in the kernel, and it's also likely
required for proper Rust support.

And the "GFP_NOFAIL must not fail" argument makes no sense, because a
failing a GFP_NOFAIL allocation is the only sane thing to do if the
allocation is buggy (too big, i.e. resulting from an integer overflow
bug, or wrong context). The alternatives are at best never returning
(stuck unkillable process), or a scheduling while atomic bug, or Michal
was even proposing killing the process (handling it like a BUG()!).

But we don't use BUG_ON() for things that we can't prove won't happen in
the wild if we can write an error path.

That is, PF_MEMALLOC_NORECLAIM lets us turn bugs into runtime errors.
