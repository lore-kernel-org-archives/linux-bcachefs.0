Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B9917555
	for <linux-bcachefs@vger.kernel.org>; Thu, 19 Sep 2024 21:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726782079; cv=none; b=d1Ky5GyV07C42+5aZMfvvBpcHKPyR4nBMsynHu0BcoV9+Hk8s70cwioJzLdVSdEZSzWTmhomRcOIltt6DlS69GSDxABIZxKcyGc8LOIpSFwI0o7H/7vh4qsv6b4PiBm5bBHVh4lk4i5nWFtmrn5Wj8G+fKb+3ZByGl6wvxqwhCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726782079; c=relaxed/simple;
	bh=WnqffNCFosVi6u5lcz1YKZTGiRy5I0laQzJ1qVWoYHY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JTE0/0ziODD8jF9dd3pUSWAoFp4kS3OK2dQrY3xr/ogo23iL/MskmdzNLMozkyEr95qCeOX0yaRxhKq30OL2PuRklNEzOjE/xQvEddGHNXaIWx3ZYRjmpX0y8VTjnBbLpPlddbdQG7lZnf7LhJVj7B8YX1ccPzi0eb1TuTq7GEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a08e615804so14505385ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 19 Sep 2024 14:41:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726782077; x=1727386877;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZKX/sd8fJgGOiv0DEuPDxctGgRWqhpSMrAriHGX9S0c=;
        b=eJ2lhkwIVjIKcgYXQF9O/SGNvgcZBGHiZMhQ+XPwNCxEvlN7mRFUd/E8NRSDTIgGvu
         d0VbijKrDhVE5qEtR5p2hR5kVqWRtNQLpFkcIvmeAV0+VDZSHOkgziOB0XjbrX1C1SPH
         ykbKMjjciYjSEU4+sOU6N1yRNu3rAyuvlO/nFqIiThMUuNlSaeasmojBEBF8hRCwSh5s
         ThIv7sfMXDzwCx4CyWArXX0M1De/NI+E2iJWGszyE1IpPAPdZ+s2LeW9tugcWGhKzA56
         f++9wIYdKsoB830smhD/7bZhUneBCANbp+parMiRQ9VdKKaZ3Z5qAwDsmGK3O5eKhoUr
         Pk2A==
X-Forwarded-Encrypted: i=1; AJvYcCUL8t+cuj6mcxfYQEZtUQdaVUqS4oVZWxByfzyqCgBnbzg6CM7RWFTRa+RgwbQ1T4g0vOvHfhISCq0mm5rRRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJaNGw9bgv2Pu0MK8fRU7QEXvunbTJw3j6w8oKW8e+jmrmQj7+
	RJaH7eRQe8RkO9bX5nO1w07qaqzSJqiHprShsUw8G9DdnPQ5qlMLTUZAKcFLGXlIIK92WEiQUeR
	o+SbfDbNOkLrbmqChFI2QhIyyWBf352fr9jf1JVkMxoBsVdF3UbqwZAQ=
X-Google-Smtp-Source: AGHT+IF3fuFzd9nfh9CPtWW3qRd1mr/8OG5Q2v+hCZsV0MDhXujwJbNo8ruuXDXUeIf9NbMNMM9wClf2tl9s+ORCkfm1S3mnIJSU
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a8e:b0:3a0:b1ea:816 with SMTP id
 e9e14a558f8ab-3a0c9db0144mr5087635ab.25.1726782077160; Thu, 19 Sep 2024
 14:41:17 -0700 (PDT)
Date: Thu, 19 Sep 2024 14:41:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66ec9a7d.050a0220.29194.004a.GAE@google.com>
Subject: [syzbot] [bcachefs?] divide error in __bch2_strtoh
From: syzbot <syzbot+24beef64217854da05a4@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    932d2d1fcb2b Merge tag 'dlm-6.12' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=157b3b00580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c208b3605ba9ec44
dashboard link: https://syzkaller.appspot.com/bug?extid=24beef64217854da05a4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11bf0ca9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14d26607980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-932d2d1f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fbcb7198214b/vmlinux-932d2d1f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/418eaebf4817/bzImage-932d2d1f.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/dd062a95a35e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+24beef64217854da05a4@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
Oops: divide error: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5102 Comm: syz-executor109 Not tainted 6.11.0-syzkaller-05442-g932d2d1fcb2b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:div_u64_rem include/linux/math64.h:29 [inline]
RIP: 0010:div_u64 include/linux/math64.h:130 [inline]
RIP: 0010:__bch2_strtou64_h fs/bcachefs/util.c:143 [inline]
RIP: 0010:__bch2_strtoh+0xb59/0xeb0 fs/bcachefs/util.c:168
Code: ff 0f 88 8f 00 00 00 4c 89 74 24 08 44 89 f8 48 01 c5 48 89 2c 24 e8 96 52 49 fd 4d 89 e6 44 89 e1 48 c7 c0 ff ff ff ff 31 d2 <48> f7 f1 48 89 c5 48 8b 5c 24 18 48 89 df 48 89 c6 e8 d1 54 49 fd
RSP: 0018:ffffc90002dff8e8 EFLAGS: 00010246
RAX: ffffffffffffffff RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8880382487a2 R08: ffffffff844a8c4d R09: 0000000000000000
R10: 0000000000000009 R11: ffff88801fdc8000 R12: 1000000000000000
R13: ffff8880382487a0 R14: 1000000000000000 R15: 0000000000000001
FS:  00005555730ab380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9b13dff000 CR3: 000000004001a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_strtou64_h+0xa5/0x120 fs/bcachefs/util.c:205
 bch2_opt_parse+0x2dd/0x4c0 fs/bcachefs/opts.c:353
 bch2_parse_one_mount_opt+0x2d3/0x5e0 fs/bcachefs/opts.c:501
 bch2_fs_parse_param+0x137/0x180 fs/bcachefs/fs.c:2095
 vfs_parse_fs_param+0x1a5/0x420 fs/fs_context.c:146
 vfs_parse_fs_string fs/fs_context.c:188 [inline]
 vfs_parse_monolithic_sep fs/fs_context.c:230 [inline]
 generic_parse_monolithic+0x2c8/0x400 fs/fs_context.c:258
 do_new_mount+0x28f/0xb40 fs/namespace.c:3503
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9b1b2ffdea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef7660ac8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffef7660ae0 RCX: 00007f9b1b2ffdea
RDX: 0000000020000040 RSI: 000000002000f680 RDI: 00007ffef7660ae0
RBP: 0000000000000004 R08: 00007ffef7660b20 R09: 000000000000f62d
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffef7660b20 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:div_u64_rem include/linux/math64.h:29 [inline]
RIP: 0010:div_u64 include/linux/math64.h:130 [inline]
RIP: 0010:__bch2_strtou64_h fs/bcachefs/util.c:143 [inline]
RIP: 0010:__bch2_strtoh+0xb59/0xeb0 fs/bcachefs/util.c:168
Code: ff 0f 88 8f 00 00 00 4c 89 74 24 08 44 89 f8 48 01 c5 48 89 2c 24 e8 96 52 49 fd 4d 89 e6 44 89 e1 48 c7 c0 ff ff ff ff 31 d2 <48> f7 f1 48 89 c5 48 8b 5c 24 18 48 89 df 48 89 c6 e8 d1 54 49 fd
RSP: 0018:ffffc90002dff8e8 EFLAGS: 00010246
RAX: ffffffffffffffff RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffff8880382487a2 R08: ffffffff844a8c4d R09: 0000000000000000
R10: 0000000000000009 R11: ffff88801fdc8000 R12: 1000000000000000
R13: ffff8880382487a0 R14: 1000000000000000 R15: 0000000000000001
FS:  00005555730ab380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b9811eb7f8 CR3: 000000004001a000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	ff 0f                	decl   (%rdi)
   2:	88 8f 00 00 00 4c    	mov    %cl,0x4c000000(%rdi)
   8:	89 74 24 08          	mov    %esi,0x8(%rsp)
   c:	44 89 f8             	mov    %r15d,%eax
   f:	48 01 c5             	add    %rax,%rbp
  12:	48 89 2c 24          	mov    %rbp,(%rsp)
  16:	e8 96 52 49 fd       	call   0xfd4952b1
  1b:	4d 89 e6             	mov    %r12,%r14
  1e:	44 89 e1             	mov    %r12d,%ecx
  21:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  28:	31 d2                	xor    %edx,%edx
* 2a:	48 f7 f1             	div    %rcx <-- trapping instruction
  2d:	48 89 c5             	mov    %rax,%rbp
  30:	48 8b 5c 24 18       	mov    0x18(%rsp),%rbx
  35:	48 89 df             	mov    %rbx,%rdi
  38:	48 89 c6             	mov    %rax,%rsi
  3b:	e8 d1 54 49 fd       	call   0xfd495511


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
