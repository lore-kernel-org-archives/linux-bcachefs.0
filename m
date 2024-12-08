Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516C080BFF
	for <linux-bcachefs@vger.kernel.org>; Sun,  8 Dec 2024 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733650950; cv=none; b=nSCZRbfcEftytRJRVReo5dFKK2qr1PkiHQHjl+/TzLhtdpgk44ul2ZqtrL5icpX5UEivJjx6TnfSATzRJFlNp7jrEYOiohmTnEVZbEYRYV6SiGQ8Xbvby6k8++ehLZB6Vovu5sNGd0Wy/3Nbo0EOUIfpPf6MVMzezPtv4p3O1Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733650950; c=relaxed/simple;
	bh=owuu9pSYKD9nFiNeDdrMMQj4NQhuC65DeXgjvdkJD8Q=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Frhn5wg3FI+hs18VGBVB4H6wVRRo0afJ113voYl34+5k28qmI2/EI6dOxJo/vX4rBIP+/Tpt87rIUusRxFNEYpGkG9LgMYa+GIMFSvwDSnW0Lc0+AIpfjG1PkGJUBaf2CdWwHMb/3Tys0sRe6mQId+Pdn5/qr4JfPcJav+eCwTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3a814406be9so39537565ab.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 08 Dec 2024 01:42:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733650947; x=1734255747;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVMa8d+KqJo9ksmjCXSRtpg8goy7IGrZlqcYwLbyk9s=;
        b=Yr2RAe2Ucq1cmKA9GDUlSUDriPIjGwDvLZRD5su+v+ERlBFpWOAzsKbO15goDCCsU+
         LBoVjTrkyYpcKPxY0vMNPlMEi2k8kGcrdC4BzX4B7CHmipEuWK3VYuFHglTpVshSAbid
         647ihJEIkxvZl/oOfQeoJlG17lXQzDdor+1Lh190GVQ3vgxH1KIlJmzhGrTgiEtoOTzT
         MueFhPeVfi+DNHFHrNOLjf8c2qgWqWQ46v3gcavbqQD/TCxeSI0YnIpQjr5NrPqDbC6j
         0lsFg6UGkLuaroGAulfG5xmZ0uCyA9zr3PSZ//+V+ArELa4WVXt5EXtugEsMmNEMSN2s
         0RtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmpPyOHsgDCwq/SYw9Mo+j1dGXl/R6H/jq2kbknfqiN2SD4tnmU1SIrkeVBxbAyPOOZ3Z9zMB5wcVdBmbvkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwzxrrS3KQ0dcekyFlDj23naSurM4EEYdBnMON/uAqu9aKbZaHt
	xY40LlhzwdUoKsv7Yxvyz3cCIUKaoNX9bRJg6LvyhKCI3U+rl1O8mIaxKSSKn9RSj6IUdlTPF9W
	d6jDxhPYKkQyYQAoHR1W0jlB2EcSdFU6oN1tj1MXWE68Qg+bhPa67dkc=
X-Google-Smtp-Source: AGHT+IFgGVVQVSRF122PVRAuYcwxBNydL/3bFaNpXdd2hDBG3h4HY6J1WklG5CmJVkCOFVOhuCNx0HB+E1ctL+koa1VgI3Vd9N37
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8f:b0:3a7:c378:3bab with SMTP id
 e9e14a558f8ab-3a811b6e422mr90097805ab.0.1733650947558; Sun, 08 Dec 2024
 01:42:27 -0800 (PST)
Date: Sun, 08 Dec 2024 01:42:27 -0800
In-Reply-To: <6731d0cf.050a0220.138bd5.0063.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67556a03.050a0220.2477f.0027.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] general protection fault in six_lock_ip_waiter
From: syzbot <syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    7503345ac5f5 Merge tag 'block-6.13-20241207' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b00c0f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1362a5aee630ff34
dashboard link: https://syzkaller.appspot.com/bug?extid=13b85e45ca365499aad5
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a8c820580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=114008f8580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-7503345a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e95a2b302e11/vmlinux-7503345a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/e78c0c786fb3/bzImage-7503345a.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/38589268f3dc/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+13b85e45ca365499aad5@syzkaller.appspotmail.com

bcachefs (loop0): bch2_get_scanned_nodes(): recovering subvolumes l=0 POS_MIN - SPOS_MAX
bcachefs (loop0): bch2_get_scanned_nodes(): recovering u64s 11 type btree_ptr_v2 SPOS_MAX len 0 ver 0: seq c0bef60d07000640 written 8 min_key POS_MIN durability: 1 ptr: 0:35:0 gen 0
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] PREEMPT SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 5305 Comm: syz-executor212 Not tainted 6.13.0-rc1-syzkaller-00337-g7503345ac5f5 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5089
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 7b cd 9e 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a8 ac 8f 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000d0cef50 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff20329a7 R12: ffff888000b8c880
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000070
FS:  000055557a2a8380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd8e5afde0 CR3: 0000000041100000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5849
 six_lock_ip_waiter+0x9e/0x160 fs/bcachefs/six.c:553
 __btree_node_lock_nopath fs/bcachefs/btree_locking.h:225 [inline]
 btree_node_lock_nopath_nofail fs/bcachefs/btree_locking.h:248 [inline]
 bch2_check_topology+0x619/0xb20 fs/bcachefs/btree_gc.c:549
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
RIP: 0033:0x7ff165df18fa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 5e 04 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffeea454f58 EFLAGS: 00000282 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffeea454f70 RCX: 00007ff165df18fa
RDX: 00000000200000c0 RSI: 0000000020000180 RDI: 00007ffeea454f70
RBP: 0000000000000010 R08: 00007ffeea454fb0 R09: 0000000000005953
R10: 0000000000000010 R11: 0000000000000282 R12: 0000000000000004
R13: 00007ffeea454fb0 R14: 0000000000000003 R15: 0000000001000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__lock_acquire+0x6a/0x2100 kernel/locking/lockdep.c:5089
Code: b6 04 30 84 c0 0f 85 f8 16 00 00 45 31 f6 83 3d 7b cd 9e 0e 00 0f 84 c8 13 00 00 89 54 24 60 89 5c 24 38 4c 89 f8 48 c1 e8 03 <80> 3c 30 00 74 12 4c 89 ff e8 a8 ac 8f 00 48 be 00 00 00 00 00 fc
RSP: 0018:ffffc9000d0cef50 EFLAGS: 00010002
RAX: 000000000000000e RBX: 0000000000000001 RCX: 0000000000000001
RDX: 0000000000000000 RSI: dffffc0000000000 RDI: 0000000000000070
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff20329a7 R12: ffff888000b8c880
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000070
FS:  000055557a2a8380(0000) GS:ffff88801fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd8e5afde0 CR3: 0000000041100000 CR4: 0000000000352ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	b6 04                	mov    $0x4,%dh
   2:	30 84 c0 0f 85 f8 16 	xor    %al,0x16f8850f(%rax,%rax,8)
   9:	00 00                	add    %al,(%rax)
   b:	45 31 f6             	xor    %r14d,%r14d
   e:	83 3d 7b cd 9e 0e 00 	cmpl   $0x0,0xe9ecd7b(%rip)        # 0xe9ecd90
  15:	0f 84 c8 13 00 00    	je     0x13e3
  1b:	89 54 24 60          	mov    %edx,0x60(%rsp)
  1f:	89 5c 24 38          	mov    %ebx,0x38(%rsp)
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 30 00          	cmpb   $0x0,(%rax,%rsi,1) <-- trapping instruction
  2e:	74 12                	je     0x42
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 a8 ac 8f 00       	call   0x8face0
  38:	48                   	rex.W
  39:	be 00 00 00 00       	mov    $0x0,%esi
  3e:	00 fc                	add    %bh,%ah


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
