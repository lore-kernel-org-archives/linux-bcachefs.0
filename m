Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D06322B
	for <linux-bcachefs@vger.kernel.org>; Sat,  8 Mar 2025 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741392085; cv=none; b=PUE3vBSdpPwTVM2dqWvcL30u4Gz54Wk+T1JoWATB9L+KEprMgcF7obwx9shrwpPM332IpdXMFaHY/Eu6YfO0bHVEAhIKL9Ie3YuOS3O+86j/ZVniwCpjGqt416ADOt9MjqP21yWaf9N4Yp/MA0zJ1fUZC3dxdS4+JcrBheMtNA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741392085; c=relaxed/simple;
	bh=N0eKSeVL7+VRhfKRNDp0NxLIQwmlrCDDLmB0QxzSMug=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZUMcO9YZpMYXuZiI4HMUiUdDSRXID1p4skB78fwvGn/2VMFsZ9SzDu5SWs5rIfYT0QDQbOIclm+zK9pbGCsMH/s8HwN4TgRGFr8D5uMiEmHq6tpOS5sl/MYWRWuO7SSTaOTYB9RMn4Oto9eyWkRfCRly9D5zEB5zQBRCOTiAY1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-85afdc0c74cso210884539f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 07 Mar 2025 16:01:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741392082; x=1741996882;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zeqWouS+SSFmOzj0vligAq58jwoQW/v1su47nD9czv8=;
        b=agnTRUWnG6m6SrRsN/fJsxx+XnWuVMKK8yXI64SuKODg3mNesQVV96bIP2uwvAf9Ke
         dXgiS5ozEnrVLOQ45+2LWI1o38RRA9bl/uiBwpquLDGXJeVaTCpV3JT5NCXYlVz3Lx8g
         lv8/XOu26CkLvMU5THg3sV9AWgSOLFFkWex9U9n8HEviwWAZxOYy3WLlYkP2xN8D6IZk
         Co6figTbIMRKjpjy51iVwkr2Qa5eVfDLc/HlEw7MTraQP89ogb9M3+H0FPkQMcPIL+u0
         RRyiT+wXETI+9mJ4afVtZpRJ6/sAyokZg//New/meC01EWoxriH3TickEHju+tjvMP50
         oAOg==
X-Forwarded-Encrypted: i=1; AJvYcCUwDw3ugHVElISEcyL73XhLLfplA09vkIFPhmiHhgOYbMwZJCT8eNSSncTzBOyouPPTz4jmpg9/cQ9pWrrUqw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0dlnF7iIrt37jZa45oFHLwJJMFpXwsfvMIF1JESREMWNcU5OW
	IE8Teu0GT5aMLfVsVBTKHjySmBMGWboUcXjjv8/gk6dcwCuIzjPr25CgDCtDW2UWPZmsgqlnl7v
	7K1m3z6j6wwlmJtKrdYDr78eLyibUmdanbTvfvs1LHPL/jv1I2toCu3o=
X-Google-Smtp-Source: AGHT+IE2RVxAN/LY5wy/Gi9Cg3zFZnJxLg+/g/jvJkGvV7nk6cVSFYhEwL0YOUHJDLjNEV8tUI9rU044HUQ7z4Y8tCdCJAizeq6H
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a83:b0:3d3:f27a:9103 with SMTP id
 e9e14a558f8ab-3d44197137fmr69704715ab.1.1741392081681; Fri, 07 Mar 2025
 16:01:21 -0800 (PST)
Date: Fri, 07 Mar 2025 16:01:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67cb88d1.050a0220.d8275.022c.GAE@google.com>
Subject: [syzbot] [net?] [bcachefs?] KASAN: slab-use-after-free Read in
 ip_skb_dst_mtu (2)
From: syzbot <syzbot+98d6cedbab2dd7eaa17e@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, kent.overstreet@linux.dev, kuba@kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    03d38806a902 Merge tag 'thermal-6.14-rc5' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15952864580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8de9cc84d5960254
dashboard link: https://syzkaller.appspot.com/bug?extid=98d6cedbab2dd7eaa17e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17952864580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/3a7779436438/disk-03d38806.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d7e23add8bc8/vmlinux-03d38806.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b718ff622c01/bzImage-03d38806.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/5b20d0f140ec/mount_0.gz

The issue was bisected to:

commit 14152654805256d760315ec24e414363bfa19a06
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Mon Nov 25 05:21:27 2024 +0000

    bcachefs: Bad btree roots are now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13c464b7980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=102464b7980000
console output: https://syzkaller.appspot.com/x/log.txt?x=17c464b7980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+98d6cedbab2dd7eaa17e@syzkaller.appspotmail.com
Fixes: 141526548052 ("bcachefs: Bad btree roots are now autofix")

==================================================================
BUG: KASAN: slab-use-after-free in sk_fullsock include/net/sock.h:2787 [inline]
BUG: KASAN: slab-use-after-free in ip_skb_dst_mtu+0xa42/0xbc0 include/net/ip.h:515
Read of size 1 at addr ffff88805fe4154a by task kworker/1:2/975

CPU: 1 UID: 0 PID: 975 Comm: kworker/1:2 Not tainted 6.14.0-rc4-syzkaller-00248-g03d38806a902 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Workqueue: mld mld_dad_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0x16e/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 sk_fullsock include/net/sock.h:2787 [inline]
 ip_skb_dst_mtu+0xa42/0xbc0 include/net/ip.h:515
 __ip_finish_output+0x12b/0x400 net/ipv4/ip_output.c:307
 iptunnel_xmit+0x55d/0x9b0 net/ipv4/ip_tunnel_core.c:82
 udp_tunnel_xmit_skb+0x262/0x3b0 net/ipv4/udp_tunnel_core.c:173
 geneve_xmit_skb drivers/net/geneve.c:916 [inline]
 geneve_xmit+0x210e/0x2bf0 drivers/net/geneve.c:1039
 __netdev_start_xmit include/linux/netdevice.h:5151 [inline]
 netdev_start_xmit include/linux/netdevice.h:5160 [inline]
 xmit_one net/core/dev.c:3800 [inline]
 dev_hard_start_xmit+0x27a/0x7d0 net/core/dev.c:3816
 __dev_queue_xmit+0x1b73/0x3f50 net/core/dev.c:4649
 dev_queue_xmit include/linux/netdevice.h:3313 [inline]
 neigh_hh_output include/net/neighbour.h:523 [inline]
 neigh_output include/net/neighbour.h:537 [inline]
 ip6_finish_output2+0x127d/0x17c0 net/ipv6/ip6_output.c:141
 ip6_finish_output+0x41e/0x840 net/ipv6/ip6_output.c:226
 NF_HOOK+0x9e/0x430 include/linux/netfilter.h:314
 mld_sendpack+0x843/0xdb0 net/ipv6/mcast.c:1868
 mld_dad_work+0x44/0x500 net/ipv6/mcast.c:2308
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Last potentially related work creation:
------------[ cut here ]------------
pool index 54431 out of bounds (772) for stack id 8c38d4a0
WARNING: CPU: 1 PID: 975 at lib/stackdepot.c:452 depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
Modules linked in:
CPU: 1 UID: 0 PID: 975 Comm: kworker/1:2 Not tainted 6.14.0-rc4-syzkaller-00248-g03d38806a902 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
Workqueue: mld mld_dad_work
RIP: 0010:depot_fetch_stack+0x86/0xc0 lib/stackdepot.c:451
Code: 83 7c 18 1c 00 74 38 48 01 d8 eb 24 90 0f 0b 90 44 39 f5 72 ca 90 48 c7 c7 6e af 39 8e 89 ee 44 89 f2 89 d9 e8 fb be 5b fc 90 <0f> 0b 90 90 31 c0 5b 41 5e 5d c3 cc cc cc cc 90 0f 0b 90 eb ef 90
RSP: 0018:ffffc90003836d28 EFLAGS: 00010046
RAX: eec25f5fb9356300 RBX: 000000008c38d4a0 RCX: ffff888026575a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 000000000000d49f R08: ffffffff81817d42 R09: 1ffff110170e519a
R10: dffffc0000000000 R11: ffffed10170e519b R12: ffff88805fe4154a
R13: ffffea00017f9000 R14: 0000000000000304 R15: ffffc90003836df8
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f086af09000 CR3: 00000000798e8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 stack_depot_fetch lib/stackdepot.c:714 [inline]
 stack_depot_print+0x16/0x50 lib/stackdepot.c:752
 kasan_print_aux_stacks+0x38/0x70 mm/kasan/report_generic.c:199
 describe_object_stacks mm/kasan/report.c:347 [inline]
 describe_object mm/kasan/report.c:353 [inline]
 print_address_description mm/kasan/report.c:412 [inline]
 print_report+0x22b/0x5b0 mm/kasan/report.c:521
 kasan_report+0x143/0x180 mm/kasan/report.c:634
 sk_fullsock include/net/sock.h:2787 [inline]
 ip_skb_dst_mtu+0xa42/0xbc0 include/net/ip.h:515
 __ip_finish_output+0x12b/0x400 net/ipv4/ip_output.c:307
 iptunnel_xmit+0x55d/0x9b0 net/ipv4/ip_tunnel_core.c:82
 udp_tunnel_xmit_skb+0x262/0x3b0 net/ipv4/udp_tunnel_core.c:173
 geneve_xmit_skb drivers/net/geneve.c:916 [inline]
 geneve_xmit+0x210e/0x2bf0 drivers/net/geneve.c:1039
 __netdev_start_xmit include/linux/netdevice.h:5151 [inline]
 netdev_start_xmit include/linux/netdevice.h:5160 [inline]
 xmit_one net/core/dev.c:3800 [inline]
 dev_hard_start_xmit+0x27a/0x7d0 net/core/dev.c:3816
 __dev_queue_xmit+0x1b73/0x3f50 net/core/dev.c:4649
 dev_queue_xmit include/linux/netdevice.h:3313 [inline]
 neigh_hh_output include/net/neighbour.h:523 [inline]
 neigh_output include/net/neighbour.h:537 [inline]
 ip6_finish_output2+0x127d/0x17c0 net/ipv6/ip6_output.c:141
 ip6_finish_output+0x41e/0x840 net/ipv6/ip6_output.c:226
 NF_HOOK+0x9e/0x430 include/linux/netfilter.h:314
 mld_sendpack+0x843/0xdb0 net/ipv6/mcast.c:1868
 mld_dad_work+0x44/0x500 net/ipv6/mcast.c:2308
 process_one_work kernel/workqueue.c:3238 [inline]
 process_scheduled_works+0xabe/0x18e0 kernel/workqueue.c:3319
 worker_thread+0x870/0xd30 kernel/workqueue.c:3400
 kthread+0x7a9/0x920 kernel/kthread.c:464
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


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
