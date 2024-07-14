Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FA6441F
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 03:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720927236; cv=none; b=FZtERm0d9YJgJX5+RwQOHdu96Sp9RcISTE1Gl46rcTW1StDg5qGRQCbFk3cf+qCN3x9tQWOxalJoj+UbExHtJRp3ZyFWI6aT1zmcjmNPkpct2tRWBv2K0YHJbsvcgQVzDGDaFqRCj/0qIgx5wP/Lg3BSz+yILYqdDd9EaAKnei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720927236; c=relaxed/simple;
	bh=rBb1GbQNBVHR6AY91qCRCN483zY3fPBOvgPCyh+MjGk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AlkmLYuQKrH9os09nz/zca1/wltgivWN0jT8UjpZRBGCczAqDzZArXEk1SCJPfH5VenAkLCYk/UmholJlG4/kX99XhyBzQ3VPxdI0kfGdm/qBqibSs22ocwYJClwciSySzd6JE7t8zP5ElISAM48j1egGF2TYsANNc0XSPpPGSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-7fdfb3333e5so357223739f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 13 Jul 2024 20:20:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720927234; x=1721532034;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=skywO3VTE+WXa1/uz86avNKPBssAxffa49a9k54M/eg=;
        b=WUZJfLk8taFaxkrDrsXm4NTwOBqsYNA63l55lAfSKJw+xV8NhvmgSWQm2HtbiC4bBQ
         xAcHbB6qrQv8R7ihj7cZh/k3IGbJ+IGg5KKOa8yPoewvvhXZKVPSH/HeSp7nmNXSIRaT
         vokopwCaNyUKcbYX1AxOx3o5+viIgWJlFG+l49ITCW5MeoE91agn5XbLtgYM1fzHCOR/
         ANd8hbNlsdJNLXghDiyPgKA/zvT2ZWaAbQeBXLl/lFyi/EHfGHFOE2jxEZunPiWXTxav
         UCjlcWLqMUJBOrT6HdmzJu1jqIdGL7XRs3KVFR18Ty4hsj3Rwlr5Fim4NqODJmVl6gHt
         BivA==
X-Forwarded-Encrypted: i=1; AJvYcCXdsBZOv6fJ+roscQ1EaPC+GO3ZjbXZFqCrfobw6nNvL2pF1rqqu8Lt4RuAFyM2v0OU7zep9NFLQFqLgcLwWW8U5nhG6ACYO9z/lRNeacs=
X-Gm-Message-State: AOJu0YxnKQheJGo9iHVDXSV/c2DWpiQe8N74MHSnT+u3hWzXr+MQ2aom
	XpXxv5/6EdFKlHE70NQPOFHQFn5nE37Q3Tp/2r9ESRA5Xnt1NeMfer9lYmM5wNIUXmSQzBdxbs1
	DspePsLVPhAFFxPc3Zj24Fp/2qGyrV7O4kbspKTDWJQDTw49DcFO7+GA=
X-Google-Smtp-Source: AGHT+IGaOLdsG8+0tChVVAwSTOCXd0vOvGD41DfmrR9iIvbp2dRXrexXbewPEeUm8hCzRQ7BIPTZrCPSYXK2w36tPAIDXdGVV967
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6109:b0:805:caf8:4e1c with SMTP id
 ca18e2360f4ac-805caf84fa5mr31687639f.4.1720927233850; Sat, 13 Jul 2024
 20:20:33 -0700 (PDT)
Date: Sat, 13 Jul 2024 20:20:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000755334061d2c9865@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in invalidate_inode_pages2_range (2)
From: syzbot <syzbot+b900ead46c19e9ec3966@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    34afb82a3c67 Merge tag '6.10-rc6-smb3-server-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1523547e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
dashboard link: https://syzkaller.appspot.com/bug?extid=b900ead46c19e9ec3966
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5e93dc1544ee/disk-34afb82a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/005e374613f0/vmlinux-34afb82a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6931db81a1a/bzImage-34afb82a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b900ead46c19e9ec3966@syzkaller.appspotmail.com

INFO: task syz.3.159:6370 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc7-syzkaller-00012-g34afb82a3c67 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.159       state:D stack:14840 pid:6370  tgid:6369  ppid:5957   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 io_schedule+0x8d/0x110 kernel/sched/core.c:9043
 folio_wait_bit_common+0x882/0x12b0 mm/filemap.c:1307
 invalidate_inode_pages2_range+0x491/0x10e0 mm/truncate.c:648
 bch2_write_invalidate_inode_pages_range+0xce/0x120 fs/bcachefs/fs-io-pagecache.c:68
 bch2_direct_write+0x2d95/0x3050 fs/bcachefs/fs-io-direct.c:647
 bch2_write_iter+0x206/0x2840 fs/bcachefs/fs-io-buffered.c:1135
 iter_file_splice_write+0xbd7/0x14e0 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11e/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x58e/0xc90 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x28c/0x3e0 fs/splice.c:1233
 do_sendfile+0x56d/0xe20 fs/read_write.c:1295
 __do_sys_sendfile64 fs/read_write.c:1362 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a69f75bd9
RSP: 002b:00007f0a6ad0a048 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f0a6a103f60 RCX: 00007f0a69f75bd9
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000005
RBP: 00007f0a69fe4e60 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f0a6a103f60 R15: 00007fff21429708
 </TASK>
INFO: task syz.3.159:6399 blocked for more than 143 seconds.
      Not tainted 6.10.0-rc7-syzkaller-00012-g34afb82a3c67 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.159       state:D stack:25400 pid:6399  tgid:6369  ppid:5957   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5408 [inline]
 __schedule+0x1796/0x49d0 kernel/sched/core.c:6745
 __schedule_loop kernel/sched/core.c:6822 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6837
 __bch2_two_state_lock+0x171/0x200 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:56 [inline]
 bch2_readahead+0xcad/0x1860 fs/bcachefs/fs-io-buffered.c:269
 read_pages+0x17e/0x840 mm/readahead.c:160
 page_cache_ra_order+0xa9f/0xd00 mm/readahead.c:535
 page_cache_sync_readahead include/linux/pagemap.h:1306 [inline]
 filemap_get_pages+0x49d/0x2090 mm/filemap.c:2529
 filemap_splice_read+0x654/0xeb0 mm/filemap.c:2894
 do_splice_read fs/splice.c:985 [inline]
 splice_direct_to_actor+0x4b7/0xc90 fs/splice.c:1089
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x28c/0x3e0 fs/splice.c:1233
 do_sendfile+0x56d/0xe20 fs/read_write.c:1295
 __do_sys_sendfile64 fs/read_write.c:1362 [inline]
 __se_sys_sendfile64+0x17c/0x1e0 fs/read_write.c:1348
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a69f75bd9
RSP: 002b:00007f0a6ace9048 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007f0a6a104038 RCX: 00007f0a69f75bd9
RDX: 0000000000000000 RSI: 0000000000000007 RDI: 0000000000000006
RBP: 00007f0a69fe4e60 R08: 0000000000000000 R09: 0000000000000000
R10: 0001000000201005 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000006e R14: 00007f0a6a104038 R15: 00007fff21429708
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e333f20 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #0: ffffffff8e333f20 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #0: ffffffff8e333f20 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6614
3 locks held by kworker/1:1/45:
 #0: ffff888015080948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3223 [inline]
 #0: ffff888015080948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3329
 #1: ffffc90000b57d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3224 [inline]
 #1: ffffc90000b57d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3329
 #2: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
3 locks held by kworker/u8:5/136:
 #0: ffff88802a544948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3223 [inline]
 #0: ffff88802a544948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3329
 #1: ffffc90002df7d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3224 [inline]
 #1: ffffc90002df7d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3329
 #2: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4193
5 locks held by kworker/u8:6/2428:
 #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3223 [inline]
 #0: ffff888015ed3148 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3329
 #1: ffffc9000917fd00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3224 [inline]
 #1: ffffc9000917fd00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3329
 #2: ffffffff8f5c80d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594
 #3: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: default_device_exit_batch+0xe9/0xa90 net/core/dev.c:11746
 #4: ffffffff8e3392f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:291 [inline]
 #4: ffffffff8e3392f8 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:939
3 locks held by kworker/u8:7/2441:
 #0: ffff8880b943e758 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:559
 #1: ffffc900090afd00 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3224 [inline]
 #1: ffffc900090afd00 ((work_completion)(&(&bat_priv->nc.work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3329
 #2: ffff888059c08768 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: wiphy_lock include/net/cfg80211.h:5966 [inline]
 #2: ffff888059c08768 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: cfg80211_wiphy_work+0x35/0x260 net/wireless/core.c:424
2 locks held by klogd/4525:
 #0: ffff8880b943e758 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:559
 #1: ffff8880b9428948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x441/0x770 kernel/sched/psi.c:988
1 lock held by dhcpcd/4750:
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0x2ce/0x1bc0 net/ipv4/devinet.c:1101
2 locks held by getty/4852:
 #0: ffff88802b4ec0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f1e2f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6b5/0x1e10 drivers/tty/n_tty.c:2211
1 lock held by syz.3.159/6370:
 #0: ffff888066960420 (sb_writers#16){.+.+}-{0:0}, at: direct_splice_actor+0x49/0x220 fs/splice.c:1163
1 lock held by syz.3.159/6399:
 #0: ffff888061f102f0 (mapping.invalidate_lock#4){.+.+}-{3:3}, at: filemap_invalidate_lock_shared include/linux/fs.h:846 [inline]
 #0: ffff888061f102f0 (mapping.invalidate_lock#4){.+.+}-{3:3}, at: page_cache_ra_order+0x3e1/0xd00 mm/readahead.c:514
1 lock held by syz-executor/8032:
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x842/0x1180 net/core/rtnetlink.c:6632
7 locks held by syz-executor/8174:
 #0: ffff88802aa10420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2854 [inline]
 #0: ffff88802aa10420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x227/0xc90 fs/read_write.c:586
 #1: ffff88802b58ec88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1eb/0x500 fs/kernfs/file.c:325
 #2: ffff888021d72878 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20f/0x500 fs/kernfs/file.c:326
 #3: ffffffff8eee1f28 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
 #4: ffff88806d9520e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1009 [inline]
 #4: ffff88806d9520e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1093 [inline]
 #4: ffff88806d9520e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xce/0x7c0 drivers/base/dd.c:1290
 #5: ffff88806d953250 (&devlink->lock_key#23){+.+.}-{3:3}, at: nsim_drv_remove+0x50/0x160 drivers/net/netdevsim/dev.c:1672
 #6: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x71/0x5c0 drivers/net/netdevsim/netdev.c:773
1 lock held by syz-executor/8175:
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x842/0x1180 net/core/rtnetlink.c:6632
1 lock held by syz-executor/8241:
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8f5d4908 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x842/0x1180 net/core/rtnetlink.c:6632

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 30 Comm: khungtaskd Not tainted 6.10.0-rc7-syzkaller-00012-g34afb82a3c67 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
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
CPU: 0 PID: 2490 Comm: kworker/u8:10 Not tainted 6.10.0-rc7-syzkaller-00012-g34afb82a3c67 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: events_unbound cfg80211_wiphy_work
RIP: 0010:should_fail_ex+0x17e/0x4e0 lib/fault-inject.c:159
Code: df fe ff ff 41 ff ce 42 0f b6 04 23 84 c0 0f 85 a1 02 00 00 44 89 75 00 45 85 f6 0f 84 a3 00 00 00 31 ed 89 e8 48 83 c4 18 5b <41> 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 49 8d 6d 08 48 89 e8 48
RSP: 0018:ffffc9000923f518 EFLAGS: 00000292
RAX: 0000000000000000 RBX: 0000000000000920 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000400 RDI: ffffffff8e443dc0
RBP: 0000000000000000 R08: ffffc9000923fa7f R09: 0000000000000000
R10: ffffc9000923fa40 R11: fffff52001247f50 R12: dffffc0000000000
R13: ffffffff8e443dc0 R14: 0000000000000000 R15: 0000000000000400
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4b2e0d0ab8 CR3: 000000001ef2e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 should_failslab+0x9/0x20 mm/slub.c:3880
 slab_pre_alloc_hook mm/slub.c:3893 [inline]
 slab_alloc_node mm/slub.c:3982 [inline]
 __do_kmalloc_node mm/slub.c:4122 [inline]
 __kmalloc_noprof+0xd8/0x400 mm/slub.c:4136
 kmalloc_noprof include/linux/slab.h:664 [inline]
 kzalloc_noprof include/linux/slab.h:778 [inline]
 ieee802_11_parse_elems_full+0xd5/0x2870 net/mac80211/parse.c:880
 ieee802_11_parse_elems_crc net/mac80211/ieee80211_i.h:2332 [inline]
 ieee802_11_parse_elems net/mac80211/ieee80211_i.h:2339 [inline]
 ieee80211_rx_mgmt_probe_beacon net/mac80211/ibss.c:1574 [inline]
 ieee80211_ibss_rx_queued_mgmt+0x4c8/0x2d70 net/mac80211/ibss.c:1605
 ieee80211_iface_process_skb net/mac80211/iface.c:1603 [inline]
 ieee80211_iface_work+0x8a3/0xf10 net/mac80211/iface.c:1657
 cfg80211_wiphy_work+0x221/0x260 net/wireless/core.c:437
 process_one_work kernel/workqueue.c:3248 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3329
 worker_thread+0x86d/0xd50 kernel/workqueue.c:3409
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
