Return-Path: <linux-bcachefs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80DCC433F5
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Oct 2021 18:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 793BD60F4B
	for <linux-bcachefs@archiver.kernel.org>; Sun, 10 Oct 2021 18:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhJJS5w (ORCPT
        <rfc822;linux-bcachefs@archiver.kernel.org>);
        Sun, 10 Oct 2021 14:57:52 -0400
Received: from cdw.me.uk ([91.203.57.136]:33357 "EHLO cdw.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232586AbhJJS5v (ORCPT <rfc822;linux-bcachefs@vger.kernel.org>);
        Sun, 10 Oct 2021 14:57:51 -0400
Received: from chris by delta.arachsys.com with local (Exim 4.80)
        (envelope-from <chris@arachsys.com>)
        id 1mZdzC-0006g1-3h; Sun, 10 Oct 2021 19:55:50 +0100
Date:   Sun, 10 Oct 2021 19:55:50 +0100
From:   Chris Webb <chris@arachsys.com>
To:     linux-bcachefs@vger.kernel.org
Cc:     Kent Overstreet <kent.overstreet@gmail.com>
Subject: Other (perhaps related) subvolume strangeness
Message-ID: <20211010185549.GA24560@arachsys.com>
References: <20211010134413.GA31142@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010134413.GA31142@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Precedence: bulk
List-ID: <linux-bcachefs.vger.kernel.org>
X-Mailing-List: linux-bcachefs@vger.kernel.org

A couple of (perhaps related) issues I noticed...

bcachefs subvolume delete only works on snapshot subvolumes:

  # bcachefs subvolume create /mnt/s
  # bcachefs subvolume snapshot /mnt/s /mnt/t
  # bcachefs subvolume delete /mnt/s
  BCH_IOCTL_SUBVOLUME_DESTROY ioctl error: No such file or directory
  # bcachefs subvolume delete /mnt/t
  #

Following through, bch2_ioctl_subvolume_destroy() calls __bch2_unlink() and
thus bch2_subvolume_delete() with deleting_snapshot == 1, so

  0 <= deleting_snapshot != BCH_SUBVOLUME_SNAP(subvol.v)

and it therefore returns -ENOENT. (Just calling __bch2_unlink() with -1
instead of 1 isn't a sufficient fix on its own, though, as this will fail to
delete non-empty snapshot subvolumes.) 


After deleting a snapshot, creating a new one also uncovers a bug:

  # bcachefs subvolume snapshot /mnt/s
  # bcachefs subvolume delete /mnt/s
  # ls /mnt
  lost+found
  # bcachefs subvolume snapshot /mnt/s
  BCH_IOCTL_SUBVOLUME_CREATE ioctl error: File exists

If instead I try to create a new snapshot with a different name:

  # bcachefs subvolume snapshot /mnt/
  [hangs]
  ^C
  # dmesg -t
  bcachefs (zram1): recovering from clean shutdown, journal seq 4
  bcachefs (zram1): going read-write
  bcachefs (zram1): mounted with opts: (null)
  ------------[ cut here ]------------
  kernel BUG at fs/bcachefs/btree_key_cache.c:548!
  invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 6 PID: 1397 Comm: bcachefs Tainted: G        W         5.13.0+ #5
  Hardware name: To Be Filled By O.E.M. 4X4 BOX/4X4-4000 Series, BIOS P1.30 11/27/2020
  RIP: 0010:bch2_btree_key_cache_verify_clean+0x33/0x40
  Code: 8b 45 10 48 89 04 24 48 8b 45 18 48 89 44 24 08 8b 45 20 89 44 24 10 48 8b 3f e8 08 e6 ff ff 48 83 c4 18 48 85 c0 75 02 c9 c3 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 49 89 ff
  RSP: 0018:ffffa5680307ba28 EFLAGS: 00010286
  RAX: ffff9b84459d92c0 RBX: ffffa5680307bc38 RCX: ffffffffffffff80
  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff9b844108d580
  RBP: ffffa5680307ba28 R08: ffff9b8445946049 R09: 0000000000000000
  R10: 0000000000000002 R11: 0000000000000000 R12: ffff9b844ef20000
  R13: ffffffff8ea60340 R14: ffff9b844fb24a40 R15: ffff9b844ef20000
  FS:  00007f0776dd4380(0000) GS:ffff9b8b2f780000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055efddee1a60 CR3: 000000010d38a000 CR4: 0000000000350ee0
  Call Trace:
   __bch2_trans_commit+0xea/0x710
   __bch2_create+0x30e/0x640
   ? generic_permission+0x25/0x200
   ? __bch2_create+0x148/0x640
   bch2_fs_file_ioctl+0x718/0x8a0
   ? bch2_fs_file_ioctl+0x718/0x8a0
   __x64_sys_ioctl+0x3e3/0x930
   ? __x64_sys_ioctl+0x3e3/0x930
   ? do_sys_openat2+0x82/0x150
   do_syscall_64+0x40/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f0776fb46fd
  Code: 03 44 24 10 83 c1 08 89 0c 24 eb 0e 48 8b 44 24 08 48 8d 48 08 48 89 4c 24 08 48 8b 10 48 63 ff 48 63 f6 b8 10 00 00 00 0f 05 <9b> 48 63 f8 e8 ba 73 fe ff 48 81 c4 d8 00 00 00 c3 0f be 05 b5 1b
  RSP: 002b:00007fff375a84f0 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
  RAX: ffffffffffffffda RBX: 00007fff375a9e16 RCX: 00007f0776fb46fd
  RDX: 00007fff375a85f0 RSI: 000000004020bc10 RDI: 0000000000000003
  RBP: 0000000000000000 R08: 00007f0776f89500 R09: 0000000000000000
  R10: 00007fff375a8510 R11: 0000000000000206 R12: 000055efddfdbc50
  R13: 0000000000000001 R14: 0000000000000000 R15: 000055efdde79012
  Modules linked in:
  ---[ end trace 2ef23b87f042ceae ]---
  RIP: 0010:bch2_btree_key_cache_verify_clean+0x33/0x40
  Code: 8b 45 10 48 89 04 24 48 8b 45 18 48 89 44 24 08 8b 45 20 89 44 24 10 48 8b 3f e8 08 e6 ff ff 48 83 c4 18 48 85 c0 75 02 c9 c3 <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 49 89 ff
  RSP: 0018:ffffa5680307ba28 EFLAGS: 00010286
  RAX: ffff9b84459d92c0 RBX: ffffa5680307bc38 RCX: ffffffffffffff80
  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff9b844108d580
  RBP: ffffa5680307ba28 R08: ffff9b8445946049 R09: 0000000000000000
  R10: 0000000000000002 R11: 0000000000000000 R12: ffff9b844ef20000
  R13: ffffffff8ea60340 R14: ffff9b844fb24a40 R15: ffff9b844ef20000
  FS:  00007f0776dd4380(0000) GS:ffff9b8b2f780000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000055efddee1a60 CR3: 000000010d38a000 CR4: 0000000000350ee0

Best wishes,

Chris.
