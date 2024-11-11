Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D370155A34
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 09:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731318033; cv=none; b=jPA0DDstopLsbykpMdfIPHG/lAPpySMkAb84HsW9pHjeX1WSayNYOGJM7r1bI05AgnNOKX+rZA/xogkZwaorcxv4j+svfQ7vUA4/Wk+yXgo8TIvPjAwtVvVFflzFcgyWyg30v8JP+xiae1D+uYkvLxUvY/NvYoGpkpmuKNaw6og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731318033; c=relaxed/simple;
	bh=KOlJ9WJCh3jhuHJebLYTNg7jqqJHU7RhYv97Ey9axiY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tNLsnUpb4fJrSQIfNEa9UMLERCODI7dChPrDfM94nGitwy4xMTsMgmXOjCq2F5qWC6KMghNIRSUmrcZYcZ6gJfMXmBsX4YkLuBTX9n2CdP++r3CAPjeKhdJNtEYSbF0XxZqF9eIa4G0mL/QqcAGcX1a+6zeBIkkxeK4bI/IMVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a6bce8a678so51730805ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Nov 2024 01:40:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731318030; x=1731922830;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/FoJC5iFNcBfmj+dmGsDuQL9+g/HbmUXcG5czvTIyEI=;
        b=EFLxWbBZqaf7mYP6UZDVrnp4Hz/ZvE7IYssqLFG6ZJ9bgG97JI0n43wCWH3U604EUr
         a7RlRTMZLCo2pGjVIRlTmHZMGD61ejShTURuqxKBBF6M2sMj522l++cOluDLADYUMVDf
         ZSQD1Po8BerBI48UErkcNh8nPRRjWwW4lgDEibb8Ax3m4CC9dEkAKBKzV3l7PepvTPA/
         0B5nk1XkOLoVZT2GvPsWbPjRoThZZbNg65pCmwu8r89bvewGRsRb4CRrLdO3Y5SdAX1r
         2pmu6+oUJFbAQW8c28Oi+CzhqkvBSnkp/n3YduSQolDinTa863yXQMZ+Hxff5OcpnxRn
         q7Ug==
X-Forwarded-Encrypted: i=1; AJvYcCX+1xClg9PVv1WAFqpbSoREMB+bfyTOARUTe7IVPnbutUqV/xWkQKQY24d9UxsJ/7kzDedEyoNvnpgxLr3Ifg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFuwVVbgENvEFad7cPy0gW5B7KDGBrkmtkscBUf0T6vSB7btJh
	gm2+qXEXLA0G3vWyhQpsxvK07nreYi/BBuuFPu4vZIVriqt5jIWZ6X6QiH8XJrOvVpNqLIzronv
	3dDqHx9Ebg+k2Lau4/balhlTijY0LgYqBwNenSLPRtxYkzWLNyJY9W7w=
X-Google-Smtp-Source: AGHT+IFcRbakUmAl1i1MUjMmTCKvb/DUYxcuWbL6ZsH7wo8wwYgwopqbMezBKS9wstFUM/e2gKppTqJjN50eznc99UQUYWCvd9O+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca46:0:b0:3a6:b34f:c1de with SMTP id
 e9e14a558f8ab-3a6f19e85aamr118814915ab.14.1731318030539; Mon, 11 Nov 2024
 01:40:30 -0800 (PST)
Date: Mon, 11 Nov 2024 01:40:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6731d10e.050a0220.138bd5.0064.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in __bch2_write
From: syzbot <syzbot+29c5fc5ec8625c84dcdd@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b04ae0f45168 Merge tag 'v6.12-rc3-smb3-client-fixes' of gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17af5240580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbd94c114a3d407
dashboard link: https://syzkaller.appspot.com/bug?extid=29c5fc5ec8625c84dcdd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-b04ae0f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3e40a4ec7885/vmlinux-b04ae0f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9312d8ec05d3/bzImage-b04ae0f4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+29c5fc5ec8625c84dcdd@syzkaller.appspotmail.com

  bp_start          8
  invalid data type (got 3 should be 9): delete?, fixing
bcachefs (loop0): check_topology... done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
bucket 0:26 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ac62141f8dc7e261 written 24 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0, fixing
bucket 0:38 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
bucket 0:41 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bucket 0:35 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bucket 0:28 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 28f61e078e70b95c written 16 min_key POS_MIN durability: 1 ptr: 0:28:0 gen 0, fixing
bucket 0:29 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 32 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:1 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:1 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:2 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:2 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:3 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:3 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:4 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:4 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:5 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:5 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:6 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:6 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:7 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:7 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:8 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:8 gen 0 data type sb has wrong dirty_sectors: got 0, should be 8, fixing
bucket 0:9 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:9 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:10 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:10 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:11 gen 0 has wrong data_type: got free, should be journal, fixing
bcachefs (loop0): Ratelimiting new instances of previous error
bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bcachefs (loop0): Ratelimiting new instances of previous error
bucket 0:34 gen 0 data type user has wrong cached_sectors: got 65535, should be 0, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): done starting filesystem
==================================================================
BUG: KASAN: slab-use-after-free in __bch2_write+0x5e18/0x5e30 fs/bcachefs/io_write.c:1413
Read of size 2 at addr ffff88804c5f8ebc by task syz.0.0/5107

CPU: 0 UID: 0 PID: 5107 Comm: syz.0.0 Not tainted 6.12.0-rc3-syzkaller-00319-gb04ae0f45168 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 __bch2_write+0x5e18/0x5e30 fs/bcachefs/io_write.c:1413
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1634
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x27d/0x380 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x35d/0x870 mm/page-writeback.c:2683
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:398
 __filemap_fdatawrite_range mm/filemap.c:431 [inline]
 file_write_and_wait_range+0x195/0x280 mm/filemap.c:788
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2871 [inline]
 bch2_write_iter+0x21d9/0x23f0 fs/bcachefs/fs-io-buffered.c:1055
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1064
 do_writev+0x1b1/0x350 fs/read_write.c:1111
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd93db7dff9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd93e8cd038 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
RAX: ffffffffffffffda RBX: 00007fd93dd35f80 RCX: 00007fd93db7dff9
RDX: 0000000000000001 RSI: 00000000200004c0 RDI: 0000000000000004
RBP: 00007fd93e8cd090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007fd93dd35f80 R15: 00007fffc2efbfd8
 </TASK>

Allocated by task 5107:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:319 [inline]
 __kasan_mempool_unpoison_object+0x9e/0x160 mm/kasan/common.c:547
 remove_element+0x129/0x1a0 mm/mempool.c:150
 mempool_alloc_noprof+0x54e/0x5a0 mm/mempool.c:408
 bio_alloc_bioset+0x26f/0x1130 block/bio.c:554
 bch2_writepage_io_alloc fs/bcachefs/fs-io-buffered.c:465 [inline]
 __bch2_writepage+0x1443/0x2b10 fs/bcachefs/fs-io-buffered.c:599
 write_cache_pages+0xd0/0x230 mm/page-writeback.c:2640
 bch2_writepages+0x14f/0x380 fs/bcachefs/fs-io-buffered.c:639
 do_writepages+0x35d/0x870 mm/page-writeback.c:2683
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:398
 __filemap_fdatawrite_range mm/filemap.c:431 [inline]
 file_write_and_wait_range+0x195/0x280 mm/filemap.c:788
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2871 [inline]
 bch2_write_iter+0x21d9/0x23f0 fs/bcachefs/fs-io-buffered.c:1055
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1064
 do_writev+0x1b1/0x350 fs/read_write.c:1111
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 4531:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_mempool_poison_object+0xaa/0x120 mm/kasan/common.c:522
 kasan_mempool_poison_object include/linux/kasan.h:357 [inline]
 kasan_poison_element mm/mempool.c:118 [inline]
 add_element mm/mempool.c:141 [inline]
 mempool_free+0x1c8/0x390 mm/mempool.c:541
 bch2_writepage_io_done+0x5c1/0x670 fs/bcachefs/fs-io-buffered.c:441
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 insert_work+0x3e/0x330 kernel/workqueue.c:2183
 __queue_work+0xc8b/0xf50 kernel/workqueue.c:2339
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2390
 queue_work include/linux/workqueue.h:662 [inline]
 closure_queue include/linux/closure.h:268 [inline]
 closure_put_after_sub+0x2b1/0x330 lib/closure.c:42
 bch2_nocow_write+0x51b0/0x56a0 fs/bcachefs/io_write.c:1370
 __bch2_write+0x5bf6/0x5e30 fs/bcachefs/io_write.c:1412
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1634
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x27d/0x380 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x35d/0x870 mm/page-writeback.c:2683
 filemap_fdatawrite_wbc+0x125/0x180 mm/filemap.c:398
 __filemap_fdatawrite_range mm/filemap.c:431 [inline]
 file_write_and_wait_range+0x195/0x280 mm/filemap.c:788
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2871 [inline]
 bch2_write_iter+0x21d9/0x23f0 fs/bcachefs/fs-io-buffered.c:1055
 do_iter_readv_writev+0x600/0x880
 vfs_writev+0x376/0xba0 fs/read_write.c:1064
 do_writev+0x1b1/0x350 fs/read_write.c:1111
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88804c5f8e40
 which belongs to the cache bio-106 of size 1064
The buggy address is located 124 bytes inside of
 freed 1064-byte region [ffff88804c5f8e40, ffff88804c5f9268)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4c5f8
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88803ddafa00 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800d000d 00000001f5000000 0000000000000000
head: 04fff00000000040 ffff88803ddafa00 dead000000000122 0000000000000000
head: 0000000000000000 00000000800d000d 00000001f5000000 0000000000000000
head: 04fff00000000002 ffffea0001317e01 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5107, tgid 5106 (syz.0.0), ts 81425363015, free_ts 81422459952
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3045/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x2a0 mm/slub.c:4141
 mempool_init_node+0x1ee/0x4e0 mm/mempool.c:217
 mempool_init_noprof+0x3a/0x50 mm/mempool.c:246
 bioset_init+0x2e8/0x820 block/bio.c:1857
 bch2_fs_fs_io_buffered_init+0x2b/0x50 fs/bcachefs/fs-io-buffered.c:1067
 bch2_fs_alloc fs/bcachefs/super.c:930 [inline]
 bch2_fs_open+0x2d4f/0x2f80 fs/bcachefs/super.c:2064
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2161
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
page last free pid 5107 tgid 5106 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2638
 stack_depot_save_flags+0x6f6/0x830 lib/stackdepot.c:666
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_save_track+0x51/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __do_kmalloc_node mm/slub.c:4264 [inline]
 __kmalloc_node_noprof+0x22a/0x440 mm/slub.c:4270
 kmalloc_array_node_noprof include/linux/slab.h:995 [inline]
 mempool_init_node+0x12c/0x4e0 mm/mempool.c:206
 mempool_init_noprof+0x3a/0x50 mm/mempool.c:246
 mempool_init_kvmalloc_pool include/linux/mempool.h:105 [inline]
 __bch2_fs_compress_init+0x80a/0x9a0 fs/bcachefs/compress.c:632
 bch2_fs_alloc fs/bcachefs/super.c:926 [inline]
 bch2_fs_open+0x2caf/0x2f80 fs/bcachefs/super.c:2064
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2161
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88804c5f8d80: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff88804c5f8e00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff88804c5f8e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff88804c5f8f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804c5f8f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
