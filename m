Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFB83112CB
	for <linux-bcachefs@vger.kernel.org>; Wed, 17 Sep 2025 22:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758149672; cv=none; b=qoUzyad1hjRFvZsL8V4m9jlGyTnP66QtvnwFk1meRA1XXRNVT9jHrsmcQ0UGiW6JFlg+jZcthJVNgIPfuPZxXeEWdZpB8mMbzYCUIDZWyX6AVuFGDckPwAJN8qnTLU8Dw3nvjUhFHNy4XkQcDGBSMnsONCqdRZRRQV0ZhOdCk7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758149672; c=relaxed/simple;
	bh=IdtSv+kThya+McSai+pRuUaP35zd3rurmW34WISWh2c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=GMlo5qV2KRGDZqSze89zLD1CqtmOY5eAKBUjge4XgG1ZVa2qlX/oY+UirJ8JQ99WzAlhcQBLHduCYvWTucPq+5pRDEEMGbNxDJMkRhlH6LxWkbZbpNVy2pJV1V5QtvJ/5iLSrtdvsMbMW4s/crKqWeazKo5UPFhRU2S1fi1EtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-896d8bc595aso83694939f.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 17 Sep 2025 15:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758149669; x=1758754469;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ha0H7zu5ogkEJkgWVqvHlZ7mIelQAqz0THYh5WuqZbM=;
        b=LtzEYGBDzzU7pc9g8I4EFZJkR0oufjtTuCV4fPM6jGYaiqS2s1fchZ5MGsXGhlI3as
         htFje2Ff6GuH7t1AMi5KrFj2YsQ2hP2cMmD6ciJt4SoOwQ2U47ap4PFs+i92qRFWjP7G
         +qSyJ9gOphJoaoVb4RtW0L0bVnwSL1OEW+zJPzOalISMOJ5+JeagTtb/YEo2/ioaK7TB
         /dFT6r2UPYAte19QDQ2e10NmrcdkYwNqpVnTW6UicH/OaANGz4W7D5w0J17MhnkXBnWw
         ASHYt9AZLFnyUrqoD3Z6GUWzmqyNao7fSh1Y8FhhoGvmS/cQ/OLUcFdoGdtFxUK4N3me
         v8Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXcmDZoO98RM9np87hYNRoVN629Wy03PII+bvlwyoMBA5P72GNJRD0sFwXMjkxFshUrRZXPR1w8Sm1Co8/yuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSUOiTcodaRmEaHIK8C0Er2H8OxD54DswLEfjHON75queKQe3z
	yNn05m6WYTeXPh/MbAJ4MxnWIRGZrO3rVU1HaVh+KIe1Nt81n5PZm3BJOxy6yPBxctA+7W3S3wd
	B04lfyFTQlVNIW9pYrOZU47uwuYMKUBqiHJq4+C2hS7d2hwQfeBKhc8QbnRA=
X-Google-Smtp-Source: AGHT+IEthyF/AW3K3cFIoA16CgwY+MSgvl5M5hlStslgWfRJEoV+ENZDmrdooBQsx9wnM4HqsVGsIH7NMP6eYqBIwW4sadx8Y9Ne
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3cc5:b0:423:fcd6:5488 with SMTP id
 e9e14a558f8ab-4241a4d1893mr57231765ab.12.1758149668946; Wed, 17 Sep 2025
 15:54:28 -0700 (PDT)
Date: Wed, 17 Sep 2025 15:54:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cb3c24.050a0220.50883.0029.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_seek_pagecache_hole (3)
From: syzbot <syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5aca7966d2a7 Merge tag 'perf-tools-fixes-for-v6.17-2025-09..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=137baf62580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=cb91f22d8a581fc19edf
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16342e42580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15c4c534580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4946b6719e9f/disk-5aca7966.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f982750cccde/vmlinux-5aca7966.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e070a17d9c63/bzImage-5aca7966.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2615c2777a3c/mount_0.gz

The issue was bisected to:

commit c02e5b57283ad6fd8dec8d834bd340bf2627fcee
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 2 19:12:49 2025 +0000

    bcachefs: Single device mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15a34c7c580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17a34c7c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=13a34c7c580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb91f22d8a581fc19edf@syzkaller.appspotmail.com
Fixes: c02e5b57283a ("bcachefs: Single device mode")

INFO: task syz.3.20:6170 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.20        state:D stack:21416 pid:6170  tgid:6147  ppid:5988   task_flags:0x400040 flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 io_schedule+0x81/0xe0 kernel/sched/core.c:7903
 folio_wait_bit_common+0x6b5/0xb90 mm/filemap.c:1317
 __folio_lock mm/filemap.c:1675 [inline]
 folio_lock include/linux/pagemap.h:1133 [inline]
 __filemap_get_folio+0x167/0xa40 mm/filemap.c:1929
 folio_hole_offset fs/bcachefs/fs-io-pagecache.c:756 [inline]
 bch2_seek_pagecache_hole+0xbb/0x7c0 fs/bcachefs/fs-io-pagecache.c:793
 bch2_clamp_data_hole+0x8f/0x180 fs/bcachefs/fs-io-pagecache.c:808
 __bchfs_fallocate+0xe77/0x1870 fs/bcachefs/fs-io.c:697
 bchfs_fallocate+0x33f/0x680 fs/bcachefs/fs-io.c:789
 bch2_fallocate_dispatch+0x28d/0x410 fs/bcachefs/fs-io.c:836
 vfs_fallocate+0x672/0x7f0 fs/open.c:342
 ksys_fallocate fs/open.c:366 [inline]
 __do_sys_fallocate fs/open.c:371 [inline]
 __se_sys_fallocate fs/open.c:369 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:369
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb0096eba9
RSP: 002b:00007feafffb5038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007feb00bb6090 RCX: 00007feb0096eba9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007feb009f1e19 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000001001ec R11: 0000000000000246 R12: 0000000000000000
R13: 00007feb00bb6128 R14: 00007feb00bb6090 R15: 00007ffc531dd1d8
 </TASK>
INFO: task syz.3.20:6171 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.20        state:D stack:26248 pid:6171  tgid:6147  ppid:5988   task_flags:0x440040 flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x16f3/0x4c20 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 __bch2_two_state_lock+0x1ea/0x370 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_readahead+0x94f/0x1100 fs/bcachefs/fs-io-buffered.c:296
 read_pages+0x177/0x580 mm/readahead.c:160
 page_cache_ra_unbounded+0x63b/0x740 mm/readahead.c:297
 filemap_get_pages+0x443/0x1df0 mm/filemap.c:2603
 filemap_splice_read+0x587/0xc60 mm/filemap.c:2991
 do_splice_read fs/splice.c:982 [inline]
 splice_direct_to_actor+0x4b1/0xcd0 fs/splice.c:1086
 do_splice_direct_actor fs/splice.c:1204 [inline]
 do_splice_direct+0x187/0x270 fs/splice.c:1230
 vfs_copy_file_range+0xad7/0x1330 fs/read_write.c:1627
 __do_sys_copy_file_range fs/read_write.c:1677 [inline]
 __se_sys_copy_file_range+0x2fb/0x470 fs/read_write.c:1644
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb0096eba9
RSP: 002b:00007feafff94038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007feb00bb6180 RCX: 00007feb0096eba9
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007feb009f1e19 R08: 0000000000000101 R09: 0000000000000000
R10: 00002000000000c0 R11: 0000000000000246 R12: 0000000000000000
R13: 00007feb00bb6218 R14: 00007feb00bb6180 R15: 00007ffc531dd1d8
 </TASK>

Showing all locks held in the system:
2 locks held by kworker/u8:1/13:
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3319
 #1: ffffc90000127bc0 ((reaper_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc90000127bc0 ((reaper_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3319
2 locks held by kworker/u8:2/37:
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3319
 #1: ffffc90000ac7bc0 (connector_reaper_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc90000ac7bc0 (connector_reaper_work){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3319
1 lock held by khungtaskd/39:
 #0: ffffffff8d9a8d80 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8d9a8d80 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:841 [inline]
 #0: ffffffff8d9a8d80 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:3/57:
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3211 [inline]
 #0: ffff888019881138 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x17b0 kernel/workqueue.c:3319
 #1: ffffc9000123fbc0 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3212 [inline]
 #1: ffffc9000123fbc0 ((work_completion)(&(&kfence_timer)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x17b0 kernel/workqueue.c:3319
2 locks held by kworker/u8:15/3581:
2 locks held by getty/5601:
 #0: ffff88823bf700a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90003e762e0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x444/0x1410 drivers/tty/n_tty.c:2222
1 lock held by udevd/6029:
2 locks held by udevd/6043:
3 locks held by syz.3.20/6170:
 #0: ffff88803941a488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff88803941a488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d6009b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d6009b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88805a404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88805a404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88805a404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.3.20/6171:
 #0: ffff88805d600b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d600b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.0.17/6189:
 #0: ffff888021f46488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff888021f46488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d7f89b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d7f89b8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff888055304678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff888055304678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff888055304678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.0.17/6191:
 #0: ffff88805d7f8b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d7f8b88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.1.18/6204:
 #0: ffff888058a7a488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff888058a7a488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d601a38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d601a38 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff888059404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff888059404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff888059404678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.1.18/6209:
 #0: ffff88805d601c08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d601c08 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.4.23/6255:
 #0: ffff88803db8c488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff88803db8c488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d604bb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d604bb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff888065204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff888065204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff888065204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.4.23/6256:
 #0: ffff88805d604d88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d604d88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
1 lock held by syz.2.40/6491:
 #0: ffff88805d7f93c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d7f93c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.2.40/6513:
 #0: ffff88805d13e488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff88805d13e488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d7f91f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d7f91f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88806de04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88806de04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88806de04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
3 locks held by syz.5.28/6539:
 #0: ffff8881413d8488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff8881413d8488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d7fd3f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d7fd3f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88806dd04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88806dd04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88806dd04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.5.28/6540:
 #0: ffff88805d7fd5c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d7fd5c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
1 lock held by syz.6.30/6542:
 #0: ffff88805d602c88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d602c88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.6.30/6555:
 #0: ffff88804856e488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff88804856e488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d602ab8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d602ab8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88806d904678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88806d904678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88806d904678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
3 locks held by syz.8.35/6579:
 #0: ffff88806dc8e488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff88806dc8e488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff88805d602278 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff88805d602278 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88806cc04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88806cc04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88806cc04678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.8.35/6580:
 #0: ffff88805d602448 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff88805d602448 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.9.46/6851:
 #0: ffff888054616488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff888054616488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff888075d6cbb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff888075d6cbb8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff88807d204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff88807d204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff88807d204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.9.46/6852:
 #0: ffff888075d6cd88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff888075d6cd88 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
3 locks held by syz.7.60/6896:
 #0: ffff888027a44488 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:3108 [inline]
 #0: ffff888027a44488 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5f9/0x7f0 fs/open.c:341
 #1: ffff888075d6d3f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:870 [inline]
 #1: ffff888075d6d3f8 (&sb->s_type->i_mutex_key#20){+.+.}-{4:4}, at: bch2_fallocate_dispatch+0x111/0x410 fs/bcachefs/fs-io.c:827
 #2: ffff888083204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:161 [inline]
 #2: ffff888083204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:253 [inline]
 #2: ffff888083204678 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0xaf/0x220 fs/bcachefs/btree_iter.c:3299
1 lock held by syz.7.60/6897:
 #0: ffff888075d6d5c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:935 [inline]
 #0: ffff888075d6d5c8 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_unbounded+0xf4/0x740 mm/readahead.c:228
2 locks held by syz.0.167/7213:
1 lock held by syz.3.168/7216:
3 locks held by syz.2.169/7219:
4 locks held by syz.1.170/7222:
2 locks held by syz.4.171/7225:

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 39 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:328 [inline]
 watchdog+0xf93/0xfe0 kernel/hung_task.c:491
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 17 Comm: pr/legacy Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:io_serial_in+0x77/0xc0 drivers/tty/serial/8250/8250_port.c:400
Code: e8 ae 4e 7f fc 44 89 f9 d3 e3 49 83 ee 80 4c 89 f0 48 c1 e8 03 42 80 3c 20 00 74 08 4c 89 f7 e8 4f 89 de fc 41 03 1e 89 da ec <0f> b6 c0 5b 41 5c 41 5e 41 5f e9 0a 81 bb 05 cc 44 89 f9 80 e1 07
RSP: 0018:ffffc90000167890 EFLAGS: 00000202
RAX: 1ffffffff3275c00 RBX: 00000000000003fd RCX: 0000000000000000
RDX: 00000000000003fd RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff993ae870 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffffff853f1f10 R12: dffffc0000000000
R13: 0000000000000000 R14: ffffffff993ae5e0 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8881268bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f20e01f8000 CR3: 000000003ae94000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 serial_in drivers/tty/serial/8250/8250.h:137 [inline]
 serial_lsr_in drivers/tty/serial/8250/8250.h:159 [inline]
 wait_for_lsr+0x1a7/0x2f0 drivers/tty/serial/8250/8250_port.c:1984
 fifo_wait_for_lsr drivers/tty/serial/8250/8250_port.c:3288 [inline]
 serial8250_console_fifo_write drivers/tty/serial/8250/8250_port.c:3311 [inline]
 serial8250_console_write+0x11bd/0x1b40 drivers/tty/serial/8250/8250_port.c:3396
 console_emit_next_record kernel/printk/printk.c:3118 [inline]
 console_flush_all+0x695/0xcd0 kernel/printk/printk.c:3226
 __console_flush_and_unlock+0xa4/0x240 kernel/printk/printk.c:3285
 legacy_kthread_func+0x13b/0x1a0 kernel/printk/printk.c:3638
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
