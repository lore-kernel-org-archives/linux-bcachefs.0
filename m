Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC97383A5
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731589224; cv=none; b=qkNVisW4TywZYlzuFb0yqNrFQ2VjusJNk+EWcBQRw5whl4nCCkSZ6ny7totYqWDaxMIgVBeuSf3ZeMqv9AVo03tn2NVbBWUuJw6gc+jWxqlXkGxw4Ax5ydREXxReRlVfkBPvua5h2vEYVBbzqi9F7DGY/3y3aDnPcowGSSyTjck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731589224; c=relaxed/simple;
	bh=1JAHe3fpxezT/O7XNdVQF8m66ixQl4ChKTHyRG14Kzs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=No5vHi3EqhU7Nh1JAB9dixFDJvlsxPM+ZmtNB4oKDI7e9TWOWNT9NRWzViowE0we242D66si1tv55P55pYzbKEmaI77xQPDZ0fv1fDJ48Z/V4mg3OOrbskEMMo4kyZ7txrCp8ZrVjVxhS/oh4aLjcQhK0MsnZXNc+twiBBLrpYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a6b7974696so6362175ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 05:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731589221; x=1732194021;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O4Oku1y/JHwL8VJfGjnFtrFIqL5brYPToBCahnkZBb8=;
        b=MSN+gzkVg519+O+gWetdNXXniGv8V3a0xBmhOwIOKtdTq4KMo+m13vf1tST7b2lXto
         /49gdtEF4C2Km70FuoI6F3c4Z6BwarJFSUF4Q+tDKAng6xsS6tICGt2R04aMTQZRheMr
         aQRfoFz23NDeDyzCPm0ZbpYZtfruSdZ2/RjPqa2n6jZ8ep91yBsTV++eK9TJeRWKpR7u
         aYHz3ds01lfI/2QVA6pNvy+K2nGeaXDWT93AOd3GVsHL/pRjZI/h051/zPUEcH92LDAT
         dN+2HnzNaI4yJonp0J+6kaMIvBXLugTZOD34tkQb37Scmau89mXD7lukjYdzLNrHewc/
         EptQ==
X-Forwarded-Encrypted: i=1; AJvYcCWB2O+ousT+lmSoxlUv7ax81010j060dzbc3gzrD/IDI6F6J6uMF0Pzu2NUo7RH7cY9Xlz2goMVHq4rHTx/Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEyFDjTFtNm1bZAAD2/wyxN6tuvIhmBd5aQx+5n6s6rRwcv1A3
	Ebi8M5ZD4cDDRkP/bnr3HQtGLMWrFv6+/a4gNf8QEpyje62tadN/b9RTfhtsAkwpcJBewlLREJc
	k83TekqJGnNTkM51J8cEcaH+rjR5XrG4G0h8NmYfg9s6k68LuGjZU6v4=
X-Google-Smtp-Source: AGHT+IHMcu87H9/bBWh7uwz+u75rjpDaIaIcSzhPCQ2/oNPsCowm+3kLCCpHacvxy9EHhC12DGqZKzB3I17Knv3GI0W4+libRX+l
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152a:b0:3a5:e1a8:8ab1 with SMTP id
 e9e14a558f8ab-3a71fe206bbmr21772845ab.3.1731589221561; Thu, 14 Nov 2024
 05:00:21 -0800 (PST)
Date: Thu, 14 Nov 2024 05:00:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6735f465.050a0220.2a2fcc.0066.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bio_compress (2)
From: syzbot <syzbot+cb3fbcfb417448cfd278@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    de2f378f2b77 Merge tag 'nfsd-6.12-4' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d05ea7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=cb3fbcfb417448cfd278
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13f6e35f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12943e30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-de2f378f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9ee61f45ffb8/vmlinux-de2f378f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a3b0e20d8f05/bzImage-de2f378f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/113ef82b215b/mount_5.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb3fbcfb417448cfd278@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/compress.c:398!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5328 Comm: bch-rebalance/l Not tainted 6.12.0-rc6-syzkaller-00279-gde2f378f2b77 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bio_compress fs/bcachefs/compress.c:398 [inline]
RIP: 0010:bch2_bio_compress+0x13a1/0x13e0 fs/bcachefs/compress.c:498
Code: e1 07 38 c1 0f 8c 77 fb ff ff be 14 00 00 00 4c 89 ef e8 e2 36 d7 fd e9 65 fb ff ff e8 88 6f 6d fd 90 0f 0b e8 80 6f 6d fd 90 <0f> 0b e8 78 6f 6d fd 90 0f 0b e8 c0 fb 9f 07 e8 6b 6f 6d fd 90 0f
RSP: 0018:ffffc9000d166c20 EFLAGS: 00010293
RAX: ffffffff84276ae0 RBX: ffff888044747b18 RCX: ffff88801f3e4880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: ffffc9000d166eb0 R08: ffffffff8427593f R09: 0000000000000078
R10: ffffc9000d1672c0 R11: fffff52001a2ce5d R12: 0000000000000000
R13: ffff88804b67b668 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005651105940d8 CR3: 000000000e734000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_write_extent fs/bcachefs/io_write.c:962 [inline]
 __bch2_write+0x151b/0x5dd0 fs/bcachefs/io_write.c:1458
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1631
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_data_update_read_done+0x22e/0x330 fs/bcachefs/data_update.c:426
 move_write fs/bcachefs/move.c:133 [inline]
 bch2_moving_ctxt_do_pending_writes+0x44c/0x8d0 fs/bcachefs/move.c:164
 bch2_moving_ctxt_flush_all+0x1c3/0x2f0 fs/bcachefs/move.c:179
 do_rebalance fs/bcachefs/rebalance.c:379 [inline]
 bch2_rebalance_thread+0x1a87/0x1fc0 fs/bcachefs/rebalance.c:401
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bio_compress fs/bcachefs/compress.c:398 [inline]
RIP: 0010:bch2_bio_compress+0x13a1/0x13e0 fs/bcachefs/compress.c:498
Code: e1 07 38 c1 0f 8c 77 fb ff ff be 14 00 00 00 4c 89 ef e8 e2 36 d7 fd e9 65 fb ff ff e8 88 6f 6d fd 90 0f 0b e8 80 6f 6d fd 90 <0f> 0b e8 78 6f 6d fd 90 0f 0b e8 c0 fb 9f 07 e8 6b 6f 6d fd 90 0f
RSP: 0018:ffffc9000d166c20 EFLAGS: 00010293
RAX: ffffffff84276ae0 RBX: ffff888044747b18 RCX: ffff88801f3e4880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: ffffc9000d166eb0 R08: ffffffff8427593f R09: 0000000000000078
R10: ffffc9000d1672c0 R11: fffff52001a2ce5d R12: 0000000000000000
R13: ffff88804b67b668 R14: dffffc0000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fddecdff000 CR3: 0000000011e72000 CR4: 0000000000352ef0
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
