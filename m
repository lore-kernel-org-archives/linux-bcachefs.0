Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D529199254
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 07:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739778867; cv=none; b=i7SRmTr7Mu9jOL2hdFwhPBOBLUVxZipzJJHNTD7Kj0nmQIRqWHS5f/vMK4IxtYxFXooGDlsflvMJK9sGpyZQIMnXadMHx0kD/nvIayg4TnaWHUW5lkLGsoEsv0NRQZI+pfNQ0vVX4h+kVLMWXtJw2PAhsdFtY0Ua+h1CoafoO5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739778867; c=relaxed/simple;
	bh=VpS7E0zow1bHWLswfAlgxGqFRHxipEFnXxOBAJSXxWM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IVmLfXBIBPxl+I6Q/xBY1n6L/8xRhISDIL9KKbYXoeuUmmfG+CVZcuClX689MHGp37wjWaxCrEjlrlOLbvCgaQxm3S97zKMzr7b19norT/gE5x6uFXVazPf6gm+7zCujO2NjGOacy+fC5FnUYFzJMWqk55r1/1PENVL/dx+FhPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d187cab068so67456745ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 16 Feb 2025 23:54:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739778864; x=1740383664;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zRkQ5044cHcmzJGX/GojjhovU3zAw/ZzG6DWHjEL9+k=;
        b=CSi1KQP+1l0l0H/CjIna71dSOYQ6lj4WqnaiXNZe/SFxVK5oQ2i6YfMrWEPPUl1u3a
         E8v9vY17vRAf6BFXhnBS0j94kdSDmSxikCqaalYUZvakmDQO7U7t7x9ntkx1gmeurSXK
         mPUtXkKjhObPn0T/d7R6pwgV4aDOhwTWYXW48ap1Po4pb5Kl7u6HY/iiN5Q2GGdqnGxj
         8SJgBA9lCWCUtjmmDsU5jd7avQYvV8cYSFUdzrGogJQBtJRquTi1PNxZrF92O+CYxhkk
         KZWBQuxZCYmYoDB3K/Aeq2NdG5liwgKklxsftRkIwK4rzdwvvIbJPaX+YiO+ocYM0IPn
         0QBw==
X-Forwarded-Encrypted: i=1; AJvYcCXL1MbVcLxy+OuIcNEfx+hufM66nCX8AyDv9m31u0uF+s/wDbjlpsLGpPu7TPzp2yVgpNph63WCtMc3AYG+Rg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzS66O3cxFcf392igD7PZ2czHmm2+8gLAMO/Z1e6jUcTpglxMr5
	gy6X3YKfAvG5uwJzmM8V2f+SPG41RJFNs+RIJaUB1XSEXRu+Zgv2nBjCz2MUyS1WGDnwabYtmwq
	tSqvf2iMViLwOsYC2aY+TlvrSubTB7BG3pAuty456C0Dm5YGGrqLXrpc=
X-Google-Smtp-Source: AGHT+IE8YhYf4UQZQYQg+69x2TPbuyV0/Mn79ybIWBx+vM+i182L6ATxzWVDaMsLCa8TUkO6E7XMhDm9da4Hauhez1h8bnMCchJd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:240b:b0:3d0:e52:7d33 with SMTP id
 e9e14a558f8ab-3d2809d114bmr84745515ab.22.1739778864559; Sun, 16 Feb 2025
 23:54:24 -0800 (PST)
Date: Sun, 16 Feb 2025 23:54:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2eb30.050a0220.173698.0022.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] kernel BUG in shmem_undo_range
From: syzbot <syzbot+0f74a9bc5e47528935fe@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ad1b832bf1cf Merge tag 'devicetree-fixes-for-6.14-1' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13ffb9b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c776e555cfbdb82d
dashboard link: https://syzkaller.appspot.com/bug?extid=0f74a9bc5e47528935fe
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146639a4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ad1b832b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/64103cb6fc45/vmlinux-ad1b832b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9bc34ac014d0/bzImage-ad1b832b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/179e2d12ea01/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0f74a9bc5e47528935fe@syzkaller.appspotmail.com

 __vm_munmap+0x372/0x510 mm/vma.c:2951
 __do_sys_munmap mm/mmap.c:1084 [inline]
 __se_sys_munmap mm/mmap.c:1081 [inline]
 __x64_sys_munmap+0x60/0x70 mm/mmap.c:1081
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
kernel BUG at mm/filemap.c:2138!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5647 Comm: syz.3.19 Not tainted 6.14.0-rc2-syzkaller-00303-gad1b832bf1cf #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:find_lock_entries+0xb8a/0xbb0 mm/filemap.c:2137
Code: f4 c6 ff 4c 89 ff 48 c7 c6 40 d7 33 8c e8 9e 91 11 00 90 0f 0b e8 16 f4 c6 ff 4c 89 ff 48 c7 c6 20 d1 33 8c e8 87 91 11 00 90 <0f> 0b e8 ff f3 c6 ff 4c 89 ff 48 c7 c6 00 da 33 8c e8 70 91 11 00
RSP: 0018:ffffc90002d2f100 EFLAGS: 00010246
RAX: 9a94e420221a6800 RBX: ffffc90002d2f5c0 RCX: ffffc90002d2ed03
RDX: 0000000000000001 RSI: ffffffff8c2ab6a0 RDI: ffffffff8c80ed00
RBP: ffffc90002d2f250 R08: ffffffff903cdd77 R09: 1ffffffff2079bae
R10: dffffc0000000000 R11: fffffbfff2079baf R12: 000000000000030e
R13: 0000000000000001 R14: ffffea000135cec0 R15: ffffea000135cec0
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005604856a8600 CR3: 00000000534c6000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 shmem_undo_range+0x2d4/0x1820 mm/shmem.c:1094
 shmem_truncate_range mm/shmem.c:1224 [inline]
 shmem_evict_inode+0x29b/0xa80 mm/shmem.c:1352
 evict+0x4e8/0x9a0 fs/inode.c:796
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 dput+0x19f/0x2b0 fs/dcache.c:885
 __fput+0x60b/0x9f0 fs/file_table.c:472
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0xa2a/0x28e0 kernel/exit.c:938
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 get_signal+0x168c/0x1720 kernel/signal.c:3036
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6d6738b89f
Code: Unable to access opcode bytes at 0x7f6d6738b875.
RSP: 002b:00007f6d68182df0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: 0000000000772000 RBX: 0000000001000000 RCX: 00007f6d6738b89f
RDX: 0000000001000000 RSI: 00007f6d5e000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 000000000000590c
R10: 0000000000000002 R11: 0000000000000293 R12: 0000000000000003
R13: 00007f6d68182ef0 R14: 00007f6d68182eb0 R15: 00007f6d5e000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:find_lock_entries+0xb8a/0xbb0 mm/filemap.c:2137
Code: f4 c6 ff 4c 89 ff 48 c7 c6 40 d7 33 8c e8 9e 91 11 00 90 0f 0b e8 16 f4 c6 ff 4c 89 ff 48 c7 c6 20 d1 33 8c e8 87 91 11 00 90 <0f> 0b e8 ff f3 c6 ff 4c 89 ff 48 c7 c6 00 da 33 8c e8 70 91 11 00
RSP: 0018:ffffc90002d2f100 EFLAGS: 00010246
RAX: 9a94e420221a6800 RBX: ffffc90002d2f5c0 RCX: ffffc90002d2ed03
RDX: 0000000000000001 RSI: ffffffff8c2ab6a0 RDI: ffffffff8c80ed00
RBP: ffffc90002d2f250 R08: ffffffff903cdd77 R09: 1ffffffff2079bae
R10: dffffc0000000000 R11: fffffbfff2079baf R12: 000000000000030e
R13: 0000000000000001 R14: ffffea000135cec0 R15: ffffea000135cec0
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005604856a8600 CR3: 00000000534c6000 CR4: 0000000000352ef0
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
