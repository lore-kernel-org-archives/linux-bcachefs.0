Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E562943F
	for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 10:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726916004; cv=none; b=uJxto34Vy7S4meU5Od4Y7h9g7tH0+D0/1ox5hUiOkVhMFxlVfC3PFLgT1TuSskssa3771XoHaF/cJ3dxjqs61o/CpsXVQZsDYYw4YX5cBwhTha9C1z/Dux9oUF3Q0fA8YNcuj4yoZXkwA3XnrVf3V7aQlHoC5K10+xuuTw8D0HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726916004; c=relaxed/simple;
	bh=AFvePqPOibw3XxCBpwPa6uxRG/zrMpMaNR/mwPlopIE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ZiQDRAjEloY6CdF0qtvWESCSE5uGesVYYSspULpmJ9ASQWfuwChYuQerlXRUtq0RzA148SrXPmnHlB/sk6/CG9ut23ILVfNYif9wPqyepgOwHSQcdeyjd0NSw6G14ndM/shUSUQjq4XMYOMYm/+H+qo2fMhkcIdRahmg2Dijonc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a0a54fb476so34804345ab.2
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Sep 2024 03:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726916002; x=1727520802;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0im4ZtA1MbWQfH6dH4YY0xWeggVJqcB4tgmnXcGu5HM=;
        b=LEy07TEMbMIIArdH0u2Zp3MEl3FrJt55auaXNVyGrtyQMMzeuDmYU/M2NbPGCW8w3c
         1DLzRrQLrtauj43frXOOkQ7Xu/zBff2YPg+FL9L9KQjA57irylzRoBRI2y+ATHHZRsfP
         xuu59hqVeTexfdIkIva+4Ezt3KEt2BMk/YXEIABW3Dy7qbLMfsJWyXGaoktk/VIbMNUA
         KcOrwHc3731GJHC/9gOJqU97sewiZ7Bzb+00/gttevON6e4rzJNYGlB3o9u73t+qlohX
         4RI9kN6RWfaqIEfkaRckBRIdXmdsMxuv6bFxdKFqQfm1ZBNqTl6vSteN748pP26hJRxF
         QJhA==
X-Forwarded-Encrypted: i=1; AJvYcCWBtpQNpOZIGVIi26219Z3B3c7rxuBs0dfd7Sv+SGFhpAdX6s2JkN+dbJbImvOeeBKaAXZ0zyZ+zrkkf2RAow==@vger.kernel.org
X-Gm-Message-State: AOJu0YyqHknIRcQESIZPe7+FUlkpw1eBgo4fKQvv/yMDo4l/mlsbhNvV
	PGI9ZQToDNiZyvySq+dYLiIt/3dXsbcLEYdQB4tenEdHTAax3KQiD7mQ+8/mE4DvzLgBv9vdZmU
	TduZe/VQUJonb1lcPfR9XmpQOIgNedbC/x4/RvCU5KEOvk5urXQJzc5M=
X-Google-Smtp-Source: AGHT+IFa2sh7TtWNLxvQ93uiIz4x3v9RBDL/dog0GxRrw9wxM6ca6f8Q2OrV0KiAFrPS4sFacLlENNzPTC8jn4135s31WF7etNZz
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:174c:b0:3a0:bc39:2d7a with SMTP id
 e9e14a558f8ab-3a0c9d2ca01mr52829595ab.13.1726916002053; Sat, 21 Sep 2024
 03:53:22 -0700 (PDT)
Date: Sat, 21 Sep 2024 03:53:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <66eea5a2.050a0220.3195df.004b.GAE@google.com>
Subject: [syzbot] [bcachefs?] general protection fault in __copy_super
From: syzbot <syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    a430d95c5efa Merge tag 'lsm-pr-20240911' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=124e6a77980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1653f803fffa3848
dashboard link: https://syzkaller.appspot.com/bug?extid=18a5c5e8a9c856944876
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129f68a9980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1539e29f980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-a430d95c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/66a65abf87c4/vmlinux-a430d95c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/09c88015f9aa/bzImage-a430d95c.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/97dbec0f4717/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+18a5c5e8a9c856944876@syzkaller.appspotmail.com

bcachefs (/dev/loop0): error reading default superblock: checksum error, type crc32c_nonzero: got 151109cf should be 29d2fb78
bcachefs (/dev/loop0): error reading superblock: checksum error, type crc32c_nonzero: got 151109cf should be 29d2fb78
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 0 UID: 0 PID: 5098 Comm: syz-executor282 Not tainted 6.11.0-syzkaller-02574-ga430d95c5efa #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__copy_super+0x59/0xe70 fs/bcachefs/super-io.c:552
Code: 44 24 10 80 3c 18 00 74 12 4c 89 f7 e8 90 71 b5 fd 48 ba 00 00 00 00 00 fc ff df 4d 8b 3e 49 8d 5c 24 10 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 2e 0c 00 00 0f b7 2b 49 8d 5f 10 48 89 d8
RSP: 0018:ffffc90002f8f2f0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: ffff888000ebc880
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff888044d807d8
RBP: 0000000000000000 R08: ffffffff84457905 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff2845f24 R12: 0000000000000000
R13: ffff888044d80000 R14: ffff888044d807d8 R15: ffff88803fb32800
FS:  00005555893e4380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555cf75a4000 CR3: 0000000011efe000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bch2_sb_to_fs+0xab/0x150 fs/bcachefs/super-io.c:610
 bch2_fs_alloc+0xd5c/0x20b0 fs/bcachefs/super.c:828
 bch2_fs_open+0x8cc/0xdf0 fs/bcachefs/super.c:2115
 bch2_fs_get_tree+0x731/0x1700 fs/bcachefs/fs.c:1943
 vfs_get_tree+0x90/0x2b0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3507
 do_mount fs/namespace.c:3847 [inline]
 __do_sys_mount fs/namespace.c:4055 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:4032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2b30c1706a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe211af6b8 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffe211af6d0 RCX: 00007f2b30c1706a
RDX: 0000000020000240 RSI: 0000000020005dc0 RDI: 00007ffe211af6d0
RBP: 0000000000000004 R08: 00007ffe211af710 R09: 0000000000005da0
R10: 0000000001000000 R11: 0000000000000282 R12: 0000000001000000
R13: 00007ffe211af710 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__copy_super+0x59/0xe70 fs/bcachefs/super-io.c:552
Code: 44 24 10 80 3c 18 00 74 12 4c 89 f7 e8 90 71 b5 fd 48 ba 00 00 00 00 00 fc ff df 4d 8b 3e 49 8d 5c 24 10 48 89 d8 48 c1 e8 03 <0f> b6 04 10 84 c0 0f 85 2e 0c 00 00 0f b7 2b 49 8d 5f 10 48 89 d8
RSP: 0018:ffffc90002f8f2f0 EFLAGS: 00010202
RAX: 0000000000000002 RBX: 0000000000000010 RCX: ffff888000ebc880
RDX: dffffc0000000000 RSI: 0000000000000000 RDI: ffff888044d807d8
RBP: 0000000000000000 R08: ffffffff84457905 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff2845f24 R12: 0000000000000000
R13: ffff888044d80000 R14: ffff888044d807d8 R15: ffff88803fb32800
FS:  00005555893e4380(0000) GS:ffff88801fe00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555cf75a4000 CR3: 0000000011efe000 CR4: 0000000000350ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	44 24 10             	rex.R and $0x10,%al
   3:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   7:	74 12                	je     0x1b
   9:	4c 89 f7             	mov    %r14,%rdi
   c:	e8 90 71 b5 fd       	call   0xfdb571a1
  11:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
  18:	fc ff df
  1b:	4d 8b 3e             	mov    (%r14),%r15
  1e:	49 8d 5c 24 10       	lea    0x10(%r12),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 10          	movzbl (%rax,%rdx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 2e 0c 00 00    	jne    0xc64
  36:	0f b7 2b             	movzwl (%rbx),%ebp
  39:	49 8d 5f 10          	lea    0x10(%r15),%rbx
  3d:	48 89 d8             	mov    %rbx,%rax


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
