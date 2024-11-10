Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA6F14D70E
	for <linux-bcachefs@vger.kernel.org>; Sun, 10 Nov 2024 08:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731227613; cv=none; b=NmMVfUefHuiGlJmKTHEmzwmwU5OI9WPMO/ogxf0HLnTQCKrC+pLzJfFmSKeppTpE2F3n9t8clYt70oLOqgmo+WeLgALGpL1MTZTdsWYaKtPITAzipxNxCqDuRgpQMD9yXnnREkalDAi6Ikrsus25hnyP6HI35dLCSOa2C/YZ/Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731227613; c=relaxed/simple;
	bh=EA8rRVaHhXclWEvb6Nhxfcw0iDTQZY0Qhmo0EsTLtZY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DX1yAIPDI49lFUNXoL391rdnDM9v7b9A8wzKEP5XIRb0qAmByiE0NCZOyo9BLNkfzxt/lDuR9AN/7tXHXtCZqfm+uxTCPxoPeKd8+7xOFaTXy+DExl+q5gJzKLgYYZazvVCxuviYC9405qNyBH0+yFr81p9TzCZ1E1fRF7hvvHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4e41e2732so46431185ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 10 Nov 2024 00:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731227611; x=1731832411;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyJKeRIFU1WmL8qzWPTR5eRitL2d2mm93xapJSMYkOc=;
        b=UpoHF7UfllrRzS6do1T4WwnxQRfl0HwXDloY96X0h2sAe58u3RBDizXHPrQAgI6yar
         DO35p8e9Ugl+tcuv/OUCzIO3mhYnpMHpFAg3G333nkY6roz9CmWnSJg1kMIMnx11rQV5
         wNIsPg5VKwiQ8UnkVIxPQ7MIGX3z2zSMxdncF/QkM8WwQC33e3WKUy3mXiEvALjpKwWw
         Q/cobPAJs/XegCPAFvcezg4NlIYpvssjXtFNtpxYnB90sYqFEuHOemaYp8sJH4AAeJ1a
         3esRxX6PH8cWGYc+YMyA/cp8+wPyaqBn8Hwmd4dwcotGl+lVzHWh1cwmakXHJ4la94+n
         KnLg==
X-Forwarded-Encrypted: i=1; AJvYcCVi84uF0LZDxVa9FAAVOzgGLVefaqn907nLQmcFtuMJZPQ9df43yqlslk7SWy7LeNhi/zhxYQFk+InZRQEJJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwY8IlZ+LKnkAVt26v3fAsGi5n0pWT32QhvTXJeNZJzztzDvglS
	6WDoEFXTsK2BW5H3xwDYBh9WU3spmsPaUur5avyKb5CeQrDLKocwS6XN09Aq17NGicq5CZ7X82Q
	rH/7x7QFHHqLlgpxXoyYiRXWmD7IEvpwht0iekUzFRyLrSdqtIFC+UxM=
X-Google-Smtp-Source: AGHT+IE0nU7kX1sQ1aXwDrc0Kmtce2lguUdrS6A8Ux6ko6dCapBwqWqK8b8VGFd8sl4wjDpMEhOiHzl4ETvOS2XBxHLX/99sK9Cm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aa3:b0:3a6:ac17:13e4 with SMTP id
 e9e14a558f8ab-3a6f1a48bdemr91889025ab.18.1731227610933; Sun, 10 Nov 2024
 00:33:30 -0800 (PST)
Date: Sun, 10 Nov 2024 00:33:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67306fda.050a0220.138bd5.0049.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in btree_write_buffer_flush_seq
From: syzbot <syzbot+cf3d1015b55ff73dcdc8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=163f4e30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11254d3590b16717
dashboard link: https://syzkaller.appspot.com/bug?extid=cf3d1015b55ff73dcdc8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a536a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1402cf40580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6a49054c25b2/disk-2e1b3cc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d6873a86739/vmlinux-2e1b3cc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/630443e7db25/bzImage-2e1b3cc9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e7e7dcf3a227/mount_0.gz

The issue was bisected to:

commit 49fd90b2cc332b8607a616d99d4bb792f18208b9
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Sep 25 22:17:31 2024 +0000

    bcachefs: Fix unlocked access to c->disk_sb.sb in bch2_replicas_entry_validate()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=117e0ea7980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=137e0ea7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=157e0ea7980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf3d1015b55ff73dcdc8@syzkaller.appspotmail.com
Fixes: 49fd90b2cc33 ("bcachefs: Fix unlocked access to c->disk_sb.sb in bch2_replicas_entry_validate()")

INFO: task bch-reclaim/loo:5865 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:25848 pid:5865  tgid:5865  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6690
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6839
 __mutex_lock_common kernel/locking/mutex.c:684 [inline]
 __mutex_lock+0x6a7/0xd70 kernel/locking/mutex.c:752
 btree_write_buffer_flush_seq+0x1a39/0x1bc0 fs/bcachefs/btree_write_buffer.c:509
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f9/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x789/0xdc0 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x174/0x560 fs/bcachefs/journal_reclaim.c:740
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
2 locks held by getty/5591:
 #0: ffff8880349da0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
3 locks held by syz-executor155/5854:
 #0: ffff88807c9ae420 (sb_writers#10){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3228
 #2: ffff8880704266d0 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202
3 locks held by bch-reclaim/loo/5865:
 #0: ffff88807044b0a8 (&j->reclaim_lock){+.+.}-{3:3}, at: bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:739
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3228
 #2: ffff888070404740 (&wb->flushing.lock){+.+.}-{3:3}, at: btree_write_buffer_flush_seq+0x1a39/0x1bc0 fs/bcachefs/btree_write_buffer.c:509
3 locks held by bch-copygc/loop/5866:
 #0: ffff888070404740 (&wb->flushing.lock){+.+.}-{3:3}, at: bch2_btree_write_buffer_flush_nocheck_rw fs/bcachefs/btree_write_buffer.c:543 [inline]
 #0: ffff888070404740 (&wb->flushing.lock){+.+.}-{3:3}, at: bch2_btree_write_buffer_tryflush+0x14b/0x1c0 fs/bcachefs/btree_write_buffer.c:558
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff888070404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x97/0x1a0 fs/bcachefs/btree_iter.c:3053
 #2: ffff8880704266d0 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
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
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 67 Comm: kworker/u8:4 Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue:  0x0 (events_unbound)
RIP: 0010:srso_alias_safe_ret+0x0/0x7 arch/x86/lib/retpoline.S:171
Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <48> 8d 64 24 08 c3 cc e8 f4 ff ff ff 0f 0b cc cc cc cc cc cc cc cc
RSP: 0018:ffffc900015f72b0 EFLAGS: 00000096
RAX: 1ffffffff1cffcbc RBX: 0000000000000008 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff8e7fe6d0
RBP: 0000000000000048 R08: ffffffff8e7fe6d7 R09: 1ffffffff1cffcda
R10: dffffc0000000000 R11: fffffbfff1cffcdb R12: ffff888020af0000
R13: ffff888020af0068 R14: 1ffff1100415e00d R15: ffff8880b873ea80
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558081776600 CR3: 000000000e734000 CR4: 0000000000350ef0
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 srso_alias_return_thunk+0x5/0xfbef5 arch/x86/lib/retpoline.S:181
 activate_task+0x61/0xc0 kernel/sched/core.c:2067
 attach_task+0xee/0x190 kernel/sched/fair.c:9641
 attach_tasks kernel/sched/fair.c:9676 [inline]
 sched_balance_rq+0x664a/0x8620 kernel/sched/fair.c:11753
 sched_balance_newidle+0x6ba/0xfd0 kernel/sched/fair.c:12795
 pick_next_task_fair+0x40/0xc90 kernel/sched/fair.c:8943
 __pick_next_task+0xdd/0x400 kernel/sched/core.c:5968
 __schedule+0x776/0x4c30 kernel/sched/core.c:6644
 __schedule_loop kernel/sched/core.c:6767 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6782
 worker_thread+0xa30/0xd30 kernel/workqueue.c:3406
 kthread+0x2f2/0x390 kernel/kthread.c:389
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
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
