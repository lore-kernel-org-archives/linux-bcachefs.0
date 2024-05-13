Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D29153BE6
	for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715615078; cv=none; b=ZmxIwv/wYfgDAe2SmrNXAmKi5wkEjk41KR0MD5fML3jZ0WfppqCES9kxpTpHY+3yeqRO0fDMcdy4XF0+EoNqdsMazPfs69LnXri2NAy0d7q+08DasdsTJmkEONj61crCqDA6G0/KXmSWfGT/I1FJlZBS33BEAjIcBCKdEvCdHKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715615078; c=relaxed/simple;
	bh=oN7MiawutG+tZggdKrfi4N1qCXAosAyMjr/Gecqlkus=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=EP0cM5I5lI/BqJAyl3t9Y/YWyrbyYEh94eIuY1TVwwQMOkv06697kGUxsT4wkkzTDxnCSxdhFirwC/hZSnPMTSf6M/ZFhho4wyWptS7s9Tit6Ogyjyyl3uf9IuSVe4/4gjuFfzZfoM8jY3FbBLNzqW9S0l+10urCYECIjXLH/Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7da7d4ccb67so540616139f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 13 May 2024 08:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715615076; x=1716219876;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qH88/LeYj5rknwBoEorXZk9LfonpI3muGMGrSqroB90=;
        b=moxlJJgCYiiJkaZXgbPFbyV2tev4WmofnN8yuxm0NlDzDf0+0280/y8qfvc9iEEzsj
         KXLPfgcSNsNmITmjzTCGgBTM+BuIPFzZlDk/+AwnLSRUiyrgt2QHbJjC34wgFoJbSI68
         H72C+TkbuLKDvqSLa+XBHYHbURw8Sr5kQGUI1rx1C78/wH86Jqa2yqGbWEkCRkA8Feak
         exijTARVDtkGZyaAU7KzgfDuIB4EMHg2Q9rNHMN6sg8C3GLmDPen0fZXP+BI5e0EGiZw
         uXcMfKqfRZ5G8z3Em9Qiw5QBJgH9k8LEghnlpuOk3zjLhN4N08LYBMIwTdFQkvb/4hSm
         8kYw==
X-Forwarded-Encrypted: i=1; AJvYcCX25vjhqnAZ3sUe+GjKq7Auy30IvzuwDZ6WoJlpAfnSI7B8vWFEEgoHKZoCaHvBfspNDwKAmBBD9EFB9c969Hcpm1Vt/mWn5GZAQWo9Kpg=
X-Gm-Message-State: AOJu0YzqRRIlMEZm67Jnn1kitzx5KQ+orQ9LVpHTEPtd5fn5eccNcIoa
	V/gXRkfGrBh9EWV6yy1bg47liw4OuNcHGxgE7rhD9p6bcxe7IRX5xIt5wvIbiG7KDoabhlBqmdX
	RAs9LxWoYHnJ8ZCBJtWAlpANDzlwE84nf05UlRff5gGqPKNRN54U4X+s=
X-Google-Smtp-Source: AGHT+IH78Wr5497hpciecnJMG+jB/pG0aBCThkmbFNJMvkBpvi3SlAX4SiX9IcaA8sYbxrSfGQwBxiKAoGa1Jr4PaGlS2EGVYeRl
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:482:b0:7de:e506:e54a with SMTP id
 ca18e2360f4ac-7e1b520d32dmr51582039f.3.1715615076148; Mon, 13 May 2024
 08:44:36 -0700 (PDT)
Date: Mon, 13 May 2024 08:44:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002f75db061857c3db@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in evict_inodes
From: syzbot <syzbot+a0ddc9873c280a4cb18f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    45db3ab70092 Merge tag '6.9-rc7-ksmbd-fixes' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10a6583f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=a0ddc9873c280a4cb18f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134a63bc980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151501b8980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c89213fc1e8d/disk-45db3ab7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b52e3a7a65ea/vmlinux-45db3ab7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a871fa10f977/bzImage-45db3ab7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/1b9088f19946/mount_0.gz

The issue was bisected to:

commit 0e42f381193d7f9b47922f1c4308e7729a45ba13
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Apr 21 02:26:47 2024 +0000

    bcachefs: Fix inode early destruction path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16cdf3bc980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15cdf3bc980000
console output: https://syzkaller.appspot.com/x/log.txt?x=11cdf3bc980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a0ddc9873c280a4cb18f@syzkaller.appspotmail.com
Fixes: 0e42f381193d ("bcachefs: Fix inode early destruction path")

==================================================================
BUG: KASAN: slab-use-after-free in evict_inodes+0x111/0x690
Read of size 8 at addr ffff888075cc70e0 by task syz-executor647/5099

CPU: 0 PID: 5099 Comm: syz-executor647 Not tainted 6.9.0-rc7-syzkaller-00056-g45db3ab70092 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 evict_inodes+0x111/0x690
 generic_shutdown_super+0x9d/0x2d0 fs/super.c:626
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2012
 deactivate_locked_super+0xc4/0x130 fs/super.c:472
 cleanup_mnt+0x426/0x4c0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x102/0x240 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9d14a95cb7
Code: 09 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b0 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffd534829a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f9d14a95cb7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffd53482a60
RBP: 00007ffd53482a60 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007ffd53483b20
R13: 0000555567b26700 R14: 431bde82d7b634db R15: 00007ffd53483ac4
 </TASK>

Allocated by task 8194:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3804 [inline]
 slab_alloc_node mm/slub.c:3851 [inline]
 kmem_cache_alloc+0x174/0x350 mm/slub.c:3858
 bch2_alloc_inode+0x1f/0x130 fs/bcachefs/fs.c:1494
 alloc_inode fs/inode.c:261 [inline]
 new_inode_pseudo+0x69/0x1e0 fs/inode.c:1007
 new_inode+0x22/0x1d0 fs/inode.c:1033
 bch2_new_inode+0xa7/0x1a0 fs/bcachefs/fs.c:224
 bch2_lookup_trans fs/bcachefs/fs.c:408 [inline]
 bch2_lookup+0xc44/0x1330 fs/bcachefs/fs.c:437
 lookup_open fs/namei.c:3475 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x1033/0x3240 fs/namei.c:3796
 do_filp_open+0x235/0x490 fs/namei.c:3826
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1432
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 8194:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xa6/0xe0 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2111 [inline]
 slab_free mm/slub.c:4286 [inline]
 kmem_cache_free+0x10b/0x2d0 mm/slub.c:4350
 bch2_inode_insert+0x339/0x3a0 fs/bcachefs/fs.c:192
 bch2_lookup_trans fs/bcachefs/fs.c:420 [inline]
 bch2_lookup+0xdf0/0x1330 fs/bcachefs/fs.c:437
 lookup_open fs/namei.c:3475 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x1033/0x3240 fs/namei.c:3796
 do_filp_open+0x235/0x490 fs/namei.c:3826
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1432
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888075cc6f18
 which belongs to the cache bch_inode_info of size 1768
The buggy address is located 456 bytes inside of
 freed 1768-byte region [ffff888075cc6f18, ffff888075cc7600)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888075cc0768 pfn:0x75cc0
head: order:3 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000840(slab|head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 00fff00000000840 ffff88801af46c80 ffffea0001da0c00 0000000000000002
raw: ffff888075cc0768 0000000080110010 00000001ffffffff 0000000000000000
head: 00fff00000000840 ffff88801af46c80 ffffea0001da0c00 0000000000000002
head: ffff888075cc0768 0000000080110010 00000001ffffffff 0000000000000000
head: 00fff00000000003 ffffea0001d73001 dead000000000122 00000000ffffffff
head: 0000000800000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd2050(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_RECLAIMABLE), pid 5468, tgid -1659749701 (syz-executor647), ts 5469, free_ts 597295756743
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1ea/0x210 mm/page_alloc.c:1534
 prep_new_page mm/page_alloc.c:1541 [inline]
 get_page_from_freelist+0x3410/0x35b0 mm/page_alloc.c:3317
 __alloc_pages+0x256/0x6c0 mm/page_alloc.c:4575
 __alloc_pages_node include/linux/gfp.h:238 [inline]
 alloc_pages_node include/linux/gfp.h:261 [inline]
 alloc_slab_page+0x5f/0x160 mm/slub.c:2180
 allocate_slab mm/slub.c:2343 [inline]
 new_slab+0x84/0x2f0 mm/slub.c:2396
 ___slab_alloc+0xc73/0x1260 mm/slub.c:3530
 __slab_alloc mm/slub.c:3615 [inline]
 __slab_alloc_node mm/slub.c:3668 [inline]
 slab_alloc_node mm/slub.c:3841 [inline]
 kmem_cache_alloc+0x252/0x350 mm/slub.c:3858
 bch2_alloc_inode+0x1f/0x130 fs/bcachefs/fs.c:1494
 alloc_inode fs/inode.c:261 [inline]
 new_inode_pseudo+0x69/0x1e0 fs/inode.c:1007
 new_inode+0x22/0x1d0 fs/inode.c:1033
 bch2_new_inode+0xa7/0x1a0 fs/bcachefs/fs.c:224
 bch2_lookup_trans fs/bcachefs/fs.c:408 [inline]
 bch2_lookup+0xc44/0x1330 fs/bcachefs/fs.c:437
 lookup_open fs/namei.c:3475 [inline]
 open_last_lookups fs/namei.c:3566 [inline]
 path_openat+0x1033/0x3240 fs/namei.c:3796
 do_filp_open+0x235/0x490 fs/namei.c:3826
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1406
 do_sys_open fs/open.c:1421 [inline]
 __do_sys_openat fs/open.c:1437 [inline]
 __se_sys_openat fs/open.c:1432 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1432
page last free pid 5099 tgid 5099 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1141 [inline]
 free_unref_page_prepare+0x97b/0xaa0 mm/page_alloc.c:2347
 free_unref_page+0x37/0x3f0 mm/page_alloc.c:2487
 vfree+0x186/0x2e0 mm/vmalloc.c:3340
 bch2_fs_btree_write_buffer_exit+0x140/0x1b0 fs/bcachefs/btree_write_buffer.c:652
 __bch2_fs_free fs/bcachefs/super.c:573 [inline]
 bch2_fs_release+0x2c7/0x5a0 fs/bcachefs/super.c:610
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 deactivate_locked_super+0xc4/0x130 fs/super.c:472
 cleanup_mnt+0x426/0x4c0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x370 kernel/entry/common.c:218
 do_syscall_64+0x102/0x240 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888075cc6f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075cc7000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888075cc7080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                       ^
 ffff888075cc7100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075cc7180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


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
