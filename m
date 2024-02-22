Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B050A98
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 Feb 2024 13:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708608118; cv=none; b=fnMNC1qCQLywelU9EeYDCe3RQWQ25FT1EnSefrI019aEzABqvtZbop6/xRCeBAH+u67nUhxWOkqAHncAc+nttQ9FOGIawXvmOH78dDR4Yp6y6kHrt7MrbLRDZhX5qowm8sXRtHpjcjv7TrxDXlfXoTwlXbJQprMg74tkX2k/npQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708608118; c=relaxed/simple;
	bh=r9pchHV/VKVdQAsNxN4FRRok863wUbwJ2ZFTGYRsVyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVKZ78EFC3ykbPgBAdvbvrI0BZ1UPRplD/z6mmfaVDDbyTv0MKjvttvEEWXQkZxWWaE+vczQ0tUGj1WLW6t4tiSAcWuLiDzk4XtPdFOcu+sx4z0GGW1nONsnr8hHJUi9pkPV+Af4oAVP2gC1tPAChCPdJg78bdivHcQ4TGxvDos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1zwG5cQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1zwG5cQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708608115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vvnoi3gxxb5piLgIp9jCALAJ4khy9KvaO5KQ84qQBNM=;
	b=A1zwG5cQT/WhsAbjt9S4XbDGFUlfRjD9EKW6KiMJCCzZ3v7G5LypkT1Y0Bf7iqjw4BA5LG
	UuX8VfAZ8dsXDlrMRRY40FfH+RaMWg2udYf9RE+l17pHjtciRKMU6G/5zd+5qYhAKFXbG2
	CbIfDoVux7bpOIioHox86AquJSSGOgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-A_pRdYkJOqu-zRNzv1HWeA-1; Thu, 22 Feb 2024 08:21:52 -0500
X-MC-Unique: A_pRdYkJOqu-zRNzv1HWeA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73B3710AFD62;
	Thu, 22 Feb 2024 13:21:51 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.149])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B3F01492BE7;
	Thu, 22 Feb 2024 13:21:50 +0000 (UTC)
Date: Thu, 22 Feb 2024 08:23:09 -0500
From: Brian Foster <bfoster@redhat.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, Tony Asleson <tasleson@redhat.com>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <ZddKvWVjyOg1ENz+@bfoster>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
 <Zc5CH7rzhzbrLzyV@bfoster>
 <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
 <20240216080017.GA11646@lst.de>
 <Zc9XwqqDk/NC2j4b@bfoster>
 <iv32eaej2g7fgkaaq4ghe7ekt52degs43vecwdsd56gvzwteyr@hhdjqokbki4o>
 <ZdXvFT+Rl439kUMo@bfoster>
 <w4uqoqykzazwyqcmlz4bamxpqloxfbitipgigzxmccqczlixp2@yr4bizgz5kqk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <w4uqoqykzazwyqcmlz4bamxpqloxfbitipgigzxmccqczlixp2@yr4bizgz5kqk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Wed, Feb 21, 2024 at 07:07:37PM -0500, Kent Overstreet wrote:
> On Wed, Feb 21, 2024 at 07:39:49AM -0500, Brian Foster wrote:
> > On Fri, Feb 16, 2024 at 10:57:24AM -0500, Kent Overstreet wrote:
> > > On Fri, Feb 16, 2024 at 07:40:34AM -0500, Brian Foster wrote:
> > > > On Fri, Feb 16, 2024 at 09:00:17AM +0100, Christoph Hellwig wrote:
> > > > > On Thu, Feb 15, 2024 at 07:24:23PM -0500, Kent Overstreet wrote:
> > > > > > > It looks like the warning could be avoided in bcachefs by checking for
> > > > > > > whether the parent dir/node still exists at cleanup time, but I'm not
> > > > > > > familiar enough with kobj management to say whether that's the
> > > > > > > right/best solution. It also looks a little odd to me to see a
> > > > > > > /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> > > > > > > do such a thing in the block sysfs dir(s).
> > > > > > > 
> > > > > > > Any thoughts on this from the block subsystem folks? Is it reasonable to
> > > > > > > leave this link around and just fix the removal check, or is another
> > > > > > > behavior preferred? Thanks.
> > > > > 
> > > > > This is the general problem with random cross-subsystem sysfs reference,
> > > > > and why they are best avoided.  The block layer tears down all the sysfs
> > > > > objects at del_gendisk time as no one should start using the sysfs files
> > > > > at that point, but a mounted file system or other opener will of course
> > > > > keep the bdev itself alive.
> > > > > 
> > > > 
> > > > Yeah, makes sense. The fact that the dir goes away despite having the
> > > > bdev open is partly what made this seem a little odd to me.
> > > > 
> > > > > I'm not sure why bcachefs is doing this, but no one really should be
> > > > > using the block layer sysfs structures and pointers except for the block
> > > > > layer itself.  
> > > > > 
> > > > 
> > > > From Kent's comments it sounds like it was just some loose carryover
> > > > from old bcache stuff. I had poked around a bit for anything similar and
> > > > it looked to me that current bcache doesn't do this either, but I could
> > > > have missed something.
> > > > 
> > > > > > so there's an existing bd_holder mechanism that e.g. device mapper uses
> > > > > > for links between block devices. I think the "this block device is going
> > > > > > away" code knows how to clean those up.
> > > > > > 
> > > > > > We're not using that mechanism - and perhaps we should have been, I'd
> > > > > > need a time machine to ask myself why I did it that way 15 years back.
> > > > > 
> > > > > Well, at least Tejun had a very strong opinion that no one should be
> > > > > abusing sysfs symlinks for linking up subsystems at all, see commit
> > > > > 49731baa41df404c2c3f44555869ab387363af43, which is also why this code
> > > > > is marked deprecated and we've not added additional users.
> > > > > 
> > > > 
> > > > Thanks. I'll send a patch to remove this once I'm back from vacation.
> > > 
> > > No, we can't remove it - userspace needs to know this topology. When
> > > we've got one sysfs node with a direct relationship to another sysfs
> > > node, that needs to be reflected in syfs.
> > > 
> > 
> > Do you mean that some related userspace tool relies on this to function,
> > or generally disagreeing with the statement(s) above around links from
> > /sys/block/<dev>/?
> 
> I would have to do some digging to give a definitive answer to that
> question.
> 
> bcache definitely needed those links (IIRC in udev rules?) - bcachefs
> may not, but we haven't even started on integrating bcachefs with all
> the userspace disk management tooling out there.
> 

I don't know bcache that well, but I didn't see anything obviously
putting links in the bdev dir when I last looked. It did look like it
created some links between its own sysfs dirs, but maybe I
misinterpreted the code.

I don't think that any other fs with its own /sys/fs/ presence (i.e.,
XFS, ext4, btrfs) does this sort of thing, so I'm a little skeptical of
the idea that userspace currently needs it (not necessarily that it
couldn't use it for the better in the future).

> And this is stuff that userspace does in general need; if we're getting
> by without it for other filesystems right now it's probably by doing
> something horrid like parsing /proc/mounts; if we could get filesystems
> using the same bd_holder stuff that other block layer stuff uses, that
> would be _amazing_
> 

Ok, but that sounds contradictory to what the block layer folks want.

I dunno, it seems to me that the notions of better general coordination
between /sys/block and /sys/fs and that of bcachefs' current behavior
being wrong are not mutually exclusive things. But I'll just leave it
alone until there's some more clarity here..

Brian

