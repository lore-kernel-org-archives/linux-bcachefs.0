Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1995F14E2E6
	for <linux-bcachefs@vger.kernel.org>; Thu, 26 Dec 2024 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735195405; cv=none; b=aQQW9nP2NrD3ENebRoEeOvZWNQeIErB0MP3IoLt7WT6dcRYRM5vWqEfhqyLNwrvbCJ0fglnuzYPG6b+jNdRYj50P2f6kvBsiWRUFaP8OZnllaumB7Ww9MqgjbCNVbXGvxjuelUlda3Xbv8HzVcvBraHfp7FdEvLkljJE5KSDjBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735195405; c=relaxed/simple;
	bh=81QFhsbyQRqwwcnMDRXHme+/A2x+4yS5Vc04KZC+s9Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=H0VvU4/a/6HLvOOlR8GKyr0QT4TDn7YldPoBz1q7OubNLvRnLEhX8fb2MvOCY9DevcFBqZUu03PCg+RGuI+TSArjdDJtunmVdUEsY+QeRKLWKxlAi1PyEk4bF/PYkDoT93mFrHej0ZC3QzEwhDrbAKlSUf5UfIO3UhRSOGktBlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a814c7d58eso62210045ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 25 Dec 2024 22:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735195403; x=1735800203;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X2VQeufeerpJYlSwszd6z0TNJSBGjt00IENvwa6IrRI=;
        b=Vj+SkQh+kydkA+HCylL9GYhwNQZ1Tecs/BJwY8Z2FV+MEA+7zUoZUwXOI1Zhj0BQgo
         3txwDhFIiqo8StCMqepwx7OqB/29tUynBSWFhu7EQFVZeg85hutLuP0byhKb1Yw9JDRK
         29tTGKAjelJPRkhcDf7JqDB0oYMZQKeY9eplfJvqk6KN4SALUnr9GcDDswgL7KdGAoyn
         up3qZRVnFXLgdlxYnzbBMtBkMxB3ySW7Xk9Xe7S/Du9T9bofSDq3M15TrGhYjo+0/eJ4
         1XDWbxMxINGtyHDOTCUq+QjOhu8j1/iJ6mSnzDKzo4pQVlSLf7grF0wKXtvGJtzd6ar1
         yiWg==
X-Forwarded-Encrypted: i=1; AJvYcCVl39KzBvp0iIuAbi2CngGdVAYcHFMZEtOQJECSFYYOP79KPUWeqXgQ/63xWC4GL3js/uwD6bJVTU3zbGeqQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwuI9KQp2XUt1Z+cW+o6fkS4xgu2h0Xo4pq3DpZO0hQGudR2KjI
	6a07XcDCZ4uDEk14fvlR409d0fRfxwWt3YLEnt+jAN6/IuzQqs0vYOKae4nAvt0o6JTGkIHzuGF
	l02dBU6KdLPQCVOuKnOQHO8Cy5b/gDYwKmPGaUtC91571iTt9TZr2sis=
X-Google-Smtp-Source: AGHT+IFwR41UVDHb/efJAO2736ZUaQluynvE0gEgsTKUPm1TcrlUxVJh7mnx1SdOg1GZYMUS+fs2vbqDAzoJGL1MACPdjtpr14iA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:184c:b0:3a7:635e:d365 with SMTP id
 e9e14a558f8ab-3c2d25669c7mr195991585ab.6.1735195403239; Wed, 25 Dec 2024
 22:43:23 -0800 (PST)
Date: Wed, 25 Dec 2024 22:43:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676cfb0b.050a0220.2f3838.042a.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __bkey_unpack_pos (2)
From: syzbot <syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4bbf9020becb Linux 6.13-rc4
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=167d3f30580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d269ef41b9262400
dashboard link: https://syzkaller.appspot.com/bug?extid=c5e7a66b3b23ae65d44f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fd3fe8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13fd3fe8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-4bbf9020.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7afd8269bdaf/vmlinux-4bbf9020.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a3b5b5de34f1/bzImage-4bbf9020.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/63f4c8c02183/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c5e7a66b3b23ae65d44f@syzkaller.appspotmail.com

bcachefs (loop0): alloc_read... done
bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/bkey.c:298!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5299 Comm: syz-executor313 Not tainted 6.13.0-rc4-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__bkey_unpack_pos+0x781/0x790 fs/bcachefs/bkey.c:298
Code: e8 74 9f 89 fd 48 c7 c7 80 fa f2 8e 4c 89 e6 48 89 da e8 b2 ea e4 00 e9 f4 fc ff ff e8 58 9f 89 fd 90 0f 0b e8 50 9f 89 fd 90 <0f> 0b e8 48 9f 89 fd 90 0f 0b 0f 1f 44 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d01e2c0 EFLAGS: 00010293
RAX: ffffffff8415d4e0 RBX: 0000000000000003 RCX: ffff88801ab70000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8415ce35 R09: 0000000000000000
R10: ffffc9000d01e380 R11: fffff52001a03c72 R12: ffffc9000d01e380
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804b901060
FS:  0000555573836380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcd6804fa8 CR3: 0000000044000000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bkey_unpack_pos_format_checked fs/bcachefs/bkey.h:456 [inline]
 bkey_unpack_pos fs/bcachefs/bkey.h:464 [inline]
 __bch2_bkey_cmp_packed_format_checked_inlined fs/bcachefs/bkey_cmp.h:103 [inline]
 __bch2_bkey_cmp_packed_format_checked+0x2c7/0x800 fs/bcachefs/bkey.c:1020
 bkey_cmp_p_or_unp fs/bcachefs/bset.h:291 [inline]
 bkey_iter_cmp_p_or_unp fs/bcachefs/bset.h:400 [inline]
 bch2_bset_search_linear fs/bcachefs/bset.c:1189 [inline]
 bch2_btree_node_iter_init+0x234b/0x4280 fs/bcachefs/bset.c:1334
 __bch2_btree_path_set_pos+0xb8e/0x1710 fs/bcachefs/btree_iter.c:1302
 bch2_btree_path_set_pos fs/bcachefs/btree_iter.h:229 [inline]
 bch2_btree_iter_peek_node+0x7c5/0xed0 fs/bcachefs/btree_iter.c:1915
 bch2_gc_btree fs/bcachefs/btree_gc.c:686 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x2125/0x7070 fs/bcachefs/btree_gc.c:1133
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
RIP: 0033:0x7fa1db696b7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc50c8acf8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc50c8ad10 RCX: 00007fa1db696b7a
RDX: 00000000200002c0 RSI: 0000000020000380 RDI: 00007ffc50c8ad10
RBP: 0000000000000004 R08: 00007ffc50c8ad50 R09: 0000000000005931
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffc50c8ad50 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__bkey_unpack_pos+0x781/0x790 fs/bcachefs/bkey.c:298
Code: e8 74 9f 89 fd 48 c7 c7 80 fa f2 8e 4c 89 e6 48 89 da e8 b2 ea e4 00 e9 f4 fc ff ff e8 58 9f 89 fd 90 0f 0b e8 50 9f 89 fd 90 <0f> 0b e8 48 9f 89 fd 90 0f 0b 0f 1f 44 00 00 90 90 90 90 90 90 90
RSP: 0018:ffffc9000d01e2c0 EFLAGS: 00010293
RAX: ffffffff8415d4e0 RBX: 0000000000000003 RCX: ffff88801ab70000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff8415ce35 R09: 0000000000000000
R10: ffffc9000d01e380 R11: fffff52001a03c72 R12: ffffc9000d01e380
R13: dffffc0000000000 R14: 0000000000000000 R15: ffff88804b901060
FS:  0000555573836380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcd6804fa8 CR3: 0000000044000000 CR4: 0000000000352ef0
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
