Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305131854
	for <linux-bcachefs@vger.kernel.org>; Wed,  1 Jan 2025 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735724783; cv=none; b=UDom668G9v2aIbIRLfpklLCA+c8Krm1NP/JHhpm6Ns3du1o7DRFBt3AWz1ZRfxIAX78eNKpWvDryV3qv0jT0S4zm21gue9VPfVciOPLRvDe7hHhLDfzbkKyzMMpE4gZNhtf5LLoFJC7SWSKyd2BOxc8i+HBXsf8bISKYASPsHhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735724783; c=relaxed/simple;
	bh=jSDxdr0CvvNrWSw8xj4VglIGlnmkNYFwZTnamUHXeSA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XiNsv1PM7F1gkpEX4RmR8UigxhvXootxCWw56CTibJ6utwu589v675qmU4IpeZ/bpuKxiywsDIvfRQ6u0A/BdLf7JeHjKU2P4i755IXDb08vp5EZm2DoZo6/ZiidRQPD9Vj5/uGJ9VxTK6aF5xsqdKnJyxKmX3Fd/KFmYQmtBKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a819a4e83dso116243365ab.1
        for <linux-bcachefs@vger.kernel.org>; Wed, 01 Jan 2025 01:46:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735724781; x=1736329581;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H8g7aBzwu2+3niNdcIoTKjHeTLMX5Oz6W06VNKGfTvk=;
        b=bkhXFMYVP0nhpTBxx0YkgRcrg5ykahlBwoFcImxTnVdSVJ3Uu+Fzk/vTH1W8siAM8c
         KHP1m6rC5pK5LxOK21cK5djeKchWye///ojVgtMvCwFLeRs2Usd8rLKfiFbDSodzlava
         EO82S0xnWaGrpoiHU0y28BuT91Erxj1fqLth3/mwdb9XiyIlC1OMrfzgWnaZk0hSXOrR
         X0M2h5OoocwwdHWeIADX3TQd4ZMcGp1nN7yYxyJrdVQ6aLl4FNA/UHMFzpMnd1qqOwjm
         kz8YNwrArH1XZ1YdupWKZ/mE0M+8PmlyHC0jSJFc/2mLNqqLdBA5XKznwgL30JTrdUh/
         mPAQ==
X-Forwarded-Encrypted: i=1; AJvYcCWO6LYZ+864d+YXGOvAcl6XwLO7QUylQGDH6TwfrJRaBUns8eWFRB0JbV/NiHTOZWRXNo62kdWO9yzOrHqM5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkXQjcJ+xeMImeqaJgVEOG9sIp5KWUDwA+8y8WJkjg5aDHkXsT
	YkQWM/u10YLOk47qEO91PDLyFMEpHppZcZ303/op7Z9Py5MwRtYnT46wqZr93nAUnIK26CJ1DAh
	JVdZs7v3zryDdoNuwBaRBnjNVOwrCumdcotaocvU2U3sjNRT5FYs30fU=
X-Google-Smtp-Source: AGHT+IGxA7AZgcWjXKXQhZjNgfU9gogGNbDYZlOzMokMGF+wPqhKTRGUPgb7C3N4cGx8qY2C4fvqX2RiwaNGWWqLQbua5qxIui+2
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20ca:b0:3a7:86ab:bebe with SMTP id
 e9e14a558f8ab-3c2d514f966mr351268895ab.16.1735724781386; Wed, 01 Jan 2025
 01:46:21 -0800 (PST)
Date: Wed, 01 Jan 2025 01:46:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67750eed.050a0220.25abdd.09cb.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in rcu_segcblist_advance
From: syzbot <syzbot+075b092b57be8d0576dc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fd0584d220fe Merge tag 'trace-tools-v6.13-rc4' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17618af8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4c4096b0d467a682
dashboard link: https://syzkaller.appspot.com/bug?extid=075b092b57be8d0576dc
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/99f5cc30ce2c/disk-fd0584d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ff08027daffe/vmlinux-fd0584d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e103bb4babf1/bzImage-fd0584d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+075b092b57be8d0576dc@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5821 at kernel/rcu/rcu_segcblist.c:473 rcu_segcblist_advance+0x3c6/0x3f0 kernel/rcu/rcu_segcblist.c:473
Modules linked in:
CPU: 0 UID: 0 PID: 5821 Comm: syz-executor Not tainted 6.13.0-rc4-syzkaller-00071-gfd0584d220fe #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:rcu_segcblist_advance+0x3c6/0x3f0 kernel/rcu/rcu_segcblist.c:473
Code: 3c 38 00 48 8b 6c 24 28 74 08 48 89 ef e8 52 0c 7c 00 48 89 5d 00 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc 90 <0f> 0b 90 e9 76 fc ff ff 89 e9 80 e1 07 38 c1 0f 8c 5f fc ff ff 48
RSP: 0018:ffffc90003faf918 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffffe8ffffc69880 RCX: ffff888027e0c6d8
RDX: dffffc0000000000 RSI: fffffffffffffe70 RDI: ffffe8ffffc69880
RBP: ffffe8ffffc698f0 R08: ffffffff9427088f R09: 1ffffffff284e111
R10: dffffc0000000000 R11: fffffbfff284e112 R12: fffffffffffffe70
R13: ffff888053c043c0 R14: ffffe8ffffc69880 R15: dffffc0000000000
FS:  00005555747f2500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc0af769160 CR3: 000000005f0e2000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 srcu_gp_start_if_needed+0x699/0x11e0 kernel/rcu/srcutree.c:1311
 __call_srcu kernel/rcu/srcutree.c:1384 [inline]
 __synchronize_srcu+0x34f/0x400 kernel/rcu/srcutree.c:1432
 bch2_fs_btree_iter_exit+0x3e8/0x480 fs/bcachefs/btree_iter.c:3445
 __bch2_fs_free fs/bcachefs/super.c:558 [inline]
 bch2_fs_release+0x216/0x7d0 fs/bcachefs/super.c:611
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
RIP: 0033:0x7f806fd87057
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffc1a734be8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f806fd87057
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffc1a734ca0
RBP: 00007ffc1a734ca0 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffc1a735d20
R13: 00007f806fe018f4 R14: 00007ffc1a735d60 R15: 000000000000000d
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
