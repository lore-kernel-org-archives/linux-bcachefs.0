Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ED00C433EF
	for <linux-bcachefs@archiver.kernel.org>; Mon, 18 Apr 2022 15:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243986AbiDRPMS (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 18 Apr 2022 11:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344767AbiDRPMM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 18 Apr 2022 11:12:12 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E1F36160
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Apr 2022 07:07:43 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 05F6F5C014D;
        Mon, 18 Apr 2022 10:07:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 18 Apr 2022 10:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1650290861; x=1650377261; bh=4DTbPMt4g07Kl
        m1V11HR6BXMFX35F5vT+GhF47JMQuY=; b=IFLQOwksfgzEayp1bXa5D3Pgw7g1s
        cXmabL7elkLCuuPcNhFyi+0zCd17TSxmG9HRAMVDtUrpoRsP1rtdYF90G0lJODPv
        Lo8S3WwUxmvlyIZIjwoaawwoYqfxC6g3J/2ucw5djzRlc1WFBIC1GBNg4lQ62MAO
        tBx/N/pNeJLsNlH9zT+6KL0n97DRuHN5PAGEz+Yp1b/K6mD5HrX+Z/t5QCKFPGv+
        Q6mEM0NVXXPMgxGSEagUkqkO/h5Jt+hlEbrGuJyHNp+4/vdw6Js/S5OKnFoqwEE8
        /h5DkkBqwxAtxS16XTXFN46JxHl3Uxyn73VAuIyGf3KRhPgr6gzvI6pBw==
X-ME-Sender: <xms:rHBdYu7nOXiBff7Fl9TCThq4xCzMpUGNOsfsKCPkPVlFw__1LDHmtA>
    <xme:rHBdYn6wZbKlVaWe6IhWKCSt0UFyLvujiLPkhcOAg_KMPyCz4-vcXhbb8d6JOUlCz
    -7I8knXlnjfvk4>
X-ME-Received: <xmr:rHBdYtexZUFIioXUplAho6YgqvvGUEipcyjdPGVBXMvz5BS_CuwjB0smWvYl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvddtuddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtgfgjsehtkeertddttdejnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeevgfduueelvefhgfdthefgieeltdef
    udeviefgffduffegheeujedvvdeuhfeuleenucffohhmrghinhepsggtrggthhgvfhhsrd
    horhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    uggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:rHBdYrJOK9-Cg7Jfk013NjcCUOkJJl6j5A7i8QWYXtT7CXZy9jkTQQ>
    <xmx:rHBdYiIygBIzThdtKbBZBztH0PzQ0i8dk3_lHPaklG9dT8wCc0gbVg>
    <xmx:rHBdYsyA3kH8gF5ToKeySp_vQrU0st6VMLHZFGFr2dRzVe6Z4WAYBQ>
    <xmx:rXBdYhk1tFtEqvvv3FZA5_gVMrH13Wq2YgzqSaHdx56urClS9ojPpA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Apr 2022 10:07:40 -0400 (EDT)
Date:   Mon, 18 Apr 2022 10:07:38 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: Comparison to ZFS and BTRFS
Message-ID: <Yl1wqhHUGRnPdKjx@itl-email>
References: <Yk05Sk4ztxLMpgrt@itl-email>
 <20220415191140.2xyni3kusht6wear@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; x-action=pgp-signed
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220415191140.2xyni3kusht6wear@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On Fri, Apr 15, 2022 at 03:11:40PM -0400, Kent Overstreet wrote:
> On Wed, Apr 06, 2022 at 02:55:04AM -0400, Demi Marie Obenour wrote:
> > How does bcachefs manage to outperform ZFS and BTRFS?  Obviously being
> > licensed under GPL-compatible terms is an advantage for inclusion in
> > Linux, but I am more interested in the technical aspects.
> > 
> > - How does bcachefs avoid the nasty performance pitfalls that plague
> >   BTRFS?  Are VM disks and databases on bcachefs fast?
> 
> Clean modular design (the result of years of slow incremental work), and a
> _blazingly_ fast B+ tree implementation.
> 
> We're not fast in every situation yet. We don't have a nocow (non copy-on-write)
> mode, and slow random reads can be slow due to checksum granularity being at the
> extent level (which is a good tradeoff in most situations, but we need an option
> for smaller checksum granularity at some point).

How well does bcachefs handle writes to files that have extents shared
(via reflinks or snapshots) with other files?  I would like to use
bcachefs in Qubes OS once it reaches mainline, and in Qubes OS, each VM
disk image is typically a snapshot of the previous revision.  Therefore,
each write breaks sharing.  I am curious how well bcachefs handles this
situation; I know that at least dm-thin is not optimized for it.  Also,
for a file of size N, are reflinks O(N), or are they O(log N) or better?

> > - How does bcachefs avoid the dreaded RAID write hole? 
> 
> We're copy on write - and this extends to our erasure coding implementation, we
> don't update existing stripes in place - we create new stripes as needed,
> reusing buckets from existing stripes that still have data.

How much of a performance hit can one expect from erasure coding,
compared to mirroring?

> > - Is there a good description of the bcachefs on-disk format anywhere?
> 
> Try this: https://bcachefs.org/Architecture/

Is there something lower-level available?  For instance, where should
one look if they want to add (read-only) bcachefs support to GRUB?
Also, is it possible to mount a bcachefs filesystem off of a truly
immutable volume?

> > - What are the internal abstraction layers used in bcachefs?  Is it a
> >   key-value store with a filesystem on top of it, the way ZFS is?
> 
> It's just a key value store with a filesystem on top, moreso than the way ZFS
> is, from what I understand of ZFS.
> 
> > - Is it possible to shrink a bcachefs filesystem?
> 
> Not yet, but it won't take much work to add

That would be fantastic for desktop use.  Desktop users need to do all
sorts of wild things that are basically never needed in servers.

> > Does bcachefs have
> >   any restrictions regarding the size of disks in a pool, or can I just
> >   throw a bunch of varying-size disks at bcachefs and have it spread the
> >   data around automatically to provide the level of redundancy I want?
> 
> No restrictions, the allocator stripes across available devices but biases in
> favor of devices with more free space.

That is awesome!  Is there a way to ask bcachefs to explicitly
redistribute the data, and let me know when it has finished?

> > - Can bcachefs use faster storage as a cache for slower storage, or
> >   otherwise move data around based on usage patterns?
> 
> Yes.

I am not surprised, considering that bcachefs is based on bcache.  Is
there any manual configuration required, or can bcachefs detect fast and
slow storage automatically?  Also, does the data remain on the slow
storage, or can bcachefs move frequently-used data entirely off of slow
storage to make room for infrequently used data?

> > - Can bcachefs saturate your typical NVMe drive on realistic workloads?
> >   Can it do so with encryption enabled?
> 
> This sounds like a question for someone interested in benchmarking :)

I would love to benchmark, but right now I don’t have any machines on
which I am willing to install a bespoke kernel build.  I might be able
to try bcachefs in a VM, though.  I’m also no expert in storage
benchmarking.

> > - Is support for swap files on bcachefs planned?  That would require
> >   being able to perform O_DIRECT asynchronous writes without any memory
> >   allocations.
> 
> Yes it's planned, the IO path already has the necessary support

That is awesome!  Will it require disabling CoW or checksums, or will it
work even with CoW and checksums enabled and without risking deadlocks?

> > - Is bcachefs being used in production anywhere?
> 
> Yes

Are there any places that are willing to talk about their use of
bcachefs?  Is bcachefs basically the WireGuard of filesystems?

A few other questions:

1. What would it take for bcachefs to be buildable as a loadable kernel
   module?  That would be much more convienient than building a kernel,
   and might allow bcachefs to be packaged in distributions.

2. Would it be possible to digitally sign releases?  The means to sign
   them is not particularly relevant, so long as it is secure.  OpenPGP,
   signify, minisign, and ssh-keygen -Y are all fine.

3. Are there plans to add longer, random nonces to the encryption
   implementation?  One long-term goal of Qubes OS is untrusted storage
   domains, and that requires that encrypted bcachefs be safe against a
   malicious block device.  A simple way to implement this is to use a
   192-bit random nonce stored along each 128-bit authentication tag,
   and use XChaCha20-Poly1305 as the cipher.  A 192-bit nonce is long
   enough that one can safely pick a random number at each boot, and
   then increment it for each encryption.  This also requires that any
   data read from disk that has not been authenticated be treated as
   untrusted.

I hope I have not taken too much of your time, Kent!  Thanks for the
quick responses!

- -- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJdcKsACgkQsoi1X/+c
IsFTwxAA0vWkEH90QkcC/J1TWnIf0sXdXAsZZik4tOI50Oddl8GR9L1knog5Y4vv
H4M+3YQBmMbtdt3T+HXAruhV2vHzSIcwdjx7qB2Kw3sKggTgfHByUrr78+LYKx2B
VZXd0vHslzg7NmSmSKjzeVBV/AeXkxIuHfThC+g2neeXOgzfcWW+AlFyOwvC1JcX
V/uHGeK+NakoIKx66Kz7hMFKNrxeuMCuFe3xLeDi/9jtfnMVuz1JuHDyLS5RnluP
IzLwdGCBlhdGF6NCzZIA75tsstvq8RIaFM/ctfH50PO+utoImwe1Yenaysp6fd2t
ESnb32IbA7KZU1fGVJrapS/Cx/TrTPI+Ql+LGDQobYMq/gw+kAhiNnMREMww7yyy
PdO2HaeqrIxRDrqcuLKIlLetGbUrYqQ3Zm7hSjpFoqIGrN6v7KhRLBq3Oh6LMaCC
UqIU4TQ1bnrmu+7inip5E6ts+XYTGTCeLbAmQPcp1yWZTNH/AdJbJqs4DT50tfe3
nvLW74vd2qiIh3vkxIpgLWYK0oMg87RY05kJkv+R6Y7iSI0ka60kodF8+OjVFiRC
+F+GsR6brZddmwBxf+Hcb7m1nqcp8ZPfiPL+/0NnYBlaGEghUyCcMAGh5LEOEttS
lmh+fTOEpbvj4NafS+6k/v5DSFOPUOx0z76uCVgwVBFI6VfbEjY=
=FX/G
-----END PGP SIGNATURE-----
