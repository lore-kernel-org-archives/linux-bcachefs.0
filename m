Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296E1A23BA
	for <linux-bcachefs@vger.kernel.org>; Thu,  3 Apr 2025 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743702388; cv=none; b=aTdVr/xV1yDjivEUmKk21EcMZWPQ4ubTfmKuDzZj41tuS0ZonHkCYS4h14WOyNPgKKr+RMQztRTXIyfS5cSStiFCse4cwTw6BjjSaaZtzYvjXq0Dwq1LRBaMKdqlbyrNIqEyU1ppAhwjUUu2G45NG+65Qar+M7P7IQdTKAiTOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743702388; c=relaxed/simple;
	bh=7WAOF/PGgx1dnyD4FdX5UHymjIyHujyPwO0DPA9CwPw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=A2f+u75CyOE2z4JsezM44BfNy+T5ksMMAHGbP4uuoHlGH6LTE4eMojVGyff/pTCnItGyK7iFsfK/xzSimfLqPQ06GZL7LuDkXNfy3sFIflB/mqEMXi7zGCenwoxYOCmV3MjDvcEwyohj7/stktHEnLRtmueDfP8i7doQTBaaawU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3d5da4fd946so22853485ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Apr 2025 10:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743702386; x=1744307186;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5EIrOuna1iQfxkNQJAQ8SncT+rsXyyDd2SoWc/q5hWw=;
        b=rIp9ghZR4/TD4LTa3aJQHy/kDvHGh8TdrJkRYuoJcC5XzF4jaHq+kBxcbm1kPVTw8X
         JgJ+8ICgp1pYHfUGhfRBeVyi4EDldd6SlaUKcGsae8rw9Lh8oXbS8E23+9497HjkGQGs
         qh5ykQ4sKXfz64FKcdRmz5eUocPSVTO9SDoJ+vytfOY8RsV2vKDq5kuBLJoyuLHb8+bb
         AAq8wmUgz0dNhzbgttPkEd+yi+wtyLMRZ47lzSHqh8dZVDSUmfDAidCFRFFGDapBqh7x
         GpnbjVq3z1//RbwWY1g+ldC00u6Zqyn/eE0FkuGAXU2qh+sN2YpaY9zMJRJcvV/o5HiM
         TbTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTa3CRJGtnhj9/nCdPRV8AM9w/ac/kzhXxkJkfHlRLherW50t9wQft0945Gwbe+ROdg/3OHVYMRth3ZLtD0Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCP7hEi/ZadqeBeYw+GwdZgd0mdI3xRoQehMRxChZZ+MBoM6bT
	9lF02iW4BXvk17YHETscovI+z8TFfJSnHFkXd+hH3uA7EYYF59+1pydf9S8KkKIR0Ni/hDI596T
	KLmd7M7eJomOy0Fnb1UBXLmEIiJQJGVBCtlQdO2wjjKXbbu9DRuhNiQE=
X-Google-Smtp-Source: AGHT+IHWtvoebqXEf/sTd+fBUcKziDtr+u+YE5y3cCnRiTHmaZrtU4hS05fyA0dhX1z7XLJmJkbbUGj8wTAOQujs4kPyffWIZKSC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a89:b0:3d0:4a82:3f43 with SMTP id
 e9e14a558f8ab-3d6e3eeab17mr5099515ab.5.1743702385834; Thu, 03 Apr 2025
 10:46:25 -0700 (PDT)
Date: Thu, 03 Apr 2025 10:46:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67eec971.050a0220.9040b.0207.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in bch2_fs_release
From: syzbot <syzbot+d35395c659ed8030c05d@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d6b13dbd03b7 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1653f7b0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=114db1c77c985e53
dashboard link: https://syzkaller.appspot.com/bug?extid=d35395c659ed8030c05d
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/fd0bf9e74cb0/disk-d6b13dbd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/50ade35a15e1/vmlinux-d6b13dbd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/986cdc664ca4/Image-d6b13dbd.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d35395c659ed8030c05d@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address e1ff9fffe0001864
KASAN: maybe wild-memory-access in range [0x1000ffff0000c320-0x1000ffff0000c327]
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[e1ff9fffe0001864] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6672 Comm: syz.4.10 Not tainted 6.14.0-syzkaller-gd6b13dbd03b7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5091
lr : lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
sp : ffff8000a46769a0
x29: ffff8000a4676c60 x28: ffff80008036e1e8 x27: 0000000000000000
x26: ffff0001b3737540 x25: 0000000000000000 x24: 0000000000000001
x23: 0000000000000000 x22: 1ffff00011faa0cd x21: 1000ffff0000c322
x20: 0000000000000001 x19: 0000000000000000 x18: 1fffe000366e6e86
x17: ffff80008fd4d000 x16: ffff8000832bccd4 x15: 0000000000000001
x14: 1ffff00011faa0cd x13: dfff800000000000 x12: ffff7000148ced5c
x11: ffff80008046f030 x10: ffff80008fd50668 x9 : 00000000000000f3
x8 : 02001fffe0001864 x7 : ffff80008036e1e8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 1000ffff0000c322
Call trace:
 __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5091 (P)
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
 __raw_spin_lock_irq include/linux/spinlock_api_smp.h:119 [inline]
 _raw_spin_lock_irq+0x58/0x70 kernel/locking/spinlock.c:170
 put_pwq_unlocked kernel/workqueue.c:1662 [inline]
 destroy_workqueue+0x8d8/0xdc0 kernel/workqueue.c:5911
 __bch2_fs_free fs/bcachefs/super.c:613 [inline]
 bch2_fs_release+0x64c/0x708 fs/bcachefs/super.c:624
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2a8/0x41c lib/kobject.c:737
 bch2_fs_free+0x2c4/0x334 fs/bcachefs/super.c:686
 bch2_fs_alloc fs/bcachefs/super.c:963 [inline]
 bch2_fs_open+0x18ac/0x299c fs/bcachefs/super.c:2065
 bch2_fs_get_tree+0x58c/0x11d4 fs/bcachefs/fs.c:2190
 vfs_get_tree+0x90/0x28c fs/super.c:1814
 do_new_mount+0x278/0x900 fs/namespace.c:3560
 path_mount+0x590/0xe04 fs/namespace.c:3887
 do_mount fs/namespace.c:3900 [inline]
 __do_sys_mount fs/namespace.c:4111 [inline]
 __se_sys_mount fs/namespace.c:4088 [inline]
 __arm64_sys_mount+0x4f4/0x5d0 fs/namespace.c:4088
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: b007c708 b9466908 340090a8 d343fea8 (386d6908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	b007c708 	adrp	x8, 0xf8e1000
   4:	b9466908 	ldr	w8, [x8, #1640]
   8:	340090a8 	cbz	w8, 0x121c
   c:	d343fea8 	lsr	x8, x21, #3
* 10:	386d6908 	ldrb	w8, [x8, x13] <-- trapping instruction


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
