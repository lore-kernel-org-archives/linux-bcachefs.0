Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42E5846C
	for <linux-bcachefs@vger.kernel.org>; Sat,  1 Jun 2024 11:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717241313; cv=none; b=mQI3YEseSqGUPxI0mieMmIDr2NYuTi5sy1IuH2uP1W1pfEO6f3YUPE76Azupx/x8m7FwQjuP56zah6dTsV56Cr4J5tMnCmduhVWvPchZuok3qhyEOBz+6YZxL1egj5FDoLEoMz1XpH5X9izPzmJ0e7DjruJg3Vfk2qD0tEzYPg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717241313; c=relaxed/simple;
	bh=10qYOZxx79UVSxZU+iPZbKojh8P6NYPvAGR/bB80Juo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ko1iNs0Wx4aov2254aEMb55ulIaKzplr/y0x3lCILH/bZ+hdwN3O+BQspmCe69Cd940TxFEsFRR1cWy2Iv9TeOxgbM0CSKGUwKQSqqQq3hOOkAAY7FQcAnKRjk1Y/oQ96hQeV2ZlbyWEDqN0WFjnOaY6zL4HYVhnFaG2Ve9kSnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e94cac3ee5so342008439f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 01 Jun 2024 04:28:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717241310; x=1717846110;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OliFYEC68XpkiuWSEe1hjUn5QMYnB8rS97DfkjKqSp0=;
        b=FTE9y7OrFgg30jqFBhb6OPqxQ3+ihkiIsswyZ6lY5ylacByQBPk9R5SfOmQSRc8ojm
         U08qCxSkT7jDyfAWsEFlZ1uDSkisiHxqblzoYZ3eYrwcK707db7GCWpByQEF46F4QmCD
         SPI8s370jtFiinHhB/dt6yX+i9MQraIVLUGTx8ZfOc66vrcVLDnch81eviqOdssLsBX2
         xX17+fJgRNcZgIshwBBDfEyq1txEBoXaIRQc3C32vKV4ZDoZRHcmwdA4wQYs2sgC6CKm
         hlpGnZLcgwjk7KlGd8U7rY98Y2Wwxm9/hHnaIhNJtF5OPQFAcVvsav+y/wqq+eqLHSdp
         VOTA==
X-Forwarded-Encrypted: i=1; AJvYcCWiINvr5aIrgEHJlnXmcOp7V/EWPOsDl3FKaNkycW4YfJdgVkaPN7WCkAm3EggZx6QspRhhDIEsFY2Bw3/QjPwv95m2iFgg//BGd/LnmU4=
X-Gm-Message-State: AOJu0Yy5iCLO03D1tg+B5umOika9UHpXsABYIJE2E32CJE4MR1gpfVnQ
	6WygocEQvQGIZPZS4IvhgLhEbfU0YE/1A7+nWCLLSafOc1EQ7pJXEZj22Nc5ybraJ0NiVSRgUxF
	wbn8PinXHZGfgv/MqWSzsPSUTtH2i0hxgcU1GYcnFCk8/q2XhG0XrLPY=
X-Google-Smtp-Source: AGHT+IEcjvIrwgq9zkHnhJm00ePg7QxtP/PZtQFllfDVO8aiziYzXTgTIDAeGSUVleitNLQgZVTbW01k9syefalbI+IY5JqgE7Xr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d15:b0:7de:d919:3925 with SMTP id
 ca18e2360f4ac-7eafff38c07mr30500539f.4.1717241310743; Sat, 01 Jun 2024
 04:28:30 -0700 (PDT)
Date: Sat, 01 Jun 2024 04:28:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005221690619d26681@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in gc_bucket
From: syzbot <syzbot+246b47da27f8e7e7d6fb@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e1980c40b6e Add linux-next specific files for 20240531
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10e91664980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d9c3ca4e54577b88
dashboard link: https://syzkaller.appspot.com/bug?extid=246b47da27f8e7e7d6fb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ca95fc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12a49ef2980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/44fb1d8b5978/disk-0e1980c4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a66ce5caf0b2/vmlinux-0e1980c4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8992fc8fe046/bzImage-0e1980c4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/a886eb704246/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+246b47da27f8e7e7d6fb@syzkaller.appspotmail.com

bcachefs (loop0): recovering from clean shutdown, journal seq 7
bcachefs (loop0): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.9: disk_accounting_v2
  running recovery passes: check_allocations
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/buckets.h:96!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5093 Comm: syz-executor366 Not tainted 6.10.0-rc1-next-20240531-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:gc_bucket+0x250/0x260 fs/bcachefs/buckets.h:96
Code: 8c e8 34 e1 62 fd e9 29 ff ff ff 89 f9 80 e1 07 fe c1 38 c1 0f 8c 36 ff ff ff e8 9b 71 ec fd e9 2c ff ff ff e8 71 84 86 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90 90 90 90 90 90
RSP: 0018:ffffc900035be208 EFLAGS: 00010293
RAX: ffffffff840ff77f RBX: 000000000001007c RCX: ffff88807cc70000
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000001007c
RBP: ffff888021e84000 R08: ffffffff840ff6e1 R09: 0000000000000000
R10: ffffc900035befd0 R11: fffff520006b7dfc R12: ffff888053ddd130
R13: ffff888053ddd118 R14: 000000000001007c R15: 0000000000000080
FS:  0000555563627380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cce0302c88 CR3: 000000007a7f6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_gc_alloc_start fs/bcachefs/btree_gc.c:899 [inline]
 bch2_check_allocations+0xc63/0xb9d0 fs/bcachefs/btree_gc.c:1109
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:226
 bch2_fs_recovery+0x238b/0x3730 fs/bcachefs/recovery.c:846
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1017
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2113
 bch2_mount fs/bcachefs/fs.c:1908 [inline]
 bch2_fs_get_tree+0x75e/0x14d0 fs/bcachefs/fs.c:2069
 vfs_get_tree+0x90/0x2a0 fs/super.c:1780
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa6effe7dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc6f97a5d8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc6f97a5f0 RCX: 00007fa6effe7dea
RDX: 0000000020005d80 RSI: 0000000020005dc0 RDI: 00007ffc6f97a5f0
RBP: 0000000000000004 R08: 00007ffc6f97a630 R09: 0000000000005dff
R10: 0000000000000400 R11: 0000000000000282 R12: 0000000000000400
R13: 00007ffc6f97a630 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:gc_bucket+0x250/0x260 fs/bcachefs/buckets.h:96
Code: 8c e8 34 e1 62 fd e9 29 ff ff ff 89 f9 80 e1 07 fe c1 38 c1 0f 8c 36 ff ff ff e8 9b 71 ec fd e9 2c ff ff ff e8 71 84 86 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90 90 90 90 90 90
RSP: 0018:ffffc900035be208 EFLAGS: 00010293
RAX: ffffffff840ff77f RBX: 000000000001007c RCX: ffff88807cc70000
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000000000001007c
RBP: ffff888021e84000 R08: ffffffff840ff6e1 R09: 0000000000000000
R10: ffffc900035befd0 R11: fffff520006b7dfc R12: ffff888053ddd130
R13: ffff888053ddd118 R14: 000000000001007c R15: 0000000000000080
FS:  0000555563627380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cce0302c88 CR3: 000000007a7f6000 CR4: 00000000003506f0
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
