Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F1F01E5B95
	for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 08:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748249431; cv=none; b=opAu8Et7tscj5dmzqbxCcN3sbfMOAZ2HisoCUqV2wY0uR/O3CGFkii4aWtapSESMdc01eFZhhKkOeVxuaTKkpRHobg+ztpZVy/DE4fL8uCQh1yXuG9YrF+Fl+ytq+VXF+bXJUrtDuEzU4bX5jfyj8WQunhg8FcEPbX0T+Ie0rB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748249431; c=relaxed/simple;
	bh=j3LtMtju26Q7ZyUO5+IEsDtEOmbWNVYY1y3nj7v1w/4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XTztgees057SoEAUGbpsx9fvjzmxvB86k3K+qwrDJOy4hFP6kdfzIYYvH4wCnUCVewmCtREgxqUSs72PNOZ5wdVxy08mWuQ7jdS8qBayDOIhnjHVLrA89+pc31D053LKQQNBbXpL1ZbEe7FKhg8W6DucGXzNZn6Y0gVxSDvKZHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-85e318dc464so359108239f.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 26 May 2025 01:50:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748249429; x=1748854229;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sTO5C53Lmd93U7NPZ4SLBFhzHibR0ihOHCl0ZMwbCwQ=;
        b=wtfKjm5yxohK2vQdcCK0GcLMJG6x9EGk0n15kzxb/BoI0fUWc5jr309a9A9wNJZXUd
         YyaQFe1oxbzNVwNRkBTSDvKLYJQO9z2W6VPXvq1rdj1l/ubVrPY1crQwhwCbtI7iYcSe
         Nz7jnSkiH8ojO6fYfW/tR3eO5O59Rgyl2iBIodDARdB3c5DmCAD2ELjKc+C5jMvCE8fY
         ifRSvjzMKajfLcRjEuOYIjr4Cg4UHLbgtHiWi1wipxvfXKODEnHiLpNyZ7QtICpXi2//
         yku2EZvn4PJ64jhkVvSJU+/N5TadPIuTuNHkp2v1UeguPf/TSI5s+eeJl2DUo3VbRB2a
         vsLA==
X-Forwarded-Encrypted: i=1; AJvYcCXaVnGJQXbwAXp14kAgZ80xCQeEynQb0MipNQVCvpReuiRf57+J9/9zT7O2LMoJjwHmvq4tdLGsezEzD5DE5Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjucx/vwDloB7iIhOMk1b1nNHFGUzUWos/fkKyZABuTdmAtuZX
	2JGuL6A2kGv5yjB2BtNX2SedoxhM6GghQSRE5rPvgYs4Vqw1/Bh5zyDFE6kV5y1YLOxgqJ4xfKh
	rk4qa082cNUJLRPX6xjYW/IXNvNZTZj7vM3wortK8DpU7MkC7BUcwW5MYxIs=
X-Google-Smtp-Source: AGHT+IESN2vogO8FUPtWwAie9BKDAhBT+JvZIPb7syOHYs4J2/xkRaCtWXNMZJhkWv9Qdu2zGuxFQTTGeQvwQloCKYnyJb0jmEyd
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3e85:b0:869:d4de:f7 with SMTP id
 ca18e2360f4ac-86cbb905927mr880291039f.12.1748249429441; Mon, 26 May 2025
 01:50:29 -0700 (PDT)
Date: Mon, 26 May 2025 01:50:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68342b55.a70a0220.253bc2.0092.GAE@google.com>
Subject: [syzbot] [bcachefs?] WARNING in rhashtable_init_noprof
From: syzbot <syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    176e917e010c Add linux-next specific files for 20250523
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13d555f4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e7902c752bef748
dashboard link: https://syzkaller.appspot.com/bug?extid=bcc38a9556d0324c2ec2
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145948e8580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d6a170580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5f7692c642fa/disk-176e917e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/057a442d42d0/vmlinux-176e917e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f8ebdb4dd96/bzImage-176e917e.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/d3d310848021/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+bcc38a9556d0324c2ec2@syzkaller.appspotmail.com

ODEBUG: object ffffc9000469fb90 is on stack ffffc90004698000, but NOT annotated.
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 debug_object_is_on_stack lib/debugobjects.c:655 [inline]
WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 lookup_object_or_alloc lib/debugobjects.c:688 [inline]
WARNING: CPU: 1 PID: 5924 at lib/debugobjects.c:655 __debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
Modules linked in:
CPU: 1 UID: 0 PID: 5924 Comm: bch-copygc/loop Not tainted 6.15.0-rc7-next-20250523-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:debug_object_is_on_stack lib/debugobjects.c:655 [inline]
RIP: 0010:lookup_object_or_alloc lib/debugobjects.c:688 [inline]
RIP: 0010:__debug_object_init+0x2c9/0x3c0 lib/debugobjects.c:743
Code: cc cc cc 41 ff c7 44 89 3d a4 18 14 15 48 c7 c1 80 9b e2 8b 48 c7 c7 e0 9b e2 8b 84 c0 48 0f 45 f9 48 89 de e8 48 2b 61 fc 90 <0f> 0b 90 e9 c0 fe ff ff e8 3a 1c 00 00 8b 05 1c 9c c6 09 3b 05 1a
RSP: 0018:ffffc9000469f6e0 EFLAGS: 00010046
RAX: 0000000000000050 RBX: ffffc9000469fb90 RCX: 0aa01120dfd08500
RDX: 0000000000000000 RSI: 0000000080000001 RDI: 0000000000000000
RBP: ffff88802f5c9e20 R08: ffffc9000469f3c7 R09: 1ffff920008d3e78
R10: dffffc0000000000 R11: fffff520008d3e79 R12: 0000000000000040
R13: ffff8880771e5d20 R14: dffffc0000000000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888125d56000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1c5ee80000 CR3: 0000000077540000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rhashtable_init_noprof+0x7c0/0xbb0 lib/rhashtable.c:1085
 bch2_copygc_thread+0x116/0xdc0 fs/bcachefs/movinggc.c:355
 kthread+0x711/0x8a0 kernel/kthread.c:464
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
