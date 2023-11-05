Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23C03C4167B
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 22:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjKEWQW (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 17:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKEWQV (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 17:16:21 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE25DD
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 14:16:16 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id 5614622812f47-3b2df2fb611so2819887b6e.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Nov 2023 14:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699222576; x=1699827376; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=d8EOlIiGz9rmKZp4So6k4Z2H69Eo0fb4gEtx2dH+Q0o=;
        b=kMqFYkAAuJoQ+ERighmRSC+A7ibb741i2R50U+eQXe0FfJJKDrjX3Q75G7O9GswYfB
         ES8AQ5BOXgU9g/0Dz7iOhVuTlF/V5uMXbQ8GfuhxDwkmPvcKEYLfG+8vkA2J1vwlpKRx
         DSyzuuFaXWITMqO56FOcAqLuQ0rxoEhJhMSzK+ubWKur6S9L7IYX7cCiSuCdWUCWkwPT
         DSiMqqw9/Cu5ySPuGkEZRYMvb7x+EjGFs5lbDq2JTzBkBk1xE/HAgeafxCS0vFDJRuTb
         0XOqm8GV5kLpeu5yFKQg0FA1yH2ryto71ZeHve9aIzHcV34MV87qjfEN9NZ8HPG/mCpx
         HoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699222576; x=1699827376;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d8EOlIiGz9rmKZp4So6k4Z2H69Eo0fb4gEtx2dH+Q0o=;
        b=DrEBZQmjYqkKr/l39jRaOBobSfRdCqdIMQ/ZKt625sZu8YUB0AOdIyyBy/0MS95aBm
         F/qrhj2lMZF0PLogErAaKokCcBwLHEiNDnJB1SD8yNu42Mkl00fdaXjY/MiiioCJdh3x
         OShsy8dbgfZEgPq9hDQ7Dwk6v1jct/0hMTXpn3Q6pDtnLF2LPeZulqtBgbRqTJgFvP0Y
         LRlnaFUHKGcLXe0ux2lVrEsSZ3iqQTflsWLocGYtXNj063OhbzJiaA57keBsIS5/r9Ty
         9K3c9C87oUpAOeR4wC4i4FQ/rpqjAULmOLjI/rRGaFWHTtnitGMXWHOkHtC47ODPUrBn
         LP3Q==
X-Gm-Message-State: AOJu0YyQn8Is++AEoIdO6iYwRUTHDSWmZBf8exXzH0xXeUE2DmakqHL5
        PzlK/778DTHpxXu6+x6jhuX91B4j9M+6VkVdwWs=
X-Google-Smtp-Source: AGHT+IG4mbj10b/kWViIzzPEqU6rh2xc0H5nWUoCwA5FwwxVR5JOTfA6ADZdZcZMUczPgf8d+wR9BG+z9yCFrhQMbmI=
X-Received: by 2002:a05:6808:4494:b0:3b5:6432:e0eb with SMTP id
 eq20-20020a056808449400b003b56432e0ebmr21262888oib.38.1699222576071; Sun, 05
 Nov 2023 14:16:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f8f:0:b0:4f0:1250:dd51 with HTTP; Sun, 5 Nov 2023
 14:16:15 -0800 (PST)
In-Reply-To: <CAGudoHH_DDB+exZZh0kmzhCDjtQtejGsAqeh6dmgDGwC5BpzEg@mail.gmail.com>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231105162630.q25p2vz2egh7jb43@moria.home.lan> <CAGudoHFSpfiJYKf1RtEp1H80vne+JpiSonorwD4N5YoAM8Sn3w@mail.gmail.com>
 <20231105201527.ahvcmrrmxex3hrlc@moria.home.lan> <CAGudoHFcAh=WpoL16yaf4oiq04Y_X5dzUskPuoqtZ_hgUL_MHQ@mail.gmail.com>
 <20231105203042.xr2qcdqqkbnpvnny@moria.home.lan> <CAGudoHH_DDB+exZZh0kmzhCDjtQtejGsAqeh6dmgDGwC5BpzEg@mail.gmail.com>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Sun, 5 Nov 2023 23:16:15 +0100
Message-ID: <CAGudoHEm42M1c92fZQmvXqBY1FW6H3vS_O-kf+4_tt5GWwGNvQ@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 11/5/23, Mateusz Guzik <mjguzik@gmail.com> wrote:
> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> On Sun, Nov 05, 2023 at 09:27:15PM +0100, Mateusz Guzik wrote:
>>> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>>> > On Sun, Nov 05, 2023 at 08:57:53PM +0100, Mateusz Guzik wrote:
>>> >> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>>> >> > Can you check btree_transactions in debugfs?
>>> >>
>>> >> 3807 __bch2_create
>>> >>   path 0 b l=0 subvolumes:0:1:0
>>> >>     r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks
>>> >> 6:0:0
>>> >> held by pid 0
>>> >>   path 1 c l=0 inodes:0:805879636:U32_MAX
>>> >>     w l=0       ff40076876671648 c l=0 inodes:0:805879636:U32_MAX
>>> >> locks 0:1:1 held by pid 3807
>>> >>   path 2 b l=0 inodes:0:805879771:0
>>> >>     i l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>>> >> locks 0:2:1 held by pid 3807
>>> >>   path 3 c l=0 inodes:0:805879771:U32_MAX
>>> >>     i l=0       ff4007691298d870 c l=0 inodes:0:805879771:U32_MAX
>>> >> locks 0:1:0 held by pid 3807
>>> >>   path 4 b l=0 inodes:0:805879772:U32_MAX
>>> >>     w l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>>> >> locks 0:2:1 held by pid 3807
>>> >>   path 5 c l=0 inodes:0:805879772:U32_MAX
>>> >>     w l=0       ff4007691298c958 c l=0 inodes:0:805879772:U32_MAX
>>> >> locks 0:1:1 held by pid 3807
>>> >>   path 6 b l=0 dirents:805879636:877646214245309706:U32_MAX
>>> >>     w l=0       ff4007683e260a00 b l=0
>>> >> dirents:872415232:213834028349939920:U32_MAX locks 0:1:1 held by pid
>>> >> 3807
>>> >>   path 7 c l=0 inodes:0:872415232:U32_MAX
>>> >>     i l=0       ff40076903cdc000 c l=0 inodes:0:872415232:U32_MAX
>>> >> locks 0:1:0 held by pid 3807
>>> >> backtrace:
>>> >>   [<0>] bch2_btree_key_cache_scan+0x33/0x450
>>> >>   [<0>] do_shrink_slab+0x13c/0x360
>>> >>   [<0>] shrink_slab+0xc9/0x3c0
>>> >>   [<0>] shrink_node+0x363/0xb70
>>> >>   [<0>] do_try_to_free_pages+0xd5/0x5b0
>>> >>   [<0>] try_to_free_pages+0xdd/0x200
>>> >>   [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
>>> >>   [<0>] __alloc_pages+0x305/0x330
>>> >>   [<0>] alloc_pages_mpol+0x91/0x1e0
>>> >>   [<0>] allocate_slab+0x2d1/0x4d0
>>> >>   [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
>>> >>   [<0>] __kmem_cache_alloc_node+0x113/0x270
>>> >>   [<0>] __kmalloc_node_track_caller+0x4d/0x150
>>> >>   [<0>] krealloc+0x5d/0xc0
>>> >>   [<0>] __bch2_trans_commit+0x1d59/0x1f30
>>> >>   [<0>] __bch2_create+0x288/0x4e0
>>> >>   [<0>] bch2_create+0x26/0x60
>>> >>   [<0>] path_openat+0xe9f/0x11d0
>>> >>   [<0>] do_filp_open+0xb4/0x160
>>> >>   [<0>] do_sys_openat2+0x91/0xc0
>>> >>   [<0>] __x64_sys_openat+0x6a/0xa0
>>> >>   [<0>] do_syscall_64+0x32/0xf0
>>> >>   [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
>>> >
>>> > So we called krealloc() with GFP_KERNEL, which then invoked key cache
>>> > reclaim, with btree locks held - oops.
>>> >
>>> > Can you run scripts/faddr2line on __bch2_trans_commit+0x1d59/0x1f30 ?
>>> >
>>>
>>> __bch2_trans_commit+0x1d59/0x1f30:
>>> btree_key_can_insert_cached at fs/bcachefs/btree_trans_commit.c:350
>>> (inlined by) bch2_trans_commit_write_locked at
>>> fs/bcachefs/btree_trans_commit.c:583
>>> (inlined by) do_bch2_trans_commit at
>>> fs/bcachefs/btree_trans_commit.c:847
>>> (inlined by) __bch2_trans_commit at
>>> fs/bcachefs/btree_trans_commit.c:1126
>>
>> Fix is in the bcachefs-testing branch :)
>>
>
> have you tested this? looks rather fishy as there is no memcpy of the
> old content.
>

Just cherry-picking the patch to master crashes. I booted a kernel
built from the bcachefs-testing branch and it crashes the same way.

[   66.377496] ------------[ cut here ]------------
[   66.377503] kernel BUG at fs/bcachefs/btree_trans_commit.c:40!
[   66.379023] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[   66.380335] CPU: 17 PID: 883 Comm: mkdir Not tainted 6.6.0+ #394
[   66.381985] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 0

                              4/01/2014
[   66.384234] RIP: 0010:verify_update_old_key+0x1b2/0x1c0
[   66.385085] Code: 4c 24 08 8b 40 24 89 44 24 10 e8 19 84 ff ff 48
83 c4 18 48 85 c0 0f 84 24 ff ff ff 48 89 c3 4c 8

                            d 68 28 e9 18 ff ff ff 0f 0b <0f> 0b e8 d7
f8 73 00 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90
[   66.388169] RSP: 0018:ff3bcecc00a2fa58 EFLAGS: 00010286
[   66.389017] RAX: 0000000000000000 RBX: ff3bcecc00a2fa58 RCX:
00000000acdfafdf
[   66.390164] RDX: 0000000000000000 RSI: ff3bcecc00a2fa80 RDI:
ff32af8fc7d8a628
[   66.391311] RBP: ff3bcecc00a2fab8 R08: ff32af8fcebcfb28 R09:
0000000000000000
[   66.392652] R10: 0000000001000000 R11: 0000000000000000 R12:
ff32af8fc7d8a5e0
[   66.393802] R13: 0000000000000000 R14: ff32af8fc4b00000 R15: ff32af8fc7d88000
[   66.394934] FS:  00007f45eb16fc40(0000) GS:ff32af9527a40000(0000)
knlGS:0000000000000000
[   66.396295] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.397235] CR2: 00007f45eb2f8cd0 CR3: 0000000108f34002 CR4: 0000000000371ee0
[   66.398398] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   66.399545] DR3: 0000000000000000 DR6: 00000000fffe07f0 DR7: 0000000000000400
[   66.400727] Call Trace:
[   66.401156]  <TASK>
[   66.401528]  ? die+0x32/0x80
[   66.402091]  ? do_trap+0xd6/0x100
[   66.402650]  ? verify_update_old_key+0x1b2/0x1c0
[   66.403408]  ? do_error_trap+0x6a/0x90
[   66.404837]  ? verify_update_old_key+0x1b2/0x1c0
[   66.406346]  ? exc_invalid_op+0x4c/0x60
[   66.407795]  ? verify_update_old_key+0x1b2/0x1c0
[   66.409293]  ? asm_exc_invalid_op+0x16/0x20
[   66.410694]  ? verify_update_old_key+0x1b2/0x1c0
[   66.412152]  ? verify_update_old_key+0x117/0x1c0
[   66.413609]  run_one_mem_trigger+0x7a/0x2a0
[   66.414944]  __bch2_trans_commit+0x1610/0x20d0
[   66.416382]  __bch2_create+0x288/0x4e0
[   66.417653]  ? may_create+0x111/0x120
[   66.418848]  ? bch2_mkdir+0x24/0x60
[   66.420122]  bch2_mkdir+0x24/0x60
[   66.421286]  vfs_mkdir+0x190/0x240
[   66.422606]  do_mkdirat+0x135/0x160
[   66.423768]  __x64_sys_mkdir+0x45/0x60
[   66.424928]  do_syscall_64+0x2e/0x80

I added that memcpy but it did not help.

-- 
Mateusz Guzik <mjguzik gmail.com>
