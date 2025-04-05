Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3A4189B84
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Apr 2025 10:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743849151; cv=none; b=eZ+qUfA7HECpuDLMmoXXkOH4zXPkdajikoPGe7FDqlMUA93h9ko9HZwar3vTB8WQvpteq8Kp8GwssTWJBFZrE02MvAz809F4/kQpmh6i6e4AYSd8ydwv7oJoBrceDCPOK4nA4J2yNN8GTWZSsMbatq5k/fkQWKUVOFIEn9VSgSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743849151; c=relaxed/simple;
	bh=3cp0SH55YiReXnJ8UsxAtPrCjubgnDRfbg45lvWTmA8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Y3eAVAh5cGgJLoT6JCyhCeWI3HocNnPtu/+mrCXO3Wl0xm+Wb4Qk+uHUC7aEvT1pY/c+fALTK9WUkgHJZ2mE+MMf3yoxB4pjhTGyd33DrH7Oqhgtwa2EpqPNbiYRftuA7vEWz44/zArYlIqEs1gkj3KLE/BYjPd2YcrZ1zR05G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-85c552b10b9so340380139f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Apr 2025 03:32:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743849149; x=1744453949;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CALj1vUlZ1NSx9LpykhmLtRFtU3x4ub3pHEdhE9SlmI=;
        b=r2dhpGkSK0ZO/NLnIfpyGLlEAZPm3IiT+zX2aSLFzBmmqgQinzLvVq/nRdfku97Msy
         lxApe3WmKStRUqS+hP+For2AP5+A2YMdZmj4squI4iMXYoKk3TTyn7n+OfjHV+jj76KU
         3kmc8YxANq0ohD8+SgKISOEwgpJ+qlFZL5vPOtdIceNBsqySiOvkQs5IHtXlLNY06DQJ
         XFeOzxoRcKqKe3u6EXjHkEmlAZM6uaIcfFgy7/wn3yYlzZHKj8s8OpmHgyQYOwqUxQom
         CH/AJO4z9t2mAWWfUAYobDS+VCnC70vNNBs3kWa8fRFWfaoG3+1B7FKA9V+qwHeX0NdW
         2LxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOW0+RZGCTzp2mXbFUdUIDPjCUgRw3cLYJIBvYB3nS7Ou46v13YL0vQdHeCPwz/moFmJCNYAtxCCTg9ssjxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjog5XuV58z1pjUmL3INuH93TN37WOOJZ1Jd2+AdbSj9Usc2ug
	qVNpevN7fchMcGZapk5cqSt+rYwRiV8/9mtlTXOrr8NxjDdliJC5Mqjd1agE+Xd8mYZtAX1+97a
	uzmV3AfPnh73cEwrsGLDF9tIfU9GhAmrqGrvXDDtLcWhl9jCE3Hgxu40=
X-Google-Smtp-Source: AGHT+IGOwU4ZLqFJFlzTs6oLQX3KjQuj17dfXOwXdZ68t6qzRUJdFgydDTcmdgXFwiWPoJ6QriMffRyPs5Qh5bNK8NouugP4Hi/z
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3088:b0:3d3:f9e0:709b with SMTP id
 e9e14a558f8ab-3d6e576d541mr57143835ab.17.1743849149168; Sat, 05 Apr 2025
 03:32:29 -0700 (PDT)
Date: Sat, 05 Apr 2025 03:32:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f106bd.050a0220.0a13.0235.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bchfs_read
From: syzbot <syzbot+2deb10b8dc9aae6fab67@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    acc4d5ff0b61 Merge tag 'net-6.15-rc0' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15425274580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dd3eb8e9a9c75c9
dashboard link: https://syzkaller.appspot.com/bug?extid=2deb10b8dc9aae6fab67
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=177d894c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127d4fb0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ee88ff7b5f77/disk-acc4d5ff.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ad1210e493cd/vmlinux-acc4d5ff.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1f3cc7813b7a/bzImage-acc4d5ff.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7f634c35cdf6/mount_0.gz

The issue was bisected to:

commit 3ba0240a8789f8c059990b81c6f34c29769a5a49
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Mar 24 15:51:01 2025 +0000

    bcachefs: Fix silent short reads in data read retry path

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1215494c580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1115494c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1615494c580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2deb10b8dc9aae6fab67@syzkaller.appspotmail.com
Fixes: 3ba0240a8789 ("bcachefs: Fix silent short reads in data read retry path")

==================================================================
BUG: KASAN: slab-use-after-free in bchfs_read+0x2b48/0x3350 fs/bcachefs/fs-io-buffered.c:228
Read of size 4 at addr ffff8880756ac148 by task syz-executor406/5854

CPU: 0 UID: 0 PID: 5854 Comm: syz-executor406 Not tainted 6.14.0-syzkaller-12456-gacc4d5ff0b61 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 bchfs_read+0x2b48/0x3350 fs/bcachefs/fs-io-buffered.c:228
 bch2_readahead+0xe7a/0x12d0 fs/bcachefs/fs-io-buffered.c:301
 read_pages+0x193/0x590 mm/readahead.c:160
 page_cache_ra_order+0xa37/0xca0 mm/readahead.c:515
 filemap_get_pages+0x59f/0x1fc0 mm/filemap.c:2590
 filemap_read+0x466/0x1260 mm/filemap.c:2701
 bch2_read_iter+0x1179/0x14b0 fs/bcachefs/fs-io-direct.c:221
 new_sync_read fs/read_write.c:489 [inline]
 vfs_read+0x9a0/0xb90 fs/read_write.c:570
 ksys_read+0x19d/0x2d0 fs/read_write.c:713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc1adbabc59
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 01 1b 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd419910a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 00007ffd419910d0 RCX: 00007fc1adbabc59
RDX: 0000000000002020 RSI: 0000200000000800 RDI: 0000000000000004
RBP: 0000000000000001 R08: 00007ffd41990e47 R09: 00007ffd419910f0
R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffd419910cc
R13: 0000000000000002 R14: 431bde82d7b634db R15: 00007ffd41991110
 </TASK>

Allocated by task 5854:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_mempool_unpoison_object+0x9e/0x170 mm/kasan/common.c:547
 kasan_unpoison_element mm/mempool.c:-1 [inline]
 remove_element+0x129/0x1a0 mm/mempool.c:150
 mempool_alloc_noprof+0x552/0x5a0 mm/mempool.c:408
 bio_alloc_bioset+0x26f/0x1130 block/bio.c:554
 bch2_readahead+0xbaf/0x12d0 fs/bcachefs/fs-io-buffered.c:290
 read_pages+0x193/0x590 mm/readahead.c:160
 page_cache_ra_order+0xa37/0xca0 mm/readahead.c:515
 filemap_get_pages+0x59f/0x1fc0 mm/filemap.c:2590
 filemap_read+0x466/0x1260 mm/filemap.c:2701
 bch2_read_iter+0x1179/0x14b0 fs/bcachefs/fs-io-direct.c:221
 new_sync_read fs/read_write.c:489 [inline]
 vfs_read+0x9a0/0xb90 fs/read_write.c:570
 ksys_read+0x19d/0x2d0 fs/read_write.c:713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5854:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_mempool_poison_object+0xaa/0x120 mm/kasan/common.c:522
 kasan_mempool_poison_object include/linux/kasan.h:360 [inline]
 kasan_poison_element mm/mempool.c:118 [inline]
 add_element mm/mempool.c:141 [inline]
 mempool_free+0x1c8/0x390 mm/mempool.c:541
 bch2_readpages_end_io+0x17c/0x1d0 fs/bcachefs/fs-io-buffered.c:36
 bch2_rbio_done fs/bcachefs/io_read.c:430 [inline]
 __bch2_read_extent+0x1348/0x4400 fs/bcachefs/io_read.c:1257
 bch2_read_extent fs/bcachefs/io_read.h:140 [inline]
 bchfs_read+0x251a/0x3350 fs/bcachefs/fs-io-buffered.c:226
 bch2_readahead+0xe7a/0x12d0 fs/bcachefs/fs-io-buffered.c:301
 read_pages+0x193/0x590 mm/readahead.c:160
 page_cache_ra_order+0xa37/0xca0 mm/readahead.c:515
 filemap_get_pages+0x59f/0x1fc0 mm/filemap.c:2590
 filemap_read+0x466/0x1260 mm/filemap.c:2701
 bch2_read_iter+0x1179/0x14b0 fs/bcachefs/fs-io-direct.c:221
 new_sync_read fs/read_write.c:489 [inline]
 vfs_read+0x9a0/0xb90 fs/read_write.c:570
 ksys_read+0x19d/0x2d0 fs/read_write.c:713
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880756ac000
 which belongs to the cache bio-488 of size 488
The buggy address is located 328 bytes inside of
 freed 488-byte region [ffff8880756ac000, ffff8880756ac1e8)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x756ac
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff888033497a00 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff888033497a00 dead000000000122 0000000000000000
head: 0000000000000000 00000000800c000c 00000000f5000000 0000000000000000
head: 00fff00000000001 ffffea0001d5ab01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5854, tgid 5854 (syz-executor406), ts 92613750343, free_ts 91077243774
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1717
 prep_new_page mm/page_alloc.c:1725 [inline]
 get_page_from_freelist+0x351d/0x36b0 mm/page_alloc.c:3652
 __alloc_frozen_pages_noprof+0x211/0x5b0 mm/page_alloc.c:4934
 alloc_pages_mpol+0x339/0x690 mm/mempolicy.c:2301
 alloc_slab_page mm/slub.c:2459 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2623
 new_slab mm/slub.c:2676 [inline]
 ___slab_alloc+0xc3b/0x1500 mm/slub.c:3862
 __slab_alloc+0x58/0xa0 mm/slub.c:3952
 __slab_alloc_node mm/slub.c:4027 [inline]
 slab_alloc_node mm/slub.c:4188 [inline]
 kmem_cache_alloc_noprof+0x270/0x390 mm/slub.c:4207
 mempool_init_node+0x1ee/0x4e0 mm/mempool.c:217
 mempool_init_noprof+0x3a/0x50 mm/mempool.c:246
 bioset_init+0x2ea/0x820 block/bio.c:1709
 bch2_fs_io_read_init+0x29/0xc0 fs/bcachefs/io_read.c:1377
 bch2_fs_alloc fs/bcachefs/super.c:944 [inline]
 bch2_fs_open+0x2f2f/0x32a0 fs/bcachefs/super.c:2182
 bch2_fs_get_tree+0x77b/0x18f0 fs/bcachefs/fs.c:2172
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2cf/0xb70 fs/namespace.c:3878
page last free pid 5830 tgid 5830 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_pages_ok+0xb17/0xd90 mm/page_alloc.c:1437
 __folio_put+0x2b5/0x360 mm/swap.c:112
 folio_put include/linux/mm.h:1563 [inline]
 free_large_kmalloc+0x143/0x1e0 mm/slub.c:4771
 kfree+0x216/0x430 mm/slub.c:4839
 bch2_dev_journal_exit+0x2ba/0x4a0 fs/bcachefs/journal.c:1478
 bch2_dev_free+0x14d/0x230 fs/bcachefs/super.c:1220
 bch2_fs_free+0x27b/0x3c0 fs/bcachefs/super.c:679
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x422/0x4c0 fs/namespace.c:1435
 task_work_run+0x251/0x310 kernel/task_work.c:227
 ptrace_notify+0x2dc/0x390 kernel/signal.c:2522
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc7/0x1d0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x24a/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880756ac000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880756ac080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff8880756ac100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                              ^
 ffff8880756ac180: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff8880756ac200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
