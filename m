Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38171199384
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 11:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729682491; cv=none; b=BOmTLhlpyaeMGMVOTkTGB65QOAaS/BsLuSShmtXrhVP3BdWXFY2CZcKrWUpkUxUsXgxfub2MNqTCNq/14aKu40zK2Wy/3M3wW4NBwRQwwwZkzVWZ024WR/y6uJUJiiOX2cMxarOEsjkag2q8z/VRTn7EK5khf197HCpKxX6uNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729682491; c=relaxed/simple;
	bh=jrWAzrOHkl4R41gA+b3jWb+QxSq6a6lgm0UimBv8U/k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nbMVUA/1r8E8uIZt4keYfb9RGkHENYENI4fDgp+bHk1gO+IycB2gE5m+b7BIQfLiYjBTEp8U1B7IQfeZRJ8Awe9MklzVNXXziBmfoN6UsquLYLmozam/pzzjahiDkXSpKvra0ThjUPNboHQGGGeZbPYOjcqvRPpFdI+x/Qa6pSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3da2d46b9so53355405ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 04:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729682489; x=1730287289;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ER7eBPOPMHtQyadUG47/J953jVRhit5sxW0qa/8Bg9U=;
        b=lF49xjBnGPcn22g0QX/0bv6kRRtK9xmOkrhXV7F7g0gl/OwHV6usqozOOedUdZTWKi
         rQ9h8NiGOJNi/r09TovSuNpki28gijNOZVEjqE26eQEwCUZrRcKdYj42F+Geis/gpNTj
         AD/no11xwc+sel9GZeaiA6utZq5iiN+4KIv+BOsbe6z0UZioQ/MVIJvQHJbiARUDSBLk
         cnAr37AfeabosVPHHqhTHLnQlrJEKyhoBqCeN4kipvFiEc7Avg59rEonzU6dHo15o/qK
         Ms+g/8o/4DPNUW40ji4j84UU4GI+Up1li5+TPVoSAUBwxLONMweIEZFrsIu/sY1CrLPz
         zvXQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8CgMTJVBoSZFygqx6/goGkT7YVDcrKgJJtc3MGe09EVPnOLqMvO+4hT85rI580P/JPB2CXSHRgF4r1q/EAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzldBqpA2eZF8+24ZmUC/CLYPeAFTKdY520i566DNn4pHcA8IX+
	SjecPVGJr/XMqPHA/1J8+h2uWDLVuKqUQoRpCJ7B6WvZzqe+UUSGGpXs0avEsmMOKFr5jLEAgAA
	7OU8o7dAV1++p77QInqMaafaDOt9fZ+pMsmGgRv6wYKcTASSfbnQ958E=
X-Google-Smtp-Source: AGHT+IGzh4PgGJwjcmrwuxva9h1kcWSCxlmvpZ+vONA+tG0c66jyI1Q1HBHXKXPVts4kCTwikDLaRASrCpHyk9XlIUpA9Xm7xwst
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8e:b0:3a0:a80a:997c with SMTP id
 e9e14a558f8ab-3a4d59ae1cfmr27018355ab.19.1729682489251; Wed, 23 Oct 2024
 04:21:29 -0700 (PDT)
Date: Wed, 23 Oct 2024 04:21:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6718dc39.050a0220.1e4b4d.0088.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (2)
From: syzbot <syzbot+eff0acb9087ee995577a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b04ae0f45168 Merge tag 'v6.12-rc3-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15ff7c5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=eff0acb9087ee995577a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ded240580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d04430580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b04ae0f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e40a4ec7885/vmlinux-b04ae0f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9312d8ec05d3/bzImage-b04ae0f4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/237d810e5baf/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eff0acb9087ee995577a@syzkaller.appspotmail.com

bucket 0:29 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:631!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5089 Comm: syz-executor300 Not tainted 6.12.0-rc3-syzkaller-00319-gb04ae0f45168 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_path_level_init+0x9ca/0x9f0 fs/bcachefs/btree_iter.c:631
Code: f5 fa ff ff e8 a7 73 7c fd 90 0f 0b e8 9f 73 7c fd 90 0f 0b e8 97 73 7c fd 90 0f 0b e8 8f 73 7c fd 90 0f 0b e8 87 73 7c fd 90 <0f> 0b e8 7f 73 7c fd 90 0f 0b e8 77 73 7c fd 90 0f 0b e8 6f 73 7c
RSP: 0018:ffffc9000ae2e200 EFLAGS: 00010293
RAX: ffffffff84187479 RBX: 0000000000000000 RCX: ffff88801cca8000
RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff84186ccc R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a006 R12: ffff88803d76a000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888048b60033
FS:  000055555b46c380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055f38bec7120 CR3: 0000000040558000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 btree_path_lock_root fs/bcachefs/btree_iter.c:769 [inline]
 bch2_btree_path_traverse_one+0x10de/0x2940 fs/bcachefs/btree_iter.c:1170
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2197 [inline]
 bch2_btree_iter_peek_upto+0xb58/0x70e0 fs/bcachefs/btree_iter.c:2297
 bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:685 [inline]
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1a8b/0x6e80 fs/bcachefs/btree_gc.c:1123
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
RIP: 0033:0x7f6a8cd1b93a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffa2315728 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fffa2315740 RCX: 00007f6a8cd1b93a
RDX: 0000000020000080 RSI: 0000000020000000 RDI: 00007fffa2315740
RBP: 0000000000000004 R08: 00007fffa2315780 R09: 0027e461d5230a6f
R10: 0000000000000844 R11: 0000000000000282 R12: 0000000000000844
R13: 00007fffa2315780 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_path_level_init+0x9ca/0x9f0 fs/bcachefs/btree_iter.c:631
Code: f5 fa ff ff e8 a7 73 7c fd 90 0f 0b e8 9f 73 7c fd 90 0f 0b e8 97 73 7c fd 90 0f 0b e8 8f 73 7c fd 90 0f 0b e8 87 73 7c fd 90 <0f> 0b e8 7f 73 7c fd 90 0f 0b e8 77 73 7c fd 90 0f 0b e8 6f 73 7c
RSP: 0018:ffffc9000ae2e200 EFLAGS: 00010293
RAX: ffffffff84187479 RBX: 0000000000000000 RCX: ffff88801cca8000
RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff84186ccc R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a006 R12: ffff88803d76a000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888048b60033
FS:  000055555b46c380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005654e5f57008 CR3: 0000000040558000 CR4: 0000000000352ef0
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
