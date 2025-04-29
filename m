Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9727245019
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Apr 2025 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745943713; cv=none; b=XFsePckhsnRwowZ0gDBi2SBLWN/g9Ik1WHummhWGEBkwmOfu06TJzWcXsuHQOHlHLutssAZkY82X3jqJFXRunKBDryYrS4bsi2BC3LITjVp0HFKbe/mXhg0GAJU4rfI2Wi1grTk6/xcRMag3sZdbiqbd4l9+eQq8fC/8pfjsLTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745943713; c=relaxed/simple;
	bh=Y6JiO7oYoeOTKUsy66zGL+B19kEo8r9m8dto+yrP6TQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=twchMNurTX6LCGxqAkT+hCOUTa4MVK/IRJ3sJvplECT8NAhfDSTz8ngnMdADdXz3uPT0fND84GU7eY0SsJggR4lnr2um4KsZim9dic9LDcyxXNj7WOFT3Mw4Rf+2VFOXDcSln4sx5xNcdCdoTXs4Mc98gsMsk7WUWU+N5jOLuTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VeL22eYD; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VeL22eYD"
Date: Tue, 29 Apr 2025 12:21:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745943699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cTpA6o8PWXuPbIwQZ+jU9BV1D3QBfTnXkZ2PpDFhcgQ=;
	b=VeL22eYDp+0JnPOPNWmQrO47wxt0dcHS4l10sYycSwWR+QuMITchnza5SE/uWI8Kh8X4pv
	Rf/XuAdpyPn2LD2ErpUaiz/ZKA+T7upTeWDp4CMD3XJVlsmyTeAp7io8UT/x8kW2Dc767z
	tBUd1mB1pfhpJ9Uz2QNoo/INNU7c2OQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Patrick Donnelly <batrick@batbytes.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <pkpzm6okfqchet42lhcebwaiuwrwil6wp76flnk3p3mgijtg2e@us7jkctbpsgc>
References: <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
 <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
 <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
 <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
 <CACh33FqQ_Ge6y0i0nRhGppftWdfMY=SpGsN0EFoy9B8VMgY-_Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACh33FqQ_Ge6y0i0nRhGppftWdfMY=SpGsN0EFoy9B8VMgY-_Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Apr 29, 2025 at 11:36:44AM -0400, Patrick Donnelly wrote:
> I would not consider myself a kernel developer but I assume this
> terminology (dentry aliases) refers to multiple dentries in the dcache
> referring to the same physical dentry on the backing file system?

This issue turned out to be my own pebcak; I'd missed the
dentry_operations that do normalized lookups (to be fair, they were
rather hidden) and I'd just pulled a 14 hour day so was a tad bitchy
about it on the list.

> If so, I can't convince myself that's a real problem. Wouldn't this be
> beneficial because each application/process may utilize a different
> name for the backing file system dentry? This keeps the cache hot with
> relevant names without any need to do transformations on the dentry
> names. Happy to learn otherwise because I expected this situation to
> occur in practice with ceph-fuse. I just tested and the dcache entries
> (/proc/sys/fs/dentry-state) increases as expected when performing case
> permutations on a case-insensitive file name. I didn't observe any
> cache inconsistencies when editing/removing these dentries. The danger
> perhaps is cache pollution and some kind of DoS? That should be a
> solvable problem but perhaps I misunderstand some complexity.

Dentry aliases are fine when they're intended, they're properly
supported by the dcache.

The issue with caching an alias for the un-normalized lookup name is
(as you note) that by permuting the different combinations of upper and
lower case characters in a filename, userspace would be able to create
an unbounded (technically, exponential bound in the length of the
filename) number of aliases, and that's not what we want.

(e.g. d_prune_aliases processes the whole list of aliases for an inode
under a spinlock, so it's an easy way to produce unbounded latencies).

So it sounds like you probably didn't find the dentry_operations for
normalized lookups, same as me.

Have a look at generic_set_sb_d_ops().

> > Also, originally this was all in the same core dcache lookup path. So
> > the whole "we have to check if the filesystem has its own hash
> > function" ended up slowing down the normal case. It's obviously been
> > massively modified since 1997 ("No, really?"), and now the code is
> > very much set up so that the straight-line normal case is all the
> > non-CI cases, and then case idnependence ends up out-of-line with its
> > own dcache hash lookup loops so that it doesn't affect the normal good
> > case.
> 
> It's seems to me this is a good argument for keeping case-sensitivity
> awareness out of the dcache. Let the fs do the namespace mapping and
> accept that you may have dentry aliases.
> 
> FWIW, I also wish we didn't have to deal with case-sensitivity but we
> have users/protocols to support (as usual).

The next issue I'm looking at is that the "keep d_ops out of the
fastpath" only works if case sensitivity isn't enabled on the filesystem
as a whole - i.e. if case sensitivity is enabled on even a single
directory, we'll be flagging all the dentries to hit the d_ops methods.

dcache.c doesn't check IS_CASEFOLD(inode) - d_init can probably be used
for this, but we need to be careful when flipping casefolding on and off
on an (empty) directory, there might still be cached negative dentries.

ext4 has a filesystem wide flag for "case sensitive directories are
allowed", so that enables/disables that optimization. But bcachefs
doesn't have that kind of filesystem level flag, and I'm not going to
add one - that sort of "you have to enable this option to have access to
this other option" is a pita for end users.
