Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631DB16132A
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Sep 2024 21:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727558307; cv=none; b=UPlsGciROBzOPm2wxt+BWEc8CQbghu3rHqnf9kOqXuqLs1JmF0BT/RRw8C7vwI/Zr1KppjSZnPgn3I4/VoC19XKKQ/i1sF44cYyxx+HB48lZ1MaMAO1Av8gPDH+T+gFHYok7SZuXChETw5bnKoYpq8MpJp6FecVt1HoKuPFLS0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727558307; c=relaxed/simple;
	bh=27kvSBwoiXN9dDYGdiDTZme6DGze9J8GsBD2LCBgQgg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=ToH3jJjCWAfVGfx2HgGOeIC1I8d+y8CtjP0cfciVN5qpEk9ZOQht+MmzmG4hR8hJx3YZ7nAJN3Ji5zu6skigGZLXTyZxuCxqLjxETVgrbkACbhlqmf+ljZQT0A58vjAlcKPALOS0VYo93M6qgYCeeRwW9X/hbENeR2SMnNx8/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a342e7e49cso42198965ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 28 Sep 2024 14:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727558304; x=1728163104;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gd7bxZhR8xFy64gJLLdrSEM4S5DvRb1EafC5CA94Vwc=;
        b=gC/CR2Ap6YsqaTxwMHy14xqCLRdjOhMaHquqVrZCJNiE5wJLh+o/00PkcVKlQ6tmnc
         aAGX51IqdpVAdMQQYQkU4nrUQNb4l+yoSDznJwKUoY2A5OTnkDXWw/+VIVc6Q+2gwd4W
         hqNKvU3WPHQvZceWjCk1uVrluA7hqgxrKIV+qVxgoH/SKLHH2CCbKqAZY2mmGu6kAu38
         VKLT7dapVZo09TSSSib9VUgpWPpcQ3AAB5LxECinFnDcxRwXwJ27xpOShM0BmDYjCpq1
         pJNh48+KFXsEe8xnf918oqOI4/ka4Qpezlr0paVwGYOs0emkl8sehP4PO2uiTceKwco1
         2d6g==
X-Forwarded-Encrypted: i=1; AJvYcCUUQPq73PeeTCtcvJ08E5KCt/UZ8Zc9jRU6XMtOD8ZdnhLUTGz10Oqkijq718kBFyAKoN4QVFACdeF3sQFfVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YznAguLUCvwBBz9RlqDIevH0oH0qB2es08t6OwV8/N6Y9gkV9KC
	22ZrykyQXElxQMtY7LF55T3E0R0TvkqgN5G2C8F15u+iBIeIju/fJiYjNbGpp1bRDyHK6XDrpr3
	KvQ9sNxRAvEh9Th73nLdEsrOVzpYasC+zez6TLwzongGJ102KDUEsnr0=
X-Google-Smtp-Source: AGHT+IG8hbMyfNq8ugaummtrzr2TLYE4CfhGenI1tn4LGAq5ID4y982GC2zidQS/Wj+TSKqALj/3B6Hm8bZUCoQ/HGPiuHs3Me5g
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1569:b0:39d:4c8a:370d with SMTP id
 e9e14a558f8ab-3a3451b6941mr62709085ab.18.1727558304495; Sat, 28 Sep 2024
 14:18:24 -0700 (PDT)
Date: Sat, 28 Sep 2024 14:18:24 -0700
In-Reply-To: <66ee8204.050a0220.3195df.0041.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f872a0.050a0220.4a974.000f.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_journal_reclaim_thread
 (2)
From: syzbot <syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ad46e8f95e93 Merge tag 'pm-6.12-rc1-2' of git://git.kernel..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17257e27980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4123da9de65c5cb5
dashboard link: https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=149c5e80580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149f8d9f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0a6feee5a983/disk-ad46e8f9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0017287e7d32/vmlinux-ad46e8f9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0ed0fe56738c/bzImage-ad46e8f9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/984eda72cdcf/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com

INFO: task bch-reclaim/loo:5227 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:26552 pid:5227  tgid:5227  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5315 [inline]
 __schedule+0x1843/0x4ae0 kernel/sched/core.c:6675
 __schedule_loop kernel/sched/core.c:6752 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6767
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6824
 __mutex_lock_common kernel/locking/mutex.c:684 [inline]
 __mutex_lock+0x6a7/0xd70 kernel/locking/mutex.c:752
 bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:739
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
2 locks held by getty/4974:
 #0: ffff88814bd950a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz-executor104/5217:
1 lock held by bch-reclaim/loo/5227:
 #0: ffff8880773cb0a8 (&j->reclaim_lock){+.+.}-{3:3}, at: bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:739

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
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
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5217 Comm: syz-executor104 Not tainted 6.11.0-syzkaller-11728-gad46e8f95e93 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:__trans_next_path fs/bcachefs/btree_iter.h:109 [inline]
RIP: 0010:__bch2_trans_unlock fs/bcachefs/btree_locking.c:726 [inline]
RIP: 0010:bch2_trans_unlock+0x41/0x470 fs/bcachefs/btree_locking.c:810
Code: 00 00 00 00 00 fc ff df e8 bc 97 7a fd 49 8d 5f 3a 48 89 dd 48 c1 ed 03 42 0f b6 44 35 00 84 c0 0f 85 bb 03 00 00 44 0f b7 23 <bf> 01 00 00 00 44 89 e6 e8 32 9b 7a fd 41 83 fc 01 0f 86 90 02 00
RSP: 0018:ffffc90002f5f338 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88807e07003a RCX: ffff8880772f5a00
RDX: 0000000000000000 RSI: 0000000000000009 RDI: ffff88807e070000
RBP: 1ffff1100fc0e007 R08: ffffffff842029da R09: 1ffff920005ebe64
R10: dffffc0000000000 R11: fffff520005ebe65 R12: 0000000000000040
R13: ffffc90002f5f550 R14: dffffc0000000000 R15: ffff88807e070000
FS:  0000555563498380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd670dbd0c CR3: 0000000029568000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 btree_write_buffer_flush_seq+0x17a/0x1bc0 fs/bcachefs/btree_write_buffer.c:501
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x8e/0x260 fs/bcachefs/journal_reclaim.c:819
 bch2_journal_flush_pins+0x102/0x3a0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x124/0x430 fs/bcachefs/super.c:274
 bch2_fs_read_only+0xb57/0x1200 fs/bcachefs/super.c:354
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:619
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2179
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
RIP: 0033:0x7f7d6ff06587
Code: 07 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffeb085b6c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000555563498338 RCX: 00007f7d6ff06587
RDX: 00000000000108d0 RSI: 0000000000000009 RDI: 00007ffeb085c870
RBP: 0000000000000064 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000100 R11: 0000000000000246 R12: 00007ffeb085c870
R13: 00005555634a1700 R14: 431bde82d7b634db R15: 00007ffeb085d900
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.552 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
