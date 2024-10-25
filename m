Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7E118E029
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 06:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838913; cv=none; b=NcxsGQcm1orPcb3bMFqDllvRp/kMmsYBRrT1XR8EF8qSC4Fa74GuLJiRO38PHsaw33LvdcQsK9lMWiGbXp9YFeSfs5RAVSbLSI7dSCyZ5HCAZWoiloXP2xzIYdO65dSwqqVgI5avR2R6znrZRdYyXLKFtHQCOS4AIfZ2qJx5mSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838913; c=relaxed/simple;
	bh=NXJ5Q8l8Vi8Bo2tqa01yUQxn7Bzkn9FEZNVBr9+o5Uc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=onGj/4r1klkZw5uchheBkzT19CKwbw5ntjOwJ7PhlWmLkUo5z4rt70w9wnFTbZIW1/pe5zeW03oS0HlcoKNT31w0qmic1cB8a2Md0Sw0QuhheXW/ZJOAo3v4qfje9fH0NNyUlMOlryVmn2a/hwHcZtm4zfdqj54qLAlTt61Ub/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-83ab434c629so158239639f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 23:48:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838910; x=1730443710;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kjpesi43ZtnpGfZMG7/6p241qNZ/QUOcTdIlkJa4kaE=;
        b=hoaaxEUdXIZR6bCjB62A8N8m+ia83q/BH1+cgm70k1lWOz1g0O4zdCQWKjM7bSCssd
         EYnHEJqPUYBfagPN8EdzY5xM5LTOl6UFwm43nB9SgoP4QKvLabbXfqX/75JBeDlhFNmf
         LkebaKoB04jaLYD1vTBEd1hIUEDhjCo9Neeb744LSpqfo0AIGcA29lF5dFSS5/+gJbYY
         +s8tqZBI3zbVLY2ldQ4f/oI2Re6qfUiUpr34xPdLHBxoxO5flNnlilAZQfv/BgwVhk+B
         cn2fiauSDYUXImEsqDDhZUxMt7+RFzgouIvWdAQAs+wZhyRiDXIgd8QN70Vicp4m0GEZ
         hnbQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/WpeXSUveopTaRBTURMxZUbnZ7fUrYNr3Oz0MDV9sn1FFrFTOU8r0LAyjXzY8xAn2cV/bUqzDzr9h2wcUQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwX7bmcUbP0b4or080Mlh96H5jlA8DPQ/ThrXWKCSX00N6bqKmo
	SAX43Cvg9AP3m6netGA7kF43N94JaOYRtAiZTkBqiVNV351w7Sp1+89CU0c+BnJBnGW9Svm7uAb
	GCLM38pN7/rV3eaY5lGNgta0hxk6kWGpJB6DYZVSLED+oYyOOq6WYrbc=
X-Google-Smtp-Source: AGHT+IEUOZ+2LPDyfKS5+wy9it4t61yy3mYlMA0Eo0EQEaThVfgJMc4Ycjj8+vG46HRIheRggEwgvQ5eqN1qaKBOnYbr9+U8PnYo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aac:b0:3a3:9792:e9e8 with SMTP id
 e9e14a558f8ab-3a4d592c8famr91855645ab.5.1729838910123; Thu, 24 Oct 2024
 23:48:30 -0700 (PDT)
Date: Thu, 24 Oct 2024 23:48:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671b3f3e.050a0220.2eb763.00d4.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_btree_path_traverse_one
From: syzbot <syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=126cd0a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=e22007d6acb9c87c2362
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=166cd0a7980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15378287980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1b5cb4a585a3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e22007d6acb9c87c2362@syzkaller.appspotmail.com

bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations... done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000013: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000098-0x000000000000009f]
CPU: 0 UID: 0 PID: 5090 Comm: syz-executor250 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:btree_path_lock_root fs/bcachefs/btree_iter.c:732 [inline]
RIP: 0010:bch2_btree_path_traverse_one+0x94a/0x2940 fs/bcachefs/btree_iter.c:1170
Code: 89 44 24 60 42 80 3c 20 00 74 08 4c 89 ef e8 cd ea e5 fd 49 8b 45 00 48 89 44 24 48 48 8d 90 98 00 00 00 48 89 d0 48 c1 e8 03 <42> 0f b6 04 20 84 c0 48 89 94 24 80 00 00 00 0f 85 ee 10 00 00 4c
RSP: 0018:ffffc9000aebcf40 EFLAGS: 00010202
RAX: 0000000000000013 RBX: 0000000000000000 RCX: ffff8880008da440
RDX: 0000000000000098 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000aebd230 R08: ffffffff8418b260 R09: ffffffff841892d9
R10: 0000000000000002 R11: ffff8880008da440 R12: dffffc0000000000
R13: ffff888041d014d8 R14: ffff888040254408 R15: 000000000000110b
FS:  0000555564217380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005564fb1350d0 CR3: 0000000040b92000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2197 [inline]
 bch2_btree_iter_peek_upto+0xb58/0x70e0 fs/bcachefs/btree_iter.c:2297
 bch2_btree_iter_peek_upto_type fs/bcachefs/btree_iter.h:685 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:491 [inline]
 bch2_bucket_alloc_trans+0x1122/0x3a50 fs/bcachefs/alloc_foreground.c:644
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:804
 __open_bucket_add_buckets+0x10dc/0x1b60 fs/bcachefs/alloc_foreground.c:1049
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1093
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:343 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:554
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1252
 bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
 bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_journal_replay+0x1a3a/0x2a40 fs/bcachefs/recovery.c:318
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
 bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
 bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a8f435cba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0b30fb48 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc0b30fb60 RCX: 00007f4a8f435cba
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffc0b30fb60
RBP: 0000000000000004 R08: 00007ffc0b30fba0 R09: 00000000000058dd
R10: 0000000000010000 R11: 0000000000000282 R12: 0000000000010000
R13: 00007ffc0b30fba0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:btree_path_lock_root fs/bcachefs/btree_iter.c:732 [inline]
RIP: 0010:bch2_btree_path_traverse_one+0x94a/0x2940 fs/bcachefs/btree_iter.c:1170
Code: 89 44 24 60 42 80 3c 20 00 74 08 4c 89 ef e8 cd ea e5 fd 49 8b 45 00 48 89 44 24 48 48 8d 90 98 00 00 00 48 89 d0 48 c1 e8 03 <42> 0f b6 04 20 84 c0 48 89 94 24 80 00 00 00 0f 85 ee 10 00 00 4c
RSP: 0018:ffffc9000aebcf40 EFLAGS: 00010202
RAX: 0000000000000013 RBX: 0000000000000000 RCX: ffff8880008da440
RDX: 0000000000000098 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000aebd230 R08: ffffffff8418b260 R09: ffffffff841892d9
R10: 0000000000000002 R11: ffff8880008da440 R12: dffffc0000000000
R13: ffff888041d014d8 R14: ffff888040254408 R15: 000000000000110b
FS:  0000555564217380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005564fb1350d0 CR3: 0000000040b92000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 44 24 60          	mov    %eax,0x60(%rsp)
   4:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   9:	74 08                	je     0x13
   b:	4c 89 ef             	mov    %r13,%rdi
   e:	e8 cd ea e5 fd       	call   0xfde5eae0
  13:	49 8b 45 00          	mov    0x0(%r13),%rax
  17:	48 89 44 24 48       	mov    %rax,0x48(%rsp)
  1c:	48 8d 90 98 00 00 00 	lea    0x98(%rax),%rdx
  23:	48 89 d0             	mov    %rdx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	48 89 94 24 80 00 00 	mov    %rdx,0x80(%rsp)
  38:	00
  39:	0f 85 ee 10 00 00    	jne    0x112d
  3f:	4c                   	rex.WR


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
