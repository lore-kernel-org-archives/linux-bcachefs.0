Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE608433BC
	for <linux-bcachefs@vger.kernel.org>; Tue,  3 Sep 2024 21:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725399812; cv=none; b=dkHGirhpPjj2ypPQxQwxgfMWcV+sDBT/6T7Mv6IQv8ylajhWK+gXtcLsGRqTkjujMzbudW+j/iMMzcyYHknTj5h1P7NQ4+JpEoCI9xTlc0v0x5Biyk4wKBRYSGyVoeDZP+AY7ke3eZ8lKVJcop7O3O4Jb+ozC1qIuPhlH2N/nxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725399812; c=relaxed/simple;
	bh=nKhlaHlVZc5ihigHKfJXfOH3mhJJs7wZ4FKT/Lm95Xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFoPOliBIV3y3fIVRKMgNNAk8YtuEq2qJwhaVrDTSu68PSCgAiQr+yQKe0a7lSF2sZW3Y+4VFjXrEGtVk+SrL7Woe7UIUrRKs11MjTFlghu8vmZLyNOpOoy2ia2Z3vchXlvtEnA8rQM+TTbtdIdB8sZeDtNbxDMBEizohjZ/J28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 7D63D61851;
	Tue, 03 Sep 2024 21:37:32 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Eli Schwartz <eschwartz@gentoo.org>,
 "Carl E. Thompson" <cet@carlthompson.net>, linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Date: Tue, 03 Sep 2024 23:37:32 +0200
Message-ID: <2197543.irdbgypaU6@lichtvoll.de>
In-Reply-To: <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
References:
 <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <4609869.LvFx2qVVIh@lichtvoll.de>
 <sdmildnu2r55ale4pi4qywu2fjgd323izex6lxmkzde34dixsb@cuzsmplhlek7>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Kent Overstreet - 07.08.24, 21:55:09 CEST:
> On Wed, Aug 07, 2024 at 08:58:23PM GMT, Martin Steigerwald wrote:
> > I amended the subject line a bit. I am not sure whether Debian Testing
> > or Debian Unstable should also be avoided.
>=20
> Unstable as well - unstable is stuck at 1.9.1 and tools is up to 1.9.4,
> and it's their policy of switching rust dependencies to distro packages
> that broke the build.

Experimental meanwhile has 1.9.4.

But I do find this quite sad and concerning:

https://jonathancarter.org/2024/08/29/orphaning-bcachefs-tools-in-debian/

I do not completely agree with removing it from Debian Unstable aka Sid at=
=20
this time, but if upstream development continues like this until too short=
=20
before Debian 13 aka Trixie release I can somewhat understand. However it=20
would still be good to have it there for people who use Debian Sid to=20
test.

I more and more come to the conclusion myself that BCacheFS might be just=20
a tad bit too much of a moving target for me at the moment.

BTRFS can be used just fine in Debian Stable meanwhile. But it took quite a=
=20
while to get there. Version of btrfs-progs in Unstable is available as a=20
backport for Debian stable. As far as I understand this cannot be done=20
with BCacheFS tools without putting all the dependencies as is into the=20
package and violating the principle to package a library dependency in one=
=20
place and be able to update it for security updates in one place for all=20
the applications and tools depending on it to benefit from them in one go.

I hope that at one point it can be like this for BCacheFS as well. And I=20
am fine with this point being several years away.

Of course distributions with relaxed policies may not have a problem with=20
packaging all the dependencies within a bcache-tools package. But this is=20
not Debian or Ubuntu=E2=80=A6 or quite a lot of derivatives. I bet this is =
also=20
not RHEL or SLES and derivatives of those.

=2D-=20
Martin


