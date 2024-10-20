Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E0BA33
	for <linux-bcachefs@vger.kernel.org>; Sun, 20 Oct 2024 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729443591; cv=none; b=XX+XFypx+mVpV90heLzpGAG4av6LuC13rHwqyuakBbfIs/7T/DCyZxPyN/lsVu1aDEJ+7Ubn/hyjul3+++XjVSZ3TU9bqQmTNJL+albpqGl/Uo+EseM6fvk6Lv01W2JrARCgyV+4kv2EASi10Vi9gDI8AVHd2O+DFKSvG3zKkSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729443591; c=relaxed/simple;
	bh=jSrHq3ebqLxlZ8HFdjLtoaGBwdoXxg9J5hSF5TyMbcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=panKqVv0eXeHW7mlhhGOfnzlJsgh/voDeVzqu+sCTD1YkzPNEpIQxVvF0/xBo9n4e8U0kAR4vaBfxtMfNxBG1Rc09kbJLPPlXHLZLrGQkRGoh2PgY2TFUBSxLhOfZ82JILsetkFChD6Sl9zEuvS9crRRco+C1jA+m5F/81N7MYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kBo/FG4F; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kBo/FG4F"
Date: Sun, 20 Oct 2024 12:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729443584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jELXNVp0eae9rWddz0phgrsODaZzM456Ru8UX+mPe+Q=;
	b=kBo/FG4FsBibJ2+wz/JHnASdFdQT6iadYgGAXEa26JAszeXt7PQHKpUIjd9PvB4YEaG3sz
	Lh6N7zFH3wR6F9MrrGFgdbwJMoHHMctauzGDGHVYSIbHGGzw0fTT7QO0UMYcLN3z88xu9y
	gL3IS8o6Vx9UQkI1KSrJHlhLt6LfDj4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Christopher Snowhill <chris@kode54.net>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <kadahbpbnfzxck7a5peye2rdvoi5w5omvhcloocqr5lypxrvse@tdddqahswipx>
References: <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
 <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
 <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249157619.1105.1729296906241@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Fri, Oct 18, 2024 at 05:15:06PM -0700, Carl E. Thompson wrote:
> 
> > On 2024-10-18 12:12 PM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > ...
> 
> > It sounds like you should go back to ZFS then.
> 
> If you tell me you don't want me testing bcachefs anymore it won't
> hurt my feelings and I'll respect your wishes. There are plenty of
> quality filesystems for me to use where I'll have less hassle. But I'd
> suggest to you that pushing out testers who point out bugs and try to
> offer constructive criticism isn't the best way to make quality
> software.

Testing is fine.

I have a lot of users and testers that I work with, and will bend over
backwards for if something is broken, and to make sure data isn't lost.

But I do draw a line at being demanding, or all the "constructive
criticism" that comes with an attitude of "I know your job better than
you do". You wouldn't walk into someone's office and immediately start
telling them how to do things, would you?

I don't suscribe to the modern theories about how we all have to be nice
to each other and always use nice words, if you're legitimately pissed
off because I screwed up and shipped something broken and it ate your
data and now you're screwed if it's not recovered - that's one thing.

Making sure your data is safe is why I'm here, and if you want help with
recovering a filesystem, I'll always help with that.

But you're complaining about an EOL kernel, where the issues have long
been fixed, so in this case there's just not a lot I can do. I could ask
Greg to cut a new 6.9 release, but all the distros have been told that
6.9 is EOL so it's not likely it would be widely deployed.

> > I have been hearing a lot of people complain about regressions in
> > amdgpu. Have you taken that up with them?
> 
> I personally have not because other people already have. They're aware of the issues and I'm confident they'll fix them.
> 
> > The capability of doing seamless, automatic upgrades and downgrades, to
> > the extent that bcachefs can, is something new that other filesystems
> > don't have.
> > 
> > And it's been incredibly useful. Without it, rolling out the disk
> > accounting rewrite wouldn't have been possible - and that got us per
> > snapshot ID accounting, compression type accounting, per-btree
> > accounting, and per-inode fragmentation accounting (not all of these are
> > exposed to the user yet, but they're there).
> > 
> > While bcachefs is still marked experimental, doing these upgrades
> > automatically makes sense because it gets us better test coverage of
> > codepaths that will need to be rock solid later, and it drastically
> > reduces the amount of compat code I have to carry around. I'm hoping to
> > get several more on disk format features done while we're still in the
> > experimental phase - for inode allocation improvements, fsck performance
> > improvements, and assorted other odds and ends.
> 
> What you say here makes perfect sense. But I also think it's risky.
> That's the point I was trying to make.

Anyone can build a bridge that doesn't fall down, it takes an engineer
to build one that just barely doesn't fall down.

There's is always some level of risk to developing new capabilities and
deploying new code, and we have to balance those risks against the worth
of those capabalities, along with all of our priorities.

The ability to upgrade to a new on disk format, and then seamlessly
downgrade - that hasn't been done before, keep that in mind, and that's
an enormously useful capability that makes it dramatically _less_ risky
to deploy new features.
