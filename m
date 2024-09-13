Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DC31B9847
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 07:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726214185; cv=none; b=I5CVyMHIy337LHvtNudgOWsENnTm8EROu6TZ8luWHDVoPmaYtSvpwfaID5/I44gfGh88MWq+1fBG2JNchobHQ1pfe8O3lu7X0pphpc+CFOSdCQ53jhoNARFTLlRps1tXj84xDuhebEg4uZLAmq1SFAM4hZ7g58a90XXf9z/AlV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726214185; c=relaxed/simple;
	bh=Yr15QIpfWky/dO4ozVU+9HdXHVnzFH4ouDka0JUIMho=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=DIPTeNlW/yoUp48Zw5aWDh9PGhKBMLQ5Q+jvzSy0yJmwXH+9XP91fD3oKJIh8hLMbG/6cjFoiIhGDFW6cOOe+Ya42T1Urr8MZJd+a1b9CUjv52cuaps/6TSymI+BVS0Z3/5GHiAlP/SB2pDAUgainCCTwf/CvmTEVtRU2LcvZdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-82cf28c74efso284375239f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Sep 2024 00:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726214182; x=1726818982;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wR1dDFeVxqrZHDmc0WK8bj1YWPlnns9AFO3OMyZOfkk=;
        b=Y/+wPydt+QilPJWYrXAa3hxxIGWm6kkZ1Rw4u7tqXFhXR/WDOairjzddOOMT9WlCaF
         2+ejIjCmQT5765TIYoP+e4kAmR9KB7t9xHPXXNCbSuug44SfsTAu0OQyNWoqRRHzna4r
         lMmsTk4xtNV5p6oXOCvueUnno4c5Xv2kCBRuSuxVC3MTQxO9k0ZQFL7h95R9d+ChyXJ/
         rB9rRmV8hau1HCJRgmuO7J9NIXYtI99W194O0+LLbcMrkwAnGRumKGYxEpLfPi15eqw9
         ZyG2NJPZSS7TBnoxOoeiol2K1eG7v+jvRN7nQzRPAB8kom2bkBykdxFe9GJUpeYXQD6k
         TUsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVotLJcXn6o+1sgt1zKweALR+G9Y1XAiBdDPV4Ud8Gon9aBBkgnbfSq9qGh2+NR0MDP31ps/38aXQFaRI/dA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxYPfcHjNkbTElAa/6ipiLD0T0HzBHbTR3O6qh9dUqp70auCssW
	lZrrXV1edvtoZ5PIcWcrz910zMchfl+G5KYKM1MpcYdmxs8ig0q7jeYGBlD5zOlwPUoJAk+bFZu
	+0UhaWH/YpQb47y2qrJQywIXysQSs5OVHXU4my50ypG6znOB8caKgi9s=
X-Google-Smtp-Source: AGHT+IEOj4to+uwsfvAdfcWGPQJtpF20/EV9wy3ou0+U3F3VoIh89jZSHqHmFuDuRelv/uU0g6w0+AzzUevT0gNnHQOSNXej9YOQ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2dc5:b0:82c:f172:6f07 with SMTP id
 ca18e2360f4ac-82d1f984e7amr664503039f.14.1726214182269; Fri, 13 Sep 2024
 00:56:22 -0700 (PDT)
Date: Fri, 13 Sep 2024 00:56:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002408bb0621fb8f8b@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in __bch2_disk_reservation_add
From: syzbot <syzbot+089ffc4307915afa0da7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    df54f4a16f82 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=123907c7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dde5a5ba8d41ee9e
dashboard link: https://syzkaller.appspot.com/bug?extid=089ffc4307915afa0da7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/aa2eb06e0aea/disk-df54f4a1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/14728733d385/vmlinux-df54f4a1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/99816271407d/Image-df54f4a1.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+089ffc4307915afa0da7@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc5-syzkaller-gdf54f4a16f82 #0 Not tainted
------------------------------------------------------
syz.0.428/9213 is trying to acquire lock:
ffff0000f4c84990 (&c->mark_lock){++++}-{0:0}, at: __bch2_disk_reservation_add+0xc4/0x99c fs/bcachefs/buckets.c:1158

but task is already holding lock:
ffff0000d464a518 (sb_pagefaults#2){.+.+}-{0:0}, at: do_page_mkwrite+0x140/0x2dc mm/memory.c:3142

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #7 (sb_pagefaults#2){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1675 [inline]
       sb_start_pagefault include/linux/fs.h:1840 [inline]
       bch2_page_mkwrite+0x280/0xe54 fs/bcachefs/fs-io-pagecache.c:614
       do_page_mkwrite+0x140/0x2dc mm/memory.c:3142
       do_shared_fault mm/memory.c:5133 [inline]
       do_fault mm/memory.c:5195 [inline]
       do_pte_missing mm/memory.c:3947 [inline]
       handle_pte_fault+0x11d4/0x56f4 mm/memory.c:5521
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0xe38/0x1460 mm/memory.c:5832
       do_page_fault+0x428/0xb1c arch/arm64/mm/fault.c:613
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:690
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:826
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
       el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #6 (&mm->mmap_lock){++++}-{3:3}:
       __might_fault+0xc4/0x124 mm/memory.c:6387
       _inline_copy_to_user include/linux/uaccess.h:176 [inline]
       copy_to_user include/linux/uaccess.h:207 [inline]
       drm_mode_getconnector+0xaa4/0x1214 drivers/gpu/drm/drm_connector.c:3185
       drm_ioctl_kernel+0x26c/0x368 drivers/gpu/drm/drm_ioctl.c:745
       drm_ioctl+0x5e4/0xae4 drivers/gpu/drm/drm_ioctl.c:842
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:907 [inline]
       __se_sys_ioctl fs/ioctl.c:893 [inline]
       __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #5 (&dev->mode_config.mutex){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       drm_client_modeset_probe+0x32c/0x3f78 drivers/gpu/drm/drm_client_modeset.c:834
       __drm_fb_helper_initial_config_and_unlock+0xf0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1852
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1940
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:226 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:252
       do_one_initcall+0x24c/0x9c0 init/main.c:1267
       do_initcall_level+0x154/0x214 init/main.c:1329
       do_initcalls+0x58/0xac init/main.c:1345
       do_basic_setup+0x8c/0xa0 init/main.c:1364
       kernel_init_freeable+0x324/0x478 init/main.c:1578
       kernel_init+0x24/0x2a0 init/main.c:1467
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #4 (&client->modeset_mutex){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       drm_client_modeset_probe+0x318/0x3f78 drivers/gpu/drm/drm_client_modeset.c:832
       __drm_fb_helper_initial_config_and_unlock+0xf0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1852
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1940
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:226 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:252
       do_one_initcall+0x24c/0x9c0 init/main.c:1267
       do_initcall_level+0x154/0x214 init/main.c:1329
       do_initcalls+0x58/0xac init/main.c:1345
       do_basic_setup+0x8c/0xa0 init/main.c:1364
       kernel_init_freeable+0x324/0x478 init/main.c:1578
       kernel_init+0x24/0x2a0 init/main.c:1467
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #3 (&helper->lock){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xb4/0x178 drivers/gpu/drm/drm_fb_helper.c:235
       drm_fb_helper_set_par+0xc4/0x110 drivers/gpu/drm/drm_fb_helper.c:1351
       fbcon_init+0xf34/0x1eb8 drivers/video/fbdev/core/fbcon.c:1093
       visual_init+0x27c/0x548 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x7dc/0xe04 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x4ac/0x5f0 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0x158/0x260 drivers/video/fbdev/core/fbcon.c:531
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2968 [inline]
       fbcon_fb_registered+0x370/0x4ec drivers/video/fbdev/core/fbcon.c:2988
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x470/0x610 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x13b0/0x19a4 drivers/gpu/drm/drm_fb_helper.c:1875
       drm_fb_helper_initial_config+0x48/0x64 drivers/gpu/drm/drm_fb_helper.c:1940
       drm_fbdev_shmem_client_hotplug+0x158/0x22c drivers/gpu/drm/drm_fbdev_shmem.c:250
       drm_client_register+0x144/0x1e0 drivers/gpu/drm/drm_client.c:141
       drm_fbdev_shmem_setup+0x11c/0x2cc drivers/gpu/drm/drm_fbdev_shmem.c:309
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:226 [inline]
       vkms_init+0x4f0/0x600 drivers/gpu/drm/vkms/vkms_drv.c:252
       do_one_initcall+0x24c/0x9c0 init/main.c:1267
       do_initcall_level+0x154/0x214 init/main.c:1329
       do_initcalls+0x58/0xac init/main.c:1345
       do_basic_setup+0x8c/0xa0 init/main.c:1364
       kernel_init_freeable+0x324/0x478 init/main.c:1578
       kernel_init+0x24/0x2a0 init/main.c:1467
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

-> #2 (console_lock){+.+.}-{0:0}:
       console_lock+0x19c/0x1f4 kernel/printk/printk.c:2735
       __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
       bch2_print_string_as_lines+0x2c/0xd4 fs/bcachefs/util.c:286
       __bch2_fsck_err+0x16c0/0x278c fs/bcachefs/error.c:388
       __bch2_bkey_fsck_err+0x7b0/0xea8 fs/bcachefs/error.c:436
       bch2_alloc_v4_validate+0x9c4/0xd24
       bch2_bkey_val_validate+0x114/0x1dc fs/bcachefs/bkey_methods.c:143
       bch2_btree_node_read_done+0x36ec/0x4ab4 fs/bcachefs/btree_io.c:1219
       btree_node_read_work+0x50c/0xe04 fs/bcachefs/btree_io.c:1323
       bch2_btree_node_read+0x1f50/0x280c fs/bcachefs/btree_io.c:1708
       __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
       bch2_btree_root_read+0x2b0/0x53c fs/bcachefs/btree_io.c:1773
       read_btree_roots+0x250/0x798 fs/bcachefs/recovery.c:523
       bch2_fs_recovery+0x3278/0x5514 fs/bcachefs/recovery.c:851
       bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1036
       bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:1946
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3472
       path_mount+0x590/0xe04 fs/namespace.c:3799
       do_mount fs/namespace.c:3812 [inline]
       __do_sys_mount fs/namespace.c:4020 [inline]
       __se_sys_mount fs/namespace.c:3997 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #1 (&c->fsck_error_msgs_lock){+.+.}-{3:3}:
       __mutex_lock_common+0x190/0x21a0 kernel/locking/mutex.c:608
       __mutex_lock kernel/locking/mutex.c:752 [inline]
       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:804
       __bch2_fsck_err+0x344/0x278c fs/bcachefs/error.c:267
       bch2_check_fix_ptr fs/bcachefs/buckets.c:127 [inline]
       bch2_check_fix_ptrs+0x1364/0x47f8 fs/bcachefs/buckets.c:256
       bch2_trigger_extent+0x740/0x83c fs/bcachefs/buckets.c:844
       bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
       bch2_gc_mark_key+0x4b4/0xb70 fs/bcachefs/btree_gc.c:633
       bch2_gc_btree fs/bcachefs/btree_gc.c:669 [inline]
       bch2_gc_btrees fs/bcachefs/btree_gc.c:728 [inline]
       bch2_check_allocations+0x110c/0x4f64 fs/bcachefs/btree_gc.c:1135
       bch2_run_recovery_pass+0xe4/0x1d4 fs/bcachefs/recovery_passes.c:183
       bch2_run_recovery_passes+0x258/0x6e0 fs/bcachefs/recovery_passes.c:230
       bch2_fs_recovery+0x32c8/0x5514 fs/bcachefs/recovery.c:859
       bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1036
       bch2_fs_get_tree+0x938/0x1030 fs/bcachefs/fs.c:1946
       vfs_get_tree+0x90/0x28c fs/super.c:1800
       do_new_mount+0x278/0x900 fs/namespace.c:3472
       path_mount+0x590/0xe04 fs/namespace.c:3799
       do_mount fs/namespace.c:3812 [inline]
       __do_sys_mount fs/namespace.c:4020 [inline]
       __se_sys_mount fs/namespace.c:3997 [inline]
       __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
       el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
       el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #0 (&c->mark_lock){++++}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3133 [inline]
       check_prevs_add kernel/locking/lockdep.c:3252 [inline]
       validate_chain kernel/locking/lockdep.c:3868 [inline]
       __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
       lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
       percpu_down_read+0x5c/0x2e8 include/linux/percpu-rwsem.h:51
       __bch2_disk_reservation_add+0xc4/0x99c fs/bcachefs/buckets.c:1158
       bch2_disk_reservation_add+0x29c/0x460 fs/bcachefs/buckets.h:375
       bch2_folio_reservation_get+0x2c4/0x5bc fs/bcachefs/fs-io-pagecache.c:445
       bch2_page_mkwrite+0xa68/0xe54 fs/bcachefs/fs-io-pagecache.c:637
       do_page_mkwrite+0x140/0x2dc mm/memory.c:3142
       do_shared_fault mm/memory.c:5133 [inline]
       do_fault mm/memory.c:5195 [inline]
       do_pte_missing mm/memory.c:3947 [inline]
       handle_pte_fault+0x11d4/0x56f4 mm/memory.c:5521
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0xe38/0x1460 mm/memory.c:5832
       do_page_fault+0x428/0xb1c arch/arm64/mm/fault.c:613
       do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:690
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:826
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
       el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

other info that might help us debug this:

Chain exists of:
  &c->mark_lock --> &mm->mmap_lock --> sb_pagefaults#2

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults#2);
                               lock(&mm->mmap_lock);
                               lock(sb_pagefaults#2);
  rlock(&c->mark_lock);

 *** DEADLOCK ***

2 locks held by syz.0.428/9213:
 #0: ffff0000cec8a188 (&mm->mmap_lock){++++}-{3:3}, at: mmap_read_trylock include/linux/mmap_lock.h:163 [inline]
 #0: ffff0000cec8a188 (&mm->mmap_lock){++++}-{3:3}, at: get_mmap_lock_carefully mm/memory.c:5869 [inline]
 #0: ffff0000cec8a188 (&mm->mmap_lock){++++}-{3:3}, at: lock_mm_and_find_vma+0x38/0x2d8 mm/memory.c:5929
 #1: ffff0000d464a518 (sb_pagefaults#2){.+.+}-{0:0}, at: do_page_mkwrite+0x140/0x2dc mm/memory.c:3142

stack backtrace:
CPU: 0 UID: 0 PID: 9213 Comm: syz.0.428 Not tainted 6.11.0-rc5-syzkaller-gdf54f4a16f82 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:119
 dump_stack+0x1c/0x28 lib/dump_stack.c:128
 print_circular_bug+0x150/0x1b8 kernel/locking/lockdep.c:2059
 check_noncircular+0x310/0x404 kernel/locking/lockdep.c:2186
 check_prev_add kernel/locking/lockdep.c:3133 [inline]
 check_prevs_add kernel/locking/lockdep.c:3252 [inline]
 validate_chain kernel/locking/lockdep.c:3868 [inline]
 __lock_acquire+0x33d8/0x779c kernel/locking/lockdep.c:5142
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
 percpu_down_read+0x5c/0x2e8 include/linux/percpu-rwsem.h:51
 __bch2_disk_reservation_add+0xc4/0x99c fs/bcachefs/buckets.c:1158
 bch2_disk_reservation_add+0x29c/0x460 fs/bcachefs/buckets.h:375
 bch2_folio_reservation_get+0x2c4/0x5bc fs/bcachefs/fs-io-pagecache.c:445
 bch2_page_mkwrite+0xa68/0xe54 fs/bcachefs/fs-io-pagecache.c:637
 do_page_mkwrite+0x140/0x2dc mm/memory.c:3142
 do_shared_fault mm/memory.c:5133 [inline]
 do_fault mm/memory.c:5195 [inline]
 do_pte_missing mm/memory.c:3947 [inline]
 handle_pte_fault+0x11d4/0x56f4 mm/memory.c:5521
 __handle_mm_fault mm/memory.c:5664 [inline]
 handle_mm_fault+0xe38/0x1460 mm/memory.c:5832
 do_page_fault+0x428/0xb1c arch/arm64/mm/fault.c:613
 do_translation_fault+0xc4/0x114 arch/arm64/mm/fault.c:690
 do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:826
 el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
 el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598


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
