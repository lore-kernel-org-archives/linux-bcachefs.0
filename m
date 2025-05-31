Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8804A08
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748703833; cv=none; b=OqaMg0QCPV+fCWfQoW2vkQkOjAg+IhFykEjSK2jq5rTxkz6QbBvT6tg4z+MulY/Rns4vtyCO66sysBmrZ+Y7wrCMtX54Zh4pceJQ4cg2eQy5McNY8MZAsGNtY1ATwSpko15lGS/3Me9HlTdNmqRvOfGdp2D5cbJBc8Y5J6uJa1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748703833; c=relaxed/simple;
	bh=un+MI9p362n842N0o2XAdWEGDd9emvkGX3AnEiJ+wpg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJQJULphlUp7Fm4NOymz4+9I7afd6+tLQftzPk7WpqOsJeBrfB9p4/3LGeYW+DTmO7c0WZQ1q2ulbKL5oJS+o+ls4+5YPgQR80s7SkZv9UeejCsa3U/geBpaRhvvkDKP5FTTHkD8biZ+T2C5op5zn/iTs1ZAiUU08/vc4NKjPxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HjpbIlHY; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HjpbIlHY"
Date: Sat, 31 May 2025 11:03:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748703828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5a5K7/t9Iiy8knoi8wQkOCyFEh2p3BBDbxxhUudnvt8=;
	b=HjpbIlHYMTvfHr+mPew1li7eySOTVXLk+N1D0ZdKyGqsKfhhBWq7Cl8pNeUckOqECUWb1b
	RizzzJN1zRl8kW+IV/DAJ4eJSiVzTppfQHYULcM4U73O3xRmNqL+f3le38gn5TN06Gd71V
	FNN9hRdl4aM5kJ/qoqeS9BKvfOocot0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: linux-bcachefs@vger.kernel.org, 
	Martin Steigerwald <martin@lichtvoll.de>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Message-ID: <bhuiydsd4ovig4i2inltu4a325c35xc4zaxyaawdfrjzghgbtr@muphmxvcw7lq>
References: <3009813.e9J7NaK4W3@lichtvoll.de>
 <evvg4qltrboeynoj4j33zzrbr2atye6mywkhzy7l5i2ifehae6@ih62wyi2fsrr>
 <74199382-7c0f-440c-b7b6-45eabc95e332@huawei.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <74199382-7c0f-440c-b7b6-45eabc95e332@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, May 31, 2025 at 10:00:55PM +0800, Hongbo Li wrote:
> 
> 在 2025/5/31 7:16, Kent Overstreet 写道:
> > On Fri, May 30, 2025 at 11:19:32PM +0200, Martin Steigerwald wrote:
> > > Hi!
> > > 
> > > Summary: I am curious why "ls -l" reports 16 EiB as the size of a
> > > directory entry. As to what I can see the filesystem is perfectly fine.
> > > 
> > > Kernel 6.15, self compiled. 320 GiB BCacheFS on LUKS encrypted LVM.
> > > Checksums are xxhash. Filesystem was created recently on self compiled
> > > 6.15-rc7 with self-compiled bcachefs tools from git tag 1.25.2. "bcachefs"
> > > reports 1.25.1 as version number.
> > > 
> > > I have a directory entry that according to ls -l is quite big:
> > > 
> > > drwxrwxr-x 5 martin martin 18446744073709551400 DATE DIRECTORY
> > Yes, this is due to a leftover from the directory i_size patchset that
> > had to be reverted. As long as it's not causing issues it'll be a bit
> > before I get to it, I've got higher priority bugs I'm working on right
> > now (as usual).
> > 
> > Hongbo, whatever happened to that patchset? I thought you were going to
> > fix it so we could get it back in later?
> I'm very sorry for the directory i_size problem. And this work has been
> postponed recently due to my other internal works. Yeah, I will get back to
> this work after this Dragon Boat festival. I'm really sorry I haven't dealt
> with it sooner.

Ok, don't worry about it, the rest of it isn't urgent, just the i_size
fixes for the revert - I'll try to get that out today.
