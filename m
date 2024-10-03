Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D81D19F489;
	Thu,  3 Oct 2024 15:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727969709; cv=none; b=EGFfGUN/Y+0H49tLrwFQIXYBfIbDWVQWX3IO8NJ+fa/kDjswXXpHd2sPy3PNHu8yuRz0fAZr6dEUdpERGpDcr7UIbuRt4WcSIVRRDQyMvzOV3Cga1SZ2fd1iBz50bUI+2YvAekEo1HGtRLe3xX9U5xnxze+4p+TOKBFuEspommE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727969709; c=relaxed/simple;
	bh=Y9+dzZ6ej6cktLk2J7H5hUHhQ+0dJdX8wCvIG11oW2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QlDah43mqIlx7oPLnbTAUFQZPV0ok+yyLW14VH3hQhanIDmdzdxdWdJt9snZz/cgMz3XlQuEJBMes7NUsYcLFcLaa7HroOtSQS2qv7Y7bnCheHgA35KuhjFfeIA+cmg2DOc680RLfhqbYvty5oc4UWXc3Jlcwc/CrOObw7JzuIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=m0VwvNSr; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Zqwt5hqi; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="m0VwvNSr";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Zqwt5hqi"
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 7D8A71140209;
	Thu,  3 Oct 2024 11:35:06 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 03 Oct 2024 11:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727969706; x=1728056106; bh=zIWMur9WX1
	+7RMEilJCIaMNXVuc6c2PkvWIccOIDHOI=; b=m0VwvNSrmtYfTLP9waUk+jTk42
	ELr3c4PtijSwlXnVjv60OjbJarivDQvXLtfnd0Pi2R1ms7XsmGPm+N3r39bnsy9j
	zEGz01vhqZiwnxp4/qAPMUF/ypLGboCLD8PSRl/dkRkZ/on3dOMg7WEunE1NwBCo
	l4zRjgeoU5rZzB9nnYFpw9/T5w53bOHp/SZaieEf2Wi8wWKtoyTjZ8XkKb9K2juB
	aQr9zLilvI6xrTxfRhZlskGJI4lMET5/AcOGKg8XPJekjHLv2b2rNKMjVjZpYdGH
	mdfujaVS4hymdVT52YW8gRqc1bCiO7+IkHZ3fJKeU8UFtrZeqrJn0vMkVg4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727969706; x=1728056106; bh=zIWMur9WX1+7RMEilJCIaMNXVuc6
	c2PkvWIccOIDHOI=; b=Zqwt5hqiSfOlXP9WTpS3Qt7XfktFcZ0cpfb1n+cY45M0
	kgGfUvOmA6u6inVBQBLm+u2+azzTy7Vv10OEtmTzIxuJRRyzw6rWJCBvtmURp2CQ
	upTdX7wP3AxGYjnrUvqBgUQpVw1fk3Gatsv/E1++54Yd7TzfFmWmiDTYjjxA45p7
	ytCnlgxDubf5WV+WF0utw6h8FjCOV5Oirnr4DMx3UYEyrWwhdWHXUwtrnrQHIrdZ
	7CKPYwNJ8Cu6I09dcLOHN3lB2XYjTh9SYlvBWWljymjkhG8xfTJ6E8C/mhJ5ZOWZ
	1LULMoyW76HTiNIqrvYWOnpwp4hVtgQwdV9klrzsuw==
X-ME-Sender: <xms:qrn-Zs4HOAw-SjUHLWZl5V_yCBKobXiFAJkfAZLs_5rJKIw0u1ZzlQ>
    <xme:qrn-Zt6CvKicXENFDscM3Ah4N2w1gQ8jujZIouMum34KDbwIcdVhgm5ZUqCEkvOh8
    bH0AeyYwIuWWPBVs1o>
X-ME-Received: <xmr:qrn-ZreE31Wof_PbvMKYtsc-5CD3-WGLyoZ8ZuANHlpOaH-kKdaGpMKvU7awEl9VmPade1WhQKs92OIAMseZXRxSXTFJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddgkeelucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:qrn-ZhJY_7Cyp26o1NU1NBsxxXvD1MMBSyqDiVpAjbbeSfd93PKE_g>
    <xmx:qrn-ZgJwtM6QNEBq1W1SQ8MOHJBUeXMaFQLoV-5XBiEK37ItNbuI_A>
    <xmx:qrn-ZiwZNJ7zuRMzh2Jqx8d9aGcf4bs9zTl3KnkE-fV5xAkdBvunlQ>
    <xmx:qrn-ZkLR-fnp4Fd6DKwXz852ILeTjn8Jc5bWJ1xg7803zw-xBehpcg>
    <xmx:qrn-ZlWhwrSyv1WXBjDJCUUOl-LH0jmy_U4wsRyMjX2b8QeU9VzZ-R1M>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 11:35:05 -0400 (EDT)
Date: Thu, 3 Oct 2024 17:35:03 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv65p8f4sxT4gKYs@archlinux>
References: <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv6YInHiwjLeBC3D@archlinux>
 <63D4756D-31B7-4EA9-A92F-181A680206EF@toblux.com>
 <Zv62pi1VVbpkvoDM@archlinux>
 <83834AC8-0109-40C5-A80C-8BFFA8F16B19@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83834AC8-0109-40C5-A80C-8BFFA8F16B19@toblux.com>

On 03 17:30:28, Thorsten Blum wrote:
> On 3. Oct 2024, at 17:22, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> > On 03 17:02:07, Thorsten Blum wrote:
> >> On 3. Oct 2024, at 15:12, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>> On 03 15:07:52, Thorsten Blum wrote:
> >>>> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >>>>>> [...]
> >>>>> 
> >>>>> This issue is now fixed on the llvm main branch:
> >>>>> https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> >>>> 
> >>>> Thanks!
> >>>> 
> >>>> Do you know if it also fixes the different sizes here:
> >>>> https://godbolt.org/z/vvK9PE1Yq

Do you already have an open issue on the llvm github? Otherwise I'll
open one and submit the PR shortly.

> >>> 
> >>> Unfortunately this still prints 36.
> >> 
> >> I just realized that the counted_by attribute itself causes the 4 bytes
> >> difference. When you remove the attribute, the sizes are equal again.
> > 
> > But we want these attributes to be in the kernel, so that
> > bounds-checking can be done in more scenarios, right?
> 
> Yes
> 
> > This changes clang to print 40, right? gcc prints 40 in the example
> > whether the attribute is there or not.
> 
> Yes, clang prints 36 with and 40 without the attribute; gcc always 40.
> 
> >>>> I ran out of disk space when compiling llvm :0
> >>>> 
> >>>>> So presumably this will go into 19.1.2, not sure what this means for
> >>>>> distros that ship clang 18. Will they have to be notified to backport
> >>>>> this?
> >>>>> 
> >>>>> Best Regards
> >>>>> Jan
