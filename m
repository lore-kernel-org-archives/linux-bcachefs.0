Received: from mail-4323.proton.ch (mail-4323.proton.ch [185.70.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6021684A37
	for <linux-bcachefs@vger.kernel.org>; Sat,  4 May 2024 22:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714860753; cv=none; b=B+yplcS1WCZUJvywIaBV2s3aXTyEZR+SspdV9px40ejFVHpd3FUX/oll+fldZ1m4ojzXl7x3CAT3Jl+GqguDFLZCcIxfDuDjfdkVnJWXR69JV7NCbWEfexcDdZsEB+YLCuV/BLsBykqw/pzLiZGhwa038FsT10QGpmW3JOgMirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714860753; c=relaxed/simple;
	bh=0piqip4PMiRierau0Sb66dmxmaxnj53asSxngHhF9VI=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=E3WNXC+tUELg63/meCbGgDuEQrfltRd+kCzarLRhE9QbLFiFChHhFZNmJcXbzkSpBfrgZd40/Gw20DtE3s7Bnt44qO6ngo17qpIiOZldLG1jHj7nk8Vg75IWTlaMWO5gXyWbl1fway2nGkNxx1L19zvCqEgjMmhEc19JsOCIprU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=XFqf7Bib; arc=none smtp.client-ip=185.70.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="XFqf7Bib"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail3; t=1714860746; x=1715119946;
	bh=HNNw2m1VFKwibVNnz3yDPMK7A++o+WVrDDwwtSjd4t0=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=XFqf7Bibxi7lCIP25utbcnIi3tZsth981kqcf+zYuPY/wTFl9FQJ44z6EOs5GhskL
	 zhw/4xuT7BrFqxs4OxHy4WNtOIiHPCfxWeMKSbhU2AA3AxZWFSLnQPZtyud5yBJI6F
	 Gf1KNJH7fc9ddrEJBQzaZvypuhCsOObYfFJDNj+NBMggjneFAYAjDZ+3vy+T6AYjsB
	 p5a5OUsZp5aFaF4NwTXjGzob9qiG8u+ih2e4xgf+D5P8c0pv4jJU7NdXM2U2QlK2YP
	 boSJMCKo9AemqoH4gxeSrVVppN88ej8GwIgvbnK3MZTAp9Stln/gTZJVP/sdQz7bdy
	 GlzZQjzf2e8Bg==
Date: Sat, 04 May 2024 22:12:23 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH] bcachefs: fix overflow in fiemap
Message-ID: <7qU8xNKAHxFIkSlLrXO1B6kyf-7DvRoJRgZloXK5qHovOzUFYbbCYhe_9Tzv1J6MgiXcakyIFiovCX3HtotUEE9fsV25jYmifgyMz_wa-Ik=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 345926a19cebd6d058a25da3807695cf764122c3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

filefrag (and potentially other utilities that call fiemap) sometimes
pass ULONG_MAX as the length.  fiemap_prep clamps excessively large
lengths - but the calculation of end can overflow if it occurs before
calling fiemap_prep.  When this happens, filefrag assumes it has read to
the end and exits.

Signed-off-by: Reed Riley <reed@riley.engineer>
---
 fs/bcachefs/fs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/bcachefs/fs.c b/fs/bcachefs/fs.c
index 4e4442bc71e3..ff01c954bff8 100644
--- a/fs/bcachefs/fs.c
+++ b/fs/bcachefs/fs.c
@@ -996,7 +996,7 @@ static int bch2_fiemap(struct inode *vinode, struct fie=
map_extent_info *info,
        struct btree_iter iter;
        struct bkey_s_c k;
        struct bkey_buf cur, prev;
-       struct bpos end =3D POS(ei->v.i_ino, (start + len) >> 9);
+       struct bpos end;
        unsigned offset_into_extent, sectors;
        bool have_extent =3D false;
        u32 snapshot;
@@ -1006,6 +1006,7 @@ static int bch2_fiemap(struct inode *vinode, struct f=
iemap_extent_info *info,
        if (ret)
                return ret;
=20
+       end =3D POS(ei->v.i_ino, (start + len) >> 9);
        if (start + len < start)
                return -EINVAL;
=20
--=20
2.44.0

