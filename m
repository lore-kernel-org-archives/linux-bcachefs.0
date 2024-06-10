Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC20D84A4A
	for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 14:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718029641; cv=none; b=B6il3GuwIf9P8UBorseA2RAu2PPtDRt9G6oCSfyvFUDmlhGmTYuiqWuQ08K7NVxqGaMgfqRlh6sCjaDTobuqPWm5UBIfNJP+zuXSpaB8QiXCgNlASUjBk3Nsu4HHQsXhYOgBm4L+y4KJ5SEve7hQSZFlV4o4KgLSZfqPywLmsNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718029641; c=relaxed/simple;
	bh=qNyY3gPYF2qmEpoo1n4bQF2sh3Dbd56uCGQJ6riwbT8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OILF0gjVMGpqIpdu1MeyisfD3xkejfL6KuZ9xYhvz9FW53lU5kTl1XSkTx9H3IP0m/Ttr/IKkJ0YBUWEerEiStp36Phd2gKnJA1u78dJ85BAPZttXopjQWQT01h/9Fo8g2VVcsaQapULsHPOZqnWdfUESMBcXs5e1tpMuHGFdjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7eb5f83ae57so279509239f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 10 Jun 2024 07:27:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718029639; x=1718634439;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7NHf6HxjWuV028m4aYYZAXBcqrsXypChDYMmJJL0QpA=;
        b=ZWtiixrbiur+hD1KW6M9Xx1Tsh3M1RVA3PqvzGlSIkQLEmWGP35zm3u+BLnyaPxbzj
         /eQciYZvHLDma39x57rWESFO/0B2LrD2zyadMwMIgDPnvUvAmGJSkQfCEsghlJMvqjyG
         hbeLDKZWwS4GIpCQzUaF8h2AETp0cevSeKh7lcAaWnQ6yLm322YtOuOLJ+hcHYDJ941H
         AUyGvfymXzBtMTxuqLb4UuYumbL8c9VEyYxGXVX71qBlsWWzt/NLi5rwUOhOjDwChXDf
         dKmH1/s3YxWRtgVCD03cDB4/24oagW/7dRmcv5iqSSGaio1uADrDW7gkZw9balqLjd15
         i9NQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+y+SWy1raDDg9v1ZcxLiaeItILBXEKDdHQf3Ak/BORyz39UK3x+F4ZZ3rqmKj0Vb8EGzWxDgCmCEaIsWN95U5CVumodHpf4p5Q0tL+KY=
X-Gm-Message-State: AOJu0Yx87/viIw9KGpuNBTvg58h16VyVQV0porIXg+30k6XlTAiMplYk
	CeBUaX9E4BWgjmQsAKQCuWAWLGy52Cf/9dMTHBvKOYLMScAT8InBKmAHfBTJ+Yq9uYdNwzZ21Ex
	43O+XFuHw2jp1tNQ1K2klD9CGm76W6nljTUFsSuRjlxNtRSPr2okjTGY=
X-Google-Smtp-Source: AGHT+IFXPybU/GeR2HByUYofJubKK0OBNNFVNX/PukOjGLzUR8cYHOn6Dzd10MgGaFXAJCIm26RvEaBcdgialvHtRp39clK3/q52
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1511:b0:7eb:801f:8645 with SMTP id
 ca18e2360f4ac-7eb801f8ab5mr20939639f.2.1718029639184; Mon, 10 Jun 2024
 07:27:19 -0700 (PDT)
Date: Mon, 10 Jun 2024 07:27:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005bad63061a89f2a1@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_replay
From: syzbot <syzbot+2c4fcb257ce2b6a29d0e@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2df0193e62cf Merge tag 'thermal-6.10-rc3' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cd4aba980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a6ac4277fffe3ea
dashboard link: https://syzkaller.appspot.com/bug?extid=2c4fcb257ce2b6a29d0e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12750c26980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10697422980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d73510b726a1/disk-2df0193e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8d9331f8840c/vmlinux-2df0193e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/67ff0539bc3c/bzImage-2df0193e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/013d86d02bf3/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1246820a980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1146820a980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1646820a980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2c4fcb257ce2b6a29d0e@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

bcachefs (loop0): recovering from clean shutdown, journal seq 4755801206503243784
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/recovery.c:129!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5080 Comm: syz-executor177 Not tainted 6.10.0-rc2-syzkaller-00097-g2df0193e62cf #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:129 [inline]
RIP: 0010:bch2_journal_replay+0x133d/0x1360 fs/bcachefs/recovery.c:268
Code: 89 e6 e8 96 86 d6 ff e8 31 8c 45 07 e8 1c 0b 5e fd 90 0f 0b e8 14 0b 5e fd 90 0f 0b e8 0c 0b 5e fd 90 0f 0b e8 04 0b 5e fd 90 <0f> 0b e8 fc 0a 5e fd 90 0f 0b e8 f4 0a 5e fd 90 0f 0b e8 ec 0a 5e
RSP: 0018:ffffc90002d6efe0 EFLAGS: 00010293
RAX: ffffffff84381a8c RBX: 4200000000000009 RCX: ffff888017fa0000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 4200000000000009
RBP: ffffc90002d6f128 R08: ffffffff84381098 R09: ffffffff84a313ec
R10: 0000000000000004 R11: ffff888017fa0000 R12: dffffc0000000000
R13: 1ffff1100e65958f R14: 00000000ffffffff R15: ffff8880732cac78
FS:  000055555ba40380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559cbf898ff0 CR3: 00000000200f8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:182
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:225
 bch2_fs_recovery+0x2370/0x3720 fs/bcachefs/recovery.c:807
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1031
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2123
 bch2_mount+0x6c0/0x1320 fs/bcachefs/fs.c:1917
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0a5e7c693a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9296c7c8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe9296c7e0 RCX: 00007f0a5e7c693a
RDX: 0000000020005b00 RSI: 0000000020000000 RDI: 00007ffe9296c7e0
RBP: 0000000000000004 R08: 00007ffe9296c820 R09: 0000000000005b72
R10: 0000000003000002 R11: 0000000000000282 R12: 0000000003000002
R13: 00007ffe9296c820 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:129 [inline]
RIP: 0010:bch2_journal_replay+0x133d/0x1360 fs/bcachefs/recovery.c:268
Code: 89 e6 e8 96 86 d6 ff e8 31 8c 45 07 e8 1c 0b 5e fd 90 0f 0b e8 14 0b 5e fd 90 0f 0b e8 0c 0b 5e fd 90 0f 0b e8 04 0b 5e fd 90 <0f> 0b e8 fc 0a 5e fd 90 0f 0b e8 f4 0a 5e fd 90 0f 0b e8 ec 0a 5e
RSP: 0018:ffffc90002d6efe0 EFLAGS: 00010293
RAX: ffffffff84381a8c RBX: 4200000000000009 RCX: ffff888017fa0000
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 4200000000000009
RBP: ffffc90002d6f128 R08: ffffffff84381098 R09: ffffffff84a313ec
R10: 0000000000000004 R11: ffff888017fa0000 R12: dffffc0000000000
R13: 1ffff1100e65958f R14: 00000000ffffffff R15: ffff8880732cac78
FS:  000055555ba40380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559cbf898ff0 CR3: 00000000200f8000 CR4: 00000000003506f0
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
