Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA201FCC66
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729899587; cv=none; b=OD7HD/Wt+awGCIDAfX45PWgSOyBKsxU9E4sNigWwOnJEZ9SzMP2tOyu5msbAQlhwvRNaehMA/rDKZteIkPjtkFQ1JtjrXXfbTT+tSbTnweg0XTog8hIKEjHwqqUx++v27nxGDeLt1AlJmoCEAeGTJfhcL2YMXMt7oBY2Cv6h/oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729899587; c=relaxed/simple;
	bh=IW7vPXI7BVX8NzADDiT5aIc+IieWqSCcKo2tzaVRMfg=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ShcgdZt7qo7WIjnkKv4UPfqtO/HqObJhHRXVPE02tmIOcinEEpEbHluvHYUlL3AVM2G9M34G3PDzhftaYUj+plSwBr2PEBZPEKlvHNHBJxquzTsK0z/VTQX67egk6d5i5vPiF/Q5K1aWiIEjhhVrBkxrZiOJKpZ1gWCAL+MmifQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=Z2xyqHvq; arc=none smtp.client-ip=185.70.43.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="Z2xyqHvq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729899582; x=1730158782;
	bh=l0pfVjigw5ZvqCB21r+SsSYkMhK0lEHs2lWzwtPAAUc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Z2xyqHvqPl73wgY/2PJ+SqofoNcYRkexzO/IHM1Q3SM2gWZ6XFJ5l66oF6y041J69
	 8GnWwTPx/0NjTpr353Kkb6fPqAln7005ZcGdyW4jsPBQnlusDSSutJLrP4wNe8DofE
	 sy7FBidg+OK6LsR8Yz1RsFPEsSJUI548P4u2gewxr12QtOMUiPRAOtqmW6hz8TBrjT
	 hl86xoOYlzR568RKrF9gjMos2/XnsNcmXWFaYBcBdXtf25TjTS9kcCbG9LlpT/bWo9
	 tdnKkSi4kddi2ROh6ALCuyZK0lPHKtP8U2p7L4+oVj0wor4N7p8Q0Z8eL0ZhCLyCOR
	 SCXIEF9tAhpQg==
Date: Fri, 25 Oct 2024 23:39:38 +0000
To: Piotr Zalewski <pZ010001011111@proton.me>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: Alan Huang <mmpgouride@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <8aW4pK0ZSmglofzD-Ej0W2ClwAV-1qDS95_nUqwxsw_I4w6gERwlUN-uqb-n2fiMyh5r_1pzEj4vCIBLL5vSJAAnzqTgijxAHB2pRnIFNww=@proton.me>
In-Reply-To: <L78wBCQQaurE7tyQP_T2Fklx8afGKmTXxDh-gweSzakgUoCwjCYeMHINndXWj4LWdUFpOvynoYeKlE7N0rUMiXYEM_VLDye48iN5ysgM09A=@proton.me>
References: <20241023072024.98915-3-pZ010001011111@proton.me> <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com> <L78wBCQQaurE7tyQP_T2Fklx8afGKmTXxDh-gweSzakgUoCwjCYeMHINndXWj4LWdUFpOvynoYeKlE7N0rUMiXYEM_VLDye48iN5ysgM09A=@proton.me>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: e30d18e7309e114e032e52e476fe9bf37bc10238
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alan and all,

On Wednesday, October 23rd, 2024 at 10:06 AM, Piotr Zalewski <pZ01000101111=
1@proton.me> wrote:

> Hi Alan,
>
> On Wednesday, October 23rd, 2024 at 9:33 AM, Alan Huang mmpgouride@gmail.=
com wrote:
>
> > On Oct 23, 2024, at 15:21, Piotr Zalewski pZ010001011111@proton.me wrot=
e:
> >
> > > Add NULL check for key returned from bch2_btree_and_journal_iter_peek=
 in
> > > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > > bch2_bkey_buf_reassemble.
> >
> > It would be helpful if the commit message explained why k.k is null in =
this case
>
>
> I will debug this more thoroughly and provide details. For now I see that
> during GC it sees journal replay hasn't finished but journal turns out to
> be empty? Which seems weird, so maybe underlying issue should be solved o=
n
> a deeper level.
>

There is a clean shutdown detected during recovery. Journal has no entries=
=20
as it was confirmed by debugging bch2_fs_journal_start. seq and seq_ondisk=
=20
members are equal so journal is "quiesced". Also, journal_keys size is 0.

So in check_allocations when keys are being marked for GC journal replay is
not done so it peeks into journal and there is nothing.

Now, maybe in case journal is empty during start, replay done should be set=
=20
already in bch2_fs_journal_start? I tested it and it fixed the issue as wel=
l.
```
diff --git a/fs/bcachefs/journal.c b/fs/bcachefs/journal.c
index 2cf8f24d50cc..67b342d23346 100644
--- a/fs/bcachefs/journal.c
+++ b/fs/bcachefs/journal.c
@@ -1287,6 +1287,9 @@ int bch2_fs_journal_start(struct journal *j, u64 cur_=
seq)
        spin_lock(&j->lock);

        set_bit(JOURNAL_running, &j->flags);
+       if (!had_entries) {
+               set_bit(JOURNAL_replay_done, &j->flags);
+       }
        j->last_flush_write =3D jiffies;

        j->reservations.idx =3D j->reservations.unwritten_idx =3D journal_c=
ur_seq(j);
```


(But at the same time there is a check for whether there were entries just=
=20
above the code which sets journal running so it seems unlikely that if it's=
=20
correct approach it's not yet there).

(In need of some pointer/explanation)

>
> > > Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d9765=
7
> > > Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> > > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > > ---
> > > fs/bcachefs/btree_iter.c | 3 +++
> > > 1 file changed, 3 insertions(+)
> > >
> > > diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> > > index 0883cf6e1a3e..625167ce191f 100644
> > > --- a/fs/bcachefs/btree_iter.c
> > > +++ b/fs/bcachefs/btree_iter.c
> > > @@ -882,6 +882,8 @@ static noinline int btree_node_iter_and_journal_p=
eek(struct btree_trans *trans,
> > > __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->=
iter, path->pos);
> > >
> > > k =3D bch2_btree_and_journal_iter_peek(&jiter);
> > > + if (!k.k)
> > > + goto err;
> > >
> > > bch2_bkey_buf_reassemble(out, c, k);
> > >
> > > @@ -889,6 +891,7 @@ static noinline int btree_node_iter_and_journal_p=
eek(struct btree_trans *trans,
> > > c->opts.btree_node_prefetch)
> > > ret =3D btree_path_prefetch_j(trans, path, &jiter);
> > >
> > > +err:
> > > bch2_btree_and_journal_iter_exit(&jiter);
> > > return ret;
> > > }
> > > --
> > > 2.47.0
>
Best regards, Piotr Zalewski
