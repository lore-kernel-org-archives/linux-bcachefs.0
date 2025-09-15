Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E9115B0FE
	for <linux-bcachefs@vger.kernel.org>; Mon, 15 Sep 2025 01:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757900919; cv=none; b=sCfrHQGstxp+taOmtRW2/7IyggIa3aSIbeeNaG7WZ8qgC0MUKMXCmgFqdr26+zCRKOmB2a6FNivX4ZMDkaE+H/9bguguNFoxKUzGTT7cPv3Lh5uyGk7Zf4JPDfPrwnlFBttL9WQjO9JWd1F3ZnlhHnFSeEjaYsQWCjd/FByioRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757900919; c=relaxed/simple;
	bh=CkvpkExQAfH2OjXjHI8UI6S/tY7kRSr8lhntTVg3IGA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gA+7/skDFFCf6FDK5curuTGPztreOYtsIz/W7u+Yy7jsthUQp084vX78hsN4HMDWxnO8UzbbveAGIDQIiYHWFi0bC83TvCQuTCLvW0sdDw4r6ygWkHN5q71KVfOn2BGFc21brU+vPdG0LPcKJo+5QqvAwe22+X8u/sRSHsxpSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-4133da01bdcso71423815ab.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Sep 2025 18:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757900916; x=1758505716;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uZA9FXENjEJqXH4Rmvuhvla4h9SuV8+cY4bNMe6nevw=;
        b=OPtZNB98/LsSVxC5dQYI3RlAY4HgTu3+4pnCQ5Raj/MvHIf2jTqUXg48Xwb5Iz97m2
         R82Z7f9XFzDTW3PnxqcSoihD/dmzkXu9d5IUmGz+mEzj68CiiNgcNGa8f+uzUQ0gwozv
         4eK2hLgMk2s6FZHadZ3oUjb+/lf6Y0paMC/MpWiMHBDo3MC7/XZxpKuzSabVh1CTwc2Y
         oY7Bm/UyOuT1r17e2+GGRg3KhC95zW+3bbuIRbq6DkrLP7ua47O2/OWmYKEhSTxPcfCb
         cOXwe3rKGSFIIKzNbQ9cRC+YzXv8uKkx5dotZEy3ZaOM6se+rnruEu8iMafJMGy6P6Jn
         mPdw==
X-Forwarded-Encrypted: i=1; AJvYcCXW1ynp2o+RrpGfA/UHNYLNfUTA8YJi+zKbtA8dThnspMOACI1SEHMymCnH+h7HojEiFzx26GEfl8PkQPRXag==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG0INZ4VpzauncrjZ7rx8+UlDhFvqvGv5IEd/YWrmB/uDyn4F4
	Uj2O7Zj01Gcojvj+08XJSQEN7zPmsAiFrBMLo/26wx0i44FL9+wkUZvBU1C/NuS8OFiUatvcHFG
	h7YoWHIFY8hycdUNV3MAt0Zvx1wnS5Umd4YLOZhJlex87NJwcGHX8XnzlQt0=
X-Google-Smtp-Source: AGHT+IEk33NYKkGPfx3Ik0d6VrztbTutmIBK7teLaowH+HZDDSK2svO+/bFkWQGTd7s7td/Ae3UMnNjcZA+JMvd0yoN7N3XIq/tS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24e:0:b0:423:fc5c:c7b9 with SMTP id
 e9e14a558f8ab-423fc5cc9eemr33492245ab.1.1757900916438; Sun, 14 Sep 2025
 18:48:36 -0700 (PDT)
Date: Sun, 14 Sep 2025 18:48:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c77074.050a0220.50883.000f.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in __bch2_read_endio
From: syzbot <syzbot+7fb23a5461e8c9d38a3e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7aac71907bde Merge tag 'nfs-for-6.17-3' of git://git.linux..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1336c362580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ee07385471829e7
dashboard link: https://syzkaller.appspot.com/bug?extid=7fb23a5461e8c9d38a3e
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/097016e74836/disk-7aac7190.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/bbf1c7ba046b/vmlinux-7aac7190.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b0ef6a7b95ca/bzImage-7aac7190.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7fb23a5461e8c9d38a3e@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in __bch2_read_endio+0xb2a/0x2240 fs/bcachefs/io_read.c:832
 __bch2_read_endio+0xb2a/0x2240 fs/bcachefs/io_read.c:832
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xb8e/0x1d80 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1e3/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 __bch2_checksum_bio+0x1097/0x1130 fs/bcachefs/checksum.c:239
 bch2_checksum_bio+0xc5/0x110 fs/bcachefs/checksum.c:252
 __bch2_read_endio+0x8e3/0x2240 fs/bcachefs/io_read.c:831
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xb8e/0x1d80 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1e3/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 put_unaligned_le64 include/linux/unaligned.h:43 [inline]
 poly1305_core_emit+0x46a/0x480 lib/crypto/poly1305-donna64.c:183
 poly1305_emit_generic include/crypto/internal/poly1305.h:55 [inline]
 poly1305_final+0x88/0x150 lib/crypto/poly1305.c:68
 __bch2_checksum_bio+0x1048/0x1130 fs/bcachefs/checksum.c:237
 bch2_checksum_bio+0xc5/0x110 fs/bcachefs/checksum.c:252
 __bch2_read_endio+0x8e3/0x2240 fs/bcachefs/io_read.c:831
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xb8e/0x1d80 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1e3/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was stored to memory at:
 poly1305_core_blocks+0x65c/0x670 lib/crypto/poly1305-donna64.c:108
 poly1305_blocks_generic include/crypto/internal/poly1305.h:44 [inline]
 poly1305_blocks lib/crypto/poly1305.c:39 [inline]
 poly1305_update+0x158/0x380 lib/crypto/poly1305.c:45
 __bch2_checksum_bio+0x429/0x1130 fs/bcachefs/checksum.c:233
 bch2_checksum_bio+0xc5/0x110 fs/bcachefs/checksum.c:252
 __bch2_read_endio+0x8e3/0x2240 fs/bcachefs/io_read.c:831
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xb8e/0x1d80 kernel/workqueue.c:3319
 worker_thread+0xedf/0x1590 kernel/workqueue.c:3400
 kthread+0xd59/0xf00 kernel/kthread.c:463
 ret_from_fork+0x1e3/0x310 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Uninit was created at:
 __alloc_frozen_pages_noprof+0x689/0xf00 mm/page_alloc.c:5171
 alloc_pages_mpol+0x328/0x860 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof mm/mempolicy.c:2507 [inline]
 folio_alloc_noprof+0x109/0x360 mm/mempolicy.c:2517
 filemap_alloc_folio_noprof+0x9d/0x420 mm/filemap.c:1007
 ractl_alloc_folio mm/readahead.c:186 [inline]
 ra_alloc_folio mm/readahead.c:441 [inline]
 page_cache_ra_order+0x83c/0x13f0 mm/readahead.c:506
 page_cache_sync_ra+0x10ac/0x1410 mm/readahead.c:619
 filemap_get_pages+0xfb3/0x3a60 mm/filemap.c:2603
 filemap_read+0x5d2/0x2300 mm/filemap.c:2712
 bch2_read_iter+0x559/0x21b0 fs/bcachefs/fs-io-direct.c:222
 __kernel_read+0x7de/0xe20 fs/read_write.c:530
 integrity_kernel_read+0x77/0x90 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:480 [inline]
 ima_calc_file_shash security/integrity/ima/ima_crypto.c:511 [inline]
 ima_calc_file_hash+0x17cb/0x4050 security/integrity/ima/ima_crypto.c:568
 ima_collect_measurement+0x45d/0xe50 security/integrity/ima/ima_api.c:293
 process_measurement+0x2d1a/0x40e0 security/integrity/ima/ima_main.c:405
 ima_file_check+0x8e/0xd0 security/integrity/ima/ima_main.c:633
 security_file_post_open+0xbf/0x530 security/security.c:3160
 do_open fs/namei.c:3889 [inline]
 path_openat+0x5ac3/0x6760 fs/namei.c:4046
 do_filp_open+0x280/0x660 fs/namei.c:4073
 do_sys_openat2+0x1bb/0x2f0 fs/open.c:1435
 do_sys_open fs/open.c:1450 [inline]
 __do_sys_openat fs/open.c:1466 [inline]
 __se_sys_openat fs/open.c:1461 [inline]
 __x64_sys_openat+0x240/0x300 fs/open.c:1461
 x64_sys_call+0x3bcc/0x3e20 arch/x86/include/generated/asm/syscalls_64.h:258
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xd9/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 3593 Comm: kworker/u8:10 Not tainted syzkaller #0 PREEMPT(none) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: events_unbound __bch2_read_endio
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
