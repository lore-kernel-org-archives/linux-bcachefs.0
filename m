Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7511F391
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Dec 2024 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733362166; cv=none; b=MFGC+1YDvT7NDaXel9/LrEETq0KJKLMVnxuwIxvuE2EN45mPVi0QPkRN+CgAefhBUGb92lu2S6o+4lnDvRwlHXs9i+xF0QddMdv2Z16iSbJvVQV6VJwvZGlKLO4mB/attirICFfBkmwbSCEsES76BXtFFH1dLYZs87V6Si+pgPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733362166; c=relaxed/simple;
	bh=oXCCELjhpbOjhgbLHSLOABqZkLkY+2KXtOofsebNK1U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VyXPn6WJVRPU85ugkU9EUN/2pdWTe98QSZGc44Alkj0DqePxoY1cw95NeU7fOrrQu9C/oYXLLu2TOGeNLdNUD+EQjrnBLODoSYgrjXkigNpEo1QrU7+njOuw+01k5xOpDUAESLnfNuBE4gyJoNugp45KrzYCoiXVIpO4/MQZhY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a71bdd158aso3630765ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 04 Dec 2024 17:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733362163; x=1733966963;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ihvd3p1P0uky0Tk5RW8Az0usZWtONx03CK2UdJ2RU0s=;
        b=eG9/l+4kSScv4no8qWK4ScKFgbW967+Np57V+I2Pj+Ar75dwYQ9cBOEDj+jCsdLVnA
         sNDjaJxf31SMM2x1O22puQ2kuRI9vIK0DT8JmO7LuSrdhNjl6D7J+yjN23wxEE1NuEvM
         toqnPhTPBjGKS9Xa7CIP1N5S/E+WDCXe00MKJ5Zzn4vPRiz0BgGD1O4mh4aXc900fMDn
         T4bXrxDEugLk2rtCfQGeQBFHozDAVugVuYe/a11TTUaOVk5mdU2kFZgG4PdOfFHoxP2l
         iFOF7G7Sh93EbHe8icz+Vw3P2PFKrdjfvSGKCdg8pwYLmMuShU28KHdmcKCViBEc2SWX
         m7ww==
X-Forwarded-Encrypted: i=1; AJvYcCU7sTSkULQPiy2/YJv+OpZviHfNIhX6qLAmBWA5ao9drEP2sHOJ81ybP8iBzhp/aT++TadNRAu8KgGnjOPhdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLcLboel3Ljfu4lQkFra+VoNZNxM6Sqyt1mKrjKPjlBzWh/NSN
	yZnqIQfFxbEhVtb/S0FSelWnoHZgzEHiW9H3SKgDNdDfBlNAzXdqTNdYO9OY8VX3ftrdY/POGu7
	JR/mD7YaaCfULu11xxSnfLhW/XbFohabHiwEV2Qsz2zroApUXwGwHLoY=
X-Google-Smtp-Source: AGHT+IHL0sBchZA9XcW7SU70i0B7GjCUY+R3OLre79Bn0J6CnvSN/Zp1qBrsFydgBSRPoURZjeTD+MVBcstLJRTCDQF2/QzCmiHg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2167:b0:3a7:e0c0:5f0d with SMTP id
 e9e14a558f8ab-3a7f9a37e4dmr122671695ab.3.1733362163676; Wed, 04 Dec 2024
 17:29:23 -0800 (PST)
Date: Wed, 04 Dec 2024 17:29:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675101f3.050a0220.17bd51.0081.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in do_truncate (3)
From: syzbot <syzbot+effe7da6578cd423f98f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    feffde684ac2 Merge tag 'for-6.13-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=107f48df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91c852e3d1d7c1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=effe7da6578cd423f98f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2efea2e60149/disk-feffde68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5331b060319/vmlinux-feffde68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ffe1099c1fd2/bzImage-feffde68.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+effe7da6578cd423f98f@syzkaller.appspotmail.com

INFO: task syz.0.32:6097 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.32        state:D stack:18040 pid:6097  tgid:6096  ppid:5826   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6905
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1176
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1578
 inode_lock include/linux/fs.h:818 [inline]
 do_truncate+0x20c/0x310 fs/open.c:63
 handle_truncate fs/namei.c:3449 [inline]
 do_open fs/namei.c:3832 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3987
 do_filp_open+0x27f/0x4e0 fs/namei.c:4014
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_open fs/open.c:1425 [inline]
 __se_sys_open fs/open.c:1421 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1421
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6d3397ff19
RSP: 002b:00007f6d3477f058 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f6d33b45fa0 RCX: 00007f6d3397ff19
RDX: 0000000000000000 RSI: 000000000014927e RDI: 0000000020000300
RBP: 00007f6d339f3986 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f6d33b45fa0 R15: 00007ffe48f28138
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937aa0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937aa0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937aa0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
2 locks held by kworker/u8:7/3010:
 #0: ffff8880b863e758 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
 #1: ffffc9000bb87d00 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000bb87d00 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
2 locks held by getty/5580:
 #0: ffff88814d0720a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by syz.0.32/6097:
 #0: ffff8880795aa420 (sb_writers#18){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff8880583808c8 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880583808c8 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: do_truncate+0x20c/0x310 fs/open.c:63
5 locks held by syz.0.32/6129:
 #0: ffff8880795aa420 (sb_writers#18){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff8880583808c8 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880583808c8 (&sb->s_type->i_mutex_key#25){++++}-{4:4}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff888052300a38 (&c->snapshot_create_lock){.+.+}-{4:4}, at: bch2_truncate+0x166/0x2d0 fs/bcachefs/io_misc.c:292
 #3: ffff888052304398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #3: ffff888052304398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #3: ffff888052304398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #4: ffff8880523266d0 (&c->gc_lock){++++}-{4:4}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1197

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
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
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:1 Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: bat_events batadv_purge_orig
RIP: 0010:batadv_purge_orig_ref+0x17f/0x1660 net/batman-adv/originator.c:1295
Code: 98 00 00 00 42 80 3c 30 00 4c 8b 74 24 70 74 0d 4c 89 f7 e8 e3 3d 73 f6 48 8b 54 24 38 48 8b 4c 24 40 48 8d 1c cd 00 00 00 00 <49> 03 1e 49 89 de 49 c1 ee 03 48 b8 00 00 00 00 00 fc ff df 41 80
RSP: 0018:ffffc90000117a40 EFLAGS: 00000246
RAX: 1ffff11004ac1e68 RBX: 0000000000001028 RCX: 0000000000000205
RDX: ffff88802560f348 RSI: 0000000000000400 RDI: 0000000000000000
RBP: ffffc90000117ba0 R08: ffffffff8b93ef65 R09: 1ffffffff203036e
R10: dffffc0000000000 R11: ffffffff8b939a10 R12: ffff88805c3a8ec8
R13: ffffffff8168f006 R14: ffff88802560f340 R15: 0000000002000000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563ee709d680 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 batadv_purge_orig+0x19/0x60 net/batman-adv/originator.c:1329
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
