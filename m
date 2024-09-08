Received: from mail-40136.proton.ch (mail-40136.proton.ch [185.70.40.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C864A1D
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Sep 2024 00:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725757099; cv=none; b=Hzya3YxGpnvYNC8aNyX6CevCiWxBlA+83MlO8s4nXXW2gRZ0JJXKYnZJwf1k5D2y3xBZdy7EoMVq8pnjK3vIoCHlMYnMN9x8bKEEtoPCUaadz1OnW/R4bSD+EwlF9o6JrAGmNXxsXa/eSQwmyYBe+9AnJ5gYCDJCCAC4N6VQVpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725757099; c=relaxed/simple;
	bh=VRmL46RT1Uaz8d+lmKPITafMEpza7L5Qt0tsqr91hTo=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4MMUmP22Afe26qCQxmcSSP78oPdwl0z55M0wTU08y4NcB1fdtht24BrqdvOrQC3WICVjU7X1CZ/BmdRsI4Qv08t8CHfCbESYmyGSGOYYAOAIxCSzrxHfiw6pCvyqtFxHX0n9LshhLhn7NnHTCKrF/MiXoXRp62AgCquhNx7BCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=WUGfsgUL; arc=none smtp.client-ip=185.70.40.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="WUGfsgUL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail; t=1725757088; x=1726016288;
	bh=KyTRItQVAflh0SiKNTr+JDLXJzgjUvOASRDJuhClMLE=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=WUGfsgULXJtvNPbI8wLhMVbcZ9eA+dtzC2eaPjTmKUXXtyaIZHqiA9zl1xlyPzSQC
	 R4LZAgMMZIauELPF0X5oTVV2RHywj1m0aKi78ZlRJ8Rb4KjL5QRGoj/qbqO6ycy7me
	 MwTxa/hYPvlf0zvhlRcO2ZqEwuuYCFIpYBTedEddXEsv/ob+VXdcYys3h3qogI9bNt
	 W4qN8T6EznY7a521zA4VstgTQlWSUTuZRmLhHUCh0jR4Jclyb4rTX0lIn19FGK6YWX
	 BnwfmcpGfYimEURazooVrOna18OGzz5Y+sIbsK1feS8eK5iaJtryGLmTJpx/JCFmmT
	 hDTiwNUFW15tw==
Date: Sun, 08 Sep 2024 00:58:03 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Reed Riley <reed@riley.engineer>
Cc: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
Subject: Re: [PATCH v2] bcachefs: Replace div_u64 with div64_u64 where second param is u64
Message-ID: <SGhMYR8swLbkCsV8OZix_Mq8MRWBtx66d9GNIY4odST3P5jYFVVVOXYD4HAr_w3A1u3ee5Neuqoc_p101M7h1II228Ioy5r5nokq78ENa1A=@riley.engineer>
In-Reply-To: <issb2c7q4uxmnxc6phkgklphomlxljbuyyjutxfq7koeu3ukuj@uxshuswwg5lz>
References: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer> <issb2c7q4uxmnxc6phkgklphomlxljbuyyjutxfq7koeu3ukuj@uxshuswwg5lz>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: abc5bda2fd3d04d56977b26859ca7d932adaa47b
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Saturday, September 7th, 2024 at 1:03 PM, Kent Overstreet <kent.overstre=
et@linux.dev> wrote:

> On Sat, Sep 07, 2024 at 04:06:30AM GMT, Reed Riley wrote:
>=20
> > Bcachefs often uses this function to divide by nanosecond times - which
> > can easily cause problems when cast to u32. For example, `cat /sys/fs/b=
cachefs/*/internal/rebalance_status` would return invalid data
> > in the `duration waited` field because dividing by the number of
> > nanoseconds in a minute requires the divisor parameter to be u64.
> >=20
> > Signed-off-by: Reed Riley reed@riley.engineer
>=20
>=20
> this patch isn't applying (git am says corrupted?); a fixup would be
> easiest since I already applied the first one

I hadn't realized the earlier one had been applied already, my apologies!  =
I'll send out a fixup diff to make it more clear what the difference here i=
s, but it's not entirely clear to me which version you'd prefer to have in =
the codebase.

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
