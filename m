Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F13B1C84C5
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 19:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739563169; cv=none; b=gRr8pu/h6aJy9MgkbzdiaKAZ2JjcUSemvsmy2bj+4U4TBkGrLq8nVPoKjGSg4TaN3bAYC8mGaplSxvDiuQFRb0kZEC51tAAj9Ku428XaQz+1ncmYNUlwuT/Hsz+kaS+Gw2gS2lnN2UW95YxNaYDoC5ua/j6xxafU5nnBzcubXfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739563169; c=relaxed/simple;
	bh=luydB5R2JMK3L8K616iIdbpVKV5tBsREZ3GUW1UwaXQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nD37gun3gffVLH2iSe2tEArvntekPkbrIYOMI9RbvElo2xn8Cbcn9D+ADj7KYbZRW6KqM6F4FsRCxRSy3LJZp+URSyk9HZj42N9aba5o7ursRigtmW5n+luizxrP/g46BVm2soXLEofBmnkmi2R2Jedf6tDUd6FXWTyAtF6Vf/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d13fb2256fso18162385ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 11:59:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739563167; x=1740167967;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KDuOjrRUrb0U1jcqyVueLA+YxDCkAKQwCHQkO72+FCI=;
        b=rlOEhZd2/Wz1npCcX3woINKudMlpAgaDq6VE80PlS3Ne4mwBS5KoIhld1oHJaBmMPR
         I+UZnKvEyAgXdqbmM1rRtr0B1UTPhj7sQTfthVw0sg4xFZE8WMefM92yJhZZqWqYhiRT
         hmNDB7A7M94MiJja87SdOX0Eqi6acIx1djnDunmm6/VKhB53KjM6U/s4Z77ZtMtwqWxF
         mgPx/niuEu5EmRaKyfjbhOJMEPspYuifBGHvSgBSfWnDZ1klkGmf3hI1dt3Ggao1Rb4K
         FM9X/FIsERWOoSOSrqPw++TgKeOypBJ/VSH2f5ivxotUWdwwO+08GWtCi/glKT26Jw0u
         o2tA==
X-Forwarded-Encrypted: i=1; AJvYcCWC8qbK3ieq15+5q953UJNBms392C4k4UmgxuMp9Tly60Mc/U651+IWj4C+1oVCO3/x70eX5cBpPEwYw1jiyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHmTDY9XMeeqUjirlkx38zeQT+AJPgpez/VKTSnNWVhl90UF6W
	QGUklGNnTjwJg7H9N9SppnjkktljJUMbq91L+JZ07XKZBqZD40j2i0OjLTpCfrr7nMQAJmaF/8V
	b9x9OB7gP3l/v0+5Oell59Mf6z9AZPv1CsMjxZQ3nGHahxw8eGqiciGU=
X-Google-Smtp-Source: AGHT+IGG3lKBu/c5iNjFr7CQYPql+sKaNdxY1YeAGzwFOlzeBE5B0+K2PeKlPHLTGCWJKixlExD8nPjoWX6W9EfrDqWIGqf0E4SF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca05:0:b0:3cf:f844:68eb with SMTP id
 e9e14a558f8ab-3d2807b1b42mr5697835ab.4.1739563167393; Fri, 14 Feb 2025
 11:59:27 -0800 (PST)
Date: Fri, 14 Feb 2025 11:59:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67afa09f.050a0220.21dd3.0053.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] KASAN: slab-out-of-bounds Read in folio_try_get
From: syzbot <syzbot+2110ef46097c323451eb@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ab68d7eb7b1a Merge tag 'loongarch-fixes-6.14-1' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10550f18580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3c2347dd6174fbe2
dashboard link: https://syzkaller.appspot.com/bug?extid=2110ef46097c323451eb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14550f18580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170061a4580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-ab68d7eb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c21c98f96a97/vmlinux-ab68d7eb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d84966ad5d14/bzImage-ab68d7eb.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/156e52e4f0ef/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2110ef46097c323451eb@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-out-of-bounds in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
BUG: KASAN: slab-out-of-bounds in page_ref_count include/linux/page_ref.h:67 [inline]
BUG: KASAN: slab-out-of-bounds in page_ref_add_unless include/linux/page_ref.h:237 [inline]
BUG: KASAN: slab-out-of-bounds in folio_ref_add_unless include/linux/page_ref.h:248 [inline]
BUG: KASAN: slab-out-of-bounds in folio_try_get+0xde/0x350 include/linux/page_ref.h:264
Read of size 4 at addr ffff88804f904b34 by task syz-executor127/5388

CPU: 0 UID: 0 PID: 5388 Comm: syz-executor127 Not tainted 6.14.0-rc2-syzkaller-00056-gab68d7eb7b1a #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
 page_ref_count include/linux/page_ref.h:67 [inline]
 page_ref_add_unless include/linux/page_ref.h:237 [inline]
 folio_ref_add_unless include/linux/page_ref.h:248 [inline]
 folio_try_get+0xde/0x350 include/linux/page_ref.h:264
 filemap_get_entry+0x240/0x3b0 mm/filemap.c:1870
 shmem_get_folio_gfp+0x285/0x1840 mm/shmem.c:2446
 shmem_get_folio mm/shmem.c:2628 [inline]
 shmem_write_begin+0x165/0x350 mm/shmem.c:3278
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb60d00ef1f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 19 81 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 6c 81 02 00 48
RSP: 002b:00007fb60c7b9fb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fb60c7b9ff0 RCX: 00007fb60d00ef1f
RDX: 0000000001000000 RSI: 00007fb604200000 RDI: 0000000000000003
RBP: 00007fb60d0976e0 R08: 0000000000000000 R09: 000000000000590c
R10: 0000000000000002 R11: 0000000000000293 R12: 00007fb60d0976ec
R13: 00007fb60c7ba030 R14: 0000000000000003 R15: 00007ffe9f1d73d8
 </TASK>

The buggy address belongs to the object at ffff88804f904b00
 which belongs to the cache radix_tree_node of size 576
The buggy address is located 52 bytes inside of
 allocated 576-byte region [ffff88804f904b00, ffff88804f904d40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4f904
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88804054b581
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801ac4fdc0 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800b000b 00000000f5000000 ffff88804054b581
head: 04fff00000000040 ffff88801ac4fdc0 dead000000000122 0000000000000000
head: 0000000000000000 00000000800b000b 00000000f5000000 ffff88804054b581
head: 04fff00000000001 ffffea00013e4101 ffffffffffffffff 0000000000000000
head: 0000000000000002 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Reclaimable, gfp_mask 0x52810(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_RECLAIMABLE), pid 5382, tgid 5381 (syz-executor127), ts 127092553802, free_ts 126870415360
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4739
 alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:2423 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2587
 new_slab mm/slub.c:2640 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3826
 __slab_alloc+0x58/0xa0 mm/slub.c:3916
 __slab_alloc_node mm/slub.c:3991 [inline]
 slab_alloc_node mm/slub.c:4152 [inline]
 kmem_cache_alloc_lru_noprof+0x26c/0x390 mm/slub.c:4183
 xas_alloc lib/xarray.c:377 [inline]
 xas_create+0x10d0/0x1ae0 lib/xarray.c:684
 xas_store+0x96/0x1870 lib/xarray.c:794
 shmem_add_to_page_cache+0x89d/0xcc0 mm/shmem.c:897
 shmem_alloc_and_add_folio+0x968/0x1090 mm/shmem.c:1928
 shmem_get_folio_gfp+0x621/0x1840 mm/shmem.c:2522
 shmem_get_folio mm/shmem.c:2628 [inline]
 shmem_write_begin+0x165/0x350 mm/shmem.c:3278
 generic_perform_write+0x346/0x990 mm/filemap.c:4189
 shmem_file_write_iter+0xf9/0x120 mm/shmem.c:3454
page last free pid 5392 tgid 5392 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0xbbf/0xe40 mm/page_alloc.c:1271
 __folio_put+0x2b3/0x360 mm/swap.c:112
 folio_put include/linux/mm.h:1489 [inline]
 free_large_kmalloc+0xfe/0x180 mm/slub.c:4728
 kfree+0x212/0x430 mm/slub.c:4751
 btree_bounce_free fs/bcachefs/btree_io.c:111 [inline]
 bch2_btree_node_read_done+0x3b1f/0x5f70 fs/bcachefs/btree_io.c:1243
 btree_node_read_work+0x6dc/0x1380 fs/bcachefs/btree_io.c:1358
 bch2_btree_node_read+0x2433/0x29f0
 bch2_btree_node_fill+0xca6/0x1370 fs/bcachefs/btree_cache.c:993
 bch2_btree_node_get_noiter+0x9d5/0xf70 fs/bcachefs/btree_cache.c:1260
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:84 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:213 [inline]
 read_btree_nodes_worker+0x1355/0x21f0 fs/bcachefs/btree_node_scan.c:262
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff88804f904a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88804f904a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88804f904b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                     ^
 ffff88804f904b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88804f904c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

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
