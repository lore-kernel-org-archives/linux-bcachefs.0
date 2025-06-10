Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819EB263F38
	for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 19:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582936; cv=none; b=mJF8CUH9cUEtEiTjoFqDU0tm8q9M+eyaSfmvq/3bR1gwthciH4jimCvew2+hs9IlJKaQhlukb8R3LztBx3Pdre+/e3tG0qIY3SYmv9RbcpZRTU5HGJ68uNEYPitQkI92aZcBsTKXLk6+nEer2HW1M8QkyQDDA8MXw+pkcn8Uvek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582936; c=relaxed/simple;
	bh=MnVd4doMubVcZCpRp3jvlXiTtAIy17BAJY+YbMXtniI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QP+oF4l+IQPphqQIX+PYd16pWCryCyD4enW2Qp6wwX8StFaJJi3dn90VE56JLNY2GKWVTNpwN1RKzrS0DFyBPQIt3T/5Pbl9nX8lzGoHhbwyOjDCUBgYxCJzxbnBjDfVcBf/GvGe404rnl4GLu56gnZNJvUuyA2UXZ07M5GpszY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f205.google.com with SMTP id e9e14a558f8ab-3ddd03db21cso74834295ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 10 Jun 2025 12:15:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749582933; x=1750187733;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rskWntauwjeEdVaZrhHTAPlRX1TrwQGFox2za0OdbUI=;
        b=YLtBe0NI+2p+Flsg1YjV8mehivvUYdpoNULgOuLco2MvGJhvETcRwFtwosaFo9DkCs
         RGRTGJ7pmCz5Oct+hWSkvidHkawFbt1iY/gPq39MI/U6r+NFm6GUMJ3zQxMU+z0d+u0D
         5poDx0GQB0WjqF5gqFOAvIzBkURdxkNWaJrU1B58Gt/rQ56INI8CCveKa3Nx3MKIKS1Q
         0N6kdnMBk3jenPRfyWnmLsad6pgq5kmHMjGi3a0HIi7mYYz+I4SL9hJrgcgMttqVevqc
         jXx9GkTtp3HANZV6n6VFt6yJThqi9IbaPjQopGXMoB3xR8IDzvWnCry7+qUa7Cg5qkZ0
         RJew==
X-Forwarded-Encrypted: i=1; AJvYcCUYhw6+aX0SifRjWvI27he3SclLVoEL/HWHOXbRUCpiKjHm6ToonIJksRvDsCA0qrQoAocaB+tAnX05Tx9COQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzFLn++bNpzFqdJfSkX0g1tMuqjb0UElRfcXizYZzDMW/J8sKSC
	Kpz+sYOANQEsVhI4iFB1kzqQaM9oVc85TCEydkf1l3zHk5U9m6C9onvrxotjnJseBIkWbcb1iCA
	BlBt75oXeCorE355Uqr71EHpR81j41O3VYa4wzxAmgzkw6yVp34mkkoANgM0=
X-Google-Smtp-Source: AGHT+IEzkcYcfJGFUGjZQV/Zb5IFoLIxDvPRBpF1RbJpyislhfcZzSXMs9e9HD+S/2oZWvX3sA6ZtXiFPuhKDODVSk1nl3jWm1er
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4e:0:b0:3dc:7a9a:44d5 with SMTP id
 e9e14a558f8ab-3ddf431592dmr4916235ab.22.1749582931993; Tue, 10 Jun 2025
 12:15:31 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:15:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68488453.a70a0220.27c366.0068.GAE@google.com>
Subject: [syzbot] [bcachefs?] divide error in bch2_sb_members_v2_to_text
From: syzbot <syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    b27cc623e01b Add linux-next specific files for 20250610
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=169ac60c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=846e731334efc0f8
dashboard link: https://syzkaller.appspot.com/bug?extid=7c8101d4d0ba2eb511d7
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1c0c417339c8/disk-b27cc623.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa29c0f3a1fa/vmlinux-b27cc623.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b902a80b6e7e/bzImage-b27cc623.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7c8101d4d0ba2eb511d7@syzkaller.appspotmail.com

loop2: detected capacity change from 0 to 32768
Oops: divide error: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6339 Comm: syz.2.181 Not tainted 6.16.0-rc1-next-20250610-syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:bch2_sb_members_v2_to_text+0x10a/0x3c0 fs/bcachefs/sb-members.c:347
Code: 49 89 f4 49 c1 ec 03 43 0f b6 0c 34 84 c9 48 89 b4 24 a0 00 00 00 0f 85 67 02 00 00 0f b7 0e 48 89 c2 48 c1 ea 20 74 07 48 99 <48> f7 f9 eb 04 31 d2 f7 f1 48 89 84 24 b0 00 00 00 48 8b 84 24 c8
RSP: 0000:ffffc90003e5ed40 EFLAGS: 00010a02
RAX: ffff888029b58368 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffffffffffff RSI: ffff888029b58338 RDI: 0000000000001de6
RBP: ffffc90003e5ef70 R08: 000000000000003a R09: 000000000000003a
R10: dffffc0000000000 R11: ffffffff844fcfb0 R12: 1ffff1100536b067
R13: 000000000000000b R14: dffffc0000000000 R15: 1ffff920007cbdc4
FS:  00007f61376166c0(0000) GS:ffff888125c4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5581bb5f78 CR3: 000000007e792000 CR4: 00000000003526f0
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
RIP: 0033:0x7f61367900ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6137615e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f6137615ef0 RCX: 00007f61367900ca
RDX: 0000200000000000 RSI: 0000200000011a40 RDI: 00007f6137615eb0
RBP: 0000200000000000 R08: 00007f6137615ef0 R09: 00000000028080c9
R10: 00000000028080c9 R11: 0000000000000246 R12: 0000200000011a40
R13: 00007f6137615eb0 R14: 00000000000119f9 R15: 0000200000013d00
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bch2_sb_members_v2_to_text+0x10a/0x3c0 fs/bcachefs/sb-members.c:347
Code: 49 89 f4 49 c1 ec 03 43 0f b6 0c 34 84 c9 48 89 b4 24 a0 00 00 00 0f 85 67 02 00 00 0f b7 0e 48 89 c2 48 c1 ea 20 74 07 48 99 <48> f7 f9 eb 04 31 d2 f7 f1 48 89 84 24 b0 00 00 00 48 8b 84 24 c8
RSP: 0000:ffffc90003e5ed40 EFLAGS: 00010a02
RAX: ffff888029b58368 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffffffffffffffff RSI: ffff888029b58338 RDI: 0000000000001de6
RBP: ffffc90003e5ef70 R08: 000000000000003a R09: 000000000000003a
R10: dffffc0000000000 R11: ffffffff844fcfb0 R12: 1ffff1100536b067
R13: 000000000000000b R14: dffffc0000000000 R15: 1ffff920007cbdc4
FS:  00007f61376166c0(0000) GS:ffff888125c4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f961d79c000 CR3: 000000007e792000 CR4: 00000000003526f0
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
