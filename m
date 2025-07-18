Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3182206B2
	for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752876786; cv=none; b=WprSICCZVa9dT09TSDjyiCGp8Dnqzqfx51USshaZx9Z0ewFNcmglCz/U7SFoAlXcT1NtoqfESrayQCM4gWCrNlmxjPAn8PeWnjcI8kGjC3evDS3vk/D9A0cNz3gUx6Ljs6JT487q8z+Twp/CxDvPJwp+KJzpk+6wjDD3WzAa2x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752876786; c=relaxed/simple;
	bh=Md2GEhQKKoSiTiXgdl9/yCbGDs012KyERSRTD2DEi1I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=TSyQhPIqdkhyfOwbeqTS8q1Sqz+FULoXeNLkI2A/G2FMvcp4GWiZseHEVN3igU52+79vezzOzOmhzOK5Vbc71wphT+/IWYGMEt1mpEnXq9M5m/X0G7dlf2ULvnjqSI9HYofCpaa+PC7723N5DzkKCNZ9cVR272+ephvX8S6LL8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-879489ddf11so515603439f.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 18 Jul 2025 15:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752876784; x=1753481584;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f6vM/WsIdrpLc11NRZhoJURG2Gp8OgVmC50TnPUYXMQ=;
        b=cb/h1P7L5IZN54rugOhfNCSAzUusu1RfEIp61ypA3MWl+NEFYWDo6jg7dNqV+cdg+V
         htDPaf4T/75sY8b2lfRIt1CN4UVQGLR+2aYqtK5vFNiZU4/e3xRdQeKvA/OTK9dFFhb4
         8wHmTUx4peIyYZtJut0R8vppencGNPnLj5DBh/cvTx2HNcE8aIFTRGpF6fub/68uQxlc
         JZobhSZBpq7nqgK6yg5ykJHNqW2CDIk7OeRqqc1273i8UITWr0a2XhlejUuky0oNUAbi
         jPZaNJTRSWxwTSOJ5CC+RQ8l+Ljn9BhibSIrAy9arfko+Al39FsUDWTcIJS43lgadbo9
         FAlw==
X-Forwarded-Encrypted: i=1; AJvYcCVPgkY2MnmTIhDNLD5ZT+Z9+vRqenOXHvwk3FTKYQXfV5yv3IQ8uAesSL/Ookyt776aD6Embqr771csm+jqTA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBTYPu1CPQVYzQXLy+nrXMcGrLKL4gTAmyjm+a3Bdn8pfee74I
	7PuDMuBKyvlKbm8kNAFfg08lx6Qd7+r7ndad/Zp2TnPMxoKKaXLTKukdXcoAmZDA60PQ9IesZ92
	/EBipmESm4qb+18/3IALyPhxHMNC2qcTAxB4uI0aI6WzGkH4smlGfXwLbDoQ=
X-Google-Smtp-Source: AGHT+IF9ZMY8S101zfCsauPh8KYQDANhBrefVYiO+R15tbg54Ik++d5KsJX1Vvv3IdgQgTKjUtxmpOlB5q6MetEqW8awM/jZd8LY
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1691:b0:876:c8e9:8b11 with SMTP id
 ca18e2360f4ac-879c08c3de2mr1533833439f.8.1752876784225; Fri, 18 Jul 2025
 15:13:04 -0700 (PDT)
Date: Fri, 18 Jul 2025 15:13:04 -0700
In-Reply-To: <ci6d4nck2pydr7gprqmv5v5rudgx5wrt5xumkzrewnwol2p2z7@t6ksfe4l3ayu>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687ac6f0.a70a0220.693ce.0070.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Write in bch2_get_next_dev
From: syzbot <syzbot+2b98caf09c41174a9697@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
general protection fault in seq_buf_puts

shmem_inode_cache total: 7.91 MiB active: 7.89 MiB
kmalloc-8k        total: 5.63 MiB active: 5.48 MiB
Shrinkers:
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 6968 Comm: syz.4.25 Not tainted 6.16.0-rc6-syzkaller-gca12b17b7ceb #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
RIP: 0010:strlen+0x29/0x70 lib/string.c:420
Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
RSP: 0018:ffffc90003dde7a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802c468000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003dde8f0 R08: ffff8880357dead7 R09: 1ffff11006afbd5a
R10: dffffc0000000000 R11: ffffed1006afbd5b R12: ffffc90003dde860
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
FS:  00007fb031fe66c0(0000) GS:ffff888125d2a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe025a39e9c CR3: 0000000034726000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __fortify_strlen include/linux/fortify-string.h:268 [inline]
 seq_buf_puts+0x34/0x1a0 lib/seq_buf.c:184
 shrinker_to_text+0x115/0x3c0 mm/shrinker.c:836
 shrinkers_to_text+0x840/0x960 mm/shrinker.c:911
 __show_mem+0x242b/0x24d0 mm/show_mem.c:496
 warn_alloc_show_mem mm/page_alloc.c:3719 [inline]
 warn_alloc+0x2dd/0x310 mm/page_alloc.c:3744
 __vmalloc_area_node mm/vmalloc.c:3702 [inline]
 __vmalloc_node_range_noprof+0x67e/0x12f0 mm/vmalloc.c:3893
 __kvmalloc_node_noprof+0x3b8/0x5f0 mm/slub.c:5037
 bch2_fs_journal_start+0x2b4/0x12b0 fs/bcachefs/journal.c:1484
 bch2_fs_recovery+0x1fbe/0x3860 fs/bcachefs/recovery.c:975
 bch2_fs_start+0x957/0xbf0 fs/bcachefs/super.c:1216
 bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2462
 vfs_get_tree+0x92/0x2b0 fs/super.c:1804
 do_new_mount+0x24a/0xa40 fs/namespace.c:3902
 do_mount fs/namespace.c:4239 [inline]
 __do_sys_mount fs/namespace.c:4450 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4427
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb0311900ca
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb031fe5e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fb031fe5ef0 RCX: 00007fb0311900ca
RDX: 000020000000fec0 RSI: 000020000000ff00 RDI: 00007fb031fe5eb0
RBP: 000020000000fec0 R08: 00007fb031fe5ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000020000000ff00
R13: 00007fb031fe5eb0 R14: 000000000000fe88 R15: 000020000000ff40
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:strlen+0x29/0x70 lib/string.c:420
Code: 90 f3 0f 1e fa 41 57 41 56 41 54 53 48 c7 c0 ff ff ff ff 49 be 00 00 00 00 00 fc ff df 48 89 fb 49 89 c7 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 75 11 48 ff c3 49 8d 47 01 42 80 7c 3f 01 00
RSP: 0018:ffffc90003dde7a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff88802c468000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90003dde8f0 R08: ffff8880357dead7 R09: 1ffff11006afbd5a
R10: dffffc0000000000 R11: ffffed1006afbd5b R12: ffffc90003dde860
R13: dffffc0000000000 R14: dffffc0000000000 R15: ffffffffffffffff
FS:  00007fb031fe66c0(0000) GS:ffff888125d2a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005578d9f91950 CR3: 0000000034726000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	f3 0f 1e fa          	endbr64
   5:	41 57                	push   %r15
   7:	41 56                	push   %r14
   9:	41 54                	push   %r12
   b:	53                   	push   %rbx
   c:	48 c7 c0 ff ff ff ff 	mov    $0xffffffffffffffff,%rax
  13:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
  1a:	fc ff df
  1d:	48 89 fb             	mov    %rdi,%rbx
  20:	49 89 c7             	mov    %rax,%r15
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	75 11                	jne    0x44
  33:	48 ff c3             	inc    %rbx
  36:	49 8d 47 01          	lea    0x1(%r15),%rax
  3a:	42 80 7c 3f 01 00    	cmpb   $0x0,0x1(%rdi,%r15,1)


Tested on:

commit:         ca12b17b bcachefs: fix check_extent_overbig() call
git tree:       git://evilpiepirate.org/bcachefs.git bcachefs-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=1752038c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=37de60b3108b6d8f
dashboard link: https://syzkaller.appspot.com/bug?extid=2b98caf09c41174a9697
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
