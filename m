Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647014B084
	for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 23:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718926706; cv=none; b=sWc/aa9drv1c1v0sDF1pIinfz0RxHdUyBaWOqHt6Q+3VgBMCnAFnMQhGR6C5YEUObSIV8+yhug3kytpR02KlKfeUA6mQWwcwWw7ZHHiYkWA8S84zQDt+hxf7CmYtVacvO8xhewzSq/Lv6Us48F/A9wTUn59IhYRL2qbf8sSvqVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718926706; c=relaxed/simple;
	bh=v3D/P95J4YmfH1xUkNBGtXvM+z5IAowxMTTY6yNvt7I=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lXo7H2NE+3Ww5F9uIld1VTOTTH8+SR+71Jffy3wgEBKOClHDqFyc92LBH/rEVdk8y83OwygqFUMpAGLmz6Lne6KOC7Qktm6EU+XMYcKrIAjIixfWHccBf9vc9NQGovF6kKGJcbmzJazbiHYSi0f2KXN67BKUOS6WRHLikKYjIhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-7f12e60c050so200055539f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 20 Jun 2024 16:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718926703; x=1719531503;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4SG3zddIQssoZma5vleUSzkCskl/93/FnF9Ajg08jlI=;
        b=MV/RmVTwjBfn+ytbnsIuZhL6jyxYYrmBDv73EA/alyKjGxNXl9HqFNyv1PzWMGM5Hv
         pkeXL7Jx8Cf/wiJkfTD5liBpTZlLK2WrPYVKDRK8lVk78zsFXykhTW8WxKaNszpCowjt
         cnd4VGm1T9FETq+5cYq+ysc5eHJ0cpgqMzFYLaOyDmAHgX59r7eSx8JEICKv0bhxvbv/
         JtTlI/BT0EPh2Usx4tsJBvFyFcZtowqPAK/8VAEaKgKbNwk+ZIP6PMp9oJBhEt419wvY
         fm4hbZdAgd5CFaL1z4X6RRXJvU6LSDpKRVHEGOpihyHxvN/dnpPxKV2xJEMGu4F5H7pA
         im0g==
X-Forwarded-Encrypted: i=1; AJvYcCXMvh73B8jEn4L+4DlW99XH6RQaTMdMRk97CJbM7LkW6Qjm5Jc2Y+TIscqjoXcJm/NGfAqoA8z7zKc4MIXkGldcQ19r0ntl2TL6mYchhuk=
X-Gm-Message-State: AOJu0Yy0YoY7YToZe1xdLDA4Yx40YEftjQvAqeiLYJlU8O8Tqpg8NqRn
	eND79a02pr5tz8PcaQLTGVykoSMR66vpSVH7Tb9Qoun+83noplmKYR8ykhnJfScxNWJ2M1nZyDh
	phzdbkwnoUbavIAjB1kEUp9gIftAFQyg9jd0FW6tdmM4eKmvVj6RK8h8=
X-Google-Smtp-Source: AGHT+IGuAgj0r9ZVQxgndmmfXvDuF5QPVYaNfk49g1amZ9s3tQdAdpI//JU7Ue9SX/FTH0TGbHNdvipKDoGmVaERrs/L6anM7uKD
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:138b:b0:4b9:ace4:34ff with SMTP id
 8926c6da1cb9f-4b9ace44019mr226064173.2.1718926703632; Thu, 20 Jun 2024
 16:38:23 -0700 (PDT)
Date: Thu, 20 Jun 2024 16:38:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000090adbc061b5acfd9@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_fs_recovery
From: syzbot <syzbot+8992fc10a192067b8d8a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b992b79ca8bc Add linux-next specific files for 20240620
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16882c2a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=199e4e4d681e4b85
dashboard link: https://syzkaller.appspot.com/bug?extid=8992fc10a192067b8d8a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1951d72058a5/disk-b992b79c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/eb9ce26817e1/vmlinux-b992b79c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2f09002f6ed1/bzImage-b992b79c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8992fc10a192067b8d8a@syzkaller.appspotmail.com

bcachefs (loop4): Doing compatible version upgrade from 1.7: mi_btree_bitmap to 1.9: disk_accounting_v2
  running recovery passes: check_allocations
==================================================================
BUG: KASAN: slab-use-after-free in bch2_fs_recovery+0xe85/0x38e0 fs/bcachefs/recovery.c:705
Read of size 8 at addr ffff88805d598f98 by task syz-executor.4/7287

CPU: 0 UID: 0 PID: 7287 Comm: syz-executor.4 Not tainted 6.10.0-rc4-next-20240620-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 bch2_fs_recovery+0xe85/0x38e0 fs/bcachefs/recovery.c:705
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1034
 bch2_fs_get_tree+0xd42/0x16c0 fs/bcachefs/fs.c:1921
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3379
 do_mount fs/namespace.c:3719 [inline]
 __do_sys_mount fs/namespace.c:3925 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3902
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f03cde7e62a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f03ceb8aef8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f03ceb8af80 RCX: 00007f03cde7e62a
RDX: 000000002000f640 RSI: 000000002000f680 RDI: 00007f03ceb8af40
RBP: 000000002000f640 R08: 00007f03ceb8af80 R09: 0000000000200012
R10: 0000000000200012 R11: 0000000000000202 R12: 000000002000f680
R13: 00007f03ceb8af40 R14: 000000000000f629 R15: 00000000200000c0
 </TASK>

Allocated by task 7287:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slub.c:4145 [inline]
 kmalloc_node_track_caller_noprof+0x225/0x440 mm/slub.c:4165
 __do_krealloc mm/slab_common.c:1183 [inline]
 krealloc_noprof+0x7d/0x120 mm/slab_common.c:1216
 bch2_sb_realloc+0x2f5/0x660 fs/bcachefs/super-io.c:189
 __copy_super+0x5dc/0xe70 fs/bcachefs/super-io.c:579
 bch2_sb_to_fs+0xab/0x150 fs/bcachefs/super-io.c:606
 bch2_fs_alloc+0xd50/0x20a0 fs/bcachefs/super.c:826
 bch2_fs_open+0x8cc/0xdf0 fs/bcachefs/super.c:2109
 bch2_fs_get_tree+0x750/0x16c0 fs/bcachefs/fs.c:1908
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3379
 do_mount fs/namespace.c:3719 [inline]
 __do_sys_mount fs/namespace.c:3925 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3902
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 7287:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2218 [inline]
 slab_free mm/slub.c:4460 [inline]
 kfree+0x149/0x360 mm/slub.c:4581
 krealloc_noprof+0xcf/0x120
 bch2_sb_realloc+0x2f5/0x660 fs/bcachefs/super-io.c:189
 bch2_sb_field_resize_id+0x140/0x7c0 fs/bcachefs/super-io.c:221
 bch2_sb_counters_from_cpu+0xac/0x300 fs/bcachefs/sb-counters.c:67
 bch2_write_super+0xe80/0x3c80 fs/bcachefs/super-io.c:967
 bch2_fs_recovery+0xe6c/0x38e0 fs/bcachefs/recovery.c:703
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1034
 bch2_fs_get_tree+0xd42/0x16c0 fs/bcachefs/fs.c:1921
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3379
 do_mount fs/namespace.c:3719 [inline]
 __do_sys_mount fs/namespace.c:3925 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3902
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88805d598000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3992 bytes inside of
 freed 4096-byte region [ffff88805d598000, ffff88805d599000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5d598
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffefff(slab)
raw: 00fff00000000040 ffff888015042140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000
head: 00fff00000000040 ffff888015042140 dead000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000001ffffefff 0000000000000000
head: 00fff00000000003 ffffea0001756601 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x1d2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_HARDWALL), pid 7287, tgid 7286 (syz-executor.4), ts 171372494007, free_ts 171102290712
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1495
 prep_new_page mm/page_alloc.c:1503 [inline]
 get_page_from_freelist+0x2cbd/0x2d70 mm/page_alloc.c:3482
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4740
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2287
 allocate_slab+0x5a/0x2f0 mm/slub.c:2450
 new_slab mm/slub.c:2503 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3689
 __slab_alloc+0x58/0xa0 mm/slub.c:3779
 __slab_alloc_node mm/slub.c:3832 [inline]
 slab_alloc_node mm/slub.c:4012 [inline]
 __do_kmalloc_node mm/slub.c:4144 [inline]
 kmalloc_node_track_caller_noprof+0x281/0x440 mm/slub.c:4165
 __do_krealloc mm/slab_common.c:1183 [inline]
 krealloc_noprof+0x7d/0x120 mm/slab_common.c:1216
 bch2_sb_realloc+0x2f5/0x660 fs/bcachefs/super-io.c:189
 __copy_super+0x5dc/0xe70 fs/bcachefs/super-io.c:579
 bch2_sb_to_fs+0xab/0x150 fs/bcachefs/super-io.c:606
 bch2_fs_alloc+0xd50/0x20a0 fs/bcachefs/super.c:826
 bch2_fs_open+0x8cc/0xdf0 fs/bcachefs/super.c:2109
 bch2_fs_get_tree+0x750/0x16c0 fs/bcachefs/fs.c:1908
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
page last free pid 7290 tgid 7290 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1088 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2646
 __slab_free+0x31b/0x3d0 mm/slub.c:4371
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3962 [inline]
 slab_alloc_node mm/slub.c:4024 [inline]
 __do_kmalloc_node mm/slub.c:4144 [inline]
 kmalloc_node_track_caller_noprof+0x1cd/0x440 mm/slub.c:4165
 kvasprintf+0xdf/0x190 lib/kasprintf.c:25
 kobject_set_name_vargs+0x61/0x120 lib/kobject.c:274
 dev_set_name+0xd5/0x120 drivers/base/core.c:3482
 hci_register_dev+0xda/0x8b0 net/bluetooth/hci_core.c:2644
 __vhci_create_device drivers/bluetooth/hci_vhci.c:430 [inline]
 vhci_create_device+0x38b/0x6e0 drivers/bluetooth/hci_vhci.c:472
 vhci_get_user drivers/bluetooth/hci_vhci.c:529 [inline]
 vhci_write+0x3d1/0x490 drivers/bluetooth/hci_vhci.c:609
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0xa72/0xc90 fs/read_write.c:590
 ksys_write+0x1a0/0x2c0 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88805d598e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805d598f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88805d598f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                            ^
 ffff88805d599000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88805d599080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
