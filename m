Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE85221F0A
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 11:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747913068; cv=none; b=JoqIT0NW3sS+fX1+a/hWD6GCVIeWMcBQz/beaw4lfkljbXs4hoH/WufCMkn7p8l5ngE6M4iWttNIf6Qj2N/cVSLBthIw37oge9CMQAQeX5CI0fTqlxv6ZFIvdlS3Z6pCGy6fTWEbPpEv2SRNy8ZdoweeWwRNSB9BkvggylNVW4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747913068; c=relaxed/simple;
	bh=+zQS3S6RMbxbtQ1jmleifwG7mLFUwlhBih4BfL3KQyc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=S23jHB+M72Kv5R60OgLK2vekfq4uLBDGclDvqaKTq4M3BOdWjW6y4GgWd5orlMDJsTEofP3zwO1VuFgY5CErmoCtCwY6OfKGP9zXZmd458kdNb9eBtNTo9h2w6ODZB2UXCfW0YuvAuHE+48hywlp9V5o5+wTKW2AMZCSqyNJQq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hRx0XTFc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hRx0XTFc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE960C4CEE4
	for <linux-bcachefs@vger.kernel.org>; Thu, 22 May 2025 11:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747913067;
	bh=+zQS3S6RMbxbtQ1jmleifwG7mLFUwlhBih4BfL3KQyc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=hRx0XTFcH5l4Pe5k/ic8pgt3QoXZqn6+HxxKXj8ljjn3z03LROw3khFLP+8lW2Wfu
	 8kGnAay8xYUc30SRjGlPSLv8f+6/LhpwiEIZSzRIu4mVTAjTyUCuaQv3WjgoqTk5fq
	 G3g2a+dCp6NYQMlTQ3Ran8hydpbRr0B9nkbiM+F59vgVP4goUfLniX6AMWDhBoGzad
	 lS5FnRphPg2jA8ig4efWwDphmjEFUToGn5PgNjA8CG13r7amwpf7yjzSvTKfn2DKys
	 npdhBho+cBJ2ZNwrXYJpHyOhR+uZl7yGPGi81wKbnh1Dw/Ui3U3hrTRUZY+WkD/sVe
	 1AMsd4HiHPwqw==
Received: from phl-compute-05.internal (phl-compute-05.phl.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id B66641200043;
	Thu, 22 May 2025 07:24:26 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-05.internal (MEProxy); Thu, 22 May 2025 07:24:26 -0400
X-ME-Sender: <xms:agkvaGInivNR1_igikpTEaJ8gFW66enV8XgE2JpfYuzQr6blhyiZ1g>
    <xme:agkvaOLsgmNwYJJCeacPrh9a_u_9VErXlwN9EInDKpPNbxe8RvoKZvY2OqK2J3uNf
    kzizdlcFti2OAKaazI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtddtgdehkeegucdltddurdegfedvrddttd
    dmucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgf
    nhhsuhgsshgtrhhisggvpdfurfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttd
    enucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepofggfffhvfevkfgj
    fhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrnhguuceuvghrghhmrghnnhdfuc
    eorghrnhgusehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhepjeejffetteef
    teekieejudeguedvgfeffeeitdduieekgeegfeekhfduhfelhfevnecuvehluhhsthgvrh
    fuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhguodhmvghsmhhtphgr
    uhhthhhpvghrshhonhgrlhhithihqdduvdekhedujedtvdegqddvkeejtddtvdeigedqrg
    hrnhgupeepkhgvrhhnvghlrdhorhhgsegrrhhnuggsrdguvgdpnhgspghrtghpthhtohep
    gedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvnhhtrdhovhgvrhhsthhrvg
    gvtheslhhinhhugidruggvvhdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgv
    lheslhhishhtshdrihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehpvghnghdrfh
    grnhesnhigphdrtghomhdprhgtphhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhg
    vghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:agkvaGtASlOK3Gpw1n7r6OGUb_R7FIQzGERBuR91-LrVdZDEfGqBhg>
    <xmx:agkvaLb7BJ41ytP76-k1X4AdAfJPyUfip7SruoaM_IIxCTXVBYaD8Q>
    <xmx:agkvaNZ0UN4dyCLO8ZTUMJNF6Hjty_7LUMupho6wV182qOV-keVciw>
    <xmx:agkvaHCfaLsBkxnlU3KFPdCB_nUePkK7H3UCe8o6GC2mq8T9ySlIxw>
    <xmx:agkvaDYUqFg0nGaGmq4CoVq0Cz1Wpcr1hPzBDXHHIvMQGcK8fb8OGnvo>
Feedback-ID: i36794607:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 895A11060061; Thu, 22 May 2025 07:24:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Te8dbde31adf78faf
Date: Thu, 22 May 2025 13:23:56 +0200
From: "Arnd Bergmann" <arnd@kernel.org>
To: "Peng Fan" <peng.fan@nxp.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
 "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>
Message-Id: <d8e9f098-49a2-4f1e-a6a5-7a6437658d93@app.fastmail.com>
In-Reply-To: 
 <PAXPR04MB845954FBBF2AD810B17536138899A@PAXPR04MB8459.eurprd04.prod.outlook.com>
References: 
 <PAXPR04MB845954FBBF2AD810B17536138899A@PAXPR04MB8459.eurprd04.prod.outlook.com>
Subject: Re: error: the frame size of 1552 bytes is larger than 1280 bytes when
 building bcachefs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, May 22, 2025, at 08:39, Peng Fan wrote:
> Hi Kent, Arnd
>
> There is below build error with "make ARCH=arm randconfig; make"
>
> fs/bcachefs/data_update.c: In function 
> '__bch2_data_update_index_update':
> fs/bcachefs/data_update.c:439:1: error: the frame size of 1552 bytes is 
> larger than 1280 bytes [-Werror=frame-larger-than=]

Right, I think that's been the case with bcachefs since the start,
and I see it with allmodconfig as well, the problem being mostly
CONFIG_KASAN_STACK.

There are a couple of bcachefs functions that have an unusual number
of local struct variables in them, and KASAN_STACK adds a redzone
around each one of them, further increasing the size.

When I add "depends on !KASAN_STACK" to bcachefs, I see all
randconfig builds succeeding, but that may not be the best
solution.

     Arnd
