Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48C81F8EF5
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Dec 2024 08:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733129188; cv=none; b=SjergT0vnZOHSpl0CF6mPnX7Y658iL9jGT+FNQnCR91viMjdCkLmeKKKot6dWmzpULaeqaNnqDtyzyM/OrFepvlgeieABGRhLpRbFMk/m3Oom5R7VlfJV7mjZLEkaVFavr5q4Dy2yQFAVrMEcFVLTaLkZbqMq/ty6o++AyVqEvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733129188; c=relaxed/simple;
	bh=Wt3g3yhJk5zszp8JolPw2ERJelas8ryBqkz8gvB2R+Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=q8ddsQ0bGaxBo177CGw+asHJFarGBwdsf9U0eUCKNZYUxnOuNN78k02OpROQt+s/pBoManA+VhYOZtNToXHF//DbWxRBFKvPjTnQRRYs+dI96+F0uG8KAHxASNoVD8pG9p99dfndJfkbGqH/UbcnCCFwfo2IgPepQK1GUeoeGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-843e5314cb8so345188339f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 02 Dec 2024 00:46:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733129186; x=1733733986;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j30paMaeYrEZgwIHUVxtLA1XEyfwj5mCn4KavAoXhHo=;
        b=bkaNrq39u52xFArr4fRs9tjt39BD79pNXAbKGcZEXnXW3PBaPNwtt3QF+BCjMOrEHm
         +KnHDV/KNcENkKhO6eXoWBDlnNgkLE8/zNgAPxfADNIDZIdpPRPkqRzFFA7DQWGjhypk
         MTFQMewRrdo5vN9W3HJvbSDWIhuy8aUoxNWh8HvypHQs2Q1Ry7XEympVTLXbuzasJEIa
         +tSGaMHSgLKclb/3dbvWJsD/XjgZaAIcYtVpJ8lYLMPrGzCVGRwRpmpxUDN/8Lwg3V0G
         3dDfX5XY+hlJDXm6kNntsg4Z3xXE20IgbYkLNUJwQCxJWpQt/3P/Wb1LNGa4OzjcSXz6
         aodQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCgsZahej9eh6mSrYPKCec+Pe3EKdrBHYHrMUou7KF9osak1mxN1YtzOwMJvfo6a/jZW/hrROHqgEgVxH+tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmETrhfZVy70oOj7Yf2zXixpC5DukuJ6/ijRVpTk4GrxYSz6Lk
	qhsdDauVu9LOWzCVuTkmnTi77JIK1PGR7q+JQBqxOt5yMHPKj4k3l0wJwr94aZPZtZYy3CfUe5C
	Sqe6qyw8WLS4bQip7L9u6+16vGhyLC6tShg6WEI4MIziGtWfTdjySKNA=
X-Google-Smtp-Source: AGHT+IEQn//dFu2dOy+XTC4cS3gkVKwh2Fp8K7X0hSIp+gfOEtyPMEUa3Yi9KTNVZRL/f0ZOBBPVSj9AdqfxiGasScqwW22Wv9ld
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:13a6:b0:3a7:6d14:cc29 with SMTP id
 e9e14a558f8ab-3a7c5525871mr242480475ab.1.1733129186080; Mon, 02 Dec 2024
 00:46:26 -0800 (PST)
Date: Mon, 02 Dec 2024 00:46:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674d73e2.050a0220.ad585.0046.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in memscan
From: syzbot <syzbot+68492be514245d0e5091@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2c22dc1ee3a1 Merge tag 'mailbox-v6.13' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=175715c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=472032c4f88b28ab
dashboard link: https://syzkaller.appspot.com/bug?extid=68492be514245d0e5091
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-2c22dc1e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/edc4991391e8/vmlinux-2c22dc1e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3ddbf30097ad/bzImage-2c22dc1e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+68492be514245d0e5091@syzkaller.appspotmail.com

bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): done starting filesystem
FAULT_INJECTION: forcing a failure.
name failslab, interval 1, probability 0, space 0, times 1
CPU: 0 UID: 0 PID: 5335 Comm: syz.0.0 Not tainted 6.12.0-syzkaller-09435-g2c22dc1ee3a1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 fail_dump lib/fault-inject.c:53 [inline]
 should_fail_ex+0x3b0/0x4e0 lib/fault-inject.c:154
 should_failslab+0xac/0x100 mm/failslab.c:46
 slab_pre_alloc_hook mm/slub.c:4057 [inline]
 slab_alloc_node mm/slub.c:4133 [inline]
 __do_kmalloc_node mm/slub.c:4282 [inline]
 __kmalloc_node_track_caller_noprof+0xdc/0x4c0 mm/slub.c:4302
 __do_krealloc mm/slub.c:4809 [inline]
 krealloc_noprof+0x10f/0x2f0 mm/slub.c:4862
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 printbuf_insert_spaces+0x56/0x530 fs/bcachefs/printbuf.c:81
 __printbuf_do_indent fs/bcachefs/printbuf.c:138 [inline]
 printbuf_do_indent+0x4c1/0x9d0 fs/bcachefs/printbuf.c:155
 bch2_prt_printf+0x559/0x6d0 fs/bcachefs/printbuf.c:190
 trace_bucket_alloc2+0x119/0xba0 fs/bcachefs/alloc_foreground.c:564
 bch2_bucket_alloc_trans+0x3a43/0x3a50 fs/bcachefs/alloc_foreground.c:678
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x13d0/0x1ec0 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x72b/0x5dd0 fs/bcachefs/io_write.c:1437
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1631
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x35f/0x880 mm/page-writeback.c:2702
 filemap_fdatawrite_wbc mm/filemap.c:397 [inline]
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:787
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2904 [inline]
 bch2_write_iter+0x222f/0x2440 fs/bcachefs/fs-io-buffered.c:1061
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 vfs_copy_file_range+0xd1f/0x1510 fs/read_write.c:1620
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d0837e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d091d8038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f7d08535fa0 RCX: 00007f7d0837e819
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 00007f7d091d8090 R08: fffffbffa003e45c R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f7d08535fa0 R15: 00007ffcfb862a38
 </TASK>
==================================================================
BUG: KASAN: slab-out-of-bounds in memscan+0x62/0x80 lib/string.c:717
Read of size 1 at addr ffff8880526eaa77 by task syz.0.0/5335

CPU: 0 UID: 0 PID: 5335 Comm: syz.0.0 Not tainted 6.12.0-syzkaller-09435-g2c22dc1ee3a1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 memscan+0x62/0x80 lib/string.c:717
 __printbuf_do_indent fs/bcachefs/printbuf.c:101 [inline]
 printbuf_do_indent+0x10d/0x9d0 fs/bcachefs/printbuf.c:155
 bch2_prt_printf+0x559/0x6d0 fs/bcachefs/printbuf.c:190
 trace_bucket_alloc2+0x119/0xba0 fs/bcachefs/alloc_foreground.c:564
 bch2_bucket_alloc_trans+0x3a43/0x3a50 fs/bcachefs/alloc_foreground.c:678
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x13d0/0x1ec0 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x72b/0x5dd0 fs/bcachefs/io_write.c:1437
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1631
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x35f/0x880 mm/page-writeback.c:2702
 filemap_fdatawrite_wbc mm/filemap.c:397 [inline]
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:787
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2904 [inline]
 bch2_write_iter+0x222f/0x2440 fs/bcachefs/fs-io-buffered.c:1061
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 vfs_copy_file_range+0xd1f/0x1510 fs/read_write.c:1620
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7d0837e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7d091d8038 EFLAGS: 00000246 ORIG_RAX: 0000000000000146
RAX: ffffffffffffffda RBX: 00007f7d08535fa0 RCX: 00007f7d0837e819
RDX: 0000000000000005 RSI: 0000000000000000 RDI: 0000000000000006
RBP: 00007f7d091d8090 R08: fffffbffa003e45c R09: 0700000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f7d08535fa0 R15: 00007ffcfb862a38
 </TASK>

Allocated by task 5335:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4283 [inline]
 __kmalloc_node_track_caller_noprof+0x28b/0x4c0 mm/slub.c:4302
 __do_krealloc mm/slub.c:4809 [inline]
 krealloc_noprof+0x10f/0x2f0 mm/slub.c:4862
 bch2_printbuf_make_room+0x1f1/0x350 fs/bcachefs/printbuf.c:59
 bch2_prt_printf+0x267/0x6d0 fs/bcachefs/printbuf.c:186
 trace_bucket_alloc2+0x119/0xba0 fs/bcachefs/alloc_foreground.c:564
 bch2_bucket_alloc_trans+0x3a43/0x3a50 fs/bcachefs/alloc_foreground.c:678
 bch2_bucket_alloc_set_trans+0x517/0xd30 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x13d0/0x1ec0 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x33a/0x410 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0xce9/0x2030
 __bch2_write+0x72b/0x5dd0 fs/bcachefs/io_write.c:1437
 bch2_write+0x9b5/0x1760 fs/bcachefs/io_write.c:1631
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x284/0x390 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x35f/0x880 mm/page-writeback.c:2702
 filemap_fdatawrite_wbc mm/filemap.c:397 [inline]
 __filemap_fdatawrite_range mm/filemap.c:430 [inline]
 file_write_and_wait_range+0x2a3/0x3c0 mm/filemap.c:787
 bch2_fsync+0x13a/0x360 fs/bcachefs/fs-io.c:199
 generic_write_sync include/linux/fs.h:2904 [inline]
 bch2_write_iter+0x222f/0x2440 fs/bcachefs/fs-io-buffered.c:1061
 iter_file_splice_write+0xbfa/0x1510 fs/splice.c:743
 do_splice_from fs/splice.c:941 [inline]
 direct_splice_actor+0x11b/0x220 fs/splice.c:1164
 splice_direct_to_actor+0x586/0xc80 fs/splice.c:1108
 do_splice_direct_actor fs/splice.c:1207 [inline]
 do_splice_direct+0x289/0x3e0 fs/splice.c:1233
 vfs_copy_file_range+0xd1f/0x1510 fs/read_write.c:1620
 __do_sys_copy_file_range fs/read_write.c:1670 [inline]
 __se_sys_copy_file_range+0x3fa/0x600 fs/read_write.c:1637
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880526eaa60
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 7 bytes to the right of
 allocated 16-byte region [ffff8880526eaa60, ffff8880526eaa70)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x526ea
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801ac41640 dead000000000100 dead000000000122
raw: 0000000000000000 0000000080800080 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5319, tgid 5319 (syz-executor), ts 66442865822, free_ts 0
 create_dummy_stack mm/page_owner.c:94 [inline]
 register_dummy_stack+0x8a/0xe0 mm/page_owner.c:100
 init_page_owner+0x3e/0x970 mm/page_owner.c:118
 invoke_init_callbacks mm/page_ext.c:148 [inline]
 page_ext_init+0x731/0x790 mm/page_ext.c:497
 mm_core_init+0x4c/0x60 mm/mm_init.c:2666
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8880526ea900: 00 00 fc fc 00 00 fc fc 00 00 fc fc fa fb fc fc
 ffff8880526ea980: 00 00 fc fc fa fb fc fc fa fb fc fc 00 00 fc fc
>ffff8880526eaa00: 00 00 fc fc 00 00 fc fc 00 00 fc fc 00 00 fc fc
                                                             ^
 ffff8880526eaa80: 00 00 fc fc fa fb fc fc fc fc fc fc fc fc fc fc
 ffff8880526eab00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
