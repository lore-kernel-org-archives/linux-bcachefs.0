Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C711F14AD2B
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Feb 2025 22:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738708222; cv=none; b=f7bQf+M3aIFiUkerH+Kqcw9OlkGWae0Goi7ouYV4pJsSpqccM+YPUdi/r3xZ+sPJ4sJCjbm37X7Eli1/5Nz+dZkOsHRzOUKa3WQb6OdDXsN5Oa3/N6fuO/JNe7sK4s7YlQhg4VcRwRY3Ahiu13o30XqctFXIygzY89ytthb5NEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738708222; c=relaxed/simple;
	bh=0yuraX5ABUdiSOZbZSGb+9nDxk8cxDL4hzfcbvO/mLM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=umzQHeTZHObfj6GRPbJVUYZOoZanDUzrapZTm9v2w5Pu/ql/6TBAuCKvlby0o6h923IIiQh3EtQ+GtY9qcRrDx2tDC2b9UqZB7ntxV+ejXkAOUHRnB9yAgJcCBmDYuyoT/+pbNsXWtuqITjp0iEFqr15J1ifXQ/AfPaO5CdIS9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d05063cc0fso665965ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 14:30:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738708220; x=1739313020;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ns36zhmEd8OWtoV79SVotwphVvopr7HCjwhmtCKqZRs=;
        b=t3TlxsWn5BvSdhf6GDNHlSIxhuyaRNdz5uFQ3Dju9FyJtyc1OIZmQ7BhPLh5oNM4Mp
         vcrYtapEtpboEib8jDAOXbvMo210eikH0fMN38PJZsF4zZOcOEXykwD/kLxETHyCiAtd
         kzHg1YvuzyRQS/sQvWaLR+/H0YREN76UpA3CmDbl4QJxFcEFAryAOPj/neO7hhLwrOSU
         eeBnjJM5pKh2sji+cJrbfKuJ+X4wSqZP77Cac0qmwA9olUpbyDg2mtjUU3bDY3/cycpi
         Xb0AyCTRQXDdwqBiBa5zNcfAV+9drtxJEM5QIlhUikg+qAy4P5XXwBa7iZoixTJwo8ZU
         d97Q==
X-Forwarded-Encrypted: i=1; AJvYcCVVgI1ck6IqQzPTVuUujND6FSbHmTdMrwKXk4Uqqt/jbXnzAs1LQ+Zip9BXnRg+lm+gUU5R4OPj03FLYgjfiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxVvryurFDiBqBvMWf4tJk+DiRbVGyQnRfJ2WVHoKRpsEMhAvqR
	AaaBFLlC2H9d3AmJxPB5WADU2x8MaoEEqXx6tH8lHBosW0w+pi7157shj+rECpyd1n2aZ40H1re
	EZwSxKSQI0dj+CVMZOhRpdBYeTvliO5CZKAYNvKHijlKwwK3DzWgtObE=
X-Google-Smtp-Source: AGHT+IHSzmhD9qvdw5y293zv7MTfkt0hfgtnq7BAQeCJ4sLxR7yBycvaAVtMAVltiVwaHX5uBXTU+Jfa7lmf3TcsKIjS8GHBH3k6
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1528:b0:3d0:47ad:dc86 with SMTP id
 e9e14a558f8ab-3d047addd19mr25558025ab.10.1738708219926; Tue, 04 Feb 2025
 14:30:19 -0800 (PST)
Date: Tue, 04 Feb 2025 14:30:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a294fb.050a0220.50516.0002.GAE@google.com>
Subject: [syzbot] [batman?] [bcachefs?] BUG: unable to handle kernel paging
 request in __run_timer_base
From: syzbot <syzbot+ab2fd19057fa822e71c6@syzkaller.appspotmail.com>
To: a@unstable.cc, antonio@mandelbit.com, b.a.t.m.a.n@lists.open-mesh.org, 
	davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kent.overstreet@linux.dev, kuba@kernel.org, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, marek.lindner@mailbox.org, 
	mareklindner@neomailbox.ch, netdev@vger.kernel.org, pabeni@redhat.com, 
	sven@narfation.org, sw@simonwunderlich.de, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    69e858e0b8b2 Merge tag 'uml-for-linus-6.14-rc1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1714c518580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d033b14aeef39158
dashboard link: https://syzkaller.appspot.com/bug?extid=ab2fd19057fa822e71c6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144ff6b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-69e858e0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a53b888c1f3f/vmlinux-69e858e0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6b5e17edafc0/bzImage-69e858e0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d96853f65a99/mount_6.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ab2fd19057fa822e71c6@syzkaller.appspotmail.com

kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle page fault for address: ffff8880465c3da0
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0011) - permissions violation
PGD 1aa01067 P4D 1aa01067 PUD 1aa04067 PMD 80000000464001e3 
Oops: Oops: 0011 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 3089 Comm: kworker/u4:10 Not tainted 6.13.0-syzkaller-09760-g69e858e0b8b2 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bat_events batadv_nc_worker
RIP: 0010:0xffff8880465c3da0
Code: 00 00 00 00 00 00 00 00 00 00 01 03 06 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a8 3e 5c 46 80 88 ff ff <08> 3e 5c 46 80 88 ff ff b8 6f 54 59 80 88 ff ff 5b 15 00 00 f3 02
RSP: 0018:ffffc90000007b98 EFLAGS: 00010246
RAX: ffffffff81ac83d1 RBX: 0000000000000001 RCX: ffff88803b080000
RDX: 0000000000000100 RSI: ffffffff8c608040 RDI: ffff888059546f28
RBP: ffffc90000007c90 R08: ffffffff81ac83be R09: 1ffffffff203680e
R10: dffffc0000000000 R11: ffff8880465c3da0 R12: 1ffff92000000f78
R13: ffff888059546f28 R14: 0000000000000001 R15: 0000000000000100
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8880465c3da0 CR3: 0000000054b64000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 expire_timers kernel/time/timer.c:1840 [inline]
 __run_timers kernel/time/timer.c:2414 [inline]
 __run_timer_base+0x66a/0x8e0 kernel/time/timer.c:2426
 run_timer_base kernel/time/timer.c:2435 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2445
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
RIP: 0010:lock_acquire+0x264/0x550 kernel/locking/lockdep.c:5855
Code: 2b 00 74 08 4c 89 f7 e8 8a 2b 8b 00 f6 44 24 61 02 0f 85 85 01 00 00 41 f7 c7 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 25 00 00 00 00 00 43 c7 44 25 09 00 00 00 00 43 c7 44 25
RSP: 0018:ffffc9000db47940 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff92001b68f34 RCX: ffff88803b080ae8
RDX: dffffc0000000000 RSI: ffffffff8c0ab8e0 RDI: ffffffff8c608060
RBP: ffffc9000db47aa0 R08: ffffffff942f6847 R09: 1ffffffff285ed08
R10: dffffc0000000000 R11: fffffbfff285ed09 R12: 1ffff92001b68f30
R13: dffffc0000000000 R14: ffffc9000db479a0 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 rcu_read_lock include/linux/rcupdate.h:849 [inline]
 batadv_nc_purge_orig_hash net/batman-adv/network-coding.c:408 [inline]
 batadv_nc_worker+0xec/0x610 net/batman-adv/network-coding.c:719
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3317
 worker_thread+0x870/0xd30 kernel/workqueue.c:3398
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
CR2: ffff8880465c3da0
---[ end trace 0000000000000000 ]---
RIP: 0010:0xffff8880465c3da0
Code: 00 00 00 00 00 00 00 00 00 00 01 03 06 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a8 3e 5c 46 80 88 ff ff <08> 3e 5c 46 80 88 ff ff b8 6f 54 59 80 88 ff ff 5b 15 00 00 f3 02
RSP: 0018:ffffc90000007b98 EFLAGS: 00010246
RAX: ffffffff81ac83d1 RBX: 0000000000000001 RCX: ffff88803b080000
RDX: 0000000000000100 RSI: ffffffff8c608040 RDI: ffff888059546f28
RBP: ffffc90000007c90 R08: ffffffff81ac83be R09: 1ffffffff203680e
R10: dffffc0000000000 R11: ffff8880465c3da0 R12: 1ffff92000000f78
R13: ffff888059546f28 R14: 0000000000000001 R15: 0000000000000100
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8880465c3da0 CR3: 0000000054b64000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	2b 00                	sub    (%rax),%eax
   2:	74 08                	je     0xc
   4:	4c 89 f7             	mov    %r14,%rdi
   7:	e8 8a 2b 8b 00       	call   0x8b2b96
   c:	f6 44 24 61 02       	testb  $0x2,0x61(%rsp)
  11:	0f 85 85 01 00 00    	jne    0x19c
  17:	41 f7 c7 00 02 00 00 	test   $0x200,%r15d
  1e:	74 01                	je     0x21
  20:	fb                   	sti
  21:	48 c7 44 24 40 0e 36 	movq   $0x45e0360e,0x40(%rsp)
  28:	e0 45
* 2a:	4b c7 44 25 00 00 00 	movq   $0x0,0x0(%r13,%r12,1) <-- trapping instruction
  31:	00 00
  33:	43 c7 44 25 09 00 00 	movl   $0x0,0x9(%r13,%r12,1)
  3a:	00 00
  3c:	43                   	rex.XB
  3d:	c7                   	.byte 0xc7
  3e:	44                   	rex.R
  3f:	25                   	.byte 0x25


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
