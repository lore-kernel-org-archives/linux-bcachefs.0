Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1498712FF87
	for <linux-bcachefs@vger.kernel.org>; Mon,  3 Jun 2024 13:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419938; cv=none; b=Fnm+xCbT6RhB3jTlvGW46tZhQgUWbXNJqRN/TA30Uh4jPtV9awipKB3G2m4rzoEGaIuLL6/Q6RYEvO29aGkR9Pm5tgBNTTUigbQdBUJrXa4kQ9nKux+cFF0O4yM/fzXfsOqN23NkYZLB7a8otjK4FfJSfnaJA9drazTyutkohgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419938; c=relaxed/simple;
	bh=ZE/9DOEbNj6Jwwg0TxVGkIOgaBnrzbtYpp6IPdg3FV0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YiVB5D5yZXAfiiw9d1iTFfMdl23KOtCqHPP5M9lyn8fvzTMKlpuVQnx03JJZytGs8PHPhkhxxex73GHmKjExv4sm2U93ReWE6w4QGfTOGDYBF29sSLcIIRR7UbGXzUcUL/I1YZvDGXlZDSxM5yyH0CJGeer9AHX69+2jFmY4nAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e92491e750so394218639f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 03 Jun 2024 06:05:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419936; x=1718024736;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kDs+Jy5W9nY4VTAydTFq2pw4YqdIVNkDNMQOStvR6Hc=;
        b=tb8Z/mv228G0V6aQWRAQYP3Vqb+P8Xdf3UkVnHx0yEWiNxrmDy1rBZmBC3qdq9wJD7
         frHWZi6KEIZewfonZTMMtppjjcVMZ9rFbEvr50jd13dN/5AYJG2eM5Yx6/lPoAtyHRdd
         GZnVHA4UNtxZVKAMG2cZFk5bz2VNw7nKso2s1DyGS1NnJj4AHsus5t6YwyBStPugVCVQ
         6jGep4eM+teZxplbHvdghGMWnJUSZeZH0/EjiZJ5848BumkDS32bmOrs0WOkeNFb19mi
         yQBnDPX+qdRGJbGaL1i4VCp5Lq9sf4GA3wRfcs7K8X3aal2ych941UFATEnDI1lVuxzt
         f/BQ==
X-Forwarded-Encrypted: i=1; AJvYcCUK+pp9aDGgkoud2fADfw9tKp4S8dzCJBSDRnm3nLZHDjCMEzu+Ufntqvr4ExZTgHwpbbIbC4pdUtdV2g1XuLU/6D51Uwe+yzuhSbEXbzs=
X-Gm-Message-State: AOJu0YwL3WXUlt11E800549g/jRBanhT5t3Bg+zamcrXZiKJyzA2960j
	kkmNSU8z5wdoCNpFG2ibyf2CEZbqDIfg8LmyehuI7VM8zV5WtsXf18wm2Sa+AMv9paiE3cVG05z
	+ckNOExLq50MKnNTUaNOr9AJvdiFwRFhDWmTBDGLuSMTC9enbOPbwtdQ=
X-Google-Smtp-Source: AGHT+IET237czKJjaZusM6rvDcjlogMh6mfGSMRAaS3ThVYtJW8nLJxTt6K2qwl9febm+DX9Lfe9q3f7LPB9tKL2J6/HqkAJnmei
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a6b:6f12:0:b0:7e2:481e:7dbe with SMTP id
 ca18e2360f4ac-7eaf6d13075mr27722639f.1.1717419933246; Mon, 03 Jun 2024
 06:05:33 -0700 (PDT)
Date: Mon, 03 Jun 2024 06:05:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d38460619fbfd92@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_btree_roots_to_journal_entries
From: syzbot <syzbot+49f73403c9dd50916299@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e1980c40b6e Add linux-next specific files for 20240531
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=165e4206980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9c3ca4e54577b88
dashboard link: https://syzkaller.appspot.com/bug?extid=49f73403c9dd50916299
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165bfa9a980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10dc7ef2980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44fb1d8b5978/disk-0e1980c4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a66ce5caf0b2/vmlinux-0e1980c4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8992fc8fe046/bzImage-0e1980c4.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/6e6980c5e9d0/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/84607f339774/mount_1.gz

The issue was bisected to:

commit 228e1c91ae5ec44f38aa8852aa3953005badce82
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Dec 27 23:31:46 2023 +0000

    bcachefs: KEY_TYPE_accounting

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10de95fc980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12de95fc980000
console output: https://syzkaller.appspot.com/x/log.txt?x=14de95fc980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+49f73403c9dd50916299@syzkaller.appspotmail.com
Fixes: 228e1c91ae5e ("bcachefs: KEY_TYPE_accounting")

bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 15
bcachefs (loop0): shutdown complete, journal seq 16
bcachefs (loop0): marking filesystem clean
======================================================
WARNING: possible circular locking dependency detected
6.10.0-rc1-next-20240531-syzkaller #0 Not tainted
------------------------------------------------------
syz-executor537/5091 is trying to acquire lock:
ffff888077801a60 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633

but task is already holding lock:
ffff888077800918 (&c->sb_lock){+.+.}-{3:3}, at: bch2_fs_mark_clean+0x35/0x9f0 fs/bcachefs/sb-clean.c:287

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&c->sb_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5817
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_gc_mark_key+0xb3e/0x1050 fs/bcachefs/btree_gc.c:602
       bch2_gc_btree fs/bcachefs/btree_gc.c:650 [inline]
       bch2_gc_btrees fs/bcachefs/btree_gc.c:699 [inline]
       bch2_check_allocations+0xa1db/0xb9d0 fs/bcachefs/btree_gc.c:1121
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
       bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:226
       bch2_fs_recovery+0x238b/0x3730 fs/bcachefs/recovery.c:846
       bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1017
       bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2113
       bch2_mount fs/bcachefs/fs.c:1908 [inline]
       bch2_fs_get_tree+0x75e/0x14d0 fs/bcachefs/fs.c:2069
       vfs_get_tree+0x90/0x2a0 fs/super.c:1780
       do_new_mount+0x2be/0xb40 fs/namespace.c:3352
       do_mount fs/namespace.c:3692 [inline]
       __do_sys_mount fs/namespace.c:3898 [inline]
       __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&c->btree_root_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3159 [inline]
       check_prevs_add kernel/locking/lockdep.c:3278 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3902
       __lock_acquire+0x1359/0x2000 kernel/locking/lockdep.c:5194
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5817
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633
       bch2_fs_mark_clean+0x4a9/0x9f0 fs/bcachefs/sb-clean.c:314
       bch2_fs_read_only+0x1115/0x1220 fs/bcachefs/super.c:367
       __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:601
       generic_shutdown_super+0x136/0x2d0 fs/super.c:642
       bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2025
       deactivate_locked_super+0xc4/0x130 fs/super.c:473
       cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
       task_work_run+0x24f/0x310 kernel/task_work.c:180
       ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
       ptrace_report_syscall include/linux/ptrace.h:415 [inline]
       ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
       syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
       syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
       __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
       syscall_exit_to_user_mode+0x273/0x370 kernel/entry/common.c:218
       do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&c->sb_lock);
                               lock(&c->btree_root_lock);
                               lock(&c->sb_lock);
  lock(&c->btree_root_lock);

 *** DEADLOCK ***

3 locks held by syz-executor537/5091:
 #0: ffff88807fdf00e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock fs/super.c:56 [inline]
 #0: ffff88807fdf00e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: __super_lock_excl fs/super.c:71 [inline]
 #0: ffff88807fdf00e0 (&type->s_umount_key#44){+.+.}-{3:3}, at: deactivate_super+0xb5/0xf0 fs/super.c:505
 #1: ffff888077800278 (&c->state_lock){+.+.}-{3:3}, at: __bch2_fs_stop+0xfd/0x540 fs/bcachefs/super.c:600
 #2: ffff888077800918 (&c->sb_lock){+.+.}-{3:3}, at: bch2_fs_mark_clean+0x35/0x9f0 fs/bcachefs/sb-clean.c:287

stack backtrace:
CPU: 0 PID: 5091 Comm: syz-executor537 Not tainted 6.10.0-rc1-next-20240531-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2075
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2204
 check_prev_add kernel/locking/lockdep.c:3159 [inline]
 check_prevs_add kernel/locking/lockdep.c:3278 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3902
 __lock_acquire+0x1359/0x2000 kernel/locking/lockdep.c:5194
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5817
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633
 bch2_fs_mark_clean+0x4a9/0x9f0 fs/bcachefs/sb-clean.c:314
 bch2_fs_read_only+0x1115/0x1220 fs/bcachefs/super.c:367
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:601
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2025
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x273/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f61d2db54c7
Code: 07 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd384f1498 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 000000000000e4de RCX: 00007f61d2db54c7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd384f1550
RBP: 00007ffd384f1550 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007ffd384f25c0
R13: 000055557a8f46c0 R14: 431bde82d7b634db R15: 00007ffd384f25e0
 </TASK>
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 14
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop0): shutdown complete, journal seq 15
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 15
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 15
bcachefs (loop0): shutdown complete, journal seq 16
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 14
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop0): shutdown complete, journal seq 15
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 14
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop0): shutdown complete, journal seq 15
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 15
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 15
bcachefs (loop0): shutdown complete, journal seq 16
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 14
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop0): shutdown complete, journal seq 15
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 15
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 15
bcachefs (loop0): shutdown complete, journal seq 16
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 15
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 15
bcachefs (loop0): shutdown complete, journal seq 16
bcachefs (loop0): marking filesystem clean
bcachefs (loop0): shutdown complete
bcachefs (loop0): shutting down
bcachefs (loop0): going read-only
bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 14
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 14
bcachefs (loop0): shutdown complete, journal seq 15


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
