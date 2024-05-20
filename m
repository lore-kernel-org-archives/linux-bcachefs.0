Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4B645026
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 May 2024 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716214003; cv=none; b=cL8pDerroHKdMXyCky6yEhgqDqENPMlgRzOCOYX4wgzylAd66P9hQWaFV9fkcgMrSXw1yz38uEVWvL034Uhgqo1T0LEV6gWKKOpSMKvMhsKERyozCOH9KCHA3AtUF+MpLLNtC20Yv0U3rvRM0oRWTKayzWKQPDoH4IATEHFqG+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716214003; c=relaxed/simple;
	bh=d0YSDcNelMYbG4ysvNdRW5lvpLJtBO5Dt1mS1H7msEs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=J3e96K8GZO6+M9y0qjqwniFDyxKWhWAYfkJd+BRVIWIJeks4ce33Z9A8sSHEz77js0V9qRanfCQ2wTkONyi/Ng60sn2xKxDvIrz42yEp8WyYzM5aATMKuUMc3v9UeCfgfahlD7woR53GLfi0gQom5lpK4Y7H97f/vLmDCUaM/Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7e17eba6ba3so1026521239f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 20 May 2024 07:06:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716214001; x=1716818801;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GBDzEjJMTTsbrdhu1mVfbsArgkVxkix/3uYkI6RRvzU=;
        b=VrB0Gun5Ilt8tJ1/Z+WsW7bER0HoP0A50NYjhtyI6TXJvReRyVk0ikusIEsmsm/Yc6
         y2V1Fymk7ke9KHhhR/DK5vNui1Z21NSXvRKwebZ5jPR15tALBLxsdJ/aIY5VU7ti0u/O
         Xt8KozGmYHZtI6a+4S5DCvyXdQEzRfTf2FUF8eZdP/E7So+U+kb0CkqnQU7mR8jToYAE
         PFBvwxY7Iu393B2W9Mg2V0bgZn7LfDeNEsnJqkAtCFJoTI6dLxl+xCqeyTvJ5tj8hMwP
         mcAs/XaU0oPui+Xeb3pdGxSR8SQJbUTiKcey01GAKpPuNqBmZoPC09DJTR2nwyA69PeN
         Me0A==
X-Forwarded-Encrypted: i=1; AJvYcCX0xBU1wc7wJ12g+goJP5Iaic+43oAjko6U7hl6dw9nuqEU+evUmvMIXt/nFpZic3E8yXh1JfdUhc+NXDrTzorSeW7+nh4BzqR8jWnNE6M=
X-Gm-Message-State: AOJu0YxU9tEcMC7xvBUFIjRM3dija3fYRSdr1QUdpMYeOtUd6NW0CQ6t
	xZ8LWU/1lFtYGXWjW84pynzWUCHsfXukx0HliuBpml2QWMgosE/cRu3do+DG3OI2IbvRhJ2z3sv
	zziUg1+n2a1R7QYxnlhBfkBthrHKndxShgoxwIUhlRgpUCRn0rJgP+Hc=
X-Google-Smtp-Source: AGHT+IFU2juPo6fpmj2k6TMSCvRjegjS0EvrCxREq1UiaFlsiCuGk9Z7H743/HhNrpwKJrQmEnI3NLz56473URAtTb722tb5dWW+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:134c:b0:7de:e20f:4c65 with SMTP id
 ca18e2360f4ac-7e1b51a0370mr125382639f.1.1716214001317; Mon, 20 May 2024
 07:06:41 -0700 (PDT)
Date: Mon, 20 May 2024 07:06:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e84de10618e3352a@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __replicas_entry_idx
From: syzbot <syzbot+6365e0d1ebcb50170e86@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ea5f6ad9ad96 Merge tag 'platform-drivers-x86-v6.10-1' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11cd1bd4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f59c50304274d557
dashboard link: https://syzkaller.appspot.com/bug?extid=6365e0d1ebcb50170e86
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17cd90cc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=135dd884980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/28d741536b07/disk-ea5f6ad9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d9371342c512/vmlinux-ea5f6ad9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/711d17cc40a1/bzImage-ea5f6ad9.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1381883cf039/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=113181f4980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=133181f4980000
console output: https://syzkaller.appspot.com/x/log.txt?x=153181f4980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6365e0d1ebcb50170e86@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
------------[ cut here ]------------
kernel BUG at fs/bcachefs/replicas.c:28!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5080 Comm: syz-executor136 Not tainted 6.9.0-syzkaller-08284-gea5f6ad9ad96 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:verify_replicas_entry fs/bcachefs/replicas.c:28 [inline]
RIP: 0010:__replicas_entry_idx+0x331/0x350 fs/bcachefs/replicas.c:233
Code: d9 80 e1 07 80 c1 03 38 c1 0f 8c d7 fe ff ff 48 89 df e8 a2 d5 be fd e9 ca fe ff ff e8 68 11 5d fd 90 0f 0b e8 60 11 5d fd 90 <0f> 0b e8 58 11 5d fd 90 0f 0b e8 50 11 5d fd 90 0f 0b 66 2e 0f 1f
RSP: 0018:ffffc9000333ef70 EFLAGS: 00010293
RAX: ffffffff84391de0 RBX: 0000000000000004 RCX: ffff8880295d3c00
RDX: 0000000000000000 RSI: 000000000000007f RDI: 0000000000000009
RBP: 000000000000007f R08: ffffffff84391b58 R09: ffffffff8438288d
R10: 0000000000000007 R11: ffff8880295d3c00 R12: ffff888024a22088
R13: ffff888024a22088 R14: 0000000000000001 R15: ffff888078a80000
FS:  0000555570a13380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d9915fa648 CR3: 0000000023958000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_replicas_entry_idx fs/bcachefs/replicas.c:248 [inline]
 bch2_replicas_set_usage+0x2ff/0x710 fs/bcachefs/replicas.c:625
 journal_replay_early+0xba/0x4f0 fs/bcachefs/recovery.c:411
 bch2_fs_recovery+0x39c2/0x63b0 fs/bcachefs/recovery.c:747
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1043
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1906
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1f34ceddea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffefbf78468 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffefbf78480 RCX: 00007f1f34ceddea
RDX: 0000000020011a00 RSI: 0000000020000280 RDI: 00007ffefbf78480
RBP: 0000000000000004 R08: 00007ffefbf784c0 R09: 00000000000119f8
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffefbf784c0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:verify_replicas_entry fs/bcachefs/replicas.c:28 [inline]
RIP: 0010:__replicas_entry_idx+0x331/0x350 fs/bcachefs/replicas.c:233
Code: d9 80 e1 07 80 c1 03 38 c1 0f 8c d7 fe ff ff 48 89 df e8 a2 d5 be fd e9 ca fe ff ff e8 68 11 5d fd 90 0f 0b e8 60 11 5d fd 90 <0f> 0b e8 58 11 5d fd 90 0f 0b e8 50 11 5d fd 90 0f 0b 66 2e 0f 1f
RSP: 0018:ffffc9000333ef70 EFLAGS: 00010293
RAX: ffffffff84391de0 RBX: 0000000000000004 RCX: ffff8880295d3c00
RDX: 0000000000000000 RSI: 000000000000007f RDI: 0000000000000009
RBP: 000000000000007f R08: ffffffff84391b58 R09: ffffffff8438288d
R10: 0000000000000007 R11: ffff8880295d3c00 R12: ffff888024a22088
R13: ffff888024a22088 R14: 0000000000000001 R15: ffff888078a80000
FS:  0000555570a13380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d9915fa648 CR3: 0000000023958000 CR4: 00000000003506f0
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
