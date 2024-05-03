Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C3156C5E
	for <linux-bcachefs@vger.kernel.org>; Fri,  3 May 2024 16:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714754844; cv=none; b=iTYPF9TYU5o+bebXcEEbfs6PNKsWf1h8m53uvfY5GY17ldk3iF14pyUJMHHf/EpXmS0T7GBM0MIYPyDlR5MQik4tKpL9cZo55BJzzc7pIaGaB/mUZu2ST6ObjncIiKPGjThZPKmajK82XLoJA17F2By0fmHatCsen6nJ3gFYux0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714754844; c=relaxed/simple;
	bh=YYwepeePkijgkT4cPDmiFifUSmHB0zHBAcVI5kGTPf8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=r16UVP85X09g7Ak49XTiMNuYBXsx/KqQSf3XRfuCq+6lCv4QG2vOKgNni1xVRLD3V9Eprp28Jf8mad/Yqj7Gcu6n7r1UW95hN8aiUJaZrGoFkYd3b3sANf//as0G/MvfFVy9KjOSHeecoXWVQCCY8rnZBI0kt/pu4tYe3lqh4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7de9c6b7a36so978562439f.1
        for <linux-bcachefs@vger.kernel.org>; Fri, 03 May 2024 09:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714754842; x=1715359642;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xGZsHUUo8jw065nsmI0c4WQ+Fpe4fxWGBJML8EfnTGI=;
        b=pmb0LZIPbn/EToHu0x8nG9lHFHBmGZpGrppWgNdga4u45QYYragG4UgPM1S9Wv88tA
         dk7ktTjUcUej9wPsFpOWPJArVWYpeWKAG9nPCcor9O2jrMRL8CDiqKag5aNefLvN2eRp
         /WCqYFxht7TQ04QNtRWMdmNWQpWLXK1ttU8PYjOFp+dIVg9P2ERqTmxWDRLd8Vpvn0nW
         9z6wZ3m0OJzBKNjU+UXLFxUPVg5pAbZmqwLZvgrgZWvCdlDZSswnrDNVj5jSQQIyKNv9
         vGKStvCNo6V1wumQ937jXExzqo8EWjteOUXNyohQl1B33lpInI2vJJrK7u8PI7cbH1l0
         +/sw==
X-Forwarded-Encrypted: i=1; AJvYcCUVPKhzhy8mS54G/Qa5YecgEwAf8Uybc7xRK7Ftbj6qpq5eD6gX5TRJtStNe1mpoHHSfpg4yMo6QA8GD63NVIqzWxCjV3LevqxxAjsFMMQ=
X-Gm-Message-State: AOJu0YyQOvEoSrl0oGLYLKcWCSbcHSzJl8otWiOQZdOKkuyZQ7UXVMl8
	xQ+XdB1hxroFOHtWkn1gQrqilwmLRwswSl1aCkq+OBLOzDZWEp4W1dFvA1okqJD/9xkaAl8ebqq
	p5mFNwbw6lOBN6/bxc6bLsz0I3kBODRTfVw8UY25isnZOsBhZDea6GK0=
X-Google-Smtp-Source: AGHT+IFqaVjrHilv46QxdAUYF5hN3r+rgxzFI7hhnU/+44ZWJIieQczY/mRpSacDLBTdtEUTcX8EimHXRyOoeOkZB9DQiOdhm69H
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8320:b0:488:59cc:eb54 with SMTP id
 io32-20020a056638832000b0048859cceb54mr38688jab.3.1714754842634; Fri, 03 May
 2024 09:47:22 -0700 (PDT)
Date: Fri, 03 May 2024 09:47:22 -0700
In-Reply-To: <0000000000003355e706178d7a8a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000045bc2e06178f79e6@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in __virt_to_phys (3)
From: syzbot <syzbot+3333603f569fc2ef258c@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    6a71d2909427 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=10c8ea2f180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fca646cf17cc616b
dashboard link: https://syzkaller.appspot.com/bug?extid=3333603f569fc2ef258c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1618e660980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f44a2f180000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c77d21fa1405/disk-6a71d290.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/429fcd369816/vmlinux-6a71d290.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d3d8a4b85112/Image-6a71d290.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/f31e8145d293/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3333603f569fc2ef258c@syzkaller.appspotmail.com

bcachefs (loop0): inconsistency detected - emergency read only at journal seq 0
------------[ cut here ]------------
virt_to_phys used for non-linear address: fffffffffffff75e (0xfffffffffffff75e)
WARNING: CPU: 1 PID: 6236 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
Modules linked in:
CPU: 1 PID: 6236 Comm: syz-executor237 Not tainted 6.9.0-rc4-syzkaller-g6a71d2909427 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
pstate: 60401005 (nZCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
lr : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
sp : ffff8000a05d6e00
x29: ffff8000a05d6e00 x28: 1ffff000140bae02 x27: fffffffffffff75e
x26: ffff8000a05d7010 x25: ffff7000140badf4 x24: dfff800000000000
x23: ffff0000e1000000 x22: 000f600000000000 x21: 000000000000002d
x20: fffffffffffff75e x19: 000ffffffffff75e x18: 1fffe000367bdd96
x17: ffff80008ee7d000 x16: ffff800080333fec x15: 0000000000000001
x14: 1fffe0001abcfe00 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001abcfe01 x10: 1fffe0001abcfe00 x9 : 08be2e043077f700
x8 : 08be2e043077f700 x7 : ffff8000802aabc8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080296e70
x2 : 0000000000000001 x1 : 0000000000000004 x0 : 0000000000000001
Call trace:
 __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
 virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
 virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
 virt_to_folio include/linux/mm.h:1304 [inline]
 kfree+0xa4/0x3e8 mm/slub.c:4382
 bch2_fs_recovery+0x32c/0x4854 fs/bcachefs/recovery.c:902
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1042
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2101
 bch2_mount+0x558/0xe10 fs/bcachefs/fs.c:1900
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1779
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
irq event stamp: 75602
hardirqs last  enabled at (75601): [<ffff8000802aac68>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1397 [inline]
hardirqs last  enabled at (75601): [<ffff8000802aac68>] finish_lock_switch+0xbc/0x1e4 kernel/sched/core.c:5163
hardirqs last disabled at (75602): [<ffff80008ae6da08>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
softirqs last  enabled at (75492): [<ffff8000800218e4>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (75492): [<ffff8000800218e4>] __do_softirq+0xb10/0xd2c kernel/softirq.c:583
softirqs last disabled at (75397): [<ffff80008002ad34>] ____do_softirq+0x14/0x20 arch/arm64/kernel/irq.c:81
---[ end trace 0000000000000000 ]---
Unable to handle kernel paging request at virtual address ffffffffc37affc8
KASAN: maybe wild-memory-access in range [0x0003fffe1bd7fe40-0x0003fffe1bd7fe47]
Mem abort info:
  ESR = 0x0000000096000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001ad5bd000
[ffffffffc37affc8] pgd=0000000000000000, p4d=00000001b0d98003, pud=00000001b0d99003, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 6236 Comm: syz-executor237 Tainted: G        W          6.9.0-rc4-syzkaller-g6a71d2909427 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
pstate: 80401005 (Nzcv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
pc : _compound_head include/linux/page-flags.h:247 [inline]
pc : virt_to_folio include/linux/mm.h:1306 [inline]
pc : kfree+0xbc/0x3e8 mm/slub.c:4382
lr : virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
lr : virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
lr : virt_to_folio include/linux/mm.h:1304 [inline]
lr : kfree+0xa4/0x3e8 mm/slub.c:4382
sp : ffff8000a05d6e30
x29: ffff8000a05d6e40 x28: 1ffff000140bae02 x27: fffffffffffff75e
x26: ffff8000a05d7010 x25: ffff7000140badf4 x24: dfff800000000000
x23: ffff0000e1000000 x22: 0000000000000001 x21: ffffffffc37affc0
x20: ffff80008293e95c x19: fffffffffffff75e x18: 1fffe000367bdd96
x17: ffff80008ee7d000 x16: ffff800080333fec x15: 0000000000000001
x14: 1fffe0001abcfe00 x13: 0000000000000000 x12: 0000000000000000
x11: ffff60001abcfe01 x10: 0000000000ff0100 x9 : 00003e00037affc0
x8 : ffffc1ffc0000000 x7 : ffff8000802aabc8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff800080296e70
x2 : 0000000000000001 x1 : 0000000000000004 x0 : 000080011ebff75e
Call trace:
 virt_to_folio include/linux/mm.h:1304 [inline]
 kfree+0xbc/0x3e8 mm/slub.c:4382
 bch2_fs_recovery+0x32c/0x4854 fs/bcachefs/recovery.c:902
 bch2_fs_start+0x30c/0x53c fs/bcachefs/super.c:1042
 bch2_fs_open+0x8b4/0xb64 fs/bcachefs/super.c:2101
 bch2_mount+0x558/0xe10 fs/bcachefs/fs.c:1900
 legacy_get_tree+0xd4/0x16c fs/fs_context.c:662
 vfs_get_tree+0x90/0x288 fs/super.c:1779
 do_new_mount+0x278/0x900 fs/namespace.c:3352
 path_mount+0x590/0xe04 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __arm64_sys_mount+0x45c/0x594 fs/namespace.c:3875
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 927acd29 f2d83fe8 cb151929 8b080135 (f94006a8) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	927acd29 	and	x9, x9, #0x3ffffffffffffc0
   4:	f2d83fe8 	movk	x8, #0xc1ff, lsl #32
   8:	cb151929 	sub	x9, x9, x21, lsl #6
   c:	8b080135 	add	x21, x9, x8
* 10:	f94006a8 	ldr	x8, [x21, #8] <-- trapping instruction


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
