Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027D51EA7C6
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Sep 2025 07:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757836409; cv=none; b=fgAM3PJo+0ib1i2KX8C+RuCsv66wm85eFVlX45fJqB/r0SWbAzHBJq6/EsTBDFehsfZl7qP1Nt5SaCL8f4yIViw0Juba6ZVhdgS2ZtHggKwhI+06fnkqD48LwDfBT5sTiJ2QyBz8ZYAyYDOtulWS4pCFkSXGGfENAkW7k7acWUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757836409; c=relaxed/simple;
	bh=qkxA4K0qPEUSbPWKE/1gmkI85LY4Qnz1euenyPFCBfY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u8r01ohbz4wCMc6VksjYXO+TXRunVjjN7wcAyr0JSFjZTwKNsahzTnxgeUt9dfbdQ0GYNFRGuUNIj2rkARZ04bczNkubAZxzlmHB75df9o+LndU9a3hulkXh1OktzKnJMUU3dfmkar+l1QKGogKWwA15egFfYvemK2qF18j/NNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-42306862fc5so19808915ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Sep 2025 00:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757836407; x=1758441207;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aiqRIxpz9AdL8psvEfiBudfnoYD+n/6tWabnQVapIEY=;
        b=oYApsRuRATzhTtEN07WByXVv7q3AFPsOoVL2WjHb5xqEc7EHRVvTpSjA+6+V7Tr/yh
         VU17y6bDsl//YP/rIpPi/wzUy12R+7hfWv7bx38338y0Rmlj6BoQCTwah198Tni81Dc6
         7dNOIXonHSBU4glOtqsmfCwfI5wCrGjKxbHW+e9ZIvg/NrX1oHwCnfwAYxpTdgszjWhW
         5ueLQdBdb+i0PDnjRopq1EHhfZy71hA8GKFbsnZowcrC/qeqASWD+qdqLhJl+AESCyg/
         iBUR5YaX8cGHEvDQeuV7EC7lQAnMAdhe26NtE/MOx1Nj9PrWkZuXDItc8Nkkup/Wv8O6
         wQJg==
X-Forwarded-Encrypted: i=1; AJvYcCUUeV8oXIlEso84WUPkyWP1U/IhtbqLdui53Y0C3MuNUpHxfpXHULNCfGdu5HeXgMyOnNtKX+hWuSOcNKvNtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQdTqOIyDmAYSPQXehAMz0OGVIvkouXnB4LG3crwYMl3zlImg
	SKawr5mgABR9a5auuaLpObZ3CY+57Ck4cklNehOXFgzYKiijdQnLD1CMX6+eR88G+KAKsshSa7U
	W5Au1MOODCulc+G2JCJm5ICifbyn+nOBDqVzh25JLNqFoQthIw/hbT+72RYQ=
X-Google-Smtp-Source: AGHT+IFRyjJOy5CX3Z/PQJ+hrBL0jzi1pt2APVtVz0PTj6gbB4xr+O9pYuS5iAFAkvyFm+jfQHarge2cxcHxPynkqCVDpnkf7Njk
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3801:b0:424:57d:1a5e with SMTP id
 e9e14a558f8ab-424057d1bc0mr499245ab.5.1757836407126; Sun, 14 Sep 2025
 00:53:27 -0700 (PDT)
Date: Sun, 14 Sep 2025 00:53:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c67477.050a0220.2ff435.037f.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in mempool_alloc_noprof (3)
From: syzbot <syzbot+4ebc8d586b68728bcad6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f777d1112ee5 Merge tag 'vfs-6.17-rc6.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1547ad62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7f605fd273c8220
dashboard link: https://syzkaller.appspot.com/bug?extid=4ebc8d586b68728bcad6
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f777d111.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ff082b9d029e/vmlinux-f777d111.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e2c8489f25c3/bzImage-f777d111.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4ebc8d586b68728bcad6@syzkaller.appspotmail.com

bcachefs (loop0): compression opt none set but not marked in superblock, fixing
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: Oops: 0010 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5383 Comm: bch-rebalance/l Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000d49ec18 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff8880532c75a0
RDX: 1ffff1100a658eb4 RSI: 0000000000000000 RDI: 0000000000092800
RBP: ffffc9000d49ed70 R08: ffffc9000d49ece7 R09: 0000000000000000
R10: ffffc9000d49ecc0 R11: 0000000000000000 R12: 1ffff92001a93d94
R13: ffff8880532c75a0 R14: 0000000000092c40 R15: 0000000000092800
FS:  0000000000000000(0000) GS:ffff88808d20c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000400eb000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 mempool_alloc_noprof+0x1a4/0x510 mm/mempool.c:406
 __bio_compress fs/bcachefs/compress.c:461 [inline]
 bch2_bio_compress+0x42f/0x14c0 fs/bcachefs/compress.c:555
 bch2_write_extent fs/bcachefs/io_write.c:1060 [inline]
 __bch2_write+0xfb5/0x3900 fs/bcachefs/io_write.c:1554
 move_write fs/bcachefs/move.c:217 [inline]
 bch2_moving_ctxt_do_pending_writes+0x5a7/0xe60 fs/bcachefs/move.c:248
 bch2_move_ratelimit+0x8e8/0x1330 fs/bcachefs/move.c:585
 do_rebalance fs/bcachefs/rebalance.c:557 [inline]
 bch2_rebalance_thread+0x17b0/0x1f80 fs/bcachefs/rebalance.c:626
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc9000d49ec18 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffff8880532c75a0
RDX: 1ffff1100a658eb4 RSI: 0000000000000000 RDI: 0000000000092800
RBP: ffffc9000d49ed70 R08: ffffc9000d49ece7 R09: 0000000000000000
R10: ffffc9000d49ecc0 R11: 0000000000000000 R12: 1ffff92001a93d94
R13: ffff8880532c75a0 R14: 0000000000092c40 R15: 0000000000092800
FS:  0000000000000000(0000) GS:ffff88808d20c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000000400eb000 CR4: 0000000000352ef0


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
