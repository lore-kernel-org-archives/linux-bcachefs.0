Received: from smtp.carlthompson.net (charon.carlthompson.net [45.77.7.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF231C1AB0
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Oct 2024 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.77.7.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729330196; cv=none; b=SfM8Ia4bFkifC61oEn1Z3gMw6EVb/W7nyFPpHt+niNd9emaOEFweeEM4VYIMhxdxRw5DW6jADSCQoM/ue/mD+CN4cAfonWhv0We/vGup0e8A1NPoiAb6737VxUwQgMrbBGRWWZK8y4EstKXdYMZJsjPZJeSqUU3tGN0AKQsvudY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729330196; c=relaxed/simple;
	bh=P3UMpwupyWwqqpS2z+segWxd6Cc0qVDgVefRWDxccF8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=jym0S7pzuWcw60xDI1JyFkA3DqBuEF3DzHmimDj3THcRT/tZdJQkvQcAzOmtR4v+zx/ny7/Ckjmj9RJmkLTbA4pEg9os9a/T+/IClDg3hwsaR7/1eSiN0yvkbe5NJomKUKPdRuUU5Z6eZlNTBxKmOl36c73ezZqukilbWa3g9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net; spf=pass smtp.mailfrom=carlthompson.net; arc=none smtp.client-ip=45.77.7.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=carlthompson.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=carlthompson.net
Received: from mail.carlthompson.net (mail.home [10.35.20.252])
	(Authenticated sender: cet@carlthompson.net)
	by smtp.carlthompson.net (Postfix) with ESMTPSA id 703304015DDE6;
	Sat, 19 Oct 2024 02:29:53 -0700 (PDT)
Date: Sat, 19 Oct 2024 02:29:53 -0700 (PDT)
From: "Carl E. Thompson" <list-bcachefs@carlthompson.net>
To: Martin Steigerwald <martin@lichtvoll.de>,
	=?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>
Cc: Christopher Snowhill <chris@kode54.net>,
	"linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>
Message-ID: <1711880898.1172.1729330193274@mail.carlthompson.net>
In-Reply-To: <4958287.GXAFRqVoOG@lichtvoll.de>
References: <46uitwudetmmygddpxufepddca7azsim6trqj4o2ivsccdeavz@uztkfyqtjgks>
 <1249157619.1105.1729296906241@mail.carlthompson.net>
 <1af6fd38-7ecf-451a-9be3-fa7b9447fa43@tnxip.de>
 <4958287.GXAFRqVoOG@lichtvoll.de>
Subject: Re: Another bcachefs version downgrade bug
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.6-Rev53
X-Originating-Client: open-xchange-appsuite

I reported the bug because it's a bug that I hadn't seen reported or refere=
nced before. I didn't know at the time I reported it that it had already be=
en fixed.=20

I actually **still** don't know that the bug is fixed in current versions. =
What Kent said is that "6.10 works" which isn't quite the same thing as say=
ing that he previously found and fixed the bug. He could have meant that he=
 knew about and fixed it or he could have meant that there have not (yet) b=
een any on-disk layout changes since 6.10 that would trigger the bug. Looki=
ng at the 6.10 pull requests I don't see anything in Kent's description of =
the changes there that suggests that this bug was known or fixed then unles=
s it's the bch2_sb_downgrade_update() fix that went into rc5 but wasn't des=
cribed. Maybe Kent could clarify?

If the bug **was** discovered and fixed previously, I think a note to the l=
ist warning users about the problem would have been helpful. It certainly w=
ould have saved me a bunch of time.

Thanks,
Carl


> On 2024-10-19 1:31 AM PDT Martin Steigerwald <martin@lichtvoll.de> wrote:
>=20
> =20
> Hi Carl, hi Malte, hi,
>=20
> Malte Schr=C3=B6der - 19.10.24, 10:13:08 MESZ:
> > On 19/10/2024 02:15, Carl E. Thompson wrote:
> > > If you tell me you don't want me testing bcachefs anymore it won't
> > > hurt my feelings and I'll respect your wishes. There are plenty of
> > > quality filesystems for me to use where I'll have less hassle. But
> > > I'd suggest to you that pushing out testers who point out bugs and
> > > try to offer constructive criticism isn't the best way to make
> > > quality software.
> >
> > I think in your case the developer of the fs is the wrong person to
> > complain to. The issues you are reporting have looong been fixed but
> > apparently your distro neglected to provide these fixes to its users. S=
o
> > if you are stuck with a 6.9 series kernel, well, bcachefs was really
> > not ready for daily use back then. 6.11 is fine, 6.12 seems to fix the
> > last issue I was seeing. So I think the options you have are: get a
> > newer kernel and/or choose a different fs.
>=20
> While I certainly do not agree with Kent on everything =E2=80=93 and also=
 not with=20
> the tone of some conversations =E2=80=93, I agree here about the basic si=
tuation:
>=20
> BCacheFS is marked experimental. My take with that is: As long as it is=
=20
> marked experimental and you like to test it and give feedback, it is=20
> important to move quickly enough to new kernel versions. It was and partl=
y=20
> still is the same with BTRFS. Developers often asked users to use a newer=
=20
> kernel. Feedback on BCacheFS on 6.9 is quite likely not very useful to=20
> Kent and other BCacheFS developers while they already work on what to=20
> bring in for 6.13.
>=20
> It reminds me of an annoying issue with appointment reminders in KDE's=20
> Plasma and one frustrated bug reporter expecting to fix the issue in the=
=20
> version of the software it occured in. Due to the nature of the=20
> implementation of restoring lost functionality the fix had some familiari=
ty=20
> with a new feature and was more than 100 lines changed in different files=
.=20
> While I certainly get that it has been frustrating for the user, cause th=
e=20
> issue was annoying for me as well=E2=80=A6 I would not expect and basical=
ly demand=20
> on how developers use their free time. Of course, Carl, in case you=20
> support Kent financially regarding BCacheFS development=E2=80=A6 then tha=
t may be a=20
> bit of a different story, but once kernels are out of stable support=E2=
=80=A6 I'd=20
> still agree with Kent.
>=20
> Best,
> --=20
> Martin
