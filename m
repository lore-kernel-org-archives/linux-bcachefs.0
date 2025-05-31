Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E01C3C04
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748729428; cv=none; b=QnX5bPD2YrVdoX99UxBUeCRvMi0NVRMxElEVZrgOplQim5p96HGEw8NNK7FTmp5QGMt70Z+Cu5Sz97ddCeS2LLL+gRfrtwyHFsk7mp2TTPb5hzy976bwHa9OJdhV8jJc86L3XlAhpuEFhvH0zpp+VMFtHpgyze70BeNm7yFjOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748729428; c=relaxed/simple;
	bh=oIifjk9L5QF7cdQ+XWkmh2JHuGfNZAgRYDBR5Us6Z2w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=sHizMVZm/4GpnxFkO+H4B00xjlQM27+ChoY7iuuQPbGgmMvWlTfDbJSyaaZoqBpU+HlWaZAtsoc5j9kQDt2AU93dDPrTaiMX+wIfrTkkowasiYoIjqyvZDQ7fCM2qTs5QuRJZxgaNVo9hDlvZxcT/3edp6rfByjTNmTszHR/dSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3dd78bfeac0so31554785ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 15:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748729425; x=1749334225;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hXfmHIYcMulUPoPBdwKUNqqRuhUli24eZSQwojohek=;
        b=qZNAlEkmOYH2wEw+RbOi63AdlUYkY29pJgiprnHw3U/RZpcwCvF91ROk0JwEzbTXSq
         AynJH1sj5IyNmWN2+05EHrMTcaO7pwPTCDolMaQFKJL2vGJeGtFIC5D0kUkq+5Ckqy+5
         2BrGIep6R/UyLGqNeXmuUEMxjaJ3Lz6vGrWjRZ/RTWn0wUJuAz5OPuEywIOO0Qsk+rbE
         fgBXyX9jDNSMMsXdhqMwjeMwlao95flMadFtC0gen+FR3q6j/LZwvfQnMpvsI75LoBwq
         X2D6AAcRcnXooObQpQ3ItJpWjaTBOG0JD5Dz4TRKryuQqNOmahg8/jqYCYMWLIMhS1rV
         wZMg==
X-Forwarded-Encrypted: i=1; AJvYcCV0tBvk9JOKZnqs+HyNq5WMwi+6w7N3bcBSkpU1mM9seNDfOzeIYVOjJ3NNQEqRcdZcVzKBYQ/sPc24V8hLlw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8MuMD4nMMgCl9/w52TcuXUYFOFnQ79RNWJWAfeB+6hnu7+Xz/
	/NzOCfhAD3+xb/xJr/+BJKSDRAO9xo710oDzINkR4p10RvvZxivoGrfCt8DwEr9284NfO2W74gF
	ohp+4/sotj4bABwnSp51+fU/5T/4EpXWwdAzzkLqNF4w+Zz5vkiJWVqWvVTg=
X-Google-Smtp-Source: AGHT+IEHzVR4yywyPwb1N0XQ9c7DucpF5p9l3koGqXg1enSSKId02DM0DHi3akeMAEjdCYjSYaRZXXICCywXQN/doBFV6ZAyx4z6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1687:b0:3db:7c22:303c with SMTP id
 e9e14a558f8ab-3dd9c9936d5mr70331245ab.8.1748729425643; Sat, 31 May 2025
 15:10:25 -0700 (PDT)
Date: Sat, 31 May 2025 15:10:25 -0700
In-Reply-To: <683447f8.a70a0220.29d4a0.0803.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683b7e51.a70a0220.1a6ae.000e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in start_poll_synchronize_rcu_expedited
From: syzbot <syzbot+cbc79a37b5fa23efd23b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    0f70f5b08a47 Merge tag 'pull-automount' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ea200c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=22765942f2e2ebcf
dashboard link: https://syzkaller.appspot.com/bug?extid=cbc79a37b5fa23efd23b
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134b1970580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4af859a809ab/disk-0f70f5b0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d3df10c6aa23/vmlinux-0f70f5b0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3a2d5f44d739/bzImage-0f70f5b0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f623992a9c46/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cbc79a37b5fa23efd23b@syzkaller.appspotmail.com

ODEBUG: object ffffc90003387b90 is on stack ffffc90003380000, but NOT annotated.
======================================================
WARNING: possible circular locking dependency detected
6.15.0-syzkaller-09161-g0f70f5b08a47 #0 Not tainted
------------------------------------------------------
bch-copygc/loop/6108 is trying to acquire lock:
ffffffff8e130e00 (console_owner){....}-{0:0}, at: console_trylock_spinning kernel/printk/printk.c:2048 [inline]
ffffffff8e130e00 (console_owner){....}-{0:0}, at: vprintk_emit+0x444/0x7a0 kernel/printk/printk.c:2449

but task is already holding lock:
ffffffff99c79a98 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_object_init+0x85/0x3c0 lib/debugobjects.c:741

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&obj_hash[i].lock){-.-.}-{2:2}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
       debug_object_activate+0xbb/0x420 lib/debugobjects.c:818
       debug_work_activate kernel/workqueue.c:664 [inline]
       insert_work+0x35/0x330 kernel/workqueue.c:2180
       __queue_work+0xcfc/0xfe0 kernel/workqueue.c:2341
       queue_work_on+0x181/0x270 kernel/workqueue.c:2392
       queue_work include/linux/workqueue.h:662 [inline]
       start_poll_synchronize_rcu_expedited+0xfc/0x140 kernel/rcu/tree_exp.h:1075
       rcu_init+0x108/0x160 kernel/rcu/tree.c:4854
       start_kernel+0x1fb/0x500 init/main.c:990
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:307
       x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:288
       common_startup_64+0x13e/0x147

-> #3 (&pool->lock){-.-.}-{2:2}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
       _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
       __queue_work+0x7b0/0xfe0 kernel/workqueue.c:-1
       queue_work_on+0x181/0x270 kernel/workqueue.c:2392
       queue_work include/linux/workqueue.h:662 [inline]
       rpm_suspend+0xe54/0x1720 drivers/base/power/runtime.c:673
       __pm_runtime_idle+0x12f/0x1a0 drivers/base/power/runtime.c:1112
       pm_runtime_put include/linux/pm_runtime.h:470 [inline]
       __device_attach+0x342/0x400 drivers/base/dd.c:1047
       bus_probe_device+0x185/0x260 drivers/base/bus.c:537
       device_add+0x7b6/0xb50 drivers/base/core.c:3692
       serial_base_port_add+0x2f2/0x430 drivers/tty/serial/serial_base_bus.c:179
       serial_core_port_device_add drivers/tty/serial/serial_core.c:3342 [inline]
       serial_core_register_port+0x367/0x2700 drivers/tty/serial/serial_core.c:3381
       serial8250_register_8250_port+0x16dc/0x2050 drivers/tty/serial/8250/8250_core.c:822
       serial_pnp_probe+0x527/0x790 drivers/tty/serial/8250/8250_pnp.c:480
       pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
       call_driver_probe drivers/base/dd.c:-1 [inline]
       really_probe+0x26a/0x9a0 drivers/base/dd.c:657
       __driver_probe_device+0x18c/0x2f0 drivers/base/dd.c:799
       driver_probe_device+0x4f/0x430 drivers/base/dd.c:829
       __driver_attach+0x452/0x700 drivers/base/dd.c:1215
       bus_for_each_dev+0x230/0x2b0 drivers/base/bus.c:370
       bus_add_driver+0x345/0x640 drivers/base/bus.c:678
       driver_register+0x23a/0x320 drivers/base/driver.c:249
       serial8250_init+0xc2/0x1c0 drivers/tty/serial/8250/8250_platform.c:315
       do_one_initcall+0x233/0x820 init/main.c:1257
       do_initcall_level+0x137/0x1f0 init/main.c:1319
       do_initcalls+0x69/0xd0 init/main.c:1335
       kernel_init_freeable+0x3d9/0x570 init/main.c:1567
       kernel_init+0x1d/0x1d0 init/main.c:1457
       ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #2 (&dev->power.lock){-.-.}-{3:3}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
       __pm_runtime_resume+0x10f/0x180 drivers/base/power/runtime.c:1179
       pm_runtime_get include/linux/pm_runtime.h:418 [inline]
       __uart_start+0x171/0x440 drivers/tty/serial/serial_core.c:148
       uart_write+0x278/0xa40 drivers/tty/serial/serial_core.c:635
       process_output_block drivers/tty/n_tty.c:561 [inline]
       n_tty_write+0xd32/0x11d0 drivers/tty/n_tty.c:2377
       iterate_tty_write drivers/tty/tty_io.c:1015 [inline]
       file_tty_write+0x4fe/0x990 drivers/tty/tty_io.c:1090
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x54b/0xa90 fs/read_write.c:686
       ksys_write+0x145/0x250 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&port_lock_key){-.-.}-{3:3}:
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
       _raw_spin_lock_irqsave+0xa7/0xf0 kernel/locking/spinlock.c:162
       uart_port_lock_irqsave include/linux/serial_core.h:715 [inline]
       serial8250_console_write+0x17e/0x1ba0 drivers/tty/serial/8250/8250_port.c:3415
       console_emit_next_record kernel/printk/printk.c:3138 [inline]
       console_flush_all+0x728/0xc40 kernel/printk/printk.c:3226
       __console_flush_and_unlock kernel/printk/printk.c:3285 [inline]
       console_unlock+0xc4/0x270 kernel/printk/printk.c:3325
       vprintk_emit+0x5b7/0x7a0 kernel/printk/printk.c:2450
       _printk+0xcf/0x120 kernel/printk/printk.c:2475
       register_console+0xa8b/0xf90 kernel/printk/printk.c:4125
       univ8250_console_init+0x52/0x90 drivers/tty/serial/8250/8250_core.c:513
       console_init+0x1a1/0x670 kernel/printk/printk.c:4323
       start_kernel+0x2cc/0x500 init/main.c:1034
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:307
       x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:288
       common_startup_64+0x13e/0x147

-> #0 (console_owner){....}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3168 [inline]
       check_prevs_add kernel/locking/lockdep.c:3287 [inline]
       validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
       __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
       lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
       console_trylock_spinning kernel/printk/printk.c:2048 [inline]
       vprintk_emit+0x460/0x7a0 kernel/printk/printk.c:2449
       _printk+0xcf/0x120 kernel/printk/printk.c:2475
       debug_object_is_on_stack lib/debugobjects.c:-1 [inline]
       lookup_object_or_alloc lib/debugobjects.c:688 [inline]
       __debug_object_init+0x2c8/0x3c0 lib/debugobjects.c:743
       rhashtable_init_noprof+0x7c0/0xbb0 lib/rhashtable.c:1085
       bch2_copygc_thread+0x116/0xdc0 fs/bcachefs/movinggc.c:355
       kthread+0x711/0x8a0 kernel/kthread.c:464
       ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  console_owner --> &pool->lock --> &obj_hash[i].lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&obj_hash[i].lock);
                               lock(&pool->lock);
                               lock(&obj_hash[i].lock);
  lock(console_owner);

 *** DEADLOCK ***

1 lock held by bch-copygc/loop/6108:
 #0: ffffffff99c79a98 (&obj_hash[i].lock){-.-.}-{2:2}, at: __debug_object_init+0x85/0x3c0 lib/debugobjects.c:741

stack backtrace:
CPU: 1 UID: 0 PID: 6108 Comm: bch-copygc/loop Not tainted 6.15.0-syzkaller-09161-g0f70f5b08a47 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_circular_bug+0x2ee/0x310 kernel/locking/lockdep.c:2046
 check_noncircular+0x134/0x160 kernel/locking/lockdep.c:2178
 check_prev_add kernel/locking/lockdep.c:3168 [inline]
 check_prevs_add kernel/locking/lockdep.c:3287 [inline]
 validate_chain+0xb9b/0x2140 kernel/locking/lockdep.c:3911
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5240
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5871
 console_trylock_spinning kernel/printk/printk.c:2048 [inline]
 vprintk_emit+0x460/0x7a0 kernel/printk/printk.c:2449
 _printk+0xcf/0x120 kernel/printk/printk.c:2475
 debug_object_is_on_stack lib/debugobjects.c:-1 [inline]
 lookup_object_or_alloc lib/debugobjects.c:688 [inline]
 __debug_object_init+0x2c8/0x3c0 lib/debugobjects.c:743
 rhashtable_init_noprof+0x7c0/0xbb0 lib/rhashtable.c:1085
 bch2_copygc_thread+0x116/0xdc0 fs/bcachefs/movinggc.c:355
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 1 PID: 6108 at lib/debugobjects.c:655 debug_object_is_on_stack lib/debugobjects.c:655 [inline]
WARNING: CPU: 1 PID: 6108 at lib/debugobjects.c:655 lookup_object_or_alloc lib/debugobjects.c:688 [inline]
WARNING: CPU: 1 PID: 6108 at lib/debugobjects.c:655 __debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
Modules linked in:
CPU: 1 UID: 0 PID: 6108 Comm: bch-copygc/loop Not tainted 6.15.0-syzkaller-09161-g0f70f5b08a47 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:debug_object_is_on_stack lib/debugobjects.c:655 [inline]
RIP: 0010:lookup_object_or_alloc lib/debugobjects.c:688 [inline]
RIP: 0010:__debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
Code: cc cc cc 41 ff c7 44 89 3d 14 aa 17 15 48 c7 c1 00 9b e1 8b 48 c7 c7 60 9b e1 8b 84 c0 48 0f 45 f9 48 89 de e8 48 e5 68 fc 90 <0f> 0b 90 e9 c0 fe ff ff e8 3a 1c 00 00 8b 05 8c f3 cc 09 3b 05 8a
RSP: 0018:ffffc900033876e0 EFLAGS: 00010046
RAX: 0000000000000050 RBX: ffffc90003387b90 RCX: f040b7745b5f4c00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffff88802c68bc20 R08: ffffffff8e130da3 R09: 1ffffffff1c261b4
R10: dffffc0000000000 R11: fffffbfff1c261b5 R12: 0000000000000040
R13: ffff8880622786c8 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888125d99000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbb648c56d0 CR3: 000000007f3f6000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rhashtable_init_noprof+0x7c0/0xbb0 lib/rhashtable.c:1085
 bch2_copygc_thread+0x116/0xdc0 fs/bcachefs/movinggc.c:355
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
