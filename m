Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AF6C77B75
	for <linux-bcachefs@archiver.kernel.org>; Tue, 16 May 2023 18:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbjEPS2r (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Tue, 16 May 2023 14:28:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjEPS2q (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Tue, 16 May 2023 14:28:46 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096CA115
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 11:28:43 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id 6a1803df08f44-6237c957c5aso3888636d6.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 May 2023 11:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=temp123.org; s=google; t=1684261722; x=1686853722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qV2bKW6jxQsXhxdk9CZ/ZggQ3yOjfDpxc0k9fnjw3jQ=;
        b=W5XtUwG4ioh6ge+Mf1xnDj66egwzxTgyaSIvkcfVpkkJYbdrCvrH5vOWv8DbjEAINb
         L6b0hcZnxzE6wqzuq8g6KNalCDCuqJDMB/hlE3mTw4+I5YWuybk6bPCS7CYbUuSlSNh1
         ZPhFDTGa3j7aLfO8GzbbPpe8iqvT8+tM6WIdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684261722; x=1686853722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qV2bKW6jxQsXhxdk9CZ/ZggQ3yOjfDpxc0k9fnjw3jQ=;
        b=Tk4yOVH8H0DJ63DzZZBV9y21jKtsQnX8VJqHOcmFZwn0fKOkmdzjpLriiKkFqTpjF+
         Dtvy2WLcxm7URuAO013zkBJb4VUKrsA1NZpu83aeb58L/THM11xvRECnj7/ox0rDQ9mE
         CtuL93+br7zWFw+LmlFgazSKumVvgB0L+Fr5t7KeNI1CCI8DkOMQDPqJq/jNiUa+mD5v
         Z/iL4J9xT0plNY49RwOuXYDaIoR7PZvBAB2NJeV/ZeGz1Oc1fmZ0EcC691KkvlPMcr+U
         k+BNdMXaGTZld5rAY4BELLWMdPXxlEAcgZMfzB9iuWAd1HPc1ZxeDC+Ey3s7RNmWko3H
         xPBA==
X-Gm-Message-State: AC+VfDyEgofovJEpBMj9SuzwxhOEVQ9MjZgvF/qfoRkTLKGjq93FyeZ3
        Dn6SiAl/ouy6B88YM++xZrbcWc8y0Faj4ecrSPLe4gX1pEugUO3oBbU=
X-Google-Smtp-Source: ACHHUZ4Y2YPXYzqbRysf3KcFh6WtCyt+pJEQHT8IpwP1MQtyZ9L11JW6UlM9QXVkTtlohnS8kO1PRi5KkhVg0GFPAG4=
X-Received: by 2002:a05:6214:c85:b0:623:686e:e426 with SMTP id
 r5-20020a0562140c8500b00623686ee426mr10622148qvr.4.1684261721790; Tue, 16 May
 2023 11:28:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKib_wKEnoF4=aFVhA5Sd0Edcyo6=RTs0i81ntADFogFezR=cg@mail.gmail.com>
 <ZFnV6wfafWPeuHDv@moria.home.lan> <CAKib_wLQPr0uFjThRrpzvvPmzKTUGB-H8f5F=3kkd_W2K+NayA@mail.gmail.com>
In-Reply-To: <CAKib_wLQPr0uFjThRrpzvvPmzKTUGB-H8f5F=3kkd_W2K+NayA@mail.gmail.com>
From:   Josh Litherland <josh@temp123.org>
Date:   Tue, 16 May 2023 14:28:31 -0400
Message-ID: <CAKib_wJyoUCKVtk=Xg6gzZmn-BptqCoogPrZCkU23RD45ScaGQ@mail.gmail.com>
Subject: Re: bcachefs fsck out-of-memory
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

Is there any further diagnostic value to me leaving these drives in
their current state?  I can, if you think it will help track down the
fsck OOM issue.  But if not I'm going to wipe them and start fresh.

Thanks!

On Tue, May 9, 2023 at 11:04=E2=80=AFAM Josh Litherland <josh@temp123.org> =
wrote:
>
> On Tue, May 9, 2023 at 1:11=E2=80=AFAM Kent Overstreet
> <kent.overstreet@linux.dev> wrote:
> >
> > On Fri, May 05, 2023 at 09:49:14AM -0400, Josh Litherland wrote:
> > > I have a largeish filesystem (4x16TB + 2x2TB) which was uncleanly shu=
t
> > > down.  I am attempting to do an fsck repair, and consistently hitting
> > > the OOM killer (approximately 64GiB RAM in use) with the userspace
> > > fsck repair tool.  The in-kernel repair runs for a while and
> > > eventually stops doing any IO while the mount command hangs, so I
> > > assume it's hitting the same condition.
> > >
> > > Kernel is 6.3.0-bcachefs-ccc8737427a3.
> > > bcachefs-tools is revision 6b1f79d5df9f2735192ed1a40c711cf131d4f43e.
> > >
> > > Please let me know if there is any information I can provide that
> > > might help to debug this issue, or any other repair techniques I can
> > > try out.  I have a recent backup of the data, and I'm not in a
> > > particular hurry to wipe and reformat the drives.
> >
> > In kernel fsck is a bit more resilient to low memory conditions, and a
> > bit easier to debug.
> >
> > Could you get stacktraces when it's gotten stuck, and pipe them through
> > decode_stacktrace.sh (kernel source tree)?  'echo w >
> > /proc/sysrq-trigger' should put the right stack traces in the dmesg log=
.
>
> Interestingly, the mount actually did return this time after running
> out of memory.  Here's the parsed stack trace:
>
> --------
>
> [328043.931924] mount: vmalloc error: size 16777216, page order 9,
> failed to allocate pages, mode:0xcc2(GFP_KERNEL|__GFP_HIGHMEM),
> nodemask=3D(null),cpuset=3Duser.slice,mems_allowed=3D0
> [328043.931933] CPU: 3 PID: 467832 Comm: mount Tainted: G            E
>      6.3.0-bcachefs-ccc8737427a3 #6
> [328043.931935] Hardware name: Micro-Star International Co., Ltd.
> MS-7B46/Z370 KRAIT GAMING (MS-7B46), BIOS 1.C2 04/21/2021
> [328043.931937] Call Trace:
> [328043.931939]  <TASK>
> [328043.931940] dump_stack_lvl+0x44/0x60
> [328043.931945] warn_alloc+0x138/0x1b0
> [328043.931948] ? __alloc_pages+0x301/0x330
> [328043.931951] __vmalloc_node_range+0x6ae/0x890
> [328043.931953] ? bch2_journal_key_insert_take+0x168/0x380
> [328043.931957] kvmalloc_node+0x9a/0xc0
> [328043.931960] ? bch2_journal_key_insert_take+0x168/0x380
> [328043.931962] bch2_journal_key_insert_take+0x168/0x380
> [328043.931965] bch2_check_fix_ptrs+0x1351/0x1500
> [328043.931969] ? sysvec_x86_platform_ipi+0x20/0xd0
> [328043.931973] ? bch2_gc_mark_key+0x99/0x270
> [328043.931974] bch2_gc_mark_key+0x99/0x270
> [328043.931977] bch2_gc_btree_init_recurse+0x173/0x6e0
> [328043.931981] ? bch2_btree_node_read+0x238/0x4d0
> [328043.931984] ? bch2_btree_node_hash_insert+0x48/0xb0
> [328043.931987] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328043.931993] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328043.931999] bch2_gc_btrees+0x245/0x480
> [328043.932004] ? bch2_gc_mark_key+0xce/0x270
> [328043.932008] bch2_gc+0x381/0x850
> [328043.932011] bch2_fs_recovery+0x1b06/0x21b0
> [328043.932012] ? up_write+0x36/0x60
> [328043.932017] ? idr_alloc_u32+0x8d/0xd0
> [328043.932019] ? idr_alloc_cyclic+0x50/0xb0
> [328043.932022] ? bdev_name.constprop.0+0x3e/0x160
> [328043.932025] ? vsnprintf+0x1fd/0x4f0
> [328043.932027] ? __bch2_sb_field_resize+0x62/0x110
> [328043.932030] bch2_fs_start+0x3d9/0x430
> [328043.932032] bch2_fs_open+0x45a/0x5a0
> [328043.932034] bch2_mount+0x519/0x6e0
> [328043.932040] legacy_get_tree+0x24/0x50
> [328043.932043] vfs_get_tree+0x22/0xd0
> [328043.932045] path_mount+0x488/0xab0
> [328043.932048] __x64_sys_mount+0x107/0x140
> [328043.932051] do_syscall_64+0x38/0x90
> [328043.932054] entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [328043.932056] RIP: 0033:0x7f4fcc35062a
> [328043.932059] Code: 48 8b 0d 69 18 0d 00 f7 d8 64 89 01 48 83 c8 ff
> c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 36 18 0d 00 f7 d8 64 89
> 01 48
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 8b 0d 69 18 0d 00     mov    0xd1869(%rip),%rcx        # 0xd1=
870
>    7:    f7 d8                    neg    %eax
>    9:    64 89 01                 mov    %eax,%fs:(%rcx)
>    c:    48 83 c8 ff              or     $0xffffffffffffffff,%rax
>   10:    c3                       retq
>   11:    66 2e 0f 1f 84 00 00     nopw   %cs:0x0(%rax,%rax,1)
>   18:    00 00 00
>   1b:    0f 1f 44 00 00           nopl   0x0(%rax,%rax,1)
>   20:    49 89 ca                 mov    %rcx,%r10
>   23:    b8 a5 00 00 00           mov    $0xa5,%eax
>   28:    0f 05                    syscall
>   2a:*    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    <-- trapping instruction
>   30:    73 01                    jae    0x33
>   32:    c3                       retq
>   33:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
870
>   3a:    f7 d8                    neg    %eax
>   3c:    64 89 01                 mov    %eax,%fs:(%rcx)
>   3f:    48                       rex.W
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    6:    73 01                    jae    0x9
>    8:    c3                       retq
>    9:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
846
>   10:    f7 d8                    neg    %eax
>   12:    64 89 01                 mov    %eax,%fs:(%rcx)
>   15:    48                       rex.W
> [328043.932060] RSP: 002b:00007fff37e41b48 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a5
> [328043.932062] RAX: ffffffffffffffda RBX: 00007f4fcc484264 RCX:
> 00007f4fcc35062a
> [328043.932063] RDX: 000055fc23036c60 RSI: 000055fc23036d10 RDI:
> 000055fc23036cc0
> [328043.932064] RBP: 000055fc23036a30 R08: 000055fc23036c80 R09:
> 00007f4fcc422be0
> [328043.932065] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000000
> [328043.932066] R13: 000055fc23036cc0 R14: 000055fc23036c60 R15:
> 000055fc23036a30
> [328043.932069]  </TASK>
> [328043.932069] Mem-Info:
> [328043.932070] active_anon:4983073 inactive_anon:1879315 isolated_anon:0
> active_file:765675 inactive_file:153193 isolated_file:0
> unevictable:3135 dirty:68 writeback:0
> slab_reclaimable:659699 slab_unreclaimable:490405
> mapped:2859568 shmem:2795969 pagetables:26309
> sec_pagetables:5352 bounce:0
> kernel_misc_reclaimable:0
> free:282575 free_pcp:0 free_cma:0
> [328043.932074] Node 0 active_anon:19932292kB inactive_anon:7517260kB
> active_file:3062700kB inactive_file:612772kB unevictable:12540kB
> isolated(anon):0kB isolated(file):0kB mapped:11438272kB dirty:272kB
> writeback:0kB shmem:11183876kB shmem_thp: 0kB shmem_pmdmapped: 0kB
> anon_thp: 14264320kB writeback_tmp:0kB kernel_stack:22800kB
> pagetables:105236kB sec_pagetables:21408kB all_unreclaimable? no
> [328043.932077] Node 0 DMA free:15360kB boost:0kB min:12kB low:24kB
> high:36kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB
> active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB
> present:15984kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB
> local_pcp:0kB free_cma:0kB
> [328043.932081] lowmem_reserve[]: 0 2089 64129 64129 64129
> [328043.932084] Node 0 DMA32 free:267748kB boost:0kB min:2200kB
> low:4336kB high:6472kB reserved_highatomic:16384KB
> active_anon:759888kB inactive_anon:286036kB active_file:22592kB
> inactive_file:3060kB unevictable:0kB writepending:0kB
> present:2262788kB managed:2196980kB mlocked:0kB bounce:0kB
> free_pcp:0kB local_pcp:0kB free_cma:0kB
> [328043.932087] lowmem_reserve[]: 0 0 62040 62040 62040
> [328043.932090] Node 0 Normal free:847192kB boost:0kB min:65364kB
> low:128892kB high:192420kB reserved_highatomic:8192KB
> active_anon:19172404kB inactive_anon:7231224kB active_file:3040244kB
> inactive_file:609772kB unevictable:12540kB writepending:272kB
> present:64733184kB managed:63533120kB mlocked:12416kB bounce:0kB
> free_pcp:0kB local_pcp:0kB free_cma:0kB
> [328043.932093] lowmem_reserve[]: 0 0 0 0 0
> [328043.932096] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
> 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) =3D 15360kB
> [328043.932104] Node 0 DMA32: 2869*4kB (UME) 2036*8kB (UME) 1437*16kB
> (UME) 1003*32kB (UME) 513*64kB (UME) 364*128kB (UME) 60*256kB (UME)
> 36*512kB (UM) 14*1024kB (UM) 16*2048kB (M) 6*4096kB (UM) =3D 267748kB
> [328043.932115] Node 0 Normal: 58418*4kB (UME) 26114*8kB (UME)
> 10689*16kB (UME) 3827*32kB (UME) 1117*64kB (UME) 250*128kB (UME)
> 16*256kB (U) 5*512kB (UM) 1*1024kB (U) 0*2048kB 0*4096kB =3D 847240kB
> [328043.932126] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D1048576kB
> [328043.932127] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D2048kB
> [328043.932128] 3840046 total pagecache pages
> [328043.932129] 122579 pages in swap cache
> [328043.932129] Free swap  =3D 0kB
> [328043.932130] Total swap =3D 1048572kB
> [328043.932131] 16752989 pages RAM
> [328043.932131] 0 pages HighMem/MovableOnly
> [328043.932132] 316624 pages reserved
> [328043.932132] 0 pages hwpoisoned
> [328043.932133] Unreclaimable slab info:
> [328043.932618] kmalloc-96        total: 1.52 GB active: 1.52 GB
> filp              total: 170 MB active: 170 MB
> kmalloc-512       total: 84.5 MB active: 82.3 MB
> kmalloc-256       total: 30.6 MB active: 27.1 MB
> lsm_file_cache    total: 16.0 MB active: 15.9 MB
> kmalloc-192       total: 15.1 MB active: 13.6 MB
> task_struct       total: 9.79 MB active: 9.67 MB
> vm_area_struct    total: 8.28 MB active: 8.09 MB
> vmap_area         total: 7.82 MB active: 7.79 MB
> kernfs_node_cache total: 7.44 MB active: 7.44 MB
> [328043.932620] Shrinkers:
> [328043.932635] 56f18224-fbe1-4704-8a0f-b5486fc6d511/btree_cache
> objects:           91722
> requested to free: 793344
> objects freed:     374472
> nr nodes:        91818
> nr dirty:        0
> cannibalize lock:    0000000000000000
> freed:                374472
> not freed, dirty:        0
> not freed, write in flight:    0
> not freed, read in flight:    0
> not freed, lock intent failed:    0
> not freed, lock write failed:    1
> not freed, access bit:        418871
> not freed, no evict failed:    0
> not freed, write blocked:    0
> not freed, will make reachable:    0
>
> ext4-es:dm-0
> objects:           30432
> requested to free: 611968
> objects freed:     459800
> ext4-es:sde
> objects:           16096
> requested to free: 311748
> objects freed:     221059
> ext4-es:nvme2n1p2
> objects:           12928
> requested to free: 534280
> objects freed:     335713
> sb-ext4
> objects:           4420
> requested to free: 2287783
> objects freed:     1766886
> jbd2-journal:(252:0)
> objects:           768
> requested to free: 0
> objects freed:     0
> sb-ext4
> objects:           95
> requested to free: 595016
> objects freed:     578662
> rcu-kfree
> objects:
> [328265.990427] mount: vmalloc error: size 130023424, page order 9,
> failed to allocate pages, mode:0xcc2(GFP_KERNEL|__GFP_HIGHMEM),
> nodemask=3D(null),cpuset=3Duser.slice,mems_allowed=3D0
> [328265.990453] CPU: 9 PID: 467832 Comm: mount Tainted: G            E
>      6.3.0-bcachefs-ccc8737427a3 #6
> [328265.990455] Hardware name: Micro-Star International Co., Ltd.
> MS-7B46/Z370 KRAIT GAMING (MS-7B46), BIOS 1.C2 04/21/2021
> [328265.990456] Call Trace:
> [328265.990458]  <TASK>
> [328265.990461] dump_stack_lvl+0x44/0x60
> [328265.990466] warn_alloc+0x138/0x1b0
> [328265.990469] ? __alloc_pages+0x301/0x330
> [328265.990471] __vmalloc_node_range+0x6ae/0x890
> [328265.990474] ? bch2_journal_key_insert_take+0x168/0x380
> [328265.990478] kvmalloc_node+0x9a/0xc0
> [328265.990480] ? bch2_journal_key_insert_take+0x168/0x380
> [328265.990482] bch2_journal_key_insert_take+0x168/0x380
> [328265.990485] bch2_check_fix_ptrs+0x1351/0x1500
> [328265.990502] ? sysvec_x86_platform_ipi+0x21/0xd0
> [328265.990506] ? bch2_gc_mark_key+0x99/0x270
> [328265.990507] bch2_gc_mark_key+0x99/0x270
> [328265.990510] bch2_gc_btree_init_recurse+0x173/0x6e0
> [328265.990514] ? bch2_btree_node_read+0x238/0x4d0
> [328265.990516] ? bch2_btree_node_hash_insert+0x48/0xb0
> [328265.990520] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328265.990526] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328265.990532] bch2_gc_btrees+0x245/0x480
> [328265.990536] ? bch2_gc_mark_key+0xce/0x270
> [328265.990540] bch2_gc+0x381/0x850
> [328265.990543] bch2_fs_recovery+0x1b06/0x21b0
> [328265.990544] ? up_write+0x36/0x60
> [328265.990549] ? idr_alloc_u32+0x8d/0xd0
> [328265.990552] ? idr_alloc_cyclic+0x50/0xb0
> [328265.990554] ? bdev_name.constprop.0+0x3e/0x160
> [328265.990557] ? vsnprintf+0x1fd/0x4f0
> [328265.990559] ? __bch2_sb_field_resize+0x62/0x110
> [328265.990562] bch2_fs_start+0x3d9/0x430
> [328265.990564] bch2_fs_open+0x45a/0x5a0
> [328265.990567] bch2_mount+0x519/0x6e0
> [328265.990572] legacy_get_tree+0x24/0x50
> [328265.990575] vfs_get_tree+0x22/0xd0
> [328265.990578] path_mount+0x488/0xab0
> [328265.990581] __x64_sys_mount+0x107/0x140
> [328265.990583] do_syscall_64+0x38/0x90
> [328265.990586] entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [328265.990588] RIP: 0033:0x7f4fcc35062a
> [328265.990591] Code: 48 8b 0d 69 18 0d 00 f7 d8 64 89 01 48 83 c8 ff
> c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 36 18 0d 00 f7 d8 64 89
> 01 48
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 8b 0d 69 18 0d 00     mov    0xd1869(%rip),%rcx        # 0xd1=
870
>    7:    f7 d8                    neg    %eax
>    9:    64 89 01                 mov    %eax,%fs:(%rcx)
>    c:    48 83 c8 ff              or     $0xffffffffffffffff,%rax
>   10:    c3                       retq
>   11:    66 2e 0f 1f 84 00 00     nopw   %cs:0x0(%rax,%rax,1)
>   18:    00 00 00
>   1b:    0f 1f 44 00 00           nopl   0x0(%rax,%rax,1)
>   20:    49 89 ca                 mov    %rcx,%r10
>   23:    b8 a5 00 00 00           mov    $0xa5,%eax
>   28:    0f 05                    syscall
>   2a:*    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    <-- trapping instruction
>   30:    73 01                    jae    0x33
>   32:    c3                       retq
>   33:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
870
>   3a:    f7 d8                    neg    %eax
>   3c:    64 89 01                 mov    %eax,%fs:(%rcx)
>   3f:    48                       rex.W
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    6:    73 01                    jae    0x9
>    8:    c3                       retq
>    9:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
846
>   10:    f7 d8                    neg    %eax
>   12:    64 89 01                 mov    %eax,%fs:(%rcx)
>   15:    48                       rex.W
> [328265.990592] RSP: 002b:00007fff37e41b48 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a5
> [328265.990594] RAX: ffffffffffffffda RBX: 00007f4fcc484264 RCX:
> 00007f4fcc35062a
> [328265.990595] RDX: 000055fc23036c60 RSI: 000055fc23036d10 RDI:
> 000055fc23036cc0
> [328265.990596] RBP: 000055fc23036a30 R08: 000055fc23036c80 R09:
> 00007f4fcc422be0
> [328265.990597] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000000
> [328265.990597] R13: 000055fc23036cc0 R14: 000055fc23036c60 R15:
> 000055fc23036a30
> [328265.990600]  </TASK>
> [328265.990601] Mem-Info:
> [328265.990602] active_anon:4983104 inactive_anon:1878542 isolated_anon:0
> active_file:629127 inactive_file:153289 isolated_file:0
> unevictable:3135 dirty:44 writeback:0
> slab_reclaimable:649498 slab_unreclaimable:889902
> mapped:2857333 shmem:2795985 pagetables:26281
> sec_pagetables:5352 bounce:0
> kernel_misc_reclaimable:0
> free:161210 free_pcp:206 free_cma:0
> [328265.990608] Node 0 active_anon:19932416kB inactive_anon:7514168kB
> active_file:2516508kB inactive_file:613156kB unevictable:12540kB
> isolated(anon):0kB isolated(file):0kB mapped:11429332kB dirty:176kB
> writeback:0kB shmem:11183940kB shmem_thp: 0kB shmem_pmdmapped: 0kB
> anon_thp: 14260224kB writeback_tmp:0kB kernel_stack:22784kB
> pagetables:105124kB sec_pagetables:21408kB all_unreclaimable? no
> [328265.990625] Node 0 DMA free:15360kB boost:0kB min:12kB low:24kB
> high:36kB reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB
> active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB
> present:15984kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB
> local_pcp:0kB free_cma:0kB
> [328265.990630] lowmem_reserve[]: 0 2089 64129 64129 64129
> [328265.990633] Node 0 DMA32 free:268180kB boost:0kB min:2200kB
> low:4336kB high:6472kB reserved_highatomic:16384KB
> active_anon:759888kB inactive_anon:286068kB active_file:18620kB
> inactive_file:4216kB unevictable:0kB writepending:0kB
> present:2262788kB managed:2196980kB mlocked:0kB bounce:0kB
> free_pcp:0kB local_pcp:0kB free_cma:0kB
> [328265.990638] lowmem_reserve[]: 0 0 62040 62040 62040
> [328265.990641] Node 0 Normal free:362324kB boost:0kB min:65364kB
> low:128892kB high:192420kB reserved_highatomic:8192KB
> active_anon:19172528kB inactive_anon:7228100kB active_file:2497792kB
> inactive_file:609120kB unevictable:12540kB writepending:176kB
> present:64733184kB managed:63533120kB mlocked:12416kB bounce:0kB
> free_pcp:848kB local_pcp:256kB free_cma:0kB
> [328265.990646] lowmem_reserve[]: 0 0 0 0 0
> [328265.990650] Node 0 DMA: 0*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB
> 0*256kB 0*512kB 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) =3D 15360kB
> [328265.990662] Node 0 DMA32: 2793*4kB (UME) 1862*8kB (UME) 1048*16kB
> (UME) 636*32kB (UME) 497*64kB (UME) 367*128kB (UME) 91*256kB (UME)
> 43*512kB (UM) 27*1024kB (UM) 16*2048kB (M) 5*4096kB (UM) =3D 268180kB
> [328265.990677] Node 0 Normal: 35565*4kB (UME) 11586*8kB (UME)
> 2486*16kB (UME) 453*32kB (UME) 104*64kB (UME) 51*128kB (U) 134*256kB
> (UM) 46*512kB (U) 4*1024kB (U) 0*2048kB 0*4096kB =3D 364356kB
> [328265.990693] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D1048576kB
> [328265.990695] Node 0 hugepages_total=3D0 hugepages_free=3D0
> hugepages_surp=3D0 hugepages_size=3D2048kB
> [328265.990696] 3703674 total pagecache pages
> [328265.990697] 122579 pages in swap cache
> [328265.990698] Free swap  =3D 0kB
> [328265.990699] Total swap =3D 1048572kB
> [328265.990700] 16752989 pages RAM
> [328265.990701] 0 pages HighMem/MovableOnly
> [328265.990702] 316624 pages reserved
> [328265.990702] 0 pages hwpoisoned
> [328265.990704] Unreclaimable slab info:
> [328265.991221] kmalloc-96        total: 3.13 GB active: 3.13 GB
> filp              total: 170 MB active: 170 MB
> kmalloc-512       total: 84.5 MB active: 80.9 MB
> kmalloc-256       total: 30.4 MB active: 26.9 MB
> lsm_file_cache    total: 16.0 MB active: 15.9 MB
> kmalloc-192       total: 15.0 MB active: 13.5 MB
> task_struct       total: 9.79 MB active: 9.75 MB
> vm_area_struct    total: 8.25 MB active: 7.99 MB
> vmap_area         total: 7.71 MB active: 7.54 MB
> kernfs_node_cache total: 7.44 MB active: 7.44 MB
> [328265.991223] Shrinkers:
> [328265.991247] 56f18224-fbe1-4704-8a0f-b5486fc6d511/btree_cache
> objects:           87774
> requested to free: 852096
> objects freed:     388001
> nr nodes:        87870
> nr dirty:        0
> cannibalize lock:    0000000000000000
> freed:                388111
> not freed, dirty:        0
> not freed, write in flight:    0
> not freed, read in flight:    0
> not freed, lock intent failed:    0
> not freed, lock write failed:    1
> not freed, access bit:        463966
> not freed, no evict failed:    0
> not freed, write blocked:    0
> not freed, will make reachable:    0
>
> ext4-es:dm-0
> objects:           27872
> requested to free: 614528
> objects freed:     462360
> ext4-es:sde
> objects:           15424
> requested to free: 312516
> objects freed:     221827
> ext4-es:nvme2n1p2
> objects:           12448
> requested to free: 535048
> objects freed:     336152
> sb-ext4
> objects:           4420
> requested to free: 2312359
> objects freed:     1784481
> jbd2-journal:(252:0)
> objects:           768
> requested to free: 0
> objects freed:     0
> sb-ext4
> objects:           95
> requested to free: 601160
> objects freed:     583827
> jbd2-journal:(8:64
> [328669.086982] ------------[ cut here ]------------
> [328669.086985] WARNING: CPU: 3 PID: 467832 at mm/util.c:618
> kvmalloc_node+0xb0/0xc0
> [328669.086990] Modules linked in: dm_crypt(E) uas(E) usb_storage(E)
> tcp_diag(E) inet_diag(E) xt_nat(E) xt_conntrack(E)
> nf_conntrack_netlink(E) xfrm_user(E) xt_addrtype(E) br_netfilter(E)
> overlay(E) msdos(E) dm_mod(E) vhost_net(E) vhost(E) vhost_iotlb(E)
> tap(E) tun(E) veth(E) xt_CHECKSUM(E) nft_chain_nat(E) xt_MASQUERADE(E)
> nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E)
> xt_tcpudp(E) nft_compat(E) nf_tables(E) nfnetlink(E) bridge(E) stp(E)
> llc(E) intel_rapl_msr(E) intel_rapl_common(E) x86_pkg_temp_thermal(E)
> intel_powerclamp(E) coretemp(E) kvm_intel(E) binfmt_misc(E) i915(E)
> drm_buddy(E) kvm(E) snd_pcm(E) irqbypass(E) nls_ascii(E)
> drm_display_helper(E) snd_timer(E) rapl(E) nls_cp437(E) iTCO_wdt(E)
> cec(E) intel_pmc_bxt(E) intel_cstate(E) snd(E) vfat(E)
> iTCO_vendor_support(E) soundcore(E) mei_hdcp(E) ttm(E) fat(E) evdev(E)
> intel_uncore(E) watchdog(E) ee1004(E) mxm_wmi(E) pcspkr(E)
> efi_pstore(E) mei_me(E) sg(E) drm_kms_helper(E) i2c_algo_bit(E) mei(E)
> intel_pmc_core(E) acpi_pad(E) acpi_tad(E) button(E)
> [328669.087031]  ib_iser(E) rdma_cm(E) iw_cm(E) ib_cm(E) nfsd(E)
> ib_core(E) auth_rpcgss(E) nfs_acl(E) iscsi_tcp(E) libiscsi_tcp(E)
> libiscsi(E) lockd(E) grace(E) scsi_transport_iscsi(E) drm(E) fuse(E)
> configfs(E) sunrpc(E) efivarfs(E) ip_tables(E) x_tables(E) autofs4(E)
> raid10(E) raid456(E) async_raid6_recov(E) async_memcpy(E) async_pq(E)
> async_xor(E) async_tx(E) raid1(E) raid0(E) multipath(E) linear(E)
> md_mod(E) bcache(E) hid_generic(E) sd_mod(E) usbhid(E) hid(E)
> crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) sha512_ssse3(E)
> sha512_generic(E) nvme(E) ahci(E) libahci(E) aesni_intel(E)
> nvme_core(E) xhci_pci(E) t10_pi(E) ixgbe(E) libaes(E) xfrm_algo(E)
> libata(E) xhci_hcd(E) dca(E) crypto_simd(E) firewire_ohci(E)
> mdio_devres(E) cryptd(E) crc64_rocksoft_generic(E) e1000e(E)
> i2c_i801(E) libphy(E) firewire_core(E) i2c_smbus(E) crc64_rocksoft(E)
> crc_itu_t(E) scsi_mod(E) usbcore(E) crc_t10dif(E) ptp(E)
> crct10dif_generic(E) pps_core(E) scsi_common(E) usb_common(E) mdio(E)
> crct10dif_pclmul(E) crct10dif_common(E) fan(E)
> [328669.087072]  video(E) wmi(E)
> [328669.087074] CPU: 3 PID: 467832 Comm: mount Tainted: G            E
>      6.3.0-bcachefs-ccc8737427a3 #6
> [328669.087076] Hardware name: Micro-Star International Co., Ltd.
> MS-7B46/Z370 KRAIT GAMING (MS-7B46), BIOS 1.C2 04/21/2021
> [328669.087076] RIP: kvmalloc_node+0xb0/0xc0
> [328669.087079] Code: 68 00 04 00 00 4c 23 0d 66 72 97 01 48 01 d1 e8
> d6 42 04 00 48 83 c4 18 5d 41 5c 41 5d c3 cc cc cc cc 81 e5 00 20 00
> 00 75 ee <0f> 0b eb ea 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
> 90 90
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:    68 00 04 00 00           pushq  $0x400
>    5:    4c 23 0d 66 72 97 01     and    0x1977266(%rip),%r9        # 0x1=
977272
>    c:    48 01 d1                 add    %rdx,%rcx
>    f:    e8 d6 42 04 00           callq  0x442ea
>   14:    48 83 c4 18              add    $0x18,%rsp
>   18:    5d                       pop    %rbp
>   19:    41 5c                    pop    %r12
>   1b:    41 5d                    pop    %r13
>   1d:    c3                       retq
>   1e:    cc                       int3
>   1f:    cc                       int3
>   20:    cc                       int3
>   21:    cc                       int3
>   22:    81 e5 00 20 00 00        and    $0x2000,%ebp
>   28:    75 ee                    jne    0x18
>   2a:*    0f 0b                    ud2            <-- trapping instructio=
n
>   2c:    eb ea                    jmp    0x18
>   2e:    66 66 2e 0f 1f 84 00     data16 nopw %cs:0x0(%rax,%rax,1)
>   35:    00 00 00 00
>   39:    90                       nop
>   3a:    90                       nop
>   3b:    90                       nop
>   3c:    90                       nop
>   3d:    90                       nop
>   3e:    90                       nop
>   3f:    90                       nop
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:    0f 0b                    ud2
>    2:    eb ea                    jmp    0xffffffffffffffee
>    4:    66 66 2e 0f 1f 84 00     data16 nopw %cs:0x0(%rax,%rax,1)
>    b:    00 00 00 00
>    f:    90                       nop
>   10:    90                       nop
>   11:    90                       nop
>   12:    90                       nop
>   13:    90                       nop
>   14:    90                       nop
>   15:    90                       nop
> [328669.087080] RSP: 0018:ffffb1f78fc4ee00 EFLAGS: 00010246
> [328669.087082] RAX: 0000000000000000 RBX: ffff96969b4c0000 RCX:
> 0000000000000013
> [328669.087083] RDX: 0000000000000000 RSI: 0000000000000014 RDI:
> 0000000000000000
> [328669.087084] RBP: 0000000000000000 R08: 0000000000000000 R09:
> 0000000000000000
> [328669.087085] R10: 0000000000000100 R11: ffff969b00bb2f28 R12:
> 00000000c0000000
> [328669.087086] R13: 00000000ffffffff R14: ffff969b00bb2f00 R15:
> 0000000000000000
> [328669.087087] FS:  00007f4fcc112840(0000) GS:ffff96a42eac0000(0000)
> knlGS:0000000000000000
> [328669.087088] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [328669.087089] CR2: 00007f53e2c35000 CR3: 00000002dc6e6002 CR4:
> 00000000003726e0
> [328669.087090] Call Trace:
> [328669.087092]  <TASK>
> [328669.087094] bch2_journal_key_insert_take+0x168/0x380
> [328669.087099] bch2_check_fix_ptrs+0x1351/0x1500
> [328669.087104] ? __pfx_common_interrupt+0x10/0x10
> [328669.087108] ? bch2_gc_mark_key+0x99/0x270
> [328669.087109] bch2_gc_mark_key+0x99/0x270
> [328669.087112] bch2_gc_btree_init_recurse+0x173/0x6e0
> [328669.087115] ? bch2_btree_node_read+0x238/0x4d0
> [328669.087118] ? bch2_btree_node_hash_insert+0x48/0xb0
> [328669.087121] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328669.087127] bch2_gc_btree_init_recurse+0x529/0x6e0
> [328669.087133] bch2_gc_btrees+0x245/0x480
> [328669.087137] ? bch2_gc_mark_key+0xce/0x270
> [328669.087141] bch2_gc+0x381/0x850
> [328669.087144] bch2_fs_recovery+0x1b06/0x21b0
> [328669.087145] ? up_write+0x36/0x60
> [328669.087150] ? idr_alloc_u32+0x8d/0xd0
> [328669.087153] ? idr_alloc_cyclic+0x50/0xb0
> [328669.087156] ? bdev_name.constprop.0+0x3e/0x160
> [328669.087158] ? vsnprintf+0x1fd/0x4f0
> [328669.087160] ? __bch2_sb_field_resize+0x62/0x110
> [328669.087163] bch2_fs_start+0x3d9/0x430
> [328669.087165] bch2_fs_open+0x45a/0x5a0
> [328669.087168] bch2_mount+0x519/0x6e0
> [328669.087173] legacy_get_tree+0x24/0x50
> [328669.087176] vfs_get_tree+0x22/0xd0
> [328669.087179] path_mount+0x488/0xab0
> [328669.087182] __x64_sys_mount+0x107/0x140
> [328669.087184] do_syscall_64+0x38/0x90
> [328669.087187] entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [328669.087189] RIP: 0033:0x7f4fcc35062a
> [328669.087191] Code: 48 8b 0d 69 18 0d 00 f7 d8 64 89 01 48 83 c8 ff
> c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00
> 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 36 18 0d 00 f7 d8 64 89
> 01 48
> All code
> =3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 8b 0d 69 18 0d 00     mov    0xd1869(%rip),%rcx        # 0xd1=
870
>    7:    f7 d8                    neg    %eax
>    9:    64 89 01                 mov    %eax,%fs:(%rcx)
>    c:    48 83 c8 ff              or     $0xffffffffffffffff,%rax
>   10:    c3                       retq
>   11:    66 2e 0f 1f 84 00 00     nopw   %cs:0x0(%rax,%rax,1)
>   18:    00 00 00
>   1b:    0f 1f 44 00 00           nopl   0x0(%rax,%rax,1)
>   20:    49 89 ca                 mov    %rcx,%r10
>   23:    b8 a5 00 00 00           mov    $0xa5,%eax
>   28:    0f 05                    syscall
>   2a:*    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    <-- trapping instruction
>   30:    73 01                    jae    0x33
>   32:    c3                       retq
>   33:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
870
>   3a:    f7 d8                    neg    %eax
>   3c:    64 89 01                 mov    %eax,%fs:(%rcx)
>   3f:    48                       rex.W
>
> Code starting with the faulting instruction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>    0:    48 3d 01 f0 ff ff        cmp    $0xfffffffffffff001,%rax
>    6:    73 01                    jae    0x9
>    8:    c3                       retq
>    9:    48 8b 0d 36 18 0d 00     mov    0xd1836(%rip),%rcx        # 0xd1=
846
>   10:    f7 d8                    neg    %eax
>   12:    64 89 01                 mov    %eax,%fs:(%rcx)
>   15:    48                       rex.W
> [328669.087193] RSP: 002b:00007fff37e41b48 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a5
> [328669.087195] RAX: ffffffffffffffda RBX: 00007f4fcc484264 RCX:
> 00007f4fcc35062a
> [328669.087196] RDX: 000055fc23036c60 RSI: 000055fc23036d10 RDI:
> 000055fc23036cc0
> [328669.087196] RBP: 000055fc23036a30 R08: 000055fc23036c80 R09:
> 00007f4fcc422be0
> [328669.087197] R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000000000000000
> [328669.087198] R13: 000055fc23036cc0 R14: 000055fc23036c60 R15:
> 000055fc23036a30
> [328669.087201]  </TASK>
> [328669.087201] ---[ end trace 0000000000000000 ]---
> [328669.087202] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511):
> bch2_journal_key_insert_take: error allocating new key array (size
> 134217728)
> [328669.088071] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511): error
> from bch2_gc_mark_key(): ENOMEM_journal_key_insert
> [328669.088505] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511):
> bch2_gc_btree_init_recurse: error from bch2_gc_mark_key:
> ENOMEM_journal_key_insert
> [328669.089394] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511): error
> from bch2_gc_btree_init(): ENOMEM_journal_key_insert
> [328669.089826] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511): error
> from bch2_gc_btrees(): ENOMEM_journal_key_insert
> [328669.164925] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511): Error
> in recovery: error checking allocations (ENOMEM_journal_key_insert)
> [328669.165767] bcachefs (56f18224-fbe1-4704-8a0f-b5486fc6d511): error
> starting filesystem: ENOMEM_journal_key_insert
>
>
> -------- EOF --------
>
> --
> Josh Litherland (josh@temp123.org)



--=20
Josh Litherland (josh@temp123.org)
