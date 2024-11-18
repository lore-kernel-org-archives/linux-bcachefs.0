Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEED12C499
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 12:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731932124; cv=none; b=DJFbLNzcgxrEYF9QbwUbfYqd0HU00qG9LS0KNWO3K2bG6pjwyY1HSUOB/DU3pQUmXfuNUVXl4tRACPRYVtbopyJcBz91gwyZl1Kj3H6XcFn28cIlzcl4oTXwAQHCAITqw9e5Zcq5bjXy2ssCeekh3MuwwNMB2MMzx1XK2Xm7jm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731932124; c=relaxed/simple;
	bh=sNFIoyB7letoKRkQ4E4T1KiCJUhIEl2ZJFCGDvBQBCk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=tNDC6cjvV11yLQ6n0ifZSXuWJi7sP2UqcBpKq4pj4bL/cqGqTYhrZiiD2xi++9lwd1q8d9PZbRV4J82jpp3cqRj3epFswF+5ucIxWiDLJq5MCpRvFNNRVjHaj0dF/xyLkW8d82mdytrSx7r2VmpyoviUQx5f3wCOq5MQYpsUYVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a762c65543so11858035ab.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Nov 2024 04:15:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731932121; x=1732536921;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ojHVuJzPcRenXtwuByFE/2dQqFyG3R/w+ff38DaEG54=;
        b=KLdbavlSVULrfj+06fO4EEEW1UIH+ttIt6fLBQ5zpbcG3fZdk5y8arg6vlE8WE6HQh
         tVfZe9YyS1L0F1WKLlTRAEb5R5ew4yB+NVzq1ajfLV3VAaZ2b6L7DDTH6J3ue467optf
         MkeOrBAICIOTVW6g+akQJSbRx0KIwt/kWvTLgUck5PdLb1a0KD7MXoZTMYLM30bQDuU7
         LAF2Gaopkg7hv0jv4p4FwZp2c+8LUo8eEK+h9k9lCnF15euLYJsZCpCD688kq0gu2SQ0
         UFZoXzwvKCZp7Lasg7evxpejD9OwVWF7IliyrUSJ+14G2B4ZGxjq5gTJo/8LzFg5SvEr
         c77A==
X-Forwarded-Encrypted: i=1; AJvYcCVFiD7DQGlvCiGoOEInZoqpwQsOTu9dQPEW08N6xrnKintafsp4JrszM62q2N0m8+sWFWlFRS1/YQLtu4zznQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEDTmXcV/3U6i+CfXsTqhs6tD3szCZ+51GVTgBV9P2vId+OSLv
	3vvjjlXlGSOJqjP9qvtjj6TeKHxBhMY8GIPcOeEuUvUsjfbsMPjmuE1zjk+ZbVYB+Yip0njQ/mf
	lnpaP28CgYVFLnaVbyxUyACu11xPA8Vqk51iKTHnzjCCj2Bun5hUTsBI=
X-Google-Smtp-Source: AGHT+IFnWyR439TNLYVZSy9HvG3cjrpGvF+/ag/YPDQHP9Y+9C6BG0Gw+K1vBIGqPWsoZ/kDH7sO4uWUq0PJMVF0bbRDy5OXYKti
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174c:b0:3a7:64f5:73df with SMTP id
 e9e14a558f8ab-3a764f57672mr29124945ab.9.1731932121663; Mon, 18 Nov 2024
 04:15:21 -0800 (PST)
Date: Mon, 18 Nov 2024 04:15:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <673b2fd9.050a0220.87769.0037.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: stack-out-of-bounds Read in do_encrypt
From: syzbot <syzbot+1e42728e2fb48752d6f2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    0a9b9d17f3a7 Merge tag 'pm-6.12-rc8' of git://git.kernel.o.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D10f14b5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dd2aeec8c0b2e420=
c
dashboard link: https://syzkaller.appspot.com/bug?extid=3D1e42728e2fb48752d=
6f2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-0a9b9d17.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b80dd0292210/vmlinux-=
0a9b9d17.xz
kernel image: https://storage.googleapis.com/syzbot-assets/42a07c5c6678/bzI=
mage-0a9b9d17.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+1e42728e2fb48752d6f2@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=3Dmetadata_che=
cksum=3Dnone,data_checksum=3Dnone,compression=3Dlz4,metadata_target=3Dinval=
id device 255,noshard_inode_numbers,noinodes_use_key_cache,journal_flush_de=
lay=3D1001,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 13
bcachefs (loop0): Version upgrade required:
Version upgrade from 0.19: freespace to 1.7: mi_btree_bitmap incomplete
Doing incompatible version upgrade from 0.19: freespace to 1.13: inode_has_=
child_snapshots
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,set_fs_needs_rebalance
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: stack-out-of-bounds in sg_mark_end include/linux/scatterlist.h:=
258 [inline]
BUG: KASAN: stack-out-of-bounds in do_encrypt+0xa22/0xd70 fs/bcachefs/check=
sum.c:157
Read of size 8 at addr ffffc9000d3ce908 by task syz.0.0/5324

CPU: 0 UID: 0 PID: 5324 Comm: syz.0.0 Not tainted 6.12.0-rc7-syzkaller-0007=
0-g0a9b9d17f3a7 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 sg_mark_end include/linux/scatterlist.h:258 [inline]
 do_encrypt+0xa22/0xd70 fs/bcachefs/checksum.c:157
 bset_encrypt fs/bcachefs/btree_io.h:118 [inline]
 bch2_btree_node_read_done+0x1dfc/0x5e90 fs/bcachefs/btree_io.c:1074
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb19557feba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb19629be68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fb19629bef0 RCX: 00007fb19557feba
RDX: 0000000020000040 RSI: 000000002000f680 RDI: 00007fb19629beb0
RBP: 0000000020000040 R08: 00007fb19629bef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000002000f680
R13: 00007fb19629beb0 R14: 000000000000f629 R15: 0000000020000000
 </TASK>

The buggy address belongs to stack of task syz.0.0/5324
 and is located at offset 1768 in frame:
 do_encrypt+0x0/0xd70

This frame has 8 objects:
 [32, 48) 'nonce.i242'
 [64, 528) '__req_desc.i243'
 [592, 608) 'nonce.i224'
 [624, 1088) '__req_desc.i225'
 [1152, 1168) 'nonce.i'
 [1184, 1648) '__req_desc.i'
 [1712, 1744) 'sg'
 [1776, 1928) 'sgl'

The buggy address belongs to the virtual mapping at
 [ffffc9000d3c8000, ffffc9000d3d1000) created by:
 copy_process+0x5d1/0x3d50 kernel/fork.c:2204

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804272e9=
b0 pfn:0x4272e
flags: 0x4fff00000000000(node=3D1|zone=3D1|lastcpupid=3D0x7ff)
raw: 04fff00000000000 0000000000000000 dead000000000122 0000000000000000
raw: ffff88804272e9b0 0000000000000000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP=
_KERNEL|__GFP_HIGHMEM|__GFP_NOWARN|__GFP_ZERO), pid 5322, tgid 5322 (syz.0.=
0), ts 57859057176, free_ts 57840341861
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x3649/0x3790 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4750
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 vm_area_alloc_pages mm/vmalloc.c:3568 [inline]
 __vmalloc_area_node mm/vmalloc.c:3646 [inline]
 __vmalloc_node_range_noprof+0xa2b/0x13f0 mm/vmalloc.c:3828
 alloc_thread_stack_node kernel/fork.c:315 [inline]
 dup_task_struct+0x444/0x8c0 kernel/fork.c:1116
 copy_process+0x5d1/0x3d50 kernel/fork.c:2204
 kernel_clone+0x226/0x8f0 kernel/fork.c:2786
 __do_sys_clone3 kernel/fork.c:3090 [inline]
 __se_sys_clone3+0x2d8/0x360 kernel/fork.c:3069
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 4733 tgid 4733 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xdf9/0x1140 mm/page_alloc.c:2657
 __slab_free+0x31b/0x3d0 mm/slub.c:4490
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:247 [inline]
 slab_post_alloc_hook mm/slub.c:4085 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4141
 getname_flags+0xb7/0x540 fs/namei.c:139
 do_sys_openat2+0xd2/0x1d0 fs/open.c:1409
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_openat fs/open.c:1446 [inline]
 __se_sys_openat fs/open.c:1441 [inline]
 __x64_sys_openat+0x247/0x2a0 fs/open.c:1441
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffffc9000d3ce800: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffc9000d3ce880: 00 00 f2 f2 f2 f2 f2 f2 f2 f2 00 00 00 00 f2 f2
>ffffc9000d3ce900: f2 f2 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                      ^
 ffffc9000d3ce980: 00 00 00 00 00 f3 f3 f3 f3 f3 f3 f3 f3 f3 f3 f3
 ffffc9000d3cea00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


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
