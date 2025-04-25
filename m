Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC386334
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Apr 2025 04:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745556740; cv=none; b=GgPpA6Vkr4lYDBNWEyTWRd3IhKDTI+9gzSdlDV30Vg7d90Qe3GkbzDrjMvopM1CemamV+WJCmUfgvWusS1G+b1ObjFlZnBxf/VGOool6lR/+nCHcunDyMvcKkjP+2GMemfGJrZ+vqqMVE4JeuKfg5cmE7dwNakjKGuRSjSCL7mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745556740; c=relaxed/simple;
	bh=sYpbK9ht9/+EDXXnMErkvMAB/r9ylzJSuaM229Rnp3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dFzhgA0U1yEqXM7NG1/YGfHyJFWjOXfd5aOh6As3SEtaLIkcf2G1/aAzxDEtwinyP99w6GV2GocL3tAIaFk5JSWr2OYzirbXE6Wk7tyZr19xKkSdbJGbx6kL4Snb97tOLKq/GPGP6BEoxrBOm+Yod8i4Q+58nB5GcgAd/wBYSfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LsPf+i4G; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LsPf+i4G"
Date: Fri, 25 Apr 2025 00:51:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745556725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0q8NOUHEi971EMKXsRnOzg3dz3vI2tFwykmu0M0uoKA=;
	b=LsPf+i4G8QvHupX136T612TWsf6jpIp+q54AOFN4oStCBrtj2DtcSl4T3urjMO0NE8omSi
	SOlnLt6/7IcQKsdHCveq62v4D9ShBGR6JaDtA4ZqT95/bQSVwvv1upY1q4vRr6KZQsjOW4
	eTiVqJJemlg2Pr6GdSd2KDx99x3UNgY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Apr 24, 2025 at 09:20:53PM -0700, Linus Torvalds wrote:
> On Thu, 24 Apr 2025 at 19:46, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > There's a story behind the case insensitive directory fixes, and lessons
> > to be learned.
> 
> No.
> 
> The only lesson to be learned is that filesystem people never learn.
> 
> Case-insensitive names are horribly wrong, and you shouldn't have done
> them at all. The problem wasn't the lack of testing, the problem was
> implementing it in the first place.

While I agree with you in _principle_, on this specific subject -

This is all irrelevant given that the purpose of the operating system
and the filesystem is to support users and the applications they want to
run.

And the hacks for doing this in userspace don't work.

And the attitude of "I hate this, so I'm going to partition this off as
much as I can and spend as little time as I can on this" has all made
this even worse - the dcache stuff is all half baked. Stroll through the
ext4 and xfs code and find all the comments to the effect of "yeah, we
should really do this better _eventually_"...

And the security issues aren't even case insensitivy, it's just unicode.
But that ship has sailed too...
