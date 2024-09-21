Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5C5FEE4
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 08:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726906227; cv=none; b=bpCqo3ZwVOfR3tPdCDlDTlsgLAR/CSZF5F9swm8AReHuYuhrqG7lRZt+MMunVjAYL9RhDwfrOToQaBMJGqZh64C2qWxFFBm636H0ambk2//hBMiWnE86Kuy93ouq3hhhEz6mfhdMpDONpOD9ejRBfzRMk17XHBlx0py52lPFJ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726906227; c=relaxed/simple;
	bh=RPeDkrMh34+w9aw+idu7RyRz9cNGuhhDnPW0TjbcRUI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OLdC2ugjKC3kB4DFKnPH0ihHsXDabwBCR2ehVL8nbinA1eCY0hhhTkP5EMuy1rUpEonFFSwPze6ugTPiMjpRTz1hzSKGkUwwqG40eJbdDMkINLZAlH3G2vUz7zg7ehclqP5UWooKbaQdAY5UeV5miH6F09MtPsrf9sJ9jlosD48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82aa467836eso499838839f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 01:10:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726906225; x=1727511025;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=smLRXFA0Qe0869NRRQIyRZJDUVdL3yjtB8joiM3qt6Y=;
        b=uT+ezvB5dbxTIg5GsYLRXWHHR6Me9Pj+H4O/Dr2xdzjQcl6mfLYp/biaAH87z6cJVH
         sGxRZeBYPEAP0PbkKyQi0bZiIrdTtWbFo+9CBfAAeA76EH/6B6PQv8Kc9StbxcKuY7BJ
         Uix0DR7t7usI78qyArxggcJ1w29PKeZqlS6FCzkbmbhFKdxyL8XS5MLNbrp+Is6KK5Eq
         w9y1PeaL036evQWq+bdnjlOMvGzlFeqOthEjUcL6GMTe8Upm3Q/TCL9wf8WeMgeeeuO7
         Mrs3AZLpEsP9JUlwW1F9d3e1aNUYhASjneRry0R5oIzWPEbyBzogvtLR72CL7qi3SxaA
         3oKw==
X-Forwarded-Encrypted: i=1; AJvYcCXtPMbJXahUHXgB/M6JKFw2yKCYicnKG4e5aX4SgXPZ85Oy7qy6xPReVfXAZw98SNV0/fOLqhBvw2RSuoJnyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzwo6u3I9Qelj3WW25nSzLD2cxSD8APD2QEzGjyFJeaAqu2BXwB
	MSUWh0BsdZfk+HlfWSTS1It3XBbCIZH3+TlcSOpHLcEp6Ce6Ynf5nW6DgheykT1e5AgGzW01PZU
	JM/WrPvlW6GMbDHHx6V1zztHwVbJan2apfPxhU92poioG1V/FAytKML0=
X-Google-Smtp-Source: AGHT+IExCx9JWmy2ozDkF6LIVU7gXTU1POkeURwwGQBuuhgQWtwFgPnqlUdOIJBHeAPiIj/ihADsBnpZXHgVakotbFOgVOwDrOGA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:214f:b0:3a0:8edc:d133 with SMTP id
 e9e14a558f8ab-3a0c8c9afcfmr49393455ab.9.1726906224901; Sat, 21 Sep 2024
 01:10:24 -0700 (PDT)
Date: Sat, 21 Sep 2024 01:10:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ee7f70.050a0220.3195df.003d.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in do_loopback
From: syzbot <syzbot+4c280beef28f7e506b9a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1868f9d0260e Merge tag 'for-linux-6.12-ofs1' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=113dff00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d29c10b70cc6fdb8
dashboard link: https://syzkaller.appspot.com/bug?extid=4c280beef28f7e506b9a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/26c691e641b7/disk-1868f9d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfe97fd5f2eb/vmlinux-1868f9d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4a385cd95bd6/bzImage-1868f9d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4c280beef28f7e506b9a@syzkaller.appspotmail.com

INFO: task syz.1.2:5333 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.2         state:D stack:25424 pid:5333  tgid:5301  ppid:5217   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5264 [inline]
 __schedule+0x1843/0x4b00 kernel/sched/core.c:6607
 __schedule_loop kernel/sched/core.c:6684 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6699
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6756
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common kernel/locking/rwsem.c:1306 [inline]
 __down_write kernel/locking/rwsem.c:1315 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1580
 inode_lock include/linux/fs.h:815 [inline]
 do_lock_mount+0x112/0x3a0 fs/namespace.c:2607
 lock_mount fs/namespace.c:2649 [inline]
 do_loopback+0x2be/0x520 fs/namespace.c:2772
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f6b17def9
RSP: 002b:00007f1f6bf1b038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f1f6b336130 RCX: 00007f1f6b17def9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000020000380
RBP: 00007f1f6b1f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f1f6b336130 R15: 00007fffbc1efec8
 </TASK>
INFO: task syz.1.2:5336 blocked for more than 144 seconds.
      Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.2         state:D stack:26448 pid:5336  tgid:5301  ppid:5217   flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5264 [inline]
 __schedule+0x1843/0x4b00 kernel/sched/core.c:6607
 __schedule_loop kernel/sched/core.c:6684 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6699
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6756
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common kernel/locking/rwsem.c:1306 [inline]
 __down_write kernel/locking/rwsem.c:1315 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1580
 inode_lock include/linux/fs.h:815 [inline]
 process_measurement+0x439/0x1fb0 security/integrity/ima/ima_main.c:250
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0xb9/0x280 security/security.c:3127
 do_open fs/namei.c:3776 [inline]
 path_openat+0x2ccd/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f6b17def9
RSP: 002b:00007f1f6befa038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f1f6b336208 RCX: 00007f1f6b17def9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000200005c0
RBP: 00007f1f6b1f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007f1f6b336208 R15: 00007fffbc1efec8
 </TASK>
INFO: task syz.1.2:5337 blocked for more than 145 seconds.
      Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.2         state:D stack:21272 pid:5337  tgid:5301  ppid:5217   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5264 [inline]
 __schedule+0x1843/0x4b00 kernel/sched/core.c:6607
 __schedule_loop kernel/sched/core.c:6684 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6699
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6756
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common kernel/locking/rwsem.c:1306 [inline]
 __down_write kernel/locking/rwsem.c:1315 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1580
 inode_lock include/linux/fs.h:815 [inline]
 process_measurement+0x439/0x1fb0 security/integrity/ima/ima_main.c:250
 ima_file_check+0xf2/0x170 security/integrity/ima/ima_main.c:572
 security_file_post_open+0xb9/0x280 security/security.c:3127
 do_open fs/namei.c:3776 [inline]
 path_openat+0x2ccd/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_creat fs/open.c:1506 [inline]
 __se_sys_creat fs/open.c:1500 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1500
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f6b17def9
RSP: 002b:00007f1f6bed9038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f1f6b3362e0 RCX: 00007f1f6b17def9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000040
RBP: 00007f1f6b1f0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f1f6b3362e0 R15: 00007fffbc1efec8
 </TASK>

Showing all locks held in the system:
4 locks held by kworker/u8:1/12:
3 locks held by kworker/1:0/25:
 #0: ffff88801ac81948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac81948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900001f7d00 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900001f7d00 ((reg_check_chans).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: reg_check_chans_work+0x99/0xfd0 net/wireless/reg.c:2480
1 lock held by khungtaskd/30:
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e9389e0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
2 locks held by kworker/u8:3/52:
 #0: ffff88801e75c948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801e75c948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000bc7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000bc7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
3 locks held by kworker/u8:4/61:
 #0: ffff88814bacf948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88814bacf948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900015cfd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900015cfd00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4196
3 locks held by kworker/u8:6/1116:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90004017d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90004017d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
1 lock held by dhcpcd/4883:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: devinet_ioctl+0x2ce/0x1aa0 net/ipv4/devinet.c:1097
2 locks held by getty/4977:
 #0: ffff88802f8080a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031232f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz.1.2/5302:
 #0: ffff8880217ce420 (sb_writers#14){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff88805ae00a18 (&c->snapshot_create_lock){.+.+}-{3:3}, at: bch2_truncate+0x16c/0x2c0 fs/bcachefs/io_misc.c:290
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x97/0x1a0 fs/bcachefs/btree_iter.c:3025
 #4: ffff88805ae26690 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1197
5 locks held by syz.1.2/5328:
 #0: ffff8880217ce420 (sb_writers#14){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88805dea9008 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88805dea9008 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff88805ae00a18 (&c->snapshot_create_lock){.+.+}-{3:3}, at: bch2_truncate+0x16c/0x2c0 fs/bcachefs/io_misc.c:290
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #3: ffff88805ae042c0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x97/0x1a0 fs/bcachefs/btree_iter.c:3025
 #4: ffff88805ae26690 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1197
1 lock held by syz.1.2/5333:
 #0: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #0: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: do_lock_mount+0x112/0x3a0 fs/namespace.c:2607
1 lock held by syz.1.2/5336:
 #0: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #0: ffff88805dea88a8 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: process_measurement+0x439/0x1fb0 security/integrity/ima/ima_main.c:250
2 locks held by syz.1.2/5337:
 #0: ffff8880217ce420 (sb_writers#14){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88805dea9008 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff88805dea9008 (&sb->s_type->i_mutex_key#22){+.+.}-{3:3}, at: process_measurement+0x439/0x1fb0 security/integrity/ima/ima_main.c:250
3 locks held by bch-reclaim/loo/5321:
1 lock held by syz-executor/5894:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:698 [inline]
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3b/0x1b0 drivers/net/tun.c:3517
4 locks held by syz-executor/6158:
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2930 [inline]
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x224/0xc90 fs/read_write.c:679
 #1: ffff888028d01c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff8880272baf08 (kn->active#50){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f554f68 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: new_device_store+0x1b4/0x890 drivers/net/netdevsim/bus.c:166
4 locks held by syz-executor/6173:
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2930 [inline]
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x224/0xc90 fs/read_write.c:679
 #1: ffff888022688888 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff8880272be008 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f554f68 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
7 locks held by syz-executor/6179:
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2930 [inline]
 #0: ffff88802e4e4420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x224/0xc90 fs/read_write.c:679
 #1: ffff888144fe9488 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff8880272be008 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f554f68 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
 #4: ffff8880309a60e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1014 [inline]
 #4: ffff8880309a60e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1094 [inline]
 #4: ffff8880309a60e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xce/0x7c0 drivers/base/dd.c:1292
 #5: ffff888028374250 (&devlink->lock_key#7){+.+.}-{3:3}, at: nsim_drv_remove+0x50/0x160 drivers/net/netdevsim/dev.c:1672
 #6: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x71/0x5c0 drivers/net/netdevsim/netdev.c:773
1 lock held by syz-executor/6284:
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcb73c8 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5321 Comm: bch-reclaim/loo Not tainted 6.11.0-syzkaller-07462-g1868f9d0260e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:check_preemption_disabled+0x60/0x120 lib/smp_processor_id.c:19
Code: 00 48 3b 44 24 08 0f 85 ce 00 00 00 89 d8 48 83 c4 10 5b 41 5c 41 5e 41 5f c3 cc cc cc cc 48 c7 04 24 00 00 00 00 9c 8f 04 24 <f7> 04 24 00 02 00 00 74 c5 49 89 f6 49 89 ff 65 4c 8b 24 25 80 d6
RSP: 0000:ffffc900043771a8 EFLAGS: 00000046
RAX: 0000000080000000 RBX: 0000000000000000 RCX: ffffffff81702a24
RDX: 0000000000000000 RSI: ffffffff8c0ae4a0 RDI: ffffffff8c600d00
RBP: ffffc90004377328 R08: ffffffff901b2c2f R09: 1ffffffff2036585
R10: dffffc0000000000 R11: fffffbfff2036586 R12: 1ffff9200086ee44
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000246
FS:  0000000000000000(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2f1c336000 CR3: 000000000e734000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 lockdep_recursion_inc kernel/locking/lockdep.c:462 [inline]
 lock_acquire+0x1b0/0x550 kernel/locking/lockdep.c:5821
 trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 bch2_trans_begin+0x9bd/0x1a50 fs/bcachefs/btree_iter.c:3097
 bch2_btree_write_buffer_flush_locked+0x15e/0x59f0 fs/bcachefs/btree_write_buffer.c:281
 btree_write_buffer_flush_seq+0x1a43/0x1bc0 fs/bcachefs/btree_write_buffer.c:510
 bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x77d/0xe40 fs/bcachefs/journal_reclaim.c:697
 bch2_journal_reclaim_thread+0x174/0x560 fs/bcachefs/journal_reclaim.c:739
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
