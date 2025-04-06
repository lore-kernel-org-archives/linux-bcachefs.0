Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8524419AD89
	for <linux-bcachefs@vger.kernel.org>; Sun,  6 Apr 2025 17:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743961891; cv=none; b=SsTFMWRYrfqMIAgDVJp+5akG5xBD4HPNczHdJNhbNcx1nabKqbXkM0A+QnLoQbm7J4hU/vSEwopAp5/hVdbEFVqHfoJazthwD4Funid73DhM0RSo9mK/aps7qAQOWYTa41GaZtZ6I5WUHM/54v6JLRoXXELAPt3RiVi4h+NHXDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743961891; c=relaxed/simple;
	bh=4TU/5ujd6gO7LbywY6kaM7Nv5pUfVkYWkgxRWhcF7Dw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JQPe75d9cRZC8pNG8ThfS8T3cRoZEZs7aq774O0Iv+yC+DziqDJNDN5r/1OeSaZCoVgPlQKW6w1eH2drK4+tdCBles+BXWhOjg9mT4l7QnNPW76npekrj9zA4omQYpe+bdcgdcaZInYxljYAXYvOvPMKKvBUAuIMer1Us7XGmSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d44b221f0dso74532965ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 06 Apr 2025 10:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743961888; x=1744566688;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=buaZOcv+KflFAdJRrTq296QYGm9POebmicXn0iNE9sk=;
        b=NSXcEaEV0aIIJpq9h1OcT/q58/4/cV+tlDJRI8yHW8JnkabiU5QgLb3dpj1n3V9ptV
         l50ahq9SwnBpcNxekbrJQ9Z2tMaTjT63gH3cc+ybOKR28eds7SOFy6OgkWlCSlIg2hyA
         4tPDzi3GR13DjiM17DI9Vt52nsqG4XneCODglJM9lAHr67BXCFUUxbkHOSZRYAy1R6zQ
         rgxV+0yGVHIAYG+EDm0GjjjgMkYwHRij56Xm2AOeoF19CilYn+meR1S4LclL/48Hr+q+
         oR3jAfIzDw5GYN7TBsUlCtzOMhlAasYhucAqi7J9MZsh9DYdwNBimwBG9+XEhE6WNY9k
         eUpw==
X-Forwarded-Encrypted: i=1; AJvYcCVoSHQ8c7MiCJ18Q1kUjT4q9mU/iK8XTk8aKkjzSjnLXEJBFt1xpyyzw9Zl2Ti2ldiKcLLVnRsYdRyuYRR5kg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJV+wORftuPc220CsCOT9l+YZLzuuPWd0rVFqZAPVWRNJTyvjF
	7g4yjog3icjkAcXuUjswYJEbc6z0i51YCwXE8QsfmyBeX2pJkasfJLTZPs5DoecxJTvTK4B9MIL
	EWWkSF8YF42s07eckEEHvACp09ajkUfybcbgEPSkG1/YpW5uExM/4UEY=
X-Google-Smtp-Source: AGHT+IEXLkvEwOEoN+2Ox2Em3tdhr0nfml1l2LKi51FzaZtCI0g/nZ+JD6g4Rves3hokbz3aNmBcTeERyqqK99PxWy4pRv1XW2Vm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1449:b0:3d1:92fc:fb45 with SMTP id
 e9e14a558f8ab-3d6e52f0791mr105713925ab.5.1743961888590; Sun, 06 Apr 2025
 10:51:28 -0700 (PDT)
Date: Sun, 06 Apr 2025 10:51:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f2bf20.050a0220.0a13.0270.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work (2)
From: syzbot <syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a2392f333575 drm/panthor: Clean up FW version information ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17077c3f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8cceedf2e27e877d
dashboard link: https://syzkaller.appspot.com/bug?extid=674ccd0645d379ed5f80
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10fd894c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7df8ceab3279/disk-a2392f33.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/42c5af403371/vmlinux-a2392f33.xz
kernel image: https://storage.googleapis.com/syzbot-assets/73599b849e20/Image-a2392f33.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/fd7871ac7900/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+674ccd0645d379ed5f80@syzkaller.appspotmail.com

INFO: task kworker/1:4:6586 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:4     state:D stack:0     pid:6586  tgid:6586  ppid:2      task_flags:0x4208060 flags:0x00000008
Workqueue: events_long bch2_fs_read_only_work
Call trace:
 __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x1360/0x257c kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x18/0x2c kernel/sched/core.c:6914
 rwsem_down_write_slowpath+0xd10/0x14c8 kernel/locking/rwsem.c:1176
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write+0xb4/0xc0 kernel/locking/rwsem.c:1578
 bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
 process_one_work+0x810/0x1638 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x97c/0xeec kernel/workqueue.c:3400
 kthread+0x65c/0x7b0 kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862
INFO: task syz.0.388:10111 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc7-syzkaller-ga2392f333575 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.388       state:D stack:0     pid:10111 tgid:10110 ppid:6583   task_flags:0x400140 flags:0x0000000d
Call trace:
 __switch_to+0x414/0x788 arch/arm64/kernel/process.c:701 (T)
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x1360/0x257c kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0xbc/0x238 kernel/sched/core.c:6857
 __closure_sync+0x198/0x29c lib/closure.c:146
 closure_sync include/linux/closure.h:195 [inline]
 bch2_journal_flush_pins+0x1e0/0x348 fs/bcachefs/journal_reclaim.c:911
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 bch2_journal_replay+0x1c28/0x1f64 fs/bcachefs/recovery.c:442
 bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x260/0x92c fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x20e0/0x32ec fs/bcachefs/recovery.c:936
 bch2_fs_start+0x32c/0x570 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xa50/0x11d4 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x28c fs/super.c:1814
 do_new_mount+0x278/0x900 fs/namespace.c:3560
 path_mount+0x590/0xe04 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount fs/namespace.c:4088 [inline]
 __arm64_sys_mount+0x4f4/0x5d0 fs/namespace.c:4088
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

Showing all locks held in the system:
1 lock held by khungtaskd/32:
 #0: ffff80008ff22620 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0xc/0x44 include/linux/rcupdate.h:336
1 lock held by udevd/6081:
2 locks held by getty/6220:
 #0: ffff0000d74fa0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009bf4e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x41c/0x1228 drivers/tty/n_tty.c:2211
3 locks held by kworker/1:4/6586:
 #0: ffff0000c0029548 ((wq_completion)events_long){+.+.}-{0:0}, at: process_one_work+0x674/0x1638 kernel/workqueue.c:3212
 #1: ffff80009f6b7ba0 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_one_work+0x708/0x1638 kernel/workqueue.c:3212
 #2: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_read_only_work+0x28/0x48 fs/bcachefs/super.c:393
1 lock held by syz.0.388/10111:
 #0: ffff0000e7500278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_start+0x50/0x570 fs/bcachefs/super.c:1010
2 locks held by kworker/1:5/11232:
 #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:598 [inline]
 #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock kernel/sched/sched.h:1521 [inline]
 #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: rq_lock kernel/sched/sched.h:1852 [inline]
 #0: ffff0001b3772798 (&rq->__lock){-.-.}-{2:2}, at: __schedule+0x2e0/0x257c kernel/sched/core.c:6688
 #1: ffff0001b375d408 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x394/0x5e8 kernel/sched/psi.c:987
2 locks held by syz.3.1147/16990:
2 locks held by syz.4.1148/16993:
 #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:833 [inline]
 #0: ffff0000fc500920 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1238/0x299c fs/bcachefs/super.c:2065
 #1: ffff0000fc5049b0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x198/0x290 fs/bcachefs/replicas.c:600
3 locks held by syz.5.1149/17000:
2 locks held by syz.2.1150/17009:

=============================================



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
