Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1469F1482E7
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Dec 2024 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733669966; cv=none; b=quf51ti2wOWyT6TOS44awYYSTorY3+5KX2MOqgtz5f7n4rk4WpmCWQuZB2E15OrQNil0gLCx1INtgFVKgkJRTumtX/9GpgK8KVlx5czudaLDBDBnW/dX8I3PiBQLEWBAMuMituyRg9Cl+kmncqp6dInRh4bAM2HU0XZ5u/6zwy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733669966; c=relaxed/simple;
	bh=3eEtEjidtXgDTzg0B5z3UjOOpWcT5V8O8V9112HM0DE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=la04kfA/oV+Guz3MeApsUmCoRC/ydIt6vYHLmLcSFPk4ydSuFlUso/vyuddSuII9CKsmdbc6C0tAYrvBX7cFDOMvKcTvcJmofN+GCQYS7JJqwQFKDJe0rgWGoZ3yWN1IeVvfSess23uU0BgkTbsWgf6AP35OKppZDQWpsoAY1lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a817e4aa67so18244265ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 08 Dec 2024 06:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733669964; x=1734274764;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+dH42NuaY+7+1vYTGlakEtjQichGEMtShMQvwnmre8=;
        b=tKtf38XwO+TERLD1tF/z0wuJoTzwgUm3oCM15F/x5MWE1FJ0McIdnGL6/fF9jU0x8S
         f263hZ3l+7rPENN89sHg8m41oewg8IonzPQnZjBqq/fWX4uxatiE8O4AyUGmRmviZsFX
         4kBdm38HPz4VnBT766XcL1PxMPqe9XN7g9RMYjXMAT0q1hQOfJje4YpSvgN+qd4Gl9b1
         xSXkIa37ylzLxtj/30RY0Bb14WEbow3pMSHdXlw1HsovRtlfLFRzm2cR++Tv8S4HGiOp
         gXPGOhTD17lHAWOhjkWtmIBCxhinUJdVYvjHfEv7ogcYta6TWTzfC72F+K/HAzIqGntH
         80Lg==
X-Forwarded-Encrypted: i=1; AJvYcCWQxCLqRisvhBlkCm0q+s8cnoltPoRURJVnJxTJsO9hQnJv8UJ9dn5rMxCgD7RgRjgxAQPCkCi0kOktQHlLkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywh1e/3NPVLaJ7uv6miMBNkdHFUEywuRVuv/ZZpzYv6AyMORy87
	z8SJEm71MrulVBDwQd6pij/OHCdYRNglZd9uC3Ch3P+pAeFParTfmlAm4yoAZCsy9JwXeld/Q7l
	R2skAiBQ4v8fRpcToBugF7Sm1cBmksnYl/xh6iBIIuGanLZDaxy+qBP0=
X-Google-Smtp-Source: AGHT+IEKH+adj4zmgBG5crQuoOfI/LMIdrwhC63fRiECEEgCikDhNZGyN91QBH+hHlEAMRLEYPsb5z1d1f0xN2y/A1DpqHyrcPlv
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168a:b0:3a7:8d8e:e760 with SMTP id
 e9e14a558f8ab-3a811dab4dfmr93560865ab.4.1733669964149; Sun, 08 Dec 2024
 06:59:24 -0800 (PST)
Date: Sun, 08 Dec 2024 06:59:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6755b44c.050a0220.2477f.002a.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_bucket_alloc_trans
From: syzbot <syzbot+c761143a86b1640bc485@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ceb8bf2ceaa7 module: Convert default symbol namespace to s..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f560f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=96ee18b6611821ab
dashboard link: https://syzkaller.appspot.com/bug?extid=c761143a86b1640bc485
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2cdefe23324a/disk-ceb8bf2c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/db82aad0847e/vmlinux-ceb8bf2c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/616c479edfca/bzImage-ceb8bf2c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c761143a86b1640bc485@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
BUG: KMSAN: uninit-value in try_alloc_bucket fs/bcachefs/alloc_foreground.c:314 [inline]
BUG: KMSAN: uninit-value in bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:525 [inline]
BUG: KMSAN: uninit-value in bch2_bucket_alloc_trans+0x2533/0x3fb0 fs/bcachefs/alloc_foreground.c:648
 bch2_alloc_to_v4 fs/bcachefs/alloc_background.h:235 [inline]
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:314 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:525 [inline]
 bch2_bucket_alloc_trans+0x2533/0x3fb0 fs/bcachefs/alloc_foreground.c:648
 bch2_bucket_alloc_set_trans+0x959/0x1650 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x1dec/0x3070 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x328/0x530 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0x1833/0x32b0
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:339 [inline]
 bch2_btree_reserve_get+0x9d6/0x2290 fs/bcachefs/btree_update_interior.c:549
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1247
 bch2_btree_node_rewrite+0x1da/0x1930 fs/bcachefs/btree_update_interior.c:2148
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
 bkey_reassemble fs/bcachefs/bkey.h:513 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:259 [inline]
 btree_key_cache_fill+0x13da/0x3d60 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x988/0xe20 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x749/0x47b0 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_btree_iter_peek_slot+0x10b7/0x3950 fs/bcachefs/btree_iter.c:2629
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:575 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:589 [inline]
 try_alloc_bucket fs/bcachefs/alloc_foreground.c:305 [inline]
 bch2_bucket_alloc_freelist fs/bcachefs/alloc_foreground.c:525 [inline]
 bch2_bucket_alloc_trans+0x1bd5/0x3fb0 fs/bcachefs/alloc_foreground.c:648
 bch2_bucket_alloc_set_trans+0x959/0x1650 fs/bcachefs/alloc_foreground.c:808
 __open_bucket_add_buckets+0x1dec/0x3070 fs/bcachefs/alloc_foreground.c:1057
 open_bucket_add_buckets+0x328/0x530 fs/bcachefs/alloc_foreground.c:1101
 bch2_alloc_sectors_start_trans+0x1833/0x32b0
 __bch2_btree_node_alloc fs/bcachefs/btree_update_interior.c:339 [inline]
 bch2_btree_reserve_get+0x9d6/0x2290 fs/bcachefs/btree_update_interior.c:549
 bch2_btree_update_start+0x1af9/0x2d60 fs/bcachefs/btree_update_interior.c:1247
 bch2_btree_node_rewrite+0x1da/0x1930 fs/bcachefs/btree_update_interior.c:2148
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

CPU: 1 UID: 0 PID: 4195 Comm: kworker/u8:25 Not tainted 6.13.0-rc1-syzkaller-00005-gceb8bf2ceaa7 #0
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
