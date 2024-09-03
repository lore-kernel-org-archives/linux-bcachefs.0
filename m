Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B808820E3
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 22:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725401733; cv=none; b=AhsnMPalNOaI5oALReJKR4xIBqKAnFJi04zqs07Gq4+1G8ewobKBsMFPqVTqyW0Vqcu3ilaKW1Dyeh4RCOqEXi2vYTL5TMair7S1UR8eDNiZ31nppHuvMYazrwV+4FcBb6T711n5CkLMETrgTOmn3PtL1XqIZXsAAukMPGtQWBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725401733; c=relaxed/simple;
	bh=4qnZcaOLJgFImwEt7mF1UvRFj0cgg+mIMyUe2Nuov5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDPqNyAeTW5Y7l/CTbvt/K3+Dm1UMz8OMaHxiaEmaOlbrU1Cdq+GUt6vd9Lc0QWD6z2w1iSAQD77BYt6Vls8sChFtbUY9XmoAOYAm7qLXRRdUmnZlVeJfSXcg2D3X0U41bOE57Gl0W5YaRO/KR9GRNcE6f+55RCswlPpgfNkubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xKjYW6Cn; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xKjYW6Cn"
Date: Tue, 3 Sep 2024 18:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725401728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qEOzeBG8YywzbvQFzGQ3gDygeuKu8XhDv3dtu4ns2ss=;
	b=xKjYW6CnyDFRthda9h6hbzwY3ffneKHPtj7Kg7r9oboku3CD9rmXDb5tZtO6T2tlJp5yTD
	4J7qxjzjxmiY9smf6DRZtKbLtbjOranM00k0v3nvzFoh6nZuBUJSZyAQcLIamVEtBruq3q
	qXnGxW9F9rY4jswjSIXGcIK0PPy3FZU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Eli Schwartz <eschwartz@gentoo.org>, 
	"Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Message-ID: <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2197543.irdbgypaU6@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 11:37:32PM GMT, Martin Steigerwald wrote:
> Kent Overstreet - 07.08.24, 21:55:09 CEST:
> > On Wed, Aug 07, 2024 at 08:58:23PM GMT, Martin Steigerwald wrote:
> > > I amended the subject line a bit. I am not sure whether Debian Testing
> > > or Debian Unstable should also be avoided.
> > 
> > Unstable as well - unstable is stuck at 1.9.1 and tools is up to 1.9.4,
> > and it's their policy of switching rust dependencies to distro packages
> > that broke the build.
> 
> Experimental meanwhile has 1.9.4.
> 
> But I do find this quite sad and concerning:
> 
> https://jonathancarter.org/2024/08/29/orphaning-bcachefs-tools-in-debian/
> 
> I do not completely agree with removing it from Debian Unstable aka Sid at 
> this time, but if upstream development continues like this until too short 
> before Debian 13 aka Trixie release I can somewhat understand. However it 
> would still be good to have it there for people who use Debian Sid to 
> test.

Upstream development continues how...?

I would like Debian people to really consider if they might be
overreaching with their policies too much.

For now, we really need to be able to update bcachefs-tools in a timely
manner, because

- bugs happen: when updates stopped and debian users were stuck on
  1.9.1, that left users with filesystems they weren't able to mount -
  their machines were down - because of the bug with passing mount
  options, they weren't able to mount degraded.

  And I must repeat, I was the one fielding those bug reports, not the
  Debian package maintainer. I don't want Debian creating a mess and
  leaving me to deal with the aftermath.

- because -tools needs to stay up-to-date with on disk format features
  in the kernel

> I more and more come to the conclusion myself that BCacheFS might be just 
> a tad bit too much of a moving target for me at the moment.
> 
> BTRFS can be used just fine in Debian Stable meanwhile. But it took quite a 
> while to get there. Version of btrfs-progs in Unstable is available as a 
> backport for Debian stable. As far as I understand this cannot be done 
> with BCacheFS tools without putting all the dependencies as is into the 
> package and violating the principle to package a library dependency in one 
> place and be able to update it for security updates in one place for all 
> the applications and tools depending on it to benefit from them in one go.

I still have not yet heard a single good reason for this policy.

The rust dependencies are statically linked, and that's not going to
change because dynamic linking that works with the full Rust typesystem
is, simply, a _really_ hard problem that's going to take a massive
enginering effort to solve. Swift was able to do it - but I'm quite
familiar with what it took to do that, and they were only able to
because Apple invested significantly into it.

So, given that they're statically linked, why?

It can't be for security updates, because to update a dependency we
_still_ have to update and spin a new release of bcachefs-tools. And
that's not such a big deal, because nodays there's bots that notify me
if I need to do that.

So it seems to me that Debian people just aren't thinking things
through.
