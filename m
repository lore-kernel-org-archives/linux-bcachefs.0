Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEC4320C
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724611305; cv=none; b=n6V10OQQwKxU59ty9PBehPv7P3keTMxKF06GDQPCLi7qkRPG9OdSAYgI4DHwBhx8XL1RrJyEQeD6v8qPo/OFqa/POAAdvfrk5UojfgrqhGL56sAEsujThqNuG2p43pST/KLXVO0XO42GD9Dse3zLv7745lHQu+AKECcDur+0xKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724611305; c=relaxed/simple;
	bh=Q5AYrl1Rfy94o4/b373fwX0CwyrrsZKky2k/ScsoxXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EbtJ1Sxb3opgoFgBT44sE7xMfZ5an3E11bOrBdIegbIFRWaHzzQjg7EjkZk7e1A4Ol9sPVHTim80kF83BdMgvXt1Ljm1qgaxr0UagFM52fjDEY21RUnHSIBoRLUGo6tXvq2UibizoJjkux2KQRXvCSi08uc8oS4q1vpFfwds3VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uYxXatLL; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uYxXatLL"
Date: Sun, 25 Aug 2024 14:41:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724611300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dXaU+YVkzq5oq4ylDpppvMkUsLQGCz0i0ArVsR5SNWg=;
	b=uYxXatLLX1n3HaYtAZdBVqfTVpGNBf7Fg568Asxa9jPIA8uolHontx8UFKGdl0RkSS3TAJ
	JDfMwVN8Im5rJUdgiFVmxy6fEuFzZtN+myhg/N9Zy3x6VvSR/r6BppoLJ9bGCUeOQmWPLl
	M75xANME5WB41zFPjvUYvn1nUase9fk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
Message-ID: <wxcxtm6qag453jnafbbtq3sfvnqshxxe3awrv5ptn67hoprkkk@comfvqlyig7y>
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
 <CAHk-=wh3eEa-X6wAXpVLrh+i5a3dK0atBDPUf_XhFmhs7pKwZA@mail.gmail.com>
 <20240825-elche-einmieten-b48739f19788@brauner>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240825-elche-einmieten-b48739f19788@brauner>
X-Migadu-Flow: FLOW_OUT

On Sun, Aug 25, 2024 at 08:18:25AM GMT, Christian Brauner wrote:
> On Sun, Aug 25, 2024 at 05:32:01PM GMT, Linus Torvalds wrote:
> > On Sun, 25 Aug 2024 at 04:20, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > - rhashtable conversion for vfs inodes
> > > - rcu_pending, btree key cache conversion
> > > + nocow deadlock fix
> > > + fix for new rebalance_work accounting
> > 
> > I'd have preferred to get a proper list. I edited something together.
> > 
> > >       fs/super.c: improve get_tree() error message
> > 
> > Ugh. Please use '%d' instead of '%i'. Yes, yes, we use both, because
> > some people seem to think that 'i' makes more sense. but %d is
> > *hugely* more common by over an order of magnitude, and '%i' only
> > makes sense for sscanf (and then has magic properties that it does
> > *NOT* have on output).

Didn't know that about %i...

> > 
> > I've pulled this, but reacted to it because it was to generic vfs code.
> 
> The patch to vfs_get_tree() has never been sent to the VFS maintainers
> and it has never been on any mailing list (at least not on fsdevel and
> not on bcachefs ml as well from lore.kernel.org).
> 
> Yes, this is a minor change in this case but it's still not ok to just
> include patches in a pull request that have never been on any list and
> haven't seen by the maintainers. This isn't the first time.
> 
> So please, I want to see all patches that touch VFS generic code on
> fsdevel with the maintainers Cced.

I ran it by David Howells on IRC because it was trivial, but I'll do
that in the future.
