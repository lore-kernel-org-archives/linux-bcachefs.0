Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D0214A4DB
	for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756404945; cv=none; b=JR2vsCVarBbM9nRC4RC3zlL1/CDOnsrqklMmxvEfiiy0Z1NTC6+TJSSnGvfXW3vKKE55Pmg0pAGn/q0j9IJPr1bRtboxbyTU81EYYBKsy4sLTEvKuP8Al11vyuK1BI+nfjAkzY80RKyBxEO1bkxvtGFahDzid5flwftH83Z5+Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756404945; c=relaxed/simple;
	bh=vTcIZmfvTBPpIzuzdSGuAvEnWo82Uy3/vrxBJsPAGg0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=NOTZiXUub19/y0WDn7C1pUTtDpdo27v7ES44/WVEaSiW34QEd2S7huZc9c8mbfJjytPTspCqhcAcuMrqvvwDLQ7611toWqNTLhjNn4Q1qT2iIFmBeUYN/Dg0pt0q6tSGThqWNgSU+N+7DU4uFI669/9RtDpz8CiTSpjP7FTWexs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3efd62bc46fso14159185ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 28 Aug 2025 11:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756404943; x=1757009743;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7nGNvldgd/RRAc8uTpZZ+9Zg1c8g1AnsVsk/7T6rLYY=;
        b=L3WCnggcxgbX5FEtikbsZsXQCo+vB1pjrZd8DicNW7ujLOYiOvz2TdVBQLmXZN1j7s
         A/EHAZ7m9DaGe9NJ0KjqIjBOklpOa2MGz5mhMpw4v7IThXs1DLNnYzqBabtoO99LEGd6
         V3Kz9bEsirJUQQkC8fOfueJvDCBC5JNaDP84m4/ZJo317xRZGpsiM9/UkAEblXQM74tc
         j2ma/sBavbj+CQSNRQ+M7eRrSKODhCF/1MIvjMkNg5m9Qew63eSa1rvVJqlJa4uR7qRF
         WIyu33WG/BgGpSlY6V627ky11FfXJrpH4cccVDq2EmzyGfdQi37AOzNhIENFUaXzDFka
         lBJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJnQf4rDK1XUjsuCPRgB3ivh13vzUEhY0UGQkkWcBioKmef3wZ4zcPYsREGUEx6YtRY/J8F/+in3x2fS095A==@vger.kernel.org
X-Gm-Message-State: AOJu0YylAAxz8+cEAjBeuoLKjPXAgV9Z8dfhS26O7eGlVq/ZPBQzajQf
	a2xfiOLbllEXYvOtpwbHncc4jnJIE3c6TkrKaKQbq3wAtKOaDpT6HzJDORpgSqDIAZGQV/0/Gph
	eNfA9BufrpiZlhmZjtfjsUB/cImybxCm9jVnv2R3CnzciALHT/IoCfdU6fHw=
X-Google-Smtp-Source: AGHT+IHftrKMrTTSGzqUj80LQbx/Sw4Ni0j3ZJ0EH0D801cfx8flrI+Z6qha7+vbfgBhsav4aFAeqzkDxRL4IwAfFXa/ZAAOK1bT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2582:b0:3ed:256a:d680 with SMTP id
 e9e14a558f8ab-3ed256ad943mr216770355ab.13.1756404942663; Thu, 28 Aug 2025
 11:15:42 -0700 (PDT)
Date: Thu, 28 Aug 2025 11:15:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b09cce.050a0220.3db4df.006a.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in truncate_setsize (2)
From: syzbot <syzbot+0d26e9339d135e85c6e1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b6add54ba618 Merge tag 'pinctrl-v6.17-2' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120f7862580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e1e1566c7726877e
dashboard link: https://syzkaller.appspot.com/bug?extid=0d26e9339d135e85c6e1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14309c42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1198eef0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a4d47e89f4f4/disk-b6add54b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b1fec039895/vmlinux-b6add54b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5f14eb59c93e/bzImage-b6add54b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/de46bb7110d1/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d26e9339d135e85c6e1@syzkaller.appspotmail.com

INFO: task syz.0.19:6216 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.19        state:D stack:17448 pid:6216  tgid:6215  ppid:6040   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 io_schedule+0x81/0xe0 kernel/sched/core.c:7903
 folio_wait_bit_common+0x6b5/0xb90 mm/filemap.c:1317
 folio_lock include/linux/pagemap.h:1133 [inline]
 truncate_inode_pages_range+0x88d/0xb90 mm/truncate.c:433
 truncate_inode_pages mm/truncate.c:460 [inline]
 truncate_pagecache mm/truncate.c:769 [inline]
 truncate_setsize+0xcf/0xf0 mm/truncate.c:794
 bchfs_truncate+0x622/0xc20 fs/bcachefs/fs-io.c:488
 notify_change+0xb31/0xe60 fs/attr.c:552
 do_truncate+0x1a4/0x220 fs/open.c:68
 handle_truncate fs/namei.c:3508 [inline]
 do_open fs/namei.c:3891 [inline]
 path_openat+0x3078/0x3840 fs/namei.c:4046
 do_filp_open+0x1fa/0x410 fs/namei.c:4073
 do_sys_openat2+0x121/0x1c0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_open fs/open.c:1458 [inline]
 __se_sys_open fs/open.c:1454 [inline]
 __x64_sys_open+0x11e/0x150 fs/open.c:1454
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3c72b7ebe9
RSP: 002b:00007f3c721e6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f3c72da5fa0 RCX: 00007f3c72b7ebe9
RDX: 0000000000000040 RSI: 0000000000141242 RDI: 0000200000000140
RBP: 00007f3c72c01e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3c72da6038 R14: 00007f3c72da5fa0 R15: 00007ffee1b49c78
 </TASK>
INFO: task syz.0.19:6227 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.19        state:D stack:21432 pid:6227  tgid:6215  ppid:6040   task_flags:0x440140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 __bch2_two_state_lock+0x1ea/0x370 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x94f/0x1100 fs/bcachefs/fs-io-buffered.c:296
 read_pages+0x17a/0x580 mm/readahead.c:160
 page_cache_ra_unbounded+0x63b/0x740 mm/readahead.c:297
 filemap_readahead mm/filemap.c:2572 [inline]
 filemap_get_pages+0xaed/0x1df0 mm/filemap.c:2617
 filemap_splice_read+0x587/0xc60 mm/filemap.c:2991
 do_splice_read fs/splice.c:982 [inline]
 splice_direct_to_actor+0x4b1/0xcd0 fs/splice.c:1086
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x187/0x270 fs/splice.c:1230
 do_sendfile+0x4ec/0x7f0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3c72b7ebe9
RSP: 002b:00007f3c721c5038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f3c72da6090 RCX: 00007f3c72b7ebe9
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000005
RBP: 00007f3c72c01e19 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000e0000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f3c72da6128 R14: 00007f3c72da6090 R15: 00007ffee1b49c78
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/39:
 #0: ffffffff8d9a8b80 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8d9a8b80 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8d9a8b80 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
6 locks held by kworker/0:3/5224:
2 locks held by getty/5604:
 #0: ffff88823bf8c8a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e8b2e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x444/0x1410 drivers/tty/n_tty.c:2222
2 locks held by syz.0.19/6216:
 #0: ffff88801df4c488 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888057a89a38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff888057a89a38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
1 lock held by syz.0.19/6227:
 #0: ffff888057a89c08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff888057a89c08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
2 locks held by syz.1.30/6384:
 #0: ffff88803492a488 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888057a889b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff888057a889b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
1 lock held by syz.1.30/6395:
 #0: ffff888057a88b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff888057a88b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
1 lock held by syz.2.43/6582:
 #0: ffff888057a8bd08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff888057a8bd08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
2 locks held by syz.2.43/6593:
 #0: ffff888038354488 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff888057a8bb38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff888057a8bb38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
1 lock held by syz.3.53/6736:
 #0: ffff88805d136648 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff88805d136648 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
2 locks held by syz.3.53/6747:
 #0: ffff88803c472488 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88805d136478 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff88805d136478 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
1 lock held by syz.4.58/6838:
 #0: ffff88805d134d88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff88805d134d88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
2 locks held by syz.4.58/6849:
 #0: ffff88803c40a488 (sb_writers#12){.+.+}-{0:0}, at: mnt_want_write+0x41/0x90 fs/namespace.c:557
 #1: ffff88805d134bb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock_killable include/linux/fs.h:874 [inline]
 #1: ffff88805d134bb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: do_truncate+0x171/0x220 fs/open.c:63
2 locks held by syz-executor/6853:
 #0: ffffffff8e43aa00 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8e43aa00 (&ops->srcu#2){.+.+}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8e43aa00 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250 net/core/rtnetlink.c:570
 #1: ffffffff8ecd1f38 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:80 [inline]
 #1: ffffffff8ecd1f38 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:341 [inline]
 #1: ffffffff8ecd1f38 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0x8db/0x1c70 net/core/rtnetlink.c:4056

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 39 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
 watchdog+0xf93/0xfe0 kernel/hung_task.c:491
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5224 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Workqueue: events_power_efficient neigh_periodic_work
RIP: 0010:__bfs kernel/locking/lockdep.c:1815 [inline]
RIP: 0010:__bfs_backwards kernel/locking/lockdep.c:1860 [inline]
RIP: 0010:check_irq_usage kernel/locking/lockdep.c:2796 [inline]
RIP: 0010:check_prev_add kernel/locking/lockdep.c:3169 [inline]
RIP: 0010:check_prevs_add kernel/locking/lockdep.c:3284 [inline]
RIP: 0010:validate_chain+0xfd7/0x2140 kernel/locking/lockdep.c:3908
Code: 25 ff 0f 00 00 39 05 24 41 61 11 73 06 89 05 1c 41 61 11 49 8b 04 24 48 89 de 48 39 e8 0f 84 33 fe ff ff 4c 89 68 30 48 8b 00 <48> 39 e8 75 f4 48 89 de e9 1f fe ff ff 48 c7 c7 50 91 87 8d 48 89
RSP: 0018:ffffc90003ba73e8 EFLAGS: 00000006
RAX: ffffffff958ff8e8 RBX: 00000000000003cd RCX: 0000000000000213
RDX: 0000000000000008 RSI: 00000000000003cd RDI: ffff8880349f0000
RBP: ffffffff929f16c8 R08: ffffc90003ba73b0 R09: 0000000000000020
R10: dffffc0000000000 R11: ffffffff819c6180 R12: ffffffff95817a08
R13: ffffffff959cddd8 R14: ffff8880349f0c10 R15: 0000000000000212
FS:  0000000000000000(0000) GS:ffff8881268c2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f00417400f6 CR3: 000000000d7a6000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 update_cfs_rq_load_avg kernel/sched/fair.c:4572 [inline]
 __update_blocked_fair kernel/sched/fair.c:9705 [inline]
 sched_balance_update_blocked_averages+0x524/0x1580 kernel/sched/fair.c:9811
 sched_balance_softirq+0xe1/0x1a0 kernel/sched/fair.c:12846
 handle_softirqs+0x22c/0x710 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 __local_bh_enable_ip+0x179/0x270 kernel/softirq.c:259
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 write_unlock_bh include/linux/rwlock_rt.h:134 [inline]
 neigh_periodic_work+0xc37/0xe90 net/core/neighbour.c:1040
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
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
