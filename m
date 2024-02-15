Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04158127B6D;
	Thu, 15 Feb 2024 11:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707995372; cv=none; b=NPSglT9Tv88+cDwq+NJ/cCpHUaOrs+WsZHvCsTTTdplO3hQ/r5UFUrE0MvzYZoZnXI8rGaVtNSJe3KLJNzxqVPS7ycThBXWU5bS0vw45c7NeiDzUDLaX3U/UsMJrfo7Nsq7y9pnAFchWAE1XzkuoYFQIPRvVZKK2MzxFScfk18c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707995372; c=relaxed/simple;
	bh=Y2pGpvd23nSIXN6OktBS6/0YBWljbrMTHz18LGF/8m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Maa+PXmriJ22Xsyaa3nZmUa/LTAZN4Q7vW0nCtOWQxHgleuWvaixjBZYqV++XH4CdWhA+MtG3usckR4fEac4MW6I/9h7Iv7Uc3SgjFSopue/hjGdGgg7459kZTHp9YU0Jf5PuS74nNZ+rRbIZtkp7MaW5/YyhKu5RA3919ugpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id BF16C89B671;
	Thu, 15 Feb 2024 12:09:20 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-usb@vger.kernel.org,
 Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
 linux-bcachefs@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Date: Thu, 15 Feb 2024 12:09:20 +0100
Message-ID: <1979818.usQuhbGJ8B@lichtvoll.de>
In-Reply-To: <ypeck262h6ccdnsxzo46vydzygh2y6coe3d4mvgermaaeo5ygg@4nvailbg7ay3>
References:
 <1854085.atdPhlSkOF@lichtvoll.de> <6599603.G0QQBjFxQf@lichtvoll.de>
 <ypeck262h6ccdnsxzo46vydzygh2y6coe3d4mvgermaaeo5ygg@4nvailbg7ay3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Kent Overstreet - 12.02.24, 21:42:26 CET:

[thoughts about whether a cache flush / FUA request with write caches=20
disabled would be a no-op anyway]

> > I may test the Transcend XS2000 with BTRFS to see whether it makes a
> > difference, however I really like to use it with BCacheFS and I do not
> > really like to use LUKS for external devices. According to the kernel
> > log I still don't really think those errors at the block layer were
> > about anything filesystem specific, but what  do I know?
>=20
> It's definitely not unheard of for one specific filesystem to be
> tickling driver/device bugs and not others.
>=20
> I wonder what it would take to dump the outstanding requests on device
> timeout.

I got some reply back from Transcend support.

They brought up two possible issues:

1) Copied to many files at once. I am not going to accept that one. An=20
external 4 TB SSD should handle writing 1,4 TB in about 215000 files,=20
coming from a slower Toshiba Canvio Basics external HD, just fine. About=20
90000 files was larger files like sound and video files or installation=20
archives. The rest is from a Linux system backup, so smaller files. I=20
likely move those elsewhere before I try again as I do not need these on=20
flash anyway. However if the amount of files or data matters I could never=
=20
know what amount of data I could write safely in one go. That is not=20
acceptable to me.

2) Power management related to USB port. Cause I am using a laptop. It may=
=20
have been that the Linux kernel decided to put the USB port the SSD was=20
connected to into some kind of sleep state. However it was a constant=20
rsync based copy workload. Yes, the kernel buffers data and the reads from=
=20
Toshiba HD should be quite a bit slower than the Transcend SSD could=20
handle the writes. I saw now more than 80-90 MiB/s coming from the hard=20
disk. However I would doubt this lead to pauses of write activity of more=20
than 30 seconds. Still it could be a thing.

Regarding further testing I am unsure whether to first test with BTRFS on=20
top of LUKS =E2=80=93 I do not like to store clear text data on the SSD =E2=
=80=93 or with=20
BCacheFS plus fixes which are 6.7.5 or 6.8-rc4 in just in the case the flus=
h=20
handling fixes would still have an influence on the issue at hand.

=46irst I will have a look on how to see what USB power management options=
=20
may be in place and how to tell Linux to keep the USB port the SSD is=20
connected to at all times.

Let's see how this story unfolds. At least I am in no hurry about it.

Best,
=2D-=20
Martin


