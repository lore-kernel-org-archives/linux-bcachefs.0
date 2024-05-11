Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A548F1CD0C
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 20:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715460752; cv=none; b=jXLmpmtfUwj0A1erF5YdPVFkyjiipXexQb5N4wSRSQOuSu0oXGvikMqxzbr8y9gJU/b3eJU38cxB3WyYt3JwQbeH9SCWoh+rDTAW8P0uATBvd8g/fuB49sG/7FN9BrPJ+Eh/W0eHa7dkYjJKHxncPDfo2LoGtdSFyreqpcw7Ab0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715460752; c=relaxed/simple;
	bh=OQMWT/XESL2wSq3PMkPSKjQjIph6lO8ZBN4q383E4YY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=r2gGKJQEgufa4Um1dTH9AzQnZCKObOU+fN41gcxBjArEJhX/GLoTlHJNwIFXrcJnCTG/gODUSbyN/udJRe532v6X3lxlDOHzBWdXa7YOSoi6ztTyKzJYgczlnuYI0084dv18hd3BH+xdQILO47+Km5kfDhqIRtwQOlp90HpfqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7dabc125bddso389315939f.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 May 2024 13:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715460750; x=1716065550;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cGlFPamomYKWgAnIGl/Xy02h1wXcQK7YvJmmB63k8/E=;
        b=Ct41rrMvTcqWMs0kAlVPN2EpTTCqdY+IgvKcYHJHs1bEOMiJV6roA+pnvLxdOpz08q
         PXD9UT+Hx2zs4m4kX+TdrntlFjU9hN3yBdrZPnH5tbuZ4RZNZ/h5Watjhl7lyeo/5bV1
         IBTZY7TrMS4jmd9cCMu8IeuY81tGNRa/PfP1GJ4BVMISiXsKit5ihf3AyLGYNroPL30v
         1+CZB7ERJ6na0SviDBjpBDYSEAzjP//5RpkEYY/QzxxlN+uui+sbC3Exg1H0fuBHYxT4
         BgcGEwksk+Ln4iRt3+S5iv6eNIUHVXhsMeIuayMKuC3FPSe1sNlD6jpFrLgSS6LvuKLt
         2NNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYlKJNf0JAWg5byOTU6s+jHjPv7E3MpXr07OFG9i11DP+calSpYy5vilVW2oXLNBVUHTsn+zMQV8UKX5FQzDA6MvKg55Dh1x2u364GTBQ=
X-Gm-Message-State: AOJu0YyxbojcRkG1h2ca2BlVFxju1lMDxo1w3namUlQj+NHXx6DH7oHC
	U6HwoQGWgB/D2WEOOPiwlOBh5cc43wwskiLhMVvLlDOUsNt5mhj1bUgaW5ofkregE3lF+D5PFUk
	p4Q/Qtl61E9DTvT2u8DzEcTJOQ/jN6dqGO0L10RZZcCuUIk6TQEQoFKE=
X-Google-Smtp-Source: AGHT+IE39naJmXdDPa4XsacMJ/EyJlY+cjaAQws4yG++xeMrRw0RpBu6a9WHbcSd0nH55UawhSuhsh7hcvJ/tl7ejIRHjMWa7dy7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8506:b0:488:9082:8dd0 with SMTP id
 8926c6da1cb9f-48957cb32aemr423993173.0.1715460749885; Sat, 11 May 2024
 13:52:29 -0700 (PDT)
Date: Sat, 11 May 2024 13:52:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009f9447061833d477@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_extent_update_i_size_sectors
From: syzbot <syzbot+eceea46e8838baeeba67@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dccb07f2914c Merge tag 'for-6.9-rc7-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14c66e24980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=617171361dd3cd47
dashboard link: https://syzkaller.appspot.com/bug?extid=eceea46e8838baeeba67
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fdbc7be30633/disk-dccb07f2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a9e4c11aa835/vmlinux-dccb07f2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/43c3a343ea93/bzImage-dccb07f2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+eceea46e8838baeeba67@syzkaller.appspotmail.com

bcachefs (loop0): snapshots_read... done
bcachefs (loop0): journal_replay... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
=====================================================
BUG: KMSAN: uninit-value in bch2_extent_update_i_size_sectors+0x140f/0x17d0 fs/bcachefs/io_write.c:237
 bch2_extent_update_i_size_sectors+0x140f/0x17d0 fs/bcachefs/io_write.c:237
 bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
 bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
 __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
 bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
 bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
 closure_queue include/linux/closure.h:257 [inline]
 closure_call include/linux/closure.h:390 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
 bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
 do_writepages+0x427/0xc30 mm/page-writeback.c:2612
 filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
 __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
 sync_file_range+0x316/0x450 fs/sync.c:292
 ksys_sync_file_range fs/sync.c:364 [inline]
 __do_sys_sync_file_range fs/sync.c:373 [inline]
 __se_sys_sync_file_range fs/sync.c:370 [inline]
 __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
 x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:278
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:505 [inline]
 __bch2_bkey_make_mut_noupdate fs/bcachefs/btree_update.h:225 [inline]
 __bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:282 [inline]
 bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:293 [inline]
 bch2_extent_update_i_size_sectors+0x9a9/0x17d0 fs/bcachefs/io_write.c:219
 bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
 bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
 __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
 bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
 bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
 closure_queue include/linux/closure.h:257 [inline]
 closure_call include/linux/closure.h:390 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
 bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
 do_writepages+0x427/0xc30 mm/page-writeback.c:2612
 filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
 __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
 sync_file_range+0x316/0x450 fs/sync.c:292
 ksys_sync_file_range fs/sync.c:364 [inline]
 __do_sys_sync_file_range fs/sync.c:373 [inline]
 __se_sys_sync_file_range fs/sync.c:370 [inline]
 __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
 x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:278
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:511 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:505 [inline]
 btree_key_cache_fill fs/bcachefs/btree_key_cache.c:454 [inline]
 bch2_btree_path_traverse_cached_slowpath+0x5f02/0x79f0 fs/bcachefs/btree_key_cache.c:530
 bch2_btree_path_traverse_cached+0xd1a/0x1140
 bch2_btree_path_traverse_one+0x737/0x5290 fs/bcachefs/btree_iter.c:1155
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:225 [inline]
 bch2_btree_iter_peek_slot+0x128c/0x3840 fs/bcachefs/btree_iter.c:2473
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:549 [inline]
 __bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:278 [inline]
 bch2_bkey_get_mut_noupdate fs/bcachefs/btree_update.h:293 [inline]
 bch2_extent_update_i_size_sectors+0x404/0x17d0 fs/bcachefs/io_write.c:219
 bch2_extent_update+0x4f5/0xac0 fs/bcachefs/io_write.c:314
 bch2_write_index_default fs/bcachefs/io_write.c:366 [inline]
 __bch2_write_index+0x1653/0x2bd0 fs/bcachefs/io_write.c:520
 bch2_write_data_inline fs/bcachefs/io_write.c:1538 [inline]
 bch2_write+0x1a13/0x1b40 fs/bcachefs/io_write.c:1606
 closure_queue include/linux/closure.h:257 [inline]
 closure_call include/linux/closure.h:390 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:468 [inline]
 bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:660
 do_writepages+0x427/0xc30 mm/page-writeback.c:2612
 filemap_fdatawrite_wbc+0x1d8/0x270 mm/filemap.c:397
 __filemap_fdatawrite_range+0xe3/0x120 mm/filemap.c:430
 sync_file_range+0x316/0x450 fs/sync.c:292
 ksys_sync_file_range fs/sync.c:364 [inline]
 __do_sys_sync_file_range fs/sync.c:373 [inline]
 __se_sys_sync_file_range fs/sync.c:370 [inline]
 __x64_sys_sync_file_range+0x15a/0x2a0 fs/sync.c:370
 x64_sys_call+0xc90/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:278
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 __kmalloc_large_node+0x231/0x370 mm/slub.c:3927
 __do_kmalloc_node mm/slub.c:3960 [inline]
 __kmalloc_node+0xb10/0x10c0 mm/slub.c:3979
 kmalloc_node include/linux/slab.h:648 [inline]
 kvmalloc_node+0xc0/0x2d0 mm/util.c:634
 kvmalloc include/linux/slab.h:766 [inline]
 btree_bounce_alloc fs/bcachefs/btree_io.c:118 [inline]
 bch2_btree_node_read_done+0x4e68/0x75e0 fs/bcachefs/btree_io.c:1185
 btree_node_read_work+0x8a5/0x1eb0 fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x3d42/0x4b50
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0xa6c/0x13d0 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x454/0xee0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x7adb/0x9310 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x7b2/0xbd0 fs/bcachefs/super.c:1043
 bch2_fs_open+0x135f/0x1670 fs/bcachefs/super.c:2102
 bch2_mount+0x90d/0x1d90 fs/bcachefs/fs.c:1903
 legacy_get_tree+0x114/0x290 fs/fs_context.c:662
 vfs_get_tree+0xa7/0x570 fs/super.c:1779
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3352
 path_mount+0x742/0x1f20 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x725/0x810 fs/namespace.c:3875
 __x64_sys_mount+0xe4/0x150 fs/namespace.c:3875
 x64_sys_call+0x2bf4/0x3b50 arch/x86/include/generated/asm/syscalls_64.h:166
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcf/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 PID: 6218 Comm: syz-executor.0 Not tainted 6.9.0-rc7-syzkaller-00012-gdccb07f2914c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
=====================================================


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
