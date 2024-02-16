Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9980438F
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 00:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708043071; cv=none; b=XuwcrH1I7PMQbH6lPX9tDNtqdkEsifJHLHYleG5CNAGPMo9AVp6M5YPEkly3jxwaqMzwHDH4Rbl/+XNl+2iN0JsmZtY0aQsjcGJNr4tz4DdRyOy0d8svpguWoRu87xLw0dj1+PBFo7HV3/sJgopExoeGGPDeo4rlNZ6+pNdq0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708043071; c=relaxed/simple;
	bh=99FAE5uVyHrQ0UuVLiZHZUJilnVePBPHxYjwKsplU9M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYi00yEve94vxUCZBfaR/aW+rGJRDaQnUcv5hyVUJ4DDlZCJpcpYOesxZ6MsWSanFW9pZpqPOhY1CceftykEZnbe4YileYtnxWlqCNQGVPtG/P1UFHFfG+OZpGTIlCtw0piAvLWTB5Shifz0mOeYnD8r6xH4BVDmfFDAVpGpezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jnhooP/t; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jnhooP/t"
Date: Thu, 15 Feb 2024 19:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708043066;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RJvnwNU0Jm/jNhfKSAR/QPTE97PF7GzYu5HuiXZrjAc=;
	b=jnhooP/tfP6OkJY5VU4FfsmzAQbIfWl43vrGevgf/DTcnpZfrEH4ITg8k2K4nxbBCbjff6
	cGUp6HQyNEQHoAB3FPWzVAAGs7jZbpUbR2Wq+qQCTPkt+64jsR0ez5F36hAThKMMrVPQla
	hPpvaYVLQ2VFFa/jXcS83Bpszm8PUvw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Tony Asleson <tasleson@redhat.com>, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
 <Zc5CH7rzhzbrLzyV@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc5CH7rzhzbrLzyV@bfoster>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 15, 2024 at 11:55:59AM -0500, Brian Foster wrote:
> cc linux-block
> 
> On Thu, Feb 01, 2024 at 03:52:56PM -0600, Tony Asleson wrote:
> > Fedora 39 with 6.7 kernel with bcachefs support
> > 
> > Steps
> > 1. I created the bcachefs (using locally compiled git repo
> > f15633cce1b79e708e9debc21c7b8772df7c7a29)
> > # bcachefs format --replicas=2 /dev/sd[bcdej]
> > 2. mounted FS and wrote some files to it
> > 3. I removed one of the virtual disk drives from the VM, (/dev/sdj)
> > while the VM was running
> > 4. I wrote some more data to bcachefs FS
> > 5. unmounted the bcachefs FS
> > 
> > Got the following oops
> > 
> > ....
> > [90806.970165] bcachefs (sdj): error writing journal entry 429: I/O
> ...
> > [90850.012743] umount: attempt to access beyond end of device
> >                sdj: rw=6144, sector=8, nr_sectors = 8 limit=0
> > [90850.012747] bcachefs (sdj): superblock read error: I/O
> > [90850.013664] ------------[ cut here ]------------
> > [90850.013666] kernfs: can not remove 'bcachefs', no directory
> > [90850.013671] WARNING: CPU: 4 PID: 6892 at fs/kernfs/dir.c:1662
> > kernfs_remove_by_name_ns+0xba/0xc0
> 
> Hi Tony,
> 
> Firstly note that this is a warning, not necessarily an oops or crash.
> That aside, I am able to reproduce this pretty easily running a similar
> test as above on one of my local VMs.
> 
> It looks like the cause of this is that bcachefs creates a
> /sys/block/<dev>/bcachefs symlink on each block device associated with
> the mount. We attempt to remove the link at unmount time, but the async
> device removal has caused the sysfs parent dir to disappear and so the
> removal codepath warns about a NULL parent dir/node.
> 
> It looks like the warning could be avoided in bcachefs by checking for
> whether the parent dir/node still exists at cleanup time, but I'm not
> familiar enough with kobj management to say whether that's the
> right/best solution. It also looks a little odd to me to see a
> /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> do such a thing in the block sysfs dir(s).
> 
> Any thoughts on this from the block subsystem folks? Is it reasonable to
> leave this link around and just fix the removal check, or is another
> behavior preferred? Thanks.

so there's an existing bd_holder mechanism that e.g. device mapper uses
for links between block devices. I think the "this block device is going
away" code knows how to clean those up.

We're not using that mechanism - and perhaps we should have been, I'd
need a time machine to ask myself why I did it that way 15 years back.

But rather than switching to that directly, this should probably be
getting handled for us by more standardized vfs/sysfs code.

block layer wise, all the bd_holder stuff has been getting improved
recently, that's one thing to look at; we might want the holder that's
passed to blkdev_get_by_path() to be directly reflected in sysfs.

And Greg and Darrick have also both been making noises about wanting to
unify some sysfs stuff too - maybe filesystems should be using the
blockdev holder thing that dm uses.
