Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FCF3597E
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 01:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752802055; cv=none; b=iTyhH5sF9W5FG83s0WUcclpATuPvka8vTKw78hydPbpGcQX3h+nWLdCVKCqpvY0GVlFm3FnXre8oMgIchk3twX1P7faejaepP9AjIHnGvoeVDaSaR1gfh+W980Nc2tKHA91+GRXV//YZksWLRbcN/QL5QM/4/oXpNWIpl7wPIuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752802055; c=relaxed/simple;
	bh=ClGRLA5JwobQ+TrMYUX+2N5uynzlAkA45QbLQziQOZQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=t0uO3cAEzDjaX2N2KkbS/mx41tIJw586txcnBD+KAnuLIH2XBPw7QnRMiiWhWPXGf4DCBSk5Ajk1K+GKG5ogZeasfqiVpGuI9vRo368cyKgjN4LXKbMa/O2njotwhoI/53ve+tI22GQKQltSFm/AAEFjM/E4nNIAkptP0tj2QRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-879c1688420so252989839f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 18:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752802053; x=1753406853;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+e/8dmNeBGDHJJdePZWSz8F9xUK4kTHRVRIH1DEwq9E=;
        b=H9QiSoCa/gSEDR7tIUEwg1f0UijtjXDMfOQIxq+clLDFnxToVvg91PsqMyPxte0dpf
         X3tgpAjPBqXc8G3VbvNlHVCYEt05065uATwrUTwPowFAglaU3+G7W2GS1wlVCvIzw2A3
         Kuz1aYhqQXg252QSg0ZuR9rrVmnQT77ES9FCWDbPlfZgOVsnZV+k9ApHhhvC6yruWPe+
         T0QLt0Ln9EqHWpCtsqKIS9TE/TraNs2M3/WRipDSBL/lsa1arqIg9ceREcljiLavlTam
         Y8J/JZmYk4f6V81f8lpuQ+zAo2dakkyqivXox5sogz6U5+xjBMvqZeMs+3QecstEDyps
         W7ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVBimrJAjQF7iYbwdY9+G8RD391wHB2xgl6jcgD4Kshgpo+/CGPp6o3NR1w5bdLuMuZKgkujpMJphfvPNgquw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6pA1HQToU2kx8GHouCmFRYJCgUPsgGJq4CSe2Jhk1+Ni6iLFM
	Fbt2wIikdlo3wK7vj7xmEqAOtOehXJ09kIS2w0IQYmL6ialdtR8HEVeABlGRWAt6yrw+BkDUeiF
	JYmxfQ2xHch+cvVca62wwjkEChUp5gctdsZzuuwKYf/qVx5oW64WDJv7M7zA=
X-Google-Smtp-Source: AGHT+IF+hyYDUWUIUIGqPHGovpNWzOaNGT1VAUYD0lRvRMwhyjTQ0Ht5wONd8ON+ZFeq8seuQKfweuMBgYl0Y+3XlWppUiftJFjI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6189:b0:876:adc1:44e5 with SMTP id
 ca18e2360f4ac-87ba839fd94mr636819439f.3.1752802053013; Thu, 17 Jul 2025
 18:27:33 -0700 (PDT)
Date: Thu, 17 Jul 2025 18:27:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6879a305.a70a0220.693ce.0058.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_run_recovery_passes
From: syzbot <syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    aaef6f251176 Merge branches 'for-next/core' and 'for-next/..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=162817d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=167a38bcf05390d5
dashboard link: https://syzkaller.appspot.com/bug?extid=c2294ae43bae606e3c7d
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=112817d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/dfd0a4db9e57/disk-aaef6f25.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/602c89e1c208/vmlinux-aaef6f25.xz
kernel image: https://storage.googleapis.com/syzbot-assets/82e8ab4e1b11/Image-aaef6f25.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/780ac1e01de6/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c2294ae43bae606e3c7d@syzkaller.appspotmail.com

INFO: task syz.1.22:6793 blocked for more than 143 seconds.
      Not tainted 6.16.0-rc6-syzkaller-gaaef6f251176 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.1.22        state:D stack:0     pid:6793  tgid:6793  ppid:6662   task_flags:0x400140 flags:0x00000019
Call trace:
 __switch_to+0x414/0x834 arch/arm64/kernel/process.c:741 (T)
 context_switch kernel/sched/core.c:5397 [inline]
 __schedule+0x1414/0x2a28 kernel/sched/core.c:6786
 __schedule_loop kernel/sched/core.c:6864 [inline]
 schedule+0xb4/0x230 kernel/sched/core.c:6879
 schedule_timeout+0xac/0x270 kernel/time/sleep_timeout.c:75
 ___down_common+0x23c/0x374 kernel/locking/semaphore.c:268
 __down_common+0xc0/0x3a4 kernel/locking/semaphore.c:293
 __down+0x18/0x24 kernel/locking/semaphore.c:303
 down+0x94/0xe8 kernel/locking/semaphore.c:100
 bch2_run_recovery_passes+0x164/0x1f4 fs/bcachefs/recovery_passes.c:609
 bch2_fs_recovery+0x1df4/0x2fb4 fs/bcachefs/recovery.c:1050
 bch2_fs_start+0x940/0xbec fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0x880/0x107c fs/bcachefs/fs.c:2488
 vfs_get_tree+0x90/0x28c fs/super.c:1804
 do_new_mount+0x228/0x814 fs/namespace.c:3902
 path_mount+0x5b4/0xde0 fs/namespace.c:4226
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount fs/namespace.c:4427 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4427
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

Showing all locks held in the system:
2 locks held by kworker/u8:0/12:
1 lock held by khungtaskd/32:
 #0: ffff80008f869980 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire+0x4/0x48 include/linux/rcupdate.h:330
5 locks held by kworker/u8:2/41:
 #0: ffff0000dafdd148 ((wq_completion)btree_update#272){+.+.}-{0:0}, at: process_one_work+0x63c/0x155c kernel/workqueue.c:3212
 #1: ffff8000990f7bc0 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_one_work+0x6d4/0x155c kernel/workqueue.c:3212
 #2: ffff00010b404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:160
 #3: ffff0001078f01b0 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x68/0x200 fs/bcachefs/btree_locking.h:205
 #4: ffff00010b400920 (&c->sb_lock){+.+.}-{4:4}, at: btree_update_new_nodes_mark_sb fs/bcachefs/btree_update_interior.c:609 [inline]
 #4: ffff00010b400920 (&c->sb_lock){+.+.}-{4:4}, at: btree_update_nodes_written fs/bcachefs/btree_update_interior.c:683 [inline]
 #4: ffff00010b400920 (&c->sb_lock){+.+.}-{4:4}, at: btree_interior_update_work+0x2e8/0x1d28 fs/bcachefs/btree_update_interior.c:867
2 locks held by pr/ttyAMA0/43:
2 locks held by kworker/u8:6/352:
 #0: ffff0000c0031148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x63c/0x155c kernel/workqueue.c:3212
 #1: ffff80009bed7bc0 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work+0x6d4/0x155c kernel/workqueue.c:3212
2 locks held by kworker/u8:8/4125:
5 locks held by kworker/u8:9/4137:
 #0: ffff0000fbc4b948 ((wq_completion)btree_update#271){+.+.}-{0:0}, at: process_one_work+0x63c/0x155c kernel/workqueue.c:3212
 #1: ffff8000a0197bc0 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_one_work+0x6d4/0x155c kernel/workqueue.c:3212
 #2: ffff00010d304398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:160
 #3: ffff000104da81b0 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x68/0x200 fs/bcachefs/btree_locking.h:205
 #4: ffff00010d300920 (&c->sb_lock){+.+.}-{4:4}, at: btree_update_new_nodes_mark_sb fs/bcachefs/btree_update_interior.c:609 [inline]
 #4: ffff00010d300920 (&c->sb_lock){+.+.}-{4:4}, at: btree_update_nodes_written fs/bcachefs/btree_update_interior.c:683 [inline]
 #4: ffff00010d300920 (&c->sb_lock){+.+.}-{4:4}, at: btree_interior_update_work+0x2e8/0x1d28 fs/bcachefs/btree_update_interior.c:867
2 locks held by getty/6289:
 #0: ffff0000c19cc0a0 (&tty->ldisc_sem){++++}-{0:0}, at: ldsem_down_read+0x3c/0x4c drivers/tty/tty_ldsem.c:340
 #1: ffff80009ba3e2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x34c/0xfa4 drivers/tty/n_tty.c:2222
3 locks held by kworker/1:3/6710:
2 locks held by syz.0.299/9979:
3 locks held by syz.5.300/9983:

=============================================



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
