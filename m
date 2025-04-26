Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80D1B424F
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 03:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745639995; cv=none; b=PqANfCiQG5zdljX/Jra5UAuucNFvSJV7svPaC9N8PSJ1qAp6++KkMISY/BAI6V8yktxOd+C4TnI/kzZFIWhOsz8+U2O4Y2JZE9x/1FRBojmSmDdNTVqyI+5okc7glcgx0iKsKgDTwYKz7rTv/7F3MH96OKRd6+1B5ceFa0o8WXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745639995; c=relaxed/simple;
	bh=wrSq9RWI0GVzFpQQ2pzZObfsuqYX84mPI3FjVdf4KNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFyoc7W4AgyURucSK47zte52Y74cdgfdkT4vRJdr8DqFDjBeGIypJ/TzeBk+4uf4E2nipWZ2llM6rO9LKWYnpt44qUftBtfE7k3HdmEKhbYae26TCm1SLVVh/RyfC5B/Jcj06vgdYEnlS94aS0ZhASLGZScFoB3NeNmOeJYyPIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=j9L7ipVC; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="j9L7ipVC"
Date: Fri, 25 Apr 2025 23:59:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745639990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=42a9CcNpaAyyKeCs3vlzfwEx+fGgirdyRpOf+fcdZ+k=;
	b=j9L7ipVCxpZQw2CCXdzUHjBkvcvUkK95EOh47JE6Nu0x8ybfq0M1wghLqBqv2SkvFtYPrG
	yZQuuciIkpalJCRjw4Y3hb380gOHAZB1HkR9++FgLIjOiHhMXGK5XyYRWffU8HGMvp6zWr
	8lbg6c3h1kIfUWcJvsq95/5eoxIkreo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <opsx7zniuyrf5uef3x4vbmbusu34ymdt5myyq47ajiefigrg4n@ky74wpog4gr4>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
 <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
 <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki>
 <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 25, 2025 at 08:40:48PM -0700, Linus Torvalds wrote:
> On Fri, 25 Apr 2025 at 20:09, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > The subject is CI lookups, and I'll eat my shoe if you wrote that.
> 
> Start chomping. That nasty code with d_compare and d_hash goes way back.
> 
> From a quick look, it's from '97, and got merged in in 2.1.50. It was
> added (obviously) for FAT. Back then, that was the only case that
> wanted it.
> 
> I don't have any archives from that time, and I'm sure others were
> involved, but that whole init_name_hash / partial_name_hash /
> end_name_hash pattern in 2.1.50 looks like code I remember. So I was
> at least part of it.
> 
> The design, if you haven't figured it out yet, is that filesystems
> that have case-independent name comparisons can do their own hash
> functions and their own name comparison functions, exactly so that one
> dentry can match multiple different strings (and different strings can
> hash to the same bucket).
> 
> If you get dentry aliases, you may be doing something wrong.

Yeah, Al just pointed me at generic_set_sb_d_ops().

Which is a perverse way to hide an ops struct. Bloody hell...
