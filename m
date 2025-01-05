Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3812628D
	for <linux-bcachefs@vger.kernel.org>; Sun,  5 Jan 2025 10:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736074163; cv=none; b=WnfXRdxl61dZiVxfTEay63whTAdb2eKbh3oS4PVpfy9bqlNgD+0OzV29i9rkP2Fi/y35MQjcrEVqyCL596DG1+1U/3HOrPIcej2BlsJcDWhnSgtnxUkjx1Qzaat7FB7KrvNWLQlIoruEOirSwtWfcAkKV1+oIg199JO8l2l9OoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736074163; c=relaxed/simple;
	bh=uYy3iOcsES6OIQN/aS50SxQlMjSoK5tV8/XSnN+Vqig=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Q3GoH+F46eyVDMRCKzvirvyjiv4zztZaaOhc80cMCwKNYWPys3+/I9HOY1pFvIB9vdo3gUoJ8ZraInWbhBZ8+i1KX816hXmCOdaO5eIoVr/ZH0BDEH3QwjP8neNwqHXF8kNaMyrbygCGZ1/VETX7OqNvE4bbF/amT1hvIexeELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844e6476afeso1016813539f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 Jan 2025 02:49:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736074161; x=1736678961;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ULLl7S68cxBZyYh47LwVeGJ70HoT2jNpoXsK5wQzn4=;
        b=afkp4otRO6A5bTr5ZPEOgrtEc8NMs1IVSbnClx/Re95KWlSZL9Qgt9aqoYawT+MaYT
         lTzFA3r0bTVG4nUYgvFndIV+mHxejZrQ+/6CPy0kQ1hJCbQXtOXiOx1s74PGZhvc4E6s
         0YxamIIxQUswMDyF4KqypHiQa/Y5vZeMA8felg1hHHuO/OMDmnN99kZC7NdkUJUATA02
         HyMF/IUq7EVMCSqRxDa6/nGJPg7C+XYbRXUAX1hbjDD7v1MBINqvYTiP26Yef3843PiJ
         yfawSiPmKpiDagPdUsx8Peb9hPqpu8XvJn1l+LZURaNBbswVCxUKrTcn6WbO4EVU4dyU
         ia9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWsqzCy81tqAjUpFPI0aNYjae3n4379PpErqvVUfJ5ifaO/L29U/ne7m92vBNcgDWhfOEzzJYQWkZur+At1hg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ4qNAmc1DSn6H91p9+naQMgjioz78vRMdXeIUjRUpdEOmPYWk
	zAHT8mGLPkfad7I5WDVVEJaPNRDawLKFRSMtD2Gt7i6cXKJSjrqf30hCR5VUThnlpCzuxnDfXKu
	COGHoaSZmTT6KbSP3gIFU2x74iJKBMZIQkTMXM3bB+DjPSZfOqVG03cc=
X-Google-Smtp-Source: AGHT+IECteKHpxi6MmX22lU9iC3yWPLGwyVFsV8edsqgi98q2w7G7UUrbW88mAzDjCcpd5uHm2C0wUjuJ8QI4pkW6PlwyhkuMNOw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc7:b0:3a7:e4c7:ad18 with SMTP id
 e9e14a558f8ab-3c2d4e6bce9mr417059805ab.18.1736074161168; Sun, 05 Jan 2025
 02:49:21 -0800 (PST)
Date: Sun, 05 Jan 2025 02:49:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <677a63b1.050a0220.380ff0.000e.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_root_alloc_fake_trans
From: syzbot <syzbot+251e4e8c49656d1d3c25@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    ccb98ccef0e5 Merge tag 'platform-drivers-x86-v6.13-4' of g.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D1607d818580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1c541fa8af5c9cc=
7
dashboard link: https://syzkaller.appspot.com/bug?extid=3D251e4e8c49656d1d3=
c25
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debia=
n) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7fe=
b34a89c2a/non_bootable_disk-ccb98cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/703c842459ce/vmlinux-=
ccb98cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1a8db4bb5dbb/bzI=
mage-ccb98cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+251e4e8c49656d1d3c25@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32775
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=3Derrors=3Dcon=
tinue,metadata_checksum=3Dnone,data_checksum=3Dnone,compression=3Dgzip,degr=
aded,norecovery,reconstruct_alloc,no_data_io
bcachefs (loop0): recovering from clean shutdown, journal seq 10
bcachefs (loop0): Version upgrade required:
Version upgrade from 0.24: unwritten_extents to 1.7: mi_btree_bitmap incomp=
lete
Doing incompatible version upgrade from 0.24: unwritten_extents to 1.13: in=
ode_has_child_snapshots
  running recovery passes: check_allocations,check_alloc_info,check_lrus,ch=
eck_btree_backpointers,check_backpointers_to_extents,check_extents_to_backp=
ointers,check_alloc_to_lru_refs,bucket_gens_init,check_snapshot_trees,check=
_snapshots,check_subvols,check_subvol_children,delete_dead_snapshots,check_=
inodes,check_extents,check_indirect_extents,check_dirents,check_xattrs,chec=
k_root,check_unreachable_inodes,check_subvolume_structure,check_directory_s=
tructure,check_nlinks,set_fs_needs_rebalance
bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): error validating btree node on loop0 at btree extents lev=
el 0/0
  u64s 11 type btree_ptr_v2 18446744073707239423:U64_MAX:U32_MAX len 0 ver =
0: seq c6c25c03258c59c5 written 16 min_key POS_MIN durability: 1 ptr: 0:27:=
0 gen 0 =20
  node offset 0/16 bset u64s 0: incorrect max key SPOS_MAX
bcachefs (loop0): flagging btree extents lost data
error reading btree root extents l=3D0: btree_node_read_error, fixing
bcachefs (loop0): will run btree node scan
bcachefs (loop0): error validating btree node on loop0 at btree inodes leve=
l 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 7589ab5e0c11cc7a writ=
ten 24 min_key POS_MIN durability: 1 ptr: 0:38:0 gen 0 =20
  node offset 0/24: got wrong btree node: got
  btree=3Dinodes l=3D0 seq 18446744073709551615x
  min: POS_MIN
  max: SPOS_MAX
bcachefs (loop0): flagging btree inodes lost data
error reading btree root inodes l=3D0: btree_node_read_error, fixing
bcachefs (loop0): error validating btree node on loop0 at btree dirents lev=
el 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 9aa2895aefce4bdf writ=
ten 24 min_key POS_MIN durability: 1 ptr: 0:41:0 gen 0 =20
  node offset 0/24: bad magic: want 59513f585d347cd2, got 0
bcachefs (loop0): flagging btree dirents lost data
error reading btree root dirents l=3D0: btree_node_read_error, fixing
bcachefs (loop0): error validating btree node on loop0 at btree deleted_ino=
des level 0/0
  u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq 1db8f60c84bb244c writ=
ten 8 min_key POS_MIN durability: 1 ptr: 0:42:0 gen 0 =20
  node offset 0/8: bad magic: want 59513f585d347cd2, got 0
bcachefs (loop0): flagging btree deleted_inodes lost data
error reading btree root deleted_inodes l=3D0: btree_node_read_error, fixin=
g
bcachefs (loop0): scan_for_btree_nodes...
bch2_scan_for_btree_nodes: nodes found after overwrites:
  extents l=3D0 seq=3D1 journal_seq=3D5 cookie=3Dc6c25c03258c59c5 POS_MIN-S=
POS_MAX ptr: 0:27:0 gen 0
  xattrs l=3D0 seq=3D1 journal_seq=3D4 cookie=3D2285c34bed0abe32 POS_MIN-SP=
OS_MAX ptr: 0:31:0 gen 0
  subvolumes l=3D0 seq=3D1 journal_seq=3D1 cookie=3Dc0bef60d07ceb940 POS_MI=
N-SPOS_MAX ptr: 0:35:0 gen 0
  snapshots l=3D0 seq=3D1 journal_seq=3D1 cookie=3Debb8d5a9e3463bdb POS_MIN=
-SPOS_MAX ptr: 0:32:0 gen 0
  lru l=3D0 seq=3D1 journal_seq=3D5 cookie=3D28f61e078e70b95c POS_MIN-SPOS_=
MAX ptr: 0:28:0 gen 0
 done
bcachefs (loop0): check_topology...
bcachefs (loop0): btree root extents unreadable, must recover from scan
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_update_interior.c:2559!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5315 Comm: syz.0.0 Not tainted 6.13.0-rc5-syzkaller-0000=
4-gccb98ccef0e5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_root_alloc_fake_trans+0xc14/0xc20 fs/bcachefs/btree_up=
date_interior.c:2559
Code: 48 8b 4c 24 30 80 e1 07 38 c1 0f 8c 9e fc ff ff 48 8b 7c 24 30 e8 3c =
db dd fd e9 8f fc ff ff e8 b2 a9 a0 07 e8 ed 73 77 fd 90 <0f> 0b 66 2e 0f 1=
f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d476f20 EFLAGS: 00010287
RAX: ffffffff8427fff3 RBX: 00000000ffffffef RCX: 0000000000100000
RDX: ffffc9000e47a000 RSI: 000000000004fe69 RDI: 000000000004fe6a
RBP: ffffc9000d4771f0 R08: ffffffff8427fc99 R09: 1ffff92001a8edcc
R10: dffffc0000000000 R11: fffff52001a8edcd R12: ffff888052b80000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff888051fdb000
FS:  00007f31a6ff06c0(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb6f4f6028 CR3: 0000000041f34000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_check_topology+0x3b0/0xb20 fs/bcachefs/btree_gc.c:537
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f31a61874ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f31a6fefe68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f31a6fefef0 RCX: 00007f31a61874ca
RDX: 00000000200000c0 RSI: 0000000020000000 RDI: 00007f31a6fefeb0
RBP: 00000000200000c0 R08: 00007f31a6fefef0 R09: 0000000000800000
R10: 0000000000800000 R11: 0000000000000246 R12: 0000000020000000
R13: 00007f31a6fefeb0 R14: 0000000000005983 R15: 0000000020005bc0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_root_alloc_fake_trans+0xc14/0xc20 fs/bcachefs/btree_up=
date_interior.c:2559
Code: 48 8b 4c 24 30 80 e1 07 38 c1 0f 8c 9e fc ff ff 48 8b 7c 24 30 e8 3c =
db dd fd e9 8f fc ff ff e8 b2 a9 a0 07 e8 ed 73 77 fd 90 <0f> 0b 66 2e 0f 1=
f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d476f20 EFLAGS: 00010287
RAX: ffffffff8427fff3 RBX: 00000000ffffffef RCX: 0000000000100000
RDX: ffffc9000e47a000 RSI: 000000000004fe69 RDI: 000000000004fe6a
RBP: ffffc9000d4771f0 R08: ffffffff8427fc99 R09: 1ffff92001a8edcc
R10: dffffc0000000000 R11: fffff52001a8edcd R12: ffff888052b80000
R13: dffffc0000000000 R14: 0000000000000001 R15: ffff888051fdb000
FS:  00007f31a6ff06c0(0000) GS:ffff88801fc00000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055bb6f4f6028 CR3: 0000000041f34000 CR4: 0000000000352ef0
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
