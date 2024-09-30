Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255BF154C00
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727681247; cv=none; b=j1DdW5MUwOk0EHJmPC4VLep4adkJmC2e6+w0p5bZ1kKgeTytZreGyOdNWh2gmyyqJ5J3qJbUaeshcuUZFtk0/b6MJJ4tdDILSI7pb76hpLDpgIk7oGX0AZwpN1zahh2I6rh4KoyRvMeMf/htKqJs0TCCRJOjB3CJ64xmH7u8lbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727681247; c=relaxed/simple;
	bh=ZThZRLligTh28RonQKHEKoJQneD243pGBwxcW6YcuKY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r3lt2oI8igNcvB6/OOh+l7RDQaAbiBdD+v4JrNvFsCCBWITX7dvUE5x1dQ+8u3xfJdDbiB5/3gao2CkAYsSHGawgARnKsG3WsDKpFQXv4ouOXW3r+zJbgnlNCkALCQRRK6rURxAQyjWUEotSG3CbU9zhXeeeqez9G/Gu5/Pn7IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3412ecb29so38748885ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 30 Sep 2024 00:27:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727681245; x=1728286045;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ibv2MWph/JA1dVh9QSqKLFcxcE57JRmfUUJ5ufEIptU=;
        b=hJ49k0lGiFR0hQVIvUNPgdRVYFK7NnmfJI4UP6PVCtpMMM7xMRIY+cJAYyV26tcV4I
         oerCR2ZJu7Mqs1xz51ajEN6rKfKlHqQBHWHr5pVaRzw/3b/AANOQnGowsk/5MlE8VFXa
         2voCfU115MhrCX+lylbUb8vEi1+wteTfrfWKGExf/4+vq+XCpAlxLMoucarfbH+SCV5B
         iwOEIXPEbUKa98XRpIDWuuzrewESDN5/EoBd7VD13FUMSaaeiDEEwd2LqT6OlSumhJhW
         gfk4EnursTSvyUazZf6E+LvGUXsPVlXgEsskf6oldhy87NsX4cXkHFbuomg5HBxJK5w7
         Qt5g==
X-Forwarded-Encrypted: i=1; AJvYcCVniq8AybYZQqnxD5O9p0RPk26KPsGHIUZh5t+NZ/RJ/jqGbzIqjhrdP0MYG/eUkLmPIzPE/2eM7OhHcsbIzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvQGjaByDF2IDmaEkVT/zn941Lbh4tvhLlSb5IMLfblXeAgpeB
	v0KgHpyR9W1AFQSLGtU12Voj485Z9wltYWtDJME6rCyXoYcyUi9ABM7U+N58xMaxSQLcPBTNW7p
	G5Z+1Uf8rNnjL860MH1sgmuGTO3lDkmjaYkVfPx89dv3LOKXk+1QtxFU=
X-Google-Smtp-Source: AGHT+IG74rLtVenlCQXcyhHTuPfGnuipVqUkCQNRZaP69AECgQhu6wAUWoBmQDWfy66uS/dWw34DfsaJO59B8jQR4nlUNhalX5hX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a6:b0:3a0:451b:ade3 with SMTP id
 e9e14a558f8ab-3a3451766a1mr90566995ab.10.1727681245304; Mon, 30 Sep 2024
 00:27:25 -0700 (PDT)
Date: Mon, 30 Sep 2024 00:27:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fa52dd.050a0220.aab67.0028.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in journal_flush_done
From: syzbot <syzbot+3b312e826b8023c294e8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3efc57369a0c Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16848127980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=26c9ab6638097a6
dashboard link: https://syzkaller.appspot.com/bug?extid=3b312e826b8023c294e8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/27eb9e7acef6/disk-3efc5736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6ca1f5529a2c/vmlinux-3efc5736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a0c4c354c23/bzImage-3efc5736.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3b312e826b8023c294e8@syzkaller.appspotmail.com

INFO: task syz-executor:5227 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-11993-g3efc57369a0c #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:20992 pid:5227  tgid:5227  ppid:1      flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5315 [inline]
 __schedule+0x1843/0x4ae0 kernel/sched/core.c:6675
 __schedule_loop kernel/sched/core.c:6752 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6767
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6824
 __mutex_lock_common kernel/locking/mutex.c:684 [inline]
 __mutex_lock+0x6a7/0xd70 kernel/locking/mutex.c:752
 journal_flush_done+0x79/0x260 fs/bcachefs/journal_reclaim.c:817
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
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f615017f327
RSP: 002b:00007ffc2994c968 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f615017f327
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc2994ca20
RBP: 00007ffc2994ca20 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc2994daa0
R13: 00007f61501f0134 R14: 00000000000146a3 R15: 00007ffc2994dae0
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/u8:0/11:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
3 locks held by kworker/u8:4/68:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900020afd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900020afd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
3 locks held by kworker/u8:7/1116:
 #0: ffff88802e608948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88802e608948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90004117d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90004117d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4196
2 locks held by dhcpcd/4888:
 #0: ffffffff8fca3ae8 (vlan_ioctl_mutex){+.+.}-{3:3}, at: sock_ioctl+0x661/0x8e0 net/socket.c:1308
 #1: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: vlan_ioctl_handler+0x112/0x9d0 net/8021q/vlan.c:553
2 locks held by getty/4979:
 #0: ffff8880327120a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
3 locks held by syz-executor/5227:
 #0: ffff8880246280e0 (&type->s_umount_key#74){++++}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff8880246280e0 (&type->s_umount_key#74){++++}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff8880246280e0 (&type->s_umount_key#74){++++}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
 #1: ffff88806ac00278 (&c->state_lock){+.+.}-{3:3}, at: __bch2_fs_stop+0xfd/0x540 fs/bcachefs/super.c:618
 #2: ffff88806ac4b0a8 (&j->reclaim_lock){+.+.}-{3:3}, at: journal_flush_done+0x79/0x260 fs/bcachefs/journal_reclaim.c:817
3 locks held by kworker/1:6/5274:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900043a7d00 (deferred_process_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900043a7d00 (deferred_process_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xe/0x20 net/switchdev/switchdev.c:104
3 locks held by bch-reclaim/loo/5449:
1 lock held by syz.2.92/5865:
 #0: ffff8880246280e0 (&type->s_umount_key#74){++++}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff8880246280e0 (&type->s_umount_key#74){++++}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
5 locks held by kworker/u8:11/6471:
 #0: ffff88801baeb148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801baeb148 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc9000326fd00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000326fd00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb24d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:580
 #3: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: cleanup_net+0x6af/0xcc0 net/core/net_namespace.c:616
 #4: ffffffff8e93d338 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:297 [inline]
 #4: ffffffff8e93d338 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:976
1 lock held by syz-executor/6606:
 #0: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643
7 locks held by syz-executor/6722:
 #0: ffff88802eb0c420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #0: ffff88802eb0c420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x224/0xc90 fs/read_write.c:679
 #1: ffff888068a85088 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff888027e86968 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f55d068 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
 #4: ffff88805ffc50e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1014 [inline]
 #4: ffff88805ffc50e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1095 [inline]
 #4: ffff88805ffc50e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xce/0x7c0 drivers/base/dd.c:1293
 #5: ffff88802572a250 (&devlink->lock_key#14){+.+.}-{3:3}, at: nsim_drv_remove+0x50/0x160 drivers/net/netdevsim/dev.c:1672
 #6: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x71/0x5c0 drivers/net/netdevsim/netdev.c:773
4 locks held by syz-executor/6736:
 #0: ffff88802eb0c420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #0: ffff88802eb0c420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x224/0xc90 fs/read_write.c:679
 #1: ffff88803224f888 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff888027e86968 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f55d068 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
1 lock held by syz-executor/6747:
 #0: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcbefc8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-11993-g3efc57369a0c #0
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
CPU: 1 UID: 0 PID: 5449 Comm: bch-reclaim/loo Not tainted 6.11.0-syzkaller-11993-g3efc57369a0c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:87 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:104 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:129 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:161 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0x86/0x290 mm/kasan/generic.c:189
Code: 00 fc ff df 4f 8d 3c 31 4c 89 fd 4c 29 dd 48 83 fd 10 7f 29 48 85 ed 0f 84 3e 01 00 00 4c 89 cd 48 f7 d5 48 01 dd 41 80 3b 00 <0f> 85 c9 01 00 00 49 ff c3 48 ff c5 75 ee e9 1e 01 00 00 45 89 dc
RSP: 0018:ffffc900039a74c8 EFLAGS: 00000246
RAX: ffffffff8420ae01 RBX: 1ffff9200304006e RCX: ffffffff8420ae65
RDX: 0000000000000000 RSI: 0000000000000050 RDI: ffffc90018200370
RBP: fffffffffffffffe R08: ffffc900182003bf R09: 1ffff92003040077
R10: dffffc0000000000 R11: fffff52003040076 R12: 0000000000000050
R13: ffffc90018200370 R14: dffffc0000000001 R15: fffff52003040078
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8da3a7f000 CR3: 000000000e734000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 bch2_btree_write_buffer_flush_locked+0x54a5/0x59f0 fs/bcachefs/btree_write_buffer.c:465
 btree_write_buffer_flush_seq+0x1a43/0x1bc0 fs/bcachefs/btree_write_buffer.c:510
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x789/0xdc0 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x174/0x560 fs/bcachefs/journal_reclaim.c:740
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
