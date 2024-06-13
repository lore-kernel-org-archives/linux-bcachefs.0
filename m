Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B63513C3CD
	for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jun 2024 07:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718264485; cv=none; b=vFxkVbfKzT+8CVqVwNfBQpq4K6rEbrSNm3iitNnK1MjhJLutzqy90BUEpT+JnKkINYyLBijboK7R5Iwyzcg6ynaCDvTPtQn151CVc5icJ4pmPhFlLmZUhYRrhZiitToAgHVOtyAR70OjAsToxMvi9Bjtbwt+eHvy/FufnZnjay8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718264485; c=relaxed/simple;
	bh=cL2BgMmHh5xV3N39hCgXXAG2U3xITd4PLsXUnEWUzXc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eySXX5rJtpZyGYy3dYTqsmWT1am3Qp9LC8oszfMZw9nyzDQYr6YD+LcI+xKXdDcFMAVVdtMYNv5ouHG4VhpnHBYdg/MVBZRkgvLdmwlKd+a9ayfYyV5mTgSwAvYw1pK/j7M83wYTi5/183G/ArkMW1FFu59gArkhZS4c7vmEhSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7eb5cbe815dso66907839f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 13 Jun 2024 00:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718264482; x=1718869282;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9uZgCpTECVNHB0F5NEpJWmdXZOe3SRCkkR5z2dCIKI4=;
        b=eIh1DeRXIFdvK/MacoMSZ2o1/HHbnS9elzj2b0YXXvM6atJBfISqLcuVutCnbJBpG1
         /uPIUZfGfyVet3LWv94ZPTBN+EnT5/Wjce67LQE33FphrJPJ8+uOIbv4kO463RfkB9IF
         EVXdI8SoEk1dw64yp+His2GvdxkBPb+HGY4sic9hMUVqCkZe0Lh0gewbjxgwkNPdWzpy
         H1+H9yR9HUc3XgSBWqViirTO4eVuP9DdTT76OhLureHq2r26LO6+pe/a+JK7ey9orC97
         FC7ASCBauJ3cUQ070v0L18+/RBxDMt9HEGkSpXywb6mxKQI3E9YysEzl9bfaZtXxG3I6
         3Jtg==
X-Forwarded-Encrypted: i=1; AJvYcCWlptK6YBLhno3sn7weY/bon2iiob1YROkoKjvG5t1mc0TZPFRzndWxmn/Q5PTWGDvv3zSriHOmeWt4y/+TqOZu/ZUHpePTr9cvhKMnZq0=
X-Gm-Message-State: AOJu0Yy6YRVffE1qywTQ5Ts2mINfYBS84tdKBqSvg8JWk3kiG4uAWPoH
	Vuf3Ee4TI4qEe0Eb6MLL4ubGkobQDbNTJGYbyLa2JGybKl6r+D+UmvcJrtS8RPS3luEciJxcl4i
	6mAgLrWviwdnzPw5hYgG6kMzbRKno+CsjEKXKw7jR3piUOonJAaSRKeA=
X-Google-Smtp-Source: AGHT+IGOJwNKfU3uUXM+aL4FPvQoVNmDdQNjqkfYrBs2HOUUQZm4sqZYPJJFLOug9cdHNFORkuKJCG4VcUeRrazoJON/a3E1zQi2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8614:b0:4b9:2bc3:46ba with SMTP id
 8926c6da1cb9f-4b93ee3ab1cmr231896173.3.1718264482514; Thu, 13 Jun 2024
 00:41:22 -0700 (PDT)
Date: Thu, 13 Jun 2024 00:41:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001c53f4061ac0a03c@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_fs_btree_key_cache_exit
From: syzbot <syzbot+a7c01586b9012e998c07@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169faf7a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81c0d76ceef02b39
dashboard link: https://syzkaller.appspot.com/bug?extid=a7c01586b9012e998c07
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13cdb5bfbafa/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a14f5d07f81/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7c01586b9012e998c07@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc000000001b: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
CPU: 1 PID: 5228 Comm: syz-executor.3 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__list_add include/linux/list.h:154 [inline]
RIP: 0010:list_add include/linux/list.h:169 [inline]
RIP: 0010:bch2_fs_btree_key_cache_exit+0x90a/0x1490 fs/bcachefs/btree_key_cache.c:968
Code: 00 fc ff df 48 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 7f 08 00 00 4c 89 e0 4d 89 66 08 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 53 08 00 00 49 8d bf e0 00 00 00 4d 89 b7 d8 00
RSP: 0018:ffffc90002f6fc48 EFLAGS: 00010206
RAX: 000000000000001b RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801d384880 RSI: ffffffff83ef4d76 RDI: ffff888012192a48
RBP: ffffe8ffad3699f8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: 00000000000000d8
R13: ffffc90002f6fcc0 R14: ffff888012192a40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c100000(0063) knlGS:0000000056f3a400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000032229000 CR3: 000000004acf4000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_fs_free fs/bcachefs/super.c:554 [inline]
 bch2_fs_release+0x107/0x870 fs/bcachefs/super.c:605
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1fa/0x5b0 lib/kobject.c:737
 deactivate_locked_super+0xbe/0x1a0 fs/super.c:473
 deactivate_super+0xde/0x100 fs/super.c:506
 cleanup_mnt+0x222/0x450 fs/namespace.c:1267
 task_work_run+0x14e/0x250 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x278/0x2a0 kernel/entry/common.c:218
 __do_fast_syscall_32+0x80/0x120 arch/x86/entry/common.c:389
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf72b7579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ffd49be8 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
RAX: 0000000000000000 RBX: 00000000ffd49c90 RCX: 0000000000000009
RDX: 00000000f740dff4 RSI: 00000000f735e361 RDI: 00000000ffd4ad34
RBP: 00000000ffd49c90 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add include/linux/list.h:154 [inline]
RIP: 0010:list_add include/linux/list.h:169 [inline]
RIP: 0010:bch2_fs_btree_key_cache_exit+0x90a/0x1490 fs/bcachefs/btree_key_cache.c:968
Code: 00 fc ff df 48 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 7f 08 00 00 4c 89 e0 4d 89 66 08 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 53 08 00 00 49 8d bf e0 00 00 00 4d 89 b7 d8 00
RSP: 0018:ffffc90002f6fc48 EFLAGS: 00010206
RAX: 000000000000001b RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801d384880 RSI: ffffffff83ef4d76 RDI: ffff888012192a48
RBP: ffffe8ffad3699f8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: 00000000000000d8
R13: ffffc90002f6fcc0 R14: ffff888012192a40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c200000(0063) knlGS:0000000056f3a400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000c000b77000 CR3: 000000004acf4000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 3 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	f8                   	clc
   4:	48 c1 e8 03          	shr    $0x3,%rax
   8:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1)
   c:	0f 85 7f 08 00 00    	jne    0x891
  12:	4c 89 e0             	mov    %r12,%rax
  15:	4d 89 66 08          	mov    %r12,0x8(%r14)
  19:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  20:	fc ff df
  23:	48 c1 e8 03          	shr    $0x3,%rax
* 27:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2b:	0f 85 53 08 00 00    	jne    0x884
  31:	49 8d bf e0 00 00 00 	lea    0xe0(%r15),%rdi
  38:	4d                   	rex.WRB
  39:	89                   	.byte 0x89
  3a:	b7 d8                	mov    $0xd8,%bh


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
