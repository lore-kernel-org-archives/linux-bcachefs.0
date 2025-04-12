Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9E9645
	for <linux-bcachefs@vger.kernel.org>; Sat, 12 Apr 2025 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744440334; cv=none; b=QZ9LOZXG7E4K7qTPowpX3W+HUppZs+IHHhnoBAUcywJCOuDp8vzlG43B86k+l0uPvQPXbasw12jdaz9UaZAdK6mQcEXwC5S/RxFbvwHW5l7o9pk/iFmTEKW9gWCwzytFHUCtADHzN+lReSuF99YW1slXavccIT5AGlhIyp8dAzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744440334; c=relaxed/simple;
	bh=H9kLDsJmpzpnfYIQanCORfrJ0FSG23RcROmNIXHKYKA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jAju3/lYFtoMQtXcan/+F3VvqRqpT+w0ndcS30NjYhANkucYTpkdf+uyyFZzmJt356UdB82YCw5s/AjklGaEZJEaBf1KHuv1aeHpvPyv4WAMRYilMrHZlbSwnkOg6GYklVHuuJbv143kE/x4onbtj+ahso5+MjxsCbe4kwovLas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d43b460962so51702575ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 11 Apr 2025 23:45:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744440332; x=1745045132;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gh2HAU3Z8eygYtu2Or+U/7qjXGiVyrdhRpBi6ban/60=;
        b=wjaDKmIB8gopfl6AWIf6zQPCyINPf16/0g9dQ7DxX5jIPFA9Wa6tewS8go0llpwUTn
         GRyRCIrI8sdPuBqW17S1wz8LySyoAVywgKVOlduN8UNd7Pd6yUvdn6G8oeDgi+enbEzd
         2FjHd181B4je176Cw4sqy/ykKqFPeRnWmmyTdCH9MiFcYhq6+G3QyESmiEb29qPZCybm
         adVZCCGzu87htzrhjKv6kmVBCG3u0oJhdNXQdZhymsxp37Ce6kGX18ccpmYxECmyaGvq
         QT7DNBfblrYzVnBeVs13SclC3lMGm2OHcgqKKG5G/1mR+bKRN2NYyv0Bkx2FQRQWoOcU
         sISQ==
X-Forwarded-Encrypted: i=1; AJvYcCWffWUWH7gvIlHqHtZMvFffbnIHTTrzLmRYfnMqCgyPZi/eCJfdFzQEtzcXKDI+ZJOCQb+LBmfs1BYkfhD1kw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf/C3mOFati+n4xB4airXpCHqkyRfJM5VJtAybd87yWhZoPAFN
	rIMiS5HEWI1g/XRLxh8NfkLU/rCFQ/8SqGSEY9Xsj/Lx8CmRKzyhBTLvrK26SZnTGLXdaK5DIoA
	EVv/r5B/NewguXs7VmllnDBjRA/uX8EViy72U/dZapaWG6hmMTJacOjk=
X-Google-Smtp-Source: AGHT+IEZPmBsjfhzs+4NXAG57JJ1JWZEcwYwZLZGJietlhCZv+AJ7VrY1mZXyiH+oLPwLoXkAbye48HU8SvseC2WxtlYwPHB9Vrm
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2165:b0:3d3:d823:5402 with SMTP id
 e9e14a558f8ab-3d7ec1f3e77mr64474345ab.7.1744440332144; Fri, 11 Apr 2025
 23:45:32 -0700 (PDT)
Date: Fri, 11 Apr 2025 23:45:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67fa0c0c.050a0220.379d84.0007.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_initialize
From: syzbot <syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    29e7bf01ed80 Add linux-next specific files for 20250410
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1515f74c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a554d15459e77547
dashboard link: https://syzkaller.appspot.com/bug?extid=d10151bf01574a09a915
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14634398580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bb76302efd6b/disk-29e7bf01.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7da3c6b9e532/vmlinux-29e7bf01.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4909c61270ed/bzImage-29e7bf01.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d99f7622732d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d10151bf01574a09a915@syzkaller.appspotmail.com

0 pages HighMem/MovableOnly
428629 pages reserved
0 pages cma reserved
bcachefs (loop0): error reallocating journal fifo (32768 open entries)
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.h:442!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6987 Comm: syz.0.185 Not tainted 6.15.0-rc1-next-20250410-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:bch2_journal_set_replay_done fs/bcachefs/journal.h:442 [inline]
RIP: 0010:bch2_fs_initialize+0x15f9/0x1620 fs/bcachefs/recovery.c:1130
Code: ff e8 eb a8 a8 07 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 04 fe ff ff 4c 89 f7 e8 32 7d a3 fd e9 f7 fd ff ff e8 08 51 39 fd 90 <0f> 0b e8 00 51 39 fd e8 7b 6f a3 fd 4c 89 ff 8b 74 24 38 e8 bf 3f
RSP: 0018:ffffc90003c67420 EFLAGS: 00010293
RAX: ffffffff848a29d8 RBX: 0000000000000000 RCX: ffff88802c799e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003c67920 R08: ffffffff848a1dfe R09: 1ffff11009c792c0
R10: dffffc0000000000 R11: ffffed1009c792c1 R12: ffff88804e380000
R13: ffff88804e380820 R14: ffff88804e3c9600 R15: ffff88804e3c95c0
FS:  00007fa3bfd836c0(0000) GS:ffff888125080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00009bfc0 CR3: 000000003475c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_start+0x301/0x620 fs/bcachefs/super.c:1100
 bch2_fs_get_tree+0x1138/0x18e0 fs/bcachefs/fs.c:2253
 vfs_get_tree+0x90/0x2b0 fs/super.c:1809
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3879
 do_mount fs/namespace.c:4219 [inline]
 __do_sys_mount fs/namespace.c:4430 [inline]
 __se_sys_mount+0x38c/0x400 fs/namespace.c:4407
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa3bef8e90a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa3bfd82e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fa3bfd82ef0 RCX: 00007fa3bef8e90a
RDX: 00002000000000c0 RSI: 0000200000000180 RDI: 00007fa3bfd82eb0
RBP: 00002000000000c0 R08: 00007fa3bfd82ef0 R09: 0000000000000080
R10: 0000000000000080 R11: 0000000000000246 R12: 0000200000000180
R13: 00007fa3bfd82eb0 R14: 0000000000005a18 R15: 0000200000000440
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_journal_set_replay_done fs/bcachefs/journal.h:442 [inline]
RIP: 0010:bch2_fs_initialize+0x15f9/0x1620 fs/bcachefs/recovery.c:1130
Code: ff e8 eb a8 a8 07 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 04 fe ff ff 4c 89 f7 e8 32 7d a3 fd e9 f7 fd ff ff e8 08 51 39 fd 90 <0f> 0b e8 00 51 39 fd e8 7b 6f a3 fd 4c 89 ff 8b 74 24 38 e8 bf 3f
RSP: 0018:ffffc90003c67420 EFLAGS: 00010293
RAX: ffffffff848a29d8 RBX: 0000000000000000 RCX: ffff88802c799e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003c67920 R08: ffffffff848a1dfe R09: 1ffff11009c792c0
R10: dffffc0000000000 R11: ffffed1009c792c1 R12: ffff88804e380000
R13: ffff88804e380820 R14: ffff88804e3c9600 R15: ffff88804e3c95c0
FS:  00007fa3bfd836c0(0000) GS:ffff888125080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00009bfc0 CR3: 000000003475c000 CR4: 00000000003526f0
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
