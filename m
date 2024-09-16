Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF31D1581F0
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Sep 2024 14:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726498534; cv=none; b=bUnMTWFiJPcvWHxA01NtODKgUOmZvVB3wz0i6tFBdiVvLLeS5CG8ULPPd0BmjLnB/jvVe3/i+dg30ZqmZWGOhYABDb3UTh0SiK6sWU/vCVxRRC2HisnWv7GwHgu3MqaACGu6NIz5R/PlihyN+e6axtX9UGjpYCfjH40sGHlj4Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726498534; c=relaxed/simple;
	bh=DMw6IOWEs1msM0juFrMd0HbnFOWacLRVO7WeMoWvpZ0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=BEiWSccAI9uK4FsKgn8Ih6GZikEGNrqgJ8H4UT0GCkFA4sqAOWFNzyj2Zh+Q9R/qypPg10MQZ9vweOVmZcNsiDu/++7qDmAgIfeTybKtzTHMOPrn8Hmjv9+tpveAZM2mGVyqQ1FLfM6xZ7RKZi4U35hyTM5Mug5KynkdX7BtAXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a0a3f10064so8553475ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Sep 2024 07:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726498532; x=1727103332;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zM3SEESxGQqi1nxR4AGUHADjXH6fwpJdAETeX45OJMs=;
        b=j6rwj4mkpG3DFQU3eyIw6N1IPZheWqY8CxKsDB6+nhoVct/BMG+79GeteZDJsl2ICs
         3kVgqu9jBJZzf2PXoj79lztudI33EdV5tcIuj0CZHoz9sUN0jtwv1ULPzQ2+U0ixHDYa
         EcCaz8DAdlD1yHwJqsI2Pcf4E4x1Xmjkjff5FQ3NTORfAYrA/hzX++XC4gjuYNh2yckT
         tFRNcax3Tm3Opgk0puYUjwKd/uG7C/j0w45zhiGigaHDfqpRHlgN+Bippt71SacufVjz
         2tubWqVSRYYvjY2OyDg0ATrKn46X3bFTHqLyJRbqhVndPyeQKxcuXSzd4elyv9Jr3NHd
         mEtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi8p/UgomlDJFZuuqukm52Jud0OktNxs/Prf5ykRSxxIE4tn0D6uo6/B4RWZGFPDuZbvamSJ+VM8I6vwGqjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwvDNiRFn3064vOgu/Dl1hc/ATr7uTnJmYX3cHwcoh0XooAYy0j
	8xtpyATNoA8nMnsxjyOVDu6to7jtDUsSMX9/Zp2Xn1RsyFvyfZ/p3MIzLhRLS7req6OaSIYvQc2
	gaDfr/Myze2sz7VNuLCIguJpj6R80GcmIWiq/ZJdZaEl3B3CLwWYKEV0=
X-Google-Smtp-Source: AGHT+IE8T5EPM0jQCTYMJhXL3qhIVr3PaX8ywAfl2yIelLRNRUrUUbJq6v3VazRrBwBVn2ZoMTuseyu4qfjgte7iHFAMJxcCFlG+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1b09:b0:3a0:ab21:e32f with SMTP id
 e9e14a558f8ab-3a0ab21e472mr12675225ab.13.1726498532078; Mon, 16 Sep 2024
 07:55:32 -0700 (PDT)
Date: Mon, 16 Sep 2024 07:55:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b5ca0f06223dc3b7@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in prt_str
From: syzbot <syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d42f7708e27c Merge tag 'for-linus-6.11' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1296963b980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1c9e296880039df9
dashboard link: https://syzkaller.appspot.com/bug?extid=37186860aa7812b331d5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1245e797980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ee6200580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b879ea3b7dd4/disk-d42f7708.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/812a7fb7bfcc/vmlinux-d42f7708.xz
kernel image: https://storage.googleapis.com/syzbot-assets/806a22d4adbf/bzImage-d42f7708.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/90be36fd33d5/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11b6d7c7980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13b6d7c7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=15b6d7c7980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+37186860aa7812b331d5@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5227 Comm: syz-executor347 Not tainted 6.11.0-rc7-syzkaller-00151-gd42f7708e27c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
RIP: 0010:strlen+0x2c/0x70 lib/string.c:402
Code: 1e fa 41 57 41 56 41 54 53 49 89 fe 48 c7 c0 ff ff ff ff 49 bf 00 00 00 00 00 fc ff df 48 89 fb 49 89 c4 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 75 12 48 ff c3 49 8d 44 24 01 43 80 7c 26 01
RSP: 0018:ffffc9000324f7c8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802cd15a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000324f8c0 R08: ffffffff84394d61 R09: ffffffff84394d37
R10: 0000000000000004 R11: ffff88802cd15a00 R12: ffffffffffffffff
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555588008380(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005651fc443668 CR3: 0000000073c3c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 prt_str+0x30/0x7d0 fs/bcachefs/printbuf.h:230
 print_mount_opts+0x29e/0x3e0 fs/bcachefs/super.c:992
 bch2_fs_start+0x36/0x5b0 fs/bcachefs/super.c:1004
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1954
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f325f0c8dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffa732dc18 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fffa732dc30 RCX: 00007f325f0c8dea
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007fffa732dc30
RBP: 0000000000000004 R08: 00007fffa732dc70 R09: 0000000000005934
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007fffa732dc70 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:strlen+0x2c/0x70 lib/string.c:402
Code: 1e fa 41 57 41 56 41 54 53 49 89 fe 48 c7 c0 ff ff ff ff 49 bf 00 00 00 00 00 fc ff df 48 89 fb 49 89 c4 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 75 12 48 ff c3 49 8d 44 24 01 43 80 7c 26 01
RSP: 0018:ffffc9000324f7c8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802cd15a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000324f8c0 R08: ffffffff84394d61 R09: ffffffff84394d37
R10: 0000000000000004 R11: ffff88802cd15a00 R12: ffffffffffffffff
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555588008380(0000) GS:ffff8880b8800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005651fc443668 CR3: 0000000073c3c000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	fa                   	cli
   1:	41 57                	push   %r15
   3:	41 56                	push   %r14
   5:	41 54                	push   %r12
   7:	53                   	push   %rbx
   8:	49 89 fe             	mov    %rdi,%r14
   b:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  12:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  19:	fc ff df
  1c:	48 89 fb             	mov    %rdi,%rbx
  1f:	49 89 c4             	mov    %rax,%r12
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	75 12                	jne    0x44
  32:	48 ff c3             	inc    %rbx
  35:	49 8d 44 24 01       	lea    0x1(%r12),%rax
  3a:	43                   	rex.XB
  3b:	80                   	.byte 0x80
  3c:	7c 26                	jl     0x64
  3e:	01                   	.byte 0x1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
