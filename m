Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D41DC73E
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465965; cv=none; b=cr8ZqljeFA7xsU+CAEKfYfvTUJctyevC8mxnMYBron8tKxeEbg/pWkEvyZQ8fzt1e4E3kYQhWm/hs3h/Rre787qEO9uQAUxy199xvCKwGeDnMwRhzOsbDiPJrK+megjkktLANdtDKyFQ/AnyGou/IJZzXB8w/aB5qE7VfLyXd4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465965; c=relaxed/simple;
	bh=QIflG+i8erExsjaJTRapdmZ9iJ5ADKBmshHOtaz9yhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aZR338BxHjFQROCbjCOa2bcNlR2l+yqaAecC1WI2gf6365AnpBb1feovBTMmVfnaA3AP0GzPhSLp+YjErUnueKnuX5N/A/tKhbTPHiJ6FQpG6vLe+7YzhwgEq+vs/yJn+acy2PMLa121Cwb55UAKbVDKFsBEgvv6Qka8ptqGaDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YTpVAvFL; arc=none smtp.client-ip=95.215.58.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YTpVAvFL"
Date: Wed, 4 Sep 2024 12:05:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725465961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ip+NUzeK1lPkO63WxoY3xZeS3dUaxlsqa4wf8CU79LU=;
	b=YTpVAvFLLAL9Kaycf2+c0fuJYxA48DNH0nyRJqZurESU3J6LejkXX7JVSTATMlGJHqO6Ou
	97Z3YC0DUd44mJfdGzvqnH0PNE9X0qDygOkNCwrMuxh1lR7CQoPBIwvDW9APfu2shQXRvQ
	hCv6X8qdcMIc+uFjtqUGIAOPtqldyAM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@lst.de>, Yafang Shao <laoar.shao@gmail.com>, jack@suse.cz, 
	Vlastimil Babka <vbabka@suse.cz>, Dave Chinner <dchinner@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-bcachefs@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2 v2] remove PF_MEMALLOC_NORECLAIM
Message-ID: <xjtcom43unuubdtzj7pudew3m5yk34jdrhim5nynvoalk3bgbu@4aohsslg5c5m>
References: <20240902095203.1559361-1-mhocko@kernel.org>
 <ggrt5bn2lvxnnebqtzivmge3yjh3dnepqopznmjmkrcllb3b35@4vnnapwr36ur>
 <20240902145252.1d2590dbed417d223b896a00@linux-foundation.org>
 <yewfyeumr2vj3o6dqcrv6b2giuno66ki7vzib3syitrstjkksk@e2k5rx3xbt67>
 <qlkjvxqdm72ijaaiauifgsnyzx3mw4edl2hexfabnsdncvpyhd@dvxliffsmkl6>
 <ZtgI1bKhE3imqE5s@tiehlicka>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtgI1bKhE3imqE5s@tiehlicka>
X-Migadu-Flow: FLOW_OUT

On Wed, Sep 04, 2024 at 09:14:29AM GMT, Michal Hocko wrote:
> On Tue 03-09-24 19:53:41, Kent Overstreet wrote:
> [...]
> > However, if we agreed that GFP_NOFAIL meant "only fail if it is not
> > possible to satisfy this allocation" (and I have been arguing that that
> > is the only sane meaning) - then that could lead to a lot of error paths
> > getting simpler.
> >
> > Because there are a lot of places where there's essentially no good
> > reason to bubble up an -ENOMEM to userspace; if we're actually out of
> > memory the current allocation is just one out of many and not
> > particularly special, better to let the oom killer handle it...
> 
> This is exactly GFP_KERNEL semantic for low order allocations or
> kvmalloc for that matter. They simply never fail unless couple of corner
> cases - e.g. the allocating task is an oom victim and all of the oom
> memory reserves have been consumed. This is where we call "not possible
> to allocate".

*nod*

Which does beg the question of why GFP_NOFAIL exists.

> > So the error paths would be more along the lines of "there's a bug, or
> > userspace has requested something crazy, just shut down gracefully".
> 
> How do you expect that to be done? Who is going to go over all those
> GFP_NOFAIL users? And what kind of guide lines should they follow? It is
> clear that they believe they cannot handle the failure gracefully
> therefore they have requested GFP_NOFAIL. Many of them do not have
> return value to return.

They can't handle the allocatian failure and continue normal operation,
but that's entirely different from not being able to handle the
allocation failure at all - it's not hard to do an emergency shutdown,
that's a normal thing for filesystems to do.

And if you scan for GFP_NOFAIL uses in the kernel, a decent number
already do just that.

> So really what do you expect proper GFP_NOFAIL users to do and what
> should happen to those that are requesting unsupported size or
> allocation mode?

Emergency shutdwon.

And I'm not saying we have to rush to fix all the existing callers;
they're clearly in existing well tested code, there's not much point to
that.

Additionally most of them are deep in the guts of filesystem transaction
code where call paths to that site are limited - they're not library
code that gets called by anything.

But as a matter of policy going forward, yes we should be saying that
even GFP_NOFAIL allocations should be checking for -ENOMEM.

> Yes, we need to define some reasonable maximum supported sizes. For the
> page allocator this has been order > 1 and we considering we have a
> warning about those requests for years without a single report then we
> can assume we do not have such abusers. for kvmalloc to story is
> different. Current INT_MAX is just not any practical limit. Past
> experience says that anything based on the amount of memory just doesn't
> work (e.g. hash table sizes that used to that scaling and there are
> other examples). So we should be practical here and look at existing
> users and see what they really need and put a cap above that.

Not following what you're saying about hash tables? Hash tables scale
roughly with the amount of system memory/workingset.

But it seems to me that the limit should be lower if you're on e.g. a 2
GB machine (not failing with a warning, just failing immediately rather
than oom killing a bunch of stuff first) - and it's going to need to be
raised above INT_MAX as large memory machines keep growing, I keep
hitting it in bcachefs fsck code.
