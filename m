Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4A51DF250
	for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 15:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732288531; cv=none; b=VyZ6JQetthRLVbyzF/rAuEtmbjVovD9tVbvRf/adwkFqG36S7u1uHMhZzO/JK2si1Znxg08l1pDSoGANNwPo7MMNOVq+iic4A6Y4BFXRtzYnyoBfMkJlEJvcwZqFoHNJwLZ3/sz+jJNtpLBeZr9dR9VhDzKAwWE5/jwoUYEq0xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732288531; c=relaxed/simple;
	bh=oN0L2IfFqn8dgguJt5GAXgrQutSDbbE1W0kt61DJyUE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EqnoA5Vesk/S/ZpdTrJQHpOtcKmzp3r3X9PsJ1cbQaZTqr246x3hePWHvMQleooeDiip7wfLmA9v3Igp08QD2It/YnHseiDnPEK870UVkSv37hbBSGBjMjSm+VEtz4gVAb86JqC6XhyWBZUoXgDXl4XtnDZOkGtMYtXkmFuv+Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a7a5031e75so4075515ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 07:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732288528; x=1732893328;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A4ApWgkuG2A4yHHfw0Btk1g0uYsFp0LrAS1btN9va/c=;
        b=LHD13o8fQukiV+ETKJKuCRspUGm1U131q+frOpGaf/ub1gQftP5FkObdBQcvT2bg4Z
         IBbZKKH24Jpia630DcIY3cg/ZCxibqYSLPWYMpVYrl7Qqfhiq5hlLwYkl7AY55ngXZlV
         ZJb9G0FFHgvDvCqtmSDUBJK6aBoI6dbQNLLVgQtXO3XFpp6QPM00BAnfi15DruLUpWxT
         LSNYpLVzNjmXzag4M7yK8DLD+gquWyF4JiSWq7Aa0asGsLgGw+MtlpNWIqXztzflch8y
         H5SV9Mz3SCI5K1FQZ3hErAC4hIR0Yl2STFUKQYAV5ZlmKqza8WOdERrBZiFVd8xUwfGg
         Jy5Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/v2vsLPpIn3AfLLr2Rizu8FZx/n/6jr4V3utonIEu54ZqOzvBf1VAnNbXKVn1hBN1RKDt0FIlgB5S9fhvrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIthh6w5v2Xu7VwW01QqMDHiGotBoOFn0gnGNi6VPYckL08QAg
	I0zoJ4igXhL5t6wbKEqGHOz13/fHx3dl0wfcKPKThi9nx6UM/BJux8PVYsY1pvce2Uhx8d77w7x
	PjOVFhu9AQe3nuOYrSRLtTYf0pbC3iu/SNavEQ+gtQPWieTF2u6QZDtM=
X-Google-Smtp-Source: AGHT+IEc9btm7pI63XggMYhAvLFULbcqsnxksoNQygWIsiHcx25bmfcIm3rZKuhGGsjn/Ocl80j/ICWPpQeDWie2TTPWDmJ09r/4
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b43:b0:3a7:1a65:2fbc with SMTP id
 e9e14a558f8ab-3a79afde78bmr39476025ab.23.1732288524974; Fri, 22 Nov 2024
 07:15:24 -0800 (PST)
Date: Fri, 22 Nov 2024 07:15:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6740a00c.050a0220.363a1b.0145.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_root_read
From: syzbot <syzbot+c4b76ec6c2d45b06ec1e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel..=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D150afae8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Daabf8d2f67b7072=
a
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dc4b76ec6c2d45b06e=
c1e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1692a75f98000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D15965930580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-43fb83c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8ce8ef813dfe/vmlinux-=
43fb83c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dbfeb37f6bfa/bzI=
mage-43fb83c1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bc470092719b=
/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+c4b76ec6c2d45b06ec1e@syzkaller.appspotmail.com

bcachefs (loop0): will run btree node scan
invalid bkey u64s 7 type xattr 536870912:3798421620223919902:U32_MAX len 0 =
ver 0: user.=06:
  xattr name has invalid characters: delete?, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_io.c:1743!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5326 Comm: syz-executor408 Not tainted 6.12.0-syzkaller-=
03657-g43fb83c17ba2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_btree_root_read fs/bcachefs/btree_io.c:1743 [inline]
RIP: 0010:bch2_btree_root_read+0x78d/0x7a0 fs/bcachefs/btree_io.c:1771
Code: ff 44 89 f1 80 e1 07 38 c1 0f 8c 98 fa ff ff 4c 89 f7 e8 b6 87 e6 fd =
e9 8b fa ff ff e8 6c 73 7c fd 90 0f 0b e8 64 73 7c fd 90 <0f> 0b e8 ec ab b=
2 07 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
RSP: 0018:ffffc9000ceaf3a0 EFLAGS: 00010293
RAX: ffffffff8418856c RBX: 00000000ffffffef RCX: ffff888000728000
RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
RBP: ffffc9000ceaf4e0 R08: ffffffff841883b1 R09: 1ffff920019d5e5c
R10: dffffc0000000000 R11: fffff520019d5e5d R12: ffff88804384f000
R13: 0000000000023001 R14: ffff888044a01a80 R15: 0000000000000000
FS:  000055558b9ee380(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff9e053fe8 CR3: 0000000042fb4000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd48bf0c9ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdbfdd4698 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdbfdd46b0 RCX: 00007fd48bf0c9ba
RDX: 00000000200058c0 RSI: 0000000020000000 RDI: 00007ffdbfdd46b0
RBP: 0000000000000004 R08: 00007ffdbfdd46f0 R09: 000000000000596c
R10: 0000000000210008 R11: 0000000000000282 R12: 0000000000210008
R13: 00007ffdbfdd46f0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_btree_root_read fs/bcachefs/btree_io.c:1743 [inline]
RIP: 0010:bch2_btree_root_read+0x78d/0x7a0 fs/bcachefs/btree_io.c:1771
Code: ff 44 89 f1 80 e1 07 38 c1 0f 8c 98 fa ff ff 4c 89 f7 e8 b6 87 e6 fd =
e9 8b fa ff ff e8 6c 73 7c fd 90 0f 0b e8 64 73 7c fd 90 <0f> 0b e8 ec ab b=
2 07 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90
RSP: 0018:ffffc9000ceaf3a0 EFLAGS: 00010293
RAX: ffffffff8418856c RBX: 00000000ffffffef RCX: ffff888000728000
RDX: 0000000000000000 RSI: 00000000ffffffef RDI: 0000000000000000
RBP: ffffc9000ceaf4e0 R08: ffffffff841883b1 R09: 1ffff920019d5e5c
R10: dffffc0000000000 R11: fffff520019d5e5d R12: ffff88804384f000
R13: 0000000000023001 R14: ffff888044a01a80 R15: 0000000000000000
FS:  000055558b9ee380(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff9e053fe8 CR3: 0000000042fb4000 CR4: 0000000000352ef0
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
