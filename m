Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165B71D0F69
	for <linux-bcachefs@vger.kernel.org>; Mon, 21 Oct 2024 07:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729495588; cv=none; b=hAGuESVTiy7kyO+spH1Af8bxQgrdlDh7Uki8ZNb9z8ko5cctlxHYYp+Ii63EbczgNoknmW3lRAwAWAWvRZEP2MgPVFce57c4vTVpqMUzLdShGZkgc0EIMH52bliZCOw2bVNdI/ASjYIOLTsXwoWvTzGwBzi1M3ZKjv+GJnu8jUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729495588; c=relaxed/simple;
	bh=NBcwKd4ZQ0SIEDIBh9XmbJtc0F5CWxGGlXYDx+R6pto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkALPE9T0kf1DOt9gi6Bn742HhQeQmpqoK5W/saIEWdoKXy4XQuUBFBLJZVhCTA4PdIByq0RVzkkm7Lu9Dza9OmZx23MxkSn5t16DClIRa6Wv5DRRwOQATGb7VV9Ffcx62IPaopn52hbNC9e2KmpOeXNMU255K35IecF9sFqwgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 732377CC9E;
	Mon, 21 Oct 2024 07:26:16 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>,
 "Carl E. Thompson" <list-bcachefs@carlthompson.net>
Cc: Christopher Snowhill <chris@kode54.net>,
 "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: Another bcachefs version downgrade bug
Date: Mon, 21 Oct 2024 09:26:16 +0200
Message-ID: <4961439.31r3eYUQgx@lichtvoll.de>
In-Reply-To: <216190573.1599.1729470893479@mail.carlthompson.net>
References:
 <xcdedhwtm4aajc4fhpb2d2urtvss7bxxzdtt2hw73hewjgr2o5@4vyurjq5v5mq>
 <kadahbpbnfzxck7a5peye2rdvoi5w5omvhcloocqr5lypxrvse@tdddqahswipx>
 <216190573.1599.1729470893479@mail.carlthompson.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi Carl, hi Kent, hi,

Carl E. Thompson - 21.10.24, 02:34:53 MESZ:
> > But you're complaining about an EOL kernel, where the issues have long
> > been fixed, so in this case there's just not a lot I can do. I could
> > ask Greg to cut a new 6.9 release, but all the distros have been told
> > that 6.9 is EOL so it's not likely it would be widely deployed.
>=20
> I am **not** complaining about an EOL kernel. I explicitly stated that I
> **didn't** need a fix. I simply reported a bug that affected me which I
> was unaware had been fixed.
>=20
> I do think that if you find and fix a bug like that it would be nice for
> you to document it and let users know about it so we can possibly avoid
> wasting a lot of our time and effort unnecessarily.

Apparently there has been quite the misunderstanding here?

Kent understood "user demands a fix in EOL kernel" and you, the user,=20
thought you said "user does not demand a fix in EOL kernel"?

If so=E2=80=A6 it might be important to understand misunderstanding each ot=
her can=20
happen, especially in written language without body language and voice=20
tonality. And that there (often or even always) is a difference between=20
what one sends out and the other one receives=E2=80=A6 and how they receive=
 it.=20
And no one is at fault about that. It is just the way we are all different,=
=20
have different internal maps of what we call reality and can understand the=
=20
very same sentence in a different way.

=2D-=20
Martin


