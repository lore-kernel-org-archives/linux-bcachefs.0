Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271DD1EC006
	for <linux-bcachefs@vger.kernel.org>; Sat, 10 May 2025 13:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746884963; cv=none; b=mKIKUghN/QIlivACghD6FYF2nsZaHnH54n0l4i+PqfYzTdgdTnbLVl06Wxc1B6EiYM95Dcd5W0kR6prw3GeWZ2qzbHAHpbJMjM2rE4/j7y+RRzon47Ks8CTjqsL8+1922NClRO0V1zHZIw51wN3KUuwHdQHkLvq5YWDveZH4kBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746884963; c=relaxed/simple;
	bh=OrsFK+ZS7TM0uUGbmoMltUnue9SFjzb0xvf2VP/9Bxs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=mWm4Zdm2aknTpXQI1/YYhWtrWlki/etCWu2XFcvUGmicquQlo77dXvVr2MdjDNoN1pi4yp6T+KixlWT16yW7NBFKyPhE4Wl3dXb2b3fGrQAh0XVokGiMFerUIndvbbzOdVgoLafqYGYKWBeZd/TXUULXj8fGDpiMoxUsK4okZxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3da720e0c93so68751535ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 10 May 2025 06:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746884961; x=1747489761;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zjKAt51Ib6tJ6ZlFjMQvjnLQ7buOFeQS+pgmgxdFTsg=;
        b=ez9ch/w49G2ydsnZZdI6jExcmYePJLq0/zn3ebJ2EC5FdL1ZwZuoeAbuNo4AksmRps
         JJUpFXnHkgxchsYwHosQeelkhHtFf/NXTZsfmW9lMZGVjBq/BW1x7RhHQbk2ILZbPTfK
         4//5QxrzNAs8TpnqCm2Vtk6dLf9GMrYTh9Km1/VeHFEUCjQmK++GLWLAyEmu5LQKS2qt
         zsJhYg19a+u4jpb7W829NKN6vyELlBGAW2pLaUKBEi6XWXU8CSEQOa9zmH66mbe1dWrS
         0XClcjc/rVuo/fbSXLQbymx/3KJtWPLrI/31PoIhmk8DFQtL1s/r44ifhLV/yHHelzLz
         TABw==
X-Forwarded-Encrypted: i=1; AJvYcCVuYUcQuWl/x50L4eT5jN2lu621dFB4BinbL/AnhRNt3vqmLtuVoK1/Ys1RKsfZHBK77i/WGO7ogwjMLAD5HA==@vger.kernel.org
X-Gm-Message-State: AOJu0YydfxxCKsWJSnY5edlPeLhiCDy2pExE+PoNF/DQdL8PalSpkgia
	EGeigTf9hVS2sasUiG0otCOZb0/qfwhg5gB9R323YQZquISCxIR03HawHO5pNB6jIey6hBbk+fX
	ru6GAuWv/NxbNLU5O53l94V+ozg6TOpZeDxD48s4ebcZeXfk1d2LoUTQ=
X-Google-Smtp-Source: AGHT+IEfkOrNLDdmY3UsxnMBWH9eSicn8iesn0Lhbax5hADxAUqAasNQcEe/WHCuIeo6ixihilk9O5J/o0Oe8KBaBfDJy3pfsJeM
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:220b:b0:3d4:2409:ce6 with SMTP id
 e9e14a558f8ab-3da7e1e59e3mr83739225ab.5.1746884961239; Sat, 10 May 2025
 06:49:21 -0700 (PDT)
Date: Sat, 10 May 2025 06:49:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <681f5961.050a0220.f2294.000f.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in rcu_segcblist_advance
From: syzbot <syzbot+180ee4715c8ed6d72258@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c32f8dc5aaf9 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=12c96cf4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ea4635ffd6ad5b4a
dashboard link: https://syzkaller.appspot.com/bug?extid=180ee4715c8ed6d72258
compiler:       Debian clang version 20.1.2 (++20250402124445+58df0ef89dd6-1~exp1~20250402004600.97), Debian LLD 20.1.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11004cf4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b921498959d4/disk-c32f8dc5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/04e6ad946c4b/vmlinux-c32f8dc5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d4f0d8db50ee/Image-c32f8dc5.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/cd47245ef994/mount_17.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+180ee4715c8ed6d72258@syzkaller.appspotmail.com

  allowing incompatible features above 0.0: (unknown version)
bcachefs (loop2): initializing new filesystem
bcachefs (loop2): going read-write
bcachefs (loop2): marking superblocks
Unable to handle kernel paging request at virtual address fffffdfffffffdff
KASAN: maybe wild-memory-access in range [0x0003efffffffeff8-0x0003efffffffefff]
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
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000207bf8000
[fffffdfffffffdff] pgd=0000000000000000, p4d=100000023ea67403, pud=100000023ea66403, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6884 Comm: syz.2.18 Not tainted 6.15.0-rc5-syzkaller-gc32f8dc5aaf9 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : rcu_segcblist_restempty kernel/rcu/rcu_segcblist.h:105 [inline]
pc : rcu_segcblist_advance+0x84/0x368 kernel/rcu/rcu_segcblist.c:474
lr : srcu_gp_start_if_needed+0x568/0x10d0 kernel/rcu/srcutree.c:1316
sp : ffff80009b8661f0
x29: ffff80009b8661f0 x28: fffffdffbf72d2c0 x27: 00000000000000c0
x26: dfff800000000000 x25: 1fffffbff7ee5a61 x24: dfff800000000000
x23: ffff0000cda92980 x22: fffffdfffffffdff x21: fffffffffffffe70
x20: fffffdffbf72d308 x19: fffffdffbf72d300 x18: 0000000000000000
x17: 0000000000000000 x16: ffff80008adb421c x15: ffff70001370cc34
x14: 1ffff0001370cc34 x13: 0000000000000004 x12: ffffffffffffffff
x11: 000000001372e057 x10: 0000000000000003 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff80008059d5f8 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff80008ae837c0
x2 : 0000000000000008 x1 : fffffffffffffe70 x0 : fffffdffbf72d300
Call trace:
 rcu_segcblist_restempty kernel/rcu/rcu_segcblist.h:105 [inline] (P)
 rcu_segcblist_advance+0x84/0x368 kernel/rcu/rcu_segcblist.c:474 (P)
 srcu_gp_start_if_needed+0x568/0x10d0 kernel/rcu/srcutree.c:1316
 __call_srcu kernel/rcu/srcutree.c:1389 [inline]
 call_srcu+0xc8/0xe0 kernel/rcu/srcutree.c:1416
 __call_rcu+0x38/0x60 fs/bcachefs/rcu_pending.c:76
 __rcu_pending_enqueue fs/bcachefs/rcu_pending.c:497 [inline]
 rcu_pending_enqueue+0x70c/0x840 fs/bcachefs/rcu_pending.c:531
 bkey_cached_free+0xb8/0x1c4 fs/bcachefs/btree_key_cache.c:115
 bch2_btree_key_cache_drop+0x10c/0x5c8 fs/bcachefs/btree_key_cache.c:619
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:772 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:844 [inline]
 __bch2_trans_commit+0x4ac8/0x62d0 fs/bcachefs/btree_trans_commit.c:1050
 bch2_trans_commit fs/bcachefs/btree_update.h:195 [inline]
 bch2_trans_mark_metadata_bucket+0x328/0xe14 fs/bcachefs/buckets.c:1052
 bch2_trans_mark_metadata_sectors fs/bcachefs/buckets.c:1069 [inline]
 __bch2_trans_mark_dev_sb fs/bcachefs/buckets.c:1109 [inline]
 bch2_trans_mark_dev_sb+0x318/0x67c fs/bcachefs/buckets.c:1137
 bch2_trans_mark_dev_sbs_flags+0x6f4/0x754 fs/bcachefs/buckets.c:1147
 bch2_trans_mark_dev_sbs+0x24/0x34 fs/bcachefs/buckets.c:1159
 bch2_fs_initialize+0x8cc/0x10ac fs/bcachefs/recovery.c:1153
 bch2_fs_start+0x5a0/0x908 fs/bcachefs/super.c:1092
 bch2_fs_get_tree+0xa0c/0xf30 fs/bcachefs/fs.c:2570
 vfs_get_tree+0x90/0x28c fs/super.c:1759
 do_new_mount+0x228/0x814 fs/namespace.c:3884
 path_mount+0x5b4/0xde0 fs/namespace.c:4211
 do_mount fs/namespace.c:4224 [inline]
 __do_sys_mount fs/namespace.c:4435 [inline]
 __se_sys_mount fs/namespace.c:4412 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4412
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x17c arch/arm64/kernel/entry-common.c:767
 el0t_64_sync_handler+0x78/0x108 arch/arm64/kernel/entry-common.c:786
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: 38786908 34000068 aa1603e0 94197940 (f94002c8) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	38786908 	ldrb	w8, [x8, x24]
   4:	34000068 	cbz	w8, 0x10
   8:	aa1603e0 	mov	x0, x22
   c:	94197940 	bl	0x65e50c
* 10:	f94002c8 	ldr	x8, [x22] <-- trapping instruction


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
