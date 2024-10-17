Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823151D8E06
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Oct 2024 09:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729157435; cv=none; b=IOlmfgrkdw5j/JRNsgO0UyNu7etV8t1T6JDPBR6khpQIZCkbts19tvxeTv03Njl1WtgKN0oVk1+e29XTaLYK2DUqSa7oKn7f5vIr25QsxQWIMzu9f47T24S2bHrz92iaU/vLLSO8XqR/rwJXaoF0RS+L/BOgSN0O6xhc2sN/nJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729157435; c=relaxed/simple;
	bh=q2/IWf1wu4lkXlokYjTuaFIA3MwobOzbLKlGXZnUghg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oehrYOBC3CYs3P8ZAzUS+o9kulvoWxL6Yqny1nfYZEOSGPv3kMYciZZeTlf5aIZGCizqFN3LUvmu7NvqOacX+wbfrn0UHzH2ZnZ+qc/Z7tjD+P1D0Lr5tCXjxWZYcBhA28WqHrSS9JuHHXAOENqglaUqYHWdSf93ywrJjjz7UaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ToUxK0SE; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ToUxK0SE"
Date: Thu, 17 Oct 2024 05:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729157428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2+sCnDOIjKi5DpptS+asIhrckSAAmPKU3WEdjy84nvk=;
	b=ToUxK0SE+j0UWIICevbbBREzrZw6iY3U3MbUzRrI6UTQiEerZN4QZg+Vbd5Q9hAQS5J/OO
	mbCPxqvWhu1W6hJHuwXuRuQIBh8ol0H/TrDMRbzJhdnmkmYJscZABxJA53eivldd3iLXG5
	4fK1f39GxnnTn1P3C9tQ7jW9kA1ATvU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Message-ID: <6hoo4ruf7fzgjyx5t4vazuj6bi7fx6ahmoof4wbuc3d6xeolmq@c4n7gvcj7bfv>
References: <873903780.802.1729054276600@mail.carlthompson.net>
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1823582410.854.1729153747302@mail.carlthompson.net>
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <724749266.890.1729156527639@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <724749266.890.1729156527639@mail.carlthompson.net>
X-Migadu-Flow: FLOW_OUT

On Thu, Oct 17, 2024 at 02:15:27AM -0700, Carl E. Thompson wrote:
> 
> > On 2024-10-17 1:39 AM PDT Kent Overstreet <kent.overstreet@linux.dev> wrote:
> 
> > ...
> 
> > Again - bcachefs was only merged in 6.7, clearly marked experimental,
> > and you're running 6.9; this kind of bug is exactly the sort of thing we
> > try to shake out in the experimental phase.
> 
> Not a bcachefs problem but as a distribution user I would have no idea
> that bcachefs was experimental. Every major distribution I've looked
> at recently includes the bcachefs module and tools and there is
> nothing to tell the user it's experimental. Only the person who
> actually configured the kernel (or people who read mailing lists)
> would know that it's experimental.

I'm honestly not surprised, when I met with the Fedora people just prior
to 6.7 I spent most of the meeting telling them to _slow down_.

> Perhaps if this is to be expected right now the bcachefs command line
> tool should output a big warning letting users know that bcachefs is
> experimental and might eat their data?

Honestly not warrented at this point, things have been stabilizing fast
and I'm likely 6 months or so from taking the experimental label off.

> > Also, a fsck would have sufficed, if you haven't ran that already.
> 
> That must be a different bug because that doesn't work. I still have
> the old filesystem images and I just tried fsck again, then mounted,
> then tried to unmount and immediately got the same filesystem lockup.
> Time to reboot. See below.

Please try 6.10 - I can't get any fixes into 6.9 anymore, but if you
still run into issues on 6.10 I can fix that.

And check 'bcachefs fs usage' first, that will tell us if disc
accounting is screwed up or if we're looking for something else.
