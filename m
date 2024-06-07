Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ED5A20
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 18:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717784513; cv=none; b=ZlWiVxt2DkJfFObLJ7FjGvc0N2YOdwypROV7Mxcuu5GjwBjLorSDUjK7AWd9R/CW6f06B6ctbnS0zaYwn/M8FTZzmZGMkdc5slX5zIqzdI87BqCfl+tCoBunaWsTMXka7vqctbjtSj4izy0pJ0lAHUmxQR5c1rAd58F6adTPDPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717784513; c=relaxed/simple;
	bh=6S0ZOnASRgxHw1QeU1q8qZJd36HxjyAWq8WX1MeKxyE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O5MeQsL4CX0n4G73wHjiz9H0UXWQq9dF0AV0bSAmI0geN+lKzY8+kohn1nO0/5w3I6upm7eqGTiA0WFLF4KYaiFO270SNDWq0vt0jRweEG4nANb0KRJz89LOnXAyjmqwGRs3GQJr05Ue2LBS2IAtoarj/gi5S/+aibdggwZuGqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8NpTqpk; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8NpTqpk"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a68e7538cfaso310656566b.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 11:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717784510; x=1718389310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SUKvtdeulaBZcMG4VOArkRFV07MZZTYxxRAJFfeWHJg=;
        b=H8NpTqpknySV9HGhqsSjJ01qkjkAoGtg/28N19s7EVdtsW4myCXuZcf3T+N9aMkjg5
         ptx6O+EizvvoW1d9mgA82NA6iMBK2L6KE68H4cmCCGoPKiF4a7WB4XgFUTbUgQmhjJUj
         4xLHrSLMpYg2s5oQeaXKROY/plmsq7r0snsHQqjDUkJWpzOlJdCdaNYh1cnEk+7QsOK6
         5UQAWr5AQNtHDPHWWzDDK3gw0trW/bcLJONoed2+n17hJiMNb+O13yM+JGBJ8xfdANVN
         vnNV9/RuwIrddpXg7azAzXvniHaohM6V4FC/VWjzFfSEVgNnjI2Ys4VSDb/OINTg+gQ5
         iw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717784510; x=1718389310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SUKvtdeulaBZcMG4VOArkRFV07MZZTYxxRAJFfeWHJg=;
        b=B1OeQ3XsXprywnmlsDxXF0NCFa7f5Xi9knK225RQnYirIj0xP8fKijjKZFBK0woIMk
         P1NPcc0l0Dvery8SVOR5b4fn1cL/V+yfogMGuoPbvnzgg9n8eu2/xbcVp/XaCEU4sNT+
         Mfzo6QS7zqfmZ9epAkg8Gc/r14F8VExjCTBHwwonLclKJLxqlIdRmsHeHXazgWbSh0W5
         Wek4zeG2TQ7e02gjdayFt33AnlKbF2BHgtSV2tY4XbFwxJWvfy7RrC0e8i/98i/u2wuw
         8UD2kdudSxorFc/WzFSXBZuBhwbXy8J04BH4J7kLm+WbFb5rrS6/35c2OzI3MGInIbUO
         Ddag==
X-Gm-Message-State: AOJu0YxTJDjfFj1bvPA/Nk/Kk5zyzgLWIvn3Llu+lknWALDrdvAHygHb
	2d8VXBokeltnQnpERNxccan/SgMT5/SYpFfTuxETRFZ/PCXoBtM6G6dL9RenmatebfGexjLwpN5
	e559eipZHGtuPI2bPxJ9l9Hz94fg=
X-Google-Smtp-Source: AGHT+IGBZbnBX9TrYEsiuF2DCAdCILwma2w6+qzwpRaxL7NWX0wxmiviB3C9VjyB0D4MoI8jfcFWKGze7g0ZSwG8OvE=
X-Received: by 2002:a17:906:398:b0:a66:414c:2abf with SMTP id
 a640c23a62f3a-a6cd60a189emr228313166b.26.1717784509918; Fri, 07 Jun 2024
 11:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGudoHE1WhSSrqKbtCVhdxbPnmjGeb45mUw+gQ_ZEgMsfADu+g@mail.gmail.com>
 <nyu645ylcfo4go5bb7jyam7jvcohtjol2qz6n4kpcfdsaom4y6@yawhqfyzyudk>
 <CAGudoHFM1c2QMtbJMFCRw1YUk4p-_0GQBn9MfyFfNdxJbZqQeg@mail.gmail.com>
 <y3qdwfh7gjs6ykedg4ehrbwsiktabbtgoqloka5nnj5oatkh5k@7evginr2jhsf>
 <CAGudoHEsFHMG5UYpSyobp1zpm-eOpKdx=b7kL9NFG3_VKE8+Zg@mail.gmail.com>
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw>
 <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
 <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
 <wvpgfberqgnidhzymc5gxsa45vwtrcto45ppcx6bprar5bkg4u@6tmfvbp5xeac>
 <CAGudoHFDFgAq2--dEubAV4w2ZqdqNY56SdAmmvy1nF8Z5bX6kA@mail.gmail.com> <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
In-Reply-To: <jsrnek56sgp3stom6nmkfkacsva3iphl2hbmohece2htyrtt7l@hlbezgwrf3hk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 20:21:38 +0200
Message-ID: <CAGudoHHwAC5adU6p6yM_mwrwGzDDQLn8ES985X08kY==+juAFg@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 8:10=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 07, 2024 at 07:59:10PM +0200, Mateusz Guzik wrote:
> > On Fri, Jun 7, 2024 at 7:53=E2=80=AFPM Kent Overstreet
> > <kent.overstreet@linux.dev> wrote:
> > >
> > > On Fri, Jun 07, 2024 at 06:51:05PM +0200, Mateusz Guzik wrote:
> > > > On Fri, Jun 7, 2024 at 6:28=E2=80=AFPM Mateusz Guzik <mjguzik@gmail=
.com> wrote:
> > > > >
> > > > > On Fri, Jun 7, 2024 at 6:07=E2=80=AFPM Kent Overstreet
> > > > > <kent.overstreet@linux.dev> wrote:
> > > > > >
> > > > > > On Fri, Jun 07, 2024 at 12:10:34PM +0200, Mateusz Guzik wrote:
> > > > > > > On Fri, Jun 7, 2024 at 11:13=E2=80=AFAM Kent Overstreet
> > > > > > > <kent.overstreet@linux.dev> wrote:
> > > > > > > >
> > > > > > > > On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wro=
te:
> > > > > > > > > On Fri, Jun 7, 2024 at 2:31=E2=80=AFAM Kent Overstreet
> > > > > > > > > <kent.overstreet@linux.dev> wrote:
> > > > > > > > > >
> > > > > > > > > > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik=
 wrote:
> > > > > > > > > > > So I tried out bcachefs again and it once more fails =
to complete
> > > > > > > > > > > parallel creation of 20 mln files -- processes doing =
the work use cpu
> > > > > > > > > > > time in the kernel indefinitely.
> > > > > > > > > >
> > > > > > > > > > Hey thanks for the report - can you try my branch? It's=
 behaving
> > > > > > > > > > reasonable well in my testing now
> > > > > > > > > >
> > > > > > > > > > https://evilpiepirate.org/git/bcachefs.git bcachefs-for=
-upstream
> > > > > > > > >
> > > > > > > > > No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7=
d8959f5ce9
> > > > > > > >
> > > > > > > > That commit completely fixes the lock contention on the btr=
ee key cache
> > > > > > > > lock I was seeing before, are you sure that's the commit yo=
u were
> > > > > > > > running?
> > > > > > >
> > > > > > > Yea, I have CONFIG_LOCALVERSION_AUTO=3Dy and included part of=
 uname -a
> > > > > > > from the running kernel to indicate the commit. That's b7d895=
9f5ce9
> > > > > > > "bcachefs: Fix reporting of freed objects from key cache shri=
nker".
> > > > > > >
> > > > > > > I also have CONFIG_BCACHEFS=3Dy
> > > > > > >
> > > > > > > But to put this to bed I added this:
> > > > > > > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btre=
e_key_cache.c
> > > > > > > index e73162f9af37..459f0871c9a4 100644
> > > > > > > --- a/fs/bcachefs/btree_key_cache.c
> > > > > > > +++ b/fs/bcachefs/btree_key_cache.c
> > > > > > > @@ -821,8 +821,14 @@ static unsigned long
> > > > > > > bch2_btree_key_cache_scan(struct shrinker *shrink,
> > > > > > >         size_t scanned =3D 0, freed =3D 0, nr =3D sc->nr_to_s=
can;
> > > > > > >         unsigned start, flags;
> > > > > > >         int srcu_idx;
> > > > > > > +       static bool printed;
> > > > > > >
> > > > > > >         mutex_lock(&bc->lock);
> > > > > > > +       if (!printed) {
> > > > > > > +               printk(KERN_EMERG "here\n");
> > > > > > > +               printed =3D true;
> > > > > > > +       }
> > > > > > > +
> > > > > > >         bc->requested_to_free +=3D sc->nr_to_scan;
> > > > > > >
> > > > > > >         srcu_idx =3D srcu_read_lock(&c->btree_trans_barrier);
> > > > > > >
> > > > > > >
> > > > > > > it shows up and my procs are still stuck in the kernel
> > > > > > >
> > > > > > > Is it a problem for you to get a similar setup to mine? It's =
not very
> > > > > > > outlandish -- 24 cores and 24G of ram. You can probably get a=
way with
> > > > > > > both less cores and ram.
> > > > > >
> > > > > > I've tried with 4 GB of ram and with 24, and giving the vm 24 c=
ores -
> > > > > > your test passes for me, latest run was in 71 seconds.
> > > > > >
> > > > > > Host machine is a ryzen 5950x, 16 physical cores, 32 hyperthrea=
ded - the
> > > > > > lack of 24 physical cores is the only possible difference I can=
 see. But
> > > > > > I'm just not seeing the key cache lock contention anymore - I a=
m seeing
> > > > > > massive lock contention on the inode hash table lock, though.
> > > > > >
> > > > > > Here's a call graph profile of part of the last run. There's st=
ill a bit
> > > > > > of key cache lock contention, but it's only 2% of cpu time now.
> > > > > >
> > > > >
> > > > > Huh, it does appear fixed after all.
> > > > >
> > > > > I tried it out again, but this time without any of the debug. It =
*did*
> > > > > finish, in 3 minutes. I ran it again just to be sure.
> > > > > Also the stalls I was seeing while trying to poke also gone (for
> > > > > example bpftrace would hang).
> > > > >
> > > > > The kernel with your fixes saddled with all the debug probably ne=
eded
> > > > > significantly more than said 3 minutes and I concluded things wen=
t bad
> > > > > before it could legitimately finish. Kind of a PEBKAC here.
> > > > >
> > > > > tl;dr I confirm it is fixed, thanks
> > > > >
> > > >
> > > > While things do *work*, the walktree part of the test is very slow
> > > > compared to ext4 and bcachefs, both of which do it in less than a
> > > > minute.
> > > > bcachefs repeatedly needs over two.
> > > >
> > > > mkfs.bcachefs /dev/vdb
> > > > mount.bcachefs.sh -o noatime /dev/vdb /testfs
> > > > sh createtrees /testfs 20
> > > > while true; do sh walktrees /testfs 20; done
> > > >
> > > > I get times:
> > > > 2.80s user 986.09s system 697% cpu 2:21.84 total
> > > > 2.77s user 993.15s system 748% cpu 2:13.07 total
> > > > 2.95s user 992.67s system 747% cpu 2:13.26 total
> > >
> > > ext4 gives me
> > > WATCHDOG 300
> > > mke2fs 1.47.1-rc2 (01-May-2024)
> > > Discarding device blocks: done
> > > Creating filesystem with 8386560 4k blocks and 41943040 inodes
> > > Filesystem UUID: 4e72e045-ef0d-4d49-82d8-bc83e853a492
> > > Superblock backups stored on blocks:
> > >         6552, 19656, 32760, 45864, 58968, 163800, 176904, 321048, 530=
712,
> > >         819000, 1592136, 2247336, 4095000, 4776408
> > >
> > > Allocating group tables: done
> > > Writing inode tables: done
> > > Creating journal (32768 blocks): done
> > > Writing superblocks and filesystem accounting information: done
> > >
> > > EXT4-fs (vdb): mounted filesystem 4e72e045-ef0d-4d49-82d8-bc83e853a49=
2 r/w with ordered data mode. Quota mode: disabled.
> > >
> > > createtrees
> > > real    0m27.552s
> > > user    0m6.678s
> > > sys     4m17.175s
> > >
> > > walktrees
> > > real    0m34.830s
> > > user    0m2.266s
> > > sys     10m38.617s
> > >
> > > and I get similar from bcachefs - except I did just have a run where
> > > createtrees took ~3m with key cache lock contention spiking again, so=
 it
> > > appears that's not completely fixed.
> > >
> > > How are you getting sub 3s?
> >
> > There is no sub 3s anything but maybe user time.
> >
> > On my hw total real time walktree on bcachefs is about 2 minutes 13
> > seconds for repeated runs.
> > It is about 45 seconds on ext4.
> >
> > Looks like my hw runs into the key cache lock thing very easily.
>
> Ok, I misread.
>
> Does the following patch help? I think the hammering on the key cache
> lock may be correlated with the key cache being mostly empty (and it
> looks like the shrinker code is behaving badly and trying very hard to
> free from a mostly empty cache)
>

I'm going to bench tomorrow.

> re: your inode lock contention patch series - we really just need to
> convert fs/inode.c to an rhashtable.
>

I'm not familiar with rhashtable and don't have interest in learning
the api, big part of the point of the posted patch was how trivial it
is.

That is to say if you are willing to hack it up yourself in the
foreseeable future I'd have no complaints.

> diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_cache.=
c
> index e73162f9af37..24e88eebd23c 100644
> --- a/fs/bcachefs/btree_key_cache.c
> +++ b/fs/bcachefs/btree_key_cache.c
> @@ -875,24 +875,22 @@ static unsigned long bch2_btree_key_cache_scan(stru=
ct shrinker *shrink,
>
>                         if (test_bit(BKEY_CACHED_DIRTY, &ck->flags)) {
>                                 bc->skipped_dirty++;
> -                               goto next;
>                         } else if (test_bit(BKEY_CACHED_ACCESSED, &ck->fl=
ags)) {
>                                 clear_bit(BKEY_CACHED_ACCESSED, &ck->flag=
s);
>                                 bc->skipped_accessed++;
> -                               goto next;
> -                       } else if (bkey_cached_lock_for_evict(ck)) {
> +                       } else if (!bkey_cached_lock_for_evict(ck)) {
> +                               bc->skipped_lock_fail++;
> +                       } else {
>                                 bkey_cached_evict(bc, ck);
>                                 bkey_cached_free(bc, ck);
>                                 bc->moved_to_freelist++;
>                                 freed++;
> -                       } else {
> -                               bc->skipped_lock_fail++;
>                         }
>
>                         scanned++;
>                         if (scanned >=3D nr)
>                                 break;
> -next:
> +
>                         pos =3D next;
>                 }
>
> @@ -915,7 +913,8 @@ static unsigned long bch2_btree_key_cache_count(struc=
t shrinker *shrink,
>         struct bch_fs *c =3D shrink->private_data;
>         struct btree_key_cache *bc =3D &c->btree_key_cache;
>         long nr =3D atomic_long_read(&bc->nr_keys) -
> -               atomic_long_read(&bc->nr_dirty);
> +               atomic_long_read(&bc->nr_dirty) -
> +               128;
>
>         return max(0L, nr);
>  }



--=20
Mateusz Guzik <mjguzik gmail.com>
