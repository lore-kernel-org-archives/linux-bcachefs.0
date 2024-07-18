Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D260911717
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 01:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721265627; cv=none; b=a7V2dcVNUaR1xCvEK27W9LBgpQwScmjytibul7mHTfZYQ8Na5JsHybEII3LHHvNdq969O4ioZdsa3cn1A/aBDfTCBrEKUgG8yGhewpjeiYH7jJjIbPdx9Zev9SYjqtdx0kVbdYegDsXiMjZ9Ta6ifqNRGR2aJj3QWOcHxs0KAug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721265627; c=relaxed/simple;
	bh=BPdVVftX2d+U2W9kjO9IHLYag2yXtJxnTKw4LURjZLI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eMsk+GdaqWBbDDwyIAhXT/OwDvP5oiaIdMHp3oVLvQOjVDUQr3A9sXKE3HnVG+Usi66XW4tQ/7wwKQyzcUSgKopp6DThqMqGZtlr/9TwcpBuotwFBMn6+64KxxVtq918xQmoMnp25VkPhbIbNqQBcB2d03dlOsGlC9JXtPfQJLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7fb15d52c5cso46106039f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Jul 2024 18:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721265625; x=1721870425;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrd3jsK4XENa80T8R6an4XxbqLGWiU4eHi9rMPeCaYU=;
        b=r2eOWnb4aOaK0rEM3xSljFjPHcOcxUMYsnU8l1+duzU5HK3xCuQOVK0uL+kMu3yyY9
         DZQjlsrDcmGOPRPTcA1eK4sa1vlqqxmjjGcimoOG++BOsKR0RNY2+6GUXtmqI4GVmxwM
         X4v9aakPobP+Hinf9MoizsMO6QzqRO4LS1E210jh/k6rtI2mKPgsaFEIUUFCkgUvHqej
         mcOVQH0qsU2YVkYqUk/HCcM/Z75qamkO6SkruaIAiGRYH6WgfjaszWjpONOaLEyKF/f2
         7LR2532zMP2OgRsWjs4N5AlmADJdxKd3Pxc90kjGR5lizDIEhuRipWbv45LPfKWLSZYS
         wZDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNYfUNFIbWM/J2sjKrSPC+t3Ymk8jZxD+JmvdKfwvnwAAhQdXwoNQsbFfBQiFTu6FnEgQDMQaTal8fQBXHsJ+LJFJRTWLDM7Cr9OgKGjE=
X-Gm-Message-State: AOJu0Yxk/ovO+rOTfqPn2+5FoiPwdp5Z6/XZQDV692XptkgB2FEacd7S
	HpuCRYk1tviNlnt5mWDtlJEsQ6YELZ3nrG/H3/eLhV/h8KfnIJbAxPZ8j7DYYCSBQGdIWEbWnru
	zjQ9sWjXr43S6d3LAJDeWXNpKNRdJ/wcUMiG1j3eK2dNb69OMVQ9jcJU=
X-Google-Smtp-Source: AGHT+IEfN1rOus52VUkOw0bQfMlodhEhP5lb5phHW4jlLUrJdH82HQr0VlHmMdGTcnbNu92JPTTyB2/6toevEsKYwaikmCwGHUGw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3796:b0:4c0:a8a5:81e7 with SMTP id
 8926c6da1cb9f-4c215c85b8fmr199883173.3.1721265625048; Wed, 17 Jul 2024
 18:20:25 -0700 (PDT)
Date: Wed, 17 Jul 2024 18:20:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000025321f061d7b62ff@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in bch2_dirent_to_text
From: syzbot <syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0434dbe32053 Merge tag 'linux_kselftest-next-6.11-rc1' of ..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10fdb731980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b8bd5292e033239
dashboard link: https://syzkaller.appspot.com/bug?extid=1a11884d9c9f1353942d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122c7efd980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a7a5e9980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3766752b5090/disk-0434dbe3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3608abc3f91/vmlinux-0434dbe3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c133560ad498/bzImage-0434dbe3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2eb208d556bd/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152480b1980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=172480b1980000
console output: https://syzkaller.appspot.com/x/log.txt?x=132480b1980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a11884d9c9f1353942d@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
BUG: unable to handle page fault for address: ffffed110a6e4959
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 23ffee067 P4D 23ffee067 PUD 0 
Oops: Oops: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 PID: 5092 Comm: syz-executor341 Not tainted 6.10.0-syzkaller-02711-g0434dbe32053 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:bch2_dirent_name_bytes fs/bcachefs/dirent.c:23 [inline]
RIP: 0010:bch2_dirent_get_name fs/bcachefs/dirent.c:37 [inline]
RIP: 0010:bch2_dirent_to_text+0xba/0x2f0 fs/bcachefs/dirent.c:153
Code: bf 09 00 00 00 48 89 de e8 03 ce 78 fd 48 83 fb 08 77 09 e8 18 c9 78 fd 31 d2 eb 53 8d 45 fa 49 8d 1c c4 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 e7 4e db fd c1 e5 03 48 8b 1b 31
RSP: 0018:ffffc90002d3ed90 EFLAGS: 00010a06
RAX: 1ffff1110a6e4959 RBX: ffff888853724ac8 RCX: ffff888026263c00
RDX: 0000000000000000 RSI: ffffffffffffffd8 RDI: 0000000000000009
RBP: 0000000000000000 R08: ffffffff841d92fd R09: 0000000000000020
R10: dffffc0000000000 R11: ffffffff841d9260 R12: ffff888053724af8
R13: dffffc0000000000 R14: ffffc90002d3f540 R15: ffff888053724ad2
FS:  0000555572e1d380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed110a6e4959 CR3: 00000000795e8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 journal_entry_btree_keys_to_text+0x1d7/0x390 fs/bcachefs/journal_io.c:439
 bch2_sb_clean_to_text+0x138/0x240 fs/bcachefs/sb-clean.c:313
 bch2_sb_field_validate+0x201/0x2e0 fs/bcachefs/super-io.c:1229
 bch2_sb_validate+0xa69/0xe00 fs/bcachefs/super-io.c:468
 __bch2_read_super+0xc1b/0x1370 fs/bcachefs/super-io.c:823
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2082
 bch2_mount+0x6b0/0x13c0 fs/bcachefs/fs.c:1931
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f28ce8ed0aa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe11d678d8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe11d678f0 RCX: 00007f28ce8ed0aa
RDX: 0000000020011a00 RSI: 0000000020000000 RDI: 00007ffe11d678f0
RBP: 0000000000000004 R08: 00007ffe11d67930 R09: 00000000000119f7
R10: 0000000001200014 R11: 0000000000000282 R12: 0000000001200014
R13: 00007ffe11d67930 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
CR2: ffffed110a6e4959
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_dirent_name_bytes fs/bcachefs/dirent.c:23 [inline]
RIP: 0010:bch2_dirent_get_name fs/bcachefs/dirent.c:37 [inline]
RIP: 0010:bch2_dirent_to_text+0xba/0x2f0 fs/bcachefs/dirent.c:153
Code: bf 09 00 00 00 48 89 de e8 03 ce 78 fd 48 83 fb 08 77 09 e8 18 c9 78 fd 31 d2 eb 53 8d 45 fa 49 8d 1c c4 48 89 d8 48 c1 e8 03 <42> 80 3c 28 00 74 08 48 89 df e8 e7 4e db fd c1 e5 03 48 8b 1b 31
RSP: 0018:ffffc90002d3ed90 EFLAGS: 00010a06
RAX: 1ffff1110a6e4959 RBX: ffff888853724ac8 RCX: ffff888026263c00
RDX: 0000000000000000 RSI: ffffffffffffffd8 RDI: 0000000000000009
RBP: 0000000000000000 R08: ffffffff841d92fd R09: 0000000000000020
R10: dffffc0000000000 R11: ffffffff841d9260 R12: ffff888053724af8
R13: dffffc0000000000 R14: ffffc90002d3f540 R15: ffff888053724ad2
FS:  0000555572e1d380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffed110a6e4959 CR3: 00000000795e8000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	bf 09 00 00 00       	mov    $0x9,%edi
   5:	48 89 de             	mov    %rbx,%rsi
   8:	e8 03 ce 78 fd       	call   0xfd78ce10
   d:	48 83 fb 08          	cmp    $0x8,%rbx
  11:	77 09                	ja     0x1c
  13:	e8 18 c9 78 fd       	call   0xfd78c930
  18:	31 d2                	xor    %edx,%edx
  1a:	eb 53                	jmp    0x6f
  1c:	8d 45 fa             	lea    -0x6(%rbp),%eax
  1f:	49 8d 1c c4          	lea    (%r12,%rax,8),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 e7 4e db fd       	call   0xfddb4f20
  39:	c1 e5 03             	shl    $0x3,%ebp
  3c:	48 8b 1b             	mov    (%rbx),%rbx
  3f:	31                   	.byte 0x31


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
