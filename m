Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC04646
	for <linux-bcachefs@vger.kernel.org>; Wed,  4 Sep 2024 00:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725410331; cv=none; b=PDwzwLPjYYSBmRGptOjRSCqhznc/s9rLxV0DPJcZ20d0U+Kt5/fXn6zX+BoPordS9A+QFbUQP4QBy+c+gJguZQshA0RAj8vpIOQSIg6kzii3oKEo3plxUOKFQ3baYQ9F3+Cfti2JNzOHAHJ12HWrDa+m9egguSj25S/fAYCsUCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725410331; c=relaxed/simple;
	bh=1lpbbm4Tm9sfCZZhVW94hR8ZxozzN24gapQZ/c9WH+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtEe+V/CRLF0C24CbNr4+0IJAnP6LprkFqVp3feGPvRrt6VXRMsW54xurtlmzYmqRpRoHwmy9e/PDXhy9I7Xyh0rolVwkxP54ozcv86KXzyg6Uv3G1zWJq0b8i9IoTPyn/BvTla0weapcCXxXL6rl3JK7936L9W0K5dmGG/p3tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=m6KMsqjO; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="m6KMsqjO"
Date: Tue, 3 Sep 2024 20:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725410326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fdP8nnVbPa5YhD37l7B+42mFDXmRnBHijxxjCyR/3BI=;
	b=m6KMsqjOqL3F1h3jn/W0pIGTH7B08XN8ZfbHaeSVxqGTqGChx6/JKKjujJ4zphmDQ4kbzD
	l18aN0+wSNNncDO5XcaA7ZwaOy/dtJDPZpFRhATPGNjjaSDxx1JvYNE9vkV3B6WK/jpaS1
	2HOLtZWqPDynzWu9o8eNNrJrHOinePY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eli Schwartz <eschwartz@gentoo.org>
Cc: Martin Steigerwald <martin@lichtvoll.de>, 
	"Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Message-ID: <urrfdzixaxhhihnri4awsddghdajnfk46nrodvknuisjjuk56l@qx424lg4jg4n>
References: <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
 <2197543.irdbgypaU6@lichtvoll.de>
 <sq35zfsryexuqu2vmpvxj3gxv3kja5wv2nqqbtbyu5catvylho@wkaootfi2zhw>
 <683718c1-98c9-4b28-a301-15c4668b1476@gentoo.org>
 <wuhq6flzorkw5hgzx5h557ddroekbzt27z3pzs6uyhjhik5kls@76iojjqrczuq>
 <3d737289-9c3b-4596-8c3d-de8b0cb5c9af@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d737289-9c3b-4596-8c3d-de8b0cb5c9af@gentoo.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Sep 03, 2024 at 08:31:16PM GMT, Eli Schwartz wrote:
> On 9/3/24 8:04 PM, Kent Overstreet wrote:
> >> Back to Debian. Since each package can only have one source
> >> *.orig.tar.xz, I would assume that Debian has basically two choices as a
> >> result of their packaging format:
> >>
> >> - package each crate as a system dependency
> >> - repack each program source after running `cargo vendor`, and upload
> >>   *that* as the canonical source code
> > 
> > I already provide 'cargo vendor' tarballs. Yes, it's big (thanks to
> > bindgen), but it's not _enormous_.
> 
> 
> Sure. Debian was probably working with the notion that using vendor
> tarballs makes individual packages a "special snowflake", which is a
> tempting rationale until you realize you're patching to allow versions
> that are way too low.
> 
> 
> > And bindgen is unfortunately the problematic one (and the one that broke
> > the build) - the semantics of the packed and aligned attributes are
> > subtle, and bindgen has had difficulty getting them right (due in part
> > to differences between gcc and microsoft).
> 
> 
> Heh, no doubt. :)
> 
> -bindgen = "0.69.4"
> +bindgen = "0.66"
> 
> Really makes you think about the wisdom of allowing versions that
> upstream specifically marked as incompatible (downgrading, not upgrading!)
> 
> Especially since binding between two languages will inherently tend to
> violate rust's safety semantics! The entire point of bindgen is to
> create a "safe" description of C types...

Yeah, I think it's been pretty well established by this point that
mistakes were made.

Hopefully we're finally on a track to doing better :)

> > Don't unbundle the other dependencies. They're tiny, and it's not worth
> > the pain it could potentially cause.
> 
> 
> Yeah but again this has nothing to do with unbundling, rather, it's
> about modifying version and disrespecting:
> 
> - the lockfile
> - the Cargo.toml
> 
> If the debian packages were simply the same version as all the
> Cargo.lock entries, then it would be *unbundling*, but not *modification*.
> '
> It's the modification that's a problem, and specifically, the
> modification of *required lower bounds*. It might be safe to upgrade a
> crate, to get a "better" version, but downgrading to get a worse version
> generally feels pretty silly.

But given that different packages probably won't be specifying the exact
same versions of dependencies, so debian isn't going to have the right
one, and most of these dependencies are _tiny_ - why bother with the
enormous hassle?

Not everything tiny bit of code needs to be a distro-level package...

> Again, Simply running `cargo install --git
> https://github.com/koverstreet/bcachefs-tools` will totally ignore your
> lockfile and feel free to update to "newer == better" versions. Perhaps
> bindgen would even fix more attribute issues. :D
> 
> But it would always, always, always respect Cargo.toml, which is why
> Debian did NOT bother doing anything to the lockfile, but did apply a
> patch to Cargo.toml

Yeah, cargo still has some bugs: the modern thinking on how to do this
style of packaging 'right' has been evolving fairly recently.

Cargo.lock should really not be changed by anything but 'cargo update',
and if I was less lazy I'd file a bug about htat.
