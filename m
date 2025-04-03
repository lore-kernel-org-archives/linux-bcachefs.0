Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C477924EAB2
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Apr 2025 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743691340; cv=none; b=bH3M1YWI7/eF5G0EcYqXuQUKhtWV/J3I4dFkFrgZtpF58gRX0+Tm/d9cIcyiBUXbeZXOFUVignUk6+ChOcxIDuAMohlmJIDyia7bTQrU2rmQ/2JBuS7JG+r1HF1lTRiH/evl3gfhg+GnQUOccR0GyIhminPEl9FDiqs2jp/pAZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743691340; c=relaxed/simple;
	bh=UQAp4subuYPXvUm19rXETDbY1fbGgTFnynQF1DdG6Xk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=IUr0HpbpR2ozcXCiMZmcgsgG1AvlCup5J0F/cSu5Ryt/PocHQqx3w8Er62bUkP5LqHMagJqZIjB3VkdomlpbrOJWvbQbBqAIOd+xfNJCPgm1O9Yd2tTkz1xbLiLE7gWrmoUOcjuaI1X4nsR4iBsIOjnitSDKaPkbjOLU8qA8Y9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d5da4fb5e0so11630185ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Apr 2025 07:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743691338; x=1744296138;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMLMkq3a7kDlEivFUizhdK1aaRuHbYaJPjcv3xcjwYw=;
        b=qzlc5Ft99PBf2LD27spjTOozMKuLXYUX1BGrytUqCUGJlw4f7ie/tXdJsW3s9Xe/Yl
         /+yWS4QuZfIZpU6Q0r2VLg1Wd+iFpy+TccZ8jujUWYuJNvUziV7j4hJyD6+0Ps0Huhrn
         9tOwkZuZA0B8/Y4YXjgofQD3zDxzCd6UBDXzkMBrNlKO6cowM/h3KahFjLCw5nLTWhBE
         0q4lAU7AGF3BInsafsBS+CSpjNm8Qaeu5gWL1pSAv7oCVXwUYExQrqeoga1m0ERKzmGL
         +X37FZ2K70gl4p8W5HjliYP9uQLlI8e83W8bI72wga9M46cwC9ZUdn3RESKops3e0RlA
         F1sg==
X-Forwarded-Encrypted: i=1; AJvYcCU7pNHU0Wux5Vi5PnDDlzVOUd89r7oxmlqEZNVBjwsNpwK17Kn79nXkXS92SLq12uY0wJxkLrZQTQOJ+aXMFg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9hxmIwTMn/QHX6HSxPDj7dLnW8mAmc+eGuT3xXZGLPBY3eLl7
	AK8PvWnw+mF0wVmyWg8logEC2QQNCLKdSJSA2+kVSp3xncBUNfXZ6ZE0dl+rSQXMdXWCpdkEM3Z
	WMS47Cc7YhVbH2ZLXt8tfc4Fv/CbDf7z+aQ3TJ0e138JlBeTxSVWvkQ0=
X-Google-Smtp-Source: AGHT+IFHs9kqVaEqN/sB+YYux5WaBSDwZsw2w6HL86okt9tgQBqX7A6BYB+vwNXaMuV7P+9rligMqNMjtVaRJjiN+XUOGO/DYWHX
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1529:b0:3d4:3fbf:967d with SMTP id
 e9e14a558f8ab-3d6dd781c22mr34839455ab.7.1743691337902; Thu, 03 Apr 2025
 07:42:17 -0700 (PDT)
Date: Thu, 03 Apr 2025 07:42:17 -0700
In-Reply-To: <67e234e0.050a0220.a7ebc.0037.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ee9e49.050a0220.9040b.01d3.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in memscan (2)
From: syzbot <syzbot+ca8a872d9fa7652522da@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    a1b5bd45d4ee Merge tag 'usb-6.15-rc1' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1524d404580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe3b5e6a2cb1cc2
dashboard link: https://syzkaller.appspot.com/bug?extid=ca8a872d9fa7652522da
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1745f7b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-a1b5bd45.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8b14e02f603d/vmlinux-a1b5bd45.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cc06cac05b38/bzImage-a1b5bd45.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f3f07afca2d8/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca8a872d9fa7652522da@syzkaller.appspotmail.com

R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f14a1da5fa0 R15: 00007ffd3c658fa8
 </TASK>
==================================================================
BUG: KASAN: slab-out-of-bounds in memscan+0x61/0x80 lib/string.c:728
Read of size 1 at addr ffff8880370da18b by task syz.0.16/5514

CPU: 0 UID: 0 PID: 5514 Comm: syz.0.16 Not tainted 6.14.0-syzkaller-12886-ga1b5bd45d4ee #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 memscan+0x61/0x80 lib/string.c:728
 _Z7memscanPvU25pass_dynamic_object_size0im include/linux/fortify-string.h:708 [inline]
 __printbuf_do_indent fs/bcachefs/printbuf.c:101 [inline]
 printbuf_do_indent+0x110/0xa10 fs/bcachefs/printbuf.c:155
 bch2_prt_printf+0x55b/0x6d0 fs/bcachefs/printbuf.c:190
 trace_bucket_alloc2+0x214/0xb90 fs/bcachefs/alloc_foreground.c:472
 bch2_bucket_alloc_trans+0x2eaf/0x2ed0 fs/bcachefs/alloc_foreground.c:587
 bch2_bucket_alloc_set_trans+0x532/0xd00 fs/bcachefs/alloc_foreground.c:713
 __open_bucket_add_buckets+0x13fc/0x1e80 fs/bcachefs/alloc_foreground.c:956
 open_bucket_add_buckets+0x343/0x410 fs/bcachefs/alloc_foreground.c:1000
 bch2_alloc_sectors_start_trans+0xcf4/0x2050 fs/bcachefs/alloc_foreground.c:-1
 __bch2_write+0x677/0x46c0 fs/bcachefs/io_write.c:1482
 bch2_write+0x834/0x15d0 fs/bcachefs/io_write.c:1669
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:545 [inline]
 bch2_direct_write+0x1b0d/0x31a0 fs/bcachefs/fs-io-direct.c:668
 bch2_write_iter+0x195/0x2cd0 fs/bcachefs/fs-io-buffered.c:1057
 new_sync_write fs/read_write.c:591 [inline]
 vfs_write+0x70f/0xd10 fs/read_write.c:684
 ksys_write+0x19d/0x2d0 fs/read_write.c:736
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14a1b8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f14a2a23038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f14a1da5fa0 RCX: 00007f14a1b8d169
RDX: 000000000000f000 RSI: 0000200000000200 RDI: 0000000000000006
RBP: 00007f14a2a23090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f14a1da5fa0 R15: 00007ffd3c658fa8
 </TASK>

Allocated by task 5514:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x9d/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4331 [inline]
 __kmalloc_node_track_caller_noprof+0x295/0x4d0 mm/slub.c:4350
 __do_krealloc mm/slub.c:4908 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4961
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x269/0x6d0 fs/bcachefs/printbuf.c:186
 trace_bucket_alloc2+0x1c6/0xb90 fs/bcachefs/alloc_foreground.c:470
 bch2_bucket_alloc_trans+0x2eaf/0x2ed0 fs/bcachefs/alloc_foreground.c:587
 bch2_bucket_alloc_set_trans+0x532/0xd00 fs/bcachefs/alloc_foreground.c:713
 __open_bucket_add_buckets+0x13fc/0x1e80 fs/bcachefs/alloc_foreground.c:956
 open_bucket_add_buckets+0x343/0x410 fs/bcachefs/alloc_foreground.c:1000
 bch2_alloc_sectors_start_trans+0xcf4/0x2050 fs/bcachefs/alloc_foreground.c:-1
 __bch2_write+0x677/0x46c0 fs/bcachefs/io_write.c:1482
 bch2_write+0x834/0x15d0 fs/bcachefs/io_write.c:1669
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_dio_write_loop fs/bcachefs/fs-io-direct.c:545 [inline]
 bch2_direct_write+0x1b0d/0x31a0 fs/bcachefs/fs-io-direct.c:668
 bch2_write_iter+0x195/0x2cd0 fs/bcachefs/fs-io-buffered.c:1057
 new_sync_write fs/read_write.c:591 [inline]
 vfs_write+0x70f/0xd10 fs/read_write.c:684
 ksys_write+0x19d/0x2d0 fs/read_write.c:736
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880370da100
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 11 bytes to the right of
 allocated 128-byte region [ffff8880370da100, ffff8880370da180)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x370da
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801b041a00 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5514, tgid 5513 (syz.0.16), ts 101748145234, free_ts 101731411139
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1717
 prep_new_page mm/page_alloc.c:1725 [inline]
 get_page_from_freelist+0x352b/0x36c0 mm/page_alloc.c:3652
 __alloc_frozen_pages_noprof+0x211/0x5b0 mm/page_alloc.c:4934
 alloc_pages_mpol+0x339/0x690 mm/mempolicy.c:2301
 alloc_slab_page mm/slub.c:2459 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2623
 new_slab mm/slub.c:2676 [inline]
 ___slab_alloc+0xc3b/0x1500 mm/slub.c:3862
 __slab_alloc+0x58/0xa0 mm/slub.c:3952
 __slab_alloc_node mm/slub.c:4027 [inline]
 slab_alloc_node mm/slub.c:4188 [inline]
 __do_kmalloc_node mm/slub.c:4330 [inline]
 __kmalloc_node_track_caller_noprof+0x2ef/0x4d0 mm/slub.c:4350
 __do_krealloc mm/slub.c:4908 [inline]
 krealloc_noprof+0x10f/0x300 mm/slub.c:4961
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x269/0x6d0 fs/bcachefs/printbuf.c:186
 bch2_btree_path_to_text_short+0x8a5/0xfb0 fs/bcachefs/btree_iter.c:1520
 __bch2_trans_paths_to_text+0xe5/0x180 fs/bcachefs/btree_iter.c:1575
 bch2_trans_update_max_paths+0x173/0x420 fs/bcachefs/btree_iter.c:1611
 btree_path_alloc+0x8d9/0xad0 fs/bcachefs/btree_iter.c:1708
 bch2_path_get+0xb77/0x1610 fs/bcachefs/btree_iter.c:1759
page last free pid 5321 tgid 5321 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_frozen_pages+0xde8/0x10a0 mm/page_alloc.c:2680
 discard_slab mm/slub.c:2720 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3189
 put_cpu_partial+0x17e/0x250 mm/slub.c:3264
 __slab_free+0x294/0x390 mm/slub.c:4516
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4151 [inline]
 slab_alloc_node mm/slub.c:4200 [inline]
 __do_kmalloc_node mm/slub.c:4330 [inline]
 __kmalloc_noprof+0x238/0x4d0 mm/slub.c:4343
 kmalloc_noprof include/linux/slab.h:909 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x245/0x790 security/tomoyo/file.c:723
 security_file_ioctl+0xc6/0x2a0 security/security.c:2913
 __do_sys_ioctl fs/ioctl.c:900 [inline]
 __se_sys_ioctl+0x46/0x160 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880370da080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880370da100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8880370da180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                      ^
 ffff8880370da200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880370da280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
