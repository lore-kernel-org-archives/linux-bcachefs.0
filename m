Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A5C19993F;
	Thu,  3 Oct 2024 13:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727961128; cv=none; b=kCgGgMSM/8issKkT+XnLguFr1FyJcCUVJfLgfCTSEJS9W4k81G0jcyCUvkQQBsM8uqK1XPE7R94HQ0vA+Zj4tqKweg7CnR6Y3hKWnbsrAjQc0FmG8ugZeqVtFwrU4OnGgIuhHA+hkTUgMcQ86qyoJ+0FSyE+IgEtABd+wYjDzxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727961128; c=relaxed/simple;
	bh=anPbyQlBgh9VpTHjRNAUTppoGA6/xk4P7jIPoVh1bC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0YYl49QG3XN1QYn+NmKrcQ8V4vEDx5w379Xbolp4LDCmENyfa4UAkT4Bp4R3eu+8NGt2zoJTOIM43Z80/6WOv/FnegBf2qouEDO3rI2Rs0kKJnIpf+dVGYuvjZkvVijDSegrzas13/2jlT/2jBCbDwHg4UwUt/R0lO2RDPfKvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=n7ahmMHf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=kk2buC7w; arc=none smtp.client-ip=103.168.172.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="n7ahmMHf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="kk2buC7w"
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id C054E138024F;
	Thu,  3 Oct 2024 09:12:05 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 03 Oct 2024 09:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727961125; x=1728047525; bh=Q5l4C3MPLh
	Nagoi/hfCHiiMD9hszfuXKcIBy0Z/kEpc=; b=n7ahmMHfQhciEkHutSmwxCDeMO
	camtxzI5v/65etjb6r8YLBYZCfz/BF40Z1mz8zFP4caVO2MfpksvzbcfJRlgkimX
	UGjS8guVkPT/E76Tjc+xeG6H1Gpwrvrz4sKmsmHCnwBAfXvPRGzVdNRJrdP56QE9
	XK1VBgcnQvJ+cBEgilbyJk44k6C071EbLJXDJAxS1Sw5lqGho+kek1QHigPPToZz
	qncHklgZoMcWTs+oBaAZ0K+ZJr8yukX1hjBWCl6wr+kox0EUdvommfR6UvVXviqm
	zIXbl+zSxSpWfJ3ceDn6ELtiZ+6QYXYGTUBrnE3YLDZJ3qgUnkkvsAqBRxlA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727961125; x=1728047525; bh=Q5l4C3MPLhNagoi/hfCHiiMD9hsz
	fuXKcIBy0Z/kEpc=; b=kk2buC7wrmtEB2AIuUu7PBSTaahtGpQ4SQkJDe9J8Rqt
	ygvSeOafNQGZJEFs3vCuEnEg9nXu+tPIqiiB02DIwu45VxQkX9tW/q9+vOFAzWJ6
	MmdgqtK3JqJZ61nv8RlivmOq5lyUDQisWo3Ug8rm57JN/vMZsLzyVc8fU9NTWv1t
	t25PMUNcqE4ZOjbJ2hX2pmlTFZ05Sqq3I4FEepnhdJ4Apr87vImFB/eGL6ILBqTS
	Ua79XaHURpCB1pyjoKGm2nNXaB+hxi68Dg+ukUHq+ouJ0tSa06wTFnCUNlSmJG3Z
	/pzFJxcvh3+WvPiex1zECSpNgmKkNuVtbG0jDxx2WQ==
X-ME-Sender: <xms:JZj-Zh7Ot7tz0lH9WC8kVQ18RN0GoE6gu1LCTpov4uzQz75EalcF-A>
    <xme:JZj-Zu7SD2B2OjYRvY8bnCJoTAd9vbmhRD1eFsJYg27cFr8L7dcRJIh1MBcq550bE
    vczrSLztdiWgjSKw-w>
X-ME-Received: <xmr:JZj-Zof7Bu3_FZHu98cy7GZkocIE2Pl43uGUn1UhhlgCIKrBsdwiYY96A0qwnxr_1ONXVrRCrpzyrGWjyAFX75vLnt-o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddgieduucetufdoteggodetrfdotf
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
X-ME-Proxy: <xmx:JZj-ZqLOS2moWssrXhgOdaNuT4T2FXOx2aO57NZAaCu4h86xIHpJmg>
    <xmx:JZj-ZlJLiCYvXvLxTIINRntJElKr2bd7EV6aWFmyGUdotyGTvzXtFg>
    <xmx:JZj-ZjxaMuiTGQKwspIxxXf4dJyvF7o8J-7cLSe_j_1FWWjdUO0rsg>
    <xmx:JZj-ZhLlb8S9ms1BWCNjorX0UES7Sjp3eoltDjXocGu0ho5uXfcGSg>
    <xmx:JZj-ZuXbWdJ1fF298xeAlsMAokO2EBTh0olLMzcUPlaeLWTeJYuHUEJ9>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 09:12:04 -0400 (EDT)
Date: Thu, 3 Oct 2024 15:12:02 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv6YInHiwjLeBC3D@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>

On 03 15:07:52, Thorsten Blum wrote:
> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >> [...]
> > 
> > This issue is now fixed on the llvm main branch:
> > https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> 
> Thanks!
> 
> Do you know if it also fixes the different sizes here:
> https://godbolt.org/z/vvK9PE1Yq

Unfortunately this still prints 36.

> 
> I ran out of disk space when compiling llvm :0
> 
> > So presumably this will go into 19.1.2, not sure what this means for
> > distros that ship clang 18. Will they have to be notified to backport
> > this?
> > 
> > Best Regards
> > Jan
