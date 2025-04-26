Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9247415A864
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Apr 2025 03:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745636441; cv=none; b=UXPlZDGywMBYsoiWyo6yXOp0w656U1UgzG2j0H1Ah/Aa29iSSjwJr6fadVX9IG+L/QlyEcy6HVTXTDMUJH4cYE8hZeNMxoUwI1VZOgZj5MK6XJ3sDZIZceBrxU+Q/9NREDcJYZbLs/HCwVmYGwBaUwL0yiIUdRrQMemilQa/0Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745636441; c=relaxed/simple;
	bh=wMrLh6+JBD71sbzGOVePWFTaJpeQD1TA2pNoVbtpJCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hTMpKfH0vgFOHqe3qUFWaDlwRU1HJzhGQliSFKnaQohRH/vnvkHoX75Bh+OmmE7A7JP7p+7k7O4b2v+O7a041CZ3wJEBx8B7pMynIJKaUDEmYhODcvWwTon4waWxSopbcRrGDdHs4cPOjwDAOMQ/LlZLn5wDAC+JtIrRTwhtdw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KMnyjBQ2; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KMnyjBQ2"
Date: Fri, 25 Apr 2025 23:00:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745636435;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=brMWIiS2FVkjG+Wb7CsJ7g3GTpla+vdPud2BrTa9MLc=;
	b=KMnyjBQ2CUbCMU2ywwOi5FYezdGRIZLVvr//sm4pA6VY99MGMrN/+wN5DR79RxJe6i1nLP
	IoSw4nRSaQyhccFsN1ccAkdjRwnV0gDFm4QEwKezsjsKdwLnX3A5v8o5AWMalYJTZJl4lC
	zmeHc5jnpLHp5iqxu0e5AOVq3bthdWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 25, 2025 at 07:47:09PM -0700, Linus Torvalds wrote:
> On Fri, 25 Apr 2025 at 18:38, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Apr 25, 2025 at 09:35:27AM -0700, Linus Torvalds wrote:
> > >
> > > The thing is, you absolutely cannot make the case-insensitive lookup
> > > be the fast case.
> >
> > That's precisely what the dcache code does, and is the source of the
> > problems.
> 
> I think you're confused, and don't know what you are talking about.
> You'd better go learn how the dcache actually works.

No, what I wrote is exactly how CI lookups work with the dcache. Go have
a look.
