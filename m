Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898071B86CC
	for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729693655; cv=none; b=HDm0j3BFZ6z1ikygDZoqIYVgujsHZwFCx9kIGgOs9MUgUauKk13R9zkfKv29TmxPmO+r74wM/eGN9z6hLYdnTChz8/CaJKDt8qs8fjuNchhsQZXdqhucMipMvrmbhXDMs1h61ns0UMoslgxxE/qp7Y0WYOZ46IU+ChF9fyURkiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729693655; c=relaxed/simple;
	bh=iFRNWlUe7uqiqQhA5bR39N3N+ZKPUXvBjLwpkm0+3oU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M7JN2jy6REVHo+tqK1juSmeerRXSrWU4Wmtjr5LHXgWR17EUgZuAXZ6xY/SyaWm4Ca9ucGDpi/erQVWFu0/zpMGKFgbGS/8Ot5GzIWjJtRcQesMZF3PCuMPlcEYpbZ/TPHisTEgibsAZ/Xtc2uHe/r4wv1EhgzGq5rydwtcCc6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a3e1ef9102so69160175ab.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 23 Oct 2024 07:27:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729693653; x=1730298453;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FfFQLo8pA5nR+ZAeIDgDKmZs8/dPtqqDrYz9/8hiyVA=;
        b=AYelGcS9d54ZdDi0ZPyt3/XWUCN7aUcFH7/ONYXqV44m3uI+s0mv1gphi4Pdpo4/Vu
         cGDEh5+qZ+EDHvmeo09OEOVk2zJgVD1SaEognIwEdSUzcTBjLNJYylul3rteN7bDEpQf
         cJFnGKOiJkZp0oNHLmL8I8PasziQeB5tz7pydeHJJlaxq1hjGS3z5OGWufJBBBfWXIWW
         gqi4Ya63ogrpTh1X+RXVoH9uZXN4Z/JHlo3w8qGNK396qMyQDbdkkxYMBjoLZw/Fi+Bk
         Cw8Mv9BoQxfnUtIQHuXGkKoop8JxogIsXj7mnJKq/4G+0vhQtdVemuHKTF+FTcCI4jfi
         FIJg==
X-Forwarded-Encrypted: i=1; AJvYcCU9B3nND7U5+t08JyLzO0M+Bseu9W/BzgbvjqgPpOABA5CUzTOd3eoX63YenSaTEUaRxR6ZAuVU6badv8ZgfQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzhkk/darN9FUnFiJyW+S+XsnUrhF7dUYPiRnhC9c6VeLKpntmT
	O1W/8DD6rJcQocwYViwHVMJXgk/dFSBwatRdP8YhKHII7AEIFM/ee5gDLHmS76WDol9WW7Bkq0t
	yRiyD/Qb1cdpCZxSyYXrk4/u4eHdpj53BP/jhs5HwfnnhSURhXVFbF4g=
X-Google-Smtp-Source: AGHT+IGSRgiGyj6b6Re4zDooDVa1ZOB2X10iiqZvotw2FVR4uacdozAs+eEzwi2ThNgL1aN7cVi81sJc0XpVtshKx61Dh85QnVPQ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1e0d:b0:3a3:63c3:352e with SMTP id
 e9e14a558f8ab-3a4d59bbd73mr35446045ab.19.1729693652719; Wed, 23 Oct 2024
 07:27:32 -0700 (PDT)
Date: Wed, 23 Oct 2024 07:27:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671907d4.050a0220.1e4b4d.008f.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bch2_reconstruct_alloc
From: syzbot <syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    15e7d45e786a Add linux-next specific files for 20241016
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10cbc0a7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c36416f1c54640c0
dashboard link: https://syzkaller.appspot.com/bug?extid=9fc4dac4775d07bcfe34
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11c7f487980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=167b3240580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cf2ad43c81cc/disk-15e7d45e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c85347a66a1c/vmlinux-15e7d45e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/648cf8e59c13/bzImage-15e7d45e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bca28bd33502/mount_0.gz

The issue was bisected to:

commit 84f1638795da1ff2084597de4251e9054f1ad728
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Dec 29 20:25:07 2023 +0000

    bcachefs: bch_sb_field_downgrade

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ca7240580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ca7240580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ca7240580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9fc4dac4775d07bcfe34@syzkaller.appspotmail.com
Fixes: 84f1638795da ("bcachefs: bch_sb_field_downgrade")

bcachefs (loop0): recovering from clean shutdown, journal seq 8
bcachefs (loop0): dropping and reconstructing all alloc info
==================================================================
BUG: KASAN: slab-use-after-free in bch2_reconstruct_alloc+0x2af/0xac0 fs/bcachefs/recovery.c:134
Read of size 8 at addr ffff888075728f58 by task syz-executor251/5234

CPU: 1 UID: 0 PID: 5234 Comm: syz-executor251 Not tainted 6.12.0-rc3-next-20241016-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 bch2_reconstruct_alloc+0x2af/0xac0 fs/bcachefs/recovery.c:134
 bch2_fs_recovery+0x12dd/0x39a0 fs/bcachefs/recovery.c:842
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe135241f6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc99fea9d8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc99fea9f0 RCX: 00007fe135241f6a
RDX: 0000000020005b00 RSI: 0000000020005b40 RDI: 00007ffc99fea9f0
RBP: 0000000000000004 R08: 00007ffc99feaa30 R09: 0000000000005b27
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffc99feaa30 R14: 0000000000000003 R15: 0000000001000000
 </TASK>

Allocated by task 5234:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4273 [inline]
 __kmalloc_node_track_caller_noprof+0x28b/0x4c0 mm/slub.c:4292
 __do_krealloc mm/slub.c:4767 [inline]
 krealloc_noprof+0x65/0x100 mm/slub.c:4816
 bch2_sb_realloc+0x2d2/0x660 fs/bcachefs/super-io.c:189
 __copy_super+0x5dc/0xe70 fs/bcachefs/super-io.c:586
 bch2_sb_to_fs+0xab/0x150 fs/bcachefs/super-io.c:613
 bch2_fs_alloc fs/bcachefs/super.c:828 [inline]
 bch2_fs_open+0x16b2/0x2fa0 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2161
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5234:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:582
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2329 [inline]
 slab_free mm/slub.c:4588 [inline]
 kfree+0x1a0/0x460 mm/slub.c:4736
 krealloc_noprof+0xc9/0x100
 bch2_sb_realloc+0x2d2/0x660 fs/bcachefs/super-io.c:189
 bch2_sb_field_resize_id+0x140/0x7c0 fs/bcachefs/super-io.c:221
 bch2_sb_counters_from_cpu+0xac/0x300 fs/bcachefs/sb-counters.c:67
 bch2_write_super+0xe80/0x3c50 fs/bcachefs/super-io.c:976
 bch2_reconstruct_alloc+0x28c/0xac0 fs/bcachefs/recovery.c:131
 bch2_fs_recovery+0x12dd/0x39a0 fs/bcachefs/recovery.c:842
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888075728000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 3928 bytes inside of
 freed 4096-byte region [ffff888075728000, ffff888075729000)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x75728
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 00fff00000000040 ffff88801ac42140 dead000000000122 0000000000000000
head: 0000000000000000 0000000000040004 00000001f5000000 0000000000000000
head: 00fff00000000003 ffffea0001d5ca01 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5234, tgid 5234 (syz-executor251), ts 72141103867, free_ts 58943313114
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x3123/0x3270 mm/page_alloc.c:3493
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4769
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x120 mm/slub.c:2399
 allocate_slab+0x5a/0x2f0 mm/slub.c:2565
 new_slab mm/slub.c:2618 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3805
 __slab_alloc+0x58/0xa0 mm/slub.c:3895
 __slab_alloc_node mm/slub.c:3970 [inline]
 slab_alloc_node mm/slub.c:4131 [inline]
 __do_kmalloc_node mm/slub.c:4272 [inline]
 __kmalloc_node_track_caller_noprof+0x2e9/0x4c0 mm/slub.c:4292
 __do_krealloc mm/slub.c:4767 [inline]
 krealloc_noprof+0x65/0x100 mm/slub.c:4816
 bch2_sb_realloc+0x2d2/0x660 fs/bcachefs/super-io.c:189
 __copy_super+0x5dc/0xe70 fs/bcachefs/super-io.c:586
 bch2_sb_to_fs+0xab/0x150 fs/bcachefs/super-io.c:613
 bch2_fs_alloc fs/bcachefs/super.c:828 [inline]
 bch2_fs_open+0x16b2/0x2fa0 fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x738/0x1710 fs/bcachefs/fs.c:2161
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
page last free pid 5215 tgid 5215 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1108 [inline]
 free_unref_page+0xcfb/0xf20 mm/page_alloc.c:2674
 __folio_put+0x2c7/0x440 mm/swap.c:126
 pipe_buf_release include/linux/pipe_fs_i.h:219 [inline]
 pipe_update_tail fs/pipe.c:224 [inline]
 pipe_read+0x6ed/0x13e0 fs/pipe.c:344
 new_sync_read fs/read_write.c:488 [inline]
 vfs_read+0x9bb/0xbc0 fs/read_write.c:569
 ksys_read+0x183/0x2b0 fs/read_write.c:712
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888075728e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075728e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888075728f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                    ^
 ffff888075728f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888075729000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
