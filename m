Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583019476
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 May 2024 03:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715916684; cv=none; b=FbgYIf1MPEF3XNcmG1bf3ec9PorPU9i1h1ncoyCjNnxWlr3sLHqcn5zrAEEbqphbxhKIcZ/amhtkNUEV7LRnFM1P4l7TvO/M6xts5RSTqm6a56xtquhh+5FTskS0NcW6wqzVwWBplyVA6knbgnyBK+4bb3CTf0uTh8ddZR/py0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715916684; c=relaxed/simple;
	bh=gszQPP2asI7eG1PPZFawzTfoWFsA37Cx2w7yQy/hy+0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hYR9F6CVwA8nDkJs4UdTstAt9YceMXm0gzic4RA208dl5ZkyQois7YkgwOaNMXHGjUPeP424VRccMpVfacofM8rISzg/aBpY+bhBThgA5F2YSJDIZ40+0IjtrozaRCfYUdP6/mjCIhESiOzMm/3owFgRu9a9SW20J0VaKmIJD04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-7e1de4c052aso626509839f.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 May 2024 20:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715916681; x=1716521481;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lpu0/ayHNk1BahfE9GqfxH6tVNC5djPsGN5d+BK+glQ=;
        b=e5tdR7OsobqZiV41yIi+8kADyEqocDGCu5ygcBLnl8zdxQQ3yrz794ISkNsfonBCRz
         rYYtIZ9zaWq8mMcYkXM/Y0qlKBKdnHmugLBlrlDV0vxHAZ9LAqtdude3M0fFdx91/CgU
         eY4DuLyAN8meRBwYs4fWVsMcFfRnGbFW0KI0nxxP8URRSuhiQxU7xBhidCGY7O8+X87j
         1Bgu+s5cDwVaytd7QFP6jttO6UwIdXKkVP0CzXPtdMEsvkZBNBJj2z/yba0fkaSoWn3a
         G2xWDXM0UbpeBBpJi/lSQLe31jsn62NGle9PGpMgt7mksL6kNMK79LRtZur+33Kqjobr
         YAjg==
X-Forwarded-Encrypted: i=1; AJvYcCWu8SNrPjI2CEfo/tbt6kXMyaTWDcYwBun2n3YpSFxcXV8hCm1Vg+Llod94XgWTk2iJ/UAdlXjCDALtBelfNZK0wxrjy/39ERFj9fO0tm4=
X-Gm-Message-State: AOJu0Yx8sOjEtFPIzQ7S1kNjsrVftZAUIASHI7XwquoOnbFtlz/tmQ/0
	AmsfA7gRa7NPoRjvlnN3DA+IFb5s4ayp7WptZZJHSaCXjwmR07m6ZO2vpF7/w3IxBHaAO4+HznQ
	5wxSmpwglySf70kKvecpSgKjU6eooCsy5Mft6ij4szZrjDNlibeRpwJE=
X-Google-Smtp-Source: AGHT+IFODq7xkty2QGD9HooP32PxD0hVYNsYEeNYPBSrXLsCiYQq5YO9ihoNkNalxfc66cGsLT7QZQvixLMIKHdROIgOYtOQT5Mv
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2b8e:b0:7de:e16b:4b81 with SMTP id
 ca18e2360f4ac-7e1b5209a83mr172652439f.2.1715916681553; Thu, 16 May 2024
 20:31:21 -0700 (PDT)
Date: Thu, 16 May 2024 20:31:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044bbc206189dfce4@google.com>
Subject: [syzbot] [arm?] [crypto?] [bcachefs?] KASAN: slab-use-after-free Read
 in neon_poly1305_update
From: syzbot <syzbot+6d3021bf0c4cb4ffac17@syzkaller.appspotmail.com>
To: catalin.marinas@arm.com, davem@davemloft.net, herbert@gondor.apana.org.au, 
	kent.overstreet@linux.dev, linux-arm-kernel@lists.infradead.org, 
	linux-bcachefs@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fda5695d692c Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15d0f600980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95dc1de8407c7270
dashboard link: https://syzkaller.appspot.com/bug?extid=6d3021bf0c4cb4ffac17
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c834d0980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1776a07c980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/07f3214ff0d9/disk-fda5695d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70e2e2c864e8/vmlinux-fda5695d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b259942a16dc/Image-fda5695d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/aade2af8a508/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d3021bf0c4cb4ffac17@syzkaller.appspotmail.com

bcachefs (loop0): mounting version 1.7: mi_btree_bitmap opts=metadata_checksum=none,data_checksum=none,nojournal_transaction_names
bcachefs (loop0): recovering from clean shutdown, journal seq 10
==================================================================
BUG: KASAN: slab-use-after-free in neon_poly1305_do_update arch/arm64/crypto/poly1305-glue.c:107 [inline]
BUG: KASAN: slab-use-after-free in neon_poly1305_update+0x2e0/0xb34 arch/arm64/crypto/poly1305-glue.c:119
Read of size 8 at addr ffff0000dd021790 by task syz-executor319/6238

CPU: 0 PID: 6238 Comm: syz-executor319 Not tainted 6.9.0-rc7-syzkaller-gfda5695d692c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x198/0x538 mm/kasan/report.c:488
 kasan_report+0xd8/0x138 mm/kasan/report.c:601
 kasan_check_range+0x268/0x2a8 mm/kasan/generic.c:189
 __asan_memcpy+0x3c/0x84 mm/kasan/shadow.c:105
 neon_poly1305_do_update arch/arm64/crypto/poly1305-glue.c:107 [inline]
 neon_poly1305_update+0x2e0/0xb34 arch/arm64/crypto/poly1305-glue.c:119
 crypto_shash_update+0x90/0xa8 crypto/shash.c:70
 bch2_checksum+0x690/0x770 fs/bcachefs/checksum.c:228
 bch2_btree_node_read_done+0xccc/0x45f0 fs/bcachefs/btree_io.c:1096
 btree_node_read_work+0x4e8/0xe9c fs/bcachefs/btree_io.c:1324
 bch2_btree_node_read+0x210c/0x28e4 fs/bcachefs/btree_io.c:1709
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1748 [inline]
 bch2_btree_root_read+0x2a8/0x534 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x21c/0x730 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x2dac/0x4854 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1043
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2102
 bch2_mount+0x558/0xe10 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1779
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Allocated by task 6093:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_alloc_info+0x40/0x50 mm/kasan/generic.c:565
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x74/0x8c mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3798 [inline]
 slab_alloc_node mm/slub.c:3845 [inline]
 kmem_cache_alloc+0x1dc/0x3c0 mm/slub.c:3852
 skb_clone+0x1c8/0x330 net/core/skbuff.c:2063
 dev_queue_xmit_nit+0x360/0x9c0 net/core/dev.c:2264
 xmit_one net/core/dev.c:3527 [inline]
 dev_hard_start_xmit+0x12c/0x938 net/core/dev.c:3547
 sch_direct_xmit+0x244/0x57c net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3760 [inline]
 __dev_queue_xmit+0x148c/0x33fc net/core/dev.c:4307
 dev_queue_xmit include/linux/netdevice.h:3091 [inline]
 neigh_hh_output include/net/neighbour.h:526 [inline]
 neigh_output include/net/neighbour.h:540 [inline]
 ip_finish_output2+0xdd8/0x13b4 net/ipv4/ip_output.c:235
 __ip_finish_output+0x1b0/0x458
 ip_finish_output+0x44/0x2e4 net/ipv4/ip_output.c:323
 NF_HOOK_COND include/linux/netfilter.h:303 [inline]
 ip_output+0x1a8/0x21c net/ipv4/ip_output.c:433
 dst_output include/net/dst.h:450 [inline]
 ip_local_out net/ipv4/ip_output.c:129 [inline]
 __ip_queue_xmit+0xe10/0x1874 net/ipv4/ip_output.c:535
 ip_queue_xmit+0x5c/0x78 net/ipv4/ip_output.c:549
 __tcp_transmit_skb+0x1930/0x34a0 net/ipv4/tcp_output.c:1462
 tcp_transmit_skb net/ipv4/tcp_output.c:1480 [inline]
 tcp_write_xmit+0x11c0/0x4bac net/ipv4/tcp_output.c:2792
 __tcp_push_pending_frames+0x98/0x228 net/ipv4/tcp_output.c:2977
 tcp_push+0x454/0x694 net/ipv4/tcp.c:738
 tcp_sendmsg_locked+0x34dc/0x3d90 net/ipv4/tcp.c:1310
 tcp_sendmsg+0x40/0x64 net/ipv4/tcp.c:1342
 inet_sendmsg+0x15c/0x290 net/ipv4/af_inet.c:851
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 sock_write_iter+0x2d8/0x448 net/socket.c:1160
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x968/0xc3c fs/read_write.c:590
 ksys_write+0x15c/0x26c fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:652
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

Freed by task 6093:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x40/0x78 mm/kasan/common.c:68
 kasan_save_free_info+0x54/0x6c mm/kasan/generic.c:579
 poison_slab_object+0x124/0x18c mm/kasan/common.c:240
 __kasan_slab_free+0x3c/0x70 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2106 [inline]
 slab_free mm/slub.c:4280 [inline]
 kmem_cache_free+0x168/0x3f0 mm/slub.c:4344
 kfree_skbmem+0x15c/0x1ec
 __kfree_skb net/core/skbuff.c:1217 [inline]
 kfree_skb_reason+0x1cc/0x4a8 net/core/skbuff.c:1252
 packet_rcv+0x13c/0x1118 net/packet/af_packet.c:2230
 dev_queue_xmit_nit+0x88c/0x9c0 net/core/dev.c:2296
 xmit_one net/core/dev.c:3527 [inline]
 dev_hard_start_xmit+0x12c/0x938 net/core/dev.c:3547
 sch_direct_xmit+0x244/0x57c net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3760 [inline]
 __dev_queue_xmit+0x148c/0x33fc net/core/dev.c:4307
 dev_queue_xmit include/linux/netdevice.h:3091 [inline]
 neigh_hh_output include/net/neighbour.h:526 [inline]
 neigh_output include/net/neighbour.h:540 [inline]
 ip_finish_output2+0xdd8/0x13b4 net/ipv4/ip_output.c:235
 __ip_finish_output+0x1b0/0x458
 ip_finish_output+0x44/0x2e4 net/ipv4/ip_output.c:323
 NF_HOOK_COND include/linux/netfilter.h:303 [inline]
 ip_output+0x1a8/0x21c net/ipv4/ip_output.c:433
 dst_output include/net/dst.h:450 [inline]
 ip_local_out net/ipv4/ip_output.c:129 [inline]
 __ip_queue_xmit+0xe10/0x1874 net/ipv4/ip_output.c:535
 ip_queue_xmit+0x5c/0x78 net/ipv4/ip_output.c:549
 __tcp_transmit_skb+0x1930/0x34a0 net/ipv4/tcp_output.c:1462
 tcp_transmit_skb net/ipv4/tcp_output.c:1480 [inline]
 tcp_write_xmit+0x11c0/0x4bac net/ipv4/tcp_output.c:2792
 __tcp_push_pending_frames+0x98/0x228 net/ipv4/tcp_output.c:2977
 tcp_push+0x454/0x694 net/ipv4/tcp.c:738
 tcp_sendmsg_locked+0x34dc/0x3d90 net/ipv4/tcp.c:1310
 tcp_sendmsg+0x40/0x64 net/ipv4/tcp.c:1342
 inet_sendmsg+0x15c/0x290 net/ipv4/af_inet.c:851
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 sock_write_iter+0x2d8/0x448 net/socket.c:1160
 call_write_iter include/linux/fs.h:2110 [inline]
 new_sync_write fs/read_write.c:497 [inline]
 vfs_write+0x968/0xc3c fs/read_write.c:590
 ksys_write+0x15c/0x26c fs/read_write.c:643
 __do_sys_write fs/read_write.c:655 [inline]
 __se_sys_write fs/read_write.c:652 [inline]
 __arm64_sys_write+0x7c/0x90 fs/read_write.c:652
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598

The buggy address belongs to the object at ffff0000dd021780
 which belongs to the cache skbuff_head_cache of size 240
The buggy address is located 16 bytes inside of
 freed 240-byte region [ffff0000dd021780, ffff0000dd021870)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11d021
flags: 0x5ffc00000000800(slab|node=0|zone=2|lastcpupid=0x7ff)
page_type: 0xffffffff()
raw: 05ffc00000000800 ffff0000c1bc4780 dead000000000122 0000000000000000
raw: 0000000000000000 00000000000c000c 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000dd021680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff0000dd021700: fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc
>ffff0000dd021780: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                         ^
 ffff0000dd021800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff0000dd021880: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
==================================================================
bcachefs (loop0): error validating btree node on loop0 at btree lru level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq a11787a6b9c68820 written 16 min_key POS_MIN durability: 1 ptr: 0:28:0 gen 0
  node offset 8/16 bset u64s 49390: checksum error, type chacha20_poly1305_128: got 5e7d73dbe54d11175c32a6907d11332e should be 7ecf2f3506fda339523b45cdbfcbcdbd, shutting down
bcachefs (loop0): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop0): flagging btree lru lost data
error reading btree root lru l=0: btree_node_read_error, shutting down
bcachefs (loop0): bch2_fs_recovery(): error fsck_errors_not_fixed
bcachefs (loop0): bch2_fs_start(): error starting filesystem fsck_errors_not_fixed
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete


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
