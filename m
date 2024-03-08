Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C4D1E4BE
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 23:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941327; cv=none; b=aMsx+qRxMnJB/LRzDh9XybIjVJtcNwzAiWlxOT5ojHpnkXteRAHJJ8jMB7u+DccPoE0TNNB1D35T6z74XKOo1bup5cyJkRLj+z7dV6yAM6zBQEih9oYF20LRL2W26eRlTnDHZUaneDCqc3SRDs9CnNOdZwcrUN7m9mHO/G3o030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941327; c=relaxed/simple;
	bh=xAo6/e9Cl8ICQiFNMc4aperG9NOmNOI1dBkm3384ocE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IsAMJvRIrvHGyl2hgPxTiy2ilc/gl+kFG9wcTQmd8WDWt334gRqBVyy5Wm1/4D1cClS5M0za322ejNjCsS8UDvtKYEZ8OP2GQ+8g/o19wQ9fL9VYpUREaFPJy4LwDjMZjbSfpSh7mNuOOicRP8V1GPi4wUs8jcm+Iv0F5V83Bsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=o/BPJbWm; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="o/BPJbWm"
Date: Fri, 8 Mar 2024 18:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1709941321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+WD0JcoKqUEsiIpaQuQdhjo0biH3PfB4tSSehO3PSGk=;
	b=o/BPJbWm8nNzO+l8ZO+EQAFax26wx5Nfze9ZnCF6SPfXCwnBMUBNAg8OsGCudYGg7QGywF
	4iQgB1YqGCUAh1sOwEIlTzN5EEywuKrQpFNtoQBFz4Wemrr33B8rTsBIjHJk4STVFTqc/m
	qIVIIPJgrTer4KxDgkniq7y/BDPiT8Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mike Fleetwood <mike.fleetwood@googlemail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [WIP] bcachefs fs usage update
Message-ID: <yyrmhuevljcnukg6uazcw3jwf5bffpda32eabxvl5eommkxzch@loxecv63dk4a>
References: <CAMU1PDhRCpqsie5G4jOdVsyOmaXa4naDjWFTvjm_RiDrAhwPRw@mail.gmail.com>
 <iloqkrwanqljkorf3tky4rskjqpnl4zqqklejjf3w3gfu3ezjp@uwr2xwhscjlz>
 <CAMU1PDjK=j+OfZhs1i7vPwWQ1E4VNx0t0XB-q4xeZ90_imOu1w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMU1PDjK=j+OfZhs1i7vPwWQ1E4VNx0t0XB-q4xeZ90_imOu1w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Mar 08, 2024 at 11:37:13PM +0000, Mike Fleetwood wrote:
> On Fri, 8 Mar 2024 at 01:23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Wed, Mar 06, 2024 at 11:14:45AM +0000, Mike Fleetwood wrote:
> > > On 2024-03-02 04:14, Kent Overstreet wrote:
> > > > I'm currently updating the 'bcachefs fs usage' command for the disk
> > > > accounting rewrite, and looking for suggestions on any improements we
> > > > could make - ways to present the output that would be clearer and more
> > > > useful, possibly ideas on on new things to count...
> > >
> > > [Sorry for any email thread butchering.  I've only just subscribed to
> > > the list and seen this in the archive.]
> > >
> > > Background:
> > > I'm working on adding some level of support for bcachefs into GParted.
> > > It wants to be able to report the FS usage (per device) of a file system
> > > to (1) display in the UI, and (2) to limit how small it allows a
> > > partition to be shrunk.  (I understand that bcachefs doesn't currently
> > > support shrinking devices).
> > >
> > > What I would like from bcache fs usage is:
> > > 1. To be able to get free and capacity figures for a device in an
> > >    unmounted bcachefs file system.
> > >    EG:
> > >    bcachefs fs usage /dev/$PTN
> >
> > that'll take some work, but should be doable
> >
> > > 2. To continue to be able to get free and capacity figures in bytes.
> > >    Using a command line switch is okay.
> >
> > json output?
> 
> Json output is not required.  Plain human readable text will do.

But it'll be a lot less fragile as things change and are added. We
really should be getting away from machine parsing of output intended
for humans.

> 
> None of the other file system tools provide json output so GParted just
> parses the plain text output they do provide.  These are the commands
> GParted runs and parses the output from to get usage figures for a few
> of the file systems it supports:
>   btrfs inspect-internal dump-super /dev/$PTN
>   dumpe2fs -h /dev/$PTN
>   xfs_db -r -c 'sb 0' -c 'print blocksize' -c 'print dblocks' \
>   -c 'print fdblocks' /dev/$PTN
