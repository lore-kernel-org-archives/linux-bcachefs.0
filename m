Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF171F417D
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 07:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743060450; cv=none; b=KMjNtxSEnGM/dfrSAXv7HNgUOHH/21zPXwgoeHAfqtmttq0pRD3741PpaWwZQnNefEA9l5K1SIVa+0jA/LlOTzrLuhczg9K8wztsVIPfCmMWJUJQbd51upXIRBpqvURuCJpE2JMnbeREpw1DzU1fYRSkoye1GDi6xsKKSlABRFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743060450; c=relaxed/simple;
	bh=5X45kZowYE5mYUWuDCpLfOVcRiTu6rkscMtSG0GSO4k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OzXLjC7WDgXRbQh9evzvrVNxhka/LUFqDADfgm6vOyJdnrjH1kvbkPeQ0l4OJpaivBskwCU+lL7+Q7Lj6X3h8CtglvcPDTp3Ew4h7YI3onlJ9L5Sv/4ismKJdcNLci8doFyBzpjJdQXRvZlnaFgHZxFFfQRYkqKsikQTcLVDXPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d5bb1708e4so12784985ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 00:27:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743060447; x=1743665247;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+0b0lHSIbFfwt/1Y5xYGQsWxVjkrPSTc/Meg4PAzYlw=;
        b=NQ4tELnOCR85KRe4i6iZ8ykew3XsY3es9VRgw0u+IYBVdAU5dS9lNtJZ/WVRWc42gY
         JKBkcz29xA2ZkdfEUMNm8gB3pETo7utYJGJqqG2IsfXJcobszuPRkaQdAkQGPjmoNrpv
         +YMbP7fOGYGW7UKRdTwerI99Q8eRtJLtRtkiz1fTqlnEktAYkaPwW7m6D9yfR4ixh+dY
         J9Yh3lMEMVZAgQ2BU+fWk5T4E4vEGJ4fD5r5LrjZf7WVDWlBB0D7CkBKhuOpbEpigGBC
         ZJFa5sAZ6IlPOeonQ3v8xNX0CJUVN6DCQIXP0KZVQ6/SIvX82M/5u0R0vqK8zrvCxeuR
         8pCw==
X-Forwarded-Encrypted: i=1; AJvYcCUx6bSd+WQsjRtkxWFYB04PeUBp6fWcmX88YyPnBV/QKi5/OQR5GZzxdr3KjVr0GUv2rDmHOKr8yn1LMN89OA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwU0Tvv8dAcXVCKQ5QGAFhSZl17Dsw/28TY8KC5wY5ojFl2/bUT
	w98i/cLEuc7IdnIounjNAQz6wV3A2t8gViDezpxvehZJPbNNyHol24v1QjoLrBODcCMHZKAe2cc
	RZWDXPXgv0CV4A4heQxtaZUrOAP2g/k0zTS4SArzXtO98Bhziz4MErnY=
X-Google-Smtp-Source: AGHT+IFBEO9+3vBRVh/Y+ilM2tB5/SDj0vK0bu8lGuEw0gvexa8wq7ks5xTCDd2YMvIJJ2ImSrp4TZarHFzPwKGgQZ/RTVI/heic
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe6:b0:3d4:3d63:e076 with SMTP id
 e9e14a558f8ab-3d5cce1d546mr31080475ab.18.1743060447423; Thu, 27 Mar 2025
 00:27:27 -0700 (PDT)
Date: Thu, 27 Mar 2025 00:27:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e4fddf.050a0220.2f068f.0024.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in chown_common (6)
From: syzbot <syzbot+389a7212df1c1578006b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    183601b78a9b Merge tag 'perf-urgent-2025-03-22' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ab73b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=620facf12ff15d10
dashboard link: https://syzkaller.appspot.com/bug?extid=389a7212df1c1578006b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e77793f17fc6/disk-183601b7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2cd0002d51f0/vmlinux-183601b7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8e3a49885711/bzImage-183601b7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+389a7212df1c1578006b@syzkaller.appspotmail.com

INFO: task syz.4.27:6087 blocked for more than 143 seconds.
      Not tainted 6.14.0-rc7-syzkaller-00202-g183601b78a9b #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.4.27        state:D stack:27392 pid:6087  tgid:6052  ppid:5842   task_flags:0x400040 flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5378 [inline]
 __schedule+0x18bc/0x4c40 kernel/sched/core.c:6765
 __schedule_loop kernel/sched/core.c:6842 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6857
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6914
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1176
 __down_write_common kernel/locking/rwsem.c:1304 [inline]
 __down_write kernel/locking/rwsem.c:1313 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1578
 inode_lock include/linux/fs.h:877 [inline]
 chown_common+0x3e1/0x850 fs/open.c:772
 vfs_fchown fs/open.c:850 [inline]
 ksys_fchown+0xe2/0x150 fs/open.c:862
 __do_sys_fchown fs/open.c:867 [inline]
 __se_sys_fchown fs/open.c:865 [inline]
 __x64_sys_fchown+0x7a/0x90 fs/open.c:865
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3a5638d169
RSP: 002b:00007f3a541d5038 EFLAGS: 00000246 ORIG_RAX: 000000000000005d
RAX: ffffffffffffffda RBX: 00007f3a565a6080 RCX: 00007f3a5638d169
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f3a5640e2a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3a565a6080 R15: 00007fff6de31378
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u8:1/13:
 #0: ffff88814cbf3948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff88814cbf3948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
 #1: ffffc90000127c60 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc90000127c60 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
 #2: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:129 [inline]
 #2: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x10e/0x16a0 net/ipv6/addrconf.c:4190
1 lock held by khungtaskd/31:
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8eb393e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6746
6 locks held by kworker/u8:3/53:
 #0: ffff88801bef3948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff88801bef3948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
 #1: ffffc90000bd7c60 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc90000bd7c60 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
 #2: ffffffff8feb7410 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0x17a/0xd60 net/core/net_namespace.c:606
 #3: ffff88807cd8d0e8 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:1030 [inline]
 #3: ffff88807cd8d0e8 (&dev->mutex){....}-{4:4}, at: devl_dev_lock net/devlink/devl_internal.h:108 [inline]
 #3: ffff88807cd8d0e8 (&dev->mutex){....}-{4:4}, at: devlink_pernet_pre_exit+0x13b/0x440 net/devlink/core.c:506
 #4: ffff888027a4c250 (&devlink->lock_key#12){+.+.}-{4:4}, at: devl_lock net/devlink/core.c:276 [inline]
 #4: ffff888027a4c250 (&devlink->lock_key#12){+.+.}-{4:4}, at: devl_dev_lock net/devlink/devl_internal.h:109 [inline]
 #4: ffff888027a4c250 (&devlink->lock_key#12){+.+.}-{4:4}, at: devlink_pernet_pre_exit+0x14d/0x440 net/devlink/core.c:506
 #5: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: nsim_destroy+0xa4/0x620 drivers/net/netdevsim/netdev.c:1016
2 locks held by getty/5582:
 #0: ffff8880359ba0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x616/0x1770 drivers/tty/n_tty.c:2211
3 locks held by kworker/0:6/5923:
 #0: ffff88801b080d48 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3213 [inline]
 #0: ffff88801b080d48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x98b/0x18e0 kernel/workqueue.c:3319
 #1: ffffc900044bfc60 ((work_completion)(&(&devlink->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3214 [inline]
 #1: ffffc900044bfc60 ((work_completion)(&(&devlink->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9c6/0x18e0 kernel/workqueue.c:3319
 #2: ffffffff8eb3e8b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:302 [inline]
 #2: ffffffff8eb3e8b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x381/0x820 kernel/rcu/tree_exp.h:996
5 locks held by syz.4.27/6053:
 #0: ffff888031d3e420 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:547
 #1: ffff88805c0008e0 (&sb->s_type->i_mutex_key#20/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:912 [inline]
 #1: ffff88805c0008e0 (&sb->s_type->i_mutex_key#20/1){+.+.}-{4:4}, at: filename_create+0x260/0x540 fs/namei.c:4082
 #2: ffff88805c000cc8 (&inode->ei_update_lock){+.+.}-{4:4}, at: __bch2_create+0x355/0xf40 fs/bcachefs/fs.c:550
 #3: ffff88805d084378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #3: ffff88805d084378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #3: ffff88805d084378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3408
 #4: ffff88805d0a66d0 (&c->gc_lock){.+.+}-{4:4}, at: bch2_btree_update_start+0x680/0x1540 fs/bcachefs/btree_update_interior.c:1182
2 locks held by syz.4.27/6087:
 #0: ffff888031d3e420 (sb_writers#13){.+.+}-{0:0}, at: mnt_want_write_file+0x5e/0x200 fs/namespace.c:591
 #1: ffff88805c0008e0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: inode_lock include/linux/fs.h:877 [inline]
 #1: ffff88805c0008e0 (&sb->s_type->i_mutex_key#20){++++}-{4:4}, at: chown_common+0x3e1/0x850 fs/open.c:772
3 locks held by kworker/u8:9/7839:
1 lock held by syz-executor/8812:
 #0: ffff88802a39a0e0 (&type->s_umount_key#68){++++}-{4:4}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88802a39a0e0 (&type->s_umount_key#68){++++}-{4:4}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88802a39a0e0 (&type->s_umount_key#68){++++}-{4:4}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
2 locks held by syz-executor/9086:
 #0: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:335 [inline]
 #0: ffffffff8fec3c48 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc55/0x1d30 net/core/rtnetlink.c:4021
 #1: ffffffff8eb3e8b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:334 [inline]
 #1: ffffffff8eb3e8b8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x820 kernel/rcu/tree_exp.h:996

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted 6.14.0-rc7-syzkaller-00202-g183601b78a9b #0
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
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 3445 Comm: kworker/u8:7 Not tainted 6.14.0-rc7-syzkaller-00202-g183601b78a9b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Workqueue: bat_events batadv_nc_worker
RIP: 0010:__lock_acquire+0xcbf/0x2100 kernel/locking/lockdep.c:5201
Code: bf 00 00 00 00 00 fc ff df 48 0f a3 1d da 92 b4 12 0f 83 66 09 00 00 49 8d 9d e0 0a 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <80> 3c 38 00 74 12 48 89 df e8 63 b2 89 00 48 bf 00 00 00 00 00 fc
RSP: 0018:ffffc9000c607850 EFLAGS: 00000806
RAX: 1ffff1100633315c RBX: ffff888031998ae0 RCX: ffffffff819ce554
RDX: 0000000000000000 RSI: 0000000000000008 RDI: dffffc0000000000
RBP: ffff888031998b40 R08: ffffffff94517847 R09: 1ffffffff28a2f08
R10: dffffc0000000000 R11: fffffbfff28a2f09 R12: ffff888031998ad4
R13: ffff888031998000 R14: 0000000000000000 R15: ffff888031998b60
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005577a2694950 CR3: 00000000350ae000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 batadv_nc_worker+0xec/0x610 net/batman-adv/network-coding.c:719
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
