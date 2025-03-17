Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E2824887E
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742225494; cv=none; b=iErXxh7KLzE7xPLS9pemGSwOWyKJyBn5ZrIs7g72UdnaH+RxS2hYJENUy30uZdrw+eBWCHtzUK2p05GUne88K0ilHSdArQMUedMQ67wAyHpyN3oILfgAKNysFO4SBpG1pglFqs1A0bQeRBW7v0NwmVIyp1PunVT4dXF03YZkyWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742225494; c=relaxed/simple;
	bh=a9tOcJvICKfwQlzKQ1Gg+cqvgcLxdfWCM9qRpztJ3Do=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lpieXfrg2II6LeTEe7QXPMGku7R5AXyeQPUr2XH+LhCZrEhbOhILj1wzeNQ10mOnobtjJht3i64aVFDVuF0Oyw+jSp+tKnz2UY5/ibuiiHze5YffjXBC7XQvg6sKPWO/KfBdq6Z3le0H1y6KvJ+lmt98PKo2gDMZb25lBe+Kd1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ce843b51c3so128776475ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 08:31:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742225491; x=1742830291;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHF9CFj0CyBGv7pEPhPrZdGlspc1yKnU78g2f2aMVsQ=;
        b=R8boBroefDCbQK/i2wf55QGnIQe310PIv1ZZwwAVSmNiuufOzh0K1VMABFK8/a/2Yx
         9PvlzEzY3vGacfu0opO6kmIKzGSHOElM4vzXSLgkCQfHJ1PaHSkieAS6nfp8Qx0aFw75
         f23xf22ielvgQfANzwxBq7lj7V3BG6X8cQVknKNAdiLxqab3UyPZdOmXYFcmxcU3Almv
         AdW3DkotpkHm4yJyWiWIjfYxXHUDLEfb+X6f9MLeaq40R/WJzUfbg1JcKmdirF5JjzEu
         1V5twxWHWXEREg43AQ6hbNYB/mqFuD4DgB3M0iZuzoeY9UDzvj8Cub6vMKmIeKW4laqj
         01rg==
X-Forwarded-Encrypted: i=1; AJvYcCW8+8mdN+gLYxoPZfiaIuXyQO91l/xcy9uSdeztA+uQEIipDZAOfJGLssJYutZGb5UOHRtMCBZbopyGefwc2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeTKk3VtNLqiBOArTPR0dyPbE1GpVxerxbpYFj6AHJLZHK8tjY
	E8l5fk9DPwMPSS+c/96YtOIwdbuH2MfmvouGBImoupyt74pmuavOrgnpjYPocSOd+pmey6SKzR2
	tos259XbV/lGHHkN88ADAgc7Fuh4gM2JNaFiqBl+OH+PrZW2wRBpflb0=
X-Google-Smtp-Source: AGHT+IEz5reQvm0Vb1hMjH4/SkesiyYrQ5DriHUUtBLTwR8e78WsdmrC1+vzx8HEZaEHPbe852f8z0XWv0k3XOxWi11meivgzgPw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174c:b0:3d4:337f:121b with SMTP id
 e9e14a558f8ab-3d57b9c1425mr3446125ab.8.1742225490602; Mon, 17 Mar 2025
 08:31:30 -0700 (PDT)
Date: Mon, 17 Mar 2025 08:31:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d84052.050a0220.3657bb.0006.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in __closure_sync_timeout (2)
From: syzbot <syzbot+77e39767e330b03df7af@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eb88e6bfbc0a Merge tag 'fsnotify_for_v6.14-rc7' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=176d83b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb44f62cb82f8a0a
dashboard link: https://syzkaller.appspot.com/bug?extid=77e39767e330b03df7af
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1583bff8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=119c7698580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-eb88e6bf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dd1bfa9979b6/vmlinux-eb88e6bf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5dce0ab6f758/bzImage-eb88e6bf.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/78f15ca8a908/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+77e39767e330b03df7af@syzkaller.appspotmail.com

INFO: task kworker/u4:6:1037 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00212-geb88e6bfbc0a #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u4:6    state:D stack:19128 pid:1037  tgid:1037  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x190e/0x4c90 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0x15a/0x290 kernel/time/sleep_timeout.c:99
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1728
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:237 [inline]
 bch2_btree_update_start+0x1200/0x1540 fs/bcachefs/btree_update_interior.c:1254
 bch2_btree_node_rewrite+0x1ba/0x1230 fs/bcachefs/btree_update_interior.c:2144
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2217 [inline]
 async_btree_node_rewrite_work+0x3fb/0xf60 fs/bcachefs/btree_update_interior.c:2253
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task syz-executor848:5323 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00212-geb88e6bfbc0a #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor848 state:D stack:17200 pid:5323  tgid:5323  ppid:5322   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x190e/0x4c90 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0x15a/0x290 kernel/time/sleep_timeout.c:99
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1728
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:237 [inline]
 bch2_btree_update_start+0x1200/0x1540 fs/bcachefs/btree_update_interior.c:1254
 bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1853
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x8105/0x9790 fs/bcachefs/btree_trans_commit.c:1089
 bch2_trans_commit fs/bcachefs/btree_update.h:191 [inline]
 bch2_journal_replay+0x221b/0x2b10 fs/bcachefs/recovery.c:406
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb3b77fe2a
RSP: 002b:00007ffceb5721e8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffceb572200 RCX: 00007feb3b77fe2a
RDX: 0000400000000040 RSI: 0000400000000000 RDI: 00007ffceb572200
RBP: 0000400000000000 R08: 00007ffceb572240 R09: 0000000000005900
R10: 0000000000800000 R11: 0000000000000282 R12: 0000400000000040
R13: 00007ffceb572240 R14: 0000000000000003 R15: 0000000000800000
 </TASK>
INFO: task bch-reclaim/loo:5332 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc6-syzkaller-00212-geb88e6bfbc0a #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:22864 pid:5332  tgid:5332  ppid:2      task_flags:0x200840 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x190e/0x4c90 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0x15a/0x290 kernel/time/sleep_timeout.c:99
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1728
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:237 [inline]
 bch2_btree_update_start+0x1200/0x1540 fs/bcachefs/btree_update_interior.c:1254
 bch2_btree_split_leaf+0x121/0x880 fs/bcachefs/btree_update_interior.c:1853
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x8105/0x9790 fs/bcachefs/btree_trans_commit.c:1089
 bch2_trans_commit fs/bcachefs/btree_update.h:191 [inline]
 bch2_btree_write_buffer_flush_locked+0x4b12/0x5570 fs/bcachefs/btree_write_buffer.c:452
 btree_write_buffer_flush_seq+0x1c49/0x1e10 fs/bcachefs/btree_write_buffer.c:570
 bch2_btree_write_buffer_journal_flush+0xc7/0x150 fs/bcachefs/btree_write_buffer.c:586
 journal_flush_pins+0x89b/0xe40 fs/bcachefs/journal_reclaim.c:589
 __bch2_journal_reclaim+0x789/0xda0 fs/bcachefs/journal_reclaim.c:722
 bch2_journal_reclaim_thread+0x17a/0x570 fs/bcachefs/journal_reclaim.c:764
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/26:
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
4 locks held by kworker/u4:6/1037:
 #0: ffff88804085c148 ((wq_completion)btree_node_rewrite){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff88804085c148 ((wq_completion)btree_node_rewrite){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
 #1: ffffc9000252fc60 ((work_completion)(&a->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc9000252fc60 ((work_completion)(&a->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
 #2: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #2: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #2: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x9a/0x1a0 fs/bcachefs/btree_iter.c:3225
 #3: ffff8880448a66d0 (&c->gc_lock){.+.+}-{4:4}, at: bch2_btree_update_start+0x680/0x1540 fs/bcachefs/btree_update_interior.c:1182
2 locks held by getty/5105:
 #0: ffff8880003510a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000019b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
3 locks held by syz-executor848/5323:
 #0: ffff888044880278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_start+0x45/0x610 fs/bcachefs/super.c:1010
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x9a/0x1a0 fs/bcachefs/btree_iter.c:3225
 #2: ffff8880448a66d0 (&c->gc_lock){.+.+}-{4:4}, at: bch2_btree_update_start+0x680/0x1540 fs/bcachefs/btree_update_interior.c:1182
4 locks held by bch-reclaim/loo/5332:
 #0: ffff8880448cb028 (&j->reclaim_lock){+.+.}-{4:4}, at: bch2_journal_reclaim_thread+0x16d/0x570 fs/bcachefs/journal_reclaim.c:763
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #1: ffff888044884378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3408
 #2: ffff888044884720 (&wb->flushing.lock){+.+.}-{4:4}, at: btree_write_buffer_flush_seq+0x1c3f/0x1e10 fs/bcachefs/btree_write_buffer.c:569
 #3: ffff8880448a66d0 (&c->gc_lock){.+.+}-{4:4}, at: bch2_btree_update_start+0x680/0x1540 fs/bcachefs/btree_update_interior.c:1182

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted 6.14.0-rc6-syzkaller-00212-geb88e6bfbc0a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:236 [inline]
 watchdog+0x1058/0x10a0 kernel/hung_task.c:399
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
