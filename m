Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D5A1DFE38
	for <linux-bcachefs@vger.kernel.org>; Wed,  6 Nov 2024 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899471; cv=none; b=kuwvtYM4Jee2qwmcDRY9F4TqNU5gmLc9SpVcU0p6KNg8y2YskamSang+59wQ5q1e2Nfb3Iy9VQLI+ksz0Q35OyMM3gHIveoo1t6oZrT2aHQkQ9kMVUGbkbprUriV34Dl3SvY9XsqJfvp9bV31V53b+TNJmIXghT5mU9BV/2hqeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899471; c=relaxed/simple;
	bh=ENA9AWi0tjn+1a3zT70Krgt930E7soDwAJinHc+5dUM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YSirlRMNcMmF3FnWjemGOrwxY2xbGpCZXNxOU2l/EPVvV8UI2pEdI7bz0BJ+IPiaLxc7yJQhNLvewvLI9AB1GofbdMfmmdC09S9kdTFoRvvrelOMDnOnnCe8Bi2Rn2xR+GqjrhB9GHMCsIqdSpZEpwoi4drx6du2pbD7ZGKeekM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a6b7974696so53735145ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 06 Nov 2024 05:24:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730899469; x=1731504269;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HHvtJ8N+bx/9aPCFxEqXjWPVaAHCL5HZey8ePX+IBqg=;
        b=A1md+thqzruV3pULGVEOckN5cjXUMCLQ2xNR79KvivL7qKWDEeKihy1dlmF2nm0dLL
         p90Ix0vwiy/BYh+TZcgYKClE8MSFkG9QyLhcicK6jqaOQ1RdN+6RI/QnciXBvp1GZacW
         RIQDTW5Z2RbtJ7Vfca8uwnNC9PDDSRXtfzuzEnk5gxL5AmlWhFyrdXR0vStdmGU8vSE2
         I2Yf2V0JDdnFMbLYSh4pFDg8nbtLkRMfaaGHmr49qe5N+yBjv3TJ+vkbieoS/Inf6ABt
         GR8MvqNdRlZ+j9r3YucKFf2yyaOWLarfrCw0NGduhnHMFq/I9SNH7dc7MaIfxmCKithC
         T7eQ==
X-Forwarded-Encrypted: i=1; AJvYcCXW2icX7rFSCH/vawBuTBgSRSz8dhTocXR7gwHGnItHIlIAdjkfl2q01t+iIVTssoINxBSANBHePN/A7gYckA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8KNE6j1JsHIqGKujBNeXFIuOJHVoGpw1Put7tW6palDFmP+ZK
	8qfFeBMbw2WQAEAsiZ0VtO3JKWFssm2IjBva1rR+wL77tl06oZqHRffVV4LkMi0VNr7yyPb60XA
	PVkJK2I/+rfYEAWT54kA64lZ0FCuTYWJiPsCPNxhfDcAh4g6VE6uM5Bs=
X-Google-Smtp-Source: AGHT+IENVoPWcUMexzAHUgyOtsY+zH1/ohLNJevAiZYyAtrb91HgAbGnz4QiyAbmWsEu7CgX5idlkXoCc6S1W7V8X0q47mHeA70m
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c41:b0:3a5:d2a:10e0 with SMTP id
 e9e14a558f8ab-3a6b0229ecbmr187669405ab.5.1730899469442; Wed, 06 Nov 2024
 05:24:29 -0800 (PST)
Date: Wed, 06 Nov 2024 05:24:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <672b6e0d.050a0220.350062.024e.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_traverse_one
From: syzbot <syzbot+997f0573004dcb964555@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    11066801dd4b Merge tag 'linux_kselftest-fixes-6.12-rc6' of..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=123e755f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=672325e7ab17fdf7
dashboard link: https://syzkaller.appspot.com/bug?extid=997f0573004dcb964555
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156b2987980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163e755f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-11066801.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b062b193560b/vmlinux-11066801.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5b6da4ee7c42/bzImage-11066801.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/8becb7eaabe7/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+997f0573004dcb964555@syzkaller.appspotmail.com

bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.h:129!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5320 Comm: syz-executor345 Not tainted 6.12.0-rc5-syzkaller-00299-g11066801dd4b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:129 [inline]
RIP: 0010:btree_path_lock_root fs/bcachefs/btree_iter.c:723 [inline]
RIP: 0010:bch2_btree_path_traverse_one+0x28de/0x2940 fs/bcachefs/btree_iter.c:1183
Code: f4 8e 48 89 de e8 92 da dc 00 e9 78 f8 ff ff e8 38 e1 7b fd 90 0f 0b e8 c0 2d ae 07 e8 2b e1 7b fd 90 0f 0b e8 23 e1 7b fd 90 <0f> 0b e8 1b e1 7b fd 90 0f 0b e8 13 e1 7b fd 90 0f 0b 48 8b 4c 24
RSP: 0018:ffffc9000d0d5de0 EFLAGS: 00010293
RAX: ffffffff8418f8fd RBX: ffff888044480000 RCX: ffff88801f084880
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: ffffc9000d0d60d0 R08: ffffffff8418e949 R09: ffffffff8418b9a9
R10: 0000000000000002 R11: ffff88801f084880 R12: dffffc0000000000
R13: 0000000000000004 R14: ffff8880414cc380 R15: 0000000000000000
FS:  0000555593398380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056431d273820 CR3: 0000000044502000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_slot+0x84f/0x2550 fs/bcachefs/btree_iter.c:2629
 bch2_backpointer_get_key+0x2bc/0x970 fs/bcachefs/backpointers.c:322
 check_bp_exists fs/bcachefs/backpointers.c:579 [inline]
 check_extent_to_backpointers+0x21f9/0x46b0 fs/bcachefs/backpointers.c:683
 bch2_check_extents_to_backpointers_pass fs/bcachefs/backpointers.c:879 [inline]
 bch2_check_extents_to_backpointers+0x1190/0x1bf0 fs/bcachefs/backpointers.c:932
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f31be2970aa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6f7edc68 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd6f7edc70 RCX: 00007f31be2970aa
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffd6f7edc70
RBP: 0000000000000004 R08: 00007ffd6f7edcb0 R09: 00000000000058cb
R10: 0000000000000001 R11: 0000000000000282 R12: 00007ffd6f7edcb0
R13: 0000000000000003 R14: 0000000001000000 R15: 00007f31be2de03b
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_id_root fs/bcachefs/btree_cache.h:129 [inline]
RIP: 0010:btree_path_lock_root fs/bcachefs/btree_iter.c:723 [inline]
RIP: 0010:bch2_btree_path_traverse_one+0x28de/0x2940 fs/bcachefs/btree_iter.c:1183
Code: f4 8e 48 89 de e8 92 da dc 00 e9 78 f8 ff ff e8 38 e1 7b fd 90 0f 0b e8 c0 2d ae 07 e8 2b e1 7b fd 90 0f 0b e8 23 e1 7b fd 90 <0f> 0b e8 1b e1 7b fd 90 0f 0b e8 13 e1 7b fd 90 0f 0b 48 8b 4c 24
RSP: 0018:ffffc9000d0d5de0 EFLAGS: 00010293
RAX: ffffffff8418f8fd RBX: ffff888044480000 RCX: ffff88801f084880
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
RBP: ffffc9000d0d60d0 R08: ffffffff8418e949 R09: ffffffff8418b9a9
R10: 0000000000000002 R11: ffff88801f084880 R12: dffffc0000000000
R13: 0000000000000004 R14: ffff8880414cc380 R15: 0000000000000000
FS:  0000555593398380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cc391660a8 CR3: 0000000044502000 CR4: 0000000000352ef0
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
