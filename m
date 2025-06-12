Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8B1F3D56
	for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 07:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749714743; cv=none; b=IfXMR6z1WD7gaTgadbGjH7LETiJv495MJIwlDLO+73VTIj6jxaGszWHieYBi2awgB3ovz7VTDxbjFpZne+0Oeec9VVHYZurpEUqMqPuSlsv3GUbeHzc+q4Lea4lNcHIOzTH+nObFCK6cOqcE7AfuSlFWDaU44jSL+A6c2vsbG5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749714743; c=relaxed/simple;
	bh=lrfz2Yk3K2QHeSihfduCenLg/V2a6j+mpqjUFZ9a4A8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JtzIG9dG4FDrzd4l+4ceDiQv6gWJbSJWVHs7lPttLkHaywwSQKUtAbpTs3wmIz6+VISEwpl1MXG4gfgJHnRJZ+QKRY4HbpvRotq3M3Ea9XKwrWpIEDVL7VGIqx8m/+/o9sL5wAhGIhtAbBlelWPdMN6S2iYTAGSUxNXFKwzELVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3ddcb80387dso6164935ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 12 Jun 2025 00:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749714740; x=1750319540;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pX0pCA/spayx82TVldyOfyWMgTM4hCg5RuWaGrqjgfc=;
        b=KZPmHq0Api366clRm7iNu/tyANQG/EM5tOJsgq1pm5scmI5f8QXzwzBp+DIt1W2zGY
         tefc28Upi7qfeLzWdqQUJhfwxqTq8pAFx3AYFXIml5PxmoL3o5b3eyo0XEeIRSNdFZEU
         l1hMI50nU5QdnaR7OBiUbH6Wl+mid4rWQHLZb1jk2DUmvG76ky0Gei5nQ+aXNZu/x2Hz
         LB50vme8Nb8zgQWORQLuNSTWHz5SNKQVQQkPCm1d7JHI79eBbYq/pGVTtXGwV1kqgVIH
         iX/MgFk0oJOlf/htuXNuiU6qpAVH8d2c8BPbaEsjgA+VLtAj+M11SKoFvpb+FUloqZIT
         W5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWPAUyrx+cmnwqQHDb1xAydeIA2UCe52mRkVX31xiEdgSeZea544bzrMPBSQoVIjVv5MgFfFqU3TnPgC1GegA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4kMV+2Run/2iae8SjurVoEV4ZWWvIM9oM3+rlaKg4VK80DBsj
	AdCQz6rvgHDrKsSS/bpK6dSPizrRz90DA52txweALGYI4eztg/drc6KfYYP6NCCCDcMmWuUwIkn
	8WWaTvVE5BjcR0kg+3bnkOlutnwfXK3uVFPv615ADPlDNkovNm5/+vWeyMyQ=
X-Google-Smtp-Source: AGHT+IEVLerCXfQhi60ZCYvwG6rBOHBB2+VcrtYagZ28XxW6a87Er+2avDzNoWBfA0n9iNx4qqmAoJ84k0zm9oST1F4jFKKk2Un9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c24d:0:b0:3dd:e6b2:1078 with SMTP id
 e9e14a558f8ab-3ddfadd42camr23973175ab.6.1749714740658; Thu, 12 Jun 2025
 00:52:20 -0700 (PDT)
Date: Thu, 12 Jun 2025 00:52:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684a8734.050a0220.be214.028d.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in __init_work (2)
From: syzbot <syzbot+011218db4fea20179df3@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    19272b37aa4f Linux 6.16-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=174ea10c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8409c4d4e51ac27
dashboard link: https://syzkaller.appspot.com/bug?extid=011218db4fea20179df3
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17096d70580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10976e0c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/92d22b0c6493/disk-19272b37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fb0142bb63a/vmlinux-19272b37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d5f3836ae42/Image-19272b37.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e49d008f1550/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+011218db4fea20179df3@syzkaller.appspotmail.com

ODEBUG: object 000000004394caab is on stack 0000000077db2857, but NOT annotated.
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6533 at lib/debugobjects.c:655 debug_object_is_on_stack lib/debugobjects.c:-1 [inline]
WARNING: CPU: 0 PID: 6533 at lib/debugobjects.c:655 lookup_object_or_alloc lib/debugobjects.c:688 [inline]
WARNING: CPU: 0 PID: 6533 at lib/debugobjects.c:655 __debug_object_init+0x364/0x40c lib/debugobjects.c:743
Modules linked in:
CPU: 0 UID: 0 PID: 6533 Comm: bch-copygc/loop Not tainted 6.16.0-rc1-syzkaller-g19272b37aa4f #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : debug_object_is_on_stack lib/debugobjects.c:-1 [inline]
pc : lookup_object_or_alloc lib/debugobjects.c:688 [inline]
pc : __debug_object_init+0x364/0x40c lib/debugobjects.c:743
lr : debug_object_is_on_stack lib/debugobjects.c:-1 [inline]
lr : lookup_object_or_alloc lib/debugobjects.c:688 [inline]
lr : __debug_object_init+0x364/0x40c lib/debugobjects.c:743
sp : ffff80009bd57700
x29: ffff80009bd57700 x28: 0000000000000000 x27: dfff800000000000
x26: ffff800097589000 x25: ffff0000cb6c9ea0 x24: 0000000000000000
x23: ffff0000cc399428 x22: 0000000000000000 x21: ffff800097467ee8
x20: ffff80008af00de0 x19: ffff80009bd57bb0 x18: 00000000ffffffff
x17: ffff800093215000 x16: ffff80008ae5617c x15: 0000000000000001
x14: 1ffff000137aae58
 x13: 0000000000000000 x12: 0000000000000000
x11: ffff7000137aae59 x10: 0000000000ff0100 x9 : c1ad3b4b6b986d00
x8 : c1ad3b4b6b986d00 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80009bd57098 x4 : ffff80008f657060 x3 : ffff8000807bb744
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 0000000000000050
Call trace:
 debug_object_is_on_stack lib/debugobjects.c:-1 [inline] (P)
 lookup_object_or_alloc lib/debugobjects.c:688 [inline] (P)
 __debug_object_init+0x364/0x40c lib/debugobjects.c:743 (P)
 debug_object_init+0x20/0x2c lib/debugobjects.c:779
 __init_work+0x58/0x68 kernel/workqueue.c:677
 rhashtable_init_noprof+0x734/0xa10 lib/rhashtable.c:1085
 bch2_copygc_thread+0xec/0xd40 fs/bcachefs/movinggc.c:353
 kthread+0x5fc/0x75c kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
irq event stamp: 18
hardirqs last  enabled at (17): [<ffff800083e501f4>] get_random_u32+0x2d4/0x540 drivers/char/random.c:554
hardirqs last disabled at (18): [<ffff80008ae77604>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (18): [<ffff80008ae77604>] _raw_spin_lock_irqsave+0x2c/0x7c kernel/locking/spinlock.c:162
softirqs last  enabled at (0): [<ffff8000803aab44>] copy_process+0x1134/0x31ec kernel/fork.c:2114
softirqs last disabled at (0): [<0000000000000000>] 0x0
---[ end trace 0000000000000000 ]---


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
