Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCAAEC433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu,  2 Jun 2022 08:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiFBIpw (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 2 Jun 2022 04:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiFBIpw (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 2 Jun 2022 04:45:52 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766512A788A
        for <linux-bcachefs@vger.kernel.org>; Thu,  2 Jun 2022 01:45:51 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BA2083200912;
        Thu,  2 Jun 2022 04:45:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 02 Jun 2022 04:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1654159550; x=
        1654245950; bh=kmeKtT5ZY8wYhpfDVZmuFXJqwqKDotnhSYdFSqZR9FQ=; b=e
        BjD/UtDut9x//8PNG0qzf30EU7AhPcOoYb5RNtP3S/mtNmko06Vl77mMp3aOFnwN
        QN+8/k4xjFt7xcVPXrtFO4qTQw/HNFqavIkpqx6+qVuK4MVJlj09gsC1dFz0LGxb
        9OZG0GWVTpMzOlmaCrYUBReGDsE/FKS9Y+vly9UokPlHWSupK7cI5On2/7Y4aGHu
        Ru+5cfjoYd4We0RhpNbv1exaSHHQ9s6wd+FRBUklBtBDl9+HZH1IwX4bWgfQRAgO
        bezjFO8+PcFGu7081wYNxAvZ0hHVgpZjSCNWNLuEMGqtgVNIrvhWZDcgdLj/Qxp6
        +i+yhCocsVRqcYIMnXxMg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1654159550; x=1654245950; bh=kmeKtT5ZY8wYhpfDVZmuFXJqwqKD
        otnhSYdFSqZR9FQ=; b=nZNyErJ2lMNsw/kFJyor32mQduTfgN7MamsF9vdlb36y
        iwaD621i3AY33rnc97P8fTn5QU3ayZbqxHcnGo9+M40OQWSRRYtrgb36kCZhtvTf
        HbeJXoDsAkzf08gAFkdNSymdsCepM+2duoY934+2j6UjMIluargXXk3pty2DBZMX
        M5cBVF0lAmAjhffuGX3xTepQD8RlMfrfovHRZmViF3S7QaBDBhpkn8sFMe0Bmcf8
        ukHQcQ1h/3RooD0ddnLQGfxQAPfo1PLAZ7SJrx2C9xbkMaBnpRy87y2Mvl0vbR57
        00sye86me+giYfx4KVMhIrnAGM1M8bdbihFSVqjeKg==
X-ME-Sender: <xms:vniYYpk-iBCiDHahPD0SRYm9HChfrsvBqw4b5p8T9hgdKCrAht7igg>
    <xme:vniYYk05Qh0AZZV3DUpXrmfK-F8e-x0DVB0SEknbZokISWED0VIXaMKgGmp_1l7M-
    fzMa2gLzmYnS4A>
X-ME-Received: <xmr:vniYYvrrCYVx5tUXUtmE5I6xpxXD0Y1iVpeRgc5XUZ0N7IE__yk2LW1gY4Cg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrledvgddthecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehgtderredttddvnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeduieelfeeutedvleehueetffejgeej
    geffkeelveeuleeukeejjeduffetjeekteenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
    rggsrdgtohhm
X-ME-Proxy: <xmx:vniYYpmBlypEtcibUHmG_AaTHzAbIcO6AT9Lzo14dHiXph0KXc2SGw>
    <xmx:vniYYn1oQaQJ0diKp2Q1_k0s77b3iozPaR06k1bAhkkI21-XLzyV2w>
    <xmx:vniYYotn3O3ESMAm-4CoINjNcB5WOHW_Dvdi05BVmZGNmk26Yq2Pkw>
    <xmx:vniYYk_ORtmvPMRMi1CPe6rQY17ozQX37XPNdxMG-xm-2mbUCRkkTw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Jun 2022 04:45:49 -0400 (EDT)
Date:   Thu, 2 Jun 2022 04:45:47 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>,
        Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs loop devs
Message-ID: <Yph4vK0KAjokd1UL@itl-email>
References: <Yk05Sk4ztxLMpgrt@itl-email>
 <20220415191140.2xyni3kusht6wear@moria.home.lan>
 <1f3290c6-535a-a15f-c02f-325099ecc4e0@ewheeler.net>
 <20220419014140.5jz4hahhkfksulce@moria.home.lan>
 <51a52bd6-b535-e5ac-12a1-2f6dc1a84353@ewheeler.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lE9YSUVdLDEvASC5"
Content-Disposition: inline
In-Reply-To: <51a52bd6-b535-e5ac-12a1-2f6dc1a84353@ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


--lE9YSUVdLDEvASC5
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 2 Jun 2022 04:45:47 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Eric Wheeler <bcachefs@lists.ewheeler.net>,
	Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs loop devs

On Tue, Apr 19, 2022 at 01:42:49PM -0700, Eric Wheeler wrote:
> On Mon, 18 Apr 2022, Kent Overstreet wrote:
> > On Mon, Apr 18, 2022 at 06:16:09PM -0700, Eric Wheeler wrote:
> > > If bcachefs immediately calls .ki_complete() after queueing the IO wi=
thin=20
> > > bcachefs but before it commits to bcachefs's disk, then loop.c will m=
ark=20
> > > the IO as complete (blk_mq_complete_request via lo_rw_aio_complete) t=
oo=20
> > > soon after .write_iter is called, thus breaking the expected ordering=
 in=20
> > > the filesystem (eg, xfs) atop of the loop device.
> >=20
> > We don't call .ki_complete (in DIO mode) until the write has been compl=
ete,
> > including the btree update - this is necessary for read-after-write con=
sistency.=20
>=20
> Good, I figured it would and thought I would ask in case that was the=20
> issue. =20
> =20
> > If your description of the loopback code is correct that does sound sus=
picious
> > though - queuing every IO to work item shouldn't hurt anything from a
> > correctness POV but it definitely shouldn't be needed or wanted from a
> > performance POV.
>=20
> REQ_OP_FLUSH just calls vfs_sync (not WQ-queued) and all READ/WRITE IO's
> hit the WQ.  Parallel per-socket WQ's might help performance since block
> layer doesn't care about ordering and filesystems (or at least bcachefs!)
> call ki_complete() after the write finishes so consistency should be ok.
>=20
> Generally speaking I avoid loop devs for production systems unless
> absolutely necessary.
>=20
> > What are you seeing?
>=20
> Nothing real-world.
>=20
> I was just reviewing loop.c in preparation for leaving bcache+dm-thin
> for bcachefs+loop to see if there are any DIO issues to consider.
>=20
> IMHO, it would be neat to have native bcachefs block devices and avoid
> the weird loop.c serial WQ (and possibly other issues loop.c has to deal
> with that native bcachefs wouldn't).
>=20
> This is a possible workflow for native bcachefs devices.  Since bcachefs=
=20
> is awesome - it would provide SSD caching, snapshots, encryption, and raw=
=20
> DIO block devices into VMs:
>=20
> 	]# bcachefs subvolume create /volumes/vol1
> 	]# truncate -s 1T /volumes/vol1/data.raw
> 	]# bcachefs blkdev register /volumes/vol1/data.raw
> 	/dev/bcachefs0
> 	]# bcachefs subvolume snapshot /volumes/vol1 /volumes/2022-04-19_vol1
> 	]# bcachefs blkdev register /volumes/2022-04-19_vol1/data.raw
> 	/dev/bcachefs1
> 	]# bcachefs blkdev unregister /dev/bcachefs0
>=20
> And udev could be made to do something like this:
> 	]# ls -l /dev/bcachefs/volumes/vol1/data.raw
> 	lrwxrwxrwx 1 root root 7 Apr  9 17:35   data.raw -> /dev/bcachefs0
>=20
> Which means the VM can have a its disk defined as=20
> /dev/bcachefs/volumes/vol1/data.raw in its libvirt config, and thus point=
=20
> at a real block device!
>=20
> That would make bcachefs the most awesome disk volume manager, ever!

Kent, if you do decide to go this route, please use the disk sequence
number as the number part of the device name.  So instead of
/dev/bcachefs<minor>, it would be /dev/bcachefs<diskseq>.  The latter is
guaranteed to never be reused, while the former is not.

Yes, other block device drivers all have the same problem, but I would
rather fix it in at least one of them.  Also, this would mean that
opening /dev/bcachefs/volumes/something would be just as race-free as
opening a filesystem path, which otherwise could not be guaranteed
without some additional kernel support.

--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--lE9YSUVdLDEvASC5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmKYeLwACgkQsoi1X/+c
IsHLyRAAzIHwO5WzyKHGN8fKJ6iATx38p5zJBkDRQ9SkluOWoE18EL91i69XBSQw
5dt/kUvhIBK6QMi2TP3PoLwEvap7nL1qZfq/H5y2SXKy0dAwXSAhhfZF6i5PWA9G
0l3MbfbBfEyFRdCYYWm1bn7hR6ktW1rHZUFmnj1vdu0ono2oKvMIUBDvb9ecWRro
xWydg8prTOnLTe+kljU+x5uchod2NolFGnh2MSHwX1FBr8E2bGFj8/DQo9ZXjLiC
IJItqmC8ZK99gRW6JGDk7XUcLoiELJxdv1XZtbIJOfNp7k/i6Vt2jli9bisuK1Dh
S05OTMyQY5KmOB/5oATkBJXDi2wN7QEhozSomQatn/vhvrTGLGlhVPjztKJSFLSW
ZFSDupetUm5ydA8/AXurJqX1mywKVOZMc0rH6c5XxIM1b7a69ZkRnmUvJICGZqoW
N9ofDsPlNaHcbKZkj+k03EFqBRf0ri7M00D2MJHWi1dhfXfIG2QlB4cAkKyM4Jg6
tnn6nzL/E9FjFhPlqAs5L0BTiaJ+1QA7DfUAMAJppTaPSKpGiOV+EF1hxYMHRYoe
Ua7zq/3+iiTjUjkakef56mTOarQdlONWPkaWgjhDOe1pC5AheLxBqJk6KCCImhvP
XgPndUmFgiC3hdYdL4xiG0O0kGrpLyBeXtFGaVErgFGDvB3ePx4=
=xSyd
-----END PGP SIGNATURE-----

--lE9YSUVdLDEvASC5--
