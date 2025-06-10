Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C87263C8F
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 19:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582934; cv=none; b=f1WvckncWYTqN83Wy2AW7eMJh3qyif80LjN0HP1xMIit7RNjg0f6Y160zJcc2WCRADL7EKx9QeghJTyTHbPsM9kJ3DZp/B2q8c/MjRsQpBnWM9SNUHURO13iYFq8DuxjzhNYuGEnHBSu1WM/zeO4rN32iJZJsEKBJyyry615mos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582934; c=relaxed/simple;
	bh=nBiqY1ttloUkucE5ZGeKSoSl5D913yGtKORW1OhUwi0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=b4yiVy4Y/fLAf9LEEFJZy0nLG9GmmlLoRJ9Mz4fefxPUhY3iRWP/FcKrc7+oKZLoMPSTGeyG9hHLnJjEnSRRs/1p4JKHSmxopM75qh0Vi54otR2gRYHmPDhNNNEhsrbnZhex3ijR4JheLTs7WIwrbLQ8CyJgirJ+6I6+I9j6E4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddd97c04f4so38932055ab.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 12:15:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749582932; x=1750187732;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uxJfpVsOV12fZ+GhHP61HRTrfU6ZmP0YWJzM0Rw8+7s=;
        b=jG0FwHD1Cnar0CnIeuGFi70UXY0FgspUz53dMhuQTMZ3auDuaKiq3pRBk91hq+Lrvt
         6U9Wh5WKyu9bt2PwVdxCb6pts6AZQgoOIoZjRI6GtNTZ1kAAecieOt8VrimUGws8w47N
         n3LXTQcXIHXwIelzy0cItAGmOj/g/r+2smxmi+hFBHx7PewLqOIWLWjg6dAol7CQSKvB
         7lOIsJavExLXWbzZLw1WgkBho62NEVDGjaBRGLdKJVwGrm2JL5QL/5JJDTzvOAnjxaKR
         qEeeH1b3P/snDGuzWTjUBVpD5Q6QdxawYLqPdZY8O12Dz8W5U/PWxehRnYFEnb8httq1
         LNCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbV9QmOGa4+DhBVpVHrzcaG40eCucunyOY4bcqu4VquPF+p69qYWQ/f2GNpze39m0+DDbnGaGg5R3kKr5vtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZwC6SPVm9P+Hg43uE5aZDyFNnedohrwKlb6jhKfIx7B5MWJ2+
	jqdpEtpzIu5cuWdndA8uW5nTbn7hnumQivQEh1t0yHq3ae3ynxDBCcI9O2Rrc7eF1AbN56wHAnG
	IrIU8R72CHTlbyWRQJV4x4bqEsUrx2E0btcZRR3gmjuTDyr2QVaTWm0H2PgA=
X-Google-Smtp-Source: AGHT+IG7p6A8pEOvkd4J6ISChqoFiyD6AheGOCx1ESupgqu3uhJhK5LDLuH/vPrVbB9CrQrm6/cUq+xuJFHJ2Ji/cys4EFzIZwdf
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3dc:7f17:72cd with SMTP id
 e9e14a558f8ab-3ddf42e3e3dmr6204295ab.19.1749582931752; Tue, 10 Jun 2025
 12:15:31 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:15:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68488453.a70a0220.27c366.0067.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_sb_members_v1_to_text
From: syzbot <syzbot+e577022d4fba380653be@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b27cc623e01b Add linux-next specific files for 20250610
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11a1e9d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=846e731334efc0f8
dashboard link: https://syzkaller.appspot.com/bug?extid=e577022d4fba380653be
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b2260c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1144cd70580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1c0c417339c8/disk-b27cc623.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa29c0f3a1fa/vmlinux-b27cc623.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b902a80b6e7e/bzImage-b27cc623.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9ddd2f474e69/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e577022d4fba380653be@syzkaller.appspotmail.com

WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
==================================================================
BUG: KASAN: slab-out-of-bounds in members_v1_get fs/bcachefs/sb-members.c:81 [inline]
BUG: KASAN: slab-out-of-bounds in bch2_sb_members_v1_to_text+0x1b2/0x2b0 fs/bcachefs/sb-members.c:334
Read of size 56 at addr ffff88803377dfd8 by task syz-executor978/5840

CPU: 1 UID: 0 PID: 5840 Comm: syz-executor978 Not tainted 6.16.0-rc1-next-20250610-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xd2/0x2b0 mm/kasan/report.c:521
 kasan_report+0x118/0x150 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 members_v1_get fs/bcachefs/sb-members.c:81 [inline]
 bch2_sb_members_v1_to_text+0x1b2/0x2b0 fs/bcachefs/sb-members.c:334
 bch2_sb_field_validate+0x1c6/0x280 fs/bcachefs/super-io.c:1380
 bch2_sb_validate+0x14bd/0x1980 fs/bcachefs/super-io.c:552
 __bch2_read_super+0xba4/0x1040 fs/bcachefs/super-io.c:925
 bch2_fs_open+0x1fe/0x2570 fs/bcachefs/super.c:2382
 bch2_fs_get_tree+0x437/0x14f0 fs/bcachefs/fs.c:2473
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1802
 do_new_mount+0x24a/0xa40 fs/namespace.c:3885
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f3ede35b93a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffebfe7f6d8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffebfe7f6f0 RCX: 00007f3ede35b93a
RDX: 00002000000003c0 RSI: 0000200000000080 RDI: 00007ffebfe7f6f0
RBP: 0000200000000080 R08: 00007ffebfe7f730 R09: 000000000000592e
R10: 0000000000808040 R11: 0000000000000282 R12: 00002000000003c0
R13: 00007ffebfe7f730 R14: 0000000000000003 R15: 0000000000808040
 </TASK>

Allocated by task 5840:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4328 [inline]
 __kmalloc_node_track_caller_noprof+0x271/0x4e0 mm/slub.c:4347
 __do_krealloc mm/slub.c:4905 [inline]
 krealloc_noprof+0x124/0x340 mm/slub.c:4958
 bch2_sb_realloc+0x348/0x630 fs/bcachefs/super-io.c:222
 read_one_super+0x3a3/0x850 fs/bcachefs/super-io.c:759
 __bch2_read_super+0x6c6/0x1040 fs/bcachefs/super-io.c:851
 bch2_fs_open+0x1fe/0x2570 fs/bcachefs/super.c:2382
 bch2_fs_get_tree+0x437/0x14f0 fs/bcachefs/fs.c:2473
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1802
 do_new_mount+0x24a/0xa40 fs/namespace.c:3885
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88803377c000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 8152 bytes inside of
 allocated 8192-byte region [ffff88803377c000, ffff88803377e000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x33778
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801a442280 ffffea0000d03200 0000000000000005
raw: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801a442280 ffffea0000d03200 0000000000000005
head: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0000cdde01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5495, tgid 5495 (sh), ts 57351029645, free_ts 57299723965
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2451 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2619
 new_slab mm/slub.c:2673 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
 __slab_alloc mm/slub.c:3949 [inline]
 __slab_alloc_node mm/slub.c:4024 [inline]
 slab_alloc_node mm/slub.c:4185 [inline]
 __kmalloc_cache_noprof+0x296/0x3d0 mm/slub.c:4354
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 tomoyo_print_bprm security/tomoyo/audit.c:26 [inline]
 tomoyo_init_log+0x111f/0x1f70 security/tomoyo/audit.c:264
 tomoyo_supervisor+0x340/0x1480 security/tomoyo/common.c:2198
 tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
 tomoyo_env_perm+0x149/0x1e0 security/tomoyo/environ.c:63
 tomoyo_environ security/tomoyo/domain.c:672 [inline]
 tomoyo_find_next_domain+0x15cf/0x1aa0 security/tomoyo/domain.c:888
 tomoyo_bprm_check_security+0x11c/0x180 security/tomoyo/tomoyo.c:102
 security_bprm_check+0x89/0x270 security/security.c:1302
 search_binary_handler fs/exec.c:1655 [inline]
 exec_binprm fs/exec.c:1697 [inline]
 bprm_execve+0x8ee/0x1450 fs/exec.c:1749
 do_execveat_common+0x510/0x6a0 fs/exec.c:1855
 do_execve fs/exec.c:1929 [inline]
 __do_sys_execve fs/exec.c:2005 [inline]
 __se_sys_execve fs/exec.c:2000 [inline]
 __x64_sys_execve+0x94/0xb0 fs/exec.c:2000
page last free pid 5494 tgid 5494 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0xc71/0xe70 mm/page_alloc.c:2706
 discard_slab mm/slub.c:2717 [inline]
 __put_partials+0x161/0x1c0 mm/slub.c:3186
 put_cpu_partial+0x17c/0x250 mm/slub.c:3261
 __slab_free+0x2f7/0x400 mm/slub.c:4513
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4148 [inline]
 slab_alloc_node mm/slub.c:4197 [inline]
 __kmalloc_cache_noprof+0x1be/0x3d0 mm/slub.c:4354
 kmalloc_noprof include/linux/slab.h:905 [inline]
 tomoyo_print_header security/tomoyo/audit.c:156 [inline]
 tomoyo_init_log+0x183/0x1f70 security/tomoyo/audit.c:255
 tomoyo_supervisor+0x340/0x1480 security/tomoyo/common.c:2198
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission+0x25a/0x380 security/tomoyo/file.c:587
 tomoyo_check_open_permission+0x24d/0x3b0 security/tomoyo/file.c:777
 security_file_open+0xb1/0x270 security/security.c:3114
 do_dentry_open+0x35e/0x1970 fs/open.c:941
 vfs_open+0x3b/0x340 fs/open.c:1094
 do_open fs/namei.c:3887 [inline]
 path_openat+0x2ee5/0x3830 fs/namei.c:4046

Memory state around the buggy address:
 ffff88803377df00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88803377df80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88803377e000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88803377e080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803377e100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
