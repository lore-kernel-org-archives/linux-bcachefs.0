Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B3028F5
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 00:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717373150; cv=none; b=imPSUo5MuVEOH2ZpPkF3rIBiMY/5IxqGm8RfUF2D3IJx+UjkAsNraJ9ukALlN+iaHPA8t291x14E0DTv5N8xbO5tzAJNZqXPx5JYINn4DP17ykRxNsISFEN0PVuviSm493qBQDZQRzNgH2qhEEE+V1ZhWerYeWmXMxpamHSOum8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717373150; c=relaxed/simple;
	bh=4k4KD+faV8AQ1zHGpj7RTekoKiLV0FBPMYD+gFYaQSE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sVR8qK+6Vkmcg2ctupXEWj2LgvZZjWJhqCtWyWotGywiDWAyKD9egFNMfLWJN4Gpu2Lh5WafdPXcKv1JoKXiTw7AmvGtyODT7fr7d1P9Gjvag4o7gAMk3sD4FjHaNc8uA6SDkQQcxgpW5JKVwrmqi/67kU3iuXOwBr+bbqwMMXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=K/tu2LAC; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="K/tu2LAC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail3; t=1717373139; x=1717632339;
	bh=4k4KD+faV8AQ1zHGpj7RTekoKiLV0FBPMYD+gFYaQSE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=K/tu2LACquzHlPcDyxrvWiJGhxAVq4NdcuThI8fZxTyhfcYCBtNH17zahunsvqn/x
	 8MP/XATehT+3Cd12/zUaZgOoh+X5LpwOG//2SBjT7hMRPQ1xL3ZV1LjaY32KlDEopl
	 mbFu8zAHEXYcEoQ0gkNai7MDCcVGsu+BgIxEnQ7O+euFEpynVc1mdnEd0JGSFGuGOD
	 yFI8OVvCuNGCbTRiRK76QOdIBQ50LXXxvk9939ZcNOI5X+Jm07A0nP4u2tQ4W/VXaB
	 1ddPl2wTMtgBw4Zyrcg5NuuiDVvCUJi+a1+j/tPxQ4Mec3hLqvBIJUcK3XAyIAP0OV
	 P8QjPYiEXu8cA==
Date: Mon, 03 Jun 2024 00:05:36 +0000
To: Brian Foster <bfoster@redhat.com>
From: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH] bcachefs: support REMAP_FILE_DEDUP in bch2_remap_file_range
Message-ID: <IwehPOWRxy8vk3Mmm7whasvVfWWV7CsCpCiD7OqgrbIPP79B9T8XI3hQtiZvaWfWqxr6bqITfahle-YEeff1sOXioAMCdcYyjGDuNji2Ufo=@riley.engineer>
In-Reply-To: <ZkND7a95h3pzCrOq@bfoster>
References: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer> <ZkIIxvdRKrgCdoC8@bfoster> <45_rwv0SgX9alyYyitLlz7CwOVmZZejtbJRAzqVyVnXjhVDxhPp273Pwd1Lpp3n1T-HsBT9EB1ZeXyoinExuozvfk4LNfTFHxa54NBJojOo=@riley.engineer> <ZkND7a95h3pzCrOq@bfoster>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 944f68f39326ad7aef7cbe1ac3f19d49ce7b25f3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Any chance of getting this patch merged upstream?

I've been running with it on my system (and using the fideduperange ioctl f=
airly regularly) for a couple of weeks now with no issues.

Thanks,
Reed


On Tue, May 14, 2024 at 3:58 AM, Brian Foster <bfoster@redhat.com> wrote:

> On Mon, May 13, 2024 at 11:42:42PM +0000, Reed Riley wrote:
> > On Monday, May 13th, 2024 at 5:34 AM, Brian Foster <bfoster@redhat.com>=
 wrote:
> >
> > > On Sat, May 11, 2024 at 12:20:12AM +0000, Reed Riley wrote:
> > >
> > > > By removing the early-exit when REMAP_FILE_DEDUP is set, we should =
be
> > > > able to support the fideduperange ioctl, albeit less efficiently th=
an if
> > > > we handled some of the extent locking and comparison logic inside
> > > > bcachefs. Extent comparison logic already exists inside of
> > > > `__generic_remap_file_range_prep`.
> > > >
> > > > Signed-off-by: Reed Riley reed@riley.engineer
> > > > ---
> > >
> > >
> > > Seems reasonable:
> > >
> > > Reviewed-by: Brian Foster bfoster@redhat.com
> > >
> > >
> > > Have you run any tests just to make sure there are no surprises? If n=
ot,
> > > it looks like xfs_io has a 'dedupe' command that would make it easy t=
o
> > > run a quick test or two from the command line. fstests has a bunch of
> > > tests in the dedupe group (which I presume this patch should now allo=
w
> > > to run on bcachefs) as well.
> >
> > I worked with Kent to run his CI tests against the patch (https://evilp=
iepirate.org/~testdashboard/ci?branch=3Dbcachefs-fideduperange&commit=3D194=
5149c8d7549b924cd88f57f0cd938b3bb7125) and also used xfs_io to do some basi=
c sanity checks.
> >
>=20
> Ah, great. I threw this up on my test branch yesterday as well just to
> see what happens. It looks like it enabled more tests (likely the
> fstests that _require_dedupe), which is good to see.
>=20
> > Specifically, I sanity checked that:
> > 1. fideduperange doesn=E2=80=99t dedupe if file content doesn=E2=80=
=99t match,
> > 2. fideduperange does dedupe stuff when they do (according to filefrag =
-v reporting shared extents), and
> > 3. That neither of the above operations changed file checksums.
> >
>=20
> Makes sense. Thanks!
>=20
> Brian
>=20
> > I=E2=80=99d be happy to run more tests if anyone can suggest them?
> >
> > >
> > > Brian
> > >
> > > > fs/bcachefs/fs-io.c | 3 ---
> > > > 1 file changed, 3 deletions(-)
> > > >
> > > > diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
> > > > index 20b40477425f..4f513f22a66a 100644
> > > > --- a/fs/bcachefs/fs-io.c
> > > > +++ b/fs/bcachefs/fs-io.c
> > > > @@ -857,9 +857,6 @@ loff_t bch2_remap_file_range(struct file *file_=
src, loff_t pos_src,
> > > > if (remap_flags & ~(REMAP_FILE_DEDUP|REMAP_FILE_ADVISORY))
> > > > return -EINVAL;
> > > >
> > > > - if (remap_flags & REMAP_FILE_DEDUP)
> > > > - return -EOPNOTSUPP;
> > > > -
> > > > if ((pos_src & (block_bytes(c) - 1)) ||
> > > > (pos_dst & (block_bytes(c) - 1)))
> > > > return -EINVAL;
> > > > --
> > > > 2.44.0
> >
