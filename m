Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A41A270
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717783167; cv=none; b=kIq6LMNYet9NOaQDBae3NlR4zgKHzz/LSN++I+h2Wpz0SC5Wj9CRD0suPac3UDnmArIQfAMstfqNsNGC2k0WEODWIfVZTQTwFcMFqlUb9WNOzmRt9wqburwxqJbv1SLjHdIlp/ABcq2vmdlruo4HzUuI1J1R/Yf3QP2d5860+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717783167; c=relaxed/simple;
	bh=I7cNLdTfaEuom1grckiAXk1Ol+C2OBb5Eu/dilwWGaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AWNjR+mbI45SM9ht13+mOIy6WnVrzMjbj6aRH/oJET0XtCvDPcgQTP0n/WjnrSi8W5CBj0ctI5wL0iCx3Za9gzztXctjkyMagbuMTPeYjesqm8TW/JLnp80jHJzo/OLsWlrOF5ZbUVMfiFuj811Pb4QbJp+3xpCM0RuQWQ/8xCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WY7HLzxR; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WY7HLzxR"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52bbdc237f0so1120232e87.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 10:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717783163; x=1718387963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B5Tm64QSLEb0PRHGbPIjSakehwMqrKib5lsn5DRcnBc=;
        b=WY7HLzxRTLfXbI1+0uoTebyh11ieJdvxWZzAymch66rUS8JzIGmq58k8yT92ToC3CR
         Ig7YVuedLFIw9Qs3sASTqqzihO5y/gkLe2xuaBsQHZJ6Qhe0/Ut7it/jJWsIaMVYRoYW
         vW+NP6THkvs3yRFOUGA1EHNTpd8ELd9Mr9tUURga77okaWS9AzsncRNv5OawUqe59kSn
         6mPEOlsnLGrS4oTRVuCk8sishQvnaiHSk6fp7GkYP0xYx9zl3rb+le/GA6DkjH8tP1Dl
         hMpScL+t2O8sowgsEIv1eDLKgcHPXcwCejPhAJCIXcRVodymS+E/TwTwp8VdD7wN+Az1
         3/cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717783163; x=1718387963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B5Tm64QSLEb0PRHGbPIjSakehwMqrKib5lsn5DRcnBc=;
        b=hFuhzeTdxvmKXOiP38p6ze6sxs3V6/ykBY66YVH1WdHxx9tkRD/vPSV2WXdDLliFSB
         UitCwN7EqK2PQzwvFKMiWf1uzia6QPweQFKWY8ljY0l1VwZ4RsaVIDNf+jAU7yh5dU/L
         t9ifH8MLuCrGwbB85/yxGnIy82lqhdHmCifFfJcxgqc06NkbMmH+YmGFFXQaSrTgQigT
         yLhJRLyEekq7wRb51KlOsSZEg35PesnGy1VpDgeSAvYE3SHjSwmEDaq4OPEMEVqcaI5P
         AV4AVeVDQh0CDdVL79DuLxLxpRMD5zOuxUAdIX9GShXlwTY+HgtN69lB997at9OjPsH3
         zJ/Q==
X-Gm-Message-State: AOJu0YzR9XhUtdWCTWi3Md8xSLlhxEtA0a5uq52bXcdy1gI87m/gKtz+
	/8WZsT7Ltw1nWV5PaIbP+BMoXL7fmRgO+EDhBkA34GwRoV6TZcgaiYx2oH7a5OsL1kmrIHHedB2
	ISy/g15GSABIJ53xRERZr6X+/YtM=
X-Google-Smtp-Source: AGHT+IGxMD5s1uoVyV1OICvtnHZqR4u0rFbkBn5EKYbMIX5TgcNcXWyduXOvVmfjFei5cta0cXsySQtgOIqc1q1deZs=
X-Received: by 2002:ac2:4644:0:b0:52b:c10f:995d with SMTP id
 2adb3069b0e04-52bc10f9afemr1391161e87.67.1717783163147; Fri, 07 Jun 2024
 10:59:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
 <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com> <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
In-Reply-To: <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 19:59:10 +0200
Message-ID: <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 7:53=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 07, 2024 at 06:51:05PM +0200, Mateusz Guzik wrote:
> > On Fri, Jun 7, 2024 at 6:28=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com=
> wrote:
> > >
> > > On Fri, Jun 7, 2024 at 6:07=E2=80=AFPM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > >
> > > > On Fri, Jun 07, 2024 at 12:10:34PM +0200, Mateusz Guzik wrote:
> > > > > On Fri, Jun 7, 2024 at 11:13=E2=80=AFAM Kent Overstreet
> > > > > <kent.overstreet@linux.dev> wrote:
> > > > > >
> > > > > > On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wrote:
> > > > > > > On Fri, Jun 7, 2024 at 2:31=E2=80=AFAM Kent Overstreet
> > > > > > > <kent.overstreet@linux.dev> wrote:
> > > > > > > >
> > > > > > > > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wro=
te:
> > > > > > > > > So I tried out bcachefs again and it once more fails to c=
omplete
> > > > > > > > > parallel creation of 20 mln files -- processes doing the =
work use cpu
> > > > > > > > > time in the kernel indefinitely.
> > > > > > > >
> > > > > > > > Hey thanks for the report - can you try my branch? It's beh=
aving
> > > > > > > > reasonable well in my testing now
> > > > > > > >
> > > > > > > > https://evilpiepirate.org/git/bcachefs.git bcachefs-for-ups=
tream
> > > > > > >
> > > > > > > No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d895=
9f5ce9
> > > > > >
> > > > > > That commit completely fixes the lock contention on the btree k=
ey cache
> > > > > > lock I was seeing before, are you sure that's the commit you we=
re
> > > > > > running?
> > > > >
> > > > > Yea, I have CONFIG_LOCALVERSION_AUTO=3Dy and included part of una=
me -a
> > > > > from the running kernel to indicate the commit. That's b7d8959f5c=
e9
> > > > > "bcachefs: Fix reporting of freed objects from key cache shrinker=
".
> > > > >
> > > > > I also have CONFIG_BCACHEFS=3Dy
> > > > >
> > > > > But to put this to bed I added this:
> > > > > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_ke=
y_cache.c
> > > > > index e73162f9af37..459f0871c9a4 100644
> > > > > --- a/fs/bcachefs/btree_key_cache.c
> > > > > +++ b/fs/bcachefs/btree_key_cache.c
> > > > > @@ -821,8 +821,14 @@ static unsigned long
> > > > > bch2_btree_key_cache_scan(struct shrinker *shrink,
> > > > >         size_t scanned =3D 0, freed =3D 0, nr =3D sc->nr_to_scan;
> > > > >         unsigned start, flags;
> > > > >         int srcu_idx;
> > > > > +       static bool printed;
> > > > >
> > > > >         mutex_lock(&bc->lock);
> > > > > +       if (!printed) {
> > > > > +               printk(KERN_EMERG "here\n");
> > > > > +               printed =3D true;
> > > > > +       }
> > > > > +
> > > > >         bc->requested_to_free +=3D sc->nr_to_scan;
> > > > >
> > > > >         srcu_idx =3D srcu_read_lock(&c->btree_trans_barrier);
> > > > >
> > > > >
> > > > > it shows up and my procs are still stuck in the kernel
> > > > >
> > > > > Is it a problem for you to get a similar setup to mine? It's not =
very
> > > > > outlandish -- 24 cores and 24G of ram. You can probably get away =
with
> > > > > both less cores and ram.
> > > >
> > > > I've tried with 4 GB of ram and with 24, and giving the vm 24 cores=
 -
> > > > your test passes for me, latest run was in 71 seconds.
> > > >
> > > > Host machine is a ryzen 5950x, 16 physical cores, 32 hyperthreaded =
- the
> > > > lack of 24 physical cores is the only possible difference I can see=
. But
> > > > I'm just not seeing the key cache lock contention anymore - I am se=
eing
> > > > massive lock contention on the inode hash table lock, though.
> > > >
> > > > Here's a call graph profile of part of the last run. There's still =
a bit
> > > > of key cache lock contention, but it's only 2% of cpu time now.
> > > >
> > >
> > > Huh, it does appear fixed after all.
> > >
> > > I tried it out again, but this time without any of the debug. It *did=
*
> > > finish, in 3 minutes. I ran it again just to be sure.
> > > Also the stalls I was seeing while trying to poke also gone (for
> > > example bpftrace would hang).
> > >
> > > The kernel with your fixes saddled with all the debug probably needed
> > > significantly more than said 3 minutes and I concluded things went ba=
d
> > > before it could legitimately finish. Kind of a PEBKAC here.
> > >
> > > tl;dr I confirm it is fixed, thanks
> > >
> >
> > While things do *work*, the walktree part of the test is very slow
> > compared to ext4 and bcachefs, both of which do it in less than a
> > minute.
> > bcachefs repeatedly needs over two.
> >
> > mkfs.bcachefs /dev/vdb
> > mount.bcachefs.sh -o noatime /dev/vdb /testfs
> > sh createtrees /testfs 20
> > while true; do sh walktrees /testfs 20; done
> >
> > I get times:
> > 2.80s user 986.09s system 697% cpu 2:21.84 total
> > 2.77s user 993.15s system 748% cpu 2:13.07 total
> > 2.95s user 992.67s system 747% cpu 2:13.26 total
>
> ext4 gives me
> WATCHDOG 300
> mke2fs 1.47.1-rc2 (01-May-2024)
> Discarding device blocks: done
> Creating filesystem with 8386560 4k blocks and 41943040 inodes
> Filesystem UUID: 4e72e045-ef0d-4d49-82d8-bc83e853a492
> Superblock backups stored on blocks:
>         6552, 19656, 32760, 45864, 58968, 163800, 176904, 321048, 530712,
>         819000, 1592136, 2247336, 4095000, 4776408
>
> Allocating group tables: done
> Writing inode tables: done
> Creating journal (32768 blocks): done
> Writing superblocks and filesystem accounting information: done
>
> EXT4-fs (vdb): mounted filesystem 4e72e045-ef0d-4d49-82d8-bc83e853a492 r/=
w with ordered data mode. Quota mode: disabled.
>
> createtrees
> real    0m27.552s
> user    0m6.678s
> sys     4m17.175s
>
> walktrees
> real    0m34.830s
> user    0m2.266s
> sys     10m38.617s
>
> and I get similar from bcachefs - except I did just have a run where
> createtrees took ~3m with key cache lock contention spiking again, so it
> appears that's not completely fixed.
>
> How are you getting sub 3s?

There is no sub 3s anything but maybe user time.

On my hw total real time walktree on bcachefs is about 2 minutes 13
seconds for repeated runs.
It is about 45 seconds on ext4.

Looks like my hw runs into the key cache lock thing very easily.

--=20
Mateusz Guzik <mjguzik gmail.com>
