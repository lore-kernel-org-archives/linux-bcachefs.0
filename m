Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E7C18DF60
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 08:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739779461; cv=none; b=WHEX4V4WegeaKOmCtQx9YjzR1UObfxrITuhRZ+CpQsrONGxFx8OchnZaut6PWTk9R0vBp+FJAxoc6iLii4hday3VaZMJSUiBwOkPEZMldk1zIw6n6MMF5qtd70MJ1v5OlkueOJzmAdbB8TuezRWMEr/yZFPo5YJ7UTFdfECIDIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739779461; c=relaxed/simple;
	bh=v5qa6EXa3AkMnte+yhdeeG8IN5mrAAkic6DLZsC/w9c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JMZB8AzbvH8Xpeo8mjMjkRA3WFvFQr96O75mHfkPyRO4OiicRLqnAWk32EUo1/yVNiQWi0yNKiHsWnzir2i/aXNdBj3EcjUf6DXS5xgwQjnXwOvoK2iIpe06JDDBWSA300ErHPeSeE9UXJQkcWMX9NT4Xq5EMbYKyVmdJgGffIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3d18a1a0f0eso82444295ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Feb 2025 00:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739779458; x=1740384258;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=24t5/djZSZfcZjD8u1O2QysKNhx5mUob/NH/sHlKHu8=;
        b=Z7AmQAYZnM1HubRkY+ysDjCt9Xa2R/YvCf1hA4AVz2K3WBgNYIwiyDbtkXaNINFuMl
         5dUCpj0gFbtMg2o5VVYKl2rISNgnMB8Sf4rkFpMR9KhLAjRtGO/GA0tAV90ivtyENsYt
         r4YwZukD2IqUt73MEuAByhRmnUR/qypvkimd+ocbTX9655BaTYJoiCYvdfqg0N2eGNXK
         PNLhzYdLw6McAR+WwjiYPr0owpHGXqlNtTTfTYt93eqvze8DpLZltQ/7jXGni2kM8ynG
         j7+onqkkaaJgWCc84pQOxt1IP23Nk6hyBaVIhY1ABNOYQ8WlRUlaZ/vLe7w1DtLiFfdL
         X7RQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB9Ip552LiJvN1UwgzXeUsmocnS0yrJSg0d5vB225Xov0skCOuiwKWyXtp4oBirYDbbjJRhXFyCeMpjdJifA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyfVs3OhxGcEg67WgaHbo2z0EhUOqfRFNAc3ZFoC0NfynZD/mdG
	92CsHNXXJGnI0CVxKC0EjQwNgSYd6e7Vo9fGbaA2TLmMxrJdQxSiRymLvP17NF61tSyQ1Zf0JlU
	qImfCaZNGWhhSLhR7MjtlSIvqy/7GrgzrGyKeC/XwiZypJI/ZdwzPz6M=
X-Google-Smtp-Source: AGHT+IHJ25HfSVubo1Ec0fUPOkdV39ESq+Fv9jpazGfTkrT6K5LWsVUIAmNKR2Fp0dsfKJw50s/ne0yCx4MIJYt8sypcXCkRm2ng
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:330f:b0:3d1:9f4d:131 with SMTP id
 e9e14a558f8ab-3d28077166fmr77977085ab.1.1739779458676; Mon, 17 Feb 2025
 00:04:18 -0800 (PST)
Date: Mon, 17 Feb 2025 00:04:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b2ed82.050a0220.173698.0025.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING: locking bug in start_creating
From: syzbot <syzbot+d2f57500f15e9df86c90@syzkaller.appspotmail.com>
To: dakr@kernel.org, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    224e74511041 Merge tag 'kbuild-fixes-v6.14-2' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=155b35a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e55cabe422b4fcaf
dashboard link: https://syzkaller.appspot.com/bug?extid=d2f57500f15e9df86c90
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a6a898580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6b4272577622/disk-224e7451.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ec492843be2b/vmlinux-224e7451.xz
kernel image: https://storage.googleapis.com/syzbot-assets/013e7903deef/bzImage-224e7451.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/9956c6b4c5e1/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2f57500f15e9df86c90@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 5950 at kernel/locking/lockdep.c:234 hlock_class kernel/locking/lockdep.c:234 [inline]
WARNING: CPU: 0 PID: 5950 at kernel/locking/lockdep.c:234 check_wait_context kernel/locking/lockdep.c:4852 [inline]
WARNING: CPU: 0 PID: 5950 at kernel/locking/lockdep.c:234 __lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5178
Modules linked in:
CPU: 0 UID: 0 PID: 5950 Comm: syz-executor Not tainted 6.14.0-rc2-syzkaller-00390-g224e74511041 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4852 [inline]
RIP: 0010:__lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5178
Code: 00 00 83 3d 81 36 9f 0e 00 75 23 90 48 c7 c7 e0 a2 2a 8c 48 c7 c6 e0 a5 2a 8c e8 07 c2 e4 ff 48 ba 00 00 00 00 00 fc ff df 90 <0f> 0b 90 90 90 31 db 48 81 c3 c4 00 00 00 48 89 d8 48 c1 e8 03 0f
RSP: 0018:ffffc90004216a90 EFLAGS: 00010046
RAX: 6e3266fa0e7ed500 RBX: 0000000000000a0b RCX: ffff88807f24bc00
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000040a0b R08: ffffffff81817d42 R09: 1ffffffff1d4294c
R10: dffffc0000000000 R11: fffffbfff1d4294d R12: ffff88807f24c6d4
R13: 0000000000000014 R14: 1ffff1100fe498f6 R15: ffff88807f24c7b0
FS:  0000555560a1b500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555575ca0608 CR3: 0000000034c76000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:877 [inline]
 start_creating+0x130/0x310 fs/debugfs/inode.c:387
 debugfs_create_dir+0x25/0x430 fs/debugfs/inode.c:586
 ieee80211_debugfs_add_netdev net/mac80211/debugfs_netdev.c:1005 [inline]
 ieee80211_debugfs_recreate_netdev+0x1b6/0x14d0 net/mac80211/debugfs_netdev.c:1035
 ieee80211_if_add+0xef9/0x1780 net/mac80211/iface.c:2188
 ieee80211_register_hw+0x3708/0x42e0 net/mac80211/main.c:1604
 mac80211_hwsim_new_radio+0x2ae8/0x4a40 drivers/net/wireless/virtual/mac80211_hwsim.c:5558
 hwsim_new_radio_nl+0xece/0x2290 drivers/net/wireless/virtual/mac80211_hwsim.c:6242
 genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0xb1f/0xec0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x206/0x480 net/netlink/af_netlink.c:2543
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1322 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1348
 netlink_sendmsg+0x8de/0xcb0 net/netlink/af_netlink.c:1892
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:733
 __sys_sendto+0x363/0x4c0 net/socket.c:2187
 __do_sys_sendto net/socket.c:2194 [inline]
 __se_sys_sendto net/socket.c:2190 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2190
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f57e038ec7c
Code: 2a 5f 02 00 44 8b 4c 24 2c 4c 8b 44 24 20 89 c5 44 8b 54 24 28 48 8b 54 24 18 b8 2c 00 00 00 48 8b 74 24 10 8b 7c 24 08 0f 05 <48> 3d 00 f0 ff ff 77 34 89 ef 48 89 44 24 08 e8 70 5f 02 00 48 8b
RSP: 002b:00007ffd2d011db0 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f57e10d4620 RCX: 00007f57e038ec7c
RDX: 0000000000000024 RSI: 00007f57e10d4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffd2d011e04 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f57e10d4670 R15: 0000000000000000
 </TASK>


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
