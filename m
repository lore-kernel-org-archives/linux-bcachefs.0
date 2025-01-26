Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA932B9A6
	for <linux-bcachefs@vger.kernel.org>; Sun, 26 Jan 2025 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737898656; cv=none; b=obZVE3YO4KHGtBFmhhRUb8ogf1yz57tfgBBGgVbqD5vw5b9tj7ww4MCnx/Rz0TlJ4k2KnToLeOoSbFv7f+prj+IZcr2qvQcR+ZNcXIPiWNOCwAgLLq3cBhq2kjyYOP6lBdsoEYLkSz//C0ln4I6hcYr1zXmEA/dcE4wHH+vxY4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737898656; c=relaxed/simple;
	bh=uO/o2zBJKYL7hCVJckidjOlmJPiP2i81fY6cImHmo3U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pDvjq3HWAPG0UqWP3K8+sd1IpoQoE2HwmQVBThoZq+NkTPd4tmp3ZE00X7LZ1g7vDl5ZpInQDYuRAVL6gLvRBAR4ZpmSCPgWz5xQWXtbrWnNhEPePuvGxjfYSKoAVkc2N6oM+3UmQ1sZAPEZHRzTBtDO/1w5P3NIion+/+1wTQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3cfb20d74b5so25563915ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 26 Jan 2025 05:37:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737898653; x=1738503453;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tjdmOkHqAzyx18iUrY3VVxG+K49t7AT5DN8lWKuOJwc=;
        b=hnT6xOAWYaNeJWxX6wlBGhc2a6bRQ8FYOGHJ6Jo78T3C0psfhwdGyuCmivh513Chqe
         Mx8MMFxpH7VrRaZe45/XyF/ZhKFdmuXyipcdxDxCdHfJ+W/COp8+qd476cPgdr7dYVb2
         mDfZ3hINEcVgeTXe3Gt8VoBsG+gAPOJBlbMfrxdZWjYTDIJxD2akLZs//xJMIM9bVhmw
         hX0bSpKRWcuri+0BhZhBMbbMCInvuGh4utsMpuuKH1F+Je2UytECZgfbUshCwGh5gb6B
         DBnzBVRA1FgaRSm7Zxm0ZSYTYF6YhG8Yy8FW6SAvmAn223poDJSeP4k7/jom4n6St0ds
         S2VQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAJqiXD4qUSuZGnEADTQvfKMFhtQmCVTxyXT23yrsooriKQqyuFbEkwtXAc6bV1sLI7BBfck+YqhENd9RPiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd8N7PQSl9HOQi0Fq91/HTXgAjc0kNeAxK94cqwEfibpkcPi9J
	telq0bB+B60kBfZV+HgipfOfyAE7qaNolZRCW8L7g4Gy2z0CqWNLuKGHH9JFB0LJwsipxTS64pz
	iwOokE/O8KjsLbdNkrPgbTKSblS6Hfav5ZNg3FmQDZwZ9B43Pq3Geink=
X-Google-Smtp-Source: AGHT+IG7mvbKvVyYNANZq9QIHAW9Zi4q28Lg2aIo7g3pSbdtaOL7rHazkY0ka+B55K8bCFjnPXNAjcVDC0sdw0puu7jD2DdyHSUT
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a45:b0:3cf:bc71:94f5 with SMTP id
 e9e14a558f8ab-3cfbc719567mr128253695ab.22.1737898653363; Sun, 26 Jan 2025
 05:37:33 -0800 (PST)
Date: Sun, 26 Jan 2025 05:37:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67963a9d.050a0220.2eae65.0038.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_journal_halt
From: syzbot <syzbot+4a65c3228a624fc51bbd@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c4b9570cfb63 Merge tag 'audit-pr-20250121' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bac9f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d46425e33fe266e
dashboard link: https://syzkaller.appspot.com/bug?extid=4a65c3228a624fc51bbd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159225df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13671824580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c4b9570c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/731d6adef14e/vmlinux-c4b9570c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fba145e47ede/bzImage-c4b9570c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/67a3a74f7d49/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4a65c3228a624fc51bbd@syzkaller.appspotmail.com

bcachefs (loop0): journal_entry_open(): fatal error cannot start: journal seq overflow
============================================
WARNING: possible recursive locking detected
6.13.0-syzkaller-02526-gc4b9570cfb63 #0 Not tainted
--------------------------------------------
kworker/u4:7/1036 is trying to acquire lock:
ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: bch2_journal_halt+0x2f/0x110 fs/bcachefs/journal.c:315

but task is already holding lock:
ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: __journal_res_get+0x497/0x26b0 fs/bcachefs/journal.c:533

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&j->lock);
  lock(&j->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by kworker/u4:7/1036:
 #0: ffff888043693948 ((wq_completion)btree_update){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff888043693948 ((wq_completion)btree_update){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3317
 #1: ffffc9000269fc60 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc9000269fc60 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3317
 #2: ffff888044c84378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:164 [inline]
 #2: ffff888044c84378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:256 [inline]
 #2: ffff888044c84378 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e4/0xd30 fs/bcachefs/btree_iter.c:3378
 #3: ffff88804430c140 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:198 [inline]
 #3: ffff88804430c140 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9ca/0x1d90 fs/bcachefs/btree_iter.c:3275
 #4: ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #4: ffff888044cca980 (&j->lock){+.+.}-{3:3}, at: __journal_res_get+0x497/0x26b0 fs/bcachefs/journal.c:533

stack backtrace:
CPU: 0 UID: 0 PID: 1036 Comm: kworker/u4:7 Not tainted 6.13.0-syzkaller-02526-gc4b9570cfb63 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: btree_update btree_interior_update_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3039
 check_deadlock kernel/locking/lockdep.c:3091 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3893
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 bch2_journal_halt+0x2f/0x110 fs/bcachefs/journal.c:315
 bch2_fs_emergency_read_only+0x50/0xc0 fs/bcachefs/super.c:407
 bch2_fatal_error+0x15/0x40 fs/bcachefs/error.c:49
 journal_entry_open fs/bcachefs/journal.c:385 [inline]
 __journal_res_get+0xbef/0x26b0 fs/bcachefs/journal.c:557
 bch2_journal_res_get_slowpath+0xe6/0x710 fs/bcachefs/journal.c:619
 bch2_journal_res_get fs/bcachefs/journal.h:383 [inline]
 bch2_trans_journal_res_get fs/bcachefs/btree_trans_commit.c:350 [inline]
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:652 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:866 [inline]
 __bch2_trans_commit+0x353c/0x97a0 fs/bcachefs/btree_trans_commit.c:1066
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:706 [inline]
 btree_interior_update_work+0x1449/0x2a70 fs/bcachefs/btree_update_interior.c:844
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
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
