Return-Path: <linux-bcachefs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 470C0C4167D
	for <linux-bcachefs@archiver.kernel.org>; Sun,  5 Nov 2023 20:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjKEU1U (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 5 Nov 2023 15:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKEU1T (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 5 Nov 2023 15:27:19 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CFBB3
        for <linux-bcachefs@vger.kernel.org>; Sun,  5 Nov 2023 12:27:16 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id 006d021491bc7-581e9b8e5fbso1885441eaf.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Nov 2023 12:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699216036; x=1699820836; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aVXEBcaNlqJmQjQybE+7GDf2acTggol0E8H9F++4wkQ=;
        b=Z6gPhL8NSFp7X+iE8KXycmrHP9HYT8wcpXrF3q64/ldgpT/bisKfGOEQLEfM5U6GlF
         0mTdK02r6a8xKcqkYEX6hzWQDnu/8crcfooRzRsAZMpI1MBf8xh5xh0nMEpVczArK2nD
         mDxsCfIdcNS8fTP1etNcn2MHDt0uszlIRxIy10yBo4/uBR4H77htd5F962wFLcGY4rhe
         IE53UlNzB4V4oqN+/O/FcITIze9TKcjLB0CmPq/c6izN9cR/vO5/OEH1gaFuLt8te7wZ
         PrE4S+hVJmNGPjaQaOr0xtHEhGyPXKPCIUHBDjEVcAX9gg+d499cK5R6yQPUt3kQee7+
         TP3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699216036; x=1699820836;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aVXEBcaNlqJmQjQybE+7GDf2acTggol0E8H9F++4wkQ=;
        b=O6C66txGIewkPF5JEZ+mqlHVM32nbxfwTpI/ajU3xbeN7q0YLGfxk8XDLsxnT74Piu
         tgFG3LnT6R+hT96s9kUYOTyQsoBsOEWvCXZw9RwbB31gm/PO6DxJYcFicrkoCAKvjEB3
         wQoFskLnCOKTjMtB4pb0UFcV53EZm/dgeYbUWzeeeUUKUf/VIvfoyim+glsP14nMiB1L
         +3XVTYVaG8XrXm3YjtjiIxq5Camy/YmtBMpywfrDwadabqmnBncJBn1MbnvuftBOfQIn
         vZgLgBrA9T7EN9noSg9rV0X0CQGyZSUUNHBBR4PSR6wa+Kla8lqC0K/hFcZV5MIaZIPD
         rjxw==
X-Gm-Message-State: AOJu0YyVzgY/0zUEBO7NhHRFfhPxnbHPY85psQF20T7SfYTHBGgVHWpj
        ZV3fsZ1GsiQyS8SNeY2jR7oDvl4Swr6HB3SEUVw=
X-Google-Smtp-Source: AGHT+IEaJOErNGBAfOM8EcLgtiHW9glabs1qKYBXKpeA9LcDVSaBHq5dDZLTvbZ7Pra1ATIERj267/EEKncASYXax6A=
X-Received: by 2002:a4a:db88:0:b0:581:d6a6:478a with SMTP id
 s8-20020a4adb88000000b00581d6a6478amr4768101oou.0.1699216035844; Sun, 05 Nov
 2023 12:27:15 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac9:7f8f:0:b0:4f0:1250:dd51 with HTTP; Sun, 5 Nov 2023
 12:27:15 -0800 (PST)
In-Reply-To: <20231105201527.ahvcmrrmxex3hrlc@moria.home.lan>
References: <CAGudoHGenxzk0ZqPXXi1_QDbfqQhGHu+wUwzyS6WmfkUZ1HiXA@mail.gmail.com>
 <20231105162630.q25p2vz2egh7jb43@moria.home.lan> <CAGudoHFSpfiJYKf1RtEp1H80vne+JpiSonorwD4N5YoAM8Sn3w@mail.gmail.com>
 <20231105201527.ahvcmrrmxex3hrlc@moria.home.lan>
From:   Mateusz Guzik <mjguzik@gmail.com>
Date:   Sun, 5 Nov 2023 21:27:15 +0100
Message-ID: <CAGudoHFcAh=WpoL16yaf4oiq04Y_X5dzUskPuoqtZ_hgUL_MHQ@mail.gmail.com>
Subject: Re: long stalls when creating 20 directory trees of 1 million inodes
 in parallel
To:     Kent Overstreet <kent.overstreet@linux.dev>
Cc:     linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> On Sun, Nov 05, 2023 at 08:57:53PM +0100, Mateusz Guzik wrote:
>> On 11/5/23, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>> > Can you check btree_transactions in debugfs?
>>
>> 3807 __bch2_create
>>   path 0 b l=0 subvolumes:0:1:0
>>     r l=0       ff4007690c378000 b l=0 subvolumes:SPOS_MAX locks 6:0:0
>> held by pid 0
>>   path 1 c l=0 inodes:0:805879636:U32_MAX
>>     w l=0       ff40076876671648 c l=0 inodes:0:805879636:U32_MAX
>> locks 0:1:1 held by pid 3807
>>   path 2 b l=0 inodes:0:805879771:0
>>     i l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>> locks 0:2:1 held by pid 3807
>>   path 3 c l=0 inodes:0:805879771:U32_MAX
>>     i l=0       ff4007691298d870 c l=0 inodes:0:805879771:U32_MAX
>> locks 0:1:0 held by pid 3807
>>   path 4 b l=0 inodes:0:805879772:U32_MAX
>>     w l=0       ff4007683e267a00 b l=0 inodes:0:872415843:U32_MAX
>> locks 0:2:1 held by pid 3807
>>   path 5 c l=0 inodes:0:805879772:U32_MAX
>>     w l=0       ff4007691298c958 c l=0 inodes:0:805879772:U32_MAX
>> locks 0:1:1 held by pid 3807
>>   path 6 b l=0 dirents:805879636:877646214245309706:U32_MAX
>>     w l=0       ff4007683e260a00 b l=0
>> dirents:872415232:213834028349939920:U32_MAX locks 0:1:1 held by pid
>> 3807
>>   path 7 c l=0 inodes:0:872415232:U32_MAX
>>     i l=0       ff40076903cdc000 c l=0 inodes:0:872415232:U32_MAX
>> locks 0:1:0 held by pid 3807
>> backtrace:
>>   [<0>] bch2_btree_key_cache_scan+0x33/0x450
>>   [<0>] do_shrink_slab+0x13c/0x360
>>   [<0>] shrink_slab+0xc9/0x3c0
>>   [<0>] shrink_node+0x363/0xb70
>>   [<0>] do_try_to_free_pages+0xd5/0x5b0
>>   [<0>] try_to_free_pages+0xdd/0x200
>>   [<0>] __alloc_pages_slowpath.constprop.0+0x2e4/0xd50
>>   [<0>] __alloc_pages+0x305/0x330
>>   [<0>] alloc_pages_mpol+0x91/0x1e0
>>   [<0>] allocate_slab+0x2d1/0x4d0
>>   [<0>] ___slab_alloc.constprop.0+0x42a/0x6c0
>>   [<0>] __kmem_cache_alloc_node+0x113/0x270
>>   [<0>] __kmalloc_node_track_caller+0x4d/0x150
>>   [<0>] krealloc+0x5d/0xc0
>>   [<0>] __bch2_trans_commit+0x1d59/0x1f30
>>   [<0>] __bch2_create+0x288/0x4e0
>>   [<0>] bch2_create+0x26/0x60
>>   [<0>] path_openat+0xe9f/0x11d0
>>   [<0>] do_filp_open+0xb4/0x160
>>   [<0>] do_sys_openat2+0x91/0xc0
>>   [<0>] __x64_sys_openat+0x6a/0xa0
>>   [<0>] do_syscall_64+0x32/0xf0
>>   [<0>] entry_SYSCALL_64_after_hwframe+0x6e/0x76
>
> So we called krealloc() with GFP_KERNEL, which then invoked key cache
> reclaim, with btree locks held - oops.
>
> Can you run scripts/faddr2line on __bch2_trans_commit+0x1d59/0x1f30 ?
>

__bch2_trans_commit+0x1d59/0x1f30:
btree_key_can_insert_cached at fs/bcachefs/btree_trans_commit.c:350
(inlined by) bch2_trans_commit_write_locked at
fs/bcachefs/btree_trans_commit.c:583
(inlined by) do_bch2_trans_commit at fs/bcachefs/btree_trans_commit.c:847
(inlined by) __bch2_trans_commit at fs/bcachefs/btree_trans_commit.c:1126

-- 
Mateusz Guzik <mjguzik gmail.com>
