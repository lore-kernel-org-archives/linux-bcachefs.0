Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63151C330C;
	Mon, 21 Oct 2024 17:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729530100; cv=none; b=umxL/qsppxN59ayZd0akUNRkCTjTW69Whaw/n3OOJ65zf/o25llR5J2FCAY3LnuVfJv6o/6dHIq5XEjel7LbujY19dZcJgSImZFufkws0tkYTebtp8thMZ4miBsUBClX/ziw7iGjhYKITTtY/kHjFHpEorsiApS2SwlULeynCws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729530100; c=relaxed/simple;
	bh=EdrW4QyQlhTewuPVfOLFcxOIGlObb6XfUuBmUv9yjPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=spNbk9bKoraGFDyH3wf48fAyl6xtulL/5kZZ0eicXraU74FTkzxTjOyY/THK2d4jUwYYNZSjlDobUn/NKJ2+1/J9PnAwpywnw2vzTWXwT/O15+e3HORcj5soLGClfV/LEuFE5kKO8jDaWoqnwYnk424l4kH7BqAIubOA89RbKGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=kA3gMl4h; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MTLizXYG; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="kA3gMl4h";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MTLizXYG"
Received: from phl-compute-11.internal (phl-compute-11.phl.internal [10.202.2.51])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 92B6E25400DF;
	Mon, 21 Oct 2024 13:01:37 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Mon, 21 Oct 2024 13:01:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1729530097; x=1729616497; bh=0Cp/HfzuQ/
	MdndVSy8g4lWxf16i11f2fUzT7z2EWKY0=; b=kA3gMl4hNlwQUJBN0El7vPwZmb
	tHNQEyh8XFScbu4/dKOAZKsJ/znUd5g9YaXVDJ08hZVXzUGeOEVhSgvVvPculIvZ
	9Hob6qPNMq2H50lkS6IukZQ/Yp7kOZGJKkQKl8d0b+yhfFeFkS/zXfVZst/jftLW
	aAwlJd0LaXSA4xAYv3KZiMmo4SM+8FZ7/cfEiawfR4Yn//PWYki31yGhF2LvxNmQ
	JwFCImqTX5sXW7MOQnggjH6fKf6v0A+R83Qt38yFyUwI7ai2StkrpZjOiFixDih2
	fFfFt5k7OJKx9D3L+zDMIfiJcFhTQwWzX8d6hgPZzqj0cDZNKAOx4KfbPmdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1729530097; x=1729616497; bh=0Cp/HfzuQ/MdndVSy8g4lWxf16i1
	1f2fUzT7z2EWKY0=; b=MTLizXYGUWuhuuU/jMFO7jL8+HFW3oNzCoLcTiFeeQIu
	0PszXAa2/JI8o+npKACIgFtw2ErBC8xFGVO4qpBouQGZdXZv8aFfPpDqlcqza0kp
	0NZPm4ey035NyASqfy6irrhn10R25ABcd94JGPdIlSMHsuGU8IKRR0ow6Id7ZCoJ
	D/Zm4L6SfLPwVsMABITYKYXGQazU4z6dEK+SAG/wHpDPI8m7sttTLM6M9ZPp/nkt
	T59c7TaZus8kwn61EUQpVVSmC2h2E99vYH40+i8C4wBZTYJERvnk2+eVtZ/Ey28A
	GhdYGNKX3AdEkGHOweFCZPnCHHqULOCRar6pujWLRA==
X-ME-Sender: <xms:8YgWZxi6EBu8QHK7JK8e0L8DEENnALhA4lYvrOOEtAxn8oJCtP7I7A>
    <xme:8YgWZ2DoZjNXWfX-BTZklWzria2DPobpI8PeIVYVQeRpVoYXFgQybjb6AKmrAd5AF
    T-rZlpgmx3q0biNagY>
X-ME-Received: <xmr:8YgWZxGJd8d48xSgawyFbcjW6UykXpduMiaYrwmwyn1loG0s6sNV8godW5BTmwsCcGTRP0C5U3NEEmgsIlN7NJYc0Hwz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehledguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpggftfghnshhusghstghrihgsvgdp
    uffrtefokffrpgfnqfghnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivg
    hnthhsucdlqddutddtmdenfghrlhcuvffnffculdeftddmnecujfgurhepfffhvfevuffk
    fhggtggujgesthdtredttddtvdenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepudekgeff
    tdefiefhheetvedvieeuteetlefgfedvhfelueefgeeiudeiudfhkeeinecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgr
    rhhrrdgttgdpnhgspghrtghpthhtohepuddvpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehmihhguhgvlhdrohhjvggurgdrshgrnhguohhnihhssehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepnhgrthhhrghnsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehmoh
    hrsghosehgohhoghhlvgdrtghomhdprhgtphhtthhopehkvggvsheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpd
    hrtghpthhtohepkhgvnhhtrdhovhgvrhhsthhrvggvtheslhhinhhugidruggvvhdprhgt
    phhtthhopehrvghgrhgvshhsihhonhhssehlihhsthhsrdhlihhnuhigrdguvghvpdhrtg
    hpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqhhgrrhguvghnihhnghesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:8YgWZ2QOmrGfUKvIGQOhXPzkCkUkA5WQZWwAtqxnP5vfdWY7Ua79Ug>
    <xmx:8YgWZ-y8-T8y4LGPB-fX5aS-l_a45_qUu7cG23eHMVk9M5z33qQRiA>
    <xmx:8YgWZ84UiO9Dmon_rS2AhGrMK7fkPNOQma_aXQ05akDKqwyof0drEg>
    <xmx:8YgWZzyBJ4Te7--8i8aHmuovxDme4klsNLJsQFiXndKRPAkZG_Nm_A>
    <xmx:8YgWZ5pI5pLNLilpi0V_sU7_PJFarjt7RUm_rtTKX8VicfY4LkxckR7T>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Oct 2024 13:01:35 -0400 (EDT)
Date: Mon, 21 Oct 2024 19:01:32 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Bill Wendling <morbo@google.com>,
	Kees Cook <kees@kernel.org>,
	Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZxaI7EcpK3HIm0by@archlinux>
References: <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <CANiq72=yYDcG=ef9TxCCECwjSgW-5zFoTJqcjrWGOALCvaW0SA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72=yYDcG=ef9TxCCECwjSgW-5zFoTJqcjrWGOALCvaW0SA@mail.gmail.com>

On 21 08:04:03, Miguel Ojeda wrote:
> > Also after gcc 15 is released I don't think a version check for gcc
> > should be necessary. I only see an explicit version check as required
> > when we know a certain version is broken. Otherwise I would prefer using
> > the build test.
> 
> Yeah, build tests are nice, although they require spawning a process
> and so on, which (as far as I understand) we try to minimize. Version
> checks also have the advantage that it is easy to remember/check when
> we can remove the checks themselves when we upgrade the minimum
> versions.
> 

If the goal is to minimize the need for build tests, I think we should
go with Nathan's suggestion of keeping the build test for now (to
support pre-release gcc versions) and remove it and just go with
versions checks for both gcc and clang once gcc 15 is released.

Best Regards
Jan

