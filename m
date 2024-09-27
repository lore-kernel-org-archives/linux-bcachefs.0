Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75CBA29
	for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 00:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727395953; cv=none; b=TyhJ75AIZ/cafUYSySlYSfQTgsPOFxGN5VmG68zqhT8d56UPVFgEa1wI4dB86EfybT2J7ukTH4rgEtEuUrrcnCwAYx/mYHSzjG0XZULMT49wP/GYms9qvpDSjDWxBlIq6a87O7ATyxHM/Bbs6EpX2gkUNEVFWkxGffp2np815Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727395953; c=relaxed/simple;
	bh=o/EdALRI5mBrxMJucSTiPiGsjVGJhN/bEKVsgGwV1Jk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YDqzqXQX/XRfY0A1wCd/+nhhlbcqdip+N+64jz4nxq1KJqM/RvmzYKsvuxMao7ROCzjvD/50sr9eR/8ce3HtLIVUJlAshHkx0S3GGXsHqCP2ltkZDQ/2HISsOEm5FTdvcJ+dYxMCQetXeiy4f4VejVptRMxP4CnVpR4s0GKLMzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3453139c0so4347965ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 17:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727395950; x=1728000750;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sS5DXyIvLAbuX5hsaFzSKBBlNZRUZz7S05SX4YRwSJM=;
        b=Vur7CHfUWD7eYGpJd9Eggdv//gkNBHqPo16T/xlzzIXY4N619U+SBMziCTQGA8N9u4
         i41o6ebQk7Soj352M0GnqCAg4SefokZxqDU4sOQ1F3x1rtcp/jwTNhqi4RCRzXOODJdb
         YL7L9CCCbjQxnkAImStaP4kjaXiH1Mt+IGLIUHw94YNpvBDT/eURtcSeCcNvr3Csp/Wi
         FtkWfEWfkA3IVN7DxANb0sx4Zb8OiTk4oGjbHMfYvz5jqZozk7n1Z83bmZQD1lw+2lZI
         d8PaWalL91bqn7Vg/JZvkblV59fVvpolWfeC7aL/QxlrRnzINuMRkzy3gh/YTPLHX5HR
         oChQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEpoutwfv9X59OX1uT7M8hx7RPrLOYeuFZAp/JRlougfmFp+Zgb9+X5bmFHNlRA4DkFi8W++gikxKWqxNLsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwjCcobrMDcIgE+bphZOjsiQN8EAkAFJ28WO7nR4eXSl/1izPxX
	7IPgyPdwDjebs2xH5PVqmZ+FU6TyveM7dSDMK8Ud0hpVjaGZ4YWlcLddqm4IdjubhL+FTETVf8f
	FnNFnX/ellpOfc7rcVJEEi0DivRG54aO/Tp26y2xu2bY0eCyqTmPlpck=
X-Google-Smtp-Source: AGHT+IEOmZOX8tlOnMMtKqnJEm3hm7r49RL+H8CWGxFubTelPZPLAy6HzwV4swQyMLb93ossNgfQnViu96JaBLbhm/LcfrqFcEyW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d10:b0:3a0:98b2:8f3b with SMTP id
 e9e14a558f8ab-3a3451652eamr11475775ab.7.1727395950093; Thu, 26 Sep 2024
 17:12:30 -0700 (PDT)
Date: Thu, 26 Sep 2024 17:12:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f5f86e.050a0220.38ace9.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_direct_write
From: syzbot <syzbot+19ad84d5133871207377@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    68e5c7d4cefb Merge tag 'kbuild-v6.12' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175fd2a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d7be1e8a7715109f
dashboard link: https://syzkaller.appspot.com/bug?extid=19ad84d5133871207377
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-68e5c7d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/27acf8bc9a01/vmlinux-68e5c7d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fa422750cd74/bzImage-68e5c7d4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+19ad84d5133871207377@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
invalid bkey u64s 11 type alloc_v4 0:14:0 len 0 ver 0: 
  gen 0 oldest_gen 0 data_type journal
  journal_seq       1
  need_discard      1
  need_inc_gen      1
  dirty_sectors     256
  stripe_sectors    0
  cached_sectors    0
  stripe            67108864
  stripe_redundancy 0
  io_time[READ]     1
  io_time[WRITE]    1
  fragmentation     0
  bp_start          8
  invalid data type (got 2 should be 7): delete?, fixing
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 75277f57b0c8c24 written 32 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 19bc58a6c09b6540 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c18f4a4face03c6 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7675f41d391e5d36 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq bcb9905dfb2993d5 written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9a831b4a3f983356 written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
 done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
==================================================================
BUG: KASAN: slab-use-after-free in bch2_dio_write_done fs/bcachefs/fs-io-direct.c:390 [inline]
BUG: KASAN: slab-use-after-free in bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:544 [inline]
BUG: KASAN: slab-use-after-free in bch2_direct_write+0x2a60/0x3140 fs/bcachefs/fs-io-direct.c:654
Read of size 8 at addr ffff8880332890a0 by task syz.0.0/5109

CPU: 0 UID: 0 PID: 5109 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-10392-g68e5c7d4cefb #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 bch2_dio_write_done fs/bcachefs/fs-io-direct.c:390 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:544 [inline]
 bch2_direct_write+0x2a60/0x3140 fs/bcachefs/fs-io-direct.c:654
 bch2_write_iter+0x18e/0x23f0 fs/bcachefs/fs-io-buffered.c:1030
 aio_write+0x56b/0x7c0 fs/aio.c:1633
 io_submit_one+0x8a7/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x179/0x2f0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faa7fd7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faa80b10038 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
RAX: ffffffffffffffda RBX: 00007faa7ff35f80 RCX: 00007faa7fd7def9
RDX: 0000000020001d00 RSI: 0000000000000001 RDI: 00007faa80acc000
RBP: 00007faa80b10090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007faa7ff35f80 R15: 00007fff53efb458
 </TASK>

Allocated by task 5109:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_mempool_unpoison_object+0x9e/0x160 mm/kasan/common.c:547
 remove_element+0x129/0x1a0 mm/mempool.c:150
 mempool_alloc_noprof+0x54e/0x5a0 mm/mempool.c:408
 bio_alloc_bioset+0x26f/0x1130 block/bio.c:554
 bch2_direct_write+0x5a0/0x3140 fs/bcachefs/fs-io-direct.c:626
 bch2_write_iter+0x18e/0x23f0 fs/bcachefs/fs-io-buffered.c:1030
 aio_write+0x56b/0x7c0 fs/aio.c:1633
 io_submit_one+0x8a7/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x179/0x2f0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5109:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_mempool_poison_object+0xaa/0x120 mm/kasan/common.c:522
 kasan_mempool_poison_object include/linux/kasan.h:357 [inline]
 kasan_poison_element mm/mempool.c:118 [inline]
 add_element mm/mempool.c:141 [inline]
 mempool_free+0x1c8/0x390 mm/mempool.c:541
 bch2_dio_write_done fs/bcachefs/fs-io-direct.c:388 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:544 [inline]
 bch2_direct_write+0x2a49/0x3140 fs/bcachefs/fs-io-direct.c:654
 bch2_write_iter+0x18e/0x23f0 fs/bcachefs/fs-io-buffered.c:1030
 aio_write+0x56b/0x7c0 fs/aio.c:1633
 io_submit_one+0x8a7/0x18a0 fs/aio.c:2052
 __do_sys_io_submit fs/aio.c:2111 [inline]
 __se_sys_io_submit+0x179/0x2f0 fs/aio.c:2081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888033288fc0
 which belongs to the cache bio-119 of size 1192
The buggy address is located 224 bytes inside of
 freed 1192-byte region [ffff888033288fc0, ffff888033289468)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x33288
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88803d006dc0 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000001f5000000 0000000000000000
head: 04fff00000000040 ffff88803d006dc0 dead000000000122 0000000000000000
head: 0000000000000000 00000000800c000c 00000001f5000000 0000000000000000
head: 04fff00000000002 ffffea0000cca201 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5109, tgid 5108 (syz.0.0), ts 72169226459, free_ts 71873280046
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2413
 allocate_slab+0x5a/0x2f0 mm/slub.c:2579
 new_slab mm/slub.c:2632 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3819
 __slab_alloc+0x58/0xa0 mm/slub.c:3909
 __slab_alloc_node mm/slub.c:3962 [inline]
 slab_alloc_node mm/slub.c:4123 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x2a0 mm/slub.c:4142
 mempool_init_node+0x1ee/0x4e0 mm/mempool.c:217
 mempool_init_noprof+0x3a/0x50 mm/mempool.c:246
 bioset_init+0x2e8/0x820 block/bio.c:1857
 bch2_fs_fs_io_direct_init+0x67/0x90 fs/bcachefs/fs-io-direct.c:681
 bch2_fs_alloc fs/bcachefs/super.c:932 [inline]
 bch2_fs_open+0x2d77/0x2f80 fs/bcachefs/super.c:2050
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2058
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
page last free pid 9 tgid 9 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 discard_slab mm/slub.c:2678 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3146
 put_cpu_partial+0x17c/0x250 mm/slub.c:3221
 __slab_free+0x2ea/0x3d0 mm/slub.c:4450
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4086 [inline]
 slab_alloc_node mm/slub.c:4135 [inline]
 __kmalloc_cache_noprof+0x132/0x2c0 mm/slub.c:4291
 kmalloc_noprof include/linux/slab.h:878 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 nsim_fib4_rt_create drivers/net/netdevsim/fib.c:280 [inline]
 nsim_fib4_rt_insert drivers/net/netdevsim/fib.c:426 [inline]
 nsim_fib4_event drivers/net/netdevsim/fib.c:464 [inline]
 nsim_fib_event drivers/net/netdevsim/fib.c:884 [inline]
 nsim_fib_event_work+0xe1a/0x4130 drivers/net/netdevsim/fib.c:1492
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff888033288f80: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
 ffff888033289000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888033289080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                               ^
 ffff888033289100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888033289180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
