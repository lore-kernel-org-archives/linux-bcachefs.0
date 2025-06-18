Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202A42E6D13
	for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 13:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252043; cv=none; b=kOA+oHEJKmrZpe3/yDbRuJUbqzIqNTf0Btq6VZpYrq+hpPSZJkejblrcujlIlEVBQ1BiSeQp1bqMWX+L42Ky3rMB4mLnVcztoJpg0mgejIENxNgKpidn/68JbPUQUaK+gkJIvaSg3vRdhdbx9W5JVb0mpZT4I2Vuc4D8oQ7mxjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252043; c=relaxed/simple;
	bh=aSdAfxHpoXSYqKwZBlLym7HDqDR+emh7M8PqloxM5tA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nCe+YvY3fsYHfCpGxTpqfELqkyE9PJRYP+BAdUN6ldZ4ZkOfEtjtySUXyIpWQPx7kaakZeygi8/cFVmtpqvpE441/Y6eR4uTV2XxWrf7G2m+B9YCr1ba3JhnL289YfZZfBJ3z8qYU02UUCzwBl52rRnN5i/6X5wA/nCyxu1aqR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddbd339f3dso73842685ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 18 Jun 2025 06:07:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750252040; x=1750856840;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GZEYlP3cazfT0Vd6760ReqSnldFn0MXtcHWYgN+wpx8=;
        b=viybx16bKBQWknFoX4vXJ4Hpmfj+t7/lP76oUg//7Y332JmDOl6ME/otIB3TYA4qdu
         PJX05hN2dFeSWiMsdd5oLs6ymer3e/LN6R1cdVHGu1cSIvThuFLUQKJvVx94Ndf+Pb7Y
         IhSPkH0jTSnf9N+VvjWRL9LxOPOmdtjvTqcpbBzorrttW5gaFHjjU/DwuGoEZskownEI
         m0WRBB+6H7Ewl1myDyWcIjCeWViJ657y4vFz6/TYmuCkhykkQ9lQq+KwvNCSqbAwuYXt
         amIpmtZ7XhHbWfsqynhz5DTP/XPXnw2Kdqptutm+GYXOYICdqUwQ5M+A9WAF7b0HYhlC
         SIdw==
X-Forwarded-Encrypted: i=1; AJvYcCUkohLdEOc9dr5NXjKVF1r1prYqu33wLdQbUcc2tLetHHwg2wDa5TEUKqxEl8lml45tqM7ncgXihV9zoD79Dw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyY3vrYwQbjKZYWtVUii4RJ7dMVNbtWV68VOqAZF+XvA2BT3COc
	NRujtnnzPzxgyY1AwGFlHja9YC8GoBOb6jMhw31C8dtQ9923We0j2c5bZ4uKg5a05vT+WCU5jNf
	zf3vQpvrPC/yrtMotojgk6eBsqZATfUcOU2ufpsFLfpquZ1UQVIL1W6OciPU=
X-Google-Smtp-Source: AGHT+IGAPZGHXFqHyQg0bEHAbpi3Tk9lTqgH1Bnxq09IT5tBg9uO50cw79yIJOsgtccmzrcDDZbFNlcUHIZX/ZPPYEkrAnlfrIvY
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:c267:0:b0:3dd:d322:a0df with SMTP id
 e9e14a558f8ab-3de07d7dbd1mr190809755ab.17.1750252040150; Wed, 18 Jun 2025
 06:07:20 -0700 (PDT)
Date: Wed, 18 Jun 2025 06:07:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6852ba08.050a0220.216029.0010.GAE@google.com>
Subject: [syzbot] [bcachefs?] kernel BUG in __journal_res_get (3)
From: syzbot <syzbot+b58cefdc75f590b71819@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4774cfe3543a Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=163ade0c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cb55ce02d42a1797
dashboard link: https://syzkaller.appspot.com/bug?extid=b58cefdc75f590b71819
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ba25d4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16e1710c580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/97bb82d143d5/disk-4774cfe3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/705549b5d0ef/vmlinux-4774cfe3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/49a4d858182e/bzImage-4774cfe3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/641c4a3837a4/mount_0.gz

Bisection is inconclusive: the first bad commit could be any of:

0e43bf5a6a8f bcachefs: Simplify logic
58c36e6710d3 bcachefs: Initialize c->name earlier on single dev filesystems
c02e5b57283a bcachefs: Single device mode

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1348290c580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b58cefdc75f590b71819@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at fs/bcachefs/journal.c:397!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 5845 Comm: syz-executor388 Not tainted 6.16.0-rc1-syzkaller-00203-g4774cfe3543a #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:journal_entry_open fs/bcachefs/journal.c:397 [inline]
RIP: 0010:__journal_res_get+0x25cd/0x27f0 fs/bcachefs/journal.c:639
Code: ff ff e9 2b db ff ff e8 01 7c 7e fd 41 be eb f6 ff ff e9 1b db ff ff e8 11 58 1d 07 e8 ec 7b 7e fd 90 0f 0b e8 e4 7b 7e fd 90 <0f> 0b e8 dc 7b 7e fd 90 0f 0b e8 d4 7b 7e fd 90 0f 0b e8 cc 7b 7e
RSP: 0018:ffffc900044af4c0 EFLAGS: 00010293
RAX: ffffffff8441cf5c RBX: 1ffff1100dda951b RCX: ffff888011a10000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc900044af790 R08: ffff88806ed4a9f7 R09: 1ffff1100dda953e
R10: dffffc0000000000 R11: ffffed100dda953f R12: ffff88806ed49800
R13: 1ffff1100dda953e R14: 0000000000000002 R15: 00000000007ffffe
FS:  00007f2e8034d6c0(0000) GS:ffff888125d86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2e803ec758 CR3: 0000000074850000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_journal_res_get_slowpath+0xdc/0xaf0 fs/bcachefs/journal.c:734
 bch2_journal_res_get+0x14f/0x1f0 fs/bcachefs/journal.h:401
 __bch2_journal_meta+0x40/0x1d0 fs/bcachefs/journal.c:980
 bch2_fs_journal_stop+0x1dd/0x440 fs/bcachefs/journal.c:1462
 __bch2_fs_read_only+0x343/0x5b0 fs/bcachefs/super.c:307
 __bch2_fs_read_write+0x5cd/0x830 fs/bcachefs/super.c:554
 bch2_fs_reconfigure+0x29a/0x400 fs/bcachefs/fs.c:2675
 reconfigure_super+0x224/0x890 fs/super.c:1075
 do_remount fs/namespace.c:3369 [inline]
 path_mount+0xd18/0xfe0 fs/namespace.c:4201
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2e80398c49
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2e8034d218 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f2e804306a8 RCX: 00007f2e80398c49
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000000
RBP: 00007f2e804306a0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000002012024 R11: 0000000000000246 R12: 0000200000000000
R13: 0030656c69662f2e R14: 7366656863616362 R15: 0000200000000080
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:journal_entry_open fs/bcachefs/journal.c:397 [inline]
RIP: 0010:__journal_res_get+0x25cd/0x27f0 fs/bcachefs/journal.c:639
Code: ff ff e9 2b db ff ff e8 01 7c 7e fd 41 be eb f6 ff ff e9 1b db ff ff e8 11 58 1d 07 e8 ec 7b 7e fd 90 0f 0b e8 e4 7b 7e fd 90 <0f> 0b e8 dc 7b 7e fd 90 0f 0b e8 d4 7b 7e fd 90 0f 0b e8 cc 7b 7e
RSP: 0018:ffffc900044af4c0 EFLAGS: 00010293
RAX: ffffffff8441cf5c RBX: 1ffff1100dda951b RCX: ffff888011a10000
RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
RBP: ffffc900044af790 R08: ffff88806ed4a9f7 R09: 1ffff1100dda953e
R10: dffffc0000000000 R11: ffffed100dda953f R12: ffff88806ed49800
R13: 1ffff1100dda953e R14: 0000000000000002 R15: 00000000007ffffe
FS:  00007f2e8034d6c0(0000) GS:ffff888125d86000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2e803ec758 CR3: 0000000074850000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
