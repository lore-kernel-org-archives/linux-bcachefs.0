Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C7F22AE76
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Jul 2025 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753813176; cv=none; b=g+C+Hj5852YvJ+9S0xJwQ/o6V0LPYsQZiOrYnvZxWcBkQ8VOIp/tSspLb8mv+HONBmA0O74GHMhejwZP92p86GC2m6JcEYwfSCXljdXGJHH4c6IDgeypzJ5ClUdBuCj0+SQFmLDAzJl830A6+HR+ga4FwRkdHZgy7nBMKP/0Lfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753813176; c=relaxed/simple;
	bh=wpUlOwybmwMZ5+iQbeX5IpGD5/zT9tH9IX/TjdHjMBI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=V+lD/rBR/xsBcvUZh50KoftqhRcgE8dWiT2ZcYNrkzT+Eld1oqbBmAV4kgYFz2oB7IuxeL/Wrl0S3NZRgRbEX8pjzJahi1+B/r3lCkB1T2UqcpRZ4dz5iHvjlFBHI70F75PqsgIe13ebPKvBww4hH55Za/Z1LE1NUrqY8yJtXDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-87326a81ceaso15892139f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 29 Jul 2025 11:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753813173; x=1754417973;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDoCJCkPySBSG4VIhCf6u4oigoDGG+MZ0xFI3r4cOxI=;
        b=igfWK378+mL5wmR8nh/vNqu6osr6m4UMUedlTgZAzYznJSo9prjgHAc/3nds1PxmkM
         WPsUwy1Z74WPMhVme60rHzAKH/LyhWlmYD1K/J1iMnokKG5A2NKq/EkvMhvHhv6Ex+DR
         Ce2H0W6nvvc47GWnMxLHVfyQcWIpx9FbOAS6sYYM7DcEyYQn80qJGjfR53vwBAJ5HJRw
         JcrshPx0WbQagRLf18kZhgsu0fyPSouwBmGTW8e+2v4AoD5ZWdWu4NtD0HO0I1RFU9H6
         Zh9ecvvBqjrQ4CeuaTqaNMjibmYBkTOnZkybwdocZzTyowWNd/Tt0Cf21vtV5WFpK0UZ
         voKw==
X-Forwarded-Encrypted: i=1; AJvYcCUMD2x5bOPP3sjbkhu4mvBbptKRuQgrCvKhpH3UOGH9DJ5FvZLPofel0GDIbwTaY3KFHrJKruYIrO8ufPWqMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLtA0WO14rK9uRVIZ+0N6AvLlC09J/sPBcull8/usMUDNdHQZ2
	+gFeVZqwwwx3e2GQkc+o3U1M/dPAaw4UQ2O5fBH1ZC8cMgvRXE4EWvTaowUf8ankpg83Be9RPuu
	gV+1SdWzPCZBX5cJk5sxe5EIFjUTDeb8V4XI2P1cFEugO+p0vRnpnDCagpsM=
X-Google-Smtp-Source: AGHT+IHPctcsSm85/iVsXJRwOipgbdYxSmPDMzNzh12hRxt2kY76EbVt/k09cu43KBgqpugYcD4qzAR/OyrOooIJZGHgxshCIeD3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:718b:b0:87c:63cd:62a2 with SMTP id
 ca18e2360f4ac-8813744dfe1mr93183239f.1.1753813173441; Tue, 29 Jul 2025
 11:19:33 -0700 (PDT)
Date: Tue, 29 Jul 2025 11:19:33 -0700
In-Reply-To: <6879a305.a70a0220.693ce.0058.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688910b5.a00a0220.26d0e1.000c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_run_recovery_passes
From: syzbot <syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ae388edd4a8f Merge tag 'landlock-6.17-rc1' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15424cf0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8004f1b1e0ae8198
dashboard link: https://syzkaller.appspot.com/bug?extid=c2294ae43bae606e3c7d
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1583f034580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1038d4a2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/720dce21f23a/disk-ae388edd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a83240c628a9/vmlinux-ae388edd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1cabbf436747/bzImage-ae388edd.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2b16c3a29557/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com

INFO: task syz.4.23:6214 blocked for more than 143 seconds.
      Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.23        state:D stack:21160 pid:6214  tgid:6213  ppid:5960   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x165b/0x4c50 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6879
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 bch2_run_recovery_passes+0x177/0x210 fs/bcachefs/recovery_passes.c:609
 bch2_fs_recovery+0x28c9/0x3a50 fs/bcachefs/recovery.c:1050
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0774e9014a
RSP: 002b:00007f07740f5e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f07740f5ef0 RCX: 00007f0774e9014a
RDX: 0000200000000080 RSI: 00002000000001c0 RDI: 00007f07740f5eb0
RBP: 0000200000000080 R08: 00007f07740f5ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007f07740f5eb0 R14: 000000000000f628 R15: 00002000000000c0
 </TASK>
INFO: task syz.0.26:6216 blocked for more than 143 seconds.
      Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.26        state:D stack:21160 pid:6216  tgid:6215  ppid:5947   task_flags:0x40[  344.100863][   T38] task:syz.0.26        state:D stack:21160 pid:6216  tgid:6215  ppid:5947   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x165b/0x4c50 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6879
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 bch2_run_recovery_passes+0x177/0x210 fs/bcachefs/recovery_passes.c:609
 bch2_fs_recovery+0x28c9/0x3a50 fs/bcachefs/recovery.c:1050
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffbf91d014a
RSP: 002b:00007ffbf8435e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffbf8435ef0 RCX: 00007ffbf91d014a
RDX: 0000200000000080 RSI: 00002000000001c0 RDI: 00007ffbf8435eb0
RBP: 0000200000000080 R08: 00007ffbf8435ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007ffbf8435eb0 R14: 000000000000f628 R15: 00002000000000c0
 </TASK>
INFO: task syz.3.28:6241 blocked for more than 143 seconds.
      Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.28        state:D stack:21160 pid:6241  tgid:6240  ppid:5956   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x165b/0x4c50 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6879
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 bch2_run_recovery_passes+0x177/0x210 fs/bcachefs/recovery_passes.c:609
 bch2_fs_recovery+0x28c9/0x3a50 fs/bcachefs/recovery.c:1050
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f05843e014a
RSP: 002b:00007f058364de68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f058364def0 RCX: 00007f05843e014a
RDX: 0000200000000080 RSI: 00002000000001c0 RDI: 00007f058364deb0
RBP: 0000200000000080 R08: 00007f058364def0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007f058364deb0 R14: 000000000000f628 R15: 00002000000000c0
 </TASK>
INFO: task syz.1.30:6287 blocked for more than 143 seconds.
      Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.30        state:D stack:21160 pid:6287  tgid:6286  ppid:5950   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x165b/0x4c50 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6879
 schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:268 [inline]
 __down_common+0x319/0x6a0 kernel/locking/semaphore.c:293
 down+0x80/0xd0 kernel/locking/semaphore.c:100
 bch2_run_recovery_passes+0x177/0x210 fs/bcachefs/recovery_passes.c:609
 bch2_fs_recovery+0x28c9/0x3a50 fs/bcachefs/recovery.c:1050
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3e578b014a
RSP: 002b:00007f3e56b1de68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f3e56b1def0 RCX: 00007f3e578b014a
RDX: 0000200000000080 RSI: 00002000000001c0 RDI: 00007f3e56b1deb0
RBP: 0000200000000080 R08: 00007f3e56b1def0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000001c0
R13: 00007f3e56b1deb0 R14: 000000000000f628 R15: 00002000000000c0
 </TASK>

Showing all locks held in the system:
4 locks held by pr/legacy/17:
1 lock held by khungtaskd/38:
 #0: ffffffff8d9aa300 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8d9aa300 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8d9aa300 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6770
2 locks held by kworker/u8:5/1011:
2 locks held by getty/5582:
 #0: ffff88823bf4c8a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e932e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x444/0x1410 drivers/tty/n_tty.c:2222
3 locks held by kworker/1:5/6095:
1 lock held by udevd/6527:
3 locks held by udevd/6529:
3 locks held by syz.0.218/7187:
2 locks held by syz.4.219/7189:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 38 Comm: khungtaskd Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:158 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:307 [inline]
 watchdog+0xe9e/0xee0 kernel/hung_task.c:470
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 17 Comm: pr/legacy Tainted: G        W           6.16.0-syzkaller-01056-gae388edd4a8f #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:409
Code: e8 9e 32 83 fc 44 89 f9 d3 e3 49 83 ee 80 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 ef 14 e1 fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f e9 8a ad b9 05 cc 44 89 f9 80 e1 07
RSP: 0018:ffffc90000167890 EFLAGS: 00000202
RAX: 1ffffffff326fe00 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff9937f7d0 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff853b0150 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff9937f540 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881268fa000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed5ffff CR3: 0000000036c16000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:137 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:159 [inline]
 wait_for_lsr+0x1a7/0x2f0 drivers/tty/serial/8250/8250_port.c:2094
 fifo_wait_for_lsr drivers/tty/serial/8250/8250_port.c:3348 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3371 [inline]
 serial8250_console_write+0x11bd/0x1b40 drivers/tty/serial/8250/8250_port.c:3456
 console_emit_next_record kernel/printk/printk.c:3118 [inline]
 console_flush_all+0x695/0xcd0 kernel/printk/printk.c:3226
 __console_flush_and_unlock+0xa4/0x240 kernel/printk/printk.c:3285
 legacy_kthread_func+0x13b/0x1a0 kernel/printk/printk.c:3638
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
