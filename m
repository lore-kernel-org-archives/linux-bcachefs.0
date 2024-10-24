Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34361E2823
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729776876; cv=none; b=s7kvGwFjThHktk6ZDEEahr7IBv0Tc+jxSXoKwf1zvSdyjKQfU1A3FYR3HytXQ5BM486IEF02JZLgGxV7gxBz4PGUoFtNg1Z7l5RXYdZvOrm2RHSCFYNRcRxNu+8lF1CUa5luDNjx9hglvZnysdkdLuc/NAt4iJiA9C0Ot7Wvf6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729776876; c=relaxed/simple;
	bh=B7STI8A0on2AXJDZTaGMfnKSAa45tesnFff9IEYAj+o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HNYuNSMv1zOBj7LuRrLIRy3PHogcIVriPL8dLCRTuzzPoubagwHdE1Ov7bMkR7MLCDclXDlmxzLZvba3qLbJDuQGTer6Y1zHjURen/g7xp3gYuXy1ZmfBpHFrOLOVGB4Te1MtoTVwbRH+6MtB+0HC6FGN8vlHLY/p93/lN/hlTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3b506c87cso10385245ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 06:34:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729776873; x=1730381673;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9PFkQRgyqYFi17vOWms8BUDkuzYCo9qbODfC45UGqb4=;
        b=DVF4dz2RnJVF1F+rHG2pUPrptu9HwC9PwuXEYEpFGHh19th4cc63KYSGSnRr7dNvpx
         h7z+UpJjkjYZyQHo+s3dSgtYz+IvSkVWKor2T7V3J3c172AU7XtMWS0iEgQ5uaUwfsvL
         tA7CMXA8u+/wyffWZ6yzCK/GutAflh7VwY+wB7+oHHAhaV/PVTEQfmXaskZTcYc9QF+d
         ieysaMoj1meg6D/vcHzhRNtx7gxbLH6sShXH3NvTIJseUrF3a+DqxedIuiDvMbuBEeD6
         Q/R7MNZX8XnpXO15K3W5J61yFRNzX36bn0NRo/hHu9maoAa51uhtLg0Q26fqKxpCuJS+
         ERGA==
X-Forwarded-Encrypted: i=1; AJvYcCVDV9u6lmdzjTA/aMvNUGrVeY1xb1gf/kad1ottVB6WcpW6bPLBDbYrWLkSBeskqZBwTRxVnndiB3ZWiAV5KA==@vger.kernel.org
X-Gm-Message-State: AOJu0YywNaDzWdzdxxTZzOPaQW9yXuHo3hv9mgapyy3jVoyn+x7nTi+/
	X5Z/8pvGVmA5mR7G20LEVMQHE1hbc4GG64MDoY9u01qG2lCyf+shVecsbGlU1RhUTgHPgDbJ9Bw
	cQeIbAoQdygMN/Ad/vJ5W48Xy/YRU03jkVRD1p/AcmfIyW+pn420xMgw=
X-Google-Smtp-Source: AGHT+IG/0366/YHVHrkK63hlxWPY+MLcG6Ppw3aqHIzic5EnxhgLCWGrUUxhOAy2QPIN9EAH/5Sao/2ApmecGfub61EcIN101vzL
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c0e:b0:3a4:d9d0:55a6 with SMTP id
 e9e14a558f8ab-3a4de80b425mr22620505ab.19.1729776872693; Thu, 24 Oct 2024
 06:34:32 -0700 (PDT)
Date: Thu, 24 Oct 2024 06:34:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671a4ce8.050a0220.10f4f4.01ec.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in __bch2_fsck_err
From: syzbot <syzbot+3fb818b3513fe46fdd9f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    db87114dcf13 Merge tag 'x86_urgent_for_v6.12_rc4' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b2c25f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e543edc81a3008
dashboard link: https://syzkaller.appspot.com/bug?extid=3fb818b3513fe46fdd9f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102eec87980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b2c25f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-db87114d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ed43c6fe28c9/vmlinux-db87114d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9daa175d852f/bzImage-db87114d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bd3bf62c0047/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3fb818b3513fe46fdd9f@syzkaller.appspotmail.com

RBP: 0000000000000002 R08: 00007ffd4defb476 R09: 00007ffd4defb720
R10: 0000000000000002 R11: 0000000000000246 R12: 00007ffd4defb6fc
R13: 0000000000000004 R14: 431bde82d7b634db R15: 00007ffd4defb740
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xdffffc001fffffff: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: probably user-memory-access in range [0x00000000fffffff8-0x00000000ffffffff]
CPU: 0 UID: 0 PID: 5139 Comm: syz-executor157 Not tainted 6.12.0-rc3-syzkaller-00454-gdb87114dcf13 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bch2_fsck_err+0x321/0x15f0 fs/bcachefs/error.c:267
Code: 03 49 bd 00 00 00 00 00 fc ff df 43 8a 04 2e 84 c0 0f 85 3b 11 00 00 8b 9c 24 0c 01 00 00 ff cb 4c 01 e3 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 3a 11 00 00 0f b6 1b bf 3f 00 00 00 89 de
RSP: 0018:ffffc900025259e0 EFLAGS: 00010207
RAX: 000000001fffffff RBX: 00000000ffffffff RCX: 1ffff920004a4b5c
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000020
RBP: ffffc90002525ba0 R08: ffffffff8443ea4d R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d4a3e3 R12: 0000000000000000
R13: dffffc0000000000 R14: 1ffff920004a4b5d R15: ffffc90002525aec
FS:  000055558bcce380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe8b6d58580 CR3: 000000003c5ec000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bucket_ref_update+0x8ae/0x12d0 fs/bcachefs/buckets.c:469
 __mark_pointer fs/bcachefs/buckets.c:551 [inline]
 bch2_trigger_pointer fs/bcachefs/buckets.c:590 [inline]
 __trigger_extent+0x1173/0x4fa0 fs/bcachefs/buckets.c:740
 bch2_trigger_extent+0x585/0xaa0 fs/bcachefs/buckets.c:869
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_key_trigger_old fs/bcachefs/bkey_methods.h:101 [inline]
 run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:512 [inline]
 run_btree_triggers+0xb37/0x1270 fs/bcachefs/btree_trans_commit.c:540
 bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:572 [inline]
 __bch2_trans_commit+0x369/0x93c0 fs/bcachefs/btree_trans_commit.c:1057
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_extent_update+0x4c0/0xbb0 fs/bcachefs/io_write.c:325
 bch2_fpunch_at+0x882/0x1020 fs/bcachefs/io_misc.c:184
 __bch2_resume_logged_op_truncate+0x772/0xab0 fs/bcachefs/io_misc.c:262
 bch2_truncate+0x1c8/0x2d0 fs/bcachefs/io_misc.c:297
 bchfs_truncate+0x85f/0xc90 fs/bcachefs/fs-io.c:464
 notify_change+0xbca/0xe90 fs/attr.c:503
 do_truncate+0x220/0x310 fs/open.c:65
 handle_truncate fs/namei.c:3395 [inline]
 do_open fs/namei.c:3778 [inline]
 path_openat+0x2e1e/0x3590 fs/namei.c:3933
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_creat fs/open.c:1506 [inline]
 __se_sys_creat fs/open.c:1500 [inline]
 __x64_sys_creat+0x123/0x170 fs/open.c:1500
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa5cfadec99
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 1b 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd4defb6d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
RAX: ffffffffffffffda RBX: 00007ffd4defb700 RCX: 00007fa5cfadec99
RDX: 00007fa5cfaddd60 RSI: 0000000000000000 RDI: 00000000200000c0
RBP: 0000000000000002 R08: 00007ffd4defb476 R09: 00007ffd4defb720
R10: 0000000000000002 R11: 0000000000000246 R12: 00007ffd4defb6fc
R13: 0000000000000004 R14: 431bde82d7b634db R15: 00007ffd4defb740
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_fsck_err+0x321/0x15f0 fs/bcachefs/error.c:267
Code: 03 49 bd 00 00 00 00 00 fc ff df 43 8a 04 2e 84 c0 0f 85 3b 11 00 00 8b 9c 24 0c 01 00 00 ff cb 4c 01 e3 48 89 d8 48 c1 e8 03 <42> 8a 04 28 84 c0 0f 85 3a 11 00 00 0f b6 1b bf 3f 00 00 00 89 de
RSP: 0018:ffffc900025259e0 EFLAGS: 00010207
RAX: 000000001fffffff RBX: 00000000ffffffff RCX: 1ffff920004a4b5c
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000020
RBP: ffffc90002525ba0 R08: ffffffff8443ea4d R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d4a3e3 R12: 0000000000000000
R13: dffffc0000000000 R14: 1ffff920004a4b5d R15: ffffc90002525aec
FS:  000055558bcce380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe8b6d58580 CR3: 000000003c5ec000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
   7:	fc ff df
   a:	43 8a 04 2e          	mov    (%r14,%r13,1),%al
   e:	84 c0                	test   %al,%al
  10:	0f 85 3b 11 00 00    	jne    0x1151
  16:	8b 9c 24 0c 01 00 00 	mov    0x10c(%rsp),%ebx
  1d:	ff cb                	dec    %ebx
  1f:	4c 01 e3             	add    %r12,%rbx
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 8a 04 28          	mov    (%rax,%r13,1),%al <-- trapping instruction
  2d:	84 c0                	test   %al,%al
  2f:	0f 85 3a 11 00 00    	jne    0x116f
  35:	0f b6 1b             	movzbl (%rbx),%ebx
  38:	bf 3f 00 00 00       	mov    $0x3f,%edi
  3d:	89 de                	mov    %ebx,%esi


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
