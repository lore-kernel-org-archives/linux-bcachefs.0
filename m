Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B14D3C485
	for <linux-bcachefs@vger.kernel.org>; Sun, 25 Aug 2024 06:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724566711; cv=none; b=nXDZZ9LWu0+zfTVSVzseKBhJYG/xcPimkFoeSMlBqkOIuf3P8w8x6UFWLZgconD7ZoMtvW7pnMPbXE2mYDwqUhOp1/oU/CkpiIbfTTZkxfkkLvvIJZeCS8lUJT8Q3/aDQRHd0gThQz2221s5VeUcB0ohXwXyMCXscrq55k8jGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724566711; c=relaxed/simple;
	bh=PqdVVNnJiFBBLG7YTOcVVAkvE2WALVRHMZmb2pxE7Tg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYiOzt9M5YLBAOf+797zHlpk3wkeZmrfPpNTZparAlFwsFjJ27HnGnoFPZ6atZvqliHl2rAaBk7hgrCtLIolRCJw6/5zZQmmjxU94YrwpmdhI7aKoPmPRYy2e/v2t1Zk22p6qX79P/yuzuBRkbv9QzmRKajCX4jdNbDPYkDPjmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VORADR7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VORADR7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C76BC32782;
	Sun, 25 Aug 2024 06:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724566711;
	bh=PqdVVNnJiFBBLG7YTOcVVAkvE2WALVRHMZmb2pxE7Tg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VORADR7EGPp+UKXnp4otUthly+CR1RPaPPM51MOYhbC0KldsUDIMWOoO3sYZA7/1d
	 qQigZ9NHAR/fUpYMmLkamlMqH+FOoU7p4aHqHIpclmyA6g5fUnXXLgJ4dAlwaIYjjP
	 OZw3+175E98PS+J2RFcamZTTGVCWZlmuF39t/JtT6xU+Az7e3HqPC66nvGESdj4sn6
	 VgaAHbcdBNghnIixDke+mrkgo7XwWIMnGB2dY7mZ7VXiccKE4QygMZ2GWh591MIlyk
	 B64du7rn6meNDF+B9E2oJrzWFHht65Pb4wfVjCGrFAzKkTVPQt2FKQiEc7D8/vEgLH
	 /vAt2PKTDBMCQ==
Date: Sun, 25 Aug 2024 08:18:25 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-bcachefs@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.11-rc5 v2
Message-ID: <20240825-elche-einmieten-b48739f19788@brauner>
References: <awwxatomvqsjf3uao64qm3b4jq34tvdfpobe22wouydgzc534j@c6h7l4k7447c>
 <CAHk-=wh3eEa-X6wAXpVLrh+i5a3dK0atBDPUf_XhFmhs7pKwZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wh3eEa-X6wAXpVLrh+i5a3dK0atBDPUf_XhFmhs7pKwZA@mail.gmail.com>

On Sun, Aug 25, 2024 at 05:32:01PM GMT, Linus Torvalds wrote:
> On Sun, 25 Aug 2024 at 04:20, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > - rhashtable conversion for vfs inodes
> > - rcu_pending, btree key cache conversion
> > + nocow deadlock fix
> > + fix for new rebalance_work accounting
> 
> I'd have preferred to get a proper list. I edited something together.
> 
> >       fs/super.c: improve get_tree() error message
> 
> Ugh. Please use '%d' instead of '%i'. Yes, yes, we use both, because
> some people seem to think that 'i' makes more sense. but %d is
> *hugely* more common by over an order of magnitude, and '%i' only
> makes sense for sscanf (and then has magic properties that it does
> *NOT* have on output).
> 
> I've pulled this, but reacted to it because it was to generic vfs code.

The patch to vfs_get_tree() has never been sent to the VFS maintainers
and it has never been on any mailing list (at least not on fsdevel and
not on bcachefs ml as well from lore.kernel.org).

Yes, this is a minor change in this case but it's still not ok to just
include patches in a pull request that have never been on any list and
haven't seen by the maintainers. This isn't the first time.

So please, I want to see all patches that touch VFS generic code on
fsdevel with the maintainers Cced.
