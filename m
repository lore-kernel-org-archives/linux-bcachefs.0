Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7BD257D
	for <linux-bcachefs@vger.kernel.org>; Fri, 21 Jun 2024 05:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718947882; cv=none; b=C4hjxfwlveHKsmo41phuQaxxDfHcm6LASqm5asra4Rp/mPK56dWcMnMtT+ccLGFcaZT01yj7WClZXDM9wygVDqNh9UR4Gmslu7VowYjMJ8zHnV+oSH6crtMnxJsTB3PPxivX8Mk3zFanDjEb1EXoDgKAecHQuWxamVwNA50b10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718947882; c=relaxed/simple;
	bh=RR3vVc7wRSwcZE3cxRamSOc6mHQA+Vlqd20/jF/mO+U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qjfcUPaF+nwxOiCgZYGhGG+pG1bOeSyYIU1HFUv7yaiqyC0Gk+f4wcPDHtDu5sclo3Z14LuIolxye58BTjLmvbdKlHEyxVEmSiNoNdb5s8wEtDjvcfWTxbyUGEvf9QK/3t0f6Gj2I3wYu2qt5khTYSFpwpYrQhfM1+JvLvdI5i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e8e2ea7b4bso213121539f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 22:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718947880; x=1719552680;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TGG9N+kQq+//ZmXc9Ff43ybYTja3O8Qi1F/JX9mQU1k=;
        b=D7v1z7mrV0BlGJuDrE4SYZW+TumwkjXXHYUYtRY3HmFwpfVmfr4Q5gfiNLxQpbM/07
         Ce3429KzS4HsjAuzOrBaRx7QtBFvSUcnX0bkn31bIrCmAFzGP7OmLmHtXjxly/T6J7Qz
         Ffi+gkQtTepHbsRjAZIF1BtCfuyaRym7rVOrBX1/sd8RIvzDbqq2pEmuMIClA42ECYc2
         uPEPtMgQrMCBThjoI4I9jOVwp56mFWBVYCNnFeWs2LXPlefkQNsk+JLMofVVohYfqdEh
         jIPAGgR+ATB8waopl29NEqXaVqiG1DbkSAqw360dPGcZJUHU5BYwsxf0an2KH1wJqI31
         OXow==
X-Forwarded-Encrypted: i=1; AJvYcCV3F68xB95j3f6TRXT1HDoo45zATSOPpZI/rQTLX4COZsEZG6qZpXJY7G9eQ/NP7Lu9NT/v/LCE9yUj8kYpP+bc/LrfwMKUVvZshGWaiMw=
X-Gm-Message-State: AOJu0YwF0VS6eSprFVdFwZfulgNrW5MoLmPSyltsg2xaXZ0RLl4txFyx
	oVTPjvNp1ECnHa1KIl0IirrUUrJ8FNqjJA1Y4JzitPDkSVRdzahDCX3XrjDIIcLl74P9jF55PTX
	Q7wRlocY8vtv/BZ3LyiDVhz1T8uzuKk7YsBEskGvZmNn14q+Nf1wGyrc=
X-Google-Smtp-Source: AGHT+IEOZ82b+ZYi186fdhMod85zY9fHtckkupKfSQ53IjDvA9nHUTPhAby6+hUPjQ0N3T388ZV7KBp0Upl05GBOvp0D0sXV5jBa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:154f:b0:7eb:81d6:c92c with SMTP id
 ca18e2360f4ac-7f13eb9acdbmr10952039f.0.1718947879854; Thu, 20 Jun 2024
 22:31:19 -0700 (PDT)
Date: Thu, 20 Jun 2024 22:31:19 -0700
In-Reply-To: <000000000000aa7cb106196f6883@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c43781061b5fbdcd@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_gc_mark_key
From: syzbot <syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    50736169ecc8 Merge tag 'for-6.10-rc4-tag' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16a1c341980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=12f98862a3c0c799
dashboard link: https://syzkaller.appspot.com/bug?extid=050e797ad21ccc3f5d1a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144f0a61980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17cab6a6980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5cd6a6f1e8a6/disk-50736169.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2fb1a68197bc/vmlinux-50736169.xz
kernel image: https://storage.googleapis.com/syzbot-assets/783059c8c714/bzImage-50736169.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/6448974d55b4/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/3df6949f2444/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+050e797ad21ccc3f5d1a@syzkaller.appspotmail.com

bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
======================================================
WARNING: possible circular locking dependency detected
6.10.0-rc4-syzkaller-00148-g50736169ecc8 #0 Not tainted
------------------------------------------------------
syz-executor238/5085 is trying to acquire lock:
ffff888069900988 (&c->sb_lock){+.+.}-{3:3}, at: bch2_gc_mark_key+0xc66/0x1010 fs/bcachefs/btree_gc.c:600

but task is already holding lock:
ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btree fs/bcachefs/btree_gc.c:644 [inline]
ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_check_allocations+0x2e31/0xcca0 fs/bcachefs/btree_gc.c:1224

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&c->btree_root_lock){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_btree_roots_to_journal_entries+0xbb/0x980 fs/bcachefs/btree_update_interior.c:2633
       bch2_fs_mark_clean+0x2cc/0x6d0 fs/bcachefs/sb-clean.c:376
       bch2_fs_read_only+0x1101/0x1210 fs/bcachefs/super.c:381
       __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:615
       generic_shutdown_super+0x136/0x2d0 fs/super.c:642
       bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2037
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

-> #0 (&c->sb_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
       __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_gc_mark_key+0xc66/0x1010 fs/bcachefs/btree_gc.c:600
       bch2_gc_btree fs/bcachefs/btree_gc.c:648 [inline]
       bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
       bch2_check_allocations+0x3e06/0xcca0 fs/bcachefs/btree_gc.c:1224
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
       bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
       bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
       bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1035
       bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2127
       bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
       legacy_get_tree+0xee/0x190 fs/fs_context.c:662
       vfs_get_tree+0x90/0x2a0 fs/super.c:1780
       do_new_mount+0x2be/0xb40 fs/namespace.c:3352
       do_mount fs/namespace.c:3692 [inline]
       __do_sys_mount fs/namespace.c:3898 [inline]
       __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
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

4 locks held by syz-executor238/5085:
 #0: ffff888069900278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x45/0x5b0 fs/bcachefs/super.c:1005
 #1: ffff8880699268d0 (&c->gc_lock){++++}-{3:3}, at: bch2_check_allocations+0x258/0xcca0 fs/bcachefs/btree_gc.c:1209
 #2: ffff8880699042d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:116 [inline]
 #2: ffff8880699042d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:215 [inline]
 #2: ffff8880699042d8 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x9b0/0xdf0 fs/bcachefs/btree_iter.c:3199
 #3: ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btree fs/bcachefs/btree_gc.c:644 [inline]
 #3: ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
 #3: ffff888069901a58 (&c->btree_root_lock){+.+.}-{3:3}, at: bch2_check_allocations+0x2e31/0xcca0 fs/bcachefs/btree_gc.c:1224

stack backtrace:
CPU: 1 PID: 5085 Comm: syz-executor238 Not tainted 6.10.0-rc4-syzkaller-00148-g50736169ecc8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain+0x18e0/0x5900 kernel/locking/lockdep.c:3869
 __lock_acquire+0x1346/0x1fd0 kernel/locking/lockdep.c:5137
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5754
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 bch2_gc_mark_key+0xc66/0x1010 fs/bcachefs/btree_gc.c:600
 bch2_gc_btree fs/bcachefs/btree_gc.c:648 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:697 [inline]
 bch2_check_allocations+0x3e06/0xcca0 fs/bcachefs/btree_gc.c:1224
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
 bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1035
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2127
 bch2_mount+0x6b0/0x13a0 fs/bcachefs/fs.c:1919
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc2a630571a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff54862518 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff54862570 RCX: 00007fc2a630571a
RDX: 0000000020000040 RSI: 0000000020000fc0 RDI: 00007fff54862570
RBP: 0000000020000fc0 R08: 00007fff548625b0 R09: 00000000000119f9
R10: 0000000000200001 R11: 0000000000000282 R12: 0000000020000040
R13: 00007fff548625b0 R14: 00000000000119fc R15: 00000000200001c0
 </TASK>
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): check_alloc_info... done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
missing backpointer for btree=inodes l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq a22d880bb51b703b written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
  got:   u64s 5 type deleted 0:9961472:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:9961472:0 len 0 ver 0: bucket=0:38:0 btree=inodes l=1 offset=0:0 len=256 pos=SPOS_MAX, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop0): bch2_check_extents_to_backpointers(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
syz-executor238 (5085) used greatest stack depth: 18096 bytes left


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
