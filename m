Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A91F5F6
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 22:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715467585; cv=none; b=ojhRYKPa+XT8Nd+GphndQMr7JB9aNf7ceZ9vqgVJjsrcKL+Bo5odYuyAt1UYVgjVqJ2eW1VrQXRGnTa+0U6TOOgvNXP2s8hAZe1LGEXYl9ldGyplWEAP0/8Ie0088EO7to/ML7tZ7eeU6kOMG1Vbz4ssDEB5jPp7fFkPwTEoMBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715467585; c=relaxed/simple;
	bh=0/RLWK/Ne/VTSVkLzpsEdHoOVmbIOq2hnbTWA1OyjbA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f6eaL5DCtI3WKHVignfZJZrDCjoQ2o73KSm+0U1TDXYQBllpQelUJJQqUZRWk60SiZKboR7RHhKxl+IDzU2IOv2ELMqIXjjCZZu5IOJNx1aglSaCtW0+kwP2B/iIV0qZOuq+UJsnpH/7Ghit3ySWDq64hpfvSKjllgLWu5bl42M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1b97c1b19so252027639f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 15:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715467583; x=1716072383;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xinKgrj9cHjxMWFP4jMSh2ZpHyLjEx/GfcFiRmDQ03U=;
        b=YCrvS6Uv4uAN0xRReOkmCy6PQbog59dqYxQLCSWUyk2aAkeCvtV1fqPlDV2WabvNuF
         Ki2hHWwfn+qUL+QOfoO5fjBn7UHoX9iRAJGdkYdt7vMIw39EBmwckCwh3rfn8V4dFX9U
         RwtSfgQU68thDb+G/oqTWi66DiB7yjcS2y6bjSL5WN4W6PSPVFHnAf377BXW5+n3ZKMb
         S789ERrRb4+SMS1ktFLhNKATVdcxnShzg31ViH4YEjmvTe5znrdiXz0zYhO8AZNWlRT/
         hMUqHTiJN8hLDXoTV34dkJLU8X05zjCgPYRfZ/4VGxHh+SsolT+BFsD5HELuncu1TnGf
         hpqg==
X-Forwarded-Encrypted: i=1; AJvYcCWjQuKggYuHxp2e27FwU2/8ffZFstHaaXupraOC1Wda7h8XOJKM2GxJihPRlJGmATxd5GObGcezTlV/vREOEKdN+PF60kGyEECIBquj14k=
X-Gm-Message-State: AOJu0Ywp2t7zNeCiD7gcpGxhAl7eLBOKDwznGEMBJpBGtCg87iZUP5xU
	odR2SoAAVyv311eYtZcGPd5XFwcBqrXsW+Y5UJ0n7ZNBIJkCAZ9exeKl6jYCUzDarvKo0dTioMz
	KYC+aYZbhJv54gHHTX7dZcVAnnOXk7ZI9zO1NzAtzd6qWxkT4uE8xHnc=
X-Google-Smtp-Source: AGHT+IEy+5UramUsNGV4STb7GAAgkxo/OJsFZHyqQToyQTWQkjUPPcSu6Tp0vNzsVrsa2YgrkNqG6ESi978QDfvmn73rPj4UsJCm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8625:b0:488:59cc:eb54 with SMTP id
 8926c6da1cb9f-48958c05b8emr516637173.3.1715467583071; Sat, 11 May 2024
 15:46:23 -0700 (PDT)
Date: Sat, 11 May 2024 15:46:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e9b6ff0618356b26@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work
From: syzbot <syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cf87f46fd34d Merge tag 'drm-fixes-2024-05-11' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c8766c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d14c12b661fb43
dashboard link: https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1aa5ad92dfce/disk-cf87f46f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/67c336f7c1c7/vmlinux-cf87f46f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bb5b717bd2b8/bzImage-cf87f46f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com

INFO: task kworker/0:5:19779 blocked for more than 143 seconds.
      Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:5     state:D stack:28464 pid:19779 tgid:19779 ppid:2      flags:0x00004000
Workqueue: events_long bch2_fs_read_only_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5409 [inline]
 __schedule+0x17e8/0x4a50 kernel/sched/core.c:6746
 __schedule_loop kernel/sched/core.c:6823 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6838
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6895
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:393
 process_one_work kernel/workqueue.c:3267 [inline]
 process_scheduled_works+0xa12/0x17c0 kernel/workqueue.c:3348
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3429
 kthread+0x2f2/0x390 kernel/kthread.c:388
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/29:
 #0: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #0: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #0: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
2 locks held by kworker/u8:6/1095:
2 locks held by getty/4840:
 #0: ffff88802cc100a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031332f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2201
1 lock held by syz-fuzzer/5098:
5 locks held by syz-executor.4/19737:
3 locks held by kworker/0:5/19779:
 #0: ffff888015079148 ((wq_completion)events_long){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3242 [inline]
 #0: ffff888015079148 ((wq_completion)events_long){+.+.}-{0:0}, at: process_scheduled_works+0x8e0/0x17c0 kernel/workqueue.c:3348
 #1: ffffc9000cf67d00 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3243 [inline]
 #1: ffffc9000cf67d00 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_scheduled_works+0x91b/0x17c0 kernel/workqueue.c:3348
 #2: ffff88803de00278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:393
6 locks held by kworker/1:15/19807:
 #0: ffff88801beda548 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3242 [inline]
 #0: ffff88801beda548 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_scheduled_works+0x8e0/0x17c0 kernel/workqueue.c:3348
 #1: ffffc9000dfb7d00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3243 [inline]
 #1: ffffc9000dfb7d00 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_scheduled_works+0x91b/0x17c0 kernel/workqueue.c:3348
 #2: ffff88802374b190 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:990 [inline]
 #2: ffff88802374b190 (&dev->mutex){....}-{3:3}, at: hub_event+0x1fe/0x5150 drivers/usb/core/hub.c:5850
 #3: ffff88802374e518 (&port_dev->status_lock){+.+.}-{3:3}, at: usb_lock_port drivers/usb/core/hub.c:3207 [inline]
 #3: ffff88802374e518 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5419 [inline]
 #3: ffff88802374e518 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5662 [inline]
 #3: ffff88802374e518 (&port_dev->status_lock){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5822 [inline]
 #3: ffff88802374e518 (&port_dev->status_lock){+.+.}-{3:3}, at: hub_event+0x25b6/0x5150 drivers/usb/core/hub.c:5904
 #4: ffff888022fb6568 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect drivers/usb/core/hub.c:5420 [inline]
 #4: ffff888022fb6568 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_port_connect_change drivers/usb/core/hub.c:5662 [inline]
 #4: ffff888022fb6568 (hcd->address0_mutex){+.+.}-{3:3}, at: port_event drivers/usb/core/hub.c:5822 [inline]
 #4: ffff888022fb6568 (hcd->address0_mutex){+.+.}-{3:3}, at: hub_event+0x25f4/0x5150 drivers/usb/core/hub.c:5904
 #5: ffffffff8ef0a6b0 (ehci_cf_port_reset_rwsem){.+.+}-{3:3}, at: hub_port_reset+0x1f8/0x1b30 drivers/usb/core/hub.c:3022
2 locks held by syz-executor.3/21870:
2 locks held by syz-executor.5/21874:
2 locks held by syz-executor.1/21881:

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 29 Comm: khungtaskd Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xfde/0x1020 kernel/hung_task.c:380
 kthread+0x2f2/0x390 kernel/kthread.c:388
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 21874 Comm: syz-executor.5 Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:native_save_fl arch/x86/include/asm/irqflags.h:32 [inline]
RIP: 0010:arch_local_save_flags arch/x86/include/asm/irqflags.h:67 [inline]
RIP: 0010:arch_local_irq_save arch/x86/include/asm/irqflags.h:103 [inline]
RIP: 0010:lock_release+0x16d/0x9f0 kernel/locking/lockdep.c:5770
Code: eb 03 42 80 3c 3b 00 74 08 4c 89 f7 e8 ac 09 88 00 4c 89 6c 24 50 48 c7 84 24 b0 00 00 00 00 00 00 00 9c 8f 84 24 b0 00 00 00 <42> 80 3c 3b 00 74 08 4c 89 f7 e8 94 08 88 00 48 8b 9c 24 b0 00 00
RSP: 0018:ffffc9000bb0f680 EFLAGS: 00000246
RAX: 0000000000000000 RBX: 1ffff92001761ee6 RCX: ffffffff8172abb0
RDX: 0000000000000000 RSI: ffffffff8c1f8240 RDI: ffffffff8c1f8200
RBP: ffffc9000bb0f7b0 R08: ffffffff8fa8f92f R09: 1ffffffff1f51f25
R10: dffffc0000000000 R11: fffffbfff1f51f26 R12: 1ffff92001761edc
R13: ffffffff81cbece7 R14: ffffc9000bb0f730 R15: dffffc0000000000
FS:  00007f5fc8c356c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fadd80ffe00 CR3: 00000000553c2000 CR4: 0000000000350ef0
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 rcu_lock_release include/linux/rcupdate.h:339 [inline]
 rcu_read_unlock include/linux/rcupdate.h:814 [inline]
 filemap_get_entry+0x457/0x4e0 mm/filemap.c:1834
 shmem_get_folio_gfp+0x2a8/0x1f50 mm/shmem.c:1982
 shmem_get_folio mm/shmem.c:2160 [inline]
 shmem_write_begin+0x170/0x4d0 mm/shmem.c:2744
 generic_perform_write+0x324/0x640 mm/filemap.c:3974
 shmem_file_write_iter+0xfc/0x120 mm/shmem.c:2920
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa86/0xcb0 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5fc7e7caaf
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 b9 80 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 0c 81 02 00 48
RSP: 002b:00007f5fc8c34e80 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000001000000 RCX: 00007f5fc7e7caaf
RDX: 0000000001000000 RSI: 00007f5fbdc00000 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000009855
R10: 0000000000000002 R11: 0000000000000293 R12: 0000000000000004
R13: 00007f5fc8c34f80 R14: 00007f5fc8c34f40 R15: 00007f5fbdc00000
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
