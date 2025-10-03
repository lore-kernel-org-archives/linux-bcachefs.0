Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B651A9F94
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 Oct 2025 21:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759527504; cv=none; b=ECWIafowAIqbU5tD4CxKDALR2Gv7LpuIpejdNSH6Njia0vi6BotXpm+4PpwQK0q9XvDQ/JC9gDjgC5FOHZgsgyVYQUs/0YA80lft8JyR8K+KTHP0dHSRiP3GCfnS4+UYCBqCWFRMRgB1IqM4+WUagMZ4SBX6mwLTsrrNGV8WJcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759527504; c=relaxed/simple;
	bh=B8uKHKZG9j9ZUJC5t9l2AgKCHTTL9hKUFTJU9n9P/tw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bST5CYQq+gkjlNCE1GCwaeQ1r4S2yJPu9Oa2LGckGdbmqikN6TlyqYh97/4f75nfKi014Wjej+/mXVE/A95siL1isLRhH5GvmHObcAGexb6Tp9ubxufJ4rT7VPc8wALZheQSGkKfK+irR4vN3xS8YfwrxWPWjSdaBu6lPxJMUiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-42f5f2155fdso11219115ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 Oct 2025 14:38:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759527502; x=1760132302;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTtP5AV62BGebLZN1tj8/A3Mmm8u7p3OG4PAVyeK9bw=;
        b=nQzcotVc1x1DEHa1YLtKg8YY+mJaw8/rH15gIFwWw77CCQo4j0cyPzGybJWesDEVbN
         2C3fhq0nwP5cMpKIFTVWgUoE2hOK21C18hdqmZJrlSqecj3YdEtyWYJcKW7Uawd0iKuc
         vMJemmSegeQhRfyI6LzPlKW2p07scvV9DdXdQc/zFG2h9bIgYArJJj+tFLNJnMzfi6Qh
         Ap4pWnrfxo9Exs8UwWmah/7qWVjyzAZWVu4NhSDSeyuMLjNsWf9aCHuouN3tFPHp2IJ1
         Ub5cBAH8X9oNqCDCzfLMGtE4fZGXDFd5Z5DLHrGHGNDIE425Uwb6ko6AE1gihrzGSRfg
         CbbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU90ipMME4j+0Yyfy4ErM72Y+i9JCdwminaW6WZH+pRkvOZrPZF3jDb4/2F2e/4Dir7Jz7WoLVTdWMPZ0HfhA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtY5Gha3buBot2o2/MMcZJJJgL4xgxlzlsnq6ix0EZ4oDnxNhs
	myYENV70ujcXkWCBi4Y0nW9gjbAKtoT70hMD/RLdtksxuIiUR41weQgl5wf1CP0oVMT3n+pQ8kn
	/4ZCRTs64VYVq8Pyvj9x1bHDPjWQK9lDPxQl2eGKCp5r9L1AukvAcXrBSl3g=
X-Google-Smtp-Source: AGHT+IGk82uintWNJ/wmQU+F9PXEemlfGJDCvQEA12pkjdQnuXCQvZYIw1ep0Jm2sr61LFgDZ2E+0l/WTGe0UIDR9MOzuzkWL75m
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:218f:b0:425:7526:7f56 with SMTP id
 e9e14a558f8ab-42e7aced705mr63136745ab.5.1759527501704; Fri, 03 Oct 2025
 14:38:21 -0700 (PDT)
Date: Fri, 03 Oct 2025 14:38:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e0424d.050a0220.1696c6.004d.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_clear_folio_bits
From: syzbot <syzbot+5438c0a9fffa875ff01e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e5f0a698b34e Linux 6.17
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102a06e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=5438c0a9fffa875ff01e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e5f0a698.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c024c1509688/vmlinux-e5f0a698.xz
kernel image: https://storage.googleapis.com/syzbot-assets/28d9bfec58a3/bzImage-e5f0a698.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5438c0a9fffa875ff01e@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
kswapd1/78 is trying to acquire lock:
ffff88805299d558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: bch2_i_sectors_acct fs/bcachefs/fs-io.h:137 [inline]
ffff88805299d558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: bch2_clear_folio_bits+0x506/0x830 fs/bcachefs/fs-io-pagecache.c:513

but task is already holding lock:
ffffffff8e4419a0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7012 [inline]
ffffffff8e4419a0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2830 mm/vmscan.c:7386

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __fs_reclaim_acquire mm/page_alloc.c:4234 [inline]
       fs_reclaim_acquire+0x72/0x100 mm/page_alloc.c:4248
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4142 [inline]
       slab_alloc_node mm/slub.c:4220 [inline]
       __kmalloc_cache_noprof+0x41/0x3d0 mm/slub.c:4402
       kmalloc_noprof include/linux/slab.h:905 [inline]
       kzalloc_noprof include/linux/slab.h:1039 [inline]
       genradix_alloc_node include/linux/generic-radix-tree.h:101 [inline]
       __genradix_ptr_alloc+0x199/0x4a0 lib/generic-radix-tree.c:44
       bch2_quota_transfer+0x300/0xa50 fs/bcachefs/quota.c:343
       bch2_fs_quota_transfer+0x27d/0x4f0 fs/bcachefs/fs.c:183
       bch2_set_projid fs/bcachefs/fs.h:166 [inline]
       bch2_fileattr_set+0x515/0x6f0 fs/bcachefs/fs.c:1728
       vfs_fileattr_set+0x92f/0xb90 fs/file_attr.c:298
       ioctl_fssetxattr+0x1ed/0x270 fs/file_attr.c:372
       do_vfs_ioctl+0x81d/0x1430 fs/ioctl.c:567
       __do_sys_ioctl fs/ioctl.c:596 [inline]
       __se_sys_ioctl+0x82/0x170 fs/ioctl.c:584
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&inode->ei_quota_lock){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
       __mutex_lock_common kernel/locking/mutex.c:598 [inline]
       __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
       bch2_i_sectors_acct fs/bcachefs/fs-io.h:137 [inline]
       bch2_clear_folio_bits+0x506/0x830 fs/bcachefs/fs-io-pagecache.c:513
       bch2_release_folio+0xf7/0x150 fs/bcachefs/fs-io-pagecache.c:672
       shrink_folio_list+0x20ac/0x4cd0 mm/vmscan.c:1518
       evict_folios+0x471e/0x57c0 mm/vmscan.c:4744
       try_to_shrink_lruvec+0x8a3/0xb50 mm/vmscan.c:4907
       shrink_one+0x21b/0x7c0 mm/vmscan.c:4952
       shrink_many mm/vmscan.c:5015 [inline]
       lru_gen_shrink_node mm/vmscan.c:5093 [inline]
       shrink_node+0x314e/0x3760 mm/vmscan.c:6078
       kswapd_shrink_node mm/vmscan.c:6938 [inline]
       balance_pgdat mm/vmscan.c:7121 [inline]
       kswapd+0x147c/0x2830 mm/vmscan.c:7386
       kthread+0x711/0x8a0 kernel/kthread.c:463
       ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(&inode->ei_quota_lock);
                               lock(fs_reclaim);
  lock(&inode->ei_quota_lock);

 *** DEADLOCK ***

1 lock held by kswapd1/78:
 #0: ffffffff8e4419a0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:7012 [inline]
 #0: ffffffff8e4419a0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0x951/0x2830 mm/vmscan.c:7386

stack backtrace:
CPU: 0 UID: 0 PID: 78 Comm: kswapd1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2043
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3908
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __mutex_lock_common kernel/locking/mutex.c:598 [inline]
 __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
 bch2_i_sectors_acct fs/bcachefs/fs-io.h:137 [inline]
 bch2_clear_folio_bits+0x506/0x830 fs/bcachefs/fs-io-pagecache.c:513
 bch2_release_folio+0xf7/0x150 fs/bcachefs/fs-io-pagecache.c:672
 shrink_folio_list+0x20ac/0x4cd0 mm/vmscan.c:1518
 evict_folios+0x471e/0x57c0 mm/vmscan.c:4744
 try_to_shrink_lruvec+0x8a3/0xb50 mm/vmscan.c:4907
 shrink_one+0x21b/0x7c0 mm/vmscan.c:4952
 shrink_many mm/vmscan.c:5015 [inline]
 lru_gen_shrink_node mm/vmscan.c:5093 [inline]
 shrink_node+0x314e/0x3760 mm/vmscan.c:6078
 kswapd_shrink_node mm/vmscan.c:6938 [inline]
 balance_pgdat mm/vmscan.c:7121 [inline]
 kswapd+0x147c/0x2830 mm/vmscan.c:7386
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
