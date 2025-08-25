Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B62BD5BC
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Aug 2025 08:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111956; cv=none; b=hRoB0V+sAxRmIjzfukzwvx6+hVi+hDqK9Rz2cssHBpu37koINx6jsjXpMSlZZaKE+51CPpSiCJV+ygv2fQmG7KVO/8biqnaQg+5/cJRkJNZrq245f4TRzYqzssWjK3KAQRJZv6SVaGcgE5fNTOQL72mJD/RseNOYyzCrwjJK6qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111956; c=relaxed/simple;
	bh=7YtruJ5/NgMOqMzt6YTIgxVSHrb4MH0JPFJdc8dFSzs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dGv2sDqdlo/It+sjSqbG517p6arGenawWgvQiAwNRn9LlSZTO4tjWtEeOH/eZhNuLOAOiOpb5KRBl1rfKqPkc5mn1ycurcUynzb/x64SeQbvgtQtfqdzESaG1Iq4+KcEf1Kkf/HCd7dT3V/LKKXA35XKrU8p0fbHzAfmvpThRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-88432e1630fso388309039f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Aug 2025 01:52:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756111953; x=1756716753;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Iq/N5W9VQm5tHBJMSnJQLW7Pc3aY5scQCJyeKfwHP7A=;
        b=IaD3lJRkJ0OmC6LUV5Rn/v4KXNy++c+Yf09rHVYEHNX4KL1/iPJIHFep88W5jsUVOd
         i8tjnF2vJHbg+JabZVYx5QO/8Y2U3ztqXFsmx40ze5Kz1w+huWDcMfmKqKoXgvB2YKFn
         Z9X6Q7qbie2fSTS9aBADIp6e+rrtJuhsx2nDhKV2tNGE32iL2Baz2/8Jn11C6gnbhxyk
         UyRkDveRiGfsBgE7HM60XjfiVtSn9Xzi7hAPcyTyRR1D0gFfyoNBQE1In8kwpB8j0mRx
         7Va0FWOBPjrNQ8kCm3XstzwGQL7PlEfhEOBEgbB5bGFCA2H9WIjm+uUsB+xw/LTbs2k5
         fP1g==
X-Forwarded-Encrypted: i=1; AJvYcCWOXQtMQ4Orw3xQBgp6ZKeZZM68j5E8t0Q0giWSFMiZ0eF2ytgb5JmxC1JM0K6LlTXdB5OR/wPMWL+Hr4Nhmg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzSaNAnxVulxOR/TgWG3HQVcpOT3Mv/QmUH0yk3rmf137Ue/SI
	cu6PJxHpLhy+nm4Nh8NwqBdjPA8M2Nv8EEq/gmWeuaajyjh887b/1gxiBbxBPsrgdFARZqRTkKa
	TdKxHbsGmaRHMO3LgJ8eF/wTU3aEnmbKlHM9DDPTfjKUl/hboxEtuKCcnzsY=
X-Google-Smtp-Source: AGHT+IETZ3yYlz7WGrZ59JTHSAGEjISBhF9fu4bwYgA7fNp0YfRunPPSMFe5DS9LvuCY7gCWOuyEu7r/o16RDJXEZGeeiyN4Shgw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19c8:b0:3e4:9a1:6542 with SMTP id
 e9e14a558f8ab-3e921c51667mr187231425ab.18.1756111953724; Mon, 25 Aug 2025
 01:52:33 -0700 (PDT)
Date: Mon, 25 Aug 2025 01:52:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ac2451.050a0220.37038e.008a.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in __bch2_journal_key_search
From: syzbot <syzbot+64ebb0de0a7a7a1535bd@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7fa4d8dc380f Add linux-next specific files for 20250821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=124b8062580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5d054fcd55656377
dashboard link: https://syzkaller.appspot.com/bug?extid=64ebb0de0a7a7a1535bd
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14b53fa2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1569aa34580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a843be98ab42/disk-7fa4d8dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/17b718892b67/vmlinux-7fa4d8dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8939424b4b54/bzImage-7fa4d8dc.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5918c7367d54/mount_0.gz

The issue was bisected to:

commit aecfff73c6c0ef4d697aa17d752d45f60230a649
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Aug 14 14:28:41 2025 +0000

    bcachefs: accounting_read() improvemnts

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=118d4062580000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=138d4062580000
console output: https://syzkaller.appspot.com/x/log.txt?x=158d4062580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+64ebb0de0a7a7a1535bd@syzkaller.appspotmail.com
Fixes: aecfff73c6c0 ("bcachefs: accounting_read() improvemnts")

bcachefs (loop0): set_node_max(): u64s 11 type btree_ptr_v2 0:82:0 len 0 ver 0: seq 4dc858ad08044b41 written 16 min_key POS_MIN durability: 1 ptr: 0:141:0 gen 0 -> SPOS_MAX
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
==================================================================
BUG: KASAN: slab-use-after-free in __journal_key_cmp fs/bcachefs/btree_journal_iter.h:63 [inline]
BUG: KASAN: slab-use-after-free in __bch2_journal_key_search+0x57b/0x12e0 fs/bcachefs/btree_journal_iter.c:54
Read of size 4 at addr ffff88802f05fe94 by task syz.0.17/6037

CPU: 0 UID: 0 PID: 6037 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __journal_key_cmp fs/bcachefs/btree_journal_iter.h:63 [inline]
 __bch2_journal_key_search+0x57b/0x12e0 fs/bcachefs/btree_journal_iter.c:54
 bch2_journal_key_search fs/bcachefs/btree_journal_iter.c:73 [inline]
 bch2_journal_iter_init fs/bcachefs/btree_journal_iter.c:540 [inline]
 __bch2_btree_and_journal_iter_init_node_iter+0x3ad/0x9f0 fs/bcachefs/btree_journal_iter.c:659
 btree_node_iter_and_journal_peek+0x210/0x10a0 fs/bcachefs/btree_iter.c:899
 btree_path_down fs/bcachefs/btree_iter.c:956 [inline]
 bch2_btree_path_traverse_one+0x148d/0x21d0 fs/bcachefs/btree_iter.c:1199
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:252 [inline]
 __bch2_btree_iter_peek fs/bcachefs/btree_iter.c:2266 [inline]
 bch2_btree_iter_peek_max+0xa56/0x6580 fs/bcachefs/btree_iter.c:2385
 bch2_btree_iter_peek_max_type fs/bcachefs/btree_iter.h:769 [inline]
 bch2_gc_btree fs/bcachefs/btree_gc.c:736 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:800 [inline]
 bch2_check_allocations+0x149b/0x5870 fs/bcachefs/btree_gc.c:1099
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:487 [inline]
 __bch2_run_recovery_passes+0x3b7/0x1090 fs/bcachefs/recovery_passes.c:543
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:614
 bch2_fs_recovery+0x1af4/0x2c20 fs/bcachefs/recovery.c:813
 bch2_fs_start+0x97f/0xd10 fs/bcachefs/super.c:1405
 bch2_fs_get_tree+0xb35/0x1540 fs/bcachefs/fs.c:2446
 vfs_get_tree+0x92/0x2b0 fs/super.c:1752
 do_new_mount+0x2a2/0xa30 fs/namespace.c:3810
 do_mount fs/namespace.c:4138 [inline]
 __do_sys_mount fs/namespace.c:4349 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4326
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc56719038a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc8714bdf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc8714be80 RCX: 00007fc56719038a
RDX: 0000200000024c80 RSI: 0000200000000080 RDI: 00007ffc8714be40
RBP: 0000200000024c80 R08: 00007ffc8714be80 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000200000000080
R13: 00007ffc8714be40 R14: 0000000000024c6a R15: 0000200000000180
 </TASK>

Allocated by task 6037:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 poison_kmalloc_redzone mm/kasan/common.c:397 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:414
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __kmalloc_cache_noprof+0x21c/0x3a0 mm/slub.c:4396
 kmalloc_noprof include/linux/slab.h:909 [inline]
 bch2_journal_key_insert fs/bcachefs/btree_journal_iter.c:360 [inline]
 bch2_journal_key_delete+0xff/0x230 fs/bcachefs/btree_journal_iter.c:379
 bch2_btree_repair_topology_recurse+0xeb2/0x5070 fs/bcachefs/btree_gc.c:379
 bch2_check_topology+0x1059/0x19f0 fs/bcachefs/btree_gc.c:614
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:487 [inline]
 __bch2_run_recovery_passes+0x3b7/0x1090 fs/bcachefs/recovery_passes.c:543
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:614
 bch2_fs_recovery+0x1af4/0x2c20 fs/bcachefs/recovery.c:813
 bch2_fs_start+0x97f/0xd10 fs/bcachefs/super.c:1405
 bch2_fs_get_tree+0xb35/0x1540 fs/bcachefs/fs.c:2446
 vfs_get_tree+0x92/0x2b0 fs/super.c:1752
 do_new_mount+0x2a2/0xa30 fs/namespace.c:3810
 do_mount fs/namespace.c:4138 [inline]
 __do_sys_mount fs/namespace.c:4349 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4326
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6037:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2417 [inline]
 slab_free mm/slub.c:4680 [inline]
 kfree+0x18e/0x440 mm/slub.c:4879
 bch2_journal_key_insert_take+0x160e/0x1af0 fs/bcachefs/btree_journal_iter.c:300
 set_node_max+0x3f7/0x680 fs/bcachefs/btree_gc.c:172
 btree_repair_node_end fs/bcachefs/btree_gc.c:329 [inline]
 bch2_btree_repair_topology_recurse+0x3942/0x5070 fs/bcachefs/btree_gc.c:447
 bch2_check_topology+0x1059/0x19f0 fs/bcachefs/btree_gc.c:614
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:487 [inline]
 __bch2_run_recovery_passes+0x3b7/0x1090 fs/bcachefs/recovery_passes.c:543
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:614
 bch2_fs_recovery+0x1af4/0x2c20 fs/bcachefs/recovery.c:813
 bch2_fs_start+0x97f/0xd10 fs/bcachefs/super.c:1405
 bch2_fs_get_tree+0xb35/0x1540 fs/bcachefs/fs.c:2446
 vfs_get_tree+0x92/0x2b0 fs/super.c:1752
 do_new_mount+0x2a2/0xa30 fs/namespace.c:3810
 do_mount fs/namespace.c:4138 [inline]
 __do_sys_mount fs/namespace.c:4349 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4326
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88802f05fe80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 20 bytes inside of
 freed 64-byte region [ffff88802f05fe80, ffff88802f05fec0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2f05f
anon flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88801a8418c0 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 11474234050, free_ts 11427462095
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x330 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbd1/0x13e0 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 __kmalloc_cache_noprof+0x282/0x3a0 mm/slub.c:4391
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1043 [inline]
 snd_device_new+0x7b/0x320 sound/core/device.c:37
 snd_timer_new+0x516/0x6d0 sound/core/timer.c:953
 snd_pcm_timer_init+0x162/0x3e0 sound/core/pcm_timer.c:108
 snd_pcm_dev_register+0x6be/0x920 sound/core/pcm.c:1080
 __snd_device_register sound/core/device.c:149 [inline]
 snd_device_register_all+0xd0/0x1b0 sound/core/device.c:197
 snd_card_register+0x1cf/0x760 sound/core/init.c:893
 loopback_probe+0xe27/0x1420 sound/drivers/aloop.c:1831
 platform_probe+0xf6/0x190 drivers/base/platform.c:1405
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x26d/0x9e0 drivers/base/dd.c:659
page last free pid 43 tgid 43 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 vfree+0x25a/0x400 mm/vmalloc.c:3434
 delayed_vfree_work+0x55/0x80 mm/vmalloc.c:3353
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x47c/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88802f05fd80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88802f05fe00: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
>ffff88802f05fe80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                         ^
 ffff88802f05ff00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88802f05ff80: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
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
