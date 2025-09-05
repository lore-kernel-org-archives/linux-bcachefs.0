Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319BC1E519
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 12:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757074777; cv=none; b=GmPjkXw8/ONFN5pYcPToIEcfgxc3oITjhrkzrSTqtaHAr48Z3MFCgerCiLx0aK/MFrGHG56zmVjvui/Zr2ROgR7EWagcy1PNEoewbO52zifBHlxF5dWiCRDXY02UimJDUW04Io3wDtV/IOhhaSOkadBAkeLsiVQYvJd2Z7ARX8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757074777; c=relaxed/simple;
	bh=mfVdZUgryiuF8G6nHXpSoJjASx/7ng2hocWdYyY7dek=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=giwEKtOMxyvik2CqC/MIH5oxuy5dHnJgVJSTgFwYA3LBsGz4HIRM4H0tLpKFr5MNhpktzlin/ljgxbnpLLtcsj61e/uMMDpIDiCzocSUK5Z4jtR/lNP0dME4f+OdyqJetdcXUE7ZBSU8Smu8D7DGUmj+Nz4FwVDIYwu+xn4m3oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3f0c32654afso18918315ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 05:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757074774; x=1757679574;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MFhzVDNIRbuLfi1aRdhXyDPHoRUtJmfU3ZGNWHhGKVs=;
        b=AAw6RF/B6Nctoqq31ovF1smpDhkIaGgzXlKES/0ACTxAtcrsQllqybrO++dsPXLLnH
         U6GKNi4QRVG9JB2NRnehS1v5VgiPPbvKcIx3HKkB7UADKh1zXtTfAhX5oBdieggfYJ2C
         dhPQhoHZUw+g+qSWoOQi4nmzlWYuNdfPFzSPc8v6hGM5c814kDcdkLQHrSPlA0Oj2HP/
         iGzEadGvTPJykGAPfv+oLDuhwQBQboIX7p54j7Bho2kLi6wDMj3Di36EQ+DdseQEJwqo
         dcX/JEEEGqd38+I8Yw9M1gi3ohNk+/4cwNTp3/7sCp2quOKI2MBwCeR0pksGGUQjUY6x
         3tdA==
X-Forwarded-Encrypted: i=1; AJvYcCUhDG33AtI8+zO3ORvlS8kR5E7Wez4XUkLW/xAAgwKjFH4ycXuA2LSoUCOsC5zSlVIFbhkv9n1IsmSnRT1asA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXt2kZ28q838OkxmSBqi48pEeWx6KI89tWqv90QpC4k+d+/N0r
	zraXtJuKJAyTirCRG5Uj0bFm/6VGeDYsV+zgXugapad2dlzbE7lNtnMPdTRIpw31ZRxChG6q+Vl
	U9yzKWiPYKe22DFNIk6QKkrKAqTEj7pD18+RrZiRi9eGgLcHI8bWuwlq7KpI=
X-Google-Smtp-Source: AGHT+IGhGVfHT5K9WMNVLAHkrs+qvf5F2dNi5UfCbanL0oeiX8Vw3NbDIbLyrdUH0gfe/OBerFNNuBOZsS5WTisdqOMQDbs58p9M
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1521:b0:3f1:b54f:5cf7 with SMTP id
 e9e14a558f8ab-3f7c5c5db95mr37748645ab.9.1757074774226; Fri, 05 Sep 2025
 05:19:34 -0700 (PDT)
Date: Fri, 05 Sep 2025 05:19:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bad556.a00a0220.eb3d.0013.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (4)
From: syzbot <syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16d01962580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=55c84106264e92ea9ada
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1788c962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b0887c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/efa41ea44c52/disk-d69eb204.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d9ae66f326a4/vmlinux-d69eb204.xz
kernel image: https://storage.googleapis.com/syzbot-assets/967c2253578b/bzImage-d69eb204.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9e7c59fc7ab3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com

  running recovery passes: check_allocations,check_extents_to_backpointers,check_inodes
bcachefs (loop0): invalid bkey in btree_node btree=inodes level=0: u64s 18 type inode_v3 0:4102:U32_MAX len 0 ver 0: (unpack error)
  invalid variable length fields, deleting
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:633!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:bch2_btree_path_level_init+0xa01/0xa20 fs/bcachefs/btree_iter.c:633
Code: fd 90 0f 0b e8 90 05 a2 fd 90 0f 0b e8 88 05 a2 fd 90 0f 0b e8 80 05 a2 fd 90 0f 0b e8 78 05 a2 fd 90 0f 0b e8 70 05 a2 fd 90 <0f> 0b e8 68 05 a2 fd 90 0f 0b e8 60 05 a2 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc90003f8e4a0 EFLAGS: 00010293
RAX: ffffffff841c59a0 RBX: ffff88803d33c2d8 RCX: ffff888030d73b80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1007c6c817 R12: 0000000000000052
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000055557a974500(0000) GS:ffff8881268c1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff395c5f24 CR3: 0000000027dc0000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 btree_path_down fs/bcachefs/btree_iter.c:994 [inline]
 bch2_btree_path_traverse_one+0x1367/0x21d0 fs/bcachefs/btree_iter.c:1202
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:250 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2267 [inline]
 bch2_btree_iter_peek_max+0x9e8/0x58f0 fs/bcachefs/btree_iter.c:2384
 bch2_btree_iter_peek_max_type fs/bcachefs/btree_iter.h:743 [inline]
 bch2_gc_btree fs/bcachefs/btree_gc.c:729 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:792 [inline]
 bch2_check_allocations+0x120d/0x57b0 fs/bcachefs/btree_gc.c:1094
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:484 [inline]
 __bch2_run_recovery_passes+0x3bd/0x1060 fs/bcachefs/recovery_passes.c:539
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:610
 bch2_fs_recovery+0x2690/0x3a50 fs/bcachefs/recovery.c:1016
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcb57f3038a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc365dc0a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc365dc130 RCX: 00007fcb57f3038a
RDX: 0000200000000040 RSI: 0000200000004940 RDI: 00007ffc365dc0f0
RBP: 0000200000000040 R08: 00007ffc365dc130 R09: 0000000000004000
R10: 0000000000004000 R11: 0000000000000246 R12: 0000200000004940
R13: 00007ffc365dc0f0 R14: 00000000000049ae R15: 0000200000000180
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_path_level_init+0xa01/0xa20 fs/bcachefs/btree_iter.c:633
Code: fd 90 0f 0b e8 90 05 a2 fd 90 0f 0b e8 88 05 a2 fd 90 0f 0b e8 80 05 a2 fd 90 0f 0b e8 78 05 a2 fd 90 0f 0b e8 70 05 a2 fd 90 <0f> 0b e8 68 05 a2 fd 90 0f 0b e8 60 05 a2 fd 90 0f 0b 66 66 66 66
RSP: 0018:ffffc90003f8e4a0 EFLAGS: 00010293
RAX: ffffffff841c59a0 RBX: ffff88803d33c2d8 RCX: ffff888030d73b80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1007c6c817 R12: 0000000000000052
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  000055557a974500(0000) GS:ffff8881268c1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff395c5f24 CR3: 0000000027dc0000 CR4: 00000000003526f0


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
