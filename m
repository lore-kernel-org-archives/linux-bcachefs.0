Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
	by smtp.subspace.kernel.org (Postfix) with SMTP id C5F96133288
	for <linux-bcachefs@vger.kernel.org>; Thu, 15 Feb 2024 15:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.131.102.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708010403; cv=none; b=H2Y9FlhxOvWTPXSgCsJ5SzydJR0b5xYaL6oK5lcHLlX5NXPr8qymwtXZEvg0ZeRDkHwuQLtT5O+t3JZKCZuoCi8N6C2faKrzqkvwlrwxf9WNAii/bF4/uusUhbUxs0f5Me4UjYBu0uoZIsetKQjloIWf5c5MSykUMs3eK/ZxvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708010403; c=relaxed/simple;
	bh=Jx+iRtNlS80TV4/SAvkSPzKcQEUz7hjxzT++6QCGkv8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eyh0MV7FDuJ/9qqzGiOSYcJkdQryNRi82lBWd2OrjIhOE9xMKjWeuoGXcNZVq4RvwAuoMk9Nv+sa65sL4zaLPOGTadOQ+126h1a4+pq6qg+jNZfWflNug7UshTn/OxrUv4O9X3z3TboOBC8/NoekPBCQQvly6ldinCmjUw/h1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu; spf=pass smtp.mailfrom=netrider.rowland.org; arc=none smtp.client-ip=192.131.102.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netrider.rowland.org
Received: (qmail 434834 invoked by uid 1000); 15 Feb 2024 10:19:54 -0500
Date: Thu, 15 Feb 2024 10:19:54 -0500
From: Alan Stern <stern@rowland.harvard.edu>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, stable@vger.kernel.org,
  regressions@lists.linux.dev, linux-usb@vger.kernel.org,
  Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
  linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Message-ID: <eec1464d-4e9f-48b5-b619-868f0e5c1d4d@rowland.harvard.edu>
References: <1854085.atdPhlSkOF@lichtvoll.de>
 <6599603.G0QQBjFxQf@lichtvoll.de>
 <ypeck262h6ccdnsxzo46vydzygh2y6coe3d4mvgermaaeo5ygg@4nvailbg7ay3>
 <1979818.usQuhbGJ8B@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1979818.usQuhbGJ8B@lichtvoll.de>

On Thu, Feb 15, 2024 at 12:09:20PM +0100, Martin Steigerwald wrote:
> Kent Overstreet - 12.02.24, 21:42:26 CET:
> 
> [thoughts about whether a cache flush / FUA request with write caches 
> disabled would be a no-op anyway]
> 
> > > I may test the Transcend XS2000 with BTRFS to see whether it makes a
> > > difference, however I really like to use it with BCacheFS and I do not
> > > really like to use LUKS for external devices. According to the kernel
> > > log I still don't really think those errors at the block layer were
> > > about anything filesystem specific, but what  do I know?
> > 
> > It's definitely not unheard of for one specific filesystem to be
> > tickling driver/device bugs and not others.
> > 
> > I wonder what it would take to dump the outstanding requests on device
> > timeout.
> 
> I got some reply back from Transcend support.
> 
> They brought up two possible issues:
> 
> 1) Copied to many files at once. I am not going to accept that one. An 
> external 4 TB SSD should handle writing 1,4 TB in about 215000 files, 
> coming from a slower Toshiba Canvio Basics external HD, just fine. About 
> 90000 files was larger files like sound and video files or installation 
> archives. The rest is from a Linux system backup, so smaller files. I 
> likely move those elsewhere before I try again as I do not need these on 
> flash anyway. However if the amount of files or data matters I could never 
> know what amount of data I could write safely in one go. That is not 
> acceptable to me.
> 
> 2) Power management related to USB port. Cause I am using a laptop. It may 
> have been that the Linux kernel decided to put the USB port the SSD was 
> connected to into some kind of sleep state. However it was a constant 
> rsync based copy workload. Yes, the kernel buffers data and the reads from 
> Toshiba HD should be quite a bit slower than the Transcend SSD could 
> handle the writes. I saw now more than 80-90 MiB/s coming from the hard 
> disk. However I would doubt this lead to pauses of write activity of more 
> than 30 seconds. Still it could be a thing.
> 
> Regarding further testing I am unsure whether to first test with BTRFS on 
> top of LUKS – I do not like to store clear text data on the SSD – or with 
> BCacheFS plus fixes which are 6.7.5 or 6.8-rc4 in just in the case the flush 
> handling fixes would still have an influence on the issue at hand.
> 
> First I will have a look on how to see what USB power management options 
> may be in place and how to tell Linux to keep the USB port the SSD is 
> connected to at all times.
> 
> Let's see how this story unfolds. At least I am in no hurry about it.

This may not be an issue of power management but rather one of 
insufficient power.  A laptop may not provide enough power through its 
USB ports for the Transcend SSD to work properly under load.

You can test this by connecting a powered UBS-3 hub between the laptop 
and the drive.

Alan Stern
