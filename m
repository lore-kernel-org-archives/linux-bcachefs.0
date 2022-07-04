Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B911C43334
	for <linux-bcachefs@archiver.kernel.org>; Mon,  4 Jul 2022 16:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiGDQGq (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Mon, 4 Jul 2022 12:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiGDQGp (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Mon, 4 Jul 2022 12:06:45 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D11E09C
        for <linux-bcachefs@vger.kernel.org>; Mon,  4 Jul 2022 09:06:44 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 96B4F3200392;
        Mon,  4 Jul 2022 12:06:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 04 Jul 2022 12:06:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1656950801; x=
        1657037201; bh=t8fdOfOXPleXTA+HbmtNq23GcP+AiSAwXuPKJgrK1Zw=; b=g
        5idsPRFvFiluyZOovA8GapyHimAJ/gPKSMUevSddCYZDJSDAg6JXdBMZjRKa5wS/
        y6hP7jPhYJXipnvRMB89WGr54vG6KZtId8/KgnI+noXqEfvJYeCC65iqHP2Eb7le
        hquf7vCCn1HcFZBdL+JO7rlozKjUnfjDasPhTDazKst+HQDSblracHI0BYKha6Tb
        p8S632NOEFva6ftSlj6R5uTZO9iMHIjMcoWdCRKUFXQeeKu2c+akS2SuKPkW3/y5
        bkEn7ykXgI4Uzmm9ldjGZCFIfvJFAXU0t73vRU6w7zLYJfiABSh48RnG8GluvYca
        TwkOCrf18apsqFM/b0sTg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656950801; x=1657037201; bh=t8fdOfOXPleXTA+HbmtNq23GcP+A
        iSAwXuPKJgrK1Zw=; b=GYKAMyTHnZPyxeeh5h7F2crA0mITMNMzU+zLuuHT/e0G
        G60vqaPX91Zn41hfsLnvrscqArXEXp34iVIdxKUaKOkPNGWgEkqS39p9aNwmucYy
        ozDgDlpF2mC6dQ5L7BFFKA0CwM9qjWUAYPXR0v2dPhSHqKV9xd01f37L5RkeIENr
        znoUpTUb7QpTaBzxp8kS1ba1Kje9ZhU97YGHsAFMOWfnehPiQkJFb6hue8rf6VsA
        GsEGCzCrW93d27isaxr0d6L3j5YPBg/d1hI9897KHdBjjdCAdeOplQTkSIKovSj6
        h1h1s1SF3c3wS0PccHtdQ1xpae6+5P3vLMRab4lgUQ==
X-ME-Sender: <xms:ERDDYhr4jEqKCZYB8EvpXkAu7e2t_V5j1GYGzDmra0gwYi18ExlOgw>
    <xme:ERDDYjob2_ACIhWZzi28TY9_Z-lCoLP7XmMopFYHuP8OAKyRRriDcep97yUfbIqyo
    0PfpIPsvgsnPVM>
X-ME-Received: <xmr:ERDDYuMLmcSrJExTxobmhztDzsDH-qQn1p64HNTeG-rCyya2vr2-xxO2IWtk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehledgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehgtderredttdejnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpedttedtueeivdefiedugfejtdeutdel
    fedvueekledtudegjedviedukeefhfeuteenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhl
    rggsrdgtohhm
X-ME-Proxy: <xmx:ERDDYs5t_0mkP5RzZKm-SHJRDBatNxlgq9MyF4_POkQETnffIO_ohw>
    <xmx:ERDDYg6ZlBglCOvdhGJXKK8EMaH6rGJh8dShsRCaUIsaiJVkwMeiUA>
    <xmx:ERDDYkhblra9KQrSANgECcZVZYr_EdzB2HA3rmjmJXV21FRVE8Ejqw>
    <xmx:ERDDYlW7TYdMjS7X--yynhv9XMedcwVz0TCqRSn_3rX7aw0W39LVnQ>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 12:06:40 -0400 (EDT)
Date:   Mon, 4 Jul 2022 12:03:04 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcachefs@vger.kernel.org
Subject: Re: Are reflinks always O(n)?
Message-ID: <YsMP/+P72sK/nUls@itl-email>
Mail-Followup-To: Demi Marie Obenour <demi@invisiblethingslab.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcachefs@vger.kernel.org
References: <Yr0uBS40F87h+Lxp@itl-email>
 <20220704145608.3673qxxy5ubchvkn@moria.home.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="9hu3Xom/J61dC9WX"
Content-Disposition: inline
In-Reply-To: <20220704145608.3673qxxy5ubchvkn@moria.home.lan>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


--9hu3Xom/J61dC9WX
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Mon, 4 Jul 2022 12:03:04 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Kent Overstreet <kent.overstreet@gmail.com>,
	linux-bcachefs@vger.kernel.org
Subject: Re: Are reflinks always O(n)?

On Mon, Jul 04, 2022 at 10:56:08AM -0400, Kent Overstreet wrote:
> On Thu, Jun 30, 2022 at 01:00:29AM -0400, Demi Marie Obenour wrote:
> > In bcachefs, is creating a reflink O(n) in the size of the file, or in
> > the number of currently unshared extents that need to be moved into the
> > reflink btree?  The former would be annoying, but the latter is
> > proportional to the number of modifications to the file since it was
> > last reflinked, which is fine for my use-case so long as unlinking a
> > heavily reflinked file is also fast.  My reading of =E2=80=9Cbcachefs:
> > Principles of Operation=E2=80=9D suggests the latter.
> >=20
> > Basically, if a file is already reflinked, is reflinking it *again*
> > cheap?
>=20
> It's about the same. Reflinking a file doesn't change the number of exten=
ts, it
> just makes them indirect, and then to reflink the file a second time we h=
ave to
> bump the refcount on all those indirect extents.

Thanks for the information.  This could be annoying for large, heavily
fragmented files that are frequently reflinked.  What makes this tricky
is that at the time of snapshot creation, Qubes OS does not know if the
snapshot will be sparse or dense.  For instance, renaming a qube (VM)
is done by cloning the qube and then deleting the original.  That the
clone will be sparse is only known when the deletion API call is made,
which is too late to use a different method of cloning the file.
Therefore, something that performs well in both cases is highly
desirable.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--9hu3Xom/J61dC9WX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmLDD04ACgkQsoi1X/+c
IsHkTw//eE5iwF8mO8j4EJNxyeu3iBIxTowOExzEQ/GBwymuDxsMM++L0DD8Bvyz
60WjEbLa6uAFJmcOh0brOKdM2Wk7w/3E8zdQMt3ikyquqIcRLri+4W32j94N1wxu
ANYM4CqHBn+r/kTc3HsNyqKoRk7f8a7887b3puh3zLa6Nmhx2Gm0bOPQL1fPlI6c
N0SavtSm0o8ZJDHw5n+tKkdH/YbhVsAECeKPCb8MR8mj+DQMswMee82ZcqHzsFUp
ukDKC+HkU7qLvKbE/nFZPiA8hlKvyCQ+yPHtfO3wUI2r3s6jLj97V991MT7TcV8V
dGDoSuOxzYuyLP3BMcPOgr4SbLdM2BdFSxKh6SXwis+PBco7ZWoR21/La60X1a2N
Pq0+dNTZb+wLoG1Rgbvw7ZyFMkvkGCBeXq3c34lCFGfiOGnx2w+5m2fKer8nOBht
5DnuI90AqYJL76jo1oCZknpnbjSswgzWNzubEu1soBYot5Bju2MB+AsiaDyAY14o
meHI1l5heRBdVPfNtHm6CLp791sb1jX3REvH2d1IForxWTqpPoNVnWbmhH8zRHLv
Kv4iolPmAdgbaCyM30pyuwrJYhHVcwsRhLcRewM9cjGu4pNHWCJE1AkNBAFGbN2j
jhIqhV0r7VOgYoFpKCkKEnVCArZ4dFTYpcDnXsOYAq6TtgiKaRg=
=eE/Z
-----END PGP SIGNATURE-----

--9hu3Xom/J61dC9WX--
