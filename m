Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639F51442F4
	for <linux-bcachefs@vger.kernel.org>; Mon, 30 Dec 2024 04:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735533201; cv=none; b=jec5sJ0AEPmddW2LWDtjfROEntwYPyz7yzY3d3t7G1c8XHLG3n2rS7Yxhc/M+hzGINZ1To/F1iVe+1qtQZUX1kpiLt1lG2kbZHgG8o681O2+zx9yRTwkh3ayX6Fzrg1L6+nUnIyHbVSvUsnQ6aKGWg5nqa/O0kZ+tw0uz8FtJ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735533201; c=relaxed/simple;
	bh=v86r9/9cI4Jt5yRIc4N/VWJokoehDO79ci19KhvKnYQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=bA3vClRUelkxd4cTwqNv6M2rt4agBcC97H7sdisz1wv6aPjWrdNdxGmG3QXHLsfQRqBEyx7P1ciw/eB3rZ8GzxpzYLinipE60CtxfvGCy/79eDbpQGfVUS2FpES+QlKF5ise7jKk+fZbsH0P+w2/2rJ5PSNmYv/6TP23sJPenqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ab68717b73so84990385ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 29 Dec 2024 20:33:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735533198; x=1736137998;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1elTmEA1M/pFfqZH4qiTJZWKUvQ5VKAEUQDfCt4+Q7o=;
        b=ezB2LbLfAKgHUV4/dQ6zp8hagm3V3bY7mqoeOltJjQmDKFtBVSu2sUAU/ungY3URxT
         xpitcyTuirt/m9PbBX/zc0S+6qiCbnn5r9SE7vV6i1BQ0lpR71rHIaTLK8TERTyK9STA
         bu2x7iRjD7W8A5p439qZPCA1WENHbS/deO5TMQsQlVfkt3mX3Snx4mLYQ/TEFdJQHqmQ
         VUr8MMe2VJXZLNMkybEnUziIIkCsz77emRwbtI3667QP6XiLcE5yqnI5zemUtBl+bIYD
         vOZPPOpmLOFbG6n9ZKoKcmJj5DxTQV0untyTJxrYQFDdxqKEmhwY1DxHE5kTgo/8AaMx
         TG1g==
X-Forwarded-Encrypted: i=1; AJvYcCVG7psxB7BTa1vOTtMFnf/2+M+dxBVmxLySUf3KGEZ7mZI6TdJyahDmW5hIcRg/w5VdQ8c5fQw4WLQ5vDo/tg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxS2goDomPbHi5hZ4fhdlL7lJtORWehtX/RhJ7MM/YAjQ1Zu23/
	ydkV/piZrAQwZMcJwe6ZuPJXlC9ujOTV0xjpOJ71R5IO7jnoNCsNabZbvTmxaFQsIorixRFXs6i
	WivgcKyyiNRf6z3mktDcZgmIQgDqBH2PlqI/rzp7mgxyLCZW6lLeYxsE=
X-Google-Smtp-Source: AGHT+IHQv9RRnm5I4+TrzbqsROLhvjE2uzrljKnfH+VZ9bvZjHlX3OFy1Bkuqni7p3rG8aMMrF/cE1MesFlpMVhieucd18hmDUf9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9c:b0:3a7:87f2:b010 with SMTP id
 e9e14a558f8ab-3c2d1aa2b54mr275577795ab.5.1735533198621; Sun, 29 Dec 2024
 20:33:18 -0800 (PST)
Date: Sun, 29 Dec 2024 20:33:18 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6772228e.050a0220.2f3838.04b8.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_stripe_validate
From: syzbot <syzbot+f57d864a5d6eff90da3b@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9b2ffa6148b1 Merge tag 'mtd/fixes-for-6.13-rc5' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1007fcc4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d269ef41b9262400
dashboard link: https://syzkaller.appspot.com/bug?extid=f57d864a5d6eff90da3b
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11ef62f8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14464018580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-9b2ffa61.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ddc85002bb5c/vmlinux-9b2ffa61.xz
kernel image: https://storage.googleapis.com/syzbot-assets/dd33dcda671f/bzImage-9b2ffa61.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/cceaa17c84e3/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f57d864a5d6eff90da3b@syzkaller.appspotmail.com

    u64s 3 fields 2:0, 0:0, 0:0, 0:0, 0:0, 0:0
bcachefs (loop0): flagging btree freespace lost data
error reading btree root freespace l=0: btree_node_read_error, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/ec.h:35!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5300 Comm: syz-executor271 Not tainted 6.13.0-rc4-syzkaller-00012-g9b2ffa6148b1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:stripe_csum_offset fs/bcachefs/ec.h:35 [inline]
RIP: 0010:stripe_blockcount_offset fs/bcachefs/ec.h:47 [inline]
RIP: 0010:stripe_val_u64s fs/bcachefs/ec.h:67 [inline]
RIP: 0010:bch2_stripe_validate+0x639/0x680 fs/bcachefs/ec.c:122
Code: 3d 3d 6f fd e9 76 fc ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 53 fd ff ff 4c 89 ff e8 42 a4 d5 fd e9 46 fd ff ff e8 18 3d 6f fd 90 <0f> 0b e8 10 3d 6f fd 90 0f 0b 44 89 e1 80 e1 07 38 c1 7c ab 4c 89
RSP: 0018:ffffc9000cff69f8 EFLAGS: 00010293
RAX: ffffffff84303718 RBX: 0000000000000008 RCX: ffff88800015a440
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000007
RBP: 00000000ffffffff R08: ffffffff843032d9 R09: 1ffff11009090035
R10: dffffc0000000000 R11: ffffffff843030e0 R12: 0000000000000000
R13: 0000000000000009 R14: ffff8880427a00b8 R15: ffffc9000cff6e40
FS:  0000555571cbf380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe5a7e6df8 CR3: 00000000331d6000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_node_read_done+0x3e7e/0x5e90 fs/bcachefs/btree_io.c:1219
 btree_node_read_work+0x68b/0x1260 fs/bcachefs/btree_io.c:1323
 bch2_btree_node_read+0x2433/0x29f0
 __bch2_btree_root_read fs/bcachefs/btree_io.c:1749 [inline]
 bch2_btree_root_read+0x617/0x7a0 fs/bcachefs/btree_io.c:1771
 read_btree_roots+0x296/0x840 fs/bcachefs/recovery.c:523
 bch2_fs_recovery+0x2585/0x39d0 fs/bcachefs/recovery.c:853
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
RIP: 0033:0x7f3bcf61cb7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff9b9291b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fff9b9291d0 RCX: 00007f3bcf61cb7a
RDX: 0000000020000040 RSI: 0000000020000080 RDI: 00007fff9b9291d0
RBP: 0000000000000010 R08: 00007fff9b929210 R09: 0000000000005998
R10: 0000000000000010 R11: 0000000000000282 R12: 0000000000000004
R13: 00007fff9b929210 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:stripe_csum_offset fs/bcachefs/ec.h:35 [inline]
RIP: 0010:stripe_blockcount_offset fs/bcachefs/ec.h:47 [inline]
RIP: 0010:stripe_val_u64s fs/bcachefs/ec.h:67 [inline]
RIP: 0010:bch2_stripe_validate+0x639/0x680 fs/bcachefs/ec.c:122
Code: 3d 3d 6f fd e9 76 fc ff ff 44 89 f9 80 e1 07 38 c1 0f 8c 53 fd ff ff 4c 89 ff e8 42 a4 d5 fd e9 46 fd ff ff e8 18 3d 6f fd 90 <0f> 0b e8 10 3d 6f fd 90 0f 0b 44 89 e1 80 e1 07 38 c1 7c ab 4c 89
RSP: 0018:ffffc9000cff69f8 EFLAGS: 00010293
RAX: ffffffff84303718 RBX: 0000000000000008 RCX: ffff88800015a440
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000007
RBP: 00000000ffffffff R08: ffffffff843032d9 R09: 1ffff11009090035
R10: dffffc0000000000 R11: ffffffff843030e0 R12: 0000000000000000
R13: 0000000000000009 R14: ffff8880427a00b8 R15: ffffc9000cff6e40
FS:  0000555571cbf380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000559fb55d9028 CR3: 00000000331d6000 CR4: 0000000000352ef0
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
