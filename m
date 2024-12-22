Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEBB18A924
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Dec 2024 23:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734911065; cv=none; b=ujUHV0mI3XIqe2gAD/CzE/hd/kSwYLkmWc4fZV4uGky1eGgt8i5/A1Ou9fbu5E1d51Zjcz29TpdnjXOqbmhw23wu+zMZdeJ4eBsYfe1JFRFNb7CaGSiP40iSP0qSP/osOZ0TsZ8FZoNRFzo77cGnmpN9Ybp5IHp6i5RUj/JFOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734911065; c=relaxed/simple;
	bh=lFjP7VTBUO6H8dtLzDQkr+ubXyYBhgvT+By/TwBNbTY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=M+zYTV2JfmXEq0qA7440qHREpMyvkjTaXWhZSrVRtsG16FWXO4YHwv6X4vTfOFHZ+suAKoe3RE4YhNEBBluOQa5K8trhIGWHhtGTP40vd2XdlDVobYPuPEj0QSZqD7/j5sdNRq5rswl7URg83b6zCvvYjylazVBel0N31DD2K4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a9d075bdc3so64576945ab.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 22 Dec 2024 15:44:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734911063; x=1735515863;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kzSdP4WJ4xlrpZGQ3+rTTrS+uCAav5pOqK7KfoxKk1A=;
        b=hBeX6nWUZ7IThkUHWntFfIFZsrZovCDkcmQt1pGSP7WkO4K/HUw5NdVFM3pPb12Ep4
         pFMy2mYg55/zVUrUewTney5XFvGb4HU+xmloP9QqHgYhQ066HPoik4bDVYCgDiZPihpb
         iVB3fUm8+wSBoofWiwYAKR0dnxM7JXMHJFlUyIc7NxQmdNyHcvTVUxrXnliz3aboY4JN
         w8IxW/XaUVMBKcTD3bJvtu/2J5A0TSiLcZFX9H5dWwNAyn+iNtViNOQcJj0hEloKyEIk
         j4unYXgZQmvjg8QvhWPFoKnMSkYvo9OvuChX8bx2WPVx1ZyY6uwf7xXwg9e38LwEezgs
         oPkA==
X-Forwarded-Encrypted: i=1; AJvYcCU5EromW5X6XKfDT8NQzd2fAK3tZG3cDD4Sk9dCT/Zwa3ofyVCMqjVqzN8uAuTwQYNzqwG5SieZEUPeSXJaYA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyjSXEgtDGcZ4GVLVRROqoyu+I1+IUW4evROtVhDtoAPIdyP9eQ
	oD5CtXl3sq/On9DFIW0PzpChywTs8fkme9pOGnkDErKODXRWqAXkNN1y4DEJl+S5SIEmvVJMuSW
	UtmbX0RzOsXBwxIpJ3ZIDvp0uK3jjEXyBYI2/uYjScjcDHHFkWoCTt8M=
X-Google-Smtp-Source: AGHT+IG/FKdIStkbCUkqSGaVTcBixr/URdEVnSynvbUUW/1WCkTTjutMytGGYrVGoreLZZLPcoA4PYqWWmPGwzYDV7hP4YVnDU31
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4a:b0:3a7:d792:d6c4 with SMTP id
 e9e14a558f8ab-3c2d5c2f489mr95456835ab.21.1734911062092; Sun, 22 Dec 2024
 15:44:22 -0800 (PST)
Date: Sun, 22 Dec 2024 15:44:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6768a456.050a0220.2f3838.000e.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in try_check_zero (3)
From: syzbot <syzbot+cf9a826a13c8657c38e9@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    eabcdba3ad40 Merge tag 'for-6.13-rc3-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12514cf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=cf9a826a13c8657c38e9
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160d22df980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7a4dff87674a/disk-eabcdba3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/266bc2b7ced3/vmlinux-eabcdba3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ee4bcd9be832/bzImage-eabcdba3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/7cb3486c31c1/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cf9a826a13c8657c38e9@syzkaller.appspotmail.com

------------[ cut here ]------------
Mixed reader flavors for srcu_struct at 0xffff888068604388.
WARNING: CPU: 1 PID: 5992 at kernel/rcu/srcutree.c:474 srcu_readers_unlock_idx kernel/rcu/srcutree.c:473 [inline]
WARNING: CPU: 1 PID: 5992 at kernel/rcu/srcutree.c:474 srcu_readers_active_idx_check kernel/rcu/srcutree.c:489 [inline]
WARNING: CPU: 1 PID: 5992 at kernel/rcu/srcutree.c:474 try_check_zero+0x45a/0x4a0 kernel/rcu/srcutree.c:1108
Modules linked in:
CPU: 1 UID: 0 PID: 5992 Comm: kworker/1:4 Not tainted 6.13.0-rc3-syzkaller-00073-geabcdba3ad40 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Workqueue: rcu_gp process_srcu
RIP: 0010:srcu_readers_unlock_idx kernel/rcu/srcutree.c:473 [inline]
RIP: 0010:srcu_readers_active_idx_check kernel/rcu/srcutree.c:489 [inline]
RIP: 0010:try_check_zero+0x45a/0x4a0 kernel/rcu/srcutree.c:1108
Code: 8b 3d 7a c6 0e 0d e8 85 78 3a 0a e9 55 fd ff ff c6 05 01 99 7d 0e 01 90 48 c7 c7 c0 d6 0b 8c 48 8b 74 24 08 e8 67 28 db ff 90 <0f> 0b 90 90 e9 57 fe ff ff c6 05 df 98 7d 0e 01 90 48 c7 c7 c0 d6
RSP: 0018:ffffc900034efa50 EFLAGS: 00010246
RAX: 3561385088340b00 RBX: ffffe8ffffd57820 RCX: ffff888075a45a00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff81601962 R09: fffffbfff1cfa210
R10: dffffc0000000000 R11: fffffbfff1cfa210 R12: ffff888068604390
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000009
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fee10b2d000 CR3: 000000003263a000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 srcu_advance_state kernel/rcu/srcutree.c:1724 [inline]
 process_srcu+0x11f/0x12e0 kernel/rcu/srcutree.c:1851
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


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
