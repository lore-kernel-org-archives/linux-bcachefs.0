Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974FF145B39;
	Thu,  3 Oct 2024 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727993106; cv=none; b=ot0DToBx6VWT4tdGSe4Su+t87X+/KGBNADkxBXr4SaSLRE3yfqjg0XLjVBlh7fGxj0ngPiYvISKjSjfGWGl5UbDNJ9zIgO+MC5vDMpPZpOv+WE0ZYLi+rBqBRX7ba5+dws7uMNOlUxCSkgQwosKVJjMI0292ZwqDavtUf7v/KBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727993106; c=relaxed/simple;
	bh=pK+P7uUv2gxu176MHcUzT+ux1Z+gp+8DdZTEXzMIMuw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s41hUIsijXJ3DtU9oeXVblxbIJR93wnpruEEdkpnmRuC5QQ7uDH4WP74S42OV8OPo5Cw43EEvihLYYBFy5FLkel+yXHlNFCXkcOGpRDp5vvrN2D3SbN0R2W8mA1axwiySAOW9ga+nqflp9784X346zAhTRGE/j+4IH1eJmLs1t0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=xMRom+py; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hOunhY53; arc=none smtp.client-ip=103.168.172.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="xMRom+py";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hOunhY53"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CFB1D11401CC;
	Thu,  3 Oct 2024 18:05:03 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Thu, 03 Oct 2024 18:05:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727993103; x=1728079503; bh=UnuZNkWou/
	Fe/+Xh+DHrQ8uSAR/kXG8XzqV1zsuUh0U=; b=xMRom+pyQJYJ5OQ42Tt27QfPrZ
	a243CCo1qfxHHBKjZyBmgY1wHry+L8IgrBbt1akcbQqIdpc0cTHyiR351pvnHERQ
	Sg1h3emi9/7Zxt/wpbWo5b3KWPVKswg+heo9lfJjQR+UZ+S65y4Ee7IryBCbje/9
	Yy5R/dPCK9KVldb27XpzFrvyDaY3/cBHZ+eKdJNRMTUbl4u+5SWrmOgPDuy8xq0L
	zVwV8a8/j30NsA68YJmKBtqhnCUUXivEYIHDCFKfyBwEUHtTsClXj5dXmtcSoMRX
	5VEkzd+P7mEgmU1fJ6Yw7nXllA7UoyiPiVdD09wY6ABU4Bddj80qfkupCfxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727993103; x=1728079503; bh=UnuZNkWou/Fe/+Xh+DHrQ8uSAR/k
	XG8XzqV1zsuUh0U=; b=hOunhY53vOcBuySkz+r76LaGzqpGSudwpcV+0Boxs5Gc
	LmBL7MCEJojBG071VJ6FILpmT8+lWtCbS49eWSptYQOZ87Hkm/5AiduCNSlk3nF3
	xO9t4x46fX44Kn4jNPyGNf0dx/1xGs0vSPnWi/fDAiAR/ILSTXEvn8v0RwjKtAh8
	HE2VdRTZ7WIcie4bNPw6sBQP81FHJzUNxQ1f9V3jM2pRE4LWCLT4S1CO0i5/svUD
	zU2xPVf73sH61J/7qq3Iwt9pCg5UCYSsRWgbRmLwxG1AclcCop+eiFTaWiS6j36R
	ZqmRCOi8NWtT+1kiiURQusfoCFUBMCors3fYcqxsIw==
X-ME-Sender: <xms:DxX_ZmjMh-JE9Xta0cmdVrIXLFCJqONLCNTEjvt_iti8DVu--zXNRA>
    <xme:DxX_ZnCUTV00-Cb-ILQz0xQ_0iNxbT6MW647Isk5xWFRdWFl2VOvi5oNPjiE1bIm-
    NZWJRw0a_zDD83lrdw>
X-ME-Received: <xmr:DxX_ZuErBVzBiRmDZIkTCl0a_VvAQsYyYAeeRLE5Wp0zwnKh_RvLlHSh_r9Z9jGQbXwYaXCSa28DVDon3x8Zqs1xuaMY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvvddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpefffeejffev
    geejudeiveektdeiveefgefghfffveeujeefhfefffdvvdfgiedvheenucffohhmrghinh
    epghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttgdpnhgspghrtghpthhtoheple
    dpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehthhhorhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprh
    gtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghp
    thhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgtph
    htthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthhope
    hmohhrsghosehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:DxX_ZvRA76nD6vmSVJyVU8qm8NhQ-cdLKWcDptf5852LWZTR145CYg>
    <xmx:DxX_ZjykbQQArczPU95il-J7GXJK9XPv2zjt1T20OKCmujBoKi1t1g>
    <xmx:DxX_Zt5xc1Q6s90YDn62qo6hEuLZ06-ikT6CsgMQpzYq3HbpdSFGtw>
    <xmx:DxX_ZgyBupyMN7ONZQlJsut4y9cWmvKSYIw9z96Z7bayNEFKwT3CyQ>
    <xmx:DxX_ZreG5g95xLhenL0lGeIagubiZhQypBZhAVVmy03NNOtMleVjUsIF>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 18:05:02 -0400 (EDT)
Date: Fri, 4 Oct 2024 00:05:00 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@toblux.com>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv8VDKWN1GzLRT-_@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <202410031422.72F54BE4@keescook>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202410031422.72F54BE4@keescook>

On 03 14:23:20, Kees Cook wrote:
> On Wed, Oct 02, 2024 at 11:18:57AM +0200, Thorsten Blum wrote:
> > On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > > [...]
> > > 
> > > Sorry, I've been out of commission with covid. Globally disabling this
> > > macro for clang is not the right solution (way too big a hammer).
> > > 
> > > Until Bill has a fix, we can revert commit
> > > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited to
> > > certain situations where 'counted_by' is in use.
> > 
> > I already encountered two other related __counted_by() issues [1][2]
> > that are now being reverted. Would it be an option to disable it
> > globally, but only for Clang < v19 (where it looks like it'll be fixed)?
> 
> Yeah, once we have a solid fix (so we have a known Clang version to
> target), I'll want counted_by disabled in versions prior to that.
> 

Just to clarify: There are two separate issues. One was __bdos returning
0 (or sometimes other garbage). That one is fixed in main by [1] (so
will presumably be fixed in 19.1.2). The second is __bdos sometimes being off
by 4 bytes. That could be addressed by open PR [2].

[1] https://github.com/llvm/llvm-project/pull/110497
[2] https://github.com/llvm/llvm-project/pull/111015
