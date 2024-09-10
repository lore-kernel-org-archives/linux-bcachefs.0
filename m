Received: from fhigh3-smtp.messagingengine.com (fhigh3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4981DFD1;
	Tue, 10 Sep 2024 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725980661; cv=none; b=Ili/u7QAbT1b8fe6yjKQUM+/uGIlTu9HBfkHLFo0swmMHJsuQVnfYBoRfhxDyKmAi11tE7eWSAc9ekAa/Wbb2wD009arnEo9/qW40UUw5JlkG0MV8BdL5ZimTsQ5W21YiH82N7hH++Ghun1JpD6m3GMhXwVVKNSD3M64M8QVqsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725980661; c=relaxed/simple;
	bh=N7P1T6Kvc4/Yh/5fEfz+gkYqzdjCXV5jPHq9NhdWqbY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bY/3t8HX18tcidSs0n+O+1YKq5yrM3tKs90juuJJ6fGVaNH1LzgugB7mnPW4rtCHIwMcFrM+1wpJNNIgtSc+TN9q09qajmed9Sen7DYfs6uVzP5ew46jpr89k5NEVJg1ChWktZNDg9t1Z9W7KfA328Fco+vVrSJOgFOfl3fRqRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=LHNi8WUS; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=hswDu5xG; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="LHNi8WUS";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="hswDu5xG"
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 6D2A811401C4;
	Tue, 10 Sep 2024 11:04:17 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 10 Sep 2024 11:04:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1725980657; x=1726067057; bh=5JhK7hUypX
	/GjDaw+3onzCocPeW1IDBBuZSItakM/3E=; b=LHNi8WUSWhYY3EXrw3n1PPLRml
	gVv+Lvdx70aIPYdFUXMelygywGHJcaNK5Xkto8eXBnyAqENfgmiA6BkXXOGLqzmJ
	1RowphZzPzDUvXInTCJX06aSusXZZgZh+UZrMMgkraceJNuELVWUmJSyEytifNAQ
	WiyVGpbUEYXzuDOQb9E67IiIFw6ogO9ftv+z/q+21G4sOlAnhbXMCC84oHlZOswl
	JSMTmR18lL9tjHC/NXU1vxAWUrJyA38+NgEaH6qb1jd/sM1fGnq7lc4O0jZ0/Atz
	5uXTvujwuqjS/TKsCvNwRGw0pGUs9hfjGeer+1VzZK7wRsuGu64qavUAiTdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1725980657; x=1726067057; bh=5JhK7hUypX/GjDaw+3onzCocPeW1
	IDBBuZSItakM/3E=; b=hswDu5xGdezvdEUSEFca+3DIvKg86cUOdLHNJV/o5Oiu
	chw5o5M7pJf4IKi9VoW+xOPfAe6JhemvLte5pwLqBxGv4DDH4kfdjOMmalIiuduP
	r5SOFR5qNyeCrfWvzoVDd4QGtUFWIMFka7qPH3rAqOE3ogEijdcB26pCHh4SRfWp
	aD4WlRIIcN84vNjmsNJ+tYtkrmBALVFHiS1fkaCOlQ05c8c0Qtbmu4Y5X7EOcvZQ
	nF2/Hh5/EXZsFpYOBNRPOy+z70F/hWNNcT7rNSs6jcDGJhDmYqbW7VSS5gG5v1jd
	d7zJbH+t4msYfBV0im1IfrPIGGS/zhQbjSOoWiHNGg==
X-ME-Sender: <xms:8V_gZmmWCdGr9NKZj6ytucZMcvA5X7fnz44cQyVFXC6L-uY_N6dszA>
    <xme:8V_gZt18-Zz1ESt2r9fC8e7wGBYA0Oi_sGtbW_CQFoMP3JimVg43AXvM5pA0Fv9Gg
    3YZWsBuAYEtku1dXw>
X-ME-Received: <xmr:8V_gZkoQhbVVFHsDlnPUQX9dSZ5pou0gY8um94k-3wUnSLL6OqP8CICmpTZxn6WuaN0XeZuFSX1RGgZgsRsC1o1aq0I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeiledgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffvvefujghffffkgggtsehgtderredttdejnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeeiledthfdvjeefhfduueekvedtvdfgleelfeetvdetkeekvefffedt
    feegfeevffenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhihes
    rghlhihsshgrrdhishdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtohepiihlrghnghesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfhhsthgv
    shhtshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgstg
    grtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:8V_gZqnXZUtvBP6n2pVY96qoVljZOEooOBMPi7iiVSOQJ4CAncESuQ>
    <xmx:8V_gZk1tLjRWRk3lM1SAmrh37g08Q8Wy-US7adwWgCKtNGhxE773YA>
    <xmx:8V_gZhtU2vepQ8i1aUc2ckd7c0gvMcfCMy_kwTe5JquA5RdVcwBHCw>
    <xmx:8V_gZgWjBxUIk5E3HhQf9-IvMKiJD0xtmDIbkhLVNDqBP3_UIacrkA>
    <xmx:8V_gZhwC8V-xL0rS7Mr14GUbBRfaxzzwbwxOiDTvVovdwD6jmwj212kX>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Sep 2024 11:04:16 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 869D0300E8753; Tue, 10 Sep 2024 17:04:14 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test negative timespecs are accurate
In-Reply-To: <20240910135226.hfwk774mdzztqdxv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240907154527.604864-2-hi@alyssa.is>
 <20240909080132.4wliimcb2y4bt7u3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <8734m7hlnm.fsf@alyssa.is>
 <20240910135226.hfwk774mdzztqdxv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Date: Tue, 10 Sep 2024 17:04:03 +0200
Message-ID: <87zfofczz0.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Zorro Lang <zlang@redhat.com> writes:

> On Tue, Sep 10, 2024 at 12:02:05PM +0200, Alyssa Ross wrote:
>> Zorro Lang <zlang@redhat.com> writes:
>>=20
>> > On Sat, Sep 07, 2024 at 05:45:28PM +0200, Alyssa Ross wrote:
>> >> Link: https://github.com/koverstreet/bcachefs/issues/743
>> >
>> > Great, a bcachefs regression test case :)
>> >
>> > Can you add a bit more details in commit log, not only a link.
>> >
>> >> Signed-off-by: Alyssa Ross <hi@alyssa.is>
>> >> ---
>> >> This is an adapted version of generic/258, but it tests that the stor=
ed=20
>> >> timestamp is accurate to the second, rather than just testing the=20
>> >> timestamp remains negative.  I created a new test rather than just
>> >> making 258 more precise, because I understand that there may be
>> >> filesystems that don't store timestamps that accurately by design.
>> >> As an example, I've heard that FAT only has 2 second precision, so th=
is
>> >> patch is an RFC because I'm not sure how I should write a _require
>> >> function (if at all) that restricts the test to filesystems that are
>> >> expected to be able to do this.
>> >>=20
>> >>  tests/generic/363     | 26 ++++++++++++++++++++++++++
>> >>  tests/generic/363.out |  2 ++
>> >
>> > The g/363 has been taken, please rebase to latest for-next branch.
>> > You can use `xfstests/tools/mvtest generic/363 generic/365` to change
>> > the case number, before rebasing.
>> >
>> >>  2 files changed, 28 insertions(+)
>> >>  create mode 100755 tests/generic/363
>> >>  create mode 100644 tests/generic/363.out
>> >>=20
>> >> diff --git a/tests/generic/363 b/tests/generic/363
>> >> new file mode 100755
>> >> index 00000000..50459d01
>> >> --- /dev/null
>> >> +++ b/tests/generic/363
>> >> @@ -0,0 +1,26 @@
>> >> +#! /bin/bash
>> >> +# SPDX-License-Identifier: GPL-2.0
>> >> +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
>> >> +# Copyright (c) 2024 Alyssa Ross.  All Rights Reserved.
>> >> +#
>> >> +# FS QA Test 363
>> >> +#
>> >> +# Test timestamps prior to epoch with nanosecond components are
>> >> +# accurate to the second.
>> >> +# bcachefs was slightly off.
>> >> +#
>> >> +. ./common/preamble
>> >> +_begin_fstest auto quick bigtime
>> >> +
>> >
>> > As this's a bcachefs regression test:
>> > https://lore.kernel.org/linux-bcachefs/20240907160024.605850-3-hi@alys=
sa.is/
>> >
>> > So better to mark as:
>> > if [ "$FSTYP" =3D "bcachefs" ];then
>> > 	_fixed_by_kernel_commit xxxxxxxxxxxx "bcachefs: Fix negative timespec=
s"
>> > fi
>> > (replace the xxxxxxx if it's merged on mainline linux)
>> >
>> > Others looks good to me, with above changes, I'd like to
>> >
>> > Reviewed-by: Zorro Lang <zlang@redhat.com>
>>=20
>> Thanks!  So you don't think the test needs to express any extra
>> requirement that filesystems support to-the-second precision?
>
> Oh, does this test needs 1 second precision? I thought you concerned some
> filesystems cannot be the epoch you set. The _require_negative_timestamps
> will skip the test from exfat and ceph. It doesn't help the FAT, maybe you
> want to add vfat to _require_negative_timestamps.
>
> I thought you might want to output the stored timestamp (accurate to the
> second) to reproduce this bug, if not, why you hope to write this new one,
> not use the g/258 to be the reproducer directly?

I'm sorry, I don't understand the question.  I explained why I created a
new test in my commentary =E2=80=94 g/258 doesn't require 1 second precisio=
n,
and this test does.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmbgX+MACgkQ+dvtSFmy
ccCd6A/8Dpo8wVyIZ1mB25ZP65YRDd75aGviOaLGXM3RQLP18GIST8s2E2rcQsh/
t2iUSm0LZryUjJbooNrJwmrvQSfm4PItzdjyJVMf+7Lvts83Jvd7FC+6i81v2SCB
6uNsYQU/hMXeQ3Hp1cSYiwUjJiOb0/k5/c3OaDAFTCoOua/ZF+RDnGk1SJrem8mY
wf39Z50wR0CHu1HZosafOk5RZNzzMPGFXxXKxuQCIWPxjNKfeX6JO4odV4Q+3uHZ
AWm4SxWuWcAZEy5GLz9h1CIH8slFCZ1aNF2sD8NbWfPduMu3pWlERdqXDW97nVzg
DibVG4EhRkFcZOzK7gsqivnF0m47UrEMDtjRC+z5/TdyKd4UduRYZCn441Q5rmE3
hez4Liwq1MNSdYHyfOgK5GPR11Tx4ARVkC3QjE/DrjTP/xlxSxPxAQumVmtaYHRE
Fi7YMp6sMd0TXYh2kGtKCOjb1rzGRGatOkRhndwoggZUxN3WaysdLI9sR45xLFAD
uuX55uFwnc2x2yhxaGa9jkrUlf5D4TNDlfWmZELunyAcslRCqSAYGJu/FZllukFL
z0ZGZae4jdBOTUX5CbAKIh959C79hN+krx/VGDZr0mDI0J4ShNxDGkn5aKjOjAXK
ggonEpNJNL3Xuk5sggNO8OilUBt+2onsGdaaN44NDXFFmhmgZWo=
=nUBu
-----END PGP SIGNATURE-----
--=-=-=--
