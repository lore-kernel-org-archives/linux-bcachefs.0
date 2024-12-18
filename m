Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FCE1F191B
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Dec 2024 16:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734539669; cv=none; b=QL8abKYU/fEwutZyXZUU4K7FRmhg5O2vbUksxHTYR9d3331v3ciDF575bFY4fkUuNo0xslVYNVpnIQ6bFjzY28FddijR594lOtprVQ2erkBXAYSx6vkOAMtROBfjL68ZP2wyMF7rFTsqh+u9JwEZeIvIol1zsVPt/Fu6bMu2Q8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734539669; c=relaxed/simple;
	bh=IvMG3PckXAkoeuT0VmnIRtvnPGOKzOOIxA/nb9WbfU4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=j//rvJ8jAiZiv4SC3BLQ2VufiSENnZDv1IHYps5yTEuxuM+STgGVAubmWp2sXdAqofoO5YE4cjsmQ5wxYqOTtg4R8IVx4nLKWTkL+tRRBZOteO3+XkmVpXo/DfD+4TgP3DYKsWrD/eM5VHyamLyVlqHFBUs70CNpBX47u14B8AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9d4ea9e0cso67686775ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Dec 2024 08:34:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734539665; x=1735144465;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XDHfinYKRd3x8nQKXwVb9+mUmdQef6Ds49xrca0EA2Y=;
        b=ZQu+W4AMIMoQ2Fxye2Orh17J933XL3yXxDppiEbZ+4himLfEuARknNDSBfHyZaGFiF
         T17Wj4Ux33fNVSmaWWX8+d03t4Z/Zw7nSi4IbPDTNz7d2u3H4qk9eaK9Vfbdimb6xTWd
         HpF4RjgCkFn+2yFa4WKu5oj17ZnC1RQXpNjXBcmI/LMMGngQyOEjlWUWlc+0wJyOgoof
         AIny1nyYtfofo5+6MQiJ6UJBz+EOthg1IdzDS3L/B+Al422SolSVM9PbDFfkwWL5L0a6
         uNG6yo9NAsTg+ZQN4lE7EiiaUYO5FOosqDhRUkrNmcRmiWrsHO0sD2n9FyzhkL2UR930
         RtVQ==
X-Forwarded-Encrypted: i=1; AJvYcCULr88Og7S9TZP18btxH/lviAogvNkv0Zlt+bJg7wDBPxfgyIthmOyGYx5avrOVufkm/0ngP9ibAL/wRDIyCA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4oG2cgkVJBrMeVNezipbR1x7bAb8OO2Vqg2TF5xVV/U4ijJxd
	gIDd0+S3xEAlmwHXn4K5CAL9sko5QUQQIdwoZ3Atq7voWhP5cYeBYwtscgihh0zVc0Jj7AjbDG0
	s3mIoahdlNEEIZmDE6EZ1XFuI6Mckq/GNIVR59z99ObqQRkcTUHUMLbk=
X-Google-Smtp-Source: AGHT+IFuyoD2fhEPOrAgCMZWFIaL7Q1ZLy9BNN9a7Q4d3/4HnjhX1lpsIvTp4rYTF3tLxjoFEQKcMut9Rq6ijWcvsQRfONMoYMXx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4a:0:b0:3a7:98c4:86a9 with SMTP id
 e9e14a558f8ab-3bdc4f178c1mr37036395ab.20.1734539665276; Wed, 18 Dec 2024
 08:34:25 -0800 (PST)
Date: Wed, 18 Dec 2024 08:34:25 -0800
In-Reply-To: <675ff6b3.050a0220.37aaf.0125.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6762f991.050a0220.29fcd0.0098.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bkey_packed_valid
From: syzbot <syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    aef25be35d23 hexagon: Disable constant extender optimizati..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=173a37e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=5970f72a85a751ab7556
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c06f44580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10ba37e8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ba5aa1dfe5fd/disk-aef25be3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f4809d9d3d5b/vmlinux-aef25be3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d6becddf1bcb/bzImage-aef25be3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/deb86d739e78/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com

bcachefs (loop0): error validating btree node at btree subvolumes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07ceb940 written 960 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0  
  node offset 8/960 bset u64s 60677 bset byte offset 40: bad k->u64s 0 (min 3 max 253), fixing
==================================================================
BUG: KASAN: slab-use-after-free in bkey_packed_valid+0x3a8/0x4b0 fs/bcachefs/btree_io.c:847
Read of size 1 at addr ffff888078f20000 by task kworker/0:2H/5961

CPU: 0 UID: 0 PID: 5961 Comm: kworker/0:2H Not tainted 6.13.0-rc3-syzkaller-00044-gaef25be35d23 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Workqueue: bcachefs_btree_read_complete btree_node_read_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:489
 kasan_report+0x143/0x180 mm/kasan/report.c:602
 bkey_packed_valid+0x3a8/0x4b0 fs/bcachefs/btree_io.c:847
 validate_bset_keys+0x98d/0x1610 fs/bcachefs/btree_io.c:955
 bch2_btree_node_read_done+0x2402/0x5e90 fs/bcachefs/btree_io.c:1130
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 5909:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4298 [inline]
 __kmalloc_node_noprof+0x290/0x4d0 mm/slub.c:4304
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:650
 btree_node_data_alloc+0x15a/0x260 fs/bcachefs/btree_cache.c:157
 __bch2_btree_node_mem_alloc+0x1d8/0x3e0 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x26f/0x630 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:917 [inline]
 bch2_fs_open+0x2aa4/0x2f80 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2157
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5909:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:582
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2353 [inline]
 slab_free mm/slub.c:4613 [inline]
 kfree+0x196/0x430 mm/slub.c:4761
 __btree_node_data_free+0x341/0x550 fs/bcachefs/btree_cache.c:113
 btree_node_data_free fs/bcachefs/btree_cache.c:127 [inline]
 bch2_fs_btree_cache_exit+0xb1b/0x1530 fs/bcachefs/btree_cache.c:610
 __bch2_fs_free fs/bcachefs/super.c:557 [inline]
 bch2_fs_release+0x20e/0x7d0 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_alloc fs/bcachefs/super.c:960 [inline]
 bch2_fs_open+0x1ebe/0x2f80 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2157
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888078f20000
 which belongs to the cache kmalloc-rcl-512 of size 512
The buggy address is located 0 bytes inside of
 freed 512-byte region [ffff888078f20000, ffff888078f20200)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x78f20
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac42dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac42dc0 dead000000000122 0000000000000000
head: 0000000000000000 0000000000100010 00000001f5000000 0000000000000000
head: 00fff00000000002 ffffea0001e3c801 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Reclaimable, gfp_mask 0xd20d0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC|__GFP_RECLAIMABLE), pid 5909, tgid 5909 (syz-executor238), ts 94208745569, free_ts 92197228717
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3651/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2269
 alloc_slab_page+0x6a/0x110 mm/slub.c:2423
 allocate_slab+0x5a/0x2b0 mm/slub.c:2589
 new_slab mm/slub.c:2642 [inline]
 ___slab_alloc+0xc27/0x14a0 mm/slub.c:3830
 __slab_alloc+0x58/0xa0 mm/slub.c:3920
 __slab_alloc_node mm/slub.c:3995 [inline]
 slab_alloc_node mm/slub.c:4156 [inline]
 __do_kmalloc_node mm/slub.c:4297 [inline]
 __kmalloc_node_noprof+0x2ee/0x4d0 mm/slub.c:4304
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:650
 btree_node_data_alloc+0x15a/0x260 fs/bcachefs/btree_cache.c:157
 __bch2_btree_node_mem_alloc+0x1d8/0x3e0 fs/bcachefs/btree_cache.c:198
 bch2_fs_btree_cache_init+0x26f/0x630 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:917 [inline]
 bch2_fs_open+0x2aa4/0x2f80 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2157
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
page last free pid 5877 tgid 5877 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xd2c/0x1000 mm/page_alloc.c:2657
 __folio_put+0x2b3/0x360 mm/swap.c:112
 folio_put include/linux/mm.h:1488 [inline]
 free_large_kmalloc+0xfe/0x180 mm/slub.c:4732
 kfree+0x212/0x430 mm/slub.c:4755
 __btree_node_data_free+0x30e/0x550 fs/bcachefs/btree_cache.c:110
 btree_node_data_free fs/bcachefs/btree_cache.c:127 [inline]
 bch2_fs_btree_cache_exit+0xb1b/0x1530 fs/bcachefs/btree_cache.c:610
 __bch2_fs_free fs/bcachefs/super.c:557 [inline]
 bch2_fs_release+0x20e/0x7d0 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 bch2_fs_alloc fs/bcachefs/super.c:960 [inline]
 bch2_fs_open+0x1ebe/0x2f80 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2157
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888078f1ff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888078f1ff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888078f20000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888078f20080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888078f20100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
