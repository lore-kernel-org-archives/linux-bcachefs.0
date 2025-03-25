Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CE9479
	for <linux-bcachefs@vger.kernel.org>; Tue, 25 Mar 2025 04:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742877923; cv=none; b=LKFs4tByCKs4GCeWg1i3GDpKMJEOsOEe/H+84EoXUNWcvQ9kS2kwaQ8KYsL63GJSO7LzKKjzGpomTYWVdNjldjxC+O6fiQApxjzNorWm4RpZKPUZMGoOidRtHZ2M3jtdj3K2COYiaPBTqZr0JoaKqTvHfBkEXoiASzTp7kOLjTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742877923; c=relaxed/simple;
	bh=devzYDNalMsUjT+07OWPsr5ZmxLSUtrHJJ7Th81/KmA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jmy+TmQeIxL7nOM8VFGHbRaXkXvU1vL/bzt1MIHvl4nfNH2RPoqv9S88Cs1GFrJHyz/scKMnhylZ1S1sfWKhOYt+QpyI7jFVUb9C6HxKWm1AdU/06DMszg8LViBatsGLdJaWm/F7M4Mu9zxVr2kmWdo47uAQcKQRuv4MFt48v3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3d2a40e470fso40098825ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 24 Mar 2025 21:45:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742877921; x=1743482721;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s2PClflp1mOPEfAM9+lwaW49MMMNvSeyHVI9gRiU4BI=;
        b=PZLThkDJdZ12wbuJOfeq3Q+hsmEfWvzcQFSEC3YTViPMMvgj+15ptWh0jLT+CWitDB
         O3Kj+1QUFm+UexWPijIjcnpyIASa4tmXamjZ4Vn9WSG+fU36oz3c/hkc1TaDLJ4FmEVl
         gwUa0AE6eFPHBhZd/jTqteqQEt9AfH5/zzQqvESy9g1lnBu0hXyxxq9mPG8qttdLH1Ag
         g4usgtR9JQq26d2zjq7ka8rbnPBujbLCgsDFpBko7KdC7mYC3DKKTgnjmBIq4tBU3wT8
         fUndLBXsrbpzQSSs2z6e9y6wGCv+ETi/IlONM37Fj4ibkF2b0IRPJDOrdW+4dO8k1vXW
         Ax0w==
X-Forwarded-Encrypted: i=1; AJvYcCUxMVLK4vNXcIavsEV5WgXz6RdqIlXIJTcgjgHtyo+q7+jvPTpmUHdhYC2g1GqvkFSzz3yIzYjw7WwoyhsVIA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNwa3J6gdJgzseim3qmNeHJrVtb7zFhCna7FEilr/35MlpJQWo
	2ftwqruOfjZgUw67NBpwjB7fjM23iQc886oxXlNhUs8WtHTZYZKCvgrADLD+l/hNb8qSZF8QlXo
	pB/n8uCheV1+V8vVq4FWHcHDFZqtw/Vo7dxYmNVOlC6wSGY8YCOB5ZWA=
X-Google-Smtp-Source: AGHT+IFZq+ZHo/JIarbTlRWfyK1/HcaEsKdQlqvo+vvo90zrZBrmKURTSzFjXrXKyBqXBrW6TLymQpa34QDwBrBaYeTekD3tueqB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:746:b0:3d3:dcb8:1bf1 with SMTP id
 e9e14a558f8ab-3d5960d1ea3mr176397295ab.3.1742877920787; Mon, 24 Mar 2025
 21:45:20 -0700 (PDT)
Date: Mon, 24 Mar 2025 21:45:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67e234e0.050a0220.a7ebc.0037.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in memscan (2)
From: syzbot <syzbot+ca8a872d9fa7652522da@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    88d324e69ea9 Merge tag 'spi-fix-v6.14-rc7' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14203e98580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27515cfdbafbb90d
dashboard link: https://syzkaller.appspot.com/bug?extid=ca8a872d9fa7652522da
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-88d324e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0fdb8d29892b/vmlinux-88d324e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f6e1986450b4/bzImage-88d324e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca8a872d9fa7652522da@syzkaller.appspotmail.com

bcachefs (loop0): check_unreachable_inodes... done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure... done
bcachefs (loop0): check_nlinks... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): done starting filesystem
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5321 Comm: syz.0.0 Not tainted 6.14.0-rc7-syzkaller-00196-g88d324e69ea9 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:73 [inline]
 should_fail_ex+0x40a/0x550 lib/fault-inject.c:174
 should_failslab+0xac/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4068 [inline]
 slab_alloc_node mm/slub.c:4144 [inline]
 __do_kmalloc_node mm/slub.c:4293 [inline]
 __kmalloc_node_track_caller_noprof+0xdc/0x4c0 mm/slub.c:4313
 __do_krealloc mm/slub.c:4820 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4873
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 printbuf_insert_spaces+0x56/0x530 fs/bcachefs/printbuf.c:81
 __printbuf_do_indent fs/bcachefs/printbuf.c:138 [inline]
 printbuf_do_indent+0x4c4/0xa00 fs/bcachefs/printbuf.c:155
 bch2_prt_printf+0x559/0x6d0 fs/bcachefs/printbuf.c:190
 trace_bucket_alloc2+0x119/0xb90 fs/bcachefs/alloc_foreground.c:485
 bch2_bucket_alloc_trans+0x2e89/0x2ea0 fs/bcachefs/alloc_foreground.c:604
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:730
 __open_bucket_add_buckets+0x13e1/0x1e50 fs/bcachefs/alloc_foreground.c:973
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1017
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x769/0x5a80 fs/bcachefs/io_write.c:1466
 bch2_write+0x865/0x1660 fs/bcachefs/io_write.c:1659
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:469 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:652
 do_writepages+0x35f/0x880 mm/page-writeback.c:2687
 filemap_fdatawrite_wbc mm/filemap.c:388 [inline]
 __filemap_fdatawrite_range mm/filemap.c:421 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:796
 bch2_fsync+0x13a/0x350 fs/bcachefs/fs-io.c:228
 generic_write_sync include/linux/fs.h:2970 [inline]
 bch2_write_iter+0x298a/0x2cd0 fs/bcachefs/fs-io-buffered.c:1072
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b07d8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8b08b31038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f8b07fa5fa0 RCX: 00007f8b07d8d169
RDX: 0000000000000010 RSI: 0000200000000080 RDI: 0000000000000006
RBP: 00007f8b08b31090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007f8b07fa5fa0 R15: 00007ffca8a26258
 </TASK>
==================================================================
BUG: KASAN: slab-out-of-bounds in memscan+0x62/0x80 lib/string.c:728
Read of size 1 at addr ffff8880409bd697 by task syz.0.0/5321

CPU: 0 UID: 0 PID: 5321 Comm: syz.0.0 Not tainted 6.14.0-rc7-syzkaller-00196-g88d324e69ea9 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 memscan+0x62/0x80 lib/string.c:728
 _Z7memscanPvU25pass_dynamic_object_size0im include/linux/fortify-string.h:708 [inline]
 __printbuf_do_indent fs/bcachefs/printbuf.c:101 [inline]
 printbuf_do_indent+0x110/0xa00 fs/bcachefs/printbuf.c:155
 bch2_prt_printf+0x559/0x6d0 fs/bcachefs/printbuf.c:190
 trace_bucket_alloc2+0x119/0xb90 fs/bcachefs/alloc_foreground.c:485
 bch2_bucket_alloc_trans+0x2e89/0x2ea0 fs/bcachefs/alloc_foreground.c:604
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:730
 __open_bucket_add_buckets+0x13e1/0x1e50 fs/bcachefs/alloc_foreground.c:973
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1017
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x769/0x5a80 fs/bcachefs/io_write.c:1466
 bch2_write+0x865/0x1660 fs/bcachefs/io_write.c:1659
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:469 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:652
 do_writepages+0x35f/0x880 mm/page-writeback.c:2687
 filemap_fdatawrite_wbc mm/filemap.c:388 [inline]
 __filemap_fdatawrite_range mm/filemap.c:421 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:796
 bch2_fsync+0x13a/0x350 fs/bcachefs/fs-io.c:228
 generic_write_sync include/linux/fs.h:2970 [inline]
 bch2_write_iter+0x298a/0x2cd0 fs/bcachefs/fs-io-buffered.c:1072
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b07d8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8b08b31038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f8b07fa5fa0 RCX: 00007f8b07d8d169
RDX: 0000000000000010 RSI: 0000200000000080 RDI: 0000000000000006
RBP: 00007f8b08b31090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007f8b07fa5fa0 R15: 00007ffca8a26258
 </TASK>

Allocated by task 5321:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4294 [inline]
 __kmalloc_node_track_caller_noprof+0x28b/0x4c0 mm/slub.c:4313
 __do_krealloc mm/slub.c:4820 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4873
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x267/0x6d0 fs/bcachefs/printbuf.c:186
 trace_bucket_alloc2+0x119/0xb90 fs/bcachefs/alloc_foreground.c:485
 bch2_bucket_alloc_trans+0x2e89/0x2ea0 fs/bcachefs/alloc_foreground.c:604
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:730
 __open_bucket_add_buckets+0x13e1/0x1e50 fs/bcachefs/alloc_foreground.c:973
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1017
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x769/0x5a80 fs/bcachefs/io_write.c:1466
 bch2_write+0x865/0x1660 fs/bcachefs/io_write.c:1659
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:469 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:652
 do_writepages+0x35f/0x880 mm/page-writeback.c:2687
 filemap_fdatawrite_wbc mm/filemap.c:388 [inline]
 __filemap_fdatawrite_range mm/filemap.c:421 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:796
 bch2_fsync+0x13a/0x350 fs/bcachefs/fs-io.c:228
 generic_write_sync include/linux/fs.h:2970 [inline]
 bch2_write_iter+0x298a/0x2cd0 fs/bcachefs/fs-io-buffered.c:1072
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0xacf/0xd10 fs/read_write.c:679
 ksys_write+0x18f/0x2b0 fs/read_write.c:731
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880409bd680
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 7 bytes to the right of
 allocated 16-byte region [ffff8880409bd680, ffff8880409bd690)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x409bd
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801b041640 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080800080 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5321, tgid 5320 (syz.0.0), ts 71936914615, free_ts 71869688975
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x292/0x710 mm/page_alloc.c:4740
 alloc_pages_mpol+0x311/0x660 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:2423 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2587
 new_slab mm/slub.c:2640 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3826
 __slab_alloc+0x58/0xa0 mm/slub.c:3916
 __slab_alloc_node mm/slub.c:3991 [inline]
 slab_alloc_node mm/slub.c:4152 [inline]
 __do_kmalloc_node mm/slub.c:4293 [inline]
 __kmalloc_node_track_caller_noprof+0x2e9/0x4c0 mm/slub.c:4313
 __do_krealloc mm/slub.c:4820 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4873
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x267/0x6d0 fs/bcachefs/printbuf.c:186
 trace_bucket_alloc2+0x119/0xb90 fs/bcachefs/alloc_foreground.c:485
 bch2_bucket_alloc_trans+0x2e89/0x2ea0 fs/bcachefs/alloc_foreground.c:604
 bch2_bucket_alloc_set_trans+0x57c/0xd60 fs/bcachefs/alloc_foreground.c:730
 __open_bucket_add_buckets+0x13e1/0x1e50 fs/bcachefs/alloc_foreground.c:973
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1017
page last free pid 5321 tgid 5320 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_frozen_pages+0xe0d/0x10e0 mm/page_alloc.c:2660
 __slab_free+0x2c2/0x380 mm/slub.c:4520
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4115 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 __do_kmalloc_node mm/slub.c:4293 [inline]
 __kmalloc_node_noprof+0x23c/0x4d0 mm/slub.c:4300
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:665
 __bch2_darray_resize_noprof+0xd2/0x290 fs/bcachefs/darray.c:24
 bch2_write_super+0x48a/0x3cd0 fs/bcachefs/super-io.c:1003
 bch2_clear_recovery_pass_required fs/bcachefs/recovery_passes.c:186 [inline]
 bch2_run_recovery_passes+0x4a3/0xa90 fs/bcachefs/recovery_passes.c:295
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:936
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1041
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088

Memory state around the buggy address:
 ffff8880409bd580: fa fb fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
 ffff8880409bd600: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
>ffff8880409bd680: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff8880409bd700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880409bd780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
