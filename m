Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA2F32C88;
	Sun, 11 Feb 2024 17:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.150.191.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707671194; cv=none; b=hUhtdiaoEH3xhG8utufZ2s6kvXvxv0UzfqXksHXzke2FndFesyvAGv3sS81D9JTUZowohEb+i2xVbxNILCcxiTcEDpKcutY/0MprsVj8+3m/Mh6AU0PvUApKUiesPIzl4y6Ybgazuli3tYmrn7Qi8TmU5+wOkWdLCfcpJVzwPPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707671194; c=relaxed/simple;
	bh=agbLLuXWinunZf7A63lNVCvzSH9sGZsptDOcytkuGxQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=utiHp7wA/WQ3JK3Bdqcfljar9HBttnWDscFMazmJ5chL8uIMgfeqq64esS17rUv0tQ4zAwJZ2DY1bSdnL/kJmFLiVxnnjwQ0KM4ggLxboW1WXq/AUFN7yaMCC2/RXlJAPEXjO8sduUU5gPc+V3LjWt2KKuUdi0CJWnnZJWR17JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=194.150.191.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id B39E78964C2;
	Sun, 11 Feb 2024 18:06:27 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: stable@vger.kernel.org, regressions@lists.linux.dev,
 linux-usb@vger.kernel.org,
 Holger =?ISO-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
 linux-bcachefs@vger.kernel.org
Subject: Re: I/O errors while writing to external Transcend XS-2000 4TB SSD
Date: Sun, 11 Feb 2024 18:06:27 +0100
Message-ID: <5444405.Sb9uPGUboI@lichtvoll.de>
In-Reply-To: <5264d425-fc13-6a77-2dbf-6853479051a0@applied-asynchrony.com>
References:
 <1854085.atdPhlSkOF@lichtvoll.de>
 <5264d425-fc13-6a77-2dbf-6853479051a0@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

Hi Holger!

CC'ing BCacheFS mailing list.

My original mail is here:

https://lore.kernel.org/linux-usb/5264d425-fc13-6a77-2dbf-6853479051a0@appl=
ied-asynchrony.com/T/
#m5ec9ecad1240edfbf41ad63c7aeeb6aa6ea38a5e

Holger Hoffst=E4tte - 11.02.24, 17:02:29 CET:
> On 2024-02-11 16:42, Martin Steigerwald wrote:
> > Hi!
> > I am trying to put data on an external Kingston XS-2000 4 TB SSD using
> > self-compiled Linux 6.7.4 kernel and encrypted BCacheFS. I do not
> > think BCacheFS has any part in the errors I see, but if you disagree=20
> > feel free to CC the BCacheFS mailing list as you reply.
>=20
> This is indeed a known bug with bcachefs on USB-connected devices.
> Apply the following commit:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commi
> t/fs/bcachefs?id=3D3e44f325f6f75078cdcd44cd337f517ba3650d05
>=20
> This and some other commits are already scheduled for -stable.

Thanks!

Oh my. I was aware of some bug fixes coming for stable. I briefly looked=20
through them, but now I did not make a connection.

I will wait for 6.7.5 and retry then I bet.

Best,
=2D-=20
Martin


