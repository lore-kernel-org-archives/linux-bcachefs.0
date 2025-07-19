Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09BE1F956
	for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752944320; cv=none; b=VINW+Fvf9WG+HdDlGybG8WWWtUSh5CjSkKgJAJCamHsbPT06r1uTYWmSqjqd2EYr0MaGWwfKEsgJfWtA0ADUWOxkW47QOLWNxJsuuwOvJQNKCiMxgWMmOTPEprm8Y3Q4FNpRyWehAjCFbERna2LAgWbOUh7kePNsE0hkVfzvO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752944320; c=relaxed/simple;
	bh=9Gq+leZb/A+D6ye3VY2Hb0yCgnTy75wf619P/wTOCpU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=t82px2c+pYPH4M9Nbn4EWr/dGavZEOwtPGmkdxwWmeYbXiK11nhvfAFI148UMFrYrdAm5d5WoCbJ6oXbV9ckh9vtErAZule4Cpv09qpB3wp31hJc+ozkT87QXXHg3rWDBU8pJ6rzcc+e7Y219NqoaCjro9w81i/g6rWAI8oK9nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-86cc7cdb86fso284495439f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 19 Jul 2025 09:58:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752944315; x=1753549115;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nlqkQLh/K8VLnu8hKjximPArNY0x+mjxGEw2XcDN9WA=;
        b=JGEpX1tYtYzFqCN7KMPi+cEzCQECxz/hBrMbjZzXgT6zEu15txgLdosV4XE3b4bQs3
         ZgXR+8TSYhsX0gjICC81oQC9v3jBtkc9a5AC93btlWbRzyHajmokOBwQmwPx7l8u05Yu
         SkZ8cwBPavUxcy5tT8v21/lrmFQdrp1QdjUjds2CF0djvfH1BU2quG2Eh7ZYQzAcHteG
         /lHeJWSBQnBizduyxyhO2/lxcbqmZ3AwNlWWbIqiTuRf2B34cekXhbIdkTdV6nkGuNv8
         kI0xhc1q03iKUKQERqHMaeC/ahjZguRB3YfmDenOOVBQYgFnMjqrrwJmjsFSJb2Z/koE
         juOA==
X-Forwarded-Encrypted: i=1; AJvYcCWgz+nWaXnjWBKckQcyajCd5WOSeMEpscFsEmVfGcNGT5DFLDKCvErUuU/q7WGU9zsvjg3f2aE6m5V5Ma77ZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJvqcEnMvRzcYCYdoIZBwl2sPZEjL0s26BiPWlx3ZJ6Vz/tcUf
	CLP/ihUGkb8dibcOKCgLBLYnfK8cahIJ2VUHls1E8z1Fr8BUEgzsQ+AlI6bAzOogsUKMuUJ9SkW
	HM7gCvSCA8f9k6Vee6zDoZKYJNJYRQ1vRprBONuAR1ih7m4QJMa+Lh84/fhs=
X-Google-Smtp-Source: AGHT+IHUNKka3jl9vQQhlozaLdZY5EwGA+RSlJqz3CE10G3ZfdJGVPVsT2IpM9UV5kekB4/MX7/3+EABSGZH/ZeMdOEsZkxlMf1R
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5e:8c06:0:b0:864:4b3a:9e3a with SMTP id
 ca18e2360f4ac-879c298bce6mr1503078339f.13.1752944314711; Sat, 19 Jul 2025
 09:58:34 -0700 (PDT)
Date: Sat, 19 Jul 2025 09:58:34 -0700
In-Reply-To: <687a71bf.a70a0220.693ce.006b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687bceba.a70a0220.693ce.008d.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_get_next_dev
From: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    d086c886ceb9 Add linux-next specific files for 20250718
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=17bd438c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cc0cd9fdf69889c3
dashboard link: https://syzkaller.appspot.com/bug?extid=2b98caf09c41174a9697
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1480c38c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112df8f0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4435f80a19c4/disk-d086c886.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9a7dc57a5ea3/vmlinux-d086c886.xz
kernel image: https://storage.googleapis.com/syzbot-assets/da9f2dc22ae1/bzImage-d086c886.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/30708d56eaf8/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
BUG: KASAN: slab-use-after-free in atomic_long_inc_return include/linux/atomic/atomic-instrumented.h:3609 [inline]
BUG: KASAN: slab-use-after-free in bch2_dev_get fs/bcachefs/sb-members.h:114 [inline]
BUG: KASAN: slab-use-after-free in bch2_get_next_dev+0x38f/0x4e0 fs/bcachefs/sb-members.h:145
Write of size 8 at addr ffff88807b3cc040 by task kworker/u9:4/5922

CPU: 0 UID: 0 PID: 5922 Comm: kworker/u9:4 Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Workqueue: bcachefs_journal journal_write_done
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:96 [inline]
 atomic_long_inc_return include/linux/atomic/atomic-instrumented.h:3609 [inline]
 bch2_dev_get fs/bcachefs/sb-members.h:114 [inline]
 bch2_get_next_dev+0x38f/0x4e0 fs/bcachefs/sb-members.h:145
 bch2_do_discards+0x20/0x160 fs/bcachefs/alloc_background.c:1935
 journal_write_done+0x11b9/0x13f0 fs/bcachefs/journal_io.c:1822
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5859:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x230/0x3d0 mm/slub.c:4396
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 __bch2_dev_alloc+0xa7/0xc30 fs/bcachefs/super.c:1487
 bch2_dev_alloc+0xcd/0x180 fs/bcachefs/super.c:1558
 bch2_fs_alloc fs/bcachefs/super.c:1068 [inline]
 bch2_fs_open+0x256f/0x2760 fs/bcachefs/super.c:2395
 bch2_fs_get_tree+0x44f/0x1540 fs/bcachefs/fs.c:2440
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5859:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kfree+0x18e/0x440 mm/slub.c:4879
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22b/0x480 lib/kobject.c:737
 bch2_fs_free+0x4b3/0x5c0 fs/bcachefs/super.c:749
 bch2_fs_get_tree+0xb76/0x1540 fs/bcachefs/fs.c:2572
 vfs_get_tree+0x92/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:548
 insert_work+0x3d/0x330 kernel/workqueue.c:2184
 __queue_work+0xcd2/0xfb0 kernel/workqueue.c:2339
 queue_work_on+0x181/0x270 kernel/workqueue.c:2390
 queue_work include/linux/workqueue.h:669 [inline]
 bch2_dev_do_discards fs/bcachefs/alloc_background.c:1925 [inline]
 bch2_do_discards+0xd0/0x160 fs/bcachefs/alloc_background.c:1936
 journal_write_done+0x11b9/0x13f0 fs/bcachefs/journal_io.c:1822
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Second to last potentially related work creation:
 kasan_save_stack+0x3e/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:548
 insert_work+0x3d/0x330 kernel/workqueue.c:2184
 __queue_work+0xcd2/0xfb0 kernel/workqueue.c:2339
 queue_work_on+0x181/0x270 kernel/workqueue.c:2390
 queue_work include/linux/workqueue.h:669 [inline]
 bch2_dev_do_discards fs/bcachefs/alloc_background.c:1925 [inline]
 bch2_do_discards+0xd0/0x160 fs/bcachefs/alloc_background.c:1936
 journal_write_done+0x11b9/0x13f0 fs/bcachefs/journal_io.c:1822
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88807b3cc000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 64 bytes inside of
 freed 4096-byte region [ffff88807b3cc000, ffff88807b3cd000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7b3c8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801a442140 ffffea0000cdf200 dead000000000002
raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801a442140 ffffea0000cdf200 dead000000000002
head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0001ecf201 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5228, tgid 5228 (udevadm), ts 37270032838, free_ts 31080557231
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
 __kmalloc_cache_noprof+0x296/0x3d0 mm/slub.c:4391
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 kernfs_iop_get_link+0x66/0x6c0 fs/kernfs/symlink.c:137
 vfs_readlink+0x24d/0x550 fs/namei.c:5375
 do_readlinkat+0x215/0x500 fs/stat.c:590
 __do_sys_readlink fs/stat.c:613 [inline]
 __se_sys_readlink fs/stat.c:610 [inline]
 __x64_sys_readlink+0x7f/0x90 fs/stat.c:610
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 __free_pages mm/page_alloc.c:5260 [inline]
 free_contig_range+0x1bd/0x4a0 mm/page_alloc.c:7117
 destroy_args+0x7e/0x5d0 mm/debug_vm_pgtable.c:958
 debug_vm_pgtable+0x404/0x420 mm/debug_vm_pgtable.c:1340
 do_one_initcall+0x233/0x820 init/main.c:1269
 do_initcall_level+0x137/0x1f0 init/main.c:1331
 do_initcalls+0x69/0xd0 init/main.c:1347
 kernel_init_freeable+0x3d9/0x590 init/main.c:1579
 kernel_init+0x1d/0x1d0 init/main.c:1469
 ret_from_fork+0x3f9/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88807b3cbf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807b3cbf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88807b3cc000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88807b3cc080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88807b3cc100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
