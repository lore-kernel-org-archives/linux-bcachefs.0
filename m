Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3ED171CD
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729473357; cv=none; b=BETR63Yl4uHdlpYhbjahUNxaG0UMyfp8iWe2JnygkhHRza6Xnpaw0w39tHS/EnohuYcsvlmC0gjTuEbaTCkSC0r2hKMLohHh5cJnZ/e8orOWKCyF4hx6xoZGhzK/xeFX3q3z7WmTNyQxsXtkvdTZiWm2s1tBfn8r+VxjUj8SmUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729473357; c=relaxed/simple;
	bh=lNO8mGurnLTYYG+/mBwWBNoDKQK+FIk5iFIrcZC3uvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EC3GDd10EQQMlKYXbqs3PKAcNbfbPBba0evub9PgPfOk4nvtV/e3htUBh6a6WA1ES+tALeDq/oIzlmrVHJdBCd1lsvXVsTneOR26B1WpkIM9nvEemX/9b7a1c/RI7pz4zYymGc4hAucq+nLfxWD3hycdeZCGcwPpwU4SDHnjoZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sJPJHLWh; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sJPJHLWh"
Date: Sun, 20 Oct 2024 21:15:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729473350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wIGwHd+nE6wRtpiqT7olYpYkv3EnJodauY4RZZZjQiI=;
	b=sJPJHLWhkkyTHD0GgX7MUmAolkpq+1bCjhrko85IvTO2CzbvIM+NayQnuZdYPk43m2qMtM
	i88A2lc6+MUg9wlkk/2d32dcES7CYsjYan73S4vWUPzOADhCZnAzFgkamibSKsgU84q5Zs
	EULgBnRr7Oth1Zlm/bb4SDU7uAQRFV0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Christopher Snowhill <chris@kode54.net>, 
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <nvs2h7qmf3fsffrnh4rus7hhdkxh7fjfjnzfv7rgqrb43udzyj@lutkh4gkoiya>
References: <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
 <884724407.902.1729158319260@mail.carlthompson.net>
 <tklgk7y5drm5idjqogdccdciodtgwwjuaa6ziel5uxezeaws7u@fwbthprkau3e>
 <504302838.942.1729183773058@mail.carlthompson.net>
 <D4YS7TRT48VG.3LCDBSZGAVBSZ@kode54.net>
 <537913254.1059.1729273074517@mail.carlthompson.net>
 <od4yumygu66vn6hi2ptykbayrqeelqdciwvfrsbmthso7rzbqy@v4ba3bzceluw>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <kadahbpbnfzxck7a5peye2rdvoi5w5omvhcloocqr5lypxrvse@tdddqahswipx>
 <216190573.1599.1729470893479@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <216190573.1599.1729470893479@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Sun, Oct 20, 2024 at 05:34:53PM -0700, Carl E. Thompson wrote:
> 
> > On 2024-10-20 9:59 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > ...
> 
> > I have a lot of users and testers that I work with, and will bend over
> > backwards for if something is broken, and to make sure data isn't lost.
> 
> Absolutely. We've all seen you do that over the years. That's a big part of the reason why users like me spend so much of our own time and resources testing and supporting your work.
> 
> > But I do draw a line at being demanding, or all the "constructive
> > criticism" that comes with an attitude of "I know your job better than
> > you do". 
> 
> And I'm not doing that. I'm simply reporting bugs and offering perspectives that you may not have thought of for your consideration. I don't demand that you do anything because I **can't** demand that you do anything. 
> 
> I'll give you an example. More than a year ago I raised the issue that
> bcachefs does not allow multiple versions/images of a filesystem to be
> mounted at the same time. I pointed out that there are several
> professional workflows that require this (forensics, auditing, etc)
> and non-professional workflows too (retrieving a previous version of a
> file from an LVM snapshot, etc). I pointed out that other modern
> filesystems allow it and argued that it is a needed feature. You
> disagreed that it is that important and have never (to date)
> implemented the feature. This causes me to have to create special-case
> workarounds specific to bcachefs which operate differently than what I
> do for every other filesystem. Despite this extra work and
> inconvenience for me I have never brought it up again, never nagged
> you and never demanded that you listen to me and change your mind. I
> made my pitch, you made your decision and I accept your decision even
> if I don't like it.

If I came across as strongly disagreeing on that issue, I apologize.

On that issue, it's just that it's a really problematic feature for a
multi device filesystem - we have to have a unique identifier for
identifying the filesystem, separate from the block device, and if it's
not actually unique - what do we do?

Even for single device filesystems it's a problem, because some of our
userspace interfaces use that same unique identifier (sysfs, debugfs)
and a single device filesystem can become a multidevice filesystem at
any time.

So it's not impossible, but genuinely messy, and it's the kind of thing
I could see leading to landmines later, which makes me not particularly
eager to touch it. But if it keeps coming up, I may end up giving it
more study in the future.

> I'll also make the self-serving point that Linux isn't successfully
> only because of kernel developers like you it's just as much due to
> users like me. Back in the 90s I was once **literally** laughed out of
> a boardroom for presenting rationale for why my company should pivot
> from developing products on traditional Unices and start focusing our
> efforts on the new Linux thing. They disagreed; I left the company and
> within months they were out of business so I guess I got the last
> laugh. I didn't write fancy papers and become famous the way some
> people did back then but I have ever since relentlessly done my part
> by pushing every company I've worked for to be more successful by more
> fully leveraging the benefits of Linux. Now, of course, pretty much
> every company gets it. I advocate for Linux in my personal life too.
> And there are countless millions of other users who also contribute in
> their own ways big and small most of whom will never be known or even
> have conversations on kernel mailing lists but who are just as
> important and integral to the success of Linux.

Oh, absolutely. And if you come to the IRC channel, you'll see me
interacting with those users every day.

I could not have accomplished all this without their help.

But I'm the one writing the code, and I have a lot of demands on my
time, so sometimes I do ask people to chill out or be patient.

> > But you're complaining about an EOL kernel, where the issues have long
> > been fixed, so in this case there's just not a lot I can do. I could ask
> > Greg to cut a new 6.9 release, but all the distros have been told that
> > 6.9 is EOL so it's not likely it would be widely deployed.
> 
> I am **not** complaining about an EOL kernel. I explicitly stated that
> I **didn't** need a fix. I simply reported a bug that affected me
> which I was unaware had been fixed.
> 
> I do think that if you find and fix a bug like that it would be nice
> for you to document it and let users know about it so we can possibly
> avoid wasting a lot of our time and effort unnecessarily.

The best practice for users, while it's still experimental, is to stay
on Linus's tree. A lot of users are running the latest rc kernel these
days.

Not because of upgrade/downgrade shenanigans, aside from 6.9 that's been
generally working (I haven't tried 6.7 - perhaps someone could do that)
- but just because of all the fixes and improvements that are rapidly
happening. If you're testing you want to be testing and reporting bugs
on the latest, right? And because the rate of bugfixing makes
backporting anything but the most critical stuff infeasible for now.

(Seriously, the best way to support older kernels for now would be to
just periodically backport /all/ of fs/bcachefs/ to older kernels, and
if I thought Greg would be ok with that that's what I'd be doing).

Note that I do explicitly support users with old, even ancient
filesystems (someone just popped up with a 0.11 filesystem today! with
some seriously crazy corruption), it's just that adding old kernels to
that just adds a bit much to the matrix of things to keep track of for
now.

> > The ability to upgrade to a new on disk format, and then seamlessly
> > downgrade - that hasn't been done before, keep that in mind, and that's
> > an enormously useful capability that makes it dramatically _less_ risky
> > to deploy new features.
> 
> As I said previously I understand and accept your reasoning here. I
> think it's risky to believe you can ahead of time code in the ability
> to understand and correctly revert any possible format change you'll
> come up with in the future especially since the only reason we're
> talking about it is because it's already failed at least once. It's
> also a system that I believe can't be meaningfully tested without a
> time machine.

I'm not writing dedicated upgrade/downgrade code for every new feature -
that would be crazy. The upgrade/downgrade process just works by noting
which fsck passes have to be run, and which errors should be silently
corrected, which means it's quite robust (fsck has to work, after all).

The 6.9 bug was that the superblock downgrade section was being read
incorrectly and the latest entry was skipped - there was some trickyness
with the superblock section due to alignment, kasan popped up some
things and then the fixes were incorrect, whoops. 6.7/6.8/6.9 was a bit
crazy.
