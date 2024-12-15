Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052081758B
	for <linux-bcachefs@vger.kernel.org>; Sun, 15 Dec 2024 08:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734250222; cv=none; b=Fx6JEmIqNnfxZb0pApKL7EPM95kuQp4SyVCp3teC/Gocy+O5gRjwjn9VGk1NTfCPzT+3bBqxUg8O7G2WU64bkNgdOE18kJRJ1S+9u/rcS/0l2sqEcZ4X0IzDK81xgcfIXSLo3EGICFK2X5c3Arc+Fxnjh+USt/buRYEENvmJZls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734250222; c=relaxed/simple;
	bh=csz8Kq2nA5LKZioKZM7EBTYtonUiQcUHjmHh8sNsaSY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QKE3+MyNEkj2Dl7hPAYryfKB34XvcQS6ICb2qHR/l4Xde+NVJ+SEgRBymC/LKH+SNLSN3bDuvgmPhTcwjyDpfFwmwum8QL3NZCNlWK+q+JbAhT9cMAE4E596o7YGszvphy+h/WuGbupGqvuMKh0JC6X3OxoOfpCpYonPLt/79wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844e344b0b5so243563039f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 15 Dec 2024 00:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734250220; x=1734855020;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k+RTbqDoQTfoaVyJuIUhBDuylGKG3bOhmy1/Fd/j7Q0=;
        b=dlqZeBCMxHuOeLs91jVprEeCGPLDzJi4fteecrCDJ4zpBsbMXuQcFeHi3H87VlJ4Ww
         1Rpo2ayv6l4y4Tf+h1D6ps57fV/v2qq5WYjdFbC4FG+PX+BTVg3TTLNdiGXVs3oUkY8y
         o33JTN2HaLMNtK8do+y+0VoUMLwR/Z6x3SkyUODhWZwYy28DwMP4bP7wu51zVeADOpSA
         4C85VAVsKwObkgtX/wxtZ65WFdDX4WTK5Et4XxpA3hehNyYkHlws5KKJE1RL/Zx4ti28
         y++KntGNtCInyK7oFEfbK3m/dqcOmOap0ThS+U9pnUXVY5Ix5xHzYB+PbQWTNgGFnKBh
         Gnpg==
X-Forwarded-Encrypted: i=1; AJvYcCXsXM0sf/FQD05aZe5S1CXPhQqgE7s7qLZNVj4i0tJm2rlbgKp2QRWXfjgZugPp3vbtV1JEgDcvuqpjDZjJQA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPgJU1fVa3fgnoDYTD7nHoJjqa0WiVX9Mes1Eh2i2O/pP8SJSp
	9rES/2b8IOajSzw6l9g0zuCFsHzaCzvIZB20ON7xNAlJtZ63+sTkTkxIqwrAC/J4ziNs8+X8Nb7
	qBpjTfZQghnAt2YkCdALjgKJnUMG8izh8K2WejPRz8zJb5zEWq89I2Xo=
X-Google-Smtp-Source: AGHT+IE69V2GbCj2vNvegSPd7UIb0As8uSbmZ14GRIuDc4TIip1DQA0glRN0VrkqYOUDNvauCNx99ev2XSBnQqQPAyeAiD/amUci
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c566:0:b0:3a7:7558:a6ea with SMTP id
 e9e14a558f8ab-3aff01b0779mr82407405ab.10.1734250220166; Sun, 15 Dec 2024
 00:10:20 -0800 (PST)
Date: Sun, 15 Dec 2024 00:10:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <675e8eec.050a0220.37aaf.00f4.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_checksum_update (2)
From: syzbot <syzbot+60ea31958b52b09e04af@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f92f4749861b Merge tag 'clk-fixes-for-linus' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=129b3544580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=95d0bb0535bcaca0
dashboard link: https://syzkaller.appspot.com/bug?extid=60ea31958b52b09e04af
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/71d71ad0e41a/disk-f92f4749.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3c061489bceb/vmlinux-f92f4749.xz
kernel image: https://storage.googleapis.com/syzbot-assets/30c84208490c/bzImage-f92f4749.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+60ea31958b52b09e04af@syzkaller.appspotmail.com

bcachefs (loop9): shutting down
bcachefs (loop9): going read-only
bcachefs (loop9): finished waiting for writes to stop
bcachefs (loop9): flushing journal and stopping allocators, journal seq 11
=====================================================
BUG: KMSAN: uninit-value in crc64_be+0x202/0x310 lib/crc64.c:59
 crc64_be+0x202/0x310 lib/crc64.c:59
 bch2_checksum_update+0x15e/0x1d0 fs/bcachefs/checksum.c:88
 bch2_checksum+0x3ca/0x800 fs/bcachefs/checksum.c:225
 __bch2_btree_node_write+0x52e3/0x6830 fs/bcachefs/btree_io.c:2148
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x156/0x3f0 fs/bcachefs/journal_reclaim.c:822
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x210/0xb40 fs/bcachefs/super.c:276
 bch2_fs_read_only+0xd2c/0x15d0 fs/bcachefs/super.c:356
 __bch2_fs_stop+0xf0/0xf10 fs/bcachefs/super.c:621
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:2050
 generic_shutdown_super+0x197/0x4c0 fs/super.c:642
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2278
 deactivate_locked_super+0xe0/0x3f0 fs/super.c:473
 deactivate_super+0x14f/0x160 fs/super.c:506
 cleanup_mnt+0x6bb/0x730 fs/namespace.c:1373
 __cleanup_mnt+0x22/0x30 fs/namespace.c:1380
 task_work_run+0x268/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xbf/0x160 kernel/entry/common.c:218
 do_syscall_64+0xda/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_p_copy fs/bcachefs/bkey.h:47 [inline]
 bch2_sort_keys_keep_unwritten_whiteouts+0x12d5/0x19d0 fs/bcachefs/bkey_sort.c:187
 __bch2_btree_node_write+0x3ae8/0x6830 fs/bcachefs/btree_io.c:2095
 bch2_btree_node_write+0xa5/0x2e0 fs/bcachefs/btree_io.c:2284
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush1+0x38/0x60 fs/bcachefs/btree_trans_commit.c:266
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 journal_flush_done+0x156/0x3f0 fs/bcachefs/journal_reclaim.c:822
 bch2_journal_flush_pins+0xdb/0x3b0 fs/bcachefs/journal_reclaim.c:852
 bch2_journal_flush_all_pins fs/bcachefs/journal_reclaim.h:76 [inline]
 __bch2_fs_read_only+0x210/0xb40 fs/bcachefs/super.c:276
 bch2_fs_read_only+0xd2c/0x15d0 fs/bcachefs/super.c:356
 __bch2_fs_stop+0xf0/0xf10 fs/bcachefs/super.c:621
 bch2_put_super+0x3c/0x50 fs/bcachefs/fs.c:2050
 generic_shutdown_super+0x197/0x4c0 fs/super.c:642
 bch2_kill_sb+0x3d/0x70 fs/bcachefs/fs.c:2278
 deactivate_locked_super+0xe0/0x3f0 fs/super.c:473
 deactivate_super+0x14f/0x160 fs/super.c:506
 cleanup_mnt+0x6bb/0x730 fs/namespace.c:1373
 __cleanup_mnt+0x22/0x30 fs/namespace.c:1380
 task_work_run+0x268/0x310 kernel/task_work.c:239
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0xbf/0x160 kernel/entry/common.c:218
 do_syscall_64+0xda/0x1e0 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4238
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4255
 __do_kmalloc_node mm/slub.c:4271 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4289
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:650
 btree_bounce_alloc fs/bcachefs/btree_io.c:124 [inline]
 btree_node_sort+0x78a/0x1d30 fs/bcachefs/btree_io.c:323
 bch2_btree_post_write_cleanup+0x1b0/0xf20 fs/bcachefs/btree_io.c:2248
 bch2_btree_node_write+0x21c/0x2e0 fs/bcachefs/btree_io.c:2289
 btree_node_write_if_need fs/bcachefs/btree_io.h:151 [inline]
 __btree_node_flush+0x606/0x680 fs/bcachefs/btree_trans_commit.c:252
 bch2_btree_node_flush0+0x35/0x60 fs/bcachefs/btree_trans_commit.c:261
 journal_flush_pins+0xce6/0x1780 fs/bcachefs/journal_reclaim.c:565
 __bch2_journal_reclaim+0xda8/0x1670 fs/bcachefs/journal_reclaim.c:698
 bch2_journal_reclaim_thread+0x18e/0x760 fs/bcachefs/journal_reclaim.c:740
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

CPU: 0 UID: 0 PID: 13300 Comm: syz-executor Tainted: G        W          6.13.0-rc2-syzkaller-00031-gf92f4749861b #0
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


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
