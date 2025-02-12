Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5E51DEFDD
	for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 16:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739379208; cv=none; b=ki+CPQICtX/pgDQC7Bm2bBo/wfu5wJe024oUaoupxgjFV1208aoUFEtuUYizVA6tfLLZldlpDSRTP/QZVv2sM4AEB5YThPZmch92I2p0YPx4tz/nxX9RgnHxkHnmbYwfD1+Z00nQcZK2rLtiqbwRV6Jie7KmGMniesqKWbA3tMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739379208; c=relaxed/simple;
	bh=r25dJTKSFecaxXGpmSfG7z/bcWbBk3TiIUvjTPw9Goc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AxfSC9xcDPFDPhylD4W0dTF2LN7thYo8XFDhXvs1WhakpJlgpou46lBRQ/8kct2BEiLmjQGsqOOzNL4g76pstG+ksS5Ti9y+nY9Iwd4sVSkcJ6iwInGf+HNMnqw+ip3DHh8o1OdazQCp0YkF659gujdrkySWoTkCQcM9pORc1Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3d14950ac9fso103354775ab.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 12 Feb 2025 08:53:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739379205; x=1739984005;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uWgLD1vusl8skohv78bYDjNV0c9w8OpHAzd5f8hHkd8=;
        b=ZO6plxFq4LQCpks1p7BQZqBXG5Im/rGBIlmd0EZLqICm+JbwrXQLZ7CYgi0nEBKXPq
         0c9AY9hjQUtCCdaai8VneCijAQD0126kY975UnPWJ97Y7xpg5Md1usiQiBS+u9LMYvOz
         5FTyIe0HPaLdEiDomotu/a9Hhb98mKphAvBESsbOf+znOuXVIe16E7TEdVgNu8zJF5TK
         Ha4ntLyNGzvE0MqvgP3+wNEVbJ56VJ+Awj3x2QeP8/IvtibTqwYAmnZhcTIOGDUlC1hp
         /lvacDCvobPdfsp8/OHdrxbk5SIyd1r4LPNAiapPEDR2cnBuhcwHv/jzBkI0rPKSJk4Z
         wmcA==
X-Forwarded-Encrypted: i=1; AJvYcCXk+Cy/tjd7Be+okc1YHwtjMgFL7gyzAIa22QkFHuRcMa0Bphx9RPtT6lv+KHJN3/5NRiugfcXJdBVIDL/0fg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4RyV6RFwkJR3qdcnGg49qnSUgq/rw/Q6gUGM696pmxIDC9spW
	He46lq5x2nL6VvF8W7Qpvpzs6SaHvXVo4Dw3vi5wAuB9Vq3Qs+Etydq6DYT8ezlCgbiKyCN779+
	jjnn8jdQRTzvgrK5ZS5+wfO+2peispbRuuZxqpZgX3Izu9c2R+OmUg6g=
X-Google-Smtp-Source: AGHT+IGwJ6cBqgXv7DnZVIBFzb6rv4k41eoOZFrlQ4CMlfisQqY7Aot5REdFqPkae7IuHy80sidluk2ZIDYAfMcLuB8Ukd9AQudE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17cc:b0:3cf:c9ad:46a1 with SMTP id
 e9e14a558f8ab-3d17bfc7465mr36439155ab.13.1739379205288; Wed, 12 Feb 2025
 08:53:25 -0800 (PST)
Date: Wed, 12 Feb 2025 08:53:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67acd205.050a0220.3d72c.01bf.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in bch2_journal_do_writes
 (2)
From: syzbot <syzbot+167028f6dd31d18e95c3@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    ed58d103e6da Add linux-next specific files for 20250207
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=158addf8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=244a34ec1429746
dashboard link: https://syzkaller.appspot.com/bug?extid=167028f6dd31d18e95c3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ce459b7174dd/disk-ed58d103.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/60699733c0c8/vmlinux-ed58d103.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f589bce7c898/bzImage-ed58d103.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+167028f6dd31d18e95c3@syzkaller.appspotmail.com

bcachefs (loop0): done initializing freespace
bcachefs (loop0): reading snapshots table
bcachefs (loop0): reading snapshots done
Oops: general protection fault, probably for non-canonical address 0xf110004ee8002002: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0x8880227740010010-0x8880227740010017]
CPU: 0 UID: 0 PID: 9260 Comm: syz.0.650 Not tainted 6.14.0-rc1-next-20250207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5091
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 3b fe 80 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 e8 79 8b 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc90004886c30 EFLAGS: 00010803
RAX: 1110044ee8002002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 8880227740010017
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff20376cf R12: ffff888025483c00
R13: 0000000000000000 R14: 0000000000000000 R15: 8880227740010017
FS:  00007f1ec11346c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbd2b5fbdf0 CR3: 000000005e3ea000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 __queue_work+0x759/0xf50
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2390
 queue_work include/linux/workqueue.h:662 [inline]
 closure_queue include/linux/closure.h:268 [inline]
 closure_call include/linux/closure.h:432 [inline]
 bch2_journal_do_writes+0x383/0x420 fs/bcachefs/journal.c:200
 bch2_journal_buf_put_final+0x9e/0xf0 fs/bcachefs/journal.c:218
 __bch2_journal_buf_put fs/bcachefs/journal.h:277 [inline]
 __journal_entry_close+0x812/0xdf0 fs/bcachefs/journal.c:309
 journal_entry_want_write+0xf3/0x250 fs/bcachefs/journal.c:339
 bch2_journal_flush_seq_async+0x769/0x880 fs/bcachefs/journal.c:805
 bch2_journal_flush_seq+0xe5/0x2b0 fs/bcachefs/journal.c:822
 bch2_fs_initialize+0x129a/0x1610 fs/bcachefs/recovery.c:1200
 bch2_fs_start+0x36d/0x610 fs/bcachefs/super.c:1042
 bch2_fs_get_tree+0xd8d/0x1740 fs/bcachefs/fs.c:2203
 vfs_get_tree+0x90/0x2b0 fs/super.c:1759
 do_new_mount+0x2be/0xb40 fs/namespace.c:3659
 do_mount fs/namespace.c:3999 [inline]
 __do_sys_mount fs/namespace.c:4210 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4187
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ec038e58a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1ec1133e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f1ec1133ef0 RCX: 00007f1ec038e58a
RDX: 00004000000000c0 RSI: 0000400000000180 RDI: 00007f1ec1133eb0
RBP: 00004000000000c0 R08: 00007f1ec1133ef0 R09: 0000000000000010
R10: 0000000000000010 R11: 0000000000000246 R12: 0000400000000180
R13: 00007f1ec1133eb0 R14: 00000000000059d5 R15: 0000400000000480
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5091
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 3b fe 80 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 e8 79 8b 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc90004886c30 EFLAGS: 00010803
RAX: 1110044ee8002002 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 8880227740010017
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000001
R10: dffffc0000000000 R11: fffffbfff20376cf R12: ffff888025483c00
R13: 0000000000000000 R14: 0000000000000000 R15: 8880227740010017
FS:  00007f1ec11346c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbd2b5fbdf0 CR3: 000000005e3ea000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 f8 16 	xor    %al,0x16f8850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d 3b fe 80 0e 00 	cmpl   $0x0,0xe80fe3b(%rip)        # 0xe80fe50
  15:	0f 84 c8 13 00 00    	je     0x13e3
  1b:	89 54 24 60          	mov    %edx,0x60(%rsp)
  1f:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 e8 79 8b 00       	call   0x8b7a20
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


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
