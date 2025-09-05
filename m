Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915593191A2
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 17:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757093194; cv=none; b=hKEIIuntOcFQBVcrmr80x+B3Z15KMOyEGir23F8gsKsbMkqlltainE4s+s7AUyvT0cd5uaPtR8DHhyXiJdew+o+ouoGA9LFMNewcLiwduuwBW8hY/X6J87Q8Jq4xiPbr6XT+gAgQ7fpEsICF467Rn5qRoXPopNIrZKPWw8P/rnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757093194; c=relaxed/simple;
	bh=Lp5fgNEyzLV5sKb9jE04U7SlEyBQqlduXG9QuM1Ub0U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uHWiTOajAX4I+D4zXDgK9I5mt3a70G0iyzrzu8xXRjCtD7Ik0X/qJzCynnT5YV4cgioFXJpJImuqOJzpmiqb5M5vYqBzvPhzXJ+C+f4sdtFNPRTmlqH228/Q+hMMZYxJFSPLce5uUwcLqfHUZqL3tGaBxQzimRGriI+gfjb7w70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-88760a9d5c6so459285639f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 10:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757093192; x=1757697992;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jtu418UTsdlNJQI1Uvfc3XM5Ot3P2gXA/LjM0DbScZw=;
        b=U9x80ER34aMOery+ueRNmvnvp1UBohm0l5kYedumCf62FovQg9sc8/kRKKfZ5MQJv2
         h0gxzsJlhqgjDOxmRGl1opVWYutc/+HtgvF/8NgihCGnuVWYi82Am4HXPXJ0ujVpBzbW
         L6UFI+NlU+8C9BjgQhx4EObYC9NSdYuzY5gWvDdmdGjPg25aYNE71Q/UFQ4xFhoKWBkT
         5p0j4xhppVKrU2ealTpJZM8o56iCZGqusf2i31oIy6KX0bW6A2yTMrr9PpbtfZCDI/Jx
         5IivRXIp9CEzTXywguFn27sgD26LEDMuWAaBF9YDrqiYlCTpY1otY2OIOe5j6xFyxtGy
         x7HA==
X-Forwarded-Encrypted: i=1; AJvYcCU5fkmOqcZv3cBFGgvTJ09DJru8ChTDMUb0pONqOYFseqbbPqkUtNVZ3/MeGDidbQrXW1u20NK4IB35G+v6Dg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp938gTitLxghc1l37MKY0bI/Rb2dhv3wmcLlYcZQ5SH96p/w1
	KnYlsHaEYei88CEEmbiwyq9LSukvbbAC1YSJttHvLaSSwuOvWadYJ9Nxw0WgqN2JjROYqUU0Ji0
	J0zqHjm5vzmwuVk1ZiE4d61g+uCvT6oqXi1D0Nq62NHdvfplODVxO5MiwAI8=
X-Google-Smtp-Source: AGHT+IHH/yTpMyRsFZOmf7O714Z3F8oARKaPJTTuxbTwdET54JoqHSYYqxpZehhMDmXzVrKRTaEEYgnTLWiRVtkomyFQ6AFGs+rg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6d17:b0:887:6854:b075 with SMTP id
 ca18e2360f4ac-8876863f515mr589990839f.2.1757093191676; Fri, 05 Sep 2025
 10:26:31 -0700 (PDT)
Date: Fri, 05 Sep 2025 10:26:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bb1d47.a70a0220.7a912.02be.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in __bch2_trans_get
From: syzbot <syzbot+b70ffe7893bd1110ddd0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    08b06c30a445 Merge tag 'v6.17-rc4-ksmbd-fix' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13851312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=385d836f07b5a70d
dashboard link: https://syzkaller.appspot.com/bug?extid=b70ffe7893bd1110ddd0
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-08b06c30.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/516e142f1f8b/vmlinux-08b06c30.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a968d13b9737/bzImage-08b06c30.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b70ffe7893bd1110ddd0@syzkaller.appspotmail.com

bcachefs (loop0): /file0/file0 offset 0: data_read_io_err
  u64s 8 type extent 4099:8:U32_MAX len 8 ver 1: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum chacha20_poly1305_80 77fa:f532966a693125aa  compress incompressible ptr: 0:34:0 gen 0
bcachefs (loop0): /file0/file0 offset 0: data read error: data_read_io_err
bcachefs (loop0): /file0/file0 offset 0: data read error, data_read_io_err
  u64s 8 type extent 4099:8:U32_MAX len 8 ver 1: durability: 1 crc: c_size 8 size 8 offset 0 nonce 0 csum chacha20_poly1305_80 77fa:f532966a693125aa  compress incompressible ptr: 0:34:0 gen 0
  loop0 io error
============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/u4:5/1037 is trying to acquire lock:
ffff888055bec1b0 (bcachefs_btree){+.+.}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
ffff888055bec1b0 (bcachefs_btree){+.+.}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
ffff888055bec1b0 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_get+0x7f4/0xd80 fs/bcachefs/btree_iter.c:3505

but task is already holding lock:
ffff888051f701b0 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:206 [inline]
ffff888051f701b0 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0xbe0/0x2310 fs/bcachefs/btree_iter.c:3403

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(bcachefs_btree);
  lock(bcachefs_btree);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

5 locks held by kworker/u4:5/1037:
 #0: ffff88801a479148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff88801a479148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3319
 #1: ffffc900025ffbc0 ((work_completion)(&rbio->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc900025ffbc0 ((work_completion)(&rbio->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3319
 #2: ffff888051f701b0 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:206 [inline]
 #2: ffff888051f701b0 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0xbe0/0x2310 fs/bcachefs/btree_iter.c:3403
 #3: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #3: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #3: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
 #4: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #4: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #4: ffff888052f04398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7f4/0xd80 fs/bcachefs/btree_iter.c:3505

stack backtrace:
CPU: 0 UID: 0 PID: 1037 Comm: kworker/u4:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: events_unbound bch2_rbio_retry
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
 __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 trans_set_locked fs/bcachefs/btree_locking.h:206 [inline]
 __bch2_trans_get+0x8fd/0xd80 fs/bcachefs/btree_iter.c:3508
 bch2_rbio_retry+0x1d1/0x19b0 fs/bcachefs/io_read.c:594
 bch2_rbio_done fs/bcachefs/io_read.c:464 [inline]
 bch2_rbio_retry+0xbf4/0x19b0 fs/bcachefs/io_read.c:667
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
