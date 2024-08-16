Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AD21714A7
	for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 09:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801826; cv=none; b=nEs5w5p0KlCrPYmyIHruFAJ76yOFTv7GXTEvllFRzXB7+WMWz1F+e8y447eWN7zd04v2guEyVdsomNREn/wcn3g+2ySrLMn5x1eAZwPepZAv41hXFx3oq78MTRvWAUZrvlBpgUOiGofPNvVUnYRuMtKSvNwEUwYguct/VjktSzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801826; c=relaxed/simple;
	bh=YMlRIfpgLWfzMnUxUOnXs045GiCUCvfInjRCzY39Xdc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dMG4zycrjwvxFiTdnP3ZP3vTZ9c8su+T4HvCkFJ36QWYPm+JfLt6alJORX1uwn8ITWoiAH1gwDQe94vhcy2FXDQB5B0fMjgrMEAbBSkewAToO8UBV5zAPbQgS890jR7oijsz4m0U0mV+eUiDRzcOrAPvCzyg/8nWDEdRICYa9r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-39d2ced7e8eso1915725ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 16 Aug 2024 02:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723801824; x=1724406624;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RGL9FQmB5nbopldCpt+u4K2VdFzYz6hmq4pNpCAgyHY=;
        b=Y+tZg7tP2KVt3zg2tLAy/JxlirzjxFtS3g1k0UhEfQVus94xm1W/zgDsSf3UcXf9ZL
         8WpiFHyXZbC8vW9mves9Vp1tRoTsjbDOCxw25jy+oLTc+JVcY4dIKMqI2drQzRa6bcZt
         nwfWOxmduT3lzXLCFXqERsvhIuqcdboVMHfROWuVwgJVVza9NjYBcX4oKaXNYUDDv80n
         uU3btz2xgntnqFLc5+WkE/0LB82pD+JymG4+v7dafS4zHNZnv7UTLOShSxuG8JivoLAI
         k2LwxRQYYTSmDwL6UqOaE/8CbOmQNnzBWYWUZHHYRUM2iwHln7MXZVyFRAnxBjGrIkR0
         2umQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8Jci7eU5b2cgmkFmnptN5wCK0YEb9HYjcz+XcqTFUlFk5NMBqeoeWXGLXxI9QNno11hjeEYDQ3PkIwZJfrNCuDxyGbeyNF++EO+Z4TPg=
X-Gm-Message-State: AOJu0Yy2o+W0MSeFta97see2Is28qS534mTgeNKnp+Q23m7EcgBrXyq0
	kkZwwehV+BS7LXJPuLi6JEXAX2vgR0p83ys8FNnMLZYPKcGZTG3tyUx50fSb4TCNbDOv4QWfjRS
	wdmyIZCcB2jBXiRfmKvfrdM1HKBJiVtGtrS2bIS8AXTv/PHNmzhZMJFk=
X-Google-Smtp-Source: AGHT+IERcO2HqACqr41RDkKB2vxzlsKnEPdx3dkn9e3rFXNcfYP9pF4V9ffVljmUSusg+ZMOLbun+sdOCOHRDMgIRAW34M2ISA/p
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a25:b0:380:9233:96e6 with SMTP id
 e9e14a558f8ab-39d26d856dcmr1543855ab.4.1723801823791; Fri, 16 Aug 2024
 02:50:23 -0700 (PDT)
Date: Fri, 16 Aug 2024 02:50:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ee2e9061fc9e38c@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_lru_change (2)
From: syzbot <syzbot+510b0b28f8e6de64d307@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1fb918967b56 Merge tag 'for-6.11-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d08bc5980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=510b0b28f8e6de64d307
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145916d5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134f55f3980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-1fb91896.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd6e8883313a/vmlinux-1fb91896.xz
kernel image: https://storage.googleapis.com/syzbot-assets/87b718d2d1df/bzImage-1fb91896.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4878c2c54d9c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+510b0b28f8e6de64d307@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/lru.h:19!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5085 Comm: syz-executor267 Not tainted 6.11.0-rc3-syzkaller-00066-g1fb918967b56 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:lru_pos fs/bcachefs/lru.h:19 [inline]
RIP: 0010:__bch2_lru_set fs/bcachefs/lru.c:48 [inline]
RIP: 0010:bch2_lru_del fs/bcachefs/lru.c:54 [inline]
RIP: 0010:bch2_lru_change+0x65c/0x680 fs/bcachefs/lru.c:69
Code: 80 e1 07 38 c1 0f 8c 47 fd ff ff be 14 00 00 00 48 8b 7c 24 10 e8 14 d9 c2 fd e9 33 fd ff ff e8 3a 62 7e 07 e8 65 92 5b fd 90 <0f> 0b e8 5d 92 5b fd 90 0f 0b e8 55 92 5b fd 90 0f 0b e8 4d 92 5b
RSP: 0018:ffffc9000aece6e0 EFLAGS: 00010293
RAX: ffffffff8437f70b RBX: 1ffff920015d9cf2 RCX: ffff8880001fc880
RDX: 0000000000000000 RSI: 0100000001000000 RDI: 0000ffffffffffff
RBP: ffffc9000aece810 R08: ffffffff8437f253 R09: ffffffff8404216f
R10: 0000000000000003 R11: ffff8880001fc880 R12: 0000ffffffffffff
R13: 1ffff920015d9ce4 R14: 0100000001000000 R15: ffff000001000000
FS:  0000555576dd6380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6d9100bd97 CR3: 00000000122b8000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_trigger_alloc+0x1745/0x3f80 fs/bcachefs/alloc_background.c:877
 bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:507 [inline]
 run_btree_triggers+0xc91/0x1270 fs/bcachefs/btree_trans_commit.c:540
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:583 [inline]
 __bch2_trans_commit+0x542/0x9030 fs/bcachefs/btree_trans_commit.c:1058
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_extent_update+0x4c0/0xbb0 fs/bcachefs/io_write.c:325
 bch2_fpunch_at+0x87c/0x1020 fs/bcachefs/io_misc.c:184
 bch2_fpunch+0x412/0x690 fs/bcachefs/io_misc.c:203
 bchfs_fpunch+0x282/0x7a0 fs/bcachefs/fs-io.c:538
 bch2_fallocate_dispatch+0x3e7/0x540 fs/bcachefs/fs-io.c:792
 vfs_fallocate+0x553/0x6c0 fs/open.c:334
 do_vfs_ioctl+0x2592/0x2e50 fs/ioctl.c:886
 __do_sys_ioctl fs/ioctl.c:905 [inline]
 __se_sys_ioctl+0x81/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fad0bc1ab99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc8d92bed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007fad0bc1ab99
RDX: 0000000020000180 RSI: 0000000040305829 RDI: 0000000000000004
RBP: 00007fad0bc935f0 R08: 0000555576dd74c0 R09: 0000555576dd74c0
R10: 0000555576dd74c0 R11: 0000000000000246 R12: 00007ffc8d92bf00
R13: 00007ffc8d92c128 R14: 431bde82d7b634db R15: 00007fad0bc6303b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lru_pos fs/bcachefs/lru.h:19 [inline]
RIP: 0010:__bch2_lru_set fs/bcachefs/lru.c:48 [inline]
RIP: 0010:bch2_lru_del fs/bcachefs/lru.c:54 [inline]
RIP: 0010:bch2_lru_change+0x65c/0x680 fs/bcachefs/lru.c:69
Code: 80 e1 07 38 c1 0f 8c 47 fd ff ff be 14 00 00 00 48 8b 7c 24 10 e8 14 d9 c2 fd e9 33 fd ff ff e8 3a 62 7e 07 e8 65 92 5b fd 90 <0f> 0b e8 5d 92 5b fd 90 0f 0b e8 55 92 5b fd 90 0f 0b e8 4d 92 5b
RSP: 0018:ffffc9000aece6e0 EFLAGS: 00010293
RAX: ffffffff8437f70b RBX: 1ffff920015d9cf2 RCX: ffff8880001fc880
RDX: 0000000000000000 RSI: 0100000001000000 RDI: 0000ffffffffffff
RBP: ffffc9000aece810 R08: ffffffff8437f253 R09: ffffffff8404216f
R10: 0000000000000003 R11: ffff8880001fc880 R12: 0000ffffffffffff
R13: 1ffff920015d9ce4 R14: 0100000001000000 R15: ffff000001000000
FS:  0000555576dd6380(0000) GS:ffff888020800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffab111bad5 CR3: 00000000122b8000 CR4: 0000000000350ef0
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
