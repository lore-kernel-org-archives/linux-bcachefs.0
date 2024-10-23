Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F1E136338
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 04:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729656753; cv=none; b=rj/5TH51bWdmIr+uEvLQJDTaL9t43MDuB4J67vspk6oenwVZ12wzhfLYzn+8q1HVP+Mb17FHx52AWwSjKPXMF9GOQmfq+w52eMPKZuqpmMvj0p3Nv0NAmuJ6qNP0jLQTAY8J6vHqbLpkJzJrjuMkeVk4vsUueZ4h++W0nohb/I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729656753; c=relaxed/simple;
	bh=xdfnBrQH/bPWIfgOGShd6kh3AFBADqOxfA86FupkZAY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=PIdH6ere/EyHtErTJmRUfpMcjNn7+Xs0BnrTdkEuOoATKAHOYUz0ocUpUMeucRawH51DXxHjE5ajS2vREVfNZvl+X2fd4Zw6nmsaW02Ap6JbWlpJ51Q5vACDgCVz7d3wkll5GukSF4XooU6pvyYDh2ixm8qe77ry0vZAISBc+lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a3a5f6cb13so54810915ab.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 22 Oct 2024 21:12:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729656751; x=1730261551;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t8CxMGBnRejRLhYDFtNNtObU4IE/ZxQNen+BJxCLAJY=;
        b=sEEa6VsdYrdIZlJyjrtGYW7zpU11FxhBnr/wp7sI7JNIQqXUi9uulsnBjoEc/PzjBr
         DuNjs8m6Ce0cvzCLsX0+NdHwfp+xYjnUlEeKx369xskL9AcgwLkYnlm7x9HVNTaowzst
         NHhd1QDz9zXzbxxNOeOEylUppIJyxGxEzHmNuRlFlyH6dZ29OFozOyyaZNJPivGJ/2Sa
         H/SSO2Twc8kg2o8mfAMz3CCfVcwB3iFOljTYnTESY1UyQ0A1QoUoRQA7ENmAtPmgrzbZ
         pbeTvlljhCco26S0p6CPAQJHbQjdEBmdzarLex8nI8ulzisWw/JeHqfTpZUSSx32+XCV
         7GBA==
X-Forwarded-Encrypted: i=1; AJvYcCX3BiG7eFLV4J799zlbRyp7xwQiNJ75qPfgD19P6OPvs+alC4p2H+rZxRgdxt2OBLxfM8BOqVtnRRTWqdvW/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxF+Xsd3GAGnGwIAoMF/2hYO15aYHTnaA+5M9DpOZF7hNv8MVQn
	h+jCgOPyeH2/xltZY/+VhVLzpSmS84EavWqFUUnua3NmuACIrrcKNKAAHiTgr2KM1uNvIIUHSXO
	9MfdDJ1wmnfEYg96WZYCEGwcEtF0SsuMkM1H7HwCB+/FB/sA3oD/PjkU=
X-Google-Smtp-Source: AGHT+IH0+j4HopetIp2b8kzJCZxYLO810Tia0x1elzUgQoQpHuYarqMZKJVXDocRbxPL7gtfxFvPcCT3KrMtFZIzG7gpqxjH0KBx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2169:b0:3a3:f82d:ba43 with SMTP id
 e9e14a558f8ab-3a4d5a17b54mr12336285ab.25.1729656750916; Tue, 22 Oct 2024
 21:12:30 -0700 (PDT)
Date: Tue, 22 Oct 2024 21:12:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671877ae.050a0220.1e4b4d.0084.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_ptr_swab
From: syzbot <syzbot+4f29c3f12f864d8a8d17@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b04ae0f45168 Merge tag 'v6.12-rc3-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14bfbc5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=4f29c3f12f864d8a8d17
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11241f27980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bfbc5f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b04ae0f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e40a4ec7885/vmlinux-b04ae0f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9312d8ec05d3/bzImage-b04ae0f4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4ecaa2a54f31/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4f29c3f12f864d8a8d17@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/extents.h:62!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5090 Comm: syz-executor228 Not tainted 6.12.0-rc3-syzkaller-00319-gb04ae0f45168 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:extent_entry_type fs/bcachefs/extents.h:62 [inline]
RIP: 0010:bch2_ptr_swab+0x4f6/0x510 fs/bcachefs/extents.c:1313
Code: 60 60 cf fd e9 ae fb ff ff 44 89 f1 80 e1 07 38 c1 0f 8c 5f fc ff ff 4c 89 f7 e8 45 60 cf fd e9 52 fc ff ff e8 db aa 65 fd 90 <0f> 0b e8 d3 aa 65 fd 90 0f 0b e8 cb aa 65 fd 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc9000aee64a0 EFLAGS: 00010293
RAX: ffffffff842f3d25 RBX: 0000000000000024 RCX: ffff888000d22440
RDX: 0000000000000000 RSI: 0000000000000024 RDI: 0000000000000005
RBP: 1e0e005000000000 R08: ffffffff842f3a13 R09: ffffffff842f387e
R10: 0000000000000005 R11: ffff888000d22440 R12: dffffc0000000000
R13: ffff888047881050 R14: ffff888047881060 R15: 1ffff11008f1020a
FS:  000055557cc8e380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b528cde220 CR3: 000000004105a000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bkey_swab_val fs/bcachefs/bkey_methods.c:323 [inline]
 __bch2_bkey_compat+0x4a2/0xfe0 fs/bcachefs/bkey_methods.c:469
 bch2_bkey_compat fs/bcachefs/bkey_methods.h:133 [inline]
 validate_bset_keys+0x617/0x1610 fs/bcachefs/btree_io.c:908
 bch2_btree_node_read_done+0x2402/0x5e90 fs/bcachefs/btree_io.c:1134
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
 bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
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
RIP: 0033:0x7ff1b36c0b7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc62e862b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc62e862d0 RCX: 00007ff1b36c0b7a
RDX: 0000000020000000 RSI: 0000000020005900 RDI: 00007ffc62e862d0
RBP: 0000000000000004 R08: 00007ffc62e86310 R09: 000000000000590d
R10: 0000000000010000 R11: 0000000000000282 R12: 0000000000010000
R13: 00007ffc62e86310 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:extent_entry_type fs/bcachefs/extents.h:62 [inline]
RIP: 0010:bch2_ptr_swab+0x4f6/0x510 fs/bcachefs/extents.c:1313
Code: 60 60 cf fd e9 ae fb ff ff 44 89 f1 80 e1 07 38 c1 0f 8c 5f fc ff ff 4c 89 f7 e8 45 60 cf fd e9 52 fc ff ff e8 db aa 65 fd 90 <0f> 0b e8 d3 aa 65 fd 90 0f 0b e8 cb aa 65 fd 90 0f 0b 0f 1f 84 00
RSP: 0018:ffffc9000aee64a0 EFLAGS: 00010293
RAX: ffffffff842f3d25 RBX: 0000000000000024 RCX: ffff888000d22440
RDX: 0000000000000000 RSI: 0000000000000024 RDI: 0000000000000005
RBP: 1e0e005000000000 R08: ffffffff842f3a13 R09: ffffffff842f387e
R10: 0000000000000005 R11: ffff888000d22440 R12: dffffc0000000000
R13: ffff888047881050 R14: ffff888047881060 R15: 1ffff11008f1020a
FS:  000055557cc8e380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b528cde220 CR3: 000000004105a000 CR4: 0000000000352ef0
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
