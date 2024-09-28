Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00AC1802E
	for <linux-bcachefs@vger.kernel.org>; Sat, 28 Sep 2024 02:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727489611; cv=none; b=SsLmwnGwv6a1iLdqOEjA5AWw3cD78AoLDYYQYnlP8fM67jGVhq8Wmhmt33bJIQto2a1WoL8uBQKUlhn0Biuuy+a4JT2DUb7VZ08L75HVK5XdHfr1/tsq+JmnWUbDWB1dew5j4vT5t9oGeQ+2qPepVQSH/4frE8otxLBKd0Cu1MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727489611; c=relaxed/simple;
	bh=8RCQVeQ/XK9Z1B/wmO3ESfDVi+pbkKDn4zwyhJE3VZ8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MZtOn9ZK1jvFJkGY5OsqMFk7rFMpZv3dRknCkX6DrACCfJgOpW4Q6f3nxjVKOl7iH+pf6HH30r0xWnuwAhoq6MlEt2L4J4EH/SPdrOyOYGA2L7q9vmR42aU7w6DM3q/r5wxjPqnmrszwu+c3e5X7lrL/owdVCjuXZz9bbO5YA58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a0ce3a623eso27923945ab.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 27 Sep 2024 19:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727489609; x=1728094409;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M27INvGaSPwNPQg+W1lIH9OA4BsNDC8o2mri1nC+Z2I=;
        b=OJoe0yowYEMmnvxwgv7VDtJF14XjDCo3eBL9nlBdX/zu2Xl8cCV2q+DnRvzF/+na7g
         p0rcNwxcl7RX4vMp7DwRvCPw9GoCavmdPYWQ6H++y7fXhVEUUO/wEFNuVt2/5XiaIF1/
         q4dk0ENEQWLbFsIaytawR7LOLi6CuXCsgsRKSEw34Y9O6q1yk7oSssK/oM9yJyaGjALU
         agpxBNGCdCLgwIjMygrilkXTHrRoxgUzLOk+9n+6+Dd0ss5BzITDQr6iYGSaffWqfe1j
         +DBuL2ZMbneJVAiHooCEWoYfpU2mk7i9Kn7q3hkBR3VGoH3l6zO49wsUKqgvlDF4r7qs
         eW8A==
X-Forwarded-Encrypted: i=1; AJvYcCXtRwedkX3WeSK89/lztfw9cGVkSWiBdqIF5vezojFD+ctH2FZI+qZ3fht2MH7f+dtxM7bxcapSQGQyz+cv+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlBUQClR4zK9Vc0oaFZcIbevaCAcgNNCsoAxx4evoL8YiwWiSp
	4ROyrajoxLVGnyHIxo5gxUpkDu0a1bgUKMJ0RcOEywZ5RZ9d024M8t4Y1GeMoPShONEW7h5Pd+M
	4HqWycdBBJDouC9hQrMH+QYqLu27ga6OT+FGPoWxlHW49xO69txZh4d0=
X-Google-Smtp-Source: AGHT+IEg8HEFCGGB6ofQHbf1Qqy83n/cVSR+6UKhQR3NvXjj5JLo7yamoo/+SXfD9XvNAyzaHT5sLiLiR35QXEayNMM2xOsQfF3D
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2164:b0:3a0:ac0d:22b9 with SMTP id
 e9e14a558f8ab-3a345166d4dmr47655665ab.6.1727489608835; Fri, 27 Sep 2024
 19:13:28 -0700 (PDT)
Date: Fri, 27 Sep 2024 19:13:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f76648.050a0220.46d20.002c.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_fs_btree_write_buffer_exit
From: syzbot <syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11ef8507980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=e4b5080f1e963225063e
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e4b5080f1e963225063e@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/btree_write_buffer.c:801!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6419 Comm: syz-executor Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : bch2_fs_btree_write_buffer_exit+0x1dc/0x1e0 fs/bcachefs/btree_write_buffer.c:800
lr : bch2_fs_btree_write_buffer_exit+0x1dc/0x1e0 fs/bcachefs/btree_write_buffer.c:800
sp : ffff8000a3217a80
x29: ffff8000a3217a80 x28: 1fffe0001e5b0010 x27: 1fffe0001e5b000d
x26: dfff800000000000 x25: ffff0000f2d80000 x24: dfff800000000000
x23: ffff0000f2dcb174 x22: 00000000000fffff x21: 00000000000ffffe
x20: ffff0000f2d80000 x19: ffff0000f2d845a0 x18: 1fffe000366d79ee
x17: ffff80008f56d000 x16: ffff80008b274880 x15: 0000000000000001
x14: 1fffe0001e5b962e x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001e5b962f x10: 0000000000ff0100 x9 : 0000000000000000
x8 : ffff0000ea698000 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : 0000000000000000 x3 : ffff800082a3a0cc
x2 : 0000000000000000 x1 : 00000000000ffffe x0 : 00000000000fffff
Call trace:
 bch2_fs_btree_write_buffer_exit+0x1dc/0x1e0 fs/bcachefs/btree_write_buffer.c:800
 __bch2_fs_free fs/bcachefs/super.c:564 [inline]
 bch2_fs_release+0x2d4/0x720 fs/bcachefs/super.c:608
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2a8/0x41c lib/kobject.c:737
 bch2_fs_free+0x2c4/0x334 fs/bcachefs/super.c:672
 bch2_kill_sb+0x48/0x58 fs/bcachefs/fs.c:2055
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x34c/0x3dc fs/namespace.c:1373
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1380
 task_work_run+0x230/0x2e0 kernel/task_work.c:228
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x178/0x1f4 arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xac/0x168 arch/arm64/kernel/entry-common.c:713
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: d65f03c0 9774c432 17ffffc0 9774c430 (d4210000) 
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
