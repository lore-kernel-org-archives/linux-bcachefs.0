Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE072DF15F
	for <linux-bcachefs@vger.kernel.org>; Tue,  2 Sep 2025 05:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756790012; cv=none; b=a1dvi+8gGKCBLpRX1xaqtAZoSoy4zf87w/eECOZLJEkYkCj8rrmkHMMcediVegbYl7z/Cfo+jmCJziht723xuvggYhDTZmgKLJ/5zGMkWqhTDbCgWPw17QMrhvCoAsxWZxHswYGwe9t+W032o8h9ot4/yyAaJiVYo6gjM9H23Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756790012; c=relaxed/simple;
	bh=MT06K0h8Kc/KXuoX0+ZpF6PWQC8jK1LoGGhoTevKupo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=RXygpfz7FV6bGqHaxVjOBUmkr0TXJH0axAtIIwBf+mOluCLG8lTg4z3L9WpJeMszvUwceuFMtL8wBAeSLh4W6WYCjR66sU6dLKRVoF+1F1ePAc8frzyjRBV/4pt6JcX7/lHCzG4arMDMotxwDJyRxRmbM4GpVemUVS799bPi+8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3f34562d2c6so40137245ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 01 Sep 2025 22:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756790009; x=1757394809;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ugY4OwDR6k/3TcECTl3vbOdh6mZW+BCABiGGf60cZW4=;
        b=AUG9KLdByJGm2Rgu10Sdkco9ZYhED3M7eApMKwDRT99A4+gQV8tigUdL7vlN+cuusQ
         4RqLlCqbmt2r2uKAmkLTxDf2kPiqyX1xPYnYzUrtvDZvcnsZ8miEo7neVqaZiu6ugyax
         m+Vks4u1yCmol7k5s8H2U6Vo9nP1VcJTam1Ez6OcLaZ1MhdboIfjNkKMLP1NUt9ZOY0/
         s0lMQDlDyFgObPyzDac4pzMtRLiQUo0+duVcScAc9EkhpWFScyu7XOBGrprho99mOriU
         244UeVnY8xfv9jj/sNQ+TyURZvGlsrH0gIiE7qbfCrE3Ay2weFjFCgeIY7UJKj1etNA9
         dw6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+kFEu26ln9ZPoooOErmVTTZl5MjGVszfbxgcW5qkojozh8DsH8LFz8Tv6u2wg2D1EGfUwCxzt0UFUC1F7nw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBVT6PLYjqb4Xr7ITR//lu1EW82rmagixoRxPUg0tJPAoYxT5/
	zx5SY1ZyNh4QhWZpLrlPmFw/K/Yxx0yJFMFMECbTYVwCWzV8Gegnof/+PZtqrbGV+2HU7mXwzeW
	3z2T4avCSdJ6AJvfyJaC8+SxxYb/dyW5Z2/tbMuAEPqGiTbsiZdpfy4rN2ko=
X-Google-Smtp-Source: AGHT+IEiI7BFf52vOGv33nNZ5Eb/w7dDXWfb6QFMIw+ls59Utskb3Ckl8Ip89TtlBmWgae8JJlZktH7dpvjlznl7wPqM01kBGnx+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cd8e:0:b0:3f0:a056:e10f with SMTP id
 e9e14a558f8ab-3f40066c550mr178707975ab.5.1756790009392; Mon, 01 Sep 2025
 22:13:29 -0700 (PDT)
Date: Mon, 01 Sep 2025 22:13:29 -0700
In-Reply-To: <6740795d.050a0220.363a1b.013a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b67cf9.a00a0220.1337b0.05cb.GAE@google.com>
Subject: Re: [syzbot] [mm?] BUG: corrupted list in list_lru_add
From: syzbot <syzbot+092ef2e75c24d23f33c4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b320789d6883 Linux 6.17-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100d0312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9c302bcfb26a48af
dashboard link: https://syzkaller.appspot.com/bug?extid=092ef2e75c24d23f33c4
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156be662580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15230e62580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/01625a78a66b/disk-b320789d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8d91d48fc1b/vmlinux-b320789d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5cce19077de9/bzImage-b320789d.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/c616867486c6/mount_2.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=11230e62580000)
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/f5d9d153bd09/mount_5.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+092ef2e75c24d23f33c4@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __list_add_valid_or_report+0x6a/0x130 lib/list_debug.c:32
Read of size 8 at addr ffff888051ac9708 by task syz-executor/5975

CPU: 1 UID: 0 PID: 5975 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __list_add_valid_or_report+0x6a/0x130 lib/list_debug.c:32
 __list_add_valid include/linux/list.h:88 [inline]
 __list_add include/linux/list.h:150 [inline]
 list_add_tail include/linux/list.h:183 [inline]
 list_lru_add+0xf2/0x270 mm/list_lru.c:171
 qd_put+0x114/0x190 fs/gfs2/quota.c:342
 do_qc+0x488/0x5e0 fs/gfs2/quota.c:719
 do_sync+0x88d/0xc60 fs/gfs2/quota.c:966
 gfs2_quota_sync+0x359/0x460 fs/gfs2/quota.c:1357
 gfs2_sync_fs+0x4c/0xb0 fs/gfs2/super.c:658
 sync_filesystem+0xee/0x230 fs/sync.c:56
 generic_shutdown_super+0x6f/0x2c0 fs/super.c:622
 kill_block_super+0x44/0x90 fs/super.c:1766
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1375
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f04ff58ff17
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe3b39e568 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f04ff611c05 RCX: 00007f04ff58ff17
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe3b39e620
RBP: 00007ffe3b39e620 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe3b39f6b0
R13: 00007f04ff611c05 R14: 000000000005a186 R15: 00007ffe3b39f6f0
 </TASK>

Allocated by task 7054:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:330 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:356
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4180 [inline]
 slab_alloc_node mm/slub.c:4229 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4236
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x777/0x1230 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1278
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 23:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kmem_cache_free+0x18f/0x400 mm/slub.c:4782
 gfs2_qd_dealloc+0x70/0xe0 fs/gfs2/quota.c:111
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
 handle_softirqs+0x286/0x870 kernel/softirq.c:579
 run_ksoftirqd+0x9b/0x100 kernel/softirq.c:968
 smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:548
 __call_rcu_common kernel/rcu/tree.c:3123 [inline]
 call_rcu+0x157/0x9c0 kernel/rcu/tree.c:3243
 gfs2_quota_sync+0x3c4/0x460 fs/gfs2/quota.c:1361
 gfs2_sync_fs+0x4c/0xb0 fs/gfs2/super.c:658
 sync_filesystem+0xee/0x230 fs/sync.c:56
 generic_shutdown_super+0x6f/0x2c0 fs/super.c:622
 kill_block_super+0x44/0x90 fs/super.c:1766
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1375
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888051ac9690
 which belongs to the cache gfs2_quotad of size 272
The buggy address is located 120 bytes inside of
 freed 272-byte region [ffff888051ac9690, ffff888051ac97a0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888051ac9540 pfn:0x51ac9
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff8881405d6000 dead000000000122 0000000000000000
raw: ffff888051ac9540 00000000800c0007 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Reclaimable, gfp_mask 0x52c50(GFP_NOFS|__GFP_RECLAIMABLE|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 6304, tgid 6304 (syz.2.68), ts 167216429244, free_ts 31894484706
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 kmem_cache_alloc_noprof+0x283/0x3c0 mm/slub.c:4236
 qd_alloc+0x50/0x250 fs/gfs2/quota.c:234
 gfs2_quota_init+0x777/0x1230 fs/gfs2/quota.c:1448
 gfs2_make_fs_rw+0x181/0x2b0 fs/gfs2/super.c:149
 gfs2_fill_super+0x1a7b/0x20d0 fs/gfs2/ops_fstype.c:1278
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1692
 gfs2_get_tree+0x51/0x1e0 fs/gfs2/ops_fstype.c:1335
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 __free_pages mm/page_alloc.c:5260 [inline]
 free_contig_range+0x1bd/0x4a0 mm/page_alloc.c:7091
 destroy_args+0x69/0x660 mm/debug_vm_pgtable.c:958
 debug_vm_pgtable+0x39f/0x3b0 mm/debug_vm_pgtable.c:1345
 do_one_initcall+0x236/0x820 init/main.c:1269
 do_initcall_level+0x104/0x190 init/main.c:1331
 do_initcalls+0x59/0xa0 init/main.c:1347
 kernel_init_freeable+0x334/0x4b0 init/main.c:1579
 kernel_init+0x1d/0x1d0 init/main.c:1469
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888051ac9600: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
 ffff888051ac9680: fc fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888051ac9700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                      ^
 ffff888051ac9780: fb fb fb fb fc fc fc fc fc fc fc fc 00 00 00 00
 ffff888051ac9800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
