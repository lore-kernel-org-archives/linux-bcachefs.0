Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47E619994F
	for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 18:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748716118; cv=none; b=qMNHXGPpv48ldTXeEE2oltWK7xDRvzuQ1L7nEK+xY5a+uNblYeiLHqk9zUAS9BzqApgMzZ5bahvscCxcJZVWcj3693gRTcMsHgpEXo7qpQYPOtWZnPX0CZAqI6ZVe+OVv6hzud0qqjJntbxPVzlBzhPDpekO22V2f31Gs0f2OUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748716118; c=relaxed/simple;
	bh=KzSffM1aevSBmkvD6jkFGDQpUHk+Z6oxjiHShe29E7E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ETh7yhQq2GUnIFpBYe1XDK6iFGsDUhhA3ZERpG9Pl/C8zlj7V4w8mAoq7jGbHq1553DTiEi16xswcYNKwuqSHlh9h2+7lFp/rQNzR7QSrk74oN8xGeFDzpnwr62bCQOQ9syobw+Bw5Q+eYG6mK7QCx4vR3med6kK46BknHgEYjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3dc8ab29f1eso39487885ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 31 May 2025 11:28:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748716116; x=1749320916;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZWE0pzSq45hRnTBBprYcArathFtef7VGWSlEoL/nWM=;
        b=HwP6jzVK1x5fPXhJS9DkJn/2K/wwq8pdWkBUkLYtTKrlFHZbzObf7UndJGyBylYnBC
         hm9JcbUwtZLO64A0fLfWUPph/WHX8N1Q5mvri/MXlxmRYxvkf68DAnt+4B1nYmu8x55C
         iHQRQHHmja/L3taBbS3ArzvMHeLIIxIUOIJDnjYG0YHeqTVHxMaskPawVrAX6y0pWgfX
         r4R4QH1BQASQt5Q4mBz9OIb2oay6CewdLxQNJbr9KrVTu5lzJG6I6nCqKfE3qG7/26AN
         WKuUNoHAcUo728h0rlSDRUOMAOP4YcNV2IS3OWVrtsE6jKerJs0acISl6BI9Qo6lt8Tx
         4uwg==
X-Forwarded-Encrypted: i=1; AJvYcCWHSWWN4tuCm1jQge8CrvxVYPGlvQowB1yIGD7hD66/1LreLdbHSmJgDuTKj2Ja9xcZk5K8WDU/YX6NCRI88w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxylkkQ6DV23l6z53fANeOpHCDvtKM2/DL/KhYYuktLNVIS9g6E
	Q2b2GDGWi9irxRbXQAGaQhm70xK7kPhAP9R/hpMlKpFNRFoShUJf8p/07QOsffBN6AgISlzaKc6
	I3UlY7lVnE3USMgtaskrSwBsyZgDZdp7ywcQqLHGUh3WqCkd2VHP1uUkh4a4=
X-Google-Smtp-Source: AGHT+IHRYtGaTQNH2dyAo3CMNaycgyyhx42ObEZBhpal3YuvV0mkrdnkAFmA4sZYx0yqzK5O6K3zV3OiCZcO4cNrUGEx5WpXjYR3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3a04:b0:3dc:7240:94a6 with SMTP id
 e9e14a558f8ab-3dda33367a8mr19543635ab.3.1748716115952; Sat, 31 May 2025
 11:28:35 -0700 (PDT)
Date: Sat, 31 May 2025 11:28:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <683b4a53.a00a0220.d8eae.001c.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_journal_start
From: syzbot <syzbot+527519da96e15b411c73@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    b1456f6dc167 Merge tag 'timers-core-2025-05-25' of git://g.=
.
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D17256df4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3De178ebeb0aded44=
c
dashboard link: https://syzkaller.appspot.com/bug?extid=3D527519da96e15b411=
c73
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-=
1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1560048258000=
0
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1409a6d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/501bf321b156/disk-=
b1456f6d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/d3c8e81517e2/vmlinux-=
b1456f6d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e6e8960905fd/bzI=
mage-b1456f6d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/674711f8120d=
/mount_0.gz

The issue was bisected to:

commit 521f9584c2bd48198ac9d9b99a372b1306f3bb97
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri May 23 18:03:06 2025 +0000

    bcachefs: Ensure we don't use a blacklisted journal seq

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D170266d45800=
00
final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D148266d45800=
00
console output: https://syzkaller.appspot.com/x/log.txt?x=3D108266d4580000

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+527519da96e15b411c73@syzkaller.appspotmail.com
Fixes: 521f9584c2bd ("bcachefs: Ensure we don't use a blacklisted journal s=
eq")

bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.7: mi_btree_bitmap incomp=
lete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.28: in=
ode_has_case_insensitive
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,check_rebalance_work,set_fs_needs_rebalance
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5823 at mm/slub.c:5024 __kvmalloc_node_noprof+0x4ca/0x=
600 mm/slub.c:5024
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz-executor230 Not tainted 6.15.0-syzkaller-=
02198-gb1456f6dc167 #0 PREEMPT(full)=20
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 05/07/2025
RIP: 0010:__kvmalloc_node_noprof+0x4ca/0x600 mm/slub.c:5024
Code: 0f 85 36 fc ff ff 31 c0 41 f6 c5 10 0f 94 c0 4c 8d 34 45 01 00 00 00 =
e9 20 fc ff ff 41 f7 c0 00 20 00 00 0f 85 8f fe ff ff 90 <0f> 0b 90 31 db e=
9 f2 fe ff ff 48 c7 c7 80 86 04 8e 48 89 de e8 0d
RSP: 0018:ffffc900043af1d8 EFLAGS: 00010246
RAX: 0000000000000360 RBX: 0000000000000000 RCX: 72c1c7b072d25100
RDX: 000001b000000000 RSI: ffffffff8bc17920 RDI: ffffffff8bc178e0
RBP: ffffffff843fb660 R08: 0000000000000cc0 R09: 00000000ffffffff
R10: ffffc900043af080 R11: fffff52000875e15 R12: 000001b000000000
R13: 0000000000012cc0 R14: ffffffff843fb660 R15: 00000000ffffffff
FS:  0000555588a53380(0000) GS:ffff8881261c7000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffca09dfed4 CR3: 0000000034b80000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fs_journal_start+0x480/0x1500 fs/bcachefs/journal.c:1459
 bch2_fs_recovery+0x20ca/0x3970 fs/bcachefs/recovery.c:953
 bch2_fs_start+0xa43/0xd30 fs/bcachefs/super.c:1206
 bch2_fs_get_tree+0xbfc/0x15f0 fs/bcachefs/fs.c:2479
 vfs_get_tree+0x92/0x2b0 fs/super.c:1809
 do_new_mount+0x24a/0xa40 fs/namespace.c:3882
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa56d6f7faa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe2a8b108 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fffe2a8b120 RCX: 00007fa56d6f7faa
RDX: 0000200000000040 RSI: 0000200000000000 RDI: 00007fffe2a8b120
RBP: 0000200000000000 R08: 00007fffe2a8b160 R09: 00000000000059d1
R10: 0000000000800000 R11: 0000000000000282 R12: 0000200000000040
R13: 00007fffe2a8b160 R14: 0000000000000003 R15: 0000000000800000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisectio=
n

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
