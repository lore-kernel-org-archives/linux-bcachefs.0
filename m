Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B699A47
	for <linux-bcachefs@vger.kernel.org>; Sun,  9 Feb 2025 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739060371; cv=none; b=MkB8XTyZoXq+Berfo9V9tT0Wv6OHMdmGLbUgv16vdlRaEG+74aIonRvpf0nMfTrfZJ2WDWz3gr6RuhOWAxYn7dbwQ3ykuPJ2koVb7OxmGzK8zES0zSvXbQVQKMMcR6wCxaL6EAqKiAaRab9O8uxzXPR5U0tnRrxHfCqMjIA2mM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739060371; c=relaxed/simple;
	bh=C/K6eAfrjQ31gBQ+jL+8yvFxveWps9ggzg2aVOPJq9c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=f2tHjTrhIjhB4qiN942tTjkl9nS9pd2oujvaMtL+/N/kEKL3FnzAnZ6BjaW7aDMvqj4N2yHttoMWCJH4wY8b3Aj6pWGy+Qveo2o2wQH7ijMXy1SMNE5O1fM69O8RITgLXpfIN24GxJemyUbL0w3mERttk9z7Tn27n2Qt+C9aem8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d13d1f8420so15771725ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 08 Feb 2025 16:19:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739060369; x=1739665169;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TwDhLvTG33fGX0NUP4PJo8UU819dO3p8hiVZZIufPo=;
        b=SuW9TMBVdu7C1QaU2Yb/zhAPJLvpL7zh/xwtQHtAjSz7/tNs9Fif0e/oX674Chlp2L
         IH4qcC8pLZn7c/QDLKF57pEWtra1dCGTXrz9eAFWVoFAWwUsgUM3sWzBlFJl1HDxCaEg
         1tz40z8vb6ElkpnHMWpp1dbpYwpPtgdsmzKk7AwctywSRRMDN0h0TkQwP/cHdKu6rZ8n
         HqvAqqjLKgP4E7Afgp/5Jyr0dBkl4oV4lwvsSYZRFDk7oFiVTssf3oAAMQoCgrW91TrS
         e+VeFzmOFWyawfVoaXmbk5jP3nOkG23Rf1FqzUWD8usoU9d6HRgPLHnTtQQN0fJu+Qd6
         bZGQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7m12Zm88mafL+OkbGb1UnNZ8mwqZczi1c0zSm9uwvplTn2PBlUDQy5rntLvwPyz7L7AqdYKTwRS1CKCpTNA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz81LAh4/uJYVMt/e0XhgR2przkeNjFYJyl30L2I8NGmNSgqUkz
	UeKo7QsMFWryQH6uL8guqVbBuWuSP8v5loqmiZxvCs8aJJkmKRHFl3TGmR+gIa12JDW/2vv0xr0
	H27wlCWnZOTAJaRDPTkCTz+/oUg/07DBhyStTYohJ105tUGGfHJcbbMs=
X-Google-Smtp-Source: AGHT+IHSUu4bqcmPja9EI0/WD+00zrh1cDMgeOgEy4rU65hL7IOAe/0G0ZftcASw5CCJLIJBS3Bco1JXPU6koeSIR30WJ2gAjPAr
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda8:0:b0:3ce:7cca:db24 with SMTP id
 e9e14a558f8ab-3d13dd62ad2mr61650135ab.13.1739060369158; Sat, 08 Feb 2025
 16:19:29 -0800 (PST)
Date: Sat, 08 Feb 2025 16:19:29 -0800
In-Reply-To: <66f01abe.050a0220.3195df.009d.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a7f491.050a0220.3d72c.0031.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_fs_release
From: syzbot <syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f6629c004b1 kbuild: Move -Wenum-enum-conversion to W=2
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12b102a4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=147b7d49d83b8036
dashboard link: https://syzkaller.appspot.com/bug?extid=08d08d52c3a09bfc70f7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1312cbdf980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=129411b0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f60addb0f276/disk-8f6629c0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/59d0658fa6fd/vmlinux-8f6629c0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/25afa4128fc2/bzImage-8f6629c0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/574abc7822e2/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com

bcachefs (loop0): shutting down
bcachefs (loop0): shutdown complete
------------[ cut here ]------------
online_reserved not 0 at shutdown: 1792
WARNING: CPU: 0 PID: 5820 at fs/bcachefs/super.c:585 __bch2_fs_free fs/bcachefs/super.c:585 [inline]
WARNING: CPU: 0 PID: 5820 at fs/bcachefs/super.c:585 bch2_fs_release+0x744/0x7b0 fs/bcachefs/super.c:624
Modules linked in:
CPU: 0 UID: 0 PID: 5820 Comm: syz-executor117 Not tainted 6.14.0-rc1-syzkaller-00187-g8f6629c004b1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:__bch2_fs_free fs/bcachefs/super.c:585 [inline]
RIP: 0010:bch2_fs_release+0x744/0x7b0 fs/bcachefs/super.c:624
Code: 41 5e 41 5f 5d e9 2c 67 33 fd e8 37 85 49 fd e9 06 fd ff ff e8 2d 85 49 fd 90 48 c7 c7 a0 6a 55 8c 4c 89 ee e8 fd 2f 0a fd 90 <0f> 0b 90 90 e9 13 fd ff ff 44 89 f1 80 e1 07 38 c1 0f 8c 18 fb ff
RSP: 0018:ffffc90003e2fb88 EFLAGS: 00010246
RAX: c22db852ba485a00 RBX: ffff888077104a10 RCX: ffff88807de41e00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff1100ee20942 R08: ffffffff81800b32 R09: 1ffff110170c519a
R10: dffffc0000000000 R11: ffffed10170c519b R12: 00000000fffffff8
R13: 0000000000000700 R14: dffffc0000000000 R15: 0000607f47622c00
FS:  000055555c502380(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff51ad82bc CR3: 00000000781b8000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x22f/0x480 lib/kobject.c:737
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1413
 task_work_run+0x24f/0x310 kernel/task_work.c:227
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2522
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc7/0x1d0 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x24a/0x340 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8aac0ec447
Code: 07 00 48 83 c4 08 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 b8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fff51ad82a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f8aac0ec447
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007fff51ad8360
RBP: 00007fff51ad8360 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000202 R12: 00007fff51ad93d0
R13: 000055555c5036c0 R14: 0000000000000001 R15: 431bde82d7b634db
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
