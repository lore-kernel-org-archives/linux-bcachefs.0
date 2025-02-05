Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA93227BAB
	for <linux-bcachefs@vger.kernel.org>; Wed,  5 Feb 2025 00:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716984; cv=none; b=QULRKNerQnarnl5VayzcRyHdPZ232iiO90Egu6HR1fXdgLVcFuXpQhvLSt9FV7NTzEntYphfpekYBlRDCZwXM05g7mrMnEfCXWIQK/ZQJngo65MIQF/w7qRIznNZ3e8qZxQ0MsEJGieqDfXs7su66B/dRMu8tDtcOHn/nIsmeZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716984; c=relaxed/simple;
	bh=EBrWifbanb0zc7pvQ3Kv7DlRRrhDIFrvcaH/WW27vrw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OMc24gbfkx6rLr/XlIlngktJCoXJ5Cn1+84XMmAKBrHc6i1awzOUria0cBjBY/+2/mM21rai0f2y/4aGeTGGBnNkAqlfT8W5D03nTU+q2KT13J+6Ixl4Uc50detGszEOTncmKRFKNQBazzcYoWO7F/q6EbFS3/DPz2xUqCppe3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a814bfb77bso3413175ab.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Feb 2025 16:56:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738716981; x=1739321781;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WT/8rt6aNwDyzyNN8ZEeHlZbNcUqHd4pkLgsMoyF++E=;
        b=bfvAME1hXUv5YAVerkeNVcSyV6XndKrugLre/fG7V3PIZvK0N8CAhsj4YQijX4UEye
         vXWyRb6UzXDE2BUIztahW0G7xLjkIbMHzKw/sxMwrz1fAD/vIxIIeCMyI2qxzycfmgPs
         5bbjM5IKvlf/9H+s5R6IbfDotiMMkwYw+wLIDsrtcIKncceO0CrNcBXf0uUA9hrex5Dm
         ZYxluR8NRNUiqT4pkoIoIeS8xgrI3xjXhBbMHoLVzgRfexjwilODo5omkSMvvb7VWRxv
         efJaSQTuOk+p8CiEqyIQgPjBtA5N/MADwzNlu9JC6/OEDzDnCm/YF+XC6IH3gmWC55DF
         Pnaw==
X-Forwarded-Encrypted: i=1; AJvYcCWRSfaTdvrhORaRmaHm69leTrtjgQFYZ+AI2+2164peurD6zvNYwDIznNkQR52T9LI7S+A9+sL94OjoOVssrA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr/L+/ojH8vo5GA1tmFOzzqvZ7Px/jEik1wYOV6U4ll0UYtqdb
	hr92knTRon5vYGYk49O7zyHq6plsEhU+PTZK0dVlxAQ9adu0mImLGQ+VFiMMGiha5lbs3zxGy6S
	yp7uBeNLk8BW5DpZ+vxKJ7xmSQcaMCqIrkyy+YFg5IJoQ7kK4POVULbA=
X-Google-Smtp-Source: AGHT+IFYipUdm09vPq/WGzwoQ6GyJRX5tdfolbVS2nwUQW3DxbvgvX2zapDRKz646jquYjNjpbZext2NbbA9TuSuaR8J2pJ1LXyZ
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca3:b0:3cf:ba90:6ad9 with SMTP id
 e9e14a558f8ab-3d04f97651cmr8076805ab.9.1738716981658; Tue, 04 Feb 2025
 16:56:21 -0800 (PST)
Date: Tue, 04 Feb 2025 16:56:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a2b735.050a0220.50516.0004.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: corrupted list in new_inode
From: syzbot <syzbot+2dabb3dce04e28763712@syzkaller.appspotmail.com>
To: dakr@kernel.org, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    0de63bb7d919 Merge tag 'pull-fix' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10f023df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=2dabb3dce04e28763712
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f03724580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d96aac16c63b/disk-0de63bb7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cec7aa6a6ed3/vmlinux-0de63bb7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8601bc76fa6b/bzImage-0de63bb7.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/492e4b80ab1e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2dabb3dce04e28763712@syzkaller.appspotmail.com

 slab debugfs_inode_cache start ffff88805b66d978 pointer offset 448 size 1176
list_add corruption. next->prev should be prev (ffff8881422a49c0), but was ffffffff9a43e100. (next=ffff88805b66db38).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:31!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5946 Comm: syz-executor Not tainted 6.14.0-rc1-syzkaller-00020-g0de63bb7d919 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:__list_add_valid_or_report+0xf3/0x130 lib/list_debug.c:29
Code: 13 1b fd 42 80 7c 2d 00 00 74 08 48 89 df e8 14 52 3c fd 49 8b 56 08 48 c7 c7 c0 b7 5f 8c 4c 89 e6 4c 89 f1 e8 1e e3 3f fc 90 <0f> 0b 4c 89 e7 e8 f3 12 1b fd 42 80 3c 2b 00 74 08 4c 89 e7 e8 e4
RSP: 0018:ffffc90003c46d98 EFLAGS: 00010246
RAX: 0000000000000075 RBX: ffff88805b66db40 RCX: 2a333a4c251a8c00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: 1ffff1100b6cdb68 R08: ffffffff819f140c R09: 1ffff110170e519a
R10: dffffc0000000000 R11: ffffed10170e519b R12: ffff8881422a49c0
R13: dffffc0000000000 R14: ffff88805b66db38 R15: ffff88805b66e050
FS:  000055555cae1500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c008a79000 CR3: 0000000027990000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_add_valid include/linux/list.h:88 [inline]
 __list_add include/linux/list.h:150 [inline]
 list_add include/linux/list.h:169 [inline]
 inode_sb_list_add fs/inode.c:617 [inline]
 new_inode+0xc7/0x1d0 fs/inode.c:1195
 debugfs_get_inode fs/debugfs/inode.c:72 [inline]
 debugfs_create_dir+0xf6/0x430 fs/debugfs/inode.c:597
 wiphy_register+0x1b8f/0x27b0 net/wireless/core.c:1015
 ieee80211_register_hw+0x354e/0x4240 net/mac80211/main.c:1587
 mac80211_hwsim_new_radio+0x2a9f/0x4aa0 drivers/net/wireless/virtual/mac80211_hwsim.c:5558
 hwsim_new_radio_nl+0xece/0x2290 drivers/net/wireless/virtual/mac80211_hwsim.c:6242
 genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0xb14/0xec0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2543
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1322 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1348
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:713 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:728
 __sys_sendto+0x363/0x4c0 net/socket.c:2182
 __do_sys_sendto net/socket.c:2189 [inline]
 __se_sys_sendto net/socket.c:2185 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2185
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f33d418ec3c
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffc9ca207b0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f33d4ed4620 RCX: 00007f33d418ec3c
RDX: 0000000000000024 RSI: 00007f33d4ed4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffc9ca20804 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f33d4ed4670 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid_or_report+0xf3/0x130 lib/list_debug.c:29
Code: 13 1b fd 42 80 7c 2d 00 00 74 08 48 89 df e8 14 52 3c fd 49 8b 56 08 48 c7 c7 c0 b7 5f 8c 4c 89 e6 4c 89 f1 e8 1e e3 3f fc 90 <0f> 0b 4c 89 e7 e8 f3 12 1b fd 42 80 3c 2b 00 74 08 4c 89 e7 e8 e4
RSP: 0018:ffffc90003c46d98 EFLAGS: 00010246
RAX: 0000000000000075 RBX: ffff88805b66db40 RCX: 2a333a4c251a8c00
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: 1ffff1100b6cdb68 R08: ffffffff819f140c R09: 1ffff110170e519a
R10: dffffc0000000000 R11: ffffed10170e519b R12: ffff8881422a49c0
R13: dffffc0000000000 R14: ffff88805b66db38 R15: ffff88805b66e050
FS:  000055555cae1500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c008a79000 CR3: 0000000027990000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
