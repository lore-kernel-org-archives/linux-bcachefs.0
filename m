Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EBC18CBFE
	for <linux-bcachefs@vger.kernel.org>; Sat, 11 Jan 2025 13:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736602649; cv=none; b=UiR3+Ust1ZKPawoCITeMVJua2i9MoTZpBZ/k7Nl4MKW2zt5HKN/JP2pPtzLBaqNjaMYCLAEhsDZ+mb4XwXeYG1rg/L6WxmgVgrj1T9atvaQMMnWh7NLUwIW7thXPoEZch0Z9Nwo8LFgeKyc7XNomke1RFRMXs4XB3etmZQ/e6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736602649; c=relaxed/simple;
	bh=KBsS/iBKicCVO72r9pDHtNMFaoLi0MNZab7kWaeabPM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=U+IT0qG+9Ylu3hO2x9siIH3fwwl36qYO+PlaJL1iITHUG0cs5d/WZGZd3DUncleJw9/r2ThmyqR9eLjg2+v/9cHmWsIoWscPjfLaag2+rBtl7RV7vZRNN3h711RWzb7ZzCe0pnJ5G8No06ylEX4AYFy2EFik5tKr3GReLxGls5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3ce6817ccd8so2139075ab.3
        for <linux-bcachefs@vger.kernel.org>; Sat, 11 Jan 2025 05:37:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736602646; x=1737207446;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fuyObhNJkilb1hXrzNwP6Vi4du6OQOdpxz1m1hwIllI=;
        b=NepSaLNDXnLDUmpyeW5xd7t1D/T+TQM2v+wXIIzYEfGLkkN7sau3ROelyNqKqiwiNE
         vi322mom761jjYikGsXIi6j18SRPHQntGrTn81xqNH5nF4vFU5jm93Mmm1Rd9D5Y/Jh6
         xrQTq3Bd4KmnRMp9jrvXUcB3AYubXEquT4bN+RmZNydzzqt7p1yEDc13h0QTa/xneWQT
         V5SCAtnjlIQRKgtnsWFNuyUMwY7tAKdUmeqgNJkMrU59VI3F7lgIynD9dTtFpePPAo2C
         H1Rx15Qc5PZl1xu+10NAwFC5IEt5iHMMCyE6P2o7x6kOCJx6ti6ie1jXvQ0gO/hivVW8
         7xHw==
X-Forwarded-Encrypted: i=1; AJvYcCVjin/CmaJHI0IdUGp2wWogBpLuDjk8K0NdX0/qq0Zch/ZAJ7kdapxLQVjUDTdNfRVbyApo/155AB2qDLJU3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLxGV+2ghpchIwV4jYxK9NQoFsqjD0kaDX8O47mWSU2H76mciO
	RDxM8cPzYqROVyS9yBRc/C8QwhbK9fVdNCBSIDM0OoRlHEjHiRbKmGojNxBhVqVeMlseA1b4zUD
	ncyLhWLbUUXxduN5DFs6S0KRN7oi6dyov2jVHZtK2sH+t/njafWluUtE=
X-Google-Smtp-Source: AGHT+IHjiih4refK4THP+qamKiiUSq5Cq++/BMeZNO0xl9YxcaYqCCVFcUMgIoQBmMU7qrFQaGm05SbQhyuG/9/ucsW9nWZw5KuB
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8e:b0:3ce:3016:fbc3 with SMTP id
 e9e14a558f8ab-3ce3a8882c6mr101975035ab.14.1736602646535; Sat, 11 Jan 2025
 05:37:26 -0800 (PST)
Date: Sat, 11 Jan 2025 05:37:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67827416.050a0220.216c54.0020.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_readdir (2)
From: syzbot <syzbot+a7b475122da841580575@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    fbfd64d25c7a Merge tag 'vfs-6.13-rc7.fixes' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=125755c4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=93fafdd434f3247d
dashboard link: https://syzkaller.appspot.com/bug?extid=a7b475122da841580575
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be5f7d21fc6d/disk-fbfd64d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/18656986c542/vmlinux-fbfd64d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/23240d42568c/bzImage-fbfd64d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7b475122da841580575@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_dirent_read_target fs/bcachefs/dirent.c:259 [inline]
BUG: KMSAN: uninit-value in bch2_readdir+0x1a45/0x2470 fs/bcachefs/dirent.c:551
 bch2_dirent_read_target fs/bcachefs/dirent.c:259 [inline]
 bch2_readdir+0x1a45/0x2470 fs/bcachefs/dirent.c:551
 bch2_vfs_readdir+0x347/0x7c0 fs/bcachefs/fs.c:1377
 iterate_dir+0x5b3/0x9e0 fs/readdir.c:108
 __do_sys_getdents fs/readdir.c:322 [inline]
 __se_sys_getdents+0x170/0x550 fs/readdir.c:308
 __x64_sys_getdents+0x96/0xe0 fs/readdir.c:308
 x64_sys_call+0x38d8/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:79
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 memcpy_u64s_small fs/bcachefs/util.h:393 [inline]
 bkey_reassemble fs/bcachefs/bkey.h:513 [inline]
 bch2_bkey_buf_reassemble fs/bcachefs/bkey_buf.h:28 [inline]
 bch2_readdir+0x14f7/0x2470 fs/bcachefs/dirent.c:551
 bch2_vfs_readdir+0x347/0x7c0 fs/bcachefs/fs.c:1377
 iterate_dir+0x5b3/0x9e0 fs/readdir.c:108
 __do_sys_getdents fs/readdir.c:322 [inline]
 __se_sys_getdents+0x170/0x550 fs/readdir.c:308
 __x64_sys_getdents+0x96/0xe0 fs/readdir.c:308
 x64_sys_call+0x38d8/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:79
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 ___kmalloc_large_node+0x22c/0x370 mm/slub.c:4253
 __kmalloc_large_node_noprof+0x3f/0x1e0 mm/slub.c:4270
 __do_kmalloc_node mm/slub.c:4286 [inline]
 __kmalloc_node_noprof+0xc96/0x1250 mm/slub.c:4304
 __kvmalloc_node_noprof+0xc0/0x2d0 mm/util.c:645
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

CPU: 0 UID: 0 PID: 9169 Comm: syz.7.774 Not tainted 6.13.0-rc6-syzkaller-00036-gfbfd64d25c7a #0
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
