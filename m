Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EE933981
	for <linux-bcachefs@vger.kernel.org>; Mon, 20 Jan 2025 02:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737340050; cv=none; b=oguJFlyg5GWxrbrZjCu+D7gWfL+KmFYskCHlrDjlkB8ogbCrjJXOmXDkkIl66Ii/aqZ6u3kFPMUl90/PPOIePWxdw0Ktai5m1YIGE4xNWnROSWHiNovn/CqkJsrzMqkHu1a+yTJH/lYOZQcZUPFmJZTXgNTNLGGpdflPv645VU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737340050; c=relaxed/simple;
	bh=7s4LazgSB3nl91hq3ij1dUZjYyKgr7VuoeMa6SA04bg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TIajjnV1Pj8Q+PGU0k4dv/QDUQ+hpTcIlh48Dq03hwk1Q3Fx66337a60K6bmbq48PZWhjXTEjxXUccey6LHQNI+1QNtVlA2449XUNU4527w8ekJPhow4wblK2kYUg6RosTTRDqnPfR2AvcRj0p1HgINmRN3OBzzaM5yPrOJ8rwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ce7e5d651aso33763325ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 Jan 2025 18:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737340048; x=1737944848;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aXK7FTqP2CbySk1eptLetoCJWgzqzUYaIzurOZkrqNE=;
        b=BPL5kZxAn6VWVjDtvId7Sxbpxc6FI5hldC0kjG5GQd1vkl8ctz5ajdp+7XLOYbTt64
         fRsPBXHHSbM/9dSLhZFy6pHnOrrPfVaQEWZQJEebb6t4giLo65FqM0wu0dcHPMF2QV5L
         j1RX6JtvgKrLvuzhmhUkePVnObv8GxioY9kjWw6/JD9hXLBHtAXr/9m4kx839I3XN8vV
         aKyHJNRfv9SSof3yyVTfUTF1FRJVIk4WrBIKd2YRS53B5ox3a98vTu+qEnZWvyUNu6n2
         o0e7XHDR63IYfELVrioxDl0yFZlDLxwXZUznm2dgx6EaG0TDBzpiAjmoi9aPlCFaYZcm
         6TFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVkFjXWDlpu+8BqrK6lerYO13moDepPm4sxZecmh1RLCPihAlMGlBLBzp0PYHALLzo6Q2i894sE71gp216jcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRm9Q8IHJK9//ROe+k91+NH7WMnQ0Td/km3B3qCbVC9prjlDL3
	V3JybgMpJq8aLG6j6xLw2SUnULDaBwEu3qvV9SBJNRq5gVjf5FDjHnbne+fEZ+ZhAhYRXWps2vH
	UQyudaOerXW+YC1a35aXZarocifeBW2KG6kuwyBYQEmiN5rKMeEOV7Nw=
X-Google-Smtp-Source: AGHT+IF7O3leYwA1fjOs1jJNHpKwN+mPFkNbudvNlAT1glrPpOlUV1sc7SdBKmmJ3zo+marjSpkoGO4ndyaSDp/+QzUCGtNcMzS9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:9f:b0:3ce:7bbd:971c with SMTP id
 e9e14a558f8ab-3cf74496441mr95633825ab.15.1737340047786; Sun, 19 Jan 2025
 18:27:27 -0800 (PST)
Date: Sun, 19 Jan 2025 18:27:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678db48f.050a0220.303755.0065.GAE@google.com>
Subject: [syzbot] [bcachefs?] possible deadlock in bch2_trans_begin
From: syzbot <syzbot+8f9c94814c0235823861@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    619f0b6fad52 Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154ac9df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aadf89e2f6db86cc
dashboard link: https://syzkaller.appspot.com/bug?extid=8f9c94814c0235823861
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/820c5fcece46/disk-619f0b6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/22a2cbc89593/vmlinux-619f0b6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09df72182529/bzImage-619f0b6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8f9c94814c0235823861@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0 Not tainted
------------------------------------------------------
syz.1.4054/25525 is trying to acquire lock:
ffff8880577fc128 (bcachefs_btree){+.+.}-{0:0}, at: trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
ffff8880577fc128 (bcachefs_btree){+.+.}-{0:0}, at: bch2_trans_begin+0x9b0/0x1bf0 fs/bcachefs/btree_iter.c:3125

but task is already holding lock:
ffff8880545f3ee8 (mapping.invalidate_lock#6){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
ffff8880545f3ee8 (mapping.invalidate_lock#6){.+.+}-{4:4}, at: page_cache_ra_order+0x326/0xb60 mm/readahead.c:488

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #8 (mapping.invalidate_lock#6){.+.+}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       down_read+0xb1/0xa40 kernel/locking/rwsem.c:1524
       filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
       filemap_fault+0x615/0x1490 mm/filemap.c:3323
       bch2_page_fault+0x52c/0x960 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0x137/0x390 mm/memory.c:4907
       do_read_fault mm/memory.c:5322 [inline]
       do_fault mm/memory.c:5456 [inline]
       do_pte_missing mm/memory.c:3979 [inline]
       handle_pte_fault+0x39eb/0x5ed0 mm/memory.c:5801
       __handle_mm_fault mm/memory.c:5944 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
       do_user_addr_fault arch/x86/mm/fault.c:1389 [inline]
       handle_page_fault arch/x86/mm/fault.c:1481 [inline]
       exc_page_fault+0x2b9/0x8b0 arch/x86/mm/fault.c:1539
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623
       fault_in_readable+0x111/0x2d0
       fault_in_iov_iter_readable+0x229/0x280 lib/iov_iter.c:94
       bch2_buffered_write fs/bcachefs/fs-io-buffered.c:983 [inline]
       bch2_write_iter+0x528/0x2c10 fs/bcachefs/fs-io-buffered.c:1054
       new_sync_write fs/read_write.c:586 [inline]
       vfs_write+0xaed/0xd30 fs/read_write.c:679
       ksys_write+0x18f/0x2b0 fs/read_write.c:731
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (&mm->mmap_lock){++++}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __might_fault+0xc6/0x120 mm/memory.c:6751
       drm_mode_atomic_ioctl+0x5d4/0x1410 drivers/gpu/drm/drm_atomic_uapi.c:1437
       drm_ioctl_kernel+0x339/0x440 drivers/gpu/drm/drm_ioctl.c:796
       drm_ioctl+0x60e/0xad0 drivers/gpu/drm/drm_ioctl.c:893
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:906 [inline]
       __se_sys_ioctl+0xf7/0x170 fs/ioctl.c:892
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (crtc_ww_class_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       ww_acquire_init include/linux/ww_mutex.h:162 [inline]
       drm_modeset_acquire_init+0x20b/0x3d0 drivers/gpu/drm/drm_modeset_lock.c:250
       drmm_mode_config_init+0xe05/0x1800 drivers/gpu/drm/drm_mode_config.c:453
       vkms_modeset_init drivers/gpu/drm/vkms/vkms_drv.c:158 [inline]
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:219 [inline]
       vkms_init+0x380/0x720 drivers/gpu/drm/vkms/vkms_drv.c:256
       do_one_initcall+0x24a/0x870 init/main.c:1266
       do_initcall_level+0x157/0x210 init/main.c:1328
       do_initcalls+0x3f/0x80 init/main.c:1344
       kernel_init_freeable+0x435/0x5d0 init/main.c:1577
       kernel_init+0x1d/0x2b0 init/main.c:1466
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #5 (crtc_ww_class_acquire){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       ww_acquire_init include/linux/ww_mutex.h:161 [inline]
       drm_modeset_acquire_init+0x1ee/0x3d0 drivers/gpu/drm/drm_modeset_lock.c:250
       drm_client_modeset_commit_atomic+0xcf/0x7d0 drivers/gpu/drm/drm_client_modeset.c:1009
       drm_client_modeset_commit_locked+0xe0/0x520 drivers/gpu/drm/drm_client_modeset.c:1173
       drm_client_modeset_commit+0x4a/0x70 drivers/gpu/drm/drm_client_modeset.c:1199
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xc3/0x170 drivers/gpu/drm/drm_fb_helper.c:237
       drm_fb_helper_set_par+0xaf/0x100 drivers/gpu/drm/drm_fb_helper.c:1351
       fbcon_init+0x112d/0x2100 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x2e9/0x660 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x863/0xf60 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x5e7/0x750 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0x11a/0x200 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x364/0x620 drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x654/0x810 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x1697/0x1cc0 drivers/gpu/drm/drm_fb_helper.c:1841
       drm_fbdev_client_hotplug+0x16e/0x230 drivers/gpu/drm/drm_fbdev_client.c:51
       drm_client_register+0x181/0x210 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a9/0x3b0 drivers/gpu/drm/drm_fbdev_client.c:158
       drm_client_setup+0x1d/0x90 drivers/gpu/drm/drm_client_setup.c:29
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:230 [inline]
       vkms_init+0x5eb/0x720 drivers/gpu/drm/vkms/vkms_drv.c:256
       do_one_initcall+0x24a/0x870 init/main.c:1266
       do_initcall_level+0x157/0x210 init/main.c:1328
       do_initcalls+0x3f/0x80 init/main.c:1344
       kernel_init_freeable+0x435/0x5d0 init/main.c:1577
       kernel_init+0x1d/0x2b0 init/main.c:1466
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #4 (&client->modeset_mutex){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       drm_client_modeset_probe+0x3ab/0x5490 drivers/gpu/drm/drm_client_modeset.c:834
       __drm_fb_helper_initial_config_and_unlock+0x11e/0x1cc0 drivers/gpu/drm/drm_fb_helper.c:1818
       drm_fbdev_client_hotplug+0x16e/0x230 drivers/gpu/drm/drm_fbdev_client.c:51
       drm_client_register+0x181/0x210 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a9/0x3b0 drivers/gpu/drm/drm_fbdev_client.c:158
       drm_client_setup+0x1d/0x90 drivers/gpu/drm/drm_client_setup.c:29
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:230 [inline]
       vkms_init+0x5eb/0x720 drivers/gpu/drm/vkms/vkms_drv.c:256
       do_one_initcall+0x24a/0x870 init/main.c:1266
       do_initcall_level+0x157/0x210 init/main.c:1328
       do_initcalls+0x3f/0x80 init/main.c:1344
       kernel_init_freeable+0x435/0x5d0 init/main.c:1577
       kernel_init+0x1d/0x2b0 init/main.c:1466
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #3 (&helper->lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       __drm_fb_helper_restore_fbdev_mode_unlocked+0xa2/0x170 drivers/gpu/drm/drm_fb_helper.c:228
       drm_fb_helper_set_par+0xaf/0x100 drivers/gpu/drm/drm_fb_helper.c:1351
       fbcon_init+0x112d/0x2100 drivers/video/fbdev/core/fbcon.c:1113
       visual_init+0x2e9/0x660 drivers/tty/vt/vt.c:1011
       do_bind_con_driver+0x863/0xf60 drivers/tty/vt/vt.c:3833
       do_take_over_console+0x5e7/0x750 drivers/tty/vt/vt.c:4399
       do_fbcon_takeover+0x11a/0x200 drivers/video/fbdev/core/fbcon.c:549
       do_fb_registered drivers/video/fbdev/core/fbcon.c:2988 [inline]
       fbcon_fb_registered+0x364/0x620 drivers/video/fbdev/core/fbcon.c:3008
       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 [inline]
       register_framebuffer+0x654/0x810 drivers/video/fbdev/core/fbmem.c:515
       __drm_fb_helper_initial_config_and_unlock+0x1697/0x1cc0 drivers/gpu/drm/drm_fb_helper.c:1841
       drm_fbdev_client_hotplug+0x16e/0x230 drivers/gpu/drm/drm_fbdev_client.c:51
       drm_client_register+0x181/0x210 drivers/gpu/drm/drm_client.c:140
       drm_fbdev_client_setup+0x1a9/0x3b0 drivers/gpu/drm/drm_fbdev_client.c:158
       drm_client_setup+0x1d/0x90 drivers/gpu/drm/drm_client_setup.c:29
       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:230 [inline]
       vkms_init+0x5eb/0x720 drivers/gpu/drm/vkms/vkms_drv.c:256
       do_one_initcall+0x24a/0x870 init/main.c:1266
       do_initcall_level+0x157/0x210 init/main.c:1328
       do_initcalls+0x3f/0x80 init/main.c:1344
       kernel_init_freeable+0x435/0x5d0 init/main.c:1577
       kernel_init+0x1d/0x2b0 init/main.c:1466
       ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

-> #2 (console_lock){+.+.}-{0:0}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       console_lock+0x164/0x1b0 kernel/printk/printk.c:2833
       __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
       bch2_print_string_as_lines+0x20/0xc0 fs/bcachefs/util.c:286
       __bch2_fsck_err+0x104d/0x1570 fs/bcachefs/error.c:411
       bch2_bucket_ref_update+0x89e/0x12d0 fs/bcachefs/buckets.c:469
       __mark_pointer fs/bcachefs/buckets.c:551 [inline]
       bch2_trigger_pointer fs/bcachefs/buckets.c:590 [inline]
       __trigger_extent+0x1173/0x4fa0 fs/bcachefs/buckets.c:740
       bch2_trigger_extent+0x585/0xaa0 fs/bcachefs/buckets.c:869
       bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
       bch2_key_trigger_old fs/bcachefs/bkey_methods.h:101 [inline]
       run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:512 [inline]
       run_btree_triggers+0xb39/0x1270 fs/bcachefs/btree_trans_commit.c:540
       bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:572 [inline]
       __bch2_trans_commit+0x369/0x93c0 fs/bcachefs/btree_trans_commit.c:1057
       bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
       bch2_inode_delete_keys+0xae6/0x1440 fs/bcachefs/inode.c:986
       bch2_inode_rm+0x17d/0xf60 fs/bcachefs/inode.c:1015
       bch2_evict_inode+0x20a/0x3f0 fs/bcachefs/fs.c:1836
       evict+0x4ea/0x9a0 fs/inode.c:796
       do_unlinkat+0x512/0x830 fs/namei.c:4594
       __do_sys_unlink fs/namei.c:4635 [inline]
       __se_sys_unlink fs/namei.c:4633 [inline]
       __x64_sys_unlink+0x47/0x50 fs/namei.c:4633
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&c->fsck_error_msgs_lock){+.+.}-{4:4}:
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       __mutex_lock_common kernel/locking/mutex.c:585 [inline]
       __mutex_lock+0x1ac/0xee0 kernel/locking/mutex.c:735
       __bch2_fsck_err+0x3d4/0x1570 fs/bcachefs/error.c:282
       bch2_bucket_ref_update+0x89e/0x12d0 fs/bcachefs/buckets.c:469
       __mark_pointer fs/bcachefs/buckets.c:551 [inline]
       bch2_trigger_pointer fs/bcachefs/buckets.c:590 [inline]
       __trigger_extent+0x1173/0x4fa0 fs/bcachefs/buckets.c:740
       bch2_trigger_extent+0x585/0xaa0 fs/bcachefs/buckets.c:869
       bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
       bch2_key_trigger_old fs/bcachefs/bkey_methods.h:101 [inline]
       run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:512 [inline]
       run_btree_triggers+0xb39/0x1270 fs/bcachefs/btree_trans_commit.c:540
       bch2_trans_commit_run_triggers fs/bcachefs/btree_trans_commit.c:572 [inline]
       __bch2_trans_commit+0x369/0x93c0 fs/bcachefs/btree_trans_commit.c:1057
       bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
       bch2_inode_delete_keys+0xae6/0x1440 fs/bcachefs/inode.c:986
       bch2_inode_rm+0x17d/0xf60 fs/bcachefs/inode.c:1015
       bch2_evict_inode+0x20a/0x3f0 fs/bcachefs/fs.c:1836
       evict+0x4ea/0x9a0 fs/inode.c:796
       do_unlinkat+0x512/0x830 fs/namei.c:4594
       __do_sys_unlink fs/namei.c:4635 [inline]
       __se_sys_unlink fs/namei.c:4633 [inline]
       __x64_sys_unlink+0x47/0x50 fs/namei.c:4633
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (bcachefs_btree){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3161 [inline]
       check_prevs_add kernel/locking/lockdep.c:3280 [inline]
       validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
       __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
       lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
       trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
       bch2_trans_begin+0x9c5/0x1bf0 fs/bcachefs/btree_iter.c:3125
       bchfs_read+0x1e0/0x2b10 fs/bcachefs/fs-io-buffered.c:161
       bch2_readahead+0xdce/0x11e0 fs/bcachefs/fs-io-buffered.c:277
       read_pages+0x178/0x750 mm/readahead.c:160
       page_cache_ra_order+0x7e3/0xb60 mm/readahead.c:512
       do_sync_mmap_readahead+0x499/0x970
       filemap_fault+0x8a9/0x1490 mm/filemap.c:3335
       bch2_page_fault+0x52c/0x960 fs/bcachefs/fs-io-pagecache.c:594
       __do_fault+0x137/0x390 mm/memory.c:4907
       do_read_fault mm/memory.c:5322 [inline]
       do_fault mm/memory.c:5456 [inline]
       do_pte_missing mm/memory.c:3979 [inline]
       handle_pte_fault+0x39eb/0x5ed0 mm/memory.c:5801
       __handle_mm_fault mm/memory.c:5944 [inline]
       handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
       faultin_page mm/gup.c:1196 [inline]
       __get_user_pages+0x1c82/0x49e0 mm/gup.c:1494
       populate_vma_page_range+0x264/0x330 mm/gup.c:1932
       __mm_populate+0x27a/0x460 mm/gup.c:2035
       mm_populate include/linux/mm.h:3397 [inline]
       vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:580
       ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:546
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  bcachefs_btree --> &mm->mmap_lock --> mapping.invalidate_lock#6

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(mapping.invalidate_lock#6);
                               lock(&mm->mmap_lock);
                               lock(mapping.invalidate_lock#6);
  lock(bcachefs_btree);

 *** DEADLOCK ***

1 lock held by syz.1.4054/25525:
 #0: ffff8880545f3ee8 (mapping.invalidate_lock#6){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:873 [inline]
 #0: ffff8880545f3ee8 (mapping.invalidate_lock#6){.+.+}-{4:4}, at: page_cache_ra_order+0x326/0xb60 mm/readahead.c:488

stack backtrace:
CPU: 0 UID: 0 PID: 25525 Comm: syz.1.4054 Not tainted 6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_circular_bug+0x13a/0x1b0 kernel/locking/lockdep.c:2074
 check_noncircular+0x36a/0x4a0 kernel/locking/lockdep.c:2206
 check_prev_add kernel/locking/lockdep.c:3161 [inline]
 check_prevs_add kernel/locking/lockdep.c:3280 [inline]
 validate_chain+0x18ef/0x5920 kernel/locking/lockdep.c:3904
 __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5226
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 trans_set_locked fs/bcachefs/btree_locking.h:194 [inline]
 bch2_trans_begin+0x9c5/0x1bf0 fs/bcachefs/btree_iter.c:3125
 bchfs_read+0x1e0/0x2b10 fs/bcachefs/fs-io-buffered.c:161
 bch2_readahead+0xdce/0x11e0 fs/bcachefs/fs-io-buffered.c:277
 read_pages+0x178/0x750 mm/readahead.c:160
 page_cache_ra_order+0x7e3/0xb60 mm/readahead.c:512
 do_sync_mmap_readahead+0x499/0x970
 filemap_fault+0x8a9/0x1490 mm/filemap.c:3335
 bch2_page_fault+0x52c/0x960 fs/bcachefs/fs-io-pagecache.c:594
 __do_fault+0x137/0x390 mm/memory.c:4907
 do_read_fault mm/memory.c:5322 [inline]
 do_fault mm/memory.c:5456 [inline]
 do_pte_missing mm/memory.c:3979 [inline]
 handle_pte_fault+0x39eb/0x5ed0 mm/memory.c:5801
 __handle_mm_fault mm/memory.c:5944 [inline]
 handle_mm_fault+0x1106/0x1bb0 mm/memory.c:6112
 faultin_page mm/gup.c:1196 [inline]
 __get_user_pages+0x1c82/0x49e0 mm/gup.c:1494
 populate_vma_page_range+0x264/0x330 mm/gup.c:1932
 __mm_populate+0x27a/0x460 mm/gup.c:2035
 mm_populate include/linux/mm.h:3397 [inline]
 vm_mmap_pgoff+0x2c3/0x3d0 mm/util.c:580
 ksys_mmap_pgoff+0x4eb/0x720 mm/mmap.c:546
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbe7b185d29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbe7c04d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007fbe7b376080 RCX: 00007fbe7b185d29
RDX: 00000000027ffff7 RSI: 0000000000600000 RDI: 0000000020000000
RBP: 00007fbe7b201b08 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000004012011 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000001 R14: 00007fbe7b376080 R15: 00007ffd12016ca8
 </TASK>


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
