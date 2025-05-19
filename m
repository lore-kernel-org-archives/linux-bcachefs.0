Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E71B43147
	for <linux-bcachefs@vger.kernel.org>; Mon, 19 May 2025 15:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668591; cv=none; b=iXPtXL5qd+9Thv+0fyVStqC32PdXHuufVXOz62Av6JudCiin/e6PtgkdKQKlbyresctqRlTq5Ydgk0Y7bTnDuaPVDkatmDwjbdOhf1blACrZKvAWXgG4oSNfOeIaHS2D/Whe/s59Ol4+UHQRNThTYNUOlJPrl+svP/WY5Msyo28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668591; c=relaxed/simple;
	bh=NZpUjXlfzgv2+3WwktvBzyYdkXKRAN9A0/R6VRcSAEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ckhFHO3pEuuRQEjo1gwMv6H/eGi+8sZmDK1qUno3DRNYQMtG3EgEmnsIcs5RO8bdsScTQMq7CNsmChVzWb5PA/7NdiBgH3lw0M//iKxHolqUXvzuu3nHkzvTeebPRwAdFgCdM7TiyQ2mRYpFy+VUQBheNL4sJg5VIV5FOksD5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 13A6FFCAE1;
	Mon, 19 May 2025 15:29:39 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: John Stoffel <john@stoffel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Cc: Malte =?UTF-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>,
 Pavin Joseph <me@pavinjoseph.com>, linux-bcachefs@vger.kernel.org
Subject: Re: Status of rebalance and scrub support
Date: Mon, 19 May 2025 17:29:38 +0200
Message-ID: <3362164.44csPzL39Z@lichtvoll.de>
In-Reply-To: <wqlurfdcgogbxneenl4dbu756x3qy5oez3thyp5ifjb2n326md@ixrcqjntrzc2>
References:
 <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <26667.17285.448393.277537@quad.stoffel.home>
 <wqlurfdcgogbxneenl4dbu756x3qy5oez3thyp5ifjb2n326md@ixrcqjntrzc2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

Kent Overstreet - 19.05.25, 16:54:17 CEST:
> > >> If by "rebalance" you mean equalize the amount of data between
> > >> drives
> > >> (like btrfs): No, it can't do that at the moment. There is a thing
> > >> called rebalance on bcachefs, but it does something different (I
> > >> think
> > >> it moves data between tiers).
> > > 
> > > I was thinking about renaming "rebalance" to "background_data".
> > 
> > tier_migrate?  migrate?
> 
> It's not just for migrating to different devices, background compression
> is quite popular.

How about "background_data" as new command group (maybe you meant it this 
way to begin with)? Like in:

- background_data migrate
- background_data compression

Only caveat is: It is a bit lengthy this way.

Maybe there is a good shortcut for "background_data" like "bg_data" or an 
alternative word for it that is short but also matches the meaning. But 
maybe these are more rare command calls and then length may not really 
matter.

Best,
-- 
Martin


