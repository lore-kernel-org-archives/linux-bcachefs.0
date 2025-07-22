Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFC020CCE3
	for <linux-bcachefs@vger.kernel.org>; Tue, 22 Jul 2025 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753201269; cv=none; b=KFFEzkU7Saq+KpG4GJt3M7LRLBQPYJyvpuQ0HYZohOJGh115tpli6EQOtqc+IJPABFI/rK26fE43oeYZE8NxTSuK+5alHeQEkJQxcG4PxhjhUmZ0plKRTip/7DvuSyYMzUwIHFZ5uDi891RIRn3f6TrFvAkAF23U9Zx/6P1wAzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753201269; c=relaxed/simple;
	bh=WZ5zblbFjn5nzCnrQaOPKKWOCgSc/1RSP/OY9Ph4mH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5euKkD7y2c8huTc1+puq+YXMM02hFSuqg8cx27c58g0WSfUsOrXMvy1DtGj9nOrtVkJj8Oae4Wj1eRzoBFdW7IVthcwfGQCD/ao5Q/nQSK8DSEA8LwbJh3E7uXyKXW2ek5akm4/eCfLdCLaZY+L3GkALGOWRc2B4OryqQaKNBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CrZtZYmm; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CrZtZYmm"
Date: Tue, 22 Jul 2025 12:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753201264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J4hYFek2OVZlJqI5+fP55CNQUvcRLJWSENQJ1oK5FKQ=;
	b=CrZtZYmmdom/GKJa43rt39CagC0+SAIzHQn1BpNn8qYS60hzuM5QE36cS4A6sxCp1rjqCS
	BTtmbpRBoFG0UF87f5tOR0+Nqdg9y0AdBmcJHmRq5utQ+ur53r3tvmyOyfVAb8lTNf9e75
	/EFAKPSCCjC5x0C8E+dqDkXmjq2pbgk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: syzbot <syzbot+e3f91c76099a777cbf16@syzkaller.appspotmail.com>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [bcachefs?] kernel BUG in
 do_bch2_trans_commit_to_journal_replay
Message-ID: <i5jizyac6siolrwgsd6dtj4shebjophbf6mk6itete7rusmrxn@hbebk47xym6v>
References: <687c89c0.a70a0220.693ce.00b1.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687c89c0.a70a0220.693ce.00b1.GAE@google.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jul 19, 2025 at 11:16:32PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    d086c886ceb9 Add linux-next specific files for 20250718
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=174f04f0580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=cc0cd9fdf69889c3
> dashboard link: https://syzkaller.appspot.com/bug?extid=e3f91c76099a777cbf16
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/4435f80a19c4/disk-d086c886.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/9a7dc57a5ea3/vmlinux-d086c886.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/da9f2dc22ae1/bzImage-d086c886.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e3f91c76099a777cbf16@syzkaller.appspotmail.com
> 
>   features: lz4,new_siphash,inline_data,new_extent_overwrite,btree_ptr_v2,new_varint,journal_no_flush,alloc_v2,extents_across_btree_nodes
> bcachefs (loop0): Using encoding defined by superblock: utf8-12.1.0
> bcachefs (loop0): initializing new filesystem
> ------------[ cut here ]------------
> kernel BUG at fs/bcachefs/btree_trans_commit.c:1027!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 7573 Comm: syz.0.296 Not tainted 6.16.0-rc6-next-20250718-syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
> RIP: 0010:do_bch2_trans_commit_to_journal_replay+0x10f3/0x1120 fs/bcachefs/btree_trans_commit.c:1027
> Code: 48 c7 c1 79 7b 99 8d 49 89 c0 e8 f8 7a 2b 00 4c 89 ff e8 10 c7 0d 00 48 8b 7c 24 68 e8 d6 1b 00 00 90 0f 0b e8 4e e3 92 fd 90 <0f> 0b e8 46 e3 92 fd eb ad e8 3f e3 92 fd eb a6 e8 38 e3 92 fd 90
> RSP: 0018:ffffc9000494edb8 EFLAGS: 00010283
> RAX: ffffffff842ccdc2 RBX: 00000000fffff7ab RCX: 0000000000080000
> RDX: ffffc9000b829000 RSI: 0000000000043784 RDI: 0000000000043785
> RBP: ffff88807e458000 R08: ffff888063f849e3 R09: 1ffff1100c7f093c
> R10: dffffc0000000000 R11: ffffed100c7f093d R12: ffff88807e458028
> R13: 0000000000000000 R14: ffff88807e4580d2 R15: ffff8880269a6000
> FS:  00007f6f1c5f26c0(0000) GS:ffff888125be3000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc41ced2048 CR3: 0000000059546000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  __bch2_trans_commit+0x1b13/0x8a70 fs/bcachefs/btree_trans_commit.c:1060
>  bch2_trans_commit fs/bcachefs/btree_update.h:270 [inline]
>  bch2_dev_usage_init+0x22c/0x3f0 fs/bcachefs/disk_accounting.c:934
>  bch2_fs_initialize+0x4b5/0xe60 fs/bcachefs/recovery.c:1179
>  bch2_fs_start+0xa00/0xcc0 fs/bcachefs/super.c:1217
>  bch2_fs_get_tree+0xb39/0x1540 fs/bcachefs/fs.c:2456
>  vfs_get_tree+0x92/0x2b0 fs/super.c:1815
>  do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>  do_mount fs/namespace.c:4133 [inline]
>  __do_sys_mount fs/namespace.c:4344 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6f1b79014a
> Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f6f1c5f1e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f6f1c5f1ef0 RCX: 00007f6f1b79014a
> RDX: 0000200000000140 RSI: 0000200000000100 RDI: 00007f6f1c5f1eb0
> RBP: 0000200000000140 R08: 00007f6f1c5f1ef0 R09: 0000000002800000
> R10: 0000000002800000 R11: 0000000000000246 R12: 0000200000000100
> R13: 00007f6f1c5f1eb0 R14: 0000000000005a7a R15: 0000200000000300
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:do_bch2_trans_commit_to_journal_replay+0x10f3/0x1120 fs/bcachefs/btree_trans_commit.c:1027
> Code: 48 c7 c1 79 7b 99 8d 49 89 c0 e8 f8 7a 2b 00 4c 89 ff e8 10 c7 0d 00 48 8b 7c 24 68 e8 d6 1b 00 00 90 0f 0b e8 4e e3 92 fd 90 <0f> 0b e8 46 e3 92 fd eb ad e8 3f e3 92 fd eb a6 e8 38 e3 92 fd 90
> RSP: 0018:ffffc9000494edb8 EFLAGS: 00010283
> RAX: ffffffff842ccdc2 RBX: 00000000fffff7ab RCX: 0000000000080000
> RDX: ffffc9000b829000 RSI: 0000000000043784 RDI: 0000000000043785
> RBP: ffff88807e458000 R08: ffff888063f849e3 R09: 1ffff1100c7f093c
> R10: dffffc0000000000 R11: ffffed100c7f093d R12: ffff88807e458028
> R13: 0000000000000000 R14: ffff88807e4580d2 R15: ffff8880269a6000
> FS:  00007f6f1c5f26c0(0000) GS:ffff888125ce3000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc8ab0e9000 CR3: 0000000059546000 CR4: 00000000003526f0
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

fixed in the updated version of
bcachefs: do_bch2_trans_commit_to_journal_replay handles accounting

#syz test: git://evilpiepirate.org/bcachefs.git for-next
