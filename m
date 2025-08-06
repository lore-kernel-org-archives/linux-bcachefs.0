Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCE8215F42
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Aug 2025 07:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754464232; cv=none; b=C8ZQ3yLRNWjc0WnQOnP1MlgRCajsgyHYig1nV39V4poXI3RcKPMQoVGhV1uamHxKlo7pw6ctH7icQkt/obFmp55sH83n+swiLWHoHxfDKBcZqFiRBvGywa1FeHjk/tNgEfL8TTdEh1p2FZpSNiR3ZxE+2FFoiJ2N2lYuyTxspfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754464232; c=relaxed/simple;
	bh=yUXp9RbYYMvAi4aYBqaN/Y2uH8tUrWetLfNJUkte98I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q4lsBEbzvqkGBgQedpgDjdLZx8P/o518VDwAaQ/+6ahrE2uj9N5Cxmnj+8dPITNWvSRYGL1VDEqpchRvI34EiimkII3USelqutrhHVesBeR4L4ROzOwLXYecAB4kNTtP2P/HijXRPvWVqikP7FrFbMcOvF+uPTiVT6CQgfCR0TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88177d82b26so675487039f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Aug 2025 00:10:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754464230; x=1755069030;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kin3gMriSKVRww+UkHVI/MEOxcjSahtIRjKoHJ1LHvk=;
        b=fdITpd4LlDQeXIavc5GybBhUavonihSy7k+/Qpbei65n/z7iQVnHqpZNXwRPIdNSYJ
         QBvq0hmx/6sotVqGqhvdfQBdHiPGW5pd1yUHg6AoQO6dVMaUHzFIhxbnxgAe5uErwv+G
         dCpjd9wmfQmJzoAGGEmDJJklwWjB35djia6a8hC4k+nXbmQ8Y50ZMxh+Jv+mN48MyLGS
         B0QLHL6jDrbDGeWEYk5rXSPGqxRwuYJSIALPbEau1abKnx4ApfJWn2kl8JUOy2iORb8Y
         kuVP6xB5j/xiYcrT9yh3iWhbDIGKkIQiprMn8C5SE/rk/f1aiwaDgmtgdLiDPEnPGnn3
         tftg==
X-Forwarded-Encrypted: i=1; AJvYcCVfGPaQL7zZiBP6F7Ur61ffJg/1IAc/sW1Yw+YLybhO/zERerro9i5gBW4o+6iIfh7pClr/KOpCwYCS4txjTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5qUo4/IwPzsR0EDmksBtr6VZa+A2lds5HxCTPeYYwWMfgzriA
	vq5nO2rkUdNjlCIT//iwB1ufyPSxlu4v2T79ZRpx7jOBW2fbkXflj+GUSkb1q7SYs9djZ+OXOI8
	pJDAKBQQew5TQRfipDAlHSL1d+ZILow9l7Gc+7EVJq1TpR87LfvzplQibkQQ=
X-Google-Smtp-Source: AGHT+IGiY0SG7lUZ/g8z97ZDwF7VuX62DwfUi8lBBh+9ImWnlvov1U8Yb42fl7nP9zVvVvJmAesNffh8P85xucWrQAaZnPQitBSD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fd3:b0:881:9412:c917 with SMTP id
 ca18e2360f4ac-8819eda4411mr386020939f.0.1754464230257; Wed, 06 Aug 2025
 00:10:30 -0700 (PDT)
Date: Wed, 06 Aug 2025 00:10:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6892ffe6.050a0220.7f033.0039.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_pin_set (2)
From: syzbot <syzbot+240906f6485cdb6035a7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a6923c06a3b2 Merge tag 'bpf-fixes' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128df2a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bbdefbf39cb79f7e
dashboard link: https://syzkaller.appspot.com/bug?extid=240906f6485cdb6035a7
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-a6923c06.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c2b6f269429/vmlinux-a6923c06.xz
kernel image: https://storage.googleapis.com/syzbot-assets/32390e35232b/bzImage-a6923c06.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+240906f6485cdb6035a7@syzkaller.appspotmail.com

bcachefs (loop0): backpointer doesn't match extent it points to:
  u64s 9 type backpointer 0:8921088:0 len 0 ver 0: bucket=0:34:8 btree=extents level=0 data_type=user suboffset=0 len=8 gen=0 pos=536870913:24:U32_MAX
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 1 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 0:34:8 gen 0
  u64s 9 type backpointer 0:8921088:0 len 0 ver 0: bucket=0:34:8 btree=extents level=0 data_type=user suboffset=0 len=8 gen=0 pos=536870913:24:U32_MAX, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_reclaim.c:483!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5362 Comm: bch-copygc/loop Not tainted 6.16.0-syzkaller-11105-ga6923c06a3b2 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_journal_pin_set+0x5c1/0x5e0 fs/bcachefs/journal_reclaim.c:483
Code: 25 3d d8 fd e9 0c ff ff ff 44 89 e9 80 e1 07 38 c1 0f 8c 88 fb ff ff 4c 89 ef e8 fa 3d d8 fd e9 7b fb ff ff e8 e0 6b 73 fd 90 <0f> 0b e8 d8 6b 73 fd 90 0f 0b e8 d0 6b 73 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc9000d4ae728 EFLAGS: 00010293
RAX: ffffffff844c42c0 RBX: 000000000000000c RCX: ffff88801fb60000
RDX: 0000000000000000 RSI: 000000000000000c RDI: 000000000000000b
RBP: ffff888052e846b8 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52001a95cd4 R12: ffff888052ecaa38
R13: ffff888052eca898 R14: ffff888052ec9800 R15: 000000000000000b
FS:  0000000000000000(0000) GS:ffff88808d21f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff022fdc9c CR3: 0000000011ba9000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_journal_pin_add fs/bcachefs/journal_reclaim.h:48 [inline]
 bch2_journal_keys_to_write_buffer_start+0x3bb/0x3c0 fs/bcachefs/btree_write_buffer.c:793
 bch2_journal_keys_to_write_buffer fs/bcachefs/btree_write_buffer.c:510 [inline]
 fetch_wb_keys_from_journal fs/bcachefs/btree_write_buffer.c:534 [inline]
 btree_write_buffer_flush_seq+0x222/0x1a40 fs/bcachefs/btree_write_buffer.c:563
 bch2_btree_write_buffer_flush_sync+0x143/0x2c0 fs/bcachefs/btree_write_buffer.c:598
 bch2_btree_write_buffer_maybe_flush+0x7e0/0x1400 fs/bcachefs/btree_write_buffer.c:673
 bch2_backpointers_maybe_flush fs/bcachefs/backpointers.c:200 [inline]
 backpointer_target_not_found+0x110/0xc10 fs/bcachefs/backpointers.c:220
 __bch2_backpointer_get_key+0x33a/0x490 fs/bcachefs/backpointers.c:352
 bch2_backpointer_get_key+0x3e/0x60 fs/bcachefs/backpointers.c:379
 __bch2_move_data_phys+0xf82/0x1c50 fs/bcachefs/move.c:942
 bch2_evacuate_bucket+0x228/0x3a0 fs/bcachefs/move.c:1082
 bch2_copygc+0x3be3/0x4510 fs/bcachefs/movinggc.c:234
 bch2_copygc_thread+0x97a/0xe00 fs/bcachefs/movinggc.c:409
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_journal_pin_set+0x5c1/0x5e0 fs/bcachefs/journal_reclaim.c:483
Code: 25 3d d8 fd e9 0c ff ff ff 44 89 e9 80 e1 07 38 c1 0f 8c 88 fb ff ff 4c 89 ef e8 fa 3d d8 fd e9 7b fb ff ff e8 e0 6b 73 fd 90 <0f> 0b e8 d8 6b 73 fd 90 0f 0b e8 d0 6b 73 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc9000d4ae728 EFLAGS: 00010293
RAX: ffffffff844c42c0 RBX: 000000000000000c RCX: ffff88801fb60000
RDX: 0000000000000000 RSI: 000000000000000c RDI: 000000000000000b
RBP: ffff888052e846b8 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52001a95cd4 R12: ffff888052ecaa38
R13: ffff888052eca898 R14: ffff888052ec9800 R15: 000000000000000b
FS:  0000000000000000(0000) GS:ffff88808d21f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff022fdc9c CR3: 0000000011ba9000 CR4: 0000000000352ef0


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
