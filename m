Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3933CA
	for <linux-bcachefs@vger.kernel.org>; Thu, 14 Nov 2024 07:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731570323; cv=none; b=k+U8Cy0WqpdD1KPmGbxMuUfAIl19sjvg3vpfbcJiONk1EcHlcG2m6jX33ZIQ1JPcsVBb9ysnKDXyXFMuUzSv+sBcwYMs5XREiD9/4Ea1TJ3Yt3lTsMf39ybDoUH70C8euLUZU1rWCcV7yUWWu5C+5QcMQMiUSkeP7yZRGY0yOpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731570323; c=relaxed/simple;
	bh=4aygyGZKY3JPG9WtgXtgxhQU2Igc5mur7ylYHuZWOPY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nc4m5yAq7+cD5ArsfcPY5Uabamy4PwLUl+jEZCqs/kcBfk+RQuLmO7pzQ23CF3S/cim5C87Z2AKwzz2UjJoXMYCuoLXDMEdGipYEEAREn6K4SUsM90D0FPVKn9/A0Ai5Y0HYFHPgowliShuGd14UAUNFDgT0aWQ+vS/kZ3H18Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83ac354a75fso36994339f.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 13 Nov 2024 23:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731570321; x=1732175121;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PqvmgvBR9m5SljygQm+B9Kx+CKF5bDb/PHHWTNfTiTs=;
        b=d4BzIhVfFQkofNNChcaMMFPr2kI7bhFzjaBdfu6aVS61XCD+EpbRoVnvPuurSlESf/
         RcfyfbXyfOQPrRRf1Tt5oGDzMUadra9nv2HS2uPSVsXd1GUWXbijdyLoLyyGkPw9StPj
         PZMgnOK0wP74G+wpNBUt2A6Mo9bdGmC+Z2xvKzUyC+qdp8S+3jlazEehwqFzG8rqj1+z
         XTQ/7xC5K/mHJpuuTpiWUzuHnBzkNgHoGjEi3zZm2sTiZTJjzx42b3arG05w48GnNfVd
         Nox4D4Oq8iHdZV3kTEc0put5zGe6/RQ+UW88AEuBP81bO1BYhiPXtf2rjbCNDd8rQBfS
         xtXA==
X-Forwarded-Encrypted: i=1; AJvYcCUUMN3qFdTMMJiiAiQZz7/IJeSddnAXGATE7fAw0Y50Wd/0yT3iSoTbbHkc0+yEalEEPJBAu7NIBXnfBvSvBw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgLmSh2GJqpC8sh+GOtK1Y3IG7aTeH5Ynm0i6Rc5+Sa7CprS1X
	HA4vBxkTlnDcEF8TuyA9Px1VZldzv5m+j4Is7W0pL/r0NfFTEDxANGUyvjiOiyQ/RRf9MstqM2K
	iPA/mbD4MRaQOoZkus8n0+8ukKJxveZdiX0gUb5uWmR9VihL/3SabZ6E=
X-Google-Smtp-Source: AGHT+IFj4OZCCqsm0I4l7H9DrfrhkUA9iQ8WlvvGKBrz2kqraxzcDsKVpg5BhaTCLmDVpPjhHpiM1aQHYBTw/1N+rPLCcO3QAPCa
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1562:b0:3a4:eca2:95f1 with SMTP id
 e9e14a558f8ab-3a71fe391f0mr14068685ab.6.1731570321482; Wed, 13 Nov 2024
 23:45:21 -0800 (PST)
Date: Wed, 13 Nov 2024 23:45:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6735aa91.050a0220.2a2fcc.0062.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __journal_res_get (2)
From: syzbot <syzbot+53bb24d476ef8368a7f0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0a9b9d17f3a7 Merge tag 'pm-6.12-rc8' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17ac94c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=53bb24d476ef8368a7f0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0a9b9d17.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b80dd0292210/vmlinux-0a9b9d17.xz
kernel image: https://storage.googleapis.com/syzbot-assets/42a07c5c6678/bzImage-0a9b9d17.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53bb24d476ef8368a7f0@syzkaller.appspotmail.com

bcachefs (loop0): shutdown by ioctl type 1
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.c:359!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5334 Comm: syz.0.0 Not tainted 6.12.0-rc7-syzkaller-00070-g0a9b9d17f3a7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:journal_entry_open fs/bcachefs/journal.c:359 [inline]
RIP: 0010:__journal_res_get+0x24cb/0x2670 fs/bcachefs/journal.c:544
Code: 89 f9 80 e1 07 38 c1 0f 8c 0d fe ff ff e8 3d 5a c0 fd e9 03 fe ff ff e8 63 4a 89 07 e8 6e 7d 56 fd 90 0f 0b e8 66 7d 56 fd 90 <0f> 0b e8 5e 7d 56 fd 90 0f 0b e8 56 7d 56 fd 90 0f 0b e8 4e 7d 56
RSP: 0018:ffffc9000cfa71c0 EFLAGS: 00010283
RAX: ffffffff843e6caa RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000d829000 RSI: 0000000000000848 RDI: 0000000000000849
RBP: ffffc9000cfa7490 R08: ffffffff843e4f14 R09: 1ffff1100a049567
R10: dffffc0000000000 R11: ffffed100a049568 R12: 0000000000000023
R13: 00000000003ffffe R14: ffff88805024a500 R15: 1ffff1100a049545
FS:  00007f212f59b6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f212f59af98 CR3: 000000003c2e0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_res_get_slowpath+0xe6/0x710 fs/bcachefs/journal.c:606
 bch2_journal_res_get+0x12b/0x1c0 fs/bcachefs/journal.h:382
 bch2_journal_flush_seq_async+0x524/0x830 fs/bcachefs/journal.c:717
 bch2_journal_flush_seq+0xe5/0x2b0 fs/bcachefs/journal.c:772
 bch2_ioc_goingdown fs/bcachefs/fs-ioctl.c:361 [inline]
 bch2_fs_file_ioctl+0x1d17/0x28b0 fs/bcachefs/fs-ioctl.c:581
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:893
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f212e77e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f212f59b038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f212e936058 RCX: 00007f212e77e719
RDX: 0000000020000080 RSI: 000000008004587d RDI: 0000000000000004
RBP: 00007f212e7f175e R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f212e936058 R15: 00007fff5924ac88
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_entry_open fs/bcachefs/journal.c:359 [inline]
RIP: 0010:__journal_res_get+0x24cb/0x2670 fs/bcachefs/journal.c:544
Code: 89 f9 80 e1 07 38 c1 0f 8c 0d fe ff ff e8 3d 5a c0 fd e9 03 fe ff ff e8 63 4a 89 07 e8 6e 7d 56 fd 90 0f 0b e8 66 7d 56 fd 90 <0f> 0b e8 5e 7d 56 fd 90 0f 0b e8 56 7d 56 fd 90 0f 0b e8 4e 7d 56
RSP: 0018:ffffc9000cfa71c0 EFLAGS: 00010283
RAX: ffffffff843e6caa RBX: 0000000000000002 RCX: 0000000000040000
RDX: ffffc9000d829000 RSI: 0000000000000848 RDI: 0000000000000849
RBP: ffffc9000cfa7490 R08: ffffffff843e4f14 R09: 1ffff1100a049567
R10: dffffc0000000000 R11: ffffed100a049568 R12: 0000000000000023
R13: 00000000003ffffe R14: ffff88805024a500 R15: 1ffff1100a049545
FS:  00007f212f59b6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f212f59af98 CR3: 000000003c2e0000 CR4: 0000000000352ef0
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
