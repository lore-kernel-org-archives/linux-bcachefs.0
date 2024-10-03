Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FB74779F;
	Thu,  3 Oct 2024 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968940; cv=none; b=jFudm9cteH11AYlRyaL9ZEmBjhID1JACwy9zRCi1hLnzdqu6cf13a5mAxsacltaqXm7lBs4wGr/i6IwVPV27HTDZ9ql8MZFoPiyUp31+DwUKvWn1otUaV8gxLZGyjsVDyGmiDBN+NpNxPW/HjH1WktY4tvqo6mHAsLK99cMmpy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968940; c=relaxed/simple;
	bh=1tekR1kgznI6NTy+GMChZdqNxnl6/U+MCw9OglcS63w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5S8T6N+5tbYdnnK6wNMCUq2p3RwMDXJ0rG45Q4DThEIop8DQ1QBo+/pX72tn2XX0Pre95N8nYoDcyJg80OMLs8dQ+4u7ZlSPCaqAfcJ0HUfFWJsLo6w1WeTWmaUxcFS+IZ2+5CSdsgQdczEfx7v95Q6Q1wVWfv392m57LVHpME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=qZAEOvRV; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JJaaM96T; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="qZAEOvRV";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JJaaM96T"
Received: from phl-compute-10.internal (phl-compute-10.phl.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 31E6D1140172;
	Thu,  3 Oct 2024 11:22:17 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 03 Oct 2024 11:22:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727968937; x=1728055337; bh=+iiyeW6L/B
	6JihfOiOsc/n7n8+rRFS/4VgmyvtE0pRQ=; b=qZAEOvRVH6fSn6O8qmjmFNYgY2
	vOoFF8kLlLuXHr6AJURxagaYG3I7XtVQZksSkoNCJD/Ly1CScbxS3JIIwyHOORO5
	xM5+0y+GEGSqgWq2u/rOni60uwNxZT8Ot2Dos0RWbPoAFy+bb1pUi425iY5DK6Cw
	hAqfyYuup73g3V5aqq2xRETk55AXVWH1RfcAHEgf8UGpvQLPqCS74GsHtSPyTnOt
	wkbUENW7oloQJldu2Kxt0OKN83bOMaTbxdjdKKVSBwGMbgAg7JdAkLAkfs/W0Psx
	RuTqtvQj6yj3IbFvhMU8ahZ4pLF3E5BAuYLmuRCfPCAz5A8dBf1/3Lx/tFdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727968937; x=1728055337; bh=+iiyeW6L/B6JihfOiOsc/n7n8+rR
	FS/4VgmyvtE0pRQ=; b=JJaaM96ThUKi4lOTDSjznYf8fXup/bdeLmoDMdqp36x8
	Oo5bKQw1/t0POTfzCS7IC7NAvmowpKQhe1FDZZRgAuiS9ywmMICpztg6GFrATZMR
	jUlOOffRb60XIN7yHHUGOrhaJOPy8CP0NG3ZgSCdSNFyUvCprUl6abAT5r/xrq+i
	y5MIhugmBYdL3OCcqGvQ4uMjwS5agh7xaDAg84GqB60CWqoa5CL16XWikXeQnhpI
	98dAaUaTsMjMN7mHeX33ubxKD0fyIBnLUuScj0GWtYT/xGO2IUvW6oNedzoqCCIZ
	yh4uEdo54Psh3aPYFKWFvizf1KkTlvxCqiJ2uypC1Q==
X-ME-Sender: <xms:qLb-Zsdf8J1BVoBYZF9ccOfBRZ9HdeN3mE_Yg0ushniR4ZQOYoup8A>
    <xme:qLb-ZuOtz1paEJL4QVBuVZLAm80GwdTh93rNOzHTUAKRaPJbHRcrIaKqN2fAB3lGU
    Ve35yIwUsljRsFWrd0>
X-ME-Received: <xmr:qLb-ZthTS1_nBcizEhXY65KjPv6BSGIGzIQcKUjdP9Nfrh2S9U4aUFt-j06N2LVLxTInyTzu6di8T1cFNBzDfysGusiu>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeeftdffuddv
    geekueeivdeguddvueeffeevgeetgfeiueeuhfevffeutddvgfekvdenucffohhmrghinh
    epghhithhhuhgsrdgtohhmpdhgohgusgholhhtrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttg
    dpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhh
    ohhrshhtvghnrdgslhhumhesthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvvghsse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehl
    ihhnuhigrdguvghvpdhrtghpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlh
    hinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghr
    rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehmohhrsghosehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:qLb-Zh8vaiBjbK7G-xnw5j0Rs173fgmsEfVNKfj-zAOHzGpTHQ8s8A>
    <xmx:qLb-ZouuY8L9OSMFCGID1YvtPnMGtucRxbMfSBnKmP6aaoVXOfmyBg>
    <xmx:qLb-ZoHPTEbD4Sk_o1k-VutbFTZ7nWIAXhPo5DSGeepnLo25Oe0t2A>
    <xmx:qLb-ZnPRq4zHjjqMJRsPZ9BjZpCpE65IpuYcBjN6pg24fx-oXlTarQ>
    <xmx:qbb-ZqJVdSZSuBCS6iRq0T9vKNy4SxoaAB2WpkdX9QNgaZXFKCzsiUfH>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 11:22:15 -0400 (EDT)
Date: Thu, 3 Oct 2024 17:22:14 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv62pi1VVbpkvoDM@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv6YInHiwjLeBC3D@archlinux>
 <63D4756D-31B7-4EA9-A92F-181A680206EF@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63D4756D-31B7-4EA9-A92F-181A680206EF@toblux.com>

On 03 17:02:07, Thorsten Blum wrote:
> On 3. Oct 2024, at 15:12, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > On 03 15:07:52, Thorsten Blum wrote:
> >> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>>> [...]
> >>> 
> >>> This issue is now fixed on the llvm main branch:
> >>> https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> >> 
> >> Thanks!
> >> 
> >> Do you know if it also fixes the different sizes here:
> >> https://godbolt.org/z/vvK9PE1Yq
> > 
> > Unfortunately this still prints 36.
> 
> I just realized that the counted_by attribute itself causes the 4 bytes
> difference. When you remove the attribute, the sizes are equal again.

But we want these attributes to be in the kernel, so that
bounds-checking can be done in more scenarios, right?

This changes clang to print 40, right? gcc prints 40 in the example
whether the attribute is there or not.

> 
> >> I ran out of disk space when compiling llvm :0
> >> 
> >>> So presumably this will go into 19.1.2, not sure what this means for
> >>> distros that ship clang 18. Will they have to be notified to backport
> >>> this?
> >>> 
> >>> Best Regards
> >>> Jan
