Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626352063C0
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 Jan 2025 03:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737775768; cv=none; b=SIHRia7KgqM0x3JzV2uCP7OYCrAFLKZh4L3YLSxYhvLYVmKgybVtnLCXL24wF5k9JS7cNSiIDeOMIn/uovIZO6wNu2CGN4M4gg7B5rtipVIliVt/AQa4xB0RijeB2jJjOnAaLtOqZnuyuix6eyZnFc6Vd5ChlhSSGBoAG635eEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737775768; c=relaxed/simple;
	bh=3CA6UsB5qUYNEHVDM63Y85h6dbiX8N1YbN0QdG6cxyk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WUAbAWyKZguIfCiBk0DPyGCK3NFQdhzUcBVr9qZHGKIeDBU1Zx+9Mmll8EU+ChGCHtW0NqWxpugtkKoZcP6QfIXrBlgsRCglXaBy0OYLSTvCHvBkBuVPGMUZkxND+DXmXuFwoo/OwLOGoFkWAwo6jD+A/uGVMGqaSLvJmSfCvaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a7e0d7b804so18249365ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 24 Jan 2025 19:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737775765; x=1738380565;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9EAu5LWnTCvF1HwvNMZzGANl0vMt4L7dqbB2wjEiLaY=;
        b=Oe2YmLY4dnCIY5VSSap2kI/usgfI/66QT98bcSR+RKhGULu963VRr8sFeKhdNMCr0p
         cin5x1TkYIienrGTglAAkAyzkdM4RfWAbUWx1sRwWnoXtQMcN4Qs4RSG8+/Tw9WsBJU7
         HIq/Np+UTFipo7KiX7ckoSLU+PektrGWd36d4543llGTFoE0jbiHcx5lieAkAh8ormXx
         hbFiZ+qG7NA+MnQC8lIjGYP38/My9GcvHBYGMxdtVsYPe9w6h67RiyneX1tJ7T735qiP
         4wgEXTXWz77jr5hWe7Y215Ldx4ifYkp9cm/3zQPftcSFFir8oRhFottoImq9+991Saef
         xVZA==
X-Forwarded-Encrypted: i=1; AJvYcCU/2EKVZtiYb/TV/H7u37vq4zuslaSHi01N9+DjT2VMf6+NnOMk5Mknhe9oQpfI0V9cvE2X4HYWRkWPfLwS/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGtwI9uwkDlKFN82pPzm6hI9aqhpEdxUGtxmQLlp4LOCH0qD2M
	sYwK78zsgRtscSxcrfhzXJQ0f90PfdGcW97VeP/i7LjG3pZjgjx+hR8CqXoxmPJ8ZXHO/dALbtv
	Kl4aN7hy0QTrkNSwC6JvpPBmhYl5Kqk17TriyLKNvE0hoyHj+6bi3Cmw=
X-Google-Smtp-Source: AGHT+IGtOyjtr8ys+4TLqITBbTrY9EmN+Uy1ODZl2j9YME5soORkn8osapMgMXOvK69Nci75OiR/ItdOYx84bu7Me0ruU2Tptfgc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:8d:b0:3cf:b9d3:95a7 with SMTP id
 e9e14a558f8ab-3cfb9d39641mr121514605ab.18.1737775765525; Fri, 24 Jan 2025
 19:29:25 -0800 (PST)
Date: Fri, 24 Jan 2025 19:29:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67945a95.050a0220.2eae65.0022.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_run_recovery_pass (2)
From: syzbot <syzbot+3a290f5ff67ca3023834@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d3a9c8b89d4 Merge tag 'dlm-6.14' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=120385df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88da85736adb8c92
dashboard link: https://syzkaller.appspot.com/bug?extid=3a290f5ff67ca3023834
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12740ab0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=157d5824580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3d3a9c8b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e3e59d52398c/vmlinux-3d3a9c8b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2cd5680cc455/bzImage-3d3a9c8b.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/aaacc394b03b/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3a290f5ff67ca3023834@syzkaller.appspotmail.com

bcachefs (loop0): check_btree_backpointers... done
bcachefs (loop0): check_backpointers_to_extents... done
bcachefs (loop0): check_extents_to_backpointers...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/backpointers.c:841!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 0 UID: 0 PID: 5305 Comm: syz-executor396 Not tainted 6.13.0-syzkaller-00603-g3d3a9c8b89d4 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:data_type_to_alloc_counter fs/bcachefs/backpointers.c:841 [inline]
RIP: 0010:check_bucket_backpointer_mismatch fs/bcachefs/backpointers.c:892 [inline]
RIP: 0010:bch2_check_extents_to_backpointers+0x7320/0x7360 fs/bcachefs/backpointers.c:1087
Code: fd 90 0f 0b e8 d1 3a 89 fd 90 0f 0b e8 c9 3a 89 fd 90 0f 0b e8 c1 3a 89 fd 90 0f 0b e8 b9 3a 89 fd 90 0f 0b e8 b1 3a 89 fd 90 <0f> 0b e8 a9 3a 89 fd 90 0f 0b e8 a1 3a 89 fd 90 0f 0b e8 99 3a 89
RSP: 0018:ffffc9000d1c6480 EFLAGS: 00010293
RAX: ffffffff84164a4f RBX: 0000000000000000 RCX: ffff888000672440
RDX: 0000000000000000 RSI: ffffffff8ef38cb0 RDI: 0000000000000000
RBP: ffffc9000d1c7428 R08: 0000000000000001 R09: ffffffff8415ef86
R10: 0000000000000004 R11: ffff888000672440 R12: ffffc9000d1c70e0
R13: ffffc9000d1c72f0 R14: ffff888047d80162 R15: 0000000000000100
FS:  000055558d2d0380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ae15764088 CR3: 000000003f042000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:226
 bch2_run_recovery_passes+0x2ad/0xa90 fs/bcachefs/recovery_passes.c:291
 bch2_fs_recovery+0x265a/0x3de0 fs/bcachefs/recovery.c:937
 bch2_fs_start+0x37c/0x610 fs/bcachefs/super.c:1030
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa8181a2b7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdeb100318 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffdeb100330 RCX: 00007fa8181a2b7a
RDX: 00000000200000c0 RSI: 00000000200001c0 RDI: 00007ffdeb100330
RBP: 0000000000000004 R08: 00007ffdeb100370 R09: 000000000000595a
R10: 0000000000800000 R11: 0000000000000282 R12: 0000000000800000
R13: 00007ffdeb100370 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:data_type_to_alloc_counter fs/bcachefs/backpointers.c:841 [inline]
RIP: 0010:check_bucket_backpointer_mismatch fs/bcachefs/backpointers.c:892 [inline]
RIP: 0010:bch2_check_extents_to_backpointers+0x7320/0x7360 fs/bcachefs/backpointers.c:1087
Code: fd 90 0f 0b e8 d1 3a 89 fd 90 0f 0b e8 c9 3a 89 fd 90 0f 0b e8 c1 3a 89 fd 90 0f 0b e8 b9 3a 89 fd 90 0f 0b e8 b1 3a 89 fd 90 <0f> 0b e8 a9 3a 89 fd 90 0f 0b e8 a1 3a 89 fd 90 0f 0b e8 99 3a 89
RSP: 0018:ffffc9000d1c6480 EFLAGS: 00010293
RAX: ffffffff84164a4f RBX: 0000000000000000 RCX: ffff888000672440
RDX: 0000000000000000 RSI: ffffffff8ef38cb0 RDI: 0000000000000000
RBP: ffffc9000d1c7428 R08: 0000000000000001 R09: ffffffff8415ef86
R10: 0000000000000004 R11: ffff888000672440 R12: ffffc9000d1c70e0
R13: ffffc9000d1c72f0 R14: ffff888047d80162 R15: 0000000000000100
FS:  000055558d2d0380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ae15764088 CR3: 000000003f042000 CR4: 0000000000352ef0
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
