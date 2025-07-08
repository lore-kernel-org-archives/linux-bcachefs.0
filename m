Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5029B2DEA86
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Jul 2025 14:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751983468; cv=none; b=lcvvm+wNqVL3nY6xLWQ73wzwu96wjvacxf755drE3PO9J9c6ZG4596CpiEYP69C2FuKYUBNy5ok0uYHe6MFgXNDorOS9hbiG9NnTDH88EqoyUf0HzYhkb+D4t1bjH3NR+/T/U5EBWExZCseyZabB8nEYKNEcrbm/ATTtGeO18lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751983468; c=relaxed/simple;
	bh=1ui1pnb0YfuDpvSRr7ex1Bs1oDL2sPMZAnSKQuzOAdM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dpRl2D1J7yysHiSNIJs8LhL29r+7EguMUm1wr37DC3FizkgswTzOMXVKMEpHiEq9CQEVxrfklbgfp//FKm9/121NM3xTSFMtzLP1Patva74xRk5uJjDoalfy6izMt8WOBjA0wmxhCiasQKP2t3sUhWlRkAuQql+YkNcjGoBNsCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3df2d0b7c7eso46033205ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Jul 2025 07:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751983465; x=1752588265;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tqUTJ9vjhsed4esUsaWpwmcG5kQc35wIkpaLVvg/j1s=;
        b=wDzKvAsLpcF/+lFpdW9eaHJu23casxYt1fBO1kIHvF3/qIVuSFdjyl3EPrL24tgVsk
         FeEJBkeEm8Sn+HcfXGE3L9aIpyGC4+uDYkdiyUswjsM7qyWAsV3wccxSE/FpElkn0c9p
         4NhWaqOODtCQycHknMJzP7wXBBxgD7dV8j7yb2NN2C/qwqmbIU+bsxUlHWbQlhX1l7/L
         LEzrZWQErT8DxVsDyfhr/2qCKXwLLLDxfy4XdBXjRcKAL9KDLftqnQEqA4kVlya5ztr0
         6LoTFuH9cLYL0SXQNRNQ3nnGV9dIzzOrPltoG7TINcmc8OgwmMPFGROJ7ccIKvTCtJDm
         3btQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGbSb6y1+EUEMlPkX2DvAS+kIBewU+9LxjS/D0Mc0UA1KK90coFBKAFBZsrRlmBVG2vCwH4OCx7B0606G0tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTfAJNNQcvczeL+SoY2zb9SWzWqlTLLVO8ExXFvH8E920aTVk0
	IDaYseIvYjqZvCAID3do9kV/Fycq6Dz+z8sySm9VkkuklCGtlYwrtedukqGX6lAtA4wrWOwVf6D
	B20P4W4p8PaztZcghWp+gw5figPlg2NNwWthB2MYdRwwnzjF46xChbj+0YpQ=
X-Google-Smtp-Source: AGHT+IH48zyS+Sz0llFPcImH5vmtB9+dqCDIHWO/gxsi7FXgF6aPKEVP6M7LFIAYmYulwVvSe9sAVuUQM8YFhnLRrutfY/Io/Zgb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3283:b0:3df:154d:aa60 with SMTP id
 e9e14a558f8ab-3e1372384bemr178086055ab.22.1751983465168; Tue, 08 Jul 2025
 07:04:25 -0700 (PDT)
Date: Tue, 08 Jul 2025 07:04:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686d2569.050a0220.1ffab7.000e.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_copygc
From: syzbot <syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4c06e63b9203 Merge tag 'for-6.16-rc4-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10487ebc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b29b1a0d7330d4a8
dashboard link: https://syzkaller.appspot.com/bug?extid=3168625f36f4a539237e
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-4c06e63b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ff61efc838cb/vmlinux-4c06e63b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dea44d0d14bb/bzImage-4c06e63b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3168625f36f4a539237e@syzkaller.appspotmail.com

bcachefs (loop0): Detected missing backpointers in bucket 34, now have 1/128 with missing
  running recovery pass check_extents_to_backpointers (17), currently at check_inodes (28)
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-use-after-free in bch2_bucket_bitmap_test fs/bcachefs/backpointers.h:194 [inline]
BUG: KASAN: slab-use-after-free in bch2_bucket_is_movable fs/bcachefs/movinggc.c:78 [inline]
BUG: KASAN: slab-use-after-free in bch2_copygc_get_buckets fs/bcachefs/movinggc.c:157 [inline]
BUG: KASAN: slab-use-after-free in bch2_copygc+0xfb1/0x4380 fs/bcachefs/movinggc.c:221
Read of size 8 at addr ffff888055be7920 by task bch-copygc/loop/5355

CPU: 0 UID: 0 PID: 5355 Comm: bch-copygc/loop Not tainted 6.16.0-rc4-syzkaller-00123-g4c06e63b9203 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 bch2_bucket_bitmap_test fs/bcachefs/backpointers.h:194 [inline]
 bch2_bucket_is_movable fs/bcachefs/movinggc.c:78 [inline]
 bch2_copygc_get_buckets fs/bcachefs/movinggc.c:157 [inline]
 bch2_copygc+0xfb1/0x4380 fs/bcachefs/movinggc.c:221
 bch2_copygc_thread+0x97a/0xe00 fs/bcachefs/movinggc.c:409
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5355:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kvmalloc_node_noprof+0x30d/0x5f0 mm/slub.c:5015
 kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
 bch2_bucket_bitmap_set+0x9a/0x1a0 fs/bcachefs/backpointers.c:1351
 check_bucket_backpointer_mismatch+0x1bdf/0x23a0 fs/bcachefs/backpointers.c:964
 check_bucket_backpointer_pos_mismatch fs/bcachefs/backpointers.c:1193 [inline]
 bch2_check_bucket_backpointer_mismatch+0x36c/0x690 fs/bcachefs/backpointers.c:1205
 __bch2_move_data_phys+0x17a7/0x1c50 fs/bcachefs/move.c:922
 bch2_evacuate_bucket+0x228/0x3a0 fs/bcachefs/move.c:1082
 bch2_copygc+0x3a89/0x4380 fs/bcachefs/movinggc.c:234
 bch2_copygc_thread+0x97a/0xe00 fs/bcachefs/movinggc.c:409
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888055be7920
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 0 bytes inside of
 freed 16-byte region [ffff888055be7920, ffff888055be7930)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x55be7
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801a441640 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080800080 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5319, tgid 5319 (kworker/u5:2), ts 78159391425, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2619
 new_slab mm/slub.c:2673 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
 __slab_alloc mm/slub.c:3949 [inline]
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_node_track_caller_noprof+0x2f8/0x4e0 mm/slub.c:4347
 __do_krealloc mm/slub.c:4905 [inline]
 krealloc_noprof+0x124/0x340 mm/slub.c:4958
 bch2_printbuf_make_room+0x1f5/0x360 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x282/0x740 fs/bcachefs/printbuf.c:186
 bch2_sb_validate+0xf73/0x1980 fs/bcachefs/super-io.c:514
 bch2_write_super+0xd68/0x2d30 fs/bcachefs/super-io.c:1089
 bch2_mark_replicas_slowpath+0x2e1/0x580 fs/bcachefs/replicas.c:338
 bch2_journal_write+0x49ab/0x5570 fs/bcachefs/journal_io.c:2208
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xade/0x17b0 kernel/workqueue.c:3321
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3402
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888055be7800: fa fb fc fc 00 00 fc fc 00 00 fc fc fa fb fc fc
 ffff888055be7880: fa fb fc fc 00 00 fc fc 00 00 fc fc fa fb fc fc
>ffff888055be7900: fa fb fc fc fb fb fc fc 00 00 fc fc fa fb fc fc
                               ^
 ffff888055be7980: fa fb fc fc fa fb fc fc fa fb fc fc 00 00 fc fc
 ffff888055be7a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
