Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C892749C5
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 08:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758789691; cv=none; b=k8c58mxH2ty3aaFPYrXutYlImnWkwzbUtIXzFBzdCUz6Hbu4RINeRo6itQr+FZI7/0ezRp4VLZiwVsyrl6PRorVrJkVNygMlMXqyFl+Ho80Q3taIBWqaPYXtsgwY2Zakt9GqY4TN3k6ahZtq3VJgd7/Ild6ItQskBKvY+UoKruA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758789691; c=relaxed/simple;
	bh=UJp4BUk+Bh48h2jdJe+uYKMMzD+gDghdHikwYRSzQII=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=m9axubTIQcu1+fuXoVxtSAWTVW3U0+etGccs4cD4BZtQPwTGD6C3ZeCSlILAPU50zPppPqzIiulvOH32v+jnIGLYe0ZvQ7Zr9+QZBrdz5ZGxRzXW5fdkQGzLd+GY/brXUJJL5LRKEfTlxevzOTaVeKBPTWvauuIH2ElGS1omDPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-4247661a0c9so9618085ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 25 Sep 2025 01:41:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758789688; x=1759394488;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ihYFcmQ1MhQ84mVxiLWB+8RfaKjBaG4n/hobTGPzLhI=;
        b=a5POPUEcPoPe52sh3NeGDP/IRAl86XTWWX3etjoc3ZH3CHf86qiB37M9wgBo/KqYIl
         ZuGzP+MzcT1f3kk5eH8S8uneoopjYzQwhFtGwMmsdP336o8tX6cCtBTjI4xH+JdmLeln
         YtpP1VK5WFl4VmlM8JITLpOd1OWUDdFcuFjR1lncPjcB+tq3syaOJg1fu4PEP54YYJDd
         U3mA0GydgqykOGM2DcefWGfWl2jNQ8E3FuRKub6B28tv3nPdoqOkKf/vTjDLOFj7XZwy
         Hg0vHFsD4KeMSv/Jy84cqXeWA9mMNzs/mf7DHIqGxbvaTJ+gIpVQALESljsGdADvm8x/
         K3kQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+onkXKNPSVMaJoD7P1TgPrZc0ifSVNUWy+K/fGUSrz56UOL4SI0Jfa+LTmEvsnpGCbagebd7rDdbEt35W8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpHfbs5138JKJ4p+Xr4Vnb61eSV9gksqdsCjU+qA8MxxHnMHlw
	Yn6BADR12DzvUIF5+V6NYnCtUV3O895QcAvtIgmgcjizLUGqDAUYyvVxsFpPVHtsP1cL/KQhGBi
	pIZDmDcTh12l4ZIJJ3n/pFPG2YM9U9S0UosEa42OwJcYmHGkcdEV254/srvo=
X-Google-Smtp-Source: AGHT+IFfL10E932GcPANbPdjmTeDA/JpTTkwFc2KdJviQV1MAwpQhL4htl5WmaF6Do9tB0OE7BhJ5rFYunSUy9Fv/wghE2EYddam
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fcd:b0:426:4470:376e with SMTP id
 e9e14a558f8ab-42644703b4emr8511625ab.29.1758789688574; Thu, 25 Sep 2025
 01:41:28 -0700 (PDT)
Date: Thu, 25 Sep 2025 01:41:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d50038.050a0220.25d7ab.0006.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in journal_write_submit
From: syzbot <syzbot+91ae1770e6d3697e4c96@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3b08f56fbbb9 Merge tag 'x86-urgent-2025-09-20' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13c350e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=91ae1770e6d3697e4c96
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3b08f56f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/db104187bd74/vmlinux-3b08f56f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/978387063602/bzImage-3b08f56f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+91ae1770e6d3697e4c96@syzkaller.appspotmail.com

Bluetooth: hci0: command tx timeout
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_io.c:1875!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5335 Comm: kworker/u5:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_journal journal_write_preflush
RIP: 0010:journal_write_submit+0x1044/0x1090 fs/bcachefs/journal_io.c:1875
Code: 1a f1 ff ff e8 6d da 72 fd 90 0f 0b e8 65 da 72 fd 90 0f 0b e8 5d da 72 fd 90 0f 0b e8 55 da 72 fd 90 0f 0b e8 4d da 72 fd 90 <0f> 0b e8 45 da 72 fd 90 0f 0b e8 3d da 72 fd 90 0f 0b e8 35 da 72
RSP: 0018:ffffc9000d3ef9a0 EFLAGS: 00010293
RAX: ffffffff844ce2f3 RBX: ffff8880333986a0 RCX: ffff88801ca3c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888033398000 R08: 0000000000000000 R09: ffffffff84b30fb0
R10: dffffc0000000000 R11: ffffed100aa78007 R12: 0000000000000000
R13: 1ffff110066730d4 R14: 0000000000000000 R15: ffff8880553c0000
FS:  0000000000000000(0000) GS:ffff88808d007000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c93c01a240 CR3: 0000000043e51000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_write_submit+0x1044/0x1090 fs/bcachefs/journal_io.c:1875
Code: 1a f1 ff ff e8 6d da 72 fd 90 0f 0b e8 65 da 72 fd 90 0f 0b e8 5d da 72 fd 90 0f 0b e8 55 da 72 fd 90 0f 0b e8 4d da 72 fd 90 <0f> 0b e8 45 da 72 fd 90 0f 0b e8 3d da 72 fd 90 0f 0b e8 35 da 72
RSP: 0018:ffffc9000d3ef9a0 EFLAGS: 00010293
RAX: ffffffff844ce2f3 RBX: ffff8880333986a0 RCX: ffff88801ca3c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff888033398000 R08: 0000000000000000 R09: ffffffff84b30fb0
R10: dffffc0000000000 R11: ffffed100aa78007 R12: 0000000000000000
R13: 1ffff110066730d4 R14: 0000000000000000 R15: ffff8880553c0000
FS:  0000000000000000(0000) GS:ffff88808d007000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c93c01a240 CR3: 00000000119f5000 CR4: 0000000000352ef0


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
