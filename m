Received: from fhigh7-smtp.messagingengine.com (fhigh7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F6818595E;
	Tue, 10 Sep 2024 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962541; cv=none; b=kfvnwEf0FiVQzeig12Ko4HtibX0R5KJq/J3v0Xe5thE1p+Hqj8BgqPX8Vy8asclU37vYUK4giWFPiazdC31Aq+PUGwNgfNNJjUJcpDLtIKTVvt7T+0HxXN1ASZmKWY/0UeXVkFQ/WyCSVnS9/4NHa15F1xWnGfr1jplPiFmL4r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962541; c=relaxed/simple;
	bh=+/nf0XKWilX+Q5Wc5/xlM7AwCbvLCKEIxkHcn7FhO8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=p3jy2Lv9jV8sdqgLkaJ3JXfWsYj+YetKbUsjsnmvdn0MdOdez96KhsVHrVIzPRlbEgbwMY8cWtSHzgtzVx1Dp11g4IbGZ9ZZvVgLQpw7S5RirsjrFzMtrxMmL+ZTl46hSUwvkBdkYaTy4H8bAPx6MoitNuHGssdbRDOX5EdZC0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is; spf=pass smtp.mailfrom=alyssa.is; dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b=n0lOn8ds; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=tXX2XE1X; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alyssa.is
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alyssa.is
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=alyssa.is header.i=@alyssa.is header.b="n0lOn8ds";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="tXX2XE1X"
Received: from phl-compute-07.internal (phl-compute-07.phl.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 968F51140122;
	Tue, 10 Sep 2024 06:02:16 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Tue, 10 Sep 2024 06:02:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm3; t=1725962536; x=1726048936; bh=gJHPpgFAZa
	8vt4W8j4/yb/MNCYdgVfpC/cRhv6oPxTw=; b=n0lOn8ds4IBWLsAvZwtelWPwP3
	4nexO5RDT5hlDpJM7gw8zP8ul2ntbp3OGznk3N12o6UKOIQAzKL8E524cA5oQh76
	ckGIaW8Hd4m0Vc2xRkuorCWctX240AcAvqf7fqY0RagEHsiwFMFAbc/BEoXlwyh4
	orVnpVzFUp9Fu1x2jnHqmEvhfKXzgFrvqzDwPtL+GutagHM6BQJzJNTcqxq7wbAH
	88IBLxm42Y31KPJyFcaDr1N7bc8dONA55s5lrPsGAjpDRYeXp05Ms9EjqlXb6s1+
	MRVcb5yZV27hvX4nC5ThWga4rQjkoN0WHflpTL3J3YRx1BUsRTWyTZBBi7Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1725962536; x=1726048936; bh=gJHPpgFAZa8vt4W8j4/yb/MNCYdg
	VfpC/cRhv6oPxTw=; b=tXX2XE1XdcVCGeHuPoxHd07U3zb+yFulFj0cYlXMyc5v
	nXSTyoOkxKfZ2wBltMksjEx8rvAASjCyOKJ6dY9CunRaiyWfhbKfWc59SF4ao7cX
	VClh6yARDiOnNKKa58X36RmuV03dy/Wzj4X3PDDh9ZlqLur9fhs0kcMgbUM7RX41
	XgA3Wj+JSZv6Q/TyGJuCkieO/6x0Ii6ULykz+BOjK1UafMzvECFCGFkgbqt+1uNL
	VA5bOIkrJ4E3d7O7pI+vKYTVFwl64Va4GOeOdeGS+2tgkKDG+/avy3j8I0R5wrfK
	01J87n6vVIHjW5ERtUTmHUzumGTzsXOmS6eQey4ayQ==
X-ME-Sender: <xms:KBngZjqMPVAEkXA6mq38DhFiFDY4-W4Fs7dzh2W55cKzSrQRN3bV6Q>
    <xme:KBngZtrsnk-4xQZl-W-7MKtEyuxsUall-R3ba9J5y4uf7jErW-Y4unQ6p7CCfuueX
    beG8u52JB8x9E1EUg>
X-ME-Received: <xmr:KBngZgMNzwuRY0obPxh-XTIhuU2z99eARXT9D4gO71Izj983NeYz7H78WuL_Y3lsxWW-ULP_GxFDv08rOlRqrgF6T4I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudeiledgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhephffvvefujghffffkgggtsehgtderredttddtnecu
    hfhrohhmpeetlhihshhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtf
    frrghtthgvrhhnpeejtdetffdtveffheejhfeiudfgudeuveetvdelfeeuffehuedvueff
    ffetgeffueenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgvlhdrohhrgh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhihes
    rghlhihsshgrrdhishdpnhgspghrtghpthhtohepfedpmhhouggvpehsmhhtphhouhhtpd
    hrtghpthhtohepiihlrghnghesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfhhsthgv
    shhtshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgstg
    grtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:KBngZm6ogOot0nuup4vdWQgufeqpbzLN5w-NQdES7Z_BBCSFU5-FLQ>
    <xmx:KBngZi5PxlVHfuSR8KYTEsCY9KKcNHO-YTzfxw_MAYng31N18S_VZA>
    <xmx:KBngZuim4RNlE8s0gnmIX0k_Vd9B4-UQtP9VlrxbVmacQhZJkQum6w>
    <xmx:KBngZk4ShrOo6NQU2omg9GD45ZIG3KLG1-euQdf7ojKorN1fWDFakg>
    <xmx:KBngZokB8dMoCbmE40hUbqOfMRUtGKpE9yW5QPsLCiv1UhOb3OqyTHqm>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Sep 2024 06:02:15 -0400 (EDT)
Received: by sf.qyliss.net (Postfix, from userid 1000)
	id 01F4920427F0F; Tue, 10 Sep 2024 12:02:13 +0200 (CEST)
From: Alyssa Ross <hi@alyssa.is>
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-bcachefs@vger.kernel.org
Subject: Re: [RFC PATCH] generic: test negative timespecs are accurate
In-Reply-To: <20240909080132.4wliimcb2y4bt7u3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240907154527.604864-2-hi@alyssa.is>
 <20240909080132.4wliimcb2y4bt7u3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Date: Tue, 10 Sep 2024 12:02:05 +0200
Message-ID: <8734m7hlnm.fsf@alyssa.is>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Zorro Lang <zlang@redhat.com> writes:

> On Sat, Sep 07, 2024 at 05:45:28PM +0200, Alyssa Ross wrote:
>> Link: https://github.com/koverstreet/bcachefs/issues/743
>
> Great, a bcachefs regression test case :)
>
> Can you add a bit more details in commit log, not only a link.
>
>> Signed-off-by: Alyssa Ross <hi@alyssa.is>
>> ---
>> This is an adapted version of generic/258, but it tests that the stored=
=20
>> timestamp is accurate to the second, rather than just testing the=20
>> timestamp remains negative.  I created a new test rather than just
>> making 258 more precise, because I understand that there may be
>> filesystems that don't store timestamps that accurately by design.
>> As an example, I've heard that FAT only has 2 second precision, so this
>> patch is an RFC because I'm not sure how I should write a _require
>> function (if at all) that restricts the test to filesystems that are
>> expected to be able to do this.
>>=20
>>  tests/generic/363     | 26 ++++++++++++++++++++++++++
>>  tests/generic/363.out |  2 ++
>
> The g/363 has been taken, please rebase to latest for-next branch.
> You can use `xfstests/tools/mvtest generic/363 generic/365` to change
> the case number, before rebasing.
>
>>  2 files changed, 28 insertions(+)
>>  create mode 100755 tests/generic/363
>>  create mode 100644 tests/generic/363.out
>>=20
>> diff --git a/tests/generic/363 b/tests/generic/363
>> new file mode 100755
>> index 00000000..50459d01
>> --- /dev/null
>> +++ b/tests/generic/363
>> @@ -0,0 +1,26 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
>> +# Copyright (c) 2024 Alyssa Ross.  All Rights Reserved.
>> +#
>> +# FS QA Test 363
>> +#
>> +# Test timestamps prior to epoch with nanosecond components are
>> +# accurate to the second.
>> +# bcachefs was slightly off.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick bigtime
>> +
>
> As this's a bcachefs regression test:
> https://lore.kernel.org/linux-bcachefs/20240907160024.605850-3-hi@alyssa.=
is/
>
> So better to mark as:
> if [ "$FSTYP" =3D "bcachefs" ];then
> 	_fixed_by_kernel_commit xxxxxxxxxxxx "bcachefs: Fix negative timespecs"
> fi
> (replace the xxxxxxx if it's merged on mainline linux)
>
> Others looks good to me, with above changes, I'd like to
>
> Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks!  So you don't think the test needs to express any extra
requirement that filesystems support to-the-second precision?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEH9wgcxqlHM/ARR3h+dvtSFmyccAFAmbgGR0ACgkQ+dvtSFmy
ccAvGg//Zd2D0L1jBJZoYgd6As1MHCEVDjAo/ZYcmEbvoRhIL6VTC6V/LcnyUwfW
GKlZrhEV8c99CXYI+uCaLJfCSuh+DWxlJx62tfrGnXhGquxJQxmux8fUG5mPkTMl
JbRbit19cdGXi0qUMbd9ULiEcmMXtzsHwixgx8UkWilbnbJjMF/zmjQRPcorpV4Q
GCnF8eBpQwrArJljWS9rDoQtv3kmsblZ6WBaifAug8scjvrdYqVn2UMCwM6QJR2L
jz04EG8rYzDAcmpxO0cXEM5ngkoQgYFFw8qolvZRPJWXmbl328Q9o1RrIWnKylm1
qFMGruKiAGpGQ89QTR8Zxnty2HGTHRxJ6To/VU6PlNQkIYxXKu4HQV3DiyJJAosd
qDpXlrcEYoqgFo/6X47vop5USnk/ZUhfqp6yFlaIWYNSvWrN2vLk1J4fHU9nnWzz
5WO3Elq0Qm1rhTvmQu1kdIhIGNkqBW6j8A7zzcaLbEMWVn3DPaHRaVTwCV+GTr3d
2r5ghx47VfHNDQ8cr41QWacfvpsCAT6OWqsO/gnukDSASSNYTYtezameom/6ppcv
Z97KmN24oImGUEw5j5UIxVQsrAC6WP68wTHPX2xY/62Pj3KY/Y6lqDvRizBYwkJI
SHwNSD3dVpVrny9hSjJSLKW8ZydQnIJaXlXBpcWITq+AitdA7hk=
=ykvt
-----END PGP SIGNATURE-----
--=-=-=--
