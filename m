Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FAB2199FC1
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 13:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729603185; cv=none; b=ZjAR0tthlyuvP6Pup63LhgP3lq/RCIDMqLTmhWihKAA5qOo+On4cKkvbE5/4r2WkWhddMbPsxso9JoAyw6HJcTO5VBFH/H44HpbrtlO8k+v71OfIkL7UANQppG9ujZ2QKrQphWzAuaCIZzXqKSHnvfGqziuGwZb2oADIGPezqew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729603185; c=relaxed/simple;
	bh=jr3eYlepC/Pes/1AfQJbfbjR0BX88PLItLRx5Z8fEOg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KrJcPfLQBRMgcma+kZ/+L8SkpJz/OS3AIhjP+bpzAiuE0d1OZT+J60FMiB5jyfqLVgH/DkVBNfIdF7O1rk4PRAwcHvIbkNRIftG9RJ2tRcDmeZ8NR8w7rWno8Sv/OvMMfHCAdN2CsiI1zdUlddS4zUjiBPjnGIbuwrXaLzCVwvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3a5f6cb13so48469285ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 06:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729603183; x=1730207983;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21Stx3y9XlPMtEInUKq5l0Cb7mYtjf+MQaH/tk384o8=;
        b=LEuNDOsrAJ29HCeCn2JDA7Tn9Zp5fMnKxYFWgS77RsRLHNq/9iKg3SG1Y5rqDl7L23
         d3zaDb8fYpWSS1beUVBjj26xxEy2PffRV+qDZfPQGMUnVfeI4wkVO43KTkCWN2qsJbB9
         DaQm1ZefthlslTlJLX9On0nYfeE3LajcC3Ln2hweSSPKUnCro1/BgLGLqjxJht4ZbUpV
         QsE6r+jwULZWuBV8DwrXwDL/Xm1Wf3OGZsyLvw7ykB6jNRJ1U5+FJ+hwRnme2M2HxZ8d
         l0Ly8+H9i8D+igAhAVbHWV51Cu6kTIvFq80y36H1iEh5DsDqz2pJ50agmDsz+nEhXsVT
         uR8Q==
X-Forwarded-Encrypted: i=1; AJvYcCX3WGcvIyp6bI1yyKXClxFDloa80cpICHriz+KfQOPkSD8C9/UQq4ItjSVfqSm8Tb/8R7L2uvQwxQldGMUr6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsewLif8EG4v8zZ7SP09jlKeudVezLoBwV7LELRwDGBEugi8+D
	b5KNgOv42FryyUkX2yTmqZLbzroGbMI9PyCE51Vk6upOrbjZn2TNcML0lTpdAvuonO1T+JntneI
	B91mqYb1kySxP/8MR7D3ihkiorKG8usplfDqdMFMszN4DzWx9pIVf6Wg=
X-Google-Smtp-Source: AGHT+IEXnAMtJB8k2+7SxGiopBQQ0evOp4myMxFtrHgZA8QEz2z+1tc2ugqjpkn8cuCPk0EurX2U1128DwRHrvo48Rik05TMUkPM
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1564:b0:3a1:a3bd:adcc with SMTP id
 e9e14a558f8ab-3a3f405d07emr132573605ab.6.1729603182836; Tue, 22 Oct 2024
 06:19:42 -0700 (PDT)
Date: Tue, 22 Oct 2024 06:19:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6717a66e.050a0220.10f4f4.0127.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in __closure_sync_timeout
From: syzbot <syzbot+43d0c6eb00a26a41ec60@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10e58a5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41330fd2db03893d
dashboard link: https://syzkaller.appspot.com/bug?extid=43d0c6eb00a26a41ec60
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12265430580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1105c640580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d116f71ad0eb/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bdd6f545b105/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0d26b05e3d7c/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a2d3caf3a599/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+43d0c6eb00a26a41ec60@syzkaller.appspotmail.com

INFO: task kworker/0:2:937 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:17008 pid:937   tgid:937   ppid:2      flags:0x00004000
Workqueue: bcachefs_write_ref bch2_delete_dead_snapshots_work (bcachefs-delete-dead-snapshots/)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0x1be/0x310 kernel/time/timer.c:2615
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1799
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:239 [inline]
 bch2_btree_update_start+0x11a2/0x14e0 fs/bcachefs/btree_update_interior.c:1274
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_delete_dead_snapshots+0x19b6/0x5ae0 fs/bcachefs/snapshot.c:1643
 bch2_delete_dead_snapshots_work+0x34/0x40 fs/bcachefs/snapshot.c:1718
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task bch-reclaim/loo:5264 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:21976 pid:5264  tgid:5264  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0x1be/0x310 kernel/time/timer.c:2615
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1799
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:239 [inline]
 bch2_btree_update_start+0x11a2/0x14e0 fs/bcachefs/btree_update_interior.c:1274
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_btree_write_buffer_flush_locked+0x4f03/0x59f0 fs/bcachefs/btree_write_buffer.c:429
 btree_write_buffer_flush_seq+0x1a43/0x1bc0 fs/bcachefs/btree_write_buffer.c:510
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x789/0xdc0 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x174/0x560 fs/bcachefs/journal_reclaim.c:740
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task bch-copygc/loop:5265 blocked for more than 144 seconds.
      Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-copygc/loop state:D stack:18968 pid:5265  tgid:5265  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x185a/0x4b70 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_timeout+0x1be/0x310 kernel/time/timer.c:2615
 __closure_sync_timeout+0x2d8/0x450 lib/closure.c:217
 closure_sync_timeout include/linux/closure.h:206 [inline]
 __bch2_wait_on_allocator+0x11a/0x250 fs/bcachefs/alloc_foreground.c:1799
 bch2_wait_on_allocator fs/bcachefs/alloc_foreground.h:239 [inline]
 __bch2_write+0x56ad/0x5e30 fs/bcachefs/io_write.c:1504
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1634
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_data_update_read_done+0x22e/0x330 fs/bcachefs/data_update.c:424
 move_write fs/bcachefs/move.c:133 [inline]
 bch2_moving_ctxt_do_pending_writes+0x44c/0x8d0 fs/bcachefs/move.c:164
 bch2_move_ratelimit+0x76c/0xeb0 fs/bcachefs/move.c:492
 bch2_evacuate_bucket+0x2738/0x36a0 fs/bcachefs/move.c:702
 bch2_copygc+0x42db/0x4ca0 fs/bcachefs/movinggc.c:240
 bch2_copygc_thread+0x737/0xc20 fs/bcachefs/movinggc.c:381
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937e20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
4 locks held by kworker/0:2/937:
 #0: ffff88814479b548 ((wq_completion)bcachefs_write_ref){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88814479b548 ((wq_completion)bcachefs_write_ref){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900038ffd00 ((work_completion)(&c->snapshot_delete_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900038ffd00 ((work_completion)(&c->snapshot_delete_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #2: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #2: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x97/0x1a0 fs/bcachefs/btree_iter.c:3040
 #3: ffff888077fa66d0 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202
2 locks held by getty/4982:
 #0: ffff8880329220a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
4 locks held by bch-reclaim/loo/5264:
 #0: ffff888077fcb0a8 (&j->reclaim_lock){+.+.}-{3:3}, at: bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:739
 #1: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff888077f84398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3215
 #2: ffff888077f84740 (&wb->flushing.lock){+.+.}-{3:3}, at: btree_write_buffer_flush_seq+0x1a39/0x1bc0 fs/bcachefs/btree_write_buffer.c:509
 #3: ffff888077fa66d0 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5710 Comm: syz-executor101 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0033:0x7f4adf789ccb
Code: cd 48 01 c1 49 39 4f 08 72 4c 8d 4d ff 85 ed 74 33 66 0f 1f 44 00 00 48 39 f0 72 1b 4d 8b 07 49 89 c1 49 29 f1 47 0f b6 0c 08 <45> 84 c9 74 08 45 88 0c 00 49 8b 47 10 48 83 c0 01 49 89 47 10 83
RSP: 002b:00007ffde888de70 EFLAGS: 00000206
RAX: 000000000050ec64 RBX: 00007ffde888df10 RCX: 00000000000000bd
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 00007ffde888dfb0
RBP: 0000000000000102 R08: 00007f4ad7200000 R09: 0000000000000000
R10: 0000000000000000 R11: 00007ffde888df20 R12: 0000000000000001
R13: 00007f4adf80cc00 R14: 0000000000000000 R15: 00007ffde888dfb0
FS:  0000555591fa7380 GS:  0000000000000000


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
