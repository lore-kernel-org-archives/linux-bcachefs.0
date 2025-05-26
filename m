Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363031F4E48
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748256090; cv=none; b=uerVMAL0Ho31TEMtEuBk/cDLzWen82SRQtz7u6B6BFuD6/MY471Kux88OLjtUNn/UwWMKKG68gnk65lHW670UZKYMgGgu/WARoj5P/OcIOhwRIkwG9E9Te7pHqhtJ2npFhg01PkzCmZ8Bfhv1wgPldoQOsz3wp4J26Ww8NF+j7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748256090; c=relaxed/simple;
	bh=ITYjsy2fleim43TQtPHJb0arxW8O/ITd8j3fbpHXGhg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Mn0giLkwMzaTWxC0gxMV6U0gbrnt2Lp3XtFEqbopZi/997ygrdtjLOdpVCEXJoKCCtQvYU4qYFTTlsjphuUIiuwwqaOP40WO7VpMsXQRY+nCCtQZ4piiwXo5iVcIsL/kvIHYk2cjaW56r5lgIDW+2EFHxOqSF+k1SDZCsYd1c9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-85e15e32379so188521239f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 03:41:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748256087; x=1748860887;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=05YA94D5fjmVhBlXDtWQ7aBUY+X1+W6EacWBifoALes=;
        b=SYYNJNzgEtrAworK34I/+zmTtr+7ls8RVaWO2styF55/K57mVd/yllieraFJ/e5otQ
         wk+r9TElvelzFK/xi/BiyjmI7/l82kKglLJ0YNSjUgKXWhqLXwqjqWp7dP8+ZavwfEwl
         yAjVKAlY7g1nrmoi+Otz069uscLbqrav8T6xbgrBlZ0t7UtloJIIraO+L4yZCQmMAupn
         kEXwUHOmUufgSUCClv2qL3vAiU0c/sOGx208lg3f9HJBy8KmW7GWrxV6hj+LkK3UMwYA
         7+z3i1B72f8if5F1DPnb+T4sZUt+OStRGPW8kPPE+ngQsM+i9poiBoTGINnxSSLWXIJb
         BEIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQE6nYexJFskz7VJq4kJ+GognsS3qycoEy72JHgEbxrGXtx+2VXPP5j/kVT60XT4e99gVvole6+vkCc8fHtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHcrfShy38x3TVJ1REu4wzcaNOc6Uy6zBuJHl8zkd5agPNyrxe
	HjjU53gDQ8wK3E3W6Dqr+UFbe9VZwf9vdIVdKG9r0tn8365oWNXinVMZ8npZ5bzca4hhn2W6wAA
	2ZVwVZVPtskDe1o4rPMAiT6MXnXVJd4MH1xt7aKwn3MF1n71sS8T5KiybpXY=
X-Google-Smtp-Source: AGHT+IGK4lBMUV80AaLLBm4G65pDBv+4qL3nnKr5uEl5lNK7wTJU0Sq6ILsGHAof28yobV9NVxjCgwqVj8cv/A44IfFfQli+c3f5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6cc7:b0:867:235d:32d9 with SMTP id
 ca18e2360f4ac-86cbb7caaa8mr715243939f.1.1748256087364; Mon, 26 May 2025
 03:41:27 -0700 (PDT)
Date: Mon, 26 May 2025 03:41:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68344557.a70a0220.1765ec.0165.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_sb_members_v2_to_text
From: syzbot <syzbot+5138f00559ffb3cb3610@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    176e917e010c Add linux-next specific files for 20250523
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1159c5f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7902c752bef748
dashboard link: https://syzkaller.appspot.com/bug?extid=5138f00559ffb3cb3610
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a759f4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14e065f4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5f7692c642fa/disk-176e917e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/057a442d42d0/vmlinux-176e917e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f8ebdb4dd96/bzImage-176e917e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9032c3d09738/mount_0.gz

The issue was bisected to:

commit 1c8dfd7ba50dbbb72113caf4fa7868512cdad2f4
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Wed Apr 16 03:35:48 2025 +0000

    bcachefs: sb_validate() no longer requires members_v1

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11d21ad4580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13d21ad4580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15d21ad4580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5138f00559ffb3cb3610@syzkaller.appspotmail.com
Fixes: 1c8dfd7ba50d ("bcachefs: sb_validate() no longer requires members_v1")

loop0: detected capacity change from 0 to 32768
==================================================================
BUG: KASAN: slab-out-of-bounds in members_v2_get fs/bcachefs/sb-members.c:68 [inline]
BUG: KASAN: slab-out-of-bounds in bch2_sb_members_v2_to_text+0x1ae/0x310 fs/bcachefs/sb-members.c:347
Read of size 136 at addr ffff88807716dfb8 by task syz-executor118/5842

CPU: 0 UID: 0 PID: 5842 Comm: syz-executor118 Not tainted 6.15.0-rc7-next-20250523-syzkaller #0 PREEMPT(full) 
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
 members_v2_get fs/bcachefs/sb-members.c:68 [inline]
 bch2_sb_members_v2_to_text+0x1ae/0x310 fs/bcachefs/sb-members.c:347
 bch2_sb_field_validate+0x1c6/0x280 fs/bcachefs/super-io.c:1380
 bch2_sb_validate+0x14bd/0x1980 fs/bcachefs/super-io.c:552
 __bch2_read_super+0xba4/0x1040 fs/bcachefs/super-io.c:925
 bch2_fs_open+0x1fe/0x25c0 fs/bcachefs/super.c:2371
 bch2_fs_get_tree+0x44d/0x15f0 fs/bcachefs/fs.c:2463
 vfs_get_tree+0x92/0x2b0 fs/super.c:1802
 do_new_mount+0x24a/0xa40 fs/namespace.c:3869
 do_mount fs/namespace.c:4206 [inline]
 __do_sys_mount fs/namespace.c:4417 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4394
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f813c8a7dfa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeafb83b88 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffeafb83ba0 RCX: 00007f813c8a7dfa
RDX: 00002000000000c0 RSI: 0000200000000300 RDI: 00007ffeafb83ba0
RBP: 0000000000000010 R08: 00007ffeafb83be0 R09: 00ffffffffffffff
R10: 0000000000000010 R11: 0000000000000282 R12: 00002000000000c0
R13: 0000200000000300 R14: 00007ffeafb83be0 R15: 0000000000000003
 </TASK>

Allocated by task 5842:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4327 [inline]
 __kmalloc_node_track_caller_noprof+0x271/0x4e0 mm/slub.c:4346
 __do_krealloc mm/slub.c:4904 [inline]
 krealloc_noprof+0x124/0x340 mm/slub.c:4957
 bch2_sb_realloc+0x348/0x630 fs/bcachefs/super-io.c:222
 read_one_super+0x3a3/0x850 fs/bcachefs/super-io.c:759
 __bch2_read_super+0x6c6/0x1040 fs/bcachefs/super-io.c:851
 bch2_fs_open+0x1fe/0x25c0 fs/bcachefs/super.c:2371
 bch2_fs_get_tree+0x44d/0x15f0 fs/bcachefs/fs.c:2463
 vfs_get_tree+0x92/0x2b0 fs/super.c:1802
 do_new_mount+0x24a/0xa40 fs/namespace.c:3869
 do_mount fs/namespace.c:4206 [inline]
 __do_sys_mount fs/namespace.c:4417 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4394
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88807716c000
 which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 8120 bytes inside of
 allocated 8192-byte region [ffff88807716c000, ffff88807716e000)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x77168
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801a442280 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 00fff00000000040 ffff88801a442280 dead000000000122 0000000000000000
head: 0000000000000000 0000000080020002 00000000f5000000 0000000000000000
head: 00fff00000000003 ffffea0001dc5a01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd28c0(GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5759, tgid 5759 (sshd-session), ts 67004973254, free_ts 66925363852
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
 prep_new_page mm/page_alloc.c:1712 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
 alloc_slab_page mm/slub.c:2450 [inline]
 allocate_slab+0x8a/0x3b0 mm/slub.c:2618
 new_slab mm/slub.c:2672 [inline]
 ___slab_alloc+0xbfc/0x1480 mm/slub.c:3858
 __slab_alloc mm/slub.c:3948 [inline]
 __slab_alloc_node mm/slub.c:4023 [inline]
 slab_alloc_node mm/slub.c:4184 [inline]
 __do_kmalloc_node mm/slub.c:4326 [inline]
 __kmalloc_node_track_caller_noprof+0x2f8/0x4e0 mm/slub.c:4346
 kmalloc_reserve+0x136/0x290 net/core/skbuff.c:601
 __alloc_skb+0x142/0x2d0 net/core/skbuff.c:670
 alloc_skb include/linux/skbuff.h:1336 [inline]
 netlink_dump+0x1c7/0xe20 net/netlink/af_netlink.c:2275
 netlink_recvmsg+0x67b/0xe00 net/netlink/af_netlink.c:1965
 sock_recvmsg_nosec net/socket.c:1017 [inline]
 sock_recvmsg+0x229/0x270 net/socket.c:1039
 ____sys_recvmsg+0x1c9/0x460 net/socket.c:2786
 ___sys_recvmsg+0x1b5/0x510 net/socket.c:2828
 __sys_recvmsg net/socket.c:2861 [inline]
 __do_sys_recvmsg net/socket.c:2867 [inline]
 __se_sys_recvmsg net/socket.c:2864 [inline]
 __x64_sys_recvmsg+0x198/0x260 net/socket.c:2864
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
page last free pid 5758 tgid 5758 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1248 [inline]
 __free_frozen_pages+0xc71/0xe70 mm/page_alloc.c:2706
 discard_slab mm/slub.c:2716 [inline]
 __put_partials+0x161/0x1c0 mm/slub.c:3185
 put_cpu_partial+0x17c/0x250 mm/slub.c:3260
 __slab_free+0x2f7/0x400 mm/slub.c:4512
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4147 [inline]
 slab_alloc_node mm/slub.c:4196 [inline]
 kmem_cache_alloc_noprof+0x1c1/0x3c0 mm/slub.c:4203
 getname_flags+0xb8/0x540 fs/namei.c:146
 getname include/linux/fs.h:2903 [inline]
 __do_sys_unlink fs/namei.c:4696 [inline]
 __se_sys_unlink fs/namei.c:4694 [inline]
 __x64_sys_unlink+0x3a/0x50 fs/namei.c:4694
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88807716df00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88807716df80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88807716e000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88807716e080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88807716e100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
