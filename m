Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED19183CB7
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Sep 2024 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726688728; cv=none; b=fm5gpzi/sSGPaP9VF0PXaucKpggCwULrZW0K6LGcarj/8E7s6V1e3YTUqgyPSER5i9LrNQUTIc8qGeJIh8/itEHn371ZTAV7RG7Mk3TIhf09eAwowxwyeyqWnW4Qe3t2EyDhBbekpVhY2OFfVgvFE621eIejFAAUrc/8afDyH20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726688728; c=relaxed/simple;
	bh=JH2vOBvqP1WsdIh9DtyuF3Ty2EX2W0wYCQ2LzlcI+wo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VVdznZAybU/cFqKwnhvl2jCqrpajHWiXk/qQngkhgwbk0/7WVRqTFiEWqIkprdeUJ/3W9X2vXRra0YTRTEIxZmMXTt1XvV9u8QlpWIoUNlfDwWy49DWPhLEz3jYIhKZvtGAUaW9KeXVajNsB3oBa2Mp0zF0HsiCXsMl6UYzUjwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82cdc7b7debso20134239f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Sep 2024 12:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726688726; x=1727293526;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AQnlHrptjrWkVkkalZYgwhAgBgJz42Fb0d2d0bHxQCY=;
        b=m0kMRrC88hOd1dbcZGzw9SGXNnfrq+to/vzs50yfGvv3+wZgyH9bNCktCvtSfULmZf
         AZK7im8nJIEgxLJ04l0Qedsz/s0N3PQumB4H6ObghUaep8TF6I8MCVfuPI6Nqmf7t1C5
         KWFhG3KEH7wSQ6ARk4GvyyJFJOeUFqs81d2AdG472pA5sLwyMEgVwcTniuC/hJOcFxdu
         QSgg0zLqfiGnOZDQdchUXdrxYKWFR4dmwMnMYeZxRIRUh3LcQrTOKZK/4nneMiu18Otg
         nRPH9tuzxMbwopLRb87GaOiAjXVSpEbxG7JnUis5ljSGZRoWqmRtILkx73vNnlsQVS9I
         4EKQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMg0HaQ31ArlVRBWmqU/CS039ALvS7lp3mlGMtdgoP8t9ne5YqgK+lBrYF+UjiR1VM5M247FteGdyTpJqU0w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaVkayfWWKNgc5qRCbD0U9DKYO6YRcZ2ixX3ChPkKrQwkf2Y1y
	CJEyQ79+JlIJfF3jxovv2LeGEyF0Tp4rQjv5voXOqVploRBt/PcoISnznrd44ji4Qi9q8SlZnAX
	xX3mHHsb8+wbA2csC3tyjZmJ3LdvD2rvhXMZFuVHcuqfojXX9htnqPe0=
X-Google-Smtp-Source: AGHT+IFbd+UA0UJQlV6HSI+ogPBAJajNXak+qjxq0A3e6wiTIWcOdDLCPj8JEd+LSS/0uVDW4PXZ5NuJTeZpy28emhJ5vsDLfYph
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cb:b0:3a0:9159:1561 with SMTP id
 e9e14a558f8ab-3a0915919b7mr153355635ab.2.1726688726171; Wed, 18 Sep 2024
 12:45:26 -0700 (PDT)
Date: Wed, 18 Sep 2024 12:45:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029575106226a0c43@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_lru_check_set
From: syzbot <syzbot+6e8c3cce21d276c02502@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b7718454f937 Merge tag 'pci-v6.11-fixes-4' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=141de7c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=6e8c3cce21d276c02502
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-b7718454.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e16311930277/vmlinux-b7718454.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8cee3e243f78/bzImage-b7718454.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6e8c3cce21d276c02502@syzkaller.appspotmail.com

  stripe_sectors    0
  cached_sectors    0
  stripe            0
  stripe_redundancy 0
  io_time[READ]     1
  io_time[WRITE]    512
  fragmentation     4222124717768704
  bp_start          8
, fixing
 done
bcachefs (loop0): check_extents_to_backpointers...
missing backpointer for btree=extents l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq b77ad9ee5a61c7f0 written 16 min_key POS_MIN durability: 1 ptr: 0:27:0 gen 0
  got:   u64s 5 type deleted 0:7077888:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:7077888:0 len 0 ver 0: bucket=0:27:0 btree=extents l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=extents l=0 u64s 7 type extent 4098:24:U32_MAX len 24 ver 0: durability: 1 crc: c_size 8 size 24 offset 0 nonce 0 csum crc32c 0:4925b703  compress lz4 ptr: 0:36:0 gen 0
  got:   u64s 5 type deleted 0:9437184:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:9437184:0 len 0 ver 0: bucket=0:36:0 btree=extents l=0 offset=0:0 len=8 pos=4098:24:U32_MAX, fixing
missing backpointer for btree=extents l=0 u64s 7 type extent 536870913:8:U32_MAX len 8 ver 0: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum crc32c 0:cec3872e  compress incompressible ptr: 0:34:0 gen 0
  got:   u64s 5 type deleted 0:8912896:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:8912896:0 len 0 ver 0: bucket=0:34:0 btree=extents l=0 offset=0:0 len=8 pos=536870913:8:U32_MAX, fixing
missing backpointer for btree=inodes l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 19bc58a6c09b6540 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
  got:   u64s 5 type deleted 0:9961472:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:9961472:0 len 0 ver 0: bucket=0:38:0 btree=inodes l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=dirents l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c18f4a4face03c6 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0
  got:   u64s 5 type deleted 0:10747904:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:10747904:0 len 0 ver 0: bucket=0:41:0 btree=dirents l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=xattrs l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1477538288e6fe55 written 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0
  got:   u64s 5 type deleted 0:8126464:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:8126464:0 len 0 ver 0: bucket=0:31:0 btree=xattrs l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=alloc l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 75277f57b0c8c24 written 48 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0
  got:   u64s 5 type deleted 0:6815744:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:6815744:0 len 0 ver 0: bucket=0:26:0 btree=alloc l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=subvolumes l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7675f41d391e5d36 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0
  got:   u64s 5 type deleted 0:9175040:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:9175040:0 len 0 ver 0: bucket=0:35:0 btree=subvolumes l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=snapshots l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq bcb9905dfb2993d5 written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0
  got:   u64s 5 type deleted 0:8388608:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:8388608:0 len 0 ver 0: bucket=0:32:0 btree=snapshots l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=lru l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq d19419031ca39bdb written 16 min_key POS_MIN durability: 1 ptr: 0:28:0 gen 0
  got:   u64s 5 type deleted 0:7340032:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:7340032:0 len 0 ver 0: bucket=0:28:0 btree=lru l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=freespace l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9a831b4a3f983356 written 56 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0
  got:   u64s 5 type deleted 0:7602176:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:7602176:0 len 0 ver 0: bucket=0:29:0 btree=freespace l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
missing backpointer for btree=deleted_inodes l=1 u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq a34c10fbe2d33ffa written 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen 0
  got:   u64s 5 type deleted 0:11010048:0 len 0 ver 0
  want:  u64s 9 type backpointer 0:11010048:0 len 0 ver 0: bucket=0:42:0 btree=deleted_inodes l=1 offset=0:0 len=256 pos=SPOS_MAX, fixing
 done
bcachefs (loop0): check_alloc_to_lru_refs...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/lru.h:19!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5117 Comm: syz.0.0 Not tainted 6.11.0-rc7-syzkaller-00135-gb7718454f937 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:lru_pos fs/bcachefs/lru.h:19 [inline]
RIP: 0010:bch2_lru_check_set+0xced/0xd00 fs/bcachefs/lru.c:89
Code: ff 89 d9 80 e1 07 38 c1 0f 8c 50 fb ff ff be 08 00 00 00 48 89 df e8 32 40 c1 fd 48 8b 14 24 e9 3a fb ff ff e8 b4 f6 59 fd 90 <0f> 0b e8 ac f6 59 fd 90 0f 0b e8 64 13 80 07 0f 1f 40 00 90 90 90
RSP: 0018:ffffc90002e7ef00 EFLAGS: 00010246
RAX: ffffffff843995fc RBX: 000f000004000000 RCX: 0000000000040000
RDX: ffffc90003172000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc90002e7f110 R08: ffffffff84398ae3 R09: 0000000000000000
R10: ffffc90002e7f040 R11: fffff520005cfe0c R12: 0000000000000000
R13: dffffc0000000000 R14: 000000000000ffff R15: ffffc90002e7f42f
FS:  00007f249f1dc6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055609548a028 CR3: 0000000012610000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_check_alloc_to_lru_ref fs/bcachefs/alloc_background.c:1634 [inline]
 bch2_check_alloc_to_lru_refs+0x792/0x11f0 fs/bcachefs/alloc_background.c:1682
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:230
 bch2_fs_recovery+0x24f9/0x38b0 fs/bcachefs/recovery.c:859
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1954
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f249e37f69a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f249f1dbe68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f249f1dbef0 RCX: 00007f249e37f69a
RDX: 0000000020005d80 RSI: 0000000020000140 RDI: 00007f249f1dbeb0
RBP: 0000000020005d80 R08: 00007f249f1dbef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020000140
R13: 00007f249f1dbeb0 R14: 0000000000005db4 R15: 0000000020000180
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lru_pos fs/bcachefs/lru.h:19 [inline]
RIP: 0010:bch2_lru_check_set+0xced/0xd00 fs/bcachefs/lru.c:89
Code: ff 89 d9 80 e1 07 38 c1 0f 8c 50 fb ff ff be 08 00 00 00 48 89 df e8 32 40 c1 fd 48 8b 14 24 e9 3a fb ff ff e8 b4 f6 59 fd 90 <0f> 0b e8 ac f6 59 fd 90 0f 0b e8 64 13 80 07 0f 1f 40 00 90 90 90
RSP: 0018:ffffc90002e7ef00 EFLAGS: 00010246
RAX: ffffffff843995fc RBX: 000f000004000000 RCX: 0000000000040000
RDX: ffffc90003172000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc90002e7f110 R08: ffffffff84398ae3 R09: 0000000000000000
R10: ffffc90002e7f040 R11: fffff520005cfe0c R12: 0000000000000000
R13: dffffc0000000000 R14: 000000000000ffff R15: ffffc90002e7f42f
FS:  00007f249f1dc6c0(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005555641517e0 CR3: 0000000012610000 CR4: 0000000000350ef0
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
