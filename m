Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BE0D23A6;
	Thu, 17 Oct 2024 00:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729125711; cv=none; b=IkRNauYSfKzzTapNfAyHeqL2J6xzmOtgzsOvewuS1JjBcV8WG255Vsiw6DhxNNLfz71iveJCa7hNs/Zddbag/MT+zmILP5NoHUWu/Ai+8usJIVNKB3+xCJWOlht855NhMr4zlW2pyiOBFJyPmN9xo0oBXjU6mvho7MY/juGebb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729125711; c=relaxed/simple;
	bh=7QkoQYQX3zTw7nHF+GB459hVBusGgSOd7/jSBdPBJD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=guz150GljGh9Tq40mKuX0ocXvs1BENU664TOlSMoz2djwvsv2U2bzpLmbc3XhDj/S3qH2y1mCeGRMNsbJmAmeeCrLKp7R2Nck5Htk4MwJSYOQ5nr4zv2cSkPNlTUsCoDLHVMmeR2K4Gtkl6cCcaomOwJ0BIf+LJFTTC6XTBz8zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=BH+Qo8Cw; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=GZaU02+l; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="BH+Qo8Cw";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="GZaU02+l"
Received: from phl-compute-08.internal (phl-compute-08.phl.internal [10.202.2.48])
	by mailfout.phl.internal (Postfix) with ESMTP id 66ED913800F6;
	Wed, 16 Oct 2024 20:41:48 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Wed, 16 Oct 2024 20:41:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1729125708; x=1729212108; bh=7QkoQYQX3z
	Tw7nHF+GB459hVBusGgSOd7/jSBdPBJD8=; b=BH+Qo8CwQbiGXvse6CHyuR0zbi
	mHg7VF39duGWH9HnpYPS1dDFhxVs66wXBVSfDRQzUiMWO61PHxTjKDlBQakQy7XP
	4MEDxwsKHzDtTBm67KqFEheWcZMoEEqzUzZE7XUaRfGQjBNVI/fEkJXfNDwsDlxM
	e+6mRcqjXyZcLCOw3I/juNErPbo98bWs8uD0Mwm53Jwch11bJlcNXw+48pJGgvrp
	7LnnQFfk7o5ffAzv/IOQkGb54zjSjYyj44wOUx5ujwVszVjZZtgWRZkeo2s0Kn7x
	u846ZigQPBuKNpeJVTRcpM5AKBUSeWYn11Nsch7IIBw2CpwXJyQNpxDoH7Hw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1729125708; x=1729212108; bh=7QkoQYQX3zTw7nHF+GB459hVBusG
	gSOd7/jSBdPBJD8=; b=GZaU02+lMQGSBhjhgsOnTQlWffn6SlfIOffOqHbT/NjO
	2L3vg0TSJW9drvrpeRRbeCwuU+8Yfm1om/mtJiQ8ArK35b/6xNRTCb4sS7rv6C69
	CaH/C4IqxIE7yUhVBStKaaXcVoFCRSUAVS5XAkbr1G/xYbN/aL/OcJA34j14Y9+8
	MBTlCRlRvbZLRT5F6HYWHLOwK2bgm7gqTzZINefYdpqkNNr/JUq1P5mZpY7PXprS
	yK6Qd1hXDXkB8nVOLRLpM7Oh23P0hVo4DdmyCHd6pafesN7FbQ7XVAIglJH9SgKx
	IaB8c12GvyXD0mX1QlCydYwqVqABYvTtsQrZrTj9eQ==
X-ME-Sender: <xms:S10QZzvo8wLPjxy06WB9SaJh8H3bsW2iMuGo7avw0eY5EM9R5Ep4XA>
    <xme:S10QZ0f_2OyRtD45auHV1dhhNNMY31CuzEu0eH5iVuGd1wXww7A19-BLRg5-0Kx3T
    bniHuKPezik7yNeGy8>
X-ME-Received: <xmr:S10QZ2zTkqy1gnSC7xB9Qd5V0iUzjiBR3-zZcVKyey-66hGmqPv24cPAgNBWpzSXoWO4SkQi5-IFbUYy5Ve6IEuXUl4y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdehtddgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdludehmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpefffeejffev
    geejudeiveektdeiveefgefghfffveeujeefhfefffdvvdfgiedvheenucffohhmrghinh
    epghhithhhuhgsrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttgdpnhgspghrtghpthhtoheple
    dpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgt
    ohhmpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehthh
    horhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvghnthdr
    ohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtghpthhtoheprhgvghhrvghssh
    hiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgs
    tggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuh
    igqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprghruggssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:S10QZyN56jgDuy0MUeD44oE83BxlpO46fFS4j8MFpaOMSIRLQIk-9w>
    <xmx:S10QZz_KMie2o9TWgU-MjdMIFHYE4KvYTAjYMx3_4Tl6BEe8NmXi1w>
    <xmx:S10QZyVTT-fc4lkbLBKDevoRaIDx3guDWGfYVcQ42p5IzUuNFS9FFg>
    <xmx:S10QZ0c2M_BetIcQrf4dBFaDgM-_NBrde7Ok9Hg7khFTsOTYBD1_HQ>
    <xmx:TF0QZ6YobGkUYnu5XwrXbeM5DZwK5zkw2LwiacGgpvHLfj8miwqEVHQq>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Oct 2024 20:41:46 -0400 (EDT)
Date: Thu, 17 Oct 2024 02:41:44 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Bill Wendling <morbo@google.com>
Cc: Kees Cook <kees@kernel.org>, Thorsten Blum <thorsten.blum@toblux.com>,
	kent.overstreet@linux.dev, regressions@lists.linux.dev,
	linux-bcachefs@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org, ardb@kernel.org
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <ZxBdSKuDWh6w_w-z@archlinux>
References: <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
 <Zv61dCaxScXuOjZg@archlinux>
 <202410031424.45E5D19@keescook>
 <Zv8RIs-htdc-PtXB@archlinux>
 <202410040958.C19D3B9E48@keescook>
 <ZwNb-_UPL9BPSg9N@archlinux>
 <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGG=3QUatjhoDHdkDtZ+ftz7JvMhvaQ9XkFyyZSt_95V_nSN8A@mail.gmail.com>

> I would be in favor of disabling __bdos on a whole struct pointer if
> it will match the functionality between the compilers. I don't think
> Qing has that on her plate at the moment, but when / if she revisits
> that we can discuss exactly how to perform the calculations then.

That's a good approach from my perspective.

To get this done we would:

Now:
1. Disable the __counted_by attribute calculation in clang for whole
struct __bdos cases like in [1] and get this into the next clang point
release (19.1.3)

2. In the kernel, disable __counted_by for clang versions < 19.1.3. Also
backport that into the stable kernels

In the future:
3. Try and figure out what the correct counted_by calculation for whole
structs should be in conjunction with gcc and clang. Either provide an
option in clang and gcc to follow the kernels expectations or change
struct_size in the kernel to match gcc's and clang's future behavior.


[1] https://github.com/llvm/llvm-project/pull/112636

Best Regards
Jan

