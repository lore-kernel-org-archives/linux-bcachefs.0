Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107A1B80F;
	Fri, 16 Feb 2024 08:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708070424; cv=none; b=LBB29AS42QCDFuRaQAfW4/86fei3NFf0kH2H0JZp8/kLlSLPixSgEcTEA8vCzdtBm7SDN8NbEubnqvoAiqtDOoqmWaYMucfUPbv9nEDmWGRkDgSu28WroK9U2muKmK5Ume+We6fKpS0ON8+qrb1VZqP1lKRW/5SXigMTZhpAKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708070424; c=relaxed/simple;
	bh=0YnbHwIojrJOXMOhINJkzO4RrfRUPpBMYkB/sfGxAow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGjrGe1SYV8XgjCg3yrEPMteeNxSqdkU2A0hreSWMD8r8y3kBH97I9FhnQAcVGYLONH98oVhCSZtXZ/emIxwR6D1J+VAXMyUZSOJDwEos+hHhySj5sEhc74DlXLY0QFCkUE8HlSORvujO0cb59JfOtbzr3XUCtlwWdHXeMxYCrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8EE8D68BFE; Fri, 16 Feb 2024 09:00:17 +0100 (CET)
Date: Fri, 16 Feb 2024 09:00:17 +0100
From: Christoph Hellwig <hch@lst.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Brian Foster <bfoster@redhat.com>, Tony Asleson <tasleson@redhat.com>,
	linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <20240216080017.GA11646@lst.de>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com> <Zc5CH7rzhzbrLzyV@bfoster> <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 15, 2024 at 07:24:23PM -0500, Kent Overstreet wrote:
> > It looks like the warning could be avoided in bcachefs by checking for
> > whether the parent dir/node still exists at cleanup time, but I'm not
> > familiar enough with kobj management to say whether that's the
> > right/best solution. It also looks a little odd to me to see a
> > /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> > do such a thing in the block sysfs dir(s).
> > 
> > Any thoughts on this from the block subsystem folks? Is it reasonable to
> > leave this link around and just fix the removal check, or is another
> > behavior preferred? Thanks.

This is the general problem with random cross-subsystem sysfs reference,
and why they are best avoided.  The block layer tears down all the sysfs
objects at del_gendisk time as no one should start using the sysfs files
at that point, but a mounted file system or other opener will of course
keep the bdev itself alive.

I'm not sure why bcachefs is doing this, but no one really should be
using the block layer sysfs structures and pointers except for the block
layer itself.  

> so there's an existing bd_holder mechanism that e.g. device mapper uses
> for links between block devices. I think the "this block device is going
> away" code knows how to clean those up.
> 
> We're not using that mechanism - and perhaps we should have been, I'd
> need a time machine to ask myself why I did it that way 15 years back.

Well, at least Tejun had a very strong opinion that no one should be
abusing sysfs symlinks for linking up subsystems at all, see commit
49731baa41df404c2c3f44555869ab387363af43, which is also why this code
is marked deprecated and we've not added additional users.
