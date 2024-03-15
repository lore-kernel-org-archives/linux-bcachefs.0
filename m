Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E6617592;
	Fri, 15 Mar 2024 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710493696; cv=none; b=KR70I7IZAAuXd0k0OfBNKspD58A7MIykmPCbBEmWLYsFbAmt+gj5K2ghwFzxyRTGoOkwc+7GBzVtH6hQI7/TYM+GEQOaqXoHuVkc7JkSeNF6bs+qH3JnbFFy7qXC8Rl1O8sbWvIKW28Ja47vhi/NZeXSnPFtjTmyjQzYzpyqcN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710493696; c=relaxed/simple;
	bh=2ZA3lXw/Y5WlDbXJ1oa4fCewvxABns3BN9JEMbyDDEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsqsYoC7P0wFZ9ytNO3Bk8H0xL2MN5UzRCn83WZrrPuOJzuRSf0k+WVRxrrHYga0PbeCSBq7aarF0NzQ7/EyjZ5HCYuAdX1a8Iz7P4TWQNh5Opv1R7gn+clSuENf8+xu5/dmCZGmdNE0XUTpKQKRz/3g0uKE46DVrVXv8EOD0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id E8A1B8C0883;
	Fri, 15 Mar 2024 10:08:10 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-usb@vger.kernel.org,
 Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
 linux-bcachefs@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Date: Fri, 15 Mar 2024 10:08:10 +0100
Message-ID: <4894644.GXAFRqVoOG@lichtvoll.de>
In-Reply-To: <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
References:
 <1854085.atdPhlSkOF@lichtvoll.de> <5444405.Sb9uPGUboI@lichtvoll.de>
 <mqlu3q3npll5wxq5cfuxejcxtdituyydkjdz3pxnpqqmpbs2cl@tox3ulilhaq2>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi!

Kent Overstreet - 11.02.24, 19:51:32 CET:
> He only got errors after an hour or so, or 10 minutes with UAS disabled;
> we send flushes once a second. Sounds like a screwy device.

Kingston support intends to RMA the XS-2000 4 TB SSD with a variant with a 
newer firmware version, in case they have it available, while they work on 
a newer firmware version for the device variant the error happened on.

So it appears the device has a bug. I will keep you posted, once I either 
receive that other variant or a firmware upgrade for the existing one.

I am happy with Kingston support so far. It takes quite a while, but they 
are taking the issue for real instead of writing use Windows instead of 
Linux or something like that :) - like I read before in other occasions 
with hardware from other suppliers. Thanks!

Best,
-- 
Martin


