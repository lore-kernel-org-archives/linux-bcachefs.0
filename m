Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0822422F
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 16:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749833080; cv=none; b=VAXgg7YMCY7fybhF1+L9F1PhNBfaDSlazq5pdndgqitZok4lr1Fy84+A5VaL0q1jsRDikzuVSX4YXIjab9wl8BkeJZS6O/lvRxDyWfO8yUOK0u9fvPvOA0uvKc3uaBfDJ19EMuHyhv+FNHeEVrCOv8MObV6mf9QEKUo8Bgaagiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749833080; c=relaxed/simple;
	bh=UOI7+ktaAQl6abi1s30hD25aKpctjf5gVnDzOaQ7Lqs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=pXYNhAjxt5YsSHa3zS1NSb+AUnf+9td+A+GPrJBNrmtfZvIQRgQvaSW/n2Gx8qD1lkrfMaiFPCGxTBxxBU9FFYAtq5rAbQw0mYveZB61B+FYGp4V94Ud2kq5hifZdC9a6CiKeiL/ZojxQ6Cjf4TQdPjcgwPCTiooFD8YLi4SrOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-875b6256041so194957139f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 09:44:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749833077; x=1750437877;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pn3igpYazOZPbjAx5+cQ1Nj5ricVsiPAoL5mPDgYTys=;
        b=C0G50Mtjap6Wp/1yd4BlNd387UG7K4qP2ZW93lgEnfUpHY2N54lBihIovWtUFDZbOi
         ZjfCrlAJ3Z+8KFSj57nyeIhJ2P1bxbIGKy0A3YRwaQemL1WzPu4S+Z9VW1RO6+u9lo/E
         vu2w5RMTsPgEWt8cHzjXZqK7ml2CbCtZ1pMeIiGD/e9sXT4z+8YYFQ905Q7HK+G4zDjC
         ZflEnbARsXARpNIxWBo69iE5ugawGqutGJ/css4AXUhiidoZxbQnPKBSZy9ut2u0ACkS
         PcgbWg38N960nC80+33QlP7DGwFjJV00Rq+D5kvEvCXXy3f/MluH6iLFcO0kTEemr63C
         /c2g==
X-Forwarded-Encrypted: i=1; AJvYcCVlPsGjscq5YBzxvARdw0x5PIjFgs1Azxi+EpxnwFZWet1A5B3lulr1JwwpeRZoNt2lSJ3NaTmlNfgmGg/jqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8n82zwr+6ObSveIr3kJQdCapixVP9OprmQcptayJdBBjuQU3A
	4OnD4oAAuEwmX89bKQISMX40ySwxPxQrN8eCxpWcE53/9S1oMkO0UuCf+VYD6qz/6WCy1rJs3ox
	kHl//TrenJpO4zvOQrWqTE0D0zqXG1GPjeBZohkD30VEGJ6gC2xn8YFSix5A=
X-Google-Smtp-Source: AGHT+IG1Q4iNiUn++8XEpjqsv6tiGyArUlxH+3F1GmU61g6xl33TI+0mmYdk7sTO9/Iw4SgKVyV2xCFGs60+amkgzKoNwOdB5bn3
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184a:b0:3dd:f745:89 with SMTP id
 e9e14a558f8ab-3de07cf7df0mr3530435ab.20.1749833077323; Fri, 13 Jun 2025
 09:44:37 -0700 (PDT)
Date: Fri, 13 Jun 2025 09:44:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684c5575.a00a0220.279073.0012.GAE@google.com>
Subject: [syzbot] [bcachefs?] KASAN: use-after-free Read in poly1305_update
From: syzbot <syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    19272b37aa4f Linux 6.16-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=159ab9d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8409c4d4e51ac27
dashboard link: https://syzkaller.appspot.com/bug?extid=bfaeaa8e26281970158d
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c3f682580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1340310c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/92d22b0c6493/disk-19272b37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fb0142bb63a/vmlinux-19272b37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d5f3836ae42/Image-19272b37.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d19ea34ad935/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bfaeaa8e26281970158d@syzkaller.appspotmail.com

  ret fsck_errors_not_fixed
bcachefs (loop0): error reading btree root btree=xattrs level=0: btree_node_read_error, fixing
==================================================================
BUG: KASAN: use-after-free in poly1305_update+0x138/0x188 lib/crypto/poly1305.c:44
Read of size 8 at addr ffff0000e4b60070 by task syz-executor339/6486

CPU: 1 UID: 0 PID: 6486 Comm: syz-executor339 Not tainted 6.16.0-rc1-syzkaller-g19272b37aa4f #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:466 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 print_address_description+0xa8/0x254 mm/kasan/report.c:408
 print_report+0x68/0x84 mm/kasan/report.c:521
 kasan_report+0xb0/0x110 mm/kasan/report.c:634
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2a4 mm/kasan/generic.c:189
 __asan_memcpy+0x3c/0x84 mm/kasan/shadow.c:105
 poly1305_update+0x138/0x188 lib/crypto/poly1305.c:44
 bch2_checksum+0x1d4/0x4ac fs/bcachefs/checksum.c:157
 bch2_btree_node_read_done+0x968/0x432c fs/bcachefs/btree_io.c:1148
 btree_node_read_work+0x328/0xc1c fs/bcachefs/btree_io.c:1399
 bch2_btree_node_read+0x814/0x23f8 fs/bcachefs/btree_io.c:-1
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1865 [inline]
 bch2_btree_root_read+0x280/0x3c8 fs/bcachefs/btree_io.c:1887
 read_btree_roots+0x218/0x6bc fs/bcachefs/recovery.c:591
 bch2_fs_recovery+0x1d1c/0x2fd4 fs/bcachefs/recovery.c:964
 bch2_fs_start+0x914/0xbc0 fs/bcachefs/super.c:1200
 bch2_fs_get_tree+0x890/0xfd0 fs/bcachefs/fs.c:2489
 vfs_get_tree+0x90/0x28c fs/super.c:1802
 do_new_mount+0x228/0x814 fs/namespace.c:3885
 path_mount+0x5b4/0xde0 fs/namespace.c:4209
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount fs/namespace.c:4410 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4410
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x124b60
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000000000 fffffdffc392d808 fffffdffc392d808 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff0000e4b5ff00: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff0000e4b5ff80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff0000e4b60000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                             ^
 ffff0000e4b60080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff0000e4b60100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
bcachefs (loop0): btree node read error at btree alloc level 0/0
  u64s 11 type btree_ptr_v2 U64_MAX:18446744073709551365:U32_MAX len 0 ver 0: seq 1818ce08861e3527 written 40 min_key POS_MIN durability: 1 ptr: 0:26:0 gen 0
  loop0 node offset 0/40 bset u64s 65531: checksum error, type chacha20_poly1305_128: got d1207b6f1073532ce6802ea238ac7a29 should be a1c0cae4d1c6eac9087fba7ada6f601b
  flagging btree alloc lost data
  running recovery pass check_alloc_info (13), currently at recovery_pass_empty (0)
  ret fsck_errors_not_fixed
bcachefs (loop0): error reading btree root btree=alloc level=0: btree_node_read_error, fixing
bcachefs (loop0): btree node read error at btree freespace level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq b6c44d07df4e9bb7 written 48 min_key POS_MIN durability: 1 ptr: 0:29:0 gen 0
  loop0 node offset 8/48 bset u64s 35: checksum error, type chacha20_poly1305_128: got ed761e9f1d4c73c28012c6926fffa8ec should be 696606121d98d113a1b1dc69c6e72339
  flagging btree freespace lost data
  ret fsck_errors_not_fixed
bcachefs (loop0): error reading btree root btree=freespace level=0: btree_node_read_error, fixing
bcachefs (loop0): btree node read error at btree backpointers level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 3b468546fb27822d written 24 min_key POS_MIN durability: 1 ptr: 0:36:0 gen 0
  loop0 node offset 16/24 bset u64s 14: checksum error, type chacha20_poly1305_128: got a67d0bb2ddad47adce7ef65cfcb4dbe2 should be 6399ef4aeb6d8a4369c39b0b9ed27362
  flagging btree backpointers lost data
  running recovery pass check_btree_backpointers (15), currently at recovery_pass_empty (0)
  ret fsck_errors_not_fixed
bcachefs (loop0): error reading btree root btree=backpointers level=0: btree_node_read_error, fixing
bcachefs (loop0): scan_for_btree_nodes...
bcachefs (loop0): btree node scan found 7 nodes after overwrites
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root inodes unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=inodes level=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 2a20405ac3f40602 written 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0
bcachefs (loop0): empty interior btree node at btree=inodes level=1
  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): empty btree root inodes
bcachefs (loop0): btree root dirents unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=dirents level=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 267fcf747c875937 written 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0
bcachefs (loop0): empty interior btree node at btree=dirents level=1
  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): empty btree root dirents
bcachefs (loop0): btree root xattrs unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=xattrs level=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1b881868e2a6abe1 written 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0
bcachefs (loop0): empty interior btree node at btree=xattrs level=1
  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): empty btree root xattrs
 done
bcachefs (loop0): scan_for_btree_nodes... done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): Fixed errors, running fsck a second time to verify fs is clean
bcachefs (loop0): done starting filesystem
bcachefs (loop0): missing subvolume 1
bcachefs (loop0): bch2_fs_get_tree(): error mounting: error getting root inode ENOENT_bkey_type_mismatch
bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
bcachefs: bch2_fs_get_tree() error: ENOENT_bkey_type_mismatch


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
