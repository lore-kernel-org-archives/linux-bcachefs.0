Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0054D157E9F
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Sep 2024 04:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727496873; cv=none; b=D4BukBEqJQJ14H2Mt/rDkMZ6Qd83vL1DjtqYbxiWy/RzScDj97+CtOPSGCzxhSiL8f394V3z3kf3VsVu/Wm+Q2ENIQaLlZRxzChVaKU0UEfYiHvNMsu7mvXDQuFizZOgMB7yUbAiNE1lcZ8gWwVuCYob4dSTTmUb1PbdKTgNlSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727496873; c=relaxed/simple;
	bh=4kTQ0VtkW01UPHkx2OEX1qryS8JIxux1g4LQtyxFQiU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ho1+qpl0FpupE8jfmFBBoZVZI5UsP7Lx3POorsXExbCJwIVC0Us/n0bxgDgxt7BG+L/X4qwlI7s2sf3frZOEkyJZtwpWH0b4c6hgtleqJb4RM09v72h1x7Qv/oGIae1Fi8pOV4zoWs6+D3J/KsFs731LQk7zLgbb1DKvS+gRfgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-82ad9fca5fcso268784839f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 21:14:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727496870; x=1728101670;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kXCWBXYZGxgdVBHFNvrXbluP5sin25gdWrE6XoVT9xE=;
        b=hz/skPomEFcp5SKTAo8+c4jFmy+YeBqu98y6ymq7QW+cRiG6gOTrsq2m0hYbnSm+dH
         Q1PHsPXiqErHMIGrhgmkFaoCOHPClX2dqPHhAplcQ6x7YmX9rtiU3xgBsjhAspMPUJPD
         UBMNgcvH3hZTe9rk8K7NNpzGk/aJLy1J8AsMq3V40CasXtrEV339oUZHbU8RRWdUaYi6
         bRJpyNAGyfEW9DloDdsxO5no5xJdcWSW9NEowczmCy3+wW9H/e0INU5fcmeygFdjbvBR
         EwGpwZyeCnBnjNx8E4Ag/mFz2V07DWgBKSGc83VgiWEENoc9df1COuEOfSbeZC9l3lSJ
         H72A==
X-Forwarded-Encrypted: i=1; AJvYcCVPjE8+YiiC+RDFN5+CkcPB/IbX9E34kO3IHJgS5mOfJSCy5mTzA/eejuyx0GuElcePovMQbmd9M3IRlrdMYg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy8fjzsEbEyWomiaI1tpR4ajvZCXf3rkXopWcR0vtpQOR9wIEr
	2kjxxP80Nal8JY0E2Iw4F3wQgWBIXuaNulRbNNFHPAsjwh2lSAaSVjzfXG2HJnCixMiCepW3wig
	+8HBoaJ5w4prhC2DXLQPU7LqrBQrggi/49XZwp7PfJRgxF9auG6KqnwE=
X-Google-Smtp-Source: AGHT+IEEJI33O+0OBEX0+yftGlQ1d8gexaDiWKYSxgz6946CWwrdFUOZl231CJZFt7VN8w7ttbU2/uOstbzfEAT0nfIiMdyW4xlD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12c7:b0:3a0:92e5:af68 with SMTP id
 e9e14a558f8ab-3a345188ecemr45269505ab.15.1727496870094; Fri, 27 Sep 2024
 21:14:30 -0700 (PDT)
Date: Fri, 27 Sep 2024 21:14:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f782a6.050a0220.46d20.0030.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in do_ftruncate
From: syzbot <syzbot+e48ce9d7b41255fe347c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aa486552a110 Merge tag 'memblock-v6.12-rc1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12f63627980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bad8b2899350fd0b
dashboard link: https://syzkaller.appspot.com/bug?extid=e48ce9d7b41255fe347c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/30a23c12e28d/disk-aa486552.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/abcc297fee6c/vmlinux-aa486552.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8a45329353f7/bzImage-aa486552.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e48ce9d7b41255fe347c@syzkaller.appspotmail.com

INFO: task syz.3.45:5605 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller-10622-gaa486552a110 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.45        state:D stack:22560 pid:5605  tgid:5586  ppid:5216   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5315 [inline]
 __schedule+0x1843/0x4ae0 kernel/sched/core.c:6675
 __schedule_loop kernel/sched/core.c:6752 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6767
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6824
 rwsem_down_write_slowpath+0xeee/0x13b0 kernel/locking/rwsem.c:1178
 __down_write_common kernel/locking/rwsem.c:1306 [inline]
 __down_write kernel/locking/rwsem.c:1315 [inline]
 down_write+0x1d7/0x220 kernel/locking/rwsem.c:1580
 inode_lock include/linux/fs.h:815 [inline]
 do_truncate fs/open.c:63 [inline]
 do_ftruncate+0x44e/0x580 fs/open.c:181
 do_sys_ftruncate fs/open.c:199 [inline]
 __do_sys_ftruncate fs/open.c:207 [inline]
 __se_sys_ftruncate fs/open.c:205 [inline]
 __x64_sys_ftruncate+0x95/0xf0 fs/open.c:205
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faa8237df39
RSP: 002b:00007faa81dde038 EFLAGS: 00000246 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 00007faa82536058 RCX: 00007faa8237df39
RDX: 0000000000000000 RSI: 00000000000096ef RDI: 0000000000000005
RBP: 00007faa823f0216 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007faa82536058 R15: 00007fffc6927418
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ee0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6701
2 locks held by kworker/u8:2/35:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000ab7d00 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000ab7d00 ((reaper_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
2 locks held by kworker/u8:3/57:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffff8880b8728948 (&per_cpu_ptr(group->pcpu, cpu)->seq){-.-.}-{0:0}, at: psi_task_switch+0x441/0x770 kernel/sched/psi.c:989
3 locks held by kworker/u8:6/1064:
 #0: ffff8880202fa148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880202fa148 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900040f7d00 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900040f7d00 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_trylock_shared+0x22/0xf0 fs/super.c:562
2 locks held by kworker/u8:7/1080:
 #0: ffff88814769c948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88814769c948 ((wq_completion)iou_exit){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900041a7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900041a7d00 ((work_completion)(&ctx->exit_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
3 locks held by kworker/u8:8/2926:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90009d57d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90009d57d00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcbf408 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
2 locks held by getty/4973:
 #0: ffff88814b3270a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz.3.45/5587:
 #0: ffff88801cb1a420 (sb_writers#23){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff8880560308c0 (&sb->s_type->i_mutex_key#28){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff8880560308c0 (&sb->s_type->i_mutex_key#28){+.+.}-{3:3}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff888064980a38 (&c->snapshot_create_lock){.+.+}-{3:3}, at: bch2_truncate+0x16d/0x2c0 fs/bcachefs/io_misc.c:290
 #3: ffff888064984398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #3: ffff888064984398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #3: ffff888064984398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3215
 #4: ffff8880649a66d0 (&c->gc_lock){.+.+}-{3:3}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1202
2 locks held by syz.3.45/5605:
 #0: ffff88801cb1a420 (sb_writers#23){.+.+}-{0:0}, at: do_ftruncate+0x28b/0x580 fs/open.c:178
 #1: ffff8880560308c0 (&sb->s_type->i_mutex_key#28){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #1: ffff8880560308c0 (&sb->s_type->i_mutex_key#28){+.+.}-{3:3}, at: do_truncate fs/open.c:63 [inline]
 #1: ffff8880560308c0 (&sb->s_type->i_mutex_key#28){+.+.}-{3:3}, at: do_ftruncate+0x44e/0x580 fs/open.c:181
3 locks held by bch-reclaim/loo/5600:
2 locks held by syz.1.58/5865:
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: bdi_down_write_wb_switch_rwsem fs/fs-writeback.c:388 [inline]
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: sync_inodes_sb+0x26e/0xb50 fs/fs-writeback.c:2797
2 locks held by syz.1.58/5866:
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: bdi_down_write_wb_switch_rwsem fs/fs-writeback.c:388 [inline]
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: sync_inodes_sb+0x26e/0xb50 fs/fs-writeback.c:2797
2 locks held by syz.1.58/5867:
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: bdi_down_write_wb_switch_rwsem fs/fs-writeback.c:388 [inline]
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: sync_inodes_sb+0x26e/0xb50 fs/fs-writeback.c:2797
2 locks held by syz.1.58/5869:
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: bdi_down_write_wb_switch_rwsem fs/fs-writeback.c:388 [inline]
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: sync_inodes_sb+0x26e/0xb50 fs/fs-writeback.c:2797
2 locks held by syz.1.100/6093:
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: __super_lock fs/super.c:58 [inline]
 #0: ffff88801cb1a0e0 (&type->s_umount_key#80){.+.+}-{3:3}, at: super_lock+0x27c/0x400 fs/super.c:120
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: bdi_down_write_wb_switch_rwsem fs/fs-writeback.c:388 [inline]
 #1: ffff88801cb1c7d0 (&bdi->wb_switch_rwsem){+.+.}-{3:3}, at: sync_inodes_sb+0x26e/0xb50 fs/fs-writeback.c:2797
2 locks held by kworker/u8:10/6245:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90004707d00 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90004707d00 ((reaper_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
1 lock held by syz-executor/6714:
 #0: ffffffff8fcbf408 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcbf408 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x6e6/0xcf0 net/core/rtnetlink.c:6643
2 locks held by syz.3.255/6897:
2 locks held by syz.0.256/6903:
 #0: ffff888049000908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_fs_alloc fs/bcachefs/super.c:827 [inline]
 #0: ffff888049000908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_fs_open+0x1683/0x2f80 fs/bcachefs/super.c:2050
 #1: ffff8880490049d0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x1e0/0x2e0 fs/bcachefs/replicas.c:572
2 locks held by syz.4.259/6910:
 #0: ffffffff8eec3708 (uuid_mutex){+.+.}-{3:3}, at: btrfs_get_tree_super fs/btrfs/super.c:1835 [inline]
 #0: ffffffff8eec3708 (uuid_mutex){+.+.}-{3:3}, at: btrfs_get_tree+0x2dc/0x1920 fs/btrfs/super.c:2114
 #1: ffff8880b873ea58 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:593
2 locks held by dhcpcd/6915:
 #0: ffff888078636e08 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: inode_lock include/linux/fs.h:815 [inline]
 #0: ffff888078636e08 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: __sock_release net/socket.c:658 [inline]
 #0: ffff888078636e08 (&sb->s_type->i_mutex_key#9){+.+.}-{3:3}, at: sock_close+0x90/0x240 net/socket.c:1427
 #1: ffffffff8e93d478 (rcu_state.exp_mutex){+.+.}-{3:3}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #1: ffffffff8e93d478 (rcu_state.exp_mutex){+.+.}-{3:3}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller-10622-gaa486552a110 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5600 Comm: bch-reclaim/loo Not tainted 6.11.0-syzkaller-10622-gaa486552a110 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4865 [inline]
RIP: 0010:__lock_acquire+0x974/0x2050 kernel/locking/lockdep.c:5149
Code: 40 84 ed 74 32 0f b6 44 24 08 40 0f b6 cd 40 38 e8 0f 42 c8 89 4c 24 08 48 81 c3 c6 00 00 00 48 89 d8 48 c1 e8 03 0f b6 04 10 <84> c0 0f 85 a8 00 00 00 80 3b 02 74 31 49 ff c6 48 8b 44 24 38 0f
RSP: 0018:ffffc90004167490 EFLAGS: 00000807
RAX: 0000000000000000 RBX: ffffffff93c78b66 RCX: 0000000000000003
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: ffffffff942358f8
RBP: 0000000000000003 R08: ffffffff942358ff R09: 1ffffffff2846b1f
R10: dffffc0000000000 R11: fffffbfff2846b20 R12: 0000000000000000
R13: ffff88802975a900 R14: 0000000000000000 R15: ffff88802975a900
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2502490000 CR3: 0000000067a02000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5822
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 __bch2_next_write_buffer_flush_journal_buf+0x60/0x2a0 fs/bcachefs/journal.c:870
 bch2_next_write_buffer_flush_journal_buf+0xa3/0x1b0 fs/bcachefs/journal.c:904
 fetch_wb_keys_from_journal fs/bcachefs/btree_write_buffer.c:486 [inline]
 btree_write_buffer_flush_seq+0x18c/0x1bc0 fs/bcachefs/btree_write_buffer.c:503
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
