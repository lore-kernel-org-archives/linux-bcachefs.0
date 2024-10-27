Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56163126C18
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 19:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730058426; cv=none; b=MVcujsTiP7D6s8h9QbGOw3iQPZO/YBXLuc67FZTXXkLAX49S4tfjH7lPDA7AWQ0z3iPRKqs5aoIv+FTR5kwhMwBmx6KnPdUZKtm5qQxEKB2zz7sRlk7MpPTmMXAPnWiDmTLh5FkUuSJVQfq9l+LNiMve4q/RRmaLGZuL6C7BWdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730058426; c=relaxed/simple;
	bh=yx7OKnMmxkaItU6s2bHO2Y8kAkumLtwqxfzQ1PKIJsk=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=V2NS6+5wkfK60G7LEVh0pP6laEYzxW4md19ky1gJ8sI5iicGMeVACyOa1WjAMfDjv59wJTwjh3z3BfvPga/lRNaykVpYBsqFelIKzMA21+JuklcIxdIpVt8BMdHwW+wzeL6sY1bFLTIbUEm2nLhMiM0qEo3Vqa6ruFh0eXzgMjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=hpQ68OKH; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="hpQ68OKH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1730058415; x=1730317615;
	bh=rBYrbCgFaMolyV5f9SMDe1X9M83MQXaQsQ9KhjScgm8=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=hpQ68OKH1Gr44wXmFZstKys8hQ2dYMfEYJ1tF8ZrZ63IkixSPIzi+4RbDIgAhfJtu
	 sbhR6xOuClADk8Cur6YrIGtms84MoO7gBxe4wbilaUCTVFstIOiX0Hz8QMC6NnubJ6
	 JhMb4EWgn4Wf8TSyVvz6bM/VRw98gK+62inxSttHQdAEQWAkkzOcfIY1tPlYGvC9S0
	 1A6zON80wj0HuC0BRoMYWgorP2cg/xq55CjAz6HCXJlZpUOGPyHoaLgjIIekD3K1zH
	 XUNWmZbyE/u1FgoEuWiItTLsNFA+y5oxy50OG81UuZkCIR2Dam7R44ba83T7C/56q0
	 jXiWR2859DK0Q==
Date: Sun, 27 Oct 2024 19:46:52 +0000
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: skhan@linuxfoundation.org, Piotr Zalewski <pZ010001011111@proton.me>, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, Alan Huang <mmpgouride@gmail.com>
Subject: [PATCH v3] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <20241027193842.154220-2-pZ010001011111@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 1b0b1b9852f05303eac84019b51a819f66b46bad
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
that btree topology needs repair. Print topology error message with
position at which node wasn't found, its parent node information and
btree_id with level.

Return error code returned by bch2_topology_error to ensure that topology
error is handled properly by recovery.

Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
Suggested-by: Alan Huang <mmpgouride@gmail.com>
Suggested-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Piotr Zalewski <pZ010001011111@proton.me>
---

Notes:
    changes in v3:
        - add btree_id and level info to the error message.
        - use bch2_btree_pos_to_text.

    changes in v2:
        - make commit message more verbose.
        - set topology error, print error message and return
          appropriate error code.

    link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.98915=
-3-pZ010001011111@proton.me/
    link to v2: https://lore.kernel.org/linux-bcachefs/20241026174155.23343=
0-3-pZ010001011111@proton.me/

 fs/bcachefs/btree_iter.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
index 15ac72b1af51..acf70aaf2fd2 100644
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
+=09=09prt_str(&buf, " at btree ");
+=09=09bch2_btree_pos_to_text(&buf, c, l->b);
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


