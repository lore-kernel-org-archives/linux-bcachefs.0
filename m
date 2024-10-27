Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C3B1E517
	for <linux-bcachefs@vger.kernel.org>; Sun, 27 Oct 2024 03:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730001272; cv=none; b=IdkgSe9Gy+PD2l+MGG/Ec4bnqMPxcOpHd9VrJgnP/MhuT7P+moTbIJyDKUFPGGAV0xMO786HQOX5P1n8crCCOpeDv6xpzKFMmH0zlsJaI8k+7dtekN0JFgOyzNAP3va0KmSUNbxlQLX+xnNRV70dI2iQME9F6l556XgCHsBerYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730001272; c=relaxed/simple;
	bh=Q2JnLIOfMwKDF9Af1I4c1W2+MS0Zj+MVXPh4hJfNkME=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=dIOjp7tmm/nbhIOBLU8Cd5OHwDQl0gq6iqQ6JzszdQOHIDLxioFswM7YZZzFGbUgSGXqLtDE0yliQc8l+30LaaQo/imsHJuJxzB84l1r2GGtCAib3609ThaJy+MmaEMxf716glD1P9Tfq3D1AShBpbGwqyRIEYz3KC3zpYIVHxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a4daf7174eso31270325ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 26 Oct 2024 20:54:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730001269; x=1730606069;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Awm904hT1PgOhFEY2VTxE6Gcv3mz64A+/asWkoZE+wc=;
        b=u/XAZrA3E5K47U3fZw20W0mWAWhIfML2iV2jufFMUvfrlFOCHfm8UMH7jyjHPGx95w
         zAX2C8dFopu0lefxBZs3E1d+K+CG7JgO9+qGLhbCn7qtD0j3Z4buJh+exVjiQdzS4Aoc
         Pq+lxRFUHVmUpNomEJIqfkNfv0uTO7wBKZxwZatcpA74sbp9ww3W5ii/ter2vm4hxvnb
         gGKIxGmPjp2FBPFLQggU/wOFqacU7VOK0LYCe20eRqguf9KDAB5MIUl0aSgK0FifWQmW
         yvG7Ij9scEqgGM+oBVQoKOHGKMxzXB5QaTUkUYrqVv8NlnQfdhR1dZ9OeaG7qCOpb+n9
         RZ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXBQYZDQ6xr48rSpxfz77na7RdwO6wYwx/T3OHw2ofADPVDmOBZcl/Q1kc+/jfSb9t9UKn3TgFnV2BFEizkjg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+0ZuSffOC7mUP9RiFnnSLESUlBJRC9/53C7b4DYL0+ZRSFFtT
	w8y6A7ZP+1Px48KZum1BKW1znecmuKxMAABo3C7sU0rkqaLV+5ke4xtpW04CrHVJWgPsTM66DhO
	/zjb1fvBo3Qu8PVimL6yrHd5UnAVubqT5mIGZNHBjI4k9Rikb4mS/kgo=
X-Google-Smtp-Source: AGHT+IG4uQD/UnaHViL9bOXsFCv+4FcfA4QhlRwUSsQ/XsvmmMKbY4xnYW8KawhA6PzNNH4t6I6wrgvXDO+e9LyAvP7JEbanjD8Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a25:b0:3a3:f86f:2d0f with SMTP id
 e9e14a558f8ab-3a4ed27a9a1mr33424215ab.3.1730001269007; Sat, 26 Oct 2024
 20:54:29 -0700 (PDT)
Date: Sat, 26 Oct 2024 20:54:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671db974.050a0220.2b8c0f.01c0.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_inconsistent_error
From: syzbot <syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14202a5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fc6f8ce8c5369043
dashboard link: https://syzkaller.appspot.com/bug?extid=bee87a0c3291c06aa8c6
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11468c30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166fa640580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8a3541902b13/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a00efacc2604/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7da30fa86689/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bee87a0c3291c06aa8c6@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/error.c:29!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5094 Comm: syz-executor353 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48 c7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
FS:  00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_topology_error+0x83/0xc0 fs/bcachefs/error.c:37
 __btree_err+0x610/0x760 fs/bcachefs/btree_io.c:597
 validate_bset+0x157b/0x2640 fs/bcachefs/btree_io.c:807
 bch2_btree_node_read_done+0x2108/0x5e90 fs/bcachefs/btree_io.c:1126
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1327
 bch2_btree_node_read+0x2433/0x2a10
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1753 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1775
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:524
 bch2_fs_recovery+0x2585/0x39c0 fs/bcachefs/recovery.c:854
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2174
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1aa39038fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffddefb1b08 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffddefb1b20 RCX: 00007f1aa39038fa
RDX: 0000000020000300 RSI: 0000000020005900 RDI: 00007ffddefb1b20
RBP: 0000000000000004 R08: 00007ffddefb1b60 R09: 00000000000058c4
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffddefb1b60 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_inconsistent_error+0x14c/0x150 fs/bcachefs/error.c:29
Code: fb 02 75 20 e8 f5 53 67 fd 49 81 c7 cc 01 00 00 e8 09 0c d1 fd 48 c7 c7 20 74 53 8c 4c 89 fe e8 2a cb 95 07 e8 d5 53 67 fd 90 <0f> 0b 66 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f
RSP: 0018:ffffc9000b0965f8 EFLAGS: 00010293
RAX: ffffffff842d840b RBX: 0000000000000004 RCX: ffff8880359c8000
RDX: 0000000000000000 RSI: ffffffff8ef57290 RDI: 0000000000000004
RBP: ffffc9000b0967a8 R08: 0000000000000001 R09: ffffffff842d8324
R10: 0000000000000004 R11: ffff8880359c8000 R12: dffffc0000000000
R13: ffffc9000b0966c0 R14: ffff888044c00000 R15: ffff888044c00000
FS:  00005555742e5380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe064e9e68 CR3: 000000003df88000 CR4: 0000000000352ef0
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
