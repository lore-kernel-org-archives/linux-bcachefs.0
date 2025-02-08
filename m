Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F35524111B
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Feb 2025 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739038584; cv=none; b=nQgBFEg+vIQYPjOn0kvuHaf775VWC0rsjvA6muYmuu5oJpWTqDldOsm+aNLCkyj6eXmed4MPPi8s5yFvJFG5rMx+/I/5qUrTc/eFvqsloO1xkEjV3PtIL+FqMLCnE22NJp5Ny16jjOjtl9nh39E2bbSLNtb/7f0OQQtwJR7SSJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739038584; c=relaxed/simple;
	bh=Pb+Uo58ELPI3T9aBfLN3ygvOJTjUXmpuD0b97W4ql3c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=U5uO14v+as+BId6OF3psRtpE1TSohwb78Nty9vhd/oQe2AACVZRcZArCAwxPIpNxnMkTLe/Z9X6xuZyNtSu42M7b17fSgPTTZ/8slfPTsmwgu8bXrl/wMyjpsqCbMMrPtDC2zuENVwtekCXl0HUDLGGB+Q0e2xCALCxbyN2Dnfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d14a235594so7317825ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Feb 2025 10:16:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739038582; x=1739643382;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJW2Jd9DbqYy1cTM0+4M3RRaQwiwD+ORGOFg6a94yts=;
        b=ASR/7WvchJGAthACuZPcQqTPUIm8mlyEJYRdfOSdpLhyqCyqcc+53ujPxwC7Q5zumy
         GHzpsnQnIWm1coW6Za4SUeAYXH+Ga9xhTpfz0LfKfjcoTu7He8qn5AG5L5zsxF0nqACo
         ihdGCu1Vg6Dt/ecB1/yxktqidvd6viVZfKbearTOK90mj9RvPyWBDPHizUr3slGo6OfI
         jeyvwbIX+N7lWVmspGXc4cOOA6G+Uz6S/m3qupcQH7ugvCH7NwwsJ2TX+Zm1KJ28aIGR
         X0f1MH06kf2qWPrxLMuKZgYgw4dGbx913VyI3FT4OXQV/+ZYfKZhYZnD0PW/rmzyRPGa
         87bQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSyxsGpqvJJuhyOeemdjzgG/77eI1EI0mJC4LA7q/j7FVuTKsBGINc4g4DcU5nrdH4Xq1TZwqna3aAGoECXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxuAZKTtVqa7lgXhY6UrmOfmnAGDFcL89ELhn9ybOLuaCC+yEDg
	GVGHbKbsZU1z9jMHho5fZmkzHP6YYGasCGjLmveofSLGcGLfxmw6hCroydtlODk8DnBM2ziRkHO
	ZQoHEcCURbQsGOlYLGPYZUWa+FjwbZUo/P+4Ei3fYJLzUfJ3/nAnkArs=
X-Google-Smtp-Source: AGHT+IHpy6R2fb3bIyIfyJzEUJvUbn9Byc/lExqMXaAibMryXIJTkbgCSBN8XEorKDuPShV0iufvW/XU0seXqh0wEtrO11IYHFRJ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c243:0:b0:3d0:353a:c97e with SMTP id
 e9e14a558f8ab-3d13e2e3680mr52364725ab.10.1739038582623; Sat, 08 Feb 2025
 10:16:22 -0800 (PST)
Date: Sat, 08 Feb 2025 10:16:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a79f76.050a0220.110943.000e.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_verify_accounting_clean
From: syzbot <syzbot+e99c7092c361b53acda2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f75ca4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=e99c7092c361b53acda2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54ead761f64f/disk-7ee983c8.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/95e57de2a045/vmlinux-7ee983c8.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d24a612a8ac7/bzImage-7ee983c8.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e99c7092c361b53acda2@syzkaller.appspotmail.com

bcachefs (loop3): flushing journal and stopping allocators, journal seq 9
bcachefs (loop3): flushing journal and stopping allocators complete, journal seq 9
bcachefs (loop3): clean shutdown complete, journal seq 10
bcachefs: bch2_verify_accounting_clean() fs_usage_base.nr_inodes mismatch: 0 != 1
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5823 at fs/bcachefs/disk_accounting.c:993 bch2_verify_accounting_clean+0x2917/0x2ad0 fs/bcachefs/disk_accounting.c:993
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:bch2_verify_accounting_clean+0x2917/0x2ad0 fs/bcachefs/disk_accounting.c:993
Code: e9 8f fe ff ff e8 09 6b 6d fd 48 c7 c7 a0 6c 52 8c 48 c7 c6 21 c9 12 8e 48 c7 c2 80 6d 52 8c 31 c9 4d 89 e0 e8 3a 0d d5 fc 90 <0f> 0b 90 e9 93 fe ff ff e8 dc 6a 6d fd e9 63 fb ff ff e8 d2 6a 6d
RSP: 0018:ffffc9000413f5e0 EFLAGS: 00010246
RAX: 0000000000000051 RBX: 0000000000000000 RCX: 193b5623fccba700
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc9000413fa30 R08: ffffffff819f140c R09: fffffbfff1cfa588
R10: dffffc0000000000 R11: fffffbfff1cfa588 R12: 0000000000000001
R13: 0000000000000000 R14: 0000000000000000 R15: fffff52000827eec
FS:  000055557e55e500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8ed0a00000 CR3: 000000005ee48000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_read_only+0x1150/0x12a0 fs/bcachefs/super.c:379
 __bch2_fs_stop+0x105/0x5c0 fs/bcachefs/super.c:634
 generic_shutdown_super+0x139/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2312
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f049258e117
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffee7626798 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f049260e08c RCX: 00007f049258e117
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffee7626850
RBP: 00007ffee7626850 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffee76278e0
R13: 00007f049260e08c R14: 0000000000010591 R15: 00007ffee7627920
 </TASK>


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
