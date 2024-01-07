Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF91B12E45
	for <linux-bcachefs@vger.kernel.org>; Sun,  7 Jan 2024 11:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 3B8308672EC
	for <linux-bcachefs@vger.kernel.org>; Sun,  7 Jan 2024 12:27:30 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-bcachefs@vger.kernel.org
Subject:
 Re: Error while unlocking encrypted BCacheFS: Required key not available
Date: Sun, 07 Jan 2024 12:27:29 +0100
Message-ID: <1876799.tdWV9SEqCh@lichtvoll.de>
In-Reply-To: <2312305.ElGaqSPkdT@lichtvoll.de>
References: <2312305.ElGaqSPkdT@lichtvoll.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Martin Steigerwald - 07.01.24, 12:22:53 CET:
> Hi!
>=20
> Kernel 6.7.0-rc8 with BCacheFS new year fixes. Compliled with Debian gcc
> 13.2.0-9.
>=20
> BCacheFS tools 1.3.3 =E2=80=93 according to bcachefs version =E2=80=93 fr=
om Debian
> package bcachefs-tools 24+really1.3.4-2.
>=20
> Linux kernel keyutils from Debian package keyutils 1.6.3-2+b2. (Not sure
> whether really required.)
>=20
> Created BCacheFS on external 4 TB SSD:
>=20
> % mkfs.bcachefs -L [=E2=80=A6] --data_checksum xxhash --metadata_checksum=
 xxhash
> --compression=3Dlz4 --encrypted /dev/sda1
>=20
> (also tried without xxhash, no difference)
>=20
>=20
> Unlock attempt with incorrect passphrase:
>=20
> % bcachefs unlock /dev/sda1
> Enter passphrase:
> incorrect passphrase
>=20
> Unlock attempt with correct passphrase does not yield error message
> "incorrect passphrase". Key seems to be available:
>=20
> % grep bcachefs /proc/keys
> 1b9e7153 I--Q---  1 perm 3f010000  0  0 user   bcachefs:[=E2=80=A6 UUID =
=E2=80=A6]: 32

Also keyctl sees the key in root user keyring:

% keyctl list @u
1 key in keyring:
463368531: --alswrv     0     0 user: bcachefs:[=E2=80=A6 UUID =E2=80=A6]

In case this is an issue with Debian packaging of bcachefs-tools I can=20
report there.

> UUID matches filesystem.
>=20
>=20
> Still I get:
>=20
> % LANG=3Den mount /dev/sda1 /mnt/zeit
> mount: /mnt/zeit: mount(2) system call failed: Required key not
> available. dmesg(1) may have more information after failed mount system
> call.
>=20
> % dmesg | tail -1
> [105441.695035] bcachefs ([=E2=80=A6]): error requesting encryption key: =
ENOKEY
>=20
>=20
> Why? And how to fix it?
>=20
> I found
>=20
> error requesting encryption key #93
>=20
> https://github.com/koverstreet/bcachefs/issues/93
>=20
> But I am not sure whether it applies to my situation.
>=20
> I use Devuan with elogind. Do I need that pam related configuration
> change from comment
>=20
> https://github.com/koverstreet/bcachefs/issues/93#issuecomment-609430340
>=20
> ?
>=20
> I do not like to do it in case it is not required.
>=20
> Best,


=2D-=20
Martin


