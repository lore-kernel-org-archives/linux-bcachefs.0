Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE64F2C0F63
	for <linux-bcachefs@vger.kernel.org>; Wed,  3 Sep 2025 16:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756916380; cv=none; b=qUaAlc9HuCvWXbZfntqG1YfEaPZZo3SOhlds7f+oDkXOOB77HoJ2yIbJPVsTkzjSNB26owDx54voRUYJx+/pAeSifmzbSx9t3VBvDvtFCDupfq/jQJh3BGeVK6b/3WRuWICMwwiM1Zr+jZOdKaMsxifkjjvywRnqh1PjFHcP298=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756916380; c=relaxed/simple;
	bh=4PWokzWixG4qg1i1E94EUnticAgWCTrfb9PG9kJG3tI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=OPrmzMEX23wMY2BxwpZiSD57zdsa68JK68U1anXq2GoN3+jSb28tw8ExXfmafs4tHp8Wh9PQoLn9c+qU5jL8bxU+3mZR8BlO7l0h4uJC4M6ZKBK6XPWS/tST07yHtFhXwb0nb5FDIYYekj2x+1j/p2wFLBLaafMQatWTkjyE0Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3eca67caa2bso454135ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 03 Sep 2025 09:19:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756916378; x=1757521178;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t9jMe7x0aUlqvH3GqTfPVdqlD54iq8B3J1/2sKxSjsc=;
        b=IP0lCfgMWIRy7SEfBwABhoygN/QgRYS6wayvg3MHALBpwBUwW5npoA77ktpoDq3i5u
         rXyR3F7TfUsmg4JBKXlQiyiLNsamxIPFmbFZIS1Qeh/hZYwoPiRljJzyT2J0X/qz3kyW
         nZw5NVfox77PNAWRaFOwUHQCbz3v5b6VOjJlEg+XBw3QptZPhH842Z3ChhQ5NWnZ+be7
         17YYYw7c/HaM5E4MV58U7i0eQfGbzFMbDvDrPMtxNW/WJ6WaMvRHxxgoWCEXTEdSSGKF
         tezEpTsrmiLozUSwt8/JpeRmglHT9FEWob+nCwigerSeOue/ZZlP6ZhXjmVAzYluWznZ
         Ct4w==
X-Forwarded-Encrypted: i=1; AJvYcCVynB/3FTinitnRZQ47b8RQb+MDyxypRooseRyVE/j0/kyAJJH/8VSQJh34ZkEjRQsCZmMBL0KmXS+12VoAQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzdXn5a1l50MNe2d10dw215NK3umNPF46ZDv381IY6IOmFcvA7U
	ZBwi5Os9qX16pMeG2dcwLyU6g5EvB9oSrODjFGyIKGKCCX3lOk3WfdcNSWce/UNBD7/vVdTmhqz
	heGwmMdEZRR7vSwI4jU+c5cQxfFLocMX0EN221jAHxbXAt60WDmx1GFYQM4A=
X-Google-Smtp-Source: AGHT+IGy9t9NrpZihKVmzBQ41cZQekdL6eF9nenUqdxKShx4j5mnFh9z59YOKn39RQFh3FL2PXbsV5fvoVH6ZCX+EvlB+G3GRAAq
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4616:b0:3f6:554f:f83e with SMTP id
 e9e14a558f8ab-3f6554ff9d2mr120846585ab.18.1756916378003; Wed, 03 Sep 2025
 09:19:38 -0700 (PDT)
Date: Wed, 03 Sep 2025 09:19:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b86a99.050a0220.3db4df.01f6.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: bcachefs (loop0): panic after
 error (2)
From: syzbot <syzbot+36450b3c8ace3bd1a55a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f5ae30d69d7 Linux 6.17-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=16138312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8c5ac3d8b8abfcb
dashboard link: https://syzkaller.appspot.com/bug?extid=36450b3c8ace3bd1a55a
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=118d1662580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/18a2e4bd0c4a/disk-8f5ae30d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3b5395881b25/vmlinux-8f5ae30d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e875f4e3b7ff/Image-8f5ae30d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/bd567b403b12/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+36450b3c8ace3bd1a55a@syzkaller.appspotmail.com

bcachefs (loop0): superblock marked clean but clean section not present, shutting down
  error not marked as autofix and not in fsck
  run fsck, and forward to devs so error can be marked for self-healing
Kernel panic - not syncing: bcachefs (loop0): panic after error
CPU: 1 UID: 0 PID: 6771 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-g8f5ae30d69d7 #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/30/2025
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0x30/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 vpanic+0x280/0x780 kernel/panic.c:430
 vpanic+0x0/0x780 kernel/panic.c:566
 __bch2_inconsistent_error+0x124/0x14c fs/bcachefs/error.c:36
 __bch2_fsck_err+0x82c/0xeb0 fs/bcachefs/error.c:603
 bch2_read_superblock_clean+0x150/0x238 fs/bcachefs/sb-clean.c:156
 bch2_fs_recovery+0x134/0x2fb4 fs/bcachefs/recovery.c:738
 bch2_fs_start+0x940/0xbec fs/bcachefs/super.c:1213
 bch2_fs_get_tree+0x880/0x107c fs/bcachefs/fs.c:2488
 vfs_get_tree+0x90/0x28c fs/super.c:1815
 do_new_mount+0x278/0x7f4 fs/namespace.c:3805
 path_mount+0x5b4/0xde0 fs/namespace.c:4120
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount fs/namespace.c:4321 [inline]
 __arm64_sys_mount+0x3e8/0x468 fs/namespace.c:4321
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x58/0x180 arch/arm64/kernel/entry-common.c:879
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:898
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x40000,00007800,109c1141,5427fea7
Memory Limit: none
Rebooting in 86400 seconds..


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
