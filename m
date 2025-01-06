Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F54757FC
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 Jan 2025 03:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736134289; cv=none; b=icxnXOvNifA17M+JeDAEuWak6Hwy9MAcyA02evbyIZWzhEeJzhd0eSwaWRdlF4CwN9CgtHtkKa1PB2CmeEPNadJEfZb1QamsN0YjQ9M4PRFGGvTGe7fJGMmfgW/Fewb+D28ARYcyYnlAfW4eHuSNejj7yZn4qAUchpwzHl9Zq6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736134289; c=relaxed/simple;
	bh=reQCtxGt4fkrUEiPUP6UxPc4Tfa0SHf61G0D1tnUJwk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=E08W8zlcQg2agXTmgOVH8fqJVuGArI+cLVeub5mEqdXC+wbKeE8PZH/5jBMEImDAChxTpgHHfSQC1UIXB03tBXsMYXki957c+y0+QZVhbMkn0c7EtNOo6vjtVejLywNV9tALGSPIX3Or985WQPOmA5OQJuFXgZTmw/2/cWBxo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-844dac0a906so1294541639f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Jan 2025 19:31:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736134285; x=1736739085;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9GZP1jlP49kxIcoyozcmARgTJpRXgkEaOpcDtohEu7A=;
        b=O6fQa3pk6V3uPx3YmpHCZ81zBY7AhiNbMsyuB05BLeQSAHWBpZy1gzeLVWn+twYpEp
         hvzqEhufEZAE1FQllY+X7OYIeywy6nGBGvH98JneJMKeX+NLpXbyfxIHGoKWWcYb8HyB
         Qw02RKpVxP05Hn9vHe5DBa4uS/+sgBnin5w6EF7l26TOLv8rlpkziUMG6TIyDzbSnFUJ
         OYt1T/WRWcduQRKDexySLsXGXNtTq0TUHvMkAS+3opgKwN3kPQQnqg8aTaYpmNzi1Fsb
         NZwJpfQa7G+IeaVYT7VvHwHE8GoJRAy9bRSOMbZPFTJQJLuf7yTZ+Jb1d4kFmfSacetU
         tPQA==
X-Forwarded-Encrypted: i=1; AJvYcCVh5zZ5zM2yBOArla/S7WlvoC08ocgwRAGeodnN/LCkWXMTgGw2NiDm7l/8bq6vqbNQcudZO7PB4/w1xnGBOw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxug7Xv5UknZwIDfw1vOBQ2w9EWhULueu0PdhsCD+otnq0ErhZj
	XotiOhOB9YRxMMIQQU3T+FSmcShlteRRBC0dOeg3jBodGMbFX/RJsUY+o2kZ3So+9vHS0bpq7/q
	29tENSaE+pLc6i11lNq7MutMmi1bSXVDlicW3aBEe96NJ2h4Pu7ft4gw=
X-Google-Smtp-Source: AGHT+IFhsiimC4ldQt52lvLiPduW48fppAsPNZ/p+9NychfHvIqNledBrb1wO4J/SA6QLhjDBEgxUPFisoPyz9QVQLEsTJFDmsEu
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3885:b0:3ab:71d2:9bd9 with SMTP id
 e9e14a558f8ab-3c2d514f460mr463555415ab.16.1736134285547; Sun, 05 Jan 2025
 19:31:25 -0800 (PST)
Date: Sun, 05 Jan 2025 19:31:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677b4e8d.050a0220.380ff0.0022.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_btree_node_update_key (2)
From: syzbot <syzbot+5ef4c078ccd6970db1b6@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    56e6a3499e14 Merge tag 'trace-v6.13-rc5' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17bd3af8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ba7cde9482d6bb6
dashboard link: https://syzkaller.appspot.com/bug?extid=5ef4c078ccd6970db1b6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=144666c4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1244e8b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e5f33d8e3542/disk-56e6a349.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b53906ddb840/vmlinux-56e6a349.xz
kernel image: https://storage.googleapis.com/syzbot-assets/115963cd9410/bzImage-56e6a349.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f2761616fd47/mount_0.gz

The issue was bisected to:

commit 1d16c605cc55ef26f0c65b362665a6c99080ccbc
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Nov 9 19:22:46 2023 +0000

    bcachefs: Disk space accounting rewrite

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1297baf8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1197baf8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1697baf8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ef4c078ccd6970db1b6@syzkaller.appspotmail.com
Fixes: 1d16c605cc55 ("bcachefs: Disk space accounting rewrite")

INFO: task kworker/0:0H:10 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/0:0H    state:D stack:25912 pid:10    tgid:10    ppid:2      flags:0x00004000
Workqueue: bcachefs_btree_io btree_node_write_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 six_lock_slowpath+0x660/0x1680 fs/bcachefs/six.c:499
 six_lock_ip_waiter+0x117/0x160 fs/bcachefs/six.c:556
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 __bch2_btree_node_lock_write+0x10a/0x390 fs/bcachefs/btree_locking.c:418
 __btree_node_lock_write fs/bcachefs/btree_locking.h:319 [inline]
 bch2_btree_node_lock_write_nofail+0x24c/0x440 fs/bcachefs/btree_locking.c:432
 __bch2_btree_node_update_key fs/bcachefs/btree_update_interior.c:2396 [inline]
 bch2_btree_node_update_key+0x1718/0x3090 fs/bcachefs/btree_update_interior.c:2460
 bch2_btree_node_update_key_get_iter+0x731/0x8c0 fs/bcachefs/btree_update_interior.c:2498
 btree_node_write_work+0x774/0xba0 fs/bcachefs/btree_io.c:1870
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task kworker/u8:2:35 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:2    state:D stack:21528 pid:35    tgid:35    ppid:2      flags:0x00004000
Workqueue: writeback wb_workfn (flush-bcachefs-1)
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 folio_lock include/linux/pagemap.h:1151 [inline]
 writeback_get_folio mm/page-writeback.c:2515 [inline]
 writeback_iter+0x8ad/0x12b0 mm/page-writeback.c:2609
 write_cache_pages+0xb1/0x230 mm/page-writeback.c:2658
 bch2_writepages+0x156/0x390 fs/bcachefs/fs-io-buffered.c:639
 do_writepages+0x35f/0x880 mm/page-writeback.c:2702
 __writeback_single_inode+0x14f/0x10d0 fs/fs-writeback.c:1680
 writeback_sb_inodes+0x820/0x1360 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x11b/0x260 fs/fs-writeback.c:2047
 wb_writeback+0x427/0xb80 fs/fs-writeback.c:2158
 wb_check_background_flush fs/fs-writeback.c:2228 [inline]
 wb_do_writeback fs/fs-writeback.c:2316 [inline]
 wb_workfn+0xc4b/0x1080 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task kworker/1:1H:40 blocked for more than 144 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:1H    state:D stack:25776 pid:40    tgid:40    ppid:2      flags:0x00004000
Workqueue: bcachefs_btree_io btree_node_write_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 six_lock_slowpath+0x660/0x1680 fs/bcachefs/six.c:499
 six_lock_ip_waiter+0x117/0x160 fs/bcachefs/six.c:556
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 btree_node_lock_nopath+0xa4/0x150 fs/bcachefs/btree_locking.h:241
 btree_node_lock fs/bcachefs/btree_locking.h:289 [inline]
 btree_path_lock_root fs/bcachefs/btree_iter.c:748 [inline]
 bch2_btree_path_traverse_one+0xc39/0x2940 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_traverse+0x699/0xc30 fs/bcachefs/btree_iter.c:1880
 bch2_btree_node_update_key_get_iter+0x1a5/0x8c0 fs/bcachefs/btree_update_interior.c:2482
 btree_node_write_work+0x774/0xba0 fs/bcachefs/btree_io.c:1870
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task kworker/u9:0:55 blocked for more than 144 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u9:0    state:D stack:20112 pid:55    tgid:55    ppid:2      flags:0x00004000
Workqueue: bcachefs bch2_write_point_do_index_updates
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 six_lock_slowpath+0x660/0x1680 fs/bcachefs/six.c:499
 six_lock_ip_waiter+0x117/0x160 fs/bcachefs/six.c:556
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 btree_node_lock_nopath+0xa4/0x150 fs/bcachefs/btree_locking.h:241
 btree_node_lock fs/bcachefs/btree_locking.h:289 [inline]
 btree_path_lock_root fs/bcachefs/btree_iter.c:748 [inline]
 bch2_btree_path_traverse_one+0xc39/0x2940 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse_all fs/bcachefs/btree_iter.c:1027 [inline]
 bch2_trans_begin+0x10c1/0x1bf0 fs/bcachefs/btree_iter.c:3128
 bch2_write_index_default fs/bcachefs/io_write.c:356 [inline]
 __bch2_write_index+0x4a2/0x2140 fs/bcachefs/io_write.c:526
 bch2_write_point_do_index_updates+0x32e/0x690 fs/bcachefs/io_write.c:635
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task kworker/u8:4:62 blocked for more than 145 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:4    state:D stack:22224 pid:62    tgid:62    ppid:2      flags:0x00004000
Workqueue: btree_update btree_interior_update_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 six_lock_slowpath+0x660/0x1680 fs/bcachefs/six.c:499
 six_lock_ip_waiter+0x117/0x160 fs/bcachefs/six.c:556
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 btree_node_lock_nopath+0xa4/0x150 fs/bcachefs/btree_locking.h:241
 btree_node_lock fs/bcachefs/btree_locking.h:289 [inline]
 btree_path_lock_root fs/bcachefs/btree_iter.c:748 [inline]
 bch2_btree_path_traverse_one+0xc39/0x2940 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 flush_new_cached_update+0x247/0xac0 fs/bcachefs/btree_update.c:358
 bch2_trans_update_by_path+0x15ad/0x2050 fs/bcachefs/btree_update.c:466
 bch2_trans_update+0x924/0x2550 fs/bcachefs/btree_update.c:546
 bch2_trans_start_alloc_update+0xa65/0xdd0 fs/bcachefs/alloc_background.c:492
 bch2_trigger_pointer fs/bcachefs/buckets.c:588 [inline]
 __trigger_extent+0x1050/0x4fa0 fs/bcachefs/buckets.c:740
 bch2_trigger_extent+0x630/0xaa0 fs/bcachefs/buckets.c:877
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_key_trigger_new fs/bcachefs/bkey_methods.h:115 [inline]
 btree_update_nodes_written_trans fs/bcachefs/btree_update_interior.c:660 [inline]
 btree_update_nodes_written fs/bcachefs/btree_update_interior.c:723 [inline]
 btree_interior_update_work+0x1286/0x2b10 fs/bcachefs/btree_update_interior.c:861
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
INFO: task syz-executor199:5872 blocked for more than 146 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor199 state:D stack:13424 pid:5872  tgid:5871  ppid:5826   flags:0x00004006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 folio_wait_writeback+0xb0/0x100 mm/page-writeback.c:3194
 __filemap_fdatawait_range+0x17c/0x2b0 mm/filemap.c:532
 file_write_and_wait_range+0x2f1/0x3c0 mm/filemap.c:791
 bch2_fsync+0x13a/0x350 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2904 [inline]
 bch2_write_iter+0x2918/0x2c10 fs/bcachefs/fs-io-buffered.c:1061
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1050
 do_pwritev fs/read_write.c:1146 [inline]
 __do_sys_pwritev2 fs/read_write.c:1204 [inline]
 __se_sys_pwritev2+0x196/0x2b0 fs/read_write.c:1195
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1543f16909
RSP: 002b:00007f1543ec1208 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 00007f1543f9e6e8 RCX: 00007f1543f16909
RDX: 0000000000000001 RSI: 00000000200001c0 RDI: 0000000000000004
RBP: 00007f1543f9e6e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000e7b R11: 0000000000000246 R12: 00007f1543f6a10c
R13: 0031656c69662f2e R14: 7366656863616362 R15: 00007f1543f6404d
 </TASK>
INFO: task syz-executor199:5899 blocked for more than 146 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor199 state:D stack:25784 pid:5899  tgid:5871  ppid:5826   flags:0x00000006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 folio_wait_writeback+0xb0/0x100 mm/page-writeback.c:3194
 folio_prepare_writeback mm/page-writeback.c:2474 [inline]
 writeback_get_folio mm/page-writeback.c:2516 [inline]
 writeback_iter+0xa13/0x12b0 mm/page-writeback.c:2609
 write_cache_pages+0xb1/0x230 mm/page-writeback.c:2658
 bch2_writepages+0x156/0x390 fs/bcachefs/fs-io-buffered.c:639
 do_writepages+0x35f/0x880 mm/page-writeback.c:2702
 filemap_fdatawrite_wbc mm/filemap.c:397 [inline]
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:787
 bch2_fsync+0x13a/0x350 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2904 [inline]
 bch2_write_iter+0x2918/0x2c10 fs/bcachefs/fs-io-buffered.c:1061
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xaeb/0xd30 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1543f16909
RSP: 002b:00007f1543ea0218 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f1543f9e6f8 RCX: 00007f1543f16909
RDX: 000000000000004d RSI: 0000000020000280 RDI: 0000000000000004
RBP: 00007f1543f9e6f0 R08: 00007f1543e9ffb7 R09: 0000000000000000
R10: 0000000000000014 R11: 0000000000000246 R12: 00007f1543f6a10c
R13: 0031656c69662f2e R14: 7366656863616362 R15: 00007f1543f6404d
 </TASK>
INFO: task syz-executor199:5900 blocked for more than 147 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor199 state:D stack:24608 pid:5900  tgid:5871  ppid:5826   flags:0x00000006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 io_schedule+0x8d/0x110 kernel/sched/core.c:7681
 folio_wait_bit_common+0x839/0xee0 mm/filemap.c:1308
 __folio_lock mm/filemap.c:1646 [inline]
 folio_lock include/linux/pagemap.h:1151 [inline]
 __filemap_get_folio+0x14c/0x940 mm/filemap.c:1899
 folio_hole_offset fs/bcachefs/fs-io-pagecache.c:752 [inline]
 bch2_seek_pagecache_hole+0xc1/0x7a0 fs/bcachefs/fs-io-pagecache.c:789
 bch2_seek_hole fs/bcachefs/fs-io.c:960 [inline]
 bch2_llseek+0xc6b/0x2a00 fs/bcachefs/fs-io.c:1004
 vfs_llseek fs/read_write.c:382 [inline]
 ksys_lseek fs/read_write.c:395 [inline]
 __do_sys_lseek fs/read_write.c:405 [inline]
 __se_sys_lseek fs/read_write.c:403 [inline]
 __x64_sys_lseek+0x14c/0x1e0 fs/read_write.c:403
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1543f16909
RSP: 002b:00007f1543e7f218 EFLAGS: 00000246 ORIG_RAX: 0000000000000008
RAX: ffffffffffffffda RBX: 00007f1543f9e708 RCX: 00007f1543f16909
RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f1543f9e700 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f1543f6a10c
R13: 0031656c69662f2e R14: 7366656863616362 R15: 00007f1543f6404d
 </TASK>
INFO: task bch-reclaim/loo:5889 blocked for more than 147 seconds.
      Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:bch-reclaim/loo state:D stack:13496 pid:5889  tgid:5889  ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 six_lock_slowpath+0x660/0x1680 fs/bcachefs/six.c:499
 six_lock_ip_waiter+0x117/0x160 fs/bcachefs/six.c:556
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 btree_node_lock_nopath+0xa4/0x150 fs/bcachefs/btree_locking.h:241
 btree_node_lock fs/bcachefs/btree_locking.h:289 [inline]
 btree_path_lock_root fs/bcachefs/btree_iter.c:748 [inline]
 bch2_btree_path_traverse_one+0xc39/0x2940 fs/bcachefs/btree_iter.c:1183
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_traverse+0x699/0xc30 fs/bcachefs/btree_iter.c:1880
 btree_key_cache_flush_pos fs/bcachefs/btree_key_cache.c:427 [inline]
 bch2_btree_key_cache_journal_flush+0x8e1/0xe70 fs/bcachefs/btree_key_cache.c:512
 journal_flush_pins+0x5f7/0xb20 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0x789/0xda0 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x174/0x560 fs/bcachefs/journal_reclaim.c:740
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Showing all locks held in the system:
1 lock held by pool_workqueue_/3:
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #0: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
4 locks held by kworker/0:0H/10:
 #0: ffff88802887f148 ((wq_completion)bcachefs_btree_io){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88802887f148 ((wq_completion)bcachefs_btree_io){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900000f7d00 ((work_completion)(&wb->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900000f7d00 ((work_completion)(&wb->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #3: ffff88807c120128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #3: ffff88807c120128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #3: ffff88807c120128 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
3 locks held by kworker/u8:2/35:
 #0: ffff8880206ba948 ((wq_completion)writeback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880206ba948 ((wq_completion)writeback){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000ab7d00 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000ab7d00 ((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff88802a2c80e0 (&type->s_umount_key#47){.+.+}-{4:4}, at: super_trylock_shared+0x22/0xf0 fs/super.c:562
4 locks held by kworker/1:1H/40:
 #0: ffff88802887f148 ((wq_completion)bcachefs_btree_io){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88802887f148 ((wq_completion)bcachefs_btree_io){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000b07d00 ((work_completion)(&wb->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000b07d00 ((work_completion)(&wb->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #3: ffff888027dc8128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 #3: ffff888027dc8128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9b0/0x1bf0 fs/bcachefs/btree_iter.c:3125
4 locks held by kworker/u9:0/55:
 #0: ffff88801278a148 ((wq_completion)bcachefs){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801278a148 ((wq_completion)bcachefs){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000bf7d00 ((work_completion)(&wp->index_update_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000bf7d00 ((work_completion)(&wp->index_update_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888029624128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 #2: ffff888029624128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_btree_path_traverse_all fs/bcachefs/btree_iter.c:1003 [inline]
 #2: ffff888029624128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0xde0/0x1bf0 fs/bcachefs/btree_iter.c:3128
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_trans_srcu_lock+0x9a/0x1a0 fs/bcachefs/btree_iter.c:3053
4 locks held by kworker/u8:4/62:
 #0: ffff8880676a3148 ((wq_completion)btree_update){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880676a3148 ((wq_completion)btree_update){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc9000153fd00 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000153fd00 ((work_completion)(&c->btree_interior_update_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #2: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #3: ffff888027cb8128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 #3: ffff888027cb8128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9b0/0x1bf0 fs/bcachefs/btree_iter.c:3125
2 locks held by getty/5573:
 #0: ffff8880315f40a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
1 lock held by syz-executor199/5872:
 #0: ffff88802a2c8420 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff88802a2c8420 (sb_writers#10){.+.+}-{0:0}, at: vfs_writev+0x2d1/0xba0 fs/read_write.c:1048
2 locks held by syz-executor199/5899:
 #0: ffff8880273bc478 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x254/0x320 fs/file.c:1191
 #1: ffff88802a2c8420 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #1: ffff88802a2c8420 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x225/0xd30 fs/read_write.c:675
3 locks held by syz-executor199/5900:
 #0: ffff8880340a7eb8 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x254/0x320 fs/file.c:1191
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #2: ffff888064f98128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 #2: ffff888064f98128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9b0/0x1bf0 fs/bcachefs/btree_iter.c:3125
4 locks held by bch-reclaim/loo/5889:
 #0: ffff88806744b0a8 (&j->reclaim_lock){+.+.}-{4:4}, at: bch2_journal_reclaim_thread+0x167/0x560 fs/bcachefs/journal_reclaim.c:739
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #1: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #2: ffff888029600128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #2: ffff888029600128 (bcachefs_btree){+.+.}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #2: ffff888029600128 (bcachefs_btree){+.+.}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #3: ffff888067404398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: bch2_btree_key_cache_journal_flush+0x128/0xe70 fs/bcachefs/btree_key_cache.c:492
1 lock held by dhcpcd/10141:
 #0: ffff88807533b808 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #0: ffff88807533b808 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: __sock_release net/socket.c:639 [inline]
 #0: ffff88807533b808 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: sock_close+0x90/0x240 net/socket.c:1408
1 lock held by dhcpcd/10142:
 #0: ffff88823bea0c88 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #0: ffff88823bea0c88 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: __sock_release net/socket.c:639 [inline]
 #0: ffff88823bea0c88 (&sb->s_type->i_mutex_key#9){+.+.}-{4:4}, at: sock_close+0x90/0x240 net/socket.c:1408
2 locks held by syz-executor199/10144:
 #0: ffff888037280908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:827 [inline]
 #0: ffff888037280908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1683/0x2f80 fs/bcachefs/super.c:2065
 #1: ffff8880372849d0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x1e0/0x2e0 fs/bcachefs/replicas.c:600
2 locks held by syz-executor199/10146:
 #0: ffff88803c380908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:827 [inline]
 #0: ffff88803c380908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1683/0x2f80 fs/bcachefs/super.c:2065
 #1: ffff88803c3849d0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x1e0/0x2e0 fs/bcachefs/replicas.c:600
2 locks held by syz-executor199/10148:
 #0: ffff888053d00908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:827 [inline]
 #0: ffff888053d00908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1683/0x2f80 fs/bcachefs/super.c:2065
 #1: ffff888053d049d0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x1e0/0x2e0 fs/bcachefs/replicas.c:600
2 locks held by syz-executor199/10150:
 #0: ffff888037480908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_alloc fs/bcachefs/super.c:827 [inline]
 #0: ffff888037480908 (&c->sb_lock){+.+.}-{4:4}, at: bch2_fs_open+0x1683/0x2f80 fs/bcachefs/super.c:2065
 #1: ffff8880374849d0 (&c->mark_lock){++++}-{0:0}, at: bch2_sb_replicas_to_cpu_replicas+0x1e0/0x2e0 fs/bcachefs/replicas.c:600
2 locks held by dhcpcd/10151:
 #0: ffff888030c3e258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1623 [inline]
 #0: ffff888030c3e258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
1 lock held by dhcpcd/10152:
 #0: ffff88802a50c258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1623 [inline]
 #0: ffff88802a50c258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 1153 Comm: kworker/u8:7 Not tainted 6.13.0-rc5-syzkaller-00006-g56e6a3499e14 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events_unbound nsim_dev_trap_report_work
RIP: 0010:bytes_is_nonzero mm/kasan/generic.c:87 [inline]
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:104 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:129 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:161 [inline]
RIP: 0010:check_region_inline mm/kasan/generic.c:180 [inline]
RIP: 0010:kasan_check_range+0x86/0x290 mm/kasan/generic.c:189
Code: 00 fc ff df 4f 8d 3c 31 4c 89 fd 4c 29 dd 48 83 fd 10 7f 29 48 85 ed 0f 84 3e 01 00 00 4c 89 cd 48 f7 d5 48 01 dd 41 80 3b 00 <0f> 85 c9 01 00 00 49 ff c3 48 ff c5 75 ee e9 1e 01 00 00 45 89 dc
RSP: 0018:ffffc90003f2f768 EFLAGS: 00000046
RAX: 0000000000000001 RBX: 1ffff920007e5f3a RCX: ffffffff854bb918
RDX: 0000000000000001 RSI: 0000000000000020 RDI: ffffc90003f2f9d0
RBP: fffffffffffffffc R08: ffffc90003f2f9ef R09: 1ffff920007e5f3d
R10: dffffc0000000000 R11: fffff520007e5f3a R12: 0000000000000020
R13: 1ffff110170e756e R14: dffffc0000000001 R15: fffff520007e5f3e
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005592f2707600 CR3: 000000007c4aa000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 crng_fast_key_erasure drivers/char/random.c:324 [inline]
 crng_make_state+0x368/0xa80 drivers/char/random.c:392
 _get_random_bytes+0xd7/0x2c0 drivers/char/random.c:406
 eth_random_addr include/linux/etherdevice.h:238 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:755 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:805 [inline]
 nsim_dev_trap_report_work+0x328/0xb50 drivers/net/netdevsim/dev.c:851
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
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
