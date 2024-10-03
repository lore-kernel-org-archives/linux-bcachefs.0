Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92531474C5;
	Thu,  3 Oct 2024 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727955222; cv=none; b=pQKzDVgbq7yf/Q9VsnlNyQk0E2P430kQCdcmCd3kb+CLW0o+4d9H+/wFhyzYTpkR1slpVH3rFGiKxkuvcnTVm2YjD1JcYoUy1gkV2Ccz9AvwRZNzdEzcHcswoC1b9yk9p/79sMWPFZwSDtmPzBvhmjlp83EXIglYvZxiVKYkzPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727955222; c=relaxed/simple;
	bh=9uwwMRWujgBj6NRSriDYtGiLD2SYNxubjA2LiQchzk8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtIKQ+DT62/UB9DBEoT5AYKgMLF0kLaA9hFOLwoEfa9MWBgoh6fnzGQ+tXjfOPFZlFK//I8mKNnja4bwxmXxE6bW0TU2gXle9TvnvVFRS21sNzwG0Y3XAF80MJzqTWFMqJNznzVnJQWFQNUqyaX2IPmNKs7Yzfqo33TFQY9Lo/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=W44WT1+y; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OnScxk2U; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="W44WT1+y";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OnScxk2U"
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E23CC1140098;
	Thu,  3 Oct 2024 07:33:39 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 03 Oct 2024 07:33:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727955219; x=1728041619; bh=ITwStiI4Uo
	IxQN/WOjmxMxGF8QBDYiDTW6WbZmMaBUc=; b=W44WT1+yzOf701vtK11mLHw+nr
	/QlH5RkPNP2rnV6y0LMYt98Eo0zitZUbyxdtYi69B0zW/cY5kzxKmQG5YiRIs7nI
	C4j7AIvayXbKr9MybkObbjmPlWJc0TSThzkq/f7U9qzIN1IxNKm044C23p2RS6kU
	Eod8BNM4uLvIAGhRiIUI/+AqfdLoaOoDV1Z1ugMQR5PwmdNqvS+JQjDiJqy3noF5
	0rZ1AvVrw825sB4tjdwSImIZjb+b0JFiikuGA4N7esi0lsYeeW2UWDz2cMpZ+6Hn
	Nv7GkO8PkosSS+EGJTjueT9TurEG5RxavUkRlYzyLQkzfe4MiV9+caYJi51A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727955219; x=1728041619; bh=ITwStiI4UoIxQN/WOjmxMxGF8QBD
	YiDTW6WbZmMaBUc=; b=OnScxk2U5zkrv1nL/n86Q4gLSGu1YC74mSZS2zC3nU8I
	npRQ/VeeL0stjxeOljzCp6fYjkCU6cT0hhY2aXdCL4OeFdfQU2zR6uTqTqng0twI
	m/P9RZLiU+hbRO8ArMmNqj8O7vUiU39k3nNw8mY1ctgTu2x35ne7AIC0UWL9wVxo
	lyfgWc6Qr2c9bwV+H6iYpVt6LyLz31QbxjdPw9W3zR37WawMnKDbw7+EGfktcCaG
	y5/xDiQ7ZuWgDzYoRwSi1U/XTwEsoi0+md3GBXReteD4n89Yj7yJ/mTVtH2hFlZZ
	Mx3Q9km4NWe+kwQZHR9o4H0o8zQAQyzyULpFZgFeOw==
X-ME-Sender: <xms:E4H-ZkenS-dxJs5EhlarKw9_6--U7dpLoXUagVbaeQYLQJc0RGHhCw>
    <xme:E4H-ZmMf6oJLPyZDsWNZfVeub15A_mjR_LC9Zv_BwGsinlototgmESNw5w6cyquyP
    tMuuMKvv4PAiLtnU8k>
X-ME-Received: <xmr:E4H-ZlinhtZ0HECTHwBzHO579WsoqRAWcyKStJHuIEF35gO3woQkBCscd4iOM_tC0zG8_WLq3e-_x42C8iBM6rm8Enps>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpeejleeljeev
    veffieefhfdtleetveehhfeuudfgffekkeefgedvfefggeeljeefhfenucffohhmrghinh
    epkhgvrhhnvghlrdhorhhgpdhgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkvghrnhgvlhesjhhfrghrrhdrtggtpd
    hnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehthhho
    rhhsthgvnhdrsghluhhmsehtohgslhhugidrtghomhdprhgtphhtthhopehkvggvsheskh
    gvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvnhhtrdhovhgvrhhsthhrvggvtheslhhi
    nhhugidruggvvhdprhgtphhtthhopehrvghgrhgvshhsihhonhhssehlihhsthhsrdhlih
    hnuhigrdguvghvpdhrtghpthhtoheplhhinhhugidqsggtrggthhgvfhhssehvghgvrhdr
    khgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqhhgrrhguvghnihhnghesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopegrrhgusgeskhgvrhhnvghlrd
    horhhgpdhrtghpthhtohepmhhorhgsohesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:E4H-Zp-8sStNb5B0XiPXhFNjDmSuiLLtdT_BxYoKmRtPwLGcKvXE3g>
    <xmx:E4H-Zgvu-0r0tiJETo3urgqAL9TfxM7vCG8wV7XuYGwIYnxD0cbcjQ>
    <xmx:E4H-ZgHZLMKTIG-p1vQ4NWFlmIjaup-jb1DZkB3x2ZYELEK1ysl0bg>
    <xmx:E4H-ZvPcmFXim2EvGxt7v0qXX4a9kWBZW40gJcYfj7lR2l2PnoLLyQ>
    <xmx:E4H-ZiJDu7CJLyJc9IzDApfkpGP8wubig_qzGsEr7hrd7EDGaF-N5Pgd>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 07:33:38 -0400 (EDT)
Date: Thu, 3 Oct 2024 13:33:36 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv6BEO-1Y0oJ3krr@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>

On 02 11:18:57, Thorsten Blum wrote:
> On 28. Sep 2024, at 22:34, Kees Cook <kees@kernel.org> wrote:
> > [...]
> > 
> > Sorry, I've been out of commission with covid. Globally disabling this
> > macro for clang is not the right solution (way too big a hammer).
> > 
> > Until Bill has a fix, we can revert commit
> > 86e92eeeb23741a072fe7532db663250ff2e726a, as the problem is limited to
> > certain situations where 'counted_by' is in use.
> 
> I already encountered two other related __counted_by() issues [1][2]
> that are now being reverted. Would it be an option to disable it
> globally, but only for Clang < v19 (where it looks like it'll be fixed)?
> 
> Otherwise adding __counted_by() might be a slippery slope for a long
> time and the edge cases don't seem to be that rare anymore.
> 
> Thanks,
> Thorsten
> 
> [1] https://lore.kernel.org/all/20240909162725.1805-2-thorsten.blum@toblux.com/
> [2] https://lore.kernel.org/all/20240923213809.235128-2-thorsten.blum@linux.dev/

This issue is now fixed on the llvm main branch:
https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a

So presumably this will go into 19.1.2, not sure what this means for
distros that ship clang 18. Will they have to be notified to backport
this?

Best Regards
Jan

