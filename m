Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693FF2727F9
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 Oct 2025 14:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760278222; cv=none; b=l5Lj2HGghWYKtk0UmildeDCxelscEFfOB/AotSOwYp6KXLHIk6gOU4dZMru/gjCVLitA8xthPxTNUyc3o5pdbz3EZ+UeGIzJuzVc+Yu7RAQWbZq3488Yae7ivDC3kMpmt/OL0Pt9y+bUsNg9GQYTflR17OOyKGBEL08/C5dHgK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760278222; c=relaxed/simple;
	bh=rYTCP1UzChg6PZh+5GH5Kofff7BiLew9gM/5HayvUxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FzKAzgL5TJt8NMTUK0dutqhp2F1+zp3BKwsDDz9QcLT8RXIkKUbztNUDuSexXnwzTo53luMXmlTzihYStZbhZkHttDhzBxI3IPbVe0EKprQFCMxrn6ofxKUZZVoxqQS68lHG8NDkR69zedcYkCMBSc88bV+njTbUlyDMUtLOeRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id EC4701552F3;
	Sun, 12 Oct 2025 14:01:17 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Roman Lebedev <lebedev.ri@gmail.com>
Subject:
 Debian repository: missing release channel (was: Re: bcachefs: DKMS
 availability/migration general announcement)
Date: Sun, 12 Oct 2025 16:01:16 +0200
Message-ID: <8592586.T7Z3S40VBb@laptop>
In-Reply-To: <wpunhwfhumd76tzitnd3zoxnpwq6ipxxzq7rx2igxmtpsr6jns@k3ip5mm6mxtj>
References: <wpunhwfhumd76tzitnd3zoxnpwq6ipxxzq7rx2igxmtpsr6jns@k3ip5mm6mxtj>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi Kent. Hi.

Kent Overstreet - 28.09.25, 21:01:19 CEST:
> - Debian, Ubuntu
>=20
> We're providing an external repository that has both release channels
> (note: the debian packaging refers to nightly as snapshot). A big thank
> you to Roman Lebedev who did nearly all the work here and put a ton of
> effort into making this clean and well automated.
>=20
> https://apt.bcachefs.org/

Thanks a lot for this repository! It works nicely with self-compiled 6.16=20
and 6.17.

I appears to me that the release channel "release" is gone since some=20
days:

Ign:3 https://apt.bcachefs.org/unstable bcachefs-tools-release InRelease   =
   =20
Err:4 https://apt.bcachefs.org/unstable bcachefs-tools-release Release
  404  Not Found [IP: 2a[=E2=80=A6]f3::1 443]
Error: The repository 'https://apt.bcachefs.org/unstable bcachefs-tools-
release Release' no longer has a Release file.

In https://apt.bcachefs.org/dists/unstable/dists/ I only find
bcachefs-tools-snapshot

=46or now I assume that the intention is to bring it back. Especially as th=
e=20
documentation on https://apt.bcachefs.org still refers to it.

If otherwise, please tell us what your plans are, Kent and Roman.

Thank you.

Best,
=2D-=20
Martin


