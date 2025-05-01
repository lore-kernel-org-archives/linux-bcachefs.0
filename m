Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A1A3D561;
	Thu,  1 May 2025 16:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746117965; cv=none; b=IZpgsKfK6zwEXNYqUXIfXhpn4l0gtiUwwRObwrwBp7g87+b1jYDyM+LeO4/EkVhsrJfi9uJ+QkwFOuXkGAoNutobxPzJF3Q8HoJ5e+orLF3erI5oCdJ8eBLha1+GJCsdS8BWbigTBW1yI1k3YRGjIGGnx4lPXtioMC9U4D99bCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746117965; c=relaxed/simple;
	bh=RkAW/Yjl6ixcVf6Xi5aYi2K1i1lxs3I9p2l1llyAREM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p+PfdsRw+mKRthUIKdylcqoqM42/iUK7GOXP85bPIDZ38DN/0vK5QnHv2JzrHnkpkMkSGF2P2gz+4bS8Fu6osOB/gIRVYY6CA6ReGNJLHD0EpHsC2arj4YmiRg4nZyVvOdTvfTo5R0Wiwc1jmRq7ZHmRcLDjRlobh7kD5xmOH08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=E/g6boyc; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Wl9pEPfH; arc=none smtp.client-ip=202.12.124.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="E/g6boyc";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Wl9pEPfH"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id C90D2254020A;
	Thu,  1 May 2025 12:46:00 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 01 May 2025 12:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm2; t=1746117960; x=1746204360; bh=JznQuwHGnJ
	AzLSBoeScYjcnmlWNzVWZP+ZeXKHDaGGk=; b=E/g6boycmOwzzksE1Y1MVN9ZNS
	CUy6Xado1PSJcG9epCz428dwR9j8hS+dOhoKc2HHG6ZIvpCYJfrGektWY9sVn5du
	Aq4n6BDjyS3B41iUkZ/+ZX5flOljkgPANwQjLPLjyDoQssj+d+WcJb2Fipd6jaH1
	i7bkTsSLC6GJIRnnBtkNM/6KiOoZncuFky5ywtU6qovRy7YNTt04rnljXNYxJ/91
	bkA293N2UYndDJqirRc/cXf+VzltfcqF1eicNZtFBSz3j/IJJa+9tYMW6UENqdqF
	cBbdd248ZqzxiSiRf+UnIQ/xsDy4HV3Jv7j5FJBia22Zl6JMhkTfGhzUBZFA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1746117960; x=1746204360; bh=JznQuwHGnJAzLSBoeScYjcnmlWNzVWZP+Ze
	XKHDaGGk=; b=Wl9pEPfHfhmJSHLMN+X86p6OKOii7czStitN4zG1M1e4fd2kbk3
	D7GYD2E473KSXu8Xt925A6sgxRejeuBfCSjxYaNQsRoVYUQVgv0c72jR4rpkGhV9
	gZZT0UJwtSwPTncmYrIdTE0VcTeMU6OS7Poqa5uwXb53wDlXpWoc9/WkPAIUartb
	DbPadBqrKgoJOyhWgTUMx0u/PGZB7swFsfhWCc7UEE4J0HEIcXrTAQc/J5xjeQz8
	MjDslDp89/ElBnfe+/wUD/tefjK1KLupyWcJowWk86fv4UsVs/Qf6konAnfEZLvO
	GNFgyjMFO0Blm0QxELwX4xBRi8GaiqGd3hQ==
X-ME-Sender: <xms:SKUTaPqFnT-tH_4GIiEUkKzKHnt_FRcqHORrE3lZJhovh4b3hvQzoA>
    <xme:SKUTaJrD3jKgPXtRUyJtcGBOFCA0XJpPC9NyvDoHFrAVGzNXiPT9cBk1qyA48uma3
    D0kCp2KN3k0v4tv9CM>
X-ME-Received: <xmr:SKUTaMP87aEKLNb7cp6fkXPMhzTiFrQPlWcIaXWWu3iJC1_ZmXyZ7WGRavuabD8J_UT6kD6f-19FHJBIWHUYjMRKNBAF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefvddrtddtgddvjedttdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggv
    pdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpih
    gvnhhtshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefu
    kfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrg
    hrrhcuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeeutdet
    uefhveekteekvedtiedtteefvdekleeifeekhfeiiedvleehjeefvdfgudenucffohhmrg
    hinhepphhrihhvrghtvggsihhnrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttgdpnhgspghrtg
    hpthhtohepudefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmmhhpghhouhhr
    ihguvgesghhmrghilhdrtghomhdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvg
    htsehlihhnuhigrdguvghvpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumhesthho
    sghluhigrdgtohhmpdhrtghpthhtohepmhhighhuvghlrdhojhgvuggrrdhsrghnughonh
    hishesghhmrghilhdrtghomhdprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdho
    rhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhmpdhrtghpthhtohepkh
    gvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrvghgrhgvshhsihhonhhssehl
    ihhsthhsrdhlihhnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfh
    hssehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:SKUTaC49EybdrtfUQJagGdVQtIpK8UEhzLaPvB-pf1EimwiPaH3rFg>
    <xmx:SKUTaO4k1AVuuWJ2d7V3a1Mm2G0mM-X0GK6aUpwOXyc4pXQpn1z_sQ>
    <xmx:SKUTaKgp0AT-7hB8U3LPVcA5VmEQK8Lk8aDFjGOtQW-ZaDV0Zgvnhg>
    <xmx:SKUTaA4-jJu3NqP3F4L98t7zwCHBp3NxH0Sxx-lnuKmC8z4iemJYmg>
    <xmx:SKUTaNsWCtAW_z9Y6T5ciN_4zX5nUobImVU8hFZkJ2Hmob_-2eBy9YZ->
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 1 May 2025 12:45:58 -0400 (EDT)
Date: Thu, 1 May 2025 18:45:56 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Alan Huang <mmpgouride@gmail.com>
Cc: kent.overstreet@linux.dev, Thorsten Blum <thorsten.blum@toblux.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Bill Wendling <morbo@google.com>, Kees Cook <kees@kernel.org>,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, ardb@kernel.org,
	ojeda@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <aBOlREPsG6LQqBVy@archlinux>
References: <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
 <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
 <Zxu4yhmxohKEJVSg@archlinux>
 <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <775D7FF5-052B-42B9-A1B3-3E6C0C8296DA@gmail.com>

> 
> Hello, 
> 
> Now there are users using gcc 15.1.1 came across the similar issue (they are fine with gcc 14.2.1 ):
> 
> 	https://privatebin.net/?a0d4e97d590d71e1#9bLmp2Kb5NU6X6cZEucchDcu88HzUQwHUah8okKPReEt

Just to confirm. Is this kernel built from the linux-mainline AUR
package? 

And gcc version 15.1.1+r7+gf36ec88aa85a-1 from the normal arch
linux repo?

Is bcachefs the rootfs and this happens during boot?

Best Regards
Jan

