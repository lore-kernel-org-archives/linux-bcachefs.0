Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB3F227EAA
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759171774; cv=none; b=mE5oWekrZvJOHFcIkbSYS2XdT5zIgN9wPf1D5M/kr+VA5Hwgu7jqgMVEYGeh8MBp1SvOyI7vdiv+3TlRz34HPKuc7QiowInO2lG1nNISVpM/KmdB85sI218h4aFt+YtxCzpdL/6ntNxstledlWhP7BpbCquWbORdLG8Ckkh4/LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759171774; c=relaxed/simple;
	bh=Lslmm8X80GCqx5RLRIZx88vPORk72hF9/DUvOJe0+qk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=eyX/nL0bG89sBhoheJU43QV8G7sRW1PtZA8PKnJP2ObVCgYo5lLbZ0lVdTt2/KkF+Ay2dyq8qRYyRAeYbe6RGnZvQjw6gA5EjgeuL6nonihFnQrqMZcVb4MesiQa0ZwM+342z2Wa6WlhmmNvq7ZZHfmBGluAuznhoZVDrLWyuQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-426d38c1e8fso44659785ab.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Sep 2025 11:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759171771; x=1759776571;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zmjmrE8YwyveUCo0SeX0ust3vz2WS+wpEQb+y3rBi2g=;
        b=GkHlttDLd0cW/rKWoeclh3fMgyNRcIi5Zxd+LwGmP41nGmIeNPmBz4XieZkFMtbk1f
         im2/hlRzPBWFH/opk9mtx7ZUr1TVO1zgKDtkVHdF6TFdwtf29ceJyg8S+6pKLG+xUJ78
         gv/PdF7crm2UGqh9St6SUDrYpnh1oBRcxHpIqOMqWgOCOx1Iw8Huo26IBBJxEI05ryOg
         93Uk81zP2R5mBKNeFnxreMOMNctVFG+/D3lxcqjRHfVo9NoSmt1pnECK0/hvcZq130p0
         K7aNXcKfogLvnkNosMKmIOA3x4JR2muhw/bDeXTDSEH+nLDttKxvOe6XgC3ZXggqXRwY
         cr+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzocmAuYXu6TPxdlQzjgXpjI5fRbnsnhXxznXgCA4yEEBOXhUjwa+7B3Nq7soIB3jGHy6vLAZMcEBokvrrZg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxd6h2BffhPv3ab1OvBCWTLEsSI3+62O6tW6b9blviz6Erh+KB
	R0LW9fpBGA+7DE97ugrTQWxOfGwL+RdufAU9fRr7x/Y6O2+oV/uhb2henRLOq/Fj0WP9HbEw+ZD
	xLp8ctnwdkvygLOoY+ebLe6w++o4RnPk3MjEFPn6f8jptl7XdzQEz+ERcKog=
X-Google-Smtp-Source: AGHT+IGhakd/zPGFnF5popGZL4mlBSJbsfAerbwbFs84lZDvszSVmjOFzrWpK8u74hulcKazWWzIzT8NZTpC64VVckWyuqr59vkR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cdae:0:b0:429:4c65:e8f5 with SMTP id
 e9e14a558f8ab-4294c65ebe3mr125904375ab.23.1759171771617; Mon, 29 Sep 2025
 11:49:31 -0700 (PDT)
Date: Mon, 29 Sep 2025 11:49:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dad4bb.a70a0220.10c4b.0086.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_btree_node_read_done
From: syzbot <syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    083fc6d7fa0d Merge tag 'sched-urgent-2025-09-26' of git://..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16fbe2e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f5b21423ca3f0a96
dashboard link: https://syzkaller.appspot.com/bug?extid=ba71155d3eacc8f42477
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16433d34580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e79f12580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/198ae77e2418/disk-083fc6d7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3d3f065fd75c/vmlinux-083fc6d7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e65812e9d7b0/bzImage-083fc6d7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5219cf8dcb94/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ba71155d3eacc8f42477@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in bch2_btree_node_read_done+0x950/0x5550 fs/bcachefs/btree_io.c:1128
Read of size 8 at addr ffff88805874a010 by task syz.0.17/6055

CPU: 0 UID: 0 PID: 6055 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 bch2_btree_node_read_done+0x950/0x5550 fs/bcachefs/btree_io.c:1128
 btree_node_read_work+0x40e/0xe60 fs/bcachefs/btree_io.c:1440
 bch2_btree_node_read+0x887/0x2a00 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1906 [inline]
 bch2_btree_root_read+0x5f0/0x760 fs/bcachefs/btree_io.c:1928
 read_btree_roots+0x2c6/0x840 fs/bcachefs/recovery.c:615
 bch2_fs_recovery+0x261f/0x3a50 fs/bcachefs/recovery.c:1006
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7feb1599066a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe09e19a98 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe09e19b20 RCX: 00007feb1599066a
RDX: 00002000000058c0 RSI: 0000200000000000 RDI: 00007ffe09e19ae0
RBP: 00002000000058c0 R08: 00007ffe09e19b20 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000000
R13: 00007ffe09e19ae0 R14: 00000000000058f2 R15: 0000200000000180
 </TASK>

Allocated by task 6055:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4376 [inline]
 __kvmalloc_node_noprof+0x28d/0x550 mm/slub.c:5067
 btree_node_data_alloc+0xdc/0x270 fs/bcachefs/btree_cache.c:151
 __bch2_btree_node_mem_alloc+0x1dc/0x2e0 fs/bcachefs/btree_cache.c:193
 bch2_fs_btree_cache_init+0x314/0x880 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:998 [inline]
 bch2_fs_open+0x1da6/0x26e0 fs/bcachefs/super.c:2433
 bch2_fs_get_tree+0x44f/0x1520 fs/bcachefs/fs.c:2472
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888058748000
 which belongs to the cache kmalloc-rcl-8k of size 8192
The buggy address is located 16 bytes to the right of
 allocated 8192-byte region [ffff888058748000, ffff88805874a000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x58748
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8880273c6ce1
flags: 0x80000000000040(head|node=0|zone=1)
page_type: f5(slab)
raw: 0080000000000040 ffff8880198483c0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080020002 00000000f5000000 ffff8880273c6ce1
head: 0080000000000040 ffff8880198483c0 dead000000000122 0000000000000000
head: 0000000000000000 0000000080020002 00000000f5000000 ffff8880273c6ce1
head: 0080000000000003 ffffea000161d201 00000000ffffffff 00000000ffffffff
head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask 0x528d0(GFP_NOWAIT|__GFP_RECLAIMABLE|__GFP_IO|__GFP_FS|__GFP_NORETRY|__GFP_COMP), pid 6055, tgid 6055 (syz.0.17), ts 114481807879, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x2119/0x21b0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2492 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2660
 new_slab mm/slub.c:2714 [inline]
 ___slab_alloc+0x8d1/0xdc0 mm/slub.c:3901
 __slab_alloc mm/slub.c:3992 [inline]
 __slab_alloc_node mm/slub.c:4067 [inline]
 slab_alloc_node mm/slub.c:4228 [inline]
 __do_kmalloc_node mm/slub.c:4375 [inline]
 __kvmalloc_node_noprof+0x1d6/0x550 mm/slub.c:5067
 btree_node_data_alloc+0xdc/0x270 fs/bcachefs/btree_cache.c:151
 __bch2_btree_node_mem_alloc+0x1dc/0x2e0 fs/bcachefs/btree_cache.c:193
 bch2_fs_btree_cache_init+0x314/0x880 fs/bcachefs/btree_cache.c:653
 bch2_fs_alloc fs/bcachefs/super.c:998 [inline]
 bch2_fs_open+0x1da6/0x26e0 fs/bcachefs/super.c:2433
 bch2_fs_get_tree+0x44f/0x1520 fs/bcachefs/fs.c:2472
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3808
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888058749f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888058749f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88805874a000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff88805874a080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88805874a100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
