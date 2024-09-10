Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74D175D2D
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 08:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725956193; cv=none; b=O/svamzKjM2cxi0tWbnfi9C3P650YWH9a9zLtMbkcylQyoF56cTBUobtIMHPgNvsxwk0JZxqgHQWjRPg2Q7M3QpanX13xDGFmdOu2BxQjxiIhUKHCZDslZmo8/iYjsrdccSNDaWf7FSlm2hzHJuqHen4gIY6gfLwQXsdnOqnzbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725956193; c=relaxed/simple;
	bh=JT0uGObE3hHGkn69SZSYQqxGHGrhfUswQE6UB+tMF3g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ues7B7dcUspp1y/5QBiG9SAdRPCnzMzxNZgT+3cG66F1iRytQnEVAEC2e7jm6TdiMPg4jgka8KFCxN3FuHGF/KKXBE2n9EYa4HbfbQMk0Gy9llfpVhk/4KPNYsnbBNDS+Gz0wwszEHL9I4fAHaPVaZHUon/2fGtyQFosTELi3aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-39f5605c674so112452585ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Sep 2024 01:16:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725956190; x=1726560990;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2MSZ4LEhGE4vBmKibLXslNqADaXwvSq8BlZCfD0Pb14=;
        b=Z7NNdNrPR7gIJVAnfQexxLSKimNO6zMj+LcBaLN2jpdCckE/+sUhpiJqX4u2YcX0mB
         0iWUbRpYmo6YH4LsAaywkN5MWYKVPgDUHdMhzfm9tTuwMv/qpuKNFImUtqSZCmhQD/Z5
         avAdxPUnIvqCvch8XfZoxahVlQ+rsfxrgEPYhY493cHSOaILNQbAP/zZifYbX5XuiAtq
         OlqFn/8GOl4h6GWGfmVLLvsEAdqxJbvZkhagGYKvs+jd59LcSJNE0gP4EZ8BrpovmW7c
         Iu7ers9UIjId0QVNnPWq3U95DFpaRTmTMiVm3Hd5DZ/sq0UwV/VgnC8ncy6d72lgB5S0
         rzzg==
X-Forwarded-Encrypted: i=1; AJvYcCUmcC75q0mBbOO3Ze9jv59lUSGD538DRcijghQjdD9fQMbgV1ZXGoMAqiE0N3Oqk64FDHExg8izmOpSOrXRFw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsZfW/GkBlCQAPaYmzEV5JDrBT4A2TEOayx3jC+sUNIEaYYest
	hiN5MpixJuMRv2QvBOtFFi/evREzVlNrJ2TajYn2g0IAejIX3pjs8y4t1BEd8x+IMzB1mwsDZHU
	5xw9R5fr3nxOiePovWyPISv9Sx7+0R8TbkH5N3XJRzstdsknDCOCn5fE=
X-Google-Smtp-Source: AGHT+IFLrGSpH6bukg7AFXjeHV/rB5H7JypPdwx7pr7PyihDLwvg+PYqkW0755CZRnpF8ExmTPwEwwj6OihoCFEzyvg8srJYPC0k
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c246:0:b0:37a:a9f0:f263 with SMTP id
 e9e14a558f8ab-3a04f0cce6cmr160358415ab.20.1725956190074; Tue, 10 Sep 2024
 01:16:30 -0700 (PDT)
Date: Tue, 10 Sep 2024 01:16:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009b8cd30621bf7d02@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_fs_recovery
From: syzbot <syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    bc83b4d1f086 Merge tag 'bcachefs-2024-09-09' of git://evil..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15f7449f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=61d235cb8d15001c
dashboard link: https://syzkaller.appspot.com/bug?extid=1cecc37d87c4286e5543
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10083f29980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=144da807980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-bc83b4d1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a07cb707943e/vmlinux-bc83b4d1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/35f99272bee1/bzImage-bc83b4d1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1483a93cc3a3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1cecc37d87c4286e5543@syzkaller.appspotmail.com

bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=errors=continue,metadata_checksum=xxhash,data_checksum=none,compression=lz4,background_compression=lz4,erasure_code,noinodes_use_key_cache,grpquota,nojournal_transaction_names,nocow
superblock marked clean but clean section not present, fixing
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 5108 Comm: syz-executor340 Not tainted 6.11.0-rc7-syzkaller-00017-gbc83b4d1f086 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_fs_recovery+0x274/0x38b0 fs/bcachefs/recovery.c:644
Code: 00 00 4c 89 f7 48 c7 c6 20 72 54 8c e8 85 d6 05 00 eb 41 e8 6e 55 55 fd 49 8d 9d cc 01 00 00 49 83 c7 10 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 fd 9c bc fd 49 8b 0f 4c 89 ef 48
RSP: 0018:ffffc90002e4f5c0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff8880441801cc RCX: ffff88801fd34880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002e4f968 R08: ffffffff843e3700 R09: 1ffff920005c9e9c
R10: dffffc0000000000 R11: fffff520005c9e9d R12: dffffc0000000000
R13: ffff888044180000 R14: ffff888044180777 R15: 0000000000000010
FS:  000055555e2a1380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561b4e028808 CR3: 0000000036192000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
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
RIP: 0033:0x7f6adfe3626a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff810bb308 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff810bb320 RCX: 00007f6adfe3626a
RDX: 00000000200058c0 RSI: 0000000020000080 RDI: 00007fff810bb320
RBP: 0000000000000004 R08: 00007fff810bb360 R09: 0000000000005905
R10: 0000000000008000 R11: 0000000000000282 R12: 0000000000008000
R13: 00007fff810bb360 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fs_recovery+0x274/0x38b0 fs/bcachefs/recovery.c:644
Code: 00 00 4c 89 f7 48 c7 c6 20 72 54 8c e8 85 d6 05 00 eb 41 e8 6e 55 55 fd 49 8d 9d cc 01 00 00 49 83 c7 10 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 fd 9c bc fd 49 8b 0f 4c 89 ef 48
RSP: 0018:ffffc90002e4f5c0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff8880441801cc RCX: ffff88801fd34880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90002e4f968 R08: ffffffff843e3700 R09: 1ffff920005c9e9c
R10: dffffc0000000000 R11: fffff520005c9e9d R12: dffffc0000000000
R13: ffff888044180000 R14: ffff888044180777 R15: 0000000000000010
FS:  000055555e2a1380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561b4e028808 CR3: 0000000036192000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	4c 89 f7             	mov    %r14,%rdi
   5:	48 c7 c6 20 72 54 8c 	mov    $0xffffffff8c547220,%rsi
   c:	e8 85 d6 05 00       	call   0x5d696
  11:	eb 41                	jmp    0x54
  13:	e8 6e 55 55 fd       	call   0xfd555586
  18:	49 8d 9d cc 01 00 00 	lea    0x1cc(%r13),%rbx
  1f:	49 83 c7 10          	add    $0x10,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 fd 9c bc fd       	call   0xfdbc9d36
  39:	49 8b 0f             	mov    (%r15),%rcx
  3c:	4c 89 ef             	mov    %r13,%rdi
  3f:	48                   	rex.W


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
