Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5591FAC42
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792057; cv=none; b=DDOvbcGCaHIuxrVR3JMhnslbNVBVX5MGge1KFFBMhZtlDfc0+1Akl+Bav3/kqn7RnEA8FNCNGBLwcfzFt3tMs4G81XHL1slWnAf8OuwsgQYNPiGIgUN4WiV8w1uPONt/bj+YGUCthwuwu/rigyWc7A0RuTEbhJcPd2e1TnHvoUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792057; c=relaxed/simple;
	bh=DAPJ0yduV5m4meMBXem5mEQjGv+LHoa0QciyPfI1vVw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nh7+pG5I+pbgmtuzfOKDRp3w/Spcf4iBwqPhm9gAU+lNQ9DRNlkPWyey/zTiT/y6j60JSD/XrMl9VUldM8eidzqUN0vu+RFZ5bzAWhTz2WFpwWZaWENcP2rENJ4/e1X5yH0p7E1q76XuTbri0rNShWLOdSHxq29d8Eg+DYP2HMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83aaca0efc6so121025639f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 10:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729792054; x=1730396854;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q302cqA2GtT9etQ40qs/8NVemKQh30PtxyBrh1rV1Mw=;
        b=MT9olnhguO+GaFbzpWXJ8oxdc+5lkX4jhEtkrYGhnglUIov29Mmn9MRxj0MXXWiwan
         pCXAN5/cmfmKTDIyrlMMbcLd39qZeR6nftS9BLc3ocGjQVKe41tTZ9ChA5B6JDHiBnU6
         dMBSk7SyVxNNyZcZXZ/GZ6sZJL28muqvkBo5czOgpeO/c1t3Ke5O3w/1S6glqUeV2e/5
         5QNXiAlf1Ol1UoZx4oWx+lW9+MEAcolPKOcI94Qw9nV4COuIFoO5BKdh4VW75qGZ9VV4
         NE5MSVvEhETRjX2cMUv8Xj+4W9ATdRUUoeHr3XCWyeXgvnY+ZhBGb9P8UTbfvJpOKzKj
         QSWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8xx0Pnr3REdndhIx08YxNHKvUbNRkzAvRi4cJtKDbjQFGSTkzNwPboZ5S6YPYqCJohoTM4wbzyfj+698lVA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyG6gf6cN52eFB6z6xATWEYe1UCLzK6U/ac0TRjoIGvhBJpYMUt
	cj9kCmSBw6cVLaplY8l8fuJTLywxZwX1fJ3t/yawmb4/7nRpdGkPkcLOE4I9ZBjQXUR90mFyty9
	Ml6U7rfRAfzV1jR+MW+TUrjC0Ru2+ZURdA1Ytw6ngZ1f4VXswne2Od8Y=
X-Google-Smtp-Source: AGHT+IHqqgxrt3rQuAv8IHLa2srQkydZFrX8kQbEkCr60+ySDeT89XWhE1CkBiJnk4ccdHNoPNnOAq9/hvaxUNWnMBKyBNNtfSkz
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:152c:b0:3a0:985b:ddb4 with SMTP id
 e9e14a558f8ab-3a4de7825fbmr32685445ab.2.1729792052645; Thu, 24 Oct 2024
 10:47:32 -0700 (PDT)
Date: Thu, 24 Oct 2024 10:47:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671a8834.050a0220.2eb763.00c5.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_run_recovery_pass
From: syzbot <syzbot+a27c3aaa3640dd3e1dfb@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    715ca9dd687f Merge tag 'io_uring-6.12-20241019' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15afa0a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e543edc81a3008
dashboard link: https://syzkaller.appspot.com/bug?extid=a27c3aaa3640dd3e1dfb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16a8ec87980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7425f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-715ca9dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba436e2363b6/vmlinux-715ca9dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ac78a7a1a30/bzImage-715ca9dd.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/44b65c0cea47/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a27c3aaa3640dd3e1dfb@syzkaller.appspotmail.com

bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey_types.h:210!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5098 Comm: syz-executor177 Not tainted 6.12.0-rc3-syzkaller-00420-g715ca9dd687f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bkey_s_c_to_backpointer fs/bcachefs/bkey_types.h:210 [inline]
RIP: 0010:bch2_check_backpointers_to_extents_pass fs/bcachefs/backpointers.c:1003 [inline]
RIP: 0010:bch2_check_backpointers_to_extents+0x240a/0x2430 fs/bcachefs/backpointers.c:1049
Code: 48 8b 4c 24 38 80 e1 07 38 c1 0f 8c b7 dd ff ff be 18 00 00 00 48 8b 7c 24 38 e8 11 7e ee fd e9 a3 dd ff ff e8 27 b8 84 fd 90 <0f> 0b e8 1f b8 84 fd 90 0f 0b e8 f7 56 b6 07 e8 12 b8 84 fd 90 0f
RSP: 0018:ffffc90002d9ed80 EFLAGS: 00010293
RAX: ffffffff84102fd9 RBX: ffff888041da01d0 RCX: ffff8880003e2440
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000000000000001c
RBP: ffffc90002d9f488 R08: ffffffff84101b4e R09: 0000000000000000
R10: ffffc90002d9e780 R11: fffff520005b3cfd R12: 0000000000000003
R13: ffffc90002d9f280 R14: dffffc0000000000 R15: ffff8880401a8000
FS:  000055556e26c380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffda68deef8 CR3: 000000004091a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f62c028fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe477ec068 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe477ec080 RCX: 00007f1f62c028fa
RDX: 00000000200058c0 RSI: 0000000020001040 RDI: 00007ffe477ec080
RBP: 0000000000000004 R08: 00007ffe477ec0c0 R09: 002c647261637350
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffe477ec0c0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bkey_s_c_to_backpointer fs/bcachefs/bkey_types.h:210 [inline]
RIP: 0010:bch2_check_backpointers_to_extents_pass fs/bcachefs/backpointers.c:1003 [inline]
RIP: 0010:bch2_check_backpointers_to_extents+0x240a/0x2430 fs/bcachefs/backpointers.c:1049
Code: 48 8b 4c 24 38 80 e1 07 38 c1 0f 8c b7 dd ff ff be 18 00 00 00 48 8b 7c 24 38 e8 11 7e ee fd e9 a3 dd ff ff e8 27 b8 84 fd 90 <0f> 0b e8 1f b8 84 fd 90 0f 0b e8 f7 56 b6 07 e8 12 b8 84 fd 90 0f
RSP: 0018:ffffc90002d9ed80 EFLAGS: 00010293
RAX: ffffffff84102fd9 RBX: ffff888041da01d0 RCX: ffff8880003e2440
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000000000000001c
RBP: ffffc90002d9f488 R08: ffffffff84101b4e R09: 0000000000000000
R10: ffffc90002d9e780 R11: fffff520005b3cfd R12: 0000000000000003
R13: ffffc90002d9f280 R14: dffffc0000000000 R15: ffff8880401a8000
FS:  000055556e26c380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffda68deef8 CR3: 000000004091a000 CR4: 0000000000352ef0
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
