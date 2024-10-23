Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A643614D430
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 08:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.134
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729670831; cv=none; b=en6G6l/VyXDLItfJsRWwLlvIOK2vyriYwaWzKqFnGmKSZpSy1nzpcuszoKd8j8e2L/apFdU9A4gPe7ztLoVZ18Nuzh++KwV6HNn26fnp0iSy9EYig8zsaCcf2DNmuR/izXAJ7WwQgnN1pYnXqFa+a59fbJPjzC9m0rvrCf7rjvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729670831; c=relaxed/simple;
	bh=vPfSz3qHWAUn1+CfWqVe5BPCTuXiz66jLqw1PwW7gdw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rhsDFLEK7agxmPSTqtVtxgrnXB1JVNe525mKmyw/Mmz5l5COpfwieCgsf0vFRMDx9HQ11XsRNXLRG966tkUsvpuwW0du4LORJm2kpdD6faoAsJTlgkxAPVulBUZ0wkkWSiwqWGcLVlqSsYIjuKtnCp9aN9GQGm61gyiJ1uaCXjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=JSUyjfoz; arc=none smtp.client-ip=185.70.40.134
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="JSUyjfoz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729670821; x=1729930021;
	bh=WiNZoFE52HUQsAh3tRwh1y3054lK2w2JIjigaJTNQhU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=JSUyjfozECz9DhuR67qyua5UNf9t9WWUSjqZLwtRm2pBknDEfm89211bmGksZzOeR
	 0nmsR0jF30gy+LeYm5CvjcUcxuyZMSqBYqcqoS1Jv4lCFq673mlmxVcthb+gPhuGvK
	 TCzP8NdF8/snymuRomRG2p93kRDHoGXNIXl/6lM+SnGskMsJ2+LlP3Ko7srxNW7zWz
	 X3orIAlydBY2jHpZZOtt2/tCQj6aQ0+8jYFDNuGFE/vQBDtjfWbwdj7ZtJf8RhTsQ1
	 YHE6NVA83j2WNjdCwsz36lAXLBxMemcBUkaacoVrpe0Rwa8zL9KU3AI1g563H8k41U
	 dPfsaua5g1Yxg==
Date: Wed, 23 Oct 2024 08:06:59 +0000
To: Alan Huang <mmpgouride@gmail.com>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, skhan@linuxfoundation.org, syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
Subject: Re: [PATCH] bcachefs: Fix NULL ptr dereference in btree_node_iter_and_journal_peek
Message-ID: <L78wBCQQaurE7tyQP_T2Fklx8afGKmTXxDh-gweSzakgUoCwjCYeMHINndXWj4LWdUFpOvynoYeKlE7N0rUMiXYEM_VLDye48iN5ysgM09A=@proton.me>
In-Reply-To: <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com>
References: <20241023072024.98915-3-pZ010001011111@proton.me> <09A7740A-3113-4ABF-8587-8E0A4231DD61@gmail.com>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: ce19c318e8fae47aff127ee6e443c76350c685ef
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Wednesday, October 23rd, 2024 at 9:33 AM, Alan Huang <mmpgouride@gmail.c=
om> wrote:

> On Oct 23, 2024, at 15:21, Piotr Zalewski pZ010001011111@proton.me wrote:
>=20
> > Add NULL check for key returned from bch2_btree_and_journal_iter_peek i=
n
> > btree_node_iter_and_journal_peek to avoid NULL ptr dereference in
> > bch2_bkey_buf_reassemble.
>=20
>=20
> It would be helpful if the commit message explained why k.k is null in th=
is case
=20
I will debug this more thoroughly and provide details. For now I see that
during GC it sees journal replay hasn't finished but journal turns out to
be empty? Which seems weird, so maybe underlying issue should be solved on
a deeper level.

Log from the reproducer is:
```
[   27.391332] bcachefs (loop0): accounting_read... done
[   27.408141] bcachefs (loop0): alloc_read... done
[   27.409118] bcachefs (loop0): stripes_read... done
[   27.410059] bcachefs (loop0): snapshots_read... done
[   27.411161] bcachefs (loop0): check_allocations...
[   27.415003] bucket 0:26 data type btree ptr gen 0 missing in alloc btree
[   27.415024] while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0=
: seq ac62141f8dc7e261 written 24 min_kg
[   27.422560] bucket 0:38 data type btree ptr gen 0 missing in alloc btree
[   27.422571] while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0=
: seq 7589ab5e0c11cc7a written 24 min_kg
[   27.428033] bucket 0:41 data type btree ptr gen 0 missing in alloc btree
[   27.428042] while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0=
: seq 9aa2895aefce4bdf written 24 min_kg
[   27.432315] bcachefs (loop0): btree topology error: attempting to get bt=
ree node with non-btree key u64s 0 type
[   27.435343] bcachefs (loop0): inconsistency detected - emergency read on=
ly at journal seq 10
[   27.436947] bcachefs (loop0): bch2_gc_btree(): error btree_need_topology=
_repair
[   27.438756] btree node read error for xattrs, shutting down
[   27.440081] bcachefs (loop0): bch2_gc_btrees(): error fsck_errors_not_fi=
xed
[   27.441915] bcachefs (loop0): bch2_check_allocations(): error fsck_error=
s_not_fixed
[   27.443349] bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_=
fixed
[   27.444802] bcachefs (loop0): bch2_fs_start(): error starting filesystem=
 fsck_errors_not_fixed
[   27.446270] bcachefs (loop0): shutting down
[   27.456042] bcachefs (loop0): shutdown complete
[   27.835683] bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed
```


> > Reported-by: syzbot+005ef9aa519f30d97657@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D005ef9aa519f30d97657
> > Fixes: 5222a4607cd8 ("bcachefs: BTREE_ITER_WITH_JOURNAL")
> > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > ---
> > fs/bcachefs/btree_iter.c | 3 +++
> > 1 file changed, 3 insertions(+)
> >=20
> > diff --git a/fs/bcachefs/btree_iter.c b/fs/bcachefs/btree_iter.c
> > index 0883cf6e1a3e..625167ce191f 100644
> > --- a/fs/bcachefs/btree_iter.c
> > +++ b/fs/bcachefs/btree_iter.c
> > @@ -882,6 +882,8 @@ static noinline int btree_node_iter_and_journal_pee=
k(struct btree_trans *trans,
> > __bch2_btree_and_journal_iter_init_node_iter(trans, &jiter, l->b, l->it=
er, path->pos);
> >=20
> > k =3D bch2_btree_and_journal_iter_peek(&jiter);
> > + if (!k.k)
> > + goto err;
> >=20
> > bch2_bkey_buf_reassemble(out, c, k);
> >=20
> > @@ -889,6 +891,7 @@ static noinline int btree_node_iter_and_journal_pee=
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

Best regards, Piotr Zalewski
