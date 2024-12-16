Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DEDBA4B
	for <linux-bcachefs@vger.kernel.org>; Mon, 16 Dec 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734342325; cv=none; b=V0ZoN/Bfii8gZNUnrp7OZezngwnsI54DBh3aHHcth7ASjXWuAtbigqOGiJuUC8SX4DD0/ktShh1fj9zK9o1l5X4gjQ1zjfOi78l0Rm0fQf6F6M9NKxN3fnCbGTxXSAVgyAxTv/WP3IYJ1CAsIToStifoqDPfpCEqCYZ0CY62s/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734342325; c=relaxed/simple;
	bh=tn3u8CowPxFCZFHehxXbB+FJhC6SwaD3d90NYljPnYI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qF0fAN4Zg/GfgrkXhGbSrot1xh405q1LK5KQT+mCucdK1VbrKoEULzctFZivFC5rKy2o7f37VodRrIa/2IHf7MGW8QLxv7pcYO3lFlihNJ/SUwp5VZELjoAXuCR8/s0PXoCS8dL0EAnN5ivgba12si49Ae/LjLFjJ37KXWK1fPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9c9b37244so83799565ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 16 Dec 2024 01:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734342323; x=1734947123;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSClknK1lG9ICSTrs9Hmn/ZFF36TAblGdBzLVuRH27M=;
        b=B0pVjX4GjCIIhXWYB/T39C2BEhE6l5hnHZ2EAJley/+eu+49mWoxfi2JQpr7bgAfQw
         7mT2CVdCAoE56C9xmLLc0BnUIVAukhUL0qMoHiYer08QIUB/ofX08WBcTe1t1CAAxW5K
         sobeZ/Ql3DJqFayx1FNTXA0wv/ZO3AsAeshK3uYxj3QftZWnDS6nCdIGxg4ClySPJ6yR
         iuP9fXHKyIPj/aBHvC379rIY62JJjeja2U/CdkgpVs2F0f3Wrsjk1yPSheS6J43eD33N
         Gt6cvu+PCshvIkecIRHUL1xqX3UHsZjb3kXsDctKcbgm+KWI+1NEHU6Ggo4dzpHmmMbN
         1LKw==
X-Forwarded-Encrypted: i=1; AJvYcCVH7pepfwVKDLLN1c8ntptI6UpiHY7NCLNy05a0e/jcL+4PTA8HfcltdajJ9onGUJ5h69eroQkh10HCpro25g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzGmYM4Leyg/ZlRDLenh98vi46aVbMQPAKBH79Dl0jKGfQXyTfs
	yd8ScFX9VK26+gF7TxPjr4j3BOoz8T/AeyB6o/oMGLgHKf0uqrwjWpwhVgQBUHCcdc3mVibO4cr
	B6eu/1tpnB2PJXIZnPJoStPM40X4+5S2Kzu+VqNVDu8RVXju+bozwSbA=
X-Google-Smtp-Source: AGHT+IHbRize4Wl1V3h9YIIQE06E6vAsIMFpQduYEt95WzhoWd2VNtclhWvXk1WqISlm5T4ZBCZX4FY0Kna2Pezl8ySUP4gi2k5Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2147:b0:3a7:9670:7abb with SMTP id
 e9e14a558f8ab-3aff0c4d40emr128588045ab.15.1734342323069; Mon, 16 Dec 2024
 01:45:23 -0800 (PST)
Date: Mon, 16 Dec 2024 01:45:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675ff6b3.050a0220.37aaf.0125.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bkey_packed_valid
From: syzbot <syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    dccbe2047a5b Merge tag 'edac_urgent_for_v6.13_rc3' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f247e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fee25f93665c89ac
dashboard link: https://syzkaller.appspot.com/bug?extid=5970f72a85a751ab7556
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-dccbe204.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e8e0fb0a0d4d/vmlinux-dccbe204.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c5de2ff9a074/bzImage-dccbe204.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5970f72a85a751ab7556@syzkaller.appspotmail.com

bcachefs (loop0): error validating btree node at btree inodes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 1040 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0  
  node offset 16/1040 bset u64s 65529 bset byte offset 792: keys out of order: u64s 18 type inode_v3 1536:536870913:U32_MAX len 0 ver 0 > u64s 18 type inode_v3 0:536870914:U32_MAX len 0 ver 0, fixing
bcachefs (loop0): error validating btree node at btree inodes level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a written 1040 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0  
  node offset 16/1040 bset u64s 65518 bset byte offset 792: bad k->u64s 0 (min 3 max 253), fixing
==================================================================
BUG: KASAN: use-after-free in bkey_packed_valid+0x3a8/0x4b0 fs/bcachefs/btree_io.c:847
Read of size 1 at addr ffff888052cc0000 by task kworker/0:1H/36

CPU: 0 UID: 0 PID: 36 Comm: kworker/0:1H Not tainted 6.13.0-rc2-syzkaller-00382-gdccbe2047a5b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
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

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x52cc0
flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f0(buddy)
raw: 04fff00000000000 ffffea00014bb008 ffff88805ffd7090 0000000000000000
raw: 0000000000000000 0000000000000006 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 5, migratetype Reclaimable, gfp_mask 0x452cd0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_RECLAIMABLE), pid 5312, tgid 5311 (syz.0.0), ts 58564387660, free_ts 58890136625
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x365c/0x37a0 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 ___kmalloc_large_node+0x8b/0x1d0 mm/slub.c:4243
 __kmalloc_large_node_noprof+0x1a/0x80 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0x33a/0x4d0 mm/slub.c:4304
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:650
 btree_node_data_alloc+0xdb/0x260 fs/bcachefs/btree_cache.c:153
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
page last free pid 5322 tgid 5322 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 __free_pages_ok+0xbda/0xe60 mm/page_alloc.c:1269
 __folio_put+0x2b3/0x360 mm/swap.c:112
 folio_put include/linux/mm.h:1488 [inline]
 free_large_kmalloc+0xfe/0x180 mm/slub.c:4732
 kfree+0x212/0x430 mm/slub.c:4755
 btree_bounce_free fs/bcachefs/btree_io.c:112 [inline]
 bch2_btree_node_read_done+0x3c8a/0x5e90 fs/bcachefs/btree_io.c:1209
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x29f0
 bch2_btree_node_fill+0xc77/0x12f0 fs/bcachefs/btree_cache.c:991
 bch2_btree_node_get_noiter+0x9d5/0xf70 fs/bcachefs/btree_cache.c:1260
 found_btree_node_is_readable fs/bcachefs/btree_node_scan.c:85 [inline]
 try_read_btree_node fs/bcachefs/btree_node_scan.c:193 [inline]
 read_btree_nodes_worker+0x13c5/0x2220 fs/bcachefs/btree_node_scan.c:242
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Memory state around the buggy address:
 ffff888052cbff00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888052cbff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888052cc0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888052cc0080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888052cc0100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
