Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E090EAC7
	for <linux-bcachefs@vger.kernel.org>; Sun, 19 May 2024 04:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716092064; cv=none; b=pKa7fvjx9dF4XxvXNeEwqse/ClmlvEyRpKCMp8r/0SdpSFQoyLrHVOCXXRds2fw7GHmdq9uo37ZrTPUrfRou2R6kRuY0h6BI6Ue0oNeiUS3xZQ5CtiRN1VfI0xaIzcu2RRB0wQZ9aZ0tQQTsJs7v+V5xaS5yoRqhpwmJm9OG5rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716092064; c=relaxed/simple;
	bh=tdQVZ4AwAXdSXyEHSvXRkCBni9f/234ybjzp3MRcQqQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=iqEfxhddRrOFEYeIQ4l7FyNNQoAlUImNovl/tcl4UqrJZJmaGgZlrQXnigt0V3hbPj/Gn6emN9D4lckfdNkCDvpEX09vaTclyijYxErs5Eh7lQu51G8ApFLBkKQpNPygLK45upkhnveOQHuvhAVd2uMX16iVPiJiZl2BXu+8qwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1de4c052aso865155939f.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 18 May 2024 21:14:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716092062; x=1716696862;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8Gv4btGU5EuwRMiUPysUsMEKq89JnY7Oo+TqSlvmw9c=;
        b=nrMCbybkHuv8QeI+T2O0ONNKs0ulQXX9O7BZ2GbTHBz7DqPsUgZZqN1x82XOgeph02
         agteyn3lfPy1rE0lhBS8bJOnf06A9kXaIFqX3pKuq8EMOJdRk9Vh/naACNEPms1ZxbxC
         bfRaZzhMXwmfk28VYw+K7BmYATOz4DjqlLRYPaPzZonn4ILi7d7ywnv+MudT3sPRBgmY
         A4PY5Y2Lxyrqc7iOr/e0tYFvAreyosz9TrWiG1gUTyGzhkrY2ogVQ8FgBP7PxXhkjSyg
         LyHqxo4TQVDXxsM+PgDH6lY0xwzm/qotFgXTS7hVJ/0qtteokT+sGTaEVx4G3EjOYwVq
         drvw==
X-Forwarded-Encrypted: i=1; AJvYcCXAsp+NUAI5zgfrMqL1HoXAjqo8EGw95qcZQg549rHz0ikwHNlDwP613GH1mfXNg0NPOydZna7jYYRyQAfO2fr19sQG0Xr9vpgCLXFew2A=
X-Gm-Message-State: AOJu0YwPE8WPcCFM0slDVvebdsFMu6h+XvI4LgGCYm0W+yrMR/vf+T0p
	O/N/jIOCwNKevDMTIB7Qkk+nsflniYqadRhx0/2l1340jK7WllfoqDBtexs2jkGDXbsHqaADrIL
	ISMCy/ef4fhUgSSTIcZ0ezzf38GSs6QElG8FWCuR7RZynV3kAD9oFzpA=
X-Google-Smtp-Source: AGHT+IGOILSPvfl3mS+DAYPhdxoShA1epXCEzg5FC715Lkg5fj8xD2F/3PT1qfJHumM4U9U33sXrw9nnnXCqTGEYPTpcS+lPRLDW
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2b8e:b0:7de:e16b:4b81 with SMTP id
 ca18e2360f4ac-7e1b5209a83mr216278139f.2.1716092062700; Sat, 18 May 2024
 21:14:22 -0700 (PDT)
Date: Sat, 18 May 2024 21:14:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000cca85f0618c6d150@google.com>
Subject: [syzbot] [bcachefs?] kernel panic: not locked: inodes NUM:ADDR:NUM cached
From: syzbot <syzbot+95db43b0a06f157ee865@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fda5695d692c Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=158084e0980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95dc1de8407c7270
dashboard link: https://syzkaller.appspot.com/bug?extid=95db43b0a06f157ee865
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10c1a96c980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15fffdd4980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/07f3214ff0d9/disk-fda5695d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/70e2e2c864e8/vmlinux-fda5695d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b259942a16dc/Image-fda5695d.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d58e9154055c/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+95db43b0a06f157ee865@syzkaller.appspotmail.com

path: idx  2 ref 1:0 P S btree=dirents l=0 pos 1073741824:2251139105009357257:U32_MAX locks 0 bch2_trans_iter_init fs/bcachefs/btree_iter.h:489 [inline]
path: idx  2 ref 1:0 P S btree=dirents l=0 pos 1073741824:2251139105009357257:U32_MAX locks 0 bch2_hash_lookup_in_snapshot+0x150/0x564 fs/bcachefs/str_hash.h:173
path: idx  1 ref 0:0 P S btree=subvolumes l=0 pos 0:1:0 locks 0 bch2_trans_iter_init fs/bcachefs/btree_iter.h:489 [inline]
path: idx  1 ref 0:0 P S btree=subvolumes l=0 pos 0:1:0 locks 0 __bch2_bkey_get_iter+0xe4/0x248 fs/bcachefs/btree_iter.h:548
transaction updates for bch2_lookup journal seq 0
Kernel panic - not syncing: not locked: inodes 0:1073741826:0 cached
CPU: 1 PID: 6237 Comm: syz-executor197 Not tainted 6.9.0-rc7-syzkaller-gfda5695d692c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:114
 dump_stack+0x1c/0x28 lib/dump_stack.c:123
 panic+0x30c/0x894 kernel/panic.c:348
 bch2_assert_pos_locked+0x890/0x8dc fs/bcachefs/btree_iter.c:367
 bch2_inode_update_after_write+0x184/0x88c fs/bcachefs/fs.c:59
 bch2_vfs_inode_init+0xac/0x640 fs/bcachefs/fs.c:1448
 bch2_lookup_trans fs/bcachefs/fs.c:419 [inline]
 bch2_lookup+0x918/0xbcc fs/bcachefs/fs.c:437
 lookup_one_qstr_excl+0x108/0x230 fs/namei.c:1607
 do_renameat2+0x51c/0xe40 fs/namei.c:4978
 __do_sys_renameat2 fs/namei.c:5071 [inline]
 __se_sys_renameat2 fs/namei.c:5068 [inline]
 __arm64_sys_renameat2+0xe0/0xfc fs/namei.c:5068
 __invoke_syscall arch/arm64/kernel/syscall.c:34 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:48
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:133
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:152
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
SMP: stopping secondary CPUs
Kernel Offset: disabled
CPU features: 0x00,00000103,80100128,42017203
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
