Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011B6C433F5
	for <linux-bcachefs@archiver.kernel.org>; Fri, 11 Mar 2022 00:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiCKAoe (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Mar 2022 19:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbiCKAod (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Mar 2022 19:44:33 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B22143467
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Mar 2022 16:43:31 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id b67so5899537qkc.6
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Mar 2022 16:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3NLLTG9OFHcMhsmKK0uZxt7eFYZIERxpKpNsaSLOa0=;
        b=MLswcwQTh6s8yspiHwFZbD06THWWMh9MGReNoyjnjirOUj4OgzPSE4u8/a4NP/A/UW
         TbeeRM8wHzF01nYUZiqi6YYcQKLQUTPTUhugAk6BCOlKrHm03dI5CWTrZdunDEvHs6DU
         mYPf2FOpOPqCN4o3PGqhsWAcXfdewNt9NJ8E7voZ9j9mzVpzoWltrFBmNxfbLwfbid9i
         yxYR3hBVmuLHeFF3Fnbar/TnjCQTFee+97YuAmbOXoZ+pKIUg2j96tJhrUP8AAldOaaI
         XqIy5/goEBBsrsR3L1jaDfoh9G/D82/6R5DfQFyhMWzdsnEbM3Ckh7Wb/KYvp3+YSLnj
         4esw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3NLLTG9OFHcMhsmKK0uZxt7eFYZIERxpKpNsaSLOa0=;
        b=46z5IqbZY0s+W6NEwn8gN9av3iJwobC1dD1+Kuse1CuBf8bv0cXjZZ1kwTLu+60REM
         3kV+n4L/qP+HiD6TPNC+vMSd4hvX806nhlvWnY3ZmFmi0tuBtKTems09NMR5NjiB+okI
         NX8lScPd0lhkzzrC0aVX4pqVuuIqyo2d0KAp6B+CaG0e8OQ/Hk/d04xcD9pPPf1hLFSh
         Wk1ul2X0tSTQA+JmyJn5YovMukwlKY5A0aYSM6ue4bZwweIZkLlcj4XMNzLQaM3Wzf1f
         kniCTYBqPNm9cmH2J7UVR7DH5gInObHtwysks7dzRthwuFacU+98OzsBdTjqv2Z+kcNn
         dmsA==
X-Gm-Message-State: AOAM532UNYqZLDqu7497d5/SujmtjidujOq/N1JU7sBzk7w4CvsVeRha
        LOtCvm2zTIRGm5idy1C+wiHZaOaW/g==
X-Google-Smtp-Source: ABdhPJzkQ6X2BJ4S0iRchkv34iPR9GPkIQnmkoDdS31l6qNGxhfJhsMoQAe/o+T2z/ej+Wxt/BLjLw==
X-Received: by 2002:a05:620a:22b3:b0:67b:3170:c383 with SMTP id p19-20020a05620a22b300b0067b3170c383mr4863123qkh.325.1646959410308;
        Thu, 10 Mar 2022 16:43:30 -0800 (PST)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id f7-20020a05622a104700b002d4b318692esm4342336qte.31.2022.03.10.16.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 16:43:29 -0800 (PST)
Date:   Thu, 10 Mar 2022 19:43:27 -0500
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Eric Wheeler <bcachefs@lists.ewheeler.net>
Cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs: Kernel panic - not syncing: trans path oveflow
Message-ID: <20220311004327.t2rtzd4eg7ktmdrp@moria.home.lan>
References: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net>
 <YilZD2oxhUtFVCfu@moria.home.lan>
 <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net>
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Thu, Mar 10, 2022 at 02:25:29PM -0800, Eric Wheeler wrote:
> On Wed, 9 Mar 2022, Kent Overstreet wrote:
> 
> > On Wed, Mar 09, 2022 at 01:14:58PM -0800, Eric Wheeler wrote:
> > > Hi Kent,
> > > 
> > > We just started testing bcachefs snapshots this week: we have a bunch of 
> > > mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
> > > run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
> > > and sync IO from the many database instances.
> > 
> > Cool! Would love to hear any comments you've got so far.
>  
> Happy to.  So far we've hit this bug...but once that is fixed I'm curious 
> how it will compare to btrfs, which has just become too slow...
> 
> > > We hit the following bcachefs panic while testing commit# 
> > > 5490c9c529770aa18b2571bd98f5416ed9ae24c6 from March 3rd. Can you tell what 
> > > the issue might be?
> > > 
> > > It is easily reproducable, the same problem hits shortly after we reboot 
> > > and remount so happy to test patches or git-pull's to rebuild with:
> > > 
> > > Here is the stack trace (more logs below):
> > 
> > So it looks like there's some code that iterates over btree keys and goes
> > further than it's supposed to - we have paths that point to different inode
> > numbers and that's not supposed to happen in the write path, we're only updating
> > a single inode.
> > 
> > I've had a report of a similar bug in the data move path, which may or may not
> > be the same as this bug - but I haven't worked up a repro for it yet so I
> > haven't figured out yet which code path is allocating these btree paths. Could
> > you enable CONFIG_BCACHEFS_DEBUG, then run your log through
> > scripts/decode_stacktrace.sh from the kernel source tree?
> 
> Here's the stack trace, full log below that.
> 
> [  179.179253] Kernel panic - not syncing: trans path oveflow
> [  179.179957] CPU: 0 PID: 5197 Comm: mysqld Not tainted 5.15.0+ #1
> [  179.180629] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  179.181296] Call Trace:
> [  179.181954] dump_stack_lvl (lib/dump_stack.c:107) 
> [  179.182938] panic (kernel/panic.c:240) 
> [  179.184231] ? bch2_dump_trans_paths_updates (fs/bcachefs/alloc_foreground.c:618) bcachefs
> [  179.185574] btree_path_alloc.cold.74 (fs/bcachefs/alloc_foreground.c:608) bcachefs
> [  179.186811] btree_path_clone (fs/bcachefs/btree_iter.c:1648 fs/bcachefs/btree_iter.c:1664) bcachefs
> [  179.187983] bch2_btree_path_set_pos (fs/bcachefs/btree_iter.c:1679 fs/bcachefs/btree_iter.c:1701) bcachefs
> [  179.189043] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
> [  179.190126] bch2_btree_iter_peek (fs/bcachefs/btree_iter.c:2387) bcachefs
> [  179.191178] bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
> [  179.192200] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
> [  179.193174] ? bch2_inode_unpack_v2 (fs/bcachefs/inode.c:199 (discriminator 287)) bcachefs
> [  179.194169] ? bch2_inode_peek (fs/bcachefs/inode.c:272) bcachefs
> [  179.195078] bch2_extent_update (fs/bcachefs/io.c:297) bcachefs
> [  179.195938] ? bch2_inode_peek (fs/bcachefs/inode.c:262) bcachefs
> [  179.196767] __bchfs_fallocate (fs/bcachefs/fs-io.c:3039) bcachefs
> [  179.197522] ? __bchfs_fallocate (fs/bcachefs/bkey.h:527 fs/bcachefs/fs-io.c:3006) bcachefs
> [  179.198249] ? mntput_no_expire (fs/namespace.c:1224) 
> [  179.198940] bch2_fallocate_dispatch (fs/bcachefs/fs-io.c:3096 fs/bcachefs/fs-io.c:3139) bcachefs
> [  179.199634] vfs_fallocate (fs/open.c:307) 
> [  179.200272] ksys_fallocate (./include/linux/file.h:45 fs/open.c:331) 
> [  179.200895] __x64_sys_fallocate (fs/open.c:338 fs/open.c:336 fs/open.c:336) 
> [  179.201519] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
> [  179.202074] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
> [  179.202630] RIP: 0033:0x7eff23af5fb9

Thanks, I think I know what's going on. It's the BTREE_ITER_FILTER_SNAPSHOTS
code, and in particular it's the code that saves a path for the update position
that's allocating all these iterators.

So, we need two changes:
 - delay setting the update_path as should_be_locked until we return from
   bch2_btree_iter_peek(), so that we don't end up saving a bunch of duplicate
   iterators
 - the bigger change: if the next inode is in a different subvolume, we could
   end up scanning past a bunch of different inodes until we find a key in the
   curent snapshot to return and terminate the lookup - so we need to add a
   "search up to this position" to bch2_btree_iter_peek().

I'll let you know when the fixes are up.
