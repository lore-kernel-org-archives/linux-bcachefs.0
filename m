Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E96E2B9A5
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Mar 2025 05:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742879787; cv=none; b=VeX3Qk/I28a8HwylUs0vUn/5rYo5r0s8mYPNljsqLZDLsNIpCXD3Gj4G7p7PitDPq9ww/aXsc7UVVqS03+bI81BcS+937HAH6slCF83xzX9yXmAO1z84xSobstQ37JNjRBfmdhN0zARjEFHqZt2wtTb8j8PZJ9daLxMcFt3D/GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742879787; c=relaxed/simple;
	bh=u0ClVa+B6VUbVBmBjaDQe2+IpDcW/Tw46dNL/Qy68Ig=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AztjEBsJDEiQBWcfAvk4B78FFdp/7pABBwXU2VDNNGkN52JLW/7iI6V7J1dxlhdYPo1dlt2eZCnJs38VSg4F25/+Y8ZY78XsyBBnr7NcBbHT/WX+7IhNu+w0bsfqNoKb5fqKTqyCK6bX/t4TGNHKrDZQMaBxze/Tjr5z7lhmTBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-85b418faf73so1207500039f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Mar 2025 22:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742879785; x=1743484585;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=49Wyjot1/RXrsvv+pJOQcQMQcX3wxG5AhGGcKlrmdxs=;
        b=QkjO++L2OnBxVtBu0YwY2uCCtHN08j8ZLD/hyVrm25BLseLatG6hmnOTNTQT4lsy8s
         NcCpxAwm0DKoqX6Do97f0sikjo+Hy5LNsm57v+vl2d53QELVB7VO8ZCYnSlZP6qBxcUA
         CswIJXY/6j8S5KXAb013VOJQOyskoDi40Nsd3dGvL7MmV+CFp+PWR8AN+yjqLUwbHttG
         8SPq1s3foKy0BAnXN8nN+SEwVS76zAq78tZirXvwPhhsMiHRfBH4i7kdz7YEJ2gF7Vj9
         /QjR7uAmJHtZHAfV/P0h0y2YcAbvwdrXMdlDiIuA25VTQOVhiCPPBnteNm1b9Gs6/o6e
         UVig==
X-Forwarded-Encrypted: i=1; AJvYcCWFHhUFvfiayNhMU06dkgjFX5e6N3eky9pmnEI+BzSlwP85eXVvMl2mi+lt2dwa69PtHxQfAX9LNb8RBZVtvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuLF1sAOSS3BQQc6H05UvFF9hnA/vRfEFDgsvqF8PyMvgV3Yzu
	NAbNsYiAIJaJOXufi6N+wUsBAI217PHN3lmcszrwmcBEpgf3PRyGp/JMvWE5mz34Zwey60K2kh2
	V38+hRTxgP7tcSfNbTDId/7R4KsJ1t2xhoUdgpcNxYXlXV8AlR6FNW4g=
X-Google-Smtp-Source: AGHT+IE+ZrLKmMe9eI0OoS/q5K9UZS3ycH+XT8GTMfAeFMsKVw6ua890/hvtVeILa1HKg0dzch014UpFL4SkZsW4EhPXHBawPVzt
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ce:b0:3d4:700f:67e7 with SMTP id
 e9e14a558f8ab-3d596177247mr153564915ab.17.1742879784664; Mon, 24 Mar 2025
 22:16:24 -0700 (PDT)
Date: Mon, 24 Mar 2025 22:16:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e23c28.050a0220.a7ebc.0038.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in __bch2_fsck_err
From: syzbot <syzbot+6f4fcb1aecbaa2aa6825@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5fc319360819 Merge tag 'net-6.14-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10105e98580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27515cfdbafbb90d
dashboard link: https://syzkaller.appspot.com/bug?extid=6f4fcb1aecbaa2aa6825
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110133b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-5fc31936.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/85179a8915f2/vmlinux-5fc31936.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cc4a866b3260/bzImage-5fc31936.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7a8c0330a7ea/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6f4fcb1aecbaa2aa6825@syzkaller.appspotmail.com

INFO: task syz.0.40:5746 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc7-syzkaller-00137-g5fc319360819 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.40        state:D stack:8536  pid:5746  tgid:5745  ppid:5473   task_flags:0x440140 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x190e/0x4c90 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_timeout+0xb0/0x290 kernel/time/sleep_timeout.c:75
 ___down_common kernel/locking/semaphore.c:229 [inline]
 __down_common+0x375/0x820 kernel/locking/semaphore.c:250
 down+0x84/0xc0 kernel/locking/semaphore.c:64
 console_lock+0x145/0x1b0 kernel/printk/printk.c:2833
 __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
 bch2_print_string_as_lines+0x20/0xc0 fs/bcachefs/util.c:286
 __bch2_fsck_err+0x1044/0x1420 fs/bcachefs/error.c:426
 check_snapshot fs/bcachefs/snapshot.c:774 [inline]
 bch2_check_snapshots+0x1ee1/0x3eb0 fs/bcachefs/snapshot.c:831
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f514938e90a
RSP: 002b:00007f514a2b2e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f514a2b2ef0 RCX: 00007f514938e90a
RDX: 00002000000000c0 RSI: 0000200000000000 RDI: 00007f514a2b2eb0
RBP: 00002000000000c0 R08: 00007f514a2b2ef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000200000000000
R13: 00007f514a2b2eb0 R14: 0000000000005903 R15: 0000200000000200
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/26:
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
2 locks held by getty/5106:
 #0: ffff88801aef10a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000019b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
4 locks held by kworker/0:0/5372:
2 locks held by kworker/0:5/5483:
4 locks held by syz.0.40/5746:
 #0: ffff888053680278 (&c->state_lock){+.+.}-{4:4}, at: bch2_fs_start+0x45/0x610 fs/bcachefs/super.c:1010
 #1: ffff888053684378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #1: ffff888053684378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #1: ffff888053684378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3408
 #2: ffff88804e5d4140 (bcachefs_btree){+.+.}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #2: ffff88804e5d4140 (bcachefs_btree){+.+.}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #2: ffff88804e5d4140 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3408
 #3: ffff8880536e1548 (&c->fsck_error_msgs_lock){+.+.}-{4:4}, at: __bch2_fsck_err+0x3b0/0x1420 fs/bcachefs/error.c:309
1 lock held by syz.5.468/6650:
2 locks held by syz.2.470/6654:
2 locks held by syz.3.471/6656:
2 locks held by syz.1.472/6658:
2 locks held by syz.4.473/6660:

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 26 Comm: khungtaskd Not tainted 6.14.0-rc7-syzkaller-00137-g5fc319360819 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
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
