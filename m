Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA626218E98
	for <linux-bcachefs@vger.kernel.org>; Thu,  5 Dec 2024 17:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733421566; cv=none; b=MkTHhSWtyYLX/Dc07Ci36T3kh6uZrdsXNExHGdyPUud5YW9ZdpxNdRN4UXuKzEu7ZuXHHxD6o+wuPmqO+h9rqlqdTJ3lAxRVWEt9nXv2w8b68yhOh9BOlBZU/1M6J9lUttpwRrtEQW4HOX6twxOURUmIT69qOIf+0yb6rwuwQ50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733421566; c=relaxed/simple;
	bh=zEeiNmSEhErUUQUcYSZqCWm5VAqvjdNUtlEPhSwmIpU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TAFRwBdGMOaHfGxWJOeyLGfCWHR6bclJkZ1f0mrrxP7SebbAC8ADGkSpAixH60N4hMAGW5zdmiUXcDMLWaS5dh8jcl5DvLbi7+8J78G1OZqBEkAH9t98sqSxjO6iBgo8MMipFtAAyFpqaqEJRXIATrTNPpfIXvf9x8TfNmJLI1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3a77085a3d7so12448825ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 05 Dec 2024 09:59:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733421564; x=1734026364;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9uZpi8Iuw70cK75Uave8vr+GVhhyP8UYYDIfkxq/cNU=;
        b=XdMD+4JXuOfNx5dUY61fxvEfTqyC5UgSFrLEpffD+/hlO9aQO3Z3fDgByyx5qEBwdR
         KCmkKQoEReHMvgvybEY/FnOW1zVgs4t4xlI/lGyC+tV/4BqZOWVjGOWkEqnuZmUr8MkH
         RlZXBZqv/VJ5jymXN1KvJAtN4htU1Ph+P+XtTO+5+MkmUBrJCuT1YOld/5OzLI58dGnq
         UGvYPO6TqoosAvnC08n2j5Ang0nY1N+22n26cU8cyNtM8E+Pjfn1AROHujbIjrGOaxuM
         58bjSVHVXzRvR2XZELuXIyKDWQlKk37ReSgcoO5B9KHP5mrVVhdvstEqIyTq0CKAh/TG
         ajdA==
X-Forwarded-Encrypted: i=1; AJvYcCXSuxlFKPeBwktg+V07j3Bq8U3J1NVHYvdWKZxaGEcoc/DbhnL1A5J9QRc7PA0UGq+BgbPELrCDS+DIZdb2Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd4qqq6JXB9e6HgRPX6kasC0jfoMNDfyUA2ljqRAsP47LeKJ51
	9Hmlufmr3QTLgbaMeKqI5mKFJX1oMsEIkVX6cBgJvMLHbsRXHPk0WK0We2mer2l/b3AHbgYuM4d
	yoCcWafD+CiKcpUidmdgUf39OaHafUB1Ec3rvHxOKBoFW0sclQ2YC/+U=
X-Google-Smtp-Source: AGHT+IGdef9FpppOq9RdQhXGnWQPv7jdR1YV+LsZFqswSkoERaRA9ptwssw33EIpHORvr3aXI4p+Tt3V0LhbEvslwhgsrsj7C+SG
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216a:b0:3a7:e0e4:df08 with SMTP id
 e9e14a558f8ab-3a807606312mr46407665ab.7.1733421563793; Thu, 05 Dec 2024
 09:59:23 -0800 (PST)
Date: Thu, 05 Dec 2024 09:59:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6751e9fb.050a0220.b4160.01e2.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in check_extent_overbig
From: syzbot <syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    feffde684ac2 Merge tag 'for-6.13-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15a690f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=91c852e3d1d7c1a6
dashboard link: https://syzkaller.appspot.com/bug?extid=fbc1f6040dd365cce0d8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16804020580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12ed1330580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2efea2e60149/disk-feffde68.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f5331b060319/vmlinux-feffde68.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ffe1099c1fd2/bzImage-feffde68.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/06aa5ff84226/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/bd3f07c6e88c/mount_5.gz
mounted in repro #3: https://storage.googleapis.com/syzbot-assets/d5374aa959a7/mount_6.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fbc1f6040dd365cce0d8@syzkaller.appspotmail.com

  u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durability: 1 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4 ptr: 0:34:8 gen 0, fixing
==================================================================
BUG: KASAN: use-after-free in __extent_entry_type fs/bcachefs/extents.h:54 [inline]
BUG: KASAN: use-after-free in extent_entry_is_crc fs/bcachefs/extents.h:121 [inline]
BUG: KASAN: use-after-free in check_extent_overbig+0x27b/0x7d0 fs/bcachefs/fsck.c:1904
Read of size 8 at addr ffff8880518a0188 by task syz-executor254/7637

CPU: 1 UID: 0 PID: 7637 Comm: syz-executor254 Not tainted 6.13.0-rc1-syzkaller-00025-gfeffde684ac2 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 __extent_entry_type fs/bcachefs/extents.h:54 [inline]
 extent_entry_is_crc fs/bcachefs/extents.h:121 [inline]
 check_extent_overbig+0x27b/0x7d0 fs/bcachefs/fsck.c:1904
 bch2_check_extents+0xa23/0x65a0 fs/bcachefs/fsck.c:2037
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc6920b111a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 1e 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc691859048 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000020000000 RCX: 00007fc6920b111a
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 00007fc6918590a0
RBP: 00000000200000c0 R08: 00007fc6918590e0 R09: 000000000000598a
R10: 0000000000800000 R11: 0000000000000282 R12: 00007fc6918590a0
R13: 00007fc6918590e0 R14: 0000000000005991 R15: 0000000020006a00
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x518a0
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Unmovable, gfp_mask 0x52800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP), pid 7637, tgid 7636 (syz-executor254), ts 149145294872, free_ts 151843036086
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3651/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 ___kmalloc_large_node+0x8b/0x1d0 mm/slub.c:4228
 __kmalloc_large_node_noprof+0x1a/0x80 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0x33a/0x4d0 mm/slub.c:4289
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 bch2_btree_node_read_done+0x3808/0x5e90 fs/bcachefs/btree_io.c:1188
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x29f0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
page last free pid 7637 tgid 7636 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0xc87/0xf80 mm/page_alloc.c:1269
 __folio_put+0x2c7/0x440 mm/swap.c:112
 folio_put include/linux/mm.h:1488 [inline]
 free_large_kmalloc+0x105/0x1c0 mm/slub.c:4717
 kfree+0x212/0x430 mm/slub.c:4740
 btree_bounce_free fs/bcachefs/btree_io.c:112 [inline]
 btree_node_sort+0x1100/0x1830 fs/bcachefs/btree_io.c:380
 bch2_btree_post_write_cleanup+0x11a/0xa70 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_prep_for_write+0x55b/0x8f0 fs/bcachefs/btree_trans_commit.c:93
 bch2_trans_lock_write+0x68e/0xc60 fs/bcachefs/btree_trans_commit.c:129
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:896 [inline]
 __bch2_trans_commit+0x26f2/0x93c0 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 check_extent fs/bcachefs/fsck.c:1994 [inline]
 bch2_check_extents+0x4579/0x65a0 fs/bcachefs/fsck.c:2037
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814

Memory state around the buggy address:
 ffff8880518a0080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880518a0100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880518a0180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                      ^
 ffff8880518a0200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880518a0280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
