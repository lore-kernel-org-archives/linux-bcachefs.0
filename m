Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599CA142E6C
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 08:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717491389; cv=none; b=tMu4C7a+LiCFehbGwnCdgUYqG0t/oZRzocWBFu7f8N3+NdnX8gO8i1fc/zNd4Mz8qV9clZmoJGw+tlROpjmcnWeJcRkym7U3W033W5Z8Tt+8a4AIqga4ECzmcSZTpwcVykGxfgY4QyxDLFwp+o7N6VTftREmhLCQs3gW1N5IQJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717491389; c=relaxed/simple;
	bh=RuvKglxOGuixipf1nYv69BNsHQetmYW2dZlTxap453o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AqC9D/h/H4mNY2tfr91ZnkJh7qWcbd5puPM6x+7jS/gtGby9k/K3177XIh4EqLXY6X0wR2bsGx8HNq5GJs0Tqd3UHmLQXBG4LXOXsU9z3uKoArgxaq5gbY01P5HavpbjgDuieQG5chOzhgVCPfqXXPNa3xaPHylGJNeB8n+maxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3748a38e71bso32274125ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Jun 2024 01:56:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717491387; x=1718096187;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VMftLD80Wet0hJ8KVY4oOvFRsmg3gYuLWRIgK7iHeYY=;
        b=Z7uAOJkAK8rXSeYa2R9T7Gg1Fbhk6ztB2nk1VwBV5d4ymt1+803JDb8kiz97ogvoQt
         HesoHi/LDItg6KBUKzjLHjHxG+eg96vfDxOXifozUWwyFMAfyIwbb+j6oCWge2TmNoM7
         FJUg9CSt/rPDeNxiUmBMJ1lFeaxKu8ekKq6FWsOA86rPuOz8ay1a6GDOLQ8l7kX2vU5h
         4L5ygSdChVthLC6NPsztc3MZtx1zoNQJ/+eSUM/mabH99UvM7jWQbLR3BKZl5bj+Vj2F
         Gz5Xf1Jt8HNohmpcZ/+6NrWxTB49UAOojJ7nDd1iHISyykjhDkWmyqiIm1LhQYsbSpD5
         sy0A==
X-Forwarded-Encrypted: i=1; AJvYcCWAJbmvzK0FBL80Tb/o9LuoCxprmHjHbCzy8t4A06d7vXSyZ3xQBASx0MSI+kJy4hVxWecEf6BrLBMzkwaNgDTAjqyDLSKWA9onK4//Pzg=
X-Gm-Message-State: AOJu0YwAawt2BxwndRH7OuJRu0hvcgn1oo158UIkFo9jz4uj9P0qLd09
	sgKOnIrnHVELZZYRjGSCXeet5mitSNtk0aCy0Rn5K/6jBgbqFPoamx76ifMfF5j8TkmHeQAQW5O
	3/3HpAhVIhrEVPi2vbwoMdfCDN5dtgfDaQovatdMbwejy8bpOpsqaYq0=
X-Google-Smtp-Source: AGHT+IGPgzceWfuaQCidGlhrHJje1hYdGSKOaGsiduUhXW/RfPRiezuTonZSyYVDxMm4dxLQEBbyJ10JpON4nmFvIR4rBXxnsf+i
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18cd:b0:374:a2db:d6b0 with SMTP id
 e9e14a558f8ab-374a2dbd7fbmr2874505ab.2.1717491387690; Tue, 04 Jun 2024
 01:56:27 -0700 (PDT)
Date: Tue, 04 Jun 2024 01:56:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000118399061a0ca01c@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_free
From: syzbot <syzbot+ab8e8a95fdeaf10f25fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e1980c40b6e Add linux-next specific files for 20240531
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12260914980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9c3ca4e54577b88
dashboard link: https://syzkaller.appspot.com/bug?extid=ab8e8a95fdeaf10f25fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44fb1d8b5978/disk-0e1980c4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a66ce5caf0b2/vmlinux-0e1980c4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8992fc8fe046/bzImage-0e1980c4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab8e8a95fdeaf10f25fd@syzkaller.appspotmail.com

bcachefs (loop3): bch2_check_allocations(): error fsck_errors_not_fixed
bcachefs (loop3): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop3): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop3): shutting down
------------[ cut here ]------------
kernel BUG at fs/bcachefs/super.c:647!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 PID: 6386 Comm: syz-executor.3 Not tainted 6.10.0-rc1-next-20240531-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:bch2_fs_free+0x3b1/0x3c0 fs/bcachefs/super.c:647
Code: e8 54 7b b8 fd e9 1a fe ff ff 89 d9 80 e1 07 38 c1 0f 8c 72 ff ff ff 48 89 df e8 3a 7b b8 fd e9 65 ff ff ff e8 40 8e 52 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0000:ffffc90003ee7560 EFLAGS: 00010246
RAX: ffffffff8443edb0 RBX: ffff88805d7f0000 RCX: 0000000000040000
RDX: ffffc9000b05a000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000002 R08: ffffffff8443ec58 R09: 1ffff1100bafe008
R10: dffffc0000000000 R11: ffffed100bafe009 R12: ffff8880574003d0
R13: 0000000000000000 R14: ffff8880574007a6 R15: 1ffff1100ae800f4
FS:  00007faa8d2676c0(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f712de00400 CR3: 00000000113ea000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_stop fs/bcachefs/super.c:661 [inline]
 bch2_fs_open+0xb57/0xdf0 fs/bcachefs/super.c:2129
 bch2_mount fs/bcachefs/fs.c:1908 [inline]
 bch2_fs_get_tree+0x75e/0x14d0 fs/bcachefs/fs.c:2069
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faa8c47e5ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faa8d266ef8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007faa8d266f80 RCX: 00007faa8c47e5ea
RDX: 0000000020002040 RSI: 0000000020002080 RDI: 00007faa8d266f40
RBP: 0000000020002040 R08: 00007faa8d266f80 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000020002080
R13: 00007faa8d266f40 R14: 0000000000005b5d R15: 0000000020000140
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fs_free+0x3b1/0x3c0 fs/bcachefs/super.c:647
Code: e8 54 7b b8 fd e9 1a fe ff ff 89 d9 80 e1 07 38 c1 0f 8c 72 ff ff ff 48 89 df e8 3a 7b b8 fd e9 65 ff ff ff e8 40 8e 52 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 90 90 90 90 90 90 90
RSP: 0000:ffffc90003ee7560 EFLAGS: 00010246
RAX: ffffffff8443edb0 RBX: ffff88805d7f0000 RCX: 0000000000040000
RDX: ffffc9000b05a000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: 0000000000000002 R08: ffffffff8443ec58 R09: 1ffff1100bafe008
R10: dffffc0000000000 R11: ffffed100bafe009 R12: ffff8880574003d0
R13: 0000000000000000 R14: ffff8880574007a6 R15: 1ffff1100ae800f4
FS:  00007faa8d2676c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 00000000113ea000 CR4: 00000000003506f0
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
