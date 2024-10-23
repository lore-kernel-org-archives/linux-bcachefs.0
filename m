Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8971D0F77
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729708234; cv=none; b=tIHLNY91hgmOrUKiMN/QfUyR6RH+gIRlqmeYUjBApvnB8tlHrgF0TuN+dYsxKv4OKIvxK2xmfYwdJtRIChiwRvtErjkkYS3yAk3ffE2AGms0A+uwFJX+FN8Q5FYNK4XRhcp4wDSOpFFnOLf2eLTfxDv17HZBp9XSsLGL39PglKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729708234; c=relaxed/simple;
	bh=f80vyJK5elKPj295c8PQZU+sS2ag7tyTNIMjwn0fEME=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lbWbT7f2SPIYe0sUB8Zrysg31nQnAZrAPJadj9GP8TaB2FzGzPPBKIz+30Z5tKfeK2FJEdN7fj0xl5E0jmW0R4OzH5a+NcQxIIqy6m3iaQiEIg0dO40XgpmpVD/swREKl3H+P2Wy7uzGXtngUb1kT67ScrTeAKDYYdl2UIcjOrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b506c87cso2558215ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 11:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729708232; x=1730313032;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mTuaRpT4XxWfdI4LOekmTknSgZOfJq14kNE8Z3iXgiA=;
        b=pCs3nndiJAprnmA6j+OuPcF/ogtqGotwxdWu4SPZL1vhyAUL2W6sGjcjphJNiUvoMK
         QOmkKGltRlDK8A4EfZQpuXd7SjG4+yBwOIvcrZPFn0i1DuDOt+W1Zy3MTRfvaMcGStoI
         wxQxhVoUfVsEDdzBDsTrpYSXlH23YE+qc/xHa1yErU4uvbCBGEJOKwY9lIMw6VKgMeau
         0zFRzlW8JGM9RKK507oLi7pklnVCX4RF8EW1LsS8ir/Yp2SCs/RCLTTT2IXso0j6wZZ5
         3gc1g29iJex+RbSEs5tkVH/JJjA2uwKOP991szfYcY9adDcE+8rNjwQP+9DF5fyhBAv2
         Sw1A==
X-Forwarded-Encrypted: i=1; AJvYcCWKks/ECEI3kxr7auKY5O3gMPhQfCtdWnfMxoTZHoXn9Oy13bomS5kc96Iyf0WmAA5kgVeBRAX5aRSkis4R2g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVn/eP9pQLrtjf5hZ6TyO86x0M0m937Ld5eb30NM6Fof07xTBf
	SCojvdOKZIrhRomPZ6CtHGLoeWwKxRFJZ825Zz2W7Jc1qgn0dTYeV2RfSuK9/OFidUXhXtXmNqM
	KJ6IH4HJ4Jq8sbSSAggAf7afZKMG3KDE1gmlYobjq7YKiYeQDoQThT8k=
X-Google-Smtp-Source: AGHT+IEW+LUaPuaINJHdpd2xoJW4StqBq0qHKW7qmTth4vLOnOK0k0sSvymyGpLSVZQ7VhHC6X8s9blW6wF34D/12VsQK1Wb/WNN
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a46:b0:3a0:49da:8f6d with SMTP id
 e9e14a558f8ab-3a4d59ff3e1mr41546805ab.22.1729708232510; Wed, 23 Oct 2024
 11:30:32 -0700 (PDT)
Date: Wed, 23 Oct 2024 11:30:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671940c8.050a0220.10f4f4.01c3.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in __bch2_trans_relock
From: syzbot <syzbot+e088be3c2d5c05aaac35@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d5ad2d4eca3 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16b13240580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=e088be3c2d5c05aaac35
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12f9f487980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b13240580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3d5ad2d4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa98c9bf74f4/vmlinux-3d5ad2d4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/029d128be142/bzImage-3d5ad2d4.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/1c3229c22f75/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/4506ace47d8b/mount_10.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e088be3c2d5c05aaac35@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc3-syzkaller-00389-g3d5ad2d4eca3 #0 Not tainted
------------------------------------------------------
syz-executor733/5115 is trying to acquire lock:
ffff888038550128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
ffff888038550128 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_relock+0x382/0x5f0 fs/bcachefs/btree_locking.c:785

but task is already holding lock:
ffff8880424e1548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x3dc/0x15f0 fs/bcachefs/error.c:279

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       __bch2_fsck_err+0x3dc/0x15f0 fs/bcachefs/error.c:279
       bch2_check_alloc_hole_freespace+0x816/0x1180 fs/bcachefs/alloc_background.c:1278
       bch2_check_alloc_info+0x20f8/0x5330 fs/bcachefs/alloc_background.c:1547
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
       bch2_run_online_recovery_passes+0x85/0x150 fs/bcachefs/recovery_passes.c:206
       bch2_fsck_online_thread_fn+0x1da/0x410 fs/bcachefs/chardev.c:798
       thread_with_stdio_fn+0x5f/0x130 fs/bcachefs/thread_with_file.c:298
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #0 (bcachefs_btree){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
       __bch2_trans_relock+0x397/0x5f0 fs/bcachefs/btree_locking.c:785
       __bch2_fsck_err+0x131d/0x15f0 fs/bcachefs/error.c:360
       bch2_check_alloc_hole_freespace+0x816/0x1180 fs/bcachefs/alloc_background.c:1278
       bch2_check_alloc_info+0x20f8/0x5330 fs/bcachefs/alloc_background.c:1547
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
       bch2_run_online_recovery_passes+0x85/0x150 fs/bcachefs/recovery_passes.c:206
       bch2_fsck_online_thread_fn+0x1da/0x410 fs/bcachefs/chardev.c:798
       thread_with_stdio_fn+0x5f/0x130 fs/bcachefs/thread_with_file.c:298
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&c->fsck_error_msgs_lock);
                               lock(bcachefs_btree);
                               lock(&c->fsck_error_msgs_lock);
  lock(bcachefs_btree);

 *** DEADLOCK ***

3 locks held by syz-executor733/5115:
 #0: ffff888042480278 (&c->state_lock){++++}-{3:3}, at: bch2_run_online_recovery_passes+0x32/0x150 fs/bcachefs/recovery_passes.c:198
 #1: ffff888042484398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:151 [inline]
 #1: ffff888042484398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:250 [inline]
 #1: ffff888042484398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7de/0xd20 fs/bcachefs/btree_iter.c:3215
 #2: ffff8880424e1548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x3dc/0x15f0 fs/bcachefs/error.c:279

stack backtrace:
CPU: 0 UID: 0 PID: 5115 Comm: syz-executor733 Not tainted 6.12.0-rc3-syzkaller-00389-g3d5ad2d4eca3 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 __bch2_trans_relock+0x397/0x5f0 fs/bcachefs/btree_locking.c:785
 __bch2_fsck_err+0x131d/0x15f0 fs/bcachefs/error.c:360
 bch2_check_alloc_hole_freespace+0x816/0x1180 fs/bcachefs/alloc_background.c:1278
 bch2_check_alloc_info+0x20f8/0x5330 fs/bcachefs/alloc_background.c:1547
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_online_recovery_passes+0x85/0x150 fs/bcachefs/recovery_passes.c:206
 bch2_fsck_online_thread_fn+0x1da/0x410 fs/bcachefs/chardev.c:798
 thread_with_stdio_fn+0x5f/0x130 fs/bcachefs/thread_with_file.c:298
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
syz-executor733 (5115) used greatest stack depth: 11824 bytes left


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
