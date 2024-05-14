Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAF712D75A
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 09:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715679213; cv=none; b=i2TAUY5+kIqj8d6nQB1wQGObPMVExWVeC5aYv/9YJ/4oX0DbdA/KGaE7DiFMS6PJYPHqUqfi/RB0MM3BhRwsfQSW56TTX7jn46s7xlIJ7Ur6ftn+4bc3rIMFUz4pnqjJwRCfmhNhM4NV4KNq6c8IypCXVwx8E9BoManKom1oxqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715679213; c=relaxed/simple;
	bh=kURtlY5cDvzhTq9BlSF93mSqPcR3Ib3pu/yxpA7syRo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Vqm9GBiL4boc1tYaIKGIe2RtcDbAfUUGesh92Qv1Il9em7iMBwekrqvzWdkvZ5y5KvZCfAJfmtdvSF5O1ISsnZYnUUcFevqPrG4uUo//eZoOAe1Rc9RYhaf6DkwAHHCbVsFDDsbDJOeqjPpMuo1WgG/XRoxZXL/gbcdeBqckNic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7da4360bbacso663595439f.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 May 2024 02:33:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715679211; x=1716284011;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kAB1jUJaPwwIIZCl7ic94AmiI9/S/BxVDLghu+WIUYQ=;
        b=eiIyT6cqkCz7bHsw0CrWgFRapdKF/3IqiR73PIEi5hRIMRzYQLbpZ7bTOz/mAhTUWO
         EEmfgv569oM0OVY0tXSCI0p/HShN6esw2a5e92VEz7mZVi7PBZ0kOQOCJjE2WmzBl/rk
         UXrMxCGleB2RVDc4bBI8bzKpBq3++8DfIE0jfNfWp6004IdotYeDXBRv8dYYSC/1WYrU
         35TslngWTZEfhpygj34EdjoWkDvh9iT9l0h+w1g3eIZ+GfJvXCTnH2yikNF7aQAeIgWH
         /Q3XKw/jvg3SC6zBGS6tAivL8PF8cxY4Bmv1zf2JnH9GJERZ6xW/AvwPi8EAQ0uMq3N7
         HSvg==
X-Forwarded-Encrypted: i=1; AJvYcCUFGET9gxnFG1R7p1Feh7RJlpW7TzJGTU8cB5RhCS8cs+Xv8RPkcDLrvdMwRR9lU1mxsrmXjw5R9kRplRK2EyFjOEOhOaWyFDyN2LHf61w=
X-Gm-Message-State: AOJu0YzILirrVblTMW24cejTvw6VgelZ5kT37jklaqLaBsEOsMIL/hQX
	pyzNQnHmY/dU6hop/g04agOyTpkimAA8epoVDfJhxBzqoyWsg5Hg9zB1iHjRTcpyp+5nLgBOn2N
	gRoe5y2UpL/pg29dAS/lTebxKwrz+UIhTjzmA0laFweX2c90GSEIUwBc=
X-Google-Smtp-Source: AGHT+IHlE7LVzAW3RsUeVHqIZ0qSn+eH++WU1uD97Wi3J9INxjWyaSgSR1m8nYkrFV6eioFLo/H805lpgzqGGPAr+GrTioa0vAGc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:48f:b0:7de:e172:3d4e with SMTP id
 ca18e2360f4ac-7e1b5208481mr66921939f.3.1715679211020; Tue, 14 May 2024
 02:33:31 -0700 (PDT)
Date: Tue, 14 May 2024 02:33:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ebf2e0061866b102@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in bch2_sb_dev_has_data
From: syzbot <syzbot+249018ea545364f78d04@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cf87f46fd34d Merge tag 'drm-fixes-2024-05-11' of https://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=162f8fbc980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=249018ea545364f78d04
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13a40d04980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=102e5b70980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9c147953fc8e/disk-cf87f46f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a55c9d1f91fc/vmlinux-cf87f46f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8dab47ae8c2/bzImage-cf87f46f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2c5c030a256e/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13d673d4980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=103673d4980000
console output: https://syzkaller.appspot.com/x/log.txt?x=17d673d4980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+249018ea545364f78d04@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in fs/bcachefs/replicas.c:1010:20
shift exponent 155 is too large for 32-bit type 'int'
CPU: 0 PID: 5075 Comm: syz-executor397 Not tainted 6.9.0-rc7-syzkaller-00183-gcf87f46fd34d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 bch2_sb_dev_has_data+0x22a/0x5f0 fs/bcachefs/replicas.c:1010
 member_to_text+0xcb/0x1030 fs/bcachefs/sb-members.c:163
 bch2_sb_members_v1_to_text+0x1aa/0x2f0 fs/bcachefs/sb-members.c:317
 bch2_sb_field_validate+0x1f7/0x2d0 fs/bcachefs/super-io.c:1228
 bch2_sb_validate+0x9b6/0xe10 fs/bcachefs/super-io.c:460
 __bch2_read_super+0xc9a/0x1460 fs/bcachefs/super-io.c:822
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2052
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f16b990d8ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd930ef68 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdd930ef80 RCX: 00007f16b990d8ba
RDX: 0000000020011a00 RSI: 0000000020011a40 RDI: 00007ffdd930ef80
RBP: 0000000000000004 R08: 00007ffdd930efc0 R09: 00000000000119f3
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffdd930efc0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
---[ end trace ]---


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
