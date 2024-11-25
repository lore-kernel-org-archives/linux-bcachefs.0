Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442D13D64
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 03:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732504219; cv=none; b=Fuf+ZJGR5n1iT/0a5MyWpKT7AYLdJ+aC2Zh6puC/yTLe+P29LktIiCP0fidh5q8nCojbfLKPRvkNPI5Ca4nlDAXSkukz/5UMvfxiMlQzNoaDo3y9R4usX7HUHssZlzONF8PiirArvBUFrc6JIRT/bxKQHkHw7tKZruTpmq+/W0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732504219; c=relaxed/simple;
	bh=4+3nZIIXqDGw3S2QVYI0sRv/rBgZc2LwTT1cMzInVys=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BDc5QPigTrE8PX56tw5+d5cXhSEluJ2a7dThFLrBuMK/TPF1j4Qu18ISKS8mXJaeeY3waEvLphmxF89NHeRgGIgSZaqiqxBJJ+1hd0tZU6DrthJd5mClClp2bcVz/XMTRNVJ/6uKj1XBbzbpQ6a+KELI4dXlwFMsWrjsDjmFsec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a77fad574cso39588965ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 24 Nov 2024 19:10:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732504217; x=1733109017;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NpWad5H/mNaj6Dxra+7D8HluXrRIfpGx0YWBlDtMUrc=;
        b=FYlARIneezfNelXyI4wvW46KyuO8gI3ZRCVX7+gj7vtq56qtOM9hU++DNjdHA+1Iyp
         1L4D/l6NbS8RmNZa1L4O8mFPo7L6JuqGcPlvnbStiSH2udmP4cy+9UA4rjoYnCqxvSDS
         WsKLjNd2ENy/o3+VzmQXuOMZuGoddFjy/iaBTazUdDubmURMPlqm5O1tZGhiCHi23BHK
         KMvbdOfdz5vTt37hr6MBa2CVLX3ym7QdcXL1mayoK2cp1KIUJ46mwXhQGPXOT9RhRWOK
         3LANcjJCxKH2+Afb/1RGa21Fq+L1iQnuDpQeOoq/3OZ2Z3b6kbrLkEZJNkE2wF6fYkxq
         mC5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWyTOW6BHGVi7oz6H5DneLs1JgGmtIp1XSpOYAQYNP6M4IRP2cKpR7PmSz/YPooRaz2AL5HZrz6S58XL8CHLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsXZ81XSP07opaFj88+KxI1Tv+PsMIe85Lj1llC/z84/ltLGaH
	y+3YMgxnVmtk8NN0utR53aj16T8dU+bEHNQi4xFpLsYrCQU12lTZmNeY+Ni7TNm26KZezD5l2/+
	ZVOGv5bC+RDHzhQCsbMm7EPtk2pBX/ecl4DtxKmtNVXCXA8ovTovGoHo=
X-Google-Smtp-Source: AGHT+IFw6RP/6crq8UoDD03G4DHITpEc+zY4W59hqx35yAXhfObivvyK84+/EZfDNGeBTWYy+6wKSn1cBIxshc4mb+WGUD37qVXR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144b:b0:3a0:8c5f:90c0 with SMTP id
 e9e14a558f8ab-3a79ad27289mr132437815ab.10.1732504217559; Sun, 24 Nov 2024
 19:10:17 -0800 (PST)
Date: Sun, 24 Nov 2024 19:10:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6743ea99.050a0220.1cc393.0057.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_journal_pin_put
From: syzbot <syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f7c8b88bda4 Merge tag 'sched_ext-for-6.13' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=116f1930580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=48190c1cdf985419
dashboard link: https://syzkaller.appspot.com/bug?extid=73ed43fbe826227bd4e0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-8f7c8b88.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5e6fdef85e9/vmlinux-8f7c8b88.xz
kernel image: https://storage.googleapis.com/syzbot-assets/67596a080582/bzImage-8f7c8b88.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+73ed43fbe826227bd4e0@syzkaller.appspotmail.com

Bluetooth: hci0: command tx timeout
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_reclaim.h:30!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5345 Comm: kworker/u5:3 Not tainted 6.12.0-syzkaller-01892-g8f7c8b88bda4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_journal journal_write_work
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:__bch2_journal_pin_put+0x121/0x130 fs/bcachefs/journal_reclaim.c:327
Code: 62 53 fd 31 ff 89 de e8 6d 62 53 fd 89 d8 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 58 5f 53 fd 90 0f 0b e8 50 5f 53 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d2efa10 EFLAGS: 00010293
RAX: ffffffff84417ee0 RBX: 0000000000000000 RCX: ffff888000de8000
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffffc9000d2efb78 R08: ffffffff84417e41 R09: ffffffff843ef148
R10: 0000000000000004 R11: ffff888000de8000 R12: dffffc0000000000
R13: ffff888052e4a500 R14: ffffffffffffffff R15: ffff888052e4a500
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055edf841c118 CR3: 000000004316a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_buf_put_final fs/bcachefs/journal.c:217 [inline]
 __bch2_journal_buf_put fs/bcachefs/journal.h:276 [inline]
 __journal_entry_close+0x80a/0xe30 fs/bcachefs/journal.c:301
 journal_write_work+0x129/0x140 fs/bcachefs/journal.c:487
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:__bch2_journal_pin_put+0x121/0x130 fs/bcachefs/journal_reclaim.c:327
Code: 62 53 fd 31 ff 89 de e8 6d 62 53 fd 89 d8 5b 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc e8 58 5f 53 fd 90 0f 0b e8 50 5f 53 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d2efa10 EFLAGS: 00010293
RAX: ffffffff84417ee0 RBX: 0000000000000000 RCX: ffff888000de8000
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffffc9000d2efb78 R08: ffffffff84417e41 R09: ffffffff843ef148
R10: 0000000000000004 R11: ffff888000de8000 R12: dffffc0000000000
R13: ffff888052e4a500 R14: ffffffffffffffff R15: ffff888052e4a500
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055edf841c118 CR3: 000000004316a000 CR4: 0000000000352ef0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
