Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5192227B85
	for <linux-bcachefs@vger.kernel.org>; Wed,  5 Feb 2025 00:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738715662; cv=none; b=koEeLi00cuUo/bljr9HLcsEhzlsy7jLsCJhgYQtmATcbqVhwY8308XTYINQl0bMIpnZUjlmVNeqpgQdQmubJC1th1uyW0jIllHAUbJ/cg9xawkq3+PVOg9pjpcA4MsQ6NromYLVPgGI8yurf4pBQD9HmE8U19C/aekDFiG96Wzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738715662; c=relaxed/simple;
	bh=Q4Vw+3Re6Vn9ZU9fP0QUBKUW7rK+C0tlTr4zhN2dF3E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=CJs0sfYp1mjKzMtFiGWNEq1PkktVxDbfjZm9fHwnXNwAWCmSIIBkD3zXoLtDORRnnyQuk+FS1zuKXYaWxn3fnQLsyodlncBFz4swOosEJjR5kpRNdo+ZL8AuRjmVo4dbVy7wsDhWWAVO32ufvlVefYQPvC2K8Ab8OGBmFq+kStg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d0508b8008so1242435ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 16:34:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738715660; x=1739320460;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQPG7nsKYYHsfpJzpMresG+1MH6cnrQ1XLV4kImA0a4=;
        b=HIYkSfY2Qt3efMHH5OuYvWl+SM3Q8auFusjUXbKwuh7xIIFFPgYa1s678K8763H11E
         D4rA5bCJzxIVe9qr2sbFbMXCtPlmWjQgEMp5yEbe9vEebVaeDp2InVs8ua2r6d6CHjU9
         GVvNWhb78S7xR8gH1WEde2JnvSZebQUcqKapnN6WvTu4Ia8DnDqH04cLb/gOaI6RhPVz
         FbOdKnGFJFeyjhSw7pW6FiwZstdIgIC4TXDx0TP8fSDvvtZYei25GxwRQfULiXqFquAF
         PlXWYG5H/h4Ji1JVGjoMw+CP5UnPVGqj7C1MDRDmIAvuPHQp9xi5vr+5tGu5epWjpJOe
         Vfsw==
X-Forwarded-Encrypted: i=1; AJvYcCUXGP9a0Z5hBSUihOnbcibY2mg16SFVVUgy2SdKOCUYeCrbaMb1TjsvrLxiYFyfTdXWM1tQPQCjYU9HlUMnjQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMdCvuAZ5ah/Iq8sIT7ao5sIPC1SFdn2D4R9pJ4ZYyGJjYHN4j
	SNShlPVJYXIg0jQyC3Wo0qJ+nkzwtmEGzEFQeSVH8X9v6/hj6sG7ekfZmSpAF8DW63QUlpRnepQ
	16WH8o4UBx7dYppBBG6qIX3Ob0VR75aKTqsDNN7SCQbvGMnavrPlq1q0=
X-Google-Smtp-Source: AGHT+IFvzyjgGoqm3tyli3Mq8Q6irtgPgsoSG3VLwGoxQI8kXgXlJs+2lQJS5s3nyVT4pOM/zBm2aAXAWw1hXT/KEe6xURj7AucA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1687:b0:3cf:fa94:c7d with SMTP id
 e9e14a558f8ab-3d04f45b33cmr9252425ab.9.1738715658443; Tue, 04 Feb 2025
 16:34:18 -0800 (PST)
Date: Tue, 04 Feb 2025 16:34:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a2b20a.050a0220.50516.0003.GAE@google.com>
Subject: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in rcu_core (3)
From: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, josh@joshtriplett.org, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, paulmck@kernel.org, 
	rcu@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com

 slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 0 P4D 0 
Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 rcu_do_batch kernel/rcu/tree.c:2546 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2802
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 __do_softirq kernel/softirq.c:595 [inline]
 invoke_softirq kernel/softirq.c:435 [inline]
 __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xd8/0x140 kernel/locking/spinlock.c:194
Code: 9c 8f 44 24 20 42 80 3c 23 00 74 08 4c 89 f7 e8 fe 78 2d f6 f6 44 24 21 02 75 52 41 f7 c7 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> c3 0f 95 f5 65 8b 05 d4 58 0b 74 85 c0 74 43 48 c7 04 24 0e 36
RSP: 0018:ffffc900030fef60 EFLAGS: 00000206
RAX: 23438dd059a4b100 RBX: 1ffff9200061fdf0 RCX: ffffffff819b316a
RDX: dffffc0000000000 RSI: ffffffff8c0aa680 RDI: 0000000000000001
RBP: ffffc900030feff8 R08: ffffffff942f9847 R09: 1ffffffff285f308
R10: dffffc0000000000 R11: fffffbfff285f309 R12: dffffc0000000000
R13: 1ffff9200061fdec R14: ffffc900030fef80 R15: 0000000000000246
 spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
 rmqueue_bulk mm/page_alloc.c:2329 [inline]
 __rmqueue_pcplist+0x21fd/0x2a90 mm/page_alloc.c:3004
 rmqueue_pcplist mm/page_alloc.c:3046 [inline]
 rmqueue mm/page_alloc.c:3077 [inline]
 get_page_from_freelist+0x886/0x37a0 mm/page_alloc.c:3474
 __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4739
 alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
 folio_alloc_mpol_noprof mm/mempolicy.c:2289 [inline]
 vma_alloc_folio_noprof+0x12b/0x260 mm/mempolicy.c:2324
 folio_prealloc+0x2e/0x170
 wp_page_copy mm/memory.c:3435 [inline]
 do_wp_page+0x1253/0x49b0 mm/memory.c:3827
 handle_pte_fault mm/memory.c:5905 [inline]
 __handle_mm_fault+0x24d5/0x70f0 mm/memory.c:6032
 handle_mm_fault+0x3e5/0x8d0 mm/memory.c:6201
 do_user_addr_fault arch/x86/mm/fault.c:1388 [inline]
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x2b9/0x8b0 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:__put_user_4+0x11/0x20 arch/x86/lib/putuser.S:88
Code: 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 cb 48 c1 fb 3f 48 09 d9 0f 01 cb <89> 01 31 c9 0f 01 ca c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90
RSP: 0018:ffffc900030fff00 EFLAGS: 00050202
RAX: 0000000000000005 RBX: 0000000000000000 RCX: 00005555679927d0
RDX: 0000000000000000 RSI: ffffffff8c0ab8e0 RDI: ffffffff8c608a00
RBP: ffff888000dfcf20 R08: ffffffff901b5177 R09: 1ffffffff2036a2e
R10: dffffc0000000000 R11: fffffbfff2036a2f R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000005 R15: dffffc0000000000
 schedule_tail+0x96/0xb0 kernel/sched/core.c:5312
 ret_from_fork+0x24/0x80 arch/x86/kernel/process.c:144
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	9c                   	pushf
   1:	8f 44 24 20          	pop    0x20(%rsp)
   5:	42 80 3c 23 00       	cmpb   $0x0,(%rbx,%r12,1)
   a:	74 08                	je     0x14
   c:	4c 89 f7             	mov    %r14,%rdi
   f:	e8 fe 78 2d f6       	call   0xf62d7912
  14:	f6 44 24 21 02       	testb  $0x2,0x21(%rsp)
  19:	75 52                	jne    0x6d
  1b:	41 f7 c7 00 02 00 00 	test   $0x200,%r15d
  22:	74 01                	je     0x25
  24:	fb                   	sti
  25:	bf 01 00 00 00       	mov    $0x1,%edi
* 2a:	e8 c3 0f 95 f5       	call   0xf5950ff2 <-- trapping instruction
  2f:	65 8b 05 d4 58 0b 74 	mov    %gs:0x740b58d4(%rip),%eax        # 0x740b590a
  36:	85 c0                	test   %eax,%eax
  38:	74 43                	je     0x7d
  3a:	48                   	rex.W
  3b:	c7                   	.byte 0xc7
  3c:	04 24                	add    $0x24,%al
  3e:	0e                   	(bad)
  3f:	36                   	ss


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
