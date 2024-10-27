Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D20FB6FB6;
	Sun, 27 Oct 2024 19:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730055617; cv=none; b=uPRfPStNlnTX9EWFHJH8GEbC92lgnyc6ojtdDLXciF5YMb1zv0Y8TjN9EdhDsELSzs6cp3FYosq6sm60jLMNHiKYGZedovSkS5L4VZ9Ic/zYlGCJlrMBKTdbf0wUO4WOdamvYZJiI9pwTyu12Ef5k3pxe/bVyqcq9glboVJh+ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730055617; c=relaxed/simple;
	bh=oXfsMzfLH5+0CftdcPlOInwf8zLm0ueqge6ZlGLUP8I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d+Esw0ilovQXkAg8pd+fDWJft64p5720bOPtorLrvZrOMvUEsAYpXBldGMcNsAwlUHKvShYzj0r2rBbthsMGJWH1d3saQ70c/+qSIjH8CM3w5W2XPKBWe/XczjnHp/UYlzZXQXuJalZZ9QjH6J0EJKtPvlTpGKAitaJwBoX1W5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=ZKglY7lo; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="ZKglY7lo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1730055611; x=1730314811;
	bh=oXfsMzfLH5+0CftdcPlOInwf8zLm0ueqge6ZlGLUP8I=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZKglY7loz1wqv2M0FhqyGMhmRqdLeH/FX9aWqalh9flgQdFEs+SOnU+lDDvsonxfG
	 5AkaVArjwfcIhqd+9oObqemWKzdOQ00KBRdAKETTqpJI4Ofd6lSIVe1eVUsbz1m6D4
	 QO8JDG7qK4sKHWroSabldw2TXCAGb90mzP5s4yOYnSMRbU5RWPHxRt0/j+gZtNNfkA
	 EJryZeYAZ4RoOinbZ+tiU3AEUjfKSkX2vgZBt6w2rexj33n+cJiKg3mU7xeYC22uO9
	 C8tJytscC3FA/nirVxkUNhWHfsRr+/SSoFcfre1M96wKNeZWxtSt/GpjCV5Jt95Km6
	 5sjefEH1cewAA==
Date: Sun, 27 Oct 2024 19:00:07 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com, Alan Huang <mmpgouride@gmail.com>
Subject: Re: [PATCH v2] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <KoKsgyv6vBuqwCj7ZnzZNWLYuQ_2LAfUUp3Eq8m9RkIS8hQOCpszlKj1BbYO8Md844-U-h2bmQJZtlTptr2-lKzYVdFtWy_BMejp5uPpjz4=@proton.me>
In-Reply-To: <vzmzlzbxlyapymoccpniahd6kajrtumz7zenn4fuess6kta3qc@kbtsbr3lnl73>
References: <20241026174155.233430-3-pZ010001011111@proton.me> <j3aypufmcezitilxlgkfyetnonkzlkst3hx4zxr4zspfonh5pm@mwngtgo4h4vb> <BdSD2g3SGfWQrsTULTjViyG_t0llBh4NeIVbIE_3pvf1bWxk52ErCdP5yOErBZO3NkhyOv9Mgq2xc6CsGFliqDQrTgTwoquYKJKEUY5OE9g=@proton.me> <vzmzlzbxlyapymoccpniahd6kajrtumz7zenn4fuess6kta3qc@kbtsbr3lnl73>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 19754784f6c1991427663cc034d8c25d24b49ae9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable






Sent with Proton Mail secure email.

On Sunday, October 27th, 2024 at 6:53 PM, Kent Overstreet <kent.overstreet@=
linux.dev> wrote:

> On Sun, Oct 27, 2024 at 11:34:02AM +0000, Piotr Zalewski wrote:
>=20
> > On Sunday, October 27th, 2024 at 2:28 AM, Kent Overstreet kent.overstre=
et@linux.dev wrote:
> >=20
> > > On Sat, Oct 26, 2024 at 05:46:33PM +0000, Piotr Zalewski wrote:
> > >=20
> > > > Add NULL check for key returned from bch2_btree_and_journal_iter_pe=
ek in
> > > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > > bch2_bkey_buf_reassemble.
> > > >=20
> > > > When key returned from bch2_btree_and_journal_iter_peek is NULL it =
means
> > > > that btree topology needs repair. Print error message with position=
 at
> > > > which node wasn't found and its parent node information. Call
> > > > bch2_topology_error and return error code returned by it to ensure =
that
> > > > topology error is handled properly.
> > > >=20
> > > > Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> > > > Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97=
657
> > > > Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> > > > Suggested-by: Alan Huang mmpgouride@gmail.com
> > > > Suggested-by: Kent Overstreet kent.overstreet@linux.dev
> > > > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > > > ---
> > > >=20
> > > > Notes:
> > > > changes in v2:
> > > > - make commit message more verbose.
> > > > - set topology error, print error message and return
> > > > appropriate error code.
> > > >=20
> > > > link to v1: https://lore.kernel.org/linux-bcachefs/20241023072024.9=
8915-3-pZ010001011111@proton.me/
> > > >=20
> > > > fs/bcachefs/btree_iter.c | 13 +++++++++++++
> > > > 1 file changed, 13 insertions(+)
> > > >=20
> > > > diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> > > > index 15ac72b1af51..40c824779b15 100644
> > > > --- a/fs/bcachefs/btree_iter.c
> > > > +++ b/fs/bcachefs/btree_iter.c
> > > > @@ -880,6 +880,18 @@ static noinline int btree_node_iter_and_journa=
l_peek(struct btree_trans *trans,
> > > > __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l=
->iter, path->pos);
> > > >=20
> > > > k =3D bch2_btree_and_journal_iter_peek(&jiter);
> > > > + if (!k.k) {
> > > > + struct printbuf buf =3D PRINTBUF;
> > > > +
> > > > + prt_str(&buf, "node not found at pos ");
> > > > + bch2_bpos_to_text(&buf, path->pos);
> > > > + prt_str(&buf, " within parent node ");
> > > > + bch2_bkey_val_to_text(&buf, c, bkey_i_to_s_c(&l->b->key));
> > > > +
> > > > + ret =3D bch2_fs_topology_error(c, "%s", buf.buf);
> > > > + printbuf_exit(&buf);
> > > > + goto err;
> > > > + }
> > >=20
> > > We'll want to add at least the btree ID and level to that.
> > >=20
> > > Could you also look over the other places we report topology errors a=
nd
> > > inconstencies for any commonality? btree_cache.c has some stuff, and =
I
> > > think there's a helper in there that might give you the error message
> > > you want (instead of just the btree node key), and I'd have a glance =
at
> > > the topology error reporting in btree_update_interior.c and btree_gc.=
c
> > > as well.
> >=20
> > I scanned through mentioned files and some others. There are commonalit=
ies
> > but every error message seem to be different in some way so that there =
is
> > no truly common part.
> >=20
> > Information contained is usually a mixture of:
> > - btree id and level.
> > - position at which node wasn't found or if it was found but something
> > else is wrong its key info.
> > - parent node key information.
> > - prev/next node key info.
> > - min/max key pos info.
> >=20
> > Only appropriate helpers I found were (what I already used) -
> > bch2_fs_topology_error and, in btree_iter.c, bch2_btree_path_to_text_sh=
ort
> > but there it doesn't print full parent key info just min_key pos and pa=
rent
> > key pos so I'm not sure.
> >=20
> > To what you already said I could also add min pos info.
>=20
> bch2_btree_pos_to_text()?

Ah yes, I missed it - not used in many places and ending similar to=20
bpos_to_text. I will print path->pos + bch2_btree_pos_to_text() in the next
version then.
