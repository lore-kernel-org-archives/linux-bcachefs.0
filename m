Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2151ABEBC
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727346444; cv=none; b=UA2pzUueEhZGHeXwlWEpgAr4q19E5OW+BrrBixvaqaQacRuNDSTCOiH7hijL9Cv1l8AJ7QuPlJLVbGH7snaCPPasy6AcqcyVKaDJUU+5R8c2iCkigOibGpfch/aVntde+4f9yT7kJSdl7e/KutkF2c8beMO/GkvkKFhlxLfB7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727346444; c=relaxed/simple;
	bh=RfGLQ2Aaewn4d4r+KOXGIABi2h2jaXvnG74eRLDRiqA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GQcTHGbF1GoscX58qNe/W54bhBVnvqAFu5ayzQB7NyATDooA6zRHoySTW9ugw5JxLcvg/4/ctjk9bcOxVuBTgPTYzaTeFqI/VzeDUxy0pJSHND5mmYNJjPDusruVtnPfPvBrs24rXas9rEFMHmB9hN7Oz2z9VuWirlJ8QyyB4zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f56ac8d88so10660835ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 26 Sep 2024 03:27:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727346442; x=1727951242;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9A2C4JqlBvXcXy6tg9QhkVzgwPP47FEacCMaF7rh+jM=;
        b=iNNfSPba18OiYuqWNc/+bY6+STuNcxkIHXabbPqh7IXRref/eXUm42OMm9qnKZ1W3x
         AyxF7RO7OJngLHPojsUL0jMoqrA+c9xjgax2uHkTjX8E9q9gaiUK63gqOYpPS/bbs9Cs
         AV3BMh5knQdjNbmJDrwPO5WOfEGrhT9ZIRTSTbT13/BuFyfbVpcv0IQRX27DTVboY3dt
         nebGyTpdy2+B5DJ80S4w5T7/8aLYLfMnStoKQ2Sig+Nxs0MXl65PEgiOnOzI6/tLNldv
         1AM909RQ0W2k0ALDT+evbw2gFm4ciV3zGq0IhpYDfgqHvmw3+02hLRiqCVfs4NEvJ6b4
         xMtQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsgMTPYjgRsE9LjoMFXvJXvyeYzU1QhoAMu3LdOyhyKoA2QE+OlWb3DnFksbPI8JGeKJb7niLulY8Y/cRnvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAqLt8TFkyZ5Eus2lt0GGzE0RweJPbNzRhT3lNaliTbQrxP7fy
	L+RqNMa+ZRmXqQixBMaQJQ335wHG8zk+sJCVP3gdBsjhTkfVd5UyShqZb9OcwnHcP16lLdTiRYm
	eBeWlLokJO86C7YZ/dYYVOGwpyiR4P1cv+uWsOuj9TDDtGoESdcTrkcQ=
X-Google-Smtp-Source: AGHT+IF3kavnIUZ/fQIQPUBzfVcrRJHqH4jovNob9BKTDM5flUX79dkV1qGhAgCZ6MoTcL+BYZ+73nzsZTX3J3NbMWeF+f4iFGJI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4c:0:b0:3a3:4164:eec9 with SMTP id
 e9e14a558f8ab-3a34164f2f4mr10040345ab.14.1727346441906; Thu, 26 Sep 2024
 03:27:21 -0700 (PDT)
Date: Thu, 26 Sep 2024 03:27:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f53709.050a0220.211276.0068.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only
From: syzbot <syzbot+c7aacacf99dcfd3475a7@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88264981f208 Merge tag 'sched_ext-for-6.12' of git://git.k..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16f9de9f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=74ffdb3b3fad1a43
dashboard link: https://syzkaller.appspot.com/bug?extid=c7aacacf99dcfd3475a7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b24e07980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17dfb080580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/87eaf0ad6d60/disk-88264981.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/30c01cf8bc82/vmlinux-88264981.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a1407424ea54/bzImage-88264981.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/24e9b0679e2e/mount_0.gz

The issue was bisected to:

commit 359571c327a726d622786aef3833637dacfd5d38
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Tue Apr 9 04:02:47 2024 +0000

    bcachefs: Fix check_topology() when using node scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11203880580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13203880580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15203880580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c7aacacf99dcfd3475a7@syzkaller.appspotmail.com
Fixes: 359571c327a7 ("bcachefs: Fix check_topology() when using node scan")

INFO: task syz-executor380:5235 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor380 state:D stack:23872 pid:5235  tgid:5235  ppid:5232   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5315 [inline]
 __schedule+0x1843/0x4ae0 kernel/sched/core.c:6674
 __schedule_loop kernel/sched/core.c:6751 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6766
 bch2_fs_read_only+0xa86/0x1220 fs/bcachefs/super.c:346
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:618
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2064
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2403
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x279/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5044059387
RSP: 002b:00007fffa46cc3a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f5044059387
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fffa46cc460
RBP: 00007fffa46cc460 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007fffa46cd4c0
R13: 0000555568abe6c0 R14: 0000000000000001 R15: 431bde82d7b634db
 </TASK>

Showing all locks held in the system:
5 locks held by kworker/u8:0/11:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
4 locks held by kworker/u8:4/61:
 #0: ffff888012bc9148 ((wq_completion)btree_node_rewrite){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff888012bc9148 ((wq_completion)btree_node_rewrite){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900015c7d00 ((work_completion)(&a->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900015c7d00 ((work_completion)(&a->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffff8880724042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #2: ffff8880724042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #2: ffff8880724042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3200
 #3: ffff888072426690 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1197
2 locks held by getty/4976:
 #0: ffff88803298a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by syz-executor380/5235:
 #0: ffff88802e0f20e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88802e0f20e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88802e0f20e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
 #1: ffff888072400278 (&c->state_lock){+.+.}-{3:3}, at: __bch2_fs_stop+0xfd/0x540 fs/bcachefs/super.c:617

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.11.0-syzkaller-08481-g88264981f208 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:arch_atomic_read arch/x86/include/asm/atomic.h:23 [inline]
RIP: 0010:raw_atomic_read include/linux/atomic/atomic-arch-fallback.h:457 [inline]
RIP: 0010:rcu_is_watching_curr_cpu include/linux/context_tracking.h:128 [inline]
RIP: 0010:rcu_is_watching+0x5a/0xb0 kernel/rcu/tree.c:737
Code: f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 ec 56 80 00 48 c7 c3 98 7e 03 00 49 03 1e 48 89 d8 48 c1 e8 03 42 0f b6 04 38 <84> c0 75 22 8b 03 65 ff 0d 11 3f 89 7e 74 10 83 e0 04 c1 e8 02 5b
RSP: 0018:ffffc90000107618 EFLAGS: 00000802
RAX: 0000000000000000 RBX: ffff8880b8637e98 RCX: ffffffff8142d66f
RDX: 0000000000000000 RSI: ffffffff8c5ffc60 RDI: ffffffff8c5ffc20
RBP: ffffc90000107730 R08: ffffffff901b4b2f R09: 1ffffffff2036965
R10: dffffc0000000000 R11: fffffbfff2036966 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffffff8e2faa50 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557aa7895600 CR3: 000000000e734000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 trace_tlb_flush+0x3e/0x140 include/trace/events/tlb.h:38
 switch_mm_irqs_off+0x7b0/0xb00
 unuse_temporary_mm arch/x86/kernel/alternative.c:1831 [inline]
 __text_poke+0x8f0/0xd30 arch/x86/kernel/alternative.c:1941
 text_poke arch/x86/kernel/alternative.c:1984 [inline]
 text_poke_bp_batch+0x59c/0xb30 arch/x86/kernel/alternative.c:2317
 text_poke_flush arch/x86/kernel/alternative.c:2486 [inline]
 text_poke_finish+0x30/0x50 arch/x86/kernel/alternative.c:2493
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_disable_cpuslocked+0xd2/0x1c0 kernel/jump_label.c:240
 static_key_disable+0x1a/0x20 kernel/jump_label.c:248
 toggle_allocation_gate+0x1bf/0x260 mm/kfence/core.c:854
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.548 msecs


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
