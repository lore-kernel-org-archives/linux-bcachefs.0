Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAA21CD24
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Jun 2024 03:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719546562; cv=none; b=oYLi4fQPLY2TJ0+YuHtQZfwCOgZ2+qyIyOPOHOeWRo84z72IwujWIevxyXTXq2DRGuN8dHGetFJxjxeiziWbW1sPidE8d711CzpcHcRntDC51XDhCqgtwfY4qPvh/HpL2ok7Z2bvLHMr/QwK10J33C+M23UPcOB0IJvvdeLThAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719546562; c=relaxed/simple;
	bh=4Ez0imzoqhZIdaqAVS88s2ruIY/vU2ZK5QKbU0p7CbY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=u4hT49OtZsfrwBTfmwMAjIwnC+7aUUSFeagu09Wr9raZQVRkIFhQeNzRjwbMEcLywTVBvKS0OBScdh27itRO+wSUEJGZLkHaRxFVLu4yIC8EmIEAL7jpWaUhzLPE1ITBEION5ib8cCxSoH1rJaYi59Wa+FpURwP0HU3RV9jg+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-376282b0e2bso2530875ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 27 Jun 2024 20:49:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719546560; x=1720151360;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8JwdNQNfgAC6JzHWGdFGw8Z+WdShuiruUP5M7wkwIME=;
        b=jeAW6Mk1igSXU2usDpc0uhzY1hMbUfDdv0Bu7p2sz8KQZsRdO88e8gzWzMVlVVID3m
         nq/y8Vq/Z6pOGgsw2p2XZIED5JtNXL4H1xqquVehyGfU8XZf3/amp3WaX+/sXFwCWZl/
         T8cPIU4hksYwrs9g4X17DEtI/SHUGFvB0rMbVi+MYs+kd36YTlY5PhgFhYiBP4eC8T7E
         OxpD85ZMHV8re8APXlkSQ2tqBpunpES1fXDtdA0bpicSTEM+wY3pReC7ewj0wyDv5qsP
         5tPeOlj9V6LCkq2439B4J6yzudn3eHPRuUwP8KOb+BxxcT4tfmLx6iSKmk9eXBbPut6S
         SyAA==
X-Forwarded-Encrypted: i=1; AJvYcCW1Qb/1PN8mQUefyzEDyRnJZ6WmKsXioJmfaLhbacW6jyQtYX/rMdDt77log+okAa/ujk1jZxrYQQsevbhnAlQI5UKftXnDby4iZr4QXZI=
X-Gm-Message-State: AOJu0Yx81t+V7i+ILn4m62pkuR68HHE3sJQ7xIAP9jbSqy2vdrBeQlEz
	nCeDPeyxeuEFgel6uNkjRUBOqdfJeOH4YXQ5/dPDxkPMo53v1VxqqhrzsZRT2zoDksnZS/Ialow
	AZ//yEICFM0n3PB9rrcVTKXuJZiv3o2GcHFt0Ly8iSu2K3rihV3JoCoo=
X-Google-Smtp-Source: AGHT+IEkL5gP1IvIpaLOnicTHd8Z6eZvBNeImYEDjaKPNLyjvTjKkfkc3XxebFdZD1YGsey8BlMlvF8le/v7EKcIVT5lP1Ba8rbO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ced2:0:b0:379:86a8:e438 with SMTP id
 e9e14a558f8ab-37986a8e630mr1580725ab.2.1719546559890; Thu, 27 Jun 2024
 20:49:19 -0700 (PDT)
Date: Thu, 27 Jun 2024 20:49:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e097b1061beb2182@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_release (2)
From: syzbot <syzbot+9db8552458d57264a358@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f2661062f16b Linux 6.10-rc5
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=159df741980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53ab35b556129242
dashboard link: https://syzkaller.appspot.com/bug?extid=9db8552458d57264a358
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-f2661062.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c8274ddce14a/vmlinux-f2661062.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e3623ed3bb77/bzImage-f2661062.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9db8552458d57264a358@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/super.c:567!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 PID: 5232 Comm: syz-executor.1 Not tainted 6.10.0-rc5-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__bch2_fs_free fs/bcachefs/super.c:567 [inline]
RIP: 0010:bch2_fs_release+0x722/0x870 fs/bcachefs/super.c:605
Code: 89 ee e8 c1 85 79 fd 4d 85 ed 75 20 e8 87 8a 79 fd 31 ff 4c 89 f6 e8 ad 85 79 fd 4d 85 f6 0f 84 4f fb ff ff e8 6f 8a 79 fd 90 <0f> 0b e8 67 8a 79 fd bf 07 00 00 00 f3 49 0f bc c5 89 c6 41 89 c5
RSP: 0018:ffffc90002f47d38 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888060900068 RCX: ffffffff84150573
RDX: ffff888020248000 RSI: ffffffff84150581 RDI: 0000000000000007
RBP: ffff888060900000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000607f8106a5d8
R13: 0000000000000008 R14: 0000000000000001 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:0000000057322400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000032434000 CR3: 0000000047630000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
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
RIP: 0023:0xf72c2579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000ff88f5f8 EFLAGS: 00000292 ORIG_RAX: 0000000000000034
RAX: 0000000000000000 RBX: 00000000ff88f6a0 RCX: 0000000000000009
RDX: 00000000f7418ff4 RSI: 00000000f7369361 RDI: 00000000ff890744
RBP: 00000000ff88f6a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_fs_free fs/bcachefs/super.c:567 [inline]
RIP: 0010:bch2_fs_release+0x722/0x870 fs/bcachefs/super.c:605
Code: 89 ee e8 c1 85 79 fd 4d 85 ed 75 20 e8 87 8a 79 fd 31 ff 4c 89 f6 e8 ad 85 79 fd 4d 85 f6 0f 84 4f fb ff ff e8 6f 8a 79 fd 90 <0f> 0b e8 67 8a 79 fd bf 07 00 00 00 f3 49 0f bc c5 89 c6 41 89 c5
RSP: 0018:ffffc90002f47d38 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888060900068 RCX: ffffffff84150573
RDX: ffff888020248000 RSI: ffffffff84150581 RDI: 0000000000000007
RBP: ffff888060900000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000607f8106a5d8
R13: 0000000000000008 R14: 0000000000000001 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88802c000000(0063) knlGS:0000000057322400
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000032434000 CR3: 0000000047630000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
