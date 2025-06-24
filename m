Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD862E3391
	for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 19:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750791693; cv=none; b=CzCqbD88UaT+o0y1ZZ7t0yAcACqzbkc4evJXiDBCybpC8MvYT8h0hc1Gq7Bl5LEwvExlUN/3fKFjUmEFICo/v1d4ztRFJ/HiDC+L0D8vM1ak08tiFwJW1PmxjAJXs1VNaU5H6csK+UjbDi0kP3fytuOknLGR7dHtBpxsKJ/ufKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750791693; c=relaxed/simple;
	bh=gQrsZ6cbCSheM3s3g9NTPcxAKFrp0SQJTjtk3nAmW0M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mER5/zThR/mQgpSCzWRenADKINfM7kIjhWCBaSMWnmlJKJR34rIYKjfWhN7qQfZujPYo0Gd/NNkUOUO5+b+/jgywlu/j9/mUTPDhbD3Tc6jX+XPIYoHvH7c74RZwIXWtNKxj+5bewvkXnjpLHmoLyU12XoE7qFcSSvHo2BTjBnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddbb34fc1cso8257215ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 24 Jun 2025 12:01:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750791691; x=1751396491;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mtlz5ofTzO3wu2UN4ywLnWkYLIKY82uy6DD9VJfkzpk=;
        b=C3Aa6gjLOE8sg8mPovOsEOQNpHew5uVaBUqmmeCdWxjI8ShUleKwZI8ZdnbIj+grzc
         uJIXuVkLxh3M8MhcHPI8qiJFpkB+8R3V7Oqkd26K9dREG2xq4Jn5/JiJM0D7LfTdYtpp
         TzqoFY230k95V5Arqd4crGnq5VDY1ffWjod4iIQN++j7fjii4nQHJuVg21vWiacFk7kW
         TEWVpMS8LOpZ5p058lqovy9jRPZUGxinEarR9KwwhknJ6QPl9T40MGnr1YiJeEtDDNUb
         Rcu9fliOmi04HgGuANT6bm5exB72ksPlaidoUZ1ABDXniYZLfPvGAnBZ9QHrvWmXIkaw
         FOQg==
X-Forwarded-Encrypted: i=1; AJvYcCXnN9WK6njEdzYJpZBjykwh4nAKITMC+O+qnuTRNXrMDz8QsCJsTAMqvLX6cD4dctFimfA0N1RnucY0+7bCiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYl92mFAx601J4Bn1uLOwA3s7nGBntADkRjXMr150zXU/aabPe
	ygE7bWI1LWnyskAShJxjvzw+iggMRGKucCmc0/V6m7RTiXpNv0P3x1txZ6/HFhpGoygkb7dZc2H
	vKe+2FkBOUKUzAKNVy8i+vlWDYiA253gYdeM5jwhiompAndskUU9MiIHTRNw=
X-Google-Smtp-Source: AGHT+IFyb8M9vekjwXTjQgI8c53CcdZPyxPaJNsCinG/aQL08FdH0OkGSF1t2ElCNxvdkkznR6ILRJadZ6Q0y+vzbO+M0T7rC0cR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3283:b0:3dc:8bb8:28b3 with SMTP id
 e9e14a558f8ab-3df3287f015mr2611865ab.5.1750791690919; Tue, 24 Jun 2025
 12:01:30 -0700 (PDT)
Date: Tue, 24 Jun 2025 12:01:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <685af60a.a00a0220.2e5631.0093.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bchfs_fpunch (2)
From: syzbot <syzbot+d25751466d56160d8892@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b67ec639010f Merge tag 'i2c-for-6.16-rc3' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15e46182580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a237c32900fc479
dashboard link: https://syzkaller.appspot.com/bug?extid=d25751466d56160d8892
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c46b0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1243db0c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dbd84edd9de7/disk-b67ec639.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/388ad319d5bf/vmlinux-b67ec639.xz
kernel image: https://storage.googleapis.com/syzbot-assets/961e022f7367/bzImage-b67ec639.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0c8167f99e04/mount_0.gz

The issue was bisected to:

commit e14e06e91dadcd1c65f08ba5a02716d3e855fc74
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Apr 20 15:27:18 2025 +0000

    bcachefs: __bch2_fs_read_write() no longer depends on io_ref

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12636182580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11636182580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16636182580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d25751466d56160d8892@syzkaller.appspotmail.com
Fixes: e14e06e91dad ("bcachefs: __bch2_fs_read_write() no longer depends on io_ref")

INFO: task syz-executor198:6265 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor198 state:D stack:27144 pid:6265  tgid:6239  ppid:5854   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 io_schedule+0x81/0xe0 kernel/sched/core.c:7723
 folio_wait_bit_common+0x6b0/0xb90 mm/filemap.c:1317
 folio_lock include/linux/pagemap.h:1114 [inline]
 truncate_inode_pages_range+0xa77/0xda0 mm/truncate.c:433
 bchfs_fpunch+0x1d8/0x520 fs/bcachefs/fs-io.c:570
 bch2_fallocate_dispatch+0x2bc/0x410 fs/bcachefs/fs-io.c:838
 vfs_fallocate+0x6a0/0x830 fs/open.c:341
 ksys_fallocate fs/open.c:365 [inline]
 __do_sys_fallocate fs/open.c:370 [inline]
 __se_sys_fallocate fs/open.c:368 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:368
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd2b7703d79
RSP: 002b:00007fd2b768f218 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fd2b778a6d8 RCX: 00007fd2b7703d79
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00007fd2b778a6d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000404042bbe R11: 0000000000000246 R12: 00007fd2b7756ba4
R13: 0000200000000040 R14: 0031656c69662f2e R15: 00002000000005c0
 </TASK>
INFO: task syz-executor198:6269 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor198 state:D stack:26872 pid:6269  tgid:6239  ppid:5854   task_flags:0x440040 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5396 [inline]
 __schedule+0x16a2/0x4cb0 kernel/sched/core.c:6785
 __schedule_loop kernel/sched/core.c:6863 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6878
 __bch2_two_state_lock+0x1ea/0x370 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x94f/0x1100 fs/bcachefs/fs-io-buffered.c:296
 read_pages+0x177/0x580 mm/readahead.c:160
 page_cache_ra_order+0xa24/0xc70 mm/readahead.c:515
 filemap_get_pages+0x43c/0x1ea0 mm/filemap.c:2602
 filemap_splice_read+0x4fc/0xbc0 mm/filemap.c:2990
 do_splice_read fs/splice.c:979 [inline]
 splice_direct_to_actor+0x4a9/0xcc0 fs/splice.c:1083
 do_splice_direct_actor fs/splice.c:1201 [inline]
 do_splice_direct+0x181/0x270 fs/splice.c:1227
 do_sendfile+0x4da/0x7e0 fs/read_write.c:1370
 __do_sys_sendfile64 fs/read_write.c:1431 [inline]
 __se_sys_sendfile64+0x13e/0x190 fs/read_write.c:1417
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd2b7703d79
RSP: 002b:00007fd2b766e218 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007fd2b778a6e8 RCX: 00007fd2b7703d79
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007fd2b778a6e0 R08: 00007ffd4f811977 R09: 0000000000000000
R10: 000000000e3aa6ea R11: 0000000000000246 R12: 00007fd2b7756ba4
R13: 0000200000000040 R14: 0031656c69662f2e R15: 00002000000005c0
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e13ee60 (rcu_read_lock){....}-{1:3}
, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
2 locks held by getty/5582:
 #0: ffff8880358620a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x43e/0x1400 drivers/tty/n_tty.c:2222
2 locks held by syz-executor198/5856:
3 locks held by syz-executor198/5857:
 #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: __super_lock fs/super.c:57 [inline]
 #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: __super_lock_excl fs/super.c:72 [inline]
 #0: ffff88803537c0e0 (&type->s_umount_key#43){+.+.}-{4:4}, at: deactivate_super+0xa9/0xe0 fs/super.c:506
 #1: ffff8880a2380278 (&c->state_lock){+.+.}-{4:4}, at: __bch2_fs_stop+0xf8/0x900 fs/bcachefs/super.c:677
 #2: ffffffff8e144978 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:304 [inline]
 #2: ffffffff8e144978 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:998
2 locks held by syz-executor198/6265:
 #0: ffff888076150428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff888076150428 (sb_writers#9){.+.+}-{0:0}, at: vfs_fallocate+0x62a/0x830 fs/open.c:340
 #1: ffff888078499fa8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff888078499fa8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x10e/0x410 fs/bcachefs/fs-io.c:827
1 lock held by syz-executor198/6269:
 #0: ffff88807849a148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff88807849a148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
2 locks held by syz-executor198/7079:
 #0: ffff888028336428 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3096 [inline]
 #0: ffff888028336428 (sb_writers#9){.+.+}-{0:0}, at: vfs_fallocate+0x62a/0x830 fs/open.c:340
 #1: ffff88807dd5d4d0 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:869 [inline]
 #1: ffff88807dd5d4d0 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x10e/0x410 fs/bcachefs/fs-io.c:827
1 lock held by syz-executor198/7080:
 #0: ffff88807dd5d670 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #0: ffff88807dd5d670 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x445/0xc70 mm/readahead.c:491
1 lock held by syz-executor198/9504:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xfee/0x1030 kernel/hung_task.c:470
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5857 Comm: syz-executor198 Not tainted 6.16.0-rc2-syzkaller-00378-gb67ec639010f #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:nearest_obj mm/slab.h:331 [inline]
RIP: 0010:kasan_record_aux_stack+0x62/0xd0 mm/kasan/generic.c:542
Code: c2 0f 85 81 00 00 00 4c 8b 71 08 48 89 ce 48 2b 35 2b 09 97 0b 48 c1 e6 06 48 03 35 10 09 97 0b 48 89 d8 48 29 f0 41 8b 7e 18 <48> 89 c2 48 c1 ea 20 74 07 48 99 48 f7 ff eb 04 31 d2 f7 f7 48 29
RSP: 0018:ffffc90000007ab0 EFLAGS: 00000002
RAX: 00000000000002d0 RBX: ffff8880247b82d0 RCX: ffffea000091ee00
RDX: fffffffde89b8200 RSI: ffff8880247b8000 RDI: 0000000000000800
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff817451d8
R10: dffffc0000000000 R11: fffffbfff3399595 R12: dffffc0000000000
R13: ffff88801a49cc00 R14: ffff88801a441dc0 R15: ffff8880b86395e0
FS:  000055555795f3c0(0000) GS:ffff888125c85000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5a35185000 CR3: 00000000723be000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 insert_work+0x3d/0x330 kernel/workqueue.c:2183
 __queue_work+0xcfc/0xfe0 kernel/workqueue.c:2341
 call_timer_fn+0x17b/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1793 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x646/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 __do_softirq kernel/softirq.c:613 [inline]
 invoke_softirq kernel/softirq.c:453 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:680
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:696
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1050
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:console_trylock_spinning kernel/printk/printk.c:2061 [inline]
RIP: 0010:vprintk_emit+0x58f/0x7a0 kernel/printk/printk.c:2449
Code: 85 32 01 00 00 e8 91 62 1f 00 41 89 df 4d 85 f6 48 8b 1c 24 75 07 e8 80 62 1f 00 eb 06 e8 79 62 1f 00 fb 48 c7 c7 e0 30 13 8e <31> f6 ba 01 00 00 00 31 c9 41 b8 01 00 00 00 45 31 c9 53 e8 b9 36
RSP: 0018:ffffc900043f7820 EFLAGS: 00000293
RAX: ffffffff81a0e9a7 RBX: ffffffff81a0e864 RCX: ffff88802904da00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff8e1330e0
RBP: ffffc900043f7930 R08: ffffffff8f9fe0f7 R09: 1ffffffff1f3fc1e
R10: dffffc0000000000 R11: fffffbfff1f3fc1f R12: dffffc0000000000
R13: 1ffff9200087ef08 R14: 0000000000000200 R15: 0000000000000052
 bch2_print_maybe_redirect fs/bcachefs/super.c:137 [inline]
 __bch2_print+0x176/0x220 fs/bcachefs/super.c:156
 __bch2_fs_read_only+0x271/0x5b0 fs/bcachefs/super.c:300
 bch2_fs_read_only+0x42a/0xb00 fs/bcachefs/super.c:367
 __bch2_fs_stop+0x100/0x900 fs/bcachefs/super.c:678
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2618
 deactivate_locked_super+0xb9/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1417
 task_work_run+0x1d1/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:114
 exit_to_user_mode_prepare include/linux/entry-common.h:330 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:414 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:449 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd2b7704fd7
Code: 08 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd4f810968 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00000000000664e4 RCX: 00007fd2b7704fd7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd4f810a20
RBP: 00007ffd4f810a20 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007ffd4f811ae0
R13: 0000555557960700 R14: 431bde82d7b634db R15: 00007ffd4f811a84
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
