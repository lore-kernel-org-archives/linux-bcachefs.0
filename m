Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1044DC433F5
	for <linux-bcachefs@archiver.kernel.org>; Wed,  6 Apr 2022 10:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346862AbiDFKcm (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Wed, 6 Apr 2022 06:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiDFKbM (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Wed, 6 Apr 2022 06:31:12 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA263478001
        for <linux-bcachefs@vger.kernel.org>; Tue,  5 Apr 2022 23:55:12 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 25DD33200F9C
        for <linux-bcachefs@vger.kernel.org>; Wed,  6 Apr 2022 02:55:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 06 Apr 2022 02:55:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=O0j133bChIeunoa1tyDMq53BpQIToB5MBoZsIqo3C
        iE=; b=U8mhkmlIe1yQZHL7tVL9FiiCPC5V1j0StS1hLw2Y4qZmH4JQG38tE/wvE
        PqSlk0bGDcKXoYihvYMNZr9cXij47vOSGvvpWBI+3BAj6ObjilunXJvrdxSF9fxY
        qtdEWNVxz0rm24HglRR0v2xwg+DJ9KzJhAQoizzmIEKILVyeHHQJ0AHH5ifQHBu3
        6nFPdsOsHGZU/jjlzhVdk27QK/spWqhL6r629hye3/yQbqZMW9atwnsDAK4+lBbN
        v3cD+KWy/9Z0o9UQJmv3q6RFUO2VX3aVlNYc/ZC2PAGD74Z8LvW1I3RqoB0njr4E
        zt9otEjjJEHSvkQlbWuz/IcAk5d8g==
X-ME-Sender: <xms:TDlNYqu__wch12CJYjO0eSR_Zyfyo0-o7q7yt4CLDywmOzWmmm1nSg>
    <xme:TDlNYvdZsnHp54aVhDZbUclknWO3YcEpKNcPtwiJneOH37BAqZWph8zbsflMYLZbN
    SoA3RfoBbEPICk>
X-ME-Received: <xmr:TDlNYlyQ2L7lXDSlRARTQQuovpapkDFW1NpY_VDLEfRTplDBQC5vEEEP6m4a>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudejhedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggusehgtderre
    dttddvnecuhfhrohhmpeffvghmihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihes
    ihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpe
    dujefgjeeggeelhfevkeeltdekvdeuhfetiefffefhkeehhfevhefhkefgudegkeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesih
    hnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:TDlNYlOLm_VB8hOvX4G8JC-83c8gKfvYXeSuuT03PV3SHFceEYTfJw>
    <xmx:TDlNYq-oLvlkIBHnGFxs161HOsU_MQRypQrs_D_QRVsnXBIf9Yew9Q>
    <xmx:TDlNYtWopci3DkBsKj0FlhnLnhwKgbbYKlaPK3XPRcVKpPA9d2U8Bw>
    <xmx:TDlNYtJUClVkNLimfNWbDq1MRXqbbqqQzNa5CBz3tU9QP4TcbZXgOQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <linux-bcachefs@vger.kernel.org>; Wed, 6 Apr 2022 02:55:08 -0400 (EDT)
Date:   Wed, 6 Apr 2022 02:55:04 -0400
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     linux-bcachefs@vger.kernel.org
Subject: Comparison to ZFS and BTRFS
Message-ID: <Yk05Sk4ztxLMpgrt@itl-email>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D2e4TZ+bMlesmL7Z"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org


--D2e4TZ+bMlesmL7Z
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Wed, 6 Apr 2022 02:55:04 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: linux-bcachefs@vger.kernel.org
Subject: Comparison to ZFS and BTRFS

How does bcachefs manage to outperform ZFS and BTRFS?  Obviously being
licensed under GPL-compatible terms is an advantage for inclusion in
Linux, but I am more interested in the technical aspects.

- How does bcachefs avoid the nasty performance pitfalls that plague
  BTRFS?  Are VM disks and databases on bcachefs fast?
- How does bcachefs avoid the dreaded RAID write hole?=20
- How does an O_DIRECT loop device on bcachefs compare to a zvol on ZFS?
- Is there a good description of the bcachefs on-disk format anywhere?
- What are the internal abstraction layers used in bcachefs?  Is it a
  key-value store with a filesystem on top of it, the way ZFS is?
- Is it possible to shrink a bcachefs filesystem?  Does bcachefs have
  any restrictions regarding the size of disks in a pool, or can I just
  throw a bunch of varying-size disks at bcachefs and have it spread the
  data around automatically to provide the level of redundancy I want?
- Can bcachefs use faster storage as a cache for slower storage, or
  otherwise move data around based on usage patterns?
- Can bcachefs saturate your typical NVMe drive on realistic workloads?
  Can it do so with encryption enabled?
- Is support for swap files on bcachefs planned?  That would require
  being able to perform O_DIRECT asynchronous writes without any memory
  allocations.
- Is bcachefs being used in production anywhere?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--D2e4TZ+bMlesmL7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJNOUoACgkQsoi1X/+c
IsEgzBAAhMHiSh00IdNBkkSUR4WhtpZThvbXywneb0kMjtVAJOxNMxq3GewJa5rV
2WKeelfPr1EybkGNd8MmWYEAXGP0E0QCEx6q07IqLE2dQsnVMTuATn/M5upcBKJM
b9zTIlJkf/wYzoMO4EA+mIJ5tVeWyzEceUKKD5PDLhket1sYSMXgL3Vbc8wtEXx5
MVDwJnOVhDGoprmTyrjpfeej2pXebsVBfhfOqhZk9UyVXJ/IKvyHK12TQeUXnwAc
PhfUFtJiUatkVYGc6LNmnfCV0XxPGB+YjCKJ7LJMJGcp3k16xB4nf9QCSqM5xa+s
vEGvFYiVJEZck7Eo93I7D7t7FIHUmAt4v7YpPRKukvOtbFM4WWskRzU88nilAmz8
nn4Lc3etFPOT3sa8rTQhQYk5el5PHPwEEC7KnDyRDDhaCnLBgG63DJ8hO6xJwTGi
yTz5ksmiPsjYL1vcf2MTa6N0ZQwnB3y8fURjbSHZL9ZSn5BFcaaGWCASdy9SrY4N
b2ISKhBF5dF8Xx/Pil3WaixYE32rS9eW5Xi6IapD9yNqOc2rNSw8ALQGDA1TUgtB
4zjkUWlBBYyjJkfqQAwMvfyxDCW/dUJd6oJVa6BWw6TghJaCJnA3hP6fThl85r7K
v86aP+r/eu2tyhSmMcot9pxfgcNKT3y2Wr+qCfsUw2Q0D5fmWmg=
=OGLK
-----END PGP SIGNATURE-----

--D2e4TZ+bMlesmL7Z--
