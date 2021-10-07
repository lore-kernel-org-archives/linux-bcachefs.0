Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E26C433EF
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Oct 2021 12:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D291A61037
	for <linux-bcachefs@archiver.kernel.org>; Thu,  7 Oct 2021 12:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbhJGMSu (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Thu, 7 Oct 2021 08:18:50 -0400
Received: from cdw.me.uk ([91.203.57.136]:49199 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232984AbhJGMSu (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Thu, 7 Oct 2021 08:18:50 -0400
X-Greylist: delayed 1465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2021 08:18:49 EDT
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mYRws-0006ax-Nb
        for linux-bcachefs@vger.kernel.org; Thu, 07 Oct 2021 12:52:30 +0100
Date:   Thu, 7 Oct 2021 12:52:30 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Subject: BUG_ON in fs/bcachefs/btree_iter.c
Message-ID: <20211007115230.GA24322@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

I've been testing bcachefs using the head revs (4114ced1 and 3f7b0b08) of

  https://evilpiepirate.org/git/bcachefs.git
  https://evilpiepirate.org/git/bcachefs-tools.git

I originally found the below on my (relatively weird) musl + clang distro,
but have reproduced using a completely vanilla Debian bullseye amd64 image,
building the kernel with gcc10 and linking the bcachefs tool with glibc. For
testing purposes, my config is close to x86-64 defconfig but with drivers
for my hardware and CONFIG_BCACHEFS_{FS,QUOTA,POSIX_ACL,DEBUG,TESTS}=y.

A single device filesystem seems to work well. I played with stressing
snapshots and reflinks for a while, without any issues.

However, when I test a simple replicated config on two small zram disks,
formatting and mounting with

  # zramctl -f -s 1G
  /dev/zram1
  # zramctl -f -s 1G
  /dev/zram2
  # ./bcachefs format --replicas=2 /dev/zram1 /dev/zram2
  External UUID:      30b11583-209e-494d-97eb-5d3d66e681fd
  [...]
  initializing new filesystem
  going read-write
  mounted with opts: metadata_replicas=2,data_replicas=2
  # mount -t bcachefs /dev/zram1:/dev/zram2 /mnt
  # cp -a /root/bcachefs-tools /mnt # some random data

I can get instantly get a reliable BUG_ON at fs/bcachefs/btree_iter.c:2475
by running a data rereplicate, which should presumably be a no-op?

  # ./bcachefs data rereplicate /mnt
  0% complete: current position btree inodes:18446744073709551615:1844674407370955
  [... never makes progress ...]
  0% complete: current position btree inodes:18446744073709551615:1844674407370955

Example dmesg:

  [  238.033446] ------------[ cut here ]------------
  [  238.033452] kernel BUG at fs/bcachefs/btree_iter.c:2475!
  [  238.033463] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  [  238.033474] CPU: 10 PID: 1472 Comm: bch-data/30b115 Tainted: G        W         5.13.0+ #1
  [  238.033482] Hardware name: To Be Filled By O.E.M. 4X4 BOX/4X4-4000 Series, BIOS P1.30 11/27/2020
  [  238.033488] RIP: 0010:__bch2_trans_iter_init+0x12a/0x130
  [  238.033500] Code: ff ff ff 81 ce 00 20 00 00 e9 51 ff ff ff b8 01 00 00 00 89 d1 d3 e0 a8 0f 0f 84 40 ff ff ff 81 ce 00 20 00 00 e9 35 ff ff ff <0f> 0b 0f 1f 40 00 55 48 89 e5 41 56 41 55 41 54 53 48 83 ec 30 65
  [  238.033509] RSP: 0018:ffffb904067b3b60 EFLAGS: 00010202
  [  238.033516] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  [  238.033521] RDX: 0000000000000001 RSI: ffffb904067b3c20 RDI: ffffb904067b3c88
  [  238.033525] RBP: ffffb904067b3b98 R08: 0000000000000000 R09: 0000000000001824
  [  238.033530] R10: 0000000000000002 R11: 0000000000000001 R12: ffffb904067b3c20
  [  238.033534] R13: 0000000000000000 R14: ffff966ad13a0000 R15: ffff966ad13a0000
  [  238.033538] FS:  0000000000000000(0000) GS:ffff9671af880000(0000) knlGS:0000000000000000
  [  238.033544] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  238.033549] CR2: 00007fffe2bf9080 CR3: 000000064b80a000 CR4: 0000000000350ee0
  [  238.033554] Call Trace:
  [  238.033557]  ? bch2_trans_node_iter_init+0x39/0x90
  [  238.033566]  bch2_move_btree+0x1bf/0x460
  [  238.033573]  ? bch2_move_btree+0x460/0x460
  [  238.033579]  ? bch2_sb_validate_replicas_v0+0x98/0x150
  [  238.033588]  ? bch2_move_btree+0xd8/0x460
  [  238.033595]  bch2_data_job+0x27f/0x3f0
  [  238.033602]  ? psi_task_switch+0xcd/0x240
  [  238.033611]  bch2_data_thread+0x3e/0x60
  [  238.033618]  ? bch2_data_job_read+0xf0/0xf0
  [  238.033623]  kthread+0x140/0x160
  [  238.033632]  ? __kthread_bind_mask+0x70/0x70
  [  238.033639]  ret_from_fork+0x22/0x30
  [  238.033647] Modules linked in:
  [  238.033653] ---[ end trace 4fd2bbd95dcfe63a ]---
  [  238.033657] RIP: 0010:__bch2_trans_iter_init+0x12a/0x130
  [  238.033664] Code: ff ff ff 81 ce 00 20 00 00 e9 51 ff ff ff b8 01 00 00 00 89 d1 d3 e0 a8 0f 0f 84 40 ff ff ff 81 ce 00 20 00 00 e9 35 ff ff ff <0f> 0b 0f 1f 40 00 55 48 89 e5 41 56 41 55 41 54 53 48 83 ec 30 65
  [  238.033674] RSP: 0018:ffffb904067b3b60 EFLAGS: 00010202
  [  238.033679] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
  [  238.033684] RDX: 0000000000000001 RSI: ffffb904067b3c20 RDI: ffffb904067b3c88
  [  238.033689] RBP: ffffb904067b3b98 R08: 0000000000000000 R09: 0000000000001824
  [  238.033693] R10: 0000000000000002 R11: 0000000000000001 R12: ffffb904067b3c20
  [  238.033698] R13: 0000000000000000 R14: ffff966ad13a0000 R15: ffff966ad13a0000
  [  238.033703] FS:  0000000000000000(0000) GS:ffff9671af880000(0000) knlGS:0000000000000000
  [  238.033709] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  238.033714] CR2: 00007fffe2bf9080 CR3: 000000064b80a000 CR4: 0000000000350ee0

If instead I don't copy any data onto the freshly mounted filesystem before
running the rereplicate, the bcachefs data replicate command still makes no
progress, but I instead get a BUG_ON at fs/bcachefs/btree_iter.c:367, i.e.
path->nodes_locked is false in bch2_btree_path_verify_locks:

  [  273.286865] ------------[ cut here ]------------
  [  273.286870] kernel BUG at fs/bcachefs/btree_iter.c:367!
  [  273.286881] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  [  273.286892] CPU: 15 PID: 1440 Comm: bch-data/70ff9d Tainted: G        W         5.13.0+ #1
  [  273.286899] Hardware name: To Be Filled By O.E.M. 4X4 BOX/4X4-4000 Series, BIOS P1.30 11/27/2020
  [  273.286905] RIP: 0010:bch2_btree_path_verify_locks+0x80/0x90
  [  273.286918] Code: 89 ce 89 d0 d3 fe d3 f8 83 e6 01 83 e0 01 8d 44 06 ff 44 39 d0 75 15 83 c1 01 49 83 c0 18 83 f9 04 75 a4 c3 f6 47 18 c0 75 f9 <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 0b 66 66 2e 0f
  [  273.286927] RSP: 0018:ffffba76431bf970 EFLAGS: 00010246
  [  273.286934] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
  [  273.286939] RDX: 0000000000000000 RSI: ffff9fc6520f0000 RDI: ffff9fc6520f0000
  [  273.286943] RBP: ffffba76431bf9a0 R08: ffff9fc6520f0000 R09: 0000000000000000
  [  273.286947] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9fc6520f0038
  [  273.286951] R13: ffff9fc651400000 R14: ffff9fc6520f0000 R15: ffffba76431bfc88
  [  273.286956] FS:  0000000000000000(0000) GS:ffff9fcd2f9c0000(0000) knlGS:0000000000000000
  [  273.286962] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  273.286966] CR2: 00007ffcd45c4080 CR3: 00000005f620a000 CR4: 0000000000350ee0
  [  273.286971] Call Trace:
  [  273.286975]  ? bch2_btree_path_verify+0x7f/0xb0
  [  273.286983]  btree_path_traverse_one+0x54a/0xcb0
  [  273.286990]  ? bch2_btree_path_relock.constprop.0+0x384/0x4f0
  [  273.286997]  ? __btree_path_traverse_all+0x1df/0x3b0
  [  273.287004]  ? btree_path_traverse_one+0x54a/0xcb0
  [  273.287011]  ? btree_path_traverse_one+0x54a/0xcb0
  [  273.287017]  ? bch2_btree_iter_next_node+0x144/0x430
  [  273.287024]  __btree_path_traverse_all+0x1f3/0x3b0
  [  273.287031]  ? bch2_btree_iter_next_node+0x144/0x430
  [  273.287038]  bch2_btree_path_traverse.part.0+0x82/0x90
  [  273.287045]  bch2_btree_iter_next_node+0x144/0x430
  [  273.287053]  bch2_move_btree+0x2fb/0x460
  [  273.287060]  ? bch2_move_btree+0x460/0x460
  [  273.287067]  ? bch2_sb_validate_replicas_v0+0x98/0x150
  [  273.287076]  ? bch2_move_btree+0xd8/0x460
  [  273.287083]  bch2_data_job+0x27f/0x3f0
  [  273.287089]  ? psi_task_switch+0xcd/0x240
  [  273.287099]  bch2_data_thread+0x3e/0x60
  [  273.287106]  ? bch2_data_job_read+0xf0/0xf0
  [  273.287111]  kthread+0x140/0x160
  [  273.287119]  ? __kthread_bind_mask+0x70/0x70
  [  273.287126]  ret_from_fork+0x22/0x30
  [  273.287135] Modules linked in:
  [  273.287140] ---[ end trace 2f990d5069fd2aa5 ]---
  [  273.287145] RIP: 0010:bch2_btree_path_verify_locks+0x80/0x90
  [  273.287152] Code: 89 ce 89 d0 d3 fe d3 f8 83 e6 01 83 e0 01 8d 44 06 ff 44 39 d0 75 15 83 c1 01 49 83 c0 18 83 f9 04 75 a4 c3 f6 47 18 c0 75 f9 <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 0b 66 66 2e 0f
  [  273.287162] RSP: 0018:ffffba76431bf970 EFLAGS: 00010246
  [  273.287167] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
  [  273.287172] RDX: 0000000000000000 RSI: ffff9fc6520f0000 RDI: ffff9fc6520f0000
  [  273.287176] RBP: ffffba76431bf9a0 R08: ffff9fc6520f0000 R09: 0000000000000000
  [  273.287181] R10: 0000000000000000 R11: 0000000000000001 R12: ffff9fc6520f0038
  [  273.287185] R13: ffff9fc651400000 R14: ffff9fc6520f0000 R15: ffffba76431bfc88
  [  273.287190] FS:  0000000000000000(0000) GS:ffff9fcd2f9c0000(0000) knlGS:0000000000000000
  [  273.287197] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  273.287201] CR2: 00007ffcd45c4080 CR3: 00000005f620a000 CR4: 0000000000350ee0

This isn't some /dev/zram* strangeness: I get the same result with two
loopback devices backed by nvme, or other scratch block devices.

Another way to trigger the same BUG_ON is making an empty non-replicated
multi-device fs, then attempting to evacuate one of the devices:

  # ./bcachefs format --replicas=1 /dev/zram1 /dev/zram2
  [...]
  # mount -t bcachefs /dev/zram1:/dev/zram2 /mnt
  # ./bcachefs device evacuate /dev/zram2
  Setting /dev/zram2 readonly
  0% complete: current position btree extents:18446744073709551615:18446744073709551615
  [... hangs without making progress ...]

  [Oct 7 12:34] bcachefs (e67467f1-8b07-46c6-b009-a4a9c9220135): recovering from clean shutdown, journal seq 4
  [  +0.000951] bcachefs (e67467f1-8b07-46c6-b009-a4a9c9220135): going read-write
  [  +0.000720] bcachefs (e67467f1-8b07-46c6-b009-a4a9c9220135): mounted with opts: (null)
  [ +23.348040] bcachefs (zram2): ro
  [  +0.009096] ------------[ cut here ]------------
  [  +0.000005] kernel BUG at fs/bcachefs/btree_iter.c:367!
  [  +0.000011] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  [  +0.000011] CPU: 8 PID: 1450 Comm: bch-data/e67467 Tainted: G        W         5.13.0+ #1
  [  +0.000008] Hardware name: To Be Filled By O.E.M. 4X4 BOX/4X4-4000 Series, BIOS P1.30 11/27/2020
  [  +0.000005] RIP: 0010:bch2_btree_path_verify_locks+0x80/0x90
  [  +0.000012] Code: 89 ce 89 d0 d3 fe d3 f8 83 e6 01 83 e0 01 8d 44 06 ff 44 39 d0 75 15 83 c1 01 49 83 c0 18 83 f9 04 75 a4 c3 f6 47 18 c0 75 f9 <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 0b 66 66 2e 0f
  [  +0.000009] RSP: 0018:ffffb18983edb970 EFLAGS: 00010246
  [  +0.000007] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
  [  +0.000005] RDX: 0000000000000000 RSI: ffff930853424000 RDI: ffff930853424000
  [  +0.000004] RBP: ffffb18983edb9a0 R08: ffff930853424000 R09: 0000000000000000
  [  +0.000005] R10: 0000000000000000 R11: 0000000000000001 R12: ffff930853424038
  [  +0.000004] R13: ffff930852320000 R14: ffff930853424000 R15: ffffb18983edbc88
  [  +0.000004] FS:  0000000000000000(0000) GS:ffff930f2f600000(0000) knlGS:0000000000000000
  [  +0.000006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  +0.000005] CR2: 00007f34ad2f4f0f CR3: 0000000027e0a000 CR4: 0000000000350ee0
  [  +0.000005] Call Trace:
  [  +0.000003]  ? bch2_btree_path_verify+0x7f/0xb0
  [  +0.000008]  btree_path_traverse_one+0x54a/0xcb0
  [  +0.000008]  ? bch2_btree_path_relock.constprop.0+0x384/0x4f0
  [  +0.000006]  ? __btree_path_traverse_all+0x1df/0x3b0
  [  +0.000008]  ? btree_path_traverse_one+0x54a/0xcb0
  [  +0.000006]  ? btree_path_traverse_one+0x54a/0xcb0
  [  +0.000006]  ? bch2_btree_iter_next_node+0x144/0x430
  [  +0.000008]  __btree_path_traverse_all+0x1f3/0x3b0
  [  +0.000006]  ? bch2_btree_iter_next_node+0x144/0x430
  [  +0.000007]  ? bch2_path_get+0x1fa/0x2d0
  [  +0.000007]  bch2_btree_path_traverse.part.0+0x82/0x90
  [  +0.000007]  bch2_btree_iter_next_node+0x144/0x430
  [  +0.000006]  ? bch2_btree_iter_verify+0x53/0x80
  [  +0.000006]  ? bch2_btree_iter_peek_node+0x122/0x170
  [  +0.000007]  bch2_move_btree+0x2fb/0x460
  [  +0.000009]  ? migrate_pred+0x50/0x50
  [  +0.000007]  ? bch2_sb_validate_replicas_v0+0x98/0x150
  [  +0.000008]  ? bch2_move_btree+0xd8/0x460
  [  +0.000007]  bch2_data_job+0x12c/0x3f0
  [  +0.000006]  ? psi_task_switch+0xcd/0x240
  [  +0.000010]  bch2_data_thread+0x3e/0x60
  [  +0.000007]  ? bch2_data_job_read+0xf0/0xf0
  [  +0.000006]  kthread+0x140/0x160
  [  +0.000007]  ? __kthread_bind_mask+0x70/0x70
  [  +0.000007]  ret_from_fork+0x22/0x30
  [  +0.000009] Modules linked in:
  [  +0.000005] ---[ end trace 7942a81d570e67a9 ]---
  [  +0.000005] RIP: 0010:bch2_btree_path_verify_locks+0x80/0x90
  [  +0.000007] Code: 89 ce 89 d0 d3 fe d3 f8 83 e6 01 83 e0 01 8d 44 06 ff 44 39 d0 75 15 83 c1 01 49 83 c0 18 83 f9 04 75 a4 c3 f6 47 18 c0 75 f9 <0f> 0b 0f 0b 66 66 2e 0f 1f 84 00 00 00 00 00 90 0f 0b 66 66 2e 0f
  [  +0.000010] RSP: 0018:ffffb18983edb970 EFLAGS: 00010246
  [  +0.000005] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
  [  +0.000005] RDX: 0000000000000000 RSI: ffff930853424000 RDI: ffff930853424000
  [  +0.000004] RBP: ffffb18983edb9a0 R08: ffff930853424000 R09: 0000000000000000
  [  +0.000005] R10: 0000000000000000 R11: 0000000000000001 R12: ffff930853424038
  [  +0.000005] R13: ffff930852320000 R14: ffff930853424000 R15: ffffb18983edbc88
  [  +0.000005] FS:  0000000000000000(0000) GS:ffff930f2f600000(0000) knlGS:0000000000000000
  [  +0.000006] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  +0.000004] CR2: 00007f34ad2f4f0f CR3: 0000000027e0a000 CR4: 0000000000350ee0

Is this an unexpected breakage in the recent work to support snapshots? I
confess this is the first time I've tested bcachefs, so I'm not sure if
multiple device support is finished or still work in progress? Hope this
report is useful in any case.

Best wishes,
Chris.
