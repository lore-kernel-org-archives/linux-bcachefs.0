Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D1318AE2
	for <linux-bcachefs@vger.kernel.org>; Sat, 14 Dec 2024 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734189861; cv=none; b=YagusYfcosS+73ygr67AupiO/b/4VaBTdSH5H0DHu6ghbC2oafhoCZtSATrkMPB1q328X4ghgNl3kq0OrJYK7LfWEFgIl90IKzuJmTdn40Rgh0oMv7syGNGbTVxM9x0xQmXxhjIPNKuV4mv7yNNpADcBforEdjevg4QYdOECnw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734189861; c=relaxed/simple;
	bh=E04lj5yVOBeqzKs3dKQDd09YtbOM9I/Ppznf2nKrfqw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MIti14OeQTnV7nCyWhrIYSsbnCYp7kGsuEC6U2VbJCXoMu2NY2DbC8OIraXxEc0SUoR++7+pxPJzUZiBxIsK9Vdkw/ZNqgEnMuVrUCCa2/MeZHNy5QtpgQsF5k7Mstx06/zCwqgXmSMjyBqjXcxYakdz0MAF15zXiM56MNHf9oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3a7e39b48a2so58649025ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 14 Dec 2024 07:24:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734189859; x=1734794659;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BmDIZLrgcnrv8iO3MIxVYMYuhuOMUFS5dSYpnyBnZR8=;
        b=FkodSTA44zdtmD/G4eQRPc/z+HIaJ8dzmz9c49gvLb6ERWZIY5qF2Nm1qHbM9YbLzW
         w726Q02pn8GW8sTvrDVZA9vYE0Y5idHi+yast8EIFsx+327UOgRbHs/f2EeAaDajlbVW
         M3p0LBDIsJx8+NWNfgp/RldgZKz19nxp3BOutyRyxnHcnBwvvJw9pb2vtydR3HjJVvct
         98NWYjDtETzXVFz1TP24ZLCawIzfQQCDpFfAT1o6Jk/6ExNe8Ws0cVh/cpCz43uRxMOj
         7aS1EhRZt8wD3+WSR9itoXrZ0KUSx5hJZIz+/PqYXI+CBzCWigz14N4aMjxI5UObpFHz
         prUQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1nqPWwwgYee9ZTIsls5XDVqFgrsllKiJoxtLqcEl6ir9BclAucNwSjLP5f4CL76m09qzf92Ooc8vHG1g/xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzldcTP7vc8BGd8CoPDJC/e6Go1T5FVVWhh+d7b16xy2Hpie2V1
	FdvDei+cEmT6AodVq6qvyYmFYt/A5jQ7PLXUDPPNvs2SJCr9akryOv/2Cu/TmWYjT4hkZ3owkD6
	yUuEOJGTZQX/QmQV4/HPnNuuVUNit5yY83M5dsgLlKTFWBhVVVQRfR6Y=
X-Google-Smtp-Source: AGHT+IFFBA0tQ/oCgKqM5c1Jvx7L9OYHGlEz41cvPK8xsfWMtQ21ksu5kO54OatTLBh8/lfLFjSOcvbyo5JyRH6Qditx9D8V+6KW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1708:b0:3a7:dd45:bca1 with SMTP id
 e9e14a558f8ab-3aff068290emr71726515ab.17.1734189859487; Sat, 14 Dec 2024
 07:24:19 -0800 (PST)
Date: Sat, 14 Dec 2024 07:24:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675da323.050a0220.37aaf.00cb.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __build_ro_aux_tree
From: syzbot <syzbot+4e2c4a191f656919fda2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7cb1b4663150 Merge tag 'locking_urgent_for_v6.13_rc3' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120feb30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fee25f93665c89ac
dashboard link: https://syzkaller.appspot.com/bug?extid=4e2c4a191f656919fda2
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7cb1b466.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/13e083329dab/vmlinux-7cb1b466.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fe3847d08513/bzImage-7cb1b466.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4e2c4a191f656919fda2@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/bset.c:644!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 48 Comm: kworker/u5:0 Not tainted 6.13.0-rc2-syzkaller-00018-g7cb1b4663150 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: bcachefs bch2_write_point_do_index_updates
RIP: 0010:make_bfloat fs/bcachefs/bset.c:644 [inline]
RIP: 0010:__build_ro_aux_tree+0x1a84/0x1aa0 fs/bcachefs/bset.c:742
Code: 62 59 88 fd 90 0f 0b e8 5a 59 88 fd 90 0f 0b e8 52 59 88 fd 90 0f 0b e8 1a 04 b1 07 e8 45 59 88 fd 90 0f 0b e8 3d 59 88 fd 90 <0f> 0b e8 35 59 88 fd 90 0f 0b e8 2d 59 88 fd 90 0f 0b 66 2e 0f 1f
RSP: 0018:ffffc900006367e0 EFLAGS: 00010293
RAX: ffffffff84170503 RBX: 0000000000000140 RCX: ffff88801e10c880
RDX: 0000000000000000 RSI: 0000000000000130 RDI: 00000000000000fe
RBP: ffffc90000636a18 R08: ffffffff8416fbb8 R09: ffffffff8417deca
R10: 0000000000000002 R11: ffff88801e10c880 R12: 0000000000000130
R13: 0000000000000001 R14: ffff888046cf9404 R15: 0000000000000090
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000411b0000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_bset_build_aux_tree+0x4d1/0x6c0 fs/bcachefs/bset.c:779
 bch2_btree_build_aux_trees fs/bcachefs/btree_io.c:448 [inline]
 bch2_drop_whiteouts+0x127b/0x1510 fs/bcachefs/btree_io.c:283
 bch2_btree_post_write_cleanup+0x135/0xa70 fs/bcachefs/btree_io.c:2251
 bch2_btree_node_write+0x169/0x1f0 fs/bcachefs/btree_io.c:2289
 btree_split+0x5400/0x6ba0 fs/bcachefs/btree_update_interior.c:1711
 bch2_btree_split_leaf+0x14f/0x840 fs/bcachefs/btree_update_interior.c:1862
 bch2_trans_commit_error+0x212/0x1380 fs/bcachefs/btree_trans_commit.c:942
 __bch2_trans_commit+0x7ead/0x93c0 fs/bcachefs/btree_trans_commit.c:1140
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_extent_update+0x4c0/0xbb0 fs/bcachefs/io_write.c:325
 bch2_write_index_default fs/bcachefs/io_write.c:373 [inline]
 __bch2_write_index+0xed2/0x2140 fs/bcachefs/io_write.c:526
 bch2_write_point_do_index_updates+0x32e/0x690 fs/bcachefs/io_write.c:635
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:make_bfloat fs/bcachefs/bset.c:644 [inline]
RIP: 0010:__build_ro_aux_tree+0x1a84/0x1aa0 fs/bcachefs/bset.c:742
Code: 62 59 88 fd 90 0f 0b e8 5a 59 88 fd 90 0f 0b e8 52 59 88 fd 90 0f 0b e8 1a 04 b1 07 e8 45 59 88 fd 90 0f 0b e8 3d 59 88 fd 90 <0f> 0b e8 35 59 88 fd 90 0f 0b e8 2d 59 88 fd 90 0f 0b 66 2e 0f 1f
RSP: 0018:ffffc900006367e0 EFLAGS: 00010293
RAX: ffffffff84170503 RBX: 0000000000000140 RCX: ffff88801e10c880
RDX: 0000000000000000 RSI: 0000000000000130 RDI: 00000000000000fe
RBP: ffffc90000636a18 R08: ffffffff8416fbb8 R09: ffffffff8417deca
R10: 0000000000000002 R11: ffff88801e10c880 R12: 0000000000000130
R13: 0000000000000001 R14: ffff888046cf9404 R15: 0000000000000090
FS:  0000000000000000(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000011874000 CR4: 0000000000352ef0
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
