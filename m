Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E662323CE
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 May 2024 03:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716609023; cv=none; b=Eq1u/1V2zPSkhAFDJy22ioJ/DbJW53a84dvrdigMCH963Htw49GAfhOUAma8dYg4Hzp5Rbk8MJ4yzafzYsC7DPvPYkSO8HjlDKSrMBvfPYZsA0/0mzFs2SAqa8bm0wkesnR9Ib/HogqBZT9BRX//GO+sWPXwIFyyTq8puKwJviU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716609023; c=relaxed/simple;
	bh=04e0iFaLdmXGkZM8lqn+cCR6xiFvZ0L31j1DmpefSIo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OwzZUqjbAEtsglyccsbRZes5hdH82jkdzDmXiXlsjwBXpBixzs2iFzQLl359Gw5T6612xhigzixmL8Qr5iGB/NqIAhTJlJ6HNQ56JAEV3MqP91zmBsmWcKZ7us1PhbQTvG7r++h8U1AL4A9Jz/kkF4sM35z1XUItCohSufuP490=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3737b3db665so16726025ab.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 May 2024 20:50:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716609021; x=1717213821;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QKPNbdGh9u9aMJeo1SjEg9KsR8vOcDWPVbRPuND0hu4=;
        b=GbGDK4WgiB/o+arA/MIMVIoERCkfNGocszifXYDQPHBvqaZTvjMvlYHIu0ylEHGKT+
         81JuNtwcEe+M0wujUYhWGnjWtESjaxS+klAilATrvDOukPZI1vb/jep7ZYDun+ncaDzA
         eZP3hVTk5+i2hmAUt2NItmtK+PiAA0qt+I9PDsrMQVapH4IjaF/7samnvBoF0XSroOCQ
         pls/yHealy6rj/hdqjQ6IsVVbXy6lryzxKSMGd1sXnd41KObwCIOXhyiflDpcJFcgY33
         f/bSvHMFAeXzJng2Xea8Sqi9PknFmiVSEs08qI4pC+DBzC5Qy/RfnJc1HE5zOnZElJcj
         aNTA==
X-Forwarded-Encrypted: i=1; AJvYcCUuGNgSD8fUcQ/re9/k6sKd/1H426P4QyM35Re7NNxD+zwRGbtEZXh7snOcd/tXXGmMc2AmVdEHUA5LOlO7M32llj2WEk1+knamF1vdvtI=
X-Gm-Message-State: AOJu0YyrZkPyKVp3tf3DiEAV+2EercIqSaEXt0FFAyeNhBxNUoDggQD+
	1oqk1aq1QKVDMoPuE7WJ+1jpzsrniJIZbtkngHgbtq3U+RER+p0MOL4qcNWFIANhtDWgAVc/hXi
	BWKjNG8tCVFcYCwu2p2DocjIUu00yZzhzVchgo4DMASmKR99UcMqGRqo=
X-Google-Smtp-Source: AGHT+IF7TcmogvrdNsmxOquvj+MVvTJgA3T0scIpC00VYn64lUjbviyQ8Gk7LvqUQ85n7AWGIU1dX8i9UryPKmu5j7Fbwt5Y87oH
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8d:b0:36d:a793:51a with SMTP id
 e9e14a558f8ab-3737b330202mr2949695ab.3.1716609021228; Fri, 24 May 2024
 20:50:21 -0700 (PDT)
Date: Fri, 24 May 2024 20:50:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000edcc7906193f2e93@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_release
From: syzbot <syzbot+a8074a75b8d73328751e@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6e51b4b5bbc0 Merge tag 'mips_6.10' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1499dbe4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d5d254b2919253a
dashboard link: https://syzkaller.appspot.com/bug?extid=a8074a75b8d73328751e
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6e51b4b5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a78abf5bef3/vmlinux-6e51b4b5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/283fe971fc00/bzImage-6e51b4b5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a8074a75b8d73328751e@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
workqueue: Failed to create a rescuer kthread for wq "bcachefs": -EINTR
bcachefs (076a1832-646e-4f3c-b13d-b3e266154efd): shutdown complete
------------[ cut here ]------------
kernel BUG at fs/bcachefs/super.c:567!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 2 PID: 6873 Comm: syz-executor.0 Not tainted 6.9.0-syzkaller-09868-g6e51b4b5bbc0 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__bch2_fs_free fs/bcachefs/super.c:567 [inline]
RIP: 0010:bch2_fs_release+0x6b0/0x810 fs/bcachefs/super.c:603
Code: 89 ee e8 63 7d 7b fd 48 85 ed 75 34 e8 29 82 7b fd 31 ff 4c 89 ee e8 4f 7d 7b fd 4d 85 ed 0f 84 02 fc ff ff e8 11 82 7b fd 90 <0f> 0b e8 09 82 7b fd 48 8b 7c 24 10 e8 7f 63 d9 ff e9 cb fa ff ff
RSP: 0000:ffffc9000e047410 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff888061080068 RCX: ffffc90003f21000
RDX: 0000000000040000 RSI: ffffffff8412febf RDI: 0000000000000007
RBP: 0000000000000008 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88802c200000(0063) knlGS:00000000f5e8fb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000edabe000 CR3: 00000000120f0000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x1fa/0x5b0 lib/kobject.c:737
 bch2_fs_alloc+0xe49/0x2550 fs/bcachefs/super.c:954
 bch2_fs_open+0x713/0x10f0 fs/bcachefs/super.c:2102
 bch2_mount+0xd41/0x1090 fs/bcachefs/fs.c:1917
 legacy_get_tree+0x109/0x220 fs/fs_context.c:662
 vfs_get_tree+0x8f/0x380 fs/super.c:1779
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x6e1/0x1f10 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __ia32_sys_mount+0x295/0x320 fs/namespace.c:3875
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf729d579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5e8f400 EFLAGS: 00000292 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00000000f5e8f460 RCX: 0000000020000080
RDX: 0000000020011a00 RSI: 0000000001200014 RDI: 00000000f5e8f4a0
RBP: 00000000f5e8f460 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bch2_fs_free fs/bcachefs/super.c:567 [inline]
RIP: 0010:bch2_fs_release+0x6b0/0x810 fs/bcachefs/super.c:603
Code: 89 ee e8 63 7d 7b fd 48 85 ed 75 34 e8 29 82 7b fd 31 ff 4c 89 ee e8 4f 7d 7b fd 4d 85 ed 0f 84 02 fc ff ff e8 11 82 7b fd 90 <0f> 0b e8 09 82 7b fd 48 8b 7c 24 10 e8 7f 63 d9 ff e9 cb fa ff ff
RSP: 0000:ffffc9000e047410 EFLAGS: 00010246
RAX: 0000000000040000 RBX: ffff888061080068 RCX: ffffc90003f21000
RDX: 0000000000040000 RSI: ffffffff8412febf RDI: 0000000000000007
RBP: 0000000000000008 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000008
R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88802c200000(0063) knlGS:00000000f5e8fb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000edabe000 CR3: 00000000120f0000 CR4: 0000000000350ef0
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
