Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C871AAE1E
	for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732541305; cv=none; b=uU0rWAuZ8b78PfjGnuFUkClFTRAXikiQr7txSs2Kp3YcRxW+ufdWv6upe582YCGARliHcJ0VQtgd44+4zho4GpVTnTecc1+pA2eUFr5zQ+zST58jZKSGlsIl/Z6P66LDfUFdF/vbq3KWb5dgcTE6uKvP3nmgXgqK4uPA4DT/WDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732541305; c=relaxed/simple;
	bh=aVM9e/7yL23MpRrzxA++KyKKSxwoIWGLxl8Dgy4YYIQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FrEjE8xFyEFIbSH5LzDrWg/CbrMr8YCu8BsTPf3PK1BJv/JreiVAO26Nv7x2EO7wlt9IG1AI/5qllCKV2xOMR3uZKuNTxNNYPXDKw0SHNa1TsJFxMxGtkL+eQSqacNOToFm8/jb6yX+4ajihKYlq3x8pCX9f7GtrWQiVaj9M4+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a71bdd158aso49207995ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 25 Nov 2024 05:28:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732541302; x=1733146102;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qIsfvVjfCKULBqyRe1KvC08jSx3n5sgx8OEeE56xvaY=;
        b=sA6jHAFcnf+CQb5O3eCOQezJsPyrFIOECXvIfzxhFT12s7ruSxzmXbOR5MbfFvxb2V
         vmtlCmxTz1dRwiJjJZFk96tWxO+9An/G++UVvp7DloaR4vQrEDsFM50ZmKJShwO8JqkY
         9hPOWDMVbERINAGxcKThCnjLjVS1b+UJtMU8P9yCk/XjhTB0mJWoTKYTIIHdG6ZbG7Kj
         uo9vXyTD0p2H1UzyEcxbZ/VDC7UWhNcy+2UlTrjVFXIc0X/ISSsTD9Sl77f9F8JcnLw8
         +t9XJcG9dHG3ULI6jfh3iil28800a/1x4KLfrLW7JyCCKRDzt8QfAe1f3AmuU8EPVyb0
         9Bfg==
X-Forwarded-Encrypted: i=1; AJvYcCU7gJ4wghtPphhglgTLitagDG0SBxla3lu/7UIZ6VIuBnQ3IqfCUYVP738CMFLbWcFwgP8a4C/24T4K+TeKFw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy10a/U+42WccTU4Nr5hcJ63EMfPGxlEXldfUNf8LV+NnNkEOcu
	6jn5b5KSYwQjS9f8mOKF0qNxVtFg14ciyCl0Ro/TPB9oHsoWwvDKD9n8dSvv+e7Zw/JVCPSJ51v
	OuX9yGcPqCqpBtE5B4rro+EEdxjovRP5M/GxCD1qxbP7eJNzhnXuo0KI=
X-Google-Smtp-Source: AGHT+IFIMRGZuklg/RYkhm9HteDE5Yu6S3Uldb0EEi329AdWLpec1kHzjAw49mO5iZAFQos7XJPcwfcY5vfQ+BcC5sFCXMlJu437
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4507:10b0:3a7:a3f7:f9fb with SMTP id
 e9e14a558f8ab-3a7a3f7fe4cmr64750785ab.0.1732541302567; Mon, 25 Nov 2024
 05:28:22 -0800 (PST)
Date: Mon, 25 Nov 2024 05:28:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67447b76.050a0220.1cc393.0087.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in bch2_journal_pin_set
From: syzbot <syzbot+3bd0834534ada7200422@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1411a530580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e92fc420ca55fe33
dashboard link: https://syzkaller.appspot.com/bug?extid=3bd0834534ada7200422
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=162325c0580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=112325c0580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c9f905470542/disk-9f16d5e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b4c9cc530ec/vmlinux-9f16d5e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e0f262e4c35e/bzImage-9f16d5e6.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/68d3db7c217d/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3bd0834534ada7200422@syzkaller.appspotmail.com

bucket 0:42 gen 0 data type btree has wrong dirty_sectors: got 0, should be 256, fixing
 done
bcachefs (loop0): going read-write
bcachefs (loop0): journal_replay...
------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal_reclaim.h:30!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5839 Comm: syz-executor780 Not tainted 6.12.0-syzkaller-09073-g9f16d5e6f220 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:bch2_journal_pin_set_locked fs/bcachefs/journal_reclaim.c:389 [inline]
RIP: 0010:bch2_journal_pin_set+0x766/0x780 fs/bcachefs/journal_reclaim.c:449
Code: c1 0f 8c fe f9 ff ff 48 89 df e8 c5 28 c8 fd e9 f1 f9 ff ff e8 5b 71 60 fd 90 0f 0b e8 53 71 60 fd 90 0f 0b e8 4b 71 60 fd 90 <0f> 0b e8 43 71 60 fd 90 0f 0b e8 3b 71 60 fd 90 0f 0b e8 33 71 60
RSP: 0018:ffffc9000394ee50 EFLAGS: 00010293
RAX: ffffffff84356e75 RBX: 0000000000000000 RCX: ffff88802c313c00
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84356bc2 R09: fffff52000729db8
R10: dffffc0000000000 R11: fffff52000729db8 R12: ffff88802766c901
R13: ffff8880789ca500 R14: ffff88802766c940 R15: ffffffffffffffff
FS:  00005555718ec380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557704c1da48 CR3: 000000007a91c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_pin_add fs/bcachefs/journal_reclaim.h:48 [inline]
 bch2_btree_add_journal_pin fs/bcachefs/btree_trans_commit.c:274 [inline]
 bch2_btree_insert_key_leaf+0x800/0xa90 fs/bcachefs/btree_trans_commit.c:306
 bch2_trans_commit_write_locked fs/bcachefs/btree_trans_commit.c:820 [inline]
 do_bch2_trans_commit fs/bcachefs/btree_trans_commit.c:900 [inline]
 __bch2_trans_commit+0x7163/0x93c0 fs/bcachefs/btree_trans_commit.c:1121
 bch2_trans_commit fs/bcachefs/btree_update.h:184 [inline]
 bch2_journal_replay+0x1a3a/0x2a40 fs/bcachefs/recovery.c:317
 bch2_run_recovery_pass+0xf0/0x1e0 fs/bcachefs/recovery_passes.c:191
 bch2_run_recovery_passes+0x3a7/0x880 fs/bcachefs/recovery_passes.c:244
 bch2_fs_recovery+0x25cc/0x39d0 fs/bcachefs/recovery.c:861
 bch2_fs_start+0x356/0x5b0 fs/bcachefs/super.c:1037
 bch2_fs_get_tree+0xd68/0x1710 fs/bcachefs/fs.c:2170
 vfs_get_tree+0x90/0x2b0 fs/super.c:1814
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4057 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4034
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc6f34c6dea
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc6a712b88 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc6a712ba0 RCX: 00007fc6f34c6dea
RDX: 0000000020000000 RSI: 0000000020000080 RDI: 00007ffc6a712ba0
RBP: 0000000000000004 R08: 00007ffc6a712be0 R09: 0000000000005983
R10: 0000000000000000 R11: 0000000000000282 R12: 0000000000000000
R13: 00007ffc6a712be0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_seq_pin fs/bcachefs/journal_reclaim.h:30 [inline]
RIP: 0010:bch2_journal_pin_set_locked fs/bcachefs/journal_reclaim.c:389 [inline]
RIP: 0010:bch2_journal_pin_set+0x766/0x780 fs/bcachefs/journal_reclaim.c:449
Code: c1 0f 8c fe f9 ff ff 48 89 df e8 c5 28 c8 fd e9 f1 f9 ff ff e8 5b 71 60 fd 90 0f 0b e8 53 71 60 fd 90 0f 0b e8 4b 71 60 fd 90 <0f> 0b e8 43 71 60 fd 90 0f 0b e8 3b 71 60 fd 90 0f 0b e8 33 71 60
RSP: 0018:ffffc9000394ee50 EFLAGS: 00010293
RAX: ffffffff84356e75 RBX: 0000000000000000 RCX: ffff88802c313c00
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff84356bc2 R09: fffff52000729db8
R10: dffffc0000000000 R11: fffff52000729db8 R12: ffff88802766c901
R13: ffff8880789ca500 R14: ffff88802766c940 R15: ffffffffffffffff
FS:  00005555718ec380(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557704c1da48 CR3: 000000007a91c000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


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
