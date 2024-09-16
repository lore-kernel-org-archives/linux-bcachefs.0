Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5DB14A09C
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Sep 2024 22:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726526886; cv=none; b=r9h8F9OwnbDMQu+k85QPrCL2xGnw9EM/TI3w6Sevi5aGRNggNaesoLh867r1HGhLZlI696nrYf77p/eaa8z82xJ1twkT1cdN1m5HwV1cGpodegGxhCcVMb5EYSremJhNiH10qp3u0DWwf17j8wofQ/BK36QLOpz7/b5ozRSfGZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726526886; c=relaxed/simple;
	bh=ThItjMszJ9i/A9tdAMi/YBdMUn/8JQNKAh1bvpVs7uk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=m1lHb4NoanK9UwXTFG7CNrQ1mhXTo9y7O+h0X6dDkKCZs5w0nLs7ZHp/2HXdnjRi2BCnVcCdSa5/ZGGWB9JxcpUuXi/bdDepvued+7zUnoKvQOmfBHinEwozviyxBa/foUx8y3tnXxz3rhXaUWPXhOg+pebYWJjV+wWkb+3f+So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=HMs+FpiF; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="HMs+FpiF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=4g6nhvjwt5cdlp654twaomoow4.protonmail; t=1726526880; x=1726786080;
	bh=ThItjMszJ9i/A9tdAMi/YBdMUn/8JQNKAh1bvpVs7uk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HMs+FpiFNp796OsqOK5Y8i7prLB+e5BSfcO/o9BOvlvl7dopQEO8Dx9jyJg6izPig
	 9f0rXBTFFKPok6/M4SaF6BJNf/I/0XAQejF0xGeYTBt6/Yi197ApdbD6nfS1fQgW7T
	 xAcCvbD0O/himPjFkRWO4dIbJFW8noInOUUn04nVHFuccyEP9g0lG1ytNyo+Ae43Ly
	 VI9hmiaqFiWrwPG4aJA8ITxiOOLMRVbkkst/9aHIcw87garUCglpUdH6ljlQU0LTZ8
	 tUsXYvK8Q20nfAqPEO7iAy4kOx7YhHqk24LC8QQENYhglSNJR0VmmhGkDWNjS+OCiX
	 tZirdqHB69sOA==
Date: Mon, 16 Sep 2024 22:47:57 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>
Subject: [PATCH] bcachefs: add GFP_ZERO flag in btree_bounce_alloc
Message-ID: <20240916224746.692973-1-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 2aa1de423e1f5afeabaf56fb3170c153b965b5a3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add __GFP_ZERO flag to kvmalloc call in btree_bounce_alloc to mitigate
later uinit-value use KMSAN warning[1].

After applying the patch reproducer still triggers stack overflow[2] but
it seems unrelated to the uninit-value use warning. After further
investigation it was found that stack overflow occurs because KMSAN adds
additional function calls. Backtrace of where the stack magic number gets=
=20
smashed was added as a reply to syzkaller thread[3].

I confirmed that task's stack magic number gets smashed after the code path
where KSMAN detects uninit-value use is executed, so it can be assumed that
it doesn't contribute in any way to uninit-value use detection.

[1] https://syzkaller.appspot.com/bug?extid=3D6f655a60d3244d0c6718
[2] https://lore.kernel.org/lkml/66e57e46.050a0220.115905.0002.GAE@google.c=
om
[3] https://lore.kernel.org/all/rVaWgPULej8K7HqMPNIu8kVNyXNjjCiTB-QBtItLFBm=
k0alH6fV2tk4joVPk97Evnuv4ZRDd8HB5uDCkiFG6u81xKdzDj-KrtIMJSlF6Kt8=3D@proton.=
me

Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---
 fs/bcachefs/btree_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/btree_io.c b/fs/bcachefs/btree_io.c
index 56ea9a77cd4a..3ac8b37f97d7 100644
--- a/fs/bcachefs/btree_io.c
+++ b/fs/bcachefs/btree_io.c
@@ -121,7 +121,7 @@ static void *btree_bounce_alloc(struct bch_fs *c, size_=
t size,
 =09BUG_ON(size > c->opts.btree_node_size);
=20
 =09*used_mempool =3D false;
-=09p =3D kvmalloc(size, __GFP_NOWARN|GFP_NOWAIT);
+=09p =3D kvmalloc(size, __GFP_ZERO|__GFP_NOWARN|GFP_NOWAIT);
 =09if (!p) {
 =09=09*used_mempool =3D true;
 =09=09p =3D mempool_alloc(&c->btree_bounce_pool, GFP_NOFS);
--=20
2.46.0


