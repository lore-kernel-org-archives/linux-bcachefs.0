Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E5A1D3585
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Nov 2024 12:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732192824; cv=none; b=nleR/bCH4Ea7z370A97xY/Q+3kLu5uzl3CBLzJRVb42I9ABYoHCPd/ZNuM7rfN/P0Uy+xMxnDL8CpNRdmo8mhotZnm6REZi0nm4OSbMEgCUeDF+LdkFpqBPt/W3c/l9nvIq+T5qzeBcHu3Z/16oMjJlwF0yUVtx9zYFcQgG9hrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732192824; c=relaxed/simple;
	bh=DoRbSKl/CCE+/F2Bwgvx6lCt3HjyNbRCA97O+CwuMAM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GfQmDr4RS8FdwMTtYXlrQCnOwWzinObego50Ks9lNSR5kDb0FEnfxpAUcojxX/W3FcZVpnlfRC82BhTURW42zFj3ZGtAQEcVxcDV/5ltBrzvwPJDqTr1gAFVsXejqPgYeZ6pfWgWOnw4gXjEFQfOQwE2RXXab55WjxHDFAYCw5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a77a808c27so8609435ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Nov 2024 04:40:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732192822; x=1732797622;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bBkrMIxPaDGzWlux52IzE9TfNd2nfMYF1DdeZ2NDnBA=;
        b=vNlDAkeOfQyRVGeY2mT3Vikxtm0/1PMVJmbp22Jh0RbbzhUWYGagtcxN6vzCqY5KdP
         VbJXacVzjpU+q64Jz4oqvTJ9hF8GDVFgrbdfvkCdJTTic+BaDYhWNbRkYDTdATPduFyh
         dKrHlmL7vFPxrQM2ADNeQFe54t6HkE6Mtkdk4/6vCol6zekQTggxtIpsr2lJY46JsdmF
         uXxJoOk/nM0s4LtFbSrFP/Wy9Q4COBSuyWNtFsueek2n4C70wyXRiCKwBtrKpHFspuRV
         0RRyvRgT+ae+xoAj3IJu21y563KlRlCylwaJ6XnwZA/HnGW6IZrKx3g9zHW24J4ve+bF
         k4vg==
X-Forwarded-Encrypted: i=1; AJvYcCWJ4WF0F4vVNWsWqMlc99JdECZlIZxtaIf1sXRwKab2VwaUH7x0t9BE3uLZwTyb8UaVOo+8ch5TRRjVpaotJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWr4cPS6TFeT+6MXoJqD3BBMtv/7YSqfLtuPkqQKLWYValXeS0
	EwFryL+tJ7NbgMSg3xwTRjBR6/MbhbIMq9fWWymHvT8KBVKiv1CuQjBl9d/25APBiIqYSAv/WTg
	l2X5XkkmrSwhQYitnKM2YRPnl9c9uuhAwQ1lui+FtLGAThDmB+C6oNm0=
X-Google-Smtp-Source: AGHT+IEr/E7qdlIBbIEZcua30nGkuSlQYywVbAq5j6CATh9Lq7IwwZnubEO2jo5mSWZiuiboFK1PFthGkgmgQ62uJzunConG364N
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160b:b0:3a7:466e:9ebd with SMTP id
 e9e14a558f8ab-3a786473383mr70899905ab.11.1732192821995; Thu, 21 Nov 2024
 04:40:21 -0800 (PST)
Date: Thu, 21 Nov 2024 04:40:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673f2a35.050a0220.3c9d61.016f.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_lock_write
From: syzbot <syzbot+78d82470c16a49702682@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ac24e26aa08f Add linux-next specific files for 20241120
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1471bae8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=45719eec4c74e6ba
dashboard link: https://syzkaller.appspot.com/bug?extid=78d82470c16a49702682
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e61930580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e126c0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9c6bcf3605c7/disk-ac24e26a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4ce96eb398a9/vmlinux-ac24e26a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a22aac22c90/bzImage-ac24e26a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/6a6e3ddf526a/mount_0.gz

The issue was bisected to:

commit feb21a9b4c1a8527e0a61c85eec4c078c558aee9
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Oct 27 04:40:43 2024 +0000

    bcachefs: try_alloc_bucket() now uses bch2_check_discard_freespace_key()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17b79930580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14779930580000
console output: https://syzkaller.appspot.com/x/log.txt?x=10779930580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78d82470c16a49702682@syzkaller.appspotmail.com
Fixes: feb21a9b4c1a ("bcachefs: try_alloc_bucket() now uses bch2_check_discard_freespace_key()")

  stripe            0
  stripe_redundancy 0
  io_time[READ]     0
  io_time[WRITE]    0
  fragmentation     0
  bp_start          8
  incorrectly set at freespace:0:24:0 (free 0, genbits 0 should be 0), fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_locking.h:306!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 11 Comm: kworker/u8:0 Not tainted 6.12.0-next-20241120-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
RIP: 0010:__btree_node_lock_write fs/bcachefs/btree_locking.h:306 [inline]
RIP: 0010:bch2_btree_node_lock_write+0x400/0x430 fs/bcachefs/btree_locking.h:327
Code: 06 be 03 00 00 00 48 c7 c7 80 97 f2 8e 48 89 da e8 a5 c3 d4 00 49 bf 00 00 00 00 00 fc ff df e9 f2 fd ff ff e8 b1 69 79 fd 90 <0f> 0b e8 a9 69 79 fd 90 0f 0b e8 a1 69 79 fd 90 0f 0b 48 8b 4c 24
RSP: 0018:ffffc90000107778 EFLAGS: 00010293
RAX: ffffffff8426110f RBX: ffff88803485c288 RCX: ffff88801befbc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: ffff88803485c000 R08: ffffffff84260d65 R09: 1ffffffff2030b7e
R10: dffffc0000000000 R11: fffffbfff2030b7f R12: ffff88803485c268
R13: 1ffff110061a4b13 R14: ffff888030d25800 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055976c6126b8 CR3: 000000007b348000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_set_root+0x1d8/0xd10 fs/bcachefs/btree_update_interior.c:1323
 bch2_btree_node_rewrite+0x69d/0x1280 fs/bcachefs/btree_update_interior.c:2172
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x31e/0xdf0 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__btree_node_lock_write fs/bcachefs/btree_locking.h:306 [inline]
RIP: 0010:bch2_btree_node_lock_write+0x400/0x430 fs/bcachefs/btree_locking.h:327
Code: 06 be 03 00 00 00 48 c7 c7 80 97 f2 8e 48 89 da e8 a5 c3 d4 00 49 bf 00 00 00 00 00 fc ff df e9 f2 fd ff ff e8 b1 69 79 fd 90 <0f> 0b e8 a9 69 79 fd 90 0f 0b e8 a1 69 79 fd 90 0f 0b 48 8b 4c 24
RSP: 0018:ffffc90000107778 EFLAGS: 00010293
RAX: ffffffff8426110f RBX: ffff88803485c288 RCX: ffff88801befbc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: ffff88803485c000 R08: ffffffff84260d65 R09: 1ffffffff2030b7e
R10: dffffc0000000000 R11: fffffbfff2030b7f R12: ffff88803485c268
R13: 1ffff110061a4b13 R14: ffff888030d25800 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055976c6126b8 CR3: 000000000e736000 CR4: 00000000003526f0
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
