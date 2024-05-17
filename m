Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70197B647
	for <linux-bcachefs@vger.kernel.org>; Fri, 17 May 2024 03:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715916683; cv=none; b=p8VAQ5vXE2YZBzSGmrYWopIHy4V8lrUJvCeSKMy2317+ZYX3k4UNdqTUtAFS+7C0JOo1HeXdodsg+EQrFKkdtwo/bDPXhv8RDzKD+aFm99I1jymbekUgKj+W6LHj2p9sQRofBjGhkH5j6QAcKcDvJjv2xmjF/z/emPqVjtOdcfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715916683; c=relaxed/simple;
	bh=0QmeCmlVErKS62a4/tGvvWUBV+JBXYVJvjQ4QdPkyh4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=qMv+3OEEGYRUIanMvTv2hGRvn81YEPxbL8PXE37vSBj6TmG0Ma2vQnP8yNqGfYrg4eKPy+IDKWdSi7SduXVkWpKWiHf6EFERGpx+kwgGViDeW9R1WZS/DbjrWJvdvkFLpP5fwCv81Pz0m7Dnnajo8mSrIqnd5qydcCeErixM9ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7d9fde69c43so924391239f.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 16 May 2024 20:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715916681; x=1716521481;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1A04SA3kvGvqA+VQ5AOkTR/5eUh6W6sRfdim7zdnZ3g=;
        b=s/mw7buZegvZZdONs0maNtcFxnQGHXPuRDJ+hCqr4WkmqJq9Y6M3bavO+zDIT9NZER
         gWjSF0mUIXfF2yDtHSgr5HswRr2uC24IY1zYgZGMN+TwhArfVIEHIwF6q0oL+lIwnitb
         zHZKrJOQtfGGbkSk8jEdQWxMcbKbtgKpUgfifdEvOC6p8mYVBnBNGBedq5WklIoyRFOK
         NVJzxB0G7sEkl9i7t8ZBKAut8IZPAwYVQbJ0qyduFBr9fHTgXuOVuC9e65dDf5nfi4kU
         9QrB1mSWfqvQLz6zYwmbbBrN2a/uPELyOrkZIYjltOZGB7/J3YIMak75wHGoENaPEN7B
         D3jQ==
X-Forwarded-Encrypted: i=1; AJvYcCW52/Y8YOgtM3cIRARrTO+7/ZKOpM9Vo/6/bwtTI5KHaeHCtvQ+gzL/8DgxjlmJ91xgGax3nyke3c0GpAXWiQEtu1BFoT1mHnaCdBZH9wE=
X-Gm-Message-State: AOJu0Yz/zo2TYUKK6+60dJ1cY4NE3E/0PA42e7prnTOxIEaiZveOYafA
	A5ayfh+qI5yXiH4XtCxHi+VlcLA2lz9Xim51VRiNl4Ki4GfHo2BdTXFGeN78d4L6400lx9yrW1Y
	clKV1GmuKgROlgxujwXbArXoDKU7sUeJiyuvisn0QMhe3ss88/HsuDGk=
X-Google-Smtp-Source: AGHT+IGPR2FqyrnkAH/efnF4P3adpKR3lgLF2BGh+qmsfxUKfLhqtV0Kztl3DKzvDg7eD/kcVkdkOwrAqAUfnHZjAKZwUcu7O71/
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1351:b0:7cc:2522:f5fd with SMTP id
 ca18e2360f4ac-7e1b51a9835mr124024639f.1.1715916681748; Thu, 16 May 2024
 20:31:21 -0700 (PDT)
Date: Thu, 16 May 2024 20:31:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000047b2a506189dfc1a@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_trans_put
From: syzbot <syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ba16c1cf11c9 Merge tag 'edac_urgent_for_v6.9' of git://git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13791cf4980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9d7ea7de0cb32587
dashboard link: https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/bf33b57f5750/disk-ba16c1cf.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5656c2dd228d/vmlinux-ba16c1cf.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8807d572a9fd/bzImage-ba16c1cf.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com

------------[ cut here ]------------
btree trans held srcu lock (delaying memory reclaim) for 14 seconds
WARNING: CPU: 0 PID: 29792 at fs/bcachefs/btree_iter.c:2873 check_srcu_held_too_long fs/bcachefs/btree_iter.c:2871 [inline]
WARNING: CPU: 0 PID: 29792 at fs/bcachefs/btree_iter.c:2873 bch2_trans_put+0xd8c/0xf90 fs/bcachefs/btree_iter.c:3113
Modules linked in:
CPU: 0 PID: 29792 Comm: syz-executor.3 Not tainted 6.9.0-rc7-syzkaller-00188-gba16c1cf11c9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:check_srcu_held_too_long fs/bcachefs/btree_iter.c:2871 [inline]
RIP: 0010:bch2_trans_put+0xd8c/0xf90 fs/bcachefs/btree_iter.c:3113
Code: 2b 1e 48 c1 eb 02 48 b9 c3 f5 28 5c 8f c2 f5 28 48 89 d8 48 f7 e1 48 c1 ea 02 48 c7 c7 40 28 11 8c 48 89 d6 e8 c5 71 49 fd 90 <0f> 0b 90 90 e9 2d f8 ff ff e8 86 ff 86 fd 90 0f 0b 90 e9 70 f8 ff
RSP: 0018:ffffc9000504ef78 EFLAGS: 00010246
RAX: 25f7e0a65c980f00 RBX: 000000000000015e RCX: 0000000000040000
RDX: ffffc9000b21b000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: dffffc0000000000 R08: ffffffff81587c52 R09: fffffbfff1c39b5c
R10: dffffc0000000000 R11: fffffbfff1c39b5c R12: 1ffff11003daf808
R13: 1ffff11003daf80d R14: ffff88801ed7c068 R15: ffff88801ed7c041
FS:  00007f0b753806c0(0000) GS:ffff8880b9400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd53b17db38 CR3: 000000007c3e4000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_btree_root_read+0x8b2/0x970 fs/bcachefs/btree_io.c:1772
 read_btree_roots+0x22d/0x7b0 fs/bcachefs/recovery.c:457
 bch2_fs_recovery+0x4334/0x63b0 fs/bcachefs/recovery.c:785
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1043
 bch2_fs_open+0xa8d/0xdf0 fs/bcachefs/super.c:2105
 bch2_mount+0x71d/0x1320 fs/bcachefs/fs.c:1903
 legacy_get_tree+0xee/0x190 fs/fs_context.c:662
 vfs_get_tree+0x90/0x2a0 fs/super.c:1779
 do_new_mount+0x2be/0xb40 fs/namespace.c:3352
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount+0x2d9/0x3c0 fs/namespace.c:3875
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b7467f46a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 09 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0b7537fef8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f0b7537ff80 RCX: 00007f0b7467f46a
RDX: 0000000020011a00 RSI: 0000000020011a40 RDI: 00007f0b7537ff40
RBP: 0000000020011a00 R08: 00007f0b7537ff80 R09: 0000000001200014
R10: 0000000001200014 R11: 0000000000000202 R12: 0000000020011a40
R13: 00007f0b7537ff40 R14: 00000000000119fc R15: 0000000020000100
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
