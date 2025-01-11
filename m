Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32D624B22C
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Jan 2025 09:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736586810; cv=none; b=OSU0QONqbeMYumsCA1n8TtXXya+6Bz/+qO1sOIAQZuoq1Fp3st4LgVm6yo7FlPsrvkwk4OkFAoRlD2vahnJ6Q4YgRX6tYHlMoC6YlRs81t6TcMsxjtdoUoNJKlTOzHotY2atQkwmOG2ocUVOfk97GqSFCKsMYgybNsr/rrPqqzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736586810; c=relaxed/simple;
	bh=Y1+LMYXmeqckQSg0KNnaCsg/LXdgn0dGVKbCWnHV1Z4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=rsZGT380uWkCHqgreYnJlpBY0lMW9Vo0/FXsqKBGMVZtTSzvB1yZ6KSTxiTaI+bBah4WIA1RrEkP6pXnz1J6NdAQ1IQbfGGzbdcV2YrRqIrceW4jXJlzODcfbqmXO9BnhHYgsSBL9ip3tfgTcFuu5SKZZWguiWOct0ADLjwoq+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a81754abb7so53197595ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 Jan 2025 01:13:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736586808; x=1737191608;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHKIRrSk0fcph0Snfpfc0DhgMtrZV2b6NLlFiTLD2s4=;
        b=YSmOUK2oMXWW50O1AhtmALuQPqTvzalJp+qJQRwUNLC8nlx7jD70pUOH5grhkYVrgg
         1xu4r5+BNeNqz3M5uoUlIBgiqSHxDxbvNMHJf9d02vU8eOCdtkcW9yfT3jM64WuelDhs
         YAWd4PfJBd6Ci/pJv+8I4stwJxok7ZTjrhq6KP2+dQf3rLCyqGuPmmAu+qJ+iTcLVK1/
         viDrwcximxZVS2vjDATC3OKk4DZ8le9GOP797lFAtiBRVwhdBJXNGmMVKqREyoxzs07K
         br1YBZl9MB9oMShaG3/DEJrtxPh+dD1TQhvpVx5SPMqdA9tO4m5Unylu+d9U29em6HWR
         VQfw==
X-Forwarded-Encrypted: i=1; AJvYcCVWIakbPgJLIEEtu4YRBc0M9I3maiKkrdM+NGJtd8HiXqJ1BIDNIvdlcGuPGNbBk3D6Q7xrHzuqgIEN0ERrbQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmwS50gibXqAWSMl+EXM3a1PGID2G9zmFwn9NSCVZhrzfcoWbo
	m8yKyUEDq57YUPIGdWAQEYUpRlY5KJBbPCW7zvVFLF64YP0hFRNKUHEHmGIg+23s3cFC5nDsid7
	CQzA/hFrVhAU0rRKO4b2/TqndraFjGIP3jfb76QYqWte/3NPMOLNddTM=
X-Google-Smtp-Source: AGHT+IFdgeXcdWDIrfrVOTqCkKezBK/yTSgTAoO9Vd9QjGuY0qVzjEgsdBxDAqgyYSrp/KBHlgThrkZ+ELlsrWdUvRDeTgBxxWmB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe1:b0:3a7:70a4:6872 with SMTP id
 e9e14a558f8ab-3ce3a9c1f00mr110795165ab.9.1736586808079; Sat, 11 Jan 2025
 01:13:28 -0800 (PST)
Date: Sat, 11 Jan 2025 01:13:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67823638.050a0220.d0267.0040.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_replay (2)
From: syzbot <syzbot+a3885f6d294f83923567@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fbfd64d25c7a Merge tag 'vfs-6.13-rc7.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c9a4b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ef22c4fce5135b4
dashboard link: https://syzkaller.appspot.com/bug?extid=a3885f6d294f83923567
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-fbfd64d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ae42c226ccad/vmlinux-fbfd64d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1fe6ec294113/bzImage-fbfd64d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a3885f6d294f83923567@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (/dev/loop0): error reading default superblock: Not a bcachefs superblock (got magic c68573f6-4e1a-45ca-8265-f50d00000000)
bcachefs (loop0): starting version 0.775: (unknown version) opts=metadata_checksum=none,data_checksum=none,compression=lz4,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 18446744073709550602
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/recovery.c:130!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5313 Comm: syz.0.0 Not tainted 6.13.0-rc6-syzkaller-00036-gfbfd64d25c7a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:130 [inline]
RIP: 0010:bch2_journal_replay+0x2a09/0x2a40 fs/bcachefs/recovery.c:346
Code: 9d f5 7d 07 e8 d8 9f 54 fd 90 0f 0b e8 d0 9f 54 fd 90 0f 0b e8 c8 9f 54 fd 90 0f 0b e8 c0 9f 54 fd 90 0f 0b e8 b8 9f 54 fd 90 <0f> 0b e8 b0 9f 54 fd 90 0f 0b e8 a8 9f 54 fd 90 0f 0b e8 a0 9f 54
RSP: 0018:ffffc9002301f180 EFLAGS: 00010287
RAX: ffffffff844ae468 RBX: fffffffffffffc0b RCX: 0000000000100000
RDX: ffffc9000e762000 RSI: 000000000005e908 RDI: 000000000005e909
RBP: ffffc9002301f478 R08: ffffffff844ad9d9 R09: ffffffff84beb7ff
R10: 0000000000000004 R11: ffffffff844af370 R12: ffff8880375cabb8
R13: dffffc0000000000 R14: 00000000ffffffff R15: ffff8880375cabc0
FS:  00007f599b12f6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fa4fa70200 CR3: 0000000033f4c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3513
 do_mount fs/namespace.c:3853 [inline]
 __do_sys_mount fs/namespace.c:4063 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4040
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f599a3874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f599b12ee68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f599b12eef0 RCX: 00007f599a3874ca
RDX: 00000000200000c0 RSI: 0000000020000080 RDI: 00007f599b12eeb0
RBP: 00000000200000c0 R08: 00007f599b12eef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000020000080
R13: 00007f599b12eeb0 R14: 00000000000059b2 R15: 0000000020000100
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:replay_now_at fs/bcachefs/recovery.c:130 [inline]
RIP: 0010:bch2_journal_replay+0x2a09/0x2a40 fs/bcachefs/recovery.c:346
Code: 9d f5 7d 07 e8 d8 9f 54 fd 90 0f 0b e8 d0 9f 54 fd 90 0f 0b e8 c8 9f 54 fd 90 0f 0b e8 c0 9f 54 fd 90 0f 0b e8 b8 9f 54 fd 90 <0f> 0b e8 b0 9f 54 fd 90 0f 0b e8 a8 9f 54 fd 90 0f 0b e8 a0 9f 54
RSP: 0018:ffffc9002301f180 EFLAGS: 00010287
RAX: ffffffff844ae468 RBX: fffffffffffffc0b RCX: 0000000000100000
RDX: ffffc9000e762000 RSI: 000000000005e908 RDI: 000000000005e909
RBP: ffffc9002301f478 R08: ffffffff844ad9d9 R09: ffffffff84beb7ff
R10: 0000000000000004 R11: ffffffff844af370 R12: ffff8880375cabb8
R13: dffffc0000000000 R14: 00000000ffffffff R15: ffff8880375cabc0
FS:  00007f599b12f6c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fa4fa70200 CR3: 0000000033f4c000 CR4: 0000000000352ef0
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
