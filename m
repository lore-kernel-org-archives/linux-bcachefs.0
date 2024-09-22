Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E6637
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727011521; cv=none; b=oFeCNKEAz7Y8sgKIWalb4FOAz/ioukcWol4zQxyQ1K6OUqLEdvxKT7Pwm8XcvSLksIS1a6xcv4HqT/bwTSbrFe4dMKUnwfS3EpJHz2EjKhCZsjddvP9bSov7qVXRDAsVSaYNKLiRnz9zCzSHslU8KPsUSsG6+WxnTbXfI9/eje4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727011521; c=relaxed/simple;
	bh=eaYXHifQ/+gWRNQ0Bi6jr1etY9SrUpzXn3cwrC6C8pk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=lCQvPS5eCHEPKs1RnlS/44u8CfwWypcbbJB6RP8eyyxhcYc4f1hA1InZtiw1P2IM9xDbMVGEwVnH6vhpAmSaNm/l/rmQCnxzTEAwa9W2MJz+L73ZmaGIGpMiOHMzPyjylhrkGo39MOFp+RtwqGuyrylAbjzuYNqnCj3UfVgZ50Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-82aa467836eso655947539f.2
        for <linux-bcachefs@vger.kernel.org>; Sun, 22 Sep 2024 06:25:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727011519; x=1727616319;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2+LFC3PUgiFcZNaAgxZJ2DmssPBnBLTVDgX3cD3qXGQ=;
        b=nnmC5ZBa+Gr3cLzr/KGHSPrgMqRigwnc4pKgvXv/HvTM3KImUFj5s975/9NV+4NYDs
         eTgSN6yPUkH/M6Zh62vWjukuNaF4o8p9uyVtbDnNKBboBefQ1lSlNuj+LzSNNB1kYEAf
         C5FG4WjLBTdVwXKvEz05oAXvGRqXzbPYZmd/ESYhlnkuMJJaDGzj4ObSmPoWl6ynoDjJ
         /0bk2I9gxen57K6ljzmAG6pKVdIBwakClUl9BOJY2GG+cL1e2tOKXeWAv1N7N7FnoTBM
         r6eC0edYLKRfPp5ygbJfs6fYUBrB8c3E7wmtK8oA+Eq335X/dwEr9onsMSjRG2gBT4p2
         pgMA==
X-Forwarded-Encrypted: i=1; AJvYcCWAzys/V33jW35SsyBBqDM/uBc3D1eYIsOMIV6aJscdDO/qPkQblpd11QustLhhZmZKP9GrqbrToOCBFQlaUA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1AyvwTbrC6l0plo0/pd1lvzzG7D0JsM3xH13P67hm1iy8Mvun
	N6q/joF87arXiVbAGyvjndQ389jk+XQmTo7TPvXzaZnxhAnF8elW8mjYOIzMS+K+Xe2gMR+ly4G
	LgYHLUOOoir2hpv2FNN2ZXOyoqDyCBZVHy7Y1nYmVF5jICjR6TMZHTtM=
X-Google-Smtp-Source: AGHT+IFDrOLEYGsA9cGC3KqLc8OoQBfBVAO4cdxNstLNMP3NEXq7fmchGQ5UgJWGSVBtS3YOpcPk9B7uXgA4Sy5f5lOnYS1aVRBy
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe2:b0:3a0:92b1:ec3c with SMTP id
 e9e14a558f8ab-3a0c8c6a51fmr67026745ab.4.1727011519015; Sun, 22 Sep 2024
 06:25:19 -0700 (PDT)
Date: Sun, 22 Sep 2024 06:25:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66f01abe.050a0220.3195df.009d.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_fs_release
From: syzbot <syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f5673607153 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=108f7500580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dedbcb1ff4387972
dashboard link: https://syzkaller.appspot.com/bug?extid=08d08d52c3a09bfc70f7
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148f7500580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/40172aed5414/disk-5f567360.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/58372f305e9d/vmlinux-5f567360.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d2aae6fa798f/Image-5f567360.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/019ec069588b/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+08d08d52c3a09bfc70f7@syzkaller.appspotmail.com

------------[ cut here ]------------
online_reserved not 0 at shutdown: 4
WARNING: CPU: 1 PID: 7017 at fs/bcachefs/super.c:568 __bch2_fs_free fs/bcachefs/super.c:568 [inline]
WARNING: CPU: 1 PID: 7017 at fs/bcachefs/super.c:568 bch2_fs_release+0x6c4/0x720 fs/bcachefs/super.c:608
Modules linked in:
CPU: 1 UID: 0 PID: 7017 Comm: syz.4.63 Not tainted 6.11.0-rc7-syzkaller-g5f5673607153 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/06/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __bch2_fs_free fs/bcachefs/super.c:568 [inline]
pc : bch2_fs_release+0x6c4/0x720 fs/bcachefs/super.c:608
lr : __bch2_fs_free fs/bcachefs/super.c:568 [inline]
lr : bch2_fs_release+0x6c4/0x720 fs/bcachefs/super.c:608
sp : ffff80009b667500
x29: ffff80009b667520 x28: 00007dfe9b5f3270 x27: ffffffffffffffff
x26: dfff800000000000 x25: ffff0000f5f80000 x24: 0000000000000008
x23: 0000000000000004 x22: 1fffe0001ebf093e x21: ffff0000f5fca1e8
x20: 0000000000000008 x19: ffff0000f5f80068 x18: 1fffe000366d79ee
x17: ffff80008f56d000 x16: ffff800080347214 x15: 0000000000000001
x14: 1fffe00019a65a00 x13: 0000000000000000 x12: 0000000000000000
x11: ffff600019a65a01 x10: 1fffe00019a65a00 x9 : 8734dde5ec21bf00
x8 : 8734dde5ec21bf00 x7 : ffff8000802b7e24 x6 : 0000000000000000
x5 : 0000000000000001 x4 : 0000000000000001 x3 : ffff8000802aa83c
x2 : 0000000000000001 x1 : 0000000000000004 x0 : 0000000000000001
Call trace:
 __bch2_fs_free fs/bcachefs/super.c:568 [inline]
 bch2_fs_release+0x6c4/0x720 fs/bcachefs/super.c:608
 kobject_cleanup lib/kobject.c:689 [inline]
 kobject_release lib/kobject.c:720 [inline]
 kref_put include/linux/kref.h:65 [inline]
 kobject_put+0x2a8/0x41c lib/kobject.c:737
 bch2_fs_free+0x2c4/0x334 fs/bcachefs/super.c:672
 bch2_fs_stop+0x28/0x38 fs/bcachefs/super.c:678
 bch2_fs_get_tree+0xab0/0x1030 fs/bcachefs/fs.c:2041
 vfs_get_tree+0x90/0x28c fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
irq event stamp: 90582
hardirqs last  enabled at (90581): [<ffff8000802b7ec4>] raw_spin_rq_unlock_irq kernel/sched/sched.h:1427 [inline]
hardirqs last  enabled at (90581): [<ffff8000802b7ec4>] finish_lock_switch+0xbc/0x1e4 kernel/sched/core.c:4942
hardirqs last disabled at (90582): [<ffff80008b3363f4>] el1_dbg+0x24/0x80 arch/arm64/kernel/entry-common.c:470
softirqs last  enabled at (90568): [<ffff8000801f8e88>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (90568): [<ffff8000801f8e88>] handle_softirqs+0xa3c/0xbfc kernel/softirq.c:582
softirqs last disabled at (90505): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588
---[ end trace 0000000000000000 ]---
bcachefs: bch2_fs_get_tree() error: fsck_errors_not_fixed
syz.4.63 (7017): drop_caches: 2
syz.4.63 (7017): drop_caches: 2


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
