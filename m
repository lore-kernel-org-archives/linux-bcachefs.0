Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00ADB27FD49
	for <linux-bcachefs@vger.kernel.org>; Wed, 11 Jun 2025 12:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749645398; cv=none; b=hSmF8fbkxTWIqIB7neDNRi4eAn3KEynkixQnXHsl2TUR38lAX44UsFAqnLPIsJEWd+BoA4tWQwLBuYYPMQEXuPQCIqM9+CESNR81M3/JMNYywFc3Lj9ahRWTu+xbOyPjS93qDqQ6OckL2UzrtVciYqoan9sJWdregeD+UdvVlXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749645398; c=relaxed/simple;
	bh=6hCeGR1+PDy6InKPfXDJV2Xjmo5VTsuBmiPzgasGZ1g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=WDlLcv2IijaO+ozVuaI0VTuAVJumlLSFco75d0bHN4mHXiJlswAoLGwxfzNdZatfCfzPnpDDbyXyYkrrBcfk3kjJV+JD5XGN7J/ZzhiyrIjG3QmlGGFRxNfLz/eFUECChe/EcErvSq9eJT0zR2Ie87O2/3hhPl5tqWAB8rl6SDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddbfe1fc8fso162007305ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 11 Jun 2025 05:36:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749645396; x=1750250196;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+4AGQ7lNt+XUfJJTRQig/pRESOqDOjLXHcuL3es+spk=;
        b=Ckif5MUPWLT87lWWbRPJeo684Hx9PQkEmKvvxdKTuCLDR++dtetLBpV3ZVbhFkyApn
         sgh0XLy8unxB2dl0DTgHgioBUub1r3bGwJgY9I6pxgGRt/mgvp7uuOMjNY+Tjppz7KSR
         K+pdrw7gOUBSfL6OSZECC8OCFLie3nA7MsjQI3Mz18n6cuKYTLB8zIx0kvec4dk7wLF3
         5oEJ1K4ksjU5f8Yv2xUJtQp7CtSIfY8YVR47TKhBQ4OKeOnpZxOV+IYFRbcLtwNgplSJ
         vCozFV65bmMomva1Sjvzp0UfGGwtnisWnP7Ifdv61XwYkvyRIvItp3/vsEDXYmJatvH2
         cLyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsnvUJllxZSNIRp5KWwD8KRJuVyc5s++mDBx/Lq23uN2oVJbZ4vE2d4fC2CU0vCCl2QAUgNoloN1um+sWUFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTkAsgADUCb/2rRrlnGfPGh4nZSEIuCeqq9UX8y7BTM+4sK+xn
	t+qFsOlZg2qmFADJR+VHIAIgvezoyWOvtu4raMaSSMWxoutmTIAMDN3aZWHhGrEOkqLKXXKxa6K
	pG+1mXHeveXj//nLkOBviqs+JJyvxmTfqKQWj9cIb6408edvnwczOtfCdWdE=
X-Google-Smtp-Source: AGHT+IH+3ymUxpN+SUkGGMRia6OOSYNq34u0RsdnOSQmYwfMQHiHSxhwjK67Rwr04ORQ0udBNGhdhAY9QPrWldQflZ2VrOXNcW48
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca06:0:b0:3dc:7f17:72e6 with SMTP id
 e9e14a558f8ab-3ddf423b10bmr31764465ab.5.1749645396053; Wed, 11 Jun 2025
 05:36:36 -0700 (PDT)
Date: Wed, 11 Jun 2025 05:36:36 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68497854.050a0220.33aa0e.036b.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_btree_iter_exit
From: syzbot <syzbot+1a64e5e20993a6c1a9f2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d7fa1af5b33e Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=177629d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=89c13de706fbf07a
dashboard link: https://syzkaller.appspot.com/bug?extid=1a64e5e20993a6c1a9f2
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1633ca0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b7f570580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/da97ad659b2c/disk-d7fa1af5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/659e123552a8/vmlinux-d7fa1af5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6ec5dbf4643e/Image-d7fa1af5.gz.xz
mounted in repro #1: https://storage.googleapis.com/syzbot-assets/9fd1de80f5c7/mount_0.gz
mounted in repro #2: https://storage.googleapis.com/syzbot-assets/db42b08e4cec/mount_1.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a64e5e20993a6c1a9f2@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6496 at kernel/rcu/srcutree.c:695 cleanup_srcu_struct+0x420/0x504 kernel/rcu/srcutree.c:718
Modules linked in:
CPU: 0 UID: 0 PID: 6496 Comm: syz-executor216 Not tainted 6.15.0-rc7-syzkaller-gd7fa1af5b33e #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : cleanup_srcu_struct+0x420/0x504 kernel/rcu/srcutree.c:718
lr : cleanup_srcu_struct+0x2b8/0x504 kernel/rcu/srcutree.c:694
sp : ffff8000a4f079b0
x29: ffff8000a4f079d0 x28: 1ffff00011d84e4b x27: 1fffe0001da80844
x26: ffff80008ec27000 x25: dfff800000000000 x24: fffffdffbf7693c8
x23: fffffdffbf769300 x22: ffff0000ed404220 x21: ffffffffffffffff
x20: ffff80008f321e88 x19: 0000000000000001 x18: 1fffe0003386aa76
x17: ffff80008f31e000 x16: ffff80008adbeaf4 x15: 0000000000000001
x14: 1fffffbff7eed28c x13: 0000000000000000 x12: 0000000000000000
x11: ffff7fbff7eed28d x10: 0000000000ff0100 x9 : 96b044024d34f400
x8 : 0000000000000006 x7 : ffff800080433050 x6 : 0000000000000000
x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff800080422d24
x2 : 0000000000000000 x1 : 0000000000000080 x0 : 0000000000000000
Call trace:
 cleanup_srcu_struct+0x420/0x504 kernel/rcu/srcutree.c:718 (P)
 bch2_fs_btree_iter_exit+0x380/0x420 fs/bcachefs/btree_iter.c:3617
 __bch2_fs_free fs/bcachefs/super.c:564 [inline]
 bch2_fs_release+0x24c/0x72c fs/bcachefs/super.c:618
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2b0/0x438 lib/kobject.c:737
 bch2_fs_free+0x308/0x378 fs/bcachefs/super.c:681
 bch2_kill_sb+0x48/0x58 fs/bcachefs/fs.c:2623
 deactivate_locked_super+0xc4/0x12c fs/super.c:473
 deactivate_super+0xe0/0x100 fs/super.c:506
 cleanup_mnt+0x31c/0x3ac fs/namespace.c:1431
 __cleanup_mnt+0x20/0x30 fs/namespace.c:1438
 task_work_run+0x1dc/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 do_notify_resume+0x16c/0x1ec arch/arm64/kernel/entry-common.c:151
 exit_to_user_mode_prepare arch/arm64/kernel/entry-common.c:169 [inline]
 exit_to_user_mode arch/arm64/kernel/entry-common.c:178 [inline]
 el0_svc+0xb4/0x17c arch/arm64/kernel/entry-common.c:768
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
irq event stamp: 324162
hardirqs last  enabled at (324161): [<ffff80008addfa48>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (324161): [<ffff80008addfa48>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:194
hardirqs last disabled at (324162): [<ffff80008adb9eb8>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:511
softirqs last  enabled at (322512): [<ffff8000803cf71c>] softirq_handle_end kernel/softirq.c:425 [inline]
softirqs last  enabled at (322512): [<ffff8000803cf71c>] handle_softirqs+0xaf8/0xc88 kernel/softirq.c:607
softirqs last disabled at (322371): [<ffff800080020efc>] __do_softirq+0x14/0x20 kernel/softirq.c:613
---[ end trace 0000000000000000 ]---
bcachefs (loop4): shutting down
bcachefs (loop4): going read-only
bcachefs (loop4): finished waiting for writes to stop
bcachefs (loop4): flushing journal and stopping allocators, journal seq 3
bcachefs (loop4): flushing journal and stopping allocators complete, journal seq 3
bcachefs (loop4): clean shutdown complete, journal seq 4
bcachefs (loop4): marking filesystem clean
bcachefs (loop4): shutdown complete


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
