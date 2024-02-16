Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4066B1292D2
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Feb 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708087144; cv=none; b=G1UZqHl/O/5SVJeot20IGlvadNedJPhl5psRfiuMPlzLec7EI0jjWK6Mv9jFda7Jk1LaZLaKZgVSnI3X4mAnniLi/bA3mqf1azFbJIiKcrva2ff+Q1y8Vx4FbfAYKXjcbmWkIUrX5tHIw7k4U8GL3na/xuLjH9ajG/0eWfh3Io0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708087144; c=relaxed/simple;
	bh=5EKZb6TNT863wXX3Lvmy12vfF8pG1a8jnrQ0isOW27c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T7BC0TAJgpeJgJ7Qwqo3IB9lJ+3dwS1T4do2vX6Ws6iadpXLF4xn7H1tK28GMGN1C0MBzMM6Dj9QFyqvwa/55iNxztRP18fcfy9jqx5L16slFWT73y86A4gZnYaM0Hfsi5ggJdLvSXjfWgBKXCikSZCssC7zfj3MsIE2Pw2mOKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JHAqjdMe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JHAqjdMe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708087142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oa7UvV8KdZwSjl8Zmmim1/dOmcNk0qpBZHpK5NL82o8=;
	b=JHAqjdMeu5Jv44SRobqAZU6UFWi9W6bMM6UN3/2640p7+IqnauGD3BufyuhHTFdK/CJUP8
	n6C4s+D7zPskn5ublAgQNt/wd4PDMp6VqzLHzLvTqebIcnXFrESO/KI7oHOu7asmPC2qtF
	Bs0N+T4BXAa92GAaeYolN/7PiAL8Obs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-UZt9TL1YMh-YY6L1WpYktg-1; Fri, 16 Feb 2024 07:38:58 -0500
X-MC-Unique: UZt9TL1YMh-YY6L1WpYktg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F737835140;
	Fri, 16 Feb 2024 12:38:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.56])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AB6A08CED;
	Fri, 16 Feb 2024 12:38:57 +0000 (UTC)
Date: Fri, 16 Feb 2024 07:40:34 -0500
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Tony Asleson <tasleson@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-block@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Darrick J. Wong" <djwong@kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: kernel oops on bcachefs umount, 6.7 kernel
Message-ID: <Zc9XwqqDk/NC2j4b@bfoster>
References: <CAPmdA5YK_RuKpAtnfFrfcgZZReR2p1Q+A_DOMnFFrYm1QvrYnQ@mail.gmail.com>
 <Zc5CH7rzhzbrLzyV@bfoster>
 <6ozksyyljs4hzwcbitk3pqu3pbqttai42hbghwwww2rgdbnxzy@iz3cqxjgkfmn>
 <20240216080017.GA11646@lst.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216080017.GA11646@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Fri, Feb 16, 2024 at 09:00:17AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 15, 2024 at 07:24:23PM -0500, Kent Overstreet wrote:
> > > It looks like the warning could be avoided in bcachefs by checking for
> > > whether the parent dir/node still exists at cleanup time, but I'm not
> > > familiar enough with kobj management to say whether that's the
> > > right/best solution. It also looks a little odd to me to see a
> > > /sys/block/<dev>/bcachefs dir when I've not seen any other fs or driver
> > > do such a thing in the block sysfs dir(s).
> > > 
> > > Any thoughts on this from the block subsystem folks? Is it reasonable to
> > > leave this link around and just fix the removal check, or is another
> > > behavior preferred? Thanks.
> 
> This is the general problem with random cross-subsystem sysfs reference,
> and why they are best avoided.  The block layer tears down all the sysfs
> objects at del_gendisk time as no one should start using the sysfs files
> at that point, but a mounted file system or other opener will of course
> keep the bdev itself alive.
> 

Yeah, makes sense. The fact that the dir goes away despite having the
bdev open is partly what made this seem a little odd to me.

> I'm not sure why bcachefs is doing this, but no one really should be
> using the block layer sysfs structures and pointers except for the block
> layer itself.  
> 

From Kent's comments it sounds like it was just some loose carryover
from old bcache stuff. I had poked around a bit for anything similar and
it looked to me that current bcache doesn't do this either, but I could
have missed something.

> > so there's an existing bd_holder mechanism that e.g. device mapper uses
> > for links between block devices. I think the "this block device is going
> > away" code knows how to clean those up.
> > 
> > We're not using that mechanism - and perhaps we should have been, I'd
> > need a time machine to ask myself why I did it that way 15 years back.
> 
> Well, at least Tejun had a very strong opinion that no one should be
> abusing sysfs symlinks for linking up subsystems at all, see commit
> 49731baa41df404c2c3f44555869ab387363af43, which is also why this code
> is marked deprecated and we've not added additional users.
> 

Thanks. I'll send a patch to remove this once I'm back from vacation.

Brian

