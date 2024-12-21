Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537DC1487CD
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734795213; cv=none; b=l8b46lcU3E0bpBUkW6mjDYs6JI+1pEryc0LmVl0kF23ZuPYg97UnigBWPnZAQKTUk5Pq1/cAMKDwAc5DHScWTDA8iGi6jughcNTCXm+hTkoQZbh3vCOxRCrnDhUh2elqi4SNTEOC2dsYJUH0JgUwXEwTYxZvJKJ2+RFUG1f0QWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734795213; c=relaxed/simple;
	bh=oj6GtyOvbBjt8yqK2SBO1Z1+sKqbOHrcKONC0eWVDec=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GE2vdZEcG42rvWZFDW4esUjZZpV/YJiAXgpgRzZv8l5YvNCSWqWlxJ+wgEvXzYVg0IDWOGxSGQJUPPmbixUC7FVrYTxNW06NKwDjEx3HWNF9CBYV55egVkjjkMMFevLNPTndTMhOotBBJ/JhMefTQtIktg80K2VbS8FIG15i7TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a9d303a5ccso54355335ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 07:33:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734795210; x=1735400010;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J2fBkFBd7rhg6wK+QKb2ptvNGvM+1mNN3zOrr+HUjYw=;
        b=WxvNbNKP3YfwPFuWz8CwUl4A1tXe8jlEBbrv4d9LM7IotWQm+KyEPY/5PJOTi/tdlq
         m8VtQbnjbHvhJeCOXxI12wo+oxdSso+VhLRcZTdOhjIWWx0gIQpZmj3PPsVrmTT2Kv6D
         gXUgdmwuOvINzrN/Use3howRnap7RdHM8o5JnUpz66EpIVCwSLjubZp8C0Hxj0OC9D+l
         WZSg/Pty7gVZq6JrLIy1MAnQBwuQV2O8dpe9fmKJmECVWnVWfGaODUboQ7R6P3rdZ0x5
         4WBIrKjY3QBizZWtCL69rujAX1OByPYpvIM+Lmw/R4EVq9Bqu0CCReQt5tqY955f6scF
         VyDg==
X-Forwarded-Encrypted: i=1; AJvYcCWFjwAOXy/yJz8Q4QHSWV/p6Acd7hciMTd+s23kseB984dzfP8tomCKoT1t2SILg3ss51GqfISBaxu3hpXIcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwimWSJKhQUxSIC3TPUOeUsql9WXpY1cayW2E4Cn4S8jT+ogJRR
	8vnJ5bXEuviiz60iGZnqbXmt0FuDsi3FgnzPn6CX9ueytvzUWW/rEvQW5ebABr46coHWsVGxRRp
	A/O65/Lc8OiCmgtmHtcriMwC7zqDt4tA2p7yxCzIXnXr0mMTrBbPcdGI=
X-Google-Smtp-Source: AGHT+IH83lzJN+9FtfzCVN7I3QE01OwH9PMiTzXL0TGKCv93pW/DjBqAWFkL0mgzdjLiBfD4zWSnhSBEl274HKT407pt9tcbYuA7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1889:b0:3a7:5cda:2769 with SMTP id
 e9e14a558f8ab-3c2d2f3b65emr60324855ab.12.1734795210394; Sat, 21 Dec 2024
 07:33:30 -0800 (PST)
Date: Sat, 21 Dec 2024 07:33:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6766dfca.050a0220.25abdd.0130.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (3)
From: syzbot <syzbot+5824b2660896028cfe7f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f44d154d6e3d Merge tag 'soc-fixes-6.13' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14bb8b44580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6a2b862bf4a5409f
dashboard link: https://syzkaller.appspot.com/bug?extid=5824b2660896028cfe7f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=116182df980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135974f8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-f44d154d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5966a923aa91/vmlinux-f44d154d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/41ce22f38e2f/bzImage-f44d154d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2668ea83bc50/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5824b2660896028cfe7f@syzkaller.appspotmail.com

bucket 0:41 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:631!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5298 Comm: syz-executor256 Not tainted 6.13.0-rc3-syzkaller-00017-gf44d154d6e3d #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_path_level_init+0x9ca/0x9f0 fs/bcachefs/btree_iter.c:631
Code: f5 fa ff ff e8 37 14 82 fd 90 0f 0b e8 2f 14 82 fd 90 0f 0b e8 27 14 82 fd 90 0f 0b e8 1f 14 82 fd 90 0f 0b e8 17 14 82 fd 90 <0f> 0b e8 0f 14 82 fd 90 0f 0b e8 07 14 82 fd 90 0f 0b e8 ff 13 82
RSP: 0018:ffffc9000d0e61e0 EFLAGS: 00010293
RAX: ffffffff841d5fd9 RBX: 0000000000000000 RCX: ffff88801f920000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff841d582c R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff2032f37 R12: ffff88804336c000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888048d20033
FS:  000055558e2fb380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc7a4e1ee8 CR3: 000000004320a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
 bch2_btree_path_traverse_one+0x10de/0x2940 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2210 [inline]
 bch2_btree_iter_peek_upto+0xb58/0x70e0 fs/bcachefs/btree_iter.c:2310
 bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:685 [inline]
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1abe/0x7070 fs/bcachefs/btree_gc.c:1133
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd16309bd3a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdcc127838 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdcc127850 RCX: 00007fd16309bd3a
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffdcc127850
RBP: 0000000000000004 R08: 00007ffdcc127890 R09: 002c303030303030
R10: 0000000000800000 R11: 0000000000000282 R12: 0000000000800000
R13: 00007ffdcc127890 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_path_level_init+0x9ca/0x9f0 fs/bcachefs/btree_iter.c:631
Code: f5 fa ff ff e8 37 14 82 fd 90 0f 0b e8 2f 14 82 fd 90 0f 0b e8 27 14 82 fd 90 0f 0b e8 1f 14 82 fd 90 0f 0b e8 17 14 82 fd 90 <0f> 0b e8 0f 14 82 fd 90 0f 0b e8 07 14 82 fd 90 0f 0b e8 ff 13 82
RSP: 0018:ffffc9000d0e61e0 EFLAGS: 00010293
RAX: ffffffff841d5fd9 RBX: 0000000000000000 RCX: ffff88801f920000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff841d582c R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff2032f37 R12: ffff88804336c000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888048d20033
FS:  000055558e2fb380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056329804f038 CR3: 000000004320a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
