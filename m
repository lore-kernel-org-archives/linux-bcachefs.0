Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D1E1AAE17
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 13:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541304; cv=none; b=jxYIduz8HEOK47GVVdYuMxuGIKHdsABSXRy7xnt365HkDYiAXftH7YLsr6dmdPjgvPz/OggeQP+X35GrpnVJeTuJJNb4EzTVVD1LP2pirk3DMDU5ZMbnghePq9ErYLQFZyP/fGqWQzESx3B7e0nJeCybPga7CUtNFK0owmiPjDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541304; c=relaxed/simple;
	bh=/vemIh+S1vRAcXgLhjUwivntbUc02ruACr9xa+P9Lzc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TYe4j+OTYoSIgbJ2GWQihXtkIBxrNUYH4qE7RX7zM6t+S1hkEBQGdI4pTIwk9mT72iCLIemxkkyX5b65cZ/K21v0pOoxNK8h+BM1+Z4QMh349+nw3GVpWO+Nz96y7qQwBlhJzAE4HlN+KUGnJJ46yI/XVLn/69mrHD/Lyd885ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a775636946so28662645ab.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 05:28:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732541302; x=1733146102;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EHpub5kNb7vdAGFDduTZk9dWC9QWr8QEYnWXsLNgnvE=;
        b=jcFEX4MV4j+Ceh0KkQSGqt3lGTmZmx09ZmEV/vs2hB0bMfpvbntnwKfP+Dx5flajQJ
         Y6ci4cmgZG3AlJBg3k0c0m/WZqRvSqw4xLM64JLZU4N+esd/uncBnc1o0GG80qx0uhqR
         N+Uda/NLpSGM5aoGEYQjqJe27Fgqif7immCknABcC0vC2bsehAgzuNr6zvH1zgUg0GjY
         fGbKHbqIVgbfLzwnS6qLl6KlCrEPqVmQu1jg3xKp85xksdE211Q6Cevv+oa3BgZJaQBK
         sVKSE7C11NJSREe5IrTDfVKeL9JEprvD+12/vKQMJbNJk+/05002VCGsRmzXDzaA/P9o
         h42g==
X-Forwarded-Encrypted: i=1; AJvYcCUZY2MJ35CJM5GcToIHMlcyHuhw2ZdfosddgStMf52IjxTygH8Y2Moofnr0XIWzcJAeoNJMn6bBCHhQFIq4og==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7UYdcRsVRpfwEbLkPqIe/VDCrjWllSrnVJsIMB8m1Ml1u9Ery
	ug1V0GByC0/f5nPdS8m4PL3HLOvtOZQ34FBj4GOtZdqMeBmXsKCLgRTk0CosIv546ZIc+KHgjb8
	y9uBC7yJKEVR4oGN/77ULvshG+LIVontL7PoRbDcHtgAYP9PASwEjmmM=
X-Google-Smtp-Source: AGHT+IFkqAdn4QHSQ4AfoumTzGparn4ObJ79VBklKS9CPERWbZzjP3ld0WPBNoZpAuGpzeq2RnXHb17rtHF3K3XGcEo0NOkoFOuW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:168c:b0:3a7:8cdd:c0d2 with SMTP id
 e9e14a558f8ab-3a79ab76051mr133200015ab.0.1732541302305; Mon, 25 Nov 2024
 05:28:22 -0800 (PST)
Date: Mon, 25 Nov 2024 05:28:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67447b76.050a0220.1cc393.0086.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: corrupted list in bch2_btree_and_journal_iter_exit
From: syzbot <syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1238e9c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e92fc420ca55fe33
dashboard link: https://syzkaller.appspot.com/bug?extid=2f7c2225ed8a5cb24af1
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf575f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14be0530580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c9f905470542/disk-9f16d5e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b4c9cc530ec/vmlinux-9f16d5e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e0f262e4c35e/bzImage-9f16d5e6.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f54c993ed1c0/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com

bcachefs (loop0): stripes_read... done
bcachefs (loop0): snapshots_read... done
bcachefs (loop0): check_allocations...
btree root with incorrect max_key: 18446744073707239423:U64_MAX:U32_MAX, continuing
list_del corruption, ffffc90003f06588->next is NULL
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:53!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5836 Comm: syz-executor268 Not tainted 6.12.0-syzkaller-09073-g9f16d5e6f220 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:__list_del_entry_valid_or_report+0xd0/0x140 lib/list_debug.c:52
Code: 56 fe 49 fd 48 8b 13 4c 39 fa 75 6b b0 01 5b 41 5c 41 5e 41 5f c3 cc cc cc cc 48 c7 c7 00 ad 5f 8c 4c 89 fe e8 51 50 08 07 90 <0f> 0b 48 c7 c7 60 ad 5f 8c 4c 89 fe e8 3f 50 08 07 90 0f 0b 48 c7
RSP: 0018:ffffc90003f06400 EFLAGS: 00010246
RAX: 0000000000000033 RBX: 0000000000000000 RCX: bdc83a46e3ff8100
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003f06790 R08: ffffffff8175714c R09: 1ffff920007e0c1c
R10: dffffc0000000000 R11: fffff520007e0c1d R12: dffffc0000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003f06588
FS:  0000555585f8b380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a3fcc540f0 CR3: 00000000746f0000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del include/linux/list.h:229 [inline]
 bch2_journal_iter_exit fs/bcachefs/btree_journal_iter.c:339 [inline]
 bch2_btree_and_journal_iter_exit+0x2c/0x100 fs/bcachefs/btree_journal_iter.c:443
 bch2_btree_node_check_topology+0x13dd/0x2b00 fs/bcachefs/btree_update_interior.c:144
 bch2_gc_mark_key+0x1dc/0x10e0 fs/bcachefs/btree_gc.c:588
 bch2_gc_btree fs/bcachefs/btree_gc.c:670 [inline]
 bch2_gc_btrees fs/bcachefs/btree_gc.c:729 [inline]
 bch2_check_allocations+0x1c3e/0x7070 fs/bcachefs/btree_gc.c:1133
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
RIP: 0033:0x7fa7105e0a7a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe1b2a6168 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe1b2a6180 RCX: 00007fa7105e0a7a
RDX: 0000000020000040 RSI: 0000000020000000 RDI: 00007ffe1b2a6180
RBP: 0000000000000004 R08: 00007ffe1b2a61c0 R09: 0000000000005993
R10: 0000000000800000 R11: 0000000000000282 R12: 0000000000800000
R13: 00007ffe1b2a61c0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0xd0/0x140 lib/list_debug.c:52
Code: 56 fe 49 fd 48 8b 13 4c 39 fa 75 6b b0 01 5b 41 5c 41 5e 41 5f c3 cc cc cc cc 48 c7 c7 00 ad 5f 8c 4c 89 fe e8 51 50 08 07 90 <0f> 0b 48 c7 c7 60 ad 5f 8c 4c 89 fe e8 3f 50 08 07 90 0f 0b 48 c7
RSP: 0018:ffffc90003f06400 EFLAGS: 00010246
RAX: 0000000000000033 RBX: 0000000000000000 RCX: bdc83a46e3ff8100
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffffc90003f06790 R08: ffffffff8175714c R09: 1ffff920007e0c1c
R10: dffffc0000000000 R11: fffff520007e0c1d R12: dffffc0000000000
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffc90003f06588
FS:  0000555585f8b380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a3fcc540f0 CR3: 00000000746f0000 CR4: 00000000003526f0
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
