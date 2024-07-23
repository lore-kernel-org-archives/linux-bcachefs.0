Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000371420BC
	for <linux-bcachefs@vger.kernel.org>; Tue, 23 Jul 2024 19:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721762908; cv=none; b=e3+x4wkXbEJ65zQlAj+gZdJdmzd7dFsLUawCJka0ahhKnCzgAb+Nge3GyKFHn9U5tOdZdEUxiRzlcimysJN+zG95T8xGx9kGXrl9YDsesJvRxyjWISbAgE7j9Pt9u7PTYY+Mj5WbHKCPD8TP8k/ybcZILjsrV3OLfo6v5jKmaUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721762908; c=relaxed/simple;
	bh=ubv37vmSZNzQ5HPrHtnlNCTSTR5zVeVap+n9SjTkFjc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ekYBdiTmkxKrtKgCr7q800YVFuSwwjAzPAeS1q5R5M1Z09knJwiZT460Uvj0f/nO7Sw9DYazbnm+O4Ct1U0SRWWXYndYaYim7uHR5i0c3CTNHNKLUUBhgwc80L2HxeWnmvqqATIUK/+Gil8tEXN3QJ7SqoO7hHSlr4uU2YxMrJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-396a820a8a3so1923205ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 23 Jul 2024 12:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721762906; x=1722367706;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GyrJut6P7U0bbaItFzF0nLRAa+ZqkpqWb2IKwiZyn+M=;
        b=ZdGjp5HxsNdgzFAFs1ZMl0xn4xzKZK2hi+mG/ZtiyJ+Hl5TUex1Gxgc122NBfUSXLV
         YabF+tCLBQbmLKYJFwjWBzDj79OyPNnQa7RXMAzqcFL80NwvL34VX39KKd4wZNwZzltd
         Yj+Dg6RDNLoW810h49bcMoD6JFl8KZe/YCJA+wLjdW3upAJXaEut2E3Y77fXFMszhUZT
         fsDSR8nnUPzgem3842WF+FUqvOhDNrah8kf2HF8dg/fr9iUbl3Z0gPbe3EkRAn2x4tZz
         ui7sBl/75/ewVKIuxzhzRDJVfDWASxnNF1YSgdq0HGvxxacSQh0PGjhMbVEoBBj/lk+m
         OURw==
X-Forwarded-Encrypted: i=1; AJvYcCXjkJWaYV05KkYBvaRw0o3+Yb6Q495nnVgzsTh3aWfSw7fgxZ/GcyVpNh3hPLBccFKPljQd3U7KyBwXW65WkAHuPOsE8+q8+nRQTbWi9iI=
X-Gm-Message-State: AOJu0YwolfUHyOYCkKnv7FaZWX/FtD/9bWpi+VCeJRoxDVhobX8OqLud
	GlqC3dMxldyIpKs+ZCEvQc3FPYukIYb+DNnaqO4ggq3ASaXchesZlhIqlTifwYtHZFd76OaomZd
	uHhQlmG8a33muT3rboBoRNRzGF1sOLsjxiAPF9fj82+x76/LQkEQePvs=
X-Google-Smtp-Source: AGHT+IG2JXa8QlyGoOiJG5G/mtGt3xi6rhVJwFbUVCofb8xGfW61uHzqtS11tss8mP1TpEdN1PRfVn+g8D76Znxm3MFDbxn/cbox
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d88:b0:395:fa9a:3187 with SMTP id
 e9e14a558f8ab-39a0e382ce7mr2802685ab.3.1721762906180; Tue, 23 Jul 2024
 12:28:26 -0700 (PDT)
Date: Tue, 23 Jul 2024 12:28:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000692f33061def2a6d@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in percpu_ref_put
From: syzbot <syzbot+9e0404b505e604f67e41@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0b58e108042b Add linux-next specific files for 20240703
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=178e9bae980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed034204f2e40e53
dashboard link: https://syzkaller.appspot.com/bug?extid=9e0404b505e604f67e41
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1d079762feae/disk-0b58e108.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e53996c8d8c2/vmlinux-0b58e108.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a0bf21cdd844/bzImage-0b58e108.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9e0404b505e604f67e41@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in __ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
BUG: KASAN: slab-use-after-free in percpu_ref_put_many include/linux/percpu-refcount.h:332 [inline]
BUG: KASAN: slab-use-after-free in percpu_ref_put+0xda/0x250 include/linux/percpu-refcount.h:351
Read of size 8 at addr ffff888041f600b0 by task kworker/1:5/5142

CPU: 1 UID: 0 PID: 5142 Comm: kworker/1:5 Not tainted 6.10.0-rc6-next-20240703-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: bcachefs_write_ref bch2_do_discards_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 __ref_is_percpu include/linux/percpu-refcount.h:174 [inline]
 percpu_ref_put_many include/linux/percpu-refcount.h:332 [inline]
 percpu_ref_put+0xda/0x250 include/linux/percpu-refcount.h:351
 bch2_do_discards_work+0x286a/0x2d10 fs/bcachefs/alloc_background.c:1871
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 11370:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __kmalloc_cache_noprof+0x19c/0x2c0 mm/slub.c:4189
 kmalloc_noprof include/linux/slab.h:680 [inline]
 kzalloc_noprof include/linux/slab.h:806 [inline]
 __bch2_dev_alloc+0x57/0xa60 fs/bcachefs/super.c:1286
 bch2_dev_alloc+0xd4/0x170 fs/bcachefs/super.c:1356
 bch2_fs_alloc+0x1f70/0x20a0 fs/bcachefs/super.c:935
 bch2_fs_open+0x8cc/0xdf0 fs/bcachefs/super.c:2113
 bch2_fs_get_tree+0x750/0x16c0 fs/bcachefs/fs.c:1925
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3471
 do_mount fs/namespace.c:3811 [inline]
 __do_sys_mount fs/namespace.c:4019 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3996
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 11370:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2231 [inline]
 slab_free mm/slub.c:4473 [inline]
 kfree+0x149/0x360 mm/slub.c:4594
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_free+0x27b/0x3c0 fs/bcachefs/super.c:663
 bch2_fs_get_tree+0xf6f/0x16c0 fs/bcachefs/fs.c:2031
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3471
 do_mount fs/namespace.c:3811 [inline]
 __do_sys_mount fs/namespace.c:4019 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3996
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 insert_work+0x3e/0x330 kernel/workqueue.c:2182
 __queue_work+0xc16/0xee0 kernel/workqueue.c:2334
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2385
 queue_work include/linux/workqueue.h:621 [inline]
 bch2_dev_do_discards+0x189/0x200 fs/bcachefs/alloc_background.c:1884
 bch2_do_discards+0x29/0x60 fs/bcachefs/alloc_background.c:1895
 journal_write_done+0x785/0xea0 fs/bcachefs/journal_io.c:1631
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Second to last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 insert_work+0x3e/0x330 kernel/workqueue.c:2182
 __queue_work+0xc16/0xee0 kernel/workqueue.c:2334
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2385
 queue_work include/linux/workqueue.h:621 [inline]
 bch2_dev_do_discards+0x189/0x200 fs/bcachefs/alloc_background.c:1884
 bch2_do_discards+0x29/0x60 fs/bcachefs/alloc_background.c:1895
 journal_write_done+0x785/0xea0 fs/bcachefs/journal_io.c:1631
 process_one_work kernel/workqueue.c:3224 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3305
 worker_thread+0x86d/0xd40 kernel/workqueue.c:3383
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff888041f60000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 176 bytes inside of
 freed 4096-byte region [ffff888041f60000, ffff888041f61000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x41f60
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xfdffffff(slab)
raw: 00fff00000000040 ffff888015042140 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000040004 00000001fdffffff 0000000000000000
head: 00fff00000000040 ffff888015042140 0000000000000000 dead000000000001
head: 0000000000000000 0000000000040004 00000001fdffffff 0000000000000000
head: 00fff00000000003 ffffea000107d801 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 5767, tgid 5767 (dhcpcd), ts 127655970402, free_ts 127602728804
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1493
 prep_new_page mm/page_alloc.c:1501 [inline]
 get_page_from_freelist+0x2ccb/0x2d80 mm/page_alloc.c:3480
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4738
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2300
 allocate_slab+0x5a/0x2f0 mm/slub.c:2463
 new_slab mm/slub.c:2516 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3702
 __slab_alloc+0x58/0xa0 mm/slub.c:3792
 __slab_alloc_node mm/slub.c:3845 [inline]
 slab_alloc_node mm/slub.c:4025 [inline]
 __do_kmalloc_node mm/slub.c:4157 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4170
 kmalloc_noprof include/linux/slab.h:684 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_realpath_nofollow+0xba/0x100 security/tomoyo/realpath.c:304
 tomoyo_find_next_domain+0x272/0x1cf0 security/tomoyo/domain.c:727
 tomoyo_bprm_check_security+0x115/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x65/0x90 security/security.c:1194
 search_binary_handler fs/exec.c:1787 [inline]
 exec_binprm fs/exec.c:1841 [inline]
 bprm_execve+0xa56/0x1770 fs/exec.c:1892
 do_execveat_common+0x553/0x700 fs/exec.c:1999
 do_execve fs/exec.c:2073 [inline]
 __do_sys_execve fs/exec.c:2149 [inline]
 __se_sys_execve fs/exec.c:2144 [inline]
 __x64_sys_execve+0x92/0xb0 fs/exec.c:2144
page last free pid 5763 tgid 5763 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1094 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2644
 __slab_free+0x31b/0x3d0 mm/slub.c:4384
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3975 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 __do_kmalloc_node mm/slub.c:4157 [inline]
 __kmalloc_noprof+0x1a6/0x400 mm/slub.c:4170
 kmalloc_noprof include/linux/slab.h:684 [inline]
 kzalloc_noprof include/linux/slab.h:806 [inline]
 lsm_task_alloc security/security.c:694 [inline]
 security_task_alloc+0x43/0x130 security/security.c:3041
 copy_process+0x1692/0x3d90 kernel/fork.c:2358
 kernel_clone+0x226/0x8f0 kernel/fork.c:2788
 __do_sys_clone3 kernel/fork.c:3089 [inline]
 __se_sys_clone3+0x2cb/0x350 kernel/fork.c:3073
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888041f5ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888041f60000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888041f60080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888041f60100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888041f60180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
