Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A577A42056
	for <linux-bcachefs@vger.kernel.org>; Sun,  1 Dec 2024 08:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733042070; cv=none; b=Hw7koUPhiUbS83IlrGndqHLm+6dw0I4uO+84vvDBDqMe89d/aIlxhBwrXWiWh76kfHMm/62292KvVsyKeKyr0JcanQDIlFAe0NkQxLCSqSgUP1fSf4NBUYdCi2B74Z8s/aphmZCnoxlrtkx7U71L7LFSUKd+D95qSkEoMRShdEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733042070; c=relaxed/simple;
	bh=xo7iAfSM7u3LF/kSQ7PIU5z3RdO0smnf+ZelQZanKRU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cJQqjmiXDcdmXg91f+c1psQJJ01HUkihlYc4853qsftMFgkjKzIZZ4P3K3joGcmbO6mOJt8lEJIqehJixIyX/2s0e7xPmWyjGf6s85Ihaq//SaTSDAwYzrnkH+bS/2SJmdkyXJ/TMvw8durqpPO929Tw3FM0KNm3bXhNpvP0guc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-83e5dd390bfso303209039f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Dec 2024 00:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733042068; x=1733646868;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EhaivmOwcdzarv/0HqZoatOD3z1I1AJiAjYdWR2LWzs=;
        b=SRmtapvOSBM7H8AC98xoYKC3eoNVgTNMObDB7JUHXrqjyfKnajWDYZSQ0U2U9YwPjW
         BQq2FXvahB0B0JLioPG4ng0XOr7KKYLdwk5xuTPsfAWG8J8eqF6oiGcTHida4G/xDcdU
         ZU+Pus4W9/illhY5VORaIp0HJx5PGdptEcbauAFgHy1aeJivZrV6BpqxwSiKSVS7obRK
         juzFwyuGLyrve18ZETIR5CanQfce6zwO1r7EAq5Bk36aaOSYxIilKzL/MN+gIxJPejfM
         xlFnrsafWUqAZqvcWwv6sDGu2JZaqI/z0ulKaIEpRGAHd05lTC+rqSxYWwaRKXALu7Xo
         wT3A==
X-Forwarded-Encrypted: i=1; AJvYcCVUDRNavXnTIHjtUHzFjvLWSJ/GmnnC+PgFg7OY+r6/UkfMLrraia/uPFt5vHZAgSDp65Z8ywFtYd6nrs5dzg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1uAJWGmPrqpz6HGv+EMt72jh87O/JfohiVVlUyEwF/40R4TSY
	VBnkF5rKAddhY+cN/m66+NK0c06XBTO7w/pYKRpX/4n32OMULjFHwGzTOq+A8NCex1ZlfNbJc95
	2CEj3qAGcwNsQyr8bPyeBlIijlQkJhOu3pnjqq7gtlL+Beg186LXRVqg=
X-Google-Smtp-Source: AGHT+IEAJu7ZjRp11q0rt5teutxnpYaeZrKqlt7eWDm78Hb/DxZE0zu/2NQvL08TM26A5GmD5Nz/dhnFNXXoxxEQz2py6wIAJh15
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cd:b0:3a7:e786:afb4 with SMTP id
 e9e14a558f8ab-3a7e786bb16mr23765285ab.2.1733042067896; Sun, 01 Dec 2024
 00:34:27 -0800 (PST)
Date: Sun, 01 Dec 2024 00:34:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674c1f93.050a0220.48a03.0009.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bkey_ptrs_validate
From: syzbot <syzbot+5d8a06a9e86672d9f71f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    445d9f05fa14 Merge tag 'nfsd-6.13' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=150f83c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c5486b9d7cc64830
dashboard link: https://syzkaller.appspot.com/bug?extid=5d8a06a9e86672d9f71f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7024ceac9339/disk-445d9f05.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ebf50afbcd15/vmlinux-445d9f05.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9e60e080ed9e/bzImage-445d9f05.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d8a06a9e86672d9f71f@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __extent_entry_type fs/bcachefs/extents.h:54 [inline]
BUG: KMSAN: uninit-value in bch2_bkey_ptrs_validate+0x589/0x2df0 fs/bcachefs/extents.c:1239
 __extent_entry_type fs/bcachefs/extents.h:54 [inline]
 bch2_bkey_ptrs_validate+0x589/0x2df0 fs/bcachefs/extents.c:1239
 bch2_bkey_val_validate+0x2b5/0x440 fs/bcachefs/bkey_methods.c:143
 bset_key_validate fs/bcachefs/btree_io.c:841 [inline]
 validate_bset_keys+0x1531/0x2080 fs/bcachefs/btree_io.c:910
 validate_bset_for_write+0x142/0x290 fs/bcachefs/btree_io.c:1942
 __bch2_btree_node_write+0x53df/0x6830 fs/bcachefs/btree_io.c:2152
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x12d5/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2095
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 bch2_btree_node_rewrite+0x1442/0x1930 fs/bcachefs/btree_update_interior.c:2179
 async_btree_node_rewrite_trans fs/bcachefs/btree_update_interior.c:2236 [inline]
 async_btree_node_rewrite_work+0x485/0x1710 fs/bcachefs/btree_update_interior.c:2249
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_node_data_alloc fs/bcachefs/btree_cache.c:153 [inline]
 __bch2_btree_node_mem_alloc+0x2be/0xa80 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x4e4/0xb50 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:917 [inline]
 bch2_fs_open+0x4d3a/0x5b40 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x983/0x22d0 fs/bcachefs/fs.c:2157
 vfs_get_tree+0xb1/0x5a0 fs/super.c:1814
 do_new_mount+0x71f/0x15e0 fs/namespace.c:3507
 path_mount+0x742/0x1f10 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x722/0x810 fs/namespace.c:4034
 __ia32_sys_mount+0xe3/0x150 fs/namespace.c:4034
 ia32_sys_call+0x260e/0x4180 arch/x86/include/generated/asm/syscalls_32.h:22
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0xb0/0x110 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x38/0x80 arch/x86/entry/common.c:411
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:449
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e

CPU: 0 UID: 0 PID: 3613 Comm: kworker/u8:11 Tainted: G        W          6.12.0-syzkaller-09734-g445d9f05fa14 #0
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: btree_node_rewrite async_btree_node_rewrite_work
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
