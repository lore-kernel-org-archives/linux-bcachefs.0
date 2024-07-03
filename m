Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C10133406
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Jul 2024 06:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719989485; cv=none; b=TaYIRFkJ5Grp+63Qb2TI34T5kwxd2htFubr9q3fefAyECZfg5ESlgBxOkyBEfLgN1I1Rr6qet14HK5pQp0j+WhQhKTz6gO2NeRmN9mJ6SWUnPBlUfZXRKId7auvopjp5/oydzz4Oh6zmIT1AVA1FaM1wvUxdnHHDtmd69i8G3zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719989485; c=relaxed/simple;
	bh=0gxrIwBfgOkLA2MP1w3dmuq7b4IMVgpEWB0Tft9c1ds=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XncNrS9NXB97TkBwrdvBJ0F7yTCht8GUma0+bde2c3/PAviFFVmcBJzyxdMPJWGRu7gRd6Pb2tvA97/gALHIgiLjBy5heSehoizCb8y9std4qZDiwjEM1Lv6Mu5oYPHuDTSigWSo6kyQJZeFVW+M737GJQV/4JSn3aay2Z9UfB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7f12ee1959cso570062739f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 02 Jul 2024 23:51:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719989483; x=1720594283;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fOF3J9cxgd9Au7XFZ/LO/dwUzye9hanqe/SeaAyRY7s=;
        b=xQSD7JV46c3wUL+iqfS4XZaeFncuaXuz737B43XLGW/nIdJULXBOOSvUaeoNdjhLOX
         3mYp8wQNUpIpZ4/aPgjgtPf0e9ymnbwtAtS9GVHDlcJ3qranvFWQCWYbOEwkMH28Q+fP
         ddme43COAb1vjg7wgFt2qx0mn2kjhpVDZahE0U7z7yrniE0ZIpAI5dtGNHXfzfK7auJc
         y7gHdYTvJM26P/BL7GN4AtPOcR7BjBa2ypK1Q8AX9ArEb8IlCLfFTXgOwi7zUHS9cOQC
         s4Z3GYdLJ8n7PaXb/C22SuCrWleNihbPrupNmDuzxiP7WcMc9JKZBfObEd4GMCd97/ju
         elqw==
X-Forwarded-Encrypted: i=1; AJvYcCUZzD29hMZJCCLAVRAo9obow2IzgeFLrFqw0pXMPH/1i314VLojyl1RVysoLuMkQaiymlL9C2q7ntro9yJmhFwWlewU5aXn3N+ZOqhzEn0=
X-Gm-Message-State: AOJu0Yx5V51FFB2t/anLLkfco923GhDTravjbZPgbJ6zhrnusZ2m26LC
	HLs8ZbuKIfzZwsKbstSFplKC6HJbIXbD4Uj69X4NxAbL4G5PN6J9opp9BvABS3Ilatx/frFmeux
	srpRJdZIS1ajh8TynWFZL3oAGjoD5mJwkiqDDyicDY2TO5i4LpG9uJ3E=
X-Google-Smtp-Source: AGHT+IECSfEjDrXbtBJ9FCaenHfbUjIvw4kNa09QyQOkAQZADOciYzv8+Oo7y50sfKTYsJM7NKdcNGg0LXqVie3be6qvwMGW369t
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:264f:b0:488:75e3:f3c5 with SMTP id
 8926c6da1cb9f-4bbb6b40185mr883235173.0.1719989482802; Tue, 02 Jul 2024
 23:51:22 -0700 (PDT)
Date: Tue, 02 Jul 2024 23:51:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000023e1ce061c524270@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_direct_write
From: syzbot <syzbot+1bad52f1790df954e281@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    de0a9f448633 Merge tag 'riscv-for-linus-6.10-rc6' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=141718be980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=67463c0717b8d4ca
dashboard link: https://syzkaller.appspot.com/bug?extid=1bad52f1790df954e281
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f3b0731376e4/disk-de0a9f44.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/64cc7704ba12/vmlinux-de0a9f44.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd03addcf685/bzImage-de0a9f44.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1bad52f1790df954e281@syzkaller.appspotmail.com

INFO: task syz.1.13:5198 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.13        state:D stack:14448 pid:5198  tgid:5197  ppid:5082   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 inode_lock include/linux/fs.h:791 [inline]
 bch2_direct_write+0x243/0x3050 fs/bcachefs/fs-io-direct.c:598
 bch2_write_iter+0x206/0x2840 fs/bcachefs/fs-io-buffered.c:1135
 do_iter_readv_writev+0x5a4/0x800
 vfs_writev+0x395/0xbe0 fs/read_write.c:971
 do_pwritev fs/read_write.c:1072 [inline]
 __do_sys_pwritev2 fs/read_write.c:1131 [inline]
 __se_sys_pwritev2+0x1ca/0x2d0 fs/read_write.c:1122
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73b9175b99
RSP: 002b:00007f73b9fcf048 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f73b9303fa0 RCX: 00007f73b9175b99
RDX: 0000000000000001 RSI: 0000000020000100 RDI: 0000000000000005
RBP: 00007f73b91f677e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f73b9303fa0 R15: 00007fff0b9b3f38
 </TASK>
INFO: task syz.1.13:5245 blocked for more than 144 seconds.
      Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.13        state:D stack:27392 pid:5245  tgid:5197  ppid:5082   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 inode_lock include/linux/fs.h:791 [inline]
 bch2_fallocate_dispatch+0x295/0x3810 fs/bcachefs/fs-io.c:774
 vfs_fallocate+0x564/0x6c0 fs/open.c:330
 ksys_fallocate fs/open.c:353 [inline]
 __do_sys_fallocate fs/open.c:361 [inline]
 __se_sys_fallocate fs/open.c:359 [inline]
 __x64_sys_fallocate+0xbd/0x110 fs/open.c:359
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73b9175b99
RSP: 002b:00007f73b9f8d048 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f73b9304150 RCX: 00007f73b9175b99
RDX: 0000000000004000 RSI: 0000000000000008 RDI: 0000000000000005
RBP: 00007f73b91f677e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f73b9304150 R15: 00007fff0b9b3f38
 </TASK>
INFO: task syz.1.13:5247 blocked for more than 144 seconds.
      Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.13        state:D stack:24120 pid:5247  tgid:5197  ppid:5082   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 inode_lock include/linux/fs.h:791 [inline]
 process_measurement+0x43c/0x1fb0 security/integrity/ima/ima_main.c:250
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0x6d/0xa0 security/security.c:2982
 do_open fs/namei.c:3652 [inline]
 path_openat+0x28f6/0x3280 fs/namei.c:3807
 do_filp_open+0x235/0x490 fs/namei.c:3834
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1405
 do_sys_open fs/open.c:1420 [inline]
 __do_sys_openat fs/open.c:1436 [inline]
 __se_sys_openat fs/open.c:1431 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1431
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73b9175b99
RSP: 002b:00007f73b9f6c048 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007f73b9304228 RCX: 00007f73b9175b99
RDX: 000000000006b142 RSI: 0000000020004400 RDI: ffffffffffffff9c
RBP: 00007f73b91f677e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f73b9304228 R15: 00007fff0b9b3f38
 </TASK>
INFO: task syz.1.13:5251 blocked for more than 145 seconds.
      Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.13        state:D stack:19360 pid:5251  tgid:5197  ppid:5082   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 inode_lock include/linux/fs.h:791 [inline]
 process_measurement+0x43c/0x1fb0 security/integrity/ima/ima_main.c:250
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0x6d/0xa0 security/security.c:2982
 do_open fs/namei.c:3652 [inline]
 path_openat+0x28f6/0x3280 fs/namei.c:3807
 do_filp_open+0x235/0x490 fs/namei.c:3834
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1405
 do_sys_open fs/open.c:1420 [inline]
 __do_sys_open fs/open.c:1428 [inline]
 __se_sys_open fs/open.c:1424 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1424
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73b9175b99
RSP: 002b:00007f73b9f4b048 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f73b9304300 RCX: 00007f73b9175b99
RDX: 0000000000000000 RSI: 0000000000141042 RDI: 0000000020000100
RBP: 00007f73b91f677e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f73b9304300 R15: 00007fff0b9b3f38
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
2 locks held by getty/4840:
 #0: ffff88802adec0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031432f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2211
2 locks held by syz.1.13/5198:
 #0: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2854 [inline]
 #0: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: vfs_writev+0x2d9/0xbe0 fs/read_write.c:969
 #1: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:791 [inline]
 #1: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: bch2_direct_write+0x243/0x3050 fs/bcachefs/fs-io-direct.c:598
3 locks held by syz.1.13/5241:
 #0: ffff88802bf6d4c8 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x24e/0x310 fs/file.c:1191
 #1: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2854 [inline]
 #1: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #2: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:791 [inline]
 #2: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: bch2_direct_write+0x243/0x3050 fs/bcachefs/fs-io-direct.c:598
2 locks held by syz.1.13/5245:
 #0: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2854 [inline]
 #0: ffff888063c74420 (sb_writers#14){.+.+}-{0:0}, at: vfs_fallocate+0x4d3/0x6c0 fs/open.c:329
 #1: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:791 [inline]
 #1: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: bch2_fallocate_dispatch+0x295/0x3810 fs/bcachefs/fs-io.c:774
1 lock held by syz.1.13/5247:
 #0: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:791 [inline]
 #0: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: process_measurement+0x43c/0x1fb0 security/integrity/ima/ima_main.c:250
1 lock held by syz.1.13/5251:
 #0: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:791 [inline]
 #0: ffff888061739788 (&sb->s_type->i_mutex_key#23){+.+.}-{3:3}, at: process_measurement+0x43c/0x1fb0 security/integrity/ima/ima_main.c:250
1 lock held by syz-executor/6973:
 #0: ffffffff8e339338 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:323 [inline]
 #0: ffffffff8e339338 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:939

=============================================

NMI backtrace for cpu 0
CPU: 0 PID: 30 Comm: khungtaskd Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xfde/0x1020 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 PID: 5671 Comm: syz-executor Not tainted 6.10.0-rc5-syzkaller-00253-gde0a9f448633 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:check_preemption_disabled+0x19/0x120 lib/smp_processor_id.c:14
Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 41 57 41 56 41 54 53 48 83 ec 10 65 48 8b 04 25 28 00 00 00 48 89 44 24 08 <65> 8b 1d 6c 90 86 74 65 8b 05 61 90 86 74 a9 ff ff ff 7f 74 26 65
RSP: 0018:ffffc900049af328 EFLAGS: 00000286
RAX: 210125f3d94ac900 RBX: 0000000000000001 RCX: ffffffff817266c4
RDX: 0000000000000000 RSI: ffffffff8c1f1760 RDI: ffffffff8c1f1720
RBP: ffffc900049af4d0 R08: ffffffff8fac242f R09: 1ffffffff1f58485
R10: dffffc0000000000 R11: fffffbfff1f58486 R12: 1ffff92000935e78
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc900049af820
FS:  0000555570538500(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005628575020e0 CR3: 00000000591e0000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 rcu_dynticks_curr_cpu_in_eqs include/linux/context_tracking.h:122 [inline]
 rcu_is_watching+0x15/0xb0 kernel/rcu/tree.c:724
 trace_lock_acquire include/trace/events/lock.h:24 [inline]
 lock_acquire+0xe3/0x550 kernel/locking/lockdep.c:5725
 rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 rcu_read_lock include/linux/rcupdate.h:781 [inline]
 percpu_ref_put_many include/linux/percpu-refcount.h:330 [inline]
 percpu_ref_put+0x36/0x180 include/linux/percpu-refcount.h:351
 __mem_cgroup_uncharge_folios+0xdf/0x1c0 mm/memcontrol.c:7737
 mem_cgroup_uncharge_folios include/linux/memcontrol.h:721 [inline]
 folios_put_refs+0x932/0xa60 mm/swap.c:1023
 folio_batch_release include/linux/pagevec.h:101 [inline]
 shmem_undo_range+0x6de/0x1df0 mm/shmem.c:1005
 shmem_truncate_range mm/shmem.c:1114 [inline]
 shmem_evict_inode+0x29b/0xa60 mm/shmem.c:1242
 evict+0x2a8/0x630 fs/inode.c:667
 __dentry_kill+0x20d/0x630 fs/dcache.c:603
 dput+0x19f/0x2b0 fs/dcache.c:845
 __fput+0x68c/0x8b0 fs/file_table.c:430
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x360 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f985a97579b
Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1c 48 8b 44 24 18 64 48 2b 04 25 28 00 00
RSP: 002b:00007ffe27dfe6b0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 00007f985a97579b
RDX: 0000000000000000 RSI: 0000000000004c01 RDI: 0000000000000003
RBP: 00007ffe27dfe75c R08: 0000000000000000 R09: 00007ffe27dfe457
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000038870 R14: 0000000000037a0b R15: 00007ffe27dfe7c0
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
