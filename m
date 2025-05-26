Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400AC27454
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748257987; cv=none; b=ohr1sV6ehDqoNnXv4f2SCuXCGjfcd5OfvqNfkK+ryK/QDc2Mo0g+dDj/B8/vvLYLz0fvLPPfYaQSYid3sG7Ce/72/y9SB8RoSP/U9shteLM6bf8F5P1xFen8A7aIOS/ZeIIgi6Bl8efnaaTM8lms//NcDAG7Ddeh1HyVv6uwxcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748257987; c=relaxed/simple;
	bh=j936ZhGI7U0g7mslNsfCMJ7tqnpqgWMJ1PiUp+EWck4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Htou/k+78NmViFQbcHFDSfyPBWY23QvIPZDFE5tIxRo9tok2q6+WlbSwcF7L2p0QYe2WDgqH/bVthCffYqwRln5tWV652XJi5qyYlE4ibn6zXw1xhaBIa6e6h52eIi8YX1OBLPGEhgCYuGERaH/e58tXDZXGCDX5SS0olc3oBoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-85b3b781313so425560239f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 04:13:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748257985; x=1748862785;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gtBcCEwisggIr0b3FMXx4cQKPJB6mmq/WFbpMitOhDY=;
        b=W2rysO7fO+vd5KUOXOFKah1R5C6mRlthBluG3FjH1jVBO0vr5/71584qTjIjK2U5F3
         oJ99AVreBBNIY5asY0MOF/ZBPCHB8fCjgXQOI/jghNKeNjmpErPzIX5M9bVx7iJIqeMH
         ihd1pbU0uPj0NP2dbCuVCxZDY1JMnCBvyis5KHTYOQtjr9nu19gHYNEG3EDIT4eZ59IF
         Ft9X6tar8wHhNxye7QMeJpckPRkBlh3vdoE7iIadl93lmlyo634iR9vqQo1UxqnDkumD
         cXwRUDx2S1HU/A05K+owD9QfjY5BamWoEclJmdaM4EO2jymMwKXhHV6fAggy3oAptt5f
         TgDw==
X-Forwarded-Encrypted: i=1; AJvYcCV7Gwe8FdNjqy61vKbSlleKh9AaHBCfwELB2GBxbcPuKcphCIk6gtOdK7uY7w1Pibh4O3h6OYXVoTQvEyN36w==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywho5Btf/Bp0/yI8Mx0hVZ8FNNpWJDBpmReX3NvbwkLfJjUz32r
	RK4gQystrDe3BtA5Yp2saAz/5lMd/XqNndw7y/HAXzHcQ6YvXyJgWoutu8CbTpEx4sJPNjzl7Pn
	nF3uq8VXJ651RTEZbuY8IFOo8kaDzr12r+XFFYEA783ertpE/Vnu1VqM8DRg=
X-Google-Smtp-Source: AGHT+IGKcLqczNDdOsqLKf68n4y53v3Hio4vmQPQSXfwn7R/aF6926Md1Pd4Ov7reSedg2ro2CIKaIbZ+FOXWbaLT/VDEu6fIadV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3a02:b0:85c:96a5:dc2c with SMTP id
 ca18e2360f4ac-86cbb8bee7emr881726539f.14.1748257985367; Mon, 26 May 2025
 04:13:05 -0700 (PDT)
Date: Mon, 26 May 2025 04:13:05 -0700
In-Reply-To: <05DB907D-8EF0-4E16-A133-3E32A8F8FD1C@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68344cc1.a70a0220.253bc2.0096.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in rhashtable_init_noprof
From: syzbot <syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
KASAN: slab-use-after-free Read in rhashtable_free_and_destroy

==================================================================
BUG: KASAN: slab-use-after-free in rhashtable_free_and_destroy+0x7d7/0x940 lib/rhashtable.c:1172
Read of size 8 at addr ffff8880294ab830 by task bch-copygc/loop/7051

CPU: 0 UID: 0 PID: 7051 Comm: bch-copygc/loop Not tainted 6.15.0-rc4-syzkaller-00272-g9b38df1f0d77 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 rhashtable_free_and_destroy+0x7d7/0x940 lib/rhashtable.c:1172
 bch2_copygc_thread+0xc69/0xd40 fs/bcachefs/movinggc.c:427
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 7051:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4341 [inline]
 __kvmalloc_node_noprof+0x314/0x600 mm/slub.c:5026
 bucket_table_alloc lib/rhashtable.c:186 [inline]
 rhashtable_init_noprof+0x4ee/0xbb0 lib/rhashtable.c:1075
 bch2_copygc_thread+0xb7/0xd40 fs/bcachefs/movinggc.c:356
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 7048:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x62/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2398 [inline]
 slab_free mm/slub.c:4656 [inline]
 kfree+0x18e/0x440 mm/slub.c:4855
 rhashtable_free_and_destroy+0x7e8/0x940 lib/rhashtable.c:1173
 bch2_copygc_thread+0xc69/0xd40 fs/bcachefs/movinggc.c:427
 kthread+0x70e/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:153
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff8880294ab800
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 48 bytes inside of
 freed 1024-byte region [ffff8880294ab800, ffff8880294abc00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x294a8
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801a041dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801a041dc0 dead000000000122 0000000000000000
head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0000a52a01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6998, tgid 6996 (syz.4.25), ts 143611566388, free_ts 143543501461
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1718
 prep_new_page mm/page_alloc.c:1726 [inline]
 get_page_from_freelist+0x21ce/0x22b0 mm/page_alloc.c:3688
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4970
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2301
 alloc_slab_page mm/slub.c:2468 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2632
 new_slab mm/slub.c:2686 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3872
 __slab_alloc mm/slub.c:3962 [inline]
 __slab_alloc_node mm/slub.c:4037 [inline]
 slab_alloc_node mm/slub.c:4198 [inline]
 __do_kmalloc_node mm/slub.c:4340 [inline]
 __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4353
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 __alloc_workqueue+0x103/0x1b70 kernel/workqueue.c:5683
 alloc_workqueue+0xd4/0x210 kernel/workqueue.c:5786
 bch2_fs_journal_init+0x2dc/0x4d0 fs/bcachefs/journal.c:1648
 bch2_fs_init_rw fs/bcachefs/super.c:830 [inline]
 __bch2_fs_read_write+0x837/0x880 fs/bcachefs/super.c:500
 bch2_fs_read_write_early+0x26/0x40 fs/bcachefs/super.c:588
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:415 [inline]
 __bch2_run_recovery_passes+0x391/0x1110 fs/bcachefs/recovery_passes.c:470
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:541
 bch2_fs_recovery+0x2617/0x3970 fs/bcachefs/recovery.c:974
 bch2_fs_start+0xa43/0xd30 fs/bcachefs/super.c:1206
page last free pid 7040 tgid 7040 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_frozen_pages+0xc68/0xe50 mm/page_alloc.c:2725
 discard_slab mm/slub.c:2730 [inline]
 __put_partials+0x161/0x1c0 mm/slub.c:3199
 put_cpu_partial+0x17c/0x250 mm/slub.c:3274
 __slab_free+0x2f7/0x400 mm/slub.c:4526
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4161 [inline]
 slab_alloc_node mm/slub.c:4210 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4217
 vm_area_alloc+0x24/0x140 kernel/fork.c:441
 __mmap_new_vma mm/vma.c:2402 [inline]
 __mmap_region mm/vma.c:2519 [inline]
 mmap_region+0xcf4/0x1e50 mm/vma.c:2597
 do_mmap+0xc68/0x1100 mm/mmap.c:561
 vm_mmap_pgoff+0x31b/0x4c0 mm/util.c:579
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x220 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880294ab700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880294ab780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880294ab800: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff8880294ab880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff8880294ab900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


Tested on:

commit:         9b38df1f bcachefs: Don't allocate buckets_in_flight on..
git tree:       https://github.com/alanskind/bcachefs
console output: https://syzkaller.appspot.com/x/log.txt?x=17cdbad4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96ae50edd782e9ea
dashboard link: https://syzkaller.appspot.com/bug?extid=bcc38a9556d0324c2ec2
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Note: no patches were applied.
