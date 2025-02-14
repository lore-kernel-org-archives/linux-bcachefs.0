Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBF41C84D6
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 19:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739563170; cv=none; b=dJCE1Z3lhOEoYI921al4FkEIPinPYS9+0VHYNH4XRMnHZYYAxldGfyXrds1gsDe0CDSqisrNTP1EIAZV8fgEpBLOe4NIDQomHvYcULKSlKIE1V8wF8AK03d05xO99mMIzAALQFUIBxEfIGp30doorqCvPdevvjqsJUMsC0DH26A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739563170; c=relaxed/simple;
	bh=HoneSYfjwCkyxow6qUqJHiU1p+vYZNaUKdcEgAjc16w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=uyC5vbaT+Ahh3rhlYZqnKVbsf7QzkHnaVfzTimoUEGxlelOtxU0H+7b3yEqtToAP1Izc5pVKHiYGson/CkatP0N54f97bqeLiFMtXJaxBiskYvEmoWuFtTe5kEUCTTqIpA9TCpWV6dlFF3DgKocwUpy6ffNsZKIf6ibdTdbs9xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d060cfe752so14741225ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Feb 2025 11:59:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739563167; x=1740167967;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s07l8WUdCDWeg84onPgx9DdCyplfGFjkRssez/Y+2Q0=;
        b=RPQnI1ry1xBMe0vHCSebmgBDAC7dmTop6QOiDy2lB2+d6WUjSnB7+qdSqiv+fd6l1t
         Ir9Ow36D0MQdOW7+6G6FkZ4IYxALDq8nbPfwU5PPsSBJV1MuOMYitZnzN/ceQ86lInFj
         snDPxuQ3gVYK2aXUzqfXQBLlBIAUzIRq/3VI6WUEtQj4CPpAa0bOBsNVDJjLLAu7vBwU
         pG6Kqh/514aKE4EOmwMnJhUgOcFQ2JtFFKcwM61006IroLWTI6I5KoT2fjnYrPZaGV+p
         LQf+tiDsqhUdp3rxB45pdWkkvC2D61CDFhe4YfOHWNOL66yAAjnY1j+wqDfOPjGI9V4t
         9LQA==
X-Forwarded-Encrypted: i=1; AJvYcCV6Rjp9ws/Jea85P0WGgfxrfclGCFjiQCOUrlKxZPsTOFC0s/zVD7ZRKB0d+IA3w6IfkRgLFhdciYV2AOYHwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXkMOHE3ad/2c1wIYZ4KhEMs8IX8SJA1F/Q1HwPJNPbAMkeQXR
	qAwPXQDibX3mVfzsvv+s2nc0htqdip8fa5E+/QfbSTnNPWegsna37qdP/t4YgdXV8/ndNUutQZ4
	cIWWXy6WW0KzvqSUui2fYr6lI1B3NZcLJd348w9Ic5wOAafMOhQc9qXM=
X-Google-Smtp-Source: AGHT+IFkN/W3gTpyyK01vHXOqHLRzhc2iFiGs3oj7eJXqkptUA0tXVE41WoMma3TkNsH7oXX8/Aty0a/vxWl4NscjCXSooYkgQ22
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c05:b0:3d0:443d:a5c3 with SMTP id
 e9e14a558f8ab-3d2807642aamr6015945ab.3.1739563167662; Fri, 14 Feb 2025
 11:59:27 -0800 (PST)
Date: Fri, 14 Feb 2025 11:59:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67afa09f.050a0220.21dd3.0054.GAE@google.com>
Subject: [syzbot] [kernfs?] [bcachefs?] UBSAN: shift-out-of-bounds in radix_tree_delete_item
From: syzbot <syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com>
To: gregkh@linuxfoundation.org, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    09fbf3d50205 Merge tag 'tomoyo-pr-20250211' of git://git.c..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12cd63f8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c516b1c112a81e77
dashboard link: https://syzkaller.appspot.com/bug?extid=b581c7106aa616bb522c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11e449b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f952dd0d3577/disk-09fbf3d5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/15b571b9069e/vmlinux-09fbf3d5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/299fb2913d4e/bzImage-09fbf3d5.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/40dabaf4539b/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b581c7106aa616bb522c@syzkaller.appspotmail.com

bcachefs (loop2): missing subvolume 1
bcachefs (loop2): inconsistency detected - emergency read only at journal seq 10
bcachefs (loop2): bch2_fs_get_tree(): error mounting: error getting root inode ENOENT_bkey_type_mismatch
bcachefs (loop2): shutting down
------------[ cut here ]------------
UBSAN: shift-out-of-bounds in lib/radix-tree.c:88:31
shift exponent 112 is too large for 64-bit type 'unsigned long'
CPU: 1 UID: 0 PID: 6088 Comm: syz.2.18 Not tainted 6.14.0-rc2-syzkaller-00039-g09fbf3d50205 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 radix_tree_descend lib/radix-tree.c:88 [inline]
 __radix_tree_lookup lib/radix-tree.c:766 [inline]
 radix_tree_delete_item+0x1df/0x3f0 lib/radix-tree.c:1420
 kernfs_put+0x1ba/0x370 fs/kernfs/dir.c:575
 kernfs_remove_by_name_ns+0xe4/0x160 fs/kernfs/dir.c:1696
 bch2_dev_unlink fs/bcachefs/super.c:1270 [inline]
 __bch2_fs_stop+0x1d8/0x5c0 fs/bcachefs/super.c:638
 bch2_fs_get_tree+0xd10/0x1740 fs/bcachefs/fs.c:2303
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3560
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4088
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f89e278e58a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f89e3673e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f89e3673ef0 RCX: 00007f89e278e58a
RDX: 00004000000058c0 RSI: 0000400000005900 RDI: 00007f89e3673eb0
RBP: 00004000000058c0 R08: 00007f89e3673ef0 R09: 0000000000010000
R10: 0000000000010000 R11: 0000000000000246 R12: 0000400000005900
R13: 00007f89e3673eb0 R14: 0000000000005912 R15: 00004000000001c0
 </TASK>
---[ end trace ]---


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
