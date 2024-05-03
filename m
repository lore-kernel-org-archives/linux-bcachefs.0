Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC7456457
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 May 2024 21:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714771407; cv=none; b=EXR+MHw83CNsKcbCy3bJdDUDS9kEGAwwuzbGaO0bLq6K0T6s5gF9vlnL8ia2sfpL3OAhKfN5FAYk1ujqDlOlc6LG6qD6o9ODXhVVsQyMXPaq1JhtTD0XfYVAh7UrtzyHMJqQ41m+vdWQsKgF5gya+IVXwddY0dSQPiI5J7wLihk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714771407; c=relaxed/simple;
	bh=0I9HYehUPiTbvcoZm+bi9oIqOfptahzemmvOSF8E9kQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q4Nz5Vk+7pOQ8gMkVfRTFlRYf5xn06RhQuQaRiR7GyGmPHi9Kz1d7UrWwWzkVMT3ptqnk0Y3r4Q+wFT0ufy7OSK8KkndVau2P44t623AntsVoYNadNVJ1CDmxBG1ka2GIpHv1J6Ih9EnEQxVjqy8XZ+FqbVPPotRVJ0J2tK0c9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7deb999eea4so9238339f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 May 2024 14:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714771405; x=1715376205;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x4GbqEKgZuUa1KrnN/Su4ZMPhtfNcJzTLzCPfurOMJw=;
        b=FQlMmPucbIcn9Ur5Bh3YYEe/FCTEvaKoRtWwV+mFO9gJsFXmBzanEFa7Ivdw48x6y8
         pAK/iIQ36S4dXj7pmYWCR14cykHjK7hKuIQayNIox0qct8zIwXGXw350nuZdhVa/TxRa
         5mMGHqTpaqHdWd3B5+HrBc4B/otcXcA/N4M5DnOMu2antDJrlo00+hCTDHyVo5+LT62l
         EfPxRE+DE2efkAhK14jF6IxjHuRBk6+NS6Xpf5pZXrN54XBbbg7YLPDbTMQ9PoNZSobw
         +BrI8ydNiwBvJ9JZDs3mfnegB1mNuhsj5C6W+SPqYEzN/7eHKnryA5GmVrS5SR5e2ppw
         EVQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoiI+spw2ekzzCaGp1YeNj2xCpfpFYi6f7J92KlcgltvIncBzk6n/OzN6cEJ+iMxhKHUGG839mNXezlsjrTxukIMalNuGYYfvHjv1Lx8k=
X-Gm-Message-State: AOJu0YyOXpYmyD91C65S0+riTyz0nONRzbJLRSqD4o8gYVtgynDMCkj2
	KKafvq/t2EQyszqrM/+R0jzjiiVmEtcpNt+HYItQPO03uK4A/yPRqlZVXk7aGAnIZFjKvUaGV2c
	6W+9K5uJSStADNXNhzSD6xHIAL2xKYRDnN//oMmmQhxUfsU4Gc1f2TSs=
X-Google-Smtp-Source: AGHT+IESXSSXDGivXRyeDdWZ+LhL6+oKegoJ1a3vEN9LKW76nx/PAeBHz1CdWCfX0td7zXksEE0ZqjkBPLGM3WYb+8lhIzF59bPP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:6d12:b0:487:31da:eaf1 with SMTP id
 he18-20020a0566386d1200b0048731daeaf1mr82103jab.1.1714771405656; Fri, 03 May
 2024 14:23:25 -0700 (PDT)
Date: Fri, 03 May 2024 14:23:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008160ad06179354a2@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_recovery
From: syzbot <syzbot+05c1843ef85da9e52042@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d25a941ea50 Merge tag 'block-6.9-20240503' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114b39ff180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3310e643b6ef5d69
dashboard link: https://syzkaller.appspot.com/bug?extid=05c1843ef85da9e52042
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13aed9df180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14ac7a28980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-3d25a941.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9d8ed74e49f1/vmlinux-3d25a941.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d724e9151b52/bzImage-3d25a941.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/998b7ff57836/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05c1843ef85da9e52042@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq afc6cc17f332ffe0 written 24 min_key POS_MIN durability: 0 (invalid extent entry 0000000000020040)
  invalid extent entry type (got 6, max 6), shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 0
------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:23!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 2 PID: 5178 Comm: syz-executor317 Not tainted 6.9.0-rc6-syzkaller-00227-g3d25a941ea50 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__phys_addr+0x120/0x150 arch/x86/mm/physaddr.c:23
Code: 10 00 75 39 48 8b 1d 4f c8 1b 0c 48 89 ee bf ff ff ff 1f e8 72 49 4f 00 48 01 eb 48 81 fd ff ff ff 1f 76 a7 e8 51 4e 4f 00 90 <0f> 0b 48 c7 c7 bd 39 9f 8f e8 b2 99 aa 00 e9 52 ff ff ff 48 c7 c7
RSP: 0018:ffffc900032ef4a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000007ffff75e RCX: ffffffff813e77ce
RDX: ffff888011aca440 RSI: ffffffff813e77df RDI: 0000000000000007
RBP: 000000007ffff75e R08: 0000000000000007 R09: 000000001fffffff
R10: 000000007ffff75e R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 00000000663551f8 R15: ffffed1005ea010e
FS:  000055557a454380(0000) GS:ffff88806b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff7a9096410 CR3: 00000000203ec000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1306 [inline]
 kfree+0x6c/0x390 mm/slub.c:4382
 bch2_fs_recovery+0xfe9/0x3c40 fs/bcachefs/recovery.c:905
 bch2_fs_start+0x2e9/0x600 fs/bcachefs/super.c:1043
 bch2_fs_open+0xf87/0x1110 fs/bcachefs/super.c:2102
 bch2_mount+0xdcc/0x1130 fs/bcachefs/fs.c:1903
 legacy_get_tree+0x109/0x220 fs/fs_context.c:662
 vfs_get_tree+0x8f/0x380 fs/super.c:1779
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x14e6/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __x64_sys_mount+0x297/0x320 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x260 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ad400a8fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd674e3108 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd674e3120 RCX: 00007f1ad400a8fa
RDX: 0000000020011a00 RSI: 0000000020000080 RDI: 00007ffd674e3120
RBP: 0000000000000004 R08: 00007ffd674e3160 R09: 00000000000119fd
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffd674e3160 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0x120/0x150 arch/x86/mm/physaddr.c:23
Code: 10 00 75 39 48 8b 1d 4f c8 1b 0c 48 89 ee bf ff ff ff 1f e8 72 49 4f 00 48 01 eb 48 81 fd ff ff ff 1f 76 a7 e8 51 4e 4f 00 90 <0f> 0b 48 c7 c7 bd 39 9f 8f e8 b2 99 aa 00 e9 52 ff ff ff 48 c7 c7
RSP: 0018:ffffc900032ef4a0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000007ffff75e RCX: ffffffff813e77ce
RDX: ffff888011aca440 RSI: ffffffff813e77df RDI: 0000000000000007
RBP: 000000007ffff75e R08: 0000000000000007 R09: 000000001fffffff
R10: 000000007ffff75e R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000001 R14: 00000000663551f8 R15: ffffed1005ea010e
FS:  000055557a454380(0000) GS:ffff88806b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff7a9096410 CR3: 00000000203ec000 CR4: 0000000000350ef0
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
