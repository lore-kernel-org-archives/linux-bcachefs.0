Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E702737703
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727044580; cv=none; b=Kbt0wFWud4Mff70UhiSaM/LvFMxX2Jh9+USbM1GTLwfrJFDafDaMYSNJtgj4iUC/hzVUTewR+86QwphgaU6OlX+C195YlcaL77L+mGUoO0sRAnVjGb/mjHQqnlfxUfGb0uGo4MJTGDXIJjO12uGmCgRkqlb7t2upxVg5lFMpmgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727044580; c=relaxed/simple;
	bh=rrztqsF7OwV8X/8o/MH2nesdKEqI0oNje9Kh9RGNGfQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=btWnwySvswtRddZoT9hxAQxaoJPROpQ55r0RcTiLAjqdyiM3gPapRXAxEefJk4LsTFizEzOhm6QXhlu6O5EBcjAI72k+7pqWLKVLHtO3nTrlx0+NuvkXGNuMGIG77u025V2yL6ZuNbivkiIeiu/CwLFT+3Vmk8Ak9rBGoOtwyPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-39f4e119c57so36879005ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 15:36:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727044578; x=1727649378;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iL62wxxyf2BpRpsU5hflOQFY9hc2nxQLvKroPtdHQxE=;
        b=TSLClskTnK7oFoEDatuGhsOscByFvf8ZTkYPulGySxK7a8phb6H7bH5QK/UZEDymmH
         z0a0hiJ/n8qvloInH/rRCls7Yz6XGjKlFCz+etMlilehVy7Nn9haO5NP4YAfXhIo2bY2
         mcF2E7YawuBNQ+iRa6cpBO5vSUC19u+Q7lQIMNh3XYu1peAHANrj1zeCveAa/V8SZrWo
         l5q6G8UBQeiIrsdkVUixgo2BkDFbfVFmp5ZjrlRNFo2/XZmFSHMf1OcJ5exUUtOdmvkp
         dp/FTQEzpgqz1WExcGA8giF+nB/YLzU/z5Ce7cZiR51r39lJu7CpZD/eV/p4Ppz+KNzX
         vqVg==
X-Forwarded-Encrypted: i=1; AJvYcCVcVgNW7K9vjxEBdg+BU4cN0pteJ1HSDUAtKLIXMNNYMNK+aFI58MyMRfrh//1o29qQGdTL4uJzTYjSq3hLtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqNPU76F0QpvaVvuQDya5AyE0v7y7WanFkDbFFxNXxCo9jpbxJ
	N9/ExE324q+9Lx694/rlQ0PTCJ47r5dLdCmOiBr9CN2We2LrDVO/tGlOmdFiNqTjUvIBvWfmGwi
	T5q+COg+bpaw0rHOaSkWyfn2mpEjc9nJOqwTQBwZnGVvdKFB2zEfgo8M=
X-Google-Smtp-Source: AGHT+IH9jWsMkXxh99DaVhP2wGXf9XeHPJzHQmMixq0twgjJbVBWeGbGgFkzeauvMQJbn3iEZOuiuTv5RlHFs6t+4DKFYhXfKeb7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1648:b0:39f:7a06:2a62 with SMTP id
 e9e14a558f8ab-3a0c8c5d451mr84764035ab.5.1727044578080; Sun, 22 Sep 2024
 15:36:18 -0700 (PDT)
Date: Sun, 22 Sep 2024 15:36:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f09be2.050a0220.a27de.0008.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_btree_iter_verify_entry_exit (2)
From: syzbot <syzbot+dc1f3e7147b8fc81e0ac@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4a39ac5b7d62 Merge tag 'random-6.12-rc1-for-linus' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12caffc7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dd14c10ec1b6af25
dashboard link: https://syzkaller.appspot.com/bug?extid=dc1f3e7147b8fc81e0ac
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130c4b00580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129f269f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-4a39ac5b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e77a3b8ac098/vmlinux-4a39ac5b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f8ee7a5fea46/bzImage-4a39ac5b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/01f24a788ecc/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dc1f3e7147b8fc81e0ac@syzkaller.appspotmail.com

  u64s 7 type reflink_p POS_MIN len 0 ver 0: idx 18446744069414584320 front_pad 4096 back_pad 0
  missing range 18446744069414580224-18446744069414584320, fixing
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_iter.c:268!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5096 Comm: syz-executor359 Not tainted 6.11.0-syzkaller-05319-g4a39ac5b7d62 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:bch2_btree_iter_verify_entry_exit+0x51b/0x550 fs/bcachefs/btree_iter.c:267
Code: c1 fd ff ff 44 89 e1 80 e1 07 38 c1 0f 8c c6 fd ff ff be 08 00 00 00 4c 89 e7 e8 30 01 e7 fd e9 b4 fd ff ff e8 b6 7c 7f fd 90 <0f> 0b e8 ae 7c 7f fd 90 0f 0b e8 a6 7c 7f fd 90 0f 0b e8 9e 7c 7f
RSP: 0018:ffffc90002e5d958 EFLAGS: 00010293
RAX: ffffffff8414624a RBX: 0000000000000992 RCX: ffff88801edbc880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84145db0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90002e5dfd0
R13: 0000000000000000 R14: ffffc90002e5dfe0 R15: dffffc0000000000
FS:  000055559175c380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005572bbd324a8 CR3: 0000000000b40000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_iter_peek_upto+0x600/0x6f90 fs/bcachefs/btree_iter.c:2281
 bch2_trans_update_extent fs/bcachefs/btree_update.c:299 [inline]
 bch2_trans_update+0x5f9/0x2550 fs/bcachefs/btree_update.c:514
 bch2_btree_insert_trans+0x26f/0x550 fs/bcachefs/btree_update.c:646
 gc_trigger_reflink_p_segment fs/bcachefs/reflink.c:195 [inline]
 __trigger_reflink_p+0x2a08/0x2ec0 fs/bcachefs/reflink.c:234
 bch2_trigger_reflink_p+0x297/0x380 fs/bcachefs/reflink.c:253
 bch2_key_trigger fs/bcachefs/bkey_methods.h:87 [inline]
 bch2_gc_mark_key+0x6b5/0x10e0 fs/bcachefs/btree_gc.c:633
 bch2_gc_btree fs/bcachefs/btree_gc.c:669 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:728 [inline]
 bch2_check_allocations+0x1d1b/0x7870 fs/bcachefs/btree_gc.c:1135
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:183
 bch2_run_recovery_passes+0x19e/0x820 fs/bcachefs/recovery_passes.c:230
 bch2_fs_recovery+0x24f9/0x38b0 fs/bcachefs/recovery.c:859
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1036
 bch2_fs_get_tree+0xd61/0x1700 fs/bcachefs/fs.c:1956
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fea8a61c1ea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd032097c8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd032097e0 RCX: 00007fea8a61c1ea
RDX: 0000000020005d80 RSI: 0000000020000000 RDI: 00007ffd032097e0
RBP: 0000000000000004 R08: 00007ffd03209820 R09: 0000000000005d93
R10: 0000000000000008 R11: 0000000000000282 R12: 0000000000000008
R13: 00007ffd03209820 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_btree_iter_verify_entry_exit+0x51b/0x550 fs/bcachefs/btree_iter.c:267
Code: c1 fd ff ff 44 89 e1 80 e1 07 38 c1 0f 8c c6 fd ff ff be 08 00 00 00 4c 89 e7 e8 30 01 e7 fd e9 b4 fd ff ff e8 b6 7c 7f fd 90 <0f> 0b e8 ae 7c 7f fd 90 0f 0b e8 a6 7c 7f fd 90 0f 0b e8 9e 7c 7f
RSP: 0018:ffffc90002e5d958 EFLAGS: 00010293
RAX: ffffffff8414624a RBX: 0000000000000992 RCX: ffff88801edbc880
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84145db0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffffc90002e5dfd0
R13: 0000000000000000 R14: ffffc90002e5dfe0 R15: dffffc0000000000
FS:  000055559175c380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c54a0790f8 CR3: 0000000000b40000 CR4: 0000000000350ef0
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
