Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125521A4A6;
	Fri, 25 Oct 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729870034; cv=none; b=Us5wx6wJ2qWfht3GluhzNWd+7V2MVYjTe7HUI8KZkNzX5njxtDeWqU/6fTF2bfwLaVJYWJhaTbm6LjPFr0ljuE21Teg6+L/ZaEkGX0Rm3YN0Bf8s90eTDml9Gl+bGVfpvfIFMZzORGKYJbOKnvaROyI3bUPAhXMiMvSMq72t61A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729870034; c=relaxed/simple;
	bh=RGW2QulLFv51uPgzrDVtdV/AJ/X8QIUglHvZM+LYZ7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rMWnz7nMY4AArj9Ky7lmMZ5W1gDZZUPf02Xmck7DTuVw6UAFy1BX4m9BG2gF+sIMIh0bJeI8kMLAj2dtK+lgIwBE8eKjPC7d7QHfJXfERIiKtuhCgekGQX07HY9fp05xDoiIDMHutyyiWQ1SMiMavY9bkIkknWLUZMiOdUB140s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=SYi+crlH; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OEKGY1VR; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="SYi+crlH";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OEKGY1VR"
Received: from phl-compute-01.internal (phl-compute-01.phl.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id A39D513801B5;
	Fri, 25 Oct 2024 11:27:10 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 25 Oct 2024 11:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1729870030;
	 x=1729956430; bh=RLih69XQUoMnH4TqrYPUlmUCQn82s+sfVe9uNsKWg9Y=; b=
	SYi+crlHq0VgyliAZsXMXZqdZI6hm99RwMlwTh11LZdATlBxGsdd7hFgqIsMo6/x
	aChs69wZWPS15Dw7qGVPi/mbnRX/l218Zlvaj5pwfILR/g4UvfwZfDQWlSStzZTa
	hoOkxxWygPBQgJK9J5cmFg0G4SOnXrSwx/H5LC5dKE385+KsuMqTRJWHWdT+1mpN
	Jfzq7CBV1m0J3YJcbO034Pd510rw5Qpzk7Tz++SdOkbxcxv1RE4aCyK8oUxlxTJt
	hydZckspYI4BYR8ziQIo5mWwQcAwlsy12gdvBIed6zj33XM59G4GkCeK1JQeFLmi
	8E7K85v+sVxhJ+LF0xsHgQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1729870030; x=
	1729956430; bh=RLih69XQUoMnH4TqrYPUlmUCQn82s+sfVe9uNsKWg9Y=; b=O
	EKGY1VR8gNtmI+H7gZdnvrgQwf6nMMIledDZqlTcaxu+s3Ty0wPpfwMbQCz8Aqju
	vIzPHmuo2GCdvpsr9g0NQDJfqMZCaQldl7xcoSL26HSS0nSax2UUCX+zrkhWyyg6
	ueeaQBJwQG0phhaQ8bKC3yzW5hZDxK603V2iyUEXcDwzp5Kkd+UN2HHXqBUb9ODj
	2DNVNYbNTZaUPMyMnrU0Cvux/2IcqqX5W0otmVbXMaJR6gEhmsP+IaTpZGXxnfl9
	QBIOqPv3vf2yR2OBFGwTCkeHI4rdB+RTuci6AGWEAbQEmg0oEf6sTbjrQkYPI7zH
	QlIhDbkg72XVQm3no932w==
X-ME-Sender: <xms:zrgbZ-DHmg_6lLxypIE-pvNCjon6-33m49pNt969bqxKcumCTvZe3Q>
    <xme:zrgbZ4h28H5FVX78YnNbdTKidBoFiCoaPYElP1OGlITyi738vHUDx4b7S4TadPojU
    pH1SwHxGS_OYWSYiUY>
X-ME-Received: <xmr:zrgbZxkAoUOwTebHgL8R8JvFjC_hBALkVTPR_-EOWnb8d6XOTP9EAWQQSOK-yEniOc2CvSBxmCmOCNOaNvsWe6i6ApD3>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdejvddgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepudegheef
    leeitdejheeludevtdfhgeeuiefgveffvedvjeevieeihfegteehkeeknecuffhomhgrih
    hnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtggtpdhnsggprhgtphhtthhope
    duvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhighhuvghlrdhojhgvuggr
    rdhsrghnughonhhishesghhmrghilhdrtghomhdprhgtphhtthhopehnrghthhgrnheskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehthhhorhhsth
    gvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvghnthdrohhvvghr
    shhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoheprhgvghhrvghsshhiohhnsh
    eslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghh
    vghfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhhrg
    hruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:zrgbZ8zsknsztT8-uJX3OBuZRHbrD2c22d9643eLMRH66WoVe33Zdw>
    <xmx:zrgbZzTfoQ76r9SNC_yno9ijZaPG6ZU1Lkzz-_AHqm8AMbDDv04BeQ>
    <xmx:zrgbZ3ZdSwYXbD6vef1jFWAcqBURkrxD8UhZOUg5i1zk8J6Hry3pDQ>
    <xmx:zrgbZ8RgdFNdsJa9FL3T2YKA9aSFwVWixCY2QV3NboOOGfF9sK4AJg>
    <xmx:zrgbZyIayhj-rGy8tJYhnj4sdHb_s9os3AP-mHsdaCID68usDt2qxJFn>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Oct 2024 11:27:08 -0400 (EDT)
Date: Fri, 25 Oct 2024 17:27:06 +0200
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
Message-ID: <Zxu4yhmxohKEJVSg@archlinux>
References: <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
 <CAGG=3QVcsuN0Sk79oZWjY_nNTo_XfGYsDT3gc7vEmLyS8OK3rA@mail.gmail.com>
 <ZxB-uh1KzfD4ww2a@archlinux>
 <20241017165522.GA370674@thelio-3990X>
 <ZxWvcAPHPaRxp9UE@archlinux>
 <20241021192557.GA2041610@thelio-3990X>
 <ZxpIwkfg9_mHO3lq@archlinux>
 <20241025011527.GA740745@thelio-3990X>
 <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72nbyqrzGr3Uw_vx-+8DLiv6KbeULrxpyK8Lh4ma15cq8g@mail.gmail.com>

On 25 10:10:38, Miguel Ojeda wrote:
> On Fri, Oct 25, 2024 at 3:15 AM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > on the official submission.
> 
> Same -- please feel free to add:
> 
> Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
> 
> One nit below that is fine either way:
> 
> > > +# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
> > > +# https://github.com/llvm/llvm-project/pull/110497
> > > +# https://github.com/llvm/llvm-project/pull/112636
> > > +# TODO: when gcc 15 is released remove the build test and add gcc version check
> 
> I would perhaps move these closer to the respective lines they are
> comment on (i.e. `depends on` and `def_bool`).
> 

Done, thanks!

config CC_HAS_COUNTED_BY
	# TODO: when gcc 15 is released remove the build test and add
	# a gcc version check
	def_bool $(success,echo 'struct flex { int count; int array[] __attribute__((__counted_by__(count))); };' | $(CC) $(CLANG_FLAGS) -x c - -c -o /dev/null -Werror)
	# clang needs to be at least 19.1.3 to avoid __bdos miscalculations
	# https://github.com/llvm/llvm-project/pull/110497
	# https://github.com/llvm/llvm-project/pull/112636
	depends on !(CC_IS_CLANG && CLANG_VERSION < 190103)


