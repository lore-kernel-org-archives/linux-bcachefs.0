Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025DF125A9
	for <linux-bcachefs@vger.kernel.org>; Fri, 28 Nov 2025 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764366388; cv=none; b=VAPABX5qdmJyMROHVvUO0EJ20J65StyVfzUWLlOv+jXSfg1OamyY6pjdUPiJKHgP83i+xlX+L9f/qZdnsA7xmAU8A1GYMjJ1UqfLCmYxoKzb9yDqc9lKEIp4K7sK5wFpr5vYFIuZla7KX4QZRh7ZDU6IYvPiZGD3XO5TQpifUzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764366388; c=relaxed/simple;
	bh=0IwIOSpKt8idsdB3m57tm0L3qm6OGlxAd1ozuj93Yu8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=YGC/pBKsgAXAOkKG6F3EseAn1EknALz3rgmOxgyprKE28rng860Q0EtGEma5aQUtVCJPOksMJdRXbR4ZpCyd8eu5KWVXoesbWvcz9lxEikN+yclP83sgQe3KyB/XFOqeLfqz0i7NRVQce8b9sm3fQe4dd8qnHa2EiW1//s8LW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-43322fcfae7so18179055ab.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 28 Nov 2025 13:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764366386; x=1764971186;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4zqTUfXNqwz/7tm7pYrG+8QIUcooqUYxlgrT2O9hZa0=;
        b=f48zzr6i8KY8+XBWATWcMyQqdGWz2f9f45fXiUuvykG7mOUJFaN3J/8xD25zA+/Awv
         ffqMUIc1ND67vt749t7l2lJVYbnu4t91RzTpMMMvJvSq08uMoxmYPu0IGAA0osDgZWq6
         TQSz9vZq19cdMkXTZuFihafCNnkAyv0QsEcVRdc7BkCxg+djDcfoEUIs6qMTP2SpjE8c
         UN3m3t+3aLup7239OPFp8hyDcz5zkH4J7jxWgymZxGW1yNT0UKB+gtmGvOUQmhFlhzr0
         tKOzstE3y5+PP8S1wsUPv7t1e5l5QOEAAAzwZmG69Wcy5m/JumV5+b+8h2vzwTHdbBK9
         6CYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTXT+bP6in7ogThqlPMVaHlC8VZATgREackSL54w5bsvczJEE12DkE/MRuFDuVqaN/NDEONOayoRE4+jAFMg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYg1X/7AKjOASpog0rdTXKGxUhsXJDjyIYCvxEeNOI79QheG+V
	r4+NcVW3ylaWCXjaKyml/SyO6rTsNOWkNO/TocgikhnKk2fadpiILQL8/Pr+wghYnpl4MTY6LfJ
	6I5JmoxOVIllogJFw+AhARHzxaEpoulBSHwL7A5pO5IssN7AYsG6Ge8jWFzA=
X-Google-Smtp-Source: AGHT+IEcOB/WTsXTe6x1ZunQ3YZskzecgAj5mzsYfP/KlNr1cW7cmgiWW4CLJwfqc7/WTMT5lfQ5aRh5X65Nr5cvaqpAcszYvoEO
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24b:0:b0:435:a467:b2b3 with SMTP id
 e9e14a558f8ab-435dd0fd25fmr104837015ab.20.1764366386137; Fri, 28 Nov 2025
 13:46:26 -0800 (PST)
Date: Fri, 28 Nov 2025 13:46:26 -0800
In-Reply-To: <67a4eae3.050a0220.65602.0001.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692a1832.a70a0220.d98e3.0150.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in list_lru_del
From: syzbot <syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, hughd@google.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    e538109ac71d Merge tag 'drm-fixes-2025-11-28' of https://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10fd2112580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a1db0fea040c2a9f
dashboard link: https://syzkaller.appspot.com/bug?extid=6663075ddb9be85fa6e5
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fd2112580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a10112580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e538109a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3cf595fe0afc/vmlinux-e538109a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e6e26f95e409/bzImage-e538109a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/445f48d13fdb/mount_7.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11a10112580000)

The issue was bisected to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=108d43a8580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=128d43a8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=148d43a8580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6663075ddb9be85fa6e5@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

==================================================================
BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
Read of size 8 at addr ffff88800098a080 by task syz.0.17/5483

CPU: 0 UID: 0 PID: 5483 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __list_del_entry_valid_or_report+0xb5/0x190 lib/list_debug.c:65
 __list_del_entry_valid include/linux/list.h:132 [inline]
 __list_del_entry include/linux/list.h:223 [inline]
 list_del_init include/linux/list.h:295 [inline]
 list_lru_del+0x98/0x210 mm/list_lru.c:210
 gfs2_quota_cleanup+0x21e/0x6f0 fs/gfs2/quota.c:1532
 gfs2_make_fs_ro+0x27a/0x300 fs/gfs2/super.c:566
 gfs2_put_super+0x224/0x950 fs/gfs2/super.c:598
 generic_shutdown_super+0x135/0x2c0 fs/super.c:642
 kill_block_super+0x44/0x90 fs/super.c:1729
 deactivate_locked_super+0xbc/0x130 fs/super.c:473
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1318
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6b5/0x2300 kernel/exit.c:966
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 __do_sys_exit_group kernel/exit.c:1118 [inline]
 __se_sys_exit_group kernel/exit.c:1116 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4bb3d8f7c9
Code: Unable to access opcode bytes at 0x7f4bb3d8f79f.
RSP: 002b:00007ffd56395328 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f4bb3d8f7c9
RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000003 R08: 0000001d5639541f R09: 00007f4bb3fb4280
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4bb3fb4280 R14: 0000000000000003 R15: 00007ffd563953e0
 </TASK>

Allocated by task 5483:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5295
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x762/0x1200 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1280
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1698
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1337
 vfs_get_tree+0x92/0x2b0 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3718
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4206
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 15:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kmem_cache_free+0x19b/0x690 mm/slub.c:6752
 gfs2_qd_dealloc+0x70/0xe0 fs/gfs2/quota.c:111
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:559
 __call_rcu_common kernel/rcu/tree.c:3123 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3243
 gfs2_quota_sync+0x3c4/0x460 fs/gfs2/quota.c:1361
 gfs2_sync_fs+0x4c/0xb0 fs/gfs2/super.c:658
 sync_filesystem+0xee/0x230 fs/sync.c:56
 generic_shutdown_super+0x6f/0x2c0 fs/super.c:621
 kill_block_super+0x44/0x90 fs/super.c:1729
 deactivate_locked_super+0xbc/0x130 fs/super.c:473
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1318
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6b5/0x2300 kernel/exit.c:966
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 __do_sys_exit_group kernel/exit.c:1118 [inline]
 __se_sys_exit_group kernel/exit.c:1116 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88800098a000
 which belongs to the cache gfs2_quotad of size 272
The buggy address is located 128 bytes inside of
 freed 272-byte region [ffff88800098a000, ffff88800098a110)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x98a
flags: 0x7ff00000000000(node=0|zone=0|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 007ff00000000000 ffff888032687dc0 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Reclaimable, gfp_mask 0x52c50(GFP_NOFS|__GFP_RECLAIMABLE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5483, tgid 5483 (syz.0.17), ts 105510017652, free_ts 102275632308
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x234/0x290 mm/page_alloc.c:1845
 prep_new_page mm/page_alloc.c:1853 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3879
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5178
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab+0x96/0x350 mm/slub.c:3232
 new_slab mm/slub.c:3286 [inline]
 ___slab_alloc+0xf56/0x1990 mm/slub.c:4655
 __slab_alloc+0x65/0x100 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_noprof+0x3f9/0x6e0 mm/slub.c:5295
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x762/0x1200 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1280
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1698
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1337
 vfs_get_tree+0x92/0x2b0 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3718
page last free pid 5433 tgid 5433 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 free_unref_folios+0xdb3/0x14f0 mm/page_alloc.c:2958
 folios_put_refs+0x584/0x670 mm/swap.c:1002
 free_pages_and_swap_cache+0x4be/0x520 mm/swap_state.c:358
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:136 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:149 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:397 [inline]
 tlb_flush_mmu+0x3a0/0x680 mm/mmu_gather.c:404
 tlb_finish_mmu+0xc3/0x1d0 mm/mmu_gather.c:497
 exit_mmap+0x444/0xb40 mm/mmap.c:1293
 __mmput+0x118/0x430 kernel/fork.c:1133
 exit_mm+0x1da/0x2c0 kernel/exit.c:582
 do_exit+0x648/0x2300 kernel/exit.c:954
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 __do_sys_exit_group kernel/exit.c:1118 [inline]
 __se_sys_exit_group kernel/exit.c:1116 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1116
 x64_sys_call+0x21f7/0x2200 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888000989f80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88800098a000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88800098a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff88800098a100: fb fb fc fc fc fc fc fc fc fc 00 00 00 00 00 00
 ffff88800098a180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
