Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389FE157A76
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 10:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717755050; cv=none; b=UKgxRjkwafFmvoN4Jtg1F5fVpD9aI2U7anB3v/Rrnd5myV4j1Tp+aK3HZhOg24iBdGmZ04TcsnJqRVXVK3jbO5OFq6tv/xN7OXBFpzT/jG+PKbtjq6PgzAmXM2++nzA58N3rjPv1r6WqZFA/bDgya+/J5R+qYv14g4l/DC4ZsrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717755050; c=relaxed/simple;
	bh=CjpmBH8C8aYvBrAPartcAC/9BA+gOfZamWf5VsqI4fA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RJpQzgv6F0dJ11kPlIlpfGtqcC1v8QBPr6utw2h+v4kfTpJaaPbk/gBG7GNL+E4YLYgIwsiWYdw6Cc19gI0XZ8HgkGeACZXkvbJ8VXjhOXseC1tZ1/NN+mpMJaC5N5REBZohCW0plctewFLOG4u/ai/ZbG6zQAnujv+dNDT9PzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iz+qmJTt; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iz+qmJTt"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57a526c6a2cso2192553a12.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 03:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717755047; x=1718359847; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqEEZZg+rQ4DsLoUGWC47kTVT3grHniUDLxrKsxSNXc=;
        b=iz+qmJTtiofAoDR9Nepfro3dezFBW+9h/uEsah6zvNUZG/kzJk2U86RDu92BOBX3IS
         VsdnwD8Zc98k4RaUu25IJgbwUxv5X9IovB26qXDsOkECFnwxWfCzqbYDC2VIFMSGfSRd
         RqHcXalVXTsNkHO11qoF0iDCi6HohT6W7sj+Vo32KgygymTE6AXJjwn5DBplqJKPqMEZ
         CLgXHz8rCZ0kRRNdmlcb8530mPrsMYgrC3L1ITpbkjKAYyrkj206RVtDK0KSKzwnhCIG
         HAXAEoDUFohTKRCp6TGI6QPdwOBqaI7Np8qkcHOTd0ohrP65yklKGcC3e5zM9H4TivlT
         g0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717755047; x=1718359847;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqEEZZg+rQ4DsLoUGWC47kTVT3grHniUDLxrKsxSNXc=;
        b=Z9R7vxgmamUSwvrziIZ6xi5LfZhACKbjI8+G5b3vE/BrkkBaj0A/Mmws+oRuISj54W
         dhpG2SLYgk4gARyxzDSJtXI4Q9/EEF5qnKapUW0epc8pn5QNNehVYd+FirnCoD4naPTK
         zz38rohWkNiYeNBwkNdSoPmodK61Ziu6BlThcv00SNLwEY2KjnLP9albawNwDHEe54ae
         upCAIQc/RaZQsnOxnCF9g4wsPZeitqr/ruvWw9Y7onvuL00I6pijm9g+U/WZPys72RvC
         mJQd+SwOsVJo7WdYjRoCR00+3FrbEQzVFacBeDMOvIeaQhw9AePfx1vBhxr0WkVc2c5E
         hGUQ==
X-Gm-Message-State: AOJu0Yy0LNERhxMiuyPKQ7l/GiVklAi3tuILiiw9p43Gb5xseribzQPE
	0OlINCtJGAVJw4pj4ClA06arZuyemW4O1g1xat2Q6A856TAyNwvfuPZ0deSDrad7KfVzLMbaUyY
	Y6M2UCJtEM3PgZVPVfuYvyPJiFBE=
X-Google-Smtp-Source: AGHT+IECCR/Ra2sG3famUl/t/x9fTWa5Fw0sbt6vUziuJcpUpN33UHlaOmEffRo9LbfNUw2MfuQfqhfERbDdjtapJhQ=
X-Received: by 2002:a05:6402:22d0:b0:57a:4c22:c4 with SMTP id
 4fb4d7f45d1cf-57c5098917bmr1173123a12.33.1717755047120; Fri, 07 Jun 2024
 03:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
 <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com> <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
In-Reply-To: <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 12:10:34 +0200
Message-ID: <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 11:13=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wrote:
> > On Fri, Jun 7, 2024 at 2:31=E2=80=AFAM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> > > > So I tried out bcachefs again and it once more fails to complete
> > > > parallel creation of 20 mln files -- processes doing the work use c=
pu
> > > > time in the kernel indefinitely.
> > >
> > > Hey thanks for the report - can you try my branch? It's behaving
> > > reasonable well in my testing now
> > >
> > > https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstream
> >
> > No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d8959f5ce9
>
> That commit completely fixes the lock contention on the btree key cache
> lock I was seeing before, are you sure that's the commit you were
> running?

Yea, I have CONFIG_LOCALVERSION_AUTO=3Dy and included part of uname -a
from the running kernel to indicate the commit. That's b7d8959f5ce9
"bcachefs: Fix reporting of freed objects from key cache shrinker".

I also have CONFIG_BCACHEFS=3Dy

But to put this to bed I added this:
diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.c
index e73162f9af37..459f0871c9a4 100644
--- a/fs/bcachefs/btree_key_cache.c
+++ b/fs/bcachefs/btree_key_cache.c
@@ -821,8 +821,14 @@ static unsigned long
bch2_btree_key_cache_scan(struct shrinker *shrink,
        size_t scanned =3D 0, freed =3D 0, nr =3D sc->nr_to_scan;
        unsigned start, flags;
        int srcu_idx;
+       static bool printed;

        mutex_lock(&bc->lock);
+       if (!printed) {
+               printk(KERN_EMERG "here\n");
+               printed =3D true;
+       }
+
        bc->requested_to_free +=3D sc->nr_to_scan;

        srcu_idx =3D srcu_read_lock(&c->btree_trans_barrier);


it shows up and my procs are still stuck in the kernel

Is it a problem for you to get a similar setup to mine? It's not very
outlandish -- 24 cores and 24G of ram. You can probably get away with
both less cores and ram.

Then you run this stuff and it should repro within a minute or so:
https://people.freebsd.org/~mjg/fstree.tgz

--=20
Mateusz Guzik <mjguzik gmail.com>
