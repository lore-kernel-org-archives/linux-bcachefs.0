Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0D25CC96
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Mar 2025 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741283849; cv=none; b=SrxyKbrdlvVyXhpBDkPLOoqNnWKZABmAESAXbnPnOPBOxkMz6+2sP6VqEEdaGrPTRwutuL45geBeachfwX8Mx4xGESuNdrsokMumOe39iy/9awX3wocRbzbaeHrB7qRB4RJ3Rjparar12JTk/aTddMAMlBFtJ9hn1dOeBx4Z6s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741283849; c=relaxed/simple;
	bh=fSPPLLdbFMrjw42HSo7FxlrVq+IJnvj8aGe9QfWdx/s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=f5EQsM6scjsMr+jqVq3jk3QBT91Rmmg/mxqbagpbv1EEuFrnT8nIF89C4v4t4ZftVptS1nHAwm/c1l1XnRl7UOixkzvpKaxWVnt6eLVErZl6bzZ04UlyOopVeR33hsJ6py1Mvtm9grOW3qzqO1oCbE0lT7tk7AaF010OV17YhIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d2b6d933c1so17301925ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Mar 2025 09:57:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741283847; x=1741888647;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vns/ne93NHxIB/erDfxxQpTeGm8dJSlvc8YFbKDR674=;
        b=HjKuiIZKWhHT1kfLo2+PCJ1VKLjYwSlg/EKNOVev2fvDFnF2tqtpUGur9MUZflyRck
         nAiFys/nhKYn7FkQ+1WxzJ3fRSnx+Spq1Gm41/i9mCU2h6Ci9QxPcskEsHQZPWAfdoWv
         cgJwM30CPjpy1adtnu3u9R+qK+EIx10s7LiEd9rcKFQzlsst7aCMjBT3XHWJFrDBwd4r
         ju2PPfgXTRuGhCyXkVH4NFDC98tWBFyeC/d97MGd8PfvKWYS+Hd7ljsSzSis1Nwh6W8J
         rtc4x9yKDt6IYIthWKyDP+jxI2Qbe5InnPCDx32Qu0lIZyaamFsDQn/eqNbMnuYdnAvl
         i6ww==
X-Forwarded-Encrypted: i=1; AJvYcCXiWHmYNWKQuRr1UEFoOXpHZqJl9EiAM5AxoHr8hLEskxzGRfNuFIu9ZZchnIcDwGG+Ou+3NUkBW9cVrRlV8A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAIjdRqbWgff830/lzrcxACPOiwux/9YkuOgnQDSvqA0y54qOC
	i0/LoEAxgV3zEJfWsoYKPnhqfDRmCIggeWCa+dEPz4U5LlJuBFRieOmhzyamo1vozu3V/lmmsyl
	pH4QxNnf5u9TFuOpHOGCsxtEg30yjLDC3VN+HI16ArA7g+/LjoC5UP6U=
X-Google-Smtp-Source: AGHT+IFZ4OVuy4uXXbNddxzWOEcAcBNdQKWG8w77vZ5toRF601QTyPqlMAEfqargpHJVB+mPrrU05g03IGSdzjNFbV/X1PODO5m3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2144:b0:3d3:e296:1c1c with SMTP id
 e9e14a558f8ab-3d441960cbcmr4717055ab.9.1741283847278; Thu, 06 Mar 2025
 09:57:27 -0800 (PST)
Date: Thu, 06 Mar 2025 09:57:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c9e207.050a0220.15b4b9.004c.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in __bch2_bkey_unpack_key
From: syzbot <syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    99fa936e8e4f Merge tag 'affs-6.14-rc5-tag' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f08078580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2040405600e83619
dashboard link: https://syzkaller.appspot.com/bug?extid=b9d9de2aa46b1bbe575a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13b69464580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15f08078580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-99fa936e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ef04f83d96f6/vmlinux-99fa936e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/583a7eea5c8e/bzImage-99fa936e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4d401321a7e1/mount_6.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b9d9de2aa46b1bbe575a@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 48 min_key 0:36028797018963968:0 durability: 1 ptr: 0:27:0 gen 0  
  node offset 8/48 bset u64s 2088 bset byte offset 360: bad k->u64s 0 (min 3 max 253), fixing
==================================================================
BUG: KASAN: slab-out-of-bounds in unpack_state_init fs/bcachefs/bkey.c:151 [inline]
BUG: KASAN: slab-out-of-bounds in __bch2_bkey_unpack_key+0x66/0xdd0 fs/bcachefs/bkey.c:269
Read of size 8 at addr ffff888053574140 by task kworker/0:1H/36

CPU: 0 UID: 0 PID: 36 Comm: kworker/0:1H Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_btree_read_complete btree_node_read_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 unpack_state_init fs/bcachefs/bkey.c:151 [inline]
 __bch2_bkey_unpack_key+0x66/0xdd0 fs/bcachefs/bkey.c:269
 __bkey_unpack_key_format_checked fs/bcachefs/bkey.h:407 [inline]
 __bkey_unpack_key fs/bcachefs/bkey.h:426 [inline]
 __bkey_disassemble fs/bcachefs/bkey.h:477 [inline]
 bkey_packed_valid+0x21e/0x6c0 fs/bcachefs/btree_io.c:875
 validate_bset_keys+0xeb5/0x1af0 fs/bcachefs/btree_io.c:987
 bch2_btree_node_read_done+0x2298/0x6180 fs/bcachefs/btree_io.c:1164
 btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Last potentially related work creation:
------------[ cut here ]------------
pool index 16319 out of bounds (797) for stack id 9a6c3fc0
WARNING: CPU: 0 PID: 36 at lib/stackdepot.c:452 depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
Modules linked in:
CPU: 0 UID: 0 PID: 36 Comm: kworker/0:1H Not tainted 6.14.0-rc5-syzkaller-00013-g99fa936e8e4f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs_btree_read_complete btree_node_read_work
RIP: 0010:depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
Code: 83 7c 18 1c 00 74 38 48 01 d8 eb 24 90 0f 0b 90 44 39 f5 72 ca 90 48 c7 c7 63 fc 3a 8e 89 ee 44 89 f2 89 d9 e8 ab e2 53 fc 90 <0f> 0b 90 90 31 c0 5b 41 5e 5d c3 cc cc cc cc 90 0f 0b 90 eb ef 90
RSP: 0000:ffffc90000576d08 EFLAGS: 00010046
RAX: a98b856e26fe2600 RBX: 000000009a6c3fc0 RCX: ffff88801e00c880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000003fbf R08: ffffffff81817e32 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff888053574140
R13: ffffea00014d5d00 R14: 000000000000031d R15: ffffc90000576de0
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fabca6ea000 CR3: 0000000012240000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 stack_depot_fetch lib/stackdepot.c:714 [inline]
 stack_depot_print+0x16/0x50 lib/stackdepot.c:752
 kasan_print_aux_stacks+0x38/0x70 mm/kasan/report_generic.c:199
 describe_object_stacks mm/kasan/report.c:347 [inline]
 describe_object mm/kasan/report.c:353 [inline]
 print_address_description mm/kasan/report.c:412 [inline]
 print_report+0x22b/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 unpack_state_init fs/bcachefs/bkey.c:151 [inline]
 __bch2_bkey_unpack_key+0x66/0xdd0 fs/bcachefs/bkey.c:269
 __bkey_unpack_key_format_checked fs/bcachefs/bkey.h:407 [inline]
 __bkey_unpack_key fs/bcachefs/bkey.h:426 [inline]
 __bkey_disassemble fs/bcachefs/bkey.h:477 [inline]
 bkey_packed_valid+0x21e/0x6c0 fs/bcachefs/btree_io.c:875
 validate_bset_keys+0xeb5/0x1af0 fs/bcachefs/btree_io.c:987
 bch2_btree_node_read_done+0x2298/0x6180 fs/bcachefs/btree_io.c:1164
 btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


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
