Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D897122DFBD
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 09:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739869942; cv=none; b=JNKVMmxdCHjQ5FGMwuUgd0ZyGP3RfuOsY6sCIA0R6G8bGexIr+k4oph4WLewKWLPiUmpScWJvrk8nNMlTw3PhA7RJX1waeExRauqWXdD95dH87Jbw3A902I+hiAOWO4MiQlBmvj0yaSiIXEV3UKC75MtbV1uQJ2XcbWpRqjPd0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739869942; c=relaxed/simple;
	bh=fwhbAT7iF+x60zVHX7sN2CfDkZGQmzgkZDlm1Wo11is=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OKR7+ngNxUeORUKRXFIwuVvfw6H037fMqf/Zn5z6GaoyGE1PeSR3B9LWPqhhB29R958Dy7DO5K+ka9tKCTw/PYT8CD8cdOZIfTBOCEjEKTONdM4c47EajlkbvK5T4FJU/ZFuI1UkOC7YIjnW0Gi4aW1fw1RLgaK8zMs7KJKhczQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-855a5457110so42971939f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 18 Feb 2025 01:12:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739869940; x=1740474740;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wnJLTfmta2TNrlQgFdw3Kyt9opRqxR2syxoIevQZdl0=;
        b=cUozxYLa1lc3JSu6QeK7HZoP5m7Nmf6TtnhF3mtsJYh51jC5Ir0ih9szP4APVAqnSo
         Smu1FhVXdtiA/G/XfNdEqHSiD6QZzn18gAzYNDj2tqyFSfg4b7bXwi3u9Vn1/0Jj2fEh
         Y8+OZ892adoGjWYI0KmIBJGRYZehb+VKzcQKeH6sqNrpRV3SxJBiKGejoyKrjbBK7nrg
         KphIAlZ7Gl1o0wYYpIzrk5rfZSBqwhPMMN6utwZJJF1GtOyaZ8MrObPoJnytHKknkzbt
         h/tu5EpAeZ23Lt1v8XNv0MpdyqGYy4+r0fUmNMMcsl6FbLWZfveiv2LMrtdQK65Yt/AJ
         idDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWz2RmzYBq14REWAFjt3S0bvfRqQUlltu45x2A8Tgc+FVhwbQKsdOWzQ0D8gIrbRCWk2R0w0t9cnOWrsoGSow==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/KUKsNvSpI8BUFHdFHQH9eBIAqtGIIDqpnqKSg2vNgEC3Kfmy
	E84YrI8Lt+cvUP/hBREjIraWm1mN24pFvKqEkDr+aQM53ZxZWk690cajSDLRvwV4erf7M7FbZf2
	806Ty/jhIxKPMcRebKizddfH2isna1unwHWhy2b3CI7Wh0pWUyW6LOPk=
X-Google-Smtp-Source: AGHT+IHMQJtyQW2Hs1tj4XNcBPEZT7IoVYMmmXZ7FToeiO3rHt0VXbunvM35lmcuiOnIm1wYQ6woEK/1sQr7kl15q/UlgNtpGSqP
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c548:0:b0:3d0:4700:db0f with SMTP id
 e9e14a558f8ab-3d28090d830mr117361035ab.12.1739869939950; Tue, 18 Feb 2025
 01:12:19 -0800 (PST)
Date: Tue, 18 Feb 2025 01:12:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67b44ef3.050a0220.173698.004c.GAE@google.com>
Subject: [syzbot] [bcachefs] WARNING: locking bug in simple_recursive_removal
From: syzbot <syzbot+727c886b67040701c448@syzkaller.appspotmail.com>
To: dakr@kernel.org, gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rafael@kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    0ad2507d5d93 Linux 6.14-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D13efd7df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db7bde34acd8f53b=
1
dashboard link: https://syzkaller.appspot.com/bug?extid=3D727c886b67040701c=
448
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-0ad2507d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/dfb4fc7c042e/vmlinux-=
0ad2507d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1682113b81f5/bzI=
mage-0ad2507d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+727c886b67040701c448@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=3Dmetadata_che=
cksum=3Dnone,data_checksum=3Dnone,compression=3Dlz4,erasure_code,fsck,norec=
overy,nojournal_transaction_names,reconstruct_alloc,nocow,no_data_io
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.7: mi_btree_bitmap incomp=
lete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.20: di=
rectory_size
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,set_fs_needs_rebalance
bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): error validating btree node on loop0 at btree xattrs leve=
l 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 2285c34bed0abe32 writ=
ten 16 min_key POS_MIN durability: 1 ptr: 0:31:0 gen 0 =20
  node offset 0/16 bset u64s 60928: bset past end of btree node (offset 0 l=
en 960 but written 16), exiting
bcachefs (loop0): Unable to continue, halting
bcachefs (loop0): flagging btree xattrs lost data
bcachefs (loop0): running explicit recovery pass check_topology (2), curren=
tly at recovery_pass_empty (0)
bcachefs (loop0): running explicit recovery pass scan_for_btree_nodes (1), =
currently at recovery_pass_empty (0)
error reading btree root btree=3Dxattrs level=3D0: btree_node_read_error, f=
ixing
invalid bkey in btree_node btree=3Dsubvolumes level=3D0: u64s 7 type subvol=
ume 0:1:0 len 0 ver 0: root 4096 snapshot id 0
  invalid snapshot: delete?, fixing
bcachefs (loop0): scan_for_btree_nodes...
bcachefs (loop0): btree node scan found 7 nodes after overwrites
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root xattrs unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=3Dxattrs level=
=3D0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_p=
tr_v2 SPOS_MAX len 0 ver 0: seq 2285c34bed0abe32 written 960 min_key POS_MI=
N durability: 1 ptr: 0:31:0 gen 0
empty interior btree node at btree=3Dxattrs level=3D1
u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): empty btree root xattrs
 done
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): done starting filesystem
bcachefs (loop0): missing subvolume 1
bcachefs (loop0): inconsistency detected - emergency read only at journal s=
eq 10
bcachefs (loop0): bch2_fs_get_tree(): error mounting: error getting root in=
ode ENOENT_bkey_type_mismatch
bcachefs (loop0): shutting down
------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 0 PID: 5320 at kernel/locking/lockdep.c:234 hlock_class kerne=
l/locking/lockdep.c:234 [inline]
WARNING: CPU: 0 PID: 5320 at kernel/locking/lockdep.c:234 check_wait_contex=
t kernel/locking/lockdep.c:4852 [inline]
WARNING: CPU: 0 PID: 5320 at kernel/locking/lockdep.c:234 __lock_acquire+0x=
564/0x2100 kernel/locking/lockdep.c:5178
Modules linked in:
CPU: 0 UID: 0 PID: 5320 Comm: syz.0.0 Not tainted 6.14.0-rc3-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4852 [inline]
RIP: 0010:__lock_acquire+0x564/0x2100 kernel/locking/lockdep.c:5178
Code: 00 00 83 3d 21 60 a0 0e 00 75 23 90 48 c7 c7 40 a2 2a 8c 48 c7 c6 40 =
a5 2a 8c e8 97 c2 e4 ff 48 ba 00 00 00 00 00 fc ff df 90 <0f> 0b 90 90 90 3=
1 db 48 81 c3 c4 00 00 00 48 89 d8 48 c1 e8 03 0f
RSP: 0018:ffffc9000d4df530 EFLAGS: 00010046
RAX: 95b5ba76c7869700 RBX: 0000000000000c41 RCX: 0000000000100000
RDX: dffffc0000000000 RSI: 000000000005bf76 RDI: 000000000005bf77
RBP: 0000000000040c41 R08: ffffffff81817e32 R09: 1ffff11003f8519a
R10: dffffc0000000000 R11: ffffed1003f8519b R12: ffff8880009cd354
R13: 0000000000000005 R14: 1ffff11000139a77 R15: ffff8880009cd3b8
FS:  00007f48caa6a6c0(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000562b40d2b088 CR3: 00000000408fe000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 down_write+0x99/0x220 kernel/locking/rwsem.c:1577
 inode_lock include/linux/fs.h:877 [inline]
 simple_recursive_removal+0x9a/0x8f0 fs/libfs.c:615
 debugfs_remove+0x49/0x70 fs/debugfs/inode.c:805
 __bch2_fs_stop+0x290/0x5c0 fs/bcachefs/super.c:643
 bch2_fs_get_tree+0xd3a/0x17a0 fs/bcachefs/fs.c:2303
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f48c9b8e58a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f48caa69e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f48caa69ef0 RCX: 00007f48c9b8e58a
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007f48caa69eb0
RBP: 00004000000058c0 R08: 00007f48caa69ef0 R09: 0000000000010000
R10: 0000000000010000 R11: 0000000000000246 R12: 0000400000005900
R13: 00007f48caa69eb0 R14: 0000000000005912 R15: 00004000000001c0
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
