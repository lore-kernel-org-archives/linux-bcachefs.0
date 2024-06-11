Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55BC249E5
	for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 18:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718129732; cv=none; b=o5J4odc3dtSsN9m9HFZyZPZ5zr4P/S5cmZyGpYjEwNg2ijcu/GLxoqdmKzbsxIh9SBzsfMPidrtITc2X/tukEmwueP5i79Ys8ulyIUHjdCXs+tnbWHx92I6JqhIuKp0QLefLiKiKLKknKAQyry/5GVhkEMQgV/OZpiYP3ovw7NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718129732; c=relaxed/simple;
	bh=o661/g0MT1kUaXwnCHXeEjcPMPWhzYllXTFSTkxGUlM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nmaREbOGC9+MxoGHhmQcHOcD+1hbT6/3n9p2p2uDxf3VnQXFNJnleSrZlDHUmw8kEvAgF07qaPy6ppLXG54fyv517GlkBEu90UpvYRxNEK6VLHGboX9KAVAY6nvEFPb+6gd+zFeY5qJPhRW1r2gHcGjIQQ9gt21rvCsFHsI5FFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7eb5f83ae57so10009339f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 11 Jun 2024 11:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718129730; x=1718734530;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TuhS77VD3Lms9crhQdWUS/VbA+XXLv7Cp5Bum/O7DGQ=;
        b=YzkjStEykcT+s8hLqpPlAzcFbZ9JCCMfStPx66t/Nuar1YWTk0qDSq1YMYHj+APG51
         2ga5b9mivo7WbVOWYFxXy+ieALNtvEUBD5e/Mb48tgrR6KNFdogy1ysz+9AZOWlY4iRL
         9t10vhBjrtR1aLasCeiXhHNL2IjfRM2zWVeVITp/DR+Bjh92YfiIg4Sc02bx5tKmO4Jt
         Qrw49rAf8uaueBrbkwYbSsLKwDHbnVV0aan5pWlDFI4VMg6uirDkdGfhutQDN5YZIg/V
         xdYWTaIL9v/7edAqB944WBDqGpT5KQoNnFze+VfKocAu6m33sOXbo9kFD1sbRgWRcL1G
         7PFg==
X-Forwarded-Encrypted: i=1; AJvYcCXtC8vba7XhZeDBCcbFcZTOWOGLVzffPEAmCcO1Thp8kFJ9zRjTCaLkI6algEeL6exoEkEjgFs69kYzANEAFr9wABxcig7rtyfukB+0i8w=
X-Gm-Message-State: AOJu0YxXCMW8Dw3EdPG5B0x48ktzzNuKb5UIbkuylHHg0bj0rAuvrTfU
	03UM2A2jBidOhrfeuhBALLwFRknXPjoEm5aNiPCf1BUnzCCH7GUjGNseBEW2+SjQ8o0iReuk9H7
	fpREm4GBD5xL8veq4F7uzwR5qT1RqxHS9vy0OzzsbnaVcQXkWzg01HP8=
X-Google-Smtp-Source: AGHT+IE7XzY3MNnxoMX9Jgf8zlSJ1iMLxc3tOanwogjYXZnkkJm4UlWRFqt9le0Io1IVfGOJRWs5o5YnGUFHE1pyPPOQU0CIGO21
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6286:b0:4b9:c9e:2aa2 with SMTP id
 8926c6da1cb9f-4b92ba720cdmr196209173.0.1718129729902; Tue, 11 Jun 2024
 11:15:29 -0700 (PDT)
Date: Tue, 11 Jun 2024 11:15:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003aacfb061aa140ad@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_ioctl
From: syzbot <syzbot+9757fdbdabd69eae08ad@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    83a7eefedc9b Linux 6.10-rc3
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=116b64de980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c79815c08cc14227
dashboard link: https://syzkaller.appspot.com/bug?extid=9757fdbdabd69eae08ad
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109726ee980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13f2c4fe980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b45273014a8f/disk-83a7eefe.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/94cd5708292e/vmlinux-83a7eefe.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a89698812e8b/bzImage-83a7eefe.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2b8f6b18fd8a/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1538cd96980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1738cd96980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1338cd96980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9757fdbdabd69eae08ad@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5079 at mm/page_alloc.c:4654 __alloc_pages_noprof+0x36a/0x6c0 mm/page_alloc.c:4654
Modules linked in:
CPU: 0 PID: 5079 Comm: syz-executor354 Not tainted 6.10.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:__alloc_pages_noprof+0x36a/0x6c0 mm/page_alloc.c:4654
Code: a9 00 00 08 00 0f 85 12 01 00 00 44 89 e9 81 e1 7f ff ff ff a9 00 00 04 00 44 0f 45 e9 e9 02 01 00 00 c6 05 82 e5 aa 0d 01 90 <0f> 0b 90 83 fb 0a 0f 86 6c fd ff ff 45 31 ed 48 c7 44 24 20 0e 36
RSP: 0018:ffffc900032feea0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000013 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc900032fef28
RBP: ffffc900032fefb8 R08: ffffc900032fef27 R09: 0000000000000000
R10: ffffc900032fef00 R11: fffff5200065fde5 R12: 1ffff9200065fddc
R13: 0000000000040dc0 R14: dffffc0000000000 R15: 1ffff9200065fdd8
FS:  0000555582725380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 00000000779b6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 __kmalloc_large_node+0x8b/0x1d0 mm/slub.c:4067
 __do_kmalloc_node mm/slub.c:4110 [inline]
 __kmalloc_noprof+0x2aa/0x400 mm/slub.c:4135
 kmalloc_noprof include/linux/slab.h:664 [inline]
 kzalloc_noprof include/linux/slab.h:778 [inline]
 bch2_ioctl_fs_usage fs/bcachefs/chardev.c:517 [inline]
 bch2_fs_ioctl+0xf67/0x37d0 fs/bcachefs/chardev.c:889
 bch2_fs_file_ioctl+0x827/0x27a0 fs/bcachefs/fs-ioctl.c:539
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f142b4429b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff3b1922b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fff3b192498 RCX: 00007f142b4429b9
RDX: 0000000020000000 RSI: 00000000c040bc0b RDI: 0000000000000004
RBP: 00007f142b4c8610 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000004 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff3b192488 R14: 0000000000000001 R15: 0000000000000001
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
