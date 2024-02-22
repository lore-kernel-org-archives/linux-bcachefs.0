Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A17628
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 00:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560465; cv=none; b=gl8GMU6+J39ZNDxvlYId0iDrce2Z/JXt/qesDG5lMaSlHmowvtOsn88HwvkhfAsRbdL2OkJcCaVG74KzS40qv7+/75Tzi3XS4e75Rc65Gi1R/6oqnKWOKz92sZws8VPKEIbsyHbGLr0T0YkXA3LFzUsSdVdvTt/GmxHvMNHMIFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560465; c=relaxed/simple;
	bh=oz2lnyphsZA+RdDxRIrtfI2CZmsESfKqMzGvC6yAmBA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y0xMn0WsVMEJnQ3bWirga2YnWYhubwHN++EOzaYWDFYzEkGTm5Ens5twV/39RGR775dLiq5ck1VEiEf5abTdvM6RGfh4C1CdodwpqmHpkI/4bYC+izn+8RAU5ahOO2UZbPYG6wF1tm0KrLdX43fQKzSVfChw8EBdM9FBHIq2O54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CNYgFIG9; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CNYgFIG9"
Date: Wed, 21 Feb 2024 19:07:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708560461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnwyKHQQIfiDONcTQRnWixVauzxmR9kKXO0QdiN5lkM=;
	b=CNYgFIG9Ib4r3JlXPAWjPcUf34ktmhTAqHZ6NcNTHFKhFbS2l5o+o7XtoOuCBJXGo9eKBM
	TopBFArNOkrFNi4Frj/HSOLrszOY1RdsA4yt0CWA/RcLkZYmOlyhS0+bLqajE52gvUogYB
	a9m8SDzjSxzsAeDh8Kq+i5OXoLR2Zpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Tony Asleson <tasleson@redhat.com>, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <djwong@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <w4uqoqykzazwyqcmlz4bamxpqloxfbitipgigzxmccqczlixp2@yr4bizgz5kqk>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
 <Zc5CH7rzhzbrLzyV@bfoster>
 <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
 <20240216080017.GA11646@lst.de>
 <Zc9XwqqDk/NC2j4b@bfoster>
 <iv32eaej2g7fgkaaq4ghe7ekt52degs43vecwdsd56gvzwteyr@hhdjqokbki4o>
 <ZdXvFT+Rl439kUMo@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdXvFT+Rl439kUMo@bfoster>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 21, 2024 at 07:39:49AM -0500, Brian Foster wrote:
> On Fri, Feb 16, 2024 at 10:57:24AM -0500, Kent Overstreet wrote:
> > On Fri, Feb 16, 2024 at 07:40:34AM -0500, Brian Foster wrote:
> > > On Fri, Feb 16, 2024 at 09:00:17AM +0100, Christoph Hellwig wrote:
> > > > On Thu, Feb 15, 2024 at 07:24:23PM -0500, Kent Overstreet wrote:
> > > > > > It looks like the warning could be avoided in bcachefs by checking for
> > > > > > whether the parent dir/node still exists at cleanup time, but I'm not
> > > > > > familiar enough with kobj management to say whether that's the
> > > > > > right/best solution. It also looks a little odd to me to see a
> > > > > > /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> > > > > > do such a thing in the block sysfs dir(s).
> > > > > > 
> > > > > > Any thoughts on this from the block subsystem folks? Is it reasonable to
> > > > > > leave this link around and just fix the removal check, or is another
> > > > > > behavior preferred? Thanks.
> > > > 
> > > > This is the general problem with random cross-subsystem sysfs reference,
> > > > and why they are best avoided.  The block layer tears down all the sysfs
> > > > objects at del_gendisk time as no one should start using the sysfs files
> > > > at that point, but a mounted file system or other opener will of course
> > > > keep the bdev itself alive.
> > > > 
> > > 
> > > Yeah, makes sense. The fact that the dir goes away despite having the
> > > bdev open is partly what made this seem a little odd to me.
> > > 
> > > > I'm not sure why bcachefs is doing this, but no one really should be
> > > > using the block layer sysfs structures and pointers except for the block
> > > > layer itself.  
> > > > 
> > > 
> > > From Kent's comments it sounds like it was just some loose carryover
> > > from old bcache stuff. I had poked around a bit for anything similar and
> > > it looked to me that current bcache doesn't do this either, but I could
> > > have missed something.
> > > 
> > > > > so there's an existing bd_holder mechanism that e.g. device mapper uses
> > > > > for links between block devices. I think the "this block device is going
> > > > > away" code knows how to clean those up.
> > > > > 
> > > > > We're not using that mechanism - and perhaps we should have been, I'd
> > > > > need a time machine to ask myself why I did it that way 15 years back.
> > > > 
> > > > Well, at least Tejun had a very strong opinion that no one should be
> > > > abusing sysfs symlinks for linking up subsystems at all, see commit
> > > > 49731baa41df404c2c3f44555869ab387363af43, which is also why this code
> > > > is marked deprecated and we've not added additional users.
> > > > 
> > > 
> > > Thanks. I'll send a patch to remove this once I'm back from vacation.
> > 
> > No, we can't remove it - userspace needs to know this topology. When
> > we've got one sysfs node with a direct relationship to another sysfs
> > node, that needs to be reflected in syfs.
> > 
> 
> Do you mean that some related userspace tool relies on this to function,
> or generally disagreeing with the statement(s) above around links from
> /sys/block/<dev>/?

I would have to do some digging to give a definitive answer to that
question.

bcache definitely needed those links (IIRC in udev rules?) - bcachefs
may not, but we haven't even started on integrating bcachefs with all
the userspace disk management tooling out there.

And this is stuff that userspace does in general need; if we're getting
by without it for other filesystems right now it's probably by doing
something horrid like parsing /proc/mounts; if we could get filesystems
using the same bd_holder stuff that other block layer stuff uses, that
would be _amazing_
