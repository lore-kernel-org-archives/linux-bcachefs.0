Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E91F146586
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Sep 2024 09:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726478908; cv=none; b=T8TIxB9LPQ8wJmK5kSzvNZis4DDLFJNGrsDrL/OMM57fJBLMdNmoWYulNiBFi9WnDMxGtI0ySfNuFFGSxKIxNP1ZXS+iMjLICCBigsWzNjZD9rnF8cX7Iqecv3mctQbfhWrUsSvIE2gQfaZUB3EZcdQEi4d3YvzWsfHvQwL+a90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726478908; c=relaxed/simple;
	bh=z8giI9/ZdlFf5+J23njLUMDGdqAsxhZYL7sgn4H9onA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Y9iPqahd/alCGu9bzaH1an5I5dst4EqMAR/jSLy5o2XFWDT/PRMiJMGZdQoIL/+LQHmUueYLXun5SLzebSxMXFuyqesVuyGKXeXFIaPs6bw8wqIIB0llcOQaqaX5xUUkqXoudbq8nUHazfO9Jg/NKbiXr4H8GVT/Vjj4yqEsslE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-82ced069d94so960573839f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Sep 2024 02:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726478905; x=1727083705;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nTvfKB2iP8TnE6cOWy6EnWdltzrpMIfOIwhP9EUB/sw=;
        b=N5jCNnNNVZcoT+rwTVtBm+qN2fi3ytbS039oyma18MaGxHxe2nAtsfaSSh87I99/FX
         VbSYLriC7YWGrSJl5tLkxW4Ufjck0cnAIK342td7Hg0Ygq5nv9blMf0nE4AfQPSbE5In
         zZ45gbJRnV72ZlqSdQJcIY/V8VZS95yh3pBWAm5s5bgvhTDC3LG0O5kSaPQv4UGAJJpg
         cx1r58jmrfQuXfyYF4VFyLXV+LBApbsBC2e6C42Zl4nhWrm/A0pi4fjVTuM8Dpa0bf2m
         kzUYIwZGQwkD8Ue5PUnSol31bX4bjBytFVJlUrkVQrPKH7ZzPqbbT6vEzeHLIUeyyWE0
         i+aw==
X-Forwarded-Encrypted: i=1; AJvYcCXVPxHqO/0zcFg9Jl2nIaiTsAjc9sdz0N5CzE4IfantnaO5Q4xt3JXtj/zX1le4D+5SF1gmllbZFWJnD+Zo7Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwC690kTi5ntipfOm1O18KDf/b/L3oQg3vRuEISp+TuBdd4nYFM
	mVHhyHpB7ZiNSEElaHk30tHPEVpVx0U7GddeWwOGmXdMQeV4GcTY771KfPHFkyfsVyQxCZTYCJM
	XhZrEbg+kq6nXiOxVxAHdpugc4xviuHD8mtub53mdS+URa6hvdVohgGU=
X-Google-Smtp-Source: AGHT+IFGLqZ9h8gbjyDB/vCCPxROYK+H2Z/YFGelbgEVqmucfs4vxeAIgKRT1Qv2QZNfVtvotK5oHE/a92M/7Wp6O+FiNMDmPGrg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6207:b0:82a:2143:8 with SMTP id
 ca18e2360f4ac-82d1f93f807mr1637332539f.10.1726478905471; Mon, 16 Sep 2024
 02:28:25 -0700 (PDT)
Date: Mon, 16 Sep 2024 02:28:25 -0700
In-Reply-To: <0000000000006304400619bbfae2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df862e0622393137@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_copygc_stop
From: syzbot <syzbot+c6fd966ebbdea1e8ff08@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    98f7e32f20d2 Linux 6.11
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=147c9c07980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c78874575ba70f27
dashboard link: https://syzkaller.appspot.com/bug?extid=c6fd966ebbdea1e8ff08
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156928a9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e0d7c7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5d74d59e4416/disk-98f7e32f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aa8ddac249b8/vmlinux-98f7e32f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e275b6573f40/bzImage-98f7e32f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d48bbd071463/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6fd966ebbdea1e8ff08@syzkaller.appspotmail.com

INFO: task syz-executor378:5242 blocked for more than 143 seconds.
      Not tainted 6.11.0-syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor378 state:D stack:23872 pid:5242  tgid:5242  ppid:5239   flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5188 [inline]
 __schedule+0x17ae/0x4a10 kernel/sched/core.c:6529
 __schedule_loop kernel/sched/core.c:6606 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6621
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2557
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 kthread_stop+0x19e/0x640 kernel/kthread.c:710
 bch2_copygc_stop+0x4f/0x150 fs/bcachefs/movinggc.c:405
 __bch2_fs_read_only+0x47/0x430 fs/bcachefs/super.c:264
 bch2_fs_read_only+0xb57/0x1220 fs/bcachefs/super.c:354
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:618
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2062
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x279/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f04a0768507
RSP: 002b:00007ffc704dd048 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f04a0768507
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc704dd100
RBP: 00007ffc704dd100 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000206 R12: 00007ffc704de170
R13: 00005555852866c0 R14: 431bde82d7b634db R15: 00007ffc704de190
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:326 [inline]
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:838 [inline]
 #0: ffffffff8e738320 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6626
2 locks held by getty/4978:
 #0: ffff888030d7f0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900031332f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6ac/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by syz-executor378/5242:
 #0: ffff888011a3e0e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff888011a3e0e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff888011a3e0e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
 #1: ffff888077100278 (&c->state_lock){+.+.}-{3:3}, at: __bch2_fs_stop+0xfd/0x540 fs/bcachefs/super.c:617

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.11.0-syzkaller #0
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
CPU: 1 UID: 0 PID: 4665 Comm: klogd Not tainted 6.11.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:__free_one_page+0x4/0x8a0 mm/page_alloc.c:767
Code: ff ff 4c 89 e7 48 c7 c6 00 f5 f5 8b e8 a5 8b f1 ff 90 0f 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa <55> 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 e4 e0 48 81 ec c0 00
RSP: 0018:ffffc900030bf310 EFLAGS: 00000046
RAX: 0000000000000004 RBX: ffffea00018c4010 RCX: 0000000000000002
RDX: ffff88813fffa740 RSI: 0000000000063100 RDI: ffffea00018c4000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff52000617e40 R12: 0000000000000006
R13: ffff8880b8944a00 R14: 0000000000063100 R15: ffffea00018c4000
FS:  00007f38fcd19380(0000) GS:ffff8880b8900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557211fbc680 CR3: 0000000063e60000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 free_pcppages_bulk+0x3d3/0x5e0 mm/page_alloc.c:1194
 free_unref_page_commit+0x582/0x1140 mm/page_alloc.c:2594
 free_unref_page+0x622/0xea0 mm/page_alloc.c:2642
 discard_slab mm/slub.c:2587 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3055
 put_cpu_partial+0x17c/0x250 mm/slub.c:3130
 __slab_free+0x2ea/0x3d0 mm/slub.c:4347
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3992 [inline]
 slab_alloc_node mm/slub.c:4041 [inline]
 kmem_cache_alloc_node_noprof+0x16b/0x320 mm/slub.c:4084
 __alloc_skb+0x1c3/0x440 net/core/skbuff.c:664
 alloc_skb include/linux/skbuff.h:1320 [inline]
 alloc_skb_with_frags+0xc3/0x770 net/core/skbuff.c:6526
 sock_alloc_send_pskb+0x91a/0xa60 net/core/sock.c:2815
 unix_dgram_sendmsg+0x6d3/0x1f80 net/unix/af_unix.c:2030
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:745
 __sys_sendto+0x3a4/0x4f0 net/socket.c:2204
 __do_sys_sendto net/socket.c:2216 [inline]
 __se_sys_sendto net/socket.c:2212 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2212
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f38fce7b9b5
Code: 8b 44 24 08 48 83 c4 28 48 98 c3 48 98 c3 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 26 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 7a 48 8b 15 44 c4 0c 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffd24115ca8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f38fce7b9b5
RDX: 0000000000000053 RSI: 00005650827b8f60 RDI: 0000000000000003
RBP: 00005650827b4910 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000000000000013
R13: 00007f38fd009212 R14: 00007ffd24115da8 R15: 0000000000000000
 </TASK>
INFO: NMI handler (nmi_cpu_backtrace_handler) took too long to run: 1.623 msecs


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
