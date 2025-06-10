Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96045244186
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 19:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584192; cv=none; b=A4h5GqobkG59UEhvuZpdMnxH5KZ2bDdI3zs3kZhTk2dk5nix0MfnRAzEwMiJiYrxP6xtIbH50kwWu0a/1BgaWWcqdb/uqxw8St0ngXJFT7adNG/NMzAZq3tu+pnjk4gknmc7qMX7iVBNJjxITZAXyVzygjZa1TX+80xOI9RgjoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584192; c=relaxed/simple;
	bh=3dhV5GqDavXSST+amA9fuuzurdDjUghC05BZc9imIv4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=iNdZ9AcMB+KK/JYmtnyGl1wiLX0SUC7Pvxs8Ibzv9OsYN0tW5JLXkejUwzZE0Ug3TPyRfrp2Z1Weoifliqs79Nj0TK/ZxRbRS4NXFac7yRuUS70XSlPJ+v5ejXhdcFQZjcZpPis1VzqaNUk0lJsDbCYoiVdB7nbaUX50vyJucwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-86cfea700daso436650739f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 12:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584190; x=1750188990;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tDqX/66dNoKzBq1LgpqJrNhrAp82BKueX+2DAvRNlg=;
        b=Jnx25c2a/27jf/A8RyeeJRf7+DlEIOOLvFrgmo733St/GLUGWWRuGuh+RDu0kKnl+O
         BJucT3tYQCdntLFBzGOxJhxHT0iodN0CTNo4ZYjR+0mA/jUEU54rVjxPXMxpNMf4WKTi
         1e3fhj3SlURRZ9Vab73fTwiSvsovmIDzUkvuOMqRpcbp2qDzA8WoA8mH2z1TizsFB3Ce
         mV4j9+l2i2xrS3UOHVEepGKszweQZh5sCCdD+1Mg6d25pwwsJnD25bu6hSGCuhyj90jM
         KQIspJbLYBIDES8vSGtsfenGjL321y3sl8JhGoocQ0KJHAE82+BEXYs9Sc6HGxhRih1V
         2osw==
X-Forwarded-Encrypted: i=1; AJvYcCVRHS5sqlf4ZgCjNHS6OnJw1N8ReY8F5+vBLBRyviJeVxAFZ80Hdq1+C1P9FaD4in8WtxdRKjpB27Z0hhc2mw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPFxle3duhIk++poTz0ccmyqlEA1lf7XBu6EZuRi8sHqcljhE9
	6hsY3TrGvYE+hDz2K+7pfH86jHb68NeN2ZZpXVyNHxIMRyaDwsi8QPYF90/nIZWTtWLW9pY2g0R
	1WuiNSYcE4tnj05Tveu/3XKZJiCGi6BVzVqCfnAA3VIS5ODDaj5HsnNA3824=
X-Google-Smtp-Source: AGHT+IGnHJtB7diXzuzXXrtGs+HqYC5dcoHcOKNs32PzvB9MJ7TsFGc2qw+HmI39wAZ2EannPzH2q3+D1AmYkHLTcmiCAbe6Uxhx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2587:b0:3dc:7df8:c830 with SMTP id
 e9e14a558f8ab-3ddf423919emr7130065ab.7.1749584189760; Tue, 10 Jun 2025
 12:36:29 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:36:29 -0700
In-Reply-To: <68488453.a70a0220.27c366.0068.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6848893d.050a0220.33aa0e.0361.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] divide error in bch2_sb_members_v2_to_text
From: syzbot <syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    b27cc623e01b Add linux-next specific files for 20250610
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=15386a82580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=846e731334efc0f8
dashboard link: https://syzkaller.appspot.com/bug?extid=7c8101d4d0ba2eb511d7
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=175a260c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1129e9d4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1c0c417339c8/disk-b27cc623.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa29c0f3a1fa/vmlinux-b27cc623.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b902a80b6e7e/bzImage-b27cc623.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/2fc50b6bfeb8/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
=======================================================
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
Oops: divide error: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5842 Comm: syz-executor227 Not tainted 6.16.0-rc1-next-20250610-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:bch2_sb_members_v2_to_text+0x10a/0x3c0 fs/bcachefs/sb-members.c:347
Code: 49 89 f4 49 c1 ec 03 43 0f b6 0c 34 84 c9 48 89 b4 24 a0 00 00 00 0f 85 67 02 00 00 0f b7 0e 48 89 c2 48 c1 ea 20 74 07 48 99 <48> f7 f9 eb 04 31 d2 f7 f1 48 89 84 24 b0 00 00 00 48 8b 84 24 c8
RSP: 0018:ffffc9000434ed40 EFLAGS: 00010a02
RAX: ffff88807b3f8368 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffffffffffff RSI: ffff88807b3f8338 RDI: 000000000000000e
RBP: ffffc9000434ef70 R08: 000000000000003a R09: 000000000000003a
R10: dffffc0000000000 R11: ffffffff844fcfb0 R12: 1ffff1100f67f067
R13: 000000000000000b R14: dffffc0000000000 R15: 1ffff92000869dc4
FS:  000055556af99380(0000) GS:ffff888125c4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056367c34f6a8 CR3: 00000000770e4000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_sb_field_validate+0x1c6/0x280 fs/bcachefs/super-io.c:1380
 bch2_sb_validate+0x14bd/0x1980 fs/bcachefs/super-io.c:552
 __bch2_read_super+0xba4/0x1040 fs/bcachefs/super-io.c:925
 bch2_fs_open+0x1fe/0x2570 fs/bcachefs/super.c:2382
 bch2_fs_get_tree+0x437/0x14f0 fs/bcachefs/fs.c:2473
 vfs_get_tree+0x8f/0x2b0 fs/super.c:1802
 do_new_mount+0x24a/0xa40 fs/namespace.c:3885
 do_mount fs/namespace.c:4222 [inline]
 __do_sys_mount fs/namespace.c:4433 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4410
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb499d6198a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe1a446798 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe1a4467b0 RCX: 00007fb499d6198a
RDX: 0000200000000000 RSI: 0000200000011a40 RDI: 00007ffe1a4467b0
RBP: 0000200000000000 R08: 00007ffe1a4467f0 R09: 00000000000119f3
R10: 00000000028080c9 R11: 0000000000000282 R12: 0000200000011a40
R13: 0000000000000004 R14: 0000000000000003 R15: 00007ffe1a4467f0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_sb_members_v2_to_text+0x10a/0x3c0 fs/bcachefs/sb-members.c:347
Code: 49 89 f4 49 c1 ec 03 43 0f b6 0c 34 84 c9 48 89 b4 24 a0 00 00 00 0f 85 67 02 00 00 0f b7 0e 48 89 c2 48 c1 ea 20 74 07 48 99 <48> f7 f9 eb 04 31 d2 f7 f1 48 89 84 24 b0 00 00 00 48 8b 84 24 c8
RSP: 0018:ffffc9000434ed40 EFLAGS: 00010a02
RAX: ffff88807b3f8368 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffffffffffff RSI: ffff88807b3f8338 RDI: 000000000000000e
RBP: ffffc9000434ef70 R08: 000000000000003a R09: 000000000000003a
R10: dffffc0000000000 R11: ffffffff844fcfb0 R12: 1ffff1100f67f067
R13: 000000000000000b R14: dffffc0000000000 R15: 1ffff92000869dc4
FS:  000055556af99380(0000) GS:ffff888125d4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056367c3149f8 CR3: 00000000770e4000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	49 89 f4             	mov    %rsi,%r12
   3:	49 c1 ec 03          	shr    $0x3,%r12
   7:	43 0f b6 0c 34       	movzbl (%r12,%r14,1),%ecx
   c:	84 c9                	test   %cl,%cl
   e:	48 89 b4 24 a0 00 00 	mov    %rsi,0xa0(%rsp)
  15:	00
  16:	0f 85 67 02 00 00    	jne    0x283
  1c:	0f b7 0e             	movzwl (%rsi),%ecx
  1f:	48 89 c2             	mov    %rax,%rdx
  22:	48 c1 ea 20          	shr    $0x20,%rdx
  26:	74 07                	je     0x2f
  28:	48 99                	cqto
* 2a:	48 f7 f9             	idiv   %rcx <-- trapping instruction
  2d:	eb 04                	jmp    0x33
  2f:	31 d2                	xor    %edx,%edx
  31:	f7 f1                	div    %ecx
  33:	48 89 84 24 b0 00 00 	mov    %rax,0xb0(%rsp)
  3a:	00
  3b:	48                   	rex.W
  3c:	8b                   	.byte 0x8b
  3d:	84 24 c8             	test   %ah,(%rax,%rcx,8)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
