Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79501DD0F2
	for <linux-bcachefs@vger.kernel.org>; Sat, 25 Jan 2025 12:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737807333; cv=none; b=iJ3/ZYDIPDGzVMXK4g2YJ58gwAjOWM14mhbN7yWoa12DfLmXBuCuZJGNq0MSgFYj4WvAQaHwy++q41/rrtQ5ubCGX7gfIOT19cO6TU6jkfTShwfkQI1vFuXxhKjvP+sOJjuCcWF/bFgoTIzwuyZZgnsVziI7+GVafK8wsMfCiRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737807333; c=relaxed/simple;
	bh=jB1tPj89iKQOnw3t4SptyiOJniwStM4E4Y+s6Qnh2PQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=YP1cnRROpQ1T5fCQ3aP+FufWZpPcNW9/0WKLBwFHasqRMA7LFRUhbBzHe7GW547xlROmxniYDdXEUfAnuLL9L5jfTjiCfSSqHlQoPqKt7FINHlLzGYOXAT8Q2LpcxcghcVFj1G08ArO4Wt2Fb4RWYG46eQjvMNP7QNpynkfajus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3a9d57cff85so54239255ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 25 Jan 2025 04:15:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737807331; x=1738412131;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EdYt/Nvrs9f3rWydeKFJujYsT11XhlqTHHMi1WiYHu4=;
        b=VzxpjkAFX9tvyI5o8hkccyBM5KQp3x4zaEqMMRIxDyrwBlfvH4gz01BWTzFVzj89sa
         zIRjxVViy7y1Uy7RFkDPuaX9Y87Ah40i1Aego2PJWnW1PVWor0oKYLUlWsN2LFjqTSCt
         TMfAmfQqnckQwj9PjJcP1wmEbIunFcESyJ4t4Im41tAcLPPA2CWdEaZf03wCaE910w3p
         pKn/oa6mz0zpkXE9Xrig3rnVEpc4TZC6PcuoBl+afPB6vvl7pFivF+n5e8aeUDD1K4mr
         e5Vl3ASmAcgP5BVTFXqri39Es/5ydFHxwSNxGwbQC1As2gYF6pd9ZqCnSo40BU/9hsM5
         GOEw==
X-Forwarded-Encrypted: i=1; AJvYcCVfPyl2P1ySehY7wqTCyxyK2tsvbRZkPdoAkjxoLcJBp/AwwMV7j8Vx6AD2aKoj0/lfpJGmOfSh+bwu0GS09Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8luWLKHzFm0My7TMdwoyHdsMtfTRsFMiL2eUwrIUDtvKwP5yR
	cmIO0lBVU2rhahPFu63HWUDUDGasU2ywikPwBekylm43H1ZcOLNGqjT7FxkoOg8MsL7xyXPJEnX
	8kIRDH842iQD39EHjQsKor/XABsituwddEBwOQ+aT2OYpf0HL765mUyI=
X-Google-Smtp-Source: AGHT+IEgcLLuaapAk7Nkumjmob+PyynCxQMjRM20Y4SqNpDNo9XjoqSJLXa+jRoGN2jVKsDnF4aUWS2YIAWoEhSkmSMPL6x6utLE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:450f:b0:3cf:c17d:5cc0 with SMTP id
 e9e14a558f8ab-3cfc17d5ef8mr65079135ab.13.1737807331091; Sat, 25 Jan 2025
 04:15:31 -0800 (PST)
Date: Sat, 25 Jan 2025 04:15:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6794d5e3.050a0220.2eae65.0028.GAE@google.com>
Subject: [syzbot] [bcachefs?] KMSAN: uninit-value in bch2_write_inode
From: syzbot <syzbot+c17ad4b4367b72a853cb@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    95ec54a420b8 Merge tag 'powerpc-6.14-1' of git://git.kerne..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=106f2ab0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=94988d5f349cacd5
dashboard link: https://syzkaller.appspot.com/bug?extid=c17ad4b4367b72a853cb
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13688ab0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=140d89f8580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/df0d06cacc21/disk-95ec54a4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/37dde637fea7/vmlinux-95ec54a4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2689e46ad3d/bzImage-95ec54a4.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/75c69a8942c4/mount_2.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c17ad4b4367b72a853cb@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in bch2_write_inode+0x9fa/0xf80 fs/bcachefs/fs.c:109
 bch2_write_inode+0x9fa/0xf80 fs/bcachefs/fs.c:109
 bch2_vfs_write_inode+0x8a/0x150 fs/bcachefs/fs.c:1835
 write_inode fs/fs-writeback.c:1525 [inline]
 __writeback_single_inode+0x8da/0x1290 fs/fs-writeback.c:1745
 writeback_sb_inodes+0xa34/0x1c20 fs/fs-writeback.c:1976
 __writeback_inodes_wb+0x14c/0x440 fs/fs-writeback.c:2047
 wb_writeback+0x50b/0xcb0 fs/fs-writeback.c:2158
 wb_check_old_data_flush fs/fs-writeback.c:2262 [inline]
 wb_do_writeback fs/fs-writeback.c:2315 [inline]
 wb_workfn+0x110c/0x1940 fs/fs-writeback.c:2343
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae0/0x1c40 kernel/workqueue.c:3317
 worker_thread+0xea7/0x14f0 kernel/workqueue.c:3398
 kthread+0x3e2/0x540 kernel/kthread.c:389
 ret_from_fork+0x6d/0x90 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Local variable io_opts.i117 created at:
 bch2_inode_rebalance_opts_get fs/bcachefs/inode.h:291 [inline]
 bch2_write_inode+0x696/0xf80 fs/bcachefs/fs.c:107
 bch2_vfs_write_inode+0x8a/0x150 fs/bcachefs/fs.c:1835

CPU: 0 UID: 0 PID: 3918 Comm: kworker/u8:17 Not tainted 6.13.0-syzkaller-00918-g95ec54a420b8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Workqueue: writeback wb_workfn (flush-bcachefs-1)
=====================================================


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
