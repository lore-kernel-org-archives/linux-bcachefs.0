Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0D82FE32F
	for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 19:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752779617; cv=none; b=QtuIvW5pYyHBZpyNppiHTHuigZx+1cZWQCDx72x4f3m/puBOkZZvL/eW6iEF4i0fMEKbEN95kfTu+yALhxhx4Kgd41bd9+f1fTn7o4AOLCHxDFl+hKMTFtdgbMaBdbQML5W7Ex1krIsprB4bjBgVC2OXV2imKaKBulnbJzdoafU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752779617; c=relaxed/simple;
	bh=uHanw3BffKer5S1hYmQAqDYchfX60H1ydtzPGV0p+Rw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=H1qp8PJqwiXuXDHmHHM++qF2Ffb+l963w+yOrh0BKD6KEbgUDBnc2E8BaaG8yvipF64j0Oy6y09FCsORCaAeiDBBtcLJTDZxW6H4BZfaQ3UoL5rE0NHJHpdYjKKvnL4Ct2UhrrPbIO1jlLkJmLLIE9sBFpEit4KDCzLTqhAMXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3e29099056eso9477025ab.3
        for <linux-bcachefs@vger.kernel.org>; Thu, 17 Jul 2025 12:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752779613; x=1753384413;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WUC5dpMfh44cxoF2/Hp+ObndAlHMHds+y4urJKCorQE=;
        b=L4tTNC8wyhC9dGY9FtCWHNpTup8ticX+UA8DoHK9VCMOgOwW9qAFBcpSIIgxmXALLi
         OgKZrbZxUUUTgbQbwef7wPRhHGgWg/uyWMYI0fNhN6EBhkxIGIEHxp3PDIrCmgi88+1O
         aF4E8aeolsrSEm13yPrHf1OWNtaSm6cwgM7MnMDfHsC9ih+5NCdhxFyGBYOG3WV6GKpD
         nUkDzK4Fx6Kpd+dVT/VgLvd4IPuFkWo1VJqJZ2HFADvUYIiILycuZzjJSII64kg1II2b
         34yURrrJvCxPrg0FXnOjDQXw/e2yZE9FW58a6PW0mntF3PX858rviXrMXHKznDe4zmTM
         ioag==
X-Forwarded-Encrypted: i=1; AJvYcCXVPU1YK/TCK+redCPPcvkPki9rFsS2GBWIfcyBKjAsOsmoUtofNQBS+CwIKDPVyCxztLR3w2TYAeB6oC7KvA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHy4PfZJsy78QEPV/phzdIDpM4NgV0/2HHERINQPvwvi18pn1k
	atTvIbKX+EnHwTAwuSoUd7vg/8gchUcL+OKVJL75TVshq8nwLU/FK6dmpI1uqmz2VWP3CN6h7XL
	xxIIHtwGUnrTUiY9atPJRHbHDq7exXV5aFu8SgHi0uuNntFmv1JX+PC7Fu2s=
X-Google-Smtp-Source: AGHT+IGV3TsaTYhOQzaG/Fdd1Y5H5ZxvIpodSOLpYGKCQrsvzCyQ6R+hqr723mPtW8EwzY51vzslMd2pwIigZ6zv+RDvfuQpS0UV
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2141:b0:3e2:8ab0:11cb with SMTP id
 e9e14a558f8ab-3e28ab01a17mr48104765ab.15.1752779613127; Thu, 17 Jul 2025
 12:13:33 -0700 (PDT)
Date: Thu, 17 Jul 2025 12:13:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68794b5d.a70a0220.693ce.0051.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in bch2_dev_free (2)
From: syzbot <syzbot+6d52ee9afea131b36348@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e8352908bdcd Add linux-next specific files for 20250716
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=156f67d4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2594af20939db736
dashboard link: https://syzkaller.appspot.com/bug?extid=6d52ee9afea131b36348
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a2158c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=138bc58c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/c5f2b597f40f/disk-e8352908.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0d56411fc215/vmlinux-e8352908.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7f800652df04/bzImage-e8352908.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/e21d9537db5e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6d52ee9afea131b36348@syzkaller.appspotmail.com

bcachefs (loop0): going read-write
bcachefs (loop0): bch2_write_super(): fatal error  loop0: Superblock modified by another process (seq 43 expected 42)
bcachefs (loop0): error in recovery: erofs_sb_err
bcachefs (loop0): bch2_fs_start(): error starting filesystem erofs_sb_err
------------[ cut here ]------------
WARNING: fs/bcachefs/super.c:1373 at bch2_dev_free+0x3db/0x480 fs/bcachefs/super.c:1373, CPU#0: syz-executor315/5848
Modules linked in:
CPU: 0 UID: 0 PID: 5848 Comm: syz-executor315 Not tainted 6.16.0-rc6-next-20250716-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:bch2_dev_free+0x3db/0x480 fs/bcachefs/super.c:1373
Code: f7 e8 e9 13 e2 ff 4c 89 ef e8 e1 13 e2 ff 4c 89 ff 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 7b dd 14 07 e8 96 e7 65 fd 90 <0f> 0b 90 e9 2c fd ff ff e8 88 e7 65 fd 90 0f 0b 90 e9 fe fd ff ff
RSP: 0018:ffffc90003f2f8c8 EFLAGS: 00010293
RAX: ffffffff8459bf3a RBX: dffffc0000000000 RCX: ffff888033b1bc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88801fb71687 R09: 1ffff11003f6e2d0
R10: dffffc0000000000 R11: ffffed1003f6e2d1 R12: ffff888031fe8128
R13: 0000000000000001 R14: 1ffff110063fd024 R15: 1ffff110063fd025
FS:  0000555561a5c380(0000) GS:ffff888125be2000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000557f62e59da0 CR3: 0000000068888000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 bch2_fs_free+0x440/0x550 fs/bcachefs/super.c:749
 bch2_fs_get_tree+0xb76/0x1540 fs/bcachefs/fs.c:2572
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1804
 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f27d9758eaa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd6f511ee8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffd6f511f00 RCX: 00007f27d9758eaa
RDX: 0000200000000080 RSI: 0000200000000000 RDI: 00007ffd6f511f00
RBP: 0000200000000000 R08: 00007ffd6f511f40 R09: 000000000000f631
R10: 0000000001010051 R11: 0000000000000282 R12: 0000200000000080
R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffd6f511f40
 </TASK>


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
