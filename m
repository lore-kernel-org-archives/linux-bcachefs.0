Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C8E163
	for <linux-bcachefs@vger.kernel.org>; Wed,  7 Aug 2024 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723057469; cv=none; b=rsiv9bcDLoFOKmItpSTvtjpIJwRNFU+M2USyMmn6lVEYlK3/4C22ZLN+8W0hLxNojRIdE98FQU/751lNIXFBWh+ZgSwpgJRYm3tE2Soy0CPRMbBjFHrC5IVhdJ3lCngFG0qznJgHHmQ7yMmW9pM9v50TdfmoZxN5CXYMX99RRs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723057469; c=relaxed/simple;
	bh=6wj6O142bWklA+dGLeqQbdplxg8n7BrgMVGW9WzXsHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J6rdX2tsmdj3olQBu/t13WxENt+uS7g556ZiSrRPcdksz4jR1Wkyksx123lJApw0BvrePC4DaG5t0PsQx7kZS3jBuSocHRPJ7Amic958RsAfrDOnJSi1gQ/v0zU/Lh19+FxUjBuMIkZvYkqY4EWL2CAA8DGuoIDODN4A76s7Lmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id A3AC4510B1;
	Wed, 07 Aug 2024 18:58:24 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Eli Schwartz <eschwartz@gentoo.org>,
 "Carl E. Thompson" <cet@carlthompson.net>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: PSA: Avoid Debian Stable
Date: Wed, 07 Aug 2024 20:58:23 +0200
Message-ID: <4609869.LvFx2qVVIh@lichtvoll.de>
In-Reply-To: <41409810.56.1723052597872@mail.carlthompson.net>
References:
 <36xhap5tafvm4boiy3acu5kxlhkvnp32wp3oknbfbkxbdkeq7r@galecvidi3bn>
 <wona7sjqodu7jgchtx2lpwqlmsrtbkdhk2gv6df2qdnx3vt7tc@twfs326tgt4r>
 <41409810.56.1723052597872@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

I amended the subject line a bit. I am not sure whether Debian Testing or=20
Debian Unstable should also be avoided.

And by the way, you probably have the same issue with Ubuntu, unless they=20
update bcachefs-tools to new versions in stable releases.

Carl E. Thompson - 07.08.24, 19:43:17 CEST:
> Whether or not the concept of Debian is a good idea probably isn't a
> constructive discussion for this list.
>=20
> The problem here is that what was essentially an _alpha_ piece of
> software for what at the time was essentially an _alpha_ filesystem was
> allowed into the _stable_ release of Debian at all. Whoever on the
> Debian side allowed its inclusion dropped the ball.

An option would be to at least ask for a backport.

Whether that is feasible with system based Rust packages in Debian 12 aka=20
Bookworm is another story. Or probably there might also be a way to ask=20
for removal of the outdated bcachefs-tools package. I agree it has been=20
too early to include it in Debian 12. There are users who expect 1. stable=
=20
and 2. most current software. I.e. expect they could use up-to-date=20
BCacheFS in Debian 12. But the development process of Debian does not=20
really cater for that. Either you have quite recent software, but face=20
temporary instabilities or you have stable and soon to be outdated=20
software.

One idea to use system based packages is to fix security issues once,=20
instead of recompiling a lot of packages that use their own version of=20
some Rust dependency.

=46or Debian 13 I expect BCacheFS tools to be stable enough for inclusion=20
into stable release. However=E2=80=A6 that would still not solve the issue =
with=20
fixing bugs in there during stable support =E2=80=93 unless there would be =
some=20
kind of LTS branch of BCacheFS tools by then. Critical fixes probably could=
=20
be backported, that is the usual approach for Debian packages in stable,=20
but this also does not work with Firefox ESR after a certain point. They=20
update it to the newest ESR once the support for the old one is dropped by=
=20
Mozilla. Cause it would be too much work to backport all security fixes.

Best would probably be to have a bcachefs-tools backport even for Debian=20
13. If possible.

Best,
=2D-=20
Martin


