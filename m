Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051D6C4167D
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 23:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjKEX66 (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 18:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKEX65 (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 18:58:57 -0500
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792A9D8
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 15:58:54 -0800 (PST)
Received: by mail-oo1-xc30.google.com with SMTP id 006d021491bc7-5875e24c749so1887346eaf.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Nov 2023 15:58:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699228734; x=1699833534; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CBEmASdNWHYOtoirebebSnpV4/wfxHQXrVU86nLQy2c=;
        b=AUPdBvM74EOCCHuvOargYa0sQjp8plN+16sDHyvJZGugZVFDvXkhDOv//sFbEpdNcs
         m/DIag97vsy1hCbyWLB+aZN845Ftee2CqsbmwgkHXl2vpe9KxTtLPq/V/TR+ZwWm2MD5
         fkALzZpLFrDaW89bvIdOKmXYeDo51C8Xme+1ygD5hsmlTNp4S7DyKVtjb95LvKypjQGw
         Veki026ttctG79Y1aR4WkaJxwd7FcEpnzgK+6rtHKAzBcbdt2XVFaT1J3Ngq9PhMs5Wy
         p1939bvkTg4YIHVBxVWOe8sMCWSmSsBYG20L6XQ6QfTxwaq+aPAT2HPTqKfy5MlWKkrD
         FW5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699228734; x=1699833534;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CBEmASdNWHYOtoirebebSnpV4/wfxHQXrVU86nLQy2c=;
        b=fyedWIyu41SWGO4uInux2gnKQ0cc17ZxQCNfhTvBzMvW2WbCVo9Az/lg3M4Ppiv0CB
         zQZ6gBFrvwGPvhj7iCsxnhDz6XPLWmAGXA5AK+VfKuJivI6vrpC26+j7vGBeFhlZdg7u
         YIIgY8XEEsHlTcp3/+mMFxd7Oa/BmL39gs0SfsRPrqnmxbzd6G6yF8CbXYiO7Du3YnXz
         X2SJzFx8xhGbwpNhKFJ48GaaV15Ll9fOXRDWxpOtxiwgRgrZDRG3jwgi74at4DKAyccn
         36JZfrTHjJmrPFE1m+KW3pSYHE6fJIWkYc/Dq6GJ4IxR6Fpe8GAayw4o/u28Lq9ShY3y
         EItw==
X-Gm-Message-State: AOJu0YwswhW0d8LG10J6tESTenD9bKcNsOGRSbm3gW1+nwmchEPF6r9m
        rDmlJO1ZXMN0tHFNRZoM+dwG2mojgHPECzaG5yI=
X-Google-Smtp-Source: AGHT+IGQ67R1ONaL9IONOQy11K12aab6JiV/L7jNIPIVyOls4TVxvTLwewwhkumlE+6UIfcFgR8yPNe81kbam1EXils=
X-Received: by 2002:a4a:e28a:0:b0:581:ed9a:4fde with SMTP id
 k10-20020a4ae28a000000b00581ed9a4fdemr25773091oot.1.1699228733731; Sun, 05
 Nov 2023 15:58:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f8f:0:b0:4f0:1250:dd51 with HTTP; Sun, 5 Nov 2023
 15:58:52 -0800 (PST)
In-Reply-To: <20231105234930.vo27um4uw24usaks@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231105162630.q25p2vz2egh7jb43@moria.home.lan> <CAGudoHFSpfiJYKf1RtEp1H80vne+JpiSonorwD4N5YoAM8Sn3w@mail.gmail.com>
 <20231105201527.ahvcmrrmxex3hrlc@moria.home.lan> <CAGudoHFcAh=WpoL16yaf4oiq04Y_X5dzUskPuoqtZ_hgUL_MHQ@mail.gmail.com>
 <20231105203042.xr2qcdqqkbnpvnny@moria.home.lan> <CAGudoHH_DDB+exZZh0kmzhCDjtQtejGsAqeh6dmgDGwC5BpzEg@mail.gmail.com>
 <CAGudoHEm42M1c92fZQmvXqBY1FW6H3vS_O-kf+4_tt5GWwGNvQ@mail.gmail.com> <20231105234930.vo27um4uw24usaks@moria.home.lan>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Mon, 6 Nov 2023 00:58:52 +0100
Message-ID: <CAGudoHExso=jb+i5BchTjkyx9mYGZCH1T0_ENwsuXgtu5yf8Xg@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 11/6/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Sun, Nov 05, 2023 at 11:16:15PM +0100, Mateusz Guzik wrote:
>> On 11/5/23, Mateusz Guzik <mjguzik@gmail.com> wrote:
>> > On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> >> On Sun, Nov 05, 2023 at 09:27:15PM +0100, Mateusz Guzik wrote:
>> >>> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> >>> > On Sun, Nov 05, 2023 at 08:57:53PM +0100, Mateusz Guzik wrote:
>> >>> >> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> >>> >> > Can you check btree_transactions in debugfs?
>> >>> >>
>> >>> >> 3807 __bch2_create
>> >>> >>   path 0 b l=0 subvolumes:0:1:0
>> >>> >>     r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks
>> >>> >> 6:0:0
>> >>> >> held by pid 0
>> >>> >>   path 1 c l=0 inodes:0:805879636:U32_MAX
>> >>> >>     w l=0       ff40076876671648 c l=0 inodes:0:805879636:U32_MAX
>> >>> >> locks 0:1:1 held by pid 3807
>> >>> >>   path 2 b l=0 inodes:0:805879771:0
>> >>> >>     i l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>> >>> >> locks 0:2:1 held by pid 3807
>> >>> >>   path 3 c l=0 inodes:0:805879771:U32_MAX
>> >>> >>     i l=0       ff4007691298d870 c l=0 inodes:0:805879771:U32_MAX
>> >>> >> locks 0:1:0 held by pid 3807
>> >>> >>   path 4 b l=0 inodes:0:805879772:U32_MAX
>> >>> >>     w l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>> >>> >> locks 0:2:1 held by pid 3807
>> >>> >>   path 5 c l=0 inodes:0:805879772:U32_MAX
>> >>> >>     w l=0       ff4007691298c958 c l=0 inodes:0:805879772:U32_MAX
>> >>> >> locks 0:1:1 held by pid 3807
>> >>> >>   path 6 b l=0 dirents:805879636:877646214245309706:U32_MAX
>> >>> >>     w l=0       ff4007683e260a00 b l=0
>> >>> >> dirents:872415232:213834028349939920:U32_MAX locks 0:1:1 held by
>> >>> >> pid
>> >>> >> 3807
>> >>> >>   path 7 c l=0 inodes:0:872415232:U32_MAX
>> >>> >>     i l=0       ff40076903cdc000 c l=0 inodes:0:872415232:U32_MAX
>> >>> >> locks 0:1:0 held by pid 3807
>> >>> >> backtrace:
>> >>> >>   [<0>] bch2_btree_key_cache_scan+0x33/0x450
>> >>> >>   [<0>] do_shrink_slab+0x13c/0x360
>> >>> >>   [<0>] shrink_slab+0xc9/0x3c0
>> >>> >>   [<0>] shrink_node+0x363/0xb70
>> >>> >>   [<0>] do_try_to_free_pages+0xd5/0x5b0
>> >>> >>   [<0>] try_to_free_pages+0xdd/0x200
>> >>> >>   [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
>> >>> >>   [<0>] __alloc_pages+0x305/0x330
>> >>> >>   [<0>] alloc_pages_mpol+0x91/0x1e0
>> >>> >>   [<0>] allocate_slab+0x2d1/0x4d0
>> >>> >>   [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
>> >>> >>   [<0>] __kmem_cache_alloc_node+0x113/0x270
>> >>> >>   [<0>] __kmalloc_node_track_caller+0x4d/0x150
>> >>> >>   [<0>] krealloc+0x5d/0xc0
>> >>> >>   [<0>] __bch2_trans_commit+0x1d59/0x1f30
>> >>> >>   [<0>] __bch2_create+0x288/0x4e0
>> >>> >>   [<0>] bch2_create+0x26/0x60
>> >>> >>   [<0>] path_openat+0xe9f/0x11d0
>> >>> >>   [<0>] do_filp_open+0xb4/0x160
>> >>> >>   [<0>] do_sys_openat2+0x91/0xc0
>> >>> >>   [<0>] __x64_sys_openat+0x6a/0xa0
>> >>> >>   [<0>] do_syscall_64+0x32/0xf0
>> >>> >>   [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
>> >>> >
>> >>> > So we called krealloc() with GFP_KERNEL, which then invoked key
>> >>> > cache
>> >>> > reclaim, with btree locks held - oops.
>> >>> >
>> >>> > Can you run scripts/faddr2line on __bch2_trans_commit+0x1d59/0x1f30
>> >>> > ?
>> >>> >
>> >>>
>> >>> __bch2_trans_commit+0x1d59/0x1f30:
>> >>> btree_key_can_insert_cached at fs/bcachefs/btree_trans_commit.c:350
>> >>> (inlined by) bch2_trans_commit_write_locked at
>> >>> fs/bcachefs/btree_trans_commit.c:583
>> >>> (inlined by) do_bch2_trans_commit at
>> >>> fs/bcachefs/btree_trans_commit.c:847
>> >>> (inlined by) __bch2_trans_commit at
>> >>> fs/bcachefs/btree_trans_commit.c:1126
>> >>
>> >> Fix is in the bcachefs-testing branch :)
>> >>
>> >
>> > have you tested this? looks rather fishy as there is no memcpy of the
>> > old content.
>> >
>>
>> Just cherry-picking the patch to master crashes. I booted a kernel
>> built from the bcachefs-testing branch and it crashes the same way.
>
> Yup, forgot the memcpy, fixed version is up now.
>

It does not outright panic anymore, but it still runs into something:

[  157.471988] kernel BUG at fs/bcachefs/btree_locking.h:87!
[  157.472878] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[  157.473651] CPU: 7 PID: 946 Comm: createtree Not tainted 6.6.0+
#395
[  157.474579] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 0

                              4/01/2014
[  157.476188] RIP: 0010:bch2_trans_unlock+0x153/0x170
[  157.476917] Code: 94 04 30 01 00 00 39 d1 75 2d 49 8d ac 04 30 01
00 00 48 85 ed 0f 85 1c ff ff ff 48 83 c4 08 5b 5

                            d 41 5c c3 cc cc cc cc 0f 0b <0f> 0b 0f 0b
0f 0b c3 cc cc cc cc 0f 0b 0f 0b 66 66 2e 0f 1f 84 00
[  157.479614] RSP: 0018:ff34ad9e80db79b8 EFLAGS: 00010246
[  157.480396] RAX: 0000000000000003 RBX: ffffffffb8c7dfe0 RCX:
0000000000000000
[  157.481441] RDX: 0000000000000003 RSI: 0000000000000020 RDI:
ff3321b68bdc5cc0
[  157.482487] RBP: ff3321b5eec681c0 R08: ff34ad9e80db7960 R09:
ff3321b5eec68400
[  157.483528] R10: 0000000000000000 R11: ff3321b690d40000 R12:
ff3321b5eec68000
[  157.484579] R13: ff3321b5eec6a530 R14: ff3321b5eec6a5e0 R15:
0000000000000000
[  157.485637] FS:  00007fcbb4420740(0000) GS:ff3321bbe77c0000(0000)
knlGS:0000000000000000
[  157.486819] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  157.487662] CR2: 00007fe1d0271207 CR3: 00000001100ae003 CR4:
0000000000371ee0
[  157.488800] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  157.489849] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[  157.490892] Call Trace:
[  157.491275]  <TASK>
[  157.491602]  ? die+0x32/0x80
[  157.492048]  ? do_trap+0xd6/0x100
[  157.492555]  ? bch2_trans_unlock+0x153/0x170
[  157.493192]  ? do_error_trap+0x6a/0x90
[  157.494456]  ? bch2_trans_unlock+0x153/0x170
[  157.495800]  ? exc_invalid_op+0x4c/0x60
[  157.497090]  ? bch2_trans_unlock+0x153/0x170
[  157.498414]  ? asm_exc_invalid_op+0x16/0x20
[  157.499699]  ? bch2_trans_unlock+0x60/0x170
[  157.500985]  ? bch2_trans_unlock+0x153/0x170
[  157.502259]  ? bch2_trans_unlock+0xce/0x170
[  157.503488]  __bch2_trans_commit+0x1e5d/0x20f0
[  157.504775]  __bch2_create+0x288/0x4e0
[  157.505942]  ? d_splice_alias+0x8e/0x2b0
[  157.507090]  ? bch2_create+0x26/0x60
[  157.508203]  bch2_create+0x26/0x60
[  157.509262]  path_openat+0xe9f/0x11d0
[  157.510349]  do_filp_open+0xb4/0x160
[  157.511420]  ? kmem_cache_alloc+0x16b/0x300
[  157.512553]  ? _raw_spin_unlock+0xa/0x30
[  157.513634]  do_sys_openat2+0x91/0xc0
[  157.514686]  __x64_sys_openat+0x6a/0xa0
[  157.515734]  do_syscall_64+0x2e/0x80
[  157.516734]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Everything you need to beat this into shape is here:
https://people.freebsd.org/~mjg/fstree.tgz

I'm rolling with 24 cores + 24G ram.

-- 
Mateusz Guzik <mjguzik gmail.com>
