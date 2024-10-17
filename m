Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEDB762EB
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 08:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729154355; cv=none; b=QzRQGtJOSWh25EGJG1RM/+2FDfoKyGqsv6wuKUtArzC9RpJABVjCwasRGmTlVtmzFRlyn5Qt4EbzpUV1f6t1JykvlflsXQMRL8UQtkebZWtV8cJlbC0UdIBtM/hhBJ2ydPe0e/BVjIhIwtxwcgJJEfA4X/PcjpDWt6wFmKV23r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729154355; c=relaxed/simple;
	bh=8sm816OmXhGMdji4WgXIM4ls0m4EYP4guJyGaUKDTL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbaFvDpr98AB/cUwO8drTQXiZYanncG+TWpfW0WS0KezQgdgDq7ld2JCyz4CxhfvzUth7dWi1rc0eqqAjk7FL8B1uzWU/AdR5Z08Xop/wuVXcLbR89TgF8vfOu/Vyxc+1yhCVSOxtwuSM0f98t9k/GQhP+GKjl69vuTBdQORY0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=W+qYEc28; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="W+qYEc28"
Date: Thu, 17 Oct 2024 04:39:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729154349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wPm+IZ4xC1tWg3iR84e7/1ZFvnRNdsQzx7IZRnK5iM0=;
	b=W+qYEc28XwtmqxiaC2Xhn06UJU734Lp49kOMinM29P3kkqhCt5RsZU6qkiQgyZfiQcp1uz
	U8vRxtMgDemBJVytZvMSBOUPfDmJC5vN4Nlre3n4RvBXbI0yV+gtRIVrLDU/JKZTiFcqck
	MoOSq09FX0z4iWlTj9LAW6T2smZPYMc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1823582410.854.1729153747302@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 01:29:07AM -0700, Carl E. Thompson wrote:
> Unfortunately 6.10 and 6.11 aren't options for the normal use of my laptop. But I was easily able to recover from backups so no harm done and I'm back on 6.9.
> 
> I do think problems with being able to switch between different kernel
> versions are a pretty big deal, though. At least they are in my
> workflows. 

It absolutely is - that was a bug, and it was fixed, a year ago.

But 6.9 hasn't been getting updates for some time, and 6.10 has been, so
there's not really much I can do at this point. And you should be
running a kernel that's still getting updates.

> Would an approach similar to the one ZFS takes be better where the
> filesystem's on-disk format is never upgraded automatically but
> requires the admin to manually run an upgrade?

At some point we'll likely be switching to that model. But for right
now, while it's still marked experimental, it would be adding a lot of
overhead to add conditionals to all the code for new features, so that's
why I'm not doing it while we're still rapidly iterating - it wasn't
realistically possible with the disk accounting rewrite.

> Can tests be added to your test suite to make sure previous kernels
> can still access and use filesystems after they've been upgraded by
> newer kernels?

I have those tests now. They're not run automatically yet, and they
could use some improvement, but they're there.

Again - bcachefs was only merged in 6.7, clearly marked experimental,
and you're running 6.9; this kind of bug is exactly the sort of thing we
try to shake out in the experimental phase.

Also, a fsck would have sufficed, if you haven't ran that already.
