Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1DF221260
	for <linux-bcachefs@vger.kernel.org>; Fri, 20 Jun 2025 08:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750407282; cv=none; b=FSw9wGjQ+ya35k6E+Fr5HB0+BQM+NoN/uxN2n8+SQvijNnROGKHL2bq4cnTfDVruyf9F06EeQ8gjn24sl93F4+U7cx06dwRNOAALOvhvgCr9NbSTHzhuVh92gAnb56s3vFdbIfP14jXd0UwjcnIZWMOTXE8BlAXEhfiumTOol50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750407282; c=relaxed/simple;
	bh=xfDkOff2/cp56isNgBDL74wTO4PNdFCvihi5zbefZmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CD5JZrsjom/3wV6u59OvITbD7zPVwBp2FvGdBilGHV2d1Ty0Wg/DLXHThGOYMQ0i+M9GKxoCJ+EyHvH4gQzKmOq6194jAspEilPoNl7jk2GKIp1NBF6drz8K1ofR1+jcJw+7MyBEpe2oK9ijfqtXFHjDmzQdlg5EM1BjF+NQ3RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ECCjE4i+; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ECCjE4i+"
Date: Fri, 20 Jun 2025 04:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750407268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ekidZJ9vjPqyDhRKbJdtTMUi2Cve88x65UZUoS2Frl8=;
	b=ECCjE4i+Dds9rWpM99wY2zCPSK7fP73/Dgk1Uxqcl2IKNDzDjbHXxKJq3+ZsEtmAW+/6To
	xsfdf4QsnqCIz8eiKVtX8VmVSOCJnkoULtAH4XuWVwGKaqAP4Bm5gqTA1NZQtqVEDbf9AK
	xRaZVOiHyDXsydgfyqvT8OnMJLCnS7U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Jani Partanen <jiipee@sotapeli.fi>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.16-rc3
Message-ID: <hewwxyayvr33fcu5nzq4c2zqbyhcvg5ryev42cayh2gukvdiqj@vi36wbwxzhtr>
References: <4xkggoquxqprvphz2hwnir7nnuygeybf2xzpr5a4qtj4cko6fk@dlrov4usdlzm>
 <06f75836-8276-428e-b128-8adffd0664ee@sotapeli.fi>
 <ep4g2kphzkxp3gtx6rz5ncbbnmxzkp6jsg6mvfarr5unp5f47h@dmo32t3edh2c>
 <3366564.44csPzL39Z@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3366564.44csPzL39Z@lichtvoll.de>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 09:12:21AM +0200, Martin Steigerwald wrote:
> Hi Kent, hi,
> 
> Kent Overstreet - 20.06.25, 03:51:45 CEST:
> > On Fri, Jun 20, 2025 at 04:25:58AM +0300, Jani Partanen wrote:
> > > On 20/06/2025 4.09, Kent Overstreet wrote:
> > > > I'm not seeing that _you_ get that.
> > > 
> > > How hard it is?
> > > 
> > > New feature window for 6.16 was 2 weeks ago.
> > > 
> > > rc<insert number here> is purely for fixing bugs, not adding new
> > > features and potential new bugs.
> > 
> > That's an easy rule for the rest of the kernel, where all your mistakes
> > are erased at a reboot. Filesystems don't have that luxury.
> > 
> > In the past, I've had to rush entire new on disk format features in
> > response to issues I saw starting to arise - I think more than once, but
> > the btree bitmap in the member info section was the big one that sticks
> > in my mind; that one was very hectic, but 100% proved its worth.
> 
> Kent, from what I gathered, you'd like to change some window rules – at 
> least for filesystems or new-in-kernel filesystems.

There is a time and a place for rules, and there is a time and a place
for using your head and exercising some common sense and judgement.

I'm the one who's responsible for making sure that bcachefs users have a
working filesystem. That means reading and responding to every bug
report and keeping track of what's working and what's not in
fs/bcachefs/. Not you, and not Linus.

There's no need for any of this micromanaging, which is what this has
turned into. All it's been doing is generating conflict and drama.

> > For a lot of users, compiling a kernel from some random git repository
> > is a lot to ask. I spend a lot of time doing what amounts to support;
> > that's just how it is these days. But rc kernels are packaged by most
> > kernels, and we absolutely do not want to wait an additional 3 months
> > for it to show up in a release kernel -
> 
> Those users should probably not use BCacheFS right now already to begin 
> with but wait for it to be marked as stable?

I've often told people that they should probably wait before switching,
particularly when they need features that aren't ready yet (erasure
coding), and things are not yet so trouble free that I would recommend
normal users switch.

Besides the most basic "will it eat your data", there's a lot of other
things to consider, like "is it providing stable backports yet" (I'm
explicitly not) or "is there wonky behaviour or missing APIs still to be
worked out" (yes, there definitely is, and I'm still triaging so there
will be awhile).

None of that changes my most basic responsibility.

> Kent Overstreet - 20.06.25, 03:09:07 CEST:
> > There are a _lot_ of people who've been burned by btrfs. I've even been
> > seeing more and more people in recent discussions talking about
> > unrecoverable filesystems with XFS (!).
> 
> And I have seen a lot of threads on XFS over the years where XFS 
> developers went great lengths to help users recover their data. I have 
> seen those threads also on the BTRFS mailing list. Those users had no 
> support contract, they did not pay anything for that free service either.
> 
> So I am not sure it is wise or even just accurate to implicitly imply that 
> other than BCacheFS filesystem developers do not care about user data. 
> From what I have seen I conclude: They do!

No, I'm not saying that they don't care about user data.

I know most of the other filesystem developers, particularly the XFS
ones; I'm not trying to disparage their work.

But track records do matter, and bcachefs has a good one, and I intend
to keep it that way.
