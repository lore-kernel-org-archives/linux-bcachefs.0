Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA29215788
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743087016; cv=none; b=qqewlXdZF7xAdzh3DPD3fr2+uuRylM4Xbk/wHm64+iAEW4pcQLcaQF8yE9zKs1mXLFnlqKwLcZhDNL2ewc74hrDhHxTJ5Y3xLb3f8AS2wukvo0lehTZ5YO4XZU7qftTcQfNU/pD7jsgftUJg7EEBgWxBB781cMCUoV8/++LX5dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743087016; c=relaxed/simple;
	bh=ixowdw3/tBH1MKs5lErEbKIY7YjR630dlJ2HH1jf3qA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EkCf9wExebre757eJtpi8WIL5wNhP4NbYGN3aWBhScBYHEx+lfC9ZXEDnif655xcp6Qn73EWpQfKgHO4xFA327wjZ/mc2f8S19FCBl6iT0+Rb4MOSWvgVImplwXO64YAwX7Pq4gFUAm8e2oegaPlVGaGk/qph1/zoKDz2b3VP4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=F7orR4wr; arc=none smtp.client-ip=109.224.244.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="F7orR4wr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1743087012; x=1743346212;
	bh=ixowdw3/tBH1MKs5lErEbKIY7YjR630dlJ2HH1jf3qA=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector:List-Unsubscribe:List-Unsubscribe-Post;
	b=F7orR4wrE72aQbPzGmqnOiPkwLePLaUAq4hPaWMjLJbCKtYm5dh8xp6Lmoitsj4LV
	 6JCrlez0LOVkt6Z9jEyXpK0aVInXdigdYSs5sKhDmwJ5kJN9ifeZQMqRWTquwNET+b
	 Lt6ykNIK5x7xQe1jGRjLbOdEK4Ryj9VQarDojJkTGlb51btIh1mBa6UiZv03akXgHx
	 DqdSpKEcp2NIRbsxjsWq7q5X/4duIwh1HX0nGbkAblXOOVGhR9XfFZRGiroX+AFqtG
	 XulK3+1GK1NP0RqWlZU9yBq3iyovituBGDJ0Cs10lJRr/IiIOGnVXfLSdyq0ndZdpH
	 GWPOOp9O1xs/A==
Date: Thu, 27 Mar 2025 14:50:09 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
Cc: mmpgouride@gmail.com, skhan@linuxfoundation.org, linux-kernel-mentees@lists.linux.dev
Subject: [PATCH v2 2/2] bcachefs: replace memcpy with memcpy_and_pad for jset_entry_log->d buff
Message-ID: <20250327144956.1974622-3-nicolescu.roxana@protonmail.com>
In-Reply-To: <20250327144956.1974622-1-nicolescu.roxana@protonmail.com>
References: <20250327144956.1974622-1-nicolescu.roxana@protonmail.com>
Feedback-ID: 136600343:user:proton
X-Pm-Message-ID: 47f30f9e3d6a452ed1ff7232a536c31303ac39d8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This was achieved before by zero-ing out the source buffer and then
copying the bytes into the destination buffer. This can also be done with
memcpy_and_pad which will zero out only the destination buffer if its
size is bigger than the size of the source buffer. This is already used in
the same way in journal_transaction_name().

Moreover, zero-ing the source buffer was done twice, first in
__bch2_fs_log_msg() and then in bch2_trans_log_msg(). And this method
may also require allocating some extra memory for the source buffer.

In conclusion, using memcpy_and_pad is better even tough the result is
the same because it brings uniformity with what's already used in
journal_transaction_name, it avoids code duplication and reallocating
extra memory.

Signed-off-by: Roxana Nicolescu <nicolescu.roxana@protonmail.com>
---
 fs/bcachefs/btree_update.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/bcachefs/btree_update.c b/fs/bcachefs/btree_update.c
index 13d794f201a5..97495b79ca93 100644
--- a/fs/bcachefs/btree_update.c
+++ b/fs/bcachefs/btree_update.c
@@ -826,7 +826,6 @@ int bch2_btree_bit_mod_buffered(struct btree_trans *tra=
ns, enum btree_id btree,
 int bch2_trans_log_msg(struct btree_trans *trans, struct printbuf *buf)
 {
 =09unsigned u64s =3D DIV_ROUND_UP(buf->pos, sizeof(u64));
-=09prt_chars(buf, '\0', u64s * sizeof(u64) - buf->pos);
=20
 =09int ret =3D buf->allocation_failure ? -BCH_ERR_ENOMEM_trans_log_msg : 0=
;
 =09if (ret)
@@ -839,7 +838,7 @@ int bch2_trans_log_msg(struct btree_trans *trans, struc=
t printbuf *buf)
=20
 =09struct jset_entry_log *l =3D container_of(e, struct jset_entry_log, ent=
ry);
 =09journal_entry_init(e, BCH_JSET_ENTRY_log, 0, 1, u64s);
-=09memcpy(l->d, buf->buf, buf->pos);
+=09memcpy_and_pad(l->d, u64s * sizeof(u64), buf->buf, buf->pos, 0);
 =09return 0;
 }
=20
@@ -852,7 +851,6 @@ __bch2_fs_log_msg(struct bch_fs *c, unsigned commit_fla=
gs, const char *fmt,
 =09prt_vprintf(&buf, fmt, args);
=20
 =09unsigned u64s =3D DIV_ROUND_UP(buf.pos, sizeof(u64));
-=09prt_chars(&buf, '\0', u64s * sizeof(u64) - buf.pos);
=20
 =09int ret =3D buf.allocation_failure ? -BCH_ERR_ENOMEM_trans_log_msg : 0;
 =09if (ret)
@@ -865,7 +863,7 @@ __bch2_fs_log_msg(struct bch_fs *c, unsigned commit_fla=
gs, const char *fmt,
=20
 =09=09struct jset_entry_log *l =3D (void *) &darray_top(c->journal.early_j=
ournal_entries);
 =09=09journal_entry_init(&l->entry, BCH_JSET_ENTRY_log, 0, 1, u64s);
-=09=09memcpy(l->d, buf.buf, buf.pos);
+=09=09memcpy_and_pad(l->d, u64s * sizeof(u64), buf.buf, buf.pos, 0);
 =09=09c->journal.early_journal_entries.nr +=3D jset_u64s(u64s);
 =09} else {
 =09=09ret =3D bch2_trans_commit_do(c, NULL, NULL, commit_flags,
--=20
2.34.1


