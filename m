Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F3215ECF6
	for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716816150; cv=none; b=Pn/dDPUbZsI+i3iNj6s7CrhxzROGHAUOZO/MLkA6EtA/cn0wkprPWM+2h2zJ4NH753p9WO4bKOIDiR8EWi8LTrJvWT1JlXtlEVXR2kxaWqIHy+wKl3p6hXdhyjDOFLXU+zRoaQXMHiRCDSQVh/5mGCEk0UAaR8/yzrfVDfIGcw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716816150; c=relaxed/simple;
	bh=h2EjNcRnOdSV3DrRyQsiknvlwZNQpE3YDPF0q0Tuz+Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ix7U7sGOFhCKu0aNWiJgYcbYQ0DBjPOw0+8uBw1frAtrvIemyqkp0OKJhVffTBNsxWPJEhYDYyfH0sIAFEifAh2kpU3FKtuetiguXrVZP4dWO2s6C7wdbo980oXOdhnIYavShOIQK3Fp+baItJLtXvFsoUCsaM23l4MmyLt/vJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7e8e558d366so368383539f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 27 May 2024 06:22:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716816148; x=1717420948;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+vmoO/Nv+2txm2yPb4KYAH+uAveGcGWYNX2XgXKPZCM=;
        b=Dix01W3xTRuHooli9QP+Tlx7k5XYdUeqvhnEIOY/7Ad/c+Gx8EK1mBaXHoi6HPUGfS
         rx0rHXQ6UI1Vif8JwfgdXHuCTJfU0Uyp5S5NoLXLzvEFpJSJdL8SgmLStsGNclaNlOX9
         5sDWuqrwZQeAPFCre6hVvkd2DSGmKUzq/shC/CZjpaxzbKO86ysVBQHId5y85ApFKJk8
         wYM/cN+Slah9SMz49Wc9xWTTVkRkWx2K+Bt2x1R6naMqA8zI53VY7w7Hw5qdRxYrVrNR
         anllq8vWCz/QHLV3Oy+h3AGPe3cwWuHqNKm3h77oSDbLf1Lb0cQK1TGkhuzQqIqttfnH
         rtyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXodLpjwGEWdTeH/n+o2m+EgOrsYCOOebZwSKa641Mur6ljNmtWQREowIZJox7p34xpgHp0J4KVhLbUm3wrQfbWDJ8SF2HrmlYL3wmypMY=
X-Gm-Message-State: AOJu0Yx4aVmYZBxeNUbAsyqX/MYT5nFJizHDtzsSwJnkMaW5+mdtFGqQ
	l3WtFsJbw98GrJID3ULkIfdxfFX/E/kHyNMApdx3hFyxPjnYYNoLqXhuCuP3h81JRlam9jcp1eg
	6Incw8MdBs8w5But1BAs66E0vz9Q3pRrP8ju+TLjIG1JBQV9FwvbKLVc=
X-Google-Smtp-Source: AGHT+IGHCy6gagCt/fKN9YxjO56/wZM/jeyns5XEXri714QY6R7SBKw1sUI9XotZOrKtP7bQkAUMcon3fNja/K9ulgrmnyDyuIlw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a27:b0:374:529a:dfd3 with SMTP id
 e9e14a558f8ab-374529ae1c8mr3359065ab.4.1716816148327; Mon, 27 May 2024
 06:22:28 -0700 (PDT)
Date: Mon, 27 May 2024 06:22:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa7cb106196f6883@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_gc_mark_key
From: syzbot <syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b62e02e6336 Merge tag 'mm-hotfixes-stable-2024-05-25-09-1..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10e3fb34980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3e73beba72b96506
dashboard link: https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/61b507f6e56c/disk-9b62e02e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6991f1313243/vmlinux-9b62e02e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/65f88b96d046/bzImage-9b62e02e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com

bcachefs (loop4): alloc_read... done
bcachefs (loop4): stripes_read... done
bcachefs (loop4): snapshots_read... done
bcachefs (loop4): check_allocations...
======================================================
WARNING: possible circular locking dependency detected
6.9.0-syzkaller-12393-g9b62e02e6336 #0 Not tainted
------------------------------------------------------
syz-executor.4/6744 is trying to acquire lock:
ffff888025c00988 (&c->sb_lock){+.+.}-{3:3}, at: bch2_gc_mark_key+0x9f6/0xd90 fs/bcachefs/btree_gc.c:599

but task is already holding lock:
ffff888025c01a50 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btree.constprop.0+0x106/0x11e0 fs/bcachefs/btree_gc.c:643

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&c->btree_root_lock){+.+.}-{3:3}:
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       bch2_btree_roots_to_journal_entries+0x93/0x570 fs/bcachefs/btree_update_interior.c:2633
       bch2_fs_mark_clean+0x31b/0x470 fs/bcachefs/sb-clean.c:376
       bch2_fs_read_only+0x88a/0xf10 fs/bcachefs/super.c:381
       __bch2_fs_stop+0xfc/0x540 fs/bcachefs/super.c:613
       generic_shutdown_super+0x159/0x3d0 fs/super.c:642
       bch2_kill_sb+0x3b/0x50 fs/bcachefs/fs.c:2026
       deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
       deactivate_super+0xde/0x100 fs/super.c:506
       cleanup_mnt+0x222/0x450 fs/namespace.c:1267
       task_work_run+0x14e/0x250 kernel/task_work.c:180
       resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
       exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
       exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
       syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
       do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&c->sb_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
       bch2_gc_mark_key+0x9f6/0xd90 fs/bcachefs/btree_gc.c:599
       bch2_gc_btree.constprop.0+0x394/0x11e0 fs/bcachefs/btree_gc.c:647
       bch2_gc_btrees+0x442/0x8c0 fs/bcachefs/btree_gc.c:697
       bch2_check_allocations+0x98f/0x2670 fs/bcachefs/btree_gc.c:1217
       bch2_run_recovery_pass+0x8e/0x1a0 fs/bcachefs/recovery_passes.c:182
       bch2_run_recovery_passes+0x33b/0x710 fs/bcachefs/recovery_passes.c:225
       bch2_fs_recovery+0x259f/0x3db0 fs/bcachefs/recovery.c:807
       bch2_fs_start+0x2e9/0x600 fs/bcachefs/super.c:1031
       bch2_fs_open+0xfa0/0x1110 fs/bcachefs/super.c:2123
       bch2_mount+0xdcc/0x1130 fs/bcachefs/fs.c:1917
       legacy_get_tree+0x109/0x220 fs/fs_context.c:662
       vfs_get_tree+0x8f/0x380 fs/super.c:1780
       do_new_mount fs/namespace.c:3352 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3679
       do_mount fs/namespace.c:3692 [inline]
       __do_sys_mount fs/namespace.c:3898 [inline]
       __se_sys_mount fs/namespace.c:3875 [inline]
       __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&c->btree_root_lock);
                               lock(&c->sb_lock);
                               lock(&c->btree_root_lock);
  lock(&c->sb_lock);

 *** DEADLOCK ***

4 locks held by syz-executor.4/6744:
 #0: ffff888025c00278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x3e/0x600 fs/bcachefs/super.c:1001
 #1: ffff888025c268d8 (&c->gc_lock){++++}-{3:3}, at: bch2_check_allocations+0xf1/0x2670 fs/bcachefs/btree_gc.c:1202
 #2: ffff888025c042d0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:116 [inline]
 #2: ffff888025c042d0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:215 [inline]
 #2: ffff888025c042d0 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x656/0xf20 fs/bcachefs/btree_iter.c:3204
 #3: ffff888025c01a50 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btree.constprop.0+0x106/0x11e0 fs/bcachefs/btree_gc.c:643

stack backtrace:
CPU: 0 PID: 6744 Comm: syz-executor.4 Not tainted 6.9.0-syzkaller-12393-g9b62e02e6336 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:114
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain kernel/locking/lockdep.c:3869 [inline]
 __lock_acquire+0x2478/0x3b30 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1b1/0x560 kernel/locking/lockdep.c:5719
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x175/0x9c0 kernel/locking/mutex.c:752
 bch2_gc_mark_key+0x9f6/0xd90 fs/bcachefs/btree_gc.c:599
 bch2_gc_btree.constprop.0+0x394/0x11e0 fs/bcachefs/btree_gc.c:647
 bch2_gc_btrees+0x442/0x8c0 fs/bcachefs/btree_gc.c:697
 bch2_check_allocations+0x98f/0x2670 fs/bcachefs/btree_gc.c:1217
 bch2_run_recovery_pass+0x8e/0x1a0 fs/bcachefs/recovery_passes.c:182
 bch2_run_recovery_passes+0x33b/0x710 fs/bcachefs/recovery_passes.c:225
 bch2_fs_recovery+0x259f/0x3db0 fs/bcachefs/recovery.c:807
 bch2_fs_start+0x2e9/0x600 fs/bcachefs/super.c:1031
 bch2_fs_open+0xfa0/0x1110 fs/bcachefs/super.c:2123
 bch2_mount+0xdcc/0x1130 fs/bcachefs/fs.c:1917
 legacy_get_tree+0x109/0x220 fs/fs_context.c:662
 vfs_get_tree+0x8f/0x380 fs/super.c:1780
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x14e6/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f743727e5ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7437fb6ef8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f7437fb6f80 RCX: 00007f743727e5ea
RDX: 0000000020005b00 RSI: 0000000020000000 RDI: 00007f7437fb6f40
RBP: 0000000020005b00 R08: 00007f7437fb6f80 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000020000000
R13: 00007f7437fb6f40 R14: 0000000000005b46 R15: 00000000200000c0
 </TASK>
bucket 0:26 gen 0 data type btree has wrong cached_sectors: got 458752, should be 0, shutting down
bcachefs (loop4): inconsistency detected - emergency read only at journal seq 8
bcachefs (loop4): bch2_gc_alloc_done(): error fsck_errors_not_fixed
bcachefs (loop4): bch2_check_allocations(): error fsck_errors_not_fixed
bcachefs (loop4): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop4): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop4): shutting down
bcachefs (loop4): shutdown complete


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
