Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1181F28F0
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Sep 2024 17:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725730023; cv=none; b=WnQ0MMh+elwB7U/94S/LvYaPNCHfn249bFTRkpvJ4mEpBixrHxtqt88uSJxRMShS0yNwd2N9XNOAL50dkrgJUfMioskGiDJclUjWVEvTu7heRavJbXvO64LVkWh4uUPqHl5Fu5tvLARhQ1Q3bCUxBKn66QEylYXn5DiyBqEdX2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725730023; c=relaxed/simple;
	bh=0qMBklEy76KvcPAgoylp16II3C2gw7pDOobZJZ5/SLU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jZol5ahAtpyNVQPIfw2i2msV4xfH5tdd8phqgZnD5ns6CZ51BW0ufx6TuC4TmDQnsYOnvOOa/vJJhojSsxNdDJlzNmpmpKWbVuS4UFBP7enNAZDeSl94wAX1/13fQbCmxn+00fR+6a0vsgJxPGNQOr/zh7qPEx8NO5Px19bANGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=ehxHfmLm; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="ehxHfmLm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail; t=1725730017; x=1725989217;
	bh=tBtKE41UZ4sZbgc5cRW5w8Tr5cKe+NPZ4aXiL2r3zUw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ehxHfmLmoX6Z6jzlgKVuIDgDClbDITZlKLf1H75YznPTLD0q8aVyQv7Jaz8v0vHUR
	 TrvixtP0TmTOepbbF4PQoGEYVgERldA0H/mMcFzmHAMj8oc1qKZ3DnDeFZqnGMXszZ
	 FwJD6LvI2DuUwQN5XaQZCzupHEyhJKRgwCB6He5RhKqUM3++uqLk6rSaMVWMM/ErUr
	 glG72f4d3jcVeIPJQbB+h3dlOHrV4Q2EWa4ypiWrzhFo6k7zm8EHPGzC4pnxc5hs2G
	 N1gt0//jbN20deJmVuG909mi5WuRwmSFKlfYMPe2qdSwX3JfXmv0IJdHeosG/hMcFk
	 J37TciVtbRppg==
Date: Sat, 07 Sep 2024 17:26:54 +0000
To: Hongbo Li <lihongbo22@huawei.com>
From: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH v2] bcachefs: Replace div_u64 with div64_u64 where second param is u64
Message-ID: <IWv0DX8wPEFiGxgi36Xjt7-bfKaL6aalQBV9OtMMYtDk-6UjO5hSpmsOdfybzPfRRfgf48OfZ2eXcDGQMXpQAyKQ9gabfIa9tqdTS5yESC0=@riley.engineer>
In-Reply-To: <c1a567b2-b066-4f45-870b-900324fc2df6@huawei.com>
References: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer> <c1a567b2-b066-4f45-870b-900324fc2df6@huawei.com>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 77dbf65c589ebb394d85ef533ddc68fb3957c42a
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, September 7th, 2024 at 12:00 AM, Hongbo Li <lihongbo22@huawei.=
com> wrote:

>=20
> On 2024/9/7 12:06, Reed Riley wrote:
>=20
> > Bcachefs often uses this function to divide by nanosecond times - which
> > can easily cause problems when cast to u32. For example, `cat /sys/fs/b=
cachefs/*/internal/rebalance_status` would return invalid data
> > in the `duration waited` field because dividing by the number of
> > nanoseconds in a minute requires the divisor parameter to be u64.
> >=20
> > Signed-off-by: Reed Riley reed@riley.engineer
> > ---
> > fs/bcachefs/sysfs.c | 2 +-
> > fs/bcachefs/util.c | 12 ++++++------
> > 2 files changed, 7 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
> > index f393023a3ae2..561998b2b5dc 100644
> > --- a/fs/bcachefs/sysfs.c
> > +++ b/fs/bcachefs/sysfs.c
> > @@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct pr=
intbuf *out, struct bch_fs *c
> > prt_tab_rjust(out);
> >=20
> > prt_human_readable_u64(out, nr_extents
> > - ? div_u64(sectors_uncompressed << 9, nr_extents)
> > + ? div64_u64(sectors_uncompressed << 9, nr_extents)
> > : 0);
>=20
>=20
> ah, it seems that your code lacks indentation. But the changes you've
> made appear to be fine. May be you could add some comments in the commit
> message to explain what has been modified in v2 (just separate it with
> ---) to make it more clearer. But I see that Kent has already merged
> your code. =F0=9F=98=84

Oh, all I did with the second version was remove one callsite to this funct=
ion that, as you had pointed out, didn't _technically_ need it.

(I'd included it previously because the 'XXX' comment right above it had su=
ggested that there might be future refactoring, and having the right functi=
on in place might make future refactoring safer?  But it's certainly not ne=
cessary.)

Either version of the patch is equally fine from my perspective, and I'll d=
efer entirely to the maintainers.

> Thanks,
> Hongbo
>=20
> > prt_tab_rjust(out);
> > prt_newline(out);
> > diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
> > index 1b8554460af4..144d8df48b1e 100644
> > --- a/fs/bcachefs/util.c
> > +++ b/fs/bcachefs/util.c
> > @@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
> > *res =3D 1;
> >=20
> > while (p--) {
> > - if (*res > div_u64(U64_MAX, n))
> > + if (*res > div64_u64(U64_MAX, n))
> > return -ERANGE;
> > *res *=3D n;
> > }
> > @@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 =
*res)
> >=20
> > parse_or_ret(cp, parse_unit_suffix(cp, &b));
> >=20
> > - if (v > div_u64(U64_MAX, b))
> > + if (v > div64_u64(U64_MAX, b))
> > return -ERANGE;
> > v *=3D b;
> >=20
> > - if (f_n > div_u64(U64_MAX, b))
> > + if (f_n > div64_u64(U64_MAX, b))
> > return -ERANGE;
> >=20
> > - f_n =3D div_u64(f_n * b, f_d);
> > + f_n =3D div64_u64(f_n * b, f_d);
> > if (v + f_n < v)
> > return -ERANGE;
> > v +=3D f_n;
> > @@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 n=
s)
> > {
> > const struct time_unit *u =3D bch2_pick_time_units(ns);
> >=20
> > - prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
> > + prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
> > }
> >=20
> > static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
> > @@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, =
struct bch2_time_stats *stats
> > bool is_last =3D eytzinger0_next(i, NR_QUANTILES) =3D=3D -1;
> >=20
> > u64 q =3D max(quantiles->entries[i].m, last_q);
> > - prt_printf(out, "%llu ", div_u64(q, u->nsecs));
> > + prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
> > if (is_last)
> > prt_newline(out);
> > last_q =3D q;
> > --
> > 2.46.0
