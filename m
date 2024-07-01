Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1763D16EB6A
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Jul 2024 17:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719855151; cv=none; b=ZBaueHEc2rOdFoFN3WynQeXWPIc6FE9asCXzN3dAvONQ6slnLdmM/pH7ayw+eKS6II2DeOmoI5JlbWPINdq2vmfq0VfWY4E5eSQwynEfXONZVasln/Pqli0naHMC6zVoTsZttwaEwYuJDO2wEdrFCfa5EluUpit8aUj06tQcg4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719855151; c=relaxed/simple;
	bh=51Kq3gRK+jS3Cu8UCGhkoVM3OSd3sQMg5c/pQd13i4Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=aBgA0bgRj6uEVNMozkHPReWmMw8/MDWaDwk2vKwqv3lIrb3ciV0zfZpYZpDuhYepc0KmJ5JF1XVnLmrOoMYQapguZRKB1U7Uq88hOu/XupeGcFyGuAhX+HZZnkqAgSvU5TM26xGyVLX0kxm63FmM/qn6bKxCQrC6ePVLZRVCzdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7f61f4c998bso346558239f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 01 Jul 2024 10:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719855149; x=1720459949;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ffa27t3BLrBDQAt47I5b6vb7eILrf+TZVezmh48Gadw=;
        b=lJaQujoL1NaDsj/SDMGjdEKCqsg1a33U9v5qQXC7w2eyGYCmYQZfRa9WWp+huudIDC
         iMjd3MpBq0yc2Is7CFiR8TaaT+7w1YDIlObcvSrqX4NRnFx5K+iI3oT0HAP02xn6t+e4
         ezBf2NqYUV1m9u5NzFxOxYkawYDgl3KEW+oTEwyX5GrpMTmwWLhs51sUj8FVXfAMVZlh
         Yy7ESdbYAc1cSqLHS0jNJqWpbCNGs8g0Atk3B7IkYQbmi+fraYfnw8GsNztFap//jQeV
         7TxBdEFb2tvO4M97uk+9yq+Ul0QgKkzPCUHVRAimvJZvw6XT/qTqoNbb75NyWsYQNefJ
         rPBg==
X-Forwarded-Encrypted: i=1; AJvYcCVjnXWRPZFvubrv6akfF0CZTAQQM2wbIKhxwvCd8nIRD6OJsG84cRvEtLP/IUTxwD7nU/1e4JocoIKJTVR+AGvgm2OS8PedgiswJSu9Prs=
X-Gm-Message-State: AOJu0Yzj+TXXNxFIVAaxEDMrrb5g5eO3a+cYSL95XtnF71/kh77IHuNR
	ORfj8M/zpwlCLrrrG2Da2iqlJIJkwtmpeU/8HkIiNkXd6NsMmuyv5IWIUhRXE6yRIZFo3onRy0j
	+a4LJw/k4cHodnjHewW6R9gt015Tpn9t+0xs4YMXPTR81OsChqHSoqFw=
X-Google-Smtp-Source: AGHT+IGsHkpF/sHm10D4ueOGx0LXZnSx/de8pd3wSKZeEB0AuL81ha9X6popDv3dKCdM3xkPYLYae3r5DGjx18oWZ6W+BMxBxJFF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3f8a:b0:7f6:1590:447b with SMTP id
 ca18e2360f4ac-7f62eeaf6c7mr54907839f.4.1719855149319; Mon, 01 Jul 2024
 10:32:29 -0700 (PDT)
Date: Mon, 01 Jul 2024 10:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003d9ca1061c32fbb7@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_fs_btree_key_cache_exit
 (2)
From: syzbot <syzbot+3093e1444fd7fe5e374a@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    55027e689933 Merge tag 'input-for-v6.10-rc5' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14d8e561980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53ab35b556129242
dashboard link: https://syzkaller.appspot.com/bug?extid=3093e1444fd7fe5e374a
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-55027e68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a36929b5a065/vmlinux-55027e68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d72de6f61ddc/bzImage-55027e68.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3093e1444fd7fe5e374a@syzkaller.appspotmail.com

bcachefs (loop2): flushing journal and stopping allocators complete, journal seq 12
bcachefs (loop2): shutdown complete, journal seq 13
bcachefs (loop2): marking filesystem clean
bcachefs (loop2): shutdown complete
Oops: general protection fault, probably for non-canonical address 0xdffffc000000001b: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
CPU: 0 PID: 5266 Comm: syz-executor.2 Not tainted 6.10.0-rc5-syzkaller-00018-g55027e689933 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__list_add include/linux/list.h:154 [inline]
RIP: 0010:list_add include/linux/list.h:169 [inline]
RIP: 0010:bch2_fs_btree_key_cache_exit+0x90a/0x1490 fs/bcachefs/btree_key_cache.c:968
Code: 00 fc ff df 48 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 7f 08 00 00 4c 89 e0 4d 89 66 08 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 53 08 00 00 49 8d bf e0 00 00 00 4d 89 b7 d8 00
RSP: 0018:ffffc90002e67c48 EFLAGS: 00010206
RAX: 000000000000001b RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801de2a440 RSI: ffffffff83ef5656 RDI: ffff888000932a48
RBP: ffffe8ffad043af0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: 00000000000000d8
R13: ffffc90002e67cc0 R14: ffff888000932a40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:0000000056b3b400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002c47f000 CR3: 0000000052d8e000 CR4: 0000000000350ef0
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
RIP: 0023:0xf7307579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ff9c55d8 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
RAX: 0000000000000000 RBX: 00000000ff9c5680 RCX: 0000000000000009
RDX: 00000000f745dff4 RSI: 00000000f73ae361 RDI: 00000000ff9c6724
RBP: 00000000ff9c5680 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add include/linux/list.h:154 [inline]
RIP: 0010:list_add include/linux/list.h:169 [inline]
RIP: 0010:bch2_fs_btree_key_cache_exit+0x90a/0x1490 fs/bcachefs/btree_key_cache.c:968
Code: 00 fc ff df 48 89 f8 48 c1 e8 03 80 3c 08 00 0f 85 7f 08 00 00 4c 89 e0 4d 89 66 08 48 b9 00 00 00 00 00 fc ff df 48 c1 e8 03 <80> 3c 08 00 0f 85 53 08 00 00 49 8d bf e0 00 00 00 4d 89 b7 d8 00
RSP: 0018:ffffc90002e67c48 EFLAGS: 00010206
RAX: 000000000000001b RBX: 0000000000000000 RCX: dffffc0000000000
RDX: ffff88801de2a440 RSI: ffffffff83ef5656 RDI: ffff888000932a48
RBP: ffffe8ffad043af0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000003 R12: 00000000000000d8
R13: ffffc90002e67cc0 R14: ffff888000932a40 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:0000000056b3b400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000000002c47f000 CR3: 0000000052d8e000 CR4: 0000000000350ef0
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
