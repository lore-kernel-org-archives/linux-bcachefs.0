Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A54EC433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu, 10 Mar 2022 22:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243730AbiCJW0j (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 10 Mar 2022 17:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiCJW0j (ORCPT
        <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 10 Mar 2022 17:26:39 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D33164D1E
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Mar 2022 14:25:36 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 0D0A448;
        Thu, 10 Mar 2022 14:25:36 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id rCF-leEUs0UL; Thu, 10 Mar 2022 14:25:31 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id 81DA140;
        Thu, 10 Mar 2022 14:25:31 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net 81DA140
Date:   Thu, 10 Mar 2022 14:25:29 -0800 (PST)
From:   Eric Wheeler <bcachefs@lists.ewheeler.net>
To:     Kent Overstreet <kent.overstreet@gmail.com>
cc:     linux-bcachefs@vger.kernel.org
Subject: Re: bcachefs: Kernel panic - not syncing: trans path oveflow
In-Reply-To: <YilZD2oxhUtFVCfu@moria.home.lan>
Message-ID: <bc622d24-9fad-7b3-22cb-da4bf2dd32d@ewheeler.net>
References: <6bc8aca6-2f93-4a81-376-13155fcc5d7@ewheeler.net> <YilZD2oxhUtFVCfu@moria.home.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

On Wed, 9 Mar 2022, Kent Overstreet wrote:

> On Wed, Mar 09, 2022 at 01:14:58PM -0800, Eric Wheeler wrote:
> > Hi Kent,
> > 
> > We just started testing bcachefs snapshots this week: we have a bunch of 
> > mysql replicas, each in its own subvolume.  Every 4 hours we stop mysql, 
> > run a subvolume snapshot and restart mysql, so it gets lots of snapshot 
> > and sync IO from the many database instances.
> 
> Cool! Would love to hear any comments you've got so far.
 
Happy to.  So far we've hit this bug...but once that is fixed I'm curious 
how it will compare to btrfs, which has just become too slow...

> > We hit the following bcachefs panic while testing commit# 
> > 5490c9c529770aa18b2571bd98f5416ed9ae24c6 from March 3rd. Can you tell what 
> > the issue might be?
> > 
> > It is easily reproducable, the same problem hits shortly after we reboot 
> > and remount so happy to test patches or git-pull's to rebuild with:
> > 
> > Here is the stack trace (more logs below):
> 
> So it looks like there's some code that iterates over btree keys and goes
> further than it's supposed to - we have paths that point to different inode
> numbers and that's not supposed to happen in the write path, we're only updating
> a single inode.
> 
> I've had a report of a similar bug in the data move path, which may or may not
> be the same as this bug - but I haven't worked up a repro for it yet so I
> haven't figured out yet which code path is allocating these btree paths. Could
> you enable CONFIG_BCACHEFS_DEBUG, then run your log through
> scripts/decode_stacktrace.sh from the kernel source tree?

Here's the stack trace, full log below that.

[  179.179253] Kernel panic - not syncing: trans path oveflow
[  179.179957] CPU: 0 PID: 5197 Comm: mysqld Not tainted 5.15.0+ #1
[  179.180629] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
[  179.181296] Call Trace:
[  179.181954] dump_stack_lvl (lib/dump_stack.c:107) 
[  179.182938] panic (kernel/panic.c:240) 
[  179.184231] ? bch2_dump_trans_paths_updates (fs/bcachefs/alloc_foreground.c:618) bcachefs
[  179.185574] btree_path_alloc.cold.74 (fs/bcachefs/alloc_foreground.c:608) bcachefs
[  179.186811] btree_path_clone (fs/bcachefs/btree_iter.c:1648 fs/bcachefs/btree_iter.c:1664) bcachefs
[  179.187983] bch2_btree_path_set_pos (fs/bcachefs/btree_iter.c:1679 fs/bcachefs/btree_iter.c:1701) bcachefs
[  179.189043] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
[  179.190126] bch2_btree_iter_peek (fs/bcachefs/btree_iter.c:2387) bcachefs
[  179.191178] bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
[  179.192200] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
[  179.193174] ? bch2_inode_unpack_v2 (fs/bcachefs/inode.c:199 (discriminator 287)) bcachefs
[  179.194169] ? bch2_inode_peek (fs/bcachefs/inode.c:272) bcachefs
[  179.195078] bch2_extent_update (fs/bcachefs/io.c:297) bcachefs
[  179.195938] ? bch2_inode_peek (fs/bcachefs/inode.c:262) bcachefs
[  179.196767] __bchfs_fallocate (fs/bcachefs/fs-io.c:3039) bcachefs
[  179.197522] ? __bchfs_fallocate (fs/bcachefs/bkey.h:527 fs/bcachefs/fs-io.c:3006) bcachefs
[  179.198249] ? mntput_no_expire (fs/namespace.c:1224) 
[  179.198940] bch2_fallocate_dispatch (fs/bcachefs/fs-io.c:3096 fs/bcachefs/fs-io.c:3139) bcachefs
[  179.199634] vfs_fallocate (fs/open.c:307) 
[  179.200272] ksys_fallocate (./include/linux/file.h:45 fs/open.c:331) 
[  179.200895] __x64_sys_fallocate (fs/open.c:338 fs/open.c:336 fs/open.c:336) 
[  179.201519] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
[  179.202074] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
[  179.202630] RIP: 0033:0x7eff23af5fb9

See below my signature for the full log sent through decode_stacktrace.sh

--
Eric Wheeler


]# cat /tmp/bt | ./scripts/decode_stacktrace.sh -r 5.15.0+ /boot/vmlinuz-5.15.0+
Mar 10 10:27:49 10.1.23.22 [  179.105959] path: idx 4 ref 0:0 S P btree=extents l=0 pos 5001:0:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106075] path: idx 0 ref 1:1 S btree=extents l=0 pos 5001:1:4294967288 locks 1 __bchfs_fallocate (fs/bcachefs/bkey.h:527 fs/bcachefs/fs-io.c:3006) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106159] path: idx 5 ref 0:0 S btree=extents l=0 pos 5043:24239:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106218] path: idx 7 ref 0:0 S btree=extents l=0 pos 5044:145824:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106279] path: idx 8 ref 0:0 S btree=extents l=0 pos 5044:254688:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106378] path: idx 9 ref 0:0 S btree=extents l=0 pos 5044:315872:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106445] path: idx 10 ref 0:0 S btree=extents l=0 pos 5044:365616:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106519] path: idx 11 ref 0:0 S btree=extents l=0 pos 5044:466856:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106592] path: idx 12 ref 0:0 S btree=extents l=0 pos 5044:531864:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106663] path: idx 13 ref 0:0 S btree=extents l=0 pos 5044:598768:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106732] path: idx 14 ref 0:0 S btree=extents l=0 pos 5044:675200:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.106800] path: idx 15 ref 0:0 S btree=extents l=0 pos 5045:228476:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.107457] path: idx 16 ref 0:0 S btree=extents l=0 pos 5045:342176:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.108670] path: idx 17 ref 0:0 S btree=extents l=0 pos 5045:412888:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.109859] path: idx 18 ref 0:0 S btree=extents l=0 pos 5045:475976:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.111044] path: idx 19 ref 0:0 S btree=extents l=0 pos 5045:525712:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.112293] path: idx 20 ref 0:0 S btree=extents l=0 pos 5045:590736:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.113556] path: idx 21 ref 0:0 S btree=extents l=0 pos 5045:661448:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.115021] path: idx 22 ref 0:0 S btree=extents l=0 pos 5045:711200:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.116362] path: idx 23 ref 0:0 S btree=extents l=0 pos 5045:760944:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.117674] path: idx 24 ref 0:0 S btree=extents l=0 pos 5045:811260:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.119032] path: idx 25 ref 0:0 S btree=extents l=0 pos 5045:864240:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.120403] path: idx 26 ref 0:0 S btree=extents l=0 pos 5045:913984:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.121827] path: idx 27 ref 0:0 S btree=extents l=0 pos 5045:963728:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.123219] path: idx 28 ref 0:0 S btree=extents l=0 pos 5045:1013480:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.124674] path: idx 29 ref 0:0 S btree=extents l=0 pos 5045:1063224:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.126125] path: idx 30 ref 0:0 S btree=extents l=0 pos 5045:1112960:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.127605] path: idx 31 ref 0:0 S btree=extents l=0 pos 5045:1162712:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.129080] path: idx 32 ref 0:0 S btree=extents l=0 pos 5045:1212456:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.130528] path: idx 33 ref 0:0 S btree=extents l=0 pos 5048:33532:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.131992] path: idx 34 ref 0:0 S btree=extents l=0 pos 5053:81564:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.133445] path: idx 35 ref 0:0 S btree=extents l=0 pos 5053:294912:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.134903] path: idx 36 ref 0:0 S btree=extents l=0 pos 5092:87592:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.136347] path: idx 37 ref 0:0 S btree=extents l=0 pos 5096:404775:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.137807] path: idx 38 ref 0:0 S btree=extents l=0 pos 5096:982183:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.139257] path: idx 39 ref 0:0 S btree=extents l=0 pos 5096:1559463:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.140723] path: idx 40 ref 0:0 S btree=extents l=0 pos 5096:2137127:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.142166] path: idx 41 ref 0:0 S btree=extents l=0 pos 5096:2714407:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.143616] path: idx 42 ref 0:0 S btree=extents l=0 pos 5096:3291815:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.145071] path: idx 43 ref 0:0 S btree=extents l=0 pos 5096:3869095:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.146518] path: idx 44 ref 0:0 S btree=extents l=0 pos 5096:4446503:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.147978] path: idx 45 ref 0:0 S btree=extents l=0 pos 5096:5023864:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.149418] path: idx 46 ref 0:0 S btree=extents l=0 pos 5096:5600551:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.150864] path: idx 47 ref 0:0 S btree=extents l=0 pos 5096:6178215:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.152294] path: idx 48 ref 0:0 S btree=extents l=0 pos 5096:6755751:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.153743] path: idx 49 ref 0:0 S btree=extents l=0 pos 5096:7334008:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.155160] path: idx 50 ref 0:0 S btree=extents l=0 pos 5096:7911400:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.156603] path: idx 51 ref 0:0 S btree=extents l=0 pos 5096:8488743:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.158020] path: idx 52 ref 0:0 S btree=extents l=0 pos 5096:9066151:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.159478] path: idx 53 ref 0:0 S btree=extents l=0 pos 5096:9643687:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.160902] path: idx 54 ref 0:0 S btree=extents l=0 pos 5096:10223271:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.162357] path: idx 55 ref 0:0 S btree=extents l=0 pos 5096:10800551:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.163797] path: idx 56 ref 0:0 S btree=extents l=0 pos 5096:11378983:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.165218] path: idx 57 ref 0:0 S btree=extents l=0 pos 5096:11956464:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.166675] path: idx 58 ref 0:0 S btree=extents l=0 pos 5096:12533760:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.168111] path: idx 59 ref 0:0 S btree=extents l=0 pos 5096:13111975:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.169659] path: idx 60 ref 0:0 S btree=extents l=0 pos 5096:13689127:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.171122] path: idx 61 ref 0:0 S btree=extents l=0 pos 5096:14266608:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.172576] path: idx 62 ref 0:0 S btree=extents l=0 pos 5096:14843904:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.174018] path: idx 63 ref 0:0 S btree=extents l=0 pos 5096:15421351:4294967288 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.175446] path: idx 6 ref 1:1 S btree=extents l=0 pos 5096:15421351:4294967291 locks 1 bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.176923] path: idx 2 ref 0:0 S btree=extents l=0 pos 5098:1:4294967288 locks 1 __bchfs_fallocate (fs/bcachefs/bkey.h:527 fs/bcachefs/fs-io.c:3006) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.177663] path: idx 3 ref 1:1 S P btree=inodes l=0 pos 0:5001:4294967288 locks 1 bch2_inode_peek (fs/bcachefs/inode.c:262) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.178471] path: idx 1 ref 0:0 S P btree=subvolumes l=0 pos 0:8:0 locks 1 bch2_subvolume_get (fs/bcachefs/subvolume.c:781) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.179253] Kernel panic - not syncing: trans path oveflow
Mar 10 10:27:49 10.1.23.22 [  179.179957] CPU: 0 PID: 5197 Comm: mysqld Not tainted 5.15.0+ #1
Mar 10 10:27:49 10.1.23.22 [  179.180629] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
Mar 10 10:27:49 10.1.23.22 [  179.181296] Call Trace:
Mar 10 10:27:49 10.1.23.22 [  179.181954] dump_stack_lvl (lib/dump_stack.c:107) 
Mar 10 10:27:49 10.1.23.22 [  179.182938] panic (kernel/panic.c:240) 
Mar 10 10:27:49 10.1.23.22 [  179.184231] ? bch2_dump_trans_paths_updates (fs/bcachefs/alloc_foreground.c:618) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.185574] btree_path_alloc.cold.74 (fs/bcachefs/alloc_foreground.c:608) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.186811] btree_path_clone (fs/bcachefs/btree_iter.c:1648 fs/bcachefs/btree_iter.c:1664) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.187983] bch2_btree_path_set_pos (fs/bcachefs/btree_iter.c:1679 fs/bcachefs/btree_iter.c:1701) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.189043] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.190126] bch2_btree_iter_peek (fs/bcachefs/btree_iter.c:2387) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.191178] bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.192200] ? bch2_trans_update_extent (fs/bcachefs/btree_update_leaf.c:1220) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.193174] ? bch2_inode_unpack_v2 (fs/bcachefs/inode.c:199 (discriminator 287)) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.194169] ? bch2_inode_peek (fs/bcachefs/inode.c:272) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.195078] bch2_extent_update (fs/bcachefs/io.c:297) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.195938] ? bch2_inode_peek (fs/bcachefs/inode.c:262) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.196767] __bchfs_fallocate (fs/bcachefs/fs-io.c:3039) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.197522] ? __bchfs_fallocate (fs/bcachefs/bkey.h:527 fs/bcachefs/fs-io.c:3006) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.198249] ? mntput_no_expire (fs/namespace.c:1224) 
Mar 10 10:27:49 10.1.23.22 [  179.198940] bch2_fallocate_dispatch (fs/bcachefs/fs-io.c:3096 fs/bcachefs/fs-io.c:3139) bcachefs
Mar 10 10:27:49 10.1.23.22 [  179.199634] vfs_fallocate (fs/open.c:307) 
Mar 10 10:27:49 10.1.23.22 [  179.200272] ksys_fallocate (./include/linux/file.h:45 fs/open.c:331) 
Mar 10 10:27:49 10.1.23.22 [  179.200895] __x64_sys_fallocate (fs/open.c:338 fs/open.c:336 fs/open.c:336) 
Mar 10 10:27:49 10.1.23.22 [  179.201519] do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80) 
Mar 10 10:27:49 10.1.23.22 [  179.202074] entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:113) 
Mar 10 10:27:49 10.1.23.22 [  179.202630] RIP: 0033:0x7eff23af5fb9
Mar 10 10:27:49 10.1.23.22 [ 179.203159] Code: 90 eb 9f 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 53 49 89 f1 48 89 d3 49 89 d2 41 89 f8 48 89 f2 b8 1d 01 00 00 31 f6 0f 05 <3d> 00 f0 ff ff 76 10 83 f8 a1 74 13 f7 d8 5b c3 0f 1f 80 00 00 00
All code
========
   0:    90                       nop
   1:    eb 9f                    jmp    0xffffffffffffffa2
   3:    0f 1f 40 00              nopl   0x0(%rax)
   7:    66 2e 0f 1f 84 00 00     nopw   %cs:0x0(%rax,%rax,1)
   e:    00 00 00 
  11:    53                       push   %rbx
  12:    49 89 f1                 mov    %rsi,%r9
  15:    48 89 d3                 mov    %rdx,%rbx
  18:    49 89 d2                 mov    %rdx,%r10
  1b:    41 89 f8                 mov    %edi,%r8d
  1e:    48 89 f2                 mov    %rsi,%rdx
  21:    b8 1d 01 00 00           mov    $0x11d,%eax
  26:    31 f6                    xor    %esi,%esi
  28:    0f 05                    syscall 
  2a:*    3d 00 f0 ff ff           cmp    $0xfffff000,%eax        <-- trapping instruction
  2f:    76 10                    jbe    0x41
  31:    83 f8 a1                 cmp    $0xffffffa1,%eax
  34:    74 13                    je     0x49
  36:    f7 d8                    neg    %eax
  38:    5b                       pop    %rbx
  39:    c3                       retq   
  3a:    0f                       .byte 0xf
  3b:    1f                       (bad)  
  3c:    80 00 00                 addb   $0x0,(%rax)
    ...

Code starting with the faulting instruction
===========================================
   0:    3d 00 f0 ff ff           cmp    $0xfffff000,%eax
   5:    76 10                    jbe    0x17
   7:    83 f8 a1                 cmp    $0xffffffa1,%eax
   a:    74 13                    je     0x1f
   c:    f7 d8                    neg    %eax
   e:    5b                       pop    %rbx
   f:    c3                       retq   
  10:    0f                       .byte 0xf
  11:    1f                       (bad)  
  12:    80 00 00                 addb   $0x0,(%rax)
    ...
Mar 10 10:27:49 10.1.23.22 [  179.204197] RSP: 002b:00007ffe56e7fd60 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
Mar 10 10:27:49 10.1.23.22 [  179.204990] RAX: ffffffffffffffda RBX: 0000000000c00000 RCX: 00007eff23af5fb9
Mar 10 10:27:49 10.1.23.22 [  179.205769] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000000000000c
Mar 10 10:27:49 10.1.23.22 [  179.206525] RBP: 00007ffe56e7fff0 R08: 000000000000000c R09: 0000000000000000
Mar 10 10:27:49 10.1.23.22 [  179.207247] R10: 0000000000c00000 R11: 0000000000000246 R12: 0000000000c00000
Mar 10 10:27:49 10.1.23.22 [  179.207955] R13: 0000561fcfbf0000 R14: 00007ffe56e7fdd0 R15: 0000561fd18a5280
Mar 10 10:27:49 10.1.23.22 [  179.208952] Kernel Offset: 0x3b000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
Mar 10 10:27:49 10.1.23.22 [  179.209656] ---[ end Kernel panic - not syncing: trans path oveflow ]---

