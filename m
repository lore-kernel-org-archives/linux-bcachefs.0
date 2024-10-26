Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F5923A6
	for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 17:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729964805; cv=none; b=biknbkCGeKTm2a6Xpo4+9qFSkQOw1NeaIrpYlQzi1Szg+wizCDB8ZgDm2d6SJNvXpnvuLtcFtxxlNkSTOXg2G070YS0YCBF88kVBgDMUEk7LaOD9QTWeq0sdTSWyydtV2kNpnXGYT3DsZ4Ua58KjncWVZC5LGcGSjdN+uH0u81M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729964805; c=relaxed/simple;
	bh=iK2ETm0wcmmrbAj8oW9oXQLntNSb0wUcwLYcXgB2wUk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=hgfvQC5OoyYOPipo9ck039M/0WBRYVs3Kd/CgVCQ6yQC/pl4IBGdjwLXK0BfJCIL+1L1F+ANy0+6aPRVfrK3YT8XXInrdmR61rIr6fp0bYSij4EumqQq5FxjkrBD71jdfgiQk7JYpHpMr7ou2zxSAhx/wcJsaihgkJS0CHI6no8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=jHtLJdbU; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="jHtLJdbU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729964800; x=1730224000;
	bh=tuQGb8EqIUx378UeCmNYLD8fdTFIKGwhhmJKBCspH2Y=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=jHtLJdbUDhNhbIr561dZPJHTluZl4ltVJRW7dj3SLqz4Fwi5cEEegbsmiOkswuzAV
	 psew9W7S7zGw/0CYhkm8uenkqQH+2kVedZW9TzeH+Bwg1NYVXHepRi8eAD9D+X+7if
	 p+orZf1ZlZPuSqLztB+3Ya616wNSJk7OyJXSfvFjC8bWYh/EbtiU9dQ4DCn0LNpOOY
	 xgXPX+pvAYMZ9of0ts/FzeZrH+U5JJwP9SugSJ+iet1sEJCX3/ANBu9sw7fSg+TUt1
	 D+GqHCxTWAWGBJy+w1dT8gVzn5Jxq3PP7f5AarvDvAmj2Bn3IVz5Ti4/dbADinaR0T
	 10BojcRuVGt6Q==
Date: Sat, 26 Oct 2024 17:46:33 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v2] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <20241026174155.233430-3-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 43d449c52e690306e9d7c82fde7a628aa1b10356
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

When key returned from bch2_btree_and_journal_iter_peek is NULL it means
that btree topology needs repair. Print error message with position at
which node wasn't found and its parent node information. Call
bch2_topology_error and return error code returned by it to ensure that
topology error is handled properly.

Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
Suggested-by: Alan Huang <mmpgouride@gmail.com>
Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---

Notes:
    changes in v2:
        - make commit message more verbose.
        - set topology error, print error message and return
          appropriate error code.

    link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.98915=
-3-pZ010001011111@proton.me/

 fs/bcachefs/btree_iter.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 15ac72b1af51..40c824779b15 100644
--- a/fs/bcachefs/btree_iter.c
+++ b/fs/bcachefs/btree_iter.c
@@ -880,6 +880,18 @@ static noinline int btree_node_iter_and_journal_peek(s=
truct btree_trans *trans,
 =09__bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->it=
er, path->pos);
=20
 =09k =3D bch2_btree_and_journal_iter_peek(&jiter);
+=09if (!k.k) {
+=09=09struct printbuf buf =3D PRINTBUF;
+
+=09=09prt_str(&buf, "node not found at pos ");
+=09=09bch2_bpos_to_text(&buf, path->pos);
+=09=09prt_str(&buf, " within parent node ");
+=09=09bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&l->b->key));
+
+=09=09ret =3D bch2_fs_topology_error(c, "%s", buf.buf);
+=09=09printbuf_exit(&buf);
+=09=09goto err;
+=09}
=20
 =09bch2_bkey_buf_reassemble(out, c, k);
=20
@@ -887,6 +899,7 @@ static noinline int btree_node_iter_and_journal_peek(st=
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


