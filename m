Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F57384E1C
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Apr 2025 22:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745965469; cv=none; b=PftAMHxH2HwTu9w78lWffBq04hGOCmfOrx7NZmvQ06CdSD6oG2Tj/YBEr/Lo+fdoI+XazjEOOw/4EezM+wqrbmw5bN0Wg+G9Ee8s95dGuqSVf+y8gOelXPFIM6jwffd12ztBSLkb06t7yi1PvBfe2THI/NrvPTX1nLj6vO+FEIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745965469; c=relaxed/simple;
	bh=ZxjSSO3zSdfQ+0uQV9kS+bFB1X651PDwoMLjLyWGzPI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Si4pOORXZgPkeSxIRPUh/eu9b1Wcae/1mZ178Epkg6T3JTSQZUN5+a4kuzY2v4eUlmdCkWHlA0DUn0Bt0K3AJWrlEhwf2uE95TwTbdqK8MTN29L0rr/KlSp50X53pbdZ6zvCkK2xWwJutKm5OnvSEXup4fKIhc18R90OUTyRnZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-86176e300fdso621459439f.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 29 Apr 2025 15:24:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745965466; x=1746570266;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IdNXUZqQeuiW9B9XnKTAPLYvVVlrDQjOW3qEnnYK9gQ=;
        b=B89h+sQ8MzN/+GcvbatWcutyV847k3Nad5whjepx73MA893gIEb8F3g9GbO+8Cu+xm
         S+1vUd/yAxNIPIJ2U9BHRTQUrlu/NjbpNR2jR5ykq0IN8SaGxdnw8psG9QFYiNGelfN+
         UAT8NBu3eXIqseOaBGUCtrzniEnyah7bmbLZMh3w5zLiTMlF9jwzolsFiWkRhCTlhO5/
         VNqKofAlA+gwY04K+gbU1PpeunoKDcPybZAssgKkH6E/vhq15GDWuYxyC2FojS1eX6/z
         LLmz+xedC9oARlg5Nf/UkVASPGTxVZckntsscL1rjYvfGGzwh2qz0zXntwqYIWxdw1h1
         yKZA==
X-Forwarded-Encrypted: i=1; AJvYcCVeLUIeG/i1MN0PMECt4fn1UWvY6fk6cIYwifvcnen4AumWPBsw/MRcxncTaOBhVMF3x08zpvv1CAFe/1amfg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwRM2CXucqcr3D4R6YsKIEHmSodsfNRdWsSQTrfPnJHGxjYgwu5
	11IJxpl6spQB6syd2neO1jKGZeNcoAFPN0x3jBAHeDOnqAqXopuhW8vrwIVdTk3Z8voVLCSOOQ4
	Ao7YKMsmpmcPc94V+NDS+84CnJzAh05IyyebwX32wSpAKr7r+kcoxTZg=
X-Google-Smtp-Source: AGHT+IG3BV9QV3T1xpNWUZM+44RrpkkuPVTnvQP0+PP2B8noLWzU3V0Zb6ry2PiikVafiQM5UcCgqe0GikC6NRLq1VaLIVh1onl2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:298b:b0:864:4a9b:f1f1 with SMTP id
 ca18e2360f4ac-86495f33807mr136127039f.14.1745965466554; Tue, 29 Apr 2025
 15:24:26 -0700 (PDT)
Date: Tue, 29 Apr 2025 15:24:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6811519a.050a0220.39e3a1.0c93.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fill_extent
From: syzbot <syzbot+150f08265580ecb7c31f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    c3137514f1f1 Merge tag 'riscv-for-linus-6.15-rc4' of git:/.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D10da10d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D90837c100b88a63=
6
dashboard link: https://syzkaller.appspot.com/bug?extid=3D150f08265580ecb7c=
31f
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-=
1~exp1~20250402004600.97), Debian LLD 20.1.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-c3137514.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/467c03afa53b/vmlinux-=
c3137514.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ea8b6881765e/bzI=
mage-c3137514.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+150f08265580ecb7c31f@syzkaller.appspotmail.com

bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.7: mi_btree_bitmap incomp=
lete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.25: ex=
tent_flags
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,set_fs_needs_rebalance
bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
bcachefs (loop0): pointer to nonexistent device 237
 =20
bcachefs (loop0): pointer to missing device 237
  while marking u64s 7 type extent 536870913:24:U32_MAX len 24 ver 0: durab=
ility: 0 crc: c_size 8 size 24 offset 0 nonce 0 csum none 0:0  compress lz4=
 ptr: 237:893353206280 gen 0, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay... done
bcachefs (loop0): check_alloc_info... done
bcachefs (loop0): check_lrus... done
bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
bcachefs (loop0): scanning for missing backpointers in 9/128 buckets
 done
bcachefs (loop0): check_alloc_to_lru_refs... done
bcachefs (loop0): bucket_gens_init... done
bcachefs (loop0): check_snapshot_trees... done
bcachefs (loop0): check_snapshots...
bcachefs (loop0): snapshot points to missing/incorrect tree:
  u64s 8 type snapshot 0:4294967295:0 len 0 ver 0: is_subvol 1 deleted 0 pa=
rent          0 children          0          0 subvol 1 tree 0, fixing
 done
bcachefs (loop0): check_subvols... done
bcachefs (loop0): check_subvol_children... done
bcachefs (loop0): delete_dead_snapshots... done
bcachefs (loop0): check_inodes... done
bcachefs (loop0): check_extents... done
bcachefs (loop0): check_indirect_extents... done
bcachefs (loop0): check_dirents... done
bcachefs (loop0): check_xattrs... done
bcachefs (loop0): check_root... done
bcachefs (loop0): check_unreachable_inodes... done
bcachefs (loop0): check_subvolume_structure... done
bcachefs (loop0): check_directory_structure... done
bcachefs (loop0): check_nlinks...
bcachefs (loop0): inode 536870914 type reg has wrong i_nlink (2780562353, s=
hould be 1), fixing
 done
bcachefs (loop0): resume_logged_ops... done
bcachefs (loop0): delete_dead_inodes... done
bcachefs (loop0): set_fs_needs_rebalance... done
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
kernel BUG at fs/bcachefs/fs.c:1327!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5313 Comm: syz.0.0 Not tainted 6.15.0-rc3-syzkaller-0024=
4-gc3137514f1f1 #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_fill_extent+0x96e/0x970 fs/bcachefs/fs.c:1327
Code: 0f 0b e8 d5 c2 8d fd 90 0f 0b e8 cd c2 8d fd e9 f7 fe ff ff e8 c3 c2 =
8d fd 90 0f 0b e8 bb c2 8d fd 90 0f 0b e8 b3 c2 8d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d6c7420 EFLAGS: 00010287
RAX: ffffffff8431fbed RBX: 0000000000000014 RCX: 0000000000100000
RDX: ffffc9000e0f2000 RSI: 00000000000015b3 RDI: 00000000000015b4
RBP: 0000000000000001 R08: ffff88801f690000 R09: 0000000000000004
R10: 0000000000000012 R11: 0000000000000002 R12: 0000000000000000
R13: ffffc9000d6c78a8 R14: 0000000000000002 R15: 0000000000000002
FS:  00007fc1fa9426c0(0000) GS:ffff88808d6cd000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1f9dae0a0 CR3: 000000003f77c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_fiemap+0x2764/0x2970 fs/bcachefs/fs.c:1540
 ioctl_fiemap fs/ioctl.c:220 [inline]
 do_vfs_ioctl+0x1638/0x1eb0 fs/ioctl.c:840
 __do_sys_ioctl fs/ioctl.c:904 [inline]
 __se_sys_ioctl+0x82/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf6/0x210 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc1f9b8e969
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc1fa942038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fc1f9db5fa0 RCX: 00007fc1f9b8e969
RDX: 0000200000000100 RSI: 00000000c020660b RDI: 0000000000000004
RBP: 00007fc1f9c10ab1 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fc1f9db5fa0 R15: 00007fff94ccddb8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fill_extent+0x96e/0x970 fs/bcachefs/fs.c:1327
Code: 0f 0b e8 d5 c2 8d fd 90 0f 0b e8 cd c2 8d fd e9 f7 fe ff ff e8 c3 c2 =
8d fd 90 0f 0b e8 bb c2 8d fd 90 0f 0b e8 b3 c2 8d fd 90 <0f> 0b 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa
RSP: 0018:ffffc9000d6c7420 EFLAGS: 00010287
RAX: ffffffff8431fbed RBX: 0000000000000014 RCX: 0000000000100000
RDX: ffffc9000e0f2000 RSI: 00000000000015b3 RDI: 00000000000015b4
RBP: 0000000000000001 R08: ffff88801f690000 R09: 0000000000000004
R10: 0000000000000012 R11: 0000000000000002 R12: 0000000000000000
R13: ffffc9000d6c78a8 R14: 0000000000000002 R15: 0000000000000002
FS:  00007fc1fa9426c0(0000) GS:ffff88808d6cd000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1f9dae0a0 CR3: 000000003f77c000 CR4: 0000000000352ef0
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

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
