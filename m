Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0712E851
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Feb 2024 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707661737; cv=none; b=mDZGKpD6sGUL8aBTgXL+F1WfC8BqsF3J+4xzvd2xOccZmptUD3Jv61MJVom/h7hjxQdU0MfchttgIyaSQMeBOSUlCF2s6aqcPu8Hs8ORDgcLG+fqRjBpAWENu3gIzdNA62tLdMWcsdB4q3JcpudyHbyhpJIDtGU+DndLUZSOi7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707661737; c=relaxed/simple;
	bh=xo560yL1K0HL/LPZHw1X2SwrzLajwjHAlYQ1fMyEAX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OU7WIN/RVD3RdPxAzl6r033VXsJ5pLPngPwi/2vrzS66Wxca9ZBzWK0qHVT4Al6m5zfKXoDgkI6kur/2do/dazoEt2COjdlDY8U8qxR/QdaV3R3HdQeQsV+C3Msg7a/ZWBzTwVnbnupVVG8KJisoghvbEjcVmlobR5hiJZJIzDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 69985896245;
	Sun, 11 Feb 2024 15:28:52 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: RlndVt <RlndVt@protonmail.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject:
 Re: Mounting a encrypted disk: Fatal error: Required key not available
Date: Sun, 11 Feb 2024 15:28:52 +0100
Message-ID: <2316735.ElGaqSPkdT@lichtvoll.de>
In-Reply-To: <6018852.lOV4Wx5bFT@lichtvoll.de>
References:
 <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
 <afzrkbtBglFNpOW-YIx7L6WNqdsPlgWUp9EzVxMzGXdUrzUW0Np_eVwo7EkCWWIaSNTFsZUv7TYn6zeWxLH3qa_tuB-tCNhoQeGZbb5DG4c=@protonmail.com>
 <6018852.lOV4Wx5bFT@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Martin Steigerwald - 11.02.24, 15:13:25 CET:
> Thus I recreated the file system and start from scratch after adding the
> following quirk:
>=20
> % cat /etc/modprobe.d/disable-uas.conf
> # Does not work with external SSD Transcend XS2000 4TB
> options usb-storage quirks=3D0951:176b:u
>=20
> I hope it works stable with usb-storage only instead of uas.

It does not. I/O error that aborted rsync within the first 10 minutes.

So it appears that external SSD on Linux is currently unusable. :(

After at least some Sandisk Extreme Pro SSDs reportedly having all kinds=20
of trouble =E2=80=93 I have been lucky so far =E2=80=93 it appears that Tra=
nscend SSD is=20
not really a better choice. But let's see what comes out of a report to=20
USB people.

Best,
=2D-=20
Martin


