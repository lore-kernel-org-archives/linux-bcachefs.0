Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23F026FA51
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Feb 2025 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740686136; cv=none; b=lcRcF4UHC8fTn6W+E1Ktzs2KALvpwVR1EuYpo/wfSdLwNIWA8zs0Qct5igCQtujc5aW+rOkORIism8ftna8VCHci/Th2eN7xcsrOYTl/mFVPt+Gl215YvBstO1Rq0d3H1ff/gqbVXcca400+WEZMmHGCWHcGYYsVeAYqce3OtyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740686136; c=relaxed/simple;
	bh=cKvUdXsEjvtHtHga3ldzaC1r3mLy1KMAS7EYeBbFdYQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JLFA51o5ImUGDoQLY2JE3oZeK2YONHnK5iOuWaJO18+4mr23DNaZlu51nCRVuC1PVuddkkgP4Lk4JLgKQivMK6DnBdD3pM7tJfkzhpBixNXADuk9bDjUzRKroTnIETcAVMGb5eqI3nzojn7/smceEA3VgI9/tfkCijxtXrLQVQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d2a1d6747aso16050225ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Feb 2025 11:55:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740686134; x=1741290934;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fC5MSRm9BECByFHM5ylvmXFJ1nvWpeqQ8PESL8FrfuU=;
        b=BxmmL/tCG1dtaYC4RVbTm4RxqGWNZyXGM6oVZbl/SJvu4AW+rtGzoxidgyYOjIfLqX
         L93sH8MbH3dAV9lV19P3ETGycfa1jF/oeIxkuYUXrnTDMVL2+9mm8pW2IM/7EUJMwtxt
         SvWSFBArxEIfEb0ZrKb/7Uh+yX998IwxsjHucZh/4ONaE2/jkxrTVd/K7BlTO3Xi4/Iy
         PZwmVkpWC83ekE7PIR1MRt2GARkKsVcTUh0E55nq1HTw5Llt84nwMtNmIPHq893eFsox
         hQYSForVO33B/tAXpy3e6Rmtk231z9xfoS/JGrDdjirVj0s+xXXFwfsb9ncGKNYoUvnJ
         E4FA==
X-Forwarded-Encrypted: i=1; AJvYcCWd8271PC5/YH29gutiZSxt/1Y4xH1aW9XYMBDZ9ViaAugU/o0Dv1MjvTJCwWLatMiBuPxhE2Ks+J0CJOffOg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7VDXYWsGujMBgP3sKcPM/eivYSQkmdq09XwenGk2tD4p3JGMP
	dNTzeFVW8/iqy7uotWxW8u50om7bv35fk0Yt0o6fGlyvgbmv4gTw65iFO/v3zPFilcN7ed18cvG
	tviDKsEFLJM/OSDM0xfM/tOBUkdKnnLgVLsOMsodA2BuQThE8GJl6HZ4=
X-Google-Smtp-Source: AGHT+IEAmRfhaFWJDNSDY6t96ozm4BGEa0RtrysODBtxnkZc04NzgkyhoPlXPsbDjM7OFW0P6ORGpqT6ZvUdX7QKurAnDONUn30R
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c9:b0:3cf:fd62:e39c with SMTP id
 e9e14a558f8ab-3d3e6b27ffdmr7078155ab.5.1740686133869; Thu, 27 Feb 2025
 11:55:33 -0800 (PST)
Date: Thu, 27 Feb 2025 11:55:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c0c335.050a0220.222324.0271.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in pipe_release (6)
From: syzbot <syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d082ecbc71e9 Linux 6.14-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11fe26e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=23e4a7772eb9a9715b85
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fe26e4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5efd609bee65/disk-d082ecbc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfadbc41acd8/vmlinux-d082ecbc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/50189caf8ad6/bzImage-d082ecbc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/470a5d56ad27/mount_0.gz

The issue was bisected to:

commit 1d16c605cc55ef26f0c65b362665a6c99080ccbc
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 9 19:22:46 2023 +0000

    bcachefs: Disk space accounting rewrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117c9db0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=137c9db0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=157c9db0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+23e4a7772eb9a9715b85@syzkaller.appspotmail.com
Fixes: 1d16c605cc55 ("bcachefs: Disk space accounting rewrite")

INFO: task syz-executor:5849 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:20592 pid:5849  tgid:5849  ppid:5843   task_flags:0x400100 flags:0x00000002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6914
 __mutex_lock_common kernel/locking/mutex.c:662 [inline]
 __mutex_lock+0x817/0x1010 kernel/locking/mutex.c:730
 pipe_release+0x48/0x320 fs/pipe.c:728
 __fput+0x3e9/0x9f0 fs/file_table.c:464
 __do_sys_close fs/open.c:1580 [inline]
 __se_sys_close fs/open.c:1565 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1565
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6de58bda0
RSP: 002b:00007fff16f18de8 EFLAGS: 00000202 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 0000555580184ec0 RCX: 00007fe6de58bda0
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 000000000000001d
RBP: 00005555801847a0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000202 R12: 00007fff16f18e10
R13: 0000000000000023 R14: 0000555580184f0c R15: 00005555801854c8
 </TASK>
INFO: task syz.3.64:6573 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.64        state:D stack:10240 pid:6573  tgid:6572  ppid:5971   task_flags:0x400140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 io_schedule+0x8d/0x110 kernel/sched/core.c:7690
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1318
 folio_lock include/linux/pagemap.h:1163 [inline]
 invalidate_inode_pages2_range+0x48f/0x960 mm/truncate.c:639
 bch2_write_invalidate_inode_pages_range+0xce/0x120 fs/bcachefs/fs-io-pagecache.c:68
 bch2_direct_write+0x2ebf/0x3190 fs/bcachefs/fs-io-direct.c:653
 bch2_write_iter+0x19d/0x2cd0 fs/bcachefs/fs-io-buffered.c:1047
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 do_sendfile+0x564/0x8a0 fs/read_write.c:1363
 __do_sys_sendfile64 fs/read_write.c:1424 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f893338d169
RSP: 002b:00007f89342ae038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f89335a5fa0 RCX: 00007f893338d169
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000006
RBP: 00007f893340e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000fffa83 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f89335a5fa0 R15: 00007fffa972dc48
 </TASK>
INFO: task syz.3.64:6613 blocked for more than 144 seconds.
      Not tainted 6.14.0-rc4-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.64        state:D stack:15824 pid:6613  tgid:6572  ppid:5971   task_flags:0x440140 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 __bch2_two_state_lock+0x229/0x2c0 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x9e1/0x1240 fs/bcachefs/fs-io-buffered.c:272
 read_pages+0x179/0x570 mm/readahead.c:161
 page_cache_ra_unbounded+0x708/0x820 mm/readahead.c:298
 filemap_readahead mm/filemap.c:2549 [inline]
 filemap_get_pages+0x9e4/0x1fb0 mm/filemap.c:2594
 filemap_splice_read+0x68e/0xef0 mm/filemap.c:2971
 do_splice_read fs/splice.c:985 [inline]
 splice_file_to_pipe+0x290/0x500 fs/splice.c:1295
 do_sendfile+0x508/0x8a0 fs/read_write.c:1369
 __do_sys_sendfile64 fs/read_write.c:1424 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f893338d169
RSP: 002b:00007f893428d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f89335a6080 RCX: 00007f893338d169
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: 00007f893340e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000002ab R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f89335a6080 R15: 00007fffa972dc48
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8eb38f60 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8eb38f60 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8eb38f60 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
2 locks held by getty/5582:
 #0: ffff88803571a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
1 lock held by syz-executor/5849:
 #0: ffff88802a3d6068 (&pipe->mutex){+.+.}-{4:4}, at: pipe_release+0x48/0x320 fs/pipe.c:728
4 locks held by kworker/u8:4/6005:
 #0: ffff8880b873e7d8 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
 #1: ffff8880b8728948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x41d/0x7a0 kernel/sched/psi.c:987
 #2: ffff8880b872a398 (&base->lock){-.-.}-{2:2}, at: lock_timer_base kernel/time/timer.c:1046 [inline]
 #2: ffff8880b872a398 (&base->lock){-.-.}-{2:2}, at: __mod_timer+0x24a/0x10e0 kernel/time/timer.c:1127
 #3: ffffffff9a832208 (&obj_hash[i].lock){-.-.}-{2:2}, at: debug_object_activate+0x17f/0x580 lib/debugobjects.c:818
1 lock held by syz.3.64/6573:
 #0: ffff8880741e2420 (sb_writers#13){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x220 fs/splice.c:1163
2 locks held by syz.3.64/6613:
 #0: ffff88802a3d6068 (&pipe->mutex){+.+.}-{4:4}, at: splice_file_to_pipe+0x2e/0x500 fs/splice.c:1292
 #1: ffff8880744ba148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:932 [inline]
 #1: ffff8880744ba148 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0x156/0x820 mm/readahead.c:229

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
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
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1 skipped: idling at native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
NMI backtrace for cpu 1 skipped: idling at arch_safe_halt arch/x86/include/asm/irqflags.h:106 [inline]
NMI backtrace for cpu 1 skipped: idling at acpi_safe_halt+0x21/0x30 drivers/acpi/processor_idle.c:111


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
