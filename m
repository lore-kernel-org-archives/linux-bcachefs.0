Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7AC136E0E
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Oct 2024 08:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727943025; cv=none; b=SMhYqHc120mb39Gskm0balo5F+gqTUlscdS1SNuHJqt7ODs/uQ7u/ySxbe0tUwwCGAkqbW2jDRRdWyjZPw2RGieArK8XEomY+jBWZYtQuIrDK6r14pIJvZSNNwtmzgaPTo65jcX4regxyIVaMC9cwBkLIO2afWLcLbx7Yc5ZYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727943025; c=relaxed/simple;
	bh=MELfaeYNwuK9IFIxCF34vE6/+tliHiaVi5d18j1rAuQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fMfSNGXCn5PmdphJjAu4zt9PxQ86vm1NuRWlyxIeRO3FakSilIrWRzg/z/CDOdL3su5MwD1SuRgTiJyAYfu1DAmrPmSDRtYyA3KEGLSPWb73CMYtzl6/aOuzkUs+zojdypsH0ZZQZNvq46Hjat031o665x6IFue005tll4e7DGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a1a2af837dso15625205ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 01:10:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727943022; x=1728547822;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OkqFmFF8qe4qygmPiodrfHZpkj/BCrTXbofBlX6U6qI=;
        b=iH8g+JQ5kzWgSXDCD7ZvMFCYnpfTmAhJ5KQPbAfHIOMz+a1YcvjGaI+SxBmUl2BoaJ
         iwA2MLd8h47Dkqd4IVf9EYjvzFkRMiZE5cqrKT0jlCw9HzEabM7MjiuNEIqhhWZSZXxA
         Hg6eXrJY89MbpokD4BP9fgzLEPtYcbunRVX+fl2ckQiFQ2MbSqWc30Z3ZA0cCTHCY02Y
         894s3Be5ipaMd83YvnMJTleNEZZTreQ1EM9lh1YPQfDDnqeZvtqf0+LcDX9P9f+1hgR1
         PXWbO6875an3E0YIc8G7bPyajAsfka6x61TEDi74MEpRsSTvjWjwr17WWAAoDPXIteqC
         CWWQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8fH6PRk0MEFTvmykmP/VHOyXFmvziI6XKcHZPNqtuv36545IOzJj+AtArnFplozAa2ge6Vk1M1pcKbMingQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZYfGx1XlMUU/q98gSmqJlZ2hbbgfuEpDWLWPb19HHkE80427v
	LlI4loPp7o4HuklY4YBZmK48osFmbTkgLTMcye7R11UKlTaNQILI5gXtzXyQAnClCZGMS/XGVjr
	7mPmoYaVxMovnfzFpk7zWdab2r32cI9KNwkOOnZ+1tW5tsnysUiifStI=
X-Google-Smtp-Source: AGHT+IGl1HUDBNBp1+Nf2GD98FpFyxnFBTBMau1VNmgv7DxZdx0ETEayqgjDBN/E06vPO/w8ghiEXnWMlr/Pe0R9W9Nf01iajUiE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2147:b0:3a0:ce43:fb62 with SMTP id
 e9e14a558f8ab-3a36e2be9f0mr17686815ab.11.1727943022432; Thu, 03 Oct 2024
 01:10:22 -0700 (PDT)
Date: Thu, 03 Oct 2024 01:10:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66fe516e.050a0220.28a3b.020a.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bch2_btree_node_write
From: syzbot <syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3efc57369a0c Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=142bf6a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4fcb065287cdb84
dashboard link: https://syzkaller.appspot.com/bug?extid=dedbd67513939979f84f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3efc5736.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d0988c372a39/vmlinux-3efc5736.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8547f30d7e9d/bzImage-3efc5736.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dedbd67513939979f84f@syzkaller.appspotmail.com

bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.12: rebalance_work_acct_fix
  running recovery passes: check_allocations
invalid bkey u64s 11 type alloc_v4 0:14:0 len 0 ver 0: 
  gen 0 oldest_gen 0 data_type journal
  journal_seq       1
  need_discard      1
  need_inc_gen      1
  dirty_sectors     256
  stripe_sectors    0
  cached_sectors    0
  stripe            67108864
  stripe_redundancy 0
  io_time[READ]     1
  io_time[WRITE]    1
  fragmentation     0
  bp_start          8
  invalid data type (got 2 should be 7): delete?, fixing
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
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
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq bcb9905dfb2993d5 written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9a831b4a3f983356 written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:1 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:1 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): scanning for old btree nodes: min_version 0.9: (unknown version)
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_io.c:2099!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5116 Comm: syz.0.0 Not tainted 6.11.0-syzkaller-11993-g3efc57369a0c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_btree_node_write+0x43d8/0x4400 fs/bcachefs/btree_io.c:2099
Code: fd 90 0f 0b e8 e9 a7 7d fd 90 0f 0b e8 e1 a7 7d fd 90 0f 0b e8 d9 a7 7d fd 90 0f 0b e8 d1 a7 7d fd 90 0f 0b e8 c9 a7 7d fd 90 <0f> 0b e8 c1 a7 7d fd 90 0f 0b e8 b9 a7 7d fd 90 0f 0b e8 b1 a7 7d
RSP: 0018:ffffc9000b346ac0 EFLAGS: 00010246
RAX: ffffffff84173e57 RBX: 00000000000001e2 RCX: 0000000000040000
RDX: ffffc9000b379000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc9000b346da0 R08: ffffffff84171d58 R09: 0000000000000000
R10: ffffc9000b346860 R11: fffff52001668d0e R12: dffffc0000000000
R13: ffff88804eb2809e R14: 00000000000001eb R15: 00000000000001e2
FS:  00007f445f9486c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005607e3ef4011 CR3: 000000001eaf8000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_write+0x63/0x1f0 fs/bcachefs/btree_io.c:2283
 bch2_btree_node_rewrite+0xcac/0x1280 fs/bcachefs/btree_update_interior.c:2173
 bch2_move_btree+0x7af/0xde0 fs/bcachefs/move.c:865
 bch2_scan_old_btree_nodes+0x14b/0x3c0 fs/bcachefs/move.c:995
 bch2_fs_recovery+0x33da/0x38b0 fs/bcachefs/recovery.c:962
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2071
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f445eb7f79a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f445f947e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f445f947ef0 RCX: 00007f445eb7f79a
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007f445f947eb0
RBP: 0000000020005d80 R08: 00007f445f947ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020005dc0
R13: 00007f445f947eb0 R14: 0000000000005d7d R15: 0000000020000280
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_node_write+0x43d8/0x4400 fs/bcachefs/btree_io.c:2099
Code: fd 90 0f 0b e8 e9 a7 7d fd 90 0f 0b e8 e1 a7 7d fd 90 0f 0b e8 d9 a7 7d fd 90 0f 0b e8 d1 a7 7d fd 90 0f 0b e8 c9 a7 7d fd 90 <0f> 0b e8 c1 a7 7d fd 90 0f 0b e8 b9 a7 7d fd 90 0f 0b e8 b1 a7 7d
RSP: 0018:ffffc9000b346ac0 EFLAGS: 00010246
RAX: ffffffff84173e57 RBX: 00000000000001e2 RCX: 0000000000040000
RDX: ffffc9000b379000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffc9000b346da0 R08: ffffffff84171d58 R09: 0000000000000000
R10: ffffc9000b346860 R11: fffff52001668d0e R12: dffffc0000000000
R13: ffff88804eb2809e R14: 00000000000001eb R15: 00000000000001e2
FS:  00007f445f9486c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f445f9279a0 CR3: 000000001eaf8000 CR4: 0000000000352ef0
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
