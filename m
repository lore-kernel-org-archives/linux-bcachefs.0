Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388731E9B3A;
	Tue,  5 Aug 2025 04:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754367028; cv=none; b=Ygy5iM3aVBcsmUk04oj7m/yLLpRsmPoKo0tYB/joKwA/OV/Df0DBb5CmJikKFtDGe/8JDkylBYIrtgMf3FL7aaRn3jgO46oAJupeJmYKsMXdQuAL0kUpXgR5dnEGQ0vashFQrsOi3eETb+UR+k1GxnulccWmQpJY8GdXM4v2hDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754367028; c=relaxed/simple;
	bh=OZDh4S/E2RnpgcRi9xcz0cV/zhL3qkPfAsA7AnQ0Di8=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=cIjfl/G2cN6Mx8+0VMA7Y2ENhR2BuZof+/pgIlOG+iDnUN6NLfmx2dPvSDD+XWApXquds/nFQyfTs+5F2JwVOaBpBvyiS4MHahpUyQnoRgSCb9qaKyXx5AxwSOUoBtDtUE/zyysf1MkE1ENhLnZnq16crhdACm0ecPDXNkKJYDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HHBEzyBD; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HHBEzyBD"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24049d16515so31123715ad.1;
        Mon, 04 Aug 2025 21:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754367025; x=1754971825; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AE8ZJgYR4gXvil8YZqE55/lsRZeSrvo3hkymIo26BXs=;
        b=HHBEzyBDPr/IhJVVaDcgXJuZg/1J+bGt6r5xWxtqwAGsYioYY5IbltzObj3HCk8Qcv
         o5wQO484yQWkweMWu9guatEeRNi3wl766GXLy6TqHYap2AHYUWqcNVSQGyfJboIEHfcy
         GGczAHWtOUr/S/NN1SyUttm4hxupX0qjrrKazHxNs44S/j7HbRCOhmDwl47Mb6vdpSJ2
         Vo68Rx8kF/CWW+oudwZzlPNbOyrE/TDlQloxUd0ItB0L72xZyihho3rICu0FbPVLEht/
         X+iCVT4miEo+TfMnClGwtEfVNTHxdisSVwfgjI44y8HIIqigvpjYxk4ZUcaD7lSECGWf
         UsnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754367025; x=1754971825;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AE8ZJgYR4gXvil8YZqE55/lsRZeSrvo3hkymIo26BXs=;
        b=QwaExZfT8OFruX7oCcEI5bTuKqaRU0TjHLbO+VHgPiO/o6qkOBbBLlWWd4aHkJgHXM
         3UxNoRsDcwyC7FDKyWRtdfsYlFB5vFLtgT/hDaVfX32cSwb38baU3+uoaaG2xPbvB9XE
         2dQfECFCZW0uwY+xyESH8RQQzExqwCtPoN0fCeV5kfvR98FGMeEZbhp6yBFubi4fXVd5
         dRIqVtaLRGmYsv2adE8nMQtIIdszJniChEEEsP45CWeA0cZa0AXnFHct2mDHliiOoSP0
         BGxV8Yb7xWBAH/qxpTLkeyyPd1cJktf/3vdsETnPagdK6ItAeZWvdZKovZSq3oaMZeVB
         uZfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfmzs06n+JSadadZ4yAr8B8NM3Vdiodby0kv71TnPNIVN/DDOd0XC8hgaMoSiBFw6zv8gphhHxmN3bjahL@vger.kernel.org, AJvYcCWMW7IDxz0xMwaU9OuHPM0ROTzAQmVvhR40PL/4lSzi4my5TPQpLQHYvGEwQdReaWKvB85jxsB8YmCKW665Og==@vger.kernel.org
X-Gm-Message-State: AOJu0YwsyJT7zgz+ZEYY6SJ7MH662x5BcZAIqxXs/tqju+YeXEIURmbX
	TLJkEu0BA1bAxmCSOI3apQYaxTTaRykIfYu80a/GgzYT3q6V0DwWHjq6ynTo2w==
X-Gm-Gg: ASbGncsPNydIOWQPhTKLvS9DMeLQn1/a7LdDnDcwOYQDUbGibwY0M2Axc0w3FfPgcO1
	DyNsa1hij43gURNEhyKIvodzeZcotPgx6MwastUuDzS7A64CaV5yBTe7fmGW+8qAR6jd7DwaGCw
	4ptPXBPcQymnjxuSUJtgvKcoc5Ygxz+uWxXTQ/F200gr79aqKibqgnKAUX0e5dpDFaqHmDStjBM
	pAZEj6I3egod+N1nvDDzIkEoIf9OpucNap0F/0VJL+uIXPbtARBL2JhWWYiR7rvzlz5NO8AFlZ9
	l2Dp7zVRd4UDldVdYhv8zr3aHcIkoRWOBlYJ5c/P82opMKa3z3XnvOaDs3fHB5bVtMz9RRpZ99Y
	AFS3Ghg==
X-Google-Smtp-Source: AGHT+IFKwVK74J+J5KzB4AgkE88JfLz8kYb5Wyzby6IOpBXKvO1nvc5lq8XrbctUdzTkmhlwXtSgNw==
X-Received: by 2002:a17:903:1b66:b0:240:49bf:6332 with SMTP id d9443c01a7336-2424705d855mr161410115ad.47.1754367025242;
        Mon, 04 Aug 2025 21:10:25 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422bac0f89sm10124400a12.34.2025.08.04.21.10.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Aug 2025 21:10:24 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] possible deadlock in __bch2_count_fsck_err
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <68270758.a70a0220.38f255.0000.GAE@google.com>
Date: Tue, 5 Aug 2025 12:10:09 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <57D7A699-69ED-4D64-A550-088734490FAF@gmail.com>
References: <68270758.a70a0220.38f255.0000.GAE@google.com>
To: syzbot <syzbot+2648414dd66587a935e2@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

On May 16, 2025, at 17:37, syzbot =
<syzbot+2648414dd66587a935e2@syzkaller.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    c32f8dc5aaf9 Merge branch 'for-next/core' into =
for-kernelci
> git tree:       =
git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git =
for-kernelci
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D17b6a2f4580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3Dea4635ffd6ad5b4a
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D2648414dd66587a935e2
> compiler:       Debian clang version 20.1.2 =
(++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD =
20.1.2
> userspace arch: arm64
>=20
> Unfortunately, I don't have any reproducer for this issue yet.
>=20
> Downloadable assets:
> disk image: =
https://storage.googleapis.com/syzbot-assets/b921498959d4/disk-c32f8dc5.ra=
w.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/04e6ad946c4b/vmlinux-c32f8dc5=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/d4f0d8db50ee/Image-c32f8dc5.g=
z.xz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+2648414dd66587a935e2@syzkaller.appspotmail.com
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 Not tainted
> ------------------------------------------------------
> syz.1.109/7273 is trying to acquire lock:
> ffff0000f7e61448 (&c->fsck_error_msgs_lock){+.+.}-{4:4}, at: =
__bch2_count_fsck_err+0x58/0x98 fs/bcachefs/error.c:385
>=20
> but task is already holding lock:
> ffff0000f1fb1558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: =
bch2_i_sectors_acct fs/bcachefs/fs-io.h:137 [inline]
> ffff0000f1fb1558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: =
bchfs_fpunch+0x228/0x404 fs/bcachefs/fs-io.c:578
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #9 (&inode->ei_quota_lock){+.+.}-{4:4}:
>       __mutex_lock_common+0x1d0/0x2190 kernel/locking/mutex.c:601
>       __mutex_lock kernel/locking/mutex.c:746 [inline]
>       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:798
>       bch2_quota_reservation_add fs/bcachefs/fs-io.h:97 [inline]
>       __bch2_folio_reservation_get+0x5c0/0xa00 =
fs/bcachefs/fs-io-pagecache.c:460
>       bch2_folio_reservation_get fs/bcachefs/fs-io-pagecache.c:477 =
[inline]
>       bch2_page_mkwrite+0xa48/0xd60 fs/bcachefs/fs-io-pagecache.c:637
>       do_page_mkwrite+0x138/0x2b8 mm/memory.c:3287
>       wp_page_shared mm/memory.c:3688 [inline]
>       do_wp_page+0x1b54/0x43a8 mm/memory.c:3907
>       handle_pte_fault mm/memory.c:6013 [inline]
>       __handle_mm_fault mm/memory.c:6140 [inline]
>       handle_mm_fault+0x1064/0x4cec mm/memory.c:6309
>       do_page_fault+0x428/0x1554 arch/arm64/mm/fault.c:647
>       do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:919
>       el0_da+0x64/0x160 arch/arm64/kernel/entry-common.c:627
>       el0t_64_sync_handler+0x84/0x108 =
arch/arm64/kernel/entry-common.c:789
>       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> -> #8 (sb_pagefaults#3){.+.+}-{0:0}:
>       percpu_down_read include/linux/percpu-rwsem.h:52 [inline]
>       __sb_start_write include/linux/fs.h:1783 [inline]
>       sb_start_pagefault include/linux/fs.h:1948 [inline]
>       bch2_page_mkwrite+0x260/0xd60 fs/bcachefs/fs-io-pagecache.c:614
>       do_page_mkwrite+0x138/0x2b8 mm/memory.c:3287
>       wp_page_shared mm/memory.c:3688 [inline]
>       do_wp_page+0x1b54/0x43a8 mm/memory.c:3907
>       handle_pte_fault mm/memory.c:6013 [inline]
>       __handle_mm_fault mm/memory.c:6140 [inline]
>       handle_mm_fault+0x1064/0x4cec mm/memory.c:6309
>       do_page_fault+0x428/0x1554 arch/arm64/mm/fault.c:647
>       do_mem_abort+0x70/0x194 arch/arm64/mm/fault.c:919
>       el0_da+0x64/0x160 arch/arm64/kernel/entry-common.c:627
>       el0t_64_sync_handler+0x84/0x108 =
arch/arm64/kernel/entry-common.c:789
>       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> -> #7 (vm_lock){++++}-{0:0}:
>       __vma_enter_locked+0x184/0x354 mm/memory.c:6473
>       __vma_start_write+0x34/0x158 mm/memory.c:6497
>       vma_start_write include/linux/mm.h:829 [inline]
>       vma_expand+0x1b8/0x8f0 mm/vma.c:1086
>       relocate_vma_down+0x234/0x400 mm/mmap.c:1767
>       setup_arg_pages+0x4b4/0x920 fs/exec.c:800
>       load_elf_binary+0x8c4/0x1ebc fs/binfmt_elf.c:1019
>       search_binary_handler fs/exec.c:1778 [inline]
>       exec_binprm fs/exec.c:1810 [inline]
>       bprm_execve+0x77c/0x10dc fs/exec.c:1862
>       kernel_execve+0x70c/0x7f4 fs/exec.c:2028
>       run_init_process+0x1bc/0x1ec init/main.c:1378
>       try_to_run_init_process+0x20/0x7c init/main.c:1385
>       kernel_init+0xa8/0x1dc init/main.c:1513
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #6 (&mm->mmap_lock){++++}-{4:4}:
>       __might_fault+0xc4/0x124 mm/memory.c:7151
>       drm_mode_setcrtc+0xdc0/0x182c drivers/gpu/drm/drm_crtc.c:840
>       drm_ioctl_kernel+0x238/0x310 drivers/gpu/drm/drm_ioctl.c:796
>       drm_ioctl+0x65c/0xa5c drivers/gpu/drm/drm_ioctl.c:893
>       vfs_ioctl fs/ioctl.c:51 [inline]
>       __do_sys_ioctl fs/ioctl.c:906 [inline]
>       __se_sys_ioctl fs/ioctl.c:892 [inline]
>       __arm64_sys_ioctl+0x14c/0x1c4 fs/ioctl.c:892
>       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
>       el0t_64_sync_handler+0x78/0x108 =
arch/arm64/kernel/entry-common.c:786
>       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> -> #5 (crtc_ww_class_mutex){+.+.}-{4:4}:
>       ww_acquire_init include/linux/ww_mutex.h:162 [inline]
>       drm_modeset_acquire_init+0x1d8/0x374 =
drivers/gpu/drm/drm_modeset_lock.c:250
>       drmm_mode_config_init+0xb0c/0x10d8 =
drivers/gpu/drm/drm_mode_config.c:462
>       vkms_modeset_init drivers/gpu/drm/vkms/vkms_drv.c:146 [inline]
>       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:207 [inline]
>       vkms_init+0x2c0/0x5ac drivers/gpu/drm/vkms/vkms_drv.c:242
>       do_one_initcall+0x250/0x990 init/main.c:1257
>       do_initcall_level+0x154/0x214 init/main.c:1319
>       do_initcalls+0x84/0xf4 init/main.c:1335
>       do_basic_setup+0x8c/0xa0 init/main.c:1354
>       kernel_init_freeable+0x2dc/0x444 init/main.c:1567
>       kernel_init+0x24/0x1dc init/main.c:1457
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #4 (crtc_ww_class_acquire){+.+.}-{0:0}:
>       ww_acquire_init include/linux/ww_mutex.h:161 [inline]
>       drm_modeset_acquire_init+0x1b8/0x374 =
drivers/gpu/drm/drm_modeset_lock.c:250
>       drm_client_modeset_commit_atomic+0xcc/0x6ac =
drivers/gpu/drm/drm_client_modeset.c:1018
>       drm_client_modeset_commit_locked+0xd0/0x4a0 =
drivers/gpu/drm/drm_client_modeset.c:1182
>       drm_client_modeset_commit+0x50/0x7c =
drivers/gpu/drm/drm_client_modeset.c:1208
>       __drm_fb_helper_restore_fbdev_mode_unlocked+0x94/0x198 =
drivers/gpu/drm/drm_fb_helper.c:237
>       drm_fb_helper_set_par+0xa4/0x108 =
drivers/gpu/drm/drm_fb_helper.c:1359
>       fbcon_init+0xe4c/0x1d18 drivers/video/fbdev/core/fbcon.c:1112
>       visual_init+0x27c/0x540 drivers/tty/vt/vt.c:1011
>       do_bind_con_driver+0x7b8/0xdd8 drivers/tty/vt/vt.c:3831
>       do_take_over_console+0x824/0x97c drivers/tty/vt/vt.c:4397
>       do_fbcon_takeover+0x158/0x25c =
drivers/video/fbdev/core/fbcon.c:548
>       do_fb_registered drivers/video/fbdev/core/fbcon.c:2989 [inline]
>       fbcon_fb_registered+0x354/0x4c8 =
drivers/video/fbdev/core/fbcon.c:3009
>       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 =
[inline]
>       register_framebuffer+0x44c/0x5ec =
drivers/video/fbdev/core/fbmem.c:515
>       __drm_fb_helper_initial_config_and_unlock+0x103c/0x159c =
drivers/gpu/drm/drm_fb_helper.c:1851
>       drm_fb_helper_initial_config+0x3c/0x58 =
drivers/gpu/drm/drm_fb_helper.c:1916
>       drm_fbdev_client_hotplug+0x154/0x22c =
drivers/gpu/drm/clients/drm_fbdev_client.c:52
>       drm_client_register+0x13c/0x1d4 drivers/gpu/drm/drm_client.c:140
>       drm_fbdev_client_setup+0x194/0x3d0 =
drivers/gpu/drm/clients/drm_fbdev_client.c:159
>       drm_client_setup+0x78/0x140 =
drivers/gpu/drm/clients/drm_client_setup.c:39
>       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:218 [inline]
>       vkms_init+0x4b8/0x5ac drivers/gpu/drm/vkms/vkms_drv.c:242
>       do_one_initcall+0x250/0x990 init/main.c:1257
>       do_initcall_level+0x154/0x214 init/main.c:1319
>       do_initcalls+0x84/0xf4 init/main.c:1335
>       do_basic_setup+0x8c/0xa0 init/main.c:1354
>       kernel_init_freeable+0x2dc/0x444 init/main.c:1567
>       kernel_init+0x24/0x1dc init/main.c:1457
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #3 (&client->modeset_mutex){+.+.}-{4:4}:
>       __mutex_lock_common+0x1d0/0x2190 kernel/locking/mutex.c:601
>       __mutex_lock kernel/locking/mutex.c:746 [inline]
>       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:798
>       drm_client_modeset_probe+0x2f0/0x4e88 =
drivers/gpu/drm/drm_client_modeset.c:843
>       __drm_fb_helper_initial_config_and_unlock+0xf0/0x159c =
drivers/gpu/drm/drm_fb_helper.c:1828
>       drm_fb_helper_initial_config+0x3c/0x58 =
drivers/gpu/drm/drm_fb_helper.c:1916
>       drm_fbdev_client_hotplug+0x154/0x22c =
drivers/gpu/drm/clients/drm_fbdev_client.c:52
>       drm_client_register+0x13c/0x1d4 drivers/gpu/drm/drm_client.c:140
>       drm_fbdev_client_setup+0x194/0x3d0 =
drivers/gpu/drm/clients/drm_fbdev_client.c:159
>       drm_client_setup+0x78/0x140 =
drivers/gpu/drm/clients/drm_client_setup.c:39
>       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:218 [inline]
>       vkms_init+0x4b8/0x5ac drivers/gpu/drm/vkms/vkms_drv.c:242
>       do_one_initcall+0x250/0x990 init/main.c:1257
>       do_initcall_level+0x154/0x214 init/main.c:1319
>       do_initcalls+0x84/0xf4 init/main.c:1335
>       do_basic_setup+0x8c/0xa0 init/main.c:1354
>       kernel_init_freeable+0x2dc/0x444 init/main.c:1567
>       kernel_init+0x24/0x1dc init/main.c:1457
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #2 (&helper->lock){+.+.}-{4:4}:
>       __mutex_lock_common+0x1d0/0x2190 kernel/locking/mutex.c:601
>       __mutex_lock kernel/locking/mutex.c:746 [inline]
>       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:798
>       __drm_fb_helper_restore_fbdev_mode_unlocked+0x74/0x198 =
drivers/gpu/drm/drm_fb_helper.c:228
>       drm_fb_helper_set_par+0xa4/0x108 =
drivers/gpu/drm/drm_fb_helper.c:1359
>       fbcon_init+0xe4c/0x1d18 drivers/video/fbdev/core/fbcon.c:1112
>       visual_init+0x27c/0x540 drivers/tty/vt/vt.c:1011
>       do_bind_con_driver+0x7b8/0xdd8 drivers/tty/vt/vt.c:3831
>       do_take_over_console+0x824/0x97c drivers/tty/vt/vt.c:4397
>       do_fbcon_takeover+0x158/0x25c =
drivers/video/fbdev/core/fbcon.c:548
>       do_fb_registered drivers/video/fbdev/core/fbcon.c:2989 [inline]
>       fbcon_fb_registered+0x354/0x4c8 =
drivers/video/fbdev/core/fbcon.c:3009
>       do_register_framebuffer drivers/video/fbdev/core/fbmem.c:449 =
[inline]
>       register_framebuffer+0x44c/0x5ec =
drivers/video/fbdev/core/fbmem.c:515
>       __drm_fb_helper_initial_config_and_unlock+0x103c/0x159c =
drivers/gpu/drm/drm_fb_helper.c:1851
>       drm_fb_helper_initial_config+0x3c/0x58 =
drivers/gpu/drm/drm_fb_helper.c:1916
>       drm_fbdev_client_hotplug+0x154/0x22c =
drivers/gpu/drm/clients/drm_fbdev_client.c:52
>       drm_client_register+0x13c/0x1d4 drivers/gpu/drm/drm_client.c:140
>       drm_fbdev_client_setup+0x194/0x3d0 =
drivers/gpu/drm/clients/drm_fbdev_client.c:159
>       drm_client_setup+0x78/0x140 =
drivers/gpu/drm/clients/drm_client_setup.c:39
>       vkms_create drivers/gpu/drm/vkms/vkms_drv.c:218 [inline]
>       vkms_init+0x4b8/0x5ac drivers/gpu/drm/vkms/vkms_drv.c:242
>       do_one_initcall+0x250/0x990 init/main.c:1257
>       do_initcall_level+0x154/0x214 init/main.c:1319
>       do_initcalls+0x84/0xf4 init/main.c:1335
>       do_basic_setup+0x8c/0xa0 init/main.c:1354
>       kernel_init_freeable+0x2dc/0x444 init/main.c:1567
>       kernel_init+0x24/0x1dc init/main.c:1457
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #1 (console_lock){+.+.}-{0:0}:
>       console_lock+0x194/0x1ec kernel/printk/printk.c:2849
>       __bch2_print_string_as_lines fs/bcachefs/util.c:267 [inline]
>       bch2_print_string_as_lines+0x34/0x150 fs/bcachefs/util.c:286
>       __bch2_fsck_err+0xb5c/0xdd0 fs/bcachefs/error.c:562
>       __need_discard_or_freespace_err+0x14c/0x1cc =
fs/bcachefs/alloc_background.c:678
>       bch2_bucket_do_index+0x320/0x490 =
fs/bcachefs/alloc_background.c:729
>       bch2_trigger_alloc+0xd1c/0x2d54 =
fs/bcachefs/alloc_background.c:885
>       bch2_key_trigger fs/bcachefs/bkey_methods.h:88 [inline]
>       bch2_key_trigger_new fs/bcachefs/bkey_methods.h:116 [inline]
>       run_one_trans_trigger fs/bcachefs/btree_trans_commit.c:516 =
[inline]
>       bch2_trans_commit_run_triggers =
fs/bcachefs/btree_trans_commit.c:550 [inline]
>       __bch2_trans_commit+0x634/0x62d0 =
fs/bcachefs/btree_trans_commit.c:990
>       bch2_trans_commit fs/bcachefs/btree_update.h:195 [inline]
>       btree_update_nodes_written =
fs/bcachefs/btree_update_interior.c:705 [inline]
>       btree_interior_update_work+0xb80/0x1cfc =
fs/bcachefs/btree_update_interior.c:843
>       process_one_work+0x7e8/0x156c kernel/workqueue.c:3238
>       process_scheduled_works kernel/workqueue.c:3319 [inline]
>       worker_thread+0x958/0xed8 kernel/workqueue.c:3400
>       kthread+0x5fc/0x75c kernel/kthread.c:464
>       ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
>=20
> -> #0 (&c->fsck_error_msgs_lock){+.+.}-{4:4}:
>       check_prev_add kernel/locking/lockdep.c:3166 [inline]
>       check_prevs_add kernel/locking/lockdep.c:3285 [inline]
>       validate_chain kernel/locking/lockdep.c:3909 [inline]
>       __lock_acquire+0x1728/0x3058 kernel/locking/lockdep.c:5235
>       lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5866
>       __mutex_lock_common+0x1d0/0x2190 kernel/locking/mutex.c:601
>       __mutex_lock kernel/locking/mutex.c:746 [inline]
>       mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:798
>       __bch2_count_fsck_err+0x58/0x98 fs/bcachefs/error.c:385
>       __bch2_i_sectors_acct+0x328/0x3c4 fs/bcachefs/fs-io.c:155
>       bch2_i_sectors_acct fs/bcachefs/fs-io.h:138 [inline]
>       bchfs_fpunch+0x23c/0x404 fs/bcachefs/fs-io.c:578
>       bch2_fallocate_dispatch+0x378/0x4e0 fs/bcachefs/fs-io.c:838
>       vfs_fallocate+0x5cc/0x73c fs/open.c:338
>       ioctl_preallocate fs/ioctl.c:290 [inline]
>       file_ioctl fs/ioctl.c:-1 [inline]
>       do_vfs_ioctl+0x1d4c/0x2218 fs/ioctl.c:885
>       __do_sys_ioctl fs/ioctl.c:904 [inline]
>       __se_sys_ioctl fs/ioctl.c:892 [inline]
>       __arm64_sys_ioctl+0xe4/0x1c4 fs/ioctl.c:892
>       __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
>       invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
>       el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
>       do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
>       el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
>       el0t_64_sync_handler+0x78/0x108 =
arch/arm64/kernel/entry-common.c:786
>       el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
> other info that might help us debug this:
>=20
> Chain exists of:
>  &c->fsck_error_msgs_lock --> sb_pagefaults#3 --> =
&inode->ei_quota_lock
>=20
> Possible unsafe locking scenario:
>=20
>       CPU0                    CPU1
>       ----                    ----
>  lock(&inode->ei_quota_lock);
>                               lock(sb_pagefaults#3);
>                               lock(&inode->ei_quota_lock);
>  lock(&c->fsck_error_msgs_lock);
>=20
> *** DEADLOCK ***
>=20
> 3 locks held by syz.1.109/7273:
> #0: ffff0000d8e5e420 (sb_writers#17){.+.+}-{0:0}, at: file_start_write =
include/linux/fs.h:3041 [inline]
> #0: ffff0000d8e5e420 (sb_writers#17){.+.+}-{0:0}, at: =
vfs_fallocate+0x564/0x73c fs/open.c:337
> #1: ffff0000f1fb1078 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: =
inode_lock include/linux/fs.h:867 [inline]
> #1: ffff0000f1fb1078 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: =
bch2_fallocate_dispatch+0x1a8/0x4e0 fs/bcachefs/fs-io.c:827
> #2: ffff0000f1fb1558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: =
bch2_i_sectors_acct fs/bcachefs/fs-io.h:137 [inline]
> #2: ffff0000f1fb1558 (&inode->ei_quota_lock){+.+.}-{4:4}, at: =
bchfs_fpunch+0x228/0x404 fs/bcachefs/fs-io.c:578
>=20
> stack backtrace:
> CPU: 1 UID: 0 PID: 7273 Comm: syz.1.109 Not tainted =
6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 PREEMPT=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, =
BIOS Google 02/12/2025
> Call trace:
> show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
> __dump_stack+0x30/0x40 lib/dump_stack.c:94
> dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
> dump_stack+0x1c/0x28 lib/dump_stack.c:129
> print_circular_bug+0x324/0x32c kernel/locking/lockdep.c:2079
> check_noncircular+0x154/0x174 kernel/locking/lockdep.c:2211
> check_prev_add kernel/locking/lockdep.c:3166 [inline]
> check_prevs_add kernel/locking/lockdep.c:3285 [inline]
> validate_chain kernel/locking/lockdep.c:3909 [inline]
> __lock_acquire+0x1728/0x3058 kernel/locking/lockdep.c:5235
> lock_acquire+0x14c/0x2e0 kernel/locking/lockdep.c:5866
> __mutex_lock_common+0x1d0/0x2190 kernel/locking/mutex.c:601
> __mutex_lock kernel/locking/mutex.c:746 [inline]
> mutex_lock_nested+0x2c/0x38 kernel/locking/mutex.c:798
> __bch2_count_fsck_err+0x58/0x98 fs/bcachefs/error.c:385
> __bch2_i_sectors_acct+0x328/0x3c4 fs/bcachefs/fs-io.c:155
> bch2_i_sectors_acct fs/bcachefs/fs-io.h:138 [inline]
> bchfs_fpunch+0x23c/0x404 fs/bcachefs/fs-io.c:578
> bch2_fallocate_dispatch+0x378/0x4e0 fs/bcachefs/fs-io.c:838
> vfs_fallocate+0x5cc/0x73c fs/open.c:338
> ioctl_preallocate fs/ioctl.c:290 [inline]
> file_ioctl fs/ioctl.c:-1 [inline]
> do_vfs_ioctl+0x1d4c/0x2218 fs/ioctl.c:885
> __do_sys_ioctl fs/ioctl.c:904 [inline]
> __se_sys_ioctl fs/ioctl.c:892 [inline]
> __arm64_sys_ioctl+0xe4/0x1c4 fs/ioctl.c:892
> __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
> invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
> el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
> do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
> el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
> el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
> el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20

#syz fix: bcachefs: Fix possible console lock involved deadlock=
