Received: from mail-4018.proton.ch (mail-4018.proton.ch [185.70.40.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DFF139B
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Sep 2024 01:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725757232; cv=none; b=Fn83AW9J6W9uXNJrAqqjO29u0gCHKRIVhmZlUEjct1JeGf0X1CpoB5OOLWBboX06tTmatBegwfAIgaZnuOzctSYasar9WUx3oYZ/psqxMycVUENSxnAcROrVVtec3e89jx3y8KT9n59/041mVqD4siOTVtcr89upMDcJGQeap8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725757232; c=relaxed/simple;
	bh=1qNgHHULm+7XXziZt97akb5/KkTJd0lA3bd6xrn/5Qg=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=CnRIH1CwCVSRLF+GGFS2fRjXAhKQsJ2oHWl5BUbKpvgckx9CoGnxs+OBVj5SPGuQBvk/SDSSBFdIm9T/GrRWhBW4MJFr1mkC5TKM03imroo4jvGsjsZ8hiT+6agyMUqkRzrCnEsq/KYlvwK0VVqESgBJEfFYI4M6KOdWGSuTnv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=NKO0sVBs; arc=none smtp.client-ip=185.70.40.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="NKO0sVBs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail; t=1725757222; x=1726016422;
	bh=9XVxPoC+bGUaaPT4XWjVHuwiW7C5B/ABvMKckG4q6ac=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=NKO0sVBsmjrGg7qGPr2cc0qZ4rLKtssrzPnxkn26iSvLNlHs6AzRsIt9siAkv9xBU
	 g/c8q8GEmLeQgCf+tAfLtdPkYRL37kYF5TUVTn5BzhjdgC/8NEk4KznW14eYgkd9J0
	 iSLNlIzCe0i75kRoTNDjcD66vc4MK5ej1zV7TMHKjiwFIbQeSxkNAAObD2uotEG2eg
	 M0N16+Q5yw86SMW/aa8A6jCSu/isp9pQvJHfftpj50ShVdLGcziguTlb9GoUNczytQ
	 XxKES9gLHVydIIDePJc2dvxqGMzwpWP+Ru3IdgNTvHy5/5HxPJsVaWL0kd60FqATz1
	 TR6vxAfRoWIeQ==
Date: Sun, 08 Sep 2024 01:00:17 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH]  bcachefs: fixup Replace div_u64 with div64_u64 where second  param is u64
Message-ID: <OaN1YGV-Wgd_RjZ5MV1QJNza7nAxnQ4RIK72be-Fa8oJB5zs0g-i_648m92V0Na59leAWmTPzqgJpbbtZFD3OtMdNJH6NfokHs3t-M4jwwU=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: 6bee29b53d55612eee35762a231efc6ae81422b5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

The previous diff changed a callsite to div_u64 in super-io.c when it
wasn't strictly necessary due to the types involved.

Signed-off-by: Reed Riley <reed@riley.engineer>
---
 fs/bcachefs/super-io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 6f71e8cef7ea..c8c2ccbdfbb5 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -521,7 +521,7 @@ static void bch2_sb_update(struct bch_fs *c)
 =09c->sb.time_units_per_sec =3D NSEC_PER_SEC / c->sb.nsec_per_time_unit;
=20
 =09/* XXX this is wrong, we need a 96 or 128 bit integer type */
-=09c->sb.time_base_lo=09=3D div64_u64(le64_to_cpu(src->time_base_lo),
+=09c->sb.time_base_lo=09=3D div_u64(le64_to_cpu(src->time_base_lo),
 =09=09=09=09=09  c->sb.nsec_per_time_unit);
 =09c->sb.time_base_hi=09=3D le32_to_cpu(src->time_base_hi);
=20
--=20
2.46.0
