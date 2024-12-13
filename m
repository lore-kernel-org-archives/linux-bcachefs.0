Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83B318FDC8
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 22:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129684; cv=none; b=esl0fNaAD2Nkbc5eYmJC62Mw77pKbwAZ5cZ9NqS4LwiSeCE1V6VTJZLxaZf+c2twzHLzMWoSmbfZE+y4XY2zE01BChW/EbCYr+GeTmdp+bu1MYRGwdoLsu7bsh22fYO5LsqgHE1wGKP1Z3P6iK5tyvrUf4Ywh4jWLtLb8nOrt8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129684; c=relaxed/simple;
	bh=ypQ7Y+W93YZoaBxN6qFRw2Vhzj+JNkxRbxsIK9FgJGg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mIygf2+7G+FGppbdqVbh4u8tg7btfyjRNQIKdtzd6yqjBGsWiZR6KuqG/YEo7dcz65D77TPpn5sOYfFmjyPZYCz97PkPUXgxde7iXu9Y5k4nLwkYCaS//oThvt+2Xm0/O4DGsDFecO1A+uy2Pc6M2Bm88S/1kiSwotWbBbP7uiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-844db0decffso190301839f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Dec 2024 14:41:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734129682; x=1734734482;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tx28koADOyQF6dnj6f/6cz1TJSNyqr26EUG9WdTUPg0=;
        b=KihEZrBV009XsBAUnkT8eBGVYqZS2OJUrnEba7OJksALuWolk0a2/0d+pM2BQHErHK
         309b8fJNdmAV6a6/Bi4bVt/2ufwJueb46m8WAWCBxIQTIuhzUbtC+tMaotzDsevOG6/b
         27MxCXspe7tAsENNMw1RKmLQsKM+LTH7hNlKGiszaIt1HLIvuM4ayZDINtz99ZL5wQmo
         lCz81HxgDLg6saSM5y/Eh015tY8wYsI8/YHqieer16f7cPiie0EmLpdon0eY9x3A3wSX
         m1tHy2L82dTuvdNCV+2mfloumJuxBX4YYkoLXMgE7d06ZHVrNx+w3c7hnKz8iWs6cs2C
         bo9A==
X-Forwarded-Encrypted: i=1; AJvYcCUJwblrmbCOZIaYv3sjPniE0JnutaY2JINaD13Eezl4Z1PM0/vSTb/fLj0Q2Qze6Ds8Kqc1ZP/SSpyvYAPg5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyshLGKgo20BSsG6R20SAYAYUYnrgn5jteF66YYUO64CcejtAzc
	6FlDGcX2zzruoxAOCk5DHQ5GKfM62+XrBDaQJi9RTTQabHTShvw/cunMB8VrarYy0htvkdIRho2
	PU64KCk33E/ngw3BPLCCyfZspkcP327iC5gB7tGldY7vjcyyIEFW7DT0=
X-Google-Smtp-Source: AGHT+IFdxejVftKIo1esXs43FRirMCbXPfa2qgWbkwhKE1+QQmzaUhgZy98smCNTSzDCwIFBj8hnxEQdzEXbX/tWlSMwPZ77XTmG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d10c:0:b0:3a8:13d5:bd2c with SMTP id
 e9e14a558f8ab-3ae61f23bb3mr62934715ab.2.1734129682191; Fri, 13 Dec 2024
 14:41:22 -0800 (PST)
Date: Fri, 13 Dec 2024 14:41:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675cb812.050a0220.37aaf.00b6.GAE@google.com>
Subject: [syzbot] [bcachefs?] INFO: task hung in bch2_page_fault
From: syzbot <syzbot+32415e0466b02533303c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f932fb9b4074 Merge tag 'v6.13-rc2-ksmbd-server-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=106aea0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c7c9f223bfe8924e
dashboard link: https://syzkaller.appspot.com/bug?extid=32415e0466b02533303c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f906447f0c03/disk-f932fb9b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0ddfd52ea0e6/vmlinux-f932fb9b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4c5a34e2dbda/bzImage-f932fb9b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+32415e0466b02533303c@syzkaller.appspotmail.com

INFO: task syz.3.161:7157 blocked for more than 143 seconds.
      Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.3.161       state:D stack:24320 pid:7157  tgid:7117  ppid:5827   flags:0x00000004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 __bch2_two_state_lock+0x229/0x2c0 fs/bcachefs/two_state_shared_lock.c:7
 bch2_two_state_lock fs/bcachefs/two_state_shared_lock.h:55 [inline]
 bch2_page_fault+0x31f/0x960 fs/bcachefs/fs-io-pagecache.c:592
 __do_fault+0x135/0x390 mm/memory.c:4907
 do_read_fault mm/memory.c:5322 [inline]
 do_fault mm/memory.c:5456 [inline]
 do_pte_missing mm/memory.c:3979 [inline]
 handle_pte_fault+0x39eb/0x5ed0 mm/memory.c:5801
 __handle_mm_fault mm/memory.c:5944 [inline]
 handle_mm_fault+0x1053/0x1ad0 mm/memory.c:6112
 do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x2b9/0x8b0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:fault_in_readable+0x173/0x2d0 mm/gup.c:2244
Code: 00 fc ff df 4c 89 e8 4f 8d ac 25 ff 0f 00 00 49 81 e5 00 f0 ff ff 49 39 c5 72 7a e8 e7 da b7 ff 4c 39 eb 74 7d 4c 89 64 24 08 <44> 8a 23 43 0f b6 04 3e 84 c0 75 18 44 88 64 24 40 48 81 c3 00 10
RSP: 0018:ffffc90003cf7920 EFLAGS: 00050287
RAX: ffffffff81e78309 RBX: 0000000020001000 RCX: 0000000000080000
RDX: ffffc9000f05a000 RSI: 0000000000000042 RDI: 0000000000000043
RBP: ffffc90003cf79d8 R08: ffffffff81e7829c R09: ffffffff84b7a909
R10: 0000000000000002 R11: ffff88802bd40000 R12: 000000000000fdef
R13: 0000000020010000 R14: 1ffff9200079ef2c R15: dffffc0000000000
 fault_in_iov_iter_readable+0x229/0x280 lib/iov_iter.c:94
 bch2_buffered_write fs/bcachefs/fs-io-buffered.c:983 [inline]
 bch2_write_iter+0x528/0x2c10 fs/bcachefs/fs-io-buffered.c:1054
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xaeb/0xd30 fs/read_write.c:679
 ksys_pwrite64 fs/read_write.c:786 [inline]
 __do_sys_pwrite64 fs/read_write.c:794 [inline]
 __se_sys_pwrite64 fs/read_write.c:791 [inline]
 __x64_sys_pwrite64+0x1ac/0x240 fs/read_write.c:791
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8345b85d19
RSP: 002b:00007f834692e038 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
RAX: ffffffffffffffda RBX: 00007f8345d76080 RCX: 00007f8345b85d19
RDX: 000000000000fdef RSI: 0000000020000140 RDI: 0000000000000008
RBP: 00007f8345c01a20 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000fecc R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f8345d76080 R15: 00007ffdec473828
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
1 lock held by dhcpcd/5486:
 #0: ffff8880b863e758 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x2a/0x140 kernel/sched/core.c:598
2 locks held by getty/5581:
 #0: ffff88814dac10a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
5 locks held by syz.3.161/7118:
 #0: ffff88807e0d2420 (sb_writers#27){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88805603a6c8 (&sb->s_type->i_mutex_key#32){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff88805603a6c8 (&sb->s_type->i_mutex_key#32){++++}-{4:4}, at: do_truncate+0x20c/0x310 fs/open.c:63
 #2: ffff888069880a38 (&c->snapshot_create_lock){.+.+}-{4:4}, at: bch2_truncate+0x166/0x2d0 fs/bcachefs/io_misc.c:292
 #3: ffff888069884398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire include/linux/srcu.h:158 [inline]
 #3: ffff888069884398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_read_lock include/linux/srcu.h:249 [inline]
 #3: ffff888069884398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: __bch2_trans_get+0x7e1/0xd30 fs/bcachefs/btree_iter.c:3228
 #4: ffff8880698a66d0 (&c->gc_lock){++++}-{4:4}, at: bch2_btree_update_start+0x682/0x14e0 fs/bcachefs/btree_update_interior.c:1197
3 locks held by syz.3.161/7157:
 #0: ffff88807e0d2420 (sb_writers#27){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2964 [inline]
 #0: ffff88807e0d2420 (sb_writers#27){.+.+}-{0:0}, at: vfs_write+0x225/0xd30 fs/read_write.c:675
 #1: ffff8880563497c8 (&sb->s_type->i_mutex_key#32){++++}-{4:4}, at: inode_lock include/linux/fs.h:818 [inline]
 #1: ffff8880563497c8 (&sb->s_type->i_mutex_key#32){++++}-{4:4}, at: bch2_write_iter+0x13a/0x2c10 fs/bcachefs/fs-io-buffered.c:1040
 #2: ffff8880119d60e0 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:163 [inline]
 #2: ffff8880119d60e0 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/memory.c:6149 [inline]
 #2: ffff8880119d60e0 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x32/0x2f0 mm/memory.c:6209
2 locks held by dhcpcd/11053:
 #0: ffff88807fc3e258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff88807fc3e258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
2 locks held by dhcpcd/11054:
 #0: ffff88807fa12258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff88807fa12258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:297 [inline]
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x381/0x830 kernel/rcu/tree_exp.h:976

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 3548 Comm: kworker/u8:7 Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Workqueue: events_unbound nsim_dev_trap_report_work
RIP: 0010:clear_page_erms+0xb/0x20 arch/x86/lib/clear_page_64.S:50
Code: 48 8d 7f 40 75 d9 90 c3 cc cc cc cc 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa b9 00 10 00 00 31 c0 <f3> aa c3 cc cc cc cc 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 90
RSP: 0018:ffffc9000d327390 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000dc0
RDX: ffff888034b0c000 RSI: 0000000000000004 RDI: ffff888034b0c240
RBP: 0000000000000004 R08: ffffea0000d2c237 R09: 0000000000000000
R10: ffffed1006961000 R11: fffff940001a5847 R12: 0000000000000001
R13: 0000000000000008 R14: ffffea0000d2c200 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643e844f680 CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 clear_page arch/x86/include/asm/page_64.h:54 [inline]
 clear_highpage_kasan_tagged include/linux/highmem.h:242 [inline]
 kernel_init_pages mm/page_alloc.c:1040 [inline]
 post_alloc_hook+0xf8/0x230 mm/page_alloc.c:1554
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3651/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2269
 alloc_slab_page+0x6a/0x110 mm/slub.c:2408
 allocate_slab+0x5a/0x2b0 mm/slub.c:2574
 new_slab mm/slub.c:2627 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3815
 __slab_alloc+0x58/0xa0 mm/slub.c:3905
 __slab_alloc_node mm/slub.c:3980 [inline]
 slab_alloc_node mm/slub.c:4141 [inline]
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_track_caller_noprof+0x2e9/0x4c0 mm/slub.c:4302
 kmalloc_reserve+0x111/0x2a0 net/core/skbuff.c:609
 __alloc_skb+0x1f3/0x440 net/core/skbuff.c:678
 alloc_skb include/linux/skbuff.h:1323 [inline]
 nsim_dev_trap_skb_build drivers/net/netdevsim/dev.c:748 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:805 [inline]
 nsim_dev_trap_report_work+0x261/0xb50 drivers/net/netdevsim/dev.c:851
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

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
