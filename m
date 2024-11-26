Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769318F58
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 00:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732579289; cv=none; b=g06lGQO/cknyzw9HyeGyQvV8FXNBlQJs7OQCEgCj6VB1j+DZNHVHIwXM2Fh7FUp8O4anvXlf3hg/7DL2yjhvXA5XZbqsJmEqXmDtH4G4ds/t+zN7J+wPdL7FWsOB1OEaEv2Krw3OpEiysZ+7MZmytrirvZVKDDgEQXwXhWHXMfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732579289; c=relaxed/simple;
	bh=DK2bV5jFCXcVjvyuFnimur+ALEOOVu406+lRCd4tw/s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZSZRwW3yj592Tr83zdd7IxPDgzqEFTCUKcMMEGlqpO730hv+ZaZy3sQXaOGIbRbLcTucuidZQuBK3CJqpsbqAxK6lLxk+8CgsBvxCknDDQLW1KK2ysc+AhpuqVYKXQLV2pgws8mnW2bs8S1NkWXETlbHpTHB4/Xz2zujFbxcmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a77de12c48so57682915ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 16:01:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732579285; x=1733184085;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Jbd5lguwzQQPqL+OCWKYz4u+DtX3IWw44+ww8J1AmPE=;
        b=KMRJ6a4liwxKBga/YFpWgJV8VwH31S61rS+y3MnU7eHU8zvnUnTYs10XqYbrlE/cZu
         JSoKb48wvtM62kloi6ZLvYot7N7IRfoHJ14LUk5NU8HY7BItNEPXG0Gzx89ASr5REWeK
         DBS69LIcUlJJupIm6TASkgQwROEeIt8HuWpdwsy2L6ukfWQjZ1I0HWKVPfLnah3LtHW9
         RXHuCxV8gR+eP6jAG3B7kIZDVGj+oZZgu3qEvtcPuQeKxF+8/Zy+b/qwGkBNk/qwcz90
         cme7D89rin+w+B3pXBIFGynph+8QshDPyfUDpxOJ8aVpKgKFu3CYeatWpLXyZuzatwFO
         fqtQ==
X-Forwarded-Encrypted: i=1; AJvYcCX40i4WvpoTATVxXhk+UXeNw3HcdH9HOiZ8L/6IALtONrkci+D/6AcgsXj4NbfMjdr9DkdQ2SeCYh9YzdhGKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiAl9gJlNgrNAO+6z3zTxs5oeSzizs+zKwikfH2fGUVBKSkr5U
	+qvUQfnG/vkSaP8LKgliAAbZtZr8RFVfkGH7VHbMQtngr6YYdhdhYvtcv1SVfF0NaDAgIMlEiYL
	c1fW2dmnjLkU1dza/RJMgkHDqCUG3eShAdqALe0hVHxeZx/Pk9yfo0PI=
X-Google-Smtp-Source: AGHT+IFsfRw1otpEhtmlwuyfzIiu3jWSMCC6h/EUwsaQP0P4uva1+QjRCWKpvaP50hCNWR0o/XC2+nMAWmpwCcHIuTk9MJyqA22N
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b21:b0:3a7:6e97:9877 with SMTP id
 e9e14a558f8ab-3a79af9ed3emr145227765ab.24.1732579285581; Mon, 25 Nov 2024
 16:01:25 -0800 (PST)
Date: Mon, 25 Nov 2024 16:01:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67450fd5.050a0220.1286eb.0009.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in __bch2_folio_reservation_get
From: syzbot <syzbot+9784eb115ca16c8cdd1d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    43fb83c17ba2 Merge tag 'soc-arm-6.13' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f6a75f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1638cad79464dac0
dashboard link: https://syzkaller.appspot.com/bug?extid=9784eb115ca16c8cdd1d
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b7a3a910252/disk-43fb83c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/78e328593d54/vmlinux-43fb83c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3dd5bf3f229a/bzImage-43fb83c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9784eb115ca16c8cdd1d@syzkaller.appspotmail.com

bcachefs (loop7): going read-write
bcachefs (loop7): done starting filesystem
======================================================
WARNING: possible circular locking dependency detected
6.12.0-syzkaller-03657-g43fb83c17ba2 #0 Not tainted
------------------------------------------------------
syz.7.1397/14121 is trying to acquire lock:
ffff88803c5049d0 (&c->mark_lock){++++}-{0:0}, at: bch2_disk_reservation_add fs/bcachefs/buckets.h:367 [inline]
ffff88803c5049d0 (&c->mark_lock){++++}-{0:0}, at: __bch2_folio_reservation_get+0x8d9/0xab0 fs/bcachefs/fs-io-pagecache.c:428

but task is already holding lock:
ffff88802940a518 (sb_pagefaults#5){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x380 mm/memory.c:3162

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (sb_pagefaults#5){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1725 [inline]
       sb_start_pagefault include/linux/fs.h:1890 [inline]
       bch2_page_mkwrite+0x2ec/0xec0 fs/bcachefs/fs-io-pagecache.c:614
       do_page_mkwrite+0x17a/0x380 mm/memory.c:3162
       do_shared_fault mm/memory.c:5373 [inline]
       do_fault mm/memory.c:5435 [inline]
       do_pte_missing+0x29e/0x3e70 mm/memory.c:3965
       handle_pte_fault mm/memory.c:5766 [inline]
       __handle_mm_fault+0x100a/0x2a10 mm/memory.c:5909
       handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6077
       do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
       _inline_copy_to_user include/linux/uaccess.h:197 [inline]
       _copy_to_user+0xb6/0xd0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:225 [inline]
       rng_dev_read+0x1f4/0x800 drivers/char/hw_random/core.c:258
       do_loop_readv_writev fs/read_write.c:840 [inline]
       do_loop_readv_writev fs/read_write.c:828 [inline]
       vfs_readv+0x6c2/0x890 fs/read_write.c:1013
       do_preadv+0x1b1/0x270 fs/read_write.c:1125
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       __might_fault mm/memory.c:6716 [inline]
       __might_fault+0x11b/0x190 mm/memory.c:6709
       drm_mode_atomic_ioctl+0x524/0x25d0 drivers/gpu/drm/drm_atomic_uapi.c:1437
       drm_ioctl_kernel+0x1e9/0x3d0 drivers/gpu/drm/drm_ioctl.c:745
       drm_ioctl+0x5d6/0xc00 drivers/gpu/drm/drm_ioctl.c:842
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl fs/ioctl.c:892 [inline]
       __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (crtc_ww_class_mutex){+.+.}-{0:0}:
       ww_acquire_init include/linux/ww_mutex.h:162 [inline]
       drm_modeset_acquire_init+0x234/0x410 drivers/gpu/drm/drm_modeset_lock.c:250
       drmm_mode_config_init+0x10ef/0x1870 drivers/gpu/drm/drm_mode_config.c:453
       vkms_modeset_init drivers/gpu/drm/vkms/vkms_drv.c:156 [inline]
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:217 [inline]
       vkms_init+0x3bc/0x760 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x12b/0x700 init/main.c:1266
       do_initcall_level init/main.c:1328 [inline]
       do_initcalls init/main.c:1344 [inline]
       do_basic_setup init/main.c:1363 [inline]
       kernel_init_freeable+0x5c7/0x900 init/main.c:1577
       kernel_init+0x1c/0x2b0 init/main.c:1466
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #5 (crtc_ww_class_acquire){+.+.}-{0:0}:
       ww_acquire_init include/linux/ww_mutex.h:161 [inline]
       drm_modeset_acquire_init+0x219/0x410 drivers/gpu/drm/drm_modeset_lock.c:250
       drm_client_modeset_commit_atomic+0xc9/0x7f0 drivers/gpu/drm/drm_client_modeset.c:1007
       drm_client_modeset_commit_locked+0x14d/0x580 drivers/gpu/drm/drm_client_modeset.c:1171
       drm_client_modeset_commit+0x4f/0x80 drivers/gpu/drm/drm_client_modeset.c:1197
       __drm_fb_helper_restore_fbdev_mode_unlocked drivers/gpu/drm/drm_fb_helper.c:237 [inline]
       __drm_fb_helper_restore_fbdev_mode_unlocked+0x130/0x180 drivers/gpu/drm/drm_fb_helper.c:216
       drm_fb_helper_set_par+0xd8/0x120 drivers/gpu/drm/drm_fb_helper.c:1345
       fbcon_init+0x883/0x1890 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x320/0x620 drivers/tty/vt/vt.c:1011
       do_bind_con_driver.isra.0+0x57a/0xbf0 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x4f4/0x650 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0xe8/0x210 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x375/0x6a0 drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer+0x466/0x7f0 drivers/video/fbdev/core/fbmem.c:449
       register_framebuffer+0x23/0x40 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0xd56/0x1620 drivers/gpu/drm/drm_fb_helper.c:1869
       drm_fb_helper_initial_config drivers/gpu/drm/drm_fb_helper.c:1934 [inline]
       drm_fb_helper_initial_config+0x44/0x60 drivers/gpu/drm/drm_fb_helper.c:1926
       drm_fbdev_shmem_client_hotplug+0x1a6/0x280 drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x198/0x280 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x184/0x340 drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x62d/0x760 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x12b/0x700 init/main.c:1266
       do_initcall_level init/main.c:1328 [inline]
       do_initcalls init/main.c:1344 [inline]
       do_basic_setup init/main.c:1363 [inline]
       kernel_init_freeable+0x5c7/0x900 init/main.c:1577
       kernel_init+0x1c/0x2b0 init/main.c:1466
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #4 (&client->modeset_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       drm_client_modeset_probe+0x41a/0x3060 drivers/gpu/drm/drm_client_modeset.c:832
       __drm_fb_helper_initial_config_and_unlock+0x131/0x1620 drivers/gpu/drm/drm_fb_helper.c:1846
       drm_fb_helper_initial_config drivers/gpu/drm/drm_fb_helper.c:1934 [inline]
       drm_fb_helper_initial_config+0x44/0x60 drivers/gpu/drm/drm_fb_helper.c:1926
       drm_fbdev_shmem_client_hotplug+0x1a6/0x280 drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x198/0x280 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x184/0x340 drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x62d/0x760 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x12b/0x700 init/main.c:1266
       do_initcall_level init/main.c:1328 [inline]
       do_initcalls init/main.c:1344 [inline]
       do_basic_setup init/main.c:1363 [inline]
       kernel_init_freeable+0x5c7/0x900 init/main.c:1577
       kernel_init+0x1c/0x2b0 init/main.c:1466
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&helper->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       __drm_fb_helper_restore_fbdev_mode_unlocked drivers/gpu/drm/drm_fb_helper.c:228 [inline]
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xb6/0x180 drivers/gpu/drm/drm_fb_helper.c:216
       drm_fb_helper_set_par+0xd8/0x120 drivers/gpu/drm/drm_fb_helper.c:1345
       fbcon_init+0x883/0x1890 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x320/0x620 drivers/tty/vt/vt.c:1011
       do_bind_con_driver.isra.0+0x57a/0xbf0 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x4f4/0x650 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0xe8/0x210 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x375/0x6a0 drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer+0x466/0x7f0 drivers/video/fbdev/core/fbmem.c:449
       register_framebuffer+0x23/0x40 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0xd56/0x1620 drivers/gpu/drm/drm_fb_helper.c:1869
       drm_fb_helper_initial_config drivers/gpu/drm/drm_fb_helper.c:1934 [inline]
       drm_fb_helper_initial_config+0x44/0x60 drivers/gpu/drm/drm_fb_helper.c:1926
       drm_fbdev_shmem_client_hotplug+0x1a6/0x280 drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x198/0x280 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x184/0x340 drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:228 [inline]
       vkms_init+0x62d/0x760 drivers/gpu/drm/vkms/vkms_drv.c:254
       do_one_initcall+0x12b/0x700 init/main.c:1266
       do_initcall_level init/main.c:1328 [inline]
       do_initcalls init/main.c:1344 [inline]
       do_basic_setup init/main.c:1363 [inline]
       kernel_init_freeable+0x5c7/0x900 init/main.c:1577
       kernel_init+0x1c/0x2b0 init/main.c:1466
       ret_from_fork+0x48/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (console_lock){+.+.}-{0:0}:
       console_lock+0x7a/0xa0 kernel/printk/printk.c:2833
       __bch2_print_string_as_lines+0xeb/0x130 fs/bcachefs/util.c:267
       __bch2_fsck_err+0x994/0x1d30 fs/bcachefs/error.c:411
       read_btree_roots fs/bcachefs/recovery.c:523 [inline]
       bch2_fs_recovery+0x2e46/0x4030 fs/bcachefs/recovery.c:853
       bch2_fs_start+0x2e9/0x5f0 fs/bcachefs/super.c:1037
       bch2_fs_get_tree+0x10db/0x16f0 fs/bcachefs/fs.c:2170
       vfs_get_tree+0x92/0x380 fs/super.c:1814
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&c->fsck_error_msgs_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x19b/0xa60 kernel/locking/mutex.c:735
       __bch2_fsck_err+0x34c/0x1d30 fs/bcachefs/error.c:282
       bch2_check_fix_ptr fs/bcachefs/buckets.c:137 [inline]
       bch2_check_fix_ptrs+0x1c1e/0x5230 fs/bcachefs/buckets.c:266
       bch2_trigger_extent+0x5d0/0x740 fs/bcachefs/buckets.c:856
       bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
       bch2_gc_mark_key+0x546/0xe30 fs/bcachefs/btree_gc.c:634
       bch2_gc_btree.constprop.0+0xe5c/0x1320 fs/bcachefs/btree_gc.c:698
       bch2_gc_btrees+0x47c/0xa60 fs/bcachefs/btree_gc.c:729
       bch2_check_allocations+0x55a/0xa30 fs/bcachefs/btree_gc.c:1133
       bch2_run_recovery_pass+0x91/0x1a0 fs/bcachefs/recovery_passes.c:191
       bch2_run_recovery_passes+0x49b/0x780 fs/bcachefs/recovery_passes.c:244
       bch2_fs_recovery+0x2358/0x4030 fs/bcachefs/recovery.c:861
       bch2_fs_start+0x2e9/0x5f0 fs/bcachefs/super.c:1037
       bch2_fs_get_tree+0x10db/0x16f0 fs/bcachefs/fs.c:2170
       vfs_get_tree+0x92/0x380 fs/super.c:1814
       do_new_mount fs/namespace.c:3507 [inline]
       path_mount+0x14e6/0x1f20 fs/namespace.c:3834
       do_mount fs/namespace.c:3847 [inline]
       __do_sys_mount fs/namespace.c:4057 [inline]
       __se_sys_mount fs/namespace.c:4034 [inline]
       __x64_sys_mount+0x294/0x320 fs/namespace.c:4034
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&c->mark_lock){++++}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain kernel/locking/lockdep.c:3904 [inline]
       __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
       lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __bch2_disk_reservation_add+0xd2/0xd10 fs/bcachefs/buckets.c:1170
       bch2_disk_reservation_add fs/bcachefs/buckets.h:367 [inline]
       __bch2_folio_reservation_get+0x8d9/0xab0 fs/bcachefs/fs-io-pagecache.c:428
       bch2_folio_reservation_get fs/bcachefs/fs-io-pagecache.c:477 [inline]
       bch2_page_mkwrite+0xc4f/0xec0 fs/bcachefs/fs-io-pagecache.c:637
       do_page_mkwrite+0x17a/0x380 mm/memory.c:3162
       do_shared_fault mm/memory.c:5373 [inline]
       do_fault mm/memory.c:5435 [inline]
       do_pte_missing+0x29e/0x3e70 mm/memory.c:3965
       handle_pte_fault mm/memory.c:5766 [inline]
       __handle_mm_fault+0x100a/0x2a10 mm/memory.c:5909
       handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6077
       do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
       raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
       _inline_copy_to_user include/linux/uaccess.h:197 [inline]
       _copy_to_user+0xb6/0xd0 lib/usercopy.c:26
       copy_to_user include/linux/uaccess.h:225 [inline]
       rng_dev_read+0x1f4/0x800 drivers/char/hw_random/core.c:258
       do_loop_readv_writev fs/read_write.c:840 [inline]
       do_loop_readv_writev fs/read_write.c:828 [inline]
       vfs_readv+0x6c2/0x890 fs/read_write.c:1013
       do_preadv+0x1b1/0x270 fs/read_write.c:1125
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &c->mark_lock --> &mm->mmap_lock --> sb_pagefaults#5

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults#5);
                               lock(&mm->mmap_lock);
                               lock(sb_pagefaults#5);
  rlock(&c->mark_lock);

 *** DEADLOCK ***

2 locks held by syz.7.1397/14121:
 #0: ffff88807ec2c620 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_trylock include/linux/mmap_lock.h:163 [inline]
 #0: ffff88807ec2c620 (&mm->mmap_lock){++++}-{4:4}, at: get_mmap_lock_carefully mm/memory.c:6114 [inline]
 #0: ffff88807ec2c620 (&mm->mmap_lock){++++}-{4:4}, at: lock_mm_and_find_vma+0x35/0x6a0 mm/memory.c:6174
 #1: ffff88802940a518 (sb_pagefaults#5){.+.+}-{0:0}, at: do_page_mkwrite+0x17a/0x380 mm/memory.c:3162

stack backtrace:
CPU: 1 UID: 0 PID: 14121 Comm: syz.7.1397 Not tainted 6.12.0-syzkaller-03657-g43fb83c17ba2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x419/0x5d0 kernel/locking/lockdep.c:2074
 check_noncircular+0x31a/0x400 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain kernel/locking/lockdep.c:3904 [inline]
 __lock_acquire+0x249e/0x3c40 kernel/locking/lockdep.c:5226
 lock_acquire.part.0+0x11b/0x380 kernel/locking/lockdep.c:5849
 percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
 __bch2_disk_reservation_add+0xd2/0xd10 fs/bcachefs/buckets.c:1170
 bch2_disk_reservation_add fs/bcachefs/buckets.h:367 [inline]
 __bch2_folio_reservation_get+0x8d9/0xab0 fs/bcachefs/fs-io-pagecache.c:428
 bch2_folio_reservation_get fs/bcachefs/fs-io-pagecache.c:477 [inline]
 bch2_page_mkwrite+0xc4f/0xec0 fs/bcachefs/fs-io-pagecache.c:637
 do_page_mkwrite+0x17a/0x380 mm/memory.c:3162
 do_shared_fault mm/memory.c:5373 [inline]
 do_fault mm/memory.c:5435 [inline]
 do_pte_missing+0x29e/0x3e70 mm/memory.c:3965
 handle_pte_fault mm/memory.c:5766 [inline]
 __handle_mm_fault+0x100a/0x2a10 mm/memory.c:5909
 handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6077
 do_user_addr_fault+0x7a3/0x13f0 arch/x86/mm/fault.c:1389
 handle_page_fault arch/x86/mm/fault.c:1481 [inline]
 exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1539
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
RIP: 0010:copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
RIP: 0010:raw_copy_to_user arch/x86/include/asm/uaccess_64.h:147 [inline]
RIP: 0010:_inline_copy_to_user include/linux/uaccess.h:197 [inline]
RIP: 0010:_copy_to_user+0xb6/0xd0 lib/usercopy.c:26
Code: 89 ee 48 89 ef e8 6a 05 fd fc 4d 85 ff 75 a8 e8 b0 03 fd fc 89 de 4c 89 e7 e8 76 24 5e fd 0f 01 cb 48 89 d9 48 89 ef 4c 89 e6 <f3> a4 0f 1f 00 0f 01 ca 48 89 cb eb 80 66 2e 0f 1f 84 00 00 00 00
RSP: 0018:ffffc90004d07b30 EFLAGS: 00050246
RAX: 0000000000000001 RBX: 0000000000000040 RCX: 0000000000000040
RDX: fffff520009a0f7f RSI: ffffc90004d07bb8 RDI: 000000002000b241
RBP: 000000002000b241 R08: 0000000000000000 R09: fffff520009a0f7e
R10: ffffc90004d07bf7 R11: 0000000000000000 R12: ffffc90004d07bb8
R13: 000000002000b281 R14: 00007fffffffefff R15: 0000000000000000
 copy_to_user include/linux/uaccess.h:225 [inline]
 rng_dev_read+0x1f4/0x800 drivers/char/hw_random/core.c:258
 do_loop_readv_writev fs/read_write.c:840 [inline]
 do_loop_readv_writev fs/read_write.c:828 [inline]
 vfs_readv+0x6c2/0x890 fs/read_write.c:1013
 do_preadv+0x1b1/0x270 fs/read_write.c:1125
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3a1357e819
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3a143a6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000127
RAX: ffffffffffffffda RBX: 00007f3a13735fa0 RCX: 00007f3a1357e819
RDX: 0000000000000001 RSI: 0000000020000580 RDI: 000000000000000b
RBP: 00007f3a135f175e R08: 0000000000000000 R09: 0000000000000000
R10: 00000000fffffff8 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f3a13735fa0 R15: 00007fffd1526618
 </TASK>
----------------
Code disassembly (best guess):
   0:	89 ee                	mov    %ebp,%esi
   2:	48 89 ef             	mov    %rbp,%rdi
   5:	e8 6a 05 fd fc       	call   0xfcfd0574
   a:	4d 85 ff             	test   %r15,%r15
   d:	75 a8                	jne    0xffffffb7
   f:	e8 b0 03 fd fc       	call   0xfcfd03c4
  14:	89 de                	mov    %ebx,%esi
  16:	4c 89 e7             	mov    %r12,%rdi
  19:	e8 76 24 5e fd       	call   0xfd5e2494
  1e:	0f 01 cb             	stac
  21:	48 89 d9             	mov    %rbx,%rcx
  24:	48 89 ef             	mov    %rbp,%rdi
  27:	4c 89 e6             	mov    %r12,%rsi
* 2a:	f3 a4                	rep movsb %ds:(%rsi),%es:(%rdi) <-- trapping instruction
  2c:	0f 1f 00             	nopl   (%rax)
  2f:	0f 01 ca             	clac
  32:	48 89 cb             	mov    %rcx,%rbx
  35:	eb 80                	jmp    0xffffffb7
  37:	66                   	data16
  38:	2e                   	cs
  39:	0f                   	.byte 0xf
  3a:	1f                   	(bad)
  3b:	84 00                	test   %al,(%rax)
  3d:	00 00                	add    %al,(%rax)


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
