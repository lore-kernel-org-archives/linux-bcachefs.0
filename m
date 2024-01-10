Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160A04C3C0
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jan 2024 14:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6284686B77A;
	Wed, 10 Jan 2024 15:18:56 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: AP <lkml@inml.grue.cc>, Martin Steigerwald <martin@lichtvoll.de>,
 linux-bcachefs@vger.kernel.org
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Wed, 10 Jan 2024 15:18:55 +0100
Message-ID: <6010058.lOV4Wx5bFT@lichtvoll.de>
In-Reply-To: <ZZ39La7UjQVwQ1aI@inml.grue.cc>
References:
 <2312305.ElGaqSPkdT@lichtvoll.de> <1876799.tdWV9SEqCh@lichtvoll.de>
 <ZZ39La7UjQVwQ1aI@inml.grue.cc>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

AP - 10.01.24, 03:13:01 CET:
> On Sun, Jan 07, 2024 at 12:27:29PM +0100, Martin Steigerwald wrote:
> > In case this is an issue with Debian packaging of bcachefs-tools I can
> > report there.
>=20
> What version of bcachefs-tools are you using? The default one in
> bookworm is v0.24 and is >1 year old and that may be the issue.

As I wrote:

"BCacheFS tools 1.3.3 =E2=80=93 according to bcachefs version =E2=80=93 fro=
m Debian=20
package bcachefs-tools 24+really1.3.4-2.".

> I'm starting to switch from btrfs to bcachefs and I backported v1.3.4
> from sid.

That is where above package is from.

Best,
=2D-=20
Martin


