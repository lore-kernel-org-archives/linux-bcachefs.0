Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33C125634
	for <linux-bcachefs@vger.kernel.org>; Sun, 12 May 2024 17:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715535989; cv=none; b=BAmdiUa23KCa0AoJLXmseW7n2BVi+YvCgh/3awRjfnUcttQ5++YJL5bJiLN4ptwXtLEz43vDr9gqoQSfJGX6qWMhIaWGizN9iEsHl2/n0A0dwFW7qjM+5DU27YBN760+2+ADuN0pywSqpwiiyKVxVvgClKrzUKv84lKwbGcNnMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715535989; c=relaxed/simple;
	bh=y5aEzV8ufIoSlSzlHlLdymvicZ4i0iAp7RAbKtzODxs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CK+79XKuBK7mp+mguHkJGIirRcdhznby16une2UVFBm7f44yDa6FGJ0IrMsI7TRokGYtD1DsrkVlr94LQBMcI1YTX0FratLsIS0f4UtOf9w7nX1eb0TsDT3Fx6Iml6GaV+q7StPNfg5klhCH6rEZuWz5W+33yEimWtXRejxrUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e17a8bed9eso374426139f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 12 May 2024 10:46:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715535987; x=1716140787;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XAkAAbnbPN/MDGQjNtrkgJIi0Je09liIyw+Sf3X0IEg=;
        b=AGBJ3uChjbAEdI5rKFMDvylChFuH4VvvlU7ztZsS6m0Z9FvnXjvxfOiuCmxtQIWjwu
         Wz05ezaZF3YvHUhlOh1Iy2sYvEgU204pC1dyf3uye2YRu+u+2xxwX3EECU6+Lca6zubw
         wuJZ2TDMbE4VVXtYlbHeOmV0dxQPifT83sjg9kiXc1qaCpJ45NV6RSXmpIEVfgRHW0zq
         g/DegAUrWUM7lUZCkIXamfAp+JLOdmvSDo714x0brfWITNfnCgmveKS13n77KW0QhvYo
         DDN5k1CNroC8vdG6vYvYEljJ8/xlhdAP7WQMpS82Rwvn7ia+a/JNe6Urx0kKisIcWJO2
         ErPg==
X-Forwarded-Encrypted: i=1; AJvYcCXcPZao9vOX2B0mx1jK/QT0eJ+8nsXsxRrQgWnk696Ah2DbcLjPaBeGdwnpadMwKRMhj0CSUuDGzPQYEw2W9aWTR0UGk5+UF1YHalE5epM=
X-Gm-Message-State: AOJu0Yx1O25ge6nooNS/mxgLXRAvw58MasF5lwbIEaeeLNmes+mlLAph
	0rlim67Rl/aYa5p35FQAsyw7rwvN1JWD8Q5GI+qmWfTiOlmCTRqGM32G9n94m+Vc9qY9dhc5iz2
	13gVG8z/2mAbW6RktwwDEEOtDy5TpwcGAhmvdVGjn8UFDcXiXLaA+XOc=
X-Google-Smtp-Source: AGHT+IEfDPqBk7P48KrKO9kWEhHaXd74tLYOrKloqKPr5+qBv5kD/ZPRV3bNfQ2LkhrshTQUKx0sRZaio2z6cM7F0er0QsByao9p
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:34a7:b0:488:b879:a392 with SMTP id
 8926c6da1cb9f-489592479ddmr687079173.6.1715535987230; Sun, 12 May 2024
 10:46:27 -0700 (PDT)
Date: Sun, 12 May 2024 10:46:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001e59c20618455922@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in cpu_replicas_add_entry
From: syzbot <syzbot+73414091bd382684ee2b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cf87f46fd34d Merge tag 'drm-fixes-2024-05-11' of https://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=148f37bc980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=73414091bd382684ee2b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159e243f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1460fc5c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9c147953fc8e/disk-cf87f46f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a55c9d1f91fc/vmlinux-cf87f46f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8dab47ae8c2/bzImage-cf87f46f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7ca4b9223f48/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=176de750980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14ede750980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10ede750980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73414091bd382684ee2b@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
------------[ cut here ]------------
kernel BUG at fs/bcachefs/replicas.c:205!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 5075 Comm: syz-executor128 Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:cpu_replicas_add_entry+0x6c8/0x6f0 fs/bcachefs/replicas.c:205
Code: 24 18 e8 ab 22 be fd e9 57 fd ff ff e8 f1 c5 5c fd 90 0f 0b e8 e9 c5 5c fd 90 0f 0b e8 e1 c5 5c fd 90 0f 0b e8 d9 c5 5c fd 90 <0f> 0b e8 d1 c5 5c fd 90 0f 0b e8 c9 c5 5c fd 90 0f 0b e8 c1 c5 5c
RSP: 0018:ffffc9000346ef18 EFLAGS: 00010293
RAX: ffffffff843941b7 RBX: dffffc0000000000 RCX: ffff888023cd5a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff84393d28 R09: ffffffff843804ad
R10: 0000000000000007 R11: ffff888023cd5a00 R12: 1ffff1100eb70101
R13: ffff888071e440a3 R14: 0000000000000000 R15: ffff888071e440a0
FS:  000055556e8b0380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561d03c02678 CR3: 0000000074648000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_replicas_set_usage+0x3cf/0x710 fs/bcachefs/replicas.c:630
 journal_replay_early+0xba/0x4f0 fs/bcachefs/recovery.c:411
 bch2_fs_recovery+0x39c2/0x63b0 fs/bcachefs/recovery.c:747
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1043
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efe923c2b7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffec93a6af8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffec93a6b10 RCX: 00007efe923c2b7a
RDX: 0000000020011a00 RSI: 0000000020011a40 RDI: 00007ffec93a6b10
RBP: 0000000000000004 R08: 00007ffec93a6b50 R09: 0066666666666666
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffec93a6b50 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:cpu_replicas_add_entry+0x6c8/0x6f0 fs/bcachefs/replicas.c:205
Code: 24 18 e8 ab 22 be fd e9 57 fd ff ff e8 f1 c5 5c fd 90 0f 0b e8 e9 c5 5c fd 90 0f 0b e8 e1 c5 5c fd 90 0f 0b e8 d9 c5 5c fd 90 <0f> 0b e8 d1 c5 5c fd 90 0f 0b e8 c9 c5 5c fd 90 0f 0b e8 c1 c5 5c
RSP: 0018:ffffc9000346ef18 EFLAGS: 00010293
RAX: ffffffff843941b7 RBX: dffffc0000000000 RCX: ffff888023cd5a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff84393d28 R09: ffffffff843804ad
R10: 0000000000000007 R11: ffff888023cd5a00 R12: 1ffff1100eb70101
R13: ffff888071e440a3 R14: 0000000000000000 R15: ffff888071e440a0
FS:  000055556e8b0380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561d03c02678 CR3: 0000000074648000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
