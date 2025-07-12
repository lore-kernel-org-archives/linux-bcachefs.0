Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBF32FB2
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Jul 2025 08:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752309152; cv=none; b=Xe/OyqMsFVR11kE3wFQi7sfEcpEvJbI1E8G39iTGlmp+jW6upAmYUuIpviPyllYYU2TryyLWpAv311QuPy/S+AlRnT0vZnlgO3LDsLDG4oailJVyMgewIzWYXtxsKISWdIbQi8Lsd9mDsFIYuhoFDj5xkmm2bSYUnIRchMgaIrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752309152; c=relaxed/simple;
	bh=1BMrpmFdHjxYvBZWRHiWBAs19iXWAZqA4RwsPBGRGbQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ilGHmdnspIJwzwVQtjTIRpUo9vagP+v8f9H+aezJEGI5be5iSOcs91rWPMPZK190zJ9Icq7PBbrj08ZFXYokxR0nu2AvBsiG6b/aCCLnbVuscH4LCJBnkOZOM2zYMJfzh0Ti5R5LIniuSZ1FZdH+TV9Fg2TJA5mnUV6Wa33J6tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-873fd6e896bso291828539f.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 12 Jul 2025 01:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752309150; x=1752913950;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PK7o6tuhLHNmuXB47Vn/hafZzoY6Fbu0p9VJnGIhps8=;
        b=VsIqT5yOiaUSYgB1pi5I5HGy/UrINakGalpoxeF8NUfOBGGRcaoz+D6PXYZfWnegzv
         6wI83M2zUwE5pQlJOokEL/VUFPU8OX+Ac0i6C+xMUYZtcliW6lebvadJ6jzBxEkm7/8s
         nNho+A1M+wIdzMUWaeofTD0EHlcUeUB083oAKAt77K7k0mYw8nb9P4Oz3M0HoPiKX9Gb
         TwRmZ09jJ63PGxqVZlRY+UFIq0lOGhXMiv8Rw7Oeo2e/tnt52QKGxMXn5mhqzEOvPywn
         0uv7u287xKEADje7Bxh83SCTds/EWv+xQwhCNnqIEt/Lza+aR82bJQMczWdHYTSB1y2v
         MRSA==
X-Forwarded-Encrypted: i=1; AJvYcCU4sLNYNgodTondUo4Q1RPb6iexc3/2boDmSdjU6vvSoT04WZYZmnfN8OBLSaQIcB0kiynhh13pM6dfHmzMFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwR+H9hhxyP9Hyp/7UPszQe3AujJtMZYzfeeVvpkby1nH5CW2bj
	V2rnTGERHjkUuvPQs9tEwnE+CsNtM+ymbr9kpZZ/rq2clbT4DN23Bpxln1A837Ou4Beu4OGg6lq
	H28GREi7leVxId0zsZzonJ5R3vWDh6o35ih8vu4Xym6eerfCmTQ7wbPOeg08=
X-Google-Smtp-Source: AGHT+IEXUwwoKihv5Fd8i79lfBREs3VbRueyY8mj/8AsS79tesQlhjpw2cG8LGKYrvKXtPvP06ZuH2ZZEYbFqytgsOI4yTLkppR2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:378e:b0:879:66fe:8d1e with SMTP id
 ca18e2360f4ac-87977f940fcmr772348839f.8.1752309150227; Sat, 12 Jul 2025
 01:32:30 -0700 (PDT)
Date: Sat, 12 Jul 2025 01:32:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68721d9e.a00a0220.26a83e.0074.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_trans_commit (3)
From: syzbot <syzbot+b6ef9edaba01d5b4e43f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    40f92e79b0aa Merge tag 'block-6.16-20250710' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169a7bd4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b309c907eaab29da
dashboard link: https://syzkaller.appspot.com/bug?extid=b6ef9edaba01d5b4e43f
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-40f92e79.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8022f6fa9a48/vmlinux-40f92e79.xz
kernel image: https://storage.googleapis.com/syzbot-assets/565fa9fa3299/bzImage-40f92e79.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b6ef9edaba01d5b4e43f@syzkaller.appspotmail.com

bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bcachefs (loop0): bucket 0:35 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
bcachefs (loop0): btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bcachefs (loop0): bucket 0:29 data type btree ptr gen 0 missing in alloc btree
  while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bcachefs (loop0): bucket 0:1 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:1 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:2 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:2 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:3 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:3 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:4 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:4 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:5 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:5 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:6 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:6 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:7 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:7 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:8 gen 0 has wrong data_type: got free, should be sb, fixing
bcachefs (loop0): bucket 0:8 gen 0 data type sb has wrong dirty_sectors: got 0, should be 8, fixing
bcachefs (loop0): bucket 0:9 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:9 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:10 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): bucket 0:10 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): bucket 0:11 gen 0 has wrong data_type: got free, should be journal, fixing
  Ratelimiting new instances of previous error
bcachefs (loop0): bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
  Ratelimiting new instances of previous error
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): check_extents_to_backpointers...
bcachefs (loop0): scanning for missing backpointers in 4/128 buckets
 done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_trans_commit.c:348!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5344 Comm: syz.0.0 Not tainted 6.16.0-rc5-syzkaller-00193-g40f92e79b0aa #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:btree_insert_entry_checks fs/bcachefs/btree_trans_commit.c:343 [inline]
RIP: 0010:bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:725 [inline]
RIP: 0010:do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:854 [inline]
RIP: 0010:__bch2_trans_commit+0x86e5/0x8870 fs/bcachefs/btree_trans_commit.c:1085
Code: 97 fd eb 0c e8 2c 78 97 fd eb 05 e8 25 78 97 fd 49 bd 00 00 00 00 00 fc ff df 4c 8b 64 24 48 e9 e1 af ff ff e8 0c 78 97 fd 90 <0f> 0b e8 04 78 97 fd 90 0f 0b e8 fc 77 97 fd 90 0f 0b e8 f4 77 97
RSP: 0018:ffffc9000d357780 EFLAGS: 00010287
RAX: ffffffff8428be64 RBX: ffffffff84288035 RCX: 0000000000100000
RDX: ffffc9000df42000 RSI: 0000000000004ab7 RDI: 0000000000004ab8
RBP: ffffc9000d357a70 R08: 0000000000000000 R09: ffffffff84288035
R10: dffffc0000000000 R11: ffffed100a6a9309 R12: ffff8880525b4020
R13: dffffc0000000000 R14: ffff8880525b64d8 R15: 0000000000000001
FS:  00007fe567cac6c0(0000) GS:ffff88808d21b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f10bffd2000 CR3: 000000003f923000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_trans_commit fs/bcachefs/btree_update.h:241 [inline]
 __bch2_unlink+0x2b9/0x530 fs/bcachefs/fs.c:827
 bch2_unlink+0xb1/0xf0 fs/bcachefs/fs.c:864
 vfs_unlink+0x391/0x650 fs/namei.c:4595
 do_unlinkat+0x350/0x560 fs/namei.c:4659
 __do_sys_unlink fs/namei.c:4705 [inline]
 __se_sys_unlink fs/namei.c:4703 [inline]
 __x64_sys_unlink+0x47/0x50 fs/namei.c:4703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe566d8e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe567cac038 EFLAGS: 00000246 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 00007fe566fb5fa0 RCX: 00007fe566d8e929
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000180
RBP: 00007fe566e10b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fe566fb5fa0 R15: 00007fff2f8fbd98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btree_insert_entry_checks fs/bcachefs/btree_trans_commit.c:343 [inline]
RIP: 0010:bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:725 [inline]
RIP: 0010:do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:854 [inline]
RIP: 0010:__bch2_trans_commit+0x86e5/0x8870 fs/bcachefs/btree_trans_commit.c:1085
Code: 97 fd eb 0c e8 2c 78 97 fd eb 05 e8 25 78 97 fd 49 bd 00 00 00 00 00 fc ff df 4c 8b 64 24 48 e9 e1 af ff ff e8 0c 78 97 fd 90 <0f> 0b e8 04 78 97 fd 90 0f 0b e8 fc 77 97 fd 90 0f 0b e8 f4 77 97
RSP: 0018:ffffc9000d357780 EFLAGS: 00010287
RAX: ffffffff8428be64 RBX: ffffffff84288035 RCX: 0000000000100000
RDX: ffffc9000df42000 RSI: 0000000000004ab7 RDI: 0000000000004ab8
RBP: ffffc9000d357a70 R08: 0000000000000000 R09: ffffffff84288035
R10: dffffc0000000000 R11: ffffed100a6a9309 R12: ffff8880525b4020
R13: dffffc0000000000 R14: ffff8880525b64d8 R15: 0000000000000001
FS:  00007fe567cac6c0(0000) GS:ffff88808d21b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe567c8afc8 CR3: 000000003f923000 CR4: 0000000000352ef0


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
