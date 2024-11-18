Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5F61E633C
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731966093; cv=none; b=Po5CDIIrmqh+ur0hF9emhUOYmPfgMJCqaubQ/SKkifK35gVaB/hX1ZOIypTiPpk0gF9HKuZt9CoBSmnQhL/Hck1kWL5VoEKFi5gS6nUAtqFgt28iNjpPqku8U6/KcPik2MB7GcmPacf4cJJYaOTIwuyhNlWvRx1GX3ajLGcNhIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731966093; c=relaxed/simple;
	bh=11mGdX1odmlaQVSMDbxyzhhP0XCoXErnYShjD3DDITU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=g30vZ5lrxeJf3w2O1fUMWQP77feoOh4gGQPhMoXjg4b9cEZQOiSNDcynt3vREXQr85LWIFwe+VNzhfB7fcKKAtrT22jHUIwaDLciT3L3aajb8IkM5G7dVhlycRz85knIoREYtMXlrRO2sJDGs0wCYefw/LFcCFjg20gVZygwuP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a76ee0008cso9224365ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 13:41:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731966091; x=1732570891;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5NOPzdf9kB1lp2vrOoulBULUP/flh85FQx/FmtbuZeU=;
        b=curRrdVlN49nr5ifAZngC7nE7cIbRuBaDodjPgI9po9/vbHPlMrx41e1hHBu6Xy888
         Mq/536kRC622ojJ/+rsbA5m18e/9KA0UUpQjBXkMEd1rNmiqHsqRhEHnYXt7oveBx4vk
         wFJih/klqKzJzEJrP1BVkPEr1jnQHZV/j3Vq8Lx9rmHtNJUdYihOHJvhraLoC6K5M3Jm
         b+vCCANR40KUMy5AvUvkk85Fy+Iw/LhNXPsVxn4xEHkgiGuP6hbEd7Kc8iV6fUb96xDz
         xj4zeT4baaJhNATHiT2QcB8p5uLqBZagLXl3mllwdiahzfSvdubpIRh6arugT1fHntla
         BTPw==
X-Forwarded-Encrypted: i=1; AJvYcCWH36UyI7sgJ3byjscHahzfdeaP2VTDjZdgaLFfB2gV2shsM7h9V9vhVJn6oQ4NLywqe9ooHu3SgePOce4/PA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLmVSAipD82CrXfGtaDZ5Kycx1y3MIMj5scNae9XF8wJFgJofD
	Ou+FLmKoV2qUQKE3lF2Zv1TQfTYvLZoQDR27HOCzJ31msIu6pPd0Xu/QjcppWy0C8rqshtI17Tr
	X52viO9vJXZTvgaP5lKxSlzZBjMF8wO5qJIofj05K87v6ry+P05DWuoY=
X-Google-Smtp-Source: AGHT+IHFAeKmnmpBCEKK7xs/B4eujPl+ugTyWKI+UrP9IXrYT/642KkC43LBkXXsbEZjQYgOQz6TFJdgDKQzTLWX17Wp934RlQHR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ca:b0:3a7:6ec2:71bc with SMTP id
 e9e14a558f8ab-3a76ec27381mr29456505ab.9.1731966090857; Mon, 18 Nov 2024
 13:41:30 -0800 (PST)
Date: Mon, 18 Nov 2024 13:41:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673bb48a.050a0220.87769.005e.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_bucket_alloc_trans (3)
From: syzbot <syzbot+592425844580a6598410@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13649cc0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=592425844580a6598410
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1437e130580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=163802e8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-cfaaa7d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/63eae0d3e67f/vmlinux-cfaaa7d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6495d9e4ddee/bzImage-cfaaa7d0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/902320cb2e25/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+592425844580a6598410@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/alloc_foreground.c:493!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 2975 Comm: kworker/u4:10 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:493 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x39ec/0x3a50 fs/bcachefs/alloc_foreground.c:648
Code: e8 a9 3a f0 fd e9 f0 c7 ff ff 89 d9 80 e1 07 38 c1 0f 8c f3 fd ff ff 48 89 df e8 3f 39 f0 fd e9 e6 fd ff ff e8 65 5d 86 fd 90 <0f> 0b e8 5d 5d 86 fd 90 0f 0b e8 45 4a b9 07 f3 0f 1e fa e8 4c 5d
RSP: 0018:ffffc9000d8fe140 EFLAGS: 00010293
RAX: ffffffff840e8cab RBX: 0000000000000019 RCX: ffff888040104880
RDX: 0000000000000000 RSI: 0000000000000019 RDI: 0000000000000000
RBP: ffffc9000d8fe868 R08: ffffffff840e5f79 R09: 0000000000000000
R10: ffffc9000d8fe728 R11: fffff52001b1fcea R12: dffffc0000000000
R13: ffff8880438ec000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005596e117f4e8 CR3: 0000000011cf8000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x13d0/0x1ec0 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:339 [inline]
 bch2_btree_reserve_get+0x612/0x1890 fs/bcachefs/btree_update_interior.c:549
 bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1247
 bch2_btree_node_rewrite+0x1c0/0x1280 fs/bcachefs/btree_update_interior.c:2148
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x31e/0xda0 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:493 [inline]
RIP: 0010:bch2_bucket_alloc_trans+0x39ec/0x3a50 fs/bcachefs/alloc_foreground.c:648
Code: e8 a9 3a f0 fd e9 f0 c7 ff ff 89 d9 80 e1 07 38 c1 0f 8c f3 fd ff ff 48 89 df e8 3f 39 f0 fd e9 e6 fd ff ff e8 65 5d 86 fd 90 <0f> 0b e8 5d 5d 86 fd 90 0f 0b e8 45 4a b9 07 f3 0f 1e fa e8 4c 5d
RSP: 0018:ffffc9000d8fe140 EFLAGS: 00010293
RAX: ffffffff840e8cab RBX: 0000000000000019 RCX: ffff888040104880
RDX: 0000000000000000 RSI: 0000000000000019 RDI: 0000000000000000
RBP: ffffc9000d8fe868 R08: ffffffff840e5f79 R09: 0000000000000000
R10: ffffc9000d8fe728 R11: fffff52001b1fcea R12: dffffc0000000000
R13: ffff8880438ec000 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd30c9ff000 CR3: 000000004399a000 CR4: 0000000000352ef0
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
