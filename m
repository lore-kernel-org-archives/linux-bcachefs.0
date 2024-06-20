Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DBA1EB31
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 02:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718852120; cv=none; b=dXPml8qWtiIvP5u/dJ+GH58W+f8XcMfOPF8Z+3vTD+VQ7XSug6TjbjIZJheMSh7+Cy9ECp5Fn6whQ08Tk7pmVm47SadVLQn5R/ndKaAkR/qHNv2nvxoPYKdxtl/76gHRonQ98SuU4k/G3mNnYIC/kqBce5OD+FJQMywO+iDGNJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718852120; c=relaxed/simple;
	bh=8ZAYadfQMP3kgVVXbb9DEbzHJ8kYAfE38F9eOtCv1EU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=B8/Yr+07vZf1ebvwrBYJaqqQqciwIrFsNSxijvPCUVFdzkvyl2vZtlPuvOwX/Cb8yNzyXiHbJyTYFSeU/ohnaRpwjD4Q3sAFv586Mtsg9ZygKJDuwRonEvjh95xK2mPF2+VNm5VUKWd+lMjfTD1AGJUtF2IyCYR8be4DvA3jfrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7eb7e13522bso48665739f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 19 Jun 2024 19:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718852118; x=1719456918;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lj58J19YIpPfhu4V4a/LLJxDtQkTPli6j+7LhpVu/0s=;
        b=NEO8Yd0Yu0Vp9nvJo06qBSXwoYcnBeypoKYV6MNR2mGX4AWtvhnuOuqLo8zLIhDEPn
         XxQM0F3bf8Kfuth4TfSausjV4J0Xwx60aQDcUNGWyDhHQJ7b9u6ykobXTxKMonX+hUrj
         8CBfDlBP2Yw78HAizY5NrMW7uFKTJmHvqh2fz1RhctgoblOVvsH/GlVdEyzXYbsEZ3tw
         clSnYtNWsFlFBpgUggEVsleRNmzs8NiqWWJc1FEbcE7f92Yr/HXssjeZSUfw5zFEqOL2
         H+GiaTd2oNP7QueufVXX25AHQ8uIdaiW5VdPKcEixtEAZ3FgkOZE5wt/PbMJ2AXUuOCH
         m+og==
X-Forwarded-Encrypted: i=1; AJvYcCXbawHaRBQeecLR7A7mYHKH8fvMb0a9+gPBI+b+dEUZGiPaIdai5P4cZpoK1sT2r8lH0IoNdvtQvPG14ahzduIU6oZJLx2G0vzivrD3Zdk=
X-Gm-Message-State: AOJu0YxvLSGLpTnkYPhASvSN+b4asPn3CtGKn9r0H0b//mbeONJIY4Yj
	lnbhmHe1LbWFSQtAuD1X9a5+LRetVnI1RObDh6W9VvAL0HaG4eYgbowCYyC1I3HQxYCbJUNpiKH
	elJezuRPuI8kGjWK9nUHJua7qRqetYtlqMHpD0wK4KTVQUTyscZDYM/U=
X-Google-Smtp-Source: AGHT+IFDKmHYSdoqqrWcihJVQmFeiJeeByqLhXP5SfqmK45w/mgBHFfUUXhyqlp48Edo+VtkDkao4newadT7GAhAhUilnqkGIHBu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2394:b0:4b9:afd1:d4f8 with SMTP id
 8926c6da1cb9f-4b9afd1f309mr74034173.2.1718852118501; Wed, 19 Jun 2024
 19:55:18 -0700 (PDT)
Date: Wed, 19 Jun 2024 19:55:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f1ed2e061b4971d2@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bucket_alloc_trans
From: syzbot <syzbot+24a867cb90d8315cccff@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13315dde980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79815c08cc14227
dashboard link: https://syzkaller.appspot.com/bug?extid=24a867cb90d8315cccff
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/35e32e9073a7/disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6c6e34658d16/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4417e7ef76ed/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24a867cb90d8315cccff@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/alloc_foreground.c:489!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5956 Comm: syz-executor.2 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:489 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x3ac8/0x3b30 fs/bcachefs/alloc_foreground.c:649
Code: 4e f6 f4 fd e9 07 c7 ff ff 44 89 f1 80 e1 07 38 c1 0f 8c fe fd ff ff 4c 89 f7 e8 e3 f4 f4 fd e9 f1 fd ff ff e8 69 7a 92 fd 90 <0f> 0b e8 61 7a 92 fd 90 0f 0b e8 29 3b 7a 07 f3 0f 1e fa e8 50 7a
RSP: 0018:ffffc900048f5c80 EFLAGS: 00010287
RAX: ffffffff8403aba7 RBX: 0000000000000019 RCX: 0000000000040000
RDX: ffffc90014c00000 RSI: 000000000000da04 RDI: 000000000000da05
RBP: ffffc900048f63b0 R08: ffffffff84037d73 R09: 0000000000000000
R10: ffffc900048f6268 R11: fffff5200091ec52 R12: 0000000000000037
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007efeb1dc06c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d26000 CR3: 000000002336e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bucket_alloc_set_trans+0x4f9/0xcf0 fs/bcachefs/alloc_foreground.c:810
 __open_bucket_add_buckets+0x11ed/0x1c80 fs/bcachefs/alloc_foreground.c:1058
 open_bucket_add_buckets+0x174/0x230 fs/bcachefs/alloc_foreground.c:1102
 bch2_alloc_sectors_start_trans+0xcaf/0x1f60
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:333 [inline]
 bch2_btree_reserve_get+0x5f5/0x18d0 fs/bcachefs/btree_update_interior.c:547
 bch2_btree_update_start+0xe84/0x1500 fs/bcachefs/btree_update_interior.c:1245
 bch2_btree_split_leaf+0x12c/0x810 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x200/0x1210 fs/bcachefs/btree_trans_commit.c:918
 __bch2_trans_commit+0x6e6c/0x88e0 fs/bcachefs/btree_trans_commit.c:1138
 bch2_trans_commit fs/bcachefs/btree_update.h:170 [inline]
 bch2_logged_op_start+0x1c8/0x310 fs/bcachefs/logged_ops.c:83
 bch2_truncate+0x1a4/0x2c0 fs/bcachefs/io_misc.c:291
 bchfs_truncate+0x80f/0xc80 fs/bcachefs/fs-io.c:476
 notify_change+0xb9d/0xe70 fs/attr.c:497
 do_truncate+0x220/0x310 fs/open.c:65
 vfs_truncate+0x2e1/0x3b0 fs/open.c:111
 do_sys_truncate+0xde/0x190 fs/open.c:134
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efeb107cf29
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007efeb1dc00c8 EFLAGS: 00000246 ORIG_RAX: 000000000000004c
RAX: ffffffffffffffda RBX: 00007efeb11b3f80 RCX: 00007efeb107cf29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000340
RBP: 00007efeb10ec074 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007efeb11b3f80 R15: 00007ffdd551b608
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:489 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x3ac8/0x3b30 fs/bcachefs/alloc_foreground.c:649
Code: 4e f6 f4 fd e9 07 c7 ff ff 44 89 f1 80 e1 07 38 c1 0f 8c fe fd ff ff 4c 89 f7 e8 e3 f4 f4 fd e9 f1 fd ff ff e8 69 7a 92 fd 90 <0f> 0b e8 61 7a 92 fd 90 0f 0b e8 29 3b 7a 07 f3 0f 1e fa e8 50 7a
RSP: 0018:ffffc900048f5c80 EFLAGS: 00010287
RAX: ffffffff8403aba7 RBX: 0000000000000019 RCX: 0000000000040000
RDX: ffffc90014c00000 RSI: 000000000000da04 RDI: 000000000000da05
RBP: ffffc900048f63b0 R08: ffffffff84037d73 R09: 0000000000000000
R10: ffffc900048f6268 R11: fffff5200091ec52 R12: 0000000000000037
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000000
FS:  00007efeb1dc06c0(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc6b66ca628 CR3: 000000002336e000 CR4: 00000000003506f0
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
