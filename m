Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F531B6CE6
	for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 10:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732617813; cv=none; b=TOZj3Tkf4G9bNm7lFOehVhg79X21wJc1CV6RtfNOOqzBVMgMq/6h+OBAizqrZekLwuf0UTU6CrqXl/o/Fx3KkErOZh0KWiuz8C9EcNCd8yJtZPuEJS9FwwaHVKp2zd5b5GO7o+qqC/fUD4TJwSgq8e3NidVd1wzff/+JIhrk4g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732617813; c=relaxed/simple;
	bh=wVal2/JBh+2+jvhftVXEPeEiXtKCo7oBuAe1TCsTt88=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=sT9LcxrMt8RY3VKo3ntMTKQGj3ylhgiI6sSnUvEytLn1uEaZvTKbKhWHp1vi5TJ5XiDfHav7dEat3gmrShS8pmyniXyx1g9a5Sem9wLNv+ub1sn62+bTDqg21BIj/PeCfzFxVcl8lPzxpdMJi/lSqGG6dPJrppC5oklTyz3FHro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a77de12c48so62118765ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 26 Nov 2024 02:43:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732617811; x=1733222611;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3xO2qtPyD5V1sgtd96WBcoTgbs6KVHK91cFWPJuXbqE=;
        b=UrRyXLfncm8cIocGtY+IAodstKamdORQKivLaidWiGdIhKpVjTy1kgBiXFsNm4hKKB
         HY54DIxI4Fls+qavlT5CHAHb3y3pvRs/T6obFZeT/lqq9YKaNufO9YqVKRvEgS9SHZGC
         Cx8CaY1TLSi0HOK+T8FQx4rIucOHC5PO7086eSwkxZw7iPufmPHSPatGF249g7ChMImu
         4ohGiqmWhhEHapB/NJoZ8xmjFbGH9DUUJmHKRDCVzxh/wpGxIPeN/Ddhj6jiB7X86UN0
         cZwOzhHjqRXIier2XmlnQne+uFL0UbK11L+YGHjgSU3NxnpFWrHNZbcsekqLOhlT6jCJ
         LngA==
X-Forwarded-Encrypted: i=1; AJvYcCXVC3G8NHvYY7dr39SF11bBwXn+/AmX+lw6KAcqeW8ISHfTMm2XqYHQA/TbqaW+o9iapnPX6tfgopidYei1ig==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKnbYp5tYFfxHWBzWHmoNiI36yAAledoGIvvBULk7pP080BUuS
	aSuWDWDGqoy01RPGBe7TSA/6oWqdzKnz+kYnNKQxH86DqHndQcgzqk3Ny1FgaosdNaqfY79aJfp
	yIQQqIgdz2Zwj7pWqwko5UX7cdkFNvkNzFSpLGcedMGHu3aum4yWi5XI=
X-Google-Smtp-Source: AGHT+IGFul8Wo8ubw6UXrhJH8Wlzuo5NY0YTINlj27fntWKxJjvP+60JHt9+5NEDtqxwnyFR0B1vP9IX4ZlXO6C7ysw/OwuL6fRS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:3a7:159d:2dd8 with SMTP id
 e9e14a558f8ab-3a79ad14e4fmr158548895ab.7.1732617811175; Tue, 26 Nov 2024
 02:43:31 -0800 (PST)
Date: Tue, 26 Nov 2024 02:43:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6745a653.050a0220.21d33d.0015.GAE@google.com>
Subject: [syzbot] [kernfs?] [bcachefs?] KASAN: slab-out-of-bounds Read in __radix_tree_delete
From: syzbot <syzbot+514c0f4636fc31faffdf@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    28eb75e178d3 Merge tag 'drm-next-2024-11-21' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17255b78580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=402159daa216c89d
dashboard link: https://syzkaller.appspot.com/bug?extid=514c0f4636fc31faffdf
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1351d7f7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e3c9c97af7d9/disk-28eb75e1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1e22f3d29103/vmlinux-28eb75e1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8ff56ec30fa6/bzImage-28eb75e1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/0d52bc32c4b6/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+514c0f4636fc31faffdf@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-out-of-bounds in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-out-of-bounds in tag_get lib/radix-tree.c:115 [inline]
BUG: KASAN: slab-out-of-bounds in node_tag_set lib/radix-tree.c:943 [inline]
BUG: KASAN: slab-out-of-bounds in __radix_tree_delete+0x10d/0x3a0 lib/radix-tree.c:1373
Read of size 8 at addr ffff8880609e56d8 by task syz-executor/7046

CPU: 1 UID: 0 PID: 7046 Comm: syz-executor Not tainted 6.12.0-syzkaller-07749-g28eb75e178d3 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 tag_get lib/radix-tree.c:115 [inline]
 node_tag_set lib/radix-tree.c:943 [inline]
 __radix_tree_delete+0x10d/0x3a0 lib/radix-tree.c:1373
 radix_tree_delete_item+0x2e0/0x3f0 lib/radix-tree.c:1430
 kernfs_put+0x1ba/0x370 fs/kernfs/dir.c:575
 kernfs_remove_by_name_ns+0xe4/0x160 fs/kernfs/dir.c:1695
 kernfs_remove_by_name include/linux/kernfs.h:625 [inline]
 remove_files fs/sysfs/group.c:28 [inline]
 sysfs_remove_group+0xfe/0x2c0 fs/sysfs/group.c:319
 sysfs_remove_groups+0x54/0xb0 fs/sysfs/group.c:343
 __kobject_del+0x84/0x310 lib/kobject.c:595
 kobject_cleanup lib/kobject.c:680 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x245/0x480 lib/kobject.c:737
 netdev_queue_update_kobjects+0x4c3/0x550 net/core/net-sysfs.c:1857
 netif_set_real_num_tx_queues+0x18a/0x910 net/core/dev.c:2944
 veth_init_queues drivers/net/veth.c:1756 [inline]
 veth_newlink+0x91c/0xc10 drivers/net/veth.c:1868
 rtnl_newlink_create+0x2df/0xa30 net/core/rtnetlink.c:3774
 __rtnl_newlink net/core/rtnetlink.c:3891 [inline]
 rtnl_newlink+0x17dd/0x24f0 net/core/rtnetlink.c:4001
 rtnetlink_rcv_msg+0x791/0xcf0 net/core/rtnetlink.c:6911
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2541
 netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1347
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:726
 __sys_sendto+0x363/0x4c0 net/socket.c:2197
 __do_sys_sendto net/socket.c:2204 [inline]
 __se_sys_sendto net/socket.c:2200 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2200
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f748b9806ac
Code: 2a 5a 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5a 02 00 48 8b
RSP: 002b:00007ffdccfc5420 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f748c664620 RCX: 00007f748b9806ac
RDX: 0000000000000068 RSI: 00007f748c664670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffdccfc5474 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f748c664670 R15: 0000000000000000
 </TASK>

Allocated by task 35:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __do_kmalloc_node mm/slub.c:4264 [inline]
 __kmalloc_node_noprof+0x22a/0x440 mm/slub.c:4270
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:658
 alloc_netdev_mqs+0xa4/0x1080 net/core/dev.c:11203
 nsim_create+0x7c/0x890 drivers/net/netdevsim/netdev.c:777
 __nsim_dev_port_add+0x6c0/0xae0 drivers/net/netdevsim/dev.c:1393
 nsim_dev_port_add_all drivers/net/netdevsim/dev.c:1449 [inline]
 nsim_dev_reload_create drivers/net/netdevsim/dev.c:1501 [inline]
 nsim_dev_reload_up+0x69b/0x8e0 drivers/net/netdevsim/dev.c:988
 devlink_reload+0x478/0x870 net/devlink/dev.c:474
 devlink_pernet_pre_exit+0x1f3/0x440 net/devlink/core.c:509
 ops_pre_exit_list net/core/net_namespace.c:162 [inline]
 cleanup_net+0x615/0xcc0 net/core/net_namespace.c:612
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

The buggy address belongs to the object at ffff8880609e4000
 which belongs to the cache kmalloc-cg-8k of size 8192
The buggy address is located 288 bytes to the right of
 allocated 5560-byte region [ffff8880609e4000, ffff8880609e55b8)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x609e0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88803492aaa1
ksm flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801ac4f640 ffffea0001632200 0000000000000003
raw: 0000000000000000 0000000000020002 00000001f5000000 ffff88803492aaa1
head: 00fff00000000040 ffff88801ac4f640 ffffea0001632200 0000000000000003
head: 0000000000000000 0000000000020002 00000001f5000000 ffff88803492aaa1
head: 00fff00000000003 ffffea0001827801 ffffffffffffffff 0000000000000000
head: 0000000000000008 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd60c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5932, tgid 5932 (syz-executor), ts 73744579398, free_ts 70910848455
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1556
 prep_new_page mm/page_alloc.c:1564 [inline]
 get_page_from_freelist+0x363e/0x3790 mm/page_alloc.c:3474
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4751
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x140 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_node_noprof+0x286/0x440 mm/slub.c:4270
 __kvmalloc_node_noprof+0x72/0x190 mm/util.c:658
 alloc_netdev_mqs+0xa4/0x1080 net/core/dev.c:11203
 nsim_create+0x7c/0x890 drivers/net/netdevsim/netdev.c:777
 __nsim_dev_port_add+0x6c0/0xae0 drivers/net/netdevsim/dev.c:1393
 nsim_dev_port_add_all+0x33/0xf0 drivers/net/netdevsim/dev.c:1449
 nsim_drv_probe+0x85f/0xb80 drivers/net/netdevsim/dev.c:1607
 really_probe+0x2b8/0xad0 drivers/base/dd.c:658
page last free pid 5897 tgid 5897 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xded/0x1130 mm/page_alloc.c:2657
 vfree+0x186/0x2e0 mm/vmalloc.c:3361
 kcov_put kernel/kcov.c:439 [inline]
 kcov_close+0x28/0x50 kernel/kcov.c:535
 __fput+0x23c/0xa50 fs/file_table.c:450
 task_work_run+0x24f/0x310 kernel/task_work.c:239
 exit_task_work include/linux/task_work.h:43 [inline]
 do_exit+0xa2f/0x28e0 kernel/exit.c:938
 do_group_exit+0x207/0x2c0 kernel/exit.c:1087
 get_signal+0x16b2/0x1750 kernel/signal.c:3016
 arch_do_signal_or_restart+0x96/0x860 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xce/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff8880609e5580: 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc
 ffff8880609e5600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8880609e5680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                    ^
 ffff8880609e5700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8880609e5780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
