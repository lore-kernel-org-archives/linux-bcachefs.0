Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E71D559
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 23:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715643769; cv=none; b=JWXf74LHI3uOT+5PBVUrrGLEwfDQYdTWTxu7dbJxTJDlSV3jv94s5tqJCVyWhRLfks84M05qfh6+l5IVvug1UsGTpoykw1CSliAZf0KxLn3CsNsp52odtKmmh+ZG3Er6yx0bIYuz/l/5ln7/VTH1HcA+C55fIZGQqYukDMg/EDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715643769; c=relaxed/simple;
	bh=tZD1//GgzmSUY+fatN+CDnwS14Dz9fAu8Big+X0nB/8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KQLZmZ09u5UIVBHNr9GhqzPgclArtPgF7/V0AIJtUcSAoEAVyr7z3e2cVzVu0DQOzxwoLkLT0fZ8OZuSeIjsqcI7WWFAa75vpKwHyuWG77DwHPetkNOLsZKNezwc6BIJM1kGeMweLVge8DF83/F8YdlKrj5MJs+sckXcN4Q5jG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=x5xUi6HD; arc=none smtp.client-ip=185.70.40.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="x5xUi6HD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail3; t=1715643765; x=1715902965;
	bh=tZD1//GgzmSUY+fatN+CDnwS14Dz9fAu8Big+X0nB/8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=x5xUi6HD8Mo/VQgC2Oh820mUQoxILdno0wIK1/prrbRCA1x12sy0zRHyj8Yivon6u
	 49Zemr8Z+Z7OrjK/t7LfpJZN2JqHYAQ9LeR91Z5sw3i6JxrhmfVN8VUiY8+D8vjeyd
	 Q5wY1bK60IqC6nJLUD0di3Im2OW3Kit4k5ZWiSNJz5m55ZVehPAEZXan6B9K8nte0i
	 k6zbzWu3cD9EX5WutFSBQ0NGEmbpVEjBJu9TkSkz8/NOE9yPSikU1MOqhHOEu2eyGd
	 BDt1eT5Vv7v6Q9+ywDALynyG4DZ9b5YKITr4gwjGtOK9PAVl2snA4esqFfZ+idRFSJ
	 e6plObXC6F49g==
Date: Mon, 13 May 2024 23:42:42 +0000
To: Brian Foster <bfoster@redhat.com>
From: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: support REMAP_FILE_DEDUP in bch2_remap_file_range
Message-ID: <45_rwv0SgX9alyYyitLlz7CwOVmZZejtbJRAzqVyVnXjhVDxhPp273Pwd1Lpp3n1T-HsBT9EB1ZeXyoinExuozvfk4LNfTFHxa54NBJojOo=@riley.engineer>
In-Reply-To: <ZkIIxvdRKrgCdoC8@bfoster>
References: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer> <ZkIIxvdRKrgCdoC8@bfoster>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: f3b442c0a83b62422aae13cf59d455e0765bbaa6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Monday, May 13th, 2024 at 5:34 AM, Brian Foster <bfoster@redhat.com> wro=
te:

> On Sat, May 11, 2024 at 12:20:12AM +0000, Reed Riley wrote:
>=20
> > By removing the early-exit when REMAP_FILE_DEDUP is set, we should be
> > able to support the fideduperange ioctl, albeit less efficiently than i=
f
> > we handled some of the extent locking and comparison logic inside
> > bcachefs. Extent comparison logic already exists inside of
> > `__generic_remap_file_range_prep`.
> >=20
> > Signed-off-by: Reed Riley reed@riley.engineer
> > ---
>=20
>=20
> Seems reasonable:
>=20
> Reviewed-by: Brian Foster bfoster@redhat.com
>=20
>=20
> Have you run any tests just to make sure there are no surprises? If not,
> it looks like xfs_io has a 'dedupe' command that would make it easy to
> run a quick test or two from the command line. fstests has a bunch of
> tests in the dedupe group (which I presume this patch should now allow
> to run on bcachefs) as well.

I worked with Kent to run his CI tests against the patch (https://evilpiepi=
rate.org/~testdashboard/ci?branch=3Dbcachefs-fideduperange&commit=3D1945149=
c8d7549b924cd88f57f0cd938b3bb7125) and also used xfs_io to do some basic sa=
nity checks.

Specifically, I sanity checked that:
 1. fideduperange doesn=E2=80=99t dedupe if file content doesn=E2=80=99t ma=
tch,
 2. fideduperange does dedupe stuff when they do (according to filefrag -v =
reporting shared extents), and
 3. That neither of the above operations changed file checksums.

I=E2=80=99d be happy to run more tests if anyone can suggest them?

>=20
> Brian
>=20
> > fs/bcachefs/fs-io.c | 3 ---
> > 1 file changed, 3 deletions(-)
> >=20
> > diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> > index 20b40477425f..4f513f22a66a 100644
> > --- a/fs/bcachefs/fs-io.c
> > +++ b/fs/bcachefs/fs-io.c
> > @@ -857,9 +857,6 @@ loff_t bch2_remap_file_range(struct file *file_src,=
 loff_t pos_src,
> > if (remap_flags & ~(REMAP_FILE_DEDUP|REMAP_FILE_ADVISORY))
> > return -EINVAL;
> >=20
> > - if (remap_flags & REMAP_FILE_DEDUP)
> > - return -EOPNOTSUPP;
> > -
> > if ((pos_src & (block_bytes(c) - 1)) ||
> > (pos_dst & (block_bytes(c) - 1)))
> > return -EINVAL;
> > --
> > 2.44.0
