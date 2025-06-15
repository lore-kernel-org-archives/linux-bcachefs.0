Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E621DA53
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Jun 2025 12:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749991901; cv=none; b=A7Qcste6iqPcWYFdi2u3Dd6+fiTDWf8uPfAhza8zgvNMXVKCQvVz5UbmmpWp4ZCTDL5dxHOznESNPaFJyCKyJj0R3h07sdFm8pYiXflycutJ7quXnAZLfrAdgMfn512WJzT0L1rpkw9yObEsmRBK+EvshOh0AMNDk56JEmlB4a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749991901; c=relaxed/simple;
	bh=rIu+nyoT4DsdE1e8M6uy7FUwZyf6AC6QDKKjwkiKLG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gZPJ4ZmIYyK8oUqv361oSJI8bEzOrxt74Wu8fUBC66UyUHD5vhqpplIFftAk8PMHT1MsQLVwRHQtKTX468AF3Y8xursZLMHid97WYLZogBjrgrMtParm8nQng+fJmfIQkHBwyK/l7Hx2JYLrIahnNK7T5G8a8y/oDFK47g2lWag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=BIiJU5yH; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="BIiJU5yH"
Date: Sun, 15 Jun 2025 08:51:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749991892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DRQlDgAisRNzU0nb1lDrXzBLLNIfvoiz7mv7hFL+ONM=;
	b=BIiJU5yH1ivNc6BcvQDTKB3yULZQgK/DmVrvIHShs5NjkrzNIjbW71Xv0LuIjndvYUDxYg
	myvkQ6ME2na+Iej/QUj9AnbFhKHW81M8xTXFNME+3BR2cSumFULlVS87RCwGDPIdFw+kmA
	tbWUfa7gnNoOP4uj0pfMZU7cokk9gPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Aaron Friel <mayreply@aaronfriel.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Issues setting durability on new devices in bcachefs
Message-ID: <yfxm2uhmxqavi5p5q5l5hbcn5sgrl7tviccclav2qr65muvd4u@jawmmtvgljsd>
References: <MW4PR05MB99934C43FB32313C921D7765B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
 <qj5wzirldvxhd6om54mnzenq52hdh25zbvzhtirdgumo4zwh5o@hwccwflcdvyo>
 <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR05MB9993BFE56AEF738F894D5586B571A@MW4PR05MB9993.namprd05.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 15, 2025 at 06:05:52AM +0000, Aaron Friel wrote:
> I'm looking to see if I can submit a patch to fix this, but it seems
> like the durability bit field for devices may be only 2 bits, is that
> right?

That gets you values of 0-3. Why is that not enough?

> 
> --- 
> 
> previous thread follows (sorry my mail client doesn't quote everything in the usual mailing list style. If that's preferable let me know, but it's a chore to format things correctly using my phone
> 
> ---
> 
> > Hey Kent,
> >
> > I reported an issue on Reddit with bcachefs, attempting to set durability > 1 on an additional device in the pool. Not having the best luck!
> >
> > https://www.reddit.com/r/bcachefs/comments/1lbpxvs/unable_to_set_durability_on_new_devices_segfault/
> >
> > It looks like Fedora 42 is still on 6.14, so maybe this is fixed with
> > a kernel bump or a new version of the tools? I hope so - would really
> > like to make use of it for a tiered array.
> 
> It's a tools bug. Check if it's still happening with the latest tools,
> and if it is I'll have a look.
> 
> Durability needs to be changed via sysfs, we don't have a commandline
> tool for setting device options (and I suppose we should, for
> consistency).
> 
> Also, reddit's been working out surprisingly well for bug reports, since
> it's the place that gets the most engagement from users. Bug tracker is
> still good for things that need to be filed so they don't get lost, but
> it's been a pleasant surprise :)
