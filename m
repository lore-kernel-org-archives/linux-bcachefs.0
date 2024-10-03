Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3762E419;
	Thu,  3 Oct 2024 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727973154; cv=none; b=eq2oVkBpnKJ+uUnXvCXNovEYq3UPTuuf22Bwf4oWGDjs7nm2pfjRoSGW6MWKeX3ZKWoQ9sDuqxkovwAneCkN0hI+GOdnqFN9+TsG21XXyl+Kz1KU9CdfnLM0sIZcSRay7Y0/8SAapJ7bHdhpWjyTg8mb6R5wiBnMu8kT9BCDQhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727973154; c=relaxed/simple;
	bh=vA2Cy/7P7JfH+wjtmjOh/gr9jc0vnrkloCauPlJY0m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGvwmAhCtTABn2515oTbFR786nUJHVevFa/Ir/WM6w5bK5/bCQQIdx+HaD9Hz7d3GjppAJNEG5JIaqxppsQg/aW8ed/cvYTJbydbzucpt1aJ4J72bbAX7ye7x4HHTJMtzU8Q5vdUDOlyXzd3729bZ1qnQSeLHMmHFAAgmaqw/bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=cwJXE9OB; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NneG5Ywb; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="cwJXE9OB";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NneG5Ywb"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfout.phl.internal (Postfix) with ESMTP id 76FCF1380174;
	Thu,  3 Oct 2024 12:32:30 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 03 Oct 2024 12:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727973150; x=1728059550; bh=YmrQJ6jNp9
	LjHSMYxtSFGmXVtl03FcagGzbyRt+tUEY=; b=cwJXE9OBbVCUaRr+jbnhTb43mp
	0Gb6dluHKJhq6MfpOxJtc2RozuJBAS48hJYZ7XKPxG7nW40iGhzE0Mrc1EXG/dMU
	FtNLEg+qxadoX0CBTgq/gm5N59KOpPzYJUdC5Bpzywfa8g4HuHgtAOwkkOHfqvgu
	m4sY73xHydWnUB8fQh0YeuqQSBt0Pf9mScLjrQDmGQx0t8hV7rSY+tS4pl7M9XbP
	rOcs2XSKUl+T108KqsmZZsNSheFz9yu3VYzOkQ992wRNl3FyhaLuGarT1nPo1G6l
	QJTSpZl/WtAF4TfFmKBMNUp4SXhAxy3pn/9QHrtEusfi2Ctx75/z0Zfjtg1g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727973150; x=1728059550; bh=YmrQJ6jNp9LjHSMYxtSFGmXVtl03
	FcagGzbyRt+tUEY=; b=NneG5YwbcWL9X6YHPadZFN1CSrYo+KZLLP4DhbBmfM+d
	dmlob2DgbcHpiZHMxeNvY16nooSxcx2uFqGSb66F/D8H61NVUWDo742jFpipL2kw
	PZD2P15vq9UDNkQ5RjmHTvRsdPJPFeH9rkft45sAV7ZNOZRTh85LQhg0ZE0NTAhW
	PXuNmy/WQnDWuwSHdyMd26oEE9njtYJ9+EIYCWh135dQfU5gld8gjan4ztQln9fW
	QdEugXKmmnRjyN4m/4mhgoESudEPRorjP7VCKpqsYFHx24b3U9F1uP78fW9OHCny
	5MmHXgztBu0YQlxPuIIyOX8OiGHoDExUxvky14Bckg==
X-ME-Sender: <xms:Hsf-ZqNjmP6Lkddi7FlZNr5B_5pgIWtI3CcT1GWOscqeraebvxLq3w>
    <xme:Hsf-Zo_6oMyaHEUxAFwQXFtqXey8C-YibyZuPrwrS_8G1Xfgf9II01ShXr0pbZWCZ
    fm5UBgb2U4Say-0-wg>
X-ME-Received: <xmr:Hsf-ZhSB27aweV2oTucBKzafkRs1_zBD9Is0EDUfJZpGRK5YTaD9DRsbdtwNwrAMOwclHQZ0Z08-WpSCBWolRS2KDg5q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenfghrlhcuvffnffculddutddmnecujfgurhepfffhvfevuffk
    fhggtggujgesthdtredttddtvdenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepfedtffdu
    vdegkeeuiedvgeduvdeufeefveegtefgieeuuefhveffuedtvdfgkedvnecuffhomhgrih
    hnpehgihhthhhusgdrtghomhdpghhouggsohhlthdrohhrghenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtg
    gtpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopeht
    hhhorhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvggvsh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvnhhtrdhovhgvrhhsthhrvggvthes
    lhhinhhugidruggvvhdprhgtphhtthhopehrvghgrhgvshhsihhonhhssehlihhsthhsrd
    hlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqhhgrrhguvghnihhngh
    esvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgv
    lhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:Hsf-ZqtZwaxfob-isKE2mGMAaBnXppa7ec_g43PRTMLulG_EULfm2Q>
    <xmx:Hsf-ZieUynQTA3utJTySrDceRCmwxY5yWLc8bFX0FPWyeLbZvi_PSA>
    <xmx:Hsf-Zu26NqIcTfs0d29-y7x6B9b5f6Mp5pBELhY4_PZ25wypteXwvw>
    <xmx:Hsf-Zm8WWIgjHE5P5feQKbuiNLkNydGNaHq8FEdzkShIK2XLwJWdUQ>
    <xmx:Hsf-Zi47XD4nDzsXxN7bvvMEpF3iFcB7V2EtBRIcjuRh3rKzEYdWFIjt>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 12:32:28 -0400 (EDT)
Date: Thu, 3 Oct 2024 18:32:27 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv7HG8tR-Fdvb1SZ@archlinux>
References: <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv6YInHiwjLeBC3D@archlinux>
 <63D4756D-31B7-4EA9-A92F-181A680206EF@toblux.com>
 <Zv62pi1VVbpkvoDM@archlinux>
 <83834AC8-0109-40C5-A80C-8BFFA8F16B19@toblux.com>
 <Zv65p8f4sxT4gKYs@archlinux>
 <78AAE4F3-1C2B-4EE8-AC7A-B5F3730D1DB6@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78AAE4F3-1C2B-4EE8-AC7A-B5F3730D1DB6@toblux.com>

On 03 17:43:02, Thorsten Blum wrote:
> On 3. Oct 2024, at 17:35, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > On 03 17:30:28, Thorsten Blum wrote:
> >> On 3. Oct 2024, at 17:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>> On 03 17:02:07, Thorsten Blum wrote:
> >>>> On 3. Oct 2024, at 15:12, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>>>> On 03 15:07:52, Thorsten Blum wrote:
> >>>>>> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>>>>>>> [...]
> >>>>>>> 
> >>>>>>> This issue is now fixed on the llvm main branch:
> >>>>>>> https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> >>>>>> 
> >>>>>> Thanks!
> >>>>>> 
> >>>>>> Do you know if it also fixes the different sizes here:
> >>>>>> https://godbolt.org/z/vvK9PE1Yq
> > 
> > Do you already have an open issue on the llvm github? Otherwise I'll
> > open one and submit the PR shortly.
> 
> No, feel free to open one. Thanks!

Here's the issue:
https://github.com/llvm/llvm-project/issues/111009

Here's the PR:
https://github.com/llvm/llvm-project/pull/111015

(Looks like I violated the code formatting rules somewhere, will fix)

> 
> >>>>> 
> >>>>> Unfortunately this still prints 36.
> >>>> 
> >>>> I just realized that the counted_by attribute itself causes the 4 bytes
> >>>> difference. When you remove the attribute, the sizes are equal again.
> >>> 
> >>> But we want these attributes to be in the kernel, so that
> >>> bounds-checking can be done in more scenarios, right?
> >> 
> >> Yes
> >> 
> >>> This changes clang to print 40, right? gcc prints 40 in the example
> >>> whether the attribute is there or not.
> >> 
> >> Yes, clang prints 36 with and 40 without the attribute; gcc always 40.
> >> 
> >>>>>> I ran out of disk space when compiling llvm :0
> >>>>>> 
> >>>>>>> So presumably this will go into 19.1.2, not sure what this means for
> >>>>>>> distros that ship clang 18. Will they have to be notified to backport
> >>>>>>> this?
> >>>>>>> 
> >>>>>>> Best Regards
> >>>>>>> Jan
> 
