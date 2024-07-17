Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7939A23D2
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 04:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721190625; cv=none; b=VZemD8FItAPA7fTPooWi2AoH7ZYbBvhQ4/ONDzCs8nv4sg4RMyonSXV2CBLlawmnCoiZeAEdVpyoSoUXTEq6dQwoMkkKp3IQafej3OH3kb5fkHikfK/SPijw8dWobwdXIyFt6ZrEcWHGe2fHMXSg41drvIVTwiR+7LUuPUw/1cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721190625; c=relaxed/simple;
	bh=nZe63nGxL/3DNa+AmpyTRTo3AirjJqDxqWHG4L5/h/0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=i+7hFZaIeHTuBwZNvE4m5bygVJv9cOaPj4H24MSdvAeqXMHGMbmwyW3f4HPrRWN1hXMR4+EsohG47gM/z+Jr3rINJeLD6B5LnEAhF/OwJLqJ4EVXGAiiPf2GHhP5njZzq4xZXX+3tmmBC6qjNjAXf3zdfLCqowUUrV36nXjwcG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-804b8301480so76089139f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jul 2024 21:30:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721190622; x=1721795422;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zlgbvL9ssP/qD7Fy3dwnuNqXCPLGo1yG1fZ3TXcZMu8=;
        b=e3b9pWG6Yvit36npItpy+gZ0tqyJyAn2Ly6WNrHZnvhhWSt/EB2Q97r3V5+tsHrnm5
         Cb/tjTCKwgtvi8C3vY0dFWmO69+hzqMwEF/ln0KrRMvPwg9U7MSBm0Rcd+IPQykJdgk6
         EkzcwjGmFp4j/ONsBeQ15BY/YxSywaBLCK2MlCF1wSOxXF9yqs5/Ws6x1qPGbYJ+gT1o
         xRuqUrmQpTkVlj+YygsB7cEKQyu4ZFmpzAa87bzaqeak2h0Z0xKSt+jMSe8SO1wvcWGL
         T328+EeGvWBUmbzBgiIH1RDPPHt3VOiIW99Mn+1BFfMG5Oi8yx3u6VSHtXReVT3OrwXe
         v6Ig==
X-Forwarded-Encrypted: i=1; AJvYcCUu+o5cUrKPWxcoxFxhpH28KuVwI02qj5VgKklBZ1sfN3v5VrqqwcY+oOs55/lWYIJpppvFDUI+IFSNI1GYHftvyf+GAHqzffe07KcOlzA=
X-Gm-Message-State: AOJu0YwUM0VeozfWMKCeZ3mCoi3L0btQdYWy77DpEfyPW9Xi7ezDTMyb
	+NLKe+P2S6IPwMAeCATdqQNRdPf4CWJ43coabe0HSnFepPGILeJusvBxyOXbpq3rhzkNTB2ETJF
	Zsk2z3nioiIq4MtO8kZEEmhTDq/lA1LOSjni69C+7ohjx55pgWRIQaHM=
X-Google-Smtp-Source: AGHT+IHtZAZqYcDxGMJFDIAxgloXaccF1jwUzGbiHZgmu+S/xkCB7uB4ixZoY0K+ONKMCOnloYCjhteLRDjWViAfu9eaPerAGrBc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c87:b0:375:a55e:f5fc with SMTP id
 e9e14a558f8ab-395551490d8mr566305ab.1.1721190622675; Tue, 16 Jul 2024
 21:30:22 -0700 (PDT)
Date: Tue, 16 Jul 2024 21:30:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a7d8f1061d69ebd5@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_journal_stop
From: syzbot <syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    975f3b6da180 Merge tag 'for-6.10-rc7-tag' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11b17221980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=42a432cfd0e579e0
dashboard link: https://syzkaller.appspot.com/bug?extid=4093905737cf289b6b38
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17460766980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130028f6980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62ced967be02/disk-975f3b6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c237fa04e1d4/vmlinux-975f3b6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/47f6105ecbe2/bzImage-975f3b6d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/02b246be7736/mount_0.gz

The issue was bisected to:

commit f7643bc9749f270d487c32dc35b578575bf1adb0
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 17 05:26:02 2024 +0000

    bcachefs: make btree read errors silent during scan

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10381495980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12381495980000
console output: https://syzkaller.appspot.com/x/log.txt?x=14381495980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4093905737cf289b6b38@syzkaller.appspotmail.com
Fixes: f7643bc9749f ("bcachefs: make btree read errors silent during scan")

bcachefs (loop0): flushing journal and stopping allocators, journal seq 13
bcachefs (loop0): flushing journal and stopping allocators complete, journal seq 13
------------[ cut here ]------------
journal shutdown error: cur seq 13 but last empty seq 14
WARNING: CPU: 0 PID: 5081 at fs/bcachefs/journal.c:1191 bch2_fs_journal_stop+0x5f3/0x630 fs/bcachefs/journal.c:1187
Modules linked in:
CPU: 0 PID: 5081 Comm: syz-executor334 Not tainted 6.10.0-rc7-syzkaller-00244-g975f3b6da180 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:bch2_fs_journal_stop+0x5f3/0x630 fs/bcachefs/journal.c:1187
Code: 44 24 18 42 80 3c 20 00 48 8b 5c 24 20 74 08 48 89 df e8 20 a2 c7 fd 48 8b 13 48 c7 c7 a0 34 13 8c 4c 89 f6 e8 8e 51 27 fd 90 <0f> 0b 90 90 e9 e4 fe ff ff 44 89 f1 80 e1 07 38 c1 0f 8c 7f fc ff
RSP: 0018:ffffc90003cc7780 EFLAGS: 00010246
RAX: 9ce99195b516ba00 RBX: ffff8880772caaa0 RCX: ffff88801ab3bc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003cc78c0 R08: ffffffff815857a2 R09: 1ffff1101728519a
R10: dffffc0000000000 R11: ffffed101728519b R12: dffffc0000000000
R13: ffff8880772ca440 R14: 000000000000000d R15: 1ffff1100ee59488
FS:  000055557822d380(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd538a8b68 CR3: 000000002bf54000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_fs_read_only+0x30c/0x430 fs/bcachefs/super.c:291
 bch2_fs_read_only+0xb52/0x1210 fs/bcachefs/super.c:356
 __bch2_fs_stop+0x105/0x540 fs/bcachefs/super.c:617
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2052
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x273/0x360 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa2d3adf307
Code: 08 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd538a9318 EFLAGS: 00000206 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fa2d3adf307
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd538a93d0
RBP: 00007ffd538a93d0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000206 R12: 00007ffd538aa430
R13: 000055557822e6c0 R14: 0000000000000001 R15: 431bde82d7b634db
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
