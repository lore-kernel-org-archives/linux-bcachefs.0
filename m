Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5BE136341;
	Sun, 27 Oct 2024 11:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730028859; cv=none; b=nxPFnHce/JZTIRu94LWTJgHZdIsByHmF9xuFzjYBHRrE4JTvX7s8qQafAUzU92LE2VMilsIhLH1Qp8QNuDjNajTZd4hy9XhNlA9ForiQJ6cWZTzR3xA5Ijuo8iPe7Gf4k1PunukCuYhf534VDpntD3b0gQ4GPCcsrgR2S0HI4nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730028859; c=relaxed/simple;
	bh=78MIXJvqsJKNYdM8h6v7qXpSCE+jirw0EjvKfXwrgTk=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIXL4Nc4edN7a99emrwNm97Gh79Qth3bquqJ8BV5z53/DVVAg9Fc9BPQ3KChLvyLVA5wm+1Gy/LzMNNwBUlyap6nPIpHrY3UgIyvuRIFqrYnIwjnwfR/Xws1MeHxw2cjjhkxuoXguhwC3R9WPgSLdF8VA/mAoPep+mvUsL0by+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=bUfjgUtA; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="bUfjgUtA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1730028847; x=1730288047;
	bh=bp6yKTLVrGgMMzbBVeGIBaajjOi243EDgC03o0jsoV8=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=bUfjgUtAB4HpAXaHZcr2MXQ3Tdi1FzuHjNQpiQ/JoyCXmQA3vI2FBxhpHCuyYVQxk
	 iM4lTBDC6Gc8gQ5SZYEvtydKgFTYW/luqzBseo0SXg2c3D9xBXO23kgVF6F5OQyfY0
	 l+rn6jgOstOgLebon+YcA1cbqdTGCpMl0CTSnlw+fi99BWGUDzBOPDlz9HpmGXIKW9
	 BNyUbLrH6B0pejgfamL9MFSA0mX27tsP9jEuzToIzJV9Yjk0TFSbi6VdZ2gmGxb5LP
	 FEL/sOHWwDe0o0oAyyFkfsiiwcbT0alqCQhD07mgzUJee7viO1qckYdrARsTuHE2Ui
	 N2LG7MHMQSEng==
Date: Sun, 27 Oct 2024 11:34:02 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, Alan Huang <mmpgouride@gmail.com>
Subject: Re: [PATCH v2] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <BdSD2g3SGfWQrsTULTjViyG_t0llBh4NeIVbIE_3pvf1bWxk52ErCdP5yOErBZO3NkhyOv9Mgq2xc6CsGFliqDQrTgTwoquYKJKEUY5OE9g=@proton.me>
In-Reply-To: <j3aypufmcezitilxlgkfyetnonkzlkst3hx4zxr4zspfonh5pm@mwngtgo4h4vb>
References: <20241026174155.233430-3-pZ010001011111@proton.me> <j3aypufmcezitilxlgkfyetnonkzlkst3hx4zxr4zspfonh5pm@mwngtgo4h4vb>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 6da5b59290d5712c3fdcd7360d119869e3236f8d
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sunday, October 27th, 2024 at 2:28 AM, Kent Overstreet <kent.overstreet@=
linux.dev> wrote:

> On Sat, Oct 26, 2024 at 05:46:33PM +0000, Piotr Zalewski wrote:
>=20
> > Add NULL check for key returned from bch2_btree_and_journal_iter_peek i=
n
> > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > bch2_bkey_buf_reassemble.
> >=20
> > When key returned from bch2_btree_and_journal_iter_peek is NULL it mean=
s
> > that btree topology needs repair. Print error message with position at
> > which node wasn't found and its parent node information. Call
> > bch2_topology_error and return error code returned by it to ensure that
> > topology error is handled properly.
> >=20
> > Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
> > Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> > Suggested-by: Alan Huang mmpgouride@gmail.com
> > Suggested-by: Kent Overstreet kent.overstreet@linux.dev
> > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > ---
> >=20
> > Notes:
> > changes in v2:
> > - make commit message more verbose.
> > - set topology error, print error message and return
> > appropriate error code.
> >=20
> > link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.98915=
-3-pZ010001011111@proton.me/
> >=20
> > fs/bcachefs/btree_iter.c | 13 +++++++++++++
> > 1 file changed, 13 insertions(+)
> >=20
> > diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> > index 15ac72b1af51..40c824779b15 100644
> > --- a/fs/bcachefs/btree_iter.c
> > +++ b/fs/bcachefs/btree_iter.c
> > @@ -880,6 +880,18 @@ static noinline int btree_node_iter_and_journal_pe=
ek(struct btree_trans *trans,
> > __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->it=
er, path->pos);
> >=20
> > k =3D bch2_btree_and_journal_iter_peek(&jiter);
> > + if (!k.k) {
> > + struct printbuf buf =3D PRINTBUF;
> > +
> > + prt_str(&buf, "node not found at pos ");
> > + bch2_bpos_to_text(&buf, path->pos);
> > + prt_str(&buf, " within parent node ");
> > + bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&l->b->key));
> > +
> > + ret =3D bch2_fs_topology_error(c, "%s", buf.buf);
> > + printbuf_exit(&buf);
> > + goto err;
> > + }
>=20
>=20
> We'll want to add at least the btree ID and level to that.
>=20
> Could you also look over the other places we report topology errors and
> inconstencies for any commonality? btree_cache.c has some stuff, and I
> think there's a helper in there that might give you the error message
> you want (instead of just the btree node key), and I'd have a glance at
> the topology error reporting in btree_update_interior.c and btree_gc.c
> as well.

I scanned through mentioned files and some others. There are commonalities
but every error message seem to be different in some way so that there is=
=20
no truly common part.

Information contained is usually a mixture of:
  - btree id and level.
  - position at which node wasn't found or if it was found but something=20
    else is wrong its key info.
  - parent node key information.
  - prev/next node key info.
  - min/max key pos info.

Only appropriate helpers I found were (what I already used) -=20
bch2_fs_topology_error and, in btree_iter.c, bch2_btree_path_to_text_short
but there it doesn't print full parent key info just min_key pos and parent
key pos so I'm not sure.

To what you already said I could also add min pos info.

> > bch2_bkey_buf_reassemble(out, c, k);
> >=20
> > @@ -887,6 +899,7 @@ static noinline int btree_node_iter_and_journal_pee=
k(struct btree_trans *trans,
> > c->opts.btree_node_prefetch)
> > ret =3D btree_path_prefetch_j(trans, path, &jiter);
> >=20
> > +err:
> > bch2_btree_and_journal_iter_exit(&jiter);
> > return ret;
> > }
> > --
> > 2.47.0
