Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC9C2E9752
	for <linux-bcachefs@vger.kernel.org>; Sat, 16 Aug 2025 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755374315; cv=none; b=KP/nK8OHqJebXNd4N99ZQVlxTUIUtTU6TIZCqPe8VcpjG55LdaEiXesGADwfY7pEa/4P+5VeFN/sfDlf9LnWElOrvMUWPSFGhk7t9Lztj+x8UjVu5nvNIL9bhbxq9TnaEyyJO2AL46LUdh9PepE4UIeekcXNiDVfoXI/uPAOOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755374315; c=relaxed/simple;
	bh=PmZhJ+AyyPp0IETOJ2Lp0Yr/WPBtnpQxDMgCQTq5ahQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tBdvvp4wqi8WWJhbyupcftiV7LujX7gwt2KvrEOl2RDpWAB1IdO4TtGIkqwz5KZhOlJ1Po7yEZhsKk3AJx8zDdeayZb/wKk69xG4dtxvTrwWXWNFmTNoD2KuXQfUbDSR0EvCKehIN/fVGFhSOYQ7yS9X/pY+Ur3n/sEFp8GgJes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-88432e1d004so327791539f.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 16 Aug 2025 12:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755374313; x=1755979113;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9X3frL1K6ABgF+/GeFMFMDMzdy6vwlHamHmGBwxJKy0=;
        b=F/dYglypSy5h33ysZ+Zu3CvcpOCVKzdwPHPA5KLUXPEyLi8RoBv2RdIv8WDeqgzzNV
         ioTWOxfbHZNQifeXAfxTGHBXYGOYaiq8D1iMzcWWllnvhifzcpxaSm0D5EBjdkd8fJp/
         Wv7qme26tRf2bCIl9KHhP4Ph5ks5Y1+CFCUdhNMj59zXJJrS9XTv/RIO+BTd07DHwFow
         Xwge5dRXSopjnFyjklJMlPgP1hv1UthUgS0sQ4slQconYeZOZY9QQ+6EamRnmS1QFqHY
         fzX6ZF00EMLga/bQsU3BFrBwRYhwkVsYf+KxAfrL5mmRh9MqtUuaqKEFMLPqXi2tsHJj
         zYBA==
X-Forwarded-Encrypted: i=1; AJvYcCWa0IDeE3YWebioufqvd2VhMORGfGyWAdCnJkOCwyLbqWaY8AseFiQ6SjkAimhtxECIqgXXyDCbcGSMZBQzPQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyeHSd1MtP9w+igvugFQgUciu20mWqKpvFVkqMGAB1nOlIQUwWk
	cPaL+WFz4a/4djZAwisFOJ76L9wYLN5mS4NaC3aMuVKbhvXiiho8pO279XFMgWbPNvN5OCmn8eI
	FuOTvKNdM41y2rViou3+IxG6BvfjOQzAsVdq6B1ZfHk+JQl0YrsMbX/CfBxg=
X-Google-Smtp-Source: AGHT+IF4r7sKRkuX/L42iMRPCUrR2kVmZ1UmrTutaF5hEqKsLaNQnPGd43eTzB7Eo9jlWB5cX8dp4l+iXStfBGPC5MWGiUxNXnlo
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1808:b0:3e5:4942:88dc with SMTP id
 e9e14a558f8ab-3e57e82d473mr133133955ab.9.1755374312721; Sat, 16 Aug 2025
 12:58:32 -0700 (PDT)
Date: Sat, 16 Aug 2025 12:58:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a0e2e8.050a0220.e29e5.0049.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_pin_set_locked
From: syzbot <syzbot+014934d9b1d3601f30db@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0e39a731820a Merge tag 'for-6.17-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12c6f5bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d67d3af29f50297e
dashboard link: https://syzkaller.appspot.com/bug?extid=014934d9b1d3601f30db
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-0e39a731.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4de62048a1d4/vmlinux-0e39a731.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5ed93317a562/bzImage-0e39a731.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+014934d9b1d3601f30db@syzkaller.appspotmail.com

bcachefs (loop0): u64s 12 type alloc_v4 0:42:0 len 0 ver 0: 
    gen 0 oldest_gen 0 data_type btree
    journal_seq_nonempty 7
    journal_seq_empty    0
    need_discard         1
    need_inc_gen         1
    dirty_sectors        256
    stripe_sectors       0
    cached_sectors       0
    stripe               0
    stripe_redundancy    0
    io_time[READ]        1
    io_time[WRITE]       1280
    fragmentation     0
    bp_start          7
  
  incorrectly set at freespace:0:42:0 (free 0, genbits 0 should be 0), fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_reclaim.h:30!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 1037 Comm: kworker/u4:5 Not tainted 6.17.0-rc1-syzkaller-00014-g0e39a731820a #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:bch2_journal_pin_set_locked+0x346/0x350 fs/bcachefs/journal_reclaim.c:422
Code: fe ff ff e8 3c 92 72 fd 48 c7 c7 e0 f5 78 8e 4c 89 e6 e8 bd 86 b3 00 e9 54 fe ff ff e8 23 92 72 fd 90 0f 0b e8 1b 92 72 fd 90 <0f> 0b e8 13 92 72 fd 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000256f6a0 EFLAGS: 00010293
RAX: ffffffff844d2945 RBX: ffff8880119ce108 RCX: ffff888032e4a440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000005 R08: 0000000000000005 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520004adecc R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888054049800
FS:  0000000000000000(0000) GS:ffff88808d211000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564f7dae2a38 CR3: 0000000051967000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_journal_pin_copy+0x4c7/0x5b0 fs/bcachefs/journal_reclaim.c:463
 bch2_btree_interior_update_will_free_node+0x478/0xef0 fs/bcachefs/btree_update_interior.c:1092
 bch2_btree_node_rewrite+0x9ac/0x1120 fs/bcachefs/btree_update_interior.c:2275
 bch2_btree_node_rewrite_key+0x273/0x320 fs/bcachefs/btree_update_interior.c:2312
 async_btree_node_rewrite_work+0x110/0x4f0 fs/bcachefs/btree_update_interior.c:2369
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:bch2_journal_pin_set_locked+0x346/0x350 fs/bcachefs/journal_reclaim.c:422
Code: fe ff ff e8 3c 92 72 fd 48 c7 c7 e0 f5 78 8e 4c 89 e6 e8 bd 86 b3 00 e9 54 fe ff ff e8 23 92 72 fd 90 0f 0b e8 1b 92 72 fd 90 <0f> 0b e8 13 92 72 fd 90 0f 0b 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000256f6a0 EFLAGS: 00010293
RAX: ffffffff844d2945 RBX: ffff8880119ce108 RCX: ffff888032e4a440
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000005 R08: 0000000000000005 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520004adecc R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff888054049800
FS:  0000000000000000(0000) GS:ffff88808d211000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000564f7dae2a38 CR3: 0000000051967000 CR4: 0000000000352ef0


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
