Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D7FEEDD
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Sep 2024 04:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725682003; cv=none; b=YmlXOarXgf2YhLqzKo7LyxrzVZTgQAZsq9OWWONOA/kArkqtpAkWdTmNNg8k1rSwS90BoAYsHJMx+Ao/Vos6lCjJdgbWo3bZUBSnc2xosMXpsXhwzwzfmMWwL5NEOG65caHjWBAE+oH+SGhzrOgROeDp2LU/wEw229dwWxOR6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725682003; c=relaxed/simple;
	bh=0Ds2NIyhfZ5lp8WNYlsxBsbFTQc3gKfzT0HGfAdkc1k=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=PoHFahytNKEXTUvsmXJtfRJWvVUL0FLZZMFGkc7YOqNlMS2llRD4T4yK7eF9CGrS/WJevEX3Ep2MUmQPoQDR1qMbaiR6rQjEAfq/N1xygDN1A9hi80apmr90+0O/E5dV4lfu8gY6DRBrh+x/mIqig3pRLrEnEr2zBU1OweH+jEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=oc6tDSH9; arc=none smtp.client-ip=185.70.40.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="oc6tDSH9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail; t=1725681991; x=1725941191;
	bh=0Ds2NIyhfZ5lp8WNYlsxBsbFTQc3gKfzT0HGfAdkc1k=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=oc6tDSH9lvu5D/PeeUx/a2OwXxzA6v0k8BHMkNmsh0ABEHJWcrJAYGV6wxOJ2oICG
	 l7JcrP5MLTbEEfq+r4Qv93j7bXctMqN7K6IsyCgfFOhPYdsoZ30BH02DAfvE5wnGxK
	 UkIBqllGzIwkoqRT/UBclKLcWZR4zuNshlHVygBz5XNcbwE8NBD1opkoYrvcryB3CM
	 ovGtSjzbk1WTpw2UBy7w4bX9fevMP+J4V9NcuIWGLN/Gf6OP3+qN9/9lDqev2YRFEY
	 oO+bH6i1HJ8CHYktQzuZWqVXcYm/jJ8+tB4e6dRbp5uwyAB9DQy15UQEdOmFVxTIm3
	 k8QhjYhqjfddg==
Date: Sat, 07 Sep 2024 04:06:30 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH v2] bcachefs: Replace div_u64 with div64_u64 where second param is u64
Message-ID: <K-lc38swD0bEueNP7QM-SeiuQ5wMms8wsydEpirWuaAKMX3oFFI4kxWIGzqzYGcsjLzP6SmKgBASsXd8BBvg9d45rSzUo3npVyrGU5D2Tb8=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 77d2153c5887b928b9b6ec9bc6b347ccb424f501
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bcachefs often uses this function to divide by nanosecond times - which
can easily cause problems when cast to u32. For example, `cat
/sys/fs/bcachefs/*/internal/rebalance_status` would return invalid data
in the `duration waited` field because dividing by the number of
nanoseconds in a minute requires the divisor parameter to be u64.

Signed-off-by: Reed Riley <reed@riley.engineer>
---
fs/bcachefs/sysfs.c | 2 +-
fs/bcachefs/util.c | 12 ++++++------
2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index f393023a3ae2..561998b2b5dc 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct printb=
uf *out, struct bch_fs *c
prt_tab_rjust(out);

prt_human_readable_u64(out, nr_extents
- ? div_u64(sectors_uncompressed << 9, nr_extents)
+ ? div64_u64(sectors_uncompressed << 9, nr_extents)
: 0);
prt_tab_rjust(out);
prt_newline(out);
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 1b8554460af4..144d8df48b1e 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
*res =3D 1;

while (p--) {
- if (*res > div_u64(U64_MAX, n))
+ if (*res > div64_u64(U64_MAX, n))
return -ERANGE;
*res *=3D n;
}
@@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res=
)

parse_or_ret(cp, parse_unit_suffix(cp, &b));

- if (v > div_u64(U64_MAX, b))
+ if (v > div64_u64(U64_MAX, b))
return -ERANGE;
v *=3D b;

- if (f_n > div_u64(U64_MAX, b))
+ if (f_n > div64_u64(U64_MAX, b))
return -ERANGE;

- f_n =3D div_u64(f_n * b, f_d);
+ f_n =3D div64_u64(f_n * b, f_d);
if (v + f_n < v)
return -ERANGE;
v +=3D f_n;
@@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
{
const struct time_unit *u =3D bch2_pick_time_units(ns);

- prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+ prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
}

static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
@@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, stru=
ct bch2_time_stats *stats
bool is_last =3D eytzinger0_next(i, NR_QUANTILES) =3D=3D -1;

u64 q =3D max(quantiles->entries[i].m, last_q);
- prt_printf(out, "%llu ", div_u64(q, u->nsecs));
+ prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
if (is_last)
prt_newline(out);
last_q =3D q;
--
2.46.0
