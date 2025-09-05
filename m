Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022252F6589
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 11:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757072130; cv=none; b=pWME3FtefZ6y4jpRIg6yjHfynRSzR3uBzvN0X1IPgp0qXacU2JjhIre5gU88V43AeVlC9p33Iez9hMCRCZZX8UrToMWTPvDa5P0S5hd7WffFNWLlxclhRMkaDUasAZgQY+IB43l+4VVATdUAoBpwmzWT4fT0dm07w7tEzcxOJ4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757072130; c=relaxed/simple;
	bh=tSanGJy76dLxmJqpUyrsecNK7rEn5AmFi6bLT8VZbso=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tqxqhCqOZM58h+gQ/kA4EBKSI7xoru2RsTyy+SQpvyZvyxx7GqdYZLf9h/M5nN6hbBNJYO2H+Mgp5vgXwsnGhrN+9UjuPYNySpQknAupsUkVcd9/7jrw3QcylDMu6HZN+OGIr/dXmiPEzCX7Lhqwq6feLKpAJCTzvunegRETmSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3f20528fe92so52449015ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 04:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757072128; x=1757676928;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tetDGk2ue+hHtiH3fjv21uePCmj61sLt5izm6/kTV2g=;
        b=cMJcV93SffOv1GTSrcFPshv0iovDb1EF3F3N55kTkpNPuaL7NtyVNITgSJvic+Xyib
         EOHmC7e+EoDLu4e7h6LmQItajBS+Hcl07IceMj7HnstZwBcek4MKU4T43MxoE9iXpy0M
         hj4ZipLDM8yhktAEkeFb5H+Xpl/YTyqpG9/lvaK3ENv7F7HJM0Fo/RB/8/TIvRTGtQl4
         RGUo9A6zJ5BzzziNOZvN1+tpCSGPvDrpQR3FP3RIVKJPnFMicxUGy7O9E8dc2z4OkhUd
         Mx2atlCVn/D2KmIm2AIp+no5zhG+WxoqN9zOxhZyXdIy50abG35A1SFpp/sVYb+Agec9
         gI4A==
X-Forwarded-Encrypted: i=1; AJvYcCXLoVB7XHc53WtrmIi1WOsCFG8e2MGOiUDdzlRjxCwIcBQr62E3ZRUjw2B6Ofjyo0jqAo2sbpxgOp3Fns32xA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSGX8ZoN0aHvYs3HJhHn36VhJqcvuCz0LxP6Jxd3+NimZc0Ts7
	hZ+2GBYbtAeHP7wTwom8m1RHr9opZIcuYD2LrVYSnw65lyQ3j+F0RnQCIzdDMe94jZgTyw4gpv4
	ekyyiCofe3OlkTXWk1r2yPX4uoNmlDBHh8vrWSPhHFhEV09o4jzfoaFn+lGk=
X-Google-Smtp-Source: AGHT+IH5hYnA/vwgm3oYtbUmErzdhjx9s/HmRY/FpxKQgmr3TdXmrkvZJ+gRN3BJBFsYusVwO2B+ZrH+GcaOSwA+j/0lsnfv+XXA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219d:b0:3f3:5e4:24b1 with SMTP id
 e9e14a558f8ab-3f4024cbd7cmr365484945ab.28.1757072128078; Fri, 05 Sep 2025
 04:35:28 -0700 (PDT)
Date: Fri, 05 Sep 2025 04:35:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bacb00.050a0220.192772.018c.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_prt_printf
From: syzbot <syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10d67162580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=385d836f07b5a70d
dashboard link: https://syzkaller.appspot.com/bug?extid=7f176adb30b21606c5fc
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14d67162580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1412c962580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-d69eb204.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e24d9eda2154/vmlinux-d69eb204.xz
kernel image: https://storage.googleapis.com/syzbot-assets/213a30ed1023/bzImage-d69eb204.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/aa6322da89ec/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com

bcachefs (loop0): Doing compatible version upgrade from 1.13: inode_has_child_snapshots to 1.28: inode_has_case_insensitive
  running recovery passes: check_allocations,check_extents_to_backpointers,check_inodes
==================================================================
BUG: KASAN: use-after-free in string_nocheck lib/vsprintf.c:653 [inline]
BUG: KASAN: use-after-free in string+0x231/0x2b0 lib/vsprintf.c:735
Read of size 1 at addr ffff888050fe74f7 by task syz.0.17/5533

CPU: 0 UID: 0 PID: 5533 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 string_nocheck lib/vsprintf.c:653 [inline]
 string+0x231/0x2b0 lib/vsprintf.c:735
 vsnprintf+0x739/0xf00 lib/vsprintf.c:2926
 bch2_prt_printf+0x1c6/0x740 fs/bcachefs/printbuf.c:183
 bch2_dirent_to_text+0x2bd/0xd20 fs/bcachefs/dirent.c:220
 __bch2_bkey_fsck_err+0x3f7/0x540 fs/bcachefs/error.c:691
 bch2_dirent_validate+0x7b3/0xfb0 fs/bcachefs/dirent.c:164
 bch2_bkey_val_validate+0x202/0x3e0 fs/bcachefs/bkey_methods.c:143
 btree_node_bkey_val_validate fs/bcachefs/btree_io.c:880 [inline]
 bch2_btree_node_read_done+0x4051/0x5550 fs/bcachefs/btree_io.c:1303
 btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
 bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
 bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
 read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
 bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd00ed9038a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff65054f18 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff65054fa0 RCX: 00007fd00ed9038a
RDX: 0000200000000040 RSI: 0000200000004940 RDI: 00007fff65054f60
RBP: 0000200000000040 R08: 00007fff65054fa0 R09: 0000000000004000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000200000004940
R13: 00007fff65054f60 R14: 000000000000496e R15: 0000200000000000
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888050fe7dc0 pfn:0x50fe7
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f0(buddy)
raw: 04fff00000000000 ffffea00013e8dc8 ffffea000139e008 0000000000000000
raw: ffff888050fe7dc0 0000000000000000 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_COMP), pid 5454, tgid 5454 (dhcpcd-run-hook), ts 104016831092, free_ts 104102545739
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
 pagetable_alloc_noprof include/linux/mm.h:2881 [inline]
 __pte_alloc_one_noprof include/asm-generic/pgalloc.h:75 [inline]
 pte_alloc_one+0x21/0x170 arch/x86/mm/pgtable.c:18
 __pte_alloc+0x25/0x1a0 mm/memory.c:452
 copy_pte_range mm/memory.c:1107 [inline]
 copy_pmd_range+0x6a91/0x71d0 mm/memory.c:1261
 copy_pud_range mm/memory.c:1298 [inline]
 copy_p4d_range mm/memory.c:1322 [inline]
 copy_page_range+0xc14/0x1270 mm/memory.c:1410
 dup_mmap+0xf57/0x1ac0 mm/mmap.c:1834
 dup_mm kernel/fork.c:1485 [inline]
 copy_mm+0x13c/0x4b0 kernel/fork.c:1537
 copy_process+0x1706/0x3c00 kernel/fork.c:2175
 kernel_clone+0x21e/0x840 kernel/fork.c:2605
 __do_sys_clone kernel/fork.c:2748 [inline]
 __se_sys_clone kernel/fork.c:2732 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 15 tgid 15 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 pagetable_free include/linux/mm.h:2898 [inline]
 pagetable_dtor_free include/linux/mm.h:2996 [inline]
 __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
 __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
 smpboot_thread_fn+0x53f/0xa60 kernel/smpboot.c:160
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888050fe7380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888050fe7400: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888050fe7480: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                             ^
 ffff888050fe7500: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888050fe7580: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
