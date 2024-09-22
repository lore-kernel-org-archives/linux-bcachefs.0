Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DC92139D
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 13:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727013509; cv=none; b=J3u7946A1y8hB2PBTjrosgQflIr+513WoSVxymiNY4pCjchxCWwWk93te6RciXCNL9JwYs11JteRs2prhYfwMHU5DDZcjr7/83XXvUZBOSN14hT08KoJ8z38Q5bqg4/+aqX9NgooNK3e7HWtbHcj7dutcCdLb4zUvfJxZU5O6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727013509; c=relaxed/simple;
	bh=gNw89nA/C05OLVy7A5XYqdZYsCLRKm08zgGKSlWDEFY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hiKuYg3oRLmPSm3fRdhrHliSA/GzZPIQIznrQ0uc93vW/Hcs2K9FlAFoJe2SS3nYAZNm2pK9LigBptGVVbnE2tjyEes7gbGjPPVlnDODiO+r6x06FTz/e1KvQrLunSR+wL0K3U6ImMLmAc/FZ5saIQ3dLTky/DCkBjgTIfGUoKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39f5605c674so55831655ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 06:58:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727013506; x=1727618306;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WuJBNqJzJ4KYbZNBr4rG9AefrRgvoDIAkWkxFCRgscs=;
        b=aXFP41c8OHWIA4wqzMBaXNQZeN/N/TGSYDcrA12T1Cd8h3lc5yoUgoyyZ6OCq9Ct7X
         wgH2RF0nSyrOHiXOxkLH3KXcKBjcTZakoFcEIL3v6Ja75vzsnT69CFl6bggTYIkxcpr9
         j/Kaqd8He9/0+H1nMB0kgXY4M6E2AKYjGJ31J2J91aGEJr+pE/2Xwxo2L5A+Eici6vgE
         IX3NrnuCCKy+ZUmr2nzu1DmnTU1SjDJoAXDuF/sirRWUS1M94CVjso+yHmYiJsZxd5h9
         iD0dS0jYCUWIYJepT/exnIFUbONT/VZVCQiL+64g0uMfskgBl34PWeYZvvI39DmTTGdp
         G4NQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZzRtMu+Qs6hDsolq/gmtffWxSb/ExX4f6fs6XtwmH0mKUCvVReTPlL6Jn6o8XNLsBmIvPCZ28ygGKhKZ56Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4odBVym1DmxkO8vsy6KuGuVXQ4sCm8aOSKF3opGVyVZud6ipP
	W8N3lDkMwTm4KQWAYIQQugz2CEz28xUADeRAP/TjTs2WoVaKTrz0vUhSf28mFUfCEjipjWnH4os
	LP+839fpAPQ3NKMhiIoH8ATWNrKex3QgoSHEuvlPjP1o9mDijgj0819Q=
X-Google-Smtp-Source: AGHT+IGkTugyPV0KXwzkDmwsGN9IdJKGnO04XwTk0ZJrdTmcYTrgv92sgf/HHn4Anq2OABs/IPstmqbx1PZoxcjf3npeTegmxHCu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a69:b0:3a0:978b:e6b with SMTP id
 e9e14a558f8ab-3a0c8d38877mr73819865ab.21.1727013506654; Sun, 22 Sep 2024
 06:58:26 -0700 (PDT)
Date: Sun, 22 Sep 2024 06:58:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f02282.050a0220.1b7b75.0003.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_quota_check_limit
From: syzbot <syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4a39ac5b7d62 Merge tag 'random-6.12-rc1-for-linus' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1645db00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd14c10ec1b6af25
dashboard link: https://syzkaller.appspot.com/bug?extid=8364d1e040a88ed5657d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-4a39ac5b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e77a3b8ac098/vmlinux-4a39ac5b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8ee7a5fea46/bzImage-4a39ac5b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8364d1e040a88ed5657d@syzkaller.appspotmail.com

  fragmentation     0
  bp_start          8
  invalid data type (got 2 should be 7): delete?, fixing
bcachefs (loop0): flagging btree snapshots lost data
error reading btree root snapshots l=0: btree_node_read_error, fixing
bcachefs (loop0): will run btree node scan
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  extents l=0 seq=1 journal_seq=4 cookie=b77ad9ee5a61c7f0 POS_MIN-SPOS_MAX ptr: 0:27:0 gen 0
  xattrs l=0 seq=1 journal_seq=4 cookie=1477538288e6fe55 POS_MIN-SPOS_MAX ptr: 0:31:0 gen 0
  lru l=0 seq=1 journal_seq=8796093022212 cookie=d19419031ca39bdb POS_MIN-SPOS_MAX ptr: 0:28:0 gen 0
  deleted_inodes l=0 seq=1 journal_seq=0 cookie=a34c10fbe2d33ffa POS_MIN-SPOS_MAX ptr: 0:42:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root snapshots unreadable, must recover from scan
no nodes found for btree snapshots, continuing
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read...
bcachefs (loop0): running explicit recovery pass reconstruct_snapshots (20), currently at snapshots_read (6)
 done
bcachefs (loop0): check_allocations...
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 75277f57b0c8c24 written 32 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 19bc58a6c09b6540 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c18f4a4face03c6 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7675f41d391e5d36 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9a831b4a3f983356 written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:32 gen 0 has wrong data_type: got btree, should be need_discard, fixing
bucket 0:32 gen 0 data type need_discard has wrong dirty_sectors: got 256, should be 0, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): reconstruct_snapshots...
snapshot node 4294967295 from tree 4294967295 missing, recreating
 done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): reading quotas
bcachefs (loop0): quotas done
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
kernel BUG at fs/bcachefs/quota.c:232!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5114 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-05319-g4a39ac5b7d62 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_quota_check_limit+0xd48/0xd70 fs/bcachefs/quota.c:232
Code: de e8 ac 96 b0 00 e9 9b fa ff ff e8 12 df 55 fd 48 c7 c7 50 30 f6 8e 48 89 de e8 93 96 b0 00 e9 d8 fa ff ff e8 f9 de 55 fd 90 <0f> 0b e8 f1 de 55 fd 90 0f 0b e8 e9 de 55 fd 90 0f 0b e8 e1 de 55
RSP: 0018:ffffc9000316f370 EFLAGS: 00010283
RAX: ffffffff843e0007 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc900031b1000 RSI: 0000000000032dc1 RDI: 0000000000032dc2
RBP: fffffffffffffff8 R08: ffffffff843df34f R09: fffffffffffffff8
R10: dffffc0000000000 R11: fffffbfff2037f36 R12: ffff88803b985000
R13: 0000000000000000 R14: fffffffffffffff8 R15: ffffc9000316f4a0
FS:  00007f74ca8fb6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055611ee8b958 CR3: 0000000035cea000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_quota_acct+0x3f9/0x750 fs/bcachefs/quota.c:299
 bch2_i_sectors_acct fs/bcachefs/fs-io.h:138 [inline]
 bchfs_truncate+0x984/0xc70 fs/bcachefs/fs-io.c:484
 notify_change+0xbca/0xe90 fs/attr.c:503
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3395 [inline]
 do_open fs/namei.c:3778 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_creat fs/open.c:1506 [inline]
 __se_sys_creat fs/open.c:1500 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1500
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f74c9b7def9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f74ca8fb038 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007f74c9d35f80 RCX: 00007f74c9b7def9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020001180
RBP: 00007f74c9bf0b76 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f74c9d35f80 R15: 00007fffa9737808
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_quota_check_limit+0xd48/0xd70 fs/bcachefs/quota.c:232
Code: de e8 ac 96 b0 00 e9 9b fa ff ff e8 12 df 55 fd 48 c7 c7 50 30 f6 8e 48 89 de e8 93 96 b0 00 e9 d8 fa ff ff e8 f9 de 55 fd 90 <0f> 0b e8 f1 de 55 fd 90 0f 0b e8 e9 de 55 fd 90 0f 0b e8 e1 de 55
RSP: 0018:ffffc9000316f370 EFLAGS: 00010283
RAX: ffffffff843e0007 RBX: 0000000000000000 RCX: 0000000000040000
RDX: ffffc900031b1000 RSI: 0000000000032dc1 RDI: 0000000000032dc2
RBP: fffffffffffffff8 R08: ffffffff843df34f R09: fffffffffffffff8
R10: dffffc0000000000 R11: fffffbfff2037f36 R12: ffff88803b985000
R13: 0000000000000000 R14: fffffffffffffff8 R15: ffffc9000316f4a0
FS:  00007f74ca8fb6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb45c78c96e CR3: 0000000035cea000 CR4: 0000000000350ef0
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
