Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F35155382
	for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 17:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732900174; cv=none; b=uNy/9BOcZMuJU17DuGbPlub/RTH/V2D9CrKUk5TVWsLGBBz1NgtnkuYUa9KVYD6GubQSBWaYHhLJ1G/E7RfOiX/nM7pbNpnG5a9UhhUTD5fWSXTe4RMy0kAGHIp8Rg4/Y+bHLBZtXcRCnXJK3j38Hz66JJgSvD1VHh3EMB4UDu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732900174; c=relaxed/simple;
	bh=twukQPYnqJFsI5gnHPrc4DGw0H9aNhDnDcrlSDZwAQQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fNqV0iE5D2ShzTC78Ogx/7AfC7S7Chmqh0wnMa1hdBM1uDkG8+EZdOQBpUvZrpV5OKS1t8mSTsOX1up72hoSqA2HmVsfvWsyjjv4tqqcBoyVmsx8uvHZZWti78RiPhZjBiIoSjYqfEdIFoA6fKW1ar3wOJW64/g0x6y5ylpnGzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7a5031e75so22342035ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 29 Nov 2024 09:09:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732900172; x=1733504972;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJDI1X13QdG5S5f1mMXMClbs1DBH9UJJTQWHBNQNhk8=;
        b=EqDSPT35VDtAT1iwe0VeGeOVFxxyb0Duu4HWewtiji2ckhUkdT+3oILXLVdQCh4/ec
         Z9hnbrMF3zJ4XCU7BXlBj7OzAvRYGYY2U28GF2ufZ0ouNIv9DrOl34sFePpC1uJhnLoL
         TtERU45oDsVBFSZg4OTcFa0iUopYNr57wUYkAB7tyBp5nJfJPehuoGCIgSvJvVlIsicp
         n7R4B0msqRHa9JwUNr1VLMkMC4Pa1uKG/Mp3Rvr6mHZlTvx89H2ypCYj3MZSd1rVv1cN
         KbkPisyF6DAmjsT4+K/49NNxuNoc2AjwgYjGwONkAzqmcrSpwwMcW7CGGI4OvRBtZ2vL
         gomA==
X-Forwarded-Encrypted: i=1; AJvYcCUkOai0W59aIX+jqUvy9ufLB13GlJjrKTvRbM3cRsSEF9zxIi8QZqOGg0OmsqEAFWi+ohtchbbYT+2u+ch9ug==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSMOUD1v2BJEOuq2W++1T8MeidAtJVYHCMQOsg2h497BGmh0v8
	qAUcwyKV44WUXVmf87fwSL32Z/ObdTqHgVlKyDRDcAv2G3kiA3woJBC8/7TGrThBfQAQ7iTbcpJ
	sX+oWYrXwIRp908ASCni6lQ0oBaEkSf9GxBJ+Nr4/KfWwuLUWazDi/+U=
X-Google-Smtp-Source: AGHT+IELoqYzsUEOkKIxPyCUU5ediE/cHR5XKrWti5ATIdeVW+CiQgmAaTD4aTmMgNXmT3FIoRaxCfsy4uAHaKhbnFOeHrP6AbXg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3303:b0:3a7:d792:d6c0 with SMTP id
 e9e14a558f8ab-3a7d792d996mr46998075ab.20.1732900172037; Fri, 29 Nov 2024
 09:09:32 -0800 (PST)
Date: Fri, 29 Nov 2024 09:09:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6749f54c.050a0220.253251.00bc.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in trans_set_locked
From: syzbot <syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/smmu'..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=17d6af78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9bc44a6de1ceb5d6
dashboard link: https://syzkaller.appspot.com/bug?extid=78f4eb354f5ca6c1e6eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=107bdf5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13ae49e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4d4a0162c7c3/disk-7b1d1d4c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c47a4be472/vmlinux-7b1d1d4c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0e173b91f83e/Image-7b1d1d4c.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/5ab7b24d2900/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/fbfbb60588c1/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78f4eb354f5ca6c1e6eb@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
------------------------------------------------------
syz-executor203/6432 is trying to acquire lock:
ffff0000da100128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x5c/0x21c fs/bcachefs/btree_locking.h:193

but task is already holding lock:
ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
       bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
       bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
       bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
       bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
       bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
       thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #0 (bcachefs_btree){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
       __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
       bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
       __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
       bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
       bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
       bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
       bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
       bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
       thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
       kthread+0x288/0x310 kernel/kthread.c:389
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&c->fsck_error_msgs_lock);
                               lock(bcachefs_btree);
                               lock(&c->fsck_error_msgs_lock);
  lock(bcachefs_btree);

 *** DEADLOCK ***

3 locks held by syz-executor203/6432:
 #0: ffff0000dc600278 (&c->state_lock){++++}-{3:3}, at: bch2_run_online_recovery_passes+0x3c/0x174 fs/bcachefs/recovery_passes.c:204
 #1: ffff0000dc604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:150
 #2: ffff0000dc661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282

stack backtrace:
CPU: 1 UID: 0 PID: 6432 Comm: syz-executor203 Not tainted 6.12.0-syzkaller-g7b1d1d4cfac0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 trans_set_locked+0x88/0x21c fs/bcachefs/btree_locking.h:194
 __bch2_trans_relock+0x2a0/0x394 fs/bcachefs/btree_locking.c:785
 bch2_trans_relock+0x24/0x34 fs/bcachefs/btree_locking.c:793
 __bch2_fsck_err+0x1664/0x2544 fs/bcachefs/error.c:363
 bch2_check_alloc_hole_freespace+0x5fc/0xd74 fs/bcachefs/alloc_background.c:1278
 bch2_check_alloc_info+0x1174/0x26f8 fs/bcachefs/alloc_background.c:1547
 bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
 bch2_run_online_recovery_passes+0xa4/0x174 fs/bcachefs/recovery_passes.c:212
 bch2_fsck_online_thread_fn+0x150/0x3e8 fs/bcachefs/chardev.c:799
 thread_with_stdio_fn+0x64/0x134 fs/bcachefs/thread_with_file.c:298
 kthread+0x288/0x310 kernel/kthread.c:389
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862


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
