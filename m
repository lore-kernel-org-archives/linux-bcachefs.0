Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D90B156C1
	for <linux-bcachefs@vger.kernel.org>; Thu, 11 Jan 2024 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id C0C5186C3E0;
	Thu, 11 Jan 2024 12:58:27 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: AP <lkml@inml.grue.cc>, linux-bcachefs@vger.kernel.org
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Thu, 11 Jan 2024 12:58:26 +0100
Message-ID: <12360099.O9o76ZdvQC@lichtvoll.de>
In-Reply-To: <4msliytwmws5zsxv2zbczxoce26bgxrmccpjphfvimcicwfipq@7hwgt4qvhozv>
References:
 <2312305.ElGaqSPkdT@lichtvoll.de> <6010058.lOV4Wx5bFT@lichtvoll.de>
 <4msliytwmws5zsxv2zbczxoce26bgxrmccpjphfvimcicwfipq@7hwgt4qvhozv>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Hi!

Kent Overstreet - 10.01.24, 20:13:59 CET:
> On Wed, Jan 10, 2024 at 03:18:55PM +0100, Martin Steigerwald wrote:
> > AP - 10.01.24, 03:13:01 CET:
> > > On Sun, Jan 07, 2024 at 12:27:29PM +0100, Martin Steigerwald wrote:
> > > > In case this is an issue with Debian packaging of bcachefs-tools I
> > > > can
> > > > report there.
> > >=20
> > > What version of bcachefs-tools are you using? The default one in
> > > bookworm is v0.24 and is >1 year old and that may be the issue.
> >=20
> > As I wrote:
> >=20
> > "BCacheFS tools 1.3.3 =E2=80=93 according to bcachefs version =E2=80=93=
 from Debian
> > package bcachefs-tools 24+really1.3.4-2.".
> >=20
> > > I'm starting to switch from btrfs to bcachefs and I backported
> > > v1.3.4
> > > from sid.
> >=20
> > That is where above package is from.
>=20
> The keyring stuff has been a perpetual utter headache.
>=20
> I've been debating rewriting that stuff to just pass a memfd handle as a
> mount option and rip out keyring usage...
>=20
> alternately - now that we're pretty much always mounting via the mount
> helper, perhaps it would be a little bit less fragile if the mount
> helper was adding the key to the keyring - that might be worth checking.

So no suggestion what to try to make it work except for putting BCacheFS=20
unto LUKS? I wanted to get rid of LUKS for removable media. Often enough I=
=20
have "cryptsetup luksClose" complaining about still in use while I the=20
filesystem on top of it clearly got unmounted already. In these case BTRFS=
=20
still.

Ciao,
=2D-=20
Martin


