Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911B5226D1F
	for <linux-bcachefs@vger.kernel.org>; Sun, 29 Jun 2025 16:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751216129; cv=none; b=TUqgWDhovzIosG8TJISkzQULyBv1WCazFQj9Sew/MRgp6azfgfXklWTJzxhAn/gSvtOGf3lkhlWsVm2oHKQgn7uYfkC0x6hj8k06z0LfujC/Xn4Jwu0Owyp4uxEdeHzlV44f68Vcww5N8M9O8on/9Lhg/oxYI0iaOI72wyuV57Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751216129; c=relaxed/simple;
	bh=BFnsImxbFEHGpFMp22mbpaUtFKxMygW4sfwKauVlMxw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LZcpI09WJ94XyKNN/hJjtQ/vV9HJCXhhbE8oXYqzwlWQCxtAcPFlOGlXorUQfL8g1WfH+WYEx+x/A2LNlkI4ne/NRZijd6ujWFNXoOBEwOSdd7Omui7J0GVr7z/io0UG+PDbH6G4T1WFgyCJFyIJBCXUk8h05X0BvfIzxoS4IKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3df33d97436so41850295ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Jun 2025 09:55:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751216127; x=1751820927;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYcm++AP3sm05TnQF52y5jv/PpJ0z7tlZbgfT/qsqas=;
        b=FOM10UC+wv1eRSfX+fW6OSOGjHXPPGm8DEIIlIztQLicL0WrFzz03fFPsoD5vCTS/V
         eSmsVgDrUoIVFDbc4eUCzwhEzRXoLi2bn2QlD9uLnc16Z8dlXiGL5oM4ZSYS3zCIJinD
         esZ5br9lD7uiHeD0nhcS+shi1TPQGGcozjsUOymW2s3L+8KYa4Ax8QvfDRJe788aeIEI
         M5bS+9+qT4ccnvZta/lnFdkYei3ggjyP6LpDuJqH61UXgJFsCA1daFTNaMoowuJLYOtk
         zQZQzaOWx/pq0mJvuzclT117oizS8jFKXdJE7ebL8YfrIwHxni8HhP/2MzkMOAMIP11g
         e96Q==
X-Forwarded-Encrypted: i=1; AJvYcCWWyvaHfeOhMdt9OxjZLIpv6mE4R27APXEzHhH3yn54kW/7AK5as/yb63x9G8FMiyR31J3pwo7UTU5iD5n0Mg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywnu9C6uQPzus9a4s4xjinsGm0I0ot6kTsJGfAQc9Jyr+oo5ph8
	icJFBuSiPcXkoLbLNVNfrBFyHehpMnPoquwuUljAoifs5iDLvLGWjA2g1gkw2T/1Ephy8+rVlxI
	/V44n2EAWJHv4J4VD1UMXqLynCt+gqUsLibXJ2Wnz7FWzMJXyAepbf8CN2WU=
X-Google-Smtp-Source: AGHT+IH44g/8TneriTZ//bkZeHwT+Hpsfqeqz9D/JlP58JkZSlCG1e0KrXkdM1VKmRuPRp2wQC8dJkGokxj3jRSL0sml2xh9Olxh
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1527:b0:3dd:b602:88 with SMTP id
 e9e14a558f8ab-3df4b48cdfcmr104634525ab.9.1751216126704; Sun, 29 Jun 2025
 09:55:26 -0700 (PDT)
Date: Sun, 29 Jun 2025 09:55:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68616ffe.a70a0220.2f4de1.001e.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_keys_peek_prev_min
From: syzbot <syzbot+5e43fb34e0478e83681c@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot found the following issue on:

HEAD commit:    7595b66ae9de Merge tag 'selinux-pr-20250624' of git://git..=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D10edd182580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D79da270cec5ffd6=
5
dashboard link: https://syzkaller.appspot.com/bug?extid=3D5e43fb34e0478e836=
81c
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-=
1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-7595b66a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3332acf57c8d/vmlinux-=
7595b66a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e83a48cfe09a/bzI=
mage-7595b66a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+5e43fb34e0478e83681c@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
bcachefs (loop0): starting version 1.7: mi_btree_bitmap opts=3Dmetadata_che=
cksum=3Dcrc64,data_checksum=3Dnone,compression=3Dlz4,journal_flush_disabled=
,fsck,recovery_pass_last=3Dset_may_go_rw,reconstruct_alloc,no_data_io
  allowing incompatible features above 0.0: (unknown version)
  features: lz4,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,n=
ew_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
bcachefs (loop0): Using encoding defined by superblock: utf8-12.1.0
bcachefs (loop0): recovering from clean shutdown, journal seq 10
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
bcachefs (loop0): dropping and reconstructing all alloc info
bcachefs (loop0): accounting_read... done
bcachefs (loop0): alloc_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations... done
bcachefs (loop0): going read-write
bcachefs (loop0): done starting filesystem
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_journal_iter.c:139!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5329 Comm: syz.0.0 Not tainted 6.16.0-rc3-syzkaller-0004=
4-g7595b66ae9de #0 PREEMPT(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_journal_keys_peek_prev_min+0x15e4/0x15f0 fs/bcachefs/btree_j=
ournal_iter.c:139
Code: b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 ff 87 fe fd =
48 8b 1b e9 b6 fe ff ff e8 a2 5f 41 07 e8 1d 05 9b fd 90 <0f> 0b 66 2e 0f 1=
f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d38f1a0 EFLAGS: 00010283
RAX: ffffffff84254803 RBX: ffffffffffffffff RCX: 0000000000100000
RDX: ffffc9000df5a000 RSI: 00000000000337b5 RDI: 00000000000337b6
RBP: ffffc9000d38f380 R08: 00090018ffffffff R09: 2000000000000000
R10: 0000000000000000 R11: 00090018ffffffff R12: ffffc9000d38f9b0
R13: dffffc0000000000 R14: 000000000000003b R15: ffff888052f00000
FS:  00007fe8791aa6c0(0000) GS:ffff88808d251000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1f90184000 CR3: 0000000043c47000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_journal_peek_prev fs/bcachefs/btree_iter.c:2172 [inline]
 btree_trans_peek_prev_journal+0x259/0x3b0 fs/bcachefs/btree_iter.c:2186
 __bch2_btree_iter_peek_prev fs/bcachefs/btree_iter.c:2560 [inline]
 bch2_btree_iter_peek_prev_min+0x1439/0x5400 fs/bcachefs/btree_iter.c:2635
 __bch2_resume_logged_op_finsert+0x7fc/0x2240 fs/bcachefs/io_misc.c:432
 bch2_fcollapse_finsert+0x19b/0x250 fs/bcachefs/io_misc.c:536
 bchfs_fcollapse_finsert+0x378/0x470 fs/bcachefs/fs-io.c:621
 bch2_fallocate_dispatch+0x2a4/0x410 fs/bcachefs/fs-io.c:-1
 vfs_fallocate+0x6a0/0x830 fs/open.c:341
 ksys_fallocate fs/open.c:365 [inline]
 __do_sys_fallocate fs/open.c:370 [inline]
 __se_sys_fallocate fs/open.c:368 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:368
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe87838e929
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe8791aa038 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007fe8785b5fa0 RCX: 00007fe87838e929
RDX: 0000000000000000 RSI: 0000000000000020 RDI: 000000000000000a
RBP: 00007fe878410b39 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000007000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fe8785b5fa0 R15: 00007ffc77682dc8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_journal_keys_peek_prev_min+0x15e4/0x15f0 fs/bcachefs/btree_j=
ournal_iter.c:139
Code: b9 00 00 00 00 00 fc ff df 80 3c 08 00 74 08 48 89 df e8 ff 87 fe fd =
48 8b 1b e9 b6 fe ff ff e8 a2 5f 41 07 e8 1d 05 9b fd 90 <0f> 0b 66 2e 0f 1=
f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d38f1a0 EFLAGS: 00010283
RAX: ffffffff84254803 RBX: ffffffffffffffff RCX: 0000000000100000
RDX: ffffc9000df5a000 RSI: 00000000000337b5 RDI: 00000000000337b6
RBP: ffffc9000d38f380 R08: 00090018ffffffff R09: 2000000000000000
R10: 0000000000000000 R11: 00090018ffffffff R12: ffffc9000d38f9b0
R13: dffffc0000000000 R14: 000000000000003b R15: ffff888052f00000
FS:  00007fe8791aa6c0(0000) GS:ffff88808d251000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe8783ec970 CR3: 0000000043c47000 CR4: 0000000000352ef0
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
