Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB113C69E
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 22:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726957043; cv=none; b=S0nrgr9rrTyL3Cqm8QkB8IypD20Jf01ND6idYvfsD3wWhATzSt690qA/xBlIFsNJc8pl74wkLYBv6fthSvuDdyDm1EcoWvOXPUwj38XxQo7vrtgsaap0lTADKir2LjIP8ebHSy6tReLh90Jwj0frx/Ye0/u0HgFDAk45Em4E8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726957043; c=relaxed/simple;
	bh=IFh4Maj6UW5RQOm/qPtBr9XXOIvoJz+mSd3EUAtYbok=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mZ0Ajtn98j0Z2LW1bu0LqJZivpC/ki7/A8djXSkbnIx7UJi7Dqntuo/KWpQgImhAQzBYeKBEKpUjD9gIuyyY/A6RcqXaclh2zVbCHBqBQjZCp1bkrAVSrGqGjo9B6c6K7nzF0konl2BLfKU4k+owbmkXQbu2hZxutoaOmKjgOlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a1957c7cf3so3917485ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 15:17:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726957041; x=1727561841;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lKEaZ3XUYzDkpvxFCKTLsuZp4TPmFkXohdjsHzPWWys=;
        b=SJzIIbdDFqhbx74nFJgpeMr9s6ttbATJohEqkOCpobEhPjsEo19GIrLVBExUgxhNrN
         Hbeds5XKT/o8JqYuIr7LzN2gtDS0VIvOBxcigsq7ZrWDS97aXLF3wlONnzBqyowA1og4
         HBBqJKmCNV29ileZcfe+p9tiMnOGoO6M9G65XPieX+IbyHefqAIm7Hah+WqGYKH4Uoy/
         F5U0oV88YKb8B/n9qvoi/ygMuH7KZho+Itn5lB3b+5LIWJaUMrUfg+CZYgsCAC4GZNfr
         u6uMM2NxrxQuILQYPG0hctKFxm4B6zOul5/NhxPRLZcnBZgpbWZYJhxsH/h9u/z1Wk0u
         WiyA==
X-Forwarded-Encrypted: i=1; AJvYcCWYnWj5gMPDfDR/jCCTBDZZNfvcRJSVEHUnU52o+Druz4umw3+jtnUt6SPcQfep8bPUWZU9Ow108Jj6MMURQA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl0Myuv//AFPGgiXK/+LPiB06BDBOSYIiccD079G8uARC+6cXM
	t14bW12v3InHphdtQKhTrKINQzbwwS41TUkgNUSP+9WGSJJk4NbCJw+AM7N0uMT0n/+SeuEShJK
	9ddTS8x9uEGYPYN4KhJua1+aFQDCX8mHaslF35WQMu3oaUB3iXkhHs70=
X-Google-Smtp-Source: AGHT+IG4YkzFZmYXrTvyeOyU7sGRS+Xv1+JyJgn602d4bdKPOA4Bn/DiIhoLr9thMjr5uyzLccXtxub8ygEYIjhTvjTvOHVDF3Eu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ee:b0:3a0:aac2:a0a4 with SMTP id
 e9e14a558f8ab-3a0c8c926e7mr52957165ab.9.1726957040938; Sat, 21 Sep 2024
 15:17:20 -0700 (PDT)
Date: Sat, 21 Sep 2024 15:17:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ef45f0.050a0220.3195df.006d.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_pos_to_text
From: syzbot <syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a940d9a43e62 Merge tag 'soc-arm-6.12' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ac44a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1653f803fffa3848
dashboard link: https://syzkaller.appspot.com/bug?extid=cf7b2215b5d70600ec00
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1276469f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17731207980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-a940d9a4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/371e11b6a9e5/vmlinux-a940d9a4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/920eb0c53785/bzImage-a940d9a4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/613a2d63144c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf7b2215b5d70600ec00@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.h:126!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5111 Comm: read_btree_node Not tainted 6.11.0-syzkaller-03917-ga940d9a43e62 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:126 [inline]
RIP: 0010:bch2_btree_pos_to_text+0x1ee/0x1f0 fs/bcachefs/btree_cache.c:1295
Code: 00 00 fc ff df e9 70 ff ff ff 89 d9 80 e1 07 38 c1 0f 8c 7a ff ff ff 48 89 df e8 2d 90 ec fd e9 6d ff ff ff e8 b3 4b 85 fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000315f448 EFLAGS: 00010293
RAX: ffffffff840ede8d RBX: 00000000000000de RCX: ffff88801e138000
RDX: 0000000000000000 RSI: 00000000000000de RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff840edd7a R09: 0000000000000000
R10: ffffc9000315f5e0 R11: fffff5200062bec1 R12: ffff8880410b0000
R13: ffff888041280000 R14: ffff888041280000 R15: ffffc9000315f5e0
FS:  0000000000000000(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559507bd4640 CR3: 000000003f78a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_node_read_work+0x486/0x1260 fs/bcachefs/btree_io.c:1308
 bch2_btree_node_read+0x2433/0x2a10
 bch2_btree_node_fill+0xcd1/0x1320 fs/bcachefs/btree_cache.c:886
 bch2_btree_node_get_noiter+0x9b3/0xf50 fs/bcachefs/btree_cache.c:1155
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:190 [inline]
 read_btree_nodes_worker+0x122c/0x20b0 fs/bcachefs/btree_node_scan.c:239
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:126 [inline]
RIP: 0010:bch2_btree_pos_to_text+0x1ee/0x1f0 fs/bcachefs/btree_cache.c:1295
Code: 00 00 fc ff df e9 70 ff ff ff 89 d9 80 e1 07 38 c1 0f 8c 7a ff ff ff 48 89 df e8 2d 90 ec fd e9 6d ff ff ff e8 b3 4b 85 fd 90 <0f> 0b 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000315f448 EFLAGS: 00010293
RAX: ffffffff840ede8d RBX: 00000000000000de RCX: ffff88801e138000
RDX: 0000000000000000 RSI: 00000000000000de RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff840edd7a R09: 0000000000000000
R10: ffffc9000315f5e0 R11: fffff5200062bec1 R12: ffff8880410b0000
R13: ffff888041280000 R14: ffff888041280000 R15: ffffc9000315f5e0
FS:  0000000000000000(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559507bd4640 CR3: 0000000011a04000 CR4: 0000000000350ef0
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
