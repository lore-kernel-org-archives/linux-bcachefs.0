Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87468D530
	for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 16:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723913432; cv=none; b=My5mzuIN88e6tueDEJLSnKZojXXKcWIV3HEvdVhno/EOETOtKtKhWMBCHcSCf2g+hoguaF0+rL9tqmBJxLaLrH4PeUL+kR77RJA0KLlt8n/045nSxxySE8lMjY5sYqLI5TVLsI207fQPBKBPzxsyjIRW/TIhb067rHiPYq+oU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723913432; c=relaxed/simple;
	bh=K78HzGd0jKFk7ukR56CQN1mMlgjGCLEiGvSEGC/1IIE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hLFhrZhTnbN1EUEzl8xmCTL8Uz8pXtK/09HJRYVXNJCqt2h83Uz60IxjuvKwWC98iMtzAzYYvKHuIsHrLuGGjzPWXp8pKTTDDQdFeVL0cJU2bFxd5P0Cyyc2MepSRMUao65geGtjydDTDYdc3PdaPeWiG9Gqmc2QgYnc4EdX71Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-81f87635cc1so297547039f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 17 Aug 2024 09:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723913429; x=1724518229;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WHSRz5XXTUnRmGfgXLWOeFUnFKr08MMs70Tz97IA3HM=;
        b=R9vWhLow8gWrqLZQ90MjRwpXVFxsbcVz+rvngLNnYsTQT2tFdVkBAW5urQqIJfguvF
         wRlJvvG40kxBeQJBmlOho79OxEsobKAQU2lmrZISm8njCh7wH8CdbVncJBBLJl597DOF
         Zg0sEwwtq4f1Aku9J9S1H3S3O81T9RYZJtO1xA+GmE3jS+YTghPzLoprppg+cw8/d8FI
         RMIFHK+5/qkk8O0HNA4UVI7/lufeJuBL4XGxTnYrdlvEg9hbErP587nkCd9yngAAS/5E
         TsJgLeL5lBVk2Cs3M8teK5Cb24JxzL+XW01vmQ247ctmZugnYtm3eAlnJ6szru07Nf/Y
         F+bw==
X-Forwarded-Encrypted: i=1; AJvYcCWGFP/DIK+nVe8yi7p02OkbOrwaOSwVbt2EspFvraxHZwUikXgyWW1MyHkpJqWoTO9NshRlfuVPNSOKmFycGofvFa+z/IOm0AO+KrOnY30=
X-Gm-Message-State: AOJu0YxrIi8c4BVe6k4H3S17T2IFLNlGvNRDBRmI7DUy8jMSdT3cCIlr
	sCXh+N4BuDbTJ8r2tlA0amRHpfJpQAsk7cNo/4CWejVvGySYGBi7oVPGvQkJwMAwJz3vIzlq/V4
	PV5e+ZTpN4qmrzTU3yvUJlE3SJr2CjFIKV5zZnpg7Q2c7FWAjCaQzqrM=
X-Google-Smtp-Source: AGHT+IHCM1FhTeYc1KgYCBeY5Eo9pcXn1lcefNh8MEYcWyOzJSHJVZYWfq2AjFQGi83iwTtdd4azrtosyNFY7FFtLVwMV49uzT5Q
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:8917:b0:4c1:b049:25f with SMTP id
 8926c6da1cb9f-4cce15cc51dmr322833173.1.1723913429594; Sat, 17 Aug 2024
 09:50:29 -0700 (PDT)
Date: Sat, 17 Aug 2024 09:50:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000983fad061fe3df80@google.com>
Subject: [syzbot] [bcachefs?] WARNING in __virt_to_phys (5)
From: syzbot <syzbot+e199425e3ce5a18d178c@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8867bbd4a056 mm: arm64: Fix the out-of-bounds issue in con..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14240e91980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1bc88a9f65787e86
dashboard link: https://syzkaller.appspot.com/bug?extid=e199425e3ce5a18d178c
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5ef30d34e749/disk-8867bbd4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/a21c2389ebfb/vmlinux-8867bbd4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9720b12c3f99/Image-8867bbd4.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e199425e3ce5a18d178c@syzkaller.appspotmail.com

bcachefs (loop4): done starting filesystem
------------[ cut here ]------------
virt_to_phys used for non-linear address: fffffffffffffff2 (0xfffffffffffffff2)
WARNING: CPU: 0 PID: 6849 at arch/arm64/mm/physaddr.c:15 __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
Modules linked in:
CPU: 0 PID: 6849 Comm: syz.4.112 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
lr : __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
sp : ffff8000a03b6c00
x29: ffff8000a03b6c00 x28: 0000000000000002 x27: 1ffff00014076d98
x26: 1ffff00014076d94 x25: dfff800000000000 x24: fffffffffffffff2
x23: ffff0000c96a2220 x22: 000f600000000000 x21: 000000000000002d
x20: fffffffffffffff2 x19: 000ffffffffffff2 x18: 1fffe000367a01de
x17: ffff80008f3bd000 x16: ffff80008033878c x15: 0000000000000001
x14: 1fffe000367a2e00 x13: 0000000000000000 x12: 0000000000000003
x11: 0000000000000001 x10: 0000000000000003 x9 : c187ea6d31d9c500
x8 : c187ea6d31d9c500 x7 : ffff8000802aebf8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000dc418000 x1 : ffff80008b3800a0 x0 : ffff8001249f9000
Call trace:
 __virt_to_phys+0xc4/0x138 arch/arm64/mm/physaddr.c:12
 virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
 virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
 virt_to_folio include/linux/mm.h:1313 [inline]
 kfree+0xa4/0x3f4 mm/slub.c:4549
 bch2_ioctl_fsck_online+0x358/0x580 fs/bcachefs/chardev.c:853
 bch2_fs_ioctl+0x23ec/0x3980 fs/bcachefs/chardev.c:927
 bch2_fs_file_ioctl+0x7b8/0x2460 fs/bcachefs/fs-ioctl.c:539
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
irq event stamp: 80570
hardirqs last  enabled at (80569): [<ffff8000802aec98>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1418 [inline]
hardirqs last  enabled at (80569): [<ffff8000802aec98>] finish_lock_switch+0xbc/0x1e4 kernel/sched/core.c:5162
hardirqs last disabled at (80570): [<ffff80008b1fe010>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
softirqs last  enabled at (80550): [<ffff8000801ea530>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (80550): [<ffff8000801ea530>] handle_softirqs+0xa60/0xc34 kernel/softirq.c:582
softirqs last disabled at (80541): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
---[ end trace 0000000000000000 ]---
Unable to handle kernel paging request at virtual address ffffffffc375ffc8
KASAN: maybe wild-memory-access in range [0x0003fffe1baffe40-0x0003fffe1baffe47]
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
swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000001ac6da000
[ffffffffc375ffc8] pgd=0000000000000000, p4d=00000001afff8003, pud=00000001afff9003, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 6849 Comm: syz.4.112 Tainted: G        W          6.10.0-rc2-syzkaller-g8867bbd4a056 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
pstate: 80400005 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : _compound_head include/linux/page-flags.h:245 [inline]
pc : virt_to_folio include/linux/mm.h:1315 [inline]
pc : kfree+0xbc/0x3f4 mm/slub.c:4549
lr : virt_to_phys arch/arm64/include/asm/memory.h:368 [inline]
lr : virt_to_pfn arch/arm64/include/asm/memory.h:382 [inline]
lr : virt_to_folio include/linux/mm.h:1313 [inline]
lr : kfree+0xa4/0x3f4 mm/slub.c:4549
sp : ffff8000a03b6c30
x29: ffff8000a03b6c40 x28: 0000000000000002 x27: 1ffff00014076d98
x26: 1ffff00014076d94 x25: dfff800000000000 x24: fffffffffffffff2
x23: ffff0000c96a2220 x22: ffff0000ef24a2d0 x21: fffffffffffffff2
x20: ffffffffc375ffc0 x19: ffff8000828128a8 x18: 1fffe000367a01de
x17: ffff80008f3bd000 x16: ffff80008033878c x15: 0000000000000001
x14: 1fffe000367a2e00 x13: 0000000000000000 x12: 0000000000000003
x11: 0000000000040000 x10: 0000000000015b3d x9 : 00003e000375ffc0
x8 : ffffc1ffc0000000 x7 : ffff8000802aebf8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : ffff0000dc418000 x1 : ffff80008b3800a0 x0 : 000080011d7ffff2
Call trace:
 virt_to_folio include/linux/mm.h:1313 [inline]
 kfree+0xbc/0x3f4 mm/slub.c:4549
 bch2_ioctl_fsck_online+0x358/0x580 fs/bcachefs/chardev.c:853
 bch2_fs_ioctl+0x23ec/0x3980 fs/bcachefs/chardev.c:927
 bch2_fs_file_ioctl+0x7b8/0x2460 fs/bcachefs/fs-ioctl.c:539
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:907 [inline]
 __se_sys_ioctl fs/ioctl.c:893 [inline]
 __arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:893
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: 927acd29 f2d83fe8 cb141929 8b080134 (f9400688) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	927acd29 	and	x9, x9, #0x3ffffffffffffc0
   4:	f2d83fe8 	movk	x8, #0xc1ff, lsl #32
   8:	cb141929 	sub	x9, x9, x20, lsl #6
   c:	8b080134 	add	x20, x9, x8
* 10:	f9400688 	ldr	x8, [x20, #8] <-- trapping instruction


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
