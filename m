Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DC522C6C5
	for <linux-bcachefs@vger.kernel.org>; Sat,  7 Dec 2024 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733585727; cv=none; b=Tfk1xY/xeuz8TKW8Eje4xv8W0zwK99AwP848k8oeoCkBjaxCp7feUn6PzUEdTQXB9qwr8d6I7M9rvyTMZxpoyAwU+Xreo/y5MEEMfUAaAR0emO96yLCRQH4tnyTRTNm7dnyWXn14VN6aFpuPuA/AS+93h459ZGW58exP8yyDsng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733585727; c=relaxed/simple;
	bh=s2SCfEm1LgqcbPSUt0+EhxV2wa96dK80wzsh1usPJng=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=i6or3dl5SObHssRwEEUvWr3m5sos0zIcPS9WX9FBSE/jB8IzidzgEiDdM+q32kTwtxOurjDKNnG3rPslfolaL5DlmjCcCMCC6tVzZ1bMj0HN8fPxFMuUvleVPJZstn9abfPhWWhCvqxYOG6skzQ2KAPMVmDlFg5+eteBEPtGPpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a811c18855so19865105ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 07 Dec 2024 07:35:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733585724; x=1734190524;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c+z0/PQ5AYnouHdZso5mFn1Prprug/Y/RXiw7P2HQS8=;
        b=COAm44nYLhuTEAv8lBnKyuyj7hWUuslAnu+pmSi4W49BI6xnmMVOGv1yMPDjsjRy24
         FrYFcSC72UC2rKC3dFQISmyBjRNQREFpyZpoRqBa9sB3ErMNMEz3W0qDvMBUymbGgSRE
         tP+Q7bffkweSPhU1nN5xvm100Jr88t+9rruqnTyOYpptiC5N5rfVJttDbus795vm0JbU
         JhlCB0W5EKMAacETZEDE11nlwpOVfxXZXUmxbWsCGq0qrimch+HG/WK4mLH0lVBH0LiI
         ox1KDmMztUCPHtHZ23Y0tdB+uLSpfAcVjHTgGwAMy1HAbi+F0vX1pEdUI3ePqD/aLyUT
         afsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW9UzxWBxPKE3Vbvsj471/6FnkDVSYyeax/p70WXGqQtDeK1UkZoQYr11/UNcqTFXzew8BdhcPn5njUH4QGzQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzDS6ggFUI8TDRHPHT7A0YEsrlVDGt5MVAPu20cdmF3prTfRLna
	BacppChTmQV6UJJgVzbF39RUjwC+pmOSPitO+k9i63ZUsKQYe/XqMWsfKcgLhG7vx6Dr5k0oFAJ
	1k19dC87k6Wj9bYyye2tzUn4XZyp1zIa7PJqS/Ws5S/FMzEdmgBZvMBY=
X-Google-Smtp-Source: AGHT+IFxsFBIrLuEDWsXXzUUIAu3WJoEJYuFqF7DRHb1ZDA1p+H0tZQGoCCk2x57cHmCbksPlniIIa3D3fgBXzxIjRSQmHuPwf43
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168a:b0:3a7:e528:6ee6 with SMTP id
 e9e14a558f8ab-3a811dbbe4cmr68278935ab.13.1733585724342; Sat, 07 Dec 2024
 07:35:24 -0800 (PST)
Date: Sat, 07 Dec 2024 07:35:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67546b3c.050a0220.a30f1.0155.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in __bch2_fsck_err
From: syzbot <syzbot+38641fcbda1aaffefdd4@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7b1d1d4cfac0 Merge remote-tracking branch 'iommu/arm/smmu'..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=13254330580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9bc44a6de1ceb5d6
dashboard link: https://syzkaller.appspot.com/bug?extid=38641fcbda1aaffefdd4
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/4d4a0162c7c3/disk-7b1d1d4c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a8c47a4be472/vmlinux-7b1d1d4c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0e173b91f83e/Image-7b1d1d4c.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+38641fcbda1aaffefdd4@syzkaller.appspotmail.com

  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-g7b1d1d4cfac0 #0 Not tainted
------------------------------------------------------
syz.2.179/7607 is trying to acquire lock:
ffff0000e0661548 (&c->fsck_error_msgs_lock){+.+.}-{3:3}, at: __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282

but task is already holding lock:
ffff0000e06049d0 (&c->mark_lock){++++}-{0:0}, at: bch2_check_fix_ptrs+0x2dc/0x515c fs/bcachefs/buckets.c:263

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (&c->mark_lock){++++}-{0:0}:
       percpu_down_read+0x5c/0x2e8 include/linux/percpu-rwsem.h:51
       __bch2_disk_reservation_add+0xc4/0x9f4 fs/bcachefs/buckets.c:1170
       bch2_disk_reservation_add+0x29c/0x4f4 fs/bcachefs/buckets.h:367
       __bch2_folio_reservation_get+0x2dc/0x798 fs/bcachefs/fs-io-pagecache.c:428
       bch2_folio_reservation_get fs/bcachefs/fs-io-pagecache.c:477 [inline]
       bch2_page_mkwrite+0xa70/0xe44 fs/bcachefs/fs-io-pagecache.c:637
       do_page_mkwrite+0x140/0x2dc mm/memory.c:3162
       do_shared_fault mm/memory.c:5373 [inline]
       do_fault mm/memory.c:5435 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault mm/memory.c:5766 [inline]
       __handle_mm_fault+0x1e1c/0x66e8 mm/memory.c:5909
       handle_mm_fault+0x29c/0x8b4 mm/memory.c:6077
       do_page_fault+0x570/0x10a8 arch/arm64/mm/fault.c:690
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:604
       el0t_64_sync_handler+0xcc/0x108 arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #6 (sb_pagefaults#3){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1716 [inline]
       sb_start_pagefault include/linux/fs.h:1881 [inline]
       bch2_page_mkwrite+0x280/0xe44 fs/bcachefs/fs-io-pagecache.c:614
       do_page_mkwrite+0x140/0x2dc mm/memory.c:3162
       do_shared_fault mm/memory.c:5373 [inline]
       do_fault mm/memory.c:5435 [inline]
       do_pte_missing mm/memory.c:3965 [inline]
       handle_pte_fault mm/memory.c:5766 [inline]
       __handle_mm_fault+0x1e1c/0x66e8 mm/memory.c:5909
       handle_mm_fault+0x29c/0x8b4 mm/memory.c:6077
       do_page_fault+0x570/0x10a8 arch/arm64/mm/fault.c:690
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:783
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:919
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:604
       el0t_64_sync_handler+0xcc/0x108 arch/arm64/kernel/entry-common.c:765
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #5 (&mm->mmap_lock){++++}-{3:3}:
       __might_fault+0xc4/0x124 mm/memory.c:6716
       drm_mode_atomic_ioctl+0x52c/0x13d4 drivers/gpu/drm/drm_atomic_uapi.c:1437
       drm_ioctl_kernel+0x26c/0x368 drivers/gpu/drm/drm_ioctl.c:745
       drm_ioctl+0x624/0xb14 drivers/gpu/drm/drm_ioctl.c:842
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:907 [inline]
       __se_sys_ioctl fs/ioctl.c:893 [inline]
       __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #4 (crtc_ww_class_acquire){+.+.}-{0:0}:
       ww_acquire_init include/linux/ww_mutex.h:149 [inline]
       drm_modeset_acquire_init+0x194/0x330 drivers/gpu/drm/drm_modeset_lock.c:250
       drm_client_modeset_commit_atomic+0xe0/0x730 drivers/gpu/drm/drm_client_modeset.c:1007
       drm_client_modeset_commit_locked+0xd0/0x4a8 drivers/gpu/drm/drm_client_modeset.c:1171
       drm_client_modeset_commit+0x50/0x7c drivers/gpu/drm/drm_client_modeset.c:1197
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xd4/0x178 drivers/gpu/drm/drm_fb_helper.c:237
       drm_fb_helper_set_par+0xc4/0x110 drivers/gpu/drm/drm_fb_helper.c:1345
       fbcon_init+0xf34/0x1eb8 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x27c/0x548 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x7dc/0xe04 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x4ac/0x5f0 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0x158/0x260 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x370/0x4ec drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x470/0x610 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x13b0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1869
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1934
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x24c/0x9c0 init/main.c:1269
       do_initcall_level+0x154/0x214 init/main.c:1331
       do_initcalls+0x58/0xac init/main.c:1347
       do_basic_setup+0x8c/0xa0 init/main.c:1366
       kernel_init_freeable+0x324/0x478 init/main.c:1580
       kernel_init+0x24/0x2a0 init/main.c:1469
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #3 (&client->modeset_mutex){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       drm_client_modeset_probe+0x318/0x3f78 drivers/gpu/drm/drm_client_modeset.c:832
       __drm_fb_helper_initial_config_and_unlock+0xf0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1846
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1934
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x24c/0x9c0 init/main.c:1269
       do_initcall_level+0x154/0x214 init/main.c:1331
       do_initcalls+0x58/0xac init/main.c:1347
       do_basic_setup+0x8c/0xa0 init/main.c:1366
       kernel_init_freeable+0x324/0x478 init/main.c:1580
       kernel_init+0x24/0x2a0 init/main.c:1469
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #2 (&helper->lock){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xb4/0x178 drivers/gpu/drm/drm_fb_helper.c:228
       drm_fb_helper_set_par+0xc4/0x110 drivers/gpu/drm/drm_fb_helper.c:1345
       fbcon_init+0xf34/0x1eb8 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x27c/0x548 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x7dc/0xe04 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x4ac/0x5f0 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0x158/0x260 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x370/0x4ec drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x470/0x610 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x13b0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1869
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1934
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x24c/0x9c0 init/main.c:1269
       do_initcall_level+0x154/0x214 init/main.c:1331
       do_initcalls+0x58/0xac init/main.c:1347
       do_basic_setup+0x8c/0xa0 init/main.c:1366
       kernel_init_freeable+0x324/0x478 init/main.c:1580
       kernel_init+0x24/0x2a0 init/main.c:1469
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:862

-> #1 (console_lock){+.+.}-{0:0}:
       console_lock+0x19c/0x1f4 kernel/printk/printk.c:2808
       __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
       bch2_print_string_as_lines+0x2c/0xd4 fs/bcachefs/util.c:286
       __bch2_fsck_err+0x1864/0x2544 fs/bcachefs/error.c:411
       __btree_err+0x7bc/0xb04 fs/bcachefs/btree_io.c:582
       validate_bset_keys+0xbc4/0x1204 fs/bcachefs/btree_io.c:930
       bch2_btree_node_read_done+0x1a68/0x4b78 fs/bcachefs/btree_io.c:1130
       btree_node_read_work+0x50c/0xe08 fs/bcachefs/btree_io.c:1323
       bch2_btree_node_read+0x1f3c/0x27f8 fs/bcachefs/btree_io.c:1708
       __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
       bch2_btree_root_read+0x2b0/0x40c fs/bcachefs/btree_io.c:1771
       read_btree_roots+0x24c/0x794 fs/bcachefs/recovery.c:523
       bch2_fs_recovery+0x328c/0x55dc fs/bcachefs/recovery.c:853
       bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1037
       bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:2170
       vfs_get_tree+0x90/0x28c fs/super.c:1814
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

-> #0 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
       bch2_check_fix_ptr fs/bcachefs/buckets.c:137 [inline]
       bch2_check_fix_ptrs+0x19f0/0x515c fs/bcachefs/buckets.c:266
       bch2_trigger_extent+0x71c/0x814 fs/bcachefs/buckets.c:856
       bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
       bch2_gc_mark_key+0x4b4/0xb70 fs/bcachefs/btree_gc.c:634
       bch2_gc_btree fs/bcachefs/btree_gc.c:698 [inline]
       bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
       bch2_check_allocations+0x1574/0x48f4 fs/bcachefs/btree_gc.c:1133
       bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
       bch2_run_recovery_passes+0x30c/0x73c fs/bcachefs/recovery_passes.c:244
       bch2_fs_recovery+0x32d8/0x55dc fs/bcachefs/recovery.c:861
       bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1037
       bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:2170
       vfs_get_tree+0x90/0x28c fs/super.c:1814
       do_new_mount+0x278/0x900 fs/namespace.c:3507
       path_mount+0x590/0xe04 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
       el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

other info that might help us debug this:

Chain exists of:
  &c->fsck_error_msgs_lock --> sb_pagefaults#3 --> &c->mark_lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&c->mark_lock);
                               lock(sb_pagefaults#3);
                               lock(&c->mark_lock);
  lock(&c->fsck_error_msgs_lock);

 *** DEADLOCK ***

5 locks held by syz.2.179/7607:
 #0: ffff0000e0600278 (&c->state_lock){+.+.}-{3:3}, at: bch2_fs_start+0x50/0x53c fs/bcachefs/super.c:1007
 #1: ffff0000e06266d0 (&c->gc_lock){++++}-{3:3}, at: bch2_check_allocations+0x1a0/0x48f4 fs/bcachefs/btree_gc.c:1115
 #2: ffff0000e0604398 (&c->btree_trans_barrier){.+.+}-{0:0}, at: srcu_lock_acquire+0x18/0x54 include/linux/srcu.h:150
 #3: ffff0000f02cc128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked+0x5c/0x1a4 fs/bcachefs/btree_locking.h:193
 #4: ffff0000e06049d0 (&c->mark_lock){++++}-{0:0}, at: bch2_check_fix_ptrs+0x2dc/0x515c fs/bcachefs/buckets.c:263

stack backtrace:
CPU: 1 UID: 0 PID: 7607 Comm: syz.2.179 Not tainted 6.12.0-syzkaller-g7b1d1d4cfac0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:484 (C)
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 print_circular_bug+0x154/0x1c0 kernel/locking/lockdep.c:2074
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x33f8/0x77c8 kernel/locking/lockdep.c:5202
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5825
 __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
 __mutex_lock kernel/locking/mutex.c:752 [inline]
 mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
 __bch2_fsck_err+0x344/0x2544 fs/bcachefs/error.c:282
 bch2_check_fix_ptr fs/bcachefs/buckets.c:137 [inline]
 bch2_check_fix_ptrs+0x19f0/0x515c fs/bcachefs/buckets.c:266
 bch2_trigger_extent+0x71c/0x814 fs/bcachefs/buckets.c:856
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_gc_mark_key+0x4b4/0xb70 fs/bcachefs/btree_gc.c:634
 bch2_gc_btree fs/bcachefs/btree_gc.c:698 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1574/0x48f4 fs/bcachefs/btree_gc.c:1133
 bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x30c/0x73c fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x32d8/0x55dc fs/bcachefs/recovery.c:861
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x28c fs/super.c:1814
 do_new_mount+0x278/0x900 fs/namespace.c:3507
 path_mount+0x590/0xe04 fs/namespace.c:3834
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount fs/namespace.c:4034 [inline]
 __arm64_sys_mount+0x4d4/0x5ac fs/namespace.c:4034
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
bucket 0:38 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
bucket 0:41 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
bucket 0:35 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 16 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
bucket 0:32 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb written 16 min_key POS_MIN durability: 1 ptr: 0:32:0 gen 0, fixing
btree ptr not marked in member info btree allocated bitmap
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 21 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
bucket 0:29 data type btree ptr gen 0 missing in alloc btree
while marking u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq e81e1ed936acf3df written 21 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0, fixing
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
bucket 0:11 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:12 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:12 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:13 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:13 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:14 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:14 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:15 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:15 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:16 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:16 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:17 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:17 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:18 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:18 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:19 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:19 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:20 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:20 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:21 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:21 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:22 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:22 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:23 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:23 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:24 gen 0 has wrong data_type: got free, should be journal, fixing
bucket 0:24 gen 0 data type journal has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:29 gen 0 has wrong data_type: got free, should be btree, fixing
bucket 0:29 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:32 gen 0 has wrong data_type: got free, should be btree, fixing
bucket 0:32 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:35 gen 0 has wrong data_type: got free, should be btree, fixing
bucket 0:35 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:38 gen 0 has wrong data_type: got free, should be btree, fixing
bucket 0:38 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:41 gen 0 has wrong data_type: got free, should be btree, fixing
bucket 0:41 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:120 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:120 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:121 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:121 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:122 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:122 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:123 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:123 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:124 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:124 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:125 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:125 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:126 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:126 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
bucket 0:127 gen 0 has wrong data_type: got free, should be sb, fixing
bucket 0:127 gen 0 data type sb has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop2): going read-write
bcachefs (loop2): journal_replay...
 done
bcachefs (loop2): check_inodes...
inode points to missing dirent
inum: 536870913:4294967295 
  mode=100755
  flags=(15300000)
  journal_seq=5
  hash_seed=b68791a594a6d5ae
  hash_type=siphash
  bi_size=9000
  bi_sectors=24
  bi_version=0
  bi_atime=2780562352
  bi_ctime=2780562352
  bi_mtime=2780562352
  bi_otime=2780562352
  bi_uid=0
  bi_gid=0
  bi_nlink=1
  bi_generation=0
  bi_dev=0
  bi_data_checksum=0
  bi_compression=0
  bi_project=0
  bi_background_compression=0
  bi_data_replicas=0
  bi_promote_target=0
  bi_foreground_target=0
  bi_background_target=0
  bi_erasure_code=0
  bi_fields_set=0
  bi_dir=4096
  bi_dir_offset=1896155912177158345
  bi_subvol=0
  bi_parent_subvol=0
  bi_nocow=0, fixing
 done
bcachefs (loop2): resume_logged_ops... done
bcachefs (loop2): delete_dead_inodes... done
bcachefs (loop2): done starting filesystem
bcachefs (loop2): going read-only
bcachefs (loop2): finished waiting for writes to stop
bcachefs (loop2): flushing journal and stopping allocators, journal seq 22
bcachefs (loop2): flushing journal and stopping allocators complete, journal seq 22
bcachefs (loop2): unshutdown complete, journal seq 22
bcachefs (loop2): done going read-only, filesystem not clean


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
