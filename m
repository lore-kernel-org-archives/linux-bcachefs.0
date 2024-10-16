Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51A8621E3BF;
	Wed, 16 Oct 2024 02:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045105; cv=none; b=pigJuWJAMx5rSJgAqnTc7KZxtpC2g4rloNQC44CpWABqLitk2E7vnPSX2Hefd1h08LNjYI1c6Mo+P2L80MVfX/6kOIiyxrZZsKr+JJR6XqxvWNBTO5mRIUoPPxSRwLAVXdgHErnial1mI86bRrYFrqNSpqPlZJAWZz69CVO/MBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045105; c=relaxed/simple;
	bh=5LE6tYu+X0uch1HLayLKo3gSu2cuTkosIXol167hqB4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QMC+Mr0YFOn9EHZy7mHqARoZmYFsKhYj3XdYk0pEU4iQxY4jkUPDUuH0J5yYtroBdT+EX2duE+p7mEr7anzOqUdFxllIDHS7g1DxVAqEn5zzkivQjHfpRVHmziraX1hylQPYLjnN3bQ1oCEg22nhXcojupY9pWO5NPcLkpl7kLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=fCiLcc8z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cgMiPPYM; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="fCiLcc8z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cgMiPPYM"
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6CCDF114011F;
	Tue, 15 Oct 2024 22:18:22 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Tue, 15 Oct 2024 22:18:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1729045102;
	 x=1729131502; bh=Swj7Lbo7ejzQtiVKGVdpJ37CtLEPIJTGJDsXZZH7qAM=; b=
	fCiLcc8zGKgFcHJu2nHi9P/4MvEC6iSQRyOg1zWRHxlmBlb/PEUd69Ab8RvIzNLU
	qk/k5JpPP8lhdbGFbCmPwqltHbLcfhV2fLSY7gbukO3895g2ZeoZy7taOak1WYTp
	XcbpXU0JmAA3oUSOY5lYJokEK04rwChni5aAcAnIQgkobDV0wTa1bnvvs80YcFRw
	FpVWLpZX7xJKay7LKbRI2mxK4FFMapBc44KJYGysnwStjelKJxvzUrYHewgUujbE
	95be9f4VL95xbyamWSIOCq0dpm6fdBxoKhdr/sPzJmTGGcMF+vq8wd8vaCg2mhIA
	7Ds5BYqbz3LCBbZtQxwyqw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1729045102; x=
	1729131502; bh=Swj7Lbo7ejzQtiVKGVdpJ37CtLEPIJTGJDsXZZH7qAM=; b=c
	gMiPPYMv0RLdRoOUNfHkKWyHCbbG07EQteWLMXjwTfNHqktzDiqoCo/6zAQ5oLLe
	MV7UwXMgCPS/CTDC/WZ+sElfRClY6UT6w5o6AymFtwD5+N1Z7F4lk/XiQtWDs9pN
	H2/orPowjHUrmgRAHDLvY0153E4wxgHHwpt94pKcBJC+IryFtCS2UJNUbECuyIoc
	tSVwjolcIf7OTTMzK3hEqB1SX8Dyn0EMusbDxPwB8YCwQXeAkDKrWV6/BukZK48r
	iI/B+3hVXtUH5GHXzND7gGe/nWWVOZ/B5uM4qXl2wPc8Zd1OOf0b+8bA22je7oDD
	NnGBUfm8QcNaC1X+Mlnkw==
X-ME-Sender: <xms:biIPZ1K5mGn6iSrkQOmv7Bht6iwnRXQlREiPC7JeEWsSy1rC3LBweA>
    <xme:biIPZxKwFGiPNTzsmB-nSCgrblf9HAdeqrcawZP_-piQlI54vq8htizgp7cr4rIeV
    US7Q78E5OBwKbFDvIA>
X-ME-Received: <xmr:biIPZ9t798r88r_Q5RBLbm2IPAN7zsqV0wyeSajgTjEVT2Iu1RZnzHf3bkuCG0E6zhMaFxOwV9ZiKyaVEZYbEAhEpjvT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdegkedgheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtugfgjgesthekredttddtjeenucfhrhhomheplfgrnhcujfgvnhgurhhikhcuhfgrrh
    hruceokhgvrhhnvghlsehjfhgrrhhrrdgttgeqnecuggftrfgrthhtvghrnhepfeejieet
    gfegiedtkeeigffgkeelvddtfedttddtleelffdtudevjedvleelvdelnecuffhomhgrih
    hnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhho
    rhgsohesghhoohhglhgvrdgtohhmpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumh
    esthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtg
    hpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgt
    phhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:biIPZ2bqbSG_ZKiiniCLN2xTw2tQM9Jebh1v_uTj3u1ANSdSOIeocw>
    <xmx:biIPZ8Y1sML6Y9Np6n6-rukq6jmAtHQ8Sw-Or2HkEsYe8VgNkJjiUg>
    <xmx:biIPZ6BlxfwAF5tUSY_zFv98wV1dT9sAcNsTZHHininsI5oiFsdt0g>
    <xmx:biIPZ6aWd9v7SCb9LJS30-Pw-8wDn_Q9iBupsJdyVBGFbA8AT9kYtA>
    <xmx:biIPZ6lwCux1FjsC7-KX_rLYlF0oHU4qRn9e9rmJXe64zadIMvuzB0K4>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Oct 2024 22:18:20 -0400 (EDT)
Date: Wed, 16 Oct 2024 04:18:19 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Bill Wendling <morbo@google.com>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, Kees Cook <kees@kernel.org>,
	kent.overstreet@linux.dev, regressions@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, ardb@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zw8iawAF5W2uzGuh@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <CAGG=3QVecaZfoRrjToToq8=Azh8M0vQ5Q=V8dfhdBnDR8GWy5A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGG=3QVecaZfoRrjToToq8=Azh8M0vQ5Q=V8dfhdBnDR8GWy5A@mail.gmail.com>

On 15 18:22:50, Bill Wendling wrote:
> On Thu, Oct 3, 2024 at 4:33 AM Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > On 02 11:18:57, Thorsten Blum wrote:
> > > On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > > > [...]
> > > >
> > > > Sorry, I've been out of commission with covid. Globally disabling this
> > > > macro for clang is not the right solution (way too big a hammer).
> > > >
> > > > Until Bill has a fix, we can revert commit
> > > > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited to
> > > > certain situations where 'counted_by' is in use.
> > >
> > > I already encountered two other related __counted_by() issues [1][2]
> > > that are now being reverted. Would it be an option to disable it
> > > globally, but only for Clang < v19 (where it looks like it'll be fixed)?
> > >
> > > Otherwise adding __counted_by() might be a slippery slope for a long
> > > time and the edge cases don't seem to be that rare anymore.
> > >
> > > Thanks,
> > > Thorsten
> > >
> > > [1] https://lore.kernel.org/all/20240909162725.1805-2-thorsten.blum@toblux.com/
> > > [2] https://lore.kernel.org/all/20240923213809.235128-2-thorsten.blum@linux.dev/
> >
> > This issue is now fixed on the llvm main branch:
> > https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> >
> > So presumably this will go into 19.1.2, not sure what this means for
> > distros that ship clang 18. Will they have to be notified to backport
> > this?
> >
> FYI, Clang 19.1.2 shipped with your fix in it.
> 

Thx for the info.

How should we continue with the "off by 4" issue? The way I see it either
the kernel has to change struct_size (lots of work) or clang has to get
an option to follow the kernels behavior. I'm in favor of adding an
option to clang.

Ideally I think it shouldn't be a global option but one that you can
make per __bdos invocation. So either inlcude it in type or create a
separate builtin for it.

What are your thoughts on this?


Best Regards
Jan

