Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4604D1CB9E5
	for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 17:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789418; cv=none; b=N47ymGXkGd2occ3t8LyJfeb1PZBgxCEnqklOwnD1VjNDw0yGFOtEdOIsHZA6K/6MYR90QkNGCltq1braDRW1jgxGc3nJGrSWSoLQAW5SEZ8PzBd4pXZRO8J9zhhPsrNEfYsEVp1hR/Rr+XTlwmVfy6U5dOCupUgl6n8jPC3hzYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789418; c=relaxed/simple;
	bh=Ie0760tVn1R8rbU2EnSMUzWOpJ19tpPoW/bA6hM11bQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Qy40nieM0kBhGYS+Tf0dNdvbJjQhVikT2lKyXL+a+139wwGkFlhO6M3EkI0vs2kg4gr0ULEo/yHd7tuJYaVF3rWADjsQjUyxHcEHBJ9EcZy9qTEtAqvVzukqG2z+NWZZ0auwYPBD108+xBLlZSbwYtu8HL9MnV1L1h66J1qNSEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a3f7b8b116so17462905ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 10:03:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789415; x=1730394215;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/O5YVaqmQavUmAw405AtiahzAj6ut+XeBw4kx6UPIqA=;
        b=irOFiypb3bnv2Tqx7xGY0RLwUZGDJUduhkx2a5KIRoY/P9NT+87YP5iqamgVykzDEL
         G8SC3MgYC4lrCmkmf+V0bCShJHIT0ST65oCo/qIGbhze3EnTywYI8WGNrS33BUmjWJNm
         NrEJgRDoZAuO33TL/2stZDKDSsM4ZtNJCJ89vydO33lM/K01pFrL0BjFACoMm/F9552T
         XMCPMPvO7ASZp0F008sBT6PcppMk1AHHtdMNfdJbhTHOkQ2Iwdj/QWy7qGJvgFIP5mOd
         KBKz9NK1SfxP8ANZ4x80ez8nL4qYlUCU25+4I/i3jxrM53rhnA6Wv0IEDkVreaoSroNa
         Jmuw==
X-Forwarded-Encrypted: i=1; AJvYcCUS2voykaM3BGptG1b/lv8uN5vhvVUlo1BIzMTB4yoEjmi7QMCPRBZBX0F6+M1JlAeam6CARvNbGvOnQSepfA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3zzTnLTULTc7vSpGIx/FhNcsQhrnnhzLtuZ8eEBRbP2eLmAEi
	JCRtBgTYZ2p4XcofVwCwVOPzKMXxO3sXv3ngoJzD1l03ywsMY8X1OEMaojeHdv4Gj22hObYkaln
	ftpqcLpXkyj2w3lHk3riIk+JWm9PAd03DIdIXIE/ophxbs7vIVbnnHpY=
X-Google-Smtp-Source: AGHT+IFsL3kKFYMrs0jIaHFBjharDkXmWFYtTRpQUoFAsyDjgVaA14ThjHgERtfUCKN+qh2H+dHfr6aaZcHUdTpSCTzlqG1hzEo8
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3a3:a639:a594 with SMTP id
 e9e14a558f8ab-3a4de711749mr21732885ab.4.1729789415229; Thu, 24 Oct 2024
 10:03:35 -0700 (PDT)
Date: Thu, 24 Oct 2024 10:03:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671a7de7.050a0220.2eb763.00c3.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_btree_cache_scan
From: syzbot <syzbot+3d89e46a004eafb88bc6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    715ca9dd687f Merge tag 'io_uring-6.12-20241019' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1383a430580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=16e543edc81a3008
dashboard link: https://syzkaller.appspot.com/bug?extid=3d89e46a004eafb88bc6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-715ca9dd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ba436e2363b6/vmlinux-715ca9dd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ac78a7a1a30/bzImage-715ca9dd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3d89e46a004eafb88bc6@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.12.0-rc3-syzkaller-00420-g715ca9dd687f #0 Not tainted
------------------------------------------------------
kswapd0/78 is trying to acquire lock:
ffff88804d081c50 (&bc->lock){+.+.}-{3:3}, at: bch2_btree_cache_scan+0x192/0xd00 fs/bcachefs/btree_cache.c:460

but task is already holding lock:
ffffffff8ea371a0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6844 [inline]
ffffffff8ea371a0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7226

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (fs_reclaim){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __fs_reclaim_acquire mm/page_alloc.c:3834 [inline]
       fs_reclaim_acquire+0x88/0x130 mm/page_alloc.c:3848
       might_alloc include/linux/sched/mm.h:318 [inline]
       slab_pre_alloc_hook mm/slub.c:4036 [inline]
       slab_alloc_node mm/slub.c:4114 [inline]
       __do_kmalloc_node mm/slub.c:4263 [inline]
       __kmalloc_noprof+0xa9/0x400 mm/slub.c:4276
       kmalloc_noprof include/linux/slab.h:882 [inline]
       kzalloc_noprof include/linux/slab.h:1014 [inline]
       pcpu_mem_zalloc mm/percpu.c:510 [inline]
       pcpu_alloc_chunk mm/percpu.c:1443 [inline]
       pcpu_create_chunk+0x57/0xbc0 mm/percpu-vm.c:338
       pcpu_balance_populated mm/percpu.c:2075 [inline]
       pcpu_balance_workfn+0xc4d/0xd40 mm/percpu.c:2212
       process_one_work kernel/workqueue.c:3229 [inline]
       process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
       worker_thread+0x870/0xd30 kernel/workqueue.c:3391
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #1 (pcpu_alloc_mutex){+.+.}-{3:3}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       pcpu_alloc_noprof+0x27f/0x16b0 mm/percpu.c:1795
       __six_lock_init+0x104/0x150 fs/bcachefs/six.c:869
       bch2_btree_lock_init+0x38/0x100 fs/bcachefs/btree_locking.c:12
       bch2_btree_node_mem_alloc+0x4f8/0x1340 fs/bcachefs/btree_cache.c:785
       __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:325 [inline]
       bch2_btree_reserve_get+0x2df/0x1890 fs/bcachefs/btree_update_interior.c:554
       bch2_btree_update_start+0xe56/0x14e0 fs/bcachefs/btree_update_interior.c:1252
       bch2_btree_split_leaf+0x123/0x840 fs/bcachefs/btree_update_interior.c:1850
       bch2_trans_commit_error+0x212/0x1390 fs/bcachefs/btree_trans_commit.c:942
       __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
       wb_flush_one fs/bcachefs/btree_write_buffer.c:183 [inline]
       bch2_btree_write_buffer_flush_locked+0x2aa8/0x59f0 fs/bcachefs/btree_write_buffer.c:375
       btree_write_buffer_flush_seq+0x1a43/0x1bc0 fs/bcachefs/btree_write_buffer.c:510
       bch2_btree_write_buffer_journal_flush+0x4e/0x80 fs/bcachefs/btree_write_buffer.c:525
       journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
       journal_flush_done+0x8e/0x260 fs/bcachefs/journal_reclaim.c:819
       bch2_journal_flush_pins+0x225/0x3a0 fs/bcachefs/journal_reclaim.c:852
       bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
       bch2_journal_replay+0x270f/0x2a40 fs/bcachefs/recovery.c:384
       bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:185
       bch2_run_recovery_passes+0x387/0x870 fs/bcachefs/recovery_passes.c:232
       bch2_fs_recovery+0x25cc/0x39c0 fs/bcachefs/recovery.c:862
       bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
       bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
       vfs_get_tree+0x90/0x2b0 fs/super.c:1800
       do_new_mount+0x2be/0xb40 fs/namespace.c:3507
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4055 [inline]
       __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&bc->lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:608 [inline]
       __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
       bch2_btree_cache_scan+0x192/0xd00 fs/bcachefs/btree_cache.c:460
       do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
       shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
       shrink_one+0x43b/0x850 mm/vmscan.c:4818
       shrink_many mm/vmscan.c:4879 [inline]
       lru_gen_shrink_node mm/vmscan.c:4957 [inline]
       shrink_node+0x3791/0x3e20 mm/vmscan.c:5937
       kswapd_shrink_node mm/vmscan.c:6765 [inline]
       balance_pgdat mm/vmscan.c:6957 [inline]
       kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
       kthread+0x2f0/0x390 kernel/kthread.c:389
       ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

other info that might help us debug this:

Chain exists of:
  &bc->lock --> pcpu_alloc_mutex --> fs_reclaim

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(fs_reclaim);
                               lock(pcpu_alloc_mutex);
                               lock(fs_reclaim);
  lock(&bc->lock);

 *** DEADLOCK ***

1 lock held by kswapd0/78:
 #0: ffffffff8ea371a0 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat mm/vmscan.c:6844 [inline]
 #0: ffffffff8ea371a0 (fs_reclaim){+.+.}-{0:0}, at: kswapd+0xbf1/0x3700 mm/vmscan.c:7226

stack backtrace:
CPU: 0 UID: 0 PID: 78 Comm: kswapd0 Not tainted 6.12.0-rc3-syzkaller-00420-g715ca9dd687f #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1384/0x2050 kernel/locking/lockdep.c:5202
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:608 [inline]
 __mutex_lock+0x136/0xd70 kernel/locking/mutex.c:752
 bch2_btree_cache_scan+0x192/0xd00 fs/bcachefs/btree_cache.c:460
 do_shrink_slab+0x701/0x1160 mm/shrinker.c:435
 shrink_slab+0x1093/0x14d0 mm/shrinker.c:662
 shrink_one+0x43b/0x850 mm/vmscan.c:4818
 shrink_many mm/vmscan.c:4879 [inline]
 lru_gen_shrink_node mm/vmscan.c:4957 [inline]
 shrink_node+0x3791/0x3e20 mm/vmscan.c:5937
 kswapd_shrink_node mm/vmscan.c:6765 [inline]
 balance_pgdat mm/vmscan.c:6957 [inline]
 kswapd+0x1ca3/0x3700 mm/vmscan.c:7226
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
