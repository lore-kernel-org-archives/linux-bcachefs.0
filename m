Received: from mail.lichtvoll.de (lichtvoll.de [37.120.160.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD6338FB0
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.120.160.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729327159; cv=none; b=OuQm8S2RPhbdUUozyq4hcCXdLqC/eyKkqojG6aMfcivdn/apxEY3BEPnMOgN11YO5NVxw06b0yXfPh5Du6+5UkxqGL6Vog+4azVLJMbOmf4Ar48obTfRy7KsvoAAOi2nwNuIkJm94kFA4K3kWO9a2iEvy7CIHN67+gFBzqK+6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729327159; c=relaxed/simple;
	bh=Y4zfvZxnvf/1alZZBIMH6ybFuyBC0AwS3TdDCBiyrxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WByXHTIj7w00unlyfQl1WMnYZBMqHh8CcZzqSKsf80eI+X4HxwQX59/IzOiG3slA4PRy08rT+ykCnK6JdJhdAv/CgfCo8AyGZdvqofYbo4Zqpt51jUeCtIhw6QN9Cjtwh+YumwZuc9Q5hF2s1Iq5LRGdsAcsaiC1uivyHWLPf4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de; spf=pass smtp.mailfrom=lichtvoll.de; arc=none smtp.client-ip=37.120.160.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lichtvoll.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lichtvoll.de
Received: from 127.0.0.1 (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 4917D7BCCF;
	Sat, 19 Oct 2024 08:31:25 +0000 (UTC)
Authentication-Results: mail.lichtvoll.de;
	auth=pass smtp.auth=martin@lichtvoll.de smtp.mailfrom=martin@lichtvoll.de
From: Martin Steigerwald <martin@lichtvoll.de>
To: "Carl E. Thompson" <list-bcachefs@carlthompson.net>,
 Malte =?UTF-8?B?U2NocsO2ZGVy?= <malte.schroeder@tnxip.de>
Cc: Christopher Snowhill <chris@kode54.net>,
 "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: Another bcachefs version downgrade bug
Date: Sat, 19 Oct 2024 10:31:25 +0200
Message-ID: <4958287.GXAFRqVoOG@lichtvoll.de>
In-Reply-To: <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
References:
 <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi Carl, hi Malte, hi,

Malte Schr=C3=B6der - 19.10.24, 10:13:08 MESZ:
> On 19/10/2024 02:15, Carl E. Thompson wrote:
> > If you tell me you don't want me testing bcachefs anymore it won't
> > hurt my feelings and I'll respect your wishes. There are plenty of
> > quality filesystems for me to use where I'll have less hassle. But
> > I'd suggest to you that pushing out testers who point out bugs and
> > try to offer constructive criticism isn't the best way to make
> > quality software.
>
> I think in your case the developer of the fs is the wrong person to
> complain to. The issues you are reporting have looong been fixed but
> apparently your distro neglected to provide these fixes to its users. So
> if you are stuck with a 6.9 series kernel, well, bcachefs was really
> not ready for daily use back then. 6.11 is fine, 6.12 seems to fix the
> last issue I was seeing. So I think the options you have are: get a
> newer kernel and/or choose a different fs.

While I certainly do not agree with Kent on everything =E2=80=93 and also n=
ot with=20
the tone of some conversations =E2=80=93, I agree here about the basic situ=
ation:

BCacheFS is marked experimental. My take with that is: As long as it is=20
marked experimental and you like to test it and give feedback, it is=20
important to move quickly enough to new kernel versions. It was and partly=
=20
still is the same with BTRFS. Developers often asked users to use a newer=20
kernel. Feedback on BCacheFS on 6.9 is quite likely not very useful to=20
Kent and other BCacheFS developers while they already work on what to=20
bring in for 6.13.

It reminds me of an annoying issue with appointment reminders in KDE's=20
Plasma and one frustrated bug reporter expecting to fix the issue in the=20
version of the software it occured in. Due to the nature of the=20
implementation of restoring lost functionality the fix had some familiarity=
=20
with a new feature and was more than 100 lines changed in different files.=
=20
While I certainly get that it has been frustrating for the user, cause the=
=20
issue was annoying for me as well=E2=80=A6 I would not expect and basically=
 demand=20
on how developers use their free time. Of course, Carl, in case you=20
support Kent financially regarding BCacheFS development=E2=80=A6 then that =
may be a=20
bit of a different story, but once kernels are out of stable support=E2=80=
=A6 I'd=20
still agree with Kent.

Best,
=2D-=20
Martin


