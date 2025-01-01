Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676E92119
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735736969; cv=none; b=U33WJbzmpxgq9cTS8VztJX7CMyYpNc6Phrct5euV33GsBJbiCVN8K3AKKpO/vyE1uRiR8VjcLG0XZ4Fb/KMbEmjjmn2Vy7XlJleLvrBCbTDbq7EbDOks6HID7YKk3UXSl8N0VBqHi1PTCeHXhroSOTph+6kKwIxjjCefupLaK20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735736969; c=relaxed/simple;
	bh=XrKtrRiSG7B0m8udnqMVlj3bozNfyIncj09QO7wKK6I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PtasKC8WHACToOJf0HrGYemGLo6T6/Yordey47Qggp7MgBTRq6q3KxEPFo63UMZV1O+9VHVHLRR6IAZoG2jY+HR1udy2TNoIiZvleZwBr7qtx/fVqPve0Zw6wTSylUegLz0D4KNAzorklHzkNfFPnZO4x0fFiuXhKLJ2OGtnnqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a81684bac0so217409685ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 05:09:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735736966; x=1736341766;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvEvK+Oj6mZoKg4bUW+unrHEhUvR2U2Gf0IvfOhDt8Y=;
        b=RMMQ3TRhsoBkBxILC8hWIJfeYaoS0F4vgbNaNgOCxD6FoFrI91FVUE+60P6tJ0GO9Z
         SBkRywcX0eYWYWfIfwJZLgqO3/CSgjuUk5KOKkT0GKVt2/Fp2GoyT56Kca+EsseFW5RQ
         hP+pbPa6Gb2UmY4q0ps5OzBNZCdDzdtAYDq6XldY28E/s28lvAYkp31Vg20GXaqhLpiY
         NxS+JTRSjG/SKx2UZAyY9O3Z8gdTHRzRAnLuVhwLwQHlTsQ9baMgeA67jDCnnsF2d/Pi
         ZlUHtPet7GPa6RU/Vs4WIRJo3c/S7NbQukkUBdFeAl/xbXmQzdw1lMT5GLfVBQ1+ztg1
         vlmg==
X-Forwarded-Encrypted: i=1; AJvYcCWuw5IAWIA5hpX36oy8A7xOiaCDGap4EpcOD226NDooHuYqEc6XKkaDPI5ZrUE9ZQOQsX5h2WItRQ7MDZzCrA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxO8f9ueE1zphGtskcFEdwWbS4Vt+fa32pHOsRMsoV/t1qFKsnU
	Kjn/3ASnnNQu6tHjAtP24xk03HvV4wZobpDrsET6unmY4098V9CReAbyXy7i5/AiiBpYvKRasWV
	JWKSxntiNUohLXkMK7DLPhfZWIL+HjyS3eafLnjTJWoLaETsFnyZsKiY=
X-Google-Smtp-Source: AGHT+IEMdKIm8OWaBKfT7tF8R+1EiCE+zkNf2cUuLH0ETJ5su52ORx04aRFTnKi4Skh7mf0ccWS8hf+EqgkDFJladmabzMPGKTs5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c1:b0:3a7:e3e3:bd57 with SMTP id
 e9e14a558f8ab-3c2d533e943mr334865835ab.15.1735736966568; Wed, 01 Jan 2025
 05:09:26 -0800 (PST)
Date: Wed, 01 Jan 2025 05:09:26 -0800
In-Reply-To: <6759614f.050a0220.17f54a.0037.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67753e86.050a0220.25abdd.09ee.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_alloc_sectors_start_trans
From: syzbot <syzbot+7727bbb9b847a6d3d8de@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=117aa8b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=31c2647cf06aa81e
dashboard link: https://syzkaller.appspot.com/bug?extid=7727bbb9b847a6d3d8de
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=146cdaf8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15d83818580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da86466e08c0/disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/673316cfa30c/vmlinux-ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4d50a89ed2d4/bzImage-ccb98cce.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5f0f60916397/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7727bbb9b847a6d3d8de@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in writepoint_find fs/bcachefs/alloc_foreground.c:1313 [inline]
BUG: KMSAN: uninit-value in bch2_alloc_sectors_start_trans+0x44a/0x32b0 fs/bcachefs/alloc_foreground.c:1413
 writepoint_find fs/bcachefs/alloc_foreground.c:1313 [inline]
 bch2_alloc_sectors_start_trans+0x44a/0x32b0 fs/bcachefs/alloc_foreground.c:1413
 __bch2_write+0x7f8/0x8540 fs/bcachefs/io_write.c:1437
 bch2_write+0xec0/0x1d10 fs/bcachefs/io_write.c:1631
 closure_queue include/linux/closure.h:270 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_writepage_do_io fs/bcachefs/fs-io-buffered.c:449 [inline]
 bch2_writepages+0x24a/0x3c0 fs/bcachefs/fs-io-buffered.c:641
 do_writepages+0x427/0xc30 mm/page-writeback.c:2702
 __writeback_single_inode+0x103/0x1290 fs/fs-writeback.c:1680
 writeback_sb_inodes+0xa34/0x1c20 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2047
 wb_writeback+0x50b/0xcb0 fs/fs-writeback.c:2158
 wb_check_background_flush fs/fs-writeback.c:2228 [inline]
 wb_do_writeback fs/fs-writeback.c:2316 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was stored to memory at:
 bch2_writepage_io_alloc fs/bcachefs/fs-io-buffered.c:477 [inline]
 __bch2_writepage+0x39d9/0x3f10 fs/bcachefs/fs-io-buffered.c:599
 write_cache_pages+0xc9/0x280 mm/page-writeback.c:2659
 bch2_writepages+0x11f/0x3c0 fs/bcachefs/fs-io-buffered.c:639
 do_writepages+0x427/0xc30 mm/page-writeback.c:2702
 __writeback_single_inode+0x103/0x1290 fs/fs-writeback.c:1680
 writeback_sb_inodes+0xa34/0x1c20 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2047
 wb_writeback+0x50b/0xcb0 fs/fs-writeback.c:2158
 wb_check_background_flush fs/fs-writeback.c:2228 [inline]
 wb_do_writeback fs/fs-writeback.c:2316 [inline]
 wb_workfn+0x122c/0x1940 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3310
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3391
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4125 [inline]
 slab_alloc_node mm/slub.c:4168 [inline]
 kmem_cache_alloc_lru_noprof+0x91c/0xe20 mm/slub.c:4187
 __bch2_new_inode+0x98/0x450 fs/bcachefs/fs.c:401
 bch2_new_inode fs/bcachefs/fs.c:427 [inline]
 bch2_inode_hash_init_insert+0x7d/0x3a0 fs/bcachefs/fs.c:447
 bch2_lookup_trans fs/bcachefs/fs.c:622 [inline]
 bch2_lookup+0x1605/0x2360 fs/bcachefs/fs.c:659
 lookup_open fs/namei.c:3627 [inline]
 open_last_lookups fs/namei.c:3748 [inline]
 path_openat+0x292f/0x6200 fs/namei.c:3984
 do_filp_open+0x268/0x600 fs/namei.c:4014
 do_sys_openat2+0x1bf/0x2f0 fs/open.c:1402
 do_sys_open fs/open.c:1417 [inline]
 __do_sys_openat fs/open.c:1433 [inline]
 __se_sys_openat fs/open.c:1428 [inline]
 __x64_sys_openat+0x2a1/0x310 fs/open.c:1428
 x64_sys_call+0x36f5/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted 6.13.0-rc5-syzkaller-00004-gccb98ccef0e5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: writeback wb_workfn (flush-bcachefs-1)
=====================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
