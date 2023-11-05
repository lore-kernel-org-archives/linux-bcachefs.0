Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6D4C4332F
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 23:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjKEXtj (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 18:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjKEXtj (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 18:49:39 -0500
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC67AC6
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 15:49:35 -0800 (PST)
Date:   Sun, 5 Nov 2023 18:49:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1699228173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K1FGBWdvJ6RvQIESFsWI4NQ5EMmS2s2EWAAkA4sHigQ=;
        b=ATTZOjFPuzgHIYS7RNhrxsvuD+JtEjEsOegCX21AaAE0hkewlWC9S/8XVLW6EUG2mQD/K3
        loBLiFLfXRw9GCKTZL5ZRYyoXhpSYj16Zo+pUoovq9owESZqbKExdmhkWDeWNItmiH0tRT
        2C9vk5FJzWsoUISp1SCOfsk1f7OV6Lc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Kent Overstreet <kent.overstreet@linux.dev>
To:     Mateusz Guzik <mjguzik@gmail.com>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
Message-ID: <20231105234930.vo27um4uw24usaks@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231105162630.q25p2vz2egh7jb43@moria.home.lan>
 <CAGudoHFSpfiJYKf1RtEp1H80vne+JpiSonorwD4N5YoAM8Sn3w@mail.gmail.com>
 <20231105201527.ahvcmrrmxex3hrlc@moria.home.lan>
 <CAGudoHFcAh=WpoL16yaf4oiq04Y_X5dzUskPuoqtZ_hgUL_MHQ@mail.gmail.com>
 <20231105203042.xr2qcdqqkbnpvnny@moria.home.lan>
 <CAGudoHH_DDB+exZZh0kmzhCDjtQtejGsAqeh6dmgDGwC5BpzEg@mail.gmail.com>
 <CAGudoHEm42M1c92fZQmvXqBY1FW6H3vS_O-kf+4_tt5GWwGNvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHEm42M1c92fZQmvXqBY1FW6H3vS_O-kf+4_tt5GWwGNvQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Sun, Nov 05, 2023 at 11:16:15PM +0100, Mateusz Guzik wrote:
> On 11/5/23, Mateusz Guzik <mjguzik@gmail.com> wrote:
> > On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >> On Sun, Nov 05, 2023 at 09:27:15PM +0100, Mateusz Guzik wrote:
> >>> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >>> > On Sun, Nov 05, 2023 at 08:57:53PM +0100, Mateusz Guzik wrote:
> >>> >> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >>> >> > Can you check btree_transactions in debugfs?
> >>> >>
> >>> >> 3807 __bch2_create
> >>> >>   path 0 b l=0 subvolumes:0:1:0
> >>> >>     r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks
> >>> >> 6:0:0
> >>> >> held by pid 0
> >>> >>   path 1 c l=0 inodes:0:805879636:U32_MAX
> >>> >>     w l=0       ff40076876671648 c l=0 inodes:0:805879636:U32_MAX
> >>> >> locks 0:1:1 held by pid 3807
> >>> >>   path 2 b l=0 inodes:0:805879771:0
> >>> >>     i l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
> >>> >> locks 0:2:1 held by pid 3807
> >>> >>   path 3 c l=0 inodes:0:805879771:U32_MAX
> >>> >>     i l=0       ff4007691298d870 c l=0 inodes:0:805879771:U32_MAX
> >>> >> locks 0:1:0 held by pid 3807
> >>> >>   path 4 b l=0 inodes:0:805879772:U32_MAX
> >>> >>     w l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
> >>> >> locks 0:2:1 held by pid 3807
> >>> >>   path 5 c l=0 inodes:0:805879772:U32_MAX
> >>> >>     w l=0       ff4007691298c958 c l=0 inodes:0:805879772:U32_MAX
> >>> >> locks 0:1:1 held by pid 3807
> >>> >>   path 6 b l=0 dirents:805879636:877646214245309706:U32_MAX
> >>> >>     w l=0       ff4007683e260a00 b l=0
> >>> >> dirents:872415232:213834028349939920:U32_MAX locks 0:1:1 held by pid
> >>> >> 3807
> >>> >>   path 7 c l=0 inodes:0:872415232:U32_MAX
> >>> >>     i l=0       ff40076903cdc000 c l=0 inodes:0:872415232:U32_MAX
> >>> >> locks 0:1:0 held by pid 3807
> >>> >> backtrace:
> >>> >>   [<0>] bch2_btree_key_cache_scan+0x33/0x450
> >>> >>   [<0>] do_shrink_slab+0x13c/0x360
> >>> >>   [<0>] shrink_slab+0xc9/0x3c0
> >>> >>   [<0>] shrink_node+0x363/0xb70
> >>> >>   [<0>] do_try_to_free_pages+0xd5/0x5b0
> >>> >>   [<0>] try_to_free_pages+0xdd/0x200
> >>> >>   [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
> >>> >>   [<0>] __alloc_pages+0x305/0x330
> >>> >>   [<0>] alloc_pages_mpol+0x91/0x1e0
> >>> >>   [<0>] allocate_slab+0x2d1/0x4d0
> >>> >>   [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
> >>> >>   [<0>] __kmem_cache_alloc_node+0x113/0x270
> >>> >>   [<0>] __kmalloc_node_track_caller+0x4d/0x150
> >>> >>   [<0>] krealloc+0x5d/0xc0
> >>> >>   [<0>] __bch2_trans_commit+0x1d59/0x1f30
> >>> >>   [<0>] __bch2_create+0x288/0x4e0
> >>> >>   [<0>] bch2_create+0x26/0x60
> >>> >>   [<0>] path_openat+0xe9f/0x11d0
> >>> >>   [<0>] do_filp_open+0xb4/0x160
> >>> >>   [<0>] do_sys_openat2+0x91/0xc0
> >>> >>   [<0>] __x64_sys_openat+0x6a/0xa0
> >>> >>   [<0>] do_syscall_64+0x32/0xf0
> >>> >>   [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
> >>> >
> >>> > So we called krealloc() with GFP_KERNEL, which then invoked key cache
> >>> > reclaim, with btree locks held - oops.
> >>> >
> >>> > Can you run scripts/faddr2line on __bch2_trans_commit+0x1d59/0x1f30 ?
> >>> >
> >>>
> >>> __bch2_trans_commit+0x1d59/0x1f30:
> >>> btree_key_can_insert_cached at fs/bcachefs/btree_trans_commit.c:350
> >>> (inlined by) bch2_trans_commit_write_locked at
> >>> fs/bcachefs/btree_trans_commit.c:583
> >>> (inlined by) do_bch2_trans_commit at
> >>> fs/bcachefs/btree_trans_commit.c:847
> >>> (inlined by) __bch2_trans_commit at
> >>> fs/bcachefs/btree_trans_commit.c:1126
> >>
> >> Fix is in the bcachefs-testing branch :)
> >>
> >
> > have you tested this? looks rather fishy as there is no memcpy of the
> > old content.
> >
> 
> Just cherry-picking the patch to master crashes. I booted a kernel
> built from the bcachefs-testing branch and it crashes the same way.

Yup, forgot the memcpy, fixed version is up now.
