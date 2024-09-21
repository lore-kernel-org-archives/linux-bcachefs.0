Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E9B13FD72
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 08:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726906887; cv=none; b=fzmDC8jPx7nW9dbvw5eLA2dfc/OIKGZl3BSP2QLALmwQOqJa8lfYy7nmdDgO6Uwkr4CbYsCExr8xYnMzBHvQ/UWK4MptV6d5UHqayMORTH+RYku2eR+2RyV4MCsrGHSAe7AtbOdGmVY+LXkhCKcZ4d3P+G0CJcxU4TOHQa4qcrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726906887; c=relaxed/simple;
	bh=WrDIk/EkBg2f5FsBP8qx7xoEVByyRDTvzpJ6Ec0Ag6o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IDdfQoiB4kmjno5X653whP0xVj/p2fnCPJiT+zFg2Bmy412dg+ztPGnaMukU36fsMF3dW4kUe2H2GAchG8Dty8Wj5IBuVDkXhn64IT8Um8nh3YR2jSWkzbeSc44WDvpckFb9Nr9y0aOGG387RFU4WUGrDIHSb+qVQ5CqG6VhP/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f510b3f81so35317255ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 01:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726906885; x=1727511685;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L38a55/awUqV6LuG1/5e9aAyTS3dm4s4GATY1Z+cqAI=;
        b=e3nrAytFx7G5G+w8gMwtXuFMFpoLfCqxZuEDt+DR8UwHUs3y5mIwIIaIHX0wuVPjAl
         X1oktUwUzxwud5M3R+jgo9ZV0/KmlPoVhwvOAVusI+JCfUPrEt1bSAWNd85mg5Alq4aC
         /gARPokXJTPn55EMI1tWF98Qs/f+3VrMwn9C8VQH7eTsNpZ9Y7AzqGPehmQkuZGRqhvb
         TjaMm7nXypaJOH9OcdI0eZYQp8sxFGCCHKdxSHzkJShSw5f/Q+zU8CoFadvtu5rlO89o
         laQpEDG15RP/qZuiKaGFdO/V6nTodxL73Iu2NYMbpfVbNI/blNgpDzMiTtBe67X+97ye
         zeQw==
X-Forwarded-Encrypted: i=1; AJvYcCVwNAoFn2Tmfuub+/kRS3/Ax02/5Ivhz9faFz5NPKZly3ScXEtxWhlQG0bYIS4Es2PYoKswrkpozE2tTIMeaw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvzTX4AsRlDmUK0oeLjm9ibZTDU2loGavQtKEfy2hSXao9hePu
	6oTROZCB2JzCBwPUmqSVQGpn4+05tcV1xD9TsC8eH0i7pH1ueS+YwrxXGL1mMHexmO55jWpKiX6
	PsX6bv8mj788R//RfqcOkWPylX7L9thw583dBXNz1lapxABRdW5YUnas=
X-Google-Smtp-Source: AGHT+IHnmaFe0AZkBar3w/qV/JlnyqH2VcGfTpjY5iq1L2ifBZL78+GKTJiKkuNL9bT4X7WUVgp04exexGayvxz1or0uLI2FOhw5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2a:b0:39f:5def:a23d with SMTP id
 e9e14a558f8ab-3a0bef529bdmr65625185ab.5.1726906884784; Sat, 21 Sep 2024
 01:21:24 -0700 (PDT)
Date: Sat, 21 Sep 2024 01:21:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ee8204.050a0220.3195df.0041.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_journal_reclaim_thread (2)
From: syzbot <syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1868f9d0260e Merge tag 'for-linux-6.12-ofs1' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f6ff00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d29c10b70cc6fdb8
dashboard link: https://syzkaller.appspot.com/bug?extid=820dc3b465c69f766a57
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/26c691e641b7/disk-1868f9d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfe97fd5f2eb/vmlinux-1868f9d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4a385cd95bd6/bzImage-1868f9d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+820dc3b465c69f766a57@syzkaller.appspotmail.com

INFO: task bch-reclaim/loo:6887 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:25080 pid:6887  tgid:6887  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5264 [inline]
 __schedule+0x1843/0x4b00 kernel/sched/core.c:6607
 __schedule_loop kernel/sched/core.c:6684 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6699
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6756
 __mutex_lock_common kernel/locking/mutex.c:684 [inline]
 __mutex_lock+0x6a7/0xd70 kernel/locking/mutex.c:752
 bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:738
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:0/11:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000107d00 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000107d00 ((reaper_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
3 locks held by kworker/u8:1/12:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000117d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000117d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
1 lock held by khungtaskd/30:
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
3 locks held by kworker/u8:4/66:
 #0: ffff88802dfb1948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88802dfb1948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900020bfd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900020bfd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4196
5 locks held by kworker/u8:8/2941:
 #0: ffff88801baeb148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801baeb148 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90009b17d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90009b17d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcaa8d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:580
 #3: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xe9/0xaa0 net/core/dev.c:11930
 #4: ffffffff8e93df78 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:297 [inline]
 #4: ffffffff8e93df78 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:976
2 locks held by dhcpcd/4884:
 #0: ffff88806f6926c8 (nlk_cb_mutex-ROUTE){+.+.}-{3:3}, at: __netlink_dump_start+0x119/0x790 net/netlink/af_netlink.c:2404
 #1: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #1: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_dumpit+0x99/0x200 net/core/rtnetlink.c:6505
2 locks held by getty/4974:
 #0: ffff88814bd6a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031232f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by kworker/u8:10/6132:
5 locks held by syz-executor/6609:
1 lock held by bch-reclaim/loo/6887:
 #0: ffff88806664af28 (&j->reclaim_lock){+.+.}-{3:3}, at: bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:738
1 lock held by syz.2.199/7144:
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
1 lock held by syz.4.224/7389:
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: super_lock+0x196/0x400 fs/super.c:120
1 lock held by syz.2.252/7644:
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88802425c0e0 (&type->s_umount_key#108){++++}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
1 lock held by syz-executor/7707:
1 lock held by syz-executor/8018:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643
1 lock held by syz-executor/8169:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643
1 lock held by syz-executor/8186:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
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
CPU: 1 UID: 0 PID: 7707 Comm: syz-executor Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:hlock_class kernel/locking/lockdep.c:228 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4823 [inline]
RIP: 0010:__lock_acquire+0x4dc/0x2050 kernel/locking/lockdep.c:5149
Code: 13 00 00 44 89 3b 44 89 c3 48 89 d8 48 c1 e8 06 48 8d 3c c5 80 97 21 94 be 08 00 00 00 e8 ec f3 88 00 48 0f a3 1d a4 62 b1 12 <73> 27 48 69 c3 c8 00 00 00 48 8d 98 80 16 be 93 48 ba 00 00 00 00
RSP: 0018:ffffc900033cf510 EFLAGS: 00000057
RAX: 0000000000000001 RBX: 0000000000000022 RCX: ffffffff817034d4
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff94219780
RBP: 0000000000000000 R08: ffffffff94219787 R09: 1ffffffff28432f0
R10: dffffc0000000000 R11: fffffbfff28432f1 R12: ffff88802e8c5a00
R13: 0000000000000022 R14: 0000000000020022 R15: 0000000000000000
FS:  0000555586251500(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f26c7f08178 CR3: 000000004783c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
 rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 __d_lookup+0x81/0x7b0 fs/dcache.c:2321
 lookup_fast+0x74/0x4a0 fs/namei.c:1690
 walk_component fs/namei.c:2049 [inline]
 link_path_walk+0x672/0xea0 fs/namei.c:2418
 path_openat+0x266/0x3590 fs/namei.c:3929
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b6f37c890
Code: 48 89 44 24 20 75 93 44 89 54 24 0c e8 19 8f 02 00 44 8b 54 24 0c 89 da 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 38 44 89 c7 89 44 24 0c e8 6c 8f 02 00 8b 44
RSP: 002b:00007fff27a11b50 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f8b6f37c890
RDX: 0000000000000000 RSI: 00007fff27a11c80 RDI: 00000000ffffff9c
RBP: 00007fff27a11c80 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000293 R12: 00007fff27a12d00
R13: 00007f8b6f3f0a14 R14: 00005555862514a8 R15: 0000000000000005
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
