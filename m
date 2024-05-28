Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D8E4DA04
	for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716884005; cv=none; b=BNsb0wEUvRN/7NOUsaB55D123soAOPUmoAqlkuoFoHnvxjliz3lbJQJwcyP0AFokqbSOTdzocIOvRDxaR+2zZARO97kjeCD3FdxMVt6y+r4S+Ap0VKoGsydcLj+gQO/XGsYDvgXXX8F/0CIjH7M9Hh6dZQlpkdEYRUvaYKsmsP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716884005; c=relaxed/simple;
	bh=uH34/zMLsDTLWcHo5SncexBXLQJ/4xak05E2pRJC+Lc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=XroyTD6M1GOqq6XKY3A8QLJ2g8k0SQ7GkKih7TW8gTTWr/Cqk6Lz+oat3UqIwexLzmoCBa6mHqhmuVEnmTdncoJW6x5/9q0wAPsBpfsSeFiS/Z9VTVf5vKgs9qFzSlMiNRpXABu7du2kMF6A/NN18GRB9GUY24jYsySMiCs9cGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3738db5b07dso6380095ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 28 May 2024 01:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716884003; x=1717488803;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=62y7v4snzgkp+7CkNXO5DDgESut5Y/xpHHfPFOBokxg=;
        b=P6qq9TyeDw1OUk1rg8Nm2OaMu606Awd5nKRiJJ+bRfvRm6JEiFwvZoIM4smkH7vF9J
         7FCnhxI6ZITUiGhKdUmYVjst774LtBMpix96FpGiO9LeEJiY6mB/EoFBnZLIPi1hqjIr
         t4Lh8lkasNZ2AFrEVAxYwLAf9xQ9xnd78VjXykNBQwlz4ASPAk+t/z/Tkq5h2JfQ4jPd
         tYkmdvKt9eLUgT+VWjaj4ZyHesXDFm6er2/frLLVbyTGxoKkG6JyrNckSNPpxD5ABhK7
         j36jtKnx+TcjopoToBq8Mkf+7ysotCSzhMMOz7VNcl4CflavfB/pCJ1Jlbde/wT0sHnO
         rFzw==
X-Forwarded-Encrypted: i=1; AJvYcCVSw4Ho7EuxVushvhmUSznG28tU2yBTR4uQKzrw9zhISCITC5DJu9yBlBXKRvsItAyd7vjIhRKQ7RsA18ihWNYjwwZC+wG14I4RojUjnrk=
X-Gm-Message-State: AOJu0Yxq+fVTb62OQUxdEz/aURO2Qwwsl5nh5dPD3MCRAlPtQOd59gqG
	yQ6SK1r+pjeq7ZOmkm2xybXk+gCJFnvyRKdTOTjC+rA+opfAt1s1mFABB2DbwYtYI4GKjAFJ5tt
	FBGmk1EzG3+Y845qY65QJVc9vDopx6wOcB5jltR8jDbYN7rt/HtaUutM=
X-Google-Smtp-Source: AGHT+IEjnjpbnrWUm6VxMooPc1NuJJj7CjXYC0eeNyOpKbe3kK5lPanbnI/J77AwxR33qqnyunT79I+Q6TkA1s6OgAvJ/Re0M/v+
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:216e:b0:36b:2731:4084 with SMTP id
 e9e14a558f8ab-3737b2bdafemr6954795ab.2.1716884003060; Tue, 28 May 2024
 01:13:23 -0700 (PDT)
Date: Tue, 28 May 2024 01:13:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001f886b06197f358f@google.com>
Subject: [syzbot] [bcachefs?] UBSAN: array-index-out-of-bounds in bch2_btree_path_traverse_cached_slowpath
From: syzbot <syzbot+fa3fc4c486ec9c342fcc@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2bfcfd584ff5 Merge tag 'pmdomain-v6.10-rc1' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1674fd44980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=733cc7a95171d8e7
dashboard link: https://syzkaller.appspot.com/bug?extid=fa3fc4c486ec9c342fcc
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-2bfcfd58.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c7ed3bb80bed/vmlinux-2bfcfd58.xz
kernel image: https://storage.googleapis.com/syzbot-assets/93acc5bfbaef/bzImage-2bfcfd58.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa3fc4c486ec9c342fcc@syzkaller.appspotmail.com

bcachefs (loop2): journal_replay... done
bcachefs (loop2): resume_logged_ops... done
bcachefs (loop2): going read-write
bcachefs (loop2): done starting filesystem
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in fs/bcachefs/btree_key_cache.c:215:16
index 66 is out of range for type 'bkey_cached *[16]'
CPU: 1 PID: 7694 Comm: syz-executor.2 Not tainted 6.10.0-rc1-syzkaller-00013-g2bfcfd584ff5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x16c/0x1f0 lib/dump_stack.c:114
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_out_of_bounds+0x110/0x150 lib/ubsan.c:429
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:215 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:329 [inline]
 bch2_btree_path_traverse_cached_slowpath+0x4304/0x4d90 fs/bcachefs/btree_key_cache.c:484
 bch2_btree_path_traverse_cached+0x9ec/0xdc0 fs/bcachefs/btree_key_cache.c:587
 bch2_btree_path_traverse_one+0x16b4/0x2e40 fs/bcachefs/btree_iter.c:1158
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:229 [inline]
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:221 [inline]
 bch2_btree_iter_peek_slot+0x715/0x2450 fs/bcachefs/btree_iter.c:2603
 __bch2_bkey_get_iter fs/bcachefs/btree_iter.h:552 [inline]
 bch2_bkey_get_iter fs/bcachefs/btree_iter.h:566 [inline]
 bch2_inode_peek_nowarn+0x1e3/0x390 fs/bcachefs/inode.c:340
 bch2_inode_peek fs/bcachefs/inode.c:366 [inline]
 bch2_inode_find_by_inum_trans+0x125/0x2a0 fs/bcachefs/inode.c:939
 bch2_vfs_inode_get+0x41f/0x550 fs/bcachefs/fs.c:277
 bch2_mount+0xc81/0x1090 fs/bcachefs/fs.c:1999
 legacy_get_tree+0x109/0x220 fs/fs_context.c:662
 vfs_get_tree+0x8f/0x380 fs/super.c:1780
 do_new_mount fs/namespace.c:3352 [inline]
 path_mount+0x6e1/0x1f10 fs/namespace.c:3679
 do_mount fs/namespace.c:3692 [inline]
 __do_sys_mount fs/namespace.c:3898 [inline]
 __se_sys_mount fs/namespace.c:3875 [inline]
 __ia32_sys_mount+0x295/0x320 fs/namespace.c:3875
 do_syscall_32_irqs_on arch/x86/entry/common.c:165 [inline]
 __do_fast_syscall_32+0x73/0x120 arch/x86/entry/common.c:386
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/common.c:411
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf72f3579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f5ee5400 EFLAGS: 00000292 ORIG_RAX: 0000000000000015
RAX: ffffffffffffffda RBX: 00000000f5ee5460 RCX: 0000000020011a40
RDX: 0000000020000040 RSI: 0000000001200014 RDI: 00000000f5ee54a0
RBP: 00000000f5ee5460 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
---[ end trace ]---
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
