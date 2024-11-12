Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC8C205ABD
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453084; cv=none; b=XOdNBi7YONv8+N8yMMF+lefZLXuj3SJgR9n9FC6pOzstDC8qmARNDuziHetuW2Y18tPJedC1dH/q87fuj5juONHR1IbOM8nNtSqzYLHgjWaSvSjgkXr0JUFD+A6zdafJTldlqcrlA1dLn7ySPi1VTzSV7gSvfxqn4UTRRYenq+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453084; c=relaxed/simple;
	bh=L9rBHqApwdnc2DVWE9Veoh320K7ODI1cNRzcl4FrX40=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dBoJhBNBMrIzgtCCqIEyJbWrCpiXCnwmI9jdzAOIXFdBiEpuDsCXM28Mp82/Md8ovsdB8S9rTNirhGKr871A5zims4qssdqe7RNGZgHnKpX9amuct195fqvLOJ713FcxFiQM+r97Mhldu1M/iUBE1Mk1SVt4+YHxreiDr3Ys9tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83aecd993faso18082139f.0
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Nov 2024 15:11:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453082; x=1732057882;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/a3qnjKzc/NjAB0FQeBNMWHH6zCMWt0F3EpC4Sgkw0=;
        b=D54wGQ/v75rz5UeE/uZPCGvJrqBlIU5FIuVxBC7X0oWuTVqN+Pu2Ksx8+aMdowoxJz
         Iz6hL+9/sFrjUm3K+IDs8EWkXaagjmSiIH5HXFFPZBof8LF4GPBCFzkmnaN32CaetsgS
         QMImByVVqvzssW/jA1ImNztr9F6+jga5OuwlX/5PO52XiwfpzXNiHtc3iUi9L0TIwRHL
         0I/nnZfFNjdE/R4tMSLBGuJrWZ+IYniPFPiu/DJim2TnnrlK2DCAdSLWjNNnQ5B69SLB
         DB7SAsLcW+Hr4ayTxW2fQfRyJPfFSKybIaj6zHW++BdW3rkcYVc+O6ALeaX82j2exizd
         jYEw==
X-Forwarded-Encrypted: i=1; AJvYcCWmj1SgwpnXMZemqbDZZNJlZA9zZ9gycXyFhfYbqvD+lbiR/+u6yQp87sfWNcyU0ltFiPEJXw4QAnoni0c/3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7ByBdMADC/dvwGdKZ8I4ESY56l1xUeb5EvfZQ+ncDGeTsPIlp
	2qSiQHiGOZnFp4JZpx4dR12jtvtl1Mtt/AaArnkJHIJyFbVbeYNx8eFNoi9lCwG10osSom4DVqq
	j1o33cW/jndbU+3Gye4kl7m/LGSiVMbcVp28TAtnkTaB3UlOFzNgLniE=
X-Google-Smtp-Source: AGHT+IFI9pJk3Vf5ankS08mphSrTzz+cxsZu3UCj/BO8Oca1cq8ROcRgCHijIVM923BbskCDPEXYF0px3ElUdlVEufe8BfGoCZte
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b4b:b0:3a6:e960:ef9b with SMTP id
 e9e14a558f8ab-3a6f24b0f33mr174107775ab.4.1731453081993; Tue, 12 Nov 2024
 15:11:21 -0800 (PST)
Date: Tue, 12 Nov 2024 15:11:21 -0800
In-Reply-To: <6731d0cf.050a0220.138bd5.0063.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6733e099.050a0220.2a2fcc.0000.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in six_lock_ip_waiter
From: syzbot <syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    3022e9d00ebe Merge tag 'sched_ext-for-6.12-rc7-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11b2a4c0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=13b85e45ca365499aad5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15b2a4c0580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-3022e9d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4c8c676ae511/vmlinux-3022e9d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9434a43ad72f/bzImage-3022e9d0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/8c323cc169b7/mount_12.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com

RBP: 00007f85c3d27090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f85c3135f80 R15: 00007fffe91d3d88
 </TASK>
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 5577 Comm: syz.0.15 Not tainted 6.12.0-rc7-syzkaller-00012-g3022e9d00ebe #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__lock_acquire+0x69/0x2050 kernel/locking/lockdep.c:5065
Code: b6 04 30 84 c0 0f 85 9b 16 00 00 45 31 f6 83 3d f8 ed ac 0e 00 0f 84 b6 13 00 00 89 54 24 54 89 5c 24 68 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 19 56 8e 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000cb6e0d0 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a13e R12: ffff88801f93a440
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000070
FS:  00007f85c3d276c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd2b4000000 CR3: 000000005671c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5825
 six_lock_ip_waiter+0x9e/0x160 fs/bcachefs/six.c:553
 six_lock_ip fs/bcachefs/six.h:253 [inline]
 six_lock_ip_intent fs/bcachefs/six.h:366 [inline]
 six_lock_intent fs/bcachefs/six.h:366 [inline]
 bkey_cached_alloc fs/bcachefs/btree_key_cache.c:169 [inline]
 btree_key_cache_create fs/bcachefs/btree_key_cache.c:220 [inline]
 btree_key_cache_fill+0x59a/0x2920 fs/bcachefs/btree_key_cache.c:309
 bch2_btree_path_traverse_cached+0x84e/0xbe0 fs/bcachefs/btree_key_cache.c:361
 bch2_btree_path_traverse_one+0x45d/0x2940 fs/bcachefs/btree_iter.c:1159
 bch2_btree_path_traverse fs/bcachefs/btree_iter.h:247 [inline]
 bch2_trans_update_get_key_cache+0x6c0/0x1230 fs/bcachefs/btree_update.c:494
 bch2_trans_update+0x9b1/0x2550 fs/bcachefs/btree_update.c:539
 bch2_inode_write fs/bcachefs/inode.h:139 [inline]
 bch2_create_trans+0xdfb/0x1af0 fs/bcachefs/fs-common.c:179
 __bch2_create+0x7ae/0xf60 fs/bcachefs/fs.c:522
 bch2_mknod fs/bcachefs/fs.c:673 [inline]
 bch2_create+0xea/0x1b0 fs/bcachefs/fs.c:687
 lookup_open fs/namei.c:3595 [inline]
 open_last_lookups fs/namei.c:3694 [inline]
 path_openat+0x1c03/0x3590 fs/namei.c:3930
 do_filp_open+0x235/0x490 fs/namei.c:3960
 do_sys_openat2+0x13e/0x1d0 fs/open.c:1415
 do_sys_open fs/open.c:1430 [inline]
 __do_sys_open fs/open.c:1438 [inline]
 __se_sys_open fs/open.c:1434 [inline]
 __x64_sys_open+0x225/0x270 fs/open.c:1434
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f85c2f7e719
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f85c3d27038 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007f85c3135f80 RCX: 00007f85c2f7e719
RDX: 00000000000000a0 RSI: 000000000014927e RDI: 0000000020000180
RBP: 00007f85c3d27090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
R13: 0000000000000000 R14: 00007f85c3135f80 R15: 00007fffe91d3d88
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x69/0x2050 kernel/locking/lockdep.c:5065
Code: b6 04 30 84 c0 0f 85 9b 16 00 00 45 31 f6 83 3d f8 ed ac 0e 00 0f 84 b6 13 00 00 89 54 24 54 89 5c 24 68 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 19 56 8e 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000cb6e0d0 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff203a13e R12: ffff88801f93a440
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000070
FS:  00007f85c3d276c0(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd2b4000000 CR3: 000000005671c000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 9b 16 	xor    %al,0x169b850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d f8 ed ac 0e 00 	cmpl   $0x0,0xeacedf8(%rip)        # 0xeacee0d
  15:	0f 84 b6 13 00 00    	je     0x13d1
  1b:	89 54 24 54          	mov    %edx,0x54(%rsp)
  1f:	89 5c 24 68          	mov    %ebx,0x68(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 19 56 8e 00       	call   0x8e5651
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
