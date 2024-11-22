Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA1C1D5164
	for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732281265; cv=none; b=MA+zHgn8NjkP36BQPJ6hLPw9M7x3X7DlCzpF4KYuiOvcQ6aWuipH3/Fs3IAwWYK00ATAR0sqQ4O5cgqNgbruAYeuEIX9JXjOAAo1eC9snRdMonnIQBDnN5Xbq57S1L7N73TX22hkWj41jq0T56Mp63tzCLRC2ZFTL2PIC1sOskc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732281265; c=relaxed/simple;
	bh=nJFu8eol89++k0DlHDCM1HN5XeixsNfBQyj/kfUS7qw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=e5ALSKCFpnntN1vxVon1LVaXv4mZvG17CzWAdFnY0tJqbuv2XPUhm9xr1iJUZk4yj2zpQdflIem4d0L4NLOzDSZ5WaLZCoawMJwUJbsSI0JL3Jb5Q5Mt/KLBBXCee/mWMRP2kqKaBqEbcrgrMU4gEcGUiqYLLr3QtgJLnl6qC6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a79039ae30so21494485ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 22 Nov 2024 05:14:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732281263; x=1732886063;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BJwG3V5oWvIR0/9vv6OHw/AuX72p7++/ZZufRAdqPlU=;
        b=l/ZRVZIH5nGfTK9ldBKYFexK4FaZwFtVF8e6N5PrJ5CjPS5LQ1HtJ+qEiiu4rD7o7i
         lnPZH9iGtkNmFOhQHeBx+RHwqVMhgBTv5NrC1NmVSq0/YKQqIO9decgoQjCcxhzoMHEG
         AFAlNOOneTRalAXqqqJZZ+k4r6PSmuPOR3dzMMpI5bxY6z8fDTR4lG3o4UYvwWi1h8hK
         3meHtaL08Qb4E6GvZX4DURBe4f8LjVlUh/I72fP3tHMrkRjfPes9BeVRj8Q3ZBXTuwvW
         honsy+mtS9JdrAW/nw8KmwM7C13bAakBcumKJ4Un3q1X4vRYw+Hk0FYRnjJtupYdrNLl
         GwIA==
X-Forwarded-Encrypted: i=1; AJvYcCX7cL+Gsrt4KsDHwxqzy4Yn6u2PuCmDjEvs9wc+JQFCBqqjJIFHT3POeQ6JYEEUc08Swg21LzOUk0/dtPhveA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzrrYUHn4kCo3Q11jf+wq/qzUuduqj6DQzomMmALtLNLbWGyXc
	jfrpr+uUsROZlmAUNpmeNQonRAvqHFtAPA0AS4v8Jn4/e9E2mHLyFhUt1qc70OVcYpgoklfjZBu
	c5cRbO/Ov4Csv6kMWeSoPStaNZ45zoH6Jl2v6/pCvop3RnAYSClZ2nBc=
X-Google-Smtp-Source: AGHT+IGvTzAzsFUAVyyRAClTJOPjwej0vrXhYEuMexjPIkKDybIqzMzX8eM0YFa5JvfKWOMPUNAiassEt8AXlCUv4/RHb5oypxAd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2f:b0:3a7:4826:b04e with SMTP id
 e9e14a558f8ab-3a79afe2a8emr25693605ab.22.1732281263399; Fri, 22 Nov 2024
 05:14:23 -0800 (PST)
Date: Fri, 22 Nov 2024 05:14:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674083af.050a0220.3c9d61.0190.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in qlist_free_all
From: syzbot <syzbot+86b24455266617775c21@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    adc218676eef Linux 6.12
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11a1cbf7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e31661728c1a4027
dashboard link: https://syzkaller.appspot.com/bug?extid=86b24455266617775c21
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16304930580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a48ac0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-adc21867.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9304ecc29d43/vmlinux-adc21867.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a42cc9054b58/bzImage-adc21867.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/18a921fc3d34/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+86b24455266617775c21@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 1032 min_key POS_MIN durability: 1 ptr: 0:27:0 gen 0  
  node offset 0/1032 bset u64s 34546 bset byte offset 160: bad k->u64s 0 (min 3 max 253), fixing
------------[ cut here ]------------
kernel BUG at arch/x86/mm/physaddr.c:28!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 37 Comm: kworker/0:1H Not tainted 6.12.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_btree_read_complete btree_node_read_work
RIP: 0010:__phys_addr+0x162/0x170 arch/x86/mm/physaddr.c:28
Code: e8 d3 e9 51 00 48 c7 c7 c0 87 7a 8e 4c 89 f6 4c 89 fa e8 41 43 b3 03 e9 45 ff ff ff e8 b7 e9 51 00 90 0f 0b e8 af e9 51 00 90 <0f> 0b e8 a7 e9 51 00 90 0f 0b 0f 1f 40 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000057ed98 EFLAGS: 00010293
RAX: ffffffff81430061 RBX: 0000000000000001 RCX: ffff88801ddd8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8142ffac R09: 1ffffffff285a106
R10: dffffc0000000000 R11: fffffbfff285a107 R12: ffffea00011663c0
R13: ffffea0000000000 R14: 00006180011663c0 R15: 000000000000002e
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000048944000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 virt_to_folio include/linux/mm.h:1282 [inline]
 virt_to_slab mm/slab.h:206 [inline]
 qlink_to_cache mm/kasan/quarantine.c:131 [inline]
 qlist_free_all+0x3d/0x140 mm/kasan/quarantine.c:176
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_node_track_caller_noprof+0x1cd/0x440 mm/slub.c:4283
 __do_krealloc mm/slab_common.c:1229 [inline]
 krealloc_noprof+0x88/0x120 mm/slab_common.c:1278
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x267/0x6d0 fs/bcachefs/printbuf.c:186
 btree_err_msg fs/bcachefs/btree_io.c:519 [inline]
 __btree_err+0x171/0x760 fs/bcachefs/btree_io.c:557
 validate_bset_keys+0x554/0x1610 fs/bcachefs/btree_io.c:894
 bch2_btree_node_read_done+0x2402/0x5e90 fs/bcachefs/btree_io.c:1130
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__phys_addr+0x162/0x170 arch/x86/mm/physaddr.c:28
Code: e8 d3 e9 51 00 48 c7 c7 c0 87 7a 8e 4c 89 f6 4c 89 fa e8 41 43 b3 03 e9 45 ff ff ff e8 b7 e9 51 00 90 0f 0b e8 af e9 51 00 90 <0f> 0b e8 a7 e9 51 00 90 0f 0b 0f 1f 40 00 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000057ed98 EFLAGS: 00010293
RAX: ffffffff81430061 RBX: 0000000000000001 RCX: ffff88801ddd8000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8142ffac R09: 1ffffffff285a106
R10: dffffc0000000000 R11: fffffbfff285a107 R12: ffffea00011663c0
R13: ffffea0000000000 R14: 00006180011663c0 R15: 000000000000002e
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000048944000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
