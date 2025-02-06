Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C379B1F4179
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Feb 2025 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738861286; cv=none; b=nI24YqaQQSYGRPKPMm8nMsTEwBATKkR2FH8IfhLcqKdla6XN82Ohg5tt77SOQV4LSXza4dk04j4aY3ty8PLKdPeBlCLKVZ2JJWRfGIobFJeW8FMt74hG55jCb0FeT9SGanR+pas+Mh/2/q0cDOJhOW2O2W/U+TmEYcrqwJybWcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738861286; c=relaxed/simple;
	bh=BKCQzlNMjJtLPFHKuhRkEIVFCJm7e1sTj3P4aIgjrS8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fTc1Ic45aS8XuNKO+6aMtL3faNuCzCbrkCCA/BIjbMjkUmjtm/+YbuOkD9OebX59jzkK+aJ2YGp3agvgusP2+z5JAO0EeTvhhAgtlo6dBO/It4IElpKuRS49vY5pnWoDVNa2XMgaDq1kwaH89/FJCBQiZtH7IPGMIwON8v5FrfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d05b1ae6e3so7580415ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Feb 2025 09:01:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738861284; x=1739466084;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eZvHNJpLhlFkbfLgwR/Q1ek3G9Xr2r0Vr+cVIVNDaIY=;
        b=mcs2MSoMSY9SqddoMbxTO1iFGbvNDg+pMX5PavWWbzUMwFyTplgS3X+qMTNrO1s+tb
         dOMg5QbeWrpFuJ6vRiVLGaYzCMUF2lE6134FSvt1YUGNTSmhUMq6ypdQoDrqsyKNBYmq
         uD+MDK1j7MTORkw6kJv/7pT+lXeYPSFeVfjwQmx+VmsnJFdtJganmYeJxJANgRTbSVlj
         BoIcZSqKBDuEZaDxOJNMnfM2T4Crrs7THNADtwUYGQnDSMQxBrVLn6Ihi/QJu/Z2OXcZ
         JGB2UnMuuK2v4/m+JdkG8oaVdEAInq9aZCaQv8CpzC5EyWnlbODjtLyh8WaVzcWuqfHA
         sLMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJuelFTtKQEbraOtZlMlpB9zTCawV8xkvtIXPWXvtMk17xRt0fh9bUdbrJJVt0QAtOrf9dL0FROciOKlY1pQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp0uWyKq3hJY6pxAH/B180v9hiHTW9i3raByqvkb0CxbC9g4Kh
	ErCvKR1xXvFFra2dB+Xqa7Q2Lfv3qmCWtS9xMPjzeO1MJSNfpLChWhzFHHU+hZECW27nBsNKfpW
	dF+Myw4l+L5xd8KCQLcrZXtqzXcxOCEGkvrcTM300J7koMVlshOBdqwM=
X-Google-Smtp-Source: AGHT+IGyLQTm5aK4YlZalqg6/ur/0KAPfzIxaDjHYVWhlpyDYlTkZ8pBunZh+xZdUfffgTy8iKQsf25UpWuvDQiIn1Yx7A0OnSMx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3309:b0:3cf:fc11:90ca with SMTP id
 e9e14a558f8ab-3d04f42561emr73791655ab.6.1738861283831; Thu, 06 Feb 2025
 09:01:23 -0800 (PST)
Date: Thu, 06 Feb 2025 09:01:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67a4eae3.050a0220.65602.0002.GAE@google.com>
Subject: [syzbot] [mm?] [bcachefs?] UBSAN: shift-out-of-bounds in xas_reload
From: syzbot <syzbot+8ae0902c29b15a27a4ee@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hughd@google.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    92514ef226f5 Merge tag 'for-6.14-rc1-tag' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14761318580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1909f2f0d8e641ce
dashboard link: https://syzkaller.appspot.com/bug?extid=8ae0902c29b15a27a4ee
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17df01b0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-92514ef2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c4d8b91f8769/vmlinux-92514ef2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c24ec4365966/bzImage-92514ef2.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2f20c9ca14a0/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8ae0902c29b15a27a4ee@syzkaller.appspotmail.com

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in ./include/linux/xarray.h:1604:27
shift exponent 192 is too large for 64-bit type 'unsigned long'
CPU: 0 UID: 0 PID: 5696 Comm: syz.4.33 Not tainted 6.14.0-rc1-syzkaller-00034-g92514ef226f5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_shift_out_of_bounds+0x3c8/0x420 lib/ubsan.c:468
 xas_reload+0x434/0x470 include/linux/xarray.h:1604
 find_get_entry mm/filemap.c:2032 [inline]
 find_lock_entries+0x2d4/0xbb0 mm/filemap.c:2119
 shmem_undo_range+0x2d4/0x1820 mm/shmem.c:1094
 shmem_truncate_range mm/shmem.c:1224 [inline]
 shmem_evict_inode+0x29b/0xa80 mm/shmem.c:1352
 evict+0x4e8/0x9a0 fs/inode.c:796
 __dentry_kill+0x20d/0x630 fs/dcache.c:643
 dput+0x19f/0x2b0 fs/dcache.c:885
 __fput+0x60b/0x9f0 fs/file_table.c:456
 __do_sys_close fs/open.c:1579 [inline]
 __se_sys_close fs/open.c:1564 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1564
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4dd9f8ba4a
Code: 48 3d 00 f0 ff ff 77 48 c3 0f 1f 80 00 00 00 00 48 83 ec 18 89 7c 24 0c e8 43 91 02 00 8b 7c 24 0c 89 c2 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 36 89 d7 89 44 24 0c e8 a3 91 02 00 8b 44 24
RSP: 002b:00007f4ddae87e00 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00000000ffffffff RCX: 00007f4dd9f8ba4a
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000005939
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000004
R13: 00007f4ddae87ef0 R14: 00007f4ddae87eb0 R15: 00007f4dd0c00000
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
