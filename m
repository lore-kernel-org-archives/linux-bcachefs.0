Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C8C1BEF77;
	Wed, 11 Jun 2025 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749657543; cv=none; b=fG4lQwu9fHri1Yya3hDoIJzvRS1uVZ3O9Cmn7DD9vA9uiLJYzy2wHQOckPKq1AiEh+rORAHS/vmoejePNMliLLnp5v91E9V/mrZjw8hGTTHOhBSq1DWnBjZz1UBsjQHMJ+q46gq2ShikTYCks6cNbxhyV6j/V7UGARG4SMffQWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749657543; c=relaxed/simple;
	bh=x+Vc1JTkdPHe0IjGuHdsaUGDzhJB3DcZJ0CERv8PaBI=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GlsUSlNAz9NqhqY5LVIJzU0kdlKgqgOLunCJKUXv3gj/mE8j7bLfEPuKRkdrzH3JGpHDsgkttJuvYLZ/gMrRTbQfMbgrq8uDJ+js5wz+xMaBRjKnWjsEbuCrWfZVvqWf8cAi2zhKRYrEW/UWcWo/hiz1t5ytl1K3LjYDV7FwkIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cci6YO6s; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cci6YO6s"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54afb5fcebaso8055421e87.3;
        Wed, 11 Jun 2025 08:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749657539; x=1750262339; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZIiReEJBibfyKym+mddQ8h+3q2gL3jR6Gy15euZGwtk=;
        b=Cci6YO6s6WD2HY+PGWsYnmy5MRzGOMU/3uX77Ecln9+Jy4uj+8zoLoKI8VVp7cjWbc
         1kbVNJIl+SIRP3/mkUXv8tO38SYaFtXvVooXPSGCfDQ4gU8U6w/Zc/F7Z+rN83feA9gz
         6vHqSCNpaBDBuZ9Mfs3MOMo/2wDqJUZrZv1I2gBXAGx2yY2GpacXEpfrVv0DiS5JEXVj
         aGsHgadoZcZH7wJlkL6BVlY+3QudYA12x0KSMFOw9VaPR6bbBjqec4oGjrCAl2U/h8KX
         ekT02m/H5iioL8ICOxafhBx/w1P7vuAPKll9HHRJhWVhnH3R09L8di6ciq1Nfpud7uXf
         g7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749657539; x=1750262339;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIiReEJBibfyKym+mddQ8h+3q2gL3jR6Gy15euZGwtk=;
        b=mED7arg4hjCl/jecYxpQT37KGfseYYYOliMf+688y6QiTw4QmzqWSmdadsVNwtienZ
         AF6Pnfk4BJAySGpYLy6Ga6Ajf6d5MQ2CEyGC0cVpVCydhnrI25Dulu4CbiWttwdHbISR
         EfULl+axeDWuwzeGbk4wZEqM7vBlN10OySiNdi72YHish5Q1MaMlXpOTSUibE9dHnJ5+
         Z28waFs/eesPHSsqq3i//TZAEmJH3xbLUvbD9riVT8crToPadhzBteQjWdjTGJJuS7+R
         IRowp6nwgkigjBVbw5RXTYCkbkuutA3yHV9Xqp3Lx+BXT2NSqgVBfQma9iMrRPEdJWor
         Mv2w==
X-Forwarded-Encrypted: i=1; AJvYcCUPCJZyE+Iu4obwRVhgiHSFUWH8jPQX8iBvxRRQU1kFhnR6ZOu+oJy0zKJsJ05qDXWmzTbD@vger.kernel.org, AJvYcCUg6QMWUkVCsA/mgKLI5gGjxQwBK37Z2J8JTiD8Y9MYUTUan6gkkekjInZOiulWNX2cBKZ0jKvGY3zOUDef@vger.kernel.org, AJvYcCV7gD6r389KOpiEeLgPba5E4Z20tLEI9QaeaE6DY7uQ7Sn3y2ZjPPX2xsilNHVCmW/P7qLbK/R0yC0wk82SaA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxAMS/x/+FJFztUVtpE+BO/NmvZiEhnoTHoPc8D6+ytzgTrvlDK
	6E5bPsT6s1ssnG8422v1JRGw2NRiM3b4minTj3YaEvwxJQ9bL9WztYD6quAWIQwr
X-Gm-Gg: ASbGnctialjQar29zYV8Jb5w2d5xOre5GyQfK5pFyGErhsl4NJELpzn579byuFmhHtt
	RVsxkxuhpbr6PRU9mDehts5UW09N7UwpY0uCNSwwKj5xmT6fR8L43rQ+Vx4nvAn5Jy4RSsEolOC
	EFs1yWkt7FSJDaBFjXU9mJCUBydwwhJCdwE8YR7U59uda8t2FoTTH7/k26a3IVLyvlxiwYzu6zF
	/s2eVQgKMblfv8qtxQioe/RV6Lfjn1VrhKr1W0QXKyYexhOqIzRzu4ZkRfD17ka4tiqwWxfLWn9
	diDmQQNkraqVYv1FHYwnv7ymlaF/4syGFMMNFpS3HkpecQX7zagZp+5xwQaOoYTOHNynxuBX96U
	TMgTg9BR+8AvvOGZPu4UK9w==
X-Google-Smtp-Source: AGHT+IGR6FlSC3lQaq2+a03g/KZgD2RAZnzFYe8kXns9s6R04xWJKJzw/GuhfWmda0AdU7tvnmI4jw==
X-Received: by 2002:a05:6512:3da2:b0:553:291f:92e with SMTP id 2adb3069b0e04-5539c1715cbmr1215100e87.39.1749657538750;
        Wed, 11 Jun 2025 08:58:58 -0700 (PDT)
Received: from pc636 (host-95-203-1-180.mobileonline.telia.com. [95.203.1.180])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-553676d75c2sm2013702e87.61.2025.06.11.08.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jun 2025 08:58:58 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 11 Jun 2025 17:58:55 +0200
To: syzbot <syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org,
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	paulmck@kernel.org, rcu@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [rcu?] [bcachefs?] BUG: unable to handle kernel NULL
 pointer dereference in rcu_core (3)
Message-ID: <aEmnv69zbkinkDVs@pc636>
References: <67a2b20a.050a0220.50516.0003.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67a2b20a.050a0220.50516.0003.GAE@google.com>

On Tue, Feb 04, 2025 at 04:34:18PM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10faf5f8580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
> dashboard link: https://syzkaller.appspot.com/bug?extid=80e5d6f453f14a53383a
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16b69d18580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-0de63bb7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1142009a30a7/vmlinux-0de63bb7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/5d9e46a8998d/bzImage-0de63bb7.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/526692501242/mount_0.gz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+80e5d6f453f14a53383a@syzkaller.appspotmail.com
> 
>  slab radix_tree_node start ffff88803bf382c0 pointer offset 24 size 576
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 0 P4D 0 
> Oops: Oops: 0010 [#1] PREEMPT SMP KASAN NOPTI
> CPU: 0 UID: 0 PID: 5705 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  rcu_do_batch kernel/rcu/tree.c:2546 [inline]
>  rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2802
>  handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
>  __do_softirq kernel/softirq.c:595 [inline]
>  invoke_softirq kernel/softirq.c:435 [inline]
>  __irq_exit_rcu+0xf7/0x220 kernel/softirq.c:662
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:678
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1049
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
> RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
> RIP: 0010:_raw_spin_unlock_irqrestore+0xd8/0x140 kernel/locking/spinlock.c:194
> Code: 9c 8f 44 24 20 42 80 3c 23 00 74 08 4c 89 f7 e8 fe 78 2d f6 f6 44 24 21 02 75 52 41 f7 c7 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> c3 0f 95 f5 65 8b 05 d4 58 0b 74 85 c0 74 43 48 c7 04 24 0e 36
> RSP: 0018:ffffc900030fef60 EFLAGS: 00000206
> RAX: 23438dd059a4b100 RBX: 1ffff9200061fdf0 RCX: ffffffff819b316a
> RDX: dffffc0000000000 RSI: ffffffff8c0aa680 RDI: 0000000000000001
> RBP: ffffc900030feff8 R08: ffffffff942f9847 R09: 1ffffffff285f308
> R10: dffffc0000000000 R11: fffffbfff285f309 R12: dffffc0000000000
> R13: 1ffff9200061fdec R14: ffffc900030fef80 R15: 0000000000000246
>  spin_unlock_irqrestore include/linux/spinlock.h:406 [inline]
>  rmqueue_bulk mm/page_alloc.c:2329 [inline]
>  __rmqueue_pcplist+0x21fd/0x2a90 mm/page_alloc.c:3004
>  rmqueue_pcplist mm/page_alloc.c:3046 [inline]
>  rmqueue mm/page_alloc.c:3077 [inline]
>  get_page_from_freelist+0x886/0x37a0 mm/page_alloc.c:3474
>  __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4739
>  alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
>  folio_alloc_mpol_noprof mm/mempolicy.c:2289 [inline]
>  vma_alloc_folio_noprof+0x12b/0x260 mm/mempolicy.c:2324
>  folio_prealloc+0x2e/0x170
>  wp_page_copy mm/memory.c:3435 [inline]
>  do_wp_page+0x1253/0x49b0 mm/memory.c:3827
>  handle_pte_fault mm/memory.c:5905 [inline]
>  __handle_mm_fault+0x24d5/0x70f0 mm/memory.c:6032
>  handle_mm_fault+0x3e5/0x8d0 mm/memory.c:6201
>  do_user_addr_fault arch/x86/mm/fault.c:1388 [inline]
>  handle_page_fault arch/x86/mm/fault.c:1480 [inline]
>  exc_page_fault+0x2b9/0x8b0 arch/x86/mm/fault.c:1538
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
> RIP: 0010:__put_user_4+0x11/0x20 arch/x86/lib/putuser.S:88
> Code: 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 89 cb 48 c1 fb 3f 48 09 d9 0f 01 cb <89> 01 31 c9 0f 01 ca c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90
> RSP: 0018:ffffc900030fff00 EFLAGS: 00050202
> RAX: 0000000000000005 RBX: 0000000000000000 RCX: 00005555679927d0
> RDX: 0000000000000000 RSI: ffffffff8c0ab8e0 RDI: ffffffff8c608a00
> RBP: ffff888000dfcf20 R08: ffffffff901b5177 R09: 1ffffffff2036a2e
> R10: dffffc0000000000 R11: fffffbfff2036a2f R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000005 R15: dffffc0000000000
>  schedule_tail+0x96/0xb0 kernel/sched/core.c:5312
>  ret_from_fork+0x24/0x80 arch/x86/kernel/process.c:144
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc90000007bd8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 1ffff110077e705c RCX: 23438dd059a4b100
> RDX: 0000000000000100 RSI: 0000000000000000 RDI: ffff88803bf382d8
> RBP: ffffc90000007e10 R08: ffffffff819f146c R09: 1ffff11003f8519a
> R10: dffffc0000000000 R11: 0000000000000000 R12: ffffffff81a6d507
> R13: ffff88803bf382e0 R14: 0000000000000000 R15: ffff88803bf382d8
> FS:  0000555567992500(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000004da38000 CR4: 0000000000352ef0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:	9c                   	pushf
>    1:	8f 44 24 20          	pop    0x20(%rsp)
>    5:	42 80 3c 23 00       	cmpb   $0x0,(%rbx,%r12,1)
>    a:	74 08                	je     0x14
>    c:	4c 89 f7             	mov    %r14,%rdi
>    f:	e8 fe 78 2d f6       	call   0xf62d7912
>   14:	f6 44 24 21 02       	testb  $0x2,0x21(%rsp)
>   19:	75 52                	jne    0x6d
>   1b:	41 f7 c7 00 02 00 00 	test   $0x200,%r15d
>   22:	74 01                	je     0x25
>   24:	fb                   	sti
>   25:	bf 01 00 00 00       	mov    $0x1,%edi
> * 2a:	e8 c3 0f 95 f5       	call   0xf5950ff2 <-- trapping instruction
>   2f:	65 8b 05 d4 58 0b 74 	mov    %gs:0x740b58d4(%rip),%eax        # 0x740b590a
>   36:	85 c0                	test   %eax,%eax
>   38:	74 43                	je     0x7d
>   3a:	48                   	rex.W
>   3b:	c7                   	.byte 0xc7
>   3c:	04 24                	add    $0x24,%al
>   3e:	0e                   	(bad)
>   3f:	36                   	ss
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

#syz test

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 475f31deed14..b297a32c6779 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3047,6 +3047,10 @@ __call_rcu_common(struct rcu_head *head, rcu_callback_t func, bool lazy_in)
        /* Misaligned rcu_head! */
        WARN_ON_ONCE((unsigned long)head & (sizeof(void *) - 1));

+       /* Avoid NULL dereference if callback is NULL. */
+       if (WARN_ON_ONCE(!func))
+               return;
+
        if (debug_rcu_head_queue(head)) {
                /*
                 * Probable double call_rcu(), so leak the callback.

