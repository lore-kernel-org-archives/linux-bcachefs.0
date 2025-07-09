Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A960A288C13
	for <linux-bcachefs@vger.kernel.org>; Wed,  9 Jul 2025 10:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752056378; cv=none; b=t2klDIxb6Mwk3umHtEVjN7YuqDv9cj4USKBBkQHdysNm6SxU27OtxNJMOyglvv69IP28sbZux7sniXfUZH530jDgwYnRfeBI73iqEBFIWAHv/e8R5b0CKHjDjSFXDfeYpZmnoPFLuq/ZZNhgciF/tNdkcSWtsN2MnYNfkGKJIn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752056378; c=relaxed/simple;
	bh=CBjd/dYK5mBZTnUDMNluqtKD0eSyrqiqAv9096eYEqU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=t+8Y0yqgc7yMtNkN598KwMOfHpbrk5QG/gWxT3lk54rvi0RfQH12E6zOkgolhXuTy2IvjPKX8Kq0Mr1NGLfI4Dp1D+24pJMkOUzKVCzXN7kTdU55txu0y+eIMppzxXPVxxqY0XVy+6lRtJaGtpcUNnG7vkjWVL9qbeFjD504f5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-869e9667f58so1111903339f.3
        for <linux-bcachefs@vger.kernel.org>; Wed, 09 Jul 2025 03:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752056376; x=1752661176;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kiFIMRDznFqfOqvFbnckfSKn5Gyi/myOlnv4fWjZZKE=;
        b=ptMJWYUTsHucqWcwtZAsCgY4CYHdZO0hhIcYjzRaAxVprWPc7/v3JJRPeBi9OVmXmQ
         CzZXJtybrM7AlwwVfVDzQTNLIcA5smLwTHjO5dtf8LPa3D36VDRI4OcEO+Z33nE6ufQp
         TLs7nQVn8RXWyEm8Tuq4Klmj+aUQ89mi2ekDtvbVuH96B1u+X7B7wd5LqppGtStLrbrA
         wNpUoIn0bPECCj2zm176aKU2hPD/m69AzkogL5+njdvFD2WadbsYBoek7Ng5Hp4xXc6M
         jZSWRR3pHKalN1LkR20ArtKXSIcb6eXWz+RvtCHFEUDFPhzyoNEKCpFdPVkfWDFlASPj
         6KJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWW60FZ14mk7V+7k+4hf+/A+a8PB2bVHtBBqNxz+PLHGMeG5hoA5+Wdbr+LTWchfz96PiMF/EYxzVuY8s9X8w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsGBpVsYfxC9sVVEd3PQNjm8qmprvX2m8CeYHOwePlA8IadAbv
	wFFZOASZOIxYQYWwjD8N+eRQzTFHX0wlhfQ+k2/b7yOnQGXwF9jFQr3QNJWvssKM1GZba4yhQrF
	VsP8O2yRbos1VKfQrzxb2NMypBMWgxPGN5M2pMzib5x553Gi3cX4kXBPuIEI=
X-Google-Smtp-Source: AGHT+IE0A0cB0AdxhxIXdo02g/aEMovLre8D+EQox6QHRFyc2rG2ZPpRY1Y06rQ8dGd0Z4QzfLem8yP4WJkvXQOVPhVkJnPvbRzg
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:276a:b0:85b:3c49:8811 with SMTP id
 ca18e2360f4ac-8795b0acf05mr238766239f.4.1752056375808; Wed, 09 Jul 2025
 03:19:35 -0700 (PDT)
Date: Wed, 09 Jul 2025 03:19:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686e4237.a00a0220.296254.038a.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_btree_node_mem_alloc (2)
From: syzbot <syzbot+6f91a1a3e34f980bb72c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    c435a4f487e8 Merge tag 'riscv-for-linus-6.16-rc5' of git:/.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D13c4cf70580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db29b1a0d7330d4a=
8
dashboard link: https://syzkaller.appspot.com/bug?extid=3D6f91a1a3e34f980bb=
72c
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-=
1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-c435a4f4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3a184d1ad283/vmlinux-=
c435a4f4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/db5931917c56/bzI=
mage-c435a4f4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+6f91a1a3e34f980bb72c@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.519: (unknown version) opts=3Dmetadata=
_checksum=3Dnone,data_checksum=3Dnone,checksum_err_retry_nr=3D0,compression=
=3Dlz4,nopromote_whole_extents,fsck,norecovery,nojournal_transaction_names,=
allocator_stuck_timeout=3D3,version_upgrade=3Dincompatible
  allowing incompatible features above 0.0: (unknown version)
  features: lz4,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,n=
ew_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
bcachefs (loop0): Using encoding defined by superblock: utf8-12.1.0
bcachefs (loop0): invalid bkey in superblock btree=3Dextents level=3D1: u64=
s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c6c25c03258c59c5 written 1=
6 min_key 360287970189639680:0:0 durability: 0 (invalid extent entry 000000=
000001b000)
  invalid extent entry type (got 12, max 7), deleting
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): Version downgrade required:
bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.519: (unknown version) in=
complete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.28: in=
ode_has_case_insensitive
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,check_rebalance_work,set_fs_needs_rebalance
bcachefs (loop0): Now allowing incompatible features up to 1.28: inode_has_=
case_insensitive, previously allowed up to 0.0: (unknown version)
bcachefs (loop0): error reading btree root btree=3Ddirents level=3D0: btree=
_node_read_error, fixing
bcachefs (loop0): invalid bkey in btree_node btree=3Dalloc level=3D0: u64s =
11 type xattr POS_MIN len 0 ver 0: (type 1):=20
  invalid key type for btree alloc (xattr), deleting
bcachefs (loop0): error reading btree root btree=3Dalloc level=3D0: btree_n=
ode_read_error, fixing
bcachefs (loop0): btree node read error at btree snapshots level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq ebb8d5a9e3463bdb writ=
ten 16 min_key 0:262144:0 durability: 1 ptr: 0:32:0 gen 0
  loop0 node offset 0/16: incorrect min_key: got POS_MIN should be 0:262144=
:0
  flagging btree snapshots lost data
  running recovery pass reconstruct_snapshots (21), currently at recovery_p=
ass_empty (0)
  ret btree_node_read_validate_error
bcachefs (loop0): error reading btree root btree=3Dsnapshots level=3D0: btr=
ee_node_read_error, fixing
bcachefs (loop0): error reading btree root btree=3Dfreespace level=3D0: btr=
ee_node_read_error, fixing
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root dirents unreadable, must recover from scan
bcachefs (loop0): running recovery pass scan_for_btree_nodes (1), currently=
 at check_topology (2) - rewinding
bcachefs (loop0): bch2_check_root(): error restart_recovery
bcachefs (loop0): scan_for_btree_nodes...
bcachefs (loop0): btree node scan found 7 nodes after overwrites
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root dirents unreadable, must recover from scan
bcachefs (loop0): bch2_get_scanned_nodes(): recovery btree=3Ddirents level=
=3D0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_p=
tr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf written 24 min_key POS_MIN=
 durability: 1 ptr: 0:41:0 gen 0
bcachefs (loop0): empty interior btree node at btree=3Ddirents level=3D1
  u64s 5 type btree_ptr SPOS_MAX len 0 ver 0, fixing
bcachefs (loop0): bch2_btree_repair_topology_recurse(): error ECHILD
bcachefs (loop0): empty btree root dirents
bcachefs (loop0): btree root snapshots unreadable, must recover from scan
------------[ cut here ]------------
btree cache cannibalize failed
WARNING: CPU: 0 PID: 5351 at fs/bcachefs/btree_cache.c:771 btree_node_canni=
balize fs/bcachefs/btree_cache.c:771 [inline]
WARNING: CPU: 0 PID: 5351 at fs/bcachefs/btree_cache.c:771 bch2_btree_node_=
mem_alloc+0x1015/0x1820 fs/bcachefs/btree_cache.c:871
Modules linked in:
CPU: 0 UID: 0 PID: 5351 Comm: syz.0.0 Not tainted 6.16.0-rc4-syzkaller-0028=
6-gc435a4f487e8 #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:btree_node_cannibalize fs/bcachefs/btree_cache.c:771 [inline]
RIP: 0010:bch2_btree_node_mem_alloc+0x1015/0x1820 fs/bcachefs/btree_cache.c=
:871
Code: d2 e8 8f ca 74 fd 2e 2e 2e 31 c0 e9 a6 fe ff ff e8 c0 ae a2 fd c6 05 =
4d 27 6e 0b 01 90 48 c7 c7 c0 24 d3 8b e8 3c 57 66 fd 90 <0f> 0b 90 90 eb c=
3 e8 a0 ae a2 fd eb 05 e8 99 ae a2 fd 49 8d bf b0
RSP: 0018:ffffc9000d4b6d40 EFLAGS: 00010246
RAX: 35dc07f7034c9600 RBX: ffff888059d80000 RCX: 0000000000100000
RDX: ffffc9000f7e1000 RSI: 00000000000fffff RDI: 0000000000100000
RBP: ffff888059d81ce8 R08: ffff88801fc24293 R09: 1ffff11003f84852
R10: dffffc0000000000 R11: ffffed1003f84853 R12: ffff888059cfc800
R13: ffff888059cfca28 R14: ffff888059d81cf0 R15: dffffc0000000000
FS:  00007f3575bd46c0(0000) GS:ffff88808d21c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055558c3af5f8 CR3: 0000000011c4d000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 bch2_btree_root_alloc_fake_trans+0x141/0xb00 fs/bcachefs/btree_update_inte=
rior.c:2655
 bch2_check_root fs/bcachefs/btree_gc.c:566 [inline]
 bch2_check_topology+0x390/0xe00 fs/bcachefs/btree_gc.c:594
 bch2_run_recovery_pass fs/bcachefs/recovery_passes.c:484 [inline]
 __bch2_run_recovery_passes+0x395/0x1010 fs/bcachefs/recovery_passes.c:539
 bch2_run_recovery_passes+0x184/0x210 fs/bcachefs/recovery_passes.c:610
 bch2_fs_recovery+0x2690/0x3a50 fs/bcachefs/recovery.c:1005
 bch2_fs_start+0xaaf/0xda0 fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0xb39/0x1520 fs/bcachefs/fs.c:2488
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f35797900ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3575bd3e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f3575bd3ef0 RCX: 00007f35797900ca
RDX: 00002000000000c0 RSI: 0000200000000100 RDI: 00007f3575bd3eb0
RBP: 00002000000000c0 R08: 00007f3575bd3ef0 R09: 000000000000001e
R10: 000000000000001e R11: 0000000000000246 R12: 0000200000000100
R13: 00007f3575bd3eb0 R14: 0000000000005aa7 R15: 00002000000001c0
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
