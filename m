Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2938BC433EF
	for <linux-bcachefs@archiver.kernel.org>; Tue, 19 Apr 2022 13:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbiDSNTc (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 19 Apr 2022 09:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343858AbiDSNTb (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 19 Apr 2022 09:19:31 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802F7344DA
        for <linux-bcachefs@vger.kernel.org>; Tue, 19 Apr 2022 06:16:48 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id D57005C01C7;
        Tue, 19 Apr 2022 09:16:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 19 Apr 2022 09:16:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650374207; x=
        1650460607; bh=kF5EN5oTQzFUKNjMCq9hFhYtVzDM3QWshEZUG4jlDAc=; b=L
        4UJPZDC+xX0pYRaVaridwRFZf/DYYJa5InY7YMU7HKyhW6kFl+Qc7lbhj4fBsnqP
        V8WaNCu94CWMmB7uG44tr0iIuGmdp07rQyVQZtiPWPnDgNmwYCHqeVxYLHZYD9lM
        nwkriFZlRni65wO7VocwdmR1TPKxsf4ro3qhqQfEwP3Ve6IFFo5vkSb+1sJutgad
        h3rHy5n1R5EkOnsWIkliXmIdb2elDBtmSCg9ys/CgC0cVtetRevPeRCF7zLAStmh
        Jvl1nZdHROtHPFcMqPQ3bRutFw8Bvz/KOT52yp8IEWCgLqJgm2wDwVqxK1VXWMSY
        8DdtOdRVwFud+d7I91b4w==
X-ME-Sender: <xms:P7ZeYsepfWmZ9t5d2N2OghVlgXWII5wtLs06zcCqv32sb3mnjJVKHA>
    <xme:P7ZeYuMvdC4nuh-7extVd88PP21hBkchiE2X183Et-32egdOZW1OCRuNHoPVKcy83
    ZNjblPpnpRr6ng>
X-ME-Received: <xmr:P7ZeYtitIiGkjCETLxDDNCZ4DZLdOZ57FM556DTOrYu7RTg4S5vKQ8poP-_4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvddtfedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedugfdvtdegledvheffvdehjedvkefh
    uddvjeekhfevgedtvdevhefgtdffleeghfenucffohhmrghinhepsggtrggthhgvfhhsrd
    horhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    uggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:P7ZeYh-B9xuwjdT-0Okg-EUfBY2AFg3OhIx-XOsueOK7EPHZo1A_6Q>
    <xmx:P7ZeYouYO204qNWDA1-Sapq3hQWVKrzxhB7Xzbmlif1dS6jaalDWeQ>
    <xmx:P7ZeYoFxd7i95OzjRfRetJvtTI_n1kTXlW7eQdAIMqs87AISep3uYA>
    <xmx:P7ZeYh5cS38dRTBb6-hrTbw3lnhorGsWzrz3LKFCKBZdx_TiSuP93A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Apr 2022 09:16:47 -0400 (EDT)
Date:   Tue, 19 Apr 2022 09:16:43 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS
Message-ID: <Yl62Pe/mrvb1mzuD@itl-email>
References: <Yk05Sk4ztxLMpgrt@itl-email>
 <20220415191140.2xyni3kusht6wear@moria.home.lan>
 <Yl1wqhHUGRnPdKjx@itl-email>
 <20220419013534.fb5m6kd6f6ithcig@moria.home.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xKS9xaG5+rtKe9lm"
Content-Disposition: inline
In-Reply-To: <20220419013534.fb5m6kd6f6ithcig@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


--xKS9xaG5+rtKe9lm
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Tue, 19 Apr 2022 09:16:43 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS

On Mon, Apr 18, 2022 at 09:35:34PM -0400, Kent Overstreet wrote:
> On Mon, Apr 18, 2022 at 10:07:38AM -0400, Demi Marie Obenour wrote:
> > On Fri, Apr 15, 2022 at 03:11:40PM -0400, Kent Overstreet wrote:
> > > On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> > > > How does bcachefs manage to outperform ZFS and BTRFS?  Obviously be=
ing
> > > > licensed under GPL-compatible terms is an advantage for inclusion in
> > > > Linux, but I am more interested in the technical aspects.
> > > >=20
> > > > - How does bcachefs avoid the nasty performance pitfalls that plague
> > > >   BTRFS?  Are VM disks and databases on bcachefs fast?
> > >=20
> > > Clean modular design (the result of years of slow incremental work), =
and a
> > > _blazingly_ fast B+ tree implementation.
> > >=20
> > > We're not fast in every situation yet. We don't have a nocow (non cop=
y-on-write)
> > > mode, and slow random reads can be slow due to checksum granularity b=
eing at the
> > > extent level (which is a good tradeoff in most situations, but we nee=
d an option
> > > for smaller checksum granularity at some point).
> >=20
> > How well does bcachefs handle writes to files that have extents shared
> > (via reflinks or snapshots) with other files?  I would like to use
> > bcachefs in Qubes OS once it reaches mainline, and in Qubes OS, each VM
> > disk image is typically a snapshot of the previous revision.  Therefore,
> > each write breaks sharing.  I am curious how well bcachefs handles this
> > situation; I know that at least dm-thin is not optimized for it.  Also,
> > for a file of size N, are reflinks O(N), or are they O(log N) or better?
>=20
> O(N), but they're also cheap to overwrite.

That=E2=80=99s understandable, if somewhat unfortunate.  If the constant fa=
ctor
is small enough it should not be too big of a problem in practice,
unless the files are huge.  Qubes OS also has an optimization that
allows the reflinks to be created in the background, rather than when
users are waiting on them.  Are there optimizations for
already-reflinked files?  Or are subvolumes better for this use-case?

> > How much of a performance hit can one expect from erasure coding,
> > compared to mirroring?
>=20
> Should be very little, but it's not yet stable enough for real world perf=
ormance
> testing.

Thanks!

> > Is there something lower-level available?  For instance, where should
> > one look if they want to add (read-only) bcachefs support to GRUB?
>=20
> The sanest thing to do would be to port bcachefs to grub - you can't read
> anything without reading the journal and overlaying that over the btree, =
if
> you're not doing journal replay, so that's a lot of code that you really =
don't
> want to rewrite - and just reading from btree nodes is non trivial. Bcach=
efs has
> been ported to userspace already, so it'd be a big undertaking but not cr=
azy.

That makes sense.  grub has a policy of never mutating anything except a
tiny environment block, but that is equivalent to =E2=80=98-o nochanges=E2=
=80=99.

> > Also, is it possible to mount a bcachefs filesystem off of a truly
> > immutable volume?
>=20
> Yes.

Thanks.  I was worried that this was not possible without replaying the
journal.  I should have read the manual first :).

> > > > - Can bcachefs use faster storage as a cache for slower storage, or
> > > >   otherwise move data around based on usage patterns?
> > >=20
> > > Yes.
> >=20
> > I am not surprised, considering that bcachefs is based on bcache.  Is
> > there any manual configuration required, or can bcachefs detect fast and
> > slow storage automatically?  Also, does the data remain on the slow
> > storage, or can bcachefs move frequently-used data entirely off of slow
> > storage to make room for infrequently used data?
>=20
> You should be reading the manual for these kinds of questions:
> https://bcachefs.org/bcachefs-principles-of-operation.pdf

Indeed I should, sorry!

> Long story short, you tell the IO path where to put things and it can be
> configured filesystem wide, or per file/directory.

Nice!  I was especially impressed by this: =E2=80=9CDevices need not have t=
he
same performance characteristics: we track device IO latency and direct
reads to the device that is currently fastest.=E2=80=9D  That adaptive beha=
vior
is something I would have expected from a high-end storage array.
Having it in an open source filesystem will be amazing.

> > > > - Can bcachefs saturate your typical NVMe drive on realistic worklo=
ads?
> > > >   Can it do so with encryption enabled?
> > >=20
> > > This sounds like a question for someone interested in benchmarking :)
> >=20
> > I would love to benchmark, but right now I don=E2=80=99t have any machi=
nes on
> > which I am willing to install a bespoke kernel build.  I might be able
> > to try bcachefs in a VM, though.  I=E2=80=99m also no expert in storage
> > benchmarking.
> >=20
> > > > - Is support for swap files on bcachefs planned?  That would require
> > > >   being able to perform O_DIRECT asynchronous writes without any me=
mory
> > > >   allocations.
> > >=20
> > > Yes it's planned, the IO path already has the necessary support
> >=20
> > That is awesome!  Will it require disabling CoW or checksums, or will it
> > work even with CoW and checksums enabled and without risking deadlocks?
>=20
> Normal IO path, so CoW and checksums and encryption and all.

That is incredible.

> > > > - Is bcachefs being used in production anywhere?
> > >=20
> > > Yes
> >=20
> > Are there any places that are willing to talk about their use of
> > bcachefs?  Is bcachefs basically the WireGuard of filesystems?
> >=20
> > A few other questions:
> >=20
> > 1. What would it take for bcachefs to be buildable as a loadable kernel
> >    module?  That would be much more convienient than building a kernel,
> >    and might allow bcachefs to be packaged in distributions.
>=20
> Not gonna happen. When I'm ready for more users I'll focus on upstreaming=
 it,
> right now I've still got bugs to fix :)

And I am glad that is your priority :).  A stable, high-quality
filesystem is worth the wait.

> > 2. Would it be possible to digitally sign releases?  The means to sign
> >    them is not particularly relevant, so long as it is secure.  OpenPGP,
> >    signify, minisign, and ssh-keygen -Y are all fine.
> >=20
> > 3. Are there plans to add longer, random nonces to the encryption
> >    implementation?  One long-term goal of Qubes OS is untrusted storage
> >    domains, and that requires that encrypted bcachefs be safe against a
> >    malicious block device.  A simple way to implement this is to use a
> >    192-bit random nonce stored along each 128-bit authentication tag,
> >    and use XChaCha20-Poly1305 as the cipher.  A 192-bit nonce is long
> >    enough that one can safely pick a random number at each boot, and
> >    then increment it for each encryption.  This also requires that any
> >    data read from disk that has not been authenticated be treated as
> >    untrusted.
>=20
> Nonces are stored with pointers, not with the data they protect, so this =
isn't
> necessary for what you're talking about - nonces are themselves encrypted=
 and
> authenticated, with a chain of trust up to the superblock, or journal aft=
er an
> unclean shutdown.

The problem with this approach is a whole-volume replay attack.  It=E2=80=
=99s
easy for a malicious storage device to roll back the entire volume, but
keep a snapshot for future use.  The next time the volume is mounted,
bcachefs might reuse the same nonces, but with different data.  Disaster
ensues.  Adding randomness is necessary to prevent this, and the
approach I recommended is the simplest one I am aware of.  In
cryptography, simpler is generally better.  I see that a =E2=80=98wide_macs=
=E2=80=99
option is available; could this be an extension of that?

> However, the superblock isn't currently authenticated - that would be nic=
e to
> fix.

It would be indeed; I will file an issue for that if none has already
been filed.  How is the journal handled?  For instance, could each
journal entry have a MAC or hash of the previous one, with the
superblock having a MAC or hash of the most recent journal entry as well
as a pointer to the first one?

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--xKS9xaG5+rtKe9lm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJetj4ACgkQsoi1X/+c
IsGqcRAAgAPdi2h+2rKihTGCU+Y0L6PgRP6T8KKqZAnhkNjeW+sJzFkrOVgryhhw
uKz6UYNApwfPfCdQW/TGAWCbGuBLPklsdWpo1DdACmXu3/ZTtC6jQDiuaOWfNnBV
udgPSSUksXofiTisBGHQEhaYApswxRjxTwkLWJ6m8yfWuD7AC9ZPIjbWMgZg0are
NxvLU4A7RBOHenKSRooFL6VcB6F11qQN7FQ3s8c1ulm4F4wxFFOCoLofWE7ugLUV
m7TM6ZbE3YsI1x5n3OHByZqW0T8KMdzlaeGGo60POsS0VMFC5IEllX9HPSxpgWCr
x8RgCz1cFNR69DvOLzoRZXYF0XyM62t0oYAF8omP+Yh9sO2Y5q7cJKZmFuNjk8oF
UHxP6AJChsmrP91lHBe/k68BX4TPTMR+qoXa5JyJrUgYOog4N0VODzJwcYiJFcOk
b3W7HfNrUJLWfWm7ypUgdC25wHMvVcCOVFSp/e2evbeGpaVI4xz1nAbEjiJed2aa
DznDvIu9g85IljhlCt4LH+ZVLXSug9P9Sl5SMLAvrqhHIUyAkCEo3/Myh+ZcztIT
egzN/xE5HQhsaoZfzEddEoRhZrqFma6Fv0h8mjMsz4v7xkYMy4pcDCwBdh3/W3Hz
fdHiYUbUx+qHOX5pKBBHd48yWW9a0QlbnKnfx5TutRa0T4PYTec=
=dQCU
-----END PGP SIGNATURE-----

--xKS9xaG5+rtKe9lm--
