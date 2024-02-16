Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CFC12F5B3
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 15:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708099052; cv=none; b=bZgEZVvkE3rmzWvuHYFG1SSQaKem6reZWT6dnJZOTB2F2DnnBlGFpwmSYoEaKZq8mj9Uu8sruAgR9OT6sQFeF2y3a+THF0Qai+ybnNtuM+rX2l54jOQpm50Tp3eRYSNiFsES7nqspX63jIMRAAbumlaxm92/NwkCrpQYpN0Qkc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708099052; c=relaxed/simple;
	bh=PAeh9gzfaa7F1or6Y09EtvcoBBItwsuHw0qTujOqoaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e+p3017M6lieGrCJJlxUQCOTZrSkXUbaWgyKtQLeWBVIOrBz5i/fShhLCKoWcrn3gUT00po+UnFLx1pZk8riQ7/72MP8D3yhX1kZyHpADFoH3jzCMIVfR2Qaup2N2FegM2fTe5WtT4hsupCU1aM/Zeey2X3EZV2yXUzkI24diOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iNkunASS; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iNkunASS"
Date: Fri, 16 Feb 2024 10:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1708099048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7bBSr9OVz4AGI5Lh5HFhwmsZ8SQwTm5am+3RkNbrrU8=;
	b=iNkunASSjGWwBeOXCFkYENCv+ZsySjg8dmdkxntXjKlOVv4nAH8OU3k6ZyZlKHn5JhJJkL
	M/jina9AfrimqFpw2qjALEg+hsSNfT6/twaypO3E/kAuuPyfJ42Zl8KBSF91hgYAA7NBF7
	8+rJwUwh1cCv5IpE4KTHHnUzk+JKufo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Tony Asleson <tasleson@redhat.com>, 
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Darrick J. Wong" <djwong@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <iv32eaej2g7fgkaaq4ghe7ekt52degs43vecwdsd56gvzwteyr@hhdjqokbki4o>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
 <Zc5CH7rzhzbrLzyV@bfoster>
 <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
 <20240216080017.GA11646@lst.de>
 <Zc9XwqqDk/NC2j4b@bfoster>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc9XwqqDk/NC2j4b@bfoster>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 16, 2024 at 07:40:34AM -0500, Brian Foster wrote:
> On Fri, Feb 16, 2024 at 09:00:17AM +0100, Christoph Hellwig wrote:
> > On Thu, Feb 15, 2024 at 07:24:23PM -0500, Kent Overstreet wrote:
> > > > It looks like the warning could be avoided in bcachefs by checking for
> > > > whether the parent dir/node still exists at cleanup time, but I'm not
> > > > familiar enough with kobj management to say whether that's the
> > > > right/best solution. It also looks a little odd to me to see a
> > > > /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> > > > do such a thing in the block sysfs dir(s).
> > > > 
> > > > Any thoughts on this from the block subsystem folks? Is it reasonable to
> > > > leave this link around and just fix the removal check, or is another
> > > > behavior preferred? Thanks.
> > 
> > This is the general problem with random cross-subsystem sysfs reference,
> > and why they are best avoided.  The block layer tears down all the sysfs
> > objects at del_gendisk time as no one should start using the sysfs files
> > at that point, but a mounted file system or other opener will of course
> > keep the bdev itself alive.
> > 
> 
> Yeah, makes sense. The fact that the dir goes away despite having the
> bdev open is partly what made this seem a little odd to me.
> 
> > I'm not sure why bcachefs is doing this, but no one really should be
> > using the block layer sysfs structures and pointers except for the block
> > layer itself.  
> > 
> 
> From Kent's comments it sounds like it was just some loose carryover
> from old bcache stuff. I had poked around a bit for anything similar and
> it looked to me that current bcache doesn't do this either, but I could
> have missed something.
> 
> > > so there's an existing bd_holder mechanism that e.g. device mapper uses
> > > for links between block devices. I think the "this block device is going
> > > away" code knows how to clean those up.
> > > 
> > > We're not using that mechanism - and perhaps we should have been, I'd
> > > need a time machine to ask myself why I did it that way 15 years back.
> > 
> > Well, at least Tejun had a very strong opinion that no one should be
> > abusing sysfs symlinks for linking up subsystems at all, see commit
> > 49731baa41df404c2c3f44555869ab387363af43, which is also why this code
> > is marked deprecated and we've not added additional users.
> > 
> 
> Thanks. I'll send a patch to remove this once I'm back from vacation.

No, we can't remove it - userspace needs to know this topology. When
we've got one sysfs node with a direct relationship to another sysfs
node, that needs to be reflected in syfs.

What I'm hoping for is that we can get filesystems in general to do this
right, not just bcachefs, so that they finally start showing up in the
tree lsblk reports.
