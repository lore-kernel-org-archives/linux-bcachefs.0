Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6302F14005
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Jun 2024 16:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717779084; cv=none; b=qPTBhM1xUF5iKCUbauQXbkfXSWAitOq7joMdVS+VwTh403JEbMsXDqqxVyE4Bup34+WiJ0yOuhiFrVuXDnf8gdPFo/iQlgL6MKeg1kKkbNE93OoN9hzgW+2NbB6y06B1f2WPl2rZYgiTIwpSePHbNS0MuC19QuXDdQ6Oz1uy730=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717779084; c=relaxed/simple;
	bh=euWUUXcqmIrz+WajQMRTKVweVIvcfbfSE1ZrtuEQadA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LGLqA5aF0Pbjoc2ClW/QANlKBt7MHz6gU15/611dTtlm4cCIZuEJbb0MuqgDqcZV6PJ5WBVAoNVSaHocgkQ7j/8SvTpsWVZolD4tDi6i/ohN9iyPr/kMdVHuxhsYsp0E4dNf/0L90XSouONtKOcrzVRosMDSyQUVd+2O0Si6sJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lVGQByac; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVGQByac"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52bc29c79fdso702434e87.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Jun 2024 09:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717779079; x=1718383879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iXCMhbcsUVGNjOqp4aXdAPfsQ9p8/eYi+0LJFDlQVjk=;
        b=lVGQByac/KFE/lX3CVZf/bUOcY0ORfZzLg920v/vjYe41IuRkDZsyf9M6Zef5BNGRc
         ciwb8Ae/3PWEA4Vbtiu79Jjdh/VdyU+h9x2tNe3c3yRVF8ndBoYPNOvDU2Zfw2zajJAL
         14iDFoFxhsLizx7/1ge0hMetGgIfmFvpOHGXR/X+05jryzqraZi0OWBRofabZUE47qDP
         lO+mXmK1yejV+/6RsE73vmjO43HI8cf4L0sPwFMGkM0qnALSZ+MgXa9Bch8eU2LGLGwW
         +2vjyFgs9ETZuqxRMIyzd9EuymfCedjWVQzVjgAg2JlZ+79HQAbggzq6kOL6bR702Lb6
         n6JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717779079; x=1718383879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iXCMhbcsUVGNjOqp4aXdAPfsQ9p8/eYi+0LJFDlQVjk=;
        b=Q07o66jm0JhAUbQfwwzwgW+GQcF1FQea6nzwzYe1EBNobwUNcCyaNMeKsPC+KXxwPZ
         73k9qNm64pkzWrId9EuSIonVcpKE67LFQt1IsNSDOMS2EyWqpiPU3Z6mMFQ5TNuFS1lJ
         WrO3WU2SnXk4QSnwLewVOS7bHmmC5ICNQx8fRKlvazr97cZKh2p1K0z5yBAUJKW2CvC/
         YmLHBrMabKT0+4ld5/wBiSgbw29c0GsYcbRPxwHdLWvIqz0az7sZRCZhMkbzUfGPKuNn
         5GOpEPQ6DKeGqIh3WEUCoN3LZP3yappQCeAsRRuctMe9ZUNWjnRp5GCplI+02f2OuhnM
         t7eA==
X-Gm-Message-State: AOJu0YzlCNA2XqCcBehOm9tv62OpldEg2F9jwabDS5PHafBTC1hL8buQ
	Htx2hEGV4NA1lFW4hQbShSVFJGkXeef5YFb4EaNB7rPabHcyyumnYquva9O/8mFdJ0fsrXTSGs8
	KBObpUytZBmgzaPHKnoA3lYYAXQkbqRSw
X-Google-Smtp-Source: AGHT+IFeJhfLFkrtL9G0ATN1bSmkgrux26EDe3SjblPGPV4gqjX9+ZrpTlrThsCAalunl8bZKFvSsf+EFdsdo098vUQ=
X-Received: by 2002:a05:6512:4891:b0:523:9515:4b74 with SMTP id
 2adb3069b0e04-52bb9f62754mr2724090e87.14.1717779078865; Fri, 07 Jun 2024
 09:51:18 -0700 (PDT)
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
 <ln4mfb5iv4kxxjcpm67szq24g6dxfdk36fsxb7shojmhg2fkf2@izeciivj46yw> <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
In-Reply-To: <CAGudoHGeak9cnG+qE6=zoqbg5KiOZG+aMHksmbvwWTATKhWm-w@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Jun 2024 18:51:05 +0200
Message-ID: <CAGudoHFyJ64SDwUTijSrqeDjXBO3MfFx8D8-DoMaPFEQmzzLDw@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 6:28=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> On Fri, Jun 7, 2024 at 6:07=E2=80=AFPM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, Jun 07, 2024 at 12:10:34PM +0200, Mateusz Guzik wrote:
> > > On Fri, Jun 7, 2024 at 11:13=E2=80=AFAM Kent Overstreet
> > > <kent.overstreet@linux.dev> wrote:
> > > >
> > > > On Fri, Jun 07, 2024 at 08:50:40AM +0200, Mateusz Guzik wrote:
> > > > > On Fri, Jun 7, 2024 at 2:31=E2=80=AFAM Kent Overstreet
> > > > > <kent.overstreet@linux.dev> wrote:
> > > > > >
> > > > > > On Thu, Jun 06, 2024 at 08:40:50PM +0200, Mateusz Guzik wrote:
> > > > > > > So I tried out bcachefs again and it once more fails to compl=
ete
> > > > > > > parallel creation of 20 mln files -- processes doing the work=
 use cpu
> > > > > > > time in the kernel indefinitely.
> > > > > >
> > > > > > Hey thanks for the report - can you try my branch? It's behavin=
g
> > > > > > reasonable well in my testing now
> > > > > >
> > > > > > https://evilpiepirate.org/git/bcachefs.git bcachefs-for-upstrea=
m
> > > > >
> > > > > No dice, booted up top of your tree: 6.10.0-rc2-00013-gb7d8959f5c=
e9
> > > >
> > > > That commit completely fixes the lock contention on the btree key c=
ache
> > > > lock I was seeing before, are you sure that's the commit you were
> > > > running?
> > >
> > > Yea, I have CONFIG_LOCALVERSION_AUTO=3Dy and included part of uname -=
a
> > > from the running kernel to indicate the commit. That's b7d8959f5ce9
> > > "bcachefs: Fix reporting of freed objects from key cache shrinker".
> > >
> > > I also have CONFIG_BCACHEFS=3Dy
> > >
> > > But to put this to bed I added this:
> > > diff --git a/fs/bcachefs/btree_key_cache.c b/fs/bcachefs/btree_key_ca=
che.c
> > > index e73162f9af37..459f0871c9a4 100644
> > > --- a/fs/bcachefs/btree_key_cache.c
> > > +++ b/fs/bcachefs/btree_key_cache.c
> > > @@ -821,8 +821,14 @@ static unsigned long
> > > bch2_btree_key_cache_scan(struct shrinker *shrink,
> > >         size_t scanned =3D 0, freed =3D 0, nr =3D sc->nr_to_scan;
> > >         unsigned start, flags;
> > >         int srcu_idx;
> > > +       static bool printed;
> > >
> > >         mutex_lock(&bc->lock);
> > > +       if (!printed) {
> > > +               printk(KERN_EMERG "here\n");
> > > +               printed =3D true;
> > > +       }
> > > +
> > >         bc->requested_to_free +=3D sc->nr_to_scan;
> > >
> > >         srcu_idx =3D srcu_read_lock(&c->btree_trans_barrier);
> > >
> > >
> > > it shows up and my procs are still stuck in the kernel
> > >
> > > Is it a problem for you to get a similar setup to mine? It's not very
> > > outlandish -- 24 cores and 24G of ram. You can probably get away with
> > > both less cores and ram.
> >
> > I've tried with 4 GB of ram and with 24, and giving the vm 24 cores -
> > your test passes for me, latest run was in 71 seconds.
> >
> > Host machine is a ryzen 5950x, 16 physical cores, 32 hyperthreaded - th=
e
> > lack of 24 physical cores is the only possible difference I can see. Bu=
t
> > I'm just not seeing the key cache lock contention anymore - I am seeing
> > massive lock contention on the inode hash table lock, though.
> >
> > Here's a call graph profile of part of the last run. There's still a bi=
t
> > of key cache lock contention, but it's only 2% of cpu time now.
> >
>
> Huh, it does appear fixed after all.
>
> I tried it out again, but this time without any of the debug. It *did*
> finish, in 3 minutes. I ran it again just to be sure.
> Also the stalls I was seeing while trying to poke also gone (for
> example bpftrace would hang).
>
> The kernel with your fixes saddled with all the debug probably needed
> significantly more than said 3 minutes and I concluded things went bad
> before it could legitimately finish. Kind of a PEBKAC here.
>
> tl;dr I confirm it is fixed, thanks
>

While things do *work*, the walktree part of the test is very slow
compared to ext4 and bcachefs, both of which do it in less than a
minute.
bcachefs repeatedly needs over two.

mkfs.bcachefs /dev/vdb
mount.bcachefs.sh -o noatime /dev/vdb /testfs
sh createtrees /testfs 20
while true; do sh walktrees /testfs 20; done

I get times:
2.80s user 986.09s system 697% cpu 2:21.84 total
2.77s user 993.15s system 748% cpu 2:13.07 total
2.95s user 992.67s system 747% cpu 2:13.26 total

so there is tons of idle.

see this for a reference:
https://lore.kernel.org/linux-fsdevel/bujynmx7n32tzl2xro7vz6zddt5p7lf5ultna=
ljaz2p2ler64c@acr7jih3wad7/T/#t

> > # To display the perf.data header info, please use --header/--header-on=
ly options.
> > #
> > #
> > # Total Lost Samples: 0
> > #
> > # Samples: 623K of event 'cycles:P'
> > # Event count (approx.): 663592818765
> > #
> > # Overhead  Symbol                                        IPC   [IPC Co=
verage]
> > # ........  ............................................  .............=
.......
> > #
> >     74.18%  [k] queued_spin_lock_slowpath                 -      -
> >             |
> >              --74.17%--_raw_spin_lock
> >                        |
> >                        |--34.17%--ilookup5_nowait
> >                        |          bch2_lookup_trans
> >                        |          bch2_lookup
> >                        |          __lookup_slow
> >                        |          walk_component
> >                        |          |
> >                        |           --34.14%--path_lookupat
> >                        |                     filename_lookup
> >                        |                     vfs_statx
> >                        |                     vfs_fstatat
> >                        |                     __do_sys_newfstatat
> >                        |                     __x64_sys_newfstatat
> >                        |                     x64_sys_call
> >                        |                     do_syscall_64
> >                        |                     entry_SYSCALL_64_after_hwf=
rame
> >                        |
> >                        |--34.15%--inode_insert5
> >                        |          bch2_inode_insert
> >                        |          |
> >                        |           --34.15%--bch2_lookup_trans
> >                        |                     bch2_lookup
> >                        |                     __lookup_slow
> >                        |                     walk_component
> >                        |                     |
> >                        |                      --34.12%--path_lookupat
> >                        |                                filename_lookup
> >                        |                                vfs_statx
> >                        |                                vfs_fstatat
> >                        |                                __do_sys_newfst=
atat
> >                        |                                __x64_sys_newfs=
tatat
> >                        |                                x64_sys_call
> >                        |                                do_syscall_64
> >                        |
> >                        |--4.02%--__remove_inode_hash
> >                        |          evict
> >                        |          prune_icache_sb
> >                        |          super_cache_scan
> >                        |          shrink_slab
> >                        |          shrink_node
> >                        |          |
> >                        |          |--2.16%--try_to_free_pages
> >                        |          |          __alloc_pages_slowpath.con=
stprop.0
> >                        |          |          __alloc_pages_noprof
> >                        |          |          __vmalloc_node_range_nopro=
f
> >                        |          |          kvmalloc_node_noprof
> >                        |          |          bucket_table_alloc
> >                        |          |          rht_deferred_worker
> >                        |          |          process_one_work
> >                        |          |
> >                        |           --1.86%--balance_pgdat
> >                        |                     kswapd
> >                        |                     kthread
> >                        |                     ret_from_fork
> >                        |                     ret_from_fork_asm
> >                        |
> >                         --1.82%--list_lru_add_obj
> >                                   |
> >                                    --1.81%--d_lru_add
> >                                              dput
> >                                              |
> >                                               --1.81%--path_put
> >                                                         vfs_statx
> >                                                         vfs_fstatat
> >                                                         __do_sys_newfst=
atat
> >                                                         __x64_sys_newfs=
tatat
> >                                                         x64_sys_call
> >                                                         do_syscall_64
> >                                                         entry_SYSCALL_6=
4_after_hwframe
> >                                                         __GI___fstatat6=
4
> >
> >      2.44%  [k] _raw_spin_lock                            -      -
> >             |
> >             |--1.02%--bch2_inode_insert
> >             |          bch2_lookup_trans
> >             |          bch2_lookup
> >             |          __lookup_slow
> >             |          walk_component
> >             |          |
> >             |           --1.02%--path_lookupat
> >             |                     filename_lookup
> >             |                     vfs_statx
> >             |                     vfs_fstatat
> >             |                     __do_sys_newfstatat
> >             |                     __x64_sys_newfstatat
> >             |                     x64_sys_call
> >             |                     do_syscall_64
> >             |                     entry_SYSCALL_64_after_hwframe
> >             |                     __GI___fstatat64
> >             |
> >              --0.84%--bch2_lookup_trans
> >                        bch2_lookup
> >                        __lookup_slow
> >                        walk_component
> >                        |
> >                         --0.84%--path_lookupat
> >                                   filename_lookup
> >                                   vfs_statx
> >                                   vfs_fstatat
> >                                   __do_sys_newfstatat
> >                                   __x64_sys_newfstatat
> >                                   x64_sys_call
> >                                   do_syscall_64
> >                                   entry_SYSCALL_64_after_hwframe
> >                                   __GI___fstatat64
> >
> >      2.09%  [k] mutex_spin_on_owner                       -      -
> >             |
> >              --2.09%--__mutex_lock.constprop.0
> >                        __mutex_lock_slowpath
> >                        mutex_lock
> >                        |
> >                         --2.08%--bch2_btree_path_traverse_cached_slowpa=
th
> >                                   bch2_btree_path_traverse_cached
> >                                   bch2_btree_path_traverse_one
> >                                   |
> >                                   |--1.53%--bch2_btree_iter_peek_slot
> >                                   |          bch2_inode_peek_nowarn
> >                                   |          bch2_inode_find_by_inum_no=
warn_trans
> >                                   |          bch2_lookup_trans
> >                                   |          bch2_lookup
> >                                   |          __lookup_slow
> >                                   |          walk_component
> >                                   |          path_lookupat
> >                                   |          filename_lookup
> >                                   |
> >                                    --0.55%--bch2_trans_update_get_key_c=
ache
> >                                              bch2_trans_update
> >                                              bch2_inode_write_flags
> >                                              bch2_create_trans
> >                                              __bch2_create
> >                                              bch2_create
> >                                              path_openat
> >                                              do_filp_open
> >                                              do_sys_openat2
> >
> >      1.95%  [k] find_inode                                -      -
> >             |
> >              --1.87%--ilookup5_nowait
> >                        bch2_lookup_trans
> >                        bch2_lookup
> >                        __lookup_slow
> >                        walk_component
> >                        |
> >                         --1.87%--path_lookupat
> >                                   filename_lookup
> >                                   vfs_statx
> >                                   vfs_fstatat
> >                                   __do_sys_newfstatat
> >                                   __x64_sys_newfstatat
> >                                   x64_sys_call
> >                                   do_syscall_64
> >                                   entry_SYSCALL_64_after_hwframe
> >                                   __GI___fstatat64
> >
> >      1.28%  [k] osq_lock                                  -      -
> >             |
> >              --1.28%--__mutex_lock.constprop.0
> >                        __mutex_lock_slowpath
> >                        mutex_lock
> >                        |
> >                         --1.19%--bch2_btree_path_traverse_cached_slowpa=
th
> >                                   bch2_btree_path_traverse_cached
> >                                   bch2_btree_path_traverse_one
> >                                   bch2_btree_iter_peek_slot
> >                                   bch2_inode_peek_nowarn
> >                                   bch2_inode_find_by_inum_nowarn_trans
> >                                   bch2_lookup_trans
> >                                   bch2_lookup
> >                                   __lookup_slow
> >                                   walk_component
> >                                   path_lookupat
> >                                   filename_lookup
> >
> >      1.13%  [k] bch2_btree_node_iter_init                 -      -
> >             |
> >              --1.13%--bch2_btree_path_level_init
> >                        bch2_btree_path_traverse_one
> >                        |
> >                         --1.13%--bch2_btree_iter_peek_slot
> >                                   |
> >                                   |--0.57%--bch2_lookup_trans
> >                                   |          bch2_lookup
> >                                   |          __lookup_slow
> >                                   |          walk_component
> >                                   |          |
> >                                   |           --0.57%--path_lookupat
> >                                   |                     filename_lookup
> >                                   |                     vfs_statx
> >                                   |                     vfs_fstatat
> >                                   |                     __do_sys_newfst=
atat
> >                                   |                     __x64_sys_newfs=
tatat
> >                                   |                     x64_sys_call
> >                                   |                     do_syscall_64
> >                                   |
> >                                    --0.50%--bch2_btree_path_traverse_ca=
ched_slowpath
> >                                              bch2_btree_path_traverse_c=
ached
> >                                              bch2_btree_path_traverse_o=
ne
> >                                              bch2_btree_iter_peek_slot
> >                                              bch2_inode_peek_nowarn
> >                                              bch2_inode_find_by_inum_no=
warn_trans
> >                                              bch2_lookup_trans
> >                                              bch2_lookup
> >                                              __lookup_slow
> >                                              walk_component
> >                                              |
> >                                               --0.50%--path_lookupat
> >                                                         filename_lookup
> >
> >      0.85%  [k] __d_lookup_rcu                            -      -
> >             |
> >              --0.84%--lookup_fast
> >                        |
> >                         --0.84%--walk_component
> >                                   |
> >                                    --0.82%--path_lookupat
> >                                              filename_lookup
> >                                              vfs_statx
> >                                              vfs_fstatat
> >                                              __do_sys_newfstatat
> >                                              __x64_sys_newfstatat
> >                                              x64_sys_call
> >                                              do_syscall_64
> >                                              entry_SYSCALL_64_after_hwf=
rame
> >                                              __GI___fstatat64
> >
> >      0.84%  [k] rht_deferred_worker                       -      -
> >             |
> >             ---process_one_work
> >                worker_thread
> >                kthread
> >                ret_from_fork
> >                ret_from_fork_asm
> >
> >      0.81%  [k] bch2_btree_key_cache_find                 -      -
> >             |
> >              --0.76%--bch2_btree_path_traverse_cached
> >                        bch2_btree_path_traverse_one
> >                        bch2_btree_iter_peek_slot
> >                        bch2_inode_peek_nowarn
> >                        bch2_inode_find_by_inum_nowarn_trans
> >                        bch2_lookup_trans
> >                        bch2_lookup
> >                        __lookup_slow
> >                        walk_component
> >                        |
> >                         --0.76%--path_lookupat
> >                                   filename_lookup
> >                                   vfs_statx
> >                                   vfs_fstatat
> >                                   __do_sys_newfstatat
> >                                   __x64_sys_newfstatat
> >
> >      0.77%  [k] bch2_btree_path_traverse_one              -      -
> >             |
> >              --0.76%--bch2_btree_iter_peek_slot
> >
> >      0.59%  [k] kmem_cache_free                           -      -
> >      0.55%  [k] kfree                                     -      -
> >             |
> >              --0.53%--bch2_btree_key_cache_scan
> >                        shrink_slab
> >                        shrink_node
> >
> >      0.55%  [k] mutex_unlock                              -      -
> >             |
> >              --0.51%--bch2_lookup_trans
> >                        bch2_lookup
> >                        __lookup_slow
> >                        walk_component
> >                        |
> >                         --0.51%--path_lookupat
> >                                   filename_lookup
> >                                   vfs_statx
> >                                   vfs_fstatat
> >                                   __do_sys_newfstatat
> >                                   __x64_sys_newfstatat
> >                                   x64_sys_call
> >                                   do_syscall_64
> >                                   entry_SYSCALL_64_after_hwframe
> >                                   __GI___fstatat64
> >
> >      0.53%  [k] bch2_subvolume_get                        -      -
> >             |
> >              --0.52%--bch2_lookup_trans
> >                        bch2_lookup
> >                        __lookup_slow
> >                        walk_component
> >                        |
> >                         --0.52%--path_lookupat
> >                                   filename_lookup
> >                                   vfs_statx
> >                                   vfs_fstatat
> >                                   __do_sys_newfstatat
> >                                   __x64_sys_newfstatat
> >                                   x64_sys_call
> >                                   do_syscall_64
> >                                   entry_SYSCALL_64_after_hwframe
> >                                   __GI___fstatat64
> >
> >      0.44%  [k] bch2_btree_key_cache_scan                 -      -
> >      0.38%  [k] bch2_btree_path_traverse_cached_slowpath  -      -
> >      0.31%  [k] six_unlock_ip                             -      -
> >      0.27%  [k] __do_six_trylock                          -      -
> >      0.26%  [k] bch2_bkey_pack_pos_lossy                  -      -
> >      0.26%  [k] _raw_spin_trylock                         -      -
> >      0.25%  [k] rcu_cblist_dequeue                        -      -
> >      0.23%  [k] d_alloc_parallel                          -      -
> >      0.23%  [k] __list_lru_walk_one.constprop.0           -      -
> >      0.22%  [k] __bch2_bkey_unpack_key                    -      -
> >      0.22%  [k] mutex_lock                                -      -
> >      0.22%  [k] kmem_cache_alloc_noprof                   -      -
> >      0.21%  [k] bch2_btree_iter_peek_slot                 -      -
> >      0.18%  [k] evict                                     -      -
> >      0.18%  [k] bch2_btree_node_get                       -      -
> >      0.17%  [k] bch2_path_get                             -      -
> >      0.16%  [k] memset                                    -      -
> >      0.16%  [k] __bch2_bkey_cmp_packed_format_checked     -      -
> >      0.16%  [k] bch2_trans_iter_init_outlined             -      -
> >      0.15%  [k] __btree_path_up_until_good_node           -      -
> >      0.15%  [k] bch2_inode_unpack_v3                      -      -
> >      0.15%  [k] bch2_path_put                             -      -
> >      0.15%  [k] bch2_btree_iter_peek_upto                 -      -
> >      0.15%  [k] inode_insert5                             -      -
> >      0.14%  [k] pvclock_clocksource_read_nowd             -      -
> >      0.14%  [k] bch2_lookup_trans                         -      -
> >      0.13%  [k] bch2_iget5_test                           -      -
> >      0.13%  [.] __printf_buffer                           -      -
> >      0.13%  [k] __slab_free                               -      -
> >      0.13%  [k] bch2_bkey_unpack                          -      -
> >      0.13%  [k] bch2_varint_decode_fast                   -      -
> >      0.13%  [k] bch2_btree_path_peek_slot                 -      -
> >      0.12%  [k] __bch2_btree_trans_sort_paths             -      -
> >      0.12%  [k] bch2_subvolume_get_snapshot               -      -
> >      0.11%  [k] __srcu_read_lock                          -      -
> >      0.11%  [k] ___slab_alloc                             -      -
> >      0.11%  [k] btree_path_alloc                          -      -
> >      0.11%  [k] __kmalloc_noprof                          -      -
> >      0.10%  [k] bch2_btree_path_level_init                -      -
> >      0.09%  [k] _copy_to_user                             -      -
> >      0.08%  [k] inode_init_always                         -      -
> >      0.08%  [k] __d_add                                   -      -
> >      0.08%  [k] iput                                      -      -
> >      0.08%  [k] ___d_drop                                 -      -
> >      0.07%  [k] __d_lookup_unhash                         -      -
> >      0.07%  [k] filename_lookup                           -      -
> >      0.07%  [k] ilookup5_nowait                           -      -
> >      0.06%  [k] x86_pmu_disable_all                       -      -
> >      0.06%  [k] cp_new_stat                               -      -
> >      0.06%  [k] bch2_evict_inode                          -      -
> >      0.06%  [k] rhashtable_insert_slow                    -      -
> >      0.06%  [k] entry_SYSCALL_64                          -      -
> >      0.06%  [k] __mutex_init                              -      -
> >      0.06%  [k] kmem_cache_alloc_lru_noprof               -      -
> >      0.06%  [k] __init_rwsem                              -      -
> >      0.06%  [k] d_splice_alias                            -      -
> >      0.06%  [k] strncpy_from_user                         -      -
> >      0.06%  [k] bch2_inode_update_after_write             -      -
> >      0.06%  [k] SipHash_End                               -      -
> >      0.05%  [k] _raw_spin_lock_irqsave                    -      -
> >      0.05%  [k] bch2_bkey_cmp_packed                      -      -
> >      0.05%  [k] __bch2_bkey_get_val_typed.constprop.0     -      -
> >      0.05%  [k] bch2_trans_unlock                         -      -
> >      0.05%  [k] d_set_d_op                                -      -
> >      0.05%  [k] list_lru_add_obj                          -      -
> >      0.05%  [k] bch2_dirent_hash                          -      -
> >      0.05%  [k] vfs_getattr_nosec                         -      -
> >      0.05%  [k] memcpy                                    -      -
> >      0.05%  [k] path_init                                 -      -
> >      0.05%  [k] bch2_trans_downgrade                      -      -
> >      0.04%  [k] bch2_btree_node_unlock_write              -      -
> >      0.04%  [k] link_path_walk.part.0.constprop.0         -      -
> >      0.04%  [k] __bch2_trans_get                          -      -
> >      0.04%  [k] asm_sysvec_apic_timer_interrupt           -      -
> >      0.04%  [k] rhashtable_jhash2                         -      -
> >      0.04%  [k] bkey_cached_evict                         -      -
> >      0.04%  [k] dirent_cmp_key                            -      -
> >      0.04%  [k] inode_init_once                           -      -
> >      0.04%  [k] list_lru_isolate_move                     -      -
> >      0.04%  [k] __d_rehash                                -      -
> >      0.04%  [.] __strchrnul_avx2                          -      -
> >      0.04%  [k] allocate_slab                             -      -
> >      0.04%  [.] __printf_buffer_write                     -      -
> >      0.04%  [k] __do_sys_newfstatat                       -      -
> >      0.04%  [.] sprintf                                   -      -
> >      0.04%  [.] _itoa_word                                -      -
> >      0.03%  [k] six_trylock_ip                            -      -
> >      0.03%  [k] truncate_inode_pages_range                -      -
> >      0.03%  [k] bch2_inode_peek_nowarn                    -      -
> >      0.03%  [k] __rht_bucket_nested                       -      -
> >      0.03%  [k] __d_alloc                                 -      -
> >      0.03%  [k] bch2_inode_find_by_inum_nowarn_trans      -      -
> >      0.03%  [k] SipHash_Rounds                            -      -
> >      0.03%  [k] rcu_segcblist_enqueue                     -      -
> >      0.03%  [k] clear_inode                               -      -
> >      0.02%  [.] main                                      -      -
> >      0.02%  [k] __bch2_new_inode                          -      -
> >      0.02%  [k] syscall_return_via_sysret                 -      -
> >      0.02%  [k] btree_trans_peek_key_cache                -      -
> >      0.02%  [k] bch2_trans_iter_exit                      -      -
> >      0.02%  [.] __GI___fstatat64                          -      -
> >      0.02%  [k] bch2_hash_info_init                       -      -
> >      0.02%  [k] __init_waitqueue_head                     -      -
> >      0.02%  [k] bch2_trans_put                            -      -
> >      0.02%  [k] step_into                                 -      -
> >      0.02%  [k] inode_permission                          -      -
> >      0.02%  [k] srcu_gp_start_if_needed                   -      -
> >      0.02%  [k] terminate_walk                            -      -
> >      0.02%  [k] bch2_inode_insert                         -      -
> >      0.02%  [k] bch2_set_btree_iter_dontneed              -      -
> >      0.02%  [k] d_alloc                                   -      -
> >      0.02%  [k] lapic_next_deadline                       -      -
> >      0.02%  [k] inode_lru_isolate                         -      -
> >      0.02%  [k] __srcu_read_unlock                        -      -
> >      0.02%  [k] path_lookupat                             -      -
> >      0.02%  [.] __memmove_avx_unaligned_erms              -      -
> >      0.02%  [k] lockref_put_return                        -      -
> >      0.02%  [k] __legitimize_mnt                          -      -
> >      0.02%  [k] bch2_getattr                              -      -
> >      0.02%  [k] __rmqueue_pcplist                         -      -
> >      0.02%  [k] generic_permission                        -      -
> >      0.02%  [k] vfs_statx                                 -      -
> >      0.02%  [k] __call_rcu_common.constprop.0             -      -
> >      0.02%  [k] bch2_vfs_inode_init.isra.0                -      -
> >      0.02%  [k] bch2_btree_node_iter_advance              -      -
> >      0.02%  [k] bch2_btree_path_traverse_cached           -      -
> >      0.02%  [k] bch2_trans_begin                          -      -
> >      0.01%  [k] walk_component                            -      -
> >      0.01%  [k] dput                                      -      -
> >      0.01%  [.] __vsprintf_internal                       -      -
> >      0.01%  [k] bch2_lookup                               -      -
> >      0.01%  [k] lockref_get_not_dead                      -      -
> >      0.01%  [k] bch2_new_inode                            -      -
> >      0.01%  [k] syscall_exit_to_user_mode                 -      -
> >      0.01%  [k] __bch2_trans_commit                       -      -
> >      0.01%  [k] getname_flags                             -      -
> >      0.01%  [k] up_read                                   -      -
> >      0.01%  [k] __remove_inode_hash                       -      -
> >      0.01%  [k] bch2_iget5_set                            -      -
> >      0.01%  [k] _find_first_zero_bit                      -      -
> >      0.01%  [k] __cond_resched                            -      -
> >      0.01%  [k] putname                                   -      -
> >      0.01%  [k] i_callback                                -      -
> >      0.01%  [k] bch2_dirent_read_target                   -      -
> >      0.01%  [k] do_syscall_64                             -      -
> >      0.01%  [k] SipHash_Update.part.0                     -      -
> >      0.01%  [k] complete_walk                             -      -
> >      0.01%  [k] update_curr                               -      -
> >      0.01%  [k] lookup_fast                               -      -
> >      0.01%  [k] x64_sys_call                              -      -
> >      0.01%  [k] __free_one_page                           -      -
> >      0.01%  [k] dirent_is_visible                         -      -
> >      0.01%  [k] dirent_hash_key                           -      -
> >      0.01%  [k] _atomic_dec_and_lock                      -      -
> >      0.01%  [k] legitimize_links                          -      -
> >      0.01%  [k] memcmp                                    -      -
> >      0.01%  [k] account_system_index_time                 -      -
> >      0.01%  [k] should_failslab.constprop.0               -      -
> >      0.01%  [k] perf_adjust_freq_unthr_context            -      -
> >      0.01%  [k] truncate_inode_pages_final                -      -
> >      0.01%  [k] _raw_spin_lock_irq                        -      -
> >      0.01%  [k] __x64_sys_newfstatat                      -      -
> >      0.01%  [k] unlock_new_inode                          -      -
> >      0.01%  [k] down_read                                 -      -
> >      0.01%  [k] __lookup_slow                             -      -
> >      0.01%  [k] d_lru_add                                 -      -
> >      0.01%  [k] rcu_sched_clock_irq                       -      -
> >      0.01%  [k] kvm_sched_clock_read                      -      -
> >      0.01%  [.] __printf_buffer_done                      -      -
> >      0.01%  [k] copy_page_from_iter_atomic                -      -
> >      0.01%  [k] _raw_spin_unlock_irqrestore               -      -
> >      0.01%  [k] prep_compound_page                        -      -
> >      0.01%  [k] entry_SYSCALL_64_after_hwframe            -      -
> >      0.01%  [k] __free_pages                              -      -
> >      0.01%  [k] fpregs_assert_state_consistent            -      -
> >      0.01%  [k] wake_up_bit                               -      -
> >      0.01%  [k] SipHash_Init                              -      -
> >      0.01%  [k] __update_load_avg_cfs_rq                  -      -
> >      0.01%  [k] entry_SYSCALL_64_safe_stack               -      -
> >      0.01%  [k] __update_load_avg_se                      -      -
> >      0.01%  [k] hrtimer_active                            -      -
> >      0.01%  [k] try_to_unlazy                             -      -
> >      0.01%  [.] __GI___stat64                             -      -
> >      0.01%  [k] __six_lock_init                           -      -
> >      0.01%  [k] __legitimize_path                         -      -
> >      0.01%  [k] __kmalloc_node_noprof                     -      -
> >      0.01%  [k] dentry_unlink_inode                       -      -
> >      0.01%  [k] local_clock_noinstr                       -      -
> >      0.01%  [k] get_page_from_freelist                    -      -
> >      0.01%  [k] inode_has_buffers                         -      -
> >      0.01%  [k] ktime_get                                 -      -
> >      0.01%  [k] local_clock                               -      -
> >      0.01%  [k] mntput_no_expire                          -      -
> >      0.01%  [k] account_process_tick                      -      -
> >      0.01%  [k] ktime_get_update_offsets_now              -      -
> >      0.01%  [k] vfs_fstatat                               -      -
> >      0.01%  [k] mntput                                    -      -
> >      0.01%  [k] __dentry_kill                             -      -
> >      0.01%  [k] d_flags_for_inode                         -      -
> >      0.01%  [k] bucket_table_alloc                        -      -
> >      0.00%  [k] clear_page_erms                           -      -
> >      0.00%  [k] sched_tick                                -      -
> >      0.00%  [k] update_load_avg                           -      -
> >      0.00%  [k] dentry_lru_isolate                        -      -
> >      0.00%  [k] __mutex_lock.constprop.0                  -      -
> >      0.00%  [k] mod_node_page_state                       -      -
> >      0.00%  [k] sched_clock_noinstr                       -      -
> >      0.00%  [k] queue_work_on                             -      -
> >      0.00%  [k] make_vfsuid                               -      -
> >      0.00%  [k] six_lock_exit                             -      -
> >      0.00%  [k] bch2_printbuf_exit                        -      -
> >      0.00%  [k] page_ext_get                              -      -
> >      0.00%  [k] poll_state_synchronize_srcu               -      -
> >      0.00%  [k] arch_scale_freq_tick                      -      -
> >      0.00%  [k] __cgroup_account_cputime_field            -      -
> >      0.00%  [k] default_idle                              -      -
> >      0.00%  [k] __wake_up                                 -      -
> >      0.00%  [k] path_put                                  -      -
> >      0.00%  [k] rcu_core                                  -      -
> >      0.00%  [k] fault_in_readable                         -      -
> >      0.00%  [k] bkey_cached_lock_for_evict                -      -
> >      0.00%  [.] sprintf@plt                               -      -
> >      0.00%  [k] set_nlink                                 -      -
> >      0.00%  [k] tick_nohz_handler                         -      -
> >      0.00%  [k] fsnotify_grab_connector                   -      -
> >      0.00%  [k] __inode_wait_for_writeback                -      -
> >      0.00%  [k] __alloc_pages_noprof                      -      -
> >      0.00%  [k] six_lock_ip_waiter                        -      -
> >      0.00%  [k] __wake_up_common                          -      -
> >      0.00%  [k] isolate_migratepages_block                -      -
> >      0.00%  [k] prune_icache_sb                           -      -
> >      0.00%  [k] __mod_zone_page_state                     -      -
> >      0.00%  [k] hrtimer_interrupt                         -      -
> >      0.00%  [k] sched_clock_cpu                           -      -
> >      0.00%  [k] irq_entries_start                         -      -
> >      0.00%  [k] post_alloc_hook                           -      -
> >      0.00%  [k] rb_next                                   -      -
> >      0.00%  [k] locks_free_lock_context                   -      -
> >      0.00%  [k] shrink_dentry_list                        -      -
> >      0.00%  [k] call_rcu                                  -      -
> >      0.00%  [k] __reset_isolation_pfn                     -      -
> >      0.00%  [k] entry_SYSRETQ_unsafe_stack                -      -
> >      0.00%  [k] rht_bucket_nested                         -      -
> >      0.00%  [k] bch2_btree_lock_init                      -      -
> >      0.00%  [k] lock_for_kill                             -      -
> >      0.00%  [k] update_process_times                      -      -
> >      0.00%  [k] __put_partials                            -      -
> >      0.00%  [k] __destroy_inode                           -      -
> >      0.00%  [k] kvm_clock_get_cycles                      -      -
> >      0.00%  [k] update_rq_clock                           -      -
> >      0.00%  [k] irq_work_tick                             -      -
> >      0.00%  [k] x86_pmu_disable                           -      -
> >      0.00%  [k] kvm_steal_clock                           -      -
> >      0.00%  [k] inode_wait_for_writeback                  -      -
> >      0.00%  [k] rcu_segcblist_ready_cbs                   -      -
> >      0.00%  [k] task_tick_fair                            -      -
> >      0.00%  [k] btree_cache_find                          -      -
> >      0.00%  [k] __zone_watermark_ok                       -      -
> >      0.00%  [k] update_sd_lb_stats.constprop.0            -      -
> >      0.00%  [k] fsnotify_destroy_marks                    -      -
> >      0.00%  [k] put_cpu_partial                           -      -
> >      0.00%  [k] task_mm_cid_work                          -      -
> >      0.00%  [k] percpu_counter_add_batch                  -      -
> >      0.00%  [k] sched_clock_tick                          -      -
> >      0.00%  [k] SipHash_Update                            -      -
> >      0.00%  [k] bit_waitqueue                             -      -
> >      0.00%  [k] __hrtimer_run_queues                      -      -
> >      0.00%  [k] acct_account_cputime                      -      -
> >      0.00%  [k] __d_lookup                                -      -
> >      0.00%  [.] __strchrnul_ifunc@plt                     -      -
> >      0.00%  [k] nested_table_alloc.part.0.isra.0          -      -
> >      0.00%  [k] free_unref_page_commit                    -      -
> >      0.00%  [k] xas_load                                  -      -
> >      0.00%  [k] is_bad_inode                              -      -
> >      0.00%  [k] perf_poll                                 -      -
> >      0.00%  [.] memcpy@@GLIBC_2.14@plt                    -      -
> >      0.00%  [k] amd_clear_divider                         -      -
> >      0.00%  [k] bch2_btree_key_cache_cmp_fn               -      -
> >      0.00%  [k] ext4_da_get_block_prep                    -      -
> >      0.00%  [k] free_unref_page                           -      -
> >      0.00%  [k] clockevents_program_event                 -      -
> >      0.00%  [k] __block_write_begin_int                   -      -
> >      0.00%  [k] amd_pmu_addr_offset                       -      -
> >      0.00%  [k] start_poll_synchronize_srcu               -      -
> >      0.00%  [k] rb_erase                                  -      -
> >      0.00%  [k] alloc_slab_obj_exts                       -      -
> >      0.00%  [k] default_send_IPI_single_phys              -      -
> >      0.00%  [k] __cgroup_account_cputime                  -      -
> >      0.00%  [k] perf_event_task_tick                      -      -
> >      0.00%  [k] __get_user_8                              -      -
> >      0.00%  [k] destroy_inode                             -      -
> >      0.00%  [k] task_tick_mm_cid                          -      -
> >      0.00%  [k] discard_slab                              -      -
> >      0.00%  [k] pick_next_task_fair                       -      -
> >      0.00%  [k] xas_start                                 -      -
> >      0.00%  [k] mod_zone_page_state                       -      -
> >      0.00%  [k] ext4_da_write_end                         -      -
> >      0.00%  [k] irq_work_run_list                         -      -
> >      0.00%  [k] __build_ro_aux_tree                       -      -
> >      0.00%  [k] amd_pmu_disable_all                       -      -
> >      0.00%  [k] rcu_all_qs                                -      -
> >      0.00%  [k] copy_page                                 -      -
> >      0.00%  [k] asm_exc_page_fault                        -      -
> >      0.00%  [k] lockref_mark_dead                         -      -
> >      0.00%  [k] __fsnotify_inode_delete                   -      -
> >      0.00%  [k] page_ext_put                              -      -
> >      0.00%  [k] osq_unlock                                -      -
> >      0.00%  [k] rht_bucket_nested_insert                  -      -
> >      0.00%  [k] generic_perform_write                     -      -
> >      0.00%  [k] validate_bset_keys                        -      -
> >      0.00%  [k] ext4_bio_write_folio                      -      -
> >      0.00%  [k] do_sys_poll                               -      -
> >      0.00%  [k] filemap_get_entry                         -      -
> >      0.00%  [k] rcu_implicit_dynticks_qs                  -      -
> >      0.00%  [k] delay_tsc                                 -      -
> >      0.00%  [k] sched_balance_rq                          -      -
> >      0.00%  [k] free_pcppages_bulk                        -      -
> >      0.00%  [k] __es_insert_extent                        -      -
> >      0.00%  [k] __sysvec_apic_timer_interrupt             -      -
> >      0.00%  [k] calc_global_load_tick                     -      -
> >      0.00%  [k] __free_slab                               -      -
> >      0.00%  [.] 0x000000000024ea3e                        -      -
> >      0.00%  [k] check_init_srcu_struct                    -      -
> >      0.00%  [k] balance_dirty_pages_ratelimited_flags     -      -
> >      0.00%  [k] bch2_sort_keys                            -      -
> >      0.00%  [k] kmalloc_trace_noprof                      -      -
> >      0.00%  [k] perf_mmap_fault                           -      -
> >      0.00%  [k] ext4_da_write_begin                       -      -
> >      0.00%  [k] suitable_migration_target                 -      -
> >      0.00%  [k] vfs_write                                 -      -
> >      0.00%  [k] __block_commit_write                      -      -
> >      0.00%  [k] isolate_freepages_block                   -      -
> >      0.00%  [k] xas_find                                  -      -
> >      0.00%  [k] bch2_bkey_cmp_packed_inlined              -      -
> >      0.00%  [k] __fdget                                   -      -
> >      0.00%  [k] xas_store                                 -      -
> >      0.00%  [k] vma_interval_tree_insert                  -      -
> >      0.00%  [k] xas_create                                -      -
> >      0.00%  [.] do_lookup_x                               -      -
> >      0.00%  [k] create_empty_buffers                      -      -
> >      0.00%  [k] ext4_finish_bio                           -      -
> >      0.00%  [k] down_write                                -      -
> >      0.00%  [k] __schedule                                -      -
> >      0.00%  [k] xas_find_conflict                         -      -
> >      0.00%  [k] ioread8                                   -      -
> >      0.00%  [k] __mod_node_page_state                     -      -
> >      0.00%  [k] ext4_buffered_write_iter                  -      -
> >      0.00%  [k] __filemap_get_folio                       -      -
> >      0.00%  [k] sched_balance_newidle                     -      -
> >      0.00%  [k] set_next_entity                           -      -
> >      0.00%  [k] dequeue_task_fair                         -      -
> >      0.00%  [k] rwsem_spin_on_owner                       -      -
> >      0.00%  [k] __filemap_add_folio                       -      -
> >      0.00%  [k] switch_mm_irqs_off                        -      -
> >      0.00%  [k] clean_bdev_aliases                        -      -
> >      0.00%  [k] restore_regs_and_return_to_kernel         -      -
> >      0.00%  [k] folio_unlock                              -      -
> >      0.00%  [k] ___bpf_prog_run                           -      -
> >      0.00%  [k] native_apic_mem_read                      -      -
> >      0.00%  [k] save_fpregs_to_fpstate                    -      -
> >      0.00%  [k] mark_buffer_dirty                         -      -
> >      0.00%  [k] next_uptodate_folio                       -      -
> >      0.00%  [k] filemap_get_folios_tag                    -      -
> >      0.00%  [k] ttwu_queue_wakelist                       -      -
> >      0.00%  [k] select_task_rq_fair                       -      -
> >      0.00%  [k] lock_vma_under_rcu                        -      -
> >      0.00%  [k] cpu_util.constprop.0                      -      -
> >      0.00%  [k] sysvec_apic_timer_interrupt               -      -
> >      0.00%  [k] __enqueue_entity                          -      -
> >      0.00%  [k] node_dirty_ok                             -      -
> >      0.00%  [k] activate_task                             -      -
> >      0.00%  [k] irqentry_exit                             -      -
> >      0.00%  [k] __netif_receive_skb_list_core             -      -
> >      0.00%  [k] timerqueue_del                            -      -
> >      0.00%  [k] wake_q_add                                -      -
> >      0.00%  [k] unmap_page_range                          -      -
> >      0.00%  [k] __switch_to_asm                           -      -
> >      0.00%  [k] place_entity                              -      -
> >      0.00%  [k] decay_pcp_high                            -      -
> >      0.00%  [k] asm_sysvec_reschedule_ipi                 -      -
> >      0.00%  [k] ext4_es_can_be_merged.isra.0              -      -
> >      0.00%  [k] hrtimer_run_queues                        -      -
> >      0.00%  [k] bch2_dirent_invalid                       -      -
> >      0.00%  [k] list_lru_walk_one                         -      -
> >      0.00%  [k] bch2_dirent_create                        -      -
> >      0.00%  [k] list_lru_count_one                        -      -
> >      0.00%  [k] bch2_free_inode                           -      -
> >      0.00%  [.] dl_main                                   -      -
> >      0.00%  [k] bch2_trans_unlock_write                   -      -
> >      0.00%  [k] asm_sysvec_call_function_single           -      -
> >      0.00%  [k] __d_free                                  -      -
> >      0.00%  [k] super_cache_scan                          -      -
> >      0.00%  [k] __mutex_unlock_slowpath.isra.0            -      -
> >      0.00%  [k] list_lru_isolate                          -      -
> >      0.00%  [k] ext4_has_free_clusters                    -      -
> >      0.00%  [k] __put_user_8                              -      -
> >      0.00%  [k] tick_do_update_jiffies64                  -      -
> >      0.00%  [k] error_return                              -      -
> >      0.00%  [k] task_work_add                             -      -
> >      0.00%  [k] task_work_run                             -      -
> >      0.00%  [k] alloc_empty_file                          -      -
> >      0.00%  [k] bch2_bkey_has_device_c                    -      -
> >      0.00%  [k] free_tail_page_prepare                    -      -
> >      0.00%  [k] get_pfnblock_flags_mask                   -      -
> >      0.00%  [k] pageblock_skip_persistent                 -      -
> >      0.00%  [k] native_flush_tlb_global                   -      -
> >      0.00%  [k] wake_up_q                                 -      -
> >      0.00%  [k] split_page                                -      -
> >      0.00%  [k] sched_mm_cid_remote_clear                 -      -
> >      0.00%  [k] dev_gro_receive                           -      -
> >      0.00%  [k] free_page_and_swap_cache                  -      -
> >      0.00%  [k] tcp_ack                                   -      -
> >      0.00%  [k] __bch2_btree_node_get                     -      -
> >      0.00%  [k] skb_copy_datagram_iter                    -      -
> >      0.00%  [k] __mark_inode_dirty                        -      -
> >      0.00%  [k] __fdget_pos                               -      -
> >      0.00%  [k] folio_migrate_flags                       -      -
> >      0.00%  [k] migrate_pages                             -      -
> >      0.00%  [k] find_suitable_fallback                    -      -
> >      0.00%  [.] handle_amd                                -      -
> >      0.00%  [k] bch2_bkey_transform                       -      -
> >      0.00%  [k] __folio_mark_dirty                        -      -
> >      0.00%  [k] do_idle                                   -      -
> >      0.00%  [k] __pte_offset_map_lock                     -      -
> >      0.00%  [k] generic_write_checks                      -      -
> >      0.00%  [k] ct_kernel_exit.constprop.0                -      -
> >      0.00%  [k] tcp_sendmsg_locked                        -      -
> >      0.00%  [k] task_tick_idle                            -      -
> >      0.00%  [k] folio_add_lru                             -      -
> >      0.00%  [k] shmem_mapping                             -      -
> >      0.00%  [k] ct_kernel_enter_state                     -      -
> >      0.00%  [k] filemap_add_folio                         -      -
> >      0.00%  [k] folio_end_writeback                       -      -
> >      0.00%  [.] 0x0000000000058f6e                        -      -
> >      0.00%  [k] should_fail_alloc_page                    -      -
> >      0.00%  [k] ext4_reserve_inode_write                  -      -
> >      0.00%  [.] 0x0000000000057e58                        -      -
> >      0.00%  [k] __folio_end_writeback                     -      -
> >      0.00%  [k] folio_clear_dirty_for_io                  -      -
> >      0.00%  [k] bvec_try_merge_page                       -      -
> >      0.00%  [k] __folio_start_writeback                   -      -
> >      0.00%  [k] ksys_write                                -      -
> >      0.00%  [.] 0x00000000002496ce                        -      -
> >      0.00%  [k] bio_alloc_bioset                          -      -
> >      0.00%  [k] mpage_submit_folio                        -      -
> >      0.00%  [.] __GI___libc_write                         -      -
> >      0.00%  [.] 0x0000000000057a3a                        -      -
> >      0.00%  [k] ext4_last_io_end_vec                      -      -
> >      0.00%  [k] ext4_es_insert_delayed_block              -      -
> >      0.00%  [k] idle_cpu                                  -      -
> >      0.00%  [k] bch2_btree_node_iter_peek_unpack          -      -
> >      0.00%  [k] copy_mc_enhanced_fast_string              -      -
> >      0.00%  [.] malloc                                    -      -
> >      0.00%  [k] avg_vruntime                              -      -
> >      0.00%  [.] _init_first                               -      -
> >      0.00%  [k] __es_remove_extent                        -      -
> >      0.00%  [k] filemap_get_folios                        -      -
> >      0.00%  [.] 0x000000000005ab57                        -      -
> >      0.00%  [k] __switch_to                               -      -
> >      0.00%  [k] folio_batch_move_lru                      -      -
> >      0.00%  [k] __es_tree_search.isra.0                   -      -
> >      0.00%  [k] block_write_end                           -      -
> >      0.00%  [.] 0x000000000024ea58                        -      -
> >      0.00%  [.] __libc_early_init                         -      -
> >      0.00%  [k] __bch2_inode_invalid                      -      -
> >      0.00%  [.] __GI___pthread_disable_asynccancel        -      -
> >      0.00%  [k] alloc_buffer_head                         -      -
> >      0.00%  [k] isolate_movable_page                      -      -
> >      0.00%  [k] ipv4_dst_check                            -      -
> >      0.00%  [k] schedule                                  -      -
> >      0.00%  [.] 0x000000000005aa60                        -      -
> >      0.00%  [k] anon_vma_fork                             -      -
> >      0.00%  [k] mas_walk                                  -      -
> >      0.00%  [k] up_write                                  -      -
> >      0.00%  [.] __vdso_clock_gettime                      -      -
> >      0.00%  [k] force_qs_rnp                              -      -
> >      0.00%  [k] mas_update_gap.part.0                     -      -
> >      0.00%  [k] inode_needs_update_time                   -      -
> >      0.00%  [k] blk_mq_submit_bio                         -      -
> >      0.00%  [.] __memset_avx2_unaligned_erms              -      -
> >      0.00%  [k] exc_page_fault                            -      -
> >      0.00%  [.] _dl_check_all_versions                    -      -
> >      0.00%  [k] ext4_dirty_inode                          -      -
> >      0.00%  [k] tick_program_event                        -      -
> >      0.00%  [.] 0x000000000012c245                        -      -
> >      0.00%  [k] ext4_mark_iloc_dirty                      -      -
> >      0.00%  [.] _dl_lookup_symbol_x                       -      -
> >      0.00%  [k] switch_fpu_return                         -      -
> >      0.00%  [k] bch2_btree_post_write_cleanup             -      -
> >      0.00%  [k] rwsem_down_write_slowpath                 -      -
> >      0.00%  [k] crc_pcl                                   -      -
> >      0.00%  [k] mpage_process_page_bufs                   -      -
> >      0.00%  [k] __btree_split_node.isra.0                 -      -
> >      0.00%  [k] rcu_gp_fqs_loop                           -      -
> >      0.00%  [k] ext4_es_lookup_extent                     -      -
> >      0.00%  [k] six_lock_slowpath.isra.0                  -      -
> >      0.00%  [k] chacha_permute                            -      -
> >      0.00%  [k] add_wait_queue                            -      -
> >      0.00%  [k] inode_to_bdi                              -      -
> >      0.00%  [k] mmap_region                               -      -
> >      0.00%  [k] crc32c_pcl_intel_update                   -      -
> >      0.00%  [k] wbt_inflight_cb                           -      -
> >      0.00%  [k] irqentry_enter                            -      -
> >      0.00%  [k] __tcp_select_window                       -      -
> >      0.00%  [k] mas_wr_node_store                         -      -
> >      0.00%  [.] 0x000000000012c273                        -      -
> >      0.00%  [k] __block_write_begin                       -      -
> >      0.00%  [k] update_rt_rq_load_avg                     -      -
> >      0.00%  [k] netfs_put_subrequest                      -      -
> >      0.00%  [k] fput                                      -      -
> >      0.00%  [k] ext4_get_group_desc                       -      -
> >      0.00%  [k] default_idle_call                         -      -
> >      0.00%  [k] folios_put_refs                           -      -
> >      0.00%  [k] __bch2_bkey_invalid                       -      -
> >      0.00%  [k] _copy_from_user                           -      -
> >      0.00%  [.] 0x000000000024eff2                        -      -
> >      0.00%  [k] netfs_unbuffered_read_iter                -      -
> >      0.00%  [k] sbitmap_any_bit_set                       -      -
> >      0.00%  [k] resched_curr                              -      -
> >      0.00%  [k] bch2_fs_usage_acc_to_base                 -      -
> >      0.00%  [k] start_xmit                                -      -
> >      0.00%  [k] unlink_anon_vmas                          -      -
> >      0.00%  [k] kthread_is_per_cpu                        -      -
> >      0.00%  [k] timestamp_truncate                        -      -
> >      0.00%  [k] ext4_inode_csum_set                       -      -
> >      0.00%  [k] __bch2_journal_reclaim                    -      -
> >      0.00%  [k] available_idle_cpu                        -      -
> >      0.00%  [k] packet_rcv                                -      -
> >      0.00%  [k] mt_find                                   -      -
> >      0.00%  [k] __pmd_alloc                               -      -
> >      0.00%  [k] virtqueue_add_split                       -      -
> >      0.00%  [k] __free_pages_ok                           -      -
> >      0.00%  [k] blk_mq_run_hw_queue                       -      -
> >      0.00%  [k] eventfd_poll                              -      -
> >      0.00%  [k] sched_balance_softirq                     -      -
> >      0.00%  [k] enqueue_task_fair                         -      -
> >      0.00%  [k] copy_from_kernel_nofault                  -      -
> >      0.00%  [k] __radix_tree_lookup                       -      -
> >      0.00%  [k] dyntick_save_progress_counter             -      -
> >      0.00%  [k] finish_task_switch.isra.0                 -      -
> >      0.00%  [k] sock_poll                                 -      -
> >      0.00%  [k] generic_update_time                       -      -
> >      0.00%  [k] jbd2_journal_get_write_access             -      -
> >      0.00%  [k] __ext4_get_inode_loc                      -      -
> >      0.00%  [k] kmem_cache_alloc_node_noprof              -      -
> >      0.00%  [k] folio_mapping                             -      -
> >      0.00%  [k] rcu_note_context_switch                   -      -
> >      0.00%  [k] atime_needs_update                        -      -
> >      0.00%  [k] __ext4_handle_dirty_metadata              -      -
> >      0.00%  [k] __percpu_counter_init_many                -      -
> >      0.00%  [k] arch_cpu_idle                             -      -
> >      0.00%  [k] __bch2_btree_node_write                   -      -
> >      0.00%  [k] __update_stats_enqueue_sleeper            -      -
> >      0.00%  [k] handle_softirqs                           -      -
> >      0.00%  [k] native_apic_mem_eoi                       -      -
> >      0.00%  [k] perf_event_mmap                           -      -
> >      0.00%  [.] 0x000000000024eaba                        -      -
> >      0.00%  [k] file_remove_privs_flags                   -      -
> >      0.00%  [.] 0x000000000024f154                        -      -
> >      0.00%  [k] journal_validate_key                      -      -
> >      0.00%  [k] __update_stats_wait_end                   -      -
> >      0.00%  [.] 0x0000000000015c6b                        -      -
> >      0.00%  [k] vfs_read                                  -      -
> >      0.00%  [k] _raw_write_lock                           -      -
> >      0.00%  [k] __bch2_time_stats_update                  -      -
> >      0.00%  [k] bch2_bkey_val_invalid                     -      -
> >      0.00%  [k] bch2_get_next_online_dev.constprop.0      -      -
> >      0.00%  [.] __libc_fork                               -      -
> >      0.00%  [k] __find_get_block                          -      -
> >      0.00%  [k] perf_mmap_to_page                         -      -
> >      0.00%  [k] workingset_update_node                    -      -
> >      0.00%  [k] __rdgsbase_inactive                       -      -
> >      0.00%  [k] ext4_nonda_switch                         -      -
> >      0.00%  [k] filemap_map_pages                         -      -
> >      0.00%  [.] __errno_location                          -      -
> >      0.00%  [.] 0x000000000005aaf4                        -      -
> >      0.00%  [.] 0x0000000000075ada                        -      -
> >      0.00%  [k] add_transaction_credits                   -      -
> >      0.00%  [k] sg_init_table                             -      -
> >      0.00%  [k] kick_pool                                 -      -
> >      0.00%  [k] irq_exit_rcu                              -      -
> >      0.00%  [k] folio_wait_stable                         -      -
> >      0.00%  [k] __timer_delete_sync                       -      -
> >      0.00%  [k] _copy_from_iter                           -      -
> >      0.00%  [k] bch2_journal_reclaim_thread               -      -
> >      0.00%  [k] __fsnotify_parent                         -      -
> >      0.00%  [k] blk_stat_timer_fn                         -      -
> >      0.00%  [k] __journal_space_available                 -      -
> >      0.00%  [k] tick_check_broadcast_expired              -      -
> >      0.00%  [k] set_work_pool_and_clear_pending           -      -
> >      0.00%  [k] skb_release_data                          -      -
> >      0.00%  [k] cpuidle_get_cpu_driver                    -      -
> >      0.00%  [k] crypto_shash_update                       -      -
> >      0.00%  [k] mm_cid_get                                -      -
> >      0.00%  [.] 0x000000000024eac5                        -      -
> >      0.00%  [k] update_group_capacity                     -      -
> >      0.00%  [k] iowrite16                                 -      -
> >      0.00%  [k] __ext4_mark_inode_dirty                   -      -
> >      0.00%  [k] do_wp_page                                -      -
> >      0.00%  [.] 0x000000000024ea30                        -      -
> >      0.00%  [k] flush_smp_call_function_queue             -      -
> >      0.00%  [k] sched_ttwu_pending                        -      -
> >      0.00%  [k] mnt_get_write_access_file                 -      -
> >      0.00%  [.] 0x000000000005bc82                        -      -
> >      0.00%  [k] put_prev_task_fair                        -      -
> >      0.00%  [k] _copy_to_iter                             -      -
> >      0.00%  [k] sched_clock                               -      -
> >      0.00%  [k] __update_stats_wait_start                 -      -
> >      0.00%  [k] poll_freewait                             -      -
> >      0.00%  [k] native_flush_tlb_one_user                 -      -
> >      0.00%  [.] 0x00000000001b650d                        -      -
> >      0.00%  [k] bch2_bucket_gens_invalid                  -      -
> >      0.00%  [k] try_to_wake_up                            -      -
> >      0.00%  [k] tcp_poll                                  -      -
> >      0.00%  [k] enqueue_timer                             -      -
> >      0.00%  [.] 0x0000000000083623                        -      -
> >      0.00%  [k] folio_alloc_buffers                       -      -
> >      0.00%  [k] bch2_bkey_ptrs_invalid                    -      -
> >      0.00%  [.] 0x0000000000057e87                        -      -
> >      0.00%  [k] __build_skb_around                        -      -
> >      0.00%  [k] journal_flush_pins.constprop.0            -      -
> >      0.00%  [.] 0x000000000041bea2                        -      -
> >      0.00%  [k] ext4_file_write_iter                      -      -
> >      0.00%  [k] ip_send_check                             -      -
> >      0.00%  [k] ip_rcv_core                               -      -
> >      0.00%  [k] __wrgsbase_inactive                       -      -
> >      0.00%  [.] 0x000000000024eab3                        -      -
> >      0.00%  [k] run_btree_triggers                        -      -
> >      0.00%  [k] ext4_inode_csum                           -      -
> >      0.00%  [.] 0x0000000000057cb8                        -      -
> >      0.00%  [.] _Fork                                     -      -
> >      0.00%  [k] validate_bset_for_write                   -      -
> >      0.00%  [k] ip_finish_output2                         -      -
> >      0.00%  [k] bch2_trans_update                         -      -
> >      0.00%  [k] error_entry                               -      -
> >      0.00%  [k] bch2_journal_write                        -      -
> >      0.00%  [k] tcp_write_xmit                            -      -
> >      0.00%  [k] sized_strscpy                             -      -
> >      0.00%  [k] generic_write_check_limits                -      -
> >      0.00%  [k] __skb_checksum                            -      -
> >      0.00%  [.] _int_free                                 -      -
> >      0.00%  [.] 0x000000000005bd2e                        -      -
> >      0.00%  [k] raw_spin_rq_unlock                        -      -
> >      0.00%  [k] bch2_bkey_invalid                         -      -
> >      0.00%  [k] __free_old_xmit                           -      -
> >      0.00%  [k] sched_balance_update_blocked_averages     -      -
> >      0.00%  [k] __copy_skb_header                         -      -
> >      0.00%  [k] mm_init.isra.0                            -      -
> >      0.00%  [k] filp_flush                                -      -
> >      0.00%  [.] 0x0000000000057bf2                        -      -
> >      0.00%  [.] 0x0000000000077609                        -      -
> >      0.00%  [k] tcp_sendmsg                               -      -
> >      0.00%  [k] kmalloc_node_track_caller_noprof          -      -
> >      0.00%  [k] __tcp_transmit_skb                        -      -
> >      0.00%  [.] 0x000000000005aada                        -      -
> >      0.00%  [k] strncpy                                   -      -
> >      0.00%  [k] note_gp_changes                           -      -
> >      0.00%  [.] 0x0000000000061a82                        -      -
> >      0.00%  [.] 0x00000000003d2b16                        -      -
> >      0.00%  [.] 0x0000000000083376                        -      -
> >      0.00%  [.] 0x000000000007781c                        -      -
> >      0.00%  [.] 0x0000000000069339                        -      -
> >      0.00%  [k] __msecs_to_jiffies                        -      -
> >      0.00%  [.] 0x0000000000145f26                        -      -
> >      0.00%  [.] ppoll                                     -      -
> >      0.00%  [.] 0x000000000041bec4                        -      -
> >      0.00%  [k] ct_idle_exit                              -      -
> >      0.00%  [k] virtqueue_enable_cb_delayed               -      -
> >      0.00%  [.] 0x000000000005ab04                        -      -
> >      0.00%  [k] remove_wait_queue                         -      -
> >      0.00%  [k] run_timer_softirq                         -      -
> >      0.00%  [k] bch2_trans_lock_write                     -      -
> >      0.00%  [k] down_read_trylock                         -      -
> >      0.00%  [k] refresh_cpu_vm_stats                      -      -
> >      0.00%  [k] virtqueue_get_buf_ctx                     -      -
> >      0.00%  [.] 0x000000000041bb34                        -      -
> >      0.00%  [k] wq_worker_running                         -      -
> >      0.00%  [k] bch2_do_discards                          -      -
> >      0.00%  [.] 0x00000000000761d4                        -      -
> >      0.00%  [.] 0x0000000000015c63                        -      -
> >      0.00%  [k] __inet_lookup_established                 -      -
> >      0.00%  [k] blk_mq_requeue_work                       -      -
> >      0.00%  [.] 0x000000000024ea97                        -      -
> >      0.00%  [k] arch_cpu_idle_exit                        -      -
> >      0.00%  [k] __dev_queue_xmit                          -      -
> >      0.00%  [k] __sk_mem_reduce_allocated                 -      -
> >      0.00%  [k] pick_next_task_idle                       -      -
> >      0.00%  [k] bch2_trans_update_by_path                 -      -
> >      0.00%  [k] ct_nmi_exit                               -      -
> >      0.00%  [k] jbd2_journal_stop                         -      -
> >      0.00%  [k] kthread_should_stop                       -      -
> >      0.00%  [k] xas_find_marked                           -      -
> >      0.00%  [k] bch2_btree_key_cache_journal_flush        -      -
> >      0.00%  [k] sk_forced_mem_schedule                    -      -
> >      0.00%  [k] tcp_recvmsg_locked                        -      -
> >      0.00%  [.] 0x0000000000053567                        -      -
> >      0.00%  [.] 0x000000000006e5d7                        -      -
> >      0.00%  [.] 0x0000000000078366                        -      -
> >      0.00%  [.] check_match                               -      -
> >      0.00%  [.] 0x0000000000078b52                        -      -
> >      0.00%  [.] 0x0000000000021ec5                        -      -
> >      0.00%  [.] 0x0000000000053534                        -      -
> >      0.00%  [k] local_touch_nmi                           -      -
> >      0.00%  [k] rcu_qs                                    -      -
> >      0.00%  [k] __dequeue_entity                          -      -
> >      0.00%  [k] vring_map_one_sg                          -      -
> >      0.00%  [.] 0x0000000000145a51                        -      -
> >      0.00%  [k] ext4_fill_raw_inode                       -      -
> >      0.00%  [k] sched_balance_find_src_group              -      -
> >      0.00%  [.] 0x0000000000053127                        -      -
> >      0.00%  [.] clock_gettime@@GLIBC_2.17                 -      -
> >      0.00%  [k] ipv4_mtu                                  -      -
> >      0.00%  [k] skb_to_sgvec                              -      -
> >      0.00%  [.] 0x0000000000069495                        -      -
> >      0.00%  [.] 0x0000000000145ede                        -      -
> >      0.00%  [k] virtblk_request_done                      -      -
> >      0.00%  [.] 0x000000000006ebc4                        -      -
> >      0.00%  [.] 0x0000000000078303                        -      -
> >      0.00%  [k] sigprocmask                               -      -
> >      0.00%  [k] __percpu_counter_sum                      -      -
> >      0.00%  [.] 0x0000000000068de1                        -      -
> >      0.00%  [k] ip_local_out                              -      -
> >      0.00%  [.] 0x000000000006ebcf                        -      -
> >      0.00%  [k] put_prev_task_idle                        -      -
> >      0.00%  [.] 0x0000000000058f11                        -      -
> >      0.00%  [k] rcu_gp_init                               -      -
> >      0.00%  [k] can_migrate_task                          -      -
> >      0.00%  [k] native_write_cr4                          -      -
> >      0.00%  [.] EVP_CIPHER_get_block_size                 -      -
> >      0.00%  [.] 0x0000000000052d38                        -      -
> >      0.00%  [k] deactivate_task                           -      -
> >      0.00%  [.] __GI___arc4random_buf                     -      -
> >      0.00%  [k] do_user_addr_fault                        -      -
> >      0.00%  [k] bch2_journal_reclaim_fast                 -      -
> >      0.00%  [k] __ext4_journal_stop                       -      -
> >      0.00%  [.] 0x0000000000057c7c                        -      -
> >      0.00%  [k] detach_if_pending                         -      -
> >      0.00%  [k] kblockd_mod_delayed_work_on               -      -
> >      0.00%  [.] 0x0000000000068c97                        -      -
> >      0.00%  [.] __explicit_bzero_chk                      -      -
> >      0.00%  [k] chacha_block_generic                      -      -
> >      0.00%  [k] tcp_event_data_recv                       -      -
> >      0.00%  [.] 0x0000000000078310                        -      -
> >      0.00%  [k] check_tsc_unstable                        -      -
> >      0.00%  [k] wb_timer_fn                               -      -
> >      0.00%  [k] inet_ehashfn                              -      -
> >      0.00%  [k] crng_make_state                           -      -
> >      0.00%  [.] 0x0000000000124b04                        -      -
> >      0.00%  [k] __x64_sys_ppoll                           -      -
> >      0.00%  [k] tcp_wfree                                 -      -
> >      0.00%  [k] tcp_rate_check_app_limited                -      -
> >      0.00%  [k] lock_timer_base                           -      -
> >      0.00%  [k] ksys_read                                 -      -
> >      0.00%  [.] 0x0000000000145a44                        -      -
> >      0.00%  [k] __rseq_handle_notify_resume               -      -
> >      0.00%  [k] _raw_read_lock                            -      -
> >      0.00%  [k] bch2_btree_path_upgrade_noupgrade_sibs    -      -
> >      0.00%  [.] 0x0000000000052fe7                        -      -
> >      0.00%  [.] 0x000000000006e616                        -      -
> >      0.00%  [k] timekeeping_update                        -      -
> >      0.00%  [k] __local_bh_enable_ip                      -      -
> >      0.00%  [k] tsc_verify_tsc_adjust                     -      -
> >      0.00%  [k] btree_key_cache_flush_pos.constprop.0     -      -
> >      0.00%  [k] kthread_data                              -      -
> >      0.00%  [k] tcp_rate_gen                              -      -
> >      0.00%  [k] rcu_preempt_deferred_qs                   -      -
> >      0.00%  [k] rcu_momentary_dyntick_idle                -      -
> >      0.00%  [.] 0x000000000005d7bd                        -      -
> >      0.00%  [k] smpboot_thread_fn                         -      -
> >      0.00%  [k] pskb_expand_head                          -      -
> >      0.00%  [.] 0x0000000000073d5d                        -      -
> >      0.00%  [k] __sk_mem_schedule                         -      -
> >      0.00%  [k] pcpu_chunk_addr_search                    -      -
> >      0.00%  [k] csum_partial                              -      -
> >      0.00%  [k] migration_cpu_stop                        -      -
> >      0.00%  [k] validate_bset                             -      -
> >      0.00%  [k] eth_type_trans                            -      -
> >      0.00%  [k] calc_wheel_index                          -      -
> >      0.00%  [k] update_dl_rq_load_avg                     -      -
> >      0.00%  [k] worker_thread                             -      -
> >      0.00%  [k] kmem_cache_alloc_bulk_noprof              -      -
> >      0.00%  [k] __sk_mem_raise_allocated                  -      -
> >      0.00%  [k] update_vsyscall                           -      -
> >      0.00%  [k] __queue_work.part.0                       -      -
> >      0.00%  [k] build_detached_freelist                   -      -
> >      0.00%  [k] schedule_timeout                          -      -
> >      0.00%  [.] 0x0000000000090970                        -      -
> >      0.00%  [k] tcp_newly_delivered                       -      -
> >      0.00%  [.] 0x0000000000145ec4                        -      -
> >      0.00%  [k] __kmalloc_large_node                      -      -
> >      0.00%  [k] bch2_encrypt                              -      -
> >      0.00%  [k] raise_softirq                             -      -
> >      0.00%  [k] try_fill_recv                             -      -
> >      0.00%  [k] restore_fpregs_from_fpstate               -      -
> >      0.00%  [k] sched_use_asym_prio                       -      -
> >      0.00%  [k] pwq_dec_nr_in_flight                      -      -
> >      0.00%  [k] __note_gp_changes                         -      -
> >      0.00%  [k] check_preempt_wakeup_fair                 -      -
> >      0.00%  [k] ext4_writepages                           -      -
> >      0.00%  [k] ntp_get_next_leap                         -      -
> >      0.00%  [k] blk_account_io_completion.part.0          -      -
> >      0.00%  [k] tcp_orphan_count_sum                      -      -
> >      0.00%  [k] tcp_gro_receive                           -      -
> >      0.00%  [.] 0x0000000000021f2e                        -      -
> >      0.00%  [k] bch2_journal_pin_set                      -      -
> >      0.00%  [.] 0x0000000000052ff4                        -      -
> >      0.00%  [k] vp_interrupt                              -      -
> >      0.00%  [k] tcp_data_queue                            -      -
> >      0.00%  [k] enqueue_task_stop                         -      -
> >      0.00%  [.] 0x000000000005a922                        -      -
> >      0.00%  [k] call_function_single_prep_ipi             -      -
> >      0.00%  [.] 0x00000000003d2d68                        -      -
> >      0.00%  [.] 0x000000000006ea08                        -      -
> >      0.00%  [k] napi_complete_done                        -      -
> >      0.00%  [k] __sysvec_call_function_single             -      -
> >      0.00%  [k] __flush_work                              -      -
> >      0.00%  [k] n_tty_poll                                -      -
> >      0.00%  [.] 0x000000000022416d                        -      -
> >      0.00%  [k] wakeup_preempt                            -      -
> >      0.00%  [k] __task_pid_nr_ns                          -      -
> >      0.00%  [k] _raw_spin_lock_bh                         -      -
> >      0.00%  [k] kcompactd                                 -      -
> >      0.00%  [k] ct_kernel_enter.constprop.0               -      -
> >      0.00%  [k] bch2_sort_keys_keep_unwritten_whiteouts   -      -
> >      0.00%  [k] netif_receive_skb_list_internal           -      -
> >      0.00%  [k] fold_diff                                 -      -
> >      0.00%  [k] skb_page_frag_refill                      -      -
> >      0.00%  [k] sched_mm_cid_migrate_to                   -      -
> >      0.00%  [k] __pageblock_pfn_to_page                   -      -
> >      0.00%  [k] kvm_read_and_reset_apf_flags              -      -
> >      0.00%  [k] sock_def_readable                         -      -
> >      0.00%  [k] balance_fair                              -      -
> >      0.00%  [k] bch2_btree_node_hash_insert               -      -
> >      0.00%  [k] btree_update_add_key.isra.0               -      -
> >      0.00%  [k] delayed_work_timer_fn                     -      -
> >      0.00%  [k] tcp_v4_rcv                                -      -
> >      0.00%  [k] wbt_done                                  -      -
> >      0.00%  [k] queue_delayed_work_on                     -      -
> >      0.00%  [k] pwq_tryinc_nr_active                      -      -
> >      0.00%  [k] bch2_checksum_final                       -      -
> >      0.00%  [k] try_check_zero                            -      -
> >      0.00%  [k] schedule_tail                             -      -
> >      0.00%  [k] enter_lazy_tlb                            -      -
> >      0.00%  [k] tcp_queue_rcv                             -      -
> >      0.00%  [k] call_timer_fn                             -      -
> >      0.00%  [k] process_one_work                          -      -
> >      0.00%  [k] pick_eevdf                                -      -
> >      0.00%  [k] __flush_smp_call_function_queue           -      -
> >      0.00%  [k] __do_set_cpus_allowed                     -      -
> >      0.00%  [k] __init_swait_queue_head                   -      -
> >      0.00%  [k] rcu_core_si                               -      -
> >      0.00%  [k] stop_one_cpu_nowait                       -      -
> >      0.00%  [k] set_cpus_allowed_common                   -      -
> >      0.00%  [k] update_min_vruntime                       -      -
> >      0.00%  [k] set_cpus_allowed_fair                     -      -
> >      0.00%  [k] pick_next_task_stop                       -      -
> >      0.00%  [k] __x64_sys_ioctl                           -      -
> >      0.00%  [k] perf_event_for_each_child                 -      -
> >      0.00%  [k] _find_next_and_bit                        -      -
> >      0.00%  [k] affine_move_task                          -      -
> >      0.00%  [k] llist_add_batch                           -      -
> >      0.00%  [.] 0x000000000011c9a5                        -      -
> >      0.00%  [k] cpumask_any_and_distribute                -      -
> >      0.00%  [k] perf_ioctl                                -      -
> >      0.00%  [.] __GI___ioctl                              -      -
> >      0.00%  [.] sched_setaffinity@@GLIBC_2.3.4            -      -
> >      0.00%  [.] 0x000000000011be2b                        -      -
> >      0.00%  [.] 0x000000000011c9bd                        -      -
> >      0.00%  [.] 0x000000000024bb9f                        -      -
> >      0.00%  [.] 0x000000000024c42b                        -      -
> >      0.00%  [.] 0x000000000024c44e                        -      -
> >      0.00%  [.] 0x000000000024c473                        -      -
> >      0.00%  [.] 0x000000000024c496                        -      -
> >
> >
> > #
> > # (Tip: To report cacheline events from previous recording: perf c2c re=
port)
> > #
>
>
>
> --
> Mateusz Guzik <mjguzik gmail.com>



--=20
Mateusz Guzik <mjguzik gmail.com>
