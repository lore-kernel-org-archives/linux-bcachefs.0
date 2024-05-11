Received: from mail-4022.proton.ch (mail-4022.proton.ch [185.70.40.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDA9366
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715386829; cv=none; b=uIwTiYewX5fqbdm95HzmyZbSCqPUh7HY0Vy2gaLkD15qiz5+ogTEvBztFiL7sKpVBC6qN+jAnLIxFAByGuCJ2wdIkgchOmHhjje8H6eW5ruXoLGdrLlP5uMXLLyrqD8X5Mly6Ja8CBTR7vAC29jV/HEjEOfKRsExg+WjcU01PCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715386829; c=relaxed/simple;
	bh=CUqCUhvFNbM6MS2RkGa5pBlnn0tB2t4YK37IxgfUU3Y=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=Ndx6T70tJstBYWaOpM8FoudWikxs1ohbWnKuQRbNQ8eCZKIZQcFx4VN5wHfcvrrqS1Jc2Prklv8KczwYme7JmNpWyalchANBzU6IlC+q9FgAd6Tp+MfebTf/mFPNy5TosMzhXnvGAiIe2+6K4dtp4Dy5w/UVDBskwJP6s8NJpvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer; spf=pass smtp.mailfrom=riley.engineer; dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b=F6E2nrM6; arc=none smtp.client-ip=185.70.40.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=riley.engineer
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=riley.engineer
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=riley.engineer header.i=@riley.engineer header.b="F6E2nrM6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=riley.engineer;
	s=protonmail3; t=1715386817; x=1715646017;
	bh=ass7r/RVBOGIwffVjLMMfsVgMqBfLFwvEzUd7peuSRk=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=F6E2nrM6/wzn0F8vB2E/xOltCy2GmXsw3tZ8e4QSc/vjb3CGvEj6h3YPMY4ITnXS3
	 qbTo+DgRA0ylDeGoX0bcASTs+NvxoUFaxM4cD+OZhIokYvVViX07lX+j1p0S8Ha1I5
	 mC4g8BwHz3FqsBVDCu6pV/vt6vZmJW8QN+XUdQxwR2fJHlh5G+mHrI37oaTj0dkIzf
	 gd3rBfOi6xt+d+yYejP5HFZw/gBmfONLG/dvISF5ylA+w9NbRIWKmypFCFgtkUgEn2
	 Cnj6P8Ky+sAoLWI6ylLcc/WoHfYNi0JRY7QT8UFZYcF5wzW2lIt2bDQ/01GcCwhs05
	 UEpVKUzAsRb+w==
Date: Sat, 11 May 2024 00:20:12 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: Reed Riley <reed@riley.engineer>
Subject: [PATCH] bcachefs: support REMAP_FILE_DEDUP in bch2_remap_file_range
Message-ID: <yuG-zWAd7xX9SkysCfG2ELC8drJi3bxsagrf03hf2Aeah__0W1exPDJabqC23NyOzt5BXmYEF95045yO2SfCbZMgGkYqbycmlUIBZqk2vyE=@riley.engineer>
Feedback-ID: 15554401:user:proton
X-Pm-Message-ID: a852556667f6c6b006e42d0fa922d6bfd853c129
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

By removing the early-exit when REMAP_FILE_DEDUP is set, we should be
able to support the fideduperange ioctl, albeit less efficiently than if
we handled some of the extent locking and comparison logic inside
bcachefs.  Extent comparison logic already exists inside of
`__generic_remap_file_range_prep`.

Signed-off-by: Reed Riley <reed@riley.engineer>
---
 fs/bcachefs/fs-io.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/bcachefs/fs-io.c b/fs/bcachefs/fs-io.c
index 20b40477425f..4f513f22a66a 100644
--- a/fs/bcachefs/fs-io.c
+++ b/fs/bcachefs/fs-io.c
@@ -857,9 +857,6 @@ loff_t bch2_remap_file_range(struct file *file_src, lof=
f_t pos_src,
        if (remap_flags & ~(REMAP_FILE_DEDUP|REMAP_FILE_ADVISORY))
                return -EINVAL;
=20
-       if (remap_flags & REMAP_FILE_DEDUP)
-               return -EOPNOTSUPP;
-
        if ((pos_src & (block_bytes(c) - 1)) ||
            (pos_dst & (block_bytes(c) - 1)))
                return -EINVAL;
--=20
2.44.0

