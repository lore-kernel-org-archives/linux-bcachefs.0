Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C751F3D54
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 05:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745558624; cv=none; b=j96+0M3zlCy6ffvvv2FfVtwOHZ85rYchuLYd4FIWmTXo5CtLBtxdnXiSDJzKCivhATpeQnAQBGEEhCjqT8J13qNr7cF7WSb8/pwVkZqMz0eR1LFw9PeBJGMIM77ZEXXlvmvhICK+eDDno1uGkmEAAjxFwjGvpFufN6z5flejLuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745558624; c=relaxed/simple;
	bh=P85UBvVwwLE2/25v6N2A17Dlevs8b0WkQ/HkzC1CxzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fv/+Kp+r7PD+/OJD15f6x56tCbZQBowilIiDxFPrZHlZxBH+igkfDBTDcEibLlUDgwoohhtMQEhLueFR+g7tM53cRo7/qMSqhTT7Bblzt4904PbzfruPafOVLGk+CCjbNdgpebcIvDjtZWwxf+aN+96BvDQVvoIPqmPcQk91qko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U5TO52Gc; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="U5TO52Gc"
Date: Fri, 25 Apr 2025 01:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745558609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TEjl3oHzU4GEhZhAxuK3XPL4CPm97dGtMxo2IDEfG/E=;
	b=U5TO52GcC4YpyOtqBNQ+TvcX5KDKvTdJaYFegARiRvYR6QGhQeFiMX8Rg2BRH3sTAbfGrZ
	6fTkofH7/OG0jnyFiPxHjM7M5XNUE6b94EILw388tZov589lncqgxct6RPkJyPM/0oQYy6
	5kfA6MYdapRtaWQ3QY9woQj2juSGyrc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <tqmvxysim2bnbw6raw25k6d4cjppaqibwarh7rt5wjyphdj75d@7roc5fwin7y7>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 25, 2025 at 12:52:05AM -0400, Kent Overstreet wrote:
> On Thu, Apr 24, 2025 at 09:20:53PM -0700, Linus Torvalds wrote:
> > On Thu, 24 Apr 2025 at 19:46, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> > >
> > > There's a story behind the case insensitive directory fixes, and lessons
> > > to be learned.
> > 
> > No.
> > 
> > The only lesson to be learned is that filesystem people never learn.
> > 
> > Case-insensitive names are horribly wrong, and you shouldn't have done
> > them at all. The problem wasn't the lack of testing, the problem was
> > implementing it in the first place.
> 
> While I agree with you in _principle_, on this specific subject -
> 
> This is all irrelevant given that the purpose of the operating system
> and the filesystem is to support users and the applications they want to
> run.
> 
> And the hacks for doing this in userspace don't work.
> 
> And the attitude of "I hate this, so I'm going to partition this off as
> much as I can and spend as little time as I can on this" has all made
> this even worse - the dcache stuff is all half baked. Stroll through the
> ext4 and xfs code and find all the comments to the effect of "yeah, we
> should really do this better _eventually_"...

And you can always tell when this attitude comes up, because you end up
with code that's 10 times more gross than it has to be.

Quotas are the other big one. You can tell no one wants to be working on
that code, and as a result it's just horrific.

Quotas aren't my favorite thing, but if a job needs to be done, do it
right.

And we've got an established need for both quotas and case insensitive
directories.

So I don't want any whining about "bad" they are. I want them to work,
and I want the code to be clean and maintainable, and not make my eyes
bleed when I have to go and debug it.
