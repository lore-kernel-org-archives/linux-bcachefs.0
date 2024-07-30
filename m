Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937DAC153
	for <linux-bcachefs@vger.kernel.org>; Tue, 30 Jul 2024 01:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302066; cv=none; b=s2dnarV5zn12bVDkHq4vNEl28GzrTukM3qgHLao8+4TIpMkAuwHVDfVxEU2zCZQEHi+JOnplCdsCKrh+vHXAwhn8lMWXb+FN9ihr4/TMNRlVGsPBruMUSz8R1SdHOXa8v/gV43L8MBUuC94GHHPB0RYDgO1gNfSBdtcBqomA9WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302066; c=relaxed/simple;
	bh=VbC5Ry7oO86TTGqe9Hlg5hRVCm20i7CIlucnXJxdJEY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=cUcymg3RnvATphUFTqur58R2FEO8Wdl6askyiXtr8efJ0rudIeQ8iZlxLYsM5mwX/Ytgm6Z3zK1lj4GwE9eQf68kZmxm6fZaBSdREzWjYh1kwEIY0P7xf0DzgyFKkSINQ6Ll26iqZyI6GJukCMEnlz1pfxcl61MV8bsgSU1yo0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-81d1b92b559so604202539f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jul 2024 18:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722302063; x=1722906863;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e8wZ3BzgZACh5NT8rDj7wtLR8KDVautj/orLprnxuiI=;
        b=vo6kuPwS4JWpOSxYE4uraUjUqLVaQz2YLmnV0X5G/lRabJLAt74nsDC3PGcZMnBdXW
         PVSH0yw6uQ/M4pZbFtC0c6HK5HuhNph+KpXhqwwO8H9/sg0r9LjWWoTS6NTcDVLQP+vM
         MXJq94QcE38AXyhi2rRsnwvtGEXvGIcZlqck6452ZIVEZsHsDcJXYhWuDKcFbx2bCZY6
         l6vwtZ17ZD1NIpL7UkOu6O1NFDzDxCGawl7Kfx5H6xnKmHyiC7cb21m/uArGZ8VaBLo9
         HMD7iDMkhz741KRtQbKXwLVQP/tVo2Zabb6+ZAKqlAcKAHFEB7NGFYI+AqAwRq2UwTca
         IgAA==
X-Forwarded-Encrypted: i=1; AJvYcCXTFYa221gMDwNr1b83VuNTwgJEh0+870PyHiNaVJP9+BeCxIFSGJpifg7z0CYgCWLbx5FQ14oUK3BokSb0qfyS3ylwcsM+ZofFbJxadoA=
X-Gm-Message-State: AOJu0YwKc353qnT9ETiORUPEeYzQs7wjX1bEJUKc/QsDjhBLvgi9qNKG
	noNqx2KAYbsxnE3Y1tfRbgAbUXGU5SUZiCOQo0aI1/9dxPFoykMjHrYJ02A8EHu4RRMZeipkL9t
	vEKzQsrp6UFswWc+EoX7n84xhQu8nAnYbA/ZyL9AAI+LRsu00foDh33o=
X-Google-Smtp-Source: AGHT+IEebg3YBFTCMof91VUkPj8pU/yj2oOqFuE1kMI7UqTRXV/ISZqZ1dF/V1XY3AHRHxbMte8PgGBAeMpWPGl9WatCzL6HZZiC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1383:b0:4bb:624c:5a7f with SMTP id
 8926c6da1cb9f-4c63d51ff5bmr304730173.1.1722302063619; Mon, 29 Jul 2024
 18:14:23 -0700 (PDT)
Date: Mon, 29 Jul 2024 18:14:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b2c0fc061e6cb26b@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in journal_entry_dev_usage_to_text
From: syzbot <syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1722389b0d86 Merge tag 'net-6.11-rc1' of git://git.kernel...
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1544b603980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b698a1b2fcd7ef5f
dashboard link: https://syzkaller.appspot.com/bug?extid=05d7520be047c9be86e0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1686c69d980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=150a1611980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e3f4ec8ccf7c/disk-1722389b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f19bcd908282/vmlinux-1722389b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d93604974a98/bzImage-1722389b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f4a9cf51fd0b/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=147b3b0d980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=167b3b0d980000
console output: https://syzkaller.appspot.com/x/log.txt?x=127b3b0d980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+05d7520be047c9be86e0@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

loop0: detected capacity change from 0 to 32768
==================================================================
BUG: KASAN: slab-out-of-bounds in journal_entry_dev_usage_to_text+0x109/0x1d0 fs/bcachefs/journal_io.c:731
Read of size 8 at addr ffff88807a286000 by task syz-executor816/5214

CPU: 1 UID: 0 PID: 5214 Comm: syz-executor816 Not tainted 6.10.0-syzkaller-12562-g1722389b0d86 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 journal_entry_dev_usage_to_text+0x109/0x1d0 fs/bcachefs/journal_io.c:731
 bch2_sb_clean_to_text+0x138/0x240 fs/bcachefs/sb-clean.c:251
 bch2_sb_field_validate+0x201/0x2e0 fs/bcachefs/super-io.c:1229
 bch2_sb_validate+0xa69/0xe00 fs/bcachefs/super-io.c:468
 __bch2_read_super+0xc1b/0x1370 fs/bcachefs/super-io.c:823
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2084
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1933
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f14389cf06a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe1945e9d8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe1945e9f0 RCX: 00007f14389cf06a
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffe1945e9f0
RBP: 0000000000000004 R08: 00007ffe1945ea30 R09: 0000000000005b72
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffe1945ea30 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

Allocated by task 5214:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slub.c:4158 [inline]
 __kmalloc_node_track_caller_noprof+0x225/0x440 mm/slub.c:4177
 __do_krealloc mm/slab_common.c:1280 [inline]
 krealloc_noprof+0x7d/0x120 mm/slab_common.c:1313
 bch2_sb_realloc+0x2d2/0x660 fs/bcachefs/super-io.c:189
 read_one_super+0x73b/0xf40 fs/bcachefs/super-io.c:660
 __bch2_read_super+0x873/0x1370 fs/bcachefs/super-io.c:751
 bch2_fs_open+0x246/0xdf0 fs/bcachefs/super.c:2084
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1933
 vfs_get_tree+0x90/0x2a0 fs/super.c:1789
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88807a284000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 0 bytes to the right of
 allocated 8192-byte region [ffff88807a284000, ffff88807a286000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7a280
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
ksm flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xfdffffff(slab)
raw: 00fff00000000040 ffff888015442280 ffffea0000948200 0000000000000003
raw: 0000000000000000 0000000080020002 00000001fdffffff 0000000000000000
head: 00fff00000000040 ffff888015442280 ffffea0000948200 0000000000000003
head: 0000000000000000 0000000080020002 00000001fdffffff 0000000000000000
head: 00fff00000000003 ffffea0001e8a001 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4879, tgid 4879 (rcS), ts 34538747384, free_ts 34514158572
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1493
 prep_new_page mm/page_alloc.c:1501 [inline]
 get_page_from_freelist+0x2e4c/0x2f10 mm/page_alloc.c:3438
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4696
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2321
 allocate_slab+0x5a/0x2f0 mm/slub.c:2484
 new_slab mm/slub.c:2537 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3723
 __slab_alloc+0x58/0xa0 mm/slub.c:3813
 __slab_alloc_node mm/slub.c:3866 [inline]
 slab_alloc_node mm/slub.c:4025 [inline]
 __kmalloc_cache_noprof+0x1d5/0x2c0 mm/slub.c:4184
 kmalloc_noprof include/linux/slab.h:681 [inline]
 kzalloc_noprof include/linux/slab.h:807 [inline]
 tomoyo_print_bprm security/tomoyo/audit.c:26 [inline]
 tomoyo_init_log+0x11ce/0x2050 security/tomoyo/audit.c:264
 tomoyo_supervisor+0x38a/0x11f0 security/tomoyo/common.c:2089
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x178/0x210 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x1384/0x1cf0 security/tomoyo/domain.c:878
 tomoyo_bprm_check_security+0x115/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x65/0x90 security/security.c:1191
 search_binary_handler fs/exec.c:1809 [inline]
 exec_binprm fs/exec.c:1863 [inline]
 bprm_execve+0xa56/0x1770 fs/exec.c:1914
 do_execveat_common+0x55f/0x6f0 fs/exec.c:2021
page last free pid 4878 tgid 4878 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1094 [inline]
 free_unref_page+0xd19/0xea0 mm/page_alloc.c:2608
 discard_slab mm/slub.c:2583 [inline]
 __put_partials+0xeb/0x130 mm/slub.c:3051
 put_cpu_partial+0x17c/0x250 mm/slub.c:3126
 __slab_free+0x2ea/0x3d0 mm/slub.c:4343
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3988 [inline]
 slab_alloc_node mm/slub.c:4037 [inline]
 kmem_cache_alloc_noprof+0x135/0x2a0 mm/slub.c:4044
 vm_area_alloc+0x24/0x1d0 kernel/fork.c:471
 mmap_region+0xc3d/0x2090 mm/mmap.c:2944
 do_mmap+0x8f9/0x1010 mm/mmap.c:1468
 vm_mmap_pgoff+0x1dd/0x3d0 mm/util.c:588
 ksys_mmap_pgoff+0x4f1/0x720 mm/mmap.c:1514
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88807a285f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807a285f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807a286000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88807a286080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807a286100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
