Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9CD195381
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541247; cv=none; b=B4G/e8DsQK8JcyNZVW2wMJrbSeB7uI9wwImvYLx3mqJUYRL/SWC/Z3jUwLQuAWPJ0HhBHzRfkFu2cdtc8rekEITFsWwbauY9Ef7YZQlhrXMvVTP6EI8o13ppZPNtVq6WbkiFUyaQa+KIa4tgoR+u8avSDfBYnIT8rcYfqq7iZtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541247; c=relaxed/simple;
	bh=D+GAKCsMdQoeE5MDyvDRyGCjUqt2LK4ydzJjjHQFgeI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=du8sCOjR4AkNODENjWh2FcbP2LHF6PlEoX4YwyEDOoST5A5ZSLpbBVKFK+rMp7k6+cw9p5iVI/Ur3LfsJ5wpkmTLWfHYhkHbb6lGGGmW8lUmmZh99F4fctDOKLLDl+gFyxPPGP3CEka0EedEYhql9ImML9bQjievFwHQarAcElg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-841a3f2aebfso61600139f.0
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 05:27:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732541244; x=1733146044;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vE9DS3iT++uaapJMzeuY8puv7qa9dYzX4boj9a3fiIw=;
        b=gX+q5DOOIVC0FDUXWzoD0wQ5lfpeocOqoIqoU39F+jFSOAGsM3coQem1t9U/tinyx9
         qCk1gsuDnxWCRSYvTtj8xJBvK4F65ORZ87fyUc4F9YR9Ms0S4VJ50zG/vYCjHixAmMYN
         uiHT0MSKRjPMZRX4OQvLhkO8VFbeIBuAD4htcA5veQEiQi2ZtIMvVTV9u/P3iZCVgAyL
         Ivcrbg/pk6fgWcHJUqDifxVn3is668ZMsMt/qBbJR0KHJdqIvJbqqyyqTtkmi2FAF1Ks
         4R1PhDDF5NbejQk32TaYoMtjwH3ENm1JLMe1xF9qRaAAe2nDKhw2x8VLRwkg9LZKaDwg
         T0DA==
X-Forwarded-Encrypted: i=1; AJvYcCUfTF5TP98lOpEmJvA0HSgzq3NdVxEiUJ/L5Rgy5Fnc/aE4iwo1ZMo+ViBVINThaerYF5/1ctZ3zAU4/SupUw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMZvLsPOqvqNoDj3Ep24d0hrmuEMz/0KI4DBTVgvoNWrc9bY9a
	AYI0gduZBKcROkIveNmAeeA3MP9rUCxQ/hSGMz8Ru8eMpUR0h9ctievFThK7tWY/Pvc/e6fnvSP
	y69FhRkBpG3ExjOTaywHnU/TS5dCBwCKTYSmBw5dW7g13dWYcqhp1cSs=
X-Google-Smtp-Source: AGHT+IEV8VApTAvChbcQAcmXJKTI0k5DxBqkHs4TEPSQE6UAvMIe0N3qjBv5El6js+51zL9Z9r7Y/DwdHESV7ostHZeuIc9d6NxB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2f:b0:3a7:4826:b04e with SMTP id
 e9e14a558f8ab-3a79afe2a8emr91860375ab.22.1732541244669; Mon, 25 Nov 2024
 05:27:24 -0800 (PST)
Date: Mon, 25 Nov 2024 05:27:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67447b3c.050a0220.1cc393.0084.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_btree_node_read_done
From: syzbot <syzbot+92e65e9b7a42d379f92e@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    228a1157fb9f Merge tag '6.13-rc-part1-SMB3-client-fixes' o..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16300530580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=402159daa216c89d
dashboard link: https://syzkaller.appspot.com/bug?extid=92e65e9b7a42d379f92e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159bfb78580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170169c0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d32a8e8c5aae/disk-228a1157.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/28d5c070092e/vmlinux-228a1157.xz
kernel image: https://storage.googleapis.com/syzbot-assets/45af4bfd9e8e/bzImage-228a1157.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4b641b27822f/mount_0.gz

The issue was bisected to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11388778580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13388778580000
console output: https://syzkaller.appspot.com/x/log.txt?x=15388778580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92e65e9b7a42d379f92e@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

  node offset 8/24 bset u64s 375 bset byte offset 184: keys out of order: u64s 11 type alloc_v4 0:32:0 len 0 ver 0 > u64s 11 type alloc_v4 0:2:0 len 0 ver 0, fixing
bcachefs (loop0): btree_node_read_work: rewriting btree node at btree=alloc level=0 SPOS_MAX due to error
==================================================================
BUG: KASAN: use-after-free in bch2_btree_node_read_done+0xfbe/0x5e90 fs/bcachefs/btree_io.c:1087
Read of size 8 at addr ffff888076abc010 by task syz-executor345/5842

CPU: 1 UID: 0 PID: 5842 Comm: syz-executor345 Not tainted 6.12.0-syzkaller-08446-g228a1157fb9f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 bch2_btree_node_read_done+0xfbe/0x5e90 fs/bcachefs/btree_io.c:1087
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc4572667ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 3e 06 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd22484098 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc4572667ea
RDX: 00000000200000c0 RSI: 0000000020000180 RDI: 00007ffd224840f0
RBP: 0000000000000004 R08: 00007ffd22484130 R09: 000000000000593e
R10: 0000000000000010 R11: 0000000000000282 R12: 00007ffd22484130
R13: 0000000001000000 R14: 0000000000000003 R15: 0000000000000010
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x76abc
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0001ca0108 ffff8880b87447e0 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 2, migratetype Reclaimable, gfp_mask 0x452cd0(GFP_KERNEL_ACCOUNT|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_RECLAIMABLE), pid 5842, tgid 5842 (syz-executor345), ts 64163821991, free_ts 64389007908
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x363e/0x3790 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 ___kmalloc_large_node+0x8b/0x1d0 mm/slub.c:4209
 __kmalloc_large_node_noprof+0x1a/0x80 mm/slub.c:4236
 __do_kmalloc_node mm/slub.c:4252 [inline]
 __kmalloc_node_noprof+0x2d2/0x440 mm/slub.c:4270
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:658
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
page last free pid 5842 tgid 5842 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xded/0x1130 mm/page_alloc.c:2657
 __folio_put+0x2c7/0x440 mm/swap.c:112
 folio_put include/linux/mm.h:1490 [inline]
 free_large_kmalloc+0x105/0x1c0 mm/slub.c:4698
 kfree+0x21c/0x440 mm/slub.c:4721
 btree_bounce_free fs/bcachefs/btree_io.c:112 [inline]
 bch2_btree_node_read_done+0x3c8a/0x5e90 fs/bcachefs/btree_io.c:1209
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83

Memory state around the buggy address:
 ffff888076abbf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888076abbf80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff888076abc000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                         ^
 ffff888076abc080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888076abc100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
