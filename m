Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3590220F089
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 16:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749833670; cv=none; b=EvlwjNaoQpbTS2CECOvREbmPTht50W8vUddv1RW75lRba+O5ccwMyFeZGCi7cJLeIRwK+M5gUpyALoFIIv223Ktu3MekO9BdSpaJRI9xwui1JwMKWvtGM4YVT1p7NEEsBF8yRdXYD32laJQxZs2TFiE4RLr+6Rp+C+toRgHqjsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749833670; c=relaxed/simple;
	bh=wUBuTIsXAaDgkjOn+r8DyPVWv9/PVxI/2co0S04l0Ag=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gfB/7FRweQg+xWwaLFTfB8oEcUym1TBeH25fQIi/FmfvBZxu4Phr4BFHeW3RslMorZZb8d6WQzwNZQeSNJoLz/C3/GzhhykYjJF05mNsn5HvY4ZA3Bs4aVF3t2udHdX85QdkFUMOxVmj5riB/eLDbQDFy1THNoKSwgcVn+P4PIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddd045bb28so20187745ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 09:54:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749833668; x=1750438468;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oMitTXoM0deEPmd1WdTX6JBKI3yWblNEZYBKho7BJPs=;
        b=hTT6+bEOnIJF6HQ17NeCa2g6nTgN5PseBdfAuRKdaL90r/5DblC5hBpTNswqDy3VaM
         1S6veDnEyvgutyd6oDl4QhDZlZWm5rkLj2+i2ILKea9KGMxLEDahBz8BlXS/jwDg7Q4k
         sl/S37goz57ExEeA3K2BqZ18YxnsxYKG4jE5iY02MtNgCiGp8vfcyLoU47iUI2t+DmC3
         Ivw7UmXDuOHKFub+qHanX/rJPwWnTaNFNI6byoeP6u84fAX50dqQTkZqGMk7U6Pj2Llt
         mGzHFSFayqjMSGTuNwWm1ONR7YyRMIG0aUGj1J4aj5SbV2FDS6v9lH/9FaU5ZTdYvUdo
         Ss9g==
X-Forwarded-Encrypted: i=1; AJvYcCWko8RDUExKIkr/SbWOVN7zlt25fePfNNgkApRwkRTaqdhmXJAI1v435Xf8+RW0kb0Thkuxb+Has2mHt2NxVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzxdOSCDQtSPzHYV+leCK+uUQSo1sXPmW5mFgraVHxrKAoXqkqD
	QWhMcYdExGag2qygJcTM1CbTY1Cpv1ROVnBHDtt+jMqiJg4BRS7ezM7l9o1eRrxMXmPsu26yoeX
	i3KmEJU8J4KOBlUeSTafIQZVj9z7ZQ0r3D+JH1iOIY9Tm+mOA2z6UPPhaV0A=
X-Google-Smtp-Source: AGHT+IEDGCfF+qfaOHvHvI9UWUSbqMj5Z43PgfC3Tj9dL5Q6oETeOAEPuW1wvhBTL0vWsgkpDjgQQFK7J1A6G9OQnwUDDmNPCphZ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3a03:b0:3dc:76ad:7990 with SMTP id
 e9e14a558f8ab-3de07cd0417mr5262125ab.15.1749833668310; Fri, 13 Jun 2025
 09:54:28 -0700 (PDT)
Date: Fri, 13 Jun 2025 09:54:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684c57c4.a00a0220.279073.0015.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_bkey_compat
From: syzbot <syzbot+4908f37148402680dfec@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    27605c8c0f69 Merge tag 'net-6.16-rc2' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17749d70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=162faeb2d1eaefb4
dashboard link: https://syzkaller.appspot.com/bug?extid=4908f37148402680dfec
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10f9f682580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ecb9d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8f486f1f2af2/disk-27605c8c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/774310efd683/vmlinux-27605c8c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/861612fbccfb/bzImage-27605c8c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1659e3de16d4/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4908f37148402680dfec@syzkaller.appspotmail.com

bcachefs (loop0): sb invalid before write: Unsupported superblock version_min 0.0: (unknown version) (min 0.9: (unknown version), max 1.28: inode_has_case_insensitive)
  emergency read only at seq 10
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey_methods.c:469!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5832 Comm: read_btree_node Not tainted 6.16.0-rc1-syzkaller-00101-g27605c8c0f69 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:__bch2_bkey_compat+0xbbf/0xbd0 fs/bcachefs/bkey_methods.c:469
Code: fd 90 0f 0b e8 82 2c a7 fd 90 0f 0b e8 7a 2c a7 fd 90 0f 0b e8 72 2c a7 fd 90 0f 0b e8 6a 2c a7 fd 90 0f 0b e8 62 2c a7 fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc9000438ea40 EFLAGS: 00010293
RAX: ffffffff8419218e RBX: ffff88802fc508c0 RCX: ffff888031661e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0900000000000000
RBP: ffffc9000438ece8 R08: 0000000020000000 R09: 0000000020000000
R10: ffffffff00000000 R11: 34b6b456b49c471e R12: 00000000ffffffff
R13: 0000000000000003 R14: 0000000000000001 R15: 00000000ffffffff
FS:  0000000000000000(0000) GS:ffff888125d86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd66213388 CR3: 000000002f80a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bkey_compat fs/bcachefs/bkey_methods.h:134 [inline]
 validate_bset_keys+0x5b7/0x1480 fs/bcachefs/btree_io.c:983
 bch2_btree_node_read_done+0x1d3c/0x5150 fs/bcachefs/btree_io.c:1211
 btree_node_read_work+0x426/0xe30 fs/bcachefs/btree_io.c:1399
 bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
 bch2_btree_node_fill+0xd12/0x14f0 fs/bcachefs/btree_cache.c:994
 bch2_btree_node_get_noiter+0xa2c/0x1000 fs/bcachefs/btree_cache.c:1261
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:220 [inline]
 read_btree_nodes_worker+0x1319/0x1e20 fs/bcachefs/btree_node_scan.c:269
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_bkey_compat+0xbbf/0xbd0 fs/bcachefs/bkey_methods.c:469
Code: fd 90 0f 0b e8 82 2c a7 fd 90 0f 0b e8 7a 2c a7 fd 90 0f 0b e8 72 2c a7 fd 90 0f 0b e8 6a 2c a7 fd 90 0f 0b e8 62 2c a7 fd 90 <0f> 0b cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc9000438ea40 EFLAGS: 00010293
RAX: ffffffff8419218e RBX: ffff88802fc508c0 RCX: ffff888031661e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0900000000000000
RBP: ffffc9000438ece8 R08: 0000000020000000 R09: 0000000020000000
R10: ffffffff00000000 R11: 34b6b456b49c471e R12: 00000000ffffffff
R13: 0000000000000003 R14: 0000000000000001 R15: 00000000ffffffff
FS:  0000000000000000(0000) GS:ffff888125d86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd66213388 CR3: 000000002f80a000 CR4: 00000000003526f0
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
