Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B802A17996
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 00:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753145313; cv=none; b=tnnP9NVydM/ibCfQiJK3utmHcBiUUovLWfTEuQuMXT0LP2xc/RV+ssT/5CY7R1MaChM6jmep7HsE0H6APtuLqI3jHiyXby2cD+3328TUgD9BQ55Qj9MTYtYc1pkp8AXIwoFKlEs8muPxZLJmCQ3xloQJvrpuKzd1pPb9L9IzC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753145313; c=relaxed/simple;
	bh=Xy0PDqev0d68CuYCFm+zN4FjMB/RbfjqXQ/KokFjoFM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=P7wehjJJxrxdjCDd/A8XglvyFKqVdqAzWeXnOmfYNgAYjxhTanxO7k8HX4yJJHFxL28n0WF73eBc+ZFFFDuWrz7sF/cCAgVrVUtFlsgNCPqhDKZmFOtnundI4W9Lgv3tqUKdPXLOm34h2L+6Z2qC9Xxkir50nxTvlb0iQJxNyL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-87c1c2a4f9dso630343339f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 21 Jul 2025 17:48:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753145311; x=1753750111;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ov3cBdx0uXH/MSU9o+zl21AAqKnIA/RqYihem1aVyJw=;
        b=hZYwvzDjgM/hoYBbUCzt/VVBAzr4eHIwTchDGW1ej2p6EO/DrNzv4WZ7WzYxsiJzYO
         l0NjW3RBoomD/jiDYYLI86snU22FjUZ9jHmJru441z3BEqfkjruEqvFAhJjDRZxwCvwv
         5TGcDxnhdxuaTj0Qq2nU6jHVSPApgkp9xMrjpxTbkwG2BTvEFaFIhXshs3qZaUeDdDSq
         IhysulP5Zk3egg2Yg1ciI5/MUROl38uFVtykpDfcQxNfh2OZCXenUg0RmrKCs0gZl8mz
         XzQT2Y44uy8R3LOSgOgUf1lZVT52fuY1shCk5t73mU5x/qNJU+1w4UvM79wc7n9C4KOs
         FNLg==
X-Forwarded-Encrypted: i=1; AJvYcCV86YimlF9kkgql9+4Z6JTBLofsd9My+weMr0WZR2LQgXTmbTgr1SHQQmu4CrxyQf8Ru6CbKfnbLKd11ax/dw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Kbf8rc4no6aqXE/O6yds1LpJkp6Vu07TfqOkaHwrtfVDzNub
	Uxe8pfRmp79rqFn/r9UOQjdLj1sdkOGIO03ivtGiWibFSayu/vfw28t8gX8fR6+hSnjFYfwW6C9
	B0AJGeiMWaRTHwvODlIklCa+1SpAe6s3JqYRkeL6IrBnco6+5c1pP7gqoD2w=
X-Google-Smtp-Source: AGHT+IEPSXfP/VfUbCdWq2taTKh7DbG/SM7TZxb+E9ZonANhj/7trQOrzjJcnoykjYTzZEwqDmGGmX9kvGT/zi8CSlNFO+4pxZFV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6a8b:b0:87c:155f:d0c with SMTP id
 ca18e2360f4ac-87c155f23d7mr1952432939f.0.1753145310897; Mon, 21 Jul 2025
 17:48:30 -0700 (PDT)
Date: Mon, 21 Jul 2025 17:48:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687edfde.a70a0220.61950.0089.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_do_discards
From: syzbot <syzbot+8e47e16c9fe5b95a3a88@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    89be9a83ccf1 Linux 6.16-rc7
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11931f22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ea24e637865d5be
dashboard link: https://syzkaller.appspot.com/bug?extid=8e47e16c9fe5b95a3a88
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15931f22580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/73db8bd9dfbe/disk-89be9a83.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/265feaaa0bee/vmlinux-89be9a83.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a605d08a17df/bzImage-89be9a83.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a06aa633e5b0/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8e47e16c9fe5b95a3a88@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: slab-use-after-free in atomic_long_inc_return include/linux/atomic/atomic-instrumented.h:3609 [inline]
BUG: KASAN: slab-use-after-free in bch2_dev_get fs/bcachefs/sb-members.h:114 [inline]
BUG: KASAN: slab-use-after-free in bch2_get_next_dev fs/bcachefs/sb-members.h:145 [inline]
BUG: KASAN: slab-use-after-free in bch2_do_discards+0x319/0x570 fs/bcachefs/alloc_background.c:1984
Write of size 8 at addr ffff8880322ee040 by task kworker/u9:1/5163

CPU: 1 UID: 0 PID: 5163 Comm: kworker/u9:1 Not tainted 6.16.0-rc7-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Workqueue: bcachefs_journal journal_write_done
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x610 mm/kasan/report.c:480
 kasan_report+0xe0/0x110 mm/kasan/report.c:593
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_long_inc_return include/linux/atomic/atomic-instrumented.h:3609 [inline]
 bch2_dev_get fs/bcachefs/sb-members.h:114 [inline]
 bch2_get_next_dev fs/bcachefs/sb-members.h:145 [inline]
 bch2_do_discards+0x319/0x570 fs/bcachefs/alloc_background.c:1984
 journal_write_done+0xee4/0x1430 fs/bcachefs/journal_io.c:1821
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3321 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3402
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 6436:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 __bch2_dev_alloc+0xb5/0xff0 fs/bcachefs/super.c:1487
 bch2_dev_alloc+0xb8/0x190 fs/bcachefs/super.c:1558
 bch2_fs_alloc+0x19ca/0x23f0 fs/bcachefs/super.c:1051
 bch2_fs_open+0x838/0xc50 fs/bcachefs/super.c:2433
 bch2_fs_get_tree+0xcb0/0x1b70 fs/bcachefs/fs.c:2472
 vfs_get_tree+0x8e/0x340 fs/super.c:1804
 do_new_mount fs/namespace.c:3902 [inline]
 path_mount+0x1414/0x2020 fs/namespace.c:4226
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount fs/namespace.c:4427 [inline]
 __x64_sys_mount+0x28d/0x310 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6436:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2381 [inline]
 slab_free mm/slub.c:4643 [inline]
 kfree+0x2b4/0x4d0 mm/slub.c:4842
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1e7/0x5a0 lib/kobject.c:737
 bch2_fs_free+0x225/0x420 fs/bcachefs/super.c:728
 bch2_fs_get_tree+0xd5e/0x1b70 fs/bcachefs/fs.c:2604
 vfs_get_tree+0x8e/0x340 fs/super.c:1804
 do_new_mount fs/namespace.c:3902 [inline]
 path_mount+0x1414/0x2020 fs/namespace.c:4226
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount fs/namespace.c:4427 [inline]
 __x64_sys_mount+0x28d/0x310 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:548
 insert_work+0x36/0x230 kernel/workqueue.c:2183
 __queue_work+0x97e/0x10f0 kernel/workqueue.c:2341
 queue_work_on+0x1a4/0x1f0 kernel/workqueue.c:2392
 bch2_btree_node_read_done+0x2bf9/0x4e50 fs/bcachefs/btree_io.c:1156
 btree_node_read_work+0x2c9/0xe00 fs/bcachefs/btree_io.c:1440
 bch2_btree_node_read+0x891/0xe20 fs/bcachefs/btree_io.c:1865
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
 bch2_btree_root_read+0x2d1/0x480 fs/bcachefs/btree_io.c:1928
 read_btree_roots fs/bcachefs/recovery.c:615 [inline]
 bch2_fs_recovery+0x2271/0x48a0 fs/bcachefs/recovery.c:1006
 bch2_fs_start+0xdd0/0x1450 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xd9b/0x1b70 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8e/0x340 fs/super.c:1804
 do_new_mount fs/namespace.c:3902 [inline]
 path_mount+0x1414/0x2020 fs/namespace.c:4226
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount fs/namespace.c:4427 [inline]
 __x64_sys_mount+0x28d/0x310 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880322ee000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 64 bytes inside of
 freed 4096-byte region [ffff8880322ee000, ffff8880322ef000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x322e8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b842140 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801b842140 dead000000000100 dead000000000122
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0000c8ba01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 32707965621, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1c0/0x230 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x1321/0x3890 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x261/0x23f0 mm/page_alloc.c:4959
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab mm/slub.c:2619 [inline]
 new_slab+0x23b/0x330 mm/slub.c:2673
 ___slab_alloc+0xd9c/0x1940 mm/slub.c:3859
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3949
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __kmalloc_cache_noprof+0xfb/0x3e0 mm/slub.c:4354
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 kobject_uevent_env+0x265/0x1870 lib/kobject_uevent.c:540
 version_sysfs_builtin kernel/params.c:877 [inline]
 param_sysfs_builtin_init+0xd9/0x4c0 kernel/params.c:985
 do_one_initcall+0x123/0x6e0 init/main.c:1274
 do_initcall_level init/main.c:1336 [inline]
 do_initcalls init/main.c:1352 [inline]
 do_basic_setup init/main.c:1371 [inline]
 kernel_init_freeable+0x5c2/0x900 init/main.c:1584
 kernel_init+0x1c/0x2b0 init/main.c:1474
 ret_from_fork+0x5d7/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8880322edf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880322edf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880322ee000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff8880322ee080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880322ee100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
