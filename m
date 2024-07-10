Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899E719645C
	for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 20:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720643663; cv=none; b=q+4HtIqs9rlopfuyrV2Ll6xkR/g5j8R7NV89lyzjJntbn89P76tlSGnocKeEa4KkTFj/AJFlhxXaTEufSOTKrkAQltHN1Fb/jr7rs2MvEgOZTsEgSVnsWCe0vCUB08KCDHBsFLL5dlaedhGtn6/pG7rsTkLGdPmPrHg/t215tx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720643663; c=relaxed/simple;
	bh=g8LjupbUKU8NHTH5Uuvp0PGEuzjenQ658hvrRkjCm9o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=n8dC4hly2XNcgwRGUBI8sUS43iCPxeMrcf9Cf0rKjGKVmIo+2oDF/A9iGWijrp1BVWDmdDCZkYg1B80GBz+RrQMDFA2j8XE4j5GBwqjVTHF17fg1syVh62kW6jG8koExYIDAYEVSvYx1zhIxPGH8E7GCb4nlKqdS07lpJAVUKUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7f92912a614so17675139f.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 10 Jul 2024 13:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720643661; x=1721248461;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F/FsAanCn6HRVuUfzPd0zjjxYUK3mPPHg7WjHz5sd5E=;
        b=mIQ4bzUQQHHlVUVrAdp+U9zBUHy+9QtBl8E3YT2xCVPVUoHpIVpw1tQck8viK8pWgI
         JClAJ6DkMtAds5yix6hCCEtBtmPnI+89QRALLTylmQnhNO1j8P/wcL3105OIJTLHSIxC
         DBKzr9aB4Cq+NUhRlfU5J5oNh4hLn0Ng8zUx6G12fD4tEP9dApStfczib8rZnCOJfL9F
         g7o0+wf0eD0FZcBKTdv+b3CRdbZW6ZsPDyyRJkDaTAtktE4RvO1O+CNcv1t2thNvkaSG
         OvITf5atC/nkgp8UbJUOBW7gCEcG9MiXotTfBcq5ldqhInC+X9B1s/gWrIYpDetrBzCz
         8Dyg==
X-Forwarded-Encrypted: i=1; AJvYcCUGt4YNVfNIYwZIi8zUf1P8XuufLUQ7hPttU9b98DNU8JRQcQ/p9LhOKwO0CNs9fSoGR2sLvt4l2PrXij7mfRQgano4w85rbAqvIoTw/BM=
X-Gm-Message-State: AOJu0YzSpg1kbKbYaElLM/0jH7SaPB6eUpNWVMEuwwnVBCv8Hy1FquFS
	f9pvzlEWLoTvpILbvnmno34uBTp/SWNkIPyAMI9S+dlSKw1/UBTKpDDj/uX5UEl9XoXpljFUUwr
	Wnq/9Mnx7WTO/pon+VZurautL8kFd+YGnfgBB+wbbDI6PoDSU3Ecxu9U=
X-Google-Smtp-Source: AGHT+IHWZ/UCpGMXR2VJ8jYnEPWu3BNfGHy6LS/46oHOpxdNia3MPIkNld54bakFF3OU0vBnEh4yxrJcA2eaZan8YPD4ItO61Mrx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d0c:b0:7f6:1a62:58bb with SMTP id
 ca18e2360f4ac-80004173ff5mr50758939f.3.1720643660723; Wed, 10 Jul 2024
 13:34:20 -0700 (PDT)
Date: Wed, 10 Jul 2024 13:34:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ec51a061cea9292@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bio_compress
From: syzbot <syzbot+cf190b6276e5bd33a108@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    34afb82a3c67 Merge tag '6.10-rc6-smb3-server-fixes' of git..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11932b76980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
dashboard link: https://syzkaller.appspot.com/bug?extid=cf190b6276e5bd33a108
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14109821980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1235f47e980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5e93dc1544ee/disk-34afb82a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/005e374613f0/vmlinux-34afb82a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b6931db81a1a/bzImage-34afb82a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d469706bc1c9/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1475d6e1980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1675d6e1980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1275d6e1980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf190b6276e5bd33a108@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

------------[ cut here ]------------
kernel BUG at fs/bcachefs/compress.c:398!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 1036 Comm: kworker/u8:5 Not tainted 6.10.0-rc7-syzkaller-00012-g34afb82a3c67 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: writeback wb_workfn (flush-bcachefs-1)
RIP: 0010:__bio_compress fs/bcachefs/compress.c:398 [inline]
RIP: 0010:bch2_bio_compress+0x13a1/0x13e0 fs/bcachefs/compress.c:498
Code: e1 07 38 c1 0f 8c 77 fb ff ff be 14 00 00 00 4c 89 ef e8 52 6d dc fd e9 65 fb ff ff e8 48 00 7a fd 90 0f 0b e8 40 00 7a fd 90 <0f> 0b e8 38 00 7a fd 90 0f 0b e8 00 0f 61 07 e8 2b 00 7a fd 90 0f
RSP: 0018:ffffc9000403e660 EFLAGS: 00010293
RAX: ffffffff841c2680 RBX: ffff8880769c7e78 RCX: ffff888021ddda00
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
RBP: ffffc9000403e8f0 R08: ffffffff841c14df R09: 0000000000000003
R10: ffffc9000403ed00 R11: fffff52000807da5 R12: 00000000000002e0
R13: ffff888076845688 R14: dffffc0000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b70de0db8 CR3: 0000000079450000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_write_extent fs/bcachefs/io_write.c:963 [inline]
 __bch2_write+0x1537/0x5c40 fs/bcachefs/io_write.c:1461
 bch2_write+0x947/0x1670 fs/bcachefs/io_write.c:1634
 closure_queue include/linux/closure.h:269 [inline]
 closure_call include/linux/closure.h:425 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:460 [inline]
 bch2_writepages+0x27d/0x380 fs/bcachefs/fs-io-buffered.c:652
 do_writepages+0x359/0x870 mm/page-writeback.c:2656
 __writeback_single_inode+0x165/0x10b0 fs/fs-writeback.c:1651
 writeback_sb_inodes+0x99c/0x1380 fs/fs-writeback.c:1947
 __writeback_inodes_wb+0x11b/0x260 fs/fs-writeback.c:2018
 wb_writeback+0x495/0xd40 fs/fs-writeback.c:2129
 wb_check_background_flush fs/fs-writeback.c:2199 [inline]
 wb_do_writeback fs/fs-writeback.c:2287 [inline]
 wb_workfn+0xc58/0x1090 fs/fs-writeback.c:2314
 process_one_work kernel/workqueue.c:3248 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3329
 worker_thread+0x86d/0xd50 kernel/workqueue.c:3409
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bio_compress fs/bcachefs/compress.c:398 [inline]
RIP: 0010:bch2_bio_compress+0x13a1/0x13e0 fs/bcachefs/compress.c:498
Code: e1 07 38 c1 0f 8c 77 fb ff ff be 14 00 00 00 4c 89 ef e8 52 6d dc fd e9 65 fb ff ff e8 48 00 7a fd 90 0f 0b e8 40 00 7a fd 90 <0f> 0b e8 38 00 7a fd 90 0f 0b e8 00 0f 61 07 e8 2b 00 7a fd 90 0f
RSP: 0018:ffffc9000403e660 EFLAGS: 00010293
RAX: ffffffff841c2680 RBX: ffff8880769c7e78 RCX: ffff888021ddda00
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000004
RBP: ffffc9000403e8f0 R08: ffffffff841c14df R09: 0000000000000003
R10: ffffc9000403ed00 R11: fffff52000807da5 R12: 00000000000002e0
R13: ffff888076845688 R14: dffffc0000000000 R15: 0000000000000004
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b70de0db8 CR3: 000000007d568000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
