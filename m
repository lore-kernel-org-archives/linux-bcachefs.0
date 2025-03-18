Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9065CEEBD
	for <linux-bcachefs@vger.kernel.org>; Tue, 18 Mar 2025 02:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742263588; cv=none; b=PcrvC6ORUMwEV/4Z1l/EB7xO3SZgCagaEwAU+Csv5uhwbs8jznQLaJtpFdeC0G5/RBG9Y55Yg601ci7s1nuVM3CdGw4aofSdqCIKit3PU+dVLbFF0anFldS1zjLrBLwV3AwkloTbL99RrJM2FucVx6V2QMXTGWcCzorUv5IhG1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742263588; c=relaxed/simple;
	bh=+Zmbq5ItezIwgIN1+x8ifiJOb/YFodnrTxmkwUojTX0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=JCbR6fSeQVdpqJWvGYLZj724BFuM3qan24ydWmo073xoyQZX37l4yc4kgSP38nqydSAYM1gdxI6KpGZx6+QtI/S2WrmV8CQu7z13X2+OyA+agPBr5neOp5E0ELStjfd5YZU/XA+pHiDoWFTZRllhbLhanLG19RUiyKEdylQWnn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ce8cdf1898so54518005ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 19:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742263585; x=1742868385;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H2Bm5iKAcCJvnjZ6tF1UiPmO6oyyFiit5QT15w0ftic=;
        b=RVw/XJT6nA/Biv1vSxjbn+9+Ums++YD18IOeJ8CQuOyos1Du0KnyjcaPJ/rtbiBhMp
         B3a9zORv8lNi5nWpa/MSbR6FjOVQB2QiN3TAZm/RnOhSlOALwUt9/LR+vz9F5A84tjDm
         q0lL4ay4eXocFVja/8Eo45pZrNMwGivXwXZfRI6xu2WJXHvi6Wz4iMuXSnAhnDiVurOj
         tYzhWHniWW6k7PETBiRUn6+rtPMAALbAP8Cogv9lwnkaYiLmrgNBQbeSxNjTHTeftCmA
         8itg0l6UMRt4K2eJRqXbvedrfxrv1+XuY9Qz0qE0HTKowd0H44nGPn6cjZBNpNmSYgzs
         kmDA==
X-Forwarded-Encrypted: i=1; AJvYcCXR2ilWUnBZzGWe9WyrGKQC/9fsljVq+QzuafEMVs2o012/3ZrB/Qe7fOpl35Q5MmEa2eRI3u78WQhu9JGM3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YygbswcbDAdbdqKxSYpmCbQC0ngwu+xI1f3hPo025AsZ7br8Kv4
	4n5vkXJSEkb3eyB9T2+fqWDolAVDnIQwMnxvV0mV6Lb0xl+WWDRAi3Ikplj+nzz5O8ahTm0UrJW
	pTJeEiWKBpZ28SHzFZHPPmY1non9UTlZGFM4RrQ+92L7U/1Cgqirheow=
X-Google-Smtp-Source: AGHT+IGF4RohlhtS+KfmxDzUmgeihSP6Ec1dIWSkCTJV7Qu/b0K6N/PK6djUw1vjygXW6188lT2gNOp8XQATyBXGpSLicKZWOMb9
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1805:b0:3d3:fdb8:1799 with SMTP id
 e9e14a558f8ab-3d57ba34eb0mr23768505ab.22.1742263585740; Mon, 17 Mar 2025
 19:06:25 -0700 (PDT)
Date: Mon, 17 Mar 2025 19:06:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67d8d521.050a0220.2ca2c6.00c0.GAE@google.com>
Subject: [syzbot] [bcachefs?] BUG: unable to handle kernel paging request in __bch2_btree_node_write
From: syzbot <syzbot+c15a614efdfbcab66ffe@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a5618886fdab Merge remote-tracking branch 'will/for-next/p..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=1117f84c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=29061e148cfaa3d3
dashboard link: https://syzkaller.appspot.com/bug?extid=c15a614efdfbcab66ffe
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8b90307e7f61/disk-a5618886.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8b5ea0300ee3/vmlinux-a5618886.xz
kernel image: https://storage.googleapis.com/syzbot-assets/47f59a45fc8c/Image-a5618886.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c15a614efdfbcab66ffe@syzkaller.appspotmail.com

bcachefs (loop1): done starting filesystem
Unable to handle kernel paging request at virtual address fa8a58001fffe003
KASAN: maybe wild-memory-access in range [0xd456c000ffff0018-0xd456c000ffff001f]
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
[fa8a58001fffe003] address between user and kernel address ranges
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6585 Comm: syz.1.12 Not tainted 6.14.0-rc6-syzkaller-ga5618886fdab #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
pstate: 804000c5 (Nzcv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5091
lr : lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
sp : ffff8000a2b85e60
x29: ffff8000a2b86120 x28: ffff800080363e98 x27: 0000000000000000
x26: ffff0001b378c540 x25: 0000000000000000 x24: 0000000000000001
x23: 0000000000000000 x22: 1ffff00011f780cd x21: d456c000ffff0019
x20: 0000000000000001 x19: 0000000000000000 x18: ffff8000a2b86040
x17: 000000000001d9f0 x16: ffff8000832bd8fc x15: 0000000000000001
x14: 1fffe0001a8c3d90 x13: dfff800000000000 x12: ffff700014570bf4
x11: ffff80008046cf1c x10: ffff80008fbc0668 x9 : 00000000000000f3
x8 : 1a8ad8001fffe003 x7 : ffff800080363e98 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : d456c000ffff0019
Call trace:
 __lock_acquire+0xfc/0x7904 kernel/locking/lockdep.c:5091 (P)
 lock_acquire+0x23c/0x724 kernel/locking/lockdep.c:5851
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x48/0x60 kernel/locking/spinlock.c:154
 __queue_work+0x8d4/0x1324
 queue_work_on+0xe0/0x1a0 kernel/workqueue.c:2392
 queue_work include/linux/workqueue.h:662 [inline]
 __bch2_btree_node_write+0x295c/0x3660 fs/bcachefs/btree_io.c:2254
 bch2_btree_node_write_trans+0x9c/0x650 fs/bcachefs/btree_io.c:2357
 btree_split+0x482c/0x6288 fs/bcachefs/btree_update_interior.c:1710
 bch2_btree_split_leaf+0x14c/0x804 fs/bcachefs/btree_update_interior.c:1859
 bch2_trans_commit_error+0x2a8/0x1130 fs/bcachefs/btree_trans_commit.c:908
 __bch2_trans_commit+0x12e0/0x6190 fs/bcachefs/btree_trans_commit.c:1089
 bch2_trans_commit fs/bcachefs/btree_update.h:183 [inline]
 bch2_logged_op_start+0x1d4/0x36c fs/bcachefs/logged_ops.c:93
 bch2_truncate+0x198/0x2e4 fs/bcachefs/io_misc.c:296
 bchfs_truncate+0x6d0/0xa88 fs/bcachefs/fs-io.c:494
 bch2_setattr+0x1a0/0x214 fs/bcachefs/fs.c:1199
 notify_change+0x9f0/0xca0 fs/attr.c:552
 do_truncate+0x1c0/0x28c fs/open.c:65
 vfs_truncate+0x3fc/0x464 fs/open.c:115
 do_sys_truncate+0xe8/0x1ac fs/open.c:138
 __do_sys_truncate fs/open.c:150 [inline]
 __se_sys_truncate fs/open.c:148 [inline]
 __arm64_sys_truncate+0x5c/0x70 fs/open.c:148
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:744
 el0t_64_sync_handler+0x84/0x108 arch/arm64/kernel/entry-common.c:762
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:600
Code: f007ba88 b9466908 340090a8 d343fea8 (386d6908) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	f007ba88 	adrp	x8, 0xf753000
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
