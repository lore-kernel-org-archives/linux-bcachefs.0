Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37F9111A8
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Aug 2025 02:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485489; cv=none; b=tVbTWW/sJji3kwsH0l1YHovrohtL70ZtNsPLyOMSSkmFS5r81J6u4VvToKYjfQ/ZBvKzzvuFl8FNq9rX/HeCYdXn95IW0xLBfOVDrnBvhVr7cNBumLoyFa1nyigA/jVLhosvRBtb+6UrxOKFQjd8h1m4cp18zo3zAV0jzH7CTbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485489; c=relaxed/simple;
	bh=zGPNhia5mulCJUUAaQihqHAOPp/31yRSzl25zKoPYFg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ZGA8VYUQnZZLALCF7NoGebDX4BJowZg00uHabi7kvI+BwTZGpe6nWaiN3YAa3+Wh0N10WtDC1JmLIfVph1LGtKjKp5UJQj/5ULEi3RmwO1RelRnq7ovZYeLEZwW7KIH5lyb9Uphcw44io2WNqaZyr1btAh1NwQBP0FDYMIPUZRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88432e3c4ffso399638739f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 17 Aug 2025 19:51:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755485487; x=1756090287;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e4o/cOKlJzDW0KLKKJzyDWLe4z4qJv/hHqlCpRPUX/U=;
        b=vWoQbLTd6a/jZaqFld7qmQI28R5J+OI0eH6fXVCQoymu57ndfD5+K/wOP4vPE/gJZO
         Unx3MmFiKqIZNDMxGzTdgRnA4MDcVT6S+W7Tb2lO9qbkMcuaHa7id1iGAT+uclapTKkA
         8JUWzy7bBxz4Jyzz7/fbEfX54V1rpetm/H0vF9X9aYGEK3hHprg4nOjGszV6vjd3nP0v
         ZhUPosiwzkZb9fEb8UmKeIFjuHpEkY0o0W5gNcl3jElVJmcXNiQF0eD/EMLNvQzzGIcs
         y1sVATUbhmwEXSQdyhfuOoL3fsmAiTLAmhIqRdBo3UNAUIUyCm+O+gGX0tZxvAHFYaw0
         KdQA==
X-Forwarded-Encrypted: i=1; AJvYcCUsZQVXAmQrdas5Jfp4hOyZkPiQia6fM85eHmK6w86NCdXRqJsRcjxGer3uC1JkFn3na3TOjzu+xpa5GnUzcg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwxdDnqwKNzjaGjMy8JUeN/mGCdzXfiNPwALTBKqGSveH5ggdNG
	zZBiKApLSBORrPbHMltQLZmt34FYRBA19Hy+do+vJnW/9pZzSyEU928PtEWBNHFjmiiMTZm4BeZ
	G6IjJ7NLp+7N+bT0s+uNByEtfzP49XYl4LvUn7e+DuDaMOwjU/tdOKpgVoTw=
X-Google-Smtp-Source: AGHT+IEZlVR4ig7U58KLgYHb/VMg1Xbvkiya7m8reUy54F9uVcrytnNwD6vV+7rduM38Tp8RFwarpDZ9wGalquq0ZONhWGpm7jzC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1549:b0:884:1ddb:2ca9 with SMTP id
 ca18e2360f4ac-8843e35bbfamr1806019139f.1.1755485486923; Sun, 17 Aug 2025
 19:51:26 -0700 (PDT)
Date: Sun, 17 Aug 2025 19:51:26 -0700
In-Reply-To: <67f2bf20.050a0220.0a13.0270.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a2952e.050a0220.e29e5.0083.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work (2)
From: syzbot <syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8d561baae505 Merge tag 'x86_urgent_for_v6.17_rc2' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164606f0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=98e114f4eb77e551
dashboard link: https://syzkaller.appspot.com/bug?extid=674ccd0645d379ed5f80
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12e66ba2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12c29234580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/595e1e4d6418/disk-8d561baa.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ab14cc587702/vmlinux-8d561baa.xz
kernel image: https://storage.googleapis.com/syzbot-assets/368a3a55dcfb/bzImage-8d561baa.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d34a76f45dd5/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com

INFO: task kworker/0:2:5165 blocked for more than 143 sec[  348.252664][   T38] INFO: task kworker/0:2:5165 blocked for more than 143 seconds.
      Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:2     state:D stack:19368 pid:5165  tgid:5165  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: events_long bch2_fs_read_only_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 rt_mutex_schedule+0x77/0xf0 kernel/sched/core.c:7339
 rt_mutex_slowlock_block kernel/locking/rtmutex.c:1647 [inline]
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1721 [inline]
 __rt_mutex_slowlock_locked+0x1e04/0x25e0 kernel/locking/rtmutex.c:1760
 rt_mutex_slowlock+0xb5/0x160 kernel/locking/rtmutex.c:1800
 __rt_mutex_lock kernel/locking/rtmutex.c:1815 [inline]
 rwbase_write_lock+0x14f/0x750 kernel/locking/rwbase_rt.c:244
 bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:408
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/0:3:5894 blocked for more than 143 seconds.
      Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:3     state:D stack:19368 pid:5894  tgid:5894  ppid:2      task_flags:0x4208060 flags:0x00004000
Workqueue: events_long bch2_fs_read_only_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 rt_mutex_schedule+0x77/0xf0 kernel/sched/core.c:7339
 rt_mutex_slowlock_block kernel/locking/rtmutex.c:1647 [inline]
 __rt_mutex_slowlock kernel/locking/rtmutex.c:1721 [inline]
 __rt_mutex_slowlock_locked+0x1e04/0x25e0 kernel/locking/rtmutex.c:1760
 rt_mutex_slowlock+0xb5/0x160 kernel/locking/rtmutex.c:1800
 __rt_mutex_lock kernel/locking/rtmutex.c:1815 [inline]
 rwbase_write_lock+0x14f/0x750 kernel/locking/rwbase_rt.c:244
 bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:408
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz.3.29:6306 blocked for more than 143 seconds.
      Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.29        state:D stack:22952 pid:6306  tgid:6256  ppid:5968   task_flags:0x400140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 __closure_sync+0x163/0x220 lib/closure.c:146
 closure_sync include/linux/closure.h:195 [inline]
 bch2_dev_allocator_remove+0x7ad/0x9c0 fs/bcachefs/alloc_background.c:2651
 __bch2_dev_read_only fs/bcachefs/super.c:1705 [inline]
 bch2_dev_remove+0x504/0x13a0 fs/bcachefs/super.c:1792
 bch2_ioctl_disk_remove+0x130/0x170 fs/bcachefs/chardev.c:226
 bch2_fs_ioctl+0xb41/0x1920 fs/bcachefs/chardev.c:730
 bch2_fs_file_ioctl+0x564/0x1dd0 fs/bcachefs/fs-ioctl.c:411
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5de5d0ebe9
RSP: 002b:00007f5de5355038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f5de5f36090 RCX: 00007f5de5d0ebe9
RDX: 00002000000000c0 RSI: 000000004010bc05 RDI: 0000000000000004
RBP: 00007f5de5d91e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5de5f36128 R14: 00007f5de5f36090 R15: 00007fffe9406a88
 </TASK>
INFO: task syz.1.37:6366 blocked for more than 143 seconds.
      Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.37        state:D stack:15976 pid:6366  tgid:6364  ppid:5967   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 __closure_sync+0x163/0x220 lib/closure.c:146
 closure_sync include/linux/closure.h:195 [inline]
 bch2_dev_allocator_remove+0x7ad/0x9c0 fs/bcachefs/alloc_background.c:2651
 __bch2_dev_read_only fs/bcachefs/super.c:1705 [inline]
 bch2_dev_remove+0x504/0x13a0 fs/bcachefs/super.c:1792
 bch2_ioctl_disk_remove+0x130/0x170 fs/bcachefs/chardev.c:226
 bch2_fs_ioctl+0xb41/0x1920 fs/bcachefs/chardev.c:730
 bch2_fs_file_ioctl+0x564/0x1dd0 fs/bcachefs/fs-ioctl.c:411
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbae6e3ebe9
RSP: 002b:00007fbae64ae038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbae7065fa0 RCX: 00007fbae6e3ebe9
RDX: 00002000000000c0 RSI: 000000004010bc05 RDI: 0000000000000004
RBP: 00007fbae6ec1e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbae7066038 R14: 00007fbae7065fa0 R15: 00007ffc4fe142e8
 </TASK>
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 38 Comm: khungtaskd Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
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
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 8017 Comm: syz.2.386 Tainted: G        W           6.17.0-rc1-syzkaller-00224-g8d561baae505 #0 PREEMPT_{RT,(full)} 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:xas_clear_mark+0x28/0x530 lib/xarray.c:-1
Code: 90 90 f3 0f 1e fa 55 41 57 41 56 41 55 41 54 53 48 83 ec 18 89 74 24 04 48 89 fb 49 bd 00 00 00 00 00 fc ff df e8 b8 1e ca f6 <48> 89 5c 24 08 48 8d 7b 18 48 89 f8 48 c1 e8 03 42 80 3c 28 00 74
RSP: 0018:ffffc900060df4a8 EFLAGS: 00000293
RAX: ffffffff8af43c88 RBX: ffffc900060df580 RCX: ffff888091b5bb80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed101341a6d0 R12: 0000000000000001
R13: dffffc0000000000 R14: ffff88806492a638 R15: dffffc0000000000
FS:  00007f86571066c0(0000) GS:ffff8881269c5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1deed16000 CR3: 000000003e458000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 xas_init_marks+0x6c/0xc0 lib/xarray.c:955
 page_cache_delete mm/filemap.c:142 [inline]
 __filemap_remove_folio+0x3cf/0x500 mm/filemap.c:224
 filemap_remove_folio+0xe6/0x200 mm/filemap.c:253
 truncate_inode_folio+0x5d/0x70 mm/truncate.c:176
 shmem_undo_range+0x3a9/0x14b0 mm/shmem.c:1153
 shmem_truncate_range mm/shmem.c:1269 [inline]
 shmem_evict_inode+0x272/0xa70 mm/shmem.c:1397
 evict+0x504/0x9c0 fs/inode.c:810
 __dentry_kill+0x209/0x660 fs/dcache.c:669
 dput+0x19f/0x2b0 fs/dcache.c:911
 __fput+0x69d/0xa80 fs/file_table.c:476
 fput_close_sync+0x119/0x200 fs/file_table.c:573
 __do_sys_close fs/open.c:1587 [inline]
 __se_sys_close fs/open.c:1572 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1572
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8657a9d84a
Code: 48 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c 24 0c e8 43 91 02 00 8b 7c 24 0c 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 36 89 d7 89 44 24 0c e8 a3 91 02 00 8b 44 24
RSP: 002b:00007f8657105e00 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f8657a9d84a
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000010 R08: 0000000000000000 R09: 00000000000059da
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 00007f8657105ef0 R14: 00007f8657106668 R15: 00007f864ece6000
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
