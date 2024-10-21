Received: from mail-40131.protonmail.ch (mail-40131.protonmail.ch [185.70.40.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AD11E1A2C;
	Mon, 21 Oct 2024 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729497937; cv=none; b=E769fsuT+4DqXztKagwZjpdr43bP/BwSyyE+d0MMI/+7Ra4W/zXpWvqjZEzoFaMku/IHWu20f4VYYiU5l3cb5YuE5ydtW40CQvUErWihOK/1oCf78PH89NF6xcRPaRISzyRqpHfmrjF+BVPjVHT/VuVw+oNNm6GvdPKlnCnJ7N0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729497937; c=relaxed/simple;
	bh=vaWtO++fuwx9N/zXP/tC9f/ybwh7IOWAgrp6yYyiRiY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FJccnCpqj4qlOQ2OOVWlJ30+N+LOoxxxrEd/OP0CsJtU4EvzMouZtNDObaS7VYXyyooAFDBtf1jICsdxKG7kN+kITC01PoR8L4zKnHGqjG60xDWZsJg9uiPxhbDzbwu5cdXV7y8150CcjZr4wXtoi2YsaEfZ9m2lg8qzeMGbhOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=VFgfJ4Zr; arc=none smtp.client-ip=185.70.40.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="VFgfJ4Zr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1729497926; x=1729757126;
	bh=vaWtO++fuwx9N/zXP/tC9f/ybwh7IOWAgrp6yYyiRiY=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=VFgfJ4ZrNGaaZZsbFzAASVPKBmRuOEoyj0+Fq87fOQCTPR4C9rOxwg5AZEwyDCeYI
	 v5ZLRtGb3NRpdvqMguXMeM406/njeL72nDnNh4lsKVzrZKzl7Ltky6l4zPiBagBN3b
	 d1P4NUV51740ljiZYuRyLhV8W0kAj2GioREvBDxWQ4+dWAAszSt6jyROPgkRNB9TKC
	 yAzllPxTEzqPUDI6pwnFFqc6K0/rTAMqKkaMxbFgFcV0o80r7Z2FThFKZKBN/R3ZdS
	 H2Pfl/mF3C+AaT0yEm6UOcXr+Uj2j91/B7KTfQyv3wKB7hJQ4moteLp9Hne2D7cDuL
	 DmGY/WPL6O8uw==
Date: Mon, 21 Oct 2024 08:05:23 +0000
To: Kent Overstreet <kent.overstreet@linux.dev>
From: Piotr Zalewski <pZ010001011111@proton.me>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, skhan@linuxfoundation.org, syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
Subject: Re: [PATCH v1] bcachefs: set freespace inited to false if trans_mark_dev_sbs fails
Message-ID: <zBWzq5qj3_X8s9g2hXy8ZwvGLcPoBLQJRtb4E85aZlFyDOYvqKsHT8xzaLsLssWvRhdP7NkhMxrV8lhG8UXJxSXH1z6qjudgvj6VIcDQPV4=@proton.me>
In-Reply-To: <b22xc632ptvw3jtkyp5yqj6lxpnbdwlmqxekafuunjxxsaup7n@jrybxzaqj4li>
References: <20241020170708.67044-2-pZ010001011111@proton.me> <b22xc632ptvw3jtkyp5yqj6lxpnbdwlmqxekafuunjxxsaup7n@jrybxzaqj4li>
Feedback-ID: 53478694:user:proton
X-Pm-Message-ID: 57e5a1218b2dbe8f675c4f10483292d463dc35db
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Kent,

On Monday, October 21st, 2024 at 1:23 AM, Kent Overstreet <kent.overstreet@=
linux.dev> wrote:

> On Sun, Oct 20, 2024 at 05:08:45PM +0000, Piotr Zalewski wrote:
>=20
> > In bch2_fs_initialize if bch2_trans_mark_dev_sbs fails, set freespace
> > initialized bits to 0 in member's flags and update member cached versio=
n
> > for each device. bch2_trans_mark_dev_sbs fails just before freespace
> > init which can left freespace init bits set to true erroneously which l=
ater
> > can indirectly trigger BUG condition in bch2_bucket_alloc_freelist[1].
>=20
>=20
> Err...
>=20
> freespace_initialized shouldn't even be set at this point, it's set
> later, in bch2_fs_freespace_init(), naturally.
>=20
> So - syzbot is feeding us garbage, heh. BCH_MEMBER_FREESPACE_INITIALIZED
> should be false on a non initialized filesystem.
>=20
> So we actually should be unconditially clearing it (sanitizing our
> input) at the top of bch2_fs_initialize().

Initially I added it at the beginning of bch2_fs_initialize. I changed it
to here since then the error triggered is ENOSPC_disk_reservation instead
of EIO. I thought that it's somewhat important to retain the error so moved
it to the if statement.

I will move it to the sb_lock at the top. After syzbot tests it I will send
v2.

> > [1] https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489
> >=20
> > Reported-by: syzbot+2b6a17991a6af64f9489@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3D2b6a17991a6af64f9489
> > Fixes: bbe682c76789 ("bcachefs: Ensure devices are always correctly ini=
tialized")
> > Signed-off-by: Piotr Zalewski pZ010001011111@proton.me
> > ---
> > fs/bcachefs/recovery.c | 12 +++++++++++-
> > 1 file changed, 11 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/bcachefs/recovery.c b/fs/bcachefs/recovery.c
> > index 67bba156cce9..bcec79122f65 100644
> > --- a/fs/bcachefs/recovery.c
> > +++ b/fs/bcachefs/recovery.c
> > @@ -1031,6 +1031,7 @@ int bch2_fs_initialize(struct bch_fs *c)
> > struct bkey_inode_buf packed_inode;
> > struct qstr lostfound =3D QSTR("lost+found");
> > int ret;
> > + struct bch_member *m;
> >=20
> > bch_notice(c, "initializing new filesystem");
> > set_bit(BCH_FS_new_fs, &c->flags);
> > @@ -1086,8 +1087,17 @@ int bch2_fs_initialize(struct bch_fs *c)
> > bch_verbose(c, "marking superblocks");
> > ret =3D bch2_trans_mark_dev_sbs(c);
> > bch_err_msg(c, ret, "marking superblocks");
> > - if (ret)
> > + if (ret) {
> > + mutex_lock(&c->sb_lock);
> > + for_each_member_device(c, ca) {
> > + m =3D bch2_members_v2_get_mut(c->disk_sb.sb, ca->dev_idx);
> > + SET_BCH_MEMBER_FREESPACE_INITIALIZED(m, false);
> > + ca->mi =3D bch2_mi_to_cpu(m);
> > + }
> > + mutex_unlock(&c->sb_lock);
> > +
> > goto err;
> > + }
> >=20
> > for_each_online_member(c, ca)
> > ca->new_fs_bucket_idx =3D 0;
> > --
> > 2.47.0

Best regards, Piotr Zalewski
