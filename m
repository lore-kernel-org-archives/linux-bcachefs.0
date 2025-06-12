Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFA22989B5
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 15:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749743494; cv=none; b=DdNv73kbUQ2TlEQwhI9y8ijo0l5Nr5fYrULWVK743nNGDUMf+DU6zrcfTJNLHFOAFiuIThevtRZGR+K9exqAzGvrGvRWHAJGnTAaV9rQXVFU3+mdQnSGGkqSAkHw/D1urdu7BcLAqj357+nd3wPR/Gqbx+Thd5HV/AupB6ps6D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749743494; c=relaxed/simple;
	bh=yosVDrQdfuor1dnWGT5FAY1zR+YXQR6fzG7w0KMdNvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SadpJCkV0tVNPP3HmBUOHAfv2v/3CnR4XwZaXHQaMe/6wEVHJJL3XFGIE7ApBrXMy8rILq0+dg4I90RQjit/w8Nhg3My4wXu/DG5qJ6O2uKur4yFg5uhv2vD/c25Dr36nfDSeIVs0+zFGhFcfztRZDYIi//VNoV26j4z2vYkWnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 2AE3F10AE3A;
	Thu, 12 Jun 2025 15:51:29 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Hongbo Li <lihongbo22@huawei.com>
Subject: Re: Size of directory entry 16 EiB according to "ls -l"
Date: Thu, 12 Jun 2025 17:51:26 +0200
Message-ID: <2788356.mvXUDI8C0e@lichtvoll.de>
In-Reply-To: <sckkunsdfsvkynpfh6rknpe3rggag6mcc5gkqypz3kvhi7x4cu@wkz2iepbn3o5>
References:
 <3009813.e9J7NaK4W3@lichtvoll.de> <3358454.aeNJFYEL58@lichtvoll.de>
 <sckkunsdfsvkynpfh6rknpe3rggag6mcc5gkqypz3kvhi7x4cu@wkz2iepbn3o5>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Kent Overstreet - 12.06.25, 17:17:22 CEST:
> On Thu, Jun 12, 2025 at 04:30:08PM +0200, Martin Steigerwald wrote:
> > Kent Overstreet - 12.06.25, 15:45:23 CEST:
> > > > I suppose I could just create a new directory and move over the
> > > > files
> > > > from the one with the odd size.
> > > >=20
> > > > However, keeping as is for now. Maybe I can help testing repair
> > > > code.
> > > > =F0=9F=99=82
> > >=20
> > > Well, I do need to work on making the rest of the fsck passes work
> > > online, maybe I'll be able to start on that soon... fingers crossed
> > > =F0=9F=99=82
> >=20
> > Would you like me to wait for that for testing?
>=20
> No, that won't be for ~months, most likely. You'll just need offline
> fsck to repair this for now.
>=20
> (check_inodes() shouldn't be too bad to make work online, I've just got
> filesystems to recover and projects to finish before I start new things)

[x] done:

bcachefs (DEV): directory 4096:4294967295 with nonzero i_size 75376, fixing
bcachefs (DEV): directory 4098:4294967295 with nonzero i_size -856, fixing
bcachefs (DEV): directory 4675:4294967295 with nonzero i_size 960, fixing
bcachefs (DEV): directory 4676:4294967295 with nonzero i_size 160, fixing
bcachefs (DEV): directory 8571:4294967295 with nonzero i_size 712, fixing

Thanks.

Sizes all zero again after mounting.

Best,
=2D-=20
Martin


