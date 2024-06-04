Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726333F6
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 03:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717471706; cv=none; b=bma4gNjog0Lq1MFp1iuX4/yUktZfNKJuWKqUU1t/nrva6hjwPzv7ef4PNHTvGPzfedn4eIuf8GrSWfxz8qOFzaMLn09H8M5ZhNd2OYc8WIzF5GClqS8m9HpGtXklZltSHxcitRIPLcqkb6FtIHMSUg1v7rA4/KAlYBir/yMIfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717471706; c=relaxed/simple;
	bh=r+LMGsFDjKGrfYtjwqtQ9DI0AtDSolYht/k+NP0PAr0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Dsda/DdCNEn880VKK6Cczs2XFJzM/ziGqjiaxIhGFjLzqdhuhoX92kzbI3L2m9qyZMGCPMScD2TCT4BR2HFSZgEfdnhe6SXn5dZPrni3GhJIVPKAMGWgM3qaZzgKUScihLrkghHu8cDAiS1cKEHc0LJZphrHsVJfWplWzLIFJ/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3738732f988so47736275ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Jun 2024 20:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717471704; x=1718076504;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wMKI4AorUlxgItY/OLhGTJp+VuukHWFyKgfJr6mRZKs=;
        b=qkdT0E/jQU8aXKh0i0B0Kjinfwr8Rk6z1YT3fkv4TnB6paViRPR7mMcJWoDleWGfQr
         m6fanMBXMxPwmfZ8blC28W5/iqksHv+tmSzus+DMGZsYaERR0l/RgE+dhIsnbYbCM32x
         yLKoNvdbvkun0BwAVLZpw9KFFacK8xQmcbBol8HS2dW5yJTSohNhaM3Gm+7EZxEusevj
         Ix3k+VxgXd/4O5loVzUH40+4xR1iRNa5r2zLeClcvACG8CYm+DBkB+LZoj7X+P/ZE3un
         nRSZsX2Y8LriwznrDZJy7ZBTwb8iA+wHXcLoQ+wfKcnzwWD85Q64hvPNL2wGvXvyrXDr
         WM0A==
X-Forwarded-Encrypted: i=1; AJvYcCXmg3p1e52gzfTcXtsPZs6HtrTzZJ98sJxo0ADdzSYYiFvrTYy+Wav9oBTvYSM0uwW0M2NzKpdC3R4XSBD4cxzzAst0RWOB/9AweoJcWnU=
X-Gm-Message-State: AOJu0Yw+bmYhB0NumGgXKkWKAtzeOgFaO+XIpsgPar1JlWRpTXNmpzD/
	0eb5QYDsXlYC8aPzqFbxpN6RPWObgYsAyDjkTPke1nq3gO3NqFzKmYsF9nFeYF9m513jeJweZxL
	epgA2AX8fBDhJULlPFy5wWRZZ8M/nR8/jv9XuX4WT6s4IaLvzoF8QByU=
X-Google-Smtp-Source: AGHT+IEvEI+o73lBZo+wWm3Dwj9oxcVfmdpaG1VZQU4SnI9HgguqY3B0LZ0fzqN8GTFGruXqqWlUIjMhgKKjc3nGUh9hIvxWoYVw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c563:0:b0:36c:c4ce:8448 with SMTP id
 e9e14a558f8ab-3748ba658abmr5200425ab.6.1717471704037; Mon, 03 Jun 2024
 20:28:24 -0700 (PDT)
Date: Mon, 03 Jun 2024 20:28:24 -0700
In-Reply-To: <000000000000e9b6ff0618356b26@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4c7f4061a080a7a@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work
From: syzbot <syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f06ce441457d Merge tag 'loongarch-fixes-6.10-1' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17802a16980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb72437243175f22
dashboard link: https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164255f2980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16174432980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/00ecb7bdd1a8/disk-f06ce441.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3926ab949197/vmlinux-f06ce441.xz
kernel image: https://storage.googleapis.com/syzbot-assets/36849eea4fc5/bzImage-f06ce441.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bfad9a4a2dc4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com

INFO: task kworker/1:0:25 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc2-syzkaller-00007-gf06ce441457d #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:0     state:D
 stack:26248 pid:25    tgid:25    ppid:2      flags:0x00004000
Workqueue: events_long bch2_fs_read_only_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6894
 rwsem_down_write_slowpath+0xeeb/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common+0x1af/0x200 kernel/locking/rwsem.c:1306
 bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:392
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/1:0/25:
 #0: ffff888015081148 ((wq_completion)events_long){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015081148 ((wq_completion)events_long){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc900001f7d00 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc900001f7d00 ((work_completion)(&c->read_only_work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffff888075980278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_read_only_work+0x25/0x40 fs/bcachefs/super.c:392
1 lock held by khungtaskd/30:
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #0: ffffffff8e333f60 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
5 locks held by kworker/u8:2/35:
1 lock held by klogd/4522:
2 locks held by getty/4833:
 #0: ffff88802fb4a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2201
3 locks held by syz-executor131/5078:

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 30 Comm: khungtaskd Not tainted 6.10.0-rc2-syzkaller-00007-gf06ce441457d #0
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
CPU: 0 PID: 4515 Comm: syslogd Not tainted 6.10.0-rc2-syzkaller-00007-gf06ce441457d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:skb_ext_put include/linux/skbuff.h:4688 [inline]
RIP: 0010:skb_release_head_state+0x19d/0x250 net/core/skbuff.c:1165
Code: 4e f8 eb 16 31 ff 89 ee e8 80 50 4e f8 85 ed 0f 8e 8a 00 00 00 e8 33 4c 4e f8 49 8d 5e 7f 48 89 d8 48 c1 e8 03 42 0f b6 04 20 <84> c0 0f 85 84 00 00 00 0f b6 1b 31 ff 89 de e8 0f 4f 4e f8 85 db
RSP: 0018:ffffc90004907908 EFLAGS: 00000a07
RAX: 0000000000000000 RBX: ffff88802e28ecff RCX: ffff88807d280000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8947c904 R09: 1ffff11003ca5853
R10: dffffc0000000000 R11: ffffed1003ca5854 R12: dffffc0000000000
R13: ffff88802e28ec80 R14: ffff88802e28ec80 R15: ffff88802e28ece0
FS:  00007fa63915c380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e2897e7600 CR3: 000000002dc2c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 skb_release_all net/core/skbuff.c:1171 [inline]
 __kfree_skb net/core/skbuff.c:1187 [inline]
 consume_skb+0x7b/0x160 net/core/skbuff.c:1409
 __unix_dgram_recvmsg+0xcea/0x12f0 net/unix/af_unix.c:2474
 sock_recvmsg_nosec net/socket.c:1046 [inline]
 sock_recvmsg+0x22f/0x280 net/socket.c:1068
 sock_read_iter+0x2ca/0x3e0 net/socket.c:1138
 new_sync_read fs/read_write.c:395 [inline]
 vfs_read+0x9c4/0xbd0 fs/read_write.c:476
 ksys_read+0x1a0/0x2c0 fs/read_write.c:619
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa6392b0b6a
Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffec9bf54e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fa6392b0b6a
RDX: 00000000000000ff RSI: 000055cf5b545950 RDI: 0000000000000000
RBP: 000055cf5b545910 R08: 0000000000000001 R09: 0000000000000000
R10: 00007fa63944f3a3 R11: 0000000000000246 R12: 000055cf5b54598a
R13: 000055cf5b545950 R14: 0000000000000000 R15: 00007fa639493a80
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.151 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
