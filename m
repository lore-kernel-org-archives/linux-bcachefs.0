Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E3DDCD
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727977350; cv=none; b=h+QFEDKGWmaobVi9Xx2dmLWkaBPoVUt8aIdqxca4EMwK07DYtT3JvQK0VcU1LMR4PxoMdKyQ9/g+VbOkm/TsBXWjeHPvkaRjCXfuHhxFK+hijP1RregpK8xfeI7NC6lmzVQPsajSGMA1T3JiXDyuoXyYtt2PC48/WF8X1HZKAFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727977350; c=relaxed/simple;
	bh=Tw3sYx3H7J3gzvQ37HaTe+udynk3ZScYULN3rC42aNI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=P9bHUIFOiU2UiEIP/U64ZHOSEmr97xvkl0H9MFMVIMeFDfzENKz5IMUQkFiEAT0q5KjEh7vyvxV/7DWHt7wblBv5OU1yZ5cWJaFKAh3VKk1MNs+v2qab77SM73GLEeD+ZtyJKmbINFJjN451hWEnRl5alTYawNB8+OudGQiau9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82ad9fca614so172465639f.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 10:42:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727977347; x=1728582147;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nsN0MDOsLKpxRqmM7P1rmtNrYKam7fStwhypmlPwGuA=;
        b=V7k85jfxGFIN2ReGuwFOLUOn7y1ba769jVDsPjl5scwRcUhanqCpu32FY1dX1O34Q4
         fZAqt5WBqgIUoi37fl+WnKNUYZQKOybZx2WPvQo7mFIB715KzIc54LYEiA3QEqlNv1v8
         2h67LZeDZO1+6RSdfocelq7qLe9rnEx3t7YfIjOhHcH2HnMVc1mxEvJZlG9h4sVj4lFS
         x8umWK+4+NFK259Zg/gdiV7lh/BQbCXqaDuMflDdkFuktgl1GTj6KgpigPK9p7QW5sAl
         tA9TKhOyQg1NfyEF+L0x3hj8IMi+2ZzHxFkrJUpHmRKxfPR/Y5Yw6kpK9eQihSsh8KMu
         Mk5A==
X-Forwarded-Encrypted: i=1; AJvYcCUtzpM9VWcf2A9/t97l81F7ylbNsbZy7LYYaKU+wxApsyv8ak+QuXs0urJitNdzjVADNvIzdmwAuPHRZX2PMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU4sfZn/H1NRx+lluHgj7SD0rw1nxsx07LQodO4GXutuzkr/Ds
	Xspo9eSvnzNd9Vjr1PNBzNYtRsb6Ebmya/CTVjTqis1p40dlFPxfAhv9cY3GRJ5eioll2H3NNoJ
	chDjfSGXr4cmEUsbo0L2H3U0fqRdJI+3cf6Y6oR1m7K5zAQiCiHkyiu0=
X-Google-Smtp-Source: AGHT+IEdj9gaVqPS1TGvP+/aml1Sba0BY9AKFBFwz2CsHJeHImwtKseSj1VEaflTLjATmmhYYhTuuXhg3Ao0jO0akEYt2R/c9iaJ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e06:b0:3a0:5642:c78 with SMTP id
 e9e14a558f8ab-3a36592b550mr78097885ab.15.1727977347619; Thu, 03 Oct 2024
 10:42:27 -0700 (PDT)
Date: Thu, 03 Oct 2024 10:42:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fed783.050a0220.9ec68.0051.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_replicas_entry_validate
From: syzbot <syzbot+4d24267b490e2b68a5fa@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e32cde8d2bd7 Merge tag 'sched_ext-for-6.12-rc1-fixes-1' of..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=105b939f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1f009dd80b3799c2
dashboard link: https://syzkaller.appspot.com/bug?extid=4d24267b490e2b68a5fa
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1366e927980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111c7dd0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/08f3ba449e03/disk-e32cde8d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17bcace1ab90/vmlinux-e32cde8d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/da9183ac0145/bzImage-e32cde8d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4c7b8b3c4819/mount_0.gz

The issue was bisected to:

commit 49fd90b2cc332b8607a616d99d4bb792f18208b9
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Sep 25 22:17:31 2024 +0000

    bcachefs: Fix unlocked access to c->disk_sb.sb in bch2_replicas_entry_validate()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14b8a3d0580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=16b8a3d0580000
console output: https://syzkaller.appspot.com/x/log.txt?x=12b8a3d0580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4d24267b490e2b68a5fa@syzkaller.appspotmail.com
Fixes: 49fd90b2cc33 ("bcachefs: Fix unlocked access to c->disk_sb.sb in bch2_replicas_entry_validate()")

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,compression=zstd,norecovery,recovery_pass_last=check_dirents,nojournal_transaction_names,version_upgrade=none
============================================
WARNING: possible recursive locking detected
6.12.0-rc1-syzkaller-00031-ge32cde8d2bd7 #0 Not tainted
--------------------------------------------
syz-executor340/5221 is trying to acquire lock:
ffff888078a80908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_replicas_entry_validate+0x2a/0x80 fs/bcachefs/replicas.c:101

but task is already holding lock:
ffff888078a80908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_read_superblock_clean+0x36/0x520 fs/bcachefs/sb-clean.c:149

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&c->sb_lock);
  lock(&c->sb_lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by syz-executor340/5221:
 #0: ffff888078a80278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x45/0x5b0 fs/bcachefs/super.c:1007
 #1: ffff888078a80908 (&c->sb_lock){+.+.}-{3:3}, at: bch2_read_superblock_clean+0x36/0x520 fs/bcachefs/sb-clean.c:149

stack backtrace:
CPU: 0 UID: 0 PID: 5221 Comm: syz-executor340 Not tainted 6.12.0-rc1-syzkaller-00031-ge32cde8d2bd7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3037
 check_deadlock kernel/locking/lockdep.c:3089 [inline]
 validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3891
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 bch2_replicas_entry_validate+0x2a/0x80 fs/bcachefs/replicas.c:101
 journal_entry_data_usage_validate+0x2b6/0x690 fs/bcachefs/journal_io.c:608
 bch2_sb_clean_validate_late fs/bcachefs/sb-clean.c:40 [inline]
 bch2_read_superblock_clean+0x207/0x520 fs/bcachefs/sb-clean.c:168
 bch2_fs_recovery+0x1f4/0x39c0 fs/bcachefs/recovery.c:639
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2071
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2478bb0c3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecc9ae478 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffecc9ae490 RCX: 00007f2478bb0c3a
RDX: 0000000020005d80 RSI: 0000000020000240 RDI: 00007ffecc9ae490
RBP: 0000000000000004 R08: 00007ffecc9ae4d0 R09: 0000000000005daf
R10: 0000000000000044 R11: 0000000000000282 R12: 0000000000000044
R13: 00007ffecc9ae4d0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>


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
