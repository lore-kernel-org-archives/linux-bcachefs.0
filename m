Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2312222D45
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 10:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734603923; cv=none; b=nA1pscMO2BX4ru2AUdkOtqG1CBks+huhUmdnlrLHWmr/JKXxsZwCR30PkCfF03xciO7X6pTMZzurRoTfT68H4f8Y0+R0aXlf/BaPVWjOprjoGb2OHG0ZbMYf3/TtJWIOl80u93gtn5PIAxiTNjPs+/0ns2R2ZeByZ0yMtzTQIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734603923; c=relaxed/simple;
	bh=FV1CZ0SuKwJPtXUbExJUr9qSuycbYnMAYwa2gAgGhsE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=frZnEr3AJ7T9myAvE20XlceNOna5Yq15OBt0l5FfEDzkMdmBI3cdCJJEiPvq9X4eJ1EyPIB5XMxM9sa5qa19I2wQpIsYzEBdzgvy2q1lVk5OISV4syCBrwH/pS9fH84JhAT5h5IQswKbBB27EFlVI4cB+lxsBUi4ErvXrcyrDX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e39b48a2so12580625ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Dec 2024 02:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734603921; x=1735208721;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmMz/pRDNvSZlDLVANm+Lo3llqEVsRAHoy/Ru77ZZmA=;
        b=Y1njr8AlvbrwaVNr6Xj8KblDH0YhulWo8QkC9ohbUVeWnye7wQ0WzCjev3kBxLneu6
         u0F+tEP+E5rawsYbIL6mI9MgPkpE65WPPewzdCUXuSxSrU5/bnEVIQ7EvIbTisZpnsQV
         tqbGMHEmq3MKje19/gFv8NKuhHdjmN2puRQl7jyG253LvIwRoedyWjDJUUudp7z5NfET
         ug1wDEKYDYr9D0o4kIXWV6w5N2UxfMTi9bHMjMiezVR+Pg92uUpbPAsphlVwI6S83n/c
         4FgWJlrYZ8tmfpOmycYzRqdBH8nGe3J0BYeg6S8tjHRUS4HNEiOft0PzBbQPpyNutRP3
         xDnw==
X-Forwarded-Encrypted: i=1; AJvYcCUhrxAKabJw8YD/ASviAIM6Ij3pJmfM6cXdfYzWNCieHUONgYgJL1vXyPrSENLBNZ8U6qbqrV8AcoEDe008YQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmqwqwMztics3Mc6uATGsjUwLr0GJepAf/N9tX2+KSIHQWTKR+
	5WnexghyZbDQ+VHeldvL7BPf7Y5PGljXccUyAqa8HlztOoOkvMEg8vaFYRQzSOjzfIKJVJvF6KN
	p7rFh1STjetqctwnwC29BYrFwexpWCLtmCzpxtTUSgp5UqVDFXBPP2qM=
X-Google-Smtp-Source: AGHT+IFgcWWr/TT5mH9sHfX1sMAbNYb+2bMZPhNpX02nFltE5C7myZOviHQRFIbLAU2K/lN7ovitTnEQee4RZhN+Yid4VZEBa7UI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2164:b0:3a7:e0c0:5f25 with SMTP id
 e9e14a558f8ab-3c01062a2c5mr25190575ab.4.1734603920920; Thu, 19 Dec 2024
 02:25:20 -0800 (PST)
Date: Thu, 19 Dec 2024 02:25:20 -0800
In-Reply-To: <000000000000545c120618dd6c63@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6763f490.050a0220.15da49.000e.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_readahead
From: syzbot <syzbot+a6060114362257e9798a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15d75f44580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=a6060114362257e9798a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b47730580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d75f44580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a4dff87674a/disk-eabcdba3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/266bc2b7ced3/vmlinux-eabcdba3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee4bcd9be832/bzImage-eabcdba3.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/73bc7d7deab0/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/8001214ce016/mount_6.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a6060114362257e9798a@syzkaller.appspotmail.com

INFO: task syz-executor385:6297 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor385 state:D stack:14368 pid:6297  tgid:6296  ppid:5836   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 __bch2_two_state_lock+0x229/0x2c0 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x9a2/0x11e0 fs/bcachefs/fs-io-buffered.c:258
 read_pages+0x176/0x750 mm/readahead.c:160
 page_cache_ra_order+0x7e3/0xb60 mm/readahead.c:512
 filemap_readahead mm/filemap.c:2518 [inline]
 filemap_get_pages+0x95f/0x2080 mm/filemap.c:2563
 filemap_splice_read+0x68e/0xef0 mm/filemap.c:2922
 do_splice_read fs/splice.c:985 [inline]
 splice_direct_to_actor+0x4af/0xc80 fs/splice.c:1089
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 do_sendfile+0x564/0x8a0 fs/read_write.c:1363
 __do_sys_sendfile64 fs/read_write.c:1424 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1410
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f53f8244f99
RSP: 002b:00007f53f81fb218 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f53f82f16c8 RCX: 00007f53f8244f99
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000005
RBP: 00007f53f82f16c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0001000000201005 R11: 0000000000000246 R12: 00007f53f82bdd3c
R13: 756d6d695f737973 R14: 656c626174756d6d R15: 00007f53f829906b
 </TASK>
INFO: task syz-executor385:6308 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor385 state:D stack:26768 pid:6308  tgid:6296  ppid:5836   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 folio_lock include/linux/pagemap.h:1151 [inline]
 truncate_inode_pages_range+0xc1f/0x10e0 mm/truncate.c:380
 truncate_inode_pages mm/truncate.c:407 [inline]
 truncate_pagecache mm/truncate.c:715 [inline]
 truncate_setsize+0xcf/0xf0 mm/truncate.c:740
 bchfs_truncate+0x6f3/0xc90 fs/bcachefs/fs-io.c:441
 notify_change+0xbca/0xe90 fs/attr.c:552
 do_truncate fs/open.c:65 [inline]
 do_ftruncate+0x462/0x580 fs/open.c:181
 do_sys_ftruncate fs/open.c:196 [inline]
 __do_sys_ftruncate fs/open.c:201 [inline]
 __se_sys_ftruncate fs/open.c:199 [inline]
 __x64_sys_ftruncate+0x94/0xf0 fs/open.c:199
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f53f8244f99
RSP: 002b:00007f53f81da218 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007f53f82f16d8 RCX: 00007f53f8244f99
RDX: 00007f53f821e5f6 RSI: 0000000000000006 RDI: 0000000000000005
RBP: 00007f53f82f16d0 R08: 00007ffd7e15fa57 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f53f82bdd3c
R13: 756d6d695f737973 R14: 00007ffd7e15f970 R15: 00007ffd7e15fa58
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
2 locks held by getty/5572:
 #0: ffff8880358e10a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000330b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by syz-executor385/6297:
 #0: ffff8880781a4668 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
 #0: ffff8880781a4668 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x326/0xb60 mm/readahead.c:488
2 locks held by syz-executor385/6308:
 #0: ffff8880308fc420 (sb_writers#9){.+.+}-{0:0}, at: do_ftruncate+0x28b/0x580 fs/open.c:178
 #1: ffff8880781a44c8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880781a44c8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: do_truncate fs/open.c:63 [inline]
 #1: ffff8880781a44c8 (&sb->s_type->i_mutex_key#14){+.+.}-{4:4}, at: do_ftruncate+0x44e/0x580 fs/open.c:181

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 6317 Comm: kworker/u8:0 Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Workqueue: events_unbound toggle_allocation_gate
RIP: 0010:insn_get_opcode+0x51/0xe80 arch/x86/lib/insn.c:279
Code: 4d 8d 6f 1c 4c 89 ed 48 c1 ed 03 42 0f b6 44 35 00 84 c0 0f 85 1e 0b 00 00 41 0f b6 5d 00 45 31 e4 31 ff 89 de e8 0f 95 df f5 <85> db 74 0a e8 06 92 df f5 e9 cc 0a 00 00 4c 89 ff e8 c9 e4 ff ff
RSP: 0018:ffffc90003cc7658 EFLAGS: 00000293
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8880306f3c00
RDX: ffff8880306f3c00 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff92000798f27 R08: ffffffff8bbfe191 R09: 0000000000000000
R10: ffffc90003cc7920 R11: fffff52000798f2f R12: 0000000000000000
R13: ffffc90003cc793c R14: dffffc0000000000 R15: ffffc90003cc7920
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc84f01c580 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 insn_get_modrm+0x63/0x730 arch/x86/lib/insn.c:369
 insn_get_sib arch/x86/lib/insn.c:443 [inline]
 insn_get_displacement+0x151/0x9a0 arch/x86/lib/insn.c:484
 insn_get_immediate+0x62/0x11f0 arch/x86/lib/insn.c:650
 insn_get_length arch/x86/lib/insn.c:723 [inline]
 insn_decode+0x2d6/0x4c0 arch/x86/lib/insn.c:762
 text_poke_loc_init+0xed/0x870 arch/x86/kernel/alternative.c:2428
 arch_jump_label_transform_queue+0x8f/0x100 arch/x86/kernel/jump_label.c:138
 __jump_label_update+0x177/0x3a0 kernel/jump_label.c:513
 static_key_disable_cpuslocked+0xd2/0x1c0 kernel/jump_label.c:240
 static_key_disable+0x1a/0x20 kernel/jump_label.c:248
 toggle_allocation_gate+0x1bf/0x260 mm/kfence/core.c:854
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.354 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
