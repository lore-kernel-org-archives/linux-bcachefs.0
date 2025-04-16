Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D6A22A4EC
	for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 07:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744788748; cv=none; b=Q+8xarYyyoM6TyRIEGKq9UzUMYLMzsN+TwUwHPpOU+Q8PYBH+OtowyWaEQSUKPcyAP12BdMxBjkicfGRPmljcGtzbgomPdyfvEJAkGGtYthmcWZUmt7cDRvs+L+RQZ4kOiluV+CoJBlWqkHVb0a+8lfXK3BvQtiVVWiQ7IwEsO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744788748; c=relaxed/simple;
	bh=xnJxtLuUcAokieK9A1lk2vrKLQqQEtNg0FT/f9r+eUc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=i598NGwcyzIbaIrZb6wKNk5KN6myMMe/NHFvuVIVZSdMs+hR9CRIRGRUV041uVsHIsztE9Rl1rxvt3XkyufBFedYk9nGKSaJq83VYJUUVTsUG8dopCl9mXCgQ3VkJQ3pZ4v2+CmdJbkIJqmpLdjnmawymdcGW6G8elxvz73HsgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d5b381656dso118977055ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 16 Apr 2025 00:32:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744788743; x=1745393543;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I7bI0P2VIoW2wscntTDvpk3rS9/azjA33vM4sSXdJYM=;
        b=qvzBmRzvOqqWa+m6/S2+X88HZh+DICbQwtqgtPUJ2zCXaPkwgYIiOcP2ZV3/fe6GBr
         Csb7sPqRWvqeN9AdpisMwQRJLEhX9bYJpb1JQ1Hrmo9hC6p/DCuBLYqflGDLTk2lHuYp
         oGhQDYK6mvNJcA3UzPR58mdgTY1J34S60JNZqPs+lZ4UuLtimazDxn5gwoWTIsSRdFS6
         FoJzKezr4qKthWAywJGNKR527XFdPBbh1rq3VIrz/tmzXTHloWlx9XHsOUYLFwsgF1/+
         favlnXVOopV7oIfyeysKnXvjx/st+XqhCly34S7jRlC1Illvw92cwdkf4HEevKYDQi+t
         TAmA==
X-Forwarded-Encrypted: i=1; AJvYcCX+Z9yPV6Y7NoE3wsCqOKwverr6zeRbEA/z40eY67u5Ply6pGlQgSHkess82oXAFoPESQZrhAIQcvfHETjw+A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs9gv/M/NySxncIoFiHqYM9HTn4p/ZklSOlhfm+YFcN8m80Mm4
	BgZvoQagYIZkeiH46xcK6eUrQXjjiQ035EZs6xSZjSU5SiGdW7XltskG3o51aBf39ind16teN7S
	l49fDvQHpxm5s3iiELN4tdr26cE1c5OFt6JpHPYSat9viuZEdO7blrqw=
X-Google-Smtp-Source: AGHT+IGKO8AZPK4USbSLaYwIJ9GJdpaxuTRV43A1MMcjayrzDznG8elGNv45/SUKlq6DYy1+NRe2qfGYpkNDhTnzuiyZqTqpIHW+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3181:b0:3d5:8103:1a77 with SMTP id
 e9e14a558f8ab-3d815af4400mr8548905ab.1.1744788743653; Wed, 16 Apr 2025
 00:32:23 -0700 (PDT)
Date: Wed, 16 Apr 2025 00:32:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67ff5d07.050a0220.243d89.0000.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Write in dirent_create_key
From: syzbot <syzbot+11b0847e79af78485b01@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    900241a5cc15 Merge tag 'drm-fixes-2025-04-11-1' of https:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15dc00cc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eecd7902e39d7933
dashboard link: https://syzkaller.appspot.com/bug?extid=11b0847e79af78485b01
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-900241a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17934726fb32/vmlinux-900241a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3e5656fc1aa5/bzImage-900241a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+11b0847e79af78485b01@syzkaller.appspotmail.com

    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0, fixing
bcachefs (loop0): inode points to missing dirent
  inum: 536870912:4294967295 
    mode=100755
    flags=(15300000)
    journal_seq=4
    hash_seed=8469d717004af4ef
    hash_type=siphash
    bi_size=10
    bi_sectors=8
    bi_version=0
    bi_atime=2780562352
    bi_ctime=2780562352
    bi_mtime=2780562352
    bi_otime=2780562352
    bi_uid=0
    bi_gid=0
    bi_nlink=0
    bi_generation=0
    bi_dev=0
    bi_data_checksum=0
    bi_compression=0
    bi_project=0
    bi_background_compression=0
    bi_data_replicas=0
    bi_promote_target=0
    bi_foreground_target=0
    bi_background_target=0
    bi_erasure_code=0
    bi_fields_set=0
    bi_dir=4096
    bi_dir_offset=4330382808765833931
    bi_subvol=0
    bi_parent_subvol=0
    bi_nocow=0
    bi_depth=0
    bi_inodes_32bit=0, fixing
 done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): check_extents_to_backpointers... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): done starting filesystem
==================================================================
BUG: KASAN: slab-out-of-bounds in dirent_init_casefolded_name fs/bcachefs/dirent.c:294 [inline]
BUG: KASAN: slab-out-of-bounds in dirent_create_key+0x582/0xcd0 fs/bcachefs/dirent.c:319
Write of size 257 at addr ffff888052d2c377 by task syz.0.0/5334

CPU: 0 UID: 0 PID: 5334 Comm: syz.0.0 Not tainted 6.15.0-rc1-syzkaller-00246-g900241a5cc15 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x28f/0x2a0 mm/kasan/generic.c:189
 __asan_memset+0x23/0x50 mm/kasan/shadow.c:84
 dirent_init_casefolded_name fs/bcachefs/dirent.c:294 [inline]
 dirent_create_key+0x582/0xcd0 fs/bcachefs/dirent.c:319
 bch2_dirent_create+0x330/0x13b0 fs/bcachefs/dirent.c:-1
 bch2_create_trans+0x1366/0x1cf0 fs/bcachefs/namei.c:160
 __bch2_create+0x793/0xf40 fs/bcachefs/fs.c:559
 bch2_mknod fs/bcachefs/fs.c:728 [inline]
 bch2_mkdir+0xe9/0x1b0 fs/bcachefs/fs.c:883
 vfs_mkdir+0x2f9/0x500 fs/namei.c:4324
 do_mkdirat+0x273/0x3f0 fs/namei.c:4357
 __do_sys_mkdirat fs/namei.c:4374 [inline]
 __se_sys_mkdirat fs/namei.c:4372 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5c6978d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5c6a606038 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f5c699a5fa0 RCX: 00007f5c6978d169
RDX: 0000000000000000 RSI: 0000200000000600 RDI: 0000000000000008
RBP: 00007f5c6980e990 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5c699a5fa0 R15: 00007ffc6aa3a0e8
 </TASK>

Allocated by task 5334:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x9d/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4331 [inline]
 __kmalloc_noprof+0x28e/0x4d0 mm/slub.c:4343
 kmalloc_noprof include/linux/slab.h:909 [inline]
 __bch2_trans_get+0x6ba/0xd40 fs/bcachefs/btree_iter.c:3373
 __bch2_create+0x391/0xf40 fs/bcachefs/fs.c:552
 bch2_mknod fs/bcachefs/fs.c:728 [inline]
 bch2_mkdir+0xe9/0x1b0 fs/bcachefs/fs.c:883
 vfs_mkdir+0x2f9/0x500 fs/namei.c:4324
 do_mkdirat+0x273/0x3f0 fs/namei.c:4357
 __do_sys_mkdirat fs/namei.c:4374 [inline]
 __se_sys_mkdirat fs/namei.c:4372 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888052d2c000
 which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 887 bytes inside of
 allocated 1024-byte region [ffff888052d2c000, ffff888052d2c400)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x52d2c
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x4fff00000000040(head|node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000040 ffff88801b041dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 04fff00000000040 ffff88801b041dc0 dead000000000122 0000000000000000
head: 0000000000000000 0000000080080008 00000000f5000000 0000000000000000
head: 04fff00000000002 ffffea00014b4b01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5334, tgid 5333 (syz.0.0), ts 69978698427, free_ts 69977163867
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f4/0x240 mm/page_alloc.c:1717
 prep_new_page mm/page_alloc.c:1725 [inline]
 get_page_from_freelist+0x352b/0x36c0 mm/page_alloc.c:3652
 __alloc_frozen_pages_noprof+0x211/0x5b0 mm/page_alloc.c:4934
 alloc_pages_mpol+0x339/0x690 mm/mempolicy.c:2301
 alloc_slab_page mm/slub.c:2459 [inline]
 allocate_slab+0x8f/0x3a0 mm/slub.c:2623
 new_slab mm/slub.c:2676 [inline]
 ___slab_alloc+0xc3b/0x1500 mm/slub.c:3862
 __slab_alloc+0x58/0xa0 mm/slub.c:3952
 __slab_alloc_node mm/slub.c:4027 [inline]
 slab_alloc_node mm/slub.c:4188 [inline]
 __do_kmalloc_node mm/slub.c:4330 [inline]
 __kmalloc_noprof+0x2ea/0x4d0 mm/slub.c:4343
 kmalloc_noprof include/linux/slab.h:909 [inline]
 __bch2_trans_get+0x6ba/0xd40 fs/bcachefs/btree_iter.c:3373
 __bch2_create+0x391/0xf40 fs/bcachefs/fs.c:552
 bch2_mknod fs/bcachefs/fs.c:728 [inline]
 bch2_mkdir+0xe9/0x1b0 fs/bcachefs/fs.c:883
 vfs_mkdir+0x2f9/0x500 fs/namei.c:4324
 do_mkdirat+0x273/0x3f0 fs/namei.c:4357
 __do_sys_mkdirat fs/namei.c:4374 [inline]
 __se_sys_mkdirat fs/namei.c:4372 [inline]
 __x64_sys_mkdirat+0x87/0xa0 fs/namei.c:4372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5333 tgid 5333 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1262 [inline]
 __free_frozen_pages+0xde8/0x10a0 mm/page_alloc.c:2680
 stack_depot_save_flags+0x45b/0x940 lib/stackdepot.c:678
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_save_track+0x51/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x9d/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4331 [inline]
 __kmalloc_node_noprof+0x29a/0x4d0 mm/slub.c:4337
 kmalloc_array_node_noprof include/linux/slab.h:1020 [inline]
 alloc_slab_obj_exts+0x3a/0xa0 mm/slub.c:1987
 __memcg_slab_post_alloc_hook+0x31c/0x7e0 mm/memcontrol.c:3075
 memcg_slab_post_alloc_hook mm/slub.c:2188 [inline]
 slab_post_alloc_hook mm/slub.c:4161 [inline]
 slab_alloc_node mm/slub.c:4200 [inline]
 kmem_cache_alloc_noprof+0x28f/0x390 mm/slub.c:4207
 vm_area_dup+0x2b/0x5b0 kernel/fork.c:488
 __split_vma+0x1b8/0xb20 mm/vma.c:477
 split_vma mm/vma.c:553 [inline]
 vma_modify+0x280/0x390 mm/vma.c:1547
 vma_modify_flags+0x3b2/0x430 mm/vma.c:1565
 mprotect_fixup+0x445/0xa40 mm/mprotect.c:658
 do_mprotect_pkey+0x99f/0xde0 mm/mprotect.c:832
 __do_sys_mprotect mm/mprotect.c:853 [inline]
 __se_sys_mprotect mm/mprotect.c:850 [inline]
 __x64_sys_mprotect+0x80/0x90 mm/mprotect.c:850
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94

Memory state around the buggy address:
 ffff888052d2c300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888052d2c380: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888052d2c400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff888052d2c480: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888052d2c500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
