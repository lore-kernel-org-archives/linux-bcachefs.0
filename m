Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from mail.lichtvoll.de (luna.lichtvoll.de [194.150.191.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C3B136
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Nov 2023 09:34:35 -0800 (PST)
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 07325818CB1;
	Mon, 20 Nov 2023 18:34:33 +0100 (CET)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Questions related to BCacheFS
Date: Mon, 20 Nov 2023 18:34:33 +0100
Message-ID: <3539807.iIbC2pHGDl@lichtvoll.de>
In-Reply-To: <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
References:
 <23311511.6Emhk5qWAg@lichtvoll.de> <2273246.iZASKD2KPV@lichtvoll.de>
 <20231119231001.tb3teva5j4azqp7i@moria.home.lan>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"

Kent Overstreet - 20.11.23, 00:10:01 CET:
> Maybe I need to continue testing BCacheFS on a virtual machine, but I'd
>=20
> > really love to have a BCacheFS filesystem on my laptop and actually
> > really using it for something. Well I am going to leave it at that
> > and probably research on this after the weekend. Now it is time to
> > have a Sunday off.
> The Nixos install process with bcachefs as root is pretty smooth, just
> make sure to set up a separate filesystem for /boot!

Thanks for that idea.

While it might have been that those BTRFS filesystems that got corrupted=20
where corrupted by an "thou shalt not resume from this hibernation image"=20
I will indeed wait before I try 5.7 kernel again on this laptop. Also I=20
will likely wait for an update bcachefs-tools package. I still don't know=20
why GRUB greeted me with a command prompt after having removed 5.7 kernel=20
again. My current idea on why the BTRFS corruption happened is cause of=20
kernel 6.6.1 resuming from hibernation after I fixed up the boot loader in=
=20
two GRML sessions, accessing / and /boot, but not doing anything to=20
invalidate the hibernation image on the swap volume. Reminder to self:=20
Absolutely do that next time!

I had to restore / and /home BTRFS filesystem as well as /boot, which got=20
GRUB broken once more:

xfsprogs-6.5.0 with grub 2.12~rc1-12: unknown filesystem

https://lore.kernel.org/linux-xfs/1889442.tdWV9SEqCh@lichtvoll.de/T/#t

So yes I am very well aware of the advantages of a separate /boot. But=20
even with that GRUB was funny on me. Maybe that is why I have seen Ext4 in=
=20
Ext3 mode for /boot. It does not gain new features.

I may investigate an alternative boot loader=E2=80=A6 it is not the first t=
ime GRUB=20
broke on new filesystem features and it is not even surprising. It would be=
=20
best to have GRUB use a very simple file system that does not gain new=20
features. A bootfs filesystem just for the purposes of a boot loader to=20
store a few files and be done with it.

Anyway, it will be a VM for now.

Ciao,
=2D-=20
Martin


