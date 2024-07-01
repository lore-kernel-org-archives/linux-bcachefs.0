Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D553AC
	for <linux-bcachefs@vger.kernel.org>; Mon,  1 Jul 2024 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719848666; cv=none; b=e7SfZSp8J11bwxncnsQ87EFJvrDz16UA0+esMqc/xT9HBpxrfTekDB99zrrczxUX6rNRojiOZfuJ/Qu/XL4/L0CKiuguZZIjXO/fyNj6xHubyn6OxnNh1pWGcKA4jlBLOMqW+V7AvP3LizyIaXuOepoCc+f4UNt2bw8zh5/4p4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719848666; c=relaxed/simple;
	bh=K4eyQnUx0kIdBVBeY6hpor406xm6lDTO5su5CG9C4kw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SCl1K232DgUxXpYLh7SqwkA0BiGmpcrwH6YZt5TpHfwekOUavhTmzHss8oyOsfbRC1Uj/axhZ0whq6XyF+HgLF14TxHbytMdk+Xr1XT7zZfLHlzjudtZNpByGcm/8zwIRZkHN/gXywaXp0GnIVfFZcSUmXQh01tB9T1HSyZCRXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7f639551768so164094739f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 01 Jul 2024 08:44:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719848664; x=1720453464;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4rg1E0h6guq4gzEPuKz1P5rN3rYVXsGARPLmXIRKjTg=;
        b=gT2/xcCwivzEBpeu7JIHD+1EXCswCmvQMfjdTPAX1DiYq5nUnmWTymZXl9TiJ07KBj
         eDIGdTsWNvxKgv4krVWdDcz+IiWGufK4T9IcnrxmQRz0qTga2TbtXr+99obL60eEscfY
         SKNtoc1a04/WShFkFEpgiFRpCy+oBL/+0idpq5Og832MPbxKZ2z+k+TS7LPYpAR11k0+
         i+ORsJ8QlWcbQlTjBEUB8f9KMgXQJQGzHdMtpPj3RUbw1ZIxdje4SjXM84kGXUEPJxgY
         tY1rXKcQ4BFHhu7pAwG5zOgEHjr2w7gMQRK4b313OX0cVtjnNVfeyGpcSQ+O6CTPecu7
         2vvg==
X-Forwarded-Encrypted: i=1; AJvYcCVTmcc9twSpXqTxZH6T+HBGftgCRkeGrKaUO8il+cgp0BRFw2jOkj0AVlrDbjmbKre5evTieR2L0s6bRXk+VtKzL9Vq2gr36hTuxg716qk=
X-Gm-Message-State: AOJu0YxA6ViltR4zWz5HaaTDAljzDAH+4xno2z44cCwqdlpex23A8G+2
	3hONEvPHOyeZOzvwZPJbsw6sEGsr9PcYPmwHZPC49KIT/P+XfDmBaWU4U2Cb+H7yKYXgblR61sM
	HkwXOGQbKJmEDaz+Y54PU20iN9AVpyb6AeeNt57iEPtWLbKKfVSiJ3iI=
X-Google-Smtp-Source: AGHT+IEI5HWv5TeGep4krN2FDTOO8wyUuKgs26NZDZnLtnNccSmqpjMe12wLlkU4uXLe0lMMS+HMb3uD/zsPIN0kf8Y4Fxe/wkR+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:24cb:b0:4b9:afd1:d4f8 with SMTP id
 8926c6da1cb9f-4bbb6b9ae09mr579739173.2.1719848663841; Mon, 01 Jul 2024
 08:44:23 -0700 (PDT)
Date: Mon, 01 Jul 2024 08:44:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad0d6e061c317852@google.com>
Subject: [syzbot] [bcachefs?] WARNING: ODEBUG bug in delete_node (2)
From: syzbot <syzbot+8771878f9b32e4731b79@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    22a40d14b572 Linux 6.10-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10624699980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1ace69f521989b1f
dashboard link: https://syzkaller.appspot.com/bug?extid=8771878f9b32e4731b79
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/d8763ab76416/disk-22a40d14.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f4fc1fb5933b/vmlinux-22a40d14.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66b91c8c2a1c/bzImage-22a40d14.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8771878f9b32e4731b79@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: activate active (active state 0) object: ffff888061b5aed8 object type: rcu_head hint: 0x0
WARNING: CPU: 1 PID: 5226 at lib/debugobjects.c:517 debug_print_object+0x17a/0x1f0 lib/debugobjects.c:514
Modules linked in:
CPU: 1 PID: 5226 Comm: syz.3.12 Not tainted 6.10.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
RIP: 0010:debug_print_object+0x17a/0x1f0 lib/debugobjects.c:514
Code: e8 cb a9 4a fd 4c 8b 0b 48 c7 c7 80 20 1f 8c 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f8 ff 34 24 e8 0b 6c aa fc 48 83 c4 08 90 <0f> 0b 90 90 ff 05 3c 6d fe 0a 48 83 c4 10 5b 41 5c 41 5d 41 5e 41
RSP: 0018:ffffc900047e78b8 EFLAGS: 00010286
RAX: df2335102b84e500 RBX: ffffffff8bcbd3e0 RCX: 0000000000040000
RDX: ffffc90009f1c000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffffffff8c1f2200 R08: ffffffff81585742 R09: fffffbfff1c39994
R10: dffffc0000000000 R11: fffffbfff1c39994 R12: 0000000000000000
R13: ffffffff8c1f2118 R14: dffffc0000000000 R15: ffff888061b5aed8
FS:  00007f202ffff6c0(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f62c5f6d000 CR3: 000000007e0ea000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_activate+0x357/0x510 lib/debugobjects.c:732
 debug_rcu_head_queue kernel/rcu/rcu.h:227 [inline]
 __call_rcu_common kernel/rcu/tree.c:3057 [inline]
 call_rcu+0x97/0xa70 kernel/rcu/tree.c:3176
 radix_tree_node_free lib/radix-tree.c:310 [inline]
 delete_node+0x1ac/0x770 lib/radix-tree.c:573
 radix_tree_delete_item+0x2e0/0x3f0 lib/radix-tree.c:1430
 __bch2_fs_stop+0x230/0x540 fs/bcachefs/super.c:626
 generic_shutdown_super+0x136/0x2d0 fs/super.c:642
 bch2_kill_sb+0x41/0x50 fs/bcachefs/fs.c:2044
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1267
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x168/0x360 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f203057729a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f202fffee78 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffec RBX: 00007f202fffef00 RCX: 00007f203057729a
RDX: 000000002000fec0 RSI: 000000002000ff00 RDI: 00007f202fffeec0
RBP: 000000002000fec0 R08: 00007f202fffef00 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 000000002000ff00
R13: 00007f202fffeec0 R14: 000000000000fe88 R15: 0000000020000100
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
