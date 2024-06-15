Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D2381C7
	for <linux-bcachefs@vger.kernel.org>; Sat, 15 Jun 2024 09:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718445502; cv=none; b=BKf6IpZ7iwbYKQJ5hW/jr+BuCgRAVwRgtR/A7Zjyfh/F3eDsTh9G/H8QXUR3K1jC2oTcA/lZahPACl/Emid0ZAtZaG9jyaD6ibLAmU0ktFx1iXQzQTHaEmz+H/0yzljUFFwqImiJQyv70AiX4M5nqwtU509zWaMZf1bGWZXAAp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718445502; c=relaxed/simple;
	bh=nKlN2QBUp9ZR3tphHEwe/c3JF7pOqc8Z3AIvqXvJFr4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gOZ609ixrvQJLI++T+kC2rGsX/GYYh+EA0lYajxrWdgBa0PuXIjfkLGOykGKsuHDzZK8lBIVfdzMC/4gbM4ERJhU3losY6KsACkBpihkb7Jw40Mc8t6tWOZsbOtS2Ng5Ojv1wXz0sp7eLgrAEYbclQHyYylIsQK8I/c0gXU01pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-375da99c867so24976825ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 15 Jun 2024 02:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718445500; x=1719050300;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hgAz2JZL22bf7lXOcSE5KeRR5btAdr72+RJxfSbwclc=;
        b=k0HNrwQQrYl3mHE/AE05Gdqy6lbBi3Ca/HOFermVUCXd/C0xiIB5T0hXEkTs9t6tTi
         Y231VvDzjv/v0BMKS8KrKfEAvpGyiJjW9o2589oIBaFWlFO4P1mktRB+rPQL3V6uhG5L
         NQgY3RKIEXB4+V7FC5qQMrsxD0H1F5IIaF3fgTeENWXThuzHCUGeBzCoP1gBtXw4nOL7
         oUhMKm9mlMCfUInIyZtj0kIoGTTispFfKwAEisQfLECLOYV7HAvoL29/IAHg3HypNkrf
         XFxPhuxtpXYFtoy8u/GLpIpDcf6hBYbu7Mw42pIp7BMVwcIE1rQrZx7/OFjyW+MeQD5w
         7v2g==
X-Forwarded-Encrypted: i=1; AJvYcCVlaQ9akhsV+NbPHQAiDbskPUaproiQ0pEGGyxxkPj/sppXo3lQhCDEMHzangjW+7qGZV4vsuXwbxsjU4npbJLMY71WBE4eewPUPpRB8wQ=
X-Gm-Message-State: AOJu0YwzTtTHYAXEr5bSwHBBs9wgr6DoaAr8D/X3S2/ls30ApodMoUs1
	aDndcmdc1OfWuVXT+jkj3YI/msbXoJtvjE1WUVnCAwqLD1OQ4aMstaqlu8Cn49B/WOlM18K/y0G
	uSvXh9s6e1QUB8RsWlKpwwNMeLSFycDNuoxCAkiBh4SHuC6T0bOr1Zww=
X-Google-Smtp-Source: AGHT+IEZrC6omejNXLXi/CfuqZ/GLfx9zVRH3zLlJH1LPUVQxCv3dObB+50L1aPcIJ6X+gMD1foDhqVorggn+0Eeyjthsv1qGKX6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a28:b0:375:8fd0:c939 with SMTP id
 e9e14a558f8ab-375e0e14abamr3267955ab.1.1718445500166; Sat, 15 Jun 2024
 02:58:20 -0700 (PDT)
Date: Sat, 15 Jun 2024 02:58:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009a83e9061aeac50d@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in __bch2_fs_stop
From: syzbot <syzbot+6d3e28b33490b3085412@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    83a7eefedc9b Linux 6.10-rc3
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=164ac82e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79815c08cc14227
dashboard link: https://syzkaller.appspot.com/bug?extid=6d3e28b33490b3085412
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1653cfba980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1316587a980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b45273014a8f/disk-83a7eefe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/94cd5708292e/vmlinux-83a7eefe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a89698812e8b/bzImage-83a7eefe.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/3ef828450a9b/mount_0.gz

The issue was bisected to:

commit 267b801fda10b70eca4001a819fcac07f023df6b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Dec 4 18:45:33 2023 +0000

    bcachefs: BCH_IOCTL_FSCK_ONLINE

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15166a54980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17166a54980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13166a54980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d3e28b33490b3085412@syzkaller.appspotmail.com
Fixes: 267b801fda10 ("bcachefs: BCH_IOCTL_FSCK_ONLINE")

INFO: task syz-executor427:5081 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc3-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor427 state:D stack:22048 pid:5081  tgid:5081  ppid:5078   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 __bch2_fs_stop+0x35b/0x540 fs/bcachefs/super.c:628
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2034
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x273/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f70db0df3c7
RSP: 002b:00007ffd58b093d8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f70db0df3c7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd58b09490
RBP: 00007ffd58b09490 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000206 R12: 00007ffd58b0a4f0
R13: 000055558a2c86c0 R14: 0000000000000019 R15: 431bde82d7b634db
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e333fa0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #0: ffffffff8e333fa0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #0: ffffffff8e333fa0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
2 locks held by kworker/u8:7/1105:
1 lock held by klogd/4526:
2 locks held by getty/4836:
 #0: ffff88802f6310a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f162f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2201
1 lock held by syz-executor427/5081:
 #0: ffff88807e8180e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88807e8180e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88807e8180e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 30 Comm: khungtaskd Not tainted 6.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 1105 Comm: kworker/u8:7 Not tainted 6.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:PagePoisoned include/linux/page-flags.h:296 [inline]
RIP: 0010:PageReserved include/linux/page-flags.h:536 [inline]
RIP: 0010:__text_poke+0x187/0xd30 arch/x86/kernel/alternative.c:1864
Code: 00 00 00 00 00 ea ff ff 4c 89 ff e8 13 33 0d 00 49 89 c4 49 c1 ec 06 49 83 e4 c0 49 01 dc 4c 89 e3 48 c1 eb 03 42 80 3c 2b 00 <74> 08 4c 89 e7 e8 ff 88 c3 00 4d 8b 34 24 48 c7 c7 ff ff ff ff 4c
RSP: 0018:ffffc900043f7740 EFLAGS: 00000246
RAX: 0000000001ed289c RBX: 1ffffd400000f690 RCX: ffff888022338000
RDX: 0000000000000000 RSI: 0000000001ed289c RDI: 000000001fffffff
RBP: ffffc900043f7910 R08: ffffffff81424c05 R09: 1ffffffff1f583d5
R10: dffffc0000000000 R11: fffffbfff1f583d6 R12: ffffea000007b480
R13: dffffc0000000000 R14: 0000000000000001 R15: ffffffff81ed289c
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005622c0cea600 CR3: 000000000e132000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 text_poke arch/x86/kernel/alternative.c:1968 [inline]
 text_poke_bp_batch+0x8cd/0xb30 arch/x86/kernel/alternative.c:2357
 text_poke_flush arch/x86/kernel/alternative.c:2470 [inline]
 text_poke_finish+0x30/0x50 arch/x86/kernel/alternative.c:2477
 arch_jump_label_transform_apply+0x1c/0x30 arch/x86/kernel/jump_label.c:146
 static_key_enable_cpuslocked+0x136/0x260 kernel/jump_label.c:205
 static_key_enable+0x1a/0x20 kernel/jump_label.c:218
 toggle_allocation_gate+0xb5/0x250 mm/kfence/core.c:826
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.167 msecs


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
