Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83E739B
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 03:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716088175; cv=none; b=iJDEsWGtL0RGkXm8VPFVSlrEt5DPn/FZLe+XwEpyn6yzLQTzlymtC+3lH72oZ2rx8n+iQAgtW1JBV2tgZDLFgDaTc7Yv0I2bhpbFJAf18YIamueFIjhTx9srIVn/NzucLnV6XITd0J7vil2r3V/uNWO8IaQT7BVBDeXnbXiZzAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716088175; c=relaxed/simple;
	bh=zICCI2mfS6eA5y7QIY8VtOLfKTbSjH/bX4JsI6glxro=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=suughRBg+PNi1Jo0IOCuXLzz5RH7hvXa8P3jLrGZ93zJxSDqEscpZVZoKZjBWoQrTERVk3grtUy9sVOErj8svMGfh85C48L+al9f0xdCyNENeYO5uiy8XSfHBSelC7IOtSqlmPgaVd11/32QgXVR9je5PEO1Wvw/wWGc0h+L6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7e1bcad7693so1056200439f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 18 May 2024 20:09:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716088173; x=1716692973;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h3rnlsQj06wus4CY4g2DZxA8MLIYhenwsHcYM9K/6Kk=;
        b=P3Weib+CU+5SP0AoRwClHBQar2+SHs78QY/QXne+yeEZui8ExJ/2ND4AgfDxXfwYPV
         xbYb2REpJhfEga1b7HVhYUFk3xQl/8IA5HGY6OqLOX8et3IOnX9IWlVxRp5h3jYFAR4y
         5GIJYNFcvJ8KcnzemzoskU6xzUXMr+SLVjFOqSpsXudLY5b5grFu9yJ3MKEkMSHCeBjM
         NnOzIDEm5BtAZki7Me3Ny3ATlW2/NGlRg7jVekUeM2Vilj80PPjl/byEvl1ULHhCehKc
         jTGT0HYTymR8mFk8PbKUI1o0RHmruR4sSnoEVK4J5X6t6BQuu61orpT8hnWR3zq1RscP
         o/Vg==
X-Forwarded-Encrypted: i=1; AJvYcCXh54FEeGnxQvZPviFDhSJrN54SzMKy0MtY8+JfLZTgFArCQXnIAX6dVgEBx1DlTmWLjc7q4Ba9Ra2N23pEa7L3yQ7DaXSF+B43U3XQeoc=
X-Gm-Message-State: AOJu0YzLdO8lArrRhm21drg8+onel2epHqWm/nlISba8d4HNkNBeW+To
	UYYxU9X/5ZBw0EklKPNN1PH3UH6UVAlk9cQGbcXrw9vH+VpRFpSg80wyN6o0GJEe+RlZmCugb5M
	Bl0PgJUG42bMJmEDctcOK10EUVG0uR6AnSHwRT5fMGW4DN+6ZJ7yfQ28=
X-Google-Smtp-Source: AGHT+IFwilzbzsE6nPPWZbvD3J35zI2zeITjm1a8MyPJ4IvOOJLoiwpFyuQ0qpd1PChcCKjdQ+TIGjR3h0OalNYkaTT/eXXMhchd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8509:b0:488:75e3:f3c4 with SMTP id
 8926c6da1cb9f-48959fafe3fmr2102241173.4.1716088173135; Sat, 18 May 2024
 20:09:33 -0700 (PDT)
Date: Sat, 18 May 2024 20:09:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f6b2590618c5e9db@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_writepage_io_done
From: syzbot <syzbot+b643774cddb3862d7886@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6bfd2d442af5 Merge tag 'irq-core-2024-05-12' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=164a1c3f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=395546166dcfe360
dashboard link: https://syzkaller.appspot.com/bug?extid=b643774cddb3862d7886
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-6bfd2d44.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7ad901fe99c6/vmlinux-6bfd2d44.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8d6ef2df621f/bzImage-6bfd2d44.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b643774cddb3862d7886@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 2 PID: 5296 at fs/bcachefs/fs-io-buffered.c:438 bch2_writepage_io_done+0x8fc/0xe20 fs/bcachefs/fs-io-buffered.c:438
Modules linked in:
CPU: 2 PID: 5296 Comm: syz-executor.1 Not tainted 6.9.0-syzkaller-01893-g6bfd2d442af5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bch2_writepage_io_done+0x8fc/0xe20 fs/bcachefs/fs-io-buffered.c:438
Code: ff e8 28 5d 90 fd 8b 84 24 88 00 00 00 48 8b 74 24 08 48 8b 7c 24 10 8d 50 01 89 04 24 e8 cc ec ff ff eb c5 e8 05 5d 90 fd 90 <0f> 0b 90 e8 fc 5c 90 fd 48 8b 44 24 18 48 8d 78 f8 48 b8 00 00 00
RSP: 0018:ffffc90002c173b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000008 RCX: ffffffff83fe3d29
RDX: ffff88801ec48000 RSI: ffffffff83fe447b RDI: 0000000000000007
RBP: 0000000000000008 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000002 R12: ffffea00019079c0
R13: ffff888060fe5700 R14: dffffc0000000000 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88802c400000(0063) knlGS:00000000f5eedb40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 000055680e9c9e18 CR3: 000000005d36e000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_write_done+0x243/0x400 fs/bcachefs/io_write.c:478
 bch2_write_data_inline fs/bcachefs/io_write.c:1550 [inline]
 bch2_write+0xab2/0x13f0 fs/bcachefs/io_write.c:1616
 bch2_writepages+0x136/0x200 fs/bcachefs/fs-io-buffered.c:660
 do_writepages+0x1a3/0x7f0 mm/page-writeback.c:2613
 filemap_fdatawrite_wbc mm/filemap.c:397 [inline]
 filemap_fdatawrite_wbc+0x148/0x1c0 mm/filemap.c:387
 __filemap_fdatawrite_range+0xba/0x100 mm/filemap.c:430
 file_write_and_wait_range+0xd0/0x140 mm/filemap.c:788
 bch2_fsync+0xa1/0x2a0 fs/bcachefs/fs-io.c:197
 vfs_fsync_range+0x141/0x230 fs/sync.c:188
 generic_write_sync include/linux/fs.h:2811 [inline]
 bch2_buffered_write fs/bcachefs/fs-io-buffered.c:1136 [inline]
 bch2_write_iter+0x756/0x3180 fs/bcachefs/fs-io-buffered.c:1144
 call_write_iter include/linux/fs.h:2120 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x6b6/0x1120 fs/read_write.c:590
 ksys_write+0x12f/0x260 fs/read_write.c:643
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x75/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf72fb579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5eed5ac EFLAGS: 00000292 ORIG_RAX: 0000000000000004
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000020001900
RDX: 000000000000000b RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
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
