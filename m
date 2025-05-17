Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE7DFBF6
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 May 2025 10:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747478481; cv=none; b=lDup77OSkIW2tgWXsL6YP/xLOEBUL+IniNnin/2rUrUKSLC57XA1ny8/KfBBGC+4bG/UH7iy5WqrRl7soiQsnqsMm8bT3QapK1nEgAaBHyQ1U+/9LWHTZXMZ/qr1CqXiWV5E7c2s86xXuKiCYT4D9FsFn1V+pojPN5CDrFf5QUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747478481; c=relaxed/simple;
	bh=/+/axh/Y69caNlx2c2J4BpXOl3Rev5FRE87zPKc4Qrw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PxV+vRecyoReyVFan8AFQlEnHNqbXNEg/51/+T0BYZZKHXmguUngrgo6OOXj3ZyYQmnawwxmkreDNOnwfj4mS/poGce2+v6ir5MMHh3nz06iEWHGftIEXaZj2Q4eInb2LCMS6ctIQVZlXVCEVTE4JCvMrJ3Nc9Q4cA0HeEmEQko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 94588FB898;
	Sat, 17 May 2025 10:41:15 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org, Pavin Joseph <me@pavinjoseph.com>,
 Malte =?UTF-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>
Subject: Re: Status of rebalance and scrub support
Date: Sat, 17 May 2025 12:41:15 +0200
Message-ID: <5890559.DvuYhMxLoT@lichtvoll.de>
In-Reply-To: <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
References:
 <28759521-d0ef-4f56-ad3d-3f07ad670adf@pavinjoseph.com>
 <4984817.GXAFRqVoOG@lichtvoll.de>
 <7d4de775-2fd3-4edb-8c24-bd1736a4df89@tnxip.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi.

Malte Schr=C3=B6der - 17.05.25, 11:15:39 CEST:
> > % bcachefs data scrub /mnt/tmp
> > Starting scrub on 1 devices:  dm-6
> > device   checked   corrected uncorrected  total
> > dm-6     0 B         0 B         0 B      17.2 GiB    0%  0 B/sec
[=E2=80=A6]
> Can you retest on 6.15-rc? I didn't try that on 6.14, but on 6.15 it is
> working for me (tm).

Thanks for letting me know!

Wonderful, seems to be working just fine:

% bcachefs data scrub /mnt/tmp=20
Starting scrub on 1 devices:  dm-6
device    checked   corrected uncorrected     total
dm-6      17.2 GiB        0 B         0 B  17.2 GiB  100%  complete

So seems since 6.15 there is scrub support :)

Best,
=2D-=20
Martin


