Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FD114F121
	for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 23:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740267211; cv=none; b=Shh2SkFr4mnKODLNKX3zSYwolzIUKBAx8uaUdEQuxlHXmqX4GsP19ze44ZmsT3ylFvcsRyY0/0UmDmvDoNnpYdsewB/zV4yHRuSlR00VKVflKMfYeX+tChti7pYwTwqRCnfYAP0YPV6niigwYB7ReVFWyciwRIbObB4cysvASH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740267211; c=relaxed/simple;
	bh=uas6clKwNldDoa2lEUpRUzZU13MKNtGqID8wRHlraZQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Kcrh3NDLVwOo5Nypr27lWinoQpeNF0PdhswExz8BXG96Dj/ZtAHh3IJd48RAtbLi5MEJa54eN0RMBs76JdkGQfUroQuPx52G00I/ASkixmnX9AdPtYot3YtztINUs8MnF65HAU0Mg7MXQ+JPcUMbIegZ/eCW0aXYNB8z/YPtnGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d054d79dacso64406415ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 22 Feb 2025 15:33:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740267209; x=1740872009;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LDf0vlKLZOdygl2+qkCD9Fk61ry0RL011juTt7FNvFY=;
        b=Bo8aEZZHoZmJC8i3WVpPd0p3q40jCowKq40B/MXvl2S4dYnE1sHgeyO/H6sTM3Qz87
         Kor5i3uBEvPgXqSA49IXBn+tS6PJBGoxts/80D95wtm4e45PMZ+lshYGeI0GZ10vfSgZ
         6bZvu/fd8xHaJky0WE+jd08xCEyoHmSMKxnuu+kMovTFjbQTTzuUR0X6Ur9KeVbH6U1b
         HQadajDgcQxlwxHr9/IXdr7xiA80suLBwaqxW44avTh5dhVR2AcGm125AqM2zTUqlrSo
         GQ+KcizotXKoDani1wz9lq/omJoxE1g5rgrOLKtNfh5RTrExhcy9uyoYGTnA7K/wfCK6
         jlNg==
X-Forwarded-Encrypted: i=1; AJvYcCU4pd6PV6tUdRjsxMmJLXSaHxOTR0OJY4QdPFPuMGa6LObxwecR/3TG8ivlWZzR9Mw66KUDW6zSF8z4JApusA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxlA0Q7bRnhbjv87DOWGI7eCxwwvUz0a0+OGmUHgfbFh850skEA
	FtwS4MDY9h9GfJKjuMIEVFMp9Jvm+T2Z0JZmhN0hYITzc862USaN33vJYuH5fps0RCxxwinuqby
	eIDa400ZutYt/XqIz91cUpQC+JxmLtByLWXzRhJRs2bPVs9Pgkv2Yw7c=
X-Google-Smtp-Source: AGHT+IFQzfXa6jjE12sQT4rN8bLnT8gsz9p92D+xg09k4a1cQjqmcyqBx4Y9ZMqWbpoWlXEYSjM+S33/ew37MDaYkwwhxveMFp5R
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3092:b0:3d0:21aa:a756 with SMTP id
 e9e14a558f8ab-3d2cae4c215mr92664735ab.5.1740267208902; Sat, 22 Feb 2025
 15:33:28 -0800 (PST)
Date: Sat, 22 Feb 2025 15:33:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ba5ec8.050a0220.bbfd1.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: global-out-of-bounds Read in rcu_pending_pcpu_dequeue
From: syzbot <syzbot+636e4465e7193ea92a97@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2408a807bfc3 Merge tag 'vfs-6.14-rc4.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17621898580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6cc40dfe827ffb85
dashboard link: https://syzkaller.appspot.com/bug?extid=636e4465e7193ea92a97
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3bbfce004a48/disk-2408a807.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0151460c5539/vmlinux-2408a807.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8dfe7f8b2862/bzImage-2408a807.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+636e4465e7193ea92a97@syzkaller.appspotmail.com

bcachefs (loop3): starting version 1.7: mi_btree_bitmap opts=errors=continue,metadata_checksum=none,data_checksum=none,compression=lz4,nocow
bcachefs (loop3): initializing new filesystem
bcachefs (loop3): going read-write
bcachefs (loop3): marking superblocks
------------[ cut here ]------------
==================================================================
BUG: KASAN: global-out-of-bounds in string_nocheck lib/vsprintf.c:632 [inline]
BUG: KASAN: global-out-of-bounds in string+0x229/0x2b0 lib/vsprintf.c:714
Read of size 1 at addr ffffffff8c74adc9 by task syz.3.23/6077

CPU: 0 UID: 0 PID: 6077 Comm: syz.3.23 Not tainted 6.14.0-rc3-syzkaller-00012-g2408a807bfc3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 string_nocheck lib/vsprintf.c:632 [inline]
 string+0x229/0x2b0 lib/vsprintf.c:714
 vsnprintf+0x8b4/0x1220 lib/vsprintf.c:2843
 vprintk_store+0x482/0x1240 kernel/printk/printk.c:2279
 vprintk_emit+0x271/0xa10 kernel/printk/printk.c:2408
 __warn_printk+0x263/0x360 kernel/panic.c:797
 look_up_lock_class+0xdb/0x170 kernel/locking/lockdep.c:938
 register_lock_class+0x102/0x980 kernel/locking/lockdep.c:1292
 __lock_acquire+0xf3/0x2100 kernel/locking/lockdep.c:5103
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0xd3/0x120 kernel/locking/spinlock.c:170
 spin_lock_irq include/linux/spinlock.h:376 [inline]
 rcu_pending_pcpu_dequeue+0x29/0x2b0 fs/bcachefs/rcu_pending.c:538
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:143 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:222 [inline]
 btree_key_cache_fill+0x496/0x3840 fs/bcachefs/btree_key_cache.c:319
 bch2_btree_path_traverse_cached+0x8b2/0xc60 fs/bcachefs/btree_key_cache.c:381
 bch2_btree_path_traverse_one+0x46a/0x2930 fs/bcachefs/btree_iter.c:1179
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:249 [inline]
 bch2_btree_iter_peek_slot+0x8c0/0x27c0 fs/bcachefs/btree_iter.c:2784
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:585 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:599 [inline]
 bch2_trans_start_alloc_update_noupdate+0x385/0x5e0 fs/bcachefs/alloc_background.c:458
 __bch2_trans_mark_metadata_bucket fs/bcachefs/buckets.c:955 [inline]
 bch2_trans_mark_metadata_bucket+0x2f8/0x17b0 fs/bcachefs/buckets.c:1043
 bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1060 [inline]
 __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1100 [inline]
 bch2_trans_mark_dev_sb+0x3f6/0x820 fs/bcachefs/buckets.c:1128
 bch2_trans_mark_dev_sbs_flags+0x6be/0x720 fs/bcachefs/buckets.c:1138
 bch2_fs_initialize+0xba0/0x1610 fs/bcachefs/recovery.c:1149
 bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
 bch2_fs_get_tree+0xdb7/0x17a0 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f189278e58a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1893561e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f1893561ef0 RCX: 00007f189278e58a
RDX: 0000400000000100 RSI: 0000400000000180 RDI: 00007f1893561eb0
RBP: 0000400000000100 R08: 00007f1893561ef0 R09: 0000000000000010
R10: 0000000000000010 R11: 0000000000000246 R12: 0000400000000180
R13: 00007f1893561eb0 R14: 00000000000059fa R15: 0000400000000480
 </TASK>

The buggy address belongs to the variable:
 .str+0x9/0x20

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0xc74a
flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000002000 ffffea000031d288 ffffea000031d288 0000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner info is not present (never set?)

Memory state around the buggy address:
 ffffffff8c74ac80: 00 00 00 02 f9 f9 f9 f9 00 05 f9 f9 02 f9 f9 f9
 ffffffff8c74ad00: 06 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 00
>ffffffff8c74ad80: 00 00 00 00 00 00 00 00 00 01 f9 f9 00 00 00 04
                                              ^
 ffffffff8c74ae00: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff8c74ae80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


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
