Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4524AC433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu, 30 Jun 2022 05:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiF3FA6 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 30 Jun 2022 01:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiF3FA5 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 30 Jun 2022 01:00:57 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E2824F25
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 Jun 2022 22:00:56 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C2B145C0079
        for <linux-bcachefs@vger.kernel.org>; Thu, 30 Jun 2022 01:00:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 30 Jun 2022 01:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1656565255; x=1656651655; bh=DD9Flh50Nz
        j/EnFYKF0EaU0xtd8e1llHirQ9S8+3Zfk=; b=ORaCjFDXs3HKGG8AZ4/ve93mew
        zDiguo5hfLKT6HAHFAXYCoJffuhD9ZIZ/XIpohc7mh75LFWNm4Z3MVkLxhmV2tSW
        QUiY2Xk/WdqXVtoTPiMLNfZ35PjWGRSmGBslQSf3GPffaM3mWBLSJPs2q+BLkBfi
        HNZ+PMrAH/8uSsZOlxMDkoeYiGR4/OHotBykrKBRj2lXzXsAchGZ0laJ89muL76/
        aXZZe/UqImY28nJxZ8kVyEqqtD3XTRzZujNM1/8g13VpY2flPp9rHR9StSCAPSRE
        uJ2nkj/NKKCc1Gk8XXKqPcdRRZaRV5e+IPTXOONlwJz1GHHQ4Av8ec/p/8rQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1656565255; x=
        1656651655; bh=DD9Flh50Nzj/EnFYKF0EaU0xtd8e1llHirQ9S8+3Zfk=; b=d
        v1tlvKwAN4U3V3MD6XbvX+pjQiaVVqsObdOoaFtQB+aD4lIXsLPkPrOytfI+YS1K
        Rytdosbh0K03Tv0ShqHNMHZLxDYx+yDUhoehC8scjtNRwHnX5iGgluTyFhSOEBtA
        +V+EMt2IAJ+rZLYnIFqT7oDMn4/Wz6TXj2TE/Pa24ikhfqs5J/08QHzQgFwwOz9+
        n25dT2z5kTB04S8Bj3Xj6y6C1zL1PSr7X41hWRcjLfXP/muo861STwGLC57yvA0w
        aW+I+YZ4dW4qZbd2UEttGYEtGTHTH48dyD2L/CUl1VswsR/S/NdxlxLJqnOlDy0x
        c1kF3ah52eYFae9Wzyelg==
X-ME-Sender: <xms:By69YoG3YjkgjJs1WzjXrW6DLRsd_hqSfzN473mzGtNUy4OcXWDoow>
    <xme:By69YhUkyHDiYVjMDBSO_qqNu2zEhAwBJW5pqmqZXboP-ccwt3yL_fSTjaSIgeXz3
    h0Uvb3uKs1i1cE>
X-ME-Received: <xmr:By69YiKTXkbVf_QFofoaplinQ6Yu2ITm6BvnqstHejMnSkvVvfFGPwg_VX0v>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehtddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkgggtugesghdtreertd
    dtjeenucfhrhhomhepffgvmhhiucforghrihgvucfqsggvnhhouhhruceouggvmhhisehi
    nhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheple
    ejtdegjeffleevfeeuleehjefgvdefhfehgfejgeelteegtdetjeelueeuveefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggvmhhisehinh
    hvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:By69YqGdsFK7dFZg9QQUZJBNZ0_ZFAovCpS19F08vKc_IPvZQCr6eg>
    <xmx:By69YuWHgQ3cu3p2Dc-21Gl4x9CcziGUBhXfgdU58Jp2LyaCkqJZuQ>
    <xmx:By69YtM2QX5A0Y8YSIu6Kzv4G0NUrmJvqNl8cTZWHUWX0TVJEchp3w>
    <xmx:By69YmgxqOY9d8Jzif6oiByfZxob0jMeslXUjeIqilh2zzRzqjfzCA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Thu, 30 Jun 2022 01:00:55 -0400 (EDT)
Date:   Thu, 30 Jun 2022 01:00:29 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     linux-bcachefs@vger.kernel.org
Subject: Are reflinks always O(n)?
Message-ID: <Yr0uBS40F87h+Lxp@itl-email>
Mail-Followup-To: Demi Marie Obenour <demi@invisiblethingslab.com>,
        linux-bcachefs@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wmSZLVor1GieHjWz"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


--wmSZLVor1GieHjWz
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jun 2022 01:00:29 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: linux-bcachefs@vger.kernel.org
Subject: Are reflinks always O(n)?

In bcachefs, is creating a reflink O(n) in the size of the file, or in
the number of currently unshared extents that need to be moved into the
reflink btree?  The former would be annoying, but the latter is
proportional to the number of modifications to the file since it was
last reflinked, which is fine for my use-case so long as unlinking a
heavily reflinked file is also fast.  My reading of =E2=80=9Cbcachefs:
Principles of Operation=E2=80=9D suggests the latter.

Basically, if a file is already reflinked, is reflinking it *again*
cheap?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--wmSZLVor1GieHjWz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmK9LgUACgkQsoi1X/+c
IsGekBAAwZRD27H8NZU7W8t5JMDJZZcUYfIo+Qkd97XQesYl2nJmftum1I4DROAJ
L6yPx8PCxGFEumR1GcRKQKsgwSO37QEDRx+eR5yCLdTk/DQ7tOqm711l+LTV9G7l
9fUdAHnVOwebonqAebylgb2HOeAnuN4vSasPU8NFrb83+Uy8HIp27fIQPs4tm3qo
iUuUDvX4RAaTbXDRVANc3qtwPq6+ahR4dJOqZ+mx8Hefgtu79WqSzgURErUD6sVm
k94LJkDF8yUWKfovgGoHcPCzAbGIjzoRZj7ha5EaMJ4nypFvIHGxAMVKtLxoQ3M8
k7UzKZWXn5ezFWahxHkfPaycFoJedIPW5Fh0NjwuaJIKF6Cpp5mZeh90Bk4aJBmk
RBu3JMfvTPApK0d+jIqtRw2OAlkxUlnSpSlwSe4CGbcGALimCPBZoWIpWD6IQr5y
qj07nxTT6YWTXhOUFN6IMv04HwHD8rk38rilPcClI3zgoCs5kTEdQTqtDb3OcRxb
wTDZiaB1fBQXt5moekvEGXzYdklM0LyQOWWARt9SN6Bz4bBj56/e5XsT9cdpZyc0
2RQFX81GHQJu7iaKlhebVc96CdD2ooGy0uDQE6HJmEVO75jFnQr1ygsOJywLAWry
WdO4o8rQ2tLVvknfgrwmHAYrX3jbxM/jOPn5LMvryoIilscq/7A=
=gGvA
-----END PGP SIGNATURE-----

--wmSZLVor1GieHjWz--
