Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB0B5B689
	for <linux-bcachefs@vger.kernel.org>; Sun, 11 Feb 2024 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707668108; cv=none; b=G/tArsWD1q8IYibCUPPMhDFfRpRqCznYkFitXBtVNID2rC9Iwov2dsbc5KsTOL/cTXNuqME91bWXZc6ttHlODuHw/6yKthBAhr+dzFO85iVj6quTQHRvz5sOD1IUFZaAVEQiLjq+QzrmUzMNyCB6oGYgUuvnPtycIl8NYumuG40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707668108; c=relaxed/simple;
	bh=j6IvtB1lhwnzDx3mnCeR/9OCA7JFr1yRCPKOZ/ijS0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o+heDpdrjswFpH5ip55drjupPduNip2nMDkX5Rfjm6BbZuQaFQjULRtdw4L9whkbHv4bGnbx8SdU+oyXyFAwRao2gTaNhuOY4QasYVRt+4m91Y1y9dnhWT6MU0DDrCfqmkSQ3i1wIbmM1oyH5fV/TmORJwdAkyIe0+UjIbcI4Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3DA21896463;
	Sun, 11 Feb 2024 17:15:03 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: RlndVt <RlndVt@protonmail.com>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject:
 Re: Mounting a encrypted disk: Fatal error: Required key not available
Date: Sun, 11 Feb 2024 17:15:02 +0100
Message-ID: <2381021.NG923GbCHz@lichtvoll.de>
In-Reply-To: <2316735.ElGaqSPkdT@lichtvoll.de>
References:
 <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
 <6018852.lOV4Wx5bFT@lichtvoll.de> <2316735.ElGaqSPkdT@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Martin Steigerwald - 11.02.24, 15:28:52 CET:
> Martin Steigerwald - 11.02.24, 15:13:25 CET:
> > Thus I recreated the file system and start from scratch after adding
> > the following quirk:
> >=20
> > % cat /etc/modprobe.d/disable-uas.conf
> > # Does not work with external SSD Transcend XS2000 4TB
> > options usb-storage quirks=3D0951:176b:u
> >=20
> > I hope it works stable with usb-storage only instead of uas.
>=20
> It does not. I/O error that aborted rsync within the first 10 minutes.
>=20
> So it appears that external SSD on Linux is currently unusable. :(
>=20
> After at least some Sandisk Extreme Pro SSDs reportedly having all kinds
> of trouble =E2=80=93 I have been lucky so far =E2=80=93 it appears that T=
ranscend SSD
> is not really a better choice. But let's see what comes out of a report
> to USB people.

On reporting this I got the notice that this could be fixed by the=20
following BCacheFS commit:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/
fs/bcachefs?id=3D3e44f325f6f75078cdcd44cd337f517ba3650d05

I was aware of some stable fixes, even briefly read through them. But I
did not make the connection.

I will likely wait till 6.7.5 and retry then.

Best,
=2D-=20
Martin


