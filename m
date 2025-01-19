Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA44D27450
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 Jan 2025 22:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737324214; cv=none; b=jaTU4H3lrTU7uMS2h8DF6tapXFHkPUgOUNIZIrU/6Ngv0svKOMj8vXXtsTlrd8ehbxu01Nb/qbCH9ry5MZ1jv7xEnjCDXd+sVThaVjuiSobVlm/dqB7XwoDmKAbXioFIv5tavpGPdxaBzmYdFaoVxGCXMUOYDbKgvZ5cOrSqHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737324214; c=relaxed/simple;
	bh=kcTBnACwqiR5RhIh5GQJXoRfg+nATtusZG4ye1SwuJo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YzWkvFP5Eqtxo5lHSAP2JgkYfTgp+HvTgKTF0dQfEYvZtgIcqTSc4D2e7SkP7o0t6lULXAMinr2rOgj1vN5zl3LY+f91+uHYZ0RkReH8dhK6JjiFOq6KM7WUSQ2Gp7FpEek+zWA4nmSaoTlxh+rgKE+aievwYLvDp6bnz+FL+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3cf64584097so28541685ab.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 19 Jan 2025 14:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737324212; x=1737929012;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BlqWaevAUucuVz/opMtu0ru8kwaa7JZP5AgG2JxrB8o=;
        b=KGi8PjxQrJhpP9y6pIN/ugEbvFzP5QZQ3gzi9D1EGDgfVuFBY2lMrfSr8T4ydKdFYc
         IpvKK1vorFynYx1kTIsy1UeaTLpN4hZ44F9lsmROgsKdXst72F/5O50u27cUw+pBH9WP
         jqm3X8O+JvtaKMbjDJ6l8oMCH4uMqRD+BHwrGpo8TKhXpsnbutdiorXqKNeB3cOw5vx4
         r0l4oRvz62CARbkYuTWIqWMmenw9I4H44JMwmuWzc/qeY7uieFXlaabyftdQEApBlyCT
         GkQsdFyPZsJH5pCJakcbpoIOPkmiZ9qq2fZcXZCWYDBeXrhviBKQ1wUwnNEQbgVloUKC
         9zog==
X-Forwarded-Encrypted: i=1; AJvYcCVONfwCOYxkNWIo7Rhie7zbKxOJSEaV32YEC17BfpOyjA2cPYYh/E01N5WglibEcZDYczhxYuKTZ+LrG8p8hg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKX0QsVCAWfJuV6HSMUrd2oHl9P52SefwRG1HOD1X3X5JtvyRV
	M3RaNjsTGXQV3rHhYZxhrcU0ARKEFAW0i5G/EoWafCtzTspdHrbGkq6oqtu++4fWGfXNDMvHOST
	DpaXzCuw/TXRu3RBRSpJIEe/J0lBrM4D32zvLvrBsnYulBglDagmPhHk=
X-Google-Smtp-Source: AGHT+IFwOUUB/gy9lZmJApPHDXcGZ1QWs+KOZn1hq5/YWfO/Ft77Tc9feVUG50atALQue624QKobatc5W0izjFP4s6pYWYyMz6W5
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219b:b0:3ce:665b:cdf7 with SMTP id
 e9e14a558f8ab-3cf7447c268mr71889605ab.14.1737324211835; Sun, 19 Jan 2025
 14:03:31 -0800 (PST)
Date: Sun, 19 Jan 2025 14:03:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <678d76b3.050a0220.303755.0060.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_btree_cache_exit (2)
From: syzbot <syzbot+cb21e918562a9fa8ba88@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    619f0b6fad52 Merge tag 'seccomp-v6.13-rc8' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1484fcb0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c676c8e1379fdfaa
dashboard link: https://syzkaller.appspot.com/bug?extid=cb21e918562a9fa8ba88
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a9c9c3056af4/disk-619f0b6f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/558f94c52108/vmlinux-619f0b6f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/595b7ae81ee0/bzImage-619f0b6f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cb21e918562a9fa8ba88@syzkaller.appspotmail.com

bcachefs (loop0): shutdown complete
------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_cache.c:608!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 9344 Comm: syz-executor Not tainted 6.13.0-rc7-syzkaller-00043-g619f0b6fad52 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:bch2_fs_btree_cache_exit+0x1449/0x1530 fs/bcachefs/btree_cache.c:607
Code: fd 90 0f 0b e8 c8 53 89 fd 90 0f 0b e8 c0 53 89 fd 90 0f 0b e8 b8 53 89 fd 90 0f 0b e8 b0 53 89 fd 90 0f 0b e8 a8 53 89 fd 90 <0f> 0b e8 a0 53 89 fd 90 0f 0b e8 98 53 89 fd 90 0f 0b e8 90 53 89
RSP: 0000:ffffc90002f07c38 EFLAGS: 00010293
RAX: ffffffff84161e78 RBX: 0000000000001000 RCX: ffff88802e72da00
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffff888029cec8b0 R08: ffffffff841613ec R09: 1ffff1100539d916
R10: dffffc0000000000 R11: ffffed100539d917 R12: ffff888029ceca28
R13: ffff88803009ba28 R14: 1ffff1100539d916 R15: 1ffff1100539d945
FS:  000055557c781500(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f53d8c51000 CR3: 000000004c752000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __bch2_fs_free fs/bcachefs/super.c:557 [inline]
 bch2_fs_release+0x20e/0x7d0 fs/bcachefs/super.c:611
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x13f/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca2c387057
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fffeac39e78 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fca2c387057
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fffeac39f30
RBP: 00007fffeac39f30 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007fffeac3afb0
R13: 00007fca2c4018f4 R14: 00007fffeac3aff0 R15: 0000000000000001
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---


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
