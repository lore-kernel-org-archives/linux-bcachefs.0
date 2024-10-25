Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A786AC8DF
	for <linux-bcachefs@vger.kernel.org>; Fri, 25 Oct 2024 02:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729822354; cv=none; b=ClCQ4BD+HCMKP87G5xrgktAeWJ1WXxt5JeecnzKJaWja5UVmKvXIc9GrtHNVcpwgfZhfaB4oGo28B76q2F5uPHgt/I8MZl3TU5g06Hbe4cOHLq30nr7I2MrdOsn/iCLGulh4kTooq6/eHdSLn8A1eK8Boxm88EeokywC7xFAhGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729822354; c=relaxed/simple;
	bh=1aMxInPhgdbQLKj929wl57Juz1874puJLc85vZ41OdI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Grei27C9KmOblNXQEq1e6CC9UpBPR35X1QPh50tZrV5X+XJ+gz7h2y1bMLVdbfvCExPaE6QHAsJ+8CJGIZV073F7QmFLbK5gMqUjeB5heXUmLDhyPwK/DcEsalayuVwLEf8JmSYjlSGmQ+Ib8vRqx0yIn/sLRcb5DpdRumLry9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a3c9886eccso13673865ab.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 24 Oct 2024 19:12:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729822352; x=1730427152;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T2Oiy5qXfx9l65r4lozq0HbAn1nAorcfgQqKjsjjHp0=;
        b=xVA7CeQfsQgnPKDNH+Z98ubC0W7T6rqSsZ1SMidVkutfvwFxB/mT8Nofdyi9fOvECU
         EuL1jP7NX3KHlqs8jSTSbUIuXBLPffm5+uM1zDzCpG7tAbdMwo0vZg/bISEE7yjTkJ1e
         uAriyMkBYLYQGLL06zMVO3Dy0UiUoAcTEUs/eD7yVaifgcbivzVRaNVRlE0ifmnbJYdu
         77ZdN2cR3wn92ZhDrgJYCbmsQaRoPcJHoNl134i7udVtjF7ExOT4RUo9z0T+pDqSHc/k
         UhYpNq9w2M6KS963SMHOTa5zOgGksGSkmOSXt3Wa+S65FuKDXdrwT/sjntPvEHDkzm9B
         9v6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXqqJrx7/Q81sM/cYEeDCOlD+9fTTrZKRjkm4QR0ZrycY/MTFR9fVIYKyIiHXKOPn5cwz3tZe+PHM/L/oWsIg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZjkZNuFpnR8wHEI0ZI8IJWf+PaZJff85SHf0gmPWxey/0fRkE
	/m3sdAq4eDMKyZ/e+YRqp/pzkwvnj5V3Koqi0EfKXWyy2UaV8tYD01SnCXPDSXxwrXV+EHmMZMK
	aXp7mmQklAFdTCDYHCkcZOgW5gCBxPJnJh56LbZsnGdutwZefZx2JrI4=
X-Google-Smtp-Source: AGHT+IHqBpPJJCOcW5WSnWSxdL34lrftyAeTP8WsAdMcEov3O+7eNVTJw1iXctMGR+Y7bah7LsSNgWZ6ZLrlr9efeBvVKmckqnlc
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a67:b0:3a0:b384:219b with SMTP id
 e9e14a558f8ab-3a4d59ff663mr81867485ab.26.1729822351735; Thu, 24 Oct 2024
 19:12:31 -0700 (PDT)
Date: Thu, 24 Oct 2024 19:12:31 -0700
In-Reply-To: <66f76648.050a0220.46d20.002c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <671afe8f.050a0220.381c35.0007.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_fs_btree_write_buffer_exit
From: syzbot <syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c2ee9f594da8 KVM: selftests: Fix build on on non-x86 archi..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10580230580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=309bb816d40abc28
dashboard link: https://syzkaller.appspot.com/bug?extid=e4b5080f1e963225063e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1218165f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d0a8a7980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/679bd327d6c3/disk-c2ee9f59.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/878a4498ae97/vmlinux-c2ee9f59.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a01c90b897c0/bzImage-c2ee9f59.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/886e4f0a9bc0/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_write_buffer.c:801!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 5857 Comm: syz-executor596 Not tainted 6.12.0-rc4-syzkaller-00047-gc2ee9f594da8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:bch2_fs_btree_write_buffer_exit+0x1e2/0x1f0 fs/bcachefs/btree_write_buffer.c:800
Code: 00 4c 89 f7 31 f6 e8 1d 41 da fd 5b 41 5c 41 5d 41 5e 41 5f 5d e9 f9 e1 cb 07 e8 c9 78 70 fd e9 f9 fe ff ff e8 bf 78 70 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90004a77b70 EFLAGS: 00010293
RAX: ffffffff84245f21 RBX: 00000000000ffffe RCX: ffff88806e189e00
RDX: 0000000000000000 RSI: 00000000000ffffe RDI: 00000000000fffff
RBP: ffff888067200000 R08: ffffffff84245e03 R09: 1ffff1100ce4965e
R10: dffffc0000000000 R11: ffffed100ce4965f R12: dffffc0000000000
R13: ffff888067200000 R14: ffff8880672045d8 R15: ffff8880672046a0
FS:  000055557d532380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557d53b6f8 CR3: 0000000024df8000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __bch2_fs_free fs/bcachefs/super.c:566 [inline]
 bch2_fs_release+0x2fd/0x7d0 fs/bcachefs/super.c:610
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x231/0x480 lib/kobject.c:737
 deactivate_locked_super+0xc6/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x251/0x310 kernel/task_work.c:239
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2403
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x279/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe5ea8b56c7
Code: 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffdef8fdfc8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fe5ea8b56c7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffdef8fe080
RBP: 00007ffdef8fe080 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007ffdef8ff0f0
R13: 000055557d5336c0 R14: 00007ffdef8ff0e8 R15: 431bde82d7b634db
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_fs_btree_write_buffer_exit+0x1e2/0x1f0 fs/bcachefs/btree_write_buffer.c:800
Code: 00 4c 89 f7 31 f6 e8 1d 41 da fd 5b 41 5c 41 5d 41 5e 41 5f 5d e9 f9 e1 cb 07 e8 c9 78 70 fd e9 f9 fe ff ff e8 bf 78 70 fd 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc90004a77b70 EFLAGS: 00010293

RAX: ffffffff84245f21 RBX: 00000000000ffffe RCX: ffff88806e189e00
RDX: 0000000000000000 RSI: 00000000000ffffe RDI: 00000000000fffff
RBP: ffff888067200000 R08: ffffffff84245e03 R09: 1ffff1100ce4965e
R10: dffffc0000000000 R11: ffffed100ce4965f R12: dffffc0000000000
R13: ffff888067200000 R14: ffff8880672045d8 R15: ffff8880672046a0
FS:  000055557d532380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557d53b6f8 CR3: 0000000024df8000 CR4: 0000000000350ef0


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
