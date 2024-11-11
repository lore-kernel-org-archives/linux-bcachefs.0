Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8AD155A59
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 19:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731354220; cv=none; b=mMHQDoi9N0MTUG4J+s8GXi8/J6zaUerry+jDgQEWWHbHT8Elgp5jDMgZypPPpHSkr0bElrWpKcVVK2EQOblTSz5J8eID35cGHeAA5TnrSAoPZ7xIyyiEC//7zGw6DacNK8UTuGe7HfRmMLYuLkJXdhCf1k4JcurwDL27K9AtQus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731354220; c=relaxed/simple;
	bh=Jpf2lVDYLsz2Dh5eQmV489aQF4P34ezxufCk2EkKYgg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=KYRbpN3SCb3TSE2/YZhduDy289DyRiqccvqEULwAoXXQpVFj739TZhdggpCl7glgtHpDjzmry99jhIz70VQ6on4uRP7as6Af0PHZF+3gHxfr5CPSE9mbYOwwLvqNYgSuXtgaR5JtRWXpr/B5xX6zz6JCOfQpSZHPl61QU2Vw6hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a6b963ca02so52509655ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 11:43:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731354218; x=1731959018;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vDGwHnpOwf6tNPDnZzoJVk+8E75wYbMbZEnO4Z7zOiY=;
        b=O8LKzpOwSUsN2ln2zo52w5CAZQ3phRD16cx3GnH85Y9b0ZkSaZYzNoFKB6NtHscGK/
         ngIFiHcnUyKoG0JEExg7qD3ZaE+8Y01MaCP62FQm4LSahXjqRXnENgZmClPsZ2dDHwwo
         L5Y27sOa8Ti2fhCyx9t13mYp201VYzRqyEyRiUkwMYXuvp36DgVvCLV+nHtzoHJYRYYd
         byTLgGe6IAamhuVA+VxafKz5QGLRWVjVGLAI22ucR78w03G7eHWSJL4vzbRY64lTeJAa
         1/VocRXefs19SwOfKCKzyu9soVxEe83Cj98c98Ir7/E9Nur9RMhDwc4i0B/NrukFLU+l
         hIoA==
X-Forwarded-Encrypted: i=1; AJvYcCVq3pUk1p4xDZ28hfsXQW8o1dhxiB6EZIGgRr8CFRVxJj8JVBDhYIln3Kp9gtWaehV7lJ8NnUD3MQAkleU7Gw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwULbeUsNIVA7i4y+emt0xEQpHrUItH8XdUAwBXTZ0NNMINNykM
	csn2tYk2eGPcZKDKKdled88gSOEXPxZA5uoHNhob+8jYw2RkVyUXRAUoGm3l9vO9atJVXDlaj54
	8ZVzwA3Npq9Cwpy6uUxcI4lLGa6tS/R+NTctCJYHmcOFDVaRQ5XWcJUU=
X-Google-Smtp-Source: AGHT+IEjZYpjS+t0y9w1faCUnoigZeHOY61l/vi8qF9dsi26W2i0l1Sp0buXvF4w2gfyyITNOOv/cF+8XwE2KEzntBbcyhiGzEbx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4b:b0:3a6:aa64:dc9 with SMTP id
 e9e14a558f8ab-3a6f19ca40emr135242805ab.13.1731354218509; Mon, 11 Nov 2024
 11:43:38 -0800 (PST)
Date: Mon, 11 Nov 2024 11:43:38 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67325e6a.050a0220.138bd5.00c9.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in
 bch2_btree_cache_scan (2)
From: syzbot <syzbot+7b48a45a8154d8d0a75d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a9cda7c0ffed Merge tag 'irq_urgent_for_v6.12_rc7' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1687135f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=7b48a45a8154d8d0a75d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a9cda7c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/29b6746965e0/vmlinux-a9cda7c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/455959afbe37/bzImage-a9cda7c0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7b48a45a8154d8d0a75d@syzkaller.appspotmail.com

BUG: unable to handle page fault for address: ffffe8fffe20d038
#PF: supervisor write access in kernel mode
#PF: error_code(0x0002) - not-present page
PGD 1ac3f067 P4D 1ac3f067 PUD 1e8e9067 PMD 56cec067 PTE 0
Oops: Oops: 0002 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 79 Comm: kswapd0 Not tainted 6.12.0-rc6-syzkaller-00318-ga9cda7c0ffed #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_cache_scan+0xb57/0xed0 fs/bcachefs/btree_cache.c:561
Code: 24 38 0f 85 12 02 00 00 44 21 2a 48 81 c3 38 b6 04 00 48 89 d8 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 1c 9b ea fd 48 8b 03 <65> 48 ff 40 38 41 80 3c 2e 00 74 08 4c 89 ff e8 05 9b ea fd 49 8b
RSP: 0018:ffffc900010573b8 EFLAGS: 00010246
RAX: 0000607fde60d000 RBX: ffff8880570cb638 RCX: ffffffff8bcff45d
RDX: ffff88801f06002c RSI: 0000000000000008 RDI: ffffc90001057340
RBP: dffffc0000000000 R08: ffffc90001057347 R09: 1ffff9200020ae68
R10: dffffc0000000000 R11: fffff5200020ae69 R12: 0000000000000003
R13: 00000000fffbffff R14: 1ffff9200020aed1 R15: ffffc90001057688
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffe20d038 CR3: 000000000e734000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:437
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:664
 shrink_one+0x43b/0x850 mm/vmscan.c:4824
 shrink_many mm/vmscan.c:4885 [inline]
 lru_gen_shrink_node mm/vmscan.c:4963 [inline]
 shrink_node+0x3791/0x3e20 mm/vmscan.c:5943
 kswapd_shrink_node mm/vmscan.c:6771 [inline]
 balance_pgdat mm/vmscan.c:6963 [inline]
 kswapd+0x1ca9/0x3700 mm/vmscan.c:7232
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
CR2: ffffe8fffe20d038
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_cache_scan+0xb57/0xed0 fs/bcachefs/btree_cache.c:561
Code: 24 38 0f 85 12 02 00 00 44 21 2a 48 81 c3 38 b6 04 00 48 89 d8 48 c1 e8 03 80 3c 28 00 74 08 48 89 df e8 1c 9b ea fd 48 8b 03 <65> 48 ff 40 38 41 80 3c 2e 00 74 08 4c 89 ff e8 05 9b ea fd 49 8b
RSP: 0018:ffffc900010573b8 EFLAGS: 00010246
RAX: 0000607fde60d000 RBX: ffff8880570cb638 RCX: ffffffff8bcff45d
RDX: ffff88801f06002c RSI: 0000000000000008 RDI: ffffc90001057340
RBP: dffffc0000000000 R08: ffffc90001057347 R09: 1ffff9200020ae68
R10: dffffc0000000000 R11: fffff5200020ae69 R12: 0000000000000003
R13: 00000000fffbffff R14: 1ffff9200020aed1 R15: ffffc90001057688
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffe8fffe20d038 CR3: 000000000e734000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	24 38                	and    $0x38,%al
   2:	0f 85 12 02 00 00    	jne    0x21a
   8:	44 21 2a             	and    %r13d,(%rdx)
   b:	48 81 c3 38 b6 04 00 	add    $0x4b638,%rbx
  12:	48 89 d8             	mov    %rbx,%rax
  15:	48 c1 e8 03          	shr    $0x3,%rax
  19:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  1d:	74 08                	je     0x27
  1f:	48 89 df             	mov    %rbx,%rdi
  22:	e8 1c 9b ea fd       	call   0xfdea9b43
  27:	48 8b 03             	mov    (%rbx),%rax
* 2a:	65 48 ff 40 38       	incq   %gs:0x38(%rax) <-- trapping instruction
  2f:	41 80 3c 2e 00       	cmpb   $0x0,(%r14,%rbp,1)
  34:	74 08                	je     0x3e
  36:	4c 89 ff             	mov    %r15,%rdi
  39:	e8 05 9b ea fd       	call   0xfdea9b43
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
