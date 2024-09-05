Received: from mail-4317.proton.ch (mail-4317.proton.ch [185.70.43.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1821A0AF4
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Sep 2024 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725555578; cv=none; b=gVXjUZ1aQHFb2Ux5HAQSEB0P+6lojSciu9uLEkgaGRBE7qVcGc1J/Sm0i/CzT49QKCsw4OA28wKEnoHyuUmBVQuI5AzOF3LI/TpkM+SGHDY4eaI8p6N6zzNlbE+F3nPNlVPIf/ziKb7MMMUV7Ou8l2dFiUtfYHt8DkxeoP9Djdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725555578; c=relaxed/simple;
	bh=aalIeKIVnFQPDuJvNWq+jF4I7vNcO+UGe9+3LDZVirk=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=uP3b+u8Uq2OPfR1eSaODryjJKEFRUsgEK/56tcAi3CgJuqN7p0vj/R7k6TYHdvWWNngrk82Oo1IEBbA+EsPFhUyKhDEJcNlARyavAFArRIr9xdqp0XG+VdJYh8Rut/cr66+K5aoO4rDHJNv1jxGxFoUXh2okhLCHjE6d5oEnCtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=KFZopqDp; arc=none smtp.client-ip=185.70.43.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="KFZopqDp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail; t=1725555571; x=1725814771;
	bh=5LPN1YgnrLqSImm1H0HpotUJy+wL1qR4YDreDK+8BMg=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=KFZopqDpf6jV5mRxFrb+yF2TLKPo1Y6SSvSLxS6Y2iAwmBBQEcBEBXj24I2ey2K6J
	 FwOIe4MbDthPRctSu6XTFQ/H3AoYEuKmFGi/PeTvFrNJ9ea/Ab9T8Zt16KqBczHsto
	 fDWWAKpyAjgj1ozP74BQX9/AP8L3FIN407ia46tjJwspysRh2hN9TKQyZRdKILPxQd
	 MTg4YWdvlOvKzqmCQoI7JBoZ4sj03pfMMontHhR0hbP2m4hiAK+KtaPCeWCmPeFlmb
	 CwavvsOOTYa7Z8tif1cMITQumlAy3zmZa25PbuBmKdRl+YI1hoErKh9GpiBYBnxS79
	 cXQ4Px9qmY9tQ==
Date: Thu, 05 Sep 2024 16:59:29 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH] Replace div_u64 with div64_u64 where second param is u64
Message-ID: <4sKBZZw48nEZjT1jQupVR2UFURIlwWmUkFK5KtEPZosBIeWn00r0lcENgqQiGqzfOgOvnvi_xhOR_-P8aHiY_KtW4ANW_Awf7xUjCEpEMUY=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 7a533b5aad93a35e8150f2386ffa840682697a84
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Bcachefs often uses this function to divide by nanosecond times - which
can easily cause problems when cast to u32.  For example, `cat
/sys/fs/bcachefs/*/internal/rebalance_status` would return invalid data
in the `duration waited` field because dividing by the number of
nanoseconds in a minute requires the divisor parameter to be u64.

Signed-off-by: Reed Riley <reed@riley.engineer>
---
 fs/bcachefs/super-io.c |  2 +-
 fs/bcachefs/sysfs.c    |  2 +-
 fs/bcachefs/util.c     | 12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index c8c2ccbdfbb5..6f71e8cef7ea 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -521,7 +521,7 @@ static void bch2_sb_update(struct bch_fs *c)
 =09c->sb.time_units_per_sec =3D NSEC_PER_SEC / c->sb.nsec_per_time_unit;
=20
 =09/* XXX this is wrong, we need a 96 or 128 bit integer type */
-=09c->sb.time_base_lo=09=3D div_u64(le64_to_cpu(src->time_base_lo),
+=09c->sb.time_base_lo=09=3D div64_u64(le64_to_cpu(src->time_base_lo),
 =09=09=09=09=09  c->sb.nsec_per_time_unit);
 =09c->sb.time_base_hi=09=3D le32_to_cpu(src->time_base_hi);
=20
diff --git a/fs/bcachefs/sysfs.c b/fs/bcachefs/sysfs.c
index f393023a3ae2..561998b2b5dc 100644
--- a/fs/bcachefs/sysfs.c
+++ b/fs/bcachefs/sysfs.c
@@ -288,7 +288,7 @@ static int bch2_compression_stats_to_text(struct printb=
uf *out, struct bch_fs *c
 =09=09prt_tab_rjust(out);
=20
 =09=09prt_human_readable_u64(out, nr_extents
-=09=09=09=09       ? div_u64(sectors_uncompressed << 9, nr_extents)
+=09=09=09=09       ? div64_u64(sectors_uncompressed << 9, nr_extents)
 =09=09=09=09       : 0);
 =09=09prt_tab_rjust(out);
 =09=09prt_newline(out);
diff --git a/fs/bcachefs/util.c b/fs/bcachefs/util.c
index 1b8554460af4..144d8df48b1e 100644
--- a/fs/bcachefs/util.c
+++ b/fs/bcachefs/util.c
@@ -64,7 +64,7 @@ static int bch2_pow(u64 n, u64 p, u64 *res)
 =09*res =3D 1;
=20
 =09while (p--) {
-=09=09if (*res > div_u64(U64_MAX, n))
+=09=09if (*res > div64_u64(U64_MAX, n))
 =09=09=09return -ERANGE;
 =09=09*res *=3D n;
 =09}
@@ -140,14 +140,14 @@ static int __bch2_strtou64_h(const char *cp, u64 *res=
)
=20
 =09parse_or_ret(cp, parse_unit_suffix(cp, &b));
=20
-=09if (v > div_u64(U64_MAX, b))
+=09if (v > div64_u64(U64_MAX, b))
 =09=09return -ERANGE;
 =09v *=3D b;
=20
-=09if (f_n > div_u64(U64_MAX, b))
+=09if (f_n > div64_u64(U64_MAX, b))
 =09=09return -ERANGE;
=20
-=09f_n =3D div_u64(f_n * b, f_d);
+=09f_n =3D div64_u64(f_n * b, f_d);
 =09if (v + f_n < v)
 =09=09return -ERANGE;
 =09v +=3D f_n;
@@ -360,7 +360,7 @@ void bch2_pr_time_units(struct printbuf *out, u64 ns)
 {
 =09const struct time_unit *u =3D bch2_pick_time_units(ns);
=20
-=09prt_printf(out, "%llu %s", div_u64(ns, u->nsecs), u->name);
+=09prt_printf(out, "%llu %s", div64_u64(ns, u->nsecs), u->name);
 }
=20
 static void bch2_pr_time_units_aligned(struct printbuf *out, u64 ns)
@@ -477,7 +477,7 @@ void bch2_time_stats_to_text(struct printbuf *out, stru=
ct bch2_time_stats *stats
 =09=09=09bool is_last =3D eytzinger0_next(i, NR_QUANTILES) =3D=3D -1;
=20
 =09=09=09u64 q =3D max(quantiles->entries[i].m, last_q);
-=09=09=09prt_printf(out, "%llu ", div_u64(q, u->nsecs));
+=09=09=09prt_printf(out, "%llu ", div64_u64(q, u->nsecs));
 =09=09=09if (is_last)
 =09=09=09=09prt_newline(out);
 =09=09=09last_q =3D q;
--=20
2.46.0
