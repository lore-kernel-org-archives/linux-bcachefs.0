Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE80B1E4A8
	for <linux-bcachefs@vger.kernel.org>; Fri, 19 Jan 2024 21:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705700054; cv=none; b=RgJWzad5H3CSGp0KRRlTRYuP2g835MYDQszoVjvdPw6dc/yN8U3H8FSqrqopr2UiXbX3DIFs2C5Q2q21b0WVfy5oe54f9AKwizwNHu18qlcRkVDmwjmgyABcTB0HRmad7kf0YvuY0DacjBv4P4/0/mf1GH5QreICHX7GobM05Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705700054; c=relaxed/simple;
	bh=Yh+o/gnGQFjtcs5YDaAfbW/99ZkPz0o4v0F0fI5Tmlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=retSAMf0xUsWIgkADdXTMo8aswRJosYVMLiXk1qD3k+BrjYKJdrBIXMlroQHFsu6jWnMrRsq7/NTpfeab8+Bq/yggHNl50wHH6Ir9J774S/R6iQnWvIaQs7U9DiReypM319PvBqBfOVivXmhs6eFKsDqPmMUhMQ1SaFwo3EOKsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IinR596w; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IinR596w"
Date: Fri, 19 Jan 2024 16:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1705700048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iu6wa/rK4pWrBKLxOWNu0O90Wa8WyeV3+r+u3h8jh4k=;
	b=IinR596wBybdI8NlUso85eN36G5vxLDEN+nkOaSfk4qtH3lYVBNeHWFqDfJ060ngmZLmC2
	1LS3qYu9ZxicNGWxq7KD4toKh81g09CHcN22PHP0eVr91BbL0mJX0qhIfPBUA0/OvlU7Gh
	IE9FY0LhRnaAdoYHCHbWdBalam2ATsA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mia Kanashi <chad@redpilled.dev>, linux-bcachefs@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [BUG] I/O timeouts and system freezes on Kingston A2000 NVME
 with BCACHEFS
Message-ID: <ijsmgkglg2eiy6fswgjj7utrtlq7weiih2afx2cssaaz2pjwem@wonvjbulvgsw>
References: <54fcc150f287216593b19271f443bf13@redpilled.dev>
 <c8f441c2-d662-43fc-9e8e-fc847428dbaa@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8f441c2-d662-43fc-9e8e-fc847428dbaa@kernel.dk>
X-Migadu-Flow: FLOW_OUT

On Fri, Jan 19, 2024 at 02:22:04PM -0700, Jens Axboe wrote:
> On 1/19/24 5:25 AM, Mia Kanashi wrote:
> > This issue was originally reported here: https://github.com/koverstreet/bcachefs/issues/628
> > 
> > Transferring large amounts of files to the bcachefs from the btrfs
> > causes I/O timeouts and freezes the whole system. This doesn't seem to
> > be related to the btrfs, but rather to the heavy I/O on the drive, as
> > it happens without btrfs being mounted. Transferring the files to the
> > HDD, and then from it to the bcachefs on the NVME sometimes doesn't
> > make the problem occur. The problem only happens on the bcachefs, not
> > on btrfs or ext4. It doesn't happen on the HDD, I can't test with
> > other NVME drives sadly. The behaviour when it is frozen is like this:
> > all drive accesses can't process, when not cached in ram, so every app
> > that is loaded in the ram, continues to function, but at the moment it
> > tries to access the drive it freezes, until the drive is reset and
> > those abort status messages appear in the dmesg, after that system is
> > unfrozen for a moment, if you keep copying the files then the problem
> > reoccurs once again.
> > 
> > This drive is known to have problems with the power management in the
> > past:
> > https://wiki.archlinux.org/title/Solid_state_drive/NVMe#Troubleshooting
> > But those problems where since fixed with kernel workarounds /
> > firmware updates. This issue is may be related, perhaps bcachefs does
> > something different from the other filesystems, and workarounds don't
> > apply, which causes the bug to occur only on it. It may be a problem
> > in the nvme subsystem, or just some edge case in the bcachefs too, who
> > knows. I tried to disable ASPM and setting latency to 0 like was
> > suggested, it didn't fix the problem, so I don't know. If this is
> > indeed related to that specific drive it would be hard to reproduce.
> 
> From a quick look, looks like a broken drive/firmware. It is suspicious
> that all failed IO is 256 blocks. You could try and limit the transfer
> size and see if that helps:
> 
> # echo 64 > /sys/block/nvme0n1/queue/max_sectors_kb
> 
> Or maybe the transfer size is just a red herring, who knows. The error
> code seems wonky:

Does nvme have a blacklist/quirks mechanism, if that ends up resolving
it?
