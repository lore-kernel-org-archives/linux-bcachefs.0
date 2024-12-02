Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71E42A1CF
	for <linux-bcachefs@vger.kernel.org>; Mon,  2 Dec 2024 03:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733111371; cv=none; b=lKSVtoRESKjad4MblC2ZXgE18JDEU43OAsPh5khavNdISfl1P8sBP39J2nTbBG9HNU7/aSm306FjIfyiDb2C3YUFTN8Ww2tDaW8upeNaGRQdiNrunxpGYkG6pC9fzMb7UcRujNiJXhxVOYcD7zRW9/G3eSY8OatENDKHe2KbGWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733111371; c=relaxed/simple;
	bh=ZuGUEwAXbNyAQs40cg3MSx9k5sLfFUvHw/F7c/SZR6o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WfNqp7rQjaJZqyJ8SX/PsrtVulP3kQUB2U7OtZs2cs0reaS2XxRAqqN5EIamKrAhddfz2HHi9ZhcqCJIFqtyUTf0mK2y1bpn0JVrmb1lB3uIT+wxJ3AyZmIT+TS9QUqiO1diyGvIhBCrEHzltjTgZ++umAiogyuW2lnBK54AhS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-843e86e0b3fso401864339f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 01 Dec 2024 19:49:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733111369; x=1733716169;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LhWUQjVNzI0Vfc+rBjjW0cYargSnL7fiTMluzIBuMOM=;
        b=PNR0d51HhGFymCdN5jVqr/55/GfUfQZNT6e7E5C5QTWkeXpcEa1bIgEBHbn2oLS0W8
         A1Rx9gxj2KTCeGEqcCQohmEIQGit3O61WAUky6Jfyb4KAjfLtqkNn/g3LNkHGnRF6ecj
         NollNekvRmgWD8ncp6+7lrgzOpk7iZZfHDOSi3aeuk2jstG/hSLgkhfZvC2I2F8QZBqN
         gOQ/izZX/aVrN1Shoxy7KeCRhr7ZFrGM2fkd+Y6+2bJILvbAqazanqKd6S7a56b3YUAI
         GKiZSSGxC4daU1/q5RYmmrPOjsz8E+FnS1PK7ebnii+iTqYO2tDB33B7nNb7qGU9F9ao
         bl9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVP+MxOK4mMSq++902LUEqFNPlREAahqFhPqhoMio4kDnrAdyxAOg53Gscu3JyptnEd1o6ZgR53G/Dacs/WZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEFEHKTOo1moTB3QtApLrKKyEaUI09iZAeIWPjuJYIwQc90aty
	pDt8oc2NDtWnBuzn8KX7mui6iIXxVrJFndciI2VkAvHZf7BPV6D5Gkhaa/+dozVTZtUu5HUb1L7
	Eao96qK4BBbrHEYXfWGpr/WivxJUIIgEPD9L2zPHddqEItQAMoxEL5xQ=
X-Google-Smtp-Source: AGHT+IGW4by/EpmZ1EZf2ORTOQeSqVofN65fj13N1kvHbmnbnilCqqSGfzRxFkk/lvV8Qzw+AIMwgS1JiAqr4ChfWCvTswxx1P3A
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1526:b0:3a7:4e3e:d03a with SMTP id
 e9e14a558f8ab-3a7c55f27d4mr161307995ab.22.1733111368872; Sun, 01 Dec 2024
 19:49:28 -0800 (PST)
Date: Sun, 01 Dec 2024 19:49:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <674d2e48.050a0220.ad585.0042.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING: locking bug in __timer_delete_sync (2)
From: syzbot <syzbot+b92c7b8dc15336fd1e19@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    7d4050728c83 Merge tag 'vfs-6.13-rc1.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12ed7530580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36a116bcb42870bb
dashboard link: https://syzkaller.appspot.com/bug?extid=b92c7b8dc15336fd1e19
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0402354de422/disk-7d405072.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/42baa2a574cb/vmlinux-7d405072.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bcf1d8381ffb/bzImage-7d405072.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b92c7b8dc15336fd1e19@syzkaller.appspotmail.com

------------[ cut here ]------------
Looking for class "sdp->delay_work)" with key init_srcu_struct_data.__key.29, but found a different class "(&sdp->delay_work)" with the same key
WARNING: CPU: 0 PID: 5841 at kernel/locking/lockdep.c:939 look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Modules linked in:
CPU: 0 UID: 0 PID: 5841 Comm: syz-executor Not tainted 6.12.0-syzkaller-10313-g7d4050728c83 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:look_up_lock_class+0xdc/0x170 kernel/locking/lockdep.c:936
Code: 01 0f 85 8a 00 00 00 c6 05 d3 21 3d 04 01 90 49 8b 16 49 8b 76 18 48 8b 8b b8 00 00 00 48 c7 c7 60 fa 0a 8c e8 e5 45 8c f5 90 <0f> 0b 90 90 eb 61 90 e8 78 83 ea f8 e8 83 a1 ab f5 48 c7 c7 a0 f9
RSP: 0018:ffffc90003da7790 EFLAGS: 00010046
RAX: 55568536ce262300 RBX: ffffffff93ce4d80 RCX: ffff88802f30bc00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003da78a0 R08: ffffffff81568b42 R09: 1ffff110170c519a
R10: dffffc0000000000 R11: ffffed10170c519b R12: ffffe8ffffc6a378
R13: ffffe8ffffc6a378 R14: ffffe8ffffc6a378 R15: ffffffff9a439560
FS:  000055556c511500(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055de49281e48 CR3: 0000000033e94000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 register_lock_class+0x102/0x980 kernel/locking/lockdep.c:1290
 __lock_acquire+0xf3/0x2100 kernel/locking/lockdep.c:5101
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 __timer_delete_sync+0x148/0x310 kernel/time/timer.c:1648
 del_timer_sync include/linux/timer.h:185 [inline]
 cleanup_srcu_struct+0x23e/0x4d0 kernel/rcu/srcutree.c:687
 bch2_fs_btree_iter_exit+0x3f0/0x480 fs/bcachefs/btree_iter.c:3446
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
RIP: 0033:0x7f94ef781b37
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe9cd38668 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007f94ef781b37
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe9cd38720
RBP: 00007ffe9cd38720 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe9cd397a0
R13: 00007f94ef7f37dc R14: 000000000002cc80 R15: 00007ffe9cd397e0
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
