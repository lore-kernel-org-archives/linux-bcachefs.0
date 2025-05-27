Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9723C01
	for <linux-bcachefs@vger.kernel.org>; Tue, 27 May 2025 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748358936; cv=none; b=KjRlGDCnZXQzYJsorFcjHjaQ3yzIKYXHcqmf7anMdzWUSvaVzwAumi28UbeXVwD1hgqI3cvwBZMfhkEr37cOFfEnATBFwYc8ts6qxQpgQ3O7VnMisGUDI79YIoOgZQixQ9QO6/xYHTEgvIxnyJbFYdnsdy8+W227zfAodoa9ohM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748358936; c=relaxed/simple;
	bh=iN6cqiG7kIwK8LzLIlGU8Xc2+gy7mGgnlznNjn9rCXU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CMr9xMoJlCjoORPPx2GehlNWg1mjHEh147cooiG79Q0LW62NmT2eXdxGrt/zQxSTkjMkjGh4CxmI9v7nBDZ9TLLwr09I5qSvh8byK6Smpocz0+m5ofY/EgajP2dT6NIDsx8Y7SfYtMb2HT+raFVcYjwRIVHRIn6o7JtT009nSPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-85b4dc23f03so606850839f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 27 May 2025 08:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748358933; x=1748963733;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hbBLAojSH8VzIJegjIqwElq/FCdrG3p4TFJscWwijN8=;
        b=d7QRnl8D3exIGWxzpYz6y6Fue+vvSzVhtsxxofBZv8/eWm6oYTzLTFIwOmXdgOeEsa
         roWcrIjvo1/qt6yHvfwSOXA3yyidUquKA9XjU5MdZkcdZXTFBSA4s73VhG6QWXQYAqPR
         MulULyBgLhstZO+ZfqvqmBh2gKmVbsd9nd5z1kfUj/MMtEKQ4YRV/SAueeyV2NYT4Hwg
         UZei7WETE+RHVe+EONkupOLCDx17org78EVAJ4Cd8UNfO7iwyUkSbkfAD/W3OnaLXzth
         vCbd/EFZeG3UCEDAXhn41vDdztQQCC+FJCPAz7Yz9wsp31J28m+H2ohBCGfFUt09rTNi
         zq2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWSz+7JfYzwhgTmuZgUff2dncl24/XDXP1RhtC6Iyi8hYWIUVz4LZQn0feubJTW081sj+f3gq2kUx30u6MVNA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0F9n8P0y7CU+4l7XVn4aelmA8YLP5VzLxIz4/NTduMm8HYtCf
	mCIYdP9ZTWEjZwyiG8XhRR90t7dQQG7TJ32a6qrqHDPbFKGBdS3C5Ez4lL7KzQOl4/kclmfpIwh
	04KxdZvbhZSoq/srg0piBVkh+2kUvVgT2L1GjD0ZRK60+WaWLbg2nkgPmYVQ=
X-Google-Smtp-Source: AGHT+IGCEg+q/6J2jASmg+XPgkSQldLs7G35rePtfyBcvwRXeQodmMwhXantL5BW+jCSnzdunS6gRUEL1RGBvqdWnGT0f15mBxo/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:4a0d:b0:86a:25d5:2dbe with SMTP id
 ca18e2360f4ac-86cbb7dcffamr1644475039f.4.1748358933443; Tue, 27 May 2025
 08:15:33 -0700 (PDT)
Date: Tue, 27 May 2025 08:15:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6835d715.a70a0220.253bc2.00b9.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in __bch2_bkey_unpack_key
From: syzbot <syzbot+9b7e20f8ff98aed7254e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ddddf9d64f73 Merge tag 'perf-core-2025-05-25' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=163e3170580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd18a1001092f95b
dashboard link: https://syzkaller.appspot.com/bug?extid=9b7e20f8ff98aed7254e
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160226d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1465bdf4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-ddddf9d6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bc551d1d4e46/vmlinux-ddddf9d6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d26a6de23b0e/bzImage-ddddf9d6.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/92cf6b656172/mount_6.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9b7e20f8ff98aed7254e@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffed1108cc0204
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 5ffcd067 P4D 5ffcd067 PUD 0 
Oops: Oops: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5312 Comm: read_btree_node Not tainted 6.15.0-syzkaller-01599-gddddf9d64f73 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:unpack_state_init fs/bcachefs/bkey.c:151 [inline]
RIP: 0010:__bch2_bkey_unpack_key+0x5b/0xe10 fs/bcachefs/bkey.c:269
Code: 42 0f b6 04 38 84 c0 0f 85 b2 09 00 00 48 89 5c 24 18 0f b6 1b 8d 43 ff 4c 8d 34 c5 00 00 00 00 4d 01 ee 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 f6 32 0c fe 4c 89 74 24 08 49 8b
RSP: 0018:ffffc9000d336ab8 EFLAGS: 00010a02
RAX: 1ffff11108cc0204 RBX: 0000000000000000 RCX: ffff88801fd64880
RDX: 0000000000000000 RSI: ffff88803ed370c0 RDI: ffffc9000d336d30
RBP: ffffc9000d336dc8 R08: ffff88801fd64880 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: ffffc9000d336d30
R13: ffff888046601028 R14: ffff888846601020 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88808d6b1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed1108cc0204 CR3: 0000000043885000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_bkey_compat+0x4db/0xbd0 fs/bcachefs/bkey_methods.c:480
 bch2_bkey_compat fs/bcachefs/bkey_methods.h:134 [inline]
 validate_bset_keys+0x6c1/0x1390 fs/bcachefs/btree_io.c:983
 bch2_btree_node_read_done+0x18c8/0x4f60 fs/bcachefs/btree_io.c:1211
 btree_node_read_work+0x426/0xe30 fs/bcachefs/btree_io.c:1400
 bch2_btree_node_read+0x887/0x29f0 fs/bcachefs/btree_io.c:-1
 bch2_btree_node_fill+0xd12/0x14f0 fs/bcachefs/btree_cache.c:994
 bch2_btree_node_get_noiter+0xa2c/0x1000 fs/bcachefs/btree_cache.c:1261
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:220 [inline]
 read_btree_nodes_worker+0x1319/0x1e20 fs/bcachefs/btree_node_scan.c:269
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
CR2: ffffed1108cc0204
---[ end trace 0000000000000000 ]---
RIP: 0010:unpack_state_init fs/bcachefs/bkey.c:151 [inline]
RIP: 0010:__bch2_bkey_unpack_key+0x5b/0xe10 fs/bcachefs/bkey.c:269
Code: 42 0f b6 04 38 84 c0 0f 85 b2 09 00 00 48 89 5c 24 18 0f b6 1b 8d 43 ff 4c 8d 34 c5 00 00 00 00 4d 01 ee 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 f6 32 0c fe 4c 89 74 24 08 49 8b
RSP: 0018:ffffc9000d336ab8 EFLAGS: 00010a02
RAX: 1ffff11108cc0204 RBX: 0000000000000000 RCX: ffff88801fd64880
RDX: 0000000000000000 RSI: ffff88803ed370c0 RDI: ffffc9000d336d30
RBP: ffffc9000d336dc8 R08: ffff88801fd64880 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: ffffc9000d336d30
R13: ffff888046601028 R14: ffff888846601020 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88808d6b1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed1108cc0204 CR3: 0000000043885000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax
   5:	84 c0                	test   %al,%al
   7:	0f 85 b2 09 00 00    	jne    0x9bf
   d:	48 89 5c 24 18       	mov    %rbx,0x18(%rsp)
  12:	0f b6 1b             	movzbl (%rbx),%ebx
  15:	8d 43 ff             	lea    -0x1(%rbx),%eax
  18:	4c 8d 34 c5 00 00 00 	lea    0x0(,%rax,8),%r14
  1f:	00
  20:	4d 01 ee             	add    %r13,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 f6 32 0c fe       	call   0xfe0c332f
  39:	4c 89 74 24 08       	mov    %r14,0x8(%rsp)
  3e:	49                   	rex.WB
  3f:	8b                   	.byte 0x8b


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
