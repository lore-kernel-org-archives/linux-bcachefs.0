Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112B180A65
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223562; cv=none; b=sLcBXRqZyQ4gy4J2ke2ELaGSODEKpJCwsbK97t0gG8EwUqIK7nGw97OLw0wz9TU80duvU/z7j2dgB+RUzN1mt52XMv2SA8or2Kz6LjltdyAcg2KNW0JLZtHMcbvbYTPRDi8tG4DZzVbdBqWNq8qqrbLHE4Pa6DbDbfA+IkdJYk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223562; c=relaxed/simple;
	bh=8NPf8ai7sO0e5DxJuw+CJCqz7HvOUn+DTNM2pBx4/qI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gynmTairr5g2FdQ+SClQZnC9g1gZ+xz5+GExStV16NN0z3AAxXzoqPALxa+1gVRqvMSSlw4JyYbmx9x9CrVfZUP7osdDDI1OBhQj7a8gDVXqNMxRfEdSxH7ZwOu3ibuurmRAgWaE8tbVuqp3Adb8zLWqhvdsbmXydKlpf350R7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81257dec573so137521539f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 06:39:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721223560; x=1721828360;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GvmIgyL4P2emGOTNThKhMflfj36qHDI5EsWsK7i9RC8=;
        b=sYmUisteJcF2sgHUDo7stkFpeam2yE13jonqTzdkFpv82S8Epe9RBahUeBRjnefOX6
         NpQjTlQbZde7aK0m7OK2pP1awEbqLLvm8NGoA34ofJox3gfU8gYfBOljZOG9z8vki+RR
         v0wSsPFeuOqIeFoExVGmYG0EYC0E/omD+Xjx2w4QT/NQKrH7ldGRILYmUJDZCd1ZxLm6
         V4za6IvaPJW0b6jRFSXOWnJjc97Ga8HAIi9RwTl/aFkleIC5xvoJAaWZUYRRCbeye+f3
         /FuySVqfxcz4QFE6gC2iyuca7wj3cf1PYmPPJCIryzebDYX0bpaX+CQWXzeJZyTmAJVe
         /nHA==
X-Forwarded-Encrypted: i=1; AJvYcCWtvSrc3X61Swfcp0dsrC/Xwa/atAF1kq+WRsWfgpEDHyAaoGhPIM0XAr47K1PZyj0r/f/KrcwZkv+bIr9sUcrnrmfHs90gYSBG/8S0tIs=
X-Gm-Message-State: AOJu0Yx7cSKxuZUHDXncWsKsY4H3R1RdgynxNKAcugWkU4JdDBNCTfHz
	Vp7cyJP0IZeNGRklUUQ+8NT40LrguJKr4Cy+3LnfizRXVwPZsJheBK/jyCl1bXqy3ei80Xucyfr
	2J3hvJVUBfK64Y/kMyMQYvZHng7IFgcdCj1bxiBxZJCmE8D2KY7i6uYg=
X-Google-Smtp-Source: AGHT+IGMvpqviRtnvpnfw7SCED1nyEmJ/xgUnRUzSK0PLOqPQ4K+RBeD75Vxks0EzjVOM8mePTAf+RjRgBleRijhfa0BfWCMvl/L
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:370c:b0:4be:d44b:de24 with SMTP id
 8926c6da1cb9f-4c2158e720cmr78694173.2.1721223560350; Wed, 17 Jul 2024
 06:39:20 -0700 (PDT)
Date: Wed, 17 Jul 2024 06:39:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e4d9eb061d719657@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_checksum
From: syzbot <syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0434dbe32053 Merge tag 'linux_kselftest-next-6.11-rc1' of ..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16061f4e980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b8bd5292e033239
dashboard link: https://syzkaller.appspot.com/bug?extid=dd3d9835055dacb66f35
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10d9ccb5980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12633a79980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3766752b5090/disk-0434dbe3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3608abc3f91/vmlinux-0434dbe3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c133560ad498/bzImage-0434dbe3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/ff0cf9ecbd00/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dd3d9835055dacb66f35@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
Oops: general protection fault, probably for non-canonical address 0xdffffc000000900d: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: probably user-memory-access in range [0x0000000000048068-0x000000000004806f]
CPU: 0 PID: 5080 Comm: syz-executor457 Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:gen_poly_key fs/bcachefs/checksum.c:191 [inline]
RIP: 0010:bch2_checksum+0x1c5/0x770 fs/bcachefs/checksum.c:227
Code: f6 e8 3f c5 dc fd 48 8b 44 24 28 4c 8d b0 68 80 04 00 ba 20 00 00 00 48 8d 7c 24 60 31 f6 e8 22 c5 dc fd 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 3c c2 dc fd 49 8b 3e 48 b8 00 00
RSP: 0018:ffffc90003536d40 EFLAGS: 00010202
RAX: 000000000000900d RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003536dc0
RBP: ffffc900035370b0 R08: ffffc90003536dbf R09: 0000000000000000
R10: ffffc90003536da0 R11: fffff520006a6db8 R12: ffffc90003536de0
R13: dffffc0000000000 R14: 0000000000048068 R15: 1ffff920006a6db0
FS:  000055558465b380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005568164b48e0 CR3: 0000000020ce4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 read_one_super+0xd87/0xf40 fs/bcachefs/super-io.c:673
 __bch2_read_super+0x873/0x1370 fs/bcachefs/super-io.c:751
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2082
 bch2_mount+0x6b0/0x13c0 fs/bcachefs/fs.c:1931
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb9e3d106a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd63a40f78 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd63a40f90 RCX: 00007feb9e3d106a
RDX: 0000000020005b00 RSI: 0000000020000040 RDI: 00007ffd63a40f90
RBP: 0000000000000004 R08: 00007ffd63a40fd0 R09: 0000000000005b4e
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffd63a40fd0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:gen_poly_key fs/bcachefs/checksum.c:191 [inline]
RIP: 0010:bch2_checksum+0x1c5/0x770 fs/bcachefs/checksum.c:227
Code: f6 e8 3f c5 dc fd 48 8b 44 24 28 4c 8d b0 68 80 04 00 ba 20 00 00 00 48 8d 7c 24 60 31 f6 e8 22 c5 dc fd 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 3c c2 dc fd 49 8b 3e 48 b8 00 00
RSP: 0018:ffffc90003536d40 EFLAGS: 00010202
RAX: 000000000000900d RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003536dc0
RBP: ffffc900035370b0 R08: ffffc90003536dbf R09: 0000000000000000
R10: ffffc90003536da0 R11: fffff520006a6db8 R12: ffffc90003536de0
R13: dffffc0000000000 R14: 0000000000048068 R15: 1ffff920006a6db0
FS:  000055558465b380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005568163d0fb0 CR3: 0000000020ce4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 3f c5 dc fd       	call   0xfddcc544
   5:	48 8b 44 24 28       	mov    0x28(%rsp),%rax
   a:	4c 8d b0 68 80 04 00 	lea    0x48068(%rax),%r14
  11:	ba 20 00 00 00       	mov    $0x20,%edx
  16:	48 8d 7c 24 60       	lea    0x60(%rsp),%rdi
  1b:	31 f6                	xor    %esi,%esi
  1d:	e8 22 c5 dc fd       	call   0xfddcc544
  22:	4c 89 f0             	mov    %r14,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 f7             	mov    %r14,%rdi
  33:	e8 3c c2 dc fd       	call   0xfddcc274
  38:	49 8b 3e             	mov    (%r14),%rdi
  3b:	48                   	rex.W
  3c:	b8                   	.byte 0xb8


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
