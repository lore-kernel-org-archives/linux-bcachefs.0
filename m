Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E4A3595C
	for <linux-bcachefs@vger.kernel.org>; Mon, 28 Apr 2025 02:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745807697; cv=none; b=BNcke9BiNazcqa45J4nCtH4sxsY0DhE/2rimy3AGhDGe13jui3m2QaG9i8kUlqFjoXu4O15aZpaq9GpZVLPNuGHpMxw5rc/WEy96NJLnRnqx/OZJrsgFZ/CUjaVsPDP5OF9dxM5AOy9fuQZb0gRf8wx5R2rW3nG/5IF26ywH6L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745807697; c=relaxed/simple;
	bh=OXZ7I6zXjmszyhyYL5v93WH93c/8XPRpys1YoY0VUsU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNJxWkQrz3p6UwYTLOOqv08931W1x66NdUil3P6vdZZRC84ZlqqgreBmqWTuLzAS7ukHLsWA9FIxf7pvz29LmqOdo3PlQgTcCCXfJafveoBmJrww+4i2auSkQDIK6vaN3VsHD/GwuBfcx/0XikGh1X3QY+m7anZwLkwm+yofnn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TKebCTV7; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TKebCTV7"
Date: Sun, 27 Apr 2025 22:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745807693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OXZ7I6zXjmszyhyYL5v93WH93c/8XPRpys1YoY0VUsU=;
	b=TKebCTV7aiuw7AIBIK6tzzFB6GSBZ2aZSRnTHY5SNGQRjXqLNYvkDztOw3F0O39B7gLHsn
	gLPMOWpBQ5ZdQzr2vRxpz/0TVxAQeFsVxko5rGP1CEgjHvxIjcFV4YcauAdqyTqrbqEgwt
	sY8aozhyrUCrf1u6Oxz8FNHTmPukXrs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Autumn Ashton <misyl@froggi.es>, Matthew Wilcox <willy@infradead.org>, 
	Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
Message-ID: <dorhk5yr66eemxszl6hrujiqxnpera5kpvkkd4ebumh6xc3q2c@gtvl3cjfqfln>
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <aAvlM1G1k94kvCs9@casper.infradead.org>
 <ahdxc464lydwmyqugl472r3orhrj5dasevw5f6edsdhj3dm6zc@lolmht6hpi6t>
 <20250428013059.GA6134@sol.localdomain>
 <ytjddsxe5uy4swchkn2hh56lwqegv6hinmlmipq3xxinqzkjnd@cpdw4thi3fqq>
 <5ea8aeb1-3760-4d00-baac-a81a4c4c3986@froggi.es>
 <20250428022240.GC6134@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250428022240.GC6134@sol.localdomain>
X-Migadu-Flow: FLOW_OUT

On Sun, Apr 27, 2025 at 07:22:40PM -0700, Eric Biggers wrote:
> Nor does it actually do Unicode casefolding
> (https://www.unicode.org/Public/16.0.0/ucd/CaseFolding.txt), but rather
> Unicode normalization which is more complex.

Do you mean to say that we invented yet another incompatible unicode
casefolding scheme?

Dear god, why?
