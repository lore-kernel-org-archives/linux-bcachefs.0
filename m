Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401197E0E4
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Sep 2024 23:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726443631; cv=none; b=gj7lhz0tz7VSdwS3GzQKogfO38b4GBLGRrGdiOjU0szoXrXTMMla87DVMRDgrlA7tGfHU9UEXVNrSoadUKFtGUHU3cxHQ68pBug/F7auF9w8/r8cRmJvf0n0jyCevdTk2NIxibtDzELuyL8cHJJanQAVe0Rwe+zhgNnZASCWYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726443631; c=relaxed/simple;
	bh=UADqDOWg2vNjBxQtXisbtTzPr15gXwB/1xlgwf09S6U=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=aDICIrvVAFzSGYM2f7GrX2/hCtkrE10hBKRTGpH2QCWn+8vl33Ke7EbXKQU9ntgNlC24KhqoNYquY7zjcfd9G1dfwV5Zx/4ZPpnphE5btC2ta5K4d2rPpI1yqh6da3PbUItlylZZupONZnPczzMMy4AE2oscoDyjgUJspYOvLAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82aac437083so620163139f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Sep 2024 16:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726443628; x=1727048428;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OuTsin3t/zjnDx2v8xco0kSnYd/minFvsz4MWr53674=;
        b=JRbpv79xGyAsgtaMEXhiA0dkKigaORuiWFMRKHtUsWO4wwE1oP+azUDdzG+F3SCFtI
         s3KVzUaP0tQbjoN1WyqJ4zYWrmmsPEkhFCpRrf6SVfvxHS6p9XqKwGbhg8lQUGcynh1l
         3FXO9UOr1hagMbn2vLUy4uVoIHwWR2Zsis0P9xiKWVlg6JQmwp10nnJdPO+i5Zo9bCea
         5yTtIUfUqz6F25F/PgLV7kP06peiHRi4ZdYv7nODSYAxcZJK/0zSB43RVVe/4K8cwnY2
         w8RwtHP8xE09Iy3Z6k/dOBi3DX8UJ5hI5iuUCoNUKXPNeZsfHYnlH2LCdquLYc0wE6vA
         PIfg==
X-Forwarded-Encrypted: i=1; AJvYcCX/EODdkP6clJiHnroxcDjhbZhEx2L19xrxP/uMVbXBcwMS9iOyvHcnr8IXd+Fkj8rlJEynS3em4iZjTn/O1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1s30oEEBX17Aop/zayqXON38bjd8AwDlCqawfJrnqrHeM+zlJ
	oS5vtW/8GEoGJZ3RxWtosXtoa14etb0UIldcZ+wCa+oWgp50XjNmfcpIWQ4zVacE+SncDwEq9Rh
	Ed8/wbclFxs9EWjRx9Qr5OzAS3pRw8okCGu0UMP4wd+D62kmtKRXKY7o=
X-Google-Smtp-Source: AGHT+IGFBSaAaHNwbJqGrYcGlUuyB3jF4StpIVgouDSQddEG+l2ceLq1ndIowxR87lh0H00mjo2LCPD/6xi1qEpFcmSZW7CEiXSb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a04:b0:3a0:a1d7:791d with SMTP id
 e9e14a558f8ab-3a0a1d77ab5mr11921285ab.25.1726443628305; Sun, 15 Sep 2024
 16:40:28 -0700 (PDT)
Date: Sun, 15 Sep 2024 16:40:28 -0700
In-Reply-To: <0000000000002408bb0621fb8f8b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000030ae8a062230fbff@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in __bch2_disk_reservation_add
From: syzbot <syzbot+089ffc4307915afa0da7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=113dc8a9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=089ffc4307915afa0da7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1761229f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14a2f407980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e8a95bcc5612/mount_3.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+089ffc4307915afa0da7@syzkaller.appspotmail.com

bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
======================================================
WARNING: possible circular locking dependency detected
6.11.0-rc7-syzkaller-g5f5673607153 #0 Not tainted
------------------------------------------------------
syz-executor358/6408 is trying to acquire lock:
ffff0000e0f04990 (&c->mark_lock){++++}-{0:0}, at: __bch2_disk_reservation_add+0xc4/0x99c fs/bcachefs/buckets.c:1158

but task is already holding lock:
ffff0000c537e518 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x140/0x2dc mm/memory.c:3142

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (sb_pagefaults){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1676 [inline]
       sb_start_pagefault include/linux/fs.h:1841 [inline]
       bch2_page_mkwrite+0x280/0xe54 fs/bcachefs/fs-io-pagecache.c:614
       do_page_mkwrite+0x140/0x2dc mm/memory.c:3142
       wp_page_shared mm/memory.c:3545 [inline]
       do_wp_page+0x1fb8/0x3a34 mm/memory.c:3695
       handle_pte_fault+0xca0/0x56f4 mm/memory.c:5537
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0xee8/0x1784 mm/memory.c:5832
       do_page_fault+0x3cc/0xfa8 arch/arm64/mm/fault.c:607
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:879
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
       el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

-> #7 (&vma->vm_lock->lock){++++}-{3:3}:
       down_write+0x50/0xc0 kernel/locking/rwsem.c:1579
       vma_start_write include/linux/mm.h:751 [inline]
       vma_link+0x238/0x484 mm/mmap.c:457
       insert_vm_struct+0x284/0x378 mm/mmap.c:3484
       __bprm_mm_init fs/exec.c:291 [inline]
       bprm_mm_init fs/exec.c:395 [inline]
       alloc_bprm+0x68c/0xb68 fs/exec.c:1623
       kernel_execve+0xa4/0x820 fs/exec.c:2052
       run_init_process+0x1bc/0x1ec init/main.c:1388
       try_to_run_init_process init/main.c:1395 [inline]
       kernel_init+0xdc/0x2a0 init/main.c:1523
       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860

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
       bch2_trigger_extent+0x71c/0x814 fs/bcachefs/buckets.c:844
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
       wp_page_shared mm/memory.c:3545 [inline]
       do_wp_page+0x1fb8/0x3a34 mm/memory.c:3695
       handle_pte_fault+0xca0/0x56f4 mm/memory.c:5537
       __handle_mm_fault mm/memory.c:5664 [inline]
       handle_mm_fault+0xee8/0x1784 mm/memory.c:5832
       do_page_fault+0x3cc/0xfa8 arch/arm64/mm/fault.c:607
       do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:879
       el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
       el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
       el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

other info that might help us debug this:

Chain exists of:
  &c->mark_lock --> &vma->vm_lock->lock --> sb_pagefaults

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(sb_pagefaults);
                               lock(&vma->vm_lock->lock);
                               lock(sb_pagefaults);
  rlock(&c->mark_lock);

 *** DEADLOCK ***

2 locks held by syz-executor358/6408:
 #0: ffff0000d91609b8 (&vma->vm_lock->lock){++++}-{3:3}, at: vma_start_read include/linux/mm.h:698 [inline]
 #0: ffff0000d91609b8 (&vma->vm_lock->lock){++++}-{3:3}, at: lock_vma_under_rcu+0x28c/0x5e4 mm/memory.c:5998
 #1: ffff0000c537e518 (sb_pagefaults){.+.+}-{0:0}, at: do_page_mkwrite+0x140/0x2dc mm/memory.c:3142

stack backtrace:
CPU: 1 UID: 0 PID: 6408 Comm: syz-executor358 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:319
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:326
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
 wp_page_shared mm/memory.c:3545 [inline]
 do_wp_page+0x1fb8/0x3a34 mm/memory.c:3695
 handle_pte_fault+0xca0/0x56f4 mm/memory.c:5537
 __handle_mm_fault mm/memory.c:5664 [inline]
 handle_mm_fault+0xee8/0x1784 mm/memory.c:5832
 do_page_fault+0x3cc/0xfa8 arch/arm64/mm/fault.c:607
 do_mem_abort+0x74/0x200 arch/arm64/mm/fault.c:879
 el0_da+0x60/0x178 arch/arm64/kernel/entry-common.c:580
 el0t_64_sync_handler+0xcc/0xfc arch/arm64/kernel/entry-common.c:733
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
