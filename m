Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1039217DFF2
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Oct 2024 19:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729278752; cv=none; b=k4a6QSltgaV04nIYDG1P31YPqCU53QEi2x3YNr603ivgfesA8VeDpyyVJxQjlhpNT3Ky774mqqXiCmHkEHRIw0OxQvkdLgg6Ro7w3liu53KxkGPlTiHMyN2ZMGHR4OAZsJyigDJSJzJP3ogDWsDhsVbyA9tVHtEGpQcE+vHRuTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729278752; c=relaxed/simple;
	bh=PpxlN4p+JI5pCO8lG/tiDRMgz6ZHZCozIGgqcF5KUIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AzjNj18pmQsXgU54hN8qpo0vL0ASP1GYyztp7pEcktAyhw6Xun5HzoguRHg3jGqNvxRvEZUVpOs49ztBoIWbbLVuaIULzqnJlqxpWzgiBbIEwXazjk9xk9RmYTUl+syoS4sYSZ2sc+5R+mF6A63apvF5DgeoU1OLQULWUT+Lf94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kyeYInOE; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kyeYInOE"
Date: Fri, 18 Oct 2024 15:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729278745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R2K+u9Nv1dCswotaotDELHb67BqbFZEPs7m+tUNToPI=;
	b=kyeYInOEdr1gmDokaJ8Ls65+3aGQkft9+Hmf81RWdGq7A4iFCuIuQ7cFrrywkMQ2Gc96Zs
	0jYPvSobjG/rMwjDx2wTC596IYsWuG0+m/KUKE7k0im/JPDcbmvwqN8J/76dARPEkYMfRE
	9zZKUMKHtMIHcZLq9nTrbBy3IA10NoM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Christopher Snowhill <chris@kode54.net>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537913254.1059.1729273074517@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 18, 2024 at 10:37:54AM -0700, Carl E. Thompson wrote:
> 
> > On 2024-10-18 1:17 AM PDT Christopher Snowhill <chris@kode54.net> wrote:
> 
> > ...
> 
> > FYI, 6.9 was first released in May, and is already EOL now. In fact, so
> > is 6.10, at 6.10.14.
> 
> I'm on 6.9.4 which was released in June. It's not really by choice; there are some nasty stability issues in the amdgpu driver in 6.10 and 6.11 which cause my laptop to hang multiple times per day if I use a graphical environment under them.
> 
> > There are no LTS kernels with bcachefs support yet
> > at this point. All further development is going into 6.12 now, with bug
> > fixes being backported into 6.11.
> 
> True. I understand that and accept it. I am not at all suggesting that Kent should make fixes for unsupported kernels. I'm just reporting a bug. But I also think that this sort of issue is one that really, **REALLY** should not happen in the first place. A filesystem silently modifying itself so that it no longer works on earlier kernels without warning is a very bad thing in my opinion. There should be processes in place to catch that sort of problem **before** a new kernel is released. And remember this isn't a one-time thing. It's happened before.
> 
> I'd also say that a filesystem design that requires that an older
> driver be able to successfully automatically discover and undo random
> on-disk modifications automatically made by a newer driver is probably
> a bad design (my personal opinion). It's sounds great until it doesn't
> work (as in this case). And I mean that as constructive criticism and
> not something that Kent should take personally. I think that
> particular design decision should be reevaluated.

It sounds like you should go back to ZFS then.

> It's just dumb luck that in this case the older kernel is no longer
> supported so it doesn't need to be fixed.
> 
> As for my particular case, I should probably see if I can get the
> older, stable amdgpu driver to compile under the current kernel.
> Barring that, I should see if I can get the current bcachefs driver to
> compile under the older kernel. I guess I'll find time to do that this
> evening.

I have been hearing a lot of people complain about regressions in
amdgpu. Have you taken that up with them?

The capability of doing seamless, automatic upgrades and downgrades, to
the extent that bcachefs can, is something new that other filesystems
don't have.

And it's been incredibly useful. Without it, rolling out the disk
accounting rewrite wouldn't have been possible - and that got us per
snapshot ID accounting, compression type accounting, per-btree
accounting, and per-inode fragmentation accounting (not all of these are
exposed to the user yet, but they're there).

While bcachefs is still marked experimental, doing these upgrades
automatically makes sense because it gets us better test coverage of
codepaths that will need to be rock solid later, and it drastically
reduces the amount of compat code I have to carry around. I'm hoping to
get several more on disk format features done while we're still in the
experimental phase - for inode allocation improvements, fsck performance
improvements, and assorted other odds and ends.
