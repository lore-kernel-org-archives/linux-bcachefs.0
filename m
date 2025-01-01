Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469AA17548
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 20:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735762348; cv=none; b=bGtfZ6dNxOOTrP6SIDb8yh1Inh7xTPHgd5i3WktUADPIjymWMCztKwEMToiT/D4rEMqtnmWs4QctLd9rFR1ddItv5EmE+FncmeXm72B08FhcSpIh5dFTWZYLl69QMqCFDfj9WpwqXd0kBZVig0ZPIkMNVCindTw++2sOgsME/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735762348; c=relaxed/simple;
	bh=bkEZ/SoDQst3Ln8Qnhkzw7+8MEGF0H+r5j9iDaOGdqg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AOSRU9PIUI8ObPtobZ+NiCG8Znl80YSqjCv/EKY0YHch+3zniLNDz+bxg0YDE9ND/sXH7HVuUrd8A3gFjjAUgqHYXo/q65C5WGci/DeaAEp9mWvkZsiZMqJ6vf8YpmvSI3f9b+cmQ7t6llXMQ1RiZLlBBLk85vw7E0yzwRUJOT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso104296615ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 12:12:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735762345; x=1736367145;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l99j8oa2D1Xw+B89NdtF6/MRXB1PsInU8qH2KI9Px1U=;
        b=Lf/7d/ngZ26CMAbKGOVU1PomshDkLy9H4i3nIg5Sd3jEXlWNJbYf8T8V/DT31Sz7Wo
         m5U7fmAmo/GsPRaGEfzfwUL1+nmr5CTSGZIE8Ex3G52/YK9Inccw7hc8V4nQxjSkFQax
         znRtxjiEQUjnT0iksZbOW72pa0PGYc9uRcCjVldRYkuSIqo/AJRAVwEHQf9q9WAuaRp1
         iS/a3jn7zuNVRAfd1Fx7FW1KRHnN5bnaZYWZixmZ4QZaXRfRsxYPBnnzRpO/ej3OVJvI
         Kpv4rGF/Ub38KeIXCHJaGeBzuLK9qzykQfvcB8nav8iVBtkUePPQfBK7wxcAGejBck1S
         Nh9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXCgfykkKViKSZE9NrONO9xEX9PiZ9zBgJj5ea3aHb3Zlc6jRSl2EkD/rTH+u7VAJ3lJijgMiozMYdUtkuAKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yykt2z8pozuj81W3ZthQsyJpp3BQ+bZhrPLZupf1qSGpPyJ6QI/
	edIigidGH3JU/yaOZMFkpzai0Ib2RgteH2L1cqFvMsdS6tidza0Ko/Zchhl3VJifdmb7Og8xIhP
	Jk0x2CD3aJtGa4bFwh3hCu3MbzYVWhlZQNOxT32IJlmq6e+9hHZpsGRA=
X-Google-Smtp-Source: AGHT+IFvzJMjDxWRRNCy9WE7xBCIVZUuw9uYZLsHJ302cfmcbN90A8GEEtUtiOjKnaV4byr0dwHoptXEwm9EG/3MrR79kq5PvXA0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b24:b0:3a7:8270:3e69 with SMTP id
 e9e14a558f8ab-3c2d514ff6cmr379996545ab.15.1735762345422; Wed, 01 Jan 2025
 12:12:25 -0800 (PST)
Date: Wed, 01 Jan 2025 12:12:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6775a1a9.050a0220.3a8527.002b.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bchfs_fallocate (2)
From: syzbot <syzbot+20254ae9982bc25a0dc7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8155b4ef3466 Add linux-next specific files for 20241220
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16914af8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c90bb7161a56c88
dashboard link: https://syzkaller.appspot.com/bug?extid=20254ae9982bc25a0dc7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=170cd0b0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e432c4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/98a974fc662d/disk-8155b4ef.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2dea9b72f624/vmlinux-8155b4ef.xz
kernel image: https://storage.googleapis.com/syzbot-assets/593a42b9eb34/bzImage-8155b4ef.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6a0c6a4d1204/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+20254ae9982bc25a0dc7@syzkaller.appspotmail.com

INFO: task syz-executor210:6087 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor210 state:D stack:24704 pid:6087  tgid:6048  ppid:5829   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5371 [inline]
 __schedule+0x189f/0x4c80 kernel/sched/core.c:6758
 __schedule_loop kernel/sched/core.c:6835 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6850
 io_schedule+0x8d/0x110 kernel/sched/core.c:7683
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1309
 folio_lock include/linux/pagemap.h:1172 [inline]
 truncate_inode_pages_range+0xc1f/0x10e0 mm/truncate.c:380
 bchfs_fallocate+0x2d1/0x730 fs/bcachefs/fs-io.c:756
 bch2_fallocate_dispatch+0x3ac/0x540 fs/bcachefs/fs-io.c:809
 vfs_fallocate+0x623/0x7a0 fs/open.c:338
 do_vfs_ioctl+0x258c/0x2e40 fs/ioctl.c:885
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl+0x80/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a9fb35589
RSP: 002b:00007f4a9faca168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4a9fbc26d8 RCX: 00007f4a9fb35589
RDX: 0000000020000180 RSI: 0000000040305839 RDI: 0000000000000006
RBP: 00007f4a9fbc26d0 R08: 00007f4a9faca6c0 R09: 0000000000000000
R10: 00007f4a9faca6c0 R11: 0000000000000246 R12: 00007f4a9fbc26dc
R13: 000000000000006e R14: 00007ffc05424e00 R15: 00007ffc05424ee8
 </TASK>
INFO: task syz-executor210:6091 blocked for more than 144 seconds.
      Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor210 state:D stack:25936 pid:6091  tgid:6048  ppid:5829   flags:0x00000006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5371 [inline]
 __schedule+0x189f/0x4c80 kernel/sched/core.c:6758
 __schedule_loop kernel/sched/core.c:6835 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6850
 __bch2_two_state_lock+0x229/0x2c0 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x9e1/0x1240 fs/bcachefs/fs-io-buffered.c:272
 read_pages+0x179/0x570 mm/readahead.c:161
 page_cache_ra_order+0x7ee/0xba0 mm/readahead.c:504
 page_cache_sync_readahead include/linux/pagemap.h:1413 [inline]
 filemap_get_pages+0x605/0x2080 mm/filemap.c:2528
 filemap_splice_read+0x68e/0xef0 mm/filemap.c:2904
 do_splice_read fs/splice.c:985 [inline]
 splice_direct_to_actor+0x4af/0xc80 fs/splice.c:1089
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 vfs_copy_file_range+0xd1f/0x14f0 fs/read_write.c:1620
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a9fb35589
RSP: 002b:00007f4a9faa9158 EFLAGS: 00000212 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f4a9fbc26e8 RCX: 00007f4a9fb35589
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f4a9fbc26e0 R08: 0000000000000080 R09: 0000000000000000
R10: 0000000020000280 R11: 0000000000000212 R12: 00007f4a9fbc26ec
R13: 000000000000006e R14: 00007ffc05424e00 R15: 00007ffc05424ee8
 </TASK>

Showing all locks held in the system:
1 lock held by pool_workqueue_/3:
1 lock held by ksoftirqd/0/16:
 #0: ffff8880b863e998 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
1 lock held by khungtaskd/30:
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
2 locks held by getty/5585:
 #0: ffff88814dc4d0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by syz-executor210/6087:
 #0: ffff8880297ba420 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3012 [inline]
 #0: ffff8880297ba420 (sb_writers#10){.+.+}-{0:0}, at: vfs_fallocate+0x59d/0x7a0 fs/open.c:337
 #1: ffff8880731bb670 (&sb->s_type->i_mutex_key#15){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:863 [inline]
 #1: ffff8880731bb670 (&sb->s_type->i_mutex_key#15){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x1e2/0x540 fs/bcachefs/fs-io.c:800
1 lock held by syz-executor210/6091:
 #0: ffff8880731bb810 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:918 [inline]
 #0: ffff8880731bb810 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x325/0xba0 mm/readahead.c:480
1 lock held by syz-executor210/10791:
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: apply_wqattrs_lock kernel/workqueue.c:5170 [inline]
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa55/0x1f20 kernel/workqueue.c:5724
1 lock held by syz-executor210/10793:
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: apply_wqattrs_lock kernel/workqueue.c:5170 [inline]
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa55/0x1f20 kernel/workqueue.c:5724
1 lock held by syz-executor210/10795:
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: apply_wqattrs_lock kernel/workqueue.c:5170 [inline]
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa55/0x1f20 kernel/workqueue.c:5724
1 lock held by syz-executor210/10797:
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: apply_wqattrs_lock kernel/workqueue.c:5170 [inline]
 #0: ffffffff8e7e2e88 (wq_pool_mutex){+.+.}-{4:4}, at: __alloc_workqueue+0xa55/0x1f20 kernel/workqueue.c:5724

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 10791 Comm: syz-executor210 Not tainted 6.13.0-rc3-next-20241220-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:19 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:87 [inline]
RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:123 [inline]
RIP: 0010:lock_release+0x175/0xa30 kernel/locking/lockdep.c:5866
Code: f7 e8 3f ec 8a 00 48 c7 c0 10 77 e4 93 49 39 06 0f 84 ee 04 00 00 4c 8d b4 24 b0 00 00 00 4c 89 f3 48 c1 eb 03 42 80 3c 3b 00 <74> 08 4c 89 f7 e8 01 ed 8a 00 4c 89 6c 24 50 48 c7 84 24 b0 00 00
RSP: 0018:ffffc90000007760 EFLAGS: 00000046
RAX: ffffffff93e47710 RBX: 1ffff92000000f02 RCX: ffffffff819ab2c0
RDX: 0000000000000000 RSI: ffffffff8c5fece0 RDI: ffffffff8c5feca0
RBP: ffffc900000078a0 R08: ffffffff901ab1f7 R09: 1ffffffff203563e
R10: dffffc0000000000 R11: fffffbfff203563f R12: 1ffff92000000ef8
R13: ffffffff819875fd R14: ffffc90000007810 R15: dffffc0000000000
FS:  00007f4a9faeb6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a98294000 CR3: 000000003352a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 do_write_seqcount_end include/linux/seqlock.h:522 [inline]
 psi_group_change+0xae5/0x1190 kernel/sched/psi.c:867
 psi_task_change+0xed/0x270 kernel/sched/psi.c:912
 psi_enqueue kernel/sched/stats.h:162 [inline]
 enqueue_task+0x2b4/0x330 kernel/sched/core.c:2070
 activate_task kernel/sched/core.c:2110 [inline]
 ttwu_do_activate+0x1d1/0x760 kernel/sched/core.c:3722
 ttwu_queue kernel/sched/core.c:3995 [inline]
 try_to_wake_up+0x89b/0x1470 kernel/sched/core.c:4323
 call_timer_fn+0x187/0x650 kernel/time/timer.c:1793
 expire_timers kernel/time/timer.c:1844 [inline]
 __run_timers kernel/time/timer.c:2418 [inline]
 __run_timer_base+0x66a/0x8e0 kernel/time/timer.c:2430
 run_timer_base kernel/time/timer.c:2439 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2449
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 [inline]
RIP: 0010:vprintk_emit+0x700/0xa10 kernel/printk/printk.c:2431
Code: 00 e8 f4 c7 20 00 4c 8d bc 24 a0 00 00 00 4d 85 e4 75 07 e8 e2 c7 20 00 eb 06 e8 db c7 20 00 fb 49 bc 00 00 00 00 00 fc ff df <48> c7 c7 60 37 81 8e 31 f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00
RSP: 0018:ffffc90003747140 EFLAGS: 00000293
RAX: ffffffff819e5c45 RBX: 0000000000000000 RCX: ffff888079b8da00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003747250 R08: ffffffff819e5c1e R09: 1ffffffff285af23
R10: dffffc0000000000 R11: fffffbfff285af24 R12: dffffc0000000000
R13: 1ffff920006e8e2c R14: ffffffff819e5a80 R15: ffffc900037471e0
 bch2_print_maybe_redirect fs/bcachefs/super.c:117 [inline]
 __bch2_print+0x17a/0x220 fs/bcachefs/super.c:136
 bch2_fs_online+0x240/0x860 fs/bcachefs/super.c:690
 bch2_fs_alloc fs/bcachefs/super.c:946 [inline]
 bch2_fs_open+0x2cec/0x2d60 fs/bcachefs/super.c:2055
 bch2_fs_get_tree+0x738/0x1740 fs/bcachefs/fs.c:2187
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3556
 do_mount fs/namespace.c:3896 [inline]
 __do_sys_mount fs/namespace.c:4107 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4084
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a9fb369da
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a9faeafd8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f4a9faeaff0 RCX: 00007f4a9fb369da
RDX: 00000000200000c0 RSI: 0000000020000180 RDI: 00007f4a9faeaff0
RBP: 0000000000000004 R08: 00007f4a9faeb030 R09: 00000000000059d0
R10: 0000000000000010 R11: 0000000000000282 R12: 00007f4a9faeb030
R13: 0000000000000010 R14: 0000000000000003 R15: 0000000001000000
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
