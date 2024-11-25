Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEB91BBBD7
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544318; cv=none; b=XCuUqyHJje0R2//UatRD1UskaDHBKQBe0cZd3mR9gMPLcSfoezLCt4OiVsmCyz1xlIR3RrsMnwWF3gzjjLzzsnl3o1gDPkE0WZrkqlaTJgMn7EsmY1d1Db/MiA4D5wZHf3yTZZOq6cvvz6D3/oOS4xmbRKrRTRlkwxKzSck+L/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544318; c=relaxed/simple;
	bh=0F9jLlx8VVGnwrKnBqn0cWJczvEtWxxfJFJVKn49kFk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FVSaFrdeNhOcZvK5ofeD9x9Rex0Q140mDqfyNKCaaS/YtozwhoDDH/K4O9WpP7rJ+E4sG0gy9UFhRGUoTpyKO6Ck7dI7kCwuUHQyZU6KBlnu+/HoYEurctHRwVF+gut+D25Z3cusNsr7E3olU16Qgo4w69RIAXoEid+4iTX1GvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-8419f8859f7so75115139f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 06:18:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732544316; x=1733149116;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IDiYy7syRxYhK+QrHXQlZhY4cYYyDMWsFiHB6gyc3/g=;
        b=u5dPQ+Uum3wgehqNXlPCan2dl3HFe4rBp/VCIw4sH/rM0bRavNnPgPPahZzig0ZW8I
         OpHCMY4uVAK3xDn8s3ghXTf5Me6EC5+p54urtN/pi+9Xa9tKWZQCTPk2RzVsmqcIT5ge
         LOa2BLKxgWKbIgZQ1ORBArlhWuLzcvDKsm+0awrdNdFqgbriolwvFvGcKCgvq+pLlXq0
         Eu2RPkfgXu0juABsJ8IuAw5hf9IOfvqmHhpAjKdYycMcsZSlZgMX6uUGLRl6shvaYz/A
         MZPkgZZ6cEwc9HFligfMp/NR8cYsvPik9bc03QObcKXv/efiJ7Oj+jm4PUv8atoEpTwU
         xUgw==
X-Forwarded-Encrypted: i=1; AJvYcCX7roCyEpyMyuYIljAdAueyWoNEZuVziN6eyJpSHab/OhWyWkb9WKS/VIvMnHezPjpBkMBbDjL78p+B1R/b2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YycRDKqSM39vw1skMnJ1zueQ6+lOPbvG6R5+S1/Qf9o9bPMOA9K
	U1NZQ7rQE4wTVMpqZFdlx8CPZkhbl8mDvqk3LDAP3pLRrzYagpmFGjKMtSQyvFAbBcW5ukglJeo
	q0KVKzWLATPYF//IJ2OUupsKopE3esWYE+xd5Vvp6S9zB0JUvMXlf/NE=
X-Google-Smtp-Source: AGHT+IGcbkyrBGHWuXxkpLyM1iBtg0H+0An4Yl8A7R60SMCNEpdvYzDhF2YQaDuuXxAF/5zb7lgb7Q6NOkXUqIeXb9KPl2bFiTvw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a62:b0:3a7:6f1c:a084 with SMTP id
 e9e14a558f8ab-3a79afec520mr151317035ab.23.1732544315784; Mon, 25 Nov 2024
 06:18:35 -0800 (PST)
Date: Mon, 25 Nov 2024 06:18:35 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6744873b.050a0220.1286eb.0000.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_exit
From: syzbot <syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/smmu'..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=116f6930580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dfe1e340fbee3d16
dashboard link: https://syzkaller.appspot.com/bug?extid=e733ab672a1b6724c27f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/354fe38e2935/disk-7b1d1d4c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f12e0b1ef3fd/vmlinux-7b1d1d4c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/291dbc519bb3/Image-7b1d1d4c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e733ab672a1b6724c27f@syzkaller.appspotmail.com

------------[ cut here ]------------
==================================================================
BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:646 [inline]
BUG: KASAN: global-out-of-bounds in string+0x1dc/0x264 lib/vsprintf.c:728
Read of size 1 at addr ffff80008bacf4cb by task syz-executor/6428

CPU: 1 UID: 0 PID: 6428 Comm: syz-executor Not tainted 6.12.0-syzkaller-g7b1d1d4cfac0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x198/0x538 mm/kasan/report.c:488
 kasan_report+0xd8/0x138 mm/kasan/report.c:601
 __asan_report_load1_noabort+0x20/0x2c mm/kasan/report_generic.c:378
 string_nocheck lib/vsprintf.c:646 [inline]
 string+0x1dc/0x264 lib/vsprintf.c:728
 vsnprintf+0xe9c/0x1a8c lib/vsprintf.c:2803
 vprintk_store+0x38c/0xd80 kernel/printk/printk.c:2260
 vprintk_emit+0x258/0x55c kernel/printk/printk.c:2383
 vprintk_default+0xa0/0xe4 kernel/printk/printk.c:2422
 vprintk+0x200/0x300 kernel/printk/printk_safe.c:68
 __warn_printk+0x2b0/0x484 kernel/panic.c:797
 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
 register_lock_class+0x8c/0x6b4 kernel/locking/lockdep.c:1290
 __lock_acquire+0x18c/0x77c8 kernel/locking/lockdep.c:5077
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_has_pending_or_armed fs/bcachefs/rcu_pending.c:576 [inline]
 rcu_pending_exit+0x124/0x660 fs/bcachefs/rcu_pending.c:594
 bch2_fs_btree_key_cache_exit+0x7ec/0x8f4 fs/bcachefs/btree_key_cache.c:742
 __bch2_fs_free fs/bcachefs/super.c:556 [inline]
 bch2_fs_release+0x1fc/0x728 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2a8/0x41c lib/kobject.c:737
 bch2_fs_free+0x2c4/0x334 fs/bcachefs/super.c:673
 bch2_kill_sb+0x48/0x58 fs/bcachefs/fs.c:2279
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1373
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1380
 task_work_run+0x230/0x2e0 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:745
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

The buggy address belongs to the variable:
 .str+0xb/0x20

The buggy address belongs to the virtual mapping at
 [ffff80008b5d0000, ffff80008f330000) created by:
 declare_kernel_vmas+0x58/0xb8 arch/arm64/mm/mmu.c:771

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a22cf
flags: 0x5ffc00000002000(reserved|node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000002000 fffffdffc588b3c8 fffffdffc588b3c8 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff80008bacf380: 00 f9 f9 f9 00 06 f9 f9 00 00 00 00 f9 f9 f9 f9
 ffff80008bacf400: 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 00 00 00 00
>ffff80008bacf480: 00 00 00 00 00 00 00 00 00 01 f9 f9 00 00 00 04
                                              ^
 ffff80008bacf500: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
 ffff80008bacf580: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Looking for class "" with key rcu_pending_init.__key, but found a different class "&p->lock" with the same key
WARNING: CPU: 1 PID: 6428 at kernel/locking/lockdep.c:939 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 1 UID: 0 PID: 6428 Comm: syz-executor Tainted: G    B              6.12.0-syzkaller-g7b1d1d4cfac0 #0
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
lr : look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936
sp : ffff8000a42773e0
x29: ffff8000a42773e0 x28: dfff800000000000 x27: 0000000000000000
x26: ffff8000973468c0 x25: ffff800097346000 x24: 0000000000000001
x23: 0000000000000000 x22: 1ffff00011f040ba x21: ffff8000974ed7c0
x20: fffffdffbf7434b0 x19: ffff800092e7e3c0 x18: 0000000000000008
x17: 20646e756f662074 x16: ffff8000830d1d70 x15: 0000000000000001
x14: 1fffe000366cb0e2 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000003 x10: 0000000000ff0100 x9 : 19ffed0552c97800
x8 : 19ffed0552c97800 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff8000a4276b18 x4 : ffff80008f90d220 x3 : ffff800080626d8c
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 0000000000000000
Call trace:
 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936 (P)
 look_up_lock_class+0xec/0x160 kernel/locking/lockdep.c:936 (L)
 register_lock_class+0x8c/0x6b4 kernel/locking/lockdep.c:1290
 __lock_acquire+0x18c/0x77c8 kernel/locking/lockdep.c:5077
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_has_pending_or_armed fs/bcachefs/rcu_pending.c:576 [inline]
 rcu_pending_exit+0x124/0x660 fs/bcachefs/rcu_pending.c:594
 bch2_fs_btree_key_cache_exit+0x7ec/0x8f4 fs/bcachefs/btree_key_cache.c:742
 __bch2_fs_free fs/bcachefs/super.c:556 [inline]
 bch2_fs_release+0x1fc/0x728 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2a8/0x41c lib/kobject.c:737
 bch2_fs_free+0x2c4/0x334 fs/bcachefs/super.c:673
 bch2_kill_sb+0x48/0x58 fs/bcachefs/fs.c:2279
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1373
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1380
 task_work_run+0x230/0x2e0 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:745
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 282192
hardirqs last  enabled at (282191): [<ffff80008b5a7504>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (282191): [<ffff80008b5a7504>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:194
hardirqs last disabled at (282192): [<ffff80008b5a73ac>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:117 [inline]
hardirqs last disabled at (282192): [<ffff80008b5a73ac>] _raw_spin_lock_irq+0x28/0x70 kernel/locking/spinlock.c:170
softirqs last  enabled at (280764): [<ffff80008020396c>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (280764): [<ffff80008020396c>] handle_softirqs+0xa38/0xbf8 kernel/softirq.c:582
softirqs last disabled at (280725): [<ffff800080020db4>] __do_softirq+0x14/0x20 kernel/softirq.c:588
---[ end trace 0000000000000000 ]---


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
