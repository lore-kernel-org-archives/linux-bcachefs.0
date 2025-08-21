Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF672EA73C
	for <linux-bcachefs@vger.kernel.org>; Thu, 21 Aug 2025 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755814481; cv=none; b=RTi0v5AdEq3qCCPbHSkAr6CncgRljoegEi10tAkFrg/RvcncbNk7/NbfAu6hJQlaIiTS5ZabKomMMqoh4LwEdCEU13DuU/+adVO414Zxbgvpg8F2/BNE/xnkoWqCVpw35WnezP/S1mw+g+XX0WLpnZ8dkCTh1xh5RPGX5oLQXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755814481; c=relaxed/simple;
	bh=y6o0/xujEY3dRnWjW36bCtMJHDopfxz2c2MIJXcEG0o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=T2o4HCFWI3Z49uFk89abBG8oCDW8LEBRda9Vn4EsVbpO2vrcwR9xtB86ov0s0qafSwsJXpS38KpdLI7lNd83Rk18c2YAGEVprl304N/f91ZzLYxA7ILd7KlEx3lFSaQ8hZuaSmMrtn6TlJTbmRvehmnFFJTFluC8+1sHCKfyXyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3e56ffea78fso18412375ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 21 Aug 2025 15:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755814479; x=1756419279;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kH/EniwJmnLRBhMK6SUWmXVfH8WUAiQw0RZlFHQjQ+8=;
        b=naPKLfNzJ3T/hY+yBdnXVMcNum7JwwrsD/SjWvBLzlbpyvgMxFrVWutr0peywKAa+f
         Damd5qQBNB5inDe/hoAgV6Hp2TbcYc8J8LLOIt1fQn8NKaSPJc9e+nnabBKbMX5XaUMH
         ANcss2hn69Y2q++NxEmOHAW0qaUASpcJe2F2vrtwkzgOJYcImTiHFqRoJSyQh0VRzvs5
         9mG5x3bTqZ4QDaHNw5eSOEPSRNIEBEXt6aopft8QzkAfrYKTwkCH5m1DRP4rRfbLXqnH
         oF8hMfMkdzPFJ88hh8czfwdHlcYBjSY22lgzpBXhM4aKLYJIG6Nnhms20E2fNMudDLT9
         6WTA==
X-Forwarded-Encrypted: i=1; AJvYcCWeyzgktm42/WG9c1CfB6aWobEE9QoRBWhNGXh9px41L4y8ZERoDNifXQN1vK2C3CZJopLs6Eo+osqYBHu5Bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYRb7HVyYimP3WITLCXBh2CdQvkGuw2olzj69woXtD7fIfPzjE
	/iRiu4yt0/Yx5PZIVELrnm+hNvVzvvuPlGELZ72fURgHACElasniR7LdRqnqXCLCTcY5E5pcKOV
	vpXn6zZ74kRcGYG4jEIsnND3gJiKsOdCSPpOmBBv/EtKxa7VMFYdIKJBEsf0=
X-Google-Smtp-Source: AGHT+IEH0hAQsv51nLYkOPkGLrfcKESJb6IFFb4ucTiC4uYbnybSeKaNdSx6s8Wk8CRz4NuIJ8xVkrNRG8B+m/6XX1abIV48reJK
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e9:b0:3e5:75cb:44fc with SMTP id
 e9e14a558f8ab-3e921a5d155mr19895995ab.12.1755814478859; Thu, 21 Aug 2025
 15:14:38 -0700 (PDT)
Date: Thu, 21 Aug 2025 15:14:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a79a4e.050a0220.13802c.0002.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in trans_set_locked (2)
From: syzbot <syzbot+7c044bb36ac38f98889f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=160daba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=7c044bb36ac38f98889f
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c044bb36ac38f98889f@syzkaller.appspotmail.com

  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0
======================================================
WARNING: possible circular locking dependency detected
6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 Not tainted
------------------------------------------------------
syz.2.330/8664 is trying to acquire lock:
ffff000102c481b0 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x68/0x200 fs/bcachefs/btree_locking.h:205

but task is already holding lock:
ffff0000f6b182e8 (mapping.invalidate_lock#7){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
ffff0000f6b182e8 (mapping.invalidate_lock#7){.+.+}-{4:4}, at: filemap_fault+0x3fc/0x1280 mm/filemap.c:3433

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (mapping.invalidate_lock#7){.+.+}-{4:4}:
       down_read+0x58/0x2f8 kernel/locking/rwsem.c:1537
       filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
       filemap_fault+0x3fc/0x1280 mm/filemap.c:3433
       bch2_page_fault+0x2cc/0x700 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0x1fc/0x4cc mm/memory.c:5152
       do_read_fault mm/memory.c:5573 [inline]
       do_fault mm/memory.c:5707 [inline]
       do_pte_missing mm/memory.c:4234 [inline]
       handle_pte_fault mm/memory.c:6052 [inline]
       __handle_mm_fault mm/memory.c:6195 [inline]
       handle_mm_fault+0x2c90/0x4d34 mm/memory.c:6364
       do_page_fault+0x57c/0x13cc arch/arm64/mm/fault.c:696
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:789
       do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:929
       el0_da+0x64/0x164 arch/arm64/kernel/entry-common.c:697
       el0t_64_sync_handler+0x90/0x12c arch/arm64/kernel/entry-common.c:901
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #2 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault+0xc4/0x124 mm/memory.c:6958
       _inline_copy_to_user include/linux/uaccess.h:192 [inline]
       copy_to_user include/linux/uaccess.h:223 [inline]
       copy_to_user_errcode fs/bcachefs/util.h:701 [inline]
       bch2_ioctl_read_super fs/bcachefs/chardev.c:611 [inline]
       bch2_fs_ioctl+0xb3c/0x13e0 fs/bcachefs/chardev.c:718
       bch2_fs_file_ioctl+0x4dc/0x1964 fs/bcachefs/fs-ioctl.c:411
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:598 [inline]
       __se_sys_ioctl fs/ioctl.c:584 [inline]
       __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:584
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #1 (&c->sb_lock){+.+.}-{4:4}:
       __mutex_lock_common+0x1d0/0x24ac kernel/locking/mutex.c:598
       __mutex_lock kernel/locking/mutex.c:760 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:812
       __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1129 [inline]
       bch2_trans_mark_dev_sb+0xd8/0x67c fs/bcachefs/buckets.c:1176
       bch2_trans_mark_dev_sbs_flags+0x414/0x47c fs/bcachefs/buckets.c:1186
       bch2_mark_superblocks fs/bcachefs/btree_gc.c:805 [inline]
       bch2_check_allocations+0x52c/0x3c34 fs/bcachefs/btree_gc.c:1089
       bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:484 [inline]
       __bch2_run_recovery_passes+0x2b8/0xd54 fs/bcachefs/recovery_passes.c:539
       bch2_run_recovery_passes+0x174/0x1f4 fs/bcachefs/recovery_passes.c:610
       bch2_fs_recovery+0x1c34/0x2fb4 fs/bcachefs/recovery.c:1016
       bch2_fs_start+0x940/0xbec fs/bcachefs/super.c:1213
       bch2_fs_get_tree+0x880/0x107c fs/bcachefs/fs.c:2488
       vfs_get_tree+0x90/0x28c fs/super.c:1815
       do_new_mount+0x278/0x7f4 fs/namespace.c:3805
       path_mount+0x5b4/0xde0 fs/namespace.c:4120
       do_mount fs/namespace.c:4133 [inline]
       __do_sys_mount fs/namespace.c:4344 [inline]
       __se_sys_mount fs/namespace.c:4321 [inline]
       __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
       el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

-> #0 (bcachefs_btree){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
       trans_set_locked+0x94/0x200 fs/bcachefs/btree_locking.h:206
       bch2_trans_begin+0x800/0xd30 fs/bcachefs/btree_iter.c:3403
       bch2_read_err_msg_trans+0x64/0x298 fs/bcachefs/io_read.c:374
       __bch2_read_extent+0x25f0/0x3638 fs/bcachefs/io_read.c:1070
       bch2_read_extent fs/bcachefs/io_read.h:147 [inline]
       bchfs_read+0x107c/0x17e8 fs/bcachefs/fs-io-buffered.c:226
       bch2_read_single_folio+0x498/0x6e4 fs/bcachefs/fs-io-buffered.c:360
       bch2_read_folio+0x40/0x84 fs/bcachefs/fs-io-buffered.c:378
       filemap_read_folio+0xec/0x2f8 mm/filemap.c:2413
       filemap_fault+0xd48/0x1280 mm/filemap.c:3537
       bch2_page_fault+0x2cc/0x700 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0x1fc/0x4cc mm/memory.c:5152
       do_read_fault mm/memory.c:5573 [inline]
       do_fault mm/memory.c:5707 [inline]
       do_pte_missing mm/memory.c:4234 [inline]
       handle_pte_fault mm/memory.c:6052 [inline]
       __handle_mm_fault mm/memory.c:6195 [inline]
       handle_mm_fault+0x2c90/0x4d34 mm/memory.c:6364
       do_page_fault+0x8a0/0x13cc arch/arm64/mm/fault.c:696
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:789
       do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:929
       el0_da+0x64/0x164 arch/arm64/kernel/entry-common.c:697
       el0t_64_sync_handler+0x90/0x12c arch/arm64/kernel/entry-common.c:901
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596

other info that might help us debug this:

Chain exists of:
  bcachefs_btree --> &mm->mmap_lock --> mapping.invalidate_lock#7

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(mapping.invalidate_lock#7);
                               lock(&mm->mmap_lock);
                               lock(mapping.invalidate_lock#7);
  lock(bcachefs_btree);

 *** DEADLOCK ***

2 locks held by syz.2.330/8664:
 #0: ffff0000c2c65e50 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:472 [inline]
 #0: ffff0000c2c65e50 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/mmap_lock.c:277 [inline]
 #0: ffff0000c2c65e50 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x38/0x2d8 mm/mmap_lock.c:337
 #1: ffff0000f6b182e8 (mapping.invalidate_lock#7){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:934 [inline]
 #1: ffff0000f6b182e8 (mapping.invalidate_lock#7){.+.+}-{4:4}, at: filemap_fault+0x3fc/0x1280 mm/filemap.c:3433

stack backtrace:
CPU: 0 UID: 0 PID: 8664 Comm: syz.2.330 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2043
 check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1774/0x30a4 kernel/locking/lockdep.c:5237
 lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5868
 trans_set_locked+0x94/0x200 fs/bcachefs/btree_locking.h:206
 bch2_trans_begin+0x800/0xd30 fs/bcachefs/btree_iter.c:3403
 bch2_read_err_msg_trans+0x64/0x298 fs/bcachefs/io_read.c:374
 __bch2_read_extent+0x25f0/0x3638 fs/bcachefs/io_read.c:1070
 bch2_read_extent fs/bcachefs/io_read.h:147 [inline]
 bchfs_read+0x107c/0x17e8 fs/bcachefs/fs-io-buffered.c:226
 bch2_read_single_folio+0x498/0x6e4 fs/bcachefs/fs-io-buffered.c:360
 bch2_read_folio+0x40/0x84 fs/bcachefs/fs-io-buffered.c:378
 filemap_read_folio+0xec/0x2f8 mm/filemap.c:2413
 filemap_fault+0xd48/0x1280 mm/filemap.c:3537
 bch2_page_fault+0x2cc/0x700 fs/bcachefs/fs-io-pagecache.c:594
 __do_fault+0x1fc/0x4cc mm/memory.c:5152
 do_read_fault mm/memory.c:5573 [inline]
 do_fault mm/memory.c:5707 [inline]
 do_pte_missing mm/memory.c:4234 [inline]
 handle_pte_fault mm/memory.c:6052 [inline]
 __handle_mm_fault mm/memory.c:6195 [inline]
 handle_mm_fault+0x2c90/0x4d34 mm/memory.c:6364
 do_page_fault+0x8a0/0x13cc arch/arm64/mm/fault.c:696
 do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:789
 do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:929
 el0_da+0x64/0x164 arch/arm64/kernel/entry-common.c:697
 el0t_64_sync_handler+0x90/0x12c arch/arm64/kernel/entry-common.c:901
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
bcachefs (loop2): /file3 offset 0: no_devices_valid
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0
bcachefs (loop2): /file3 offset 0: no_devices_valid
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0
bcachefs (loop2): /file3 offset 0: no_devices_valid
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0
bcachefs (loop2): /file3 offset 0: no_devices_valid
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0
bcachefs (loop2): /file3 offset 0: no_devices_valid
  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 237:893353206280 gen 0


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
