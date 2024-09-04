Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF1A173
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 00:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725408268; cv=none; b=GbdYYYYP+8qYlXCbr/tUNDbJfPyohZ9waAjzjEZCvODRkibkiGHhPL6VK0K3tT0kQtjj+EbnrmC3TFZ5tWJDwW4nBOKaYue1lw/FvnHkuC0GezFsAgfucRcK0eR8+aSv51HzeyKtwigy27ASn0QkFFbc3F9LwWvS/ptPdRGUX98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725408268; c=relaxed/simple;
	bh=NiZ+L4Kb4JYAbcCtAUZcaBKpUt639VYvh5hxr9OazyA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kggFxF2zwd3/PJzuRMptdR3eu+K77c41U1KA+coCoVBfLw+xvJVh7b6h/tnH34ndo/qVCIsX2KUJrVTZHwPQgzpgjtIB+oSBBYtAUhu8gW4VktKTAFqGVLFAQzQ+V4oD6KqwekhIMyOsKwpnLCpIekzycFVwmWKbywEvm5Q76I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AF0qIqLp; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AF0qIqLp"
Date: Tue, 3 Sep 2024 20:04:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725408263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=99RWSif1h4pLVwS1QNf/p7YwSYSOM/ZHQ8ZIta62BlE=;
	b=AF0qIqLpLxMgHKlP2ZlZIi0gO9FY8o4kuPW+VjNoXruo2kxO6jH67vQk2k5VyjqGaRFwgu
	YFHowQZq6+I2dezmW8Z2a/J3+rY4/jgTjnyt4cEsVhfi/rVjdZErB+jp4TROCvQzFHPmyx
	zmYQ3ZILMLXO6NwBPu5oCW3xyVohVTU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eli Schwartz <eschwartz@gentoo.org>
Cc: Martin Steigerwald <martin@lichtvoll.de>, 
	"Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Message-ID: <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
 <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 07:44:52PM GMT, Eli Schwartz wrote:
> On 9/3/24 6:15 PM, Kent Overstreet wrote:
> > I still have not yet heard a single good reason for this policy.
> > 
> > The rust dependencies are statically linked, and that's not going to
> > change because dynamic linking that works with the full Rust typesystem
> > is, simply, a _really_ hard problem that's going to take a massive
> > enginering effort to solve. Swift was able to do it - but I'm quite
> > familiar with what it took to do that, and they were only able to
> > because Apple invested significantly into it.
> > 
> > So, given that they're statically linked, why?
> > 
> > It can't be for security updates, because to update a dependency we
> > _still_ have to update and spin a new release of bcachefs-tools. And
> > that's not such a big deal, because nodays there's bots that notify me
> > if I need to do that.
> > 
> > So it seems to me that Debian people just aren't thinking things
> > through.
> 
> 
> There's an interesting conversation to be had here about distfiles,
> duplication, and offline building.
> 
> Probably the biggest single requirement here is the offline building.
> It's not enough to download the bcachefs-tools source tarball and build
> that, since you also need crates downloaded from crates.io and added to
> a local registry. Most (sane) distros build packages with the network
> disabled for security reasons, because you want to verify that all the
> code you are building is code which was included in the original source
> checksumming which is part of the build manifest (and the build manifest
> in turn is probably PGP-signed by the distro developer that processed
> the update).
> 
> And the Debian packaging format involves converting every package into
> an "orig" tarball with the debian build recipes installed inside as
> debian/ and then running the dpkg package building tools from inside
> there. The key to a successful packaging experience is somehow getting
> to run the build tools from that source tarball.
> 
> The packaging formats used by most other distros work differently: a
> package can have multiple (checksummed) source tarballs and one of the
> build phases is unpacking each listed distfile. Alpine, Arch, CRUX,
> Fedora, Gentoo, Void, all list urls to download the source(s) from and
> the checksums to validate against as part of the build recipe, and
> unpack those into a temporary directory.
> 
> So for example that means that Gentoo can list 90 different crate
> dependencies, plus one primary bcachefs tarball, and download each of
> those files into /var/cache/distfiles, then unpack them into a fake
> cargo registry. Of course, this is pretty slow if you don't have
> parallel downloads -- not usually a problem for most packages that have
> only one or two sources, but there you have it. And they can be shared
> between multiple packages, or multiple versions of bcachefs-tools,
> assuming that packages use exactly identical versions.
> 
> In theory, one can also specify a different crate version to use instead
> of basing the versions on Cargo.lock. The update tool (pycargoebuild)
> always builds the list based on Cargo.lock, though.
> 
> Now you have a 90-line package recipe, so have fun with that! :) Of
> course, since any solution for bcachefs-tools is logically consistent
> with handling other rust software, keep in mind that some packages have
> 1,000+ crates. Even more fun!
> 
> 
> Back to Debian. Since each package can only have one source
> *.orig.tar.xz, I would assume that Debian has basically two choices as a
> result of their packaging format:
> 
> - package each crate as a system dependency
> - repack each program source after running `cargo vendor`, and upload
>   *that* as the canonical source code

I already provide 'cargo vendor' tarballs. Yes, it's big (thanks to
bindgen), but it's not _enormous_.

And bindgen is unfortunately the problematic one (and the one that broke
the build) - the semantics of the packed and aligned attributes are
subtle, and bindgen has had difficulty getting them right (due in part
to differences between gcc and microsoft).

So if you want to unbundle bindgen:
- you get to fix it if it breaks, I don't want to see a log of a build
  error months later that you didn't try to debug

- you really should be testing it as well (e.g. create an image with
  bcachefs format --source; verify that it fscks with kernel fsck
  implementation, i.e. that they agree); the stuff in bindgen that's
  been causing issues is absolutely the sort of thing that could cause
  miscompilation and if that ever happens it's going to be a really,
  really bad day.

Don't unbundle the other dependencies. They're tiny, and it's not worth
the pain it could potentially cause.

The cargo dependency model is _really good_ because it means dependency
updates happen in commits in the consuming package, meaning it's
actually possible to bisect for breakage caused by a dependency update -
that's not something we've had before.
