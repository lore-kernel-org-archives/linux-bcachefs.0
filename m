Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B319224CC
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 18:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715624799; cv=none; b=nuwAAsj3I9ONeTx2ZIUUZvbN23D0p2sJK1Vmn6IzW8fgL1suLtp2znpe6UDhKrAK7XXhZL61HltkK5g9TAkXfo7U6qz/RTBeEZzaSi1TIXVKCSDh5BJht8x3qRI9XXj7MoKxacqd+/VRhY6hoyN+IR318Z8wwA2JybA66/fDAj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715624799; c=relaxed/simple;
	bh=mdf/xTDbAu+7XZltXr/qauCMfLs0ZWyUR+qsBTNoZjY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uql56gBnonLNKZ585pji/nRtxLBUv0yHMLzGy5nn2zkEudxKIps2nm37epUc2wNzEIYLBuRY2jSfzJDvxpQ6ktM/Y2y7MPUvpzB9B5YtLglhJXSN8H/3fKXmGotrv5EzYYW37g3+Xh/+2/8N1OqERn5MvuOhREuB0n9LPQy5EUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1d6c70aeaso232473739f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 11:26:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715624797; x=1716229597;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zfnhQHd1ZaI0j5kxzVL1jMjjmQJMNrWjEIOxkja1Wu4=;
        b=u0yXfJQ1TCpVLlfnzhRkNDOsJJ81WDoszMYtp61sMOLsolfLm8WAkO34fmlJp2B2J0
         AgvA8PWJjB734SVG9tms3uYmJc4OBd32YZLBpt4SfY/UQi+ljsv4EhCmHXCrHLWHy66B
         aNfHlZ/rvxNKDkte/B6yV1B/XKB5a7KQOd6BRYFDTvYepN3J5uE/wBRSnxhLZHa25TSr
         Feq1SGs2NW01Qg4Cs33BOBg3gskBTptwlWjek9JsJm80uDtiIhVP2x4criCp+wobFYpx
         xMRU5K083jA22cGqgWbQYsagwVWfESh7p+VjkAPbUCY3ckowGJfhijyJeyQV5PVCyYoq
         DqjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU2qYIgC66fxjqDHS3WCpTai5uMCA2r1zwRNM/K+z51AOwJd0AGml2vjUgExZT0ZA354RnhuPZopDOFsDKKhHZM1hFbQ8d1HYswtX8ZLn8=
X-Gm-Message-State: AOJu0Yzr1mygs5dMGxlAO2j6RZbpuUOnWYiXGZHnGKpov5MjaH2GamvP
	6EJDssOcC3wvjoJasps4+etXBZYw7Z74uXXSx1VgjfWIOjp0h+q2drQHrkgh+Sf4Y+sTuarQ2u9
	Red9lAFvi16u7pBjGLxihcGuNw3dZTGlzd7FDyY8yfwKEWDfY1zszGMc=
X-Google-Smtp-Source: AGHT+IEsXd4YliBtrIX0lT9zxEK95pscGf5BmhGLrskx/S1b2sFPzk83qghFLDj4Y6yyFXPc2bZRpQTd+NUd45qZLISLcZKAvMwf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:872a:b0:488:7a00:9343 with SMTP id
 8926c6da1cb9f-489589c27b6mr799200173.0.1715624797253; Mon, 13 May 2024
 11:26:37 -0700 (PDT)
Date: Mon, 13 May 2024 11:26:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009bc5fa06185a064d@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_journal_stop
From: syzbot <syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    75fa778d74b7 Add linux-next specific files for 20240510
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16f304e0980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccdd3ebd6715749a
dashboard link: https://syzkaller.appspot.com/bug?extid=10b936c5eaee2819b49b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106348cc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129c8d24980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ad9391835bcf/disk-75fa778d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d827b3da9a26/vmlinux-75fa778d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f32f0182388/bzImage-75fa778d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0d3a8c7d1a82/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=114323b8980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=134323b8980000
console output: https://syzkaller.appspot.com/x/log.txt?x=154323b8980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+10b936c5eaee2819b49b@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

bcachefs (loop0): finished waiting for writes to stop
bcachefs (loop0): flushing journal and stopping allocators, journal seq 13
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 13
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.c:1186!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5092 Comm: syz-executor214 Not tainted 6.9.0-rc7-next-20240510-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:bch2_fs_journal_stop+0x516/0x520 fs/bcachefs/journal.c:1184
Code: f0 fe ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 2f fd ff ff 4c 89 ff e8 6a e0 c6 fd e9 22 fd ff ff e8 d0 89 55 07 e8 4b 28 61 fd 90 <0f> 0b 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90002e77700 EFLAGS: 00010293
RAX: ffffffff8434f435 RBX: 000000000000000d RCX: ffff888022765a00
RDX: 0000000000000000 RSI: 000000000000000d RDI: 000000000000000e
RBP: ffffc90002e77840 R08: ffffffff8434f3f6 R09: 1ffff1100eca957f
R10: dffffc0000000000 R11: ffffed100eca9580 R12: ffff88807654a5c0
R13: dffffc0000000000 R14: 000000000000000e R15: 1ffff1100eca94b8
FS:  0000000000000000(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5a6b89130 CR3: 000000007abe8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_fs_read_only+0x30c/0x430 fs/bcachefs/super.c:291
 bch2_fs_read_only+0xb52/0x1210 fs/bcachefs/super.c:356
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:613
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2026
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x426/0x4c0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xa27/0x27e0 kernel/exit.c:874
 do_group_exit+0x207/0x2c0 kernel/exit.c:1023
 __do_sys_exit_group kernel/exit.c:1034 [inline]
 __se_sys_exit_group kernel/exit.c:1032 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5a6b00749
Code: Unable to access opcode bytes at 0x7fb5a6b0071f.
RSP: 002b:00007ffc012e1a88 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fb5a6b00749
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000001
RBP: 00007fb5a6b8b2b0 R08: ffffffffffffffb8 R09: 000000000000f626
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fb5a6b8b2b0
R13: 0000000000000000 R14: 00007fb5a6b8c020 R15: 00007fb5a6acec80
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fs_journal_stop+0x516/0x520 fs/bcachefs/journal.c:1184
Code: f0 fe ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 2f fd ff ff 4c 89 ff e8 6a e0 c6 fd e9 22 fd ff ff e8 d0 89 55 07 e8 4b 28 61 fd 90 <0f> 0b 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90002e77700 EFLAGS: 00010293
RAX: ffffffff8434f435 RBX: 000000000000000d RCX: ffff888022765a00
RDX: 0000000000000000 RSI: 000000000000000d RDI: 000000000000000e
RBP: ffffc90002e77840 R08: ffffffff8434f3f6 R09: 1ffff1100eca957f
R10: dffffc0000000000 R11: ffffed100eca9580 R12: ffff88807654a5c0
R13: dffffc0000000000 R14: 000000000000000e R15: 1ffff1100eca94b8
FS:  0000000000000000(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005639ea5a3b68 CR3: 000000007abe8000 CR4: 00000000003506f0
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
