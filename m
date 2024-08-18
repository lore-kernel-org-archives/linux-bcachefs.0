Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBEC81AD2
	for <linux-bcachefs@vger.kernel.org>; Sun, 18 Aug 2024 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724000788; cv=none; b=QEuLlpRvfPM155UBSTvx95YNO2dqWY1lVFT8M934g8JUJ8277UrnBv7ADy+Wj1hAwt/WbUYcbaiNzIo4T7REdZmLyKZPsGxWga3EDNVQBQWPDl1IDLcP+cDNot+QbKXvBMTS3F2sjeiM6n5gLugB/3biY6teI6yo335qcfsqVNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724000788; c=relaxed/simple;
	bh=z+OaRYqORscv3wgtcEX/FG0h7/p1vvdESS3vYIk4O78=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YqFEJztNzus1KW5kl9xjY1tGnGwSRhHTy5KkyX6vF/M+uWZ/zaMMQ8OnMF0+f7FLlu9C4Am7Nr9KqaxB4bWQ6p3OeO1m212s2X4nnzCAqVaENwVAwRbF8nWJzS0QJBvxFWkY8cgAX+3OMZGnCDmHj/M55K+fW495Q6WXpnt2FL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81fc0896188so362328739f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 18 Aug 2024 10:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724000786; x=1724605586;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H1XEKZayoCF5lu4+4UcVwNFy+pnc9Yam88eUDVU7qgs=;
        b=M7Vlot+sRYb/FC8EU6tAZ9Yi51HPeScEVD4z0yFRLQ82+RlMqbV5UWPk5nYBnLHsil
         xN+9XRdA4yoIhLW4rdZCIuXNBEU4jIbYAEyU1MzuIJO2BiKvBRy+Qa19yeLyg99qzQpJ
         QjB/JAlO8TGgHLo1VXNF+bm7sSJKwylt99VP4pDguaaRkiAw1tB2pM1FCLdjELVZrrCn
         k5qQygj26RNsk5M6iheAYTCt/2xMPIWkyD4D2LG7kueR/TFIYQJD7zCAaNWpI1XnX7VY
         dvS9Z5FNNgSEku4mYHvOsC4VcGy9xqr2de0Ixau7N1LM9Pf2OOrWgMBWFjFVQrNk5820
         HJ6g==
X-Forwarded-Encrypted: i=1; AJvYcCUB/RnARRSF3kOo+AB4y6fqABfAmdzwFu8HpESXLDdy3SoKfD3MBccP39C+P+XarjRtbUzV9hDN1saHP6xQaB/3FzNuax8WAMFnTCGshsE=
X-Gm-Message-State: AOJu0Yxlsf6l6zRWBCocU+LbyYmKyM3icyeD1MYjXaqKwHOS7+U5fPAz
	Pa7pp7VSDXywnPCoghf+N3aFRCmOVQzvcz+ixSKK7x7NhRiYjgN9IL4wPxoZu536PjZ/UqR3EQ3
	EtS5tJ56gaWNv89smd9j6oGK9VgRnoBsXsnkcdw6vrFkt7e+makzkVfQ=
X-Google-Smtp-Source: AGHT+IGPP5LbWlezPxSD+rpijZq1d7gn7/a4m9EkJ/OH9NTS1NLEsZ7uR8hx72ewnFt5S8XDrrFBZ5z5gO/vlmGpPukKPOeDNXeI
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2c:b0:39a:e800:eec9 with SMTP id
 e9e14a558f8ab-39d26d626a5mr5599855ab.4.1724000786032; Sun, 18 Aug 2024
 10:06:26 -0700 (PDT)
Date: Sun, 18 Aug 2024 10:06:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000071b7c5061ff83639@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Write in bch2_dev_journal_init
From: syzbot <syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c3f2d783a459 Merge tag 'mm-hotfixes-stable-2024-08-17-19-3..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=100aeafd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=47ecc948aadfb2ab3efc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b1ba05980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1315f9f5980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-c3f2d783.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4d927f7c3cfd/vmlinux-c3f2d783.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea54bdfad24b/bzImage-c3f2d783.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c595598cced9/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+47ecc948aadfb2ab3efc@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
==================================================================
BUG: KASAN: slab-out-of-bounds in bch2_dev_journal_init+0x7a1/0xb20 fs/bcachefs/journal.c:1344
Write of size 8 at addr ffff888037acd1b0 by task syz-executor526/5092

CPU: 0 UID: 0 PID: 5092 Comm: syz-executor526 Not tainted 6.11.0-rc3-syzkaller-00338-gc3f2d783a459 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 bch2_dev_journal_init+0x7a1/0xb20 fs/bcachefs/journal.c:1344
 __bch2_dev_attach_bdev+0x217/0x340 fs/bcachefs/super.c:1390
 bch2_dev_attach_bdev+0x2a8/0x6f0 fs/bcachefs/super.c:1420
 bch2_fs_open+0x97c/0xdf0 fs/bcachefs/super.c:2122
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1933
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbd7d15ddea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffefd8bb078 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffefd8bb090 RCX: 00007fbd7d15ddea
RDX: 00000000200058c0 RSI: 0000000020005900 RDI: 00007ffefd8bb090
RBP: 0000000000000004 R08: 00007ffefd8bb0d0 R09: 00000000000058a7
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffefd8bb0d0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

Allocated by task 5092:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 __do_kmalloc_node mm/slub.c:4158 [inline]
 __kmalloc_noprof+0x1fc/0x400 mm/slub.c:4170
 kmalloc_noprof include/linux/slab.h:685 [inline]
 kmalloc_array_noprof include/linux/slab.h:726 [inline]
 bch2_dev_journal_init+0x647/0xb20 fs/bcachefs/journal.c:1334
 __bch2_dev_attach_bdev+0x217/0x340 fs/bcachefs/super.c:1390
 bch2_dev_attach_bdev+0x2a8/0x6f0 fs/bcachefs/super.c:1420
 bch2_fs_open+0x97c/0xdf0 fs/bcachefs/super.c:2122
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1933
 vfs_get_tree+0x90/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888037acd180
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes to the right of
 allocated 48-byte region [ffff888037acd180, ffff888037acd1b0)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x37acd
anon flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: 0xfdffffff(slab)
raw: 04fff00000000000 ffff8880158418c0 ffffea0000e1eb00 dead000000000005
raw: 0000000000000000 0000000080200020 00000001fdffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 4863, tgid 4863 (cmp), ts 54291412922, free_ts 54229723596
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1493
 prep_new_page mm/page_alloc.c:1501 [inline]
 get_page_from_freelist+0x2e4c/0x2f10 mm/page_alloc.c:3439
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4695
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2321
 allocate_slab+0x5a/0x2f0 mm/slub.c:2484
 new_slab mm/slub.c:2537 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3723
 __slab_alloc+0x58/0xa0 mm/slub.c:3813
 __slab_alloc_node mm/slub.c:3866 [inline]
 slab_alloc_node mm/slub.c:4025 [inline]
 __do_kmalloc_node mm/slub.c:4157 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4170
 kmalloc_noprof include/linux/slab.h:685 [inline]
 tomoyo_add_entry security/tomoyo/common.c:2023 [inline]
 tomoyo_supervisor+0xe0d/0x11f0 security/tomoyo/common.c:2095
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission+0x243/0x360 security/tomoyo/file.c:587
 tomoyo_check_open_permission+0x2fb/0x500 security/tomoyo/file.c:777
 security_file_open+0x6a/0x750 security/security.c:2988
 do_dentry_open+0x38e/0x1440 fs/open.c:946
 vfs_open+0x3e/0x330 fs/open.c:1089
 do_open fs/namei.c:3727 [inline]
 path_openat+0x2b3e/0x3470 fs/namei.c:3886
 do_filp_open+0x235/0x490 fs/namei.c:3913
page last free pid 4862 tgid 4862 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1094 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2612
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
 getname_flags+0xb7/0x540 fs/namei.c:139
 vfs_fstatat+0x12c/0x190 fs/stat.c:340
 __do_sys_newfstatat fs/stat.c:505 [inline]
 __se_sys_newfstatat fs/stat.c:499 [inline]
 __x64_sys_newfstatat+0x11d/0x1a0 fs/stat.c:499
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888037acd080: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff888037acd100: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888037acd180: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
                                     ^
 ffff888037acd200: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888037acd280: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
