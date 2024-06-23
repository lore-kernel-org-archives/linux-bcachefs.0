Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EE5D268
	for <linux-bcachefs@vger.kernel.org>; Sun, 23 Jun 2024 09:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719134604; cv=none; b=KcqK0GnPf0Yc2OzVBmp0wNmjAm8LyRONGlhDtMofGh7eyDGfaDTg/u9M9ZQd2otHbDYT61vdNALIeLFHE8swkvCrhIeZ5u7UKO4jTbFeoWFap0Jo5BjF+PNp4Czk6FWme3FhPg2SZM8nOD45z2N6UV00yyLm9iAo4MRH7oLxr64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719134604; c=relaxed/simple;
	bh=6Tx/HlywB1SZROCmm+0pFE4Myol6DCd3FR75Xg9V2ns=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=HDnoqyCKI3wPxqmhm02TA7eIB0jwVNsDjKI1TEhaYGgDZKpLIm4NG2h8kynQMsW7+vGYroJ2VBk+Zcjrq5hhuOD50fLX7uKXWRmHv0vF62aMA/aESbzUkzOVstkULFe/wXQbQzLanoNbncRLi0ajtup4IF65B41bJrd65p5i8X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-375c390cedeso43082075ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 23 Jun 2024 02:23:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719134602; x=1719739402;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VqY8MGu33Fr6hJ7x2qiUELtvBNFTzdQxcNfjn3wa3cI=;
        b=VDy53RCDv5DkNOjjlJyxjeEQFUNvmI/Nuv8CpGp7E+ZqGI+M7Ww+ZsHg0sa2Oyb4zG
         H19aBYkc6kceIntamlNOTdOZCgtGgKo8IvKxH+4Wgunl2/6FqD1I3ONpWAnVicdmf+EY
         yiZnk2I85aMbPReMf6o8A3xYq6tYd9xUyLFEqHQSoSj3Lf66V2EdWiaBzegyEmuOzZ1L
         +R845H59+uxfdmOzNmFSM9RPVsddXexC3DZV0lLX2OOrPb9UYP3w8X71VqB+m8eJdtI1
         pgV2K8k9HZJTqlwwjfTpfKqABXZNuf9jtnblvvs/tI8ODwu4ObgrYCUy2pVQhsj7sNVG
         x4TQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN+t8TVviB13AO+4vHSMeHgeGL/gJBgDUYPGmpOOlegVAmFJVlwelstvslZU4dL6U2xfzpS3n0D+GLEqkZslhfhhBXXVa11Q8hWkFTD8g=
X-Gm-Message-State: AOJu0Yy9KhWbbRSqMjj2N6ZMF8iSXuxtkZ33JNj7pmUeAfDreb7IXg3y
	dkyyGjqAT5i3D908cekQRN7dZZP6juvmkB4p4Oj0xgfQ/z5cB/gyLrzNLt1LE+HOsW4mG1BzTeS
	uzsP44Iv7OB8Zc/sJCKtjybpjYH70Fd7ynn+/iy3J7q7giPbU6j0be2Q=
X-Google-Smtp-Source: AGHT+IGyv3MuGx17gA0syraHZyhZodWc6D7nU9m5tDT2e++xxRs+U8x6psQWUjapiNzBKV/9vlh1zU7cpHGMGM0SFHyEyv+PrUbE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:158a:b0:376:4049:69e4 with SMTP id
 e9e14a558f8ab-37640496befmr1693185ab.5.1719134601902; Sun, 23 Jun 2024
 02:23:21 -0700 (PDT)
Date: Sun, 23 Jun 2024 02:23:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004492c2061b8b3796@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bucket_alloc_freelist
From: syzbot <syzbot+3d2944b5612507034fc4@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2ccbdf43d5e7 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b13146980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=81c0d76ceef02b39
dashboard link: https://syzkaller.appspot.com/bug?extid=3d2944b5612507034fc4
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2ccbdf43.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13cdb5bfbafa/vmlinux-2ccbdf43.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7a14f5d07f81/bzImage-2ccbdf43.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d2944b5612507034fc4@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/alloc_foreground.c:489!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 3 PID: 5534 Comm: syz-executor.2 Not tainted 6.10.0-rc3-syzkaller-00044-g2ccbdf43d5e7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bch2_bucket_alloc_freelist+0xec0/0x1090 fs/bcachefs/alloc_foreground.c:489
Code: ff ff 48 8b bd 18 fe ff ff e8 7c ba 0a fe e9 19 f9 ff ff 48 8b bd 88 fe ff ff e8 db b9 0a fe e9 55 f9 ff ff e8 91 87 ad fd 90 <0f> 0b 4c 89 ef e8 c6 b9 0a fe e9 25 f8 ff ff 48 89 cf e8 e9 b9 0a
RSP: 0018:ffffc90007fde1a0 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000019 RCX: ffffc90002f22000
RDX: 0000000000040000 RSI: ffffffff83e1083f RDI: 0000000000000007
RBP: ffffc90007fde3d0 R08: ffff8880217ce120 R09: 0000000000000000
R10: 0000000000000019 R11: 0000000000000001 R12: ffff8880217ce000
R13: ffff8880217ce2f8 R14: ffff88802bb94042 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88802c300000(0063) knlGS:00000000f5f32b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000031c3b000 CR3: 0000000053c02000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bucket_alloc_trans+0x706/0xb20 fs/bcachefs/alloc_foreground.c:649
 bch2_bucket_alloc_set_trans+0x466/0xd40 fs/bcachefs/alloc_foreground.c:810
 __open_bucket_add_buckets+0x991/0x12f0 fs/bcachefs/alloc_foreground.c:1058
 open_bucket_add_buckets+0x116/0x200 fs/bcachefs/alloc_foreground.c:1102
 bch2_alloc_sectors_start_trans+0xa41/0x1ba0 fs/bcachefs/alloc_foreground.c:1457
 __bch2_btree_node_alloc+0x718/0xdc0 fs/bcachefs/btree_update_interior.c:333
 bch2_btree_reserve_get+0x21d/0x330 fs/bcachefs/btree_update_interior.c:547
 bch2_btree_update_start+0x1235/0x1ed0 fs/bcachefs/btree_update_interior.c:1245
 bch2_btree_split_leaf+0xc9/0x770 fs/bcachefs/btree_update_interior.c:1851
 bch2_trans_commit_error+0x327/0xd00 fs/bcachefs/btree_trans_commit.c:918
 __bch2_trans_commit+0x383b/0x7a40 fs/bcachefs/btree_trans_commit.c:1138
 bch2_trans_commit fs/bcachefs/btree_update.h:170 [inline]
 bch2_logged_op_start+0x122/0x1b0 fs/bcachefs/logged_ops.c:83
 bch2_truncate+0x173/0x240 fs/bcachefs/io_misc.c:291
 bchfs_truncate+0x90c/0xd70 fs/bcachefs/fs-io.c:476
 bch2_setattr+0x1ab/0x250 fs/bcachefs/fs.c:918
 notify_change+0x742/0x11f0 fs/attr.c:497
 do_truncate+0x15c/0x220 fs/open.c:65
 handle_truncate fs/namei.c:3308 [inline]
 do_open fs/namei.c:3654 [inline]
 path_openat+0x2505/0x29f0 fs/namei.c:3807
 do_filp_open+0x1dc/0x430 fs/namei.c:3834
 do_sys_openat2+0x17a/0x1e0 fs/open.c:1405
 do_sys_open fs/open.c:1420 [inline]
 __do_compat_sys_openat fs/open.c:1480 [inline]
 __se_compat_sys_openat fs/open.c:1478 [inline]
 __ia32_compat_sys_openat+0x16e/0x210 fs/open.c:1478
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf7340579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5f325ac EFLAGS: 00000292 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00000000ffffff9c RCX: 0000000020000080
RDX: 0000000000183341 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000292 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_bucket_alloc_freelist+0xec0/0x1090 fs/bcachefs/alloc_foreground.c:489
Code: ff ff 48 8b bd 18 fe ff ff e8 7c ba 0a fe e9 19 f9 ff ff 48 8b bd 88 fe ff ff e8 db b9 0a fe e9 55 f9 ff ff e8 91 87 ad fd 90 <0f> 0b 4c 89 ef e8 c6 b9 0a fe e9 25 f8 ff ff 48 89 cf e8 e9 b9 0a
RSP: 0018:ffffc90007fde1a0 EFLAGS: 00010246
RAX: 0000000000040000 RBX: 0000000000000019 RCX: ffffc90002f22000
RDX: 0000000000040000 RSI: ffffffff83e1083f RDI: 0000000000000007
RBP: ffffc90007fde3d0 R08: ffff8880217ce120 R09: 0000000000000000
R10: 0000000000000019 R11: 0000000000000001 R12: ffff8880217ce000
R13: ffff8880217ce2f8 R14: ffff88802bb94042 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88802c200000(0063) knlGS:00000000f5f32b40
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000560e79cc7088 CR3: 0000000053c02000 CR4: 0000000000352ef0
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
