Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7E13A8D0;
	Wed, 23 Oct 2024 07:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668131; cv=none; b=UqYeAOvwkCCauMhJdv5Cya9+qmzON4OkRtez2d0dsyomgDnso9uELTfawfXR56wsCTyUJBZJmFR7w4heMznqrUqlBp6uqjg8wts6oSajd3qr0HeOKPJPM51u71NJfE7oPiujMSsw4erFQhQv9sKfap29kfq5EukhcdQ5dyaAIs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668131; c=relaxed/simple;
	bh=vmCCpBWtyQO456rrpb/uNtHpMBrnPhyry9lsdRfwOK4=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=iHGJanFlvmK/HQavc+YKj9cBgH9JEtbbGTvfbGIOfmuAvkdgw+S8hThN80F2KfqJiXD5JOt/m+jUrMEg0hpDcP7nFz0hiQqriEcP7sehnlJA9EWvpLhQ7PEzfPECRMXgMy8S6hF7Z6HD7rhpPosujIvQTqzDTZlI39cHDuZZz0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=AMoRPhGt; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="AMoRPhGt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=j4atiai7njgmphwnxlbm5jfqpe.protonmail; t=1729668121; x=1729927321;
	bh=/zMQmuixlJjVrXyyIswg+Zp63Geeipwo7ZNgEDUsULo=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=AMoRPhGtBZvCu7MhINLGcMdFzgTzjT3HuaRVgwtlSa6ZI1mm+sxHsxMeBJnS4jzOS
	 6G2OsqQoAJEP3sqzjI/SHZtN6s+Ts1X8u/fpIaeIPsLsfKIoFhvQ98iqFgSE46ICwx
	 vLR86yxXmBv4b0y7NzhqF4eaSFIFTa5VLJSKAKItnKb3rToh9Z5H7LVXtFh6ZgpKNH
	 8JOCyK+01GZHbLH3Wu2dvxpoB9o62NQdbg5YtKXFwYENPKM0fr3Uufnra5iEnF4MZj
	 gIstqhViCbdEGQiMvmauYTzw2xfc/poB0/+v5Vm9siWoVDfeCsr+xVH4YA1cJ7d2oY
	 +k3O/k0fBED/Q==
Date: Wed, 23 Oct 2024 07:21:57 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: [PATCH] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <20241023072024.98915-3-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 9e4e4839818527cc4489e3f49e7a3deeb98759fa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Add NULL check for key returned from bch2_btree_and_journal_iter_peek in
btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
bch2_bkey_buf_reassemble.

Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---
 fs/bcachefs/btree_iter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 0883cf6e1a3e..625167ce191f 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -882,6 +882,8 @@ static noinline int btree_node_iter_and_journal_peek(st=
ruct btree_trans *trans,
 =09__bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->it=
er, path->pos);
=20
 =09k =3D bch2_btree_and_journal_iter_peek(&jiter);
+=09if (!k.k)
+=09=09goto err;
=20
 =09bch2_bkey_buf_reassemble(out, c, k);
=20
@@ -889,6 +891,7 @@ static noinline int btree_node_iter_and_journal_peek(st=
ruct btree_trans *trans,
 =09    c->opts.btree_node_prefetch)
 =09=09ret =3D btree_path_prefetch_j(trans, path, &jiter);
=20
+err:
 =09bch2_btree_and_journal_iter_exit(&jiter);
 =09return ret;
 }
--=20
2.47.0


