Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49AD136E23
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 15:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728574226; cv=none; b=jXPNIyO+I+CNFL00trXdilg46ZhX232J1AoM5i6DrQwdq8Wx99pLkxFMYURAH2bTgpd6DhHOWglvILcbiaHOhFyFGme2RUImdGBWxnzHpJh0TeLaPKnlZOxiHaQSqRSZHw+foqmSqsLbP9mdtDnbSNDBLQpXaq6fqpLI/u0IZI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728574226; c=relaxed/simple;
	bh=VUDWEFrc5drSt8vR2KliRaRHQH61de7guLqBvu/K+IU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=P7VCwTw3ly6zJ7KYc6ZA2mCmTjeZjPsJIYL/8lni+TB/9yM5h+Hqt5Y0wCuPk4G/ZCNH9KELVoHDIjaZPc7rlp8xRJVVzZkS+NINfVohD43nvYGRvCiDzAtZNstUNocmcYzXUt/ro15Cm3c9APdBM48VwL8QaezApy2v9RlXaPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a392e9a8a4so13315365ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Oct 2024 08:30:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728574224; x=1729179024;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lOrtMOEl2/v4ljPvD1T5zRUPqcdaOPtsScL3OxMIEpE=;
        b=jb2xG4zqMSufS5kx83mf445IZCC+E+5t8nPFVHNKzKUJCP+14Utq5Z6BB67hi1PMdO
         Uh5JNyc1uMf93K9m1LKKGaZEHY/FY9d/Keys0g8biXwTXneU7YC5jpTMufPjFouAc7eu
         i6tYv0KhpjFveBpS/aNfpeUCCyDEwmeoGgJhUR23ga1HtrK9CMxuhix7gm7CfQYw8jqD
         vTAdqCrVLSnuRqRwPjCN+RzOcM34LFKFquvYg/r0KOd1kRhPqV6ItHctVbIoropEuyh/
         LF+P3q7hktoyP3QhpyoxFvIWKx0ZVhbnylRx/0CjuEbf3YX+DDmiR3O0MieRm9H6ijDt
         oMGw==
X-Forwarded-Encrypted: i=1; AJvYcCUv5VefhQAHIq1MZ0RYEZsoJR9qrbB5/5M22hAxuU/FpmDj9FsWl7jGFi+SgGAEgAteo+ZAiXlifhb+LF4TfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw81arEpvU+d7jkuDyl3YuZwZWF+iIgDpnz6DAN/jUBUoVoOHmO
	0NrHw7JEKLbXNp72ns6cyQbOBqCG+Up4fmjWRbvt+eH07qA4mpd5wE3xoRikJ4JPZ21ZLY0MtLG
	6aHIxYMlGVBXRgsSQyLHgO7eYXSVN9Gjo9FL49ZDOuZ6HBNE+eq5iqyQ=
X-Google-Smtp-Source: AGHT+IE33Ptol93r2SXPC7HWoQpirh/0/J8ZyCt+2ni/kZTzF7ZvtN2D7IGcGgtbHIcA01GQObkQB4i0xkdPH9hDUr6WEyOhCdGA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fce:b0:3a3:3e17:994e with SMTP id
 e9e14a558f8ab-3a397cfc554mr72027075ab.9.1728574223820; Thu, 10 Oct 2024
 08:30:23 -0700 (PDT)
Date: Thu, 10 Oct 2024 08:30:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6707f30f.050a0220.64b99.001d.GAE@google.com>
Subject: [syzbot] [block?] [bcachefs?] KASAN: slab-use-after-free Read in
 percpu_ref_put (2)
From: syzbot <syzbot+905d719acdbd213bf67e@syzkaller.appspotmail.com>
To: axboe@kernel.dk, kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f602276d390 Merge tag 'bcachefs-2024-10-05' of git://evil..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1033c7d0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba92623fdea824c9
dashboard link: https://syzkaller.appspot.com/bug?extid=905d719acdbd213bf67e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1131f307980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15148327980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-8f602276.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d7abbd2b0653/vmlinux-8f602276.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6a9f3d168828/bzImage-8f602276.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/184260729fa9/mount_8.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+905d719acdbd213bf67e@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
BUG: KASAN: slab-use-after-free in percpu_ref_put_many include/linux/percpu-refcount.h:332 [inline]
BUG: KASAN: slab-use-after-free in percpu_ref_put+0xda/0x250 include/linux/percpu-refcount.h:351
Read of size 8 at addr ffff8880364920b0 by task kworker/u4:8/1067

CPU: 0 UID: 0 PID: 1067 Comm: kworker/u4:8 Not tainted 6.12.0-rc1-syzkaller-00349-g8f602276d390 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: loop0 loop_rootcg_workfn
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 __ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
 percpu_ref_put_many include/linux/percpu-refcount.h:332 [inline]
 percpu_ref_put+0xda/0x250 include/linux/percpu-refcount.h:351
 blk_update_request+0x5e5/0x1160 block/blk-mq.c:923
 blk_mq_end_request+0x3e/0x70 block/blk-mq.c:1051
 loop_handle_cmd drivers/block/loop.c:1927 [inline]
 loop_process_work+0x1c10/0x2170 drivers/block/loop.c:1945
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 5114:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4295
 kmalloc_noprof include/linux/slab.h:878 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 __bch2_dev_alloc+0x57/0xa60 fs/bcachefs/super.c:1289
 bch2_dev_alloc+0xd4/0x170 fs/bcachefs/super.c:1359
 bch2_fs_alloc fs/bcachefs/super.c:939 [inline]
 bch2_fs_open+0x2e3f/0x2f80 fs/bcachefs/super.c:2050
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2067
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5114:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4727
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_free+0x27b/0x3c0 fs/bcachefs/super.c:667
 bch2_fs_get_tree+0xd9f/0x1710 fs/bcachefs/fs.c:2175
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888036492000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 176 bytes inside of
 freed 4096-byte region [ffff888036492000, ffff888036493000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x36490
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 04fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 04fff00000000003 ffffea0000d92401 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5114, tgid 5114 (syz-executor374), ts 95819092336, free_ts 95351745772
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4276
 mempool_init_node+0x1ee/0x4e0 mm/mempool.c:217
 mempool_init_noprof+0x3a/0x50 mm/mempool.c:246
 bch2_fs_btree_interior_update_init+0xca/0x100 fs/bcachefs/btree_update_interior.c:2706
 bch2_fs_alloc fs/bcachefs/super.c:919 [inline]
 bch2_fs_open+0x2af9/0x2f80 fs/bcachefs/super.c:2050
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2067
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
page last free pid 5104 tgid 5104 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 mempool_exit+0xc7/0x1a0 mm/mempool.c:170
 bch2_fs_io_write_exit+0x19/0x40 fs/bcachefs/io_write.c:1673
 __bch2_fs_free fs/bcachefs/super.c:550 [inline]
 bch2_fs_release+0x1e1/0x7d0 fs/bcachefs/super.c:609
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_get_tree+0xd9f/0x1710 fs/bcachefs/fs.c:2175
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888036491f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888036492000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888036492080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888036492100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888036492180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
